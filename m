Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752787Ab2LCHgV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Dec 2012 02:36:21 -0500
Received: from mail-da0-f46.google.com ([209.85.210.46]:37147 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751483Ab2LCHgU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Dec 2012 02:36:20 -0500
From: Zhangfei Gao <zhangfei.gao@linaro.org>
To: John Stultz <john.stultz@linaro.org>, Michal Marek <mmarek@suse.cz>,
        LKML <linux-kernel@vger.kernel.org>,
        "linaro-dev@lists.linaro.org" <linaro-dev@lists.linaro.org>
Cc: Zhangfei Gao <zhangfei.gao@linaro.org>
Subject: [PATCH] merge_config.sh: Add option to specify output dir
Date: Mon,  3 Dec 2012 15:36:10 +0800
Message-Id: <1354520170-12844-1-git-send-email-zhangfei.gao@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <50B82DA7.8030404@linaro.org>
References: <50B82DA7.8030404@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Provide a -O option to specify dir to put generated .config
Then merge_config.sh does not need to be copied to target dir,
for easy re-usage in other script

Signed-off-by: Zhangfei Gao <zhangfei.gao@linaro.org>
Tested-by: Jon Medhurst (Tixy) <tixy@linaro.org>
---
 scripts/kconfig/merge_config.sh |   20 ++++++++++++++++----
 1 file changed, 16 insertions(+), 4 deletions(-)

diff --git a/scripts/kconfig/merge_config.sh b/scripts/kconfig/merge_config.sh
index 974d5cb..05274fc 100755
--- a/scripts/kconfig/merge_config.sh
+++ b/scripts/kconfig/merge_config.sh
@@ -32,11 +32,13 @@ usage() {
 	echo "  -m    only merge the fragments, do not execute the make command"
 	echo "  -n    use allnoconfig instead of alldefconfig"
 	echo "  -r    list redundant entries when merging fragments"
+	echo "  -O    dir to put generated output files"
 }
 
 MAKE=true
 ALLTARGET=alldefconfig
 WARNREDUN=false
+OUTPUT=.
 
 while true; do
 	case $1 in
@@ -59,6 +61,16 @@ while true; do
 		shift
 		continue
 		;;
+	"-O")
+		if [ -d $2 ];then
+			OUTPUT=$(echo $2 | sed 's/\/*$//')
+		else
+			echo "output directory $2 does not exist" 1>&2
+			exit 1
+		fi
+		shift 2
+		continue
+		;;
 	*)
 		break
 		;;
@@ -100,9 +112,9 @@ for MERGE_FILE in $MERGE_LIST ; do
 done
 
 if [ "$MAKE" = "false" ]; then
-	cp $TMP_FILE .config
+	cp $TMP_FILE $OUTPUT/.config
 	echo "#"
-	echo "# merged configuration written to .config (needs make)"
+	echo "# merged configuration written to $OUTPUT/.config (needs make)"
 	echo "#"
 	clean_up
 	exit
@@ -111,14 +123,14 @@ fi
 # Use the merged file as the starting point for:
 # alldefconfig: Fills in any missing symbols with Kconfig default
 # allnoconfig: Fills in any missing symbols with # CONFIG_* is not set
-make KCONFIG_ALLCONFIG=$TMP_FILE $ALLTARGET
+make KCONFIG_ALLCONFIG=$TMP_FILE O=$OUTPUT $ALLTARGET
 
 
 # Check all specified config values took (might have missed-dependency issues)
 for CFG in $(sed -n "$SED_CONFIG_EXP" $TMP_FILE); do
 
 	REQUESTED_VAL=$(grep -w -e "$CFG" $TMP_FILE)
-	ACTUAL_VAL=$(grep -w -e "$CFG" .config)
+	ACTUAL_VAL=$(grep -w -e "$CFG" $OUTPUT/.config)
 	if [ "x$REQUESTED_VAL" != "x$ACTUAL_VAL" ] ; then
 		echo "Value requested for $CFG not in final .config"
 		echo "Requested value:  $REQUESTED_VAL"
-- 
1.7.9.5

