Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755310Ab2LCQYf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Dec 2012 11:24:35 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:50554 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753490Ab2LCQYe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Dec 2012 11:24:34 -0500
From: Joonsoo Kim <js1304@gmail.com>
To: Michal Marek <mmarek@suse.cz>
Cc: linux-kernel@vger.kernel.org, Joonsoo Kim <js1304@gmail.com>
Subject: [PATCH 1/2] scripts/tags.sh: Support subarch for ARM
Date: Tue,  4 Dec 2012 01:22:03 +0900
Message-Id: <1354551724-15089-1-git-send-email-js1304@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Current tags.sh doesn't handle subarch for ARM.
There are too many subarch on ARM, it is hard that we locate some
functions which are defined in every subarch with tags util family.
Therefore support subarch for removing this unconvenience.

We can use ARM subarch functionality like below.
"make cscope O=. SRCARCH=arm SUBARCH=xxx"

Signed-off-by: Joonsoo Kim <js1304@gmail.com>

diff --git a/scripts/tags.sh b/scripts/tags.sh
index 79fdafb..a400c88 100755
--- a/scripts/tags.sh
+++ b/scripts/tags.sh
@@ -48,13 +48,14 @@ find_arch_sources()
 	for i in $archincludedir; do
 		prune="$prune -wholename $i -prune -o"
 	done
-	find ${tree}arch/$1 $ignore $prune -name "$2" -print;
+	find ${tree}arch/$1 $ignore $subarchprune $prune -name "$2" -print;
 }
 
 # find sources in arch/$1/include
 find_arch_include_sources()
 {
-	include=$(find ${tree}arch/$1/ -name include -type d);
+	include=$(find ${tree}arch/$1/ $subarchprune \
+					-name include -type d -print);
 	if [ -n "$include" ]; then
 		archincludedir="$archincludedir $include"
 		find $include $ignore -name "$2" -print;
@@ -234,6 +235,14 @@ if [ "${ARCH}" = "um" ]; then
 	else
 		archinclude=${SUBARCH}
 	fi
+elif [ "${SRCARCH}" = "arm" -a "${SUBARCH}" != "" ]; then
+	subarchdir=$(find ${tree}arch/$SRCARCH/ -name mach-* -type d -o \
+							-name plat-* -type d);
+	for i in $subarchdir; do
+		if ! [[ $i =~ .*-${SUBARCH}$ ]]; then
+			subarchprune="$subarchprune -wholename $i -prune -o"
+		fi
+	done
 fi
 
 remove_structs=
-- 
1.7.9.5

