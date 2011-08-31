Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756222Ab1HaNoP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Aug 2011 09:44:15 -0400
Received: from mga14.intel.com ([143.182.124.37]:5192 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756204Ab1HaNoM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Aug 2011 09:44:12 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.68,307,1312182000"; 
   d="scan'208";a="44294951"
From: Oren Weil <oren.jer.weil@intel.com>
To: gregkh@suse.de
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        linux-watchdog@vger.kernel.org, alan@linux.intel.com, wim@iguana.be,
        tomas.winkler@intel.com, Oren Weil <oren.jer.weil@intel.com>
Subject: [PATCH 05/12] staging: mei: adding watchdog ping
Date: Wed, 31 Aug 2011 16:42:41 +0300
Message-Id: <1314798168-15613-6-git-send-email-oren.jer.weil@intel.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1314798168-15613-1-git-send-email-oren.jer.weil@intel.com>
References: <1314798168-15613-1-git-send-email-oren.jer.weil@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

adding watchdog ping to send ping/heartbeat to the the AMT watchdog client.
in addition removing the heartbeat sending from the driver timers function.

Signed-off-by: Oren Weil <oren.jer.weil@intel.com>
Acked-by: Tomas Winkler <tomas.winkler@intel.com>
---
 drivers/staging/mei/interrupt.c |   27 --------------------
 drivers/staging/mei/wd.c        |   53 +++++++++++++++++++++++++++++++++++++++
 2 files changed, 53 insertions(+), 27 deletions(-)

diff --git a/drivers/staging/mei/interrupt.c b/drivers/staging/mei/interrupt.c
index 958a7e2..62b8001 100644
--- a/drivers/staging/mei/interrupt.c
+++ b/drivers/staging/mei/interrupt.c
@@ -1430,33 +1430,6 @@ void mei_wd_timer(struct work_struct *work)
 		}
 	}
 
-	if (dev->wd_cl.state != MEI_FILE_CONNECTED)
-		goto out;
-
-	/* Watchdog */
-	if (dev->wd_due_counter && !dev->wd_bypass) {
-		if (--dev->wd_due_counter == 0) {
-			if (dev->mei_host_buffer_is_empty &&
-			    mei_flow_ctrl_creds(dev, &dev->wd_cl) > 0) {
-				dev->mei_host_buffer_is_empty = false;
-				dev_dbg(&dev->pdev->dev, "send watchdog.\n");
-
-				if (mei_wd_send(dev))
-					dev_dbg(&dev->pdev->dev, "wd send failed.\n");
-				else
-					if (mei_flow_ctrl_reduce(dev, &dev->wd_cl))
-						goto out;
-
-				if (dev->wd_timeout)
-					dev->wd_due_counter = 2;
-				else
-					dev->wd_due_counter = 0;
-
-			} else
-				dev->wd_pending = true;
-
-		}
-	}
 	if (dev->iamthif_stall_timer) {
 		if (--dev->iamthif_stall_timer == 0) {
 			dev_dbg(&dev->pdev->dev, "reseting because of hang to amthi.\n");
diff --git a/drivers/staging/mei/wd.c b/drivers/staging/mei/wd.c
index fb2bd3d..0bb18dc 100644
--- a/drivers/staging/mei/wd.c
+++ b/drivers/staging/mei/wd.c
@@ -255,15 +255,68 @@ static int mei_wd_ops_stop(struct watchdog_device *wd_dev)
 }
 
 /*
+ * mei_wd_ops_ping - wd ping command from the watchdog core.
+ *
+ * @wd_dev - watchdog device struct
+ *
+ * returns 0 if success, negative errno code for failure
+ */
+static int mei_wd_ops_ping(struct watchdog_device *wd_dev)
+{
+	int ret = 0;
+	struct mei_device *dev;
+	dev = pci_get_drvdata(mei_device);
+
+	if (!dev)
+		return -ENODEV;
+
+	mutex_lock(&dev->device_lock);
+
+	if (dev->wd_cl.state != MEI_FILE_CONNECTED) {
+		dev_dbg(&dev->pdev->dev, "wd is not connected.\n");
+		ret = -ENODEV;
+		goto end;
+	}
+
+	/* Check if we can send the ping to HW*/
+	if (dev->mei_host_buffer_is_empty &&
+		mei_flow_ctrl_creds(dev, &dev->wd_cl) > 0) {
+			dev->mei_host_buffer_is_empty = false;
+			dev_dbg(&dev->pdev->dev, "sending watchdog ping\n");
+
+			if (mei_wd_send(dev)) {
+				dev_dbg(&dev->pdev->dev, "wd send failed.\n");
+				ret = -EIO;
+				goto end;
+			}
+
+			if (mei_flow_ctrl_reduce(dev, &dev->wd_cl)) {
+				dev_dbg(&dev->pdev->dev, "mei_flow_ctrl_reduce() failed.\n");
+				ret = -EIO;
+				goto end;
+			}
+
+		} else {
+			dev->wd_pending = true;
+		}
+
+end:
+	mutex_unlock(&dev->device_lock);
+	return ret;
+}
+
+/*
  * Watchdog Device structs
  */
 const struct watchdog_ops wd_ops = {
 		.owner = THIS_MODULE,
 		.start = mei_wd_ops_start,
 		.stop = mei_wd_ops_stop,
+		.ping = mei_wd_ops_ping,
 };
 const struct watchdog_info wd_info = {
 		.identity = INTEL_AMT_WATCHDOG_ID,
+		.options = WDIOF_KEEPALIVEPING,
 };
 
 struct watchdog_device amt_wd_dev = {
-- 
1.7.4.1

