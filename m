Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932754Ab0JDUuh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Oct 2010 16:50:37 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:44276 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932558Ab0JDUuf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Oct 2010 16:50:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:message-id:x-mailer;
        b=oSPMp/gQVzqSHLJhFY69yFQza2IXMhFfEmDMfvxWv5Z+nz+b6fwM66upgxH/3WN7Ka
         mZWDyJLb/DzTCBSHr/W3fshs990EkuTSXr4fBx5yHrzYUmlXeoSwpQUL9Z8HESb0C7Ge
         QfpjXtT0+q865/ND6fwV1aX3gb9bEDtvp1vS0=
From: Nicolas Palix <npalix.work@gmail.com>
To: Julia Lawall <julia@diku.dk>, Gilles Muller <Gilles.Muller@lip6.fr>,
        Nicolas Palix <npalix@diku.dk>, Michal Marek <mmarek@suse.cz>,
        Sam Ravnborg <sam@ravnborg.org>, Joerg Roedel <joerg.roedel@amd.com>,
        cocci@diku.dk, linux-kernel@vger.kernel.org
Subject: [PATCH 4/5] Coccinelle: Add a new mode named 'chain'
Date: Mon,  4 Oct 2010 22:50:08 +0200
Message-Id: <1286225409-22200-1-git-send-email-npalix.work@gmail.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

spatch now returns -1 when a virtual rule (given with
-D on the command line) is not defined in the semantic patch.

Using this spatch feature, coccicheck is now
tries several modes by default, in the order:
	patch, report, context, org

Signed-off-by: Nicolas Palix <npalix.work@gmail.com>
Signed-off-by: Julia Lawall <julia@diku.dk>
---
 scripts/coccicheck |   16 +++++++++++-----
 1 files changed, 11 insertions(+), 5 deletions(-)

diff --git a/scripts/coccicheck b/scripts/coccicheck
index 4655551..efaf108 100755
--- a/scripts/coccicheck
+++ b/scripts/coccicheck
@@ -16,6 +16,7 @@ if [ "$C" = "1" -o "$C" = "2" ]; then
 else
     ONLINE=0
     FLAGS="-very_quiet"
+    OPTIONS="-dir $srctree"
 fi
 
 if [ ! -x "$SPATCH" ]; then
@@ -25,11 +26,11 @@ fi
 
 if [ "$MODE" = "" ] ; then
     if [ "$ONLINE" = "0" ] ; then
-	echo 'You have not explicitly specified the mode to use. Fallback to "report".'
+	echo 'You have not explicitly specified the mode to use. Using default 'chain' mode.'
+	echo 'All available modes will be tried (in that order): patch, report, context, org'
 	echo 'You can specify the mode with "make coccicheck MODE=<mode>"'
-	echo 'Available modes are: report, patch, context, org'
     fi
-    MODE="report"
+    MODE="chain"
 fi
 
 if [ "$ONLINE" = "0" ] ; then
@@ -68,10 +69,15 @@ coccinelle () {
 	echo ' More information about semantic patching is available at'
 	echo ' http://coccinelle.lip6.fr/'
 	echo ''
+    fi
 
-	$SPATCH -D $MODE $FLAGS -sp_file $COCCI $OPT -dir $srctree || exit 1
+    if [ "$MODE" = "chain" ] ; then
+	$SPATCH -D patch   $FLAGS -sp_file $COCCI $OPT $OPTIONS || \
+	$SPATCH -D report  $FLAGS -sp_file $COCCI $OPT $OPTIONS || \
+	$SPATCH -D context $FLAGS -sp_file $COCCI $OPT $OPTIONS || \
+	$SPATCH -D org     $FLAGS -sp_file $COCCI $OPT $OPTIONS || exit 1
     else
-	$SPATCH -D $MODE $FLAGS -sp_file $COCCI $OPT $OPTIONS || exit 1
+	$SPATCH -D $MODE   $FLAGS -sp_file $COCCI $OPT $OPTIONS || exit 1
     fi
 
 }
-- 
1.7.0.4

