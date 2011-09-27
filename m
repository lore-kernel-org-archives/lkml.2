Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752858Ab1I0DZ6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Sep 2011 23:25:58 -0400
Received: from mga02.intel.com ([134.134.136.20]:52452 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752789Ab1I0DZz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Sep 2011 23:25:55 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,351,1309762800"; 
   d="scan'208";a="56846347"
From: Darren Hart <dvhart@linux.intel.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: John Stultz <johnstul@us.ibm.com>, Darren Hart <dvhart@linux.intel.com>
Subject: [PATCH 2/2] merge_config.sh: trap signals and clean up
Date: Mon, 26 Sep 2011 20:25:49 -0700
Message-Id: <7332e875ca5e32e7c956591c931a8c2c0ed8f7b1.1317093857.git.dvhart@linux.intel.com>
X-Mailer: git-send-email 1.7.6.2
In-Reply-To: <1317093949-20219-1-git-send-email-dvhart@linux.intel.com>
References: <1316582561-23066-1-git-send-email-john.stultz@linaro.org>
 <1317093949-20219-1-git-send-email-dvhart@linux.intel.com>
In-Reply-To: <a3c278930a1995e5c78486a20763a1ec780f63c4.1317093857.git.dvhart@linux.intel.com>
References: <a3c278930a1995e5c78486a20763a1ec780f63c4.1317093857.git.dvhart@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The script creates a temp file, but doesn't ensure that it cleans up after
itself in the event of a signal.

Trap SIGHUP SIGINT and SIGTERM and remove the temp file.

Signed-off-by: Darren Hart <dvhart@linux.intel.com>
---
 scripts/kconfig/merge_config.sh |   11 +++++++----
 1 files changed, 7 insertions(+), 4 deletions(-)

diff --git a/scripts/kconfig/merge_config.sh b/scripts/kconfig/merge_config.sh
index a644724..a4b1bad 100755
--- a/scripts/kconfig/merge_config.sh
+++ b/scripts/kconfig/merge_config.sh
@@ -20,11 +20,15 @@
 #  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
 #  See the GNU General Public License for more details.
 
-MERGE_LIST=$*
+clean_up() {
+	rm -f $TMP_FILE
+	exit
+}
 
+trap clean_up SIGHUP SIGINT SIGTERM
 
+MERGE_LIST=$*
 TMP_FILE=$(mktemp ./.tmp.config.XXXXXXXXXX)
-
 SED_CONFIG_EXP="s/^\(# \)\{0,1\}\(CONFIG_[a-zA-Z0-9_]*\)[= ].*/\2/p"
 
 # Merge files, printing warnings on overrided values
@@ -65,5 +69,4 @@ for CFG in `sed -n "$SED_CONFIG_EXP" $TMP_FILE`; do
 	fi
 done
 
-# Cleanup
-rm $TMP_FILE
+clean_up
-- 
1.7.6.2

