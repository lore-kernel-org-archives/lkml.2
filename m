Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753039Ab0FMH0t (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jun 2010 03:26:49 -0400
Received: from mgw2.diku.dk ([130.225.96.92]:42514 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752259Ab0FMH0r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jun 2010 03:26:47 -0400
From: Nicolas Palix <npalix@diku.dk>
To: Julia Lawall <julia@diku.dk>, Gilles Muller <Gilles.Muller@lip6.fr>,
       Nicolas Palix <npalix@diku.dk>, Michal Marek <mmarek@suse.cz>,
       Sam Ravnborg <sam@ravnborg.org>, Joerg Roedel <joerg.roedel@amd.com>,
       cocci@diku.dk, linux-kernel@vger.kernel.org
Cc: Nicolas Palix <npalix@diku.dk>
Subject: [PATCH] Add support for the C variable in the coccicheck script
Date: Sun, 13 Jun 2010 09:26:34 +0200
Message-Id: <1276413994-4044-1-git-send-email-npalix@diku.dk>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch makes it possible to use the Coccinelle checker with the C
variable of the build system. To check only newly edited code, the
following command may be used:

'make C={1,2} CHECK="scripts/coccicheck"'

This runs every semantic patch in scripts/coccinelle by default. The
COCCI variable may additionally be used to only apply a single
semantic patch.

Signed-off-by: Nicolas Palix <npalix@diku.dk>
Signed-off-by: Julia Lawall <julia@diku.dk>
---
 scripts/coccicheck |   76 +++++++++++++++++++++++++++++++++++-----------------
 1 files changed, 51 insertions(+), 25 deletions(-)

diff --git a/scripts/coccicheck b/scripts/coccicheck
index 037424b..b8bcf1f 100755
--- a/scripts/coccicheck
+++ b/scripts/coccicheck
@@ -2,53 +2,79 @@
 
 SPATCH="`which ${SPATCH:=spatch}`"
 
+if [ "$C" = "1" -o "$C" = "2" ]; then
+    ONLINE=1
+
+# This requires Coccinelle >= 0.2.3
+#    FLAGS="-ignore_unknown_options -very_quiet"
+#    OPTIONS=$*
+
+# Workaround for Coccinelle < 0.2.3
+    FLAGS="-I $srctree/include -very_quiet"
+    shift $(( $# - 1 ))
+    OPTIONS=$1
+else
+    ONLINE=0
+    FLAGS="-very_quiet"
+fi
+
 if [ ! -x "$SPATCH" ]; then
     echo 'spatch is part of the Coccinelle project and is available at http://coccinelle.lip6.fr/'
     exit 1
 fi
 
 if [ "$MODE" = "" ] ; then
-    echo 'You have not explicitly specify the mode to use. Fallback to "report".'
-    echo 'You can specify the mode with "make coccicheck MODE=<mode>"'
-    echo 'Available modes are: report, patch, context, org'
+    if [ "$ONLINE" = "0" ] ; then
+	echo 'You have not explicitly specify the mode to use. Fallback to "report".'
+	echo 'You can specify the mode with "make coccicheck MODE=<mode>"'
+	echo 'Available modes are: report, patch, context, org'
+    fi
     MODE="report"
 fi
 
-echo ''
-echo 'Please check for false positives in the output before submitting a patch.'
-echo 'When using "patch" mode, carefully review the patch before submitting it.'
-echo ''
+if [ "$ONLINE" = "0" ] ; then
+    echo ''
+    echo 'Please check for false positives in the output before submitting a patch.'
+    echo 'When using "patch" mode, carefully review the patch before submitting it.'
+    echo ''
+fi
 
-function coccinelle {
+coccinelle () {
     COCCI="$1"
-    DIR="$2"
 
     OPT=`grep "Option" $COCCI | cut -d':' -f2`
-    FILE=`echo $COCCI | sed "s|$DIR/||"`
 
-    echo "Processing `basename $COCCI` with option(s) \"$OPT\""
-    echo 'Message example to submit a patch:'
+#   The option '-parse_cocci' can be used to syntaxically check the SmPL files.
+#
+#    $SPATCH -D $MODE $FLAGS -parse_cocci $COCCI $OPT > /dev/null
 
-    sed -e '/\/\/\//!d' -e 's|^///||' $COCCI
+    if [ "$ONLINE" = "0" ] ; then
 
-    echo ' The semantic patch that makes this change is available'
-    echo " in $FILE."
-    echo ''
-    echo ' More information about semantic patching is available at'
-    echo ' http://coccinelle.lip6.fr/'
-    echo ''
+	FILE=`echo $COCCI | sed "s|$srctree/||"`
 
-#   The option '-parse_cocci' can be used to syntaxically check the SmPL files.
-#
-#    $SPATCH -D $MODE -very_quiet -parse_cocci $COCCI $OPT > /dev/null
+	echo "Processing `basename $COCCI` with option(s) \"$OPT\""
+	echo 'Message example to submit a patch:'
+
+	sed -e '/\/\/\//!d' -e 's|^///||' $COCCI
+
+	echo ' The semantic patch that makes this change is available'
+	echo " in $FILE."
+	echo ''
+	echo ' More information about semantic patching is available at'
+	echo ' http://coccinelle.lip6.fr/'
+	echo ''
+
+	$SPATCH -D $MODE $FLAGS -sp_file $COCCI $OPT -dir $srctree || exit 1
+    else
+	$SPATCH -D $MODE $FLAGS -sp_file $COCCI $OPT $OPTIONS || exit 1
+    fi
 
-    $SPATCH -D $MODE -very_quiet -sp_file $COCCI $OPT -dir $DIR
 }
 
 if [ "$COCCI" = "" ] ; then
     for f in `find $srctree/scripts/coccinelle/ -name '*.cocci' -type f | sort`; do
-	coccinelle $f $srctree;
+	coccinelle $f
     done
 else
-    coccinelle $COCCI $srctree
+    coccinelle $COCCI
 fi
-- 
1.7.0.4

