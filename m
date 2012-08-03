Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753958Ab2HCTqc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Aug 2012 15:46:32 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:56384 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753852Ab2HCTqY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Aug 2012 15:46:24 -0400
From: <pavan_savoy@ti.com>
To: <gregkh@suse.de>, <linux-kernel@vger.kernel.org>
CC: <pavan_savoy@sify.com>, Pavan Savoy <pavan_savoy@ti.com>
Subject: [PATCH v2 4/6] drivers/misc/ti-st: use cpu friendly completions
Date: Fri, 3 Aug 2012 14:46:15 -0500
Message-ID: <1344023177-21167-5-git-send-email-pavan_savoy@ti.com>
X-Mailer: git-send-email 1.5.6.3
In-Reply-To: <1344023177-21167-4-git-send-email-pavan_savoy@ti.com>
References: <1344023177-21167-1-git-send-email-pavan_savoy@ti.com>
 <1344023177-21167-2-git-send-email-pavan_savoy@ti.com>
 <1344023177-21167-3-git-send-email-pavan_savoy@ti.com>
 <1344023177-21167-4-git-send-email-pavan_savoy@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Pavan Savoy <pavan_savoy@ti.com>

Be nice to CPU and don't hog the resources, use a nice wait_for_interruptible
timeout for completions instead of wait_for_timeout which is
non-interruptible.

Signed-off-by: Pavan Savoy <pavan_savoy@ti.com>
---
 drivers/misc/ti-st/st_kim.c |   18 +++++++++---------
 1 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/misc/ti-st/st_kim.c b/drivers/misc/ti-st/st_kim.c
index 54ff644..0f36db3 100644
--- a/drivers/misc/ti-st/st_kim.c
+++ b/drivers/misc/ti-st/st_kim.c
@@ -207,8 +207,8 @@ static long read_local_version(struct kim_data_s *kim_gdata, char *bts_scr_name)
 		return -EIO;
 	}
 
-	if (!wait_for_completion_timeout
-	    (&kim_gdata->kim_rcvd, msecs_to_jiffies(CMD_RESP_TIME))) {
+	if (!wait_for_completion_interruptible_timeout(
+		&kim_gdata->kim_rcvd, msecs_to_jiffies(CMD_RESP_TIME))) {
 		pr_err(" waiting for ver info- timed out ");
 		return -ETIMEDOUT;
 	}
@@ -370,9 +370,9 @@ static long download_firmware(struct kim_data_s *kim_gdata)
 			break;
 		case ACTION_WAIT_EVENT:  /* wait */
 			pr_debug("W");
-			if (!wait_for_completion_timeout
-					(&kim_gdata->kim_rcvd,
-					 msecs_to_jiffies(CMD_RESP_TIME))) {
+			if (!wait_for_completion_interruptible_timeout(
+					&kim_gdata->kim_rcvd,
+					msecs_to_jiffies(CMD_RESP_TIME))) {
 				pr_err("response timeout during fw download ");
 				/* timed out */
 				release_firmware(kim_gdata->fw_entry);
@@ -462,8 +462,8 @@ long st_kim_start(void *kim_data)
 		sysfs_notify(&kim_gdata->kim_pdev->dev.kobj,
 				NULL, "install");
 		/* wait for ldisc to be installed */
-		err = wait_for_completion_timeout(&kim_gdata->ldisc_installed,
-				msecs_to_jiffies(LDISC_TIME));
+		err = wait_for_completion_interruptible_timeout(
+			&kim_gdata->ldisc_installed, msecs_to_jiffies(LDISC_TIME));
 		if (!err) {
 			/* ldisc installation timeout,
 			 * flush uart, power cycle BT_EN */
@@ -520,8 +520,8 @@ long st_kim_stop(void *kim_data)
 	sysfs_notify(&kim_gdata->kim_pdev->dev.kobj, NULL, "install");
 
 	/* wait for ldisc to be un-installed */
-	err = wait_for_completion_timeout(&kim_gdata->ldisc_installed,
-			msecs_to_jiffies(LDISC_TIME));
+	err = wait_for_completion_interruptible_timeout(
+		&kim_gdata->ldisc_installed, msecs_to_jiffies(LDISC_TIME));
 	if (!err) {		/* timeout */
 		pr_err(" timed out waiting for ldisc to be un-installed");
 		err = -ETIMEDOUT;
-- 
1.7.4.1

