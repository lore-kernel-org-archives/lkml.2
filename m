Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755807Ab1EETEN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 May 2011 15:04:13 -0400
Received: from mail-px0-f173.google.com ([209.85.212.173]:41053 "EHLO
	mail-px0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751571Ab1EETEL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 May 2011 15:04:11 -0400
From: Jamey Sharp <jamey@minilop.net>
To: linux-kernel@vger.kernel.org
Cc: Josh Triplett <josh@joshtriplett.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] scripts/gen_initramfs_list.sh: Convert to a /bin/sh script
Date: Thu,  5 May 2011 12:03:47 -0700
Message-Id: <1304622227-18204-2-git-send-email-jamey@minilop.net>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1304622227-18204-1-git-send-email-jamey@minilop.net>
References: <1304622227-18204-1-git-send-email-jamey@minilop.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replace bashisms with POSIX-compatible shell scripting.

Notably, de-duplicate '/' using a sed command from elsewhere in the same script
rather than "${name//\/\///}".

Commit by Jamey Sharp and Josh Triplett.

Signed-off-by: Jamey Sharp <jamey@minilop.net>
Signed-off-by: Josh Triplett <josh@joshtriplett.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
---
 scripts/gen_initramfs_list.sh |   14 +++++++-------
 1 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/scripts/gen_initramfs_list.sh b/scripts/gen_initramfs_list.sh
index e12b1a7..cf0537b 100644
--- a/scripts/gen_initramfs_list.sh
+++ b/scripts/gen_initramfs_list.sh
@@ -1,4 +1,4 @@
-#!/bin/bash
+#!/bin/sh
 # Copyright (C) Martin Schlemmer <azarah@nosferatu.za.org>
 # Copyright (C) 2006 Sam Ravnborg <sam@ravnborg.org>
 #
@@ -105,9 +105,9 @@ list_parse() {
 # for links, devices etc the format differs. See gen_init_cpio for details
 parse() {
 	local location="$1"
-	local name="${location/${srcdir}//}"
+	local name="/${location#${srcdir}}"
 	# change '//' into '/'
-	name="${name//\/\///}"
+	name=$(echo "$name" | sed -e 's://*:/:g')
 	local mode="$2"
 	local uid="$3"
 	local gid="$4"
@@ -117,8 +117,8 @@ parse() {
 	[ "$root_gid" = "squash" ] && gid=0 || [ "$gid" -eq "$root_gid" ] && gid=0
 	local str="${mode} ${uid} ${gid}"
 
-	[ "${ftype}" == "invalid" ] && return 0
-	[ "${location}" == "${srcdir}" ] && return 0
+	[ "${ftype}" = "invalid" ] && return 0
+	[ "${location}" = "${srcdir}" ] && return 0
 
 	case "${ftype}" in
 		"file")
@@ -192,7 +192,7 @@ input_file() {
 	if [ -f "$1" ]; then
 		${dep_list}header "$1"
 		is_cpio="$(echo "$1" | sed 's/^.*\.cpio\(\..*\)\?/cpio/')"
-		if [ $2 -eq 0 -a ${is_cpio} == "cpio" ]; then
+		if [ $2 -eq 0 -a ${is_cpio} = "cpio" ]; then
 			cpio_file=$1
 			echo "$1" | grep -q '^.*\.cpio\..*' && is_cpio_compressed="compressed"
 			[ ! -z ${dep_list} ] && echo "$1"
@@ -204,7 +204,7 @@ input_file() {
 		else
 		        echo "$1 \\"
 			cat "$1" | while read type dir file perm ; do
-				if [ "$type" == "file" ]; then
+				if [ "$type" = "file" ]; then
 					echo "$file \\";
 				fi
 			done
-- 
1.7.4.4

