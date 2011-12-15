Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759142Ab1LOQic (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Dec 2011 11:38:32 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:35953 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759115Ab1LOQia (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Dec 2011 11:38:30 -0500
From: <pavan_savoy@ti.com>
To: <gregkh@suse.de>, <linux-kernel@vger.kernel.org>
CC: <pavan_savoy@sify.com>, Pavan Savoy <pavan_savoy@ti.com>
Subject: [PATCH v2 2/3] drivers:misc: ti-st: flush UART upon fw failure
Date: Thu, 15 Dec 2011 10:38:21 -0600
Message-ID: <1323967102-13380-3-git-send-email-pavan_savoy@ti.com>
X-Mailer: git-send-email 1.5.6.3
In-Reply-To: <1323967102-13380-2-git-send-email-pavan_savoy@ti.com>
References: <1323967102-13380-1-git-send-email-pavan_savoy@ti.com>
 <1323967102-13380-2-git-send-email-pavan_savoy@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Pavan Savoy <pavan_savoy@ti.com>

Upon failure to read firmware version from chip or upon failure in responses
to firmware download the UART needs to be flushed of its existing buffers so
that the UIM can restart UART properly.

Signed-off-by: Pavan Savoy <pavan_savoy@ti.com>
---
 drivers/misc/ti-st/st_kim.c |   54 +++++++++++++++++++-----------------------
 1 files changed, 24 insertions(+), 30 deletions(-)

diff --git a/drivers/misc/ti-st/st_kim.c b/drivers/misc/ti-st/st_kim.c
index 43ef8d1..bc8a571 100644
--- a/drivers/misc/ti-st/st_kim.c
+++ b/drivers/misc/ti-st/st_kim.c
@@ -469,37 +469,21 @@ long st_kim_start(void *kim_data)
 		/* wait for ldisc to be installed */
 		err = wait_for_completion_timeout(&kim_gdata->ldisc_installed,
 				msecs_to_jiffies(LDISC_TIME));
-		if (!err) {	/* timeout */
-			pr_err("line disc installation timed out ");
-			kim_gdata->ldisc_install = 0;
-			pr_info("ldisc_install = 0");
-			sysfs_notify(&kim_gdata->kim_pdev->dev.kobj,
-					NULL, "install");
-			/* the following wait is never going to be completed,
-			 * since the ldisc was never installed, hence serving
-			 * as a mdelay of LDISC_TIME msecs */
-			err = wait_for_completion_timeout
-				(&kim_gdata->ldisc_installed,
-				 msecs_to_jiffies(LDISC_TIME));
-			err = -ETIMEDOUT;
+		if (!err) {
+			/* ldisc installation timeout,
+			 * flush uart, power cycle BT_EN */
+			pr_err("ldisc installation timeout");
+			err = st_kim_stop(kim_gdata);
 			continue;
 		} else {
 			/* ldisc installed now */
-			pr_info(" line discipline installed ");
+			pr_info("line discipline installed");
 			err = download_firmware(kim_gdata);
 			if (err != 0) {
+				/* ldisc installed but fw download failed,
+				 * flush uart & power cycle BT_EN */
 				pr_err("download firmware failed");
-				kim_gdata->ldisc_install = 0;
-				pr_info("ldisc_install = 0");
-				sysfs_notify(&kim_gdata->kim_pdev->dev.kobj,
-						NULL, "install");
-				/* this wait might be completed, though in the
-				 * tty_close() since the ldisc is already
-				 * installed */
-				err = wait_for_completion_timeout
-					(&kim_gdata->ldisc_installed,
-					 msecs_to_jiffies(LDISC_TIME));
-				err = -EINVAL;
+				err = st_kim_stop(kim_gdata);
 				continue;
 			} else {	/* on success don't retry */
 				break;
@@ -510,8 +494,14 @@ long st_kim_start(void *kim_data)
 }
 
 /**
- * st_kim_stop - called from ST Core, on the last un-registration
- *	toggle low the chip enable gpio
+ * st_kim_stop - stop communication with chip.
+ *	This can be called from ST Core/KIM, on the-
+ *	(a) last un-register when chip need not be powered there-after,
+ *	(b) upon failure to either install ldisc or download firmware.
+ *	The function is responsible to (a) notify UIM about un-installation,
+ *	(b) flush UART if the ldisc was installed.
+ *	(c) reset BT_EN - pull down nshutdown at the end.
+ *	(d) invoke platform's chip disabling routine.
  */
 long st_kim_stop(void *kim_data)
 {
@@ -519,12 +509,16 @@ long st_kim_stop(void *kim_data)
 	struct kim_data_s	*kim_gdata = (struct kim_data_s *)kim_data;
 	struct ti_st_plat_data	*pdata =
 		kim_gdata->kim_pdev->dev.platform_data;
+	struct tty_struct	*tty = kim_gdata->core_data->tty;
 
 	INIT_COMPLETION(kim_gdata->ldisc_installed);
 
-	/* Flush any pending characters in the driver and discipline. */
-	tty_ldisc_flush(kim_gdata->core_data->tty);
-	tty_driver_flush_buffer(kim_gdata->core_data->tty);
+	if (tty) {	/* can be called before ldisc is installed */
+		/* Flush any pending characters in the driver and discipline. */
+		tty_ldisc_flush(tty);
+		tty_driver_flush_buffer(tty);
+		tty->ops->flush_buffer(tty);
+	}
 
 	/* send uninstall notification to UIM */
 	pr_info("ldisc_install = 0");
-- 
1.7.4.1

