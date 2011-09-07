Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755622Ab1IGGHZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Sep 2011 02:07:25 -0400
Received: from mga01.intel.com ([192.55.52.88]:39453 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755510Ab1IGGE6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Sep 2011 02:04:58 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.68,343,1312182000"; 
   d="scan'208";a="48789633"
From: Oren Weil <oren.jer.weil@intel.com>
To: gregkh@suse.de
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        linux-watchdog@vger.kernel.org, alan@linux.intel.com, wim@iguana.be,
        tomas.winkler@intel.com, Oren Weil <oren.jer.weil@intel.com>
Subject: [PATCH 04/12 v2] staging: mei: adding watchdog ops
Date: Wed,  7 Sep 2011 09:03:10 +0300
Message-Id: <1315375398-29529-5-git-send-email-oren.jer.weil@intel.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1315375398-29529-1-git-send-email-oren.jer.weil@intel.com>
References: <1315375398-29529-1-git-send-email-oren.jer.weil@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

adding start and stop function.
start - check if AMT wd client is connected, which is been connected on driver
load.
stop - send stop command to AMT wd.

Signed-off-by: Oren Weil <oren.jer.weil@intel.com>
Acked-by: Tomas Winkler <tomas.winkler@intel.com>
---
 drivers/staging/mei/main.c    |    2 +-
 drivers/staging/mei/mei_dev.h |    5 ++
 drivers/staging/mei/wd.c      |   95 ++++++++++++++++++++++++++++++++++------
 3 files changed, 86 insertions(+), 16 deletions(-)

diff --git a/drivers/staging/mei/main.c b/drivers/staging/mei/main.c
index 37f07da..60003cd 100644
--- a/drivers/staging/mei/main.c
+++ b/drivers/staging/mei/main.c
@@ -58,7 +58,7 @@ static struct cdev mei_cdev;
 static int mei_major;
 /* The device pointer */
 /* Currently this driver works as long as there is only a single AMT device. */
-static struct pci_dev *mei_device;
+struct pci_dev *mei_device;
 
 static struct class *mei_class;
 
diff --git a/drivers/staging/mei/mei_dev.h b/drivers/staging/mei/mei_dev.h
index d434afc..43d7e1c 100644
--- a/drivers/staging/mei/mei_dev.h
+++ b/drivers/staging/mei/mei_dev.h
@@ -38,6 +38,11 @@
 #define MEI_WD_STATE_INDEPENDENCE_MSG_SENT       (1 << 0)
 
 /*
+ * MEI PCI Device object
+ */
+extern struct pci_dev *mei_device;
+
+/*
  * AMT Watchdog Device
  */
 #define INTEL_AMT_WATCHDOG_ID "INTCAMT"
diff --git a/drivers/staging/mei/wd.c b/drivers/staging/mei/wd.c
index d9e41a7..fb2bd3d 100644
--- a/drivers/staging/mei/wd.c
+++ b/drivers/staging/mei/wd.c
@@ -27,21 +27,6 @@
 #include "mei.h"
 
 /*
- * Watchdog Device structs
- */
-const struct watchdog_info wd_info = {
-		.identity = INTEL_AMT_WATCHDOG_ID,
-};
-
-struct watchdog_device amt_wd_dev = {
-		.info = &wd_info,
-		.timeout = AMT_WD_DEFAULT_TIMEOUT,
-		.min_timeout = AMT_WD_MIN_TIMEOUT,
-		.max_timeout = AMT_WD_MAX_TIMEOUT,
-};
-
-
-/*
  * MEI Watchdog Module Parameters
  */
 static u16 watchdog_timeout = AMT_WD_DEFAULT_TIMEOUT;
@@ -210,3 +195,83 @@ out:
 	return ret;
 }
 
+/*
+ * mei_wd_ops_start - wd start command from the watchdog core.
+ *
+ * @wd_dev - watchdog device struct
+ *
+ * returns 0 if success, negative errno code for failure
+ */
+static int mei_wd_ops_start(struct watchdog_device *wd_dev)
+{
+	int err = -ENODEV;
+	struct mei_device *dev;
+
+	dev = pci_get_drvdata(mei_device);
+	if (!dev)
+		return -ENODEV;
+
+	mutex_lock(&dev->device_lock);
+
+	if (dev->mei_state != MEI_ENABLED) {
+		dev_dbg(&dev->pdev->dev, "mei_state != MEI_ENABLED  mei_state= %d\n",
+		    dev->mei_state);
+		goto end_unlock;
+	}
+
+	if (dev->wd_cl.state != MEI_FILE_CONNECTED)	{
+		dev_dbg(&dev->pdev->dev, "MEI Driver is not connected to Watchdog Client\n");
+		goto end_unlock;
+	}
+
+	mei_wd_start_setup(dev);
+
+	err = 0;
+end_unlock:
+	mutex_unlock(&dev->device_lock);
+	return err;
+}
+
+/*
+ * mei_wd_ops_stop -  wd stop command from the watchdog core.
+ *
+ * @wd_dev - watchdog device struct
+ *
+ * returns 0 if success, negative errno code for failure
+ */
+static int mei_wd_ops_stop(struct watchdog_device *wd_dev)
+{
+	struct mei_device *dev;
+	dev = pci_get_drvdata(mei_device);
+
+	if (!dev)
+		return -ENODEV;
+
+	mutex_lock(&dev->device_lock);
+	mei_wd_stop(dev, false);
+	mutex_unlock(&dev->device_lock);
+
+	return 0;
+}
+
+/*
+ * Watchdog Device structs
+ */
+const struct watchdog_ops wd_ops = {
+		.owner = THIS_MODULE,
+		.start = mei_wd_ops_start,
+		.stop = mei_wd_ops_stop,
+};
+const struct watchdog_info wd_info = {
+		.identity = INTEL_AMT_WATCHDOG_ID,
+};
+
+struct watchdog_device amt_wd_dev = {
+		.info = &wd_info,
+		.ops = &wd_ops,
+		.timeout = AMT_WD_DEFAULT_TIMEOUT,
+		.min_timeout = AMT_WD_MIN_TIMEOUT,
+		.max_timeout = AMT_WD_MAX_TIMEOUT,
+};
+
+
-- 
1.7.4.1

