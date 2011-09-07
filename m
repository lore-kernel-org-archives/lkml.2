Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755573Ab1IGGFW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Sep 2011 02:05:22 -0400
Received: from mga01.intel.com ([192.55.52.88]:6183 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755501Ab1IGGFE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Sep 2011 02:05:04 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.68,343,1312182000"; 
   d="scan'208";a="48789681"
From: Oren Weil <oren.jer.weil@intel.com>
To: gregkh@suse.de
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        linux-watchdog@vger.kernel.org, alan@linux.intel.com, wim@iguana.be,
        tomas.winkler@intel.com, Oren Weil <oren.jer.weil@intel.com>
Subject: [PATCH 06/12 v2] staging: mei: adding set_timeout watchdog function
Date: Wed,  7 Sep 2011 09:03:12 +0300
Message-Id: <1315375398-29529-7-git-send-email-oren.jer.weil@intel.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1315375398-29529-1-git-send-email-oren.jer.weil@intel.com>
References: <1315375398-29529-1-git-send-email-oren.jer.weil@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

add the ability to let the watchdog core set
the AMT watchdog timeout value.

the default value will be only set in the start function.

Signed-off-by: Oren Weil <oren.jer.weil@intel.com>
Acked-by: Tomas Winkler <tomas.winkler@intel.com>
---
 drivers/staging/mei/interface.h |    2 +-
 drivers/staging/mei/main.c      |    1 -
 drivers/staging/mei/wd.c        |   40 ++++++++++++++++++++++++++++++++++----
 3 files changed, 36 insertions(+), 7 deletions(-)

diff --git a/drivers/staging/mei/interface.h b/drivers/staging/mei/interface.h
index 2b5a22c..7bd38ae 100644
--- a/drivers/staging/mei/interface.h
+++ b/drivers/staging/mei/interface.h
@@ -51,7 +51,7 @@ int mei_flow_ctrl_creds(struct mei_device *dev, struct mei_cl *cl);
 int mei_wd_send(struct mei_device *dev);
 int mei_wd_stop(struct mei_device *dev, bool preserve);
 bool mei_wd_host_init(struct mei_device *dev);
-void mei_wd_start_setup(struct mei_device *dev);
+void mei_wd_set_start_timeout(struct mei_device *dev, u16 timeout);
 
 int mei_flow_ctrl_reduce(struct mei_device *dev, struct mei_cl *cl);
 
diff --git a/drivers/staging/mei/main.c b/drivers/staging/mei/main.c
index 60003cd..8d124724 100644
--- a/drivers/staging/mei/main.c
+++ b/drivers/staging/mei/main.c
@@ -1153,7 +1153,6 @@ static int mei_pci_resume(struct device *device)
 
 	/* Start watchdog if stopped in suspend */
 	if (dev->wd_timeout) {
-		mei_wd_start_setup(dev);
 		dev->wd_due_counter = 1;
 		schedule_delayed_work(&dev->wd_work, HZ);
 	}
diff --git a/drivers/staging/mei/wd.c b/drivers/staging/mei/wd.c
index 9338394..6643f7a 100644
--- a/drivers/staging/mei/wd.c
+++ b/drivers/staging/mei/wd.c
@@ -51,12 +51,12 @@ const uuid_le mei_wd_guid = UUID_LE(0x05B79A6F, 0x4628, 0x4D7F, 0x89,
 						0x32, 0xAB);
 
 
-void mei_wd_start_setup(struct mei_device *dev)
+void mei_wd_set_start_timeout(struct mei_device *dev, u16 timeout)
 {
-	dev_dbg(&dev->pdev->dev, "dev->wd_timeout=%d.\n", dev->wd_timeout);
+	dev_dbg(&dev->pdev->dev, "timeout=%d.\n", timeout);
 	memcpy(dev->wd_data, mei_start_wd_params, MEI_WD_PARAMS_SIZE);
 	memcpy(dev->wd_data + MEI_WD_PARAMS_SIZE,
-		&dev->wd_timeout, sizeof(u16));
+			&timeout, sizeof(u16));
 }
 
 /**
@@ -75,7 +75,6 @@ bool mei_wd_host_init(struct mei_device *dev)
 	dev->wd_timeout = watchdog_timeout;
 
 	if (dev->wd_timeout > 0) {
-		mei_wd_start_setup(dev);
 		/* find ME WD client */
 		mei_find_me_client_update_filext(dev, &dev->wd_cl,
 					&mei_wd_guid, MEI_WD_HOST_CLIENT_ID);
@@ -224,7 +223,7 @@ static int mei_wd_ops_start(struct watchdog_device *wd_dev)
 		goto end_unlock;
 	}
 
-	mei_wd_start_setup(dev);
+	mei_wd_set_start_timeout(dev, dev->wd_timeout);
 
 	err = 0;
 end_unlock:
@@ -307,6 +306,36 @@ end:
 }
 
 /*
+ * mei_wd_ops_set_timeout - wd set timeout command from the watchdog core.
+ *
+ * @wd_dev - watchdog device struct
+ * @timeout - timeout value to set
+ *
+ * returns 0 if success, negative errno code for failure
+ */
+static int mei_wd_ops_set_timeout(struct watchdog_device *wd_dev, unsigned int timeout)
+{
+	struct mei_device *dev;
+	dev = pci_get_drvdata(mei_device);
+
+	if (!dev)
+		return -ENODEV;
+
+	/* Check Timeout value */
+	if (timeout < AMT_WD_MIN_TIMEOUT || timeout > AMT_WD_MAX_TIMEOUT)
+		return -EINVAL;
+
+	mutex_lock(&dev->device_lock);
+
+	dev->wd_timeout = timeout;
+	mei_wd_set_start_timeout(dev, dev->wd_timeout);
+
+	mutex_unlock(&dev->device_lock);
+
+	return 0;
+}
+
+/*
  * Watchdog Device structs
  */
 const struct watchdog_ops wd_ops = {
@@ -314,6 +343,7 @@ const struct watchdog_ops wd_ops = {
 		.start = mei_wd_ops_start,
 		.stop = mei_wd_ops_stop,
 		.ping = mei_wd_ops_ping,
+		.set_timeout = mei_wd_ops_set_timeout,
 };
 const struct watchdog_info wd_info = {
 		.identity = INTEL_AMT_WATCHDOG_ID,
-- 
1.7.4.1

