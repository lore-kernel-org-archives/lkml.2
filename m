Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752878Ab1LATvH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Dec 2011 14:51:07 -0500
Received: from e38.co.us.ibm.com ([32.97.110.159]:56983 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751411Ab1LATvF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Dec 2011 14:51:05 -0500
From: John Stultz <john.stultz@linaro.org>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: John Stultz <john.stultz@linaro.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Darren Hart <dvhart@linux.intel.com>, Michal Marek <mmarek@suse.cz>,
        Arnaud Lacombe <lacombar@gmail.com>
Subject: [PATCH] merge_config.sh: Fix bug in final check
Date: Thu,  1 Dec 2011 11:50:53 -0800
Message-Id: <1322769053-25038-1-git-send-email-john.stultz@linaro.org>
X-Mailer: git-send-email 1.7.3.2.146.gca209
x-cbid: 11120119-5518-0000-0000-000000BE9C70
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey Andrew,

Arnaud Lacombe pointed out the final checking that
the requested configs were included in the final .config
was broken.

The example was that if you had a fragment that disabled
CONFIG_DECOMPRESS_GZIP applied to a normal defconfig,
there would be no final warning that CONFIG_DECOMPRESS_GZIP
was acutally set in the final .config.

This bug was introduced by me in v3 of the original patch, and
the following patch reverts the invalid change.

CC: Andrew Morton <akpm@linux-foundation.org>
CC: Darren Hart <dvhart@linux.intel.com>
CC: Michal Marek <mmarek@suse.cz>
CC: Arnaud Lacombe <lacombar@gmail.com>
Reported-by: Arnaud Lacombe <lacombar@gmail.com>
Signed-off-by: John Stultz <john.stultz@linaro.org>
---
 scripts/kconfig/merge_config.sh |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/scripts/kconfig/merge_config.sh b/scripts/kconfig/merge_config.sh
index 890276b..6f12fb3 100755
--- a/scripts/kconfig/merge_config.sh
+++ b/scripts/kconfig/merge_config.sh
@@ -104,8 +104,8 @@ make KCONFIG_ALLCONFIG=$TMP_FILE $ALLTARGET
 # Check all specified config values took (might have missed-dependency issues)
 for CFG in $(sed -n "$SED_CONFIG_EXP" $TMP_FILE); do
 
-	REQUESTED_VAL=$(sed -n "$SED_CONFIG_EXP" $TMP_FILE | grep -w -e "$CFG")
-	ACTUAL_VAL=$(sed -n "$SED_CONFIG_EXP" .config | grep -w -e "$CFG")
+	REQUESTED_VAL=$(grep -w -e "$CFG" $TMP_FILE)
+	ACTUAL_VAL=$(grep -w -e "$CFG" .config)
 	if [ "x$REQUESTED_VAL" != "x$ACTUAL_VAL" ] ; then
 		echo "Value requested for $CFG not in final .config"
 		echo "Requested value:  $REQUESTED_VAL"
-- 
1.7.3.2.146.gca209

