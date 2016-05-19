#!/bin/bash

#
# SHELL script to automate process of "refreshing" Magento2 instance after module installation, theme setup etc.
#
# Compiled by Stamster
# http://stamster.github.io


#Define path to the Magento "binary"

MAG=bin/magento #local path - default
#MAG=magento  #system wide symlink
#MAG=/usr/share/nginx/artisanart/bin/magento    #absolute path

echo "Enabling all modules with clearing static content..."
$MAG module:enable --all --clear-static-content
echo "Running setup upgrade..."
$MAG setup:upgrade
echo "DI configuration must be cleared before running compiler..."
rmdir -v var/di/
# if dir is not empty do:
rm -rv var/di
echo "Running code compiler (to avoid real time configuration and code analysis)..."
$MAG setup:di:compile
echo "Running static content deployment..."
$MAG setup:static-content:deploy
echo "Performing re-index of catalog database data..."
$MAG indexer:reindex
echo "Cleaning cache to apply all settings..."
$MAG cache:clean
$MAG cache:flush
echo "ALL OPERATIONS COMPLETE."
echo "EOF"
