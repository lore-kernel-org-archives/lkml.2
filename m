Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751339Ab2LCSIM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Dec 2012 13:08:12 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:47568 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751033Ab2LCSIL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Dec 2012 13:08:11 -0500
From: Joonsoo Kim <js1304@gmail.com>
To: Michal Marek <mmarek@suse.cz>
Cc: linux-kernel@vger.kernel.org, Joonsoo Kim <js1304@gmail.com>
Subject: [PATCH v2 1/2] scripts/tags.sh: Support subarch for ARM
Date: Tue,  4 Dec 2012 03:04:32 +0900
Message-Id: <1354557873-21889-1-git-send-email-js1304@gmail.com>
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
---
v2: change bash specific '[[]]' to 'case in' statement.

diff --git a/scripts/tags.sh b/scripts/tags.sh
index 79fdafb..38483f4 100755
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
@@ -234,6 +235,21 @@ if [ "${ARCH}" = "um" ]; then
 	else
 		archinclude=${SUBARCH}
 	fi
+elif [ "${SRCARCH}" = "arm" -a "${SUBARCH}" != "" ]; then
+	subarchdir=$(find ${tree}arch/$SRCARCH/ -name mach-* -type d -o \
+							-name plat-* -type d);
+	for i in $subarchdir; do
+		case "$i" in
+			*"mach-"${SUBARCH})
+				;;
+			*"plat-"${SUBARCH})
+				;;
+			*)
+				subarchprune="$subarchprune \
+						-wholename $i -prune -o"
+				;;
+		esac
+	done
 fi
 
 remove_structs=
-- 
1.7.9.5

