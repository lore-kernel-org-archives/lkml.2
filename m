Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751509Ab1IVBaU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Sep 2011 21:30:20 -0400
Received: from smtp-relay2.palm.com ([64.28.152.243]:4666 "EHLO
	smtp-relay2.palm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750826Ab1IVBaR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Sep 2011 21:30:17 -0400
X-Greylist: delayed 571 seconds by postgrey-1.27 at vger.kernel.org; Wed, 21 Sep 2011 21:30:17 EDT
X-IronPort-AV: E=Sophos;i="4.68,420,1312182000"; 
   d="scan'208";a="8598625"
From: "Dmitry Fink (Palm GBU)" <Dmitry.Fink@palm.com>
To: John Stultz <john.stultz@linaro.org>, lkml <linux-kernel@vger.kernel.org>
CC: Sam Ravnborg <sam@ravnborg.org>, "gthelen@google.com" <gthelen@google.com>,
        "tartler@cs.fau.de" <tartler@cs.fau.de>,
        Darren Hart <dvhart@linux.intel.com>,
        Eric B Munson <ebmunson@us.ibm.com>,
        Bruce Ashfield <Bruce.Ashfield@windriver.com>,
        Michal Marek <mmarek@suse.cz>,
        "linux-kbuild@vger.kernel.org" <linux-kbuild@vger.kernel.org>
Date: Wed, 21 Sep 2011 18:20:38 -0700
Subject: Re: [PATCH] kconfig: Add merge_config.sh script
Thread-Topic: [PATCH] kconfig: Add merge_config.sh script
Thread-Index: Acx4xdaQbuFBOvEZQsaOWD1N5dzd7Q==
Message-ID: <CA9FD86E.25CEB%dmitry.fink@palm.com>
In-Reply-To: <1316582561-23066-1-git-send-email-john.stultz@linaro.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Microsoft-MacOutlook/14.12.0.110505
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, John
Here is another suggestion:

--- a/scripts/kconfig/merge_config.sh
+++ b/scripts/kconfig/merge_config.sh
@@ -28,11 +28,11 @@ TMP_FILE=$(mktemp ./.tmp.config.XXXXXXXXXX)
 # Merge files, printing warnings on overrided values
 for MERGE_FILE in $MERGE_LIST ; do
 	echo "Merging $MERGE_FILE"
-	CFG_LIST=`cat $MERGE_FILE | \
+	CFG_LIST=`cat $MERGE_FILE | grep -e "CONFIG_[a-zA-Z0-9_]*" | \
 	  sed 's/^\(# \)\{0,1\}\(CONFIG_[a-zA-Z0-9_]*\)[= ].*/\2/'`
 	for CFG in $CFG_LIST ; do
 		grep -q -w $CFG $TMP_FILE
@@ -53,7 +53,7 @@ done
 make KCONFIG_ALLCONFIG=$TMP_FILE alldefconfig
 
 # Check all specified config values took (might have missed-dependency
issues)
-cat $TMP_FILE | while read line; do
+cat $TMP_FILE | grep -e "CONFIG_[a-zA-Z0-9_]*" | while read line; do
 	CFG=`echo $line | \
 		sed 's/^\(# \)\{0,1\}\(CONFIG_[a-zA-Z0-9_]*\)[= ].*/\2/'`

The original script chokes on fragments that include empty lines or section
comments (and think we do want them in fragments). There might be a nicer
way to
handle  it, this is the quickest fix I found, feel free to consider a
different
approach.

Dmitry


On 9/20/11 10:22 PM, "John Stultz" <john.stultz@linaro.org> wrote:

>After noticing almost every distro has their own method of managing
>config fragments, I went looking at some best practices, and wanted
>to try to consolidate some of the different approaches so this fairly
>simple infrastructure can be shared (and new distros/build systems
>don't have to implement yet another config fragment merge script).
>
>This script is most influenced by the Windriver tools used in
>the Yocto Project, reusing some portions found there.
>
>This script merges multiple config fragments, warning on any
>overrided values. It then sets any unspecified values to their
>default, then finally checks to make sure no specified value was
>dropped due to unsatisfied dependencies.
>
>I'm sure I'm sure this implementation won't work for everyone, and
>I expect it will need to evolve to adapt for various use cases.
>But I think its a reasonable starting point.
>
>v2: Reworked to use alldefconfig instead of the proposed
>olddefconfig as suggested by Sam Ravnborg.
>
>Thanks to Darren Hart for early review and feedback!
>
>Please let me know if you have any comments or thoughts!
>
>CC: Sam Ravnborg <sam@ravnborg.org>
>CC: gthelen@google.com
>CC: tartler@cs.fau.de
>CC: Dmitry Fink <Dmitry.Fink@palm.com>
>CC: Darren Hart <dvhart@linux.intel.com>
>CC: Eric B Munson <ebmunson@us.ibm.com>
>CC: Bruce Ashfield <Bruce.Ashfield@windriver.com>
>CC: Michal Marek <mmarek@suse.cz>
>CC: linux-kbuild@vger.kernel.org
>Signed-off-by: John Stultz <john.stultz@linaro.org>
>---
> scripts/kconfig/merge_config.sh |   71
>+++++++++++++++++++++++++++++++++++++++
> 1 files changed, 71 insertions(+), 0 deletions(-)
> create mode 100755 scripts/kconfig/merge_config.sh
>
>diff --git a/scripts/kconfig/merge_config.sh
>b/scripts/kconfig/merge_config.sh
>new file mode 100755
>index 0000000..fda0139
>--- /dev/null
>+++ b/scripts/kconfig/merge_config.sh
>@@ -0,0 +1,71 @@
>+#!/bin/sh
>+#  merge_config.sh - Takes a list of config fragment values, and merges
>+#  them one by one. Provides warnings on overridden values, and specified
>+#  values that did not make it to the resulting .config file (due to
>missed
>+#  dependencies or config symbol removal).
>+#
>+#  Portions reused from kconf_check and generate_cfg:
>+#  
>http://git.yoctoproject.org/cgit/cgit.cgi/yocto-kernel-tools/tree/tools/kc
>onf_check
>+#  
>http://git.yoctoproject.org/cgit/cgit.cgi/yocto-kernel-tools/tree/tools/ge
>nerate_cfg
>+#
>+#  Copyright (c) 2009-2010 Wind River Systems, Inc.
>+#  Copyright 2011 Linaro
>+#
>+#  This program is free software; you can redistribute it and/or modify
>+#  it under the terms of the GNU General Public License version 2 as
>+#  published by the Free Software Foundation.
>+#
>+#  This program is distributed in the hope that it will be useful,
>+#  but WITHOUT ANY WARRANTY; without even the implied warranty of
>+#  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
>+#  See the GNU General Public License for more details.
>+
>+MERGE_LIST=$*
>+
>+
>+TMP_FILE=$(mktemp ./.tmp.config.XXXXXXXXXX)
>+
>+# Merge files, printing warnings on overrided values
>+for MERGE_FILE in $MERGE_LIST ; do
>+	echo "Merging $MERGE_FILE"
>+	CFG_LIST=`cat $MERGE_FILE | \
>+	  sed 's/^\(# \)\{0,1\}\(CONFIG_[a-zA-Z0-9_]*\)[= ].*/\2/'`
>+	for CFG in $CFG_LIST ; do
>+		grep -q -w $CFG $TMP_FILE
>+		if [ $? == 0 ] ; then
>+			PREV_VAL=`grep -w $CFG $TMP_FILE`
>+			NEW_VAL=`grep -w $CFG $MERGE_FILE`
>+			if [ "x$PREV_VAL" != "x$NEW_VAL" ] ; then
>+			echo Value of $CFG is redefined by fragment $MERGE_FILE:
>+			echo Previous  value: `grep -w $CFG $TMP_FILE`
>+			echo New value:       `grep -w $CFG $MERGE_FILE`
>+			echo
>+			fi
>+			sed -i "/$CFG[ =]/d" $TMP_FILE
>+		fi
>+	done
>+	cat $MERGE_FILE >> $TMP_FILE
>+done
>+
>+
>+# Use the merged file as the starting point for alldefconfig
>+# (Fills in any missing symbols with Kconfig default)
>+make KCONFIG_ALLCONFIG=$TMP_FILE alldefconfig
>+
>+# Check all specified config values took (might have missed-dependency
>issues)
>+cat $TMP_FILE | while read line; do
>+	CFG=`echo $line | \
>+		sed 's/^\(# \)\{0,1\}\(CONFIG_[a-zA-Z0-9_]*\)[= ].*/\2/'`
>+
>+	REQUESTED_VAL=`grep -w -e "$CFG" $TMP_FILE`
>+	ACTUAL_VAL=`grep -w -e "$CFG" .config`
>+	if [ "x$REQUESTED_VAL" != "x$ACTUAL_VAL" ] ; then
>+		echo "Value requested for $CFG not in final .config"
>+		echo "Requested value:  $REQUESTED_VAL"
>+		echo "Actual value:     $ACTUAL_VAL"
>+		echo ""
>+	fi
>+done
>+
>+# Cleanup
>+rm $TMP_FILE
>-- 
>1.7.3.2.146.gca209

