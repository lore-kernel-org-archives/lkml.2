Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756720Ab2LNQHj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2012 11:07:39 -0500
Received: from mail-lb0-f174.google.com ([209.85.217.174]:63490 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756666Ab2LNQHg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2012 11:07:36 -0500
From: =?UTF-8?q?Sjur=20Br=C3=A6ndeland?= <sjur.brandeland@stericsson.com>
To: Ohad Ben-Cohen <ohad@wizery.com>
Cc: Linus Walleij <linus.walleij@linaro.org>, linux-kernel@vger.kernel.org,
        =?UTF-8?q?Sjur=20Br=C3=A6ndeland?= <sjur@brendeland.net>,
        =?UTF-8?q?Sjur=20Br=C3=A6ndeland?= <sjur.brandeland@stericsson.com>
Subject: [RFCv2 05/11] remoteproc: Load firmware once.
Date: Fri, 14 Dec 2012 17:06:54 +0100
Message-Id: <1355501220-4572-6-git-send-email-sjur.brandeland@stericsson.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1355501220-4572-1-git-send-email-sjur.brandeland@stericsson.com>
References: <1355501220-4572-1-git-send-email-sjur.brandeland@stericsson.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Load the firmware once and pave the way for two way
communication of virtio configuration and status bits.
The virtio ring device address is now stored in the resource
table.

NOTE:  This patch requires device firmware change! The device
	memory layout changes. The virtio rings are no longer
	located at start of device memory. But the vring address
	can be read from the resource table. Also Carveout
	must be located before the virtio rings in the resource
	table.

Signed-off-by: Sjur Brændeland <sjur.brandeland@stericsson.com>
---
 drivers/remoteproc/remoteproc_core.c |  111 ++++++++++++----------------------
 1 files changed, 38 insertions(+), 73 deletions(-)

diff --git a/drivers/remoteproc/remoteproc_core.c b/drivers/remoteproc/remoteproc_core.c
index 151e138..ea4b76a 100644
--- a/drivers/remoteproc/remoteproc_core.c
+++ b/drivers/remoteproc/remoteproc_core.c
@@ -686,14 +686,10 @@ static rproc_handle_resource_t rproc_handle_rsc[RSC_LAST] = {
 	[RSC_CARVEOUT] = (rproc_handle_resource_t)rproc_handle_carveout,
 	[RSC_DEVMEM] = (rproc_handle_resource_t)rproc_handle_devmem,
 	[RSC_TRACE] = (rproc_handle_resource_t)rproc_handle_trace,
-	[RSC_VDEV] = NULL, /* VDEVs were handled upon registrarion */
-};
-
-static rproc_handle_resource_t rproc_handle_vdev_rsc[RSC_LAST] = {
 	[RSC_VDEV] = (rproc_handle_resource_t)rproc_handle_vdev,
 };
 
-/* handle firmware resource entries before booting the remote processor */
+/* handle firmware resource entries */
 static int
 rproc_handle_resource(struct rproc *rproc, struct resource_table *table,
 				int len,
@@ -778,18 +774,27 @@ static void rproc_resource_cleanup(struct rproc *rproc)
 }
 
 /*
- * take a firmware and boot a remote processor with it.
+ * take a firmware, parse the resouce table and load it
+ *
+ * Note: this function is called asynchronously upon registration of the
+ * remote processor (so we must wait until it completes before we try
+ * to unregister the device. one other option is just to use kref here,
+ * that might be cleaner).
  */
-static int rproc_fw_boot(struct rproc *rproc, const struct firmware *fw)
+static void rproc_fw_load(const struct firmware *fw, void *context)
 {
+	struct rproc *rproc = context;
 	struct device *dev = &rproc->dev;
 	const char *name = rproc->firmware;
 	struct resource_table *table;
 	int ret, tablesz;
 
+	if (!fw)
+		goto release_fw;
+
 	ret = rproc_fw_sanity_check(rproc, fw);
 	if (ret)
-		return ret;
+		goto release_fw;
 
 	dev_info(dev, "Booting fw image %s, size %zd\n", name, fw->size);
 
@@ -800,7 +805,7 @@ static int rproc_fw_boot(struct rproc *rproc, const struct firmware *fw)
 	ret = rproc_enable_iommu(rproc);
 	if (ret) {
 		dev_err(dev, "can't enable iommu: %d\n", ret);
-		return ret;
+		goto release_fw;
 	}
 
 	rproc->bootaddr = rproc_get_boot_addr(rproc, fw);
@@ -826,60 +831,23 @@ static int rproc_fw_boot(struct rproc *rproc, const struct firmware *fw)
 		goto clean_up;
 	}
 
-	/* power up the remote processor */
-	ret = rproc->ops->start(rproc);
-	if (ret) {
-		dev_err(dev, "can't start rproc %s: %d\n", rproc->name, ret);
-		goto clean_up;
-	}
-
-	rproc->state = RPROC_RUNNING;
-
-	dev_info(dev, "remote processor %s is now up\n", rproc->name);
+	rproc->state = RPROC_LOADED;
 
-	return 0;
+	dev_info(dev, "remote processor %s is loaded to memory\n", rproc->name);
 
 clean_up:
-	rproc_resource_cleanup(rproc);
-	rproc_disable_iommu(rproc);
-	return ret;
-}
-
-/*
- * take a firmware and look for virtio devices to register.
- *
- * Note: this function is called asynchronously upon registration of the
- * remote processor (so we must wait until it completes before we try
- * to unregister the device. one other option is just to use kref here,
- * that might be cleaner).
- */
-static void rproc_fw_config_virtio(const struct firmware *fw, void *context)
-{
-	struct rproc *rproc = context;
-	struct resource_table *table;
-	int ret, tablesz;
-
-	if (rproc_fw_sanity_check(rproc, fw) < 0)
-		goto out;
-
-	/* look for the resource table */
-	table = rproc_find_rsc_table(rproc, fw,  &tablesz);
-	if (!table)
-		goto out;
-
-	/* look for virtio devices and register them */
-	ret = rproc_handle_resource(rproc, table, tablesz,
-						rproc_handle_vdev_rsc);
-	if (ret)
-		goto out;
-
-out:
+	if (ret) {
+		rproc->state = RPROC_OFFLINE;
+		rproc_resource_cleanup(rproc);
+		rproc_disable_iommu(rproc);
+	}
+release_fw:
 	release_firmware(fw);
 	/* allow rproc_del() contexts, if any, to proceed */
 	complete_all(&rproc->firmware_loading_complete);
 }
 
-static int rproc_add_virtio_devices(struct rproc *rproc)
+static int rproc_load_firmware(struct rproc *rproc)
 {
 	int ret;
 
@@ -887,16 +855,12 @@ static int rproc_add_virtio_devices(struct rproc *rproc)
 	init_completion(&rproc->firmware_loading_complete);
 
 	/*
-	 * We must retrieve early virtio configuration info from
-	 * the firmware (e.g. whether to register a virtio device,
-	 * what virtio features does it support, ...).
-	 *
 	 * We're initiating an asynchronous firmware loading, so we can
 	 * be built-in kernel code, without hanging the boot process.
 	 */
 	ret = request_firmware_nowait(THIS_MODULE, FW_ACTION_HOTPLUG,
 				      rproc->firmware, &rproc->dev, GFP_KERNEL,
-				      rproc, rproc_fw_config_virtio);
+				      rproc, rproc_fw_load);
 	if (ret < 0) {
 		dev_err(&rproc->dev, "request_firmware_nowait err: %d\n", ret);
 		complete_all(&rproc->firmware_loading_complete);
@@ -930,7 +894,7 @@ int rproc_trigger_recovery(struct rproc *rproc)
 	/* wait until there is no more rproc users */
 	wait_for_completion(&rproc->crash_comp);
 
-	return rproc_add_virtio_devices(rproc);
+	return rproc_load_firmware(rproc);
 }
 
 /**
@@ -977,7 +941,6 @@ static void rproc_crash_handler_work(struct work_struct *work)
  */
 int rproc_boot(struct rproc *rproc)
 {
-	const struct firmware *firmware_p;
 	struct device *dev;
 	int ret;
 
@@ -1004,27 +967,28 @@ int rproc_boot(struct rproc *rproc)
 	/* skip the boot process if rproc is already powered up */
 	if (atomic_inc_return(&rproc->power) > 1) {
 		ret = 0;
-		goto unlock_mutex;
+		goto downref_driver;
 	}
 
 	dev_info(dev, "powering up %s\n", rproc->name);
 
-	/* load firmware */
-	ret = request_firmware(&firmware_p, rproc->firmware, dev);
-	if (ret < 0) {
-		dev_err(dev, "request_firmware failed: %d\n", ret);
+	/* power up the remote processor */
+	ret = rproc->ops->start(rproc);
+	if (ret) {
+		dev_err(dev, "can't start rproc %s: %d\n", rproc->name, ret);
+		rproc->state = RPROC_OFFLINE;
 		goto downref_rproc;
 	}
 
-	ret = rproc_fw_boot(rproc, firmware_p);
-
-	release_firmware(firmware_p);
+	rproc->state = RPROC_RUNNING;
+	dev_info(dev, "powering up %s\n", rproc->name);
 
 downref_rproc:
-	if (ret) {
+	if (ret)
 		module_put(dev->parent->driver->owner);
+downref_driver:
+	if (ret)
 		atomic_dec(&rproc->power);
-	}
 unlock_mutex:
 	mutex_unlock(&rproc->lock);
 	return ret;
@@ -1136,7 +1100,8 @@ int rproc_add(struct rproc *rproc)
 	/* create debugfs entries */
 	rproc_create_debug_dir(rproc);
 
-	return rproc_add_virtio_devices(rproc);
+	return rproc_load_firmware(rproc);
+
 }
 EXPORT_SYMBOL(rproc_add);
 
-- 
1.7.5.4

