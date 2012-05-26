Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751478Ab2EZHgy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 May 2012 03:36:54 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:46518 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750925Ab2EZHgv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 May 2012 03:36:51 -0400
From: Ohad Ben-Cohen <ohad@wizery.com>
To: <linux-kernel@vger.kernel.org>
Cc: <linux-omap@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        Ohad Ben-Cohen <ohad@wizery.com>, Stephen Boyd <sboyd@codeaurora.org>,
        Fernando Guzman Lugo <fernando.lugo@ti.com>
Subject: [PATCH 1/2] remoteproc: maintain a generic child device for each rproc
Date: Sat, 26 May 2012 10:36:30 +0300
Message-Id: <1338017791-9442-1-git-send-email-ohad@wizery.com>
X-Mailer: git-send-email 1.7.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For each registered rproc, maintain a generic remoteproc device whose
parent is the low level platform-specific device (commonly a pdev, but
it may certainly be any other type of device too).

With this in hand, the resulting device hierarchy might then look like:

omap-rproc.0
 |
 - remoteproc.0
    |
    - virtio0
    |
    - virtio1
       |
       - rpmsg0
       |
       - rpmsg1
       |
       - rpmsg2

Where:
- omap-rproc.0 is the low level device that's bound to the
  driver which invokes rproc_register()
- remoteproc.0 is the result of this patch, and will be added by the
  remoteproc framework when rproc_register() is invoked
- virtio0 and virtio1 are vdevs that are registered by remoteproc
  when it realizes that they are supported by the firmware
  of the physical remote processor represented by omap-rproc.0
- rpmsg0, rpmsg1 and rpmsg2 are rpmsg devices that represent rpmsg
  channels, and are registerd by the rpmsg bus when it gets notified
  about their existence

Technically, this patch:
- changes 'struct rproc' to contain this generic remoteproc.x device
- creates a new "remoteproc" class, to which this new generic remoteproc.x
  device belong to.
- adds a super simple enumeration method for the indices of the
  remoteproc.x devices
- updates all dev_* messaging to use the generic remoteproc.x device
  instead of the low level platform-specific device
- updates all dma_* allocations to use the parent of remoteproc.x (where
  the platform-specific memory pools, most commonly CMA, are to be found)

Adding this generic device has several merits:
- we can now add remoteproc runtime PM support simply by hooking onto the
  new "remoteproc" class
- all remoteproc log messages will now carry a common name prefix
  instead of having a platform-specific one
- having a device as part of the rproc struct makes it possible to simplify
  refcounting (see subsequent patch)

Thanks to Stephen Boyd <sboyd@codeaurora.org> for suggesting and
discussing these ideas in one of the remoteproc review threads and
to Fernando Guzman Lugo <fernando.lugo@ti.com> for trying them out
with the (upcoming) runtime PM support for remoteproc.

Cc: Stephen Boyd <sboyd@codeaurora.org>
Cc: Fernando Guzman Lugo <fernando.lugo@ti.com>
Signed-off-by: Ohad Ben-Cohen <ohad@wizery.com>
---
 drivers/remoteproc/omap_remoteproc.c    |   17 +++--
 drivers/remoteproc/remoteproc_core.c    |  125 ++++++++++++++++++++-----------
 drivers/remoteproc/remoteproc_debugfs.c |    4 +-
 drivers/remoteproc/remoteproc_virtio.c  |   13 ++--
 drivers/rpmsg/virtio_rpmsg_bus.c        |    3 +-
 include/linux/remoteproc.h              |    4 +-
 6 files changed, 106 insertions(+), 60 deletions(-)

diff --git a/drivers/remoteproc/omap_remoteproc.c b/drivers/remoteproc/omap_remoteproc.c
index de138e30..f45230c 100644
--- a/drivers/remoteproc/omap_remoteproc.c
+++ b/drivers/remoteproc/omap_remoteproc.c
@@ -66,7 +66,7 @@ static int omap_rproc_mbox_callback(struct notifier_block *this,
 {
 	mbox_msg_t msg = (mbox_msg_t) data;
 	struct omap_rproc *oproc = container_of(this, struct omap_rproc, nb);
-	struct device *dev = oproc->rproc->dev;
+	struct device *dev = oproc->rproc->dev.parent;
 	const char *name = oproc->rproc->name;
 
 	dev_dbg(dev, "mbox msg: 0x%x\n", msg);
@@ -92,12 +92,13 @@ static int omap_rproc_mbox_callback(struct notifier_block *this,
 static void omap_rproc_kick(struct rproc *rproc, int vqid)
 {
 	struct omap_rproc *oproc = rproc->priv;
+	struct device *dev = rproc->dev.parent;
 	int ret;
 
 	/* send the index of the triggered virtqueue in the mailbox payload */
 	ret = omap_mbox_msg_send(oproc->mbox, vqid);
 	if (ret)
-		dev_err(rproc->dev, "omap_mbox_msg_send failed: %d\n", ret);
+		dev_err(dev, "omap_mbox_msg_send failed: %d\n", ret);
 }
 
 /*
@@ -110,7 +111,8 @@ static void omap_rproc_kick(struct rproc *rproc, int vqid)
 static int omap_rproc_start(struct rproc *rproc)
 {
 	struct omap_rproc *oproc = rproc->priv;
-	struct platform_device *pdev = to_platform_device(rproc->dev);
+	struct device *dev = rproc->dev.parent;
+	struct platform_device *pdev = to_platform_device(dev);
 	struct omap_rproc_pdata *pdata = pdev->dev.platform_data;
 	int ret;
 
@@ -120,7 +122,7 @@ static int omap_rproc_start(struct rproc *rproc)
 	oproc->mbox = omap_mbox_get(pdata->mbox_name, &oproc->nb);
 	if (IS_ERR(oproc->mbox)) {
 		ret = PTR_ERR(oproc->mbox);
-		dev_err(rproc->dev, "omap_mbox_get failed: %d\n", ret);
+		dev_err(dev, "omap_mbox_get failed: %d\n", ret);
 		return ret;
 	}
 
@@ -133,13 +135,13 @@ static int omap_rproc_start(struct rproc *rproc)
 	 */
 	ret = omap_mbox_msg_send(oproc->mbox, RP_MBOX_ECHO_REQUEST);
 	if (ret) {
-		dev_err(rproc->dev, "omap_mbox_get failed: %d\n", ret);
+		dev_err(dev, "omap_mbox_get failed: %d\n", ret);
 		goto put_mbox;
 	}
 
 	ret = pdata->device_enable(pdev);
 	if (ret) {
-		dev_err(rproc->dev, "omap_device_enable failed: %d\n", ret);
+		dev_err(dev, "omap_device_enable failed: %d\n", ret);
 		goto put_mbox;
 	}
 
@@ -153,7 +155,8 @@ put_mbox:
 /* power off the remote processor */
 static int omap_rproc_stop(struct rproc *rproc)
 {
-	struct platform_device *pdev = to_platform_device(rproc->dev);
+	struct device *dev = rproc->dev.parent;
+	struct platform_device *pdev = to_platform_device(dev);
 	struct omap_rproc_pdata *pdata = pdev->dev.platform_data;
 	struct omap_rproc *oproc = rproc->priv;
 	int ret;
diff --git a/drivers/remoteproc/remoteproc_core.c b/drivers/remoteproc/remoteproc_core.c
index 464ea4f..9e3d4cf 100644
--- a/drivers/remoteproc/remoteproc_core.c
+++ b/drivers/remoteproc/remoteproc_core.c
@@ -66,6 +66,9 @@ typedef int (*rproc_handle_resources_t)(struct rproc *rproc,
 				struct resource_table *table, int len);
 typedef int (*rproc_handle_resource_t)(struct rproc *rproc, void *, int avail);
 
+/* Unique numbering for remoteproc devices */
+static unsigned int dev_index;
+
 /*
  * This is the IOMMU fault handler we register with the IOMMU API
  * (when relevant; not all remote processors access memory through
@@ -92,7 +95,7 @@ static int rproc_iommu_fault(struct iommu_domain *domain, struct device *dev,
 static int rproc_enable_iommu(struct rproc *rproc)
 {
 	struct iommu_domain *domain;
-	struct device *dev = rproc->dev;
+	struct device *dev = rproc->dev.parent;
 	int ret;
 
 	/*
@@ -137,7 +140,7 @@ free_domain:
 static void rproc_disable_iommu(struct rproc *rproc)
 {
 	struct iommu_domain *domain = rproc->domain;
-	struct device *dev = rproc->dev;
+	struct device *dev = rproc->dev.parent;
 
 	if (!domain)
 		return;
@@ -217,7 +220,7 @@ static void *rproc_da_to_va(struct rproc *rproc, u64 da, int len)
 static int
 rproc_load_segments(struct rproc *rproc, const u8 *elf_data, size_t len)
 {
-	struct device *dev = rproc->dev;
+	struct device *dev = &rproc->dev;
 	struct elf32_hdr *ehdr;
 	struct elf32_phdr *phdr;
 	int i, ret = 0;
@@ -282,7 +285,7 @@ rproc_load_segments(struct rproc *rproc, const u8 *elf_data, size_t len)
 int rproc_alloc_vring(struct rproc_vdev *rvdev, int i)
 {
 	struct rproc *rproc = rvdev->rproc;
-	struct device *dev = rproc->dev;
+	struct device *dev = &rproc->dev;
 	struct rproc_vring *rvring = &rvdev->vring[i];
 	dma_addr_t dma;
 	void *va;
@@ -301,9 +304,9 @@ int rproc_alloc_vring(struct rproc_vdev *rvdev, int i)
 	 * this call will also configure the IOMMU for us
 	 * TODO: let the rproc know the da of this vring
 	 */
-	va = dma_alloc_coherent(dev, size, &dma, GFP_KERNEL);
+	va = dma_alloc_coherent(dev->parent, size, &dma, GFP_KERNEL);
 	if (!va) {
-		dev_err(dev, "dma_alloc_coherent failed\n");
+		dev_err(dev->parent, "dma_alloc_coherent failed\n");
 		return -EINVAL;
 	}
 
@@ -316,7 +319,7 @@ int rproc_alloc_vring(struct rproc_vdev *rvdev, int i)
 	ret = idr_get_new(&rproc->notifyids, rvring, &notifyid);
 	if (ret) {
 		dev_err(dev, "idr_get_new failed: %d\n", ret);
-		dma_free_coherent(dev, size, va, dma);
+		dma_free_coherent(dev->parent, size, va, dma);
 		return ret;
 	}
 
@@ -334,7 +337,7 @@ static int
 rproc_parse_vring(struct rproc_vdev *rvdev, struct fw_rsc_vdev *rsc, int i)
 {
 	struct rproc *rproc = rvdev->rproc;
-	struct device *dev = rproc->dev;
+	struct device *dev = &rproc->dev;
 	struct fw_rsc_vdev_vring *vring = &rsc->vring[i];
 	struct rproc_vring *rvring = &rvdev->vring[i];
 
@@ -366,7 +369,7 @@ void rproc_free_vring(struct rproc_vring *rvring)
 	int size = PAGE_ALIGN(vring_size(rvring->len, rvring->align));
 	struct rproc *rproc = rvring->rvdev->rproc;
 
-	dma_free_coherent(rproc->dev, size, rvring->va, rvring->dma);
+	dma_free_coherent(rproc->dev.parent, size, rvring->va, rvring->dma);
 	idr_remove(&rproc->notifyids, rvring->notifyid);
 }
 
@@ -400,14 +403,14 @@ void rproc_free_vring(struct rproc_vring *rvring)
 static int rproc_handle_vdev(struct rproc *rproc, struct fw_rsc_vdev *rsc,
 								int avail)
 {
-	struct device *dev = rproc->dev;
+	struct device *dev = &rproc->dev;
 	struct rproc_vdev *rvdev;
 	int i, ret;
 
 	/* make sure resource isn't truncated */
 	if (sizeof(*rsc) + rsc->num_of_vrings * sizeof(struct fw_rsc_vdev_vring)
 			+ rsc->config_len > avail) {
-		dev_err(rproc->dev, "vdev rsc is truncated\n");
+		dev_err(dev, "vdev rsc is truncated\n");
 		return -EINVAL;
 	}
 
@@ -476,12 +479,12 @@ static int rproc_handle_trace(struct rproc *rproc, struct fw_rsc_trace *rsc,
 								int avail)
 {
 	struct rproc_mem_entry *trace;
-	struct device *dev = rproc->dev;
+	struct device *dev = &rproc->dev;
 	void *ptr;
 	char name[15];
 
 	if (sizeof(*rsc) > avail) {
-		dev_err(rproc->dev, "trace rsc is truncated\n");
+		dev_err(dev, "trace rsc is truncated\n");
 		return -EINVAL;
 	}
 
@@ -558,6 +561,7 @@ static int rproc_handle_devmem(struct rproc *rproc, struct fw_rsc_devmem *rsc,
 								int avail)
 {
 	struct rproc_mem_entry *mapping;
+	struct device *dev = &rproc->dev;
 	int ret;
 
 	/* no point in handling this resource without a valid iommu domain */
@@ -565,25 +569,25 @@ static int rproc_handle_devmem(struct rproc *rproc, struct fw_rsc_devmem *rsc,
 		return -EINVAL;
 
 	if (sizeof(*rsc) > avail) {
-		dev_err(rproc->dev, "devmem rsc is truncated\n");
+		dev_err(dev, "devmem rsc is truncated\n");
 		return -EINVAL;
 	}
 
 	/* make sure reserved bytes are zeroes */
 	if (rsc->reserved) {
-		dev_err(rproc->dev, "devmem rsc has non zero reserved bytes\n");
+		dev_err(dev, "devmem rsc has non zero reserved bytes\n");
 		return -EINVAL;
 	}
 
 	mapping = kzalloc(sizeof(*mapping), GFP_KERNEL);
 	if (!mapping) {
-		dev_err(rproc->dev, "kzalloc mapping failed\n");
+		dev_err(dev, "kzalloc mapping failed\n");
 		return -ENOMEM;
 	}
 
 	ret = iommu_map(rproc->domain, rsc->da, rsc->pa, rsc->len, rsc->flags);
 	if (ret) {
-		dev_err(rproc->dev, "failed to map devmem: %d\n", ret);
+		dev_err(dev, "failed to map devmem: %d\n", ret);
 		goto out;
 	}
 
@@ -598,7 +602,7 @@ static int rproc_handle_devmem(struct rproc *rproc, struct fw_rsc_devmem *rsc,
 	mapping->len = rsc->len;
 	list_add_tail(&mapping->node, &rproc->mappings);
 
-	dev_dbg(rproc->dev, "mapped devmem pa 0x%x, da 0x%x, len 0x%x\n",
+	dev_dbg(dev, "mapped devmem pa 0x%x, da 0x%x, len 0x%x\n",
 					rsc->pa, rsc->da, rsc->len);
 
 	return 0;
@@ -630,13 +634,13 @@ static int rproc_handle_carveout(struct rproc *rproc,
 				struct fw_rsc_carveout *rsc, int avail)
 {
 	struct rproc_mem_entry *carveout, *mapping;
-	struct device *dev = rproc->dev;
+	struct device *dev = &rproc->dev;
 	dma_addr_t dma;
 	void *va;
 	int ret;
 
 	if (sizeof(*rsc) > avail) {
-		dev_err(rproc->dev, "carveout rsc is truncated\n");
+		dev_err(dev, "carveout rsc is truncated\n");
 		return -EINVAL;
 	}
 
@@ -662,9 +666,9 @@ static int rproc_handle_carveout(struct rproc *rproc,
 		goto free_mapping;
 	}
 
-	va = dma_alloc_coherent(dev, rsc->len, &dma, GFP_KERNEL);
+	va = dma_alloc_coherent(dev->parent, rsc->len, &dma, GFP_KERNEL);
 	if (!va) {
-		dev_err(dev, "failed to dma alloc carveout: %d\n", rsc->len);
+		dev_err(dev->parent, "dma_alloc_coherent err: %d\n", rsc->len);
 		ret = -ENOMEM;
 		goto free_carv;
 	}
@@ -735,7 +739,7 @@ static int rproc_handle_carveout(struct rproc *rproc,
 	return 0;
 
 dma_free:
-	dma_free_coherent(dev, rsc->len, va, dma);
+	dma_free_coherent(dev->parent, rsc->len, va, dma);
 free_carv:
 	kfree(carveout);
 free_mapping:
@@ -758,7 +762,7 @@ static rproc_handle_resource_t rproc_handle_rsc[] = {
 static int
 rproc_handle_boot_rsc(struct rproc *rproc, struct resource_table *table, int len)
 {
-	struct device *dev = rproc->dev;
+	struct device *dev = &rproc->dev;
 	rproc_handle_resource_t handler;
 	int ret = 0, i;
 
@@ -797,7 +801,7 @@ rproc_handle_boot_rsc(struct rproc *rproc, struct resource_table *table, int len
 static int
 rproc_handle_virtio_rsc(struct rproc *rproc, struct resource_table *table, int len)
 {
-	struct device *dev = rproc->dev;
+	struct device *dev = &rproc->dev;
 	int ret = 0, i;
 
 	for (i = 0; i < table->num; i++) {
@@ -850,7 +854,7 @@ rproc_find_rsc_table(struct rproc *rproc, const u8 *elf_data, size_t len,
 	struct elf32_hdr *ehdr;
 	struct elf32_shdr *shdr;
 	const char *name_table;
-	struct device *dev = rproc->dev;
+	struct device *dev = &rproc->dev;
 	struct resource_table *table = NULL;
 	int i;
 
@@ -916,7 +920,7 @@ rproc_find_rsc_table(struct rproc *rproc, const u8 *elf_data, size_t len,
 static void rproc_resource_cleanup(struct rproc *rproc)
 {
 	struct rproc_mem_entry *entry, *tmp;
-	struct device *dev = rproc->dev;
+	struct device *dev = &rproc->dev;
 
 	/* clean up debugfs trace entries */
 	list_for_each_entry_safe(entry, tmp, &rproc->traces, node) {
@@ -928,7 +932,7 @@ static void rproc_resource_cleanup(struct rproc *rproc)
 
 	/* clean up carveout allocations */
 	list_for_each_entry_safe(entry, tmp, &rproc->carveouts, node) {
-		dma_free_coherent(dev, entry->len, entry->va, entry->dma);
+		dma_free_coherent(dev->parent, entry->len, entry->va, entry->dma);
 		list_del(&entry->node);
 		kfree(entry);
 	}
@@ -953,7 +957,7 @@ static void rproc_resource_cleanup(struct rproc *rproc)
 static int rproc_fw_sanity_check(struct rproc *rproc, const struct firmware *fw)
 {
 	const char *name = rproc->firmware;
-	struct device *dev = rproc->dev;
+	struct device *dev = &rproc->dev;
 	struct elf32_hdr *ehdr;
 	char class;
 
@@ -1014,7 +1018,7 @@ static int rproc_fw_sanity_check(struct rproc *rproc, const struct firmware *fw)
  */
 static int rproc_fw_boot(struct rproc *rproc, const struct firmware *fw)
 {
-	struct device *dev = rproc->dev;
+	struct device *dev = &rproc->dev;
 	const char *name = rproc->firmware;
 	struct elf32_hdr *ehdr;
 	struct resource_table *table;
@@ -1139,7 +1143,7 @@ int rproc_boot(struct rproc *rproc)
 		return -EINVAL;
 	}
 
-	dev = rproc->dev;
+	dev = &rproc->dev;
 
 	/*
 	 * if asynchronoush fw loading is underway, wait up to 65 secs
@@ -1167,7 +1171,7 @@ int rproc_boot(struct rproc *rproc)
 	}
 
 	/* prevent underlying implementation from being removed */
-	if (!try_module_get(dev->driver->owner)) {
+	if (!try_module_get(dev->parent->driver->owner)) {
 		dev_err(dev, "%s: can't get owner\n", __func__);
 		ret = -EINVAL;
 		goto unlock_mutex;
@@ -1194,7 +1198,7 @@ int rproc_boot(struct rproc *rproc)
 
 downref_rproc:
 	if (ret) {
-		module_put(dev->driver->owner);
+		module_put(dev->parent->driver->owner);
 		atomic_dec(&rproc->power);
 	}
 unlock_mutex:
@@ -1228,7 +1232,7 @@ EXPORT_SYMBOL(rproc_boot);
  */
 void rproc_shutdown(struct rproc *rproc)
 {
-	struct device *dev = rproc->dev;
+	struct device *dev = &rproc->dev;
 	int ret;
 
 	ret = mutex_lock_interruptible(&rproc->lock);
@@ -1261,7 +1265,7 @@ void rproc_shutdown(struct rproc *rproc)
 out:
 	mutex_unlock(&rproc->lock);
 	if (!ret)
-		module_put(dev->driver->owner);
+		module_put(dev->parent->driver->owner);
 }
 EXPORT_SYMBOL(rproc_shutdown);
 
@@ -1284,7 +1288,7 @@ void rproc_release(struct kref *kref)
 {
 	struct rproc *rproc = container_of(kref, struct rproc, refcount);
 
-	dev_info(rproc->dev, "removing %s\n", rproc->name);
+	dev_info(&rproc->dev, "removing %s\n", rproc->name);
 
 	rproc_delete_debug_dir(rproc);
 
@@ -1416,13 +1420,17 @@ EXPORT_SYMBOL(rproc_put);
  */
 int rproc_register(struct rproc *rproc)
 {
-	struct device *dev = rproc->dev;
+	struct device *dev = &rproc->dev;
 	int ret = 0;
 
+	ret = device_add(dev);
+	if (ret < 0)
+		return ret;
+
 	/* expose to rproc_get_by_name users */
 	klist_add_tail(&rproc->node, &rprocs);
 
-	dev_info(rproc->dev, "%s is available\n", rproc->name);
+	dev_info(dev, "%s is available\n", rproc->name);
 
 	dev_info(dev, "Note: remoteproc is still under development and considered experimental.\n");
 	dev_info(dev, "THE BINARY FORMAT IS NOT YET FINALIZED, and backward compatibility isn't yet guaranteed.\n");
@@ -1454,6 +1462,22 @@ int rproc_register(struct rproc *rproc)
 }
 EXPORT_SYMBOL(rproc_register);
 
+static void rproc_class_release(struct device *dev)
+{
+	struct rproc *rproc = container_of(dev, struct rproc, dev);
+
+	idr_remove_all(&rproc->notifyids);
+	idr_destroy(&rproc->notifyids);
+
+	kfree(rproc);
+}
+
+static struct class rproc_class = {
+	.name		= "remoteproc",
+	.owner		= THIS_MODULE,
+	.dev_release	= rproc_class_release,
+};
+
 /**
  * rproc_alloc() - allocate a remote processor handle
  * @dev: the underlying device
@@ -1492,12 +1516,19 @@ struct rproc *rproc_alloc(struct device *dev, const char *name,
 		return NULL;
 	}
 
-	rproc->dev = dev;
 	rproc->name = name;
 	rproc->ops = ops;
 	rproc->firmware = firmware;
 	rproc->priv = &rproc[1];
 
+	device_initialize(&rproc->dev);
+	rproc->dev.parent = dev;
+	rproc->dev.class = &rproc_class;
+
+	/* Assign a unique device index and name */
+	rproc->index = dev_index++;
+	dev_set_name(&rproc->dev, "remoteproc%d", rproc->index);
+
 	atomic_set(&rproc->power, 0);
 
 	kref_init(&rproc->refcount);
@@ -1529,10 +1560,7 @@ EXPORT_SYMBOL(rproc_alloc);
  */
 void rproc_free(struct rproc *rproc)
 {
-	idr_remove_all(&rproc->notifyids);
-	idr_destroy(&rproc->notifyids);
-
-	kfree(rproc);
+	put_device(&rproc->dev);
 }
 EXPORT_SYMBOL(rproc_free);
 
@@ -1573,6 +1601,8 @@ int rproc_unregister(struct rproc *rproc)
 	/* the rproc is downref'ed as soon as it's removed from the klist */
 	klist_del(&rproc->node);
 
+	device_del(&rproc->dev);
+
 	/* the rproc will only be released after its refcount drops to zero */
 	kref_put(&rproc->refcount, rproc_release);
 
@@ -1582,7 +1612,14 @@ EXPORT_SYMBOL(rproc_unregister);
 
 static int __init remoteproc_init(void)
 {
+	int ret;
+
+	ret = class_register(&rproc_class);
+	if (ret)
+		return ret;
+
 	rproc_init_debugfs();
+
 	return 0;
 }
 module_init(remoteproc_init);
@@ -1590,6 +1627,8 @@ module_init(remoteproc_init);
 static void __exit remoteproc_exit(void)
 {
 	rproc_exit_debugfs();
+
+	class_unregister(&rproc_class);
 }
 module_exit(remoteproc_exit);
 
diff --git a/drivers/remoteproc/remoteproc_debugfs.c b/drivers/remoteproc/remoteproc_debugfs.c
index 85d31a6..0383385 100644
--- a/drivers/remoteproc/remoteproc_debugfs.c
+++ b/drivers/remoteproc/remoteproc_debugfs.c
@@ -124,7 +124,7 @@ struct dentry *rproc_create_trace_file(const char *name, struct rproc *rproc,
 	tfile = debugfs_create_file(name, 0400, rproc->dbg_dir,
 						trace, &trace_rproc_ops);
 	if (!tfile) {
-		dev_err(rproc->dev, "failed to create debugfs trace entry\n");
+		dev_err(&rproc->dev, "failed to create debugfs trace entry\n");
 		return NULL;
 	}
 
@@ -141,7 +141,7 @@ void rproc_delete_debug_dir(struct rproc *rproc)
 
 void rproc_create_debug_dir(struct rproc *rproc)
 {
-	struct device *dev = rproc->dev;
+	struct device *dev = &rproc->dev;
 
 	if (!rproc_dbg)
 		return;
diff --git a/drivers/remoteproc/remoteproc_virtio.c b/drivers/remoteproc/remoteproc_virtio.c
index 26a7144..b662183 100644
--- a/drivers/remoteproc/remoteproc_virtio.c
+++ b/drivers/remoteproc/remoteproc_virtio.c
@@ -36,7 +36,7 @@ static void rproc_virtio_notify(struct virtqueue *vq)
 	struct rproc *rproc = rvring->rvdev->rproc;
 	int notifyid = rvring->notifyid;
 
-	dev_dbg(rproc->dev, "kicking vq index: %d\n", notifyid);
+	dev_dbg(&rproc->dev, "kicking vq index: %d\n", notifyid);
 
 	rproc->ops->kick(rproc, notifyid);
 }
@@ -57,7 +57,7 @@ irqreturn_t rproc_vq_interrupt(struct rproc *rproc, int notifyid)
 {
 	struct rproc_vring *rvring;
 
-	dev_dbg(rproc->dev, "vq index %d is interrupted\n", notifyid);
+	dev_dbg(&rproc->dev, "vq index %d is interrupted\n", notifyid);
 
 	rvring = idr_find(&rproc->notifyids, notifyid);
 	if (!rvring || !rvring->vq)
@@ -74,6 +74,7 @@ static struct virtqueue *rp_find_vq(struct virtio_device *vdev,
 {
 	struct rproc_vdev *rvdev = vdev_to_rvdev(vdev);
 	struct rproc *rproc = vdev_to_rproc(vdev);
+	struct device *dev = &rproc->dev;
 	struct rproc_vring *rvring;
 	struct virtqueue *vq;
 	void *addr;
@@ -95,7 +96,7 @@ static struct virtqueue *rp_find_vq(struct virtio_device *vdev,
 	size = vring_size(len, rvring->align);
 	memset(addr, 0, size);
 
-	dev_dbg(rproc->dev, "vring%d: va %p qsz %d notifyid %d\n",
+	dev_dbg(dev, "vring%d: va %p qsz %d notifyid %d\n",
 					id, addr, len, rvring->notifyid);
 
 	/*
@@ -105,7 +106,7 @@ static struct virtqueue *rp_find_vq(struct virtio_device *vdev,
 	vq = vring_new_virtqueue(len, rvring->align, vdev, false, addr,
 					rproc_virtio_notify, callback, name);
 	if (!vq) {
-		dev_err(rproc->dev, "vring_new_virtqueue %s failed\n", name);
+		dev_err(dev, "vring_new_virtqueue %s failed\n", name);
 		rproc_free_vring(rvring);
 		return ERR_PTR(-ENOMEM);
 	}
@@ -152,7 +153,7 @@ static int rproc_virtio_find_vqs(struct virtio_device *vdev, unsigned nvqs,
 	/* now that the vqs are all set, boot the remote processor */
 	ret = rproc_boot(rproc);
 	if (ret) {
-		dev_err(rproc->dev, "rproc_boot() failed %d\n", ret);
+		dev_err(&rproc->dev, "rproc_boot() failed %d\n", ret);
 		goto error;
 	}
 
@@ -254,7 +255,7 @@ static void rproc_vdev_release(struct device *dev)
 int rproc_add_virtio_dev(struct rproc_vdev *rvdev, int id)
 {
 	struct rproc *rproc = rvdev->rproc;
-	struct device *dev = rproc->dev;
+	struct device *dev = &rproc->dev;
 	struct virtio_device *vdev = &rvdev->vdev;
 	int ret;
 
diff --git a/drivers/rpmsg/virtio_rpmsg_bus.c b/drivers/rpmsg/virtio_rpmsg_bus.c
index d5572e8..0af7fd3 100644
--- a/drivers/rpmsg/virtio_rpmsg_bus.c
+++ b/drivers/rpmsg/virtio_rpmsg_bus.c
@@ -964,7 +964,8 @@ static int rpmsg_probe(struct virtio_device *vdev)
 	vrp->svq = vqs[1];
 
 	/* allocate coherent memory for the buffers */
-	bufs_va = dma_alloc_coherent(vdev->dev.parent, RPMSG_TOTAL_BUF_SPACE,
+	bufs_va = dma_alloc_coherent(vdev->dev.parent->parent,
+				RPMSG_TOTAL_BUF_SPACE,
 				&vrp->bufs_dma, GFP_KERNEL);
 	if (!bufs_va)
 		goto vqs_del;
diff --git a/include/linux/remoteproc.h b/include/linux/remoteproc.h
index f1ffabb..0b835d3 100644
--- a/include/linux/remoteproc.h
+++ b/include/linux/remoteproc.h
@@ -383,6 +383,7 @@ enum rproc_state {
  * @bootaddr: address of first instruction to boot rproc with (optional)
  * @rvdevs: list of remote virtio devices
  * @notifyids: idr for dynamically assigning rproc-wide unique notify ids
+ * @index: index of this rproc device
  */
 struct rproc {
 	struct klist_node node;
@@ -391,7 +392,7 @@ struct rproc {
 	const char *firmware;
 	void *priv;
 	const struct rproc_ops *ops;
-	struct device *dev;
+	struct device dev;
 	struct kref refcount;
 	atomic_t power;
 	unsigned int state;
@@ -405,6 +406,7 @@ struct rproc {
 	u32 bootaddr;
 	struct list_head rvdevs;
 	struct idr notifyids;
+	int index;
 };
 
 /* we currently support only two vrings per rvdev */
-- 
1.7.5.4

