Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1424725Ab2LFTgr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2012 14:36:47 -0500
Received: from mail-lb0-f174.google.com ([209.85.217.174]:59896 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1947019Ab2LFTfm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2012 14:35:42 -0500
From: =?UTF-8?q?Sjur=20Br=C3=A6ndeland?= <sjur.brandeland@stericsson.com>
To: Ohad Ben-Cohen <ohad@wizery.com>
Cc: Linus Walleij <linus.walleij@linaro.org>, linux-kernel@vger.kernel.org,
        sjurbren@gmail.com,
        =?UTF-8?q?Sjur=20Br=C3=A6ndeland?= <sjur.brandeland@stericsson.com>
Subject: [RFC 4/5] remoteproc: Load firmware to device memory once.
Date: Thu,  6 Dec 2012 20:35:23 +0100
Message-Id: <1354822524-4497-5-git-send-email-sjur.brandeland@stericsson.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1354822524-4497-1-git-send-email-sjur.brandeland@stericsson.com>
References: <1354822524-4497-1-git-send-email-sjur.brandeland@stericsson.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Note: This patch changes device memory layout!!
      Virtio Rings are no longer located at start of device memory.
      But Ring Address in resource table is now supported.

Load firmware into device memory before virtio devices are added,
and use resource table located in device memory when crating
virtio devices. This enables dynamically-allocated address and
kick-ids of vrings to be communicated to the remote device.
This also pave the way for implementing bi-directional virtio
config-space and virtio feature negotiation.

Signed-off-by: Sjur Brændeland <sjur.brandeland@stericsson.com>
---
 drivers/remoteproc/remoteproc_core.c |  222 ++++++++++++++--------------------
 1 file changed, 91 insertions(+), 131 deletions(-)

diff --git a/drivers/remoteproc/remoteproc_core.c b/drivers/remoteproc/remoteproc_core.c
index dd3bfaf..e407197 100644
--- a/drivers/remoteproc/remoteproc_core.c
+++ b/drivers/remoteproc/remoteproc_core.c
@@ -681,16 +681,36 @@ static rproc_handle_resource_t rproc_handle_rsc[] = {
 	[RSC_CARVEOUT] = (rproc_handle_resource_t)rproc_handle_carveout,
 	[RSC_DEVMEM] = (rproc_handle_resource_t)rproc_handle_devmem,
 	[RSC_TRACE] = (rproc_handle_resource_t)rproc_handle_trace,
-	[RSC_VDEV] = NULL, /* VDEVs were handled upon registrarion */
+	[RSC_VDEV] = (rproc_handle_resource_t)rproc_handle_vdev,
 };
 
-/* handle firmware resource entries before booting the remote processor */
+static bool
+is_mem_resource(int rsc_type)
+{
+	/* Handle memory configurations only */
+	switch (rsc_type) {
+	case RSC_CARVEOUT:
+	case RSC_DEVMEM:
+		return true;
+	default:
+		return false;
+	}
+}
+
+static inline bool
+isnt_mem_resource(int rsc_type)
+{
+	return !is_mem_resource(rsc_type);
+}
+
+/* handle firmware resource entries */
 static int
-rproc_handle_boot_rsc(struct rproc *rproc, struct resource_table *table, int len)
+rproc_handle_resouce(struct rproc *rproc, struct resource_table *table, int len,
+					bool (*rsc_filter)(int type))
 {
 	struct device *dev = &rproc->dev;
-	rproc_handle_resource_t handler;
 	int ret = 0, i;
+	rproc_handle_resource_t handler;
 
 	for (i = 0; i < table->num; i++) {
 		int offset = table->offset[i];
@@ -698,58 +718,27 @@ rproc_handle_boot_rsc(struct rproc *rproc, struct resource_table *table, int len
 		int avail = len - offset - sizeof(*hdr);
 		void *rsc = (void *)hdr + sizeof(*hdr);
 
-		/* make sure table isn't truncated */
-		if (avail < 0) {
-			dev_err(dev, "rsc table is truncated\n");
-			return -EINVAL;
-		}
-
-		dev_dbg(dev, "rsc: type %d\n", hdr->type);
-
 		if (hdr->type >= RSC_LAST) {
 			dev_warn(dev, "unsupported resource %d\n", hdr->type);
 			continue;
 		}
 
-		handler = rproc_handle_rsc[hdr->type];
-		if (!handler)
-			continue;
-
-		ret = handler(rproc, rsc, avail);
-		if (ret)
-			break;
-	}
-
-	return ret;
-}
-
-/* handle firmware resource entries while registering the remote processor */
-static int
-rproc_handle_virtio_rsc(struct rproc *rproc, struct resource_table *table, int len)
-{
-	struct device *dev = &rproc->dev;
-	int ret = 0, i;
-
-	for (i = 0; i < table->num; i++) {
-		int offset = table->offset[i];
-		struct fw_rsc_hdr *hdr = (void *)table + offset;
-		int avail = len - offset - sizeof(*hdr);
-		struct fw_rsc_vdev *vrsc;
-
 		/* make sure table isn't truncated */
 		if (avail < 0) {
 			dev_err(dev, "rsc table is truncated\n");
 			return -EINVAL;
 		}
 
+		if (!rsc_filter(hdr->type))
+			continue;
+
 		dev_dbg(dev, "%s: rsc type %d\n", __func__, hdr->type);
 
-		if (hdr->type != RSC_VDEV)
+		handler = rproc_handle_rsc[hdr->type];
+		if (!handler)
 			continue;
 
-		vrsc = (struct fw_rsc_vdev *)hdr->data;
-
-		ret = rproc_handle_vdev(rproc, vrsc, avail);
+		ret = handler(rproc, rsc, avail);
 		if (ret)
 			break;
 	}
@@ -801,20 +790,40 @@ static void rproc_resource_cleanup(struct rproc *rproc)
 }
 
 /*
- * take a firmware and boot a remote processor with it.
+ * take a firmware parse the resouce table and load it
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
-	const char *name = rproc->firmware;
 	struct resource_table *table;
 	int ret, tablesz;
 
-	ret = rproc_fw_sanity_check(rproc, fw);
+	if (!fw)
+		goto nofw;
+
+	if (rproc_fw_sanity_check(rproc, fw) < 0)
+		goto cleanup;
+
+	/* look for the resource table */
+	table = rproc_find_rsc_table(rproc, fw,  &tablesz);
+	if (!table)
+		goto cleanup;
+
+	/* Handle carveout and devmem resouces so we have memory to load into */
+	ret = rproc_handle_resouce(rproc, table, tablesz, is_mem_resource);
 	if (ret)
-		return ret;
+		goto cleanup;
 
-	dev_info(dev, "Booting fw image %s, size %zd\n", name, fw->size);
+	/* load the firmware into memory before handling the virtio devices*/
+	ret = rproc_load_segments(rproc, fw);
+	if (ret)
+		goto cleanup;
 
 	/*
 	 * if enabling an IOMMU isn't relevant for this rproc, this is
@@ -823,80 +832,35 @@ static int rproc_fw_boot(struct rproc *rproc, const struct firmware *fw)
 	ret = rproc_enable_iommu(rproc);
 	if (ret) {
 		dev_err(dev, "can't enable iommu: %d\n", ret);
-		return ret;
+		goto cleanup;
 	}
 
-	rproc->bootaddr = rproc_get_boot_addr(rproc, fw);
+	/* Find the new location of the resource table in device memory */
+	table  = rproc_get_rsctab_addr(rproc, fw);
 
-	/* look for the resource table */
-	table = rproc_find_rsc_table(rproc, fw, &tablesz);
-	if (!table) {
-		ret = -EINVAL;
-		goto clean_up;
-	}
-
-	/* handle fw resources which are required to boot rproc */
-	ret = rproc_handle_boot_rsc(rproc, table, tablesz);
-	if (ret) {
-		dev_err(dev, "Failed to process resources: %d\n", ret);
-		goto clean_up;
-	}
-
-	/* load the ELF segments to memory */
-	ret = rproc_load_segments(rproc, fw);
-	if (ret) {
-		dev_err(dev, "Failed to load program segments: %d\n", ret);
-		goto clean_up;
-	}
-
-	/* power up the remote processor */
-	ret = rproc->ops->start(rproc);
-	if (ret) {
-		dev_err(dev, "can't start rproc %s: %d\n", rproc->name, ret);
-		goto clean_up;
-	}
+	/*
+	 * Handle virtio devices with resource entries in shared memory.
+	 * This enables proper configuration space handling for virtio.
+	 */
+	ret = rproc_handle_resouce(rproc, table, tablesz,
+				   isnt_mem_resource);
+	if (ret)
+		goto disable_iommu;
 
-	rproc->state = RPROC_RUNNING;
+	rproc->bootaddr = rproc_get_boot_addr(rproc, fw);
 
-	dev_info(dev, "remote processor %s is now up\n", rproc->name);
+	rproc->state = RPROC_LOADED;
 
-	return 0;
+	dev_info(dev, "remote processor %s is loaded to memory\n", rproc->name);
+	complete_all(&rproc->firmware_loading_complete);
 
-clean_up:
-	rproc_resource_cleanup(rproc);
+	return;
+disable_iommu:
 	rproc_disable_iommu(rproc);
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
-	ret = rproc_handle_virtio_rsc(rproc, table, tablesz);
-	if (ret)
-		goto out;
-
-out:
+cleanup:
+	rproc_resource_cleanup(rproc);
 	release_firmware(fw);
+nofw:
 	/* allow rproc_del() contexts, if any, to proceed */
 	complete_all(&rproc->firmware_loading_complete);
 }
@@ -905,6 +869,12 @@ static int rproc_add_virtio_devices(struct rproc *rproc)
 {
 	int ret;
 
+	/* loading a firmware is required */
+	if (!rproc->firmware) {
+		dev_err(&rproc->dev, "%s: no firmware to load\n", __func__);
+		return -EINVAL;
+	}
+
 	/* rproc_del() calls must wait until async loader completes */
 	init_completion(&rproc->firmware_loading_complete);
 
@@ -918,7 +888,7 @@ static int rproc_add_virtio_devices(struct rproc *rproc)
 	 */
 	ret = request_firmware_nowait(THIS_MODULE, FW_ACTION_HOTPLUG,
 				      rproc->firmware, &rproc->dev, GFP_KERNEL,
-				      rproc, rproc_fw_config_virtio);
+				      rproc, rproc_fw_load);
 	if (ret < 0) {
 		dev_err(&rproc->dev, "request_firmware_nowait err: %d\n", ret);
 		complete_all(&rproc->firmware_loading_complete);
@@ -999,13 +969,12 @@ static void rproc_crash_handler_work(struct work_struct *work)
  */
 int rproc_boot(struct rproc *rproc)
 {
-	const struct firmware *firmware_p;
 	struct device *dev;
 	int ret;
 
 	if (!rproc) {
 		pr_err("invalid rproc handle\n");
-		return -EINVAL;
+
 	}
 
 	dev = &rproc->dev;
@@ -1016,13 +985,6 @@ int rproc_boot(struct rproc *rproc)
 		return ret;
 	}
 
-	/* loading a firmware is required */
-	if (!rproc->firmware) {
-		dev_err(dev, "%s: no firmware to load\n", __func__);
-		ret = -EINVAL;
-		goto unlock_mutex;
-	}
-
 	/* prevent underlying implementation from being removed */
 	if (!try_module_get(dev->parent->driver->owner)) {
 		dev_err(dev, "%s: can't get owner\n", __func__);
@@ -1036,18 +998,15 @@ int rproc_boot(struct rproc *rproc)
 		goto unlock_mutex;
 	}
 
-	dev_info(dev, "powering up %s\n", rproc->name);
-
-	/* load firmware */
-	ret = request_firmware(&firmware_p, rproc->firmware, dev);
-	if (ret < 0) {
-		dev_err(dev, "request_firmware failed: %d\n", ret);
+	/* power up the remote processor */
+	ret = rproc->ops->start(rproc);
+	if (ret) {
+		dev_err(dev, "can't start rproc %s: %d\n", rproc->name, ret);
 		goto downref_rproc;
 	}
 
-	ret = rproc_fw_boot(rproc, firmware_p);
-
-	release_firmware(firmware_p);
+	rproc->state = RPROC_RUNNING;
+	dev_info(dev, "powering up %s\n", rproc->name);
 
 downref_rproc:
 	if (ret) {
@@ -1160,6 +1119,7 @@ int rproc_add(struct rproc *rproc)
 	rproc_create_debug_dir(rproc);
 
 	return rproc_add_virtio_devices(rproc);
+
 }
 EXPORT_SYMBOL(rproc_add);
 
-- 
1.7.9.5

