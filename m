Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753182Ab1FKRxO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Jun 2011 13:53:14 -0400
Received: from mta11.charter.net ([216.33.127.80]:58651 "EHLO
	mta11.charter.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751849Ab1FKRxK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Jun 2011 13:53:10 -0400
X-Greylist: delayed 8602 seconds by postgrey-1.27 at vger.kernel.org; Sat, 11 Jun 2011 13:53:10 EDT
X-Authority-Analysis: v=1.1 cv=vT9vkN3vVXssH3Ov7r/wQUs/sfIFjNPEFFf4aeKIi4A=
 c=1 sm=1 a=roWskU_etowA:10 a=lDGNyK2vIvEA:10 a=xzrYXqw+0zwiO4gHSXHcAg==:17
 a=QC6DmiQ5i6ZtQVrIgJwA:9 a=xzrYXqw+0zwiO4gHSXHcAg==:117
From: Greg Dietsche <Gregory.Dietsche@cuw.edu>
To: julia@diku.dk
Cc: Nicolas.Palix@inria.fr, rdunlap@xenotime.net, Gilles.Muller@lip6.fr,
        cocci@diku.dk, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Greg Dietsche <Gregory.Dietsche@cuw.edu>
Subject: [PATCH 1/2 v3] coccicheck: add M= option to control which dir is processed
Date: Sat, 11 Jun 2011 12:53:02 -0500
Message-Id: <1307814782-27415-1-git-send-email-Gregory.Dietsche@cuw.edu>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <4DF3A447.3050505@cuw.edu>
References: <4DF3A447.3050505@cuw.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Examples:
	make coccicheck M=drivers/net/wireless/
	make coccicheck SUBDIRS=drivers/net/wireless/

Version 2:
	fix patch file names when using M=
	tell coccinelle where the include files are

Version 3:
	Add second include option to support out of tree development
	Fix error message

Signed-off-by: Greg Dietsche <Gregory.Dietsche@cuw.edu>
---
 scripts/coccicheck |   19 ++++++++++++++-----
 1 files changed, 14 insertions(+), 5 deletions(-)

diff --git a/scripts/coccicheck b/scripts/coccicheck
index 1bb1a1b..3c27764 100755
--- a/scripts/coccicheck
+++ b/scripts/coccicheck
@@ -9,14 +9,23 @@ if [ "$C" = "1" -o "$C" = "2" ]; then
 #    FLAGS="-ignore_unknown_options -very_quiet"
 #    OPTIONS=$*
 
-# Workaround for Coccinelle < 0.2.3
-    FLAGS="-I $srctree/include -very_quiet"
-    shift $(( $# - 1 ))
-    OPTIONS=$1
+    if [ "$KBUILD_EXTMOD" = "" ] ; then
+        # Workaround for Coccinelle < 0.2.3
+        FLAGS="-I $srctree/include -very_quiet"
+        shift $(( $# - 1 ))
+        OPTIONS=$1
+    else
+	echo M= is not currently supported when C=1 or C=2
+	exit 1
+    fi
 else
     ONLINE=0
     FLAGS="-very_quiet"
-    OPTIONS="-dir $srctree"
+    if [ "$KBUILD_EXTMOD" = "" ] ; then
+        OPTIONS="-dir $srctree"
+    else
+        OPTIONS="-dir $KBUILD_EXTMOD -patch $srctree -I $srctree/include -I $KBUILD_EXTMOD/include"
+    fi
 fi
 
 if [ ! -x "$SPATCH" ]; then
-- 
1.7.2.5

