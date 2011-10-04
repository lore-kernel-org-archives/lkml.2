Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933976Ab1JDXqL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Oct 2011 19:46:11 -0400
Received: from e33.co.us.ibm.com ([32.97.110.151]:37314 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933860Ab1JDXqJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Oct 2011 19:46:09 -0400
From: John Stultz <john.stultz@linaro.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: John Stultz <john.stultz@linaro.org>, Sam Ravnborg <sam@ravnborg.org>,
        gthelen@google.com, tartler@cs.fau.de,
        Dmitry Fink <Dmitry.Fink@palm.com>,
        Darren Hart <dvhart@linux.intel.com>,
        Eric B Munson <ebmunson@us.ibm.com>,
        Bruce Ashfield <Bruce.Ashfield@windriver.com>,
        Michal Marek <mmarek@suse.cz>, linux-kbuild@vger.kernel.org
Subject: [PATCH] kconfig: Add merge_config.sh script
Date: Tue,  4 Oct 2011 16:45:19 -0700
Message-Id: <1317771919-18774-1-git-send-email-john.stultz@linaro.org>
X-Mailer: git-send-email 1.7.3.2.146.gca209
x-cbid: 11100423-2398-0000-0000-000000B836C8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

After noticing almost every distro has their own method of managing
config fragments, I went looking at some best practices, and wanted
to try to consolidate some of the different approaches so this fairly
simple infrastructure can be shared (and new distros/build systems
don't have to implement yet another config fragment merge script).

This script is most influenced by the Windriver tools used in
the Yocto Project, reusing some portions found there.

This script merges multiple config fragments, warning on any
overrided values. It then sets any unspecified values to their
default, then finally checks to make sure no specified value was
dropped due to unsatisfied dependencies.

I'm sure this implementation won't work for everyone, and I expect
it will need to evolve to adapt for various use cases. But I think
its a reasonable starting point.

v2:
  * Reworked to use alldefconfig instead of the proposed
olddefconfig as suggested by Sam Ravnborg.

v3:
  * Script improvements from Dmitri.
  * allnoconfig option from Darren
  * pre-make exit option from Darren
  * lots of other fixes/cleanups from Darren.
  * Fix final check to not compain about config values in comments

Please let me know if you have any comments or thoughts!

CC: Sam Ravnborg <sam@ravnborg.org>
CC: gthelen@google.com
CC: tartler@cs.fau.de
CC: Dmitry Fink <Dmitry.Fink@palm.com>
CC: Darren Hart <dvhart@linux.intel.com>
CC: Eric B Munson <ebmunson@us.ibm.com>
CC: Bruce Ashfield <Bruce.Ashfield@windriver.com>
CC: Michal Marek <mmarek@suse.cz>
CC: linux-kbuild@vger.kernel.org
Signed-off-by: John Stultz <john.stultz@linaro.org>
---
 scripts/kconfig/merge_config.sh |  117 +++++++++++++++++++++++++++++++++++++++
 1 files changed, 117 insertions(+), 0 deletions(-)
 create mode 100755 scripts/kconfig/merge_config.sh

diff --git a/scripts/kconfig/merge_config.sh b/scripts/kconfig/merge_config.sh
new file mode 100755
index 0000000..890276b
--- /dev/null
+++ b/scripts/kconfig/merge_config.sh
@@ -0,0 +1,117 @@
+#!/bin/sh
+#  merge_config.sh - Takes a list of config fragment values, and merges
+#  them one by one. Provides warnings on overridden values, and specified
+#  values that did not make it to the resulting .config file (due to missed
+#  dependencies or config symbol removal).
+#
+#  Portions reused from kconf_check and generate_cfg:
+#  http://git.yoctoproject.org/cgit/cgit.cgi/yocto-kernel-tools/tree/tools/kconf_check
+#  http://git.yoctoproject.org/cgit/cgit.cgi/yocto-kernel-tools/tree/tools/generate_cfg
+#
+#  Copyright (c) 2009-2010 Wind River Systems, Inc.
+#  Copyright 2011 Linaro
+#
+#  This program is free software; you can redistribute it and/or modify
+#  it under the terms of the GNU General Public License version 2 as
+#  published by the Free Software Foundation.
+#
+#  This program is distributed in the hope that it will be useful,
+#  but WITHOUT ANY WARRANTY; without even the implied warranty of
+#  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
+#  See the GNU General Public License for more details.
+
+clean_up() {
+       rm -f $TMP_FILE
+       exit
+}
+trap clean_up SIGHUP SIGINT SIGTERM
+
+usage() {
+	echo "Usage: $0 [OPTIONS] [CONFIG [...]]"
+	echo "  -h    display this help text"
+	echo "  -m    only merge the fragments, do not execute the make command"
+	echo "  -n    use allnoconfig instead of alldefconfig"
+}
+
+MAKE=true
+ALLTARGET=alldefconfig
+
+while true; do
+	case $1 in
+	"-n")
+		ALLTARGET=allnoconfig
+		shift
+		continue
+		;;
+	"-m")
+		MAKE=false
+		shift
+		continue
+		;;
+	"-h")
+		usage
+		exit
+		;;
+	*)
+		break
+		;;
+	esac
+done
+
+
+
+MERGE_LIST=$*
+SED_CONFIG_EXP="s/^\(# \)\{0,1\}\(CONFIG_[a-zA-Z0-9_]*\)[= ].*/\2/p"
+TMP_FILE=$(mktemp ./.tmp.config.XXXXXXXXXX)
+
+# Merge files, printing warnings on overrided values
+for MERGE_FILE in $MERGE_LIST ; do
+	echo "Merging $MERGE_FILE"
+	CFG_LIST=$(sed -n "$SED_CONFIG_EXP" $MERGE_FILE)
+
+	for CFG in $CFG_LIST ; do
+		grep -q -w $CFG $TMP_FILE
+		if [ $? -eq 0 ] ; then
+			PREV_VAL=$(grep -w $CFG $TMP_FILE)
+			NEW_VAL=$(grep -w $CFG $MERGE_FILE)
+			if [ "x$PREV_VAL" != "x$NEW_VAL" ] ; then
+			echo Value of $CFG is redefined by fragment $MERGE_FILE:
+			echo Previous  value: $PREV_VAL
+			echo New value:       $NEW_VAL
+			echo
+			fi
+			sed -i "/$CFG[ =]/d" $TMP_FILE
+		fi
+	done
+	cat $MERGE_FILE >> $TMP_FILE
+done
+
+if [ "$MAKE" = "false" ]; then
+	cp $TMP_FILE .config
+	echo "#"
+	echo "# merged configuration written to .config (needs make)"
+	echo "#"
+	clean_up
+	exit
+fi
+
+# Use the merged file as the starting point for:
+# alldefconfig: Fills in any missing symbols with Kconfig default
+# allnoconfig: Fills in any missing symbols with # CONFIG_* is not set
+make KCONFIG_ALLCONFIG=$TMP_FILE $ALLTARGET
+
+
+# Check all specified config values took (might have missed-dependency issues)
+for CFG in $(sed -n "$SED_CONFIG_EXP" $TMP_FILE); do
+
+	REQUESTED_VAL=$(sed -n "$SED_CONFIG_EXP" $TMP_FILE | grep -w -e "$CFG")
+	ACTUAL_VAL=$(sed -n "$SED_CONFIG_EXP" .config | grep -w -e "$CFG")
+	if [ "x$REQUESTED_VAL" != "x$ACTUAL_VAL" ] ; then
+		echo "Value requested for $CFG not in final .config"
+		echo "Requested value:  $REQUESTED_VAL"
+		echo "Actual value:     $ACTUAL_VAL"
+		echo ""
+	fi
+done
+
+clean_up
-- 
1.7.3.2.146.gca209

