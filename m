Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964820Ab2CAIOD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2012 03:14:03 -0500
Received: from mail-wi0-f174.google.com ([209.85.212.174]:47271 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758001Ab2CAIMk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2012 03:12:40 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of ohad@wizery.com designates 10.180.87.100 as permitted sender) smtp.mail=ohad@wizery.com
MIME-Version: 1.0
From: Ohad Ben-Cohen <ohad@wizery.com>
To: <linux-omap@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>
Cc: Ohad Ben-Cohen <ohad@wizery.com>, Brian Swetland <swetland@google.com>,
        Iliyan Malchev <malchev@google.com>, Arnd Bergmann <arnd@arndb.de>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rusty Russell <rusty@rustcorp.com.au>, Mark Grosen <mgrosen@ti.com>,
        John Williams <john.williams@petalogix.com>,
        Michal Simek <monstr@monstr.eu>,
        Loic PALLARDY <loic.pallardy@stericsson.com>,
        Ludovic BARRE <ludovic.barre@stericsson.com>,
        Omar Ramirez Luna <omar.luna@linaro.org>,
        Guzman Lugo Fernando <fernando.lugo@ti.com>,
        Anna Suman <s-anna@ti.com>, Clark Rob <rob@ti.com>,
        Stephen Boyd <sboyd@codeaurora.org>,
        Saravana Kannan <skannan@codeaurora.org>,
        David Brown <davidb@codeaurora.org>,
        Kieran Bingham <kieranbingham@gmail.com>,
        Tony Lindgren <tony@atomide.com>
Subject: [PATCH 4/7] remoteproc: remove the single rpmsg vdev limitation
Date: Thu,  1 Mar 2012 10:11:34 +0200
Message-Id: <1330589497-4139-5-git-send-email-ohad@wizery.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1330589497-4139-1-git-send-email-ohad@wizery.com>
References: <1330589497-4139-1-git-send-email-ohad@wizery.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now that the resource table supports publishing a virtio device
in a single resource entry, firmware images can start supporting
more than a single vdev.

This patch removes the single vdev limitation of the remoteproc
framework so multi-vdev firmwares can be leveraged: VDEV resource
entries are parsed when the rproc is registered, and as a result
their vrings are set up and the virtio devices are registered
(and they go away when the rproc goes away).

Moreover, we no longer only support VIRTIO_ID_RPMSG vdevs; any
virtio device type goes now. As a result, there's no more any
rpmsg-specific APIs or code in remoteproc: it all becomes generic
virtio handling.

Signed-off-by: Ohad Ben-Cohen <ohad@wizery.com>
Cc: Brian Swetland <swetland@google.com>
Cc: Iliyan Malchev <malchev@google.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Grant Likely <grant.likely@secretlab.ca>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Mark Grosen <mgrosen@ti.com>
Cc: John Williams <john.williams@petalogix.com>
Cc: Michal Simek <monstr@monstr.eu>
Cc: Loic PALLARDY <loic.pallardy@stericsson.com>
Cc: Ludovic BARRE <ludovic.barre@stericsson.com>
Cc: Omar Ramirez Luna <omar.luna@linaro.org>
Cc: Guzman Lugo Fernando <fernando.lugo@ti.com>
Cc: Anna Suman <s-anna@ti.com>
Cc: Clark Rob <rob@ti.com>
Cc: Stephen Boyd <sboyd@codeaurora.org>
Cc: Saravana Kannan <skannan@codeaurora.org>
Cc: David Brown <davidb@codeaurora.org>
Cc: Kieran Bingham <kieranbingham@gmail.com>
Cc: Tony Lindgren <tony@atomide.com>
---
 Documentation/remoteproc.txt             |    9 +-
 drivers/remoteproc/remoteproc_core.c     |  292 +++++++++++++++---------------
 drivers/remoteproc/remoteproc_internal.h |    6 +-
 drivers/remoteproc/remoteproc_virtio.c   |  140 +++++++--------
 include/linux/remoteproc.h               |   41 ++++-
 5 files changed, 260 insertions(+), 228 deletions(-)

diff --git a/Documentation/remoteproc.txt b/Documentation/remoteproc.txt
index 07057ca..70a048c 100644
--- a/Documentation/remoteproc.txt
+++ b/Documentation/remoteproc.txt
@@ -20,6 +20,11 @@ platform-specific remoteproc drivers only need to provide a few low-level
 handlers, and then all rpmsg drivers will then just work
 (for more information about the virtio-based rpmsg bus and its drivers,
 please read Documentation/rpmsg.txt).
+Registration of other types of virtio devices is now also possible. Firmwares
+just need to publish what kind of virtio devices do they support, and then
+remoteproc will add those devices. This makes it possible to reuse the
+existing virtio drivers with remote processor backends at a minimal development
+cost.
 
 2. User API
 
@@ -136,8 +141,6 @@ int dummy_rproc_example(struct rproc *my_rproc)
       If found, those virtio devices will be created and added, so as a result
       of registering this remote processor, additional virtio drivers might get
       probed.
-      Currently, though, we only support a single RPMSG virtio vdev per remote
-      processor.
 
   int rproc_unregister(struct rproc *rproc)
     - Unregister a remote processor, and decrement its refcount.
@@ -174,7 +177,7 @@ struct rproc_ops {
 };
 
 Every remoteproc implementation should at least provide the ->start and ->stop
-handlers. If rpmsg functionality is also desired, then the ->kick handler
+handlers. If rpmsg/virtio functionality is also desired, then the ->kick handler
 should be provided as well.
 
 The ->start() handler takes an rproc handle and should then power on the
diff --git a/drivers/remoteproc/remoteproc_core.c b/drivers/remoteproc/remoteproc_core.c
index 1034845..ca02f12 100644
--- a/drivers/remoteproc/remoteproc_core.c
+++ b/drivers/remoteproc/remoteproc_core.c
@@ -52,8 +52,8 @@ static void klist_rproc_put(struct klist_node *n);
  * We need this in order to support name-based lookups (needed by the
  * rproc_get_by_name()).
  *
- * That said, we don't use rproc_get_by_name() anymore within the rpmsg
- * framework. The use cases that do require its existence should be
+ * That said, we don't use rproc_get_by_name() at this point.
+ * The use cases that do require its existence should be
  * scrutinized, and hopefully migrated to rproc_boot() using device-based
  * binding.
  *
@@ -279,80 +279,112 @@ rproc_load_segments(struct rproc *rproc, const u8 *elf_data, size_t len)
 	return ret;
 }
 
-/**
- * rproc_handle_early_vdev() - early handle a virtio header resource
- * @rproc: the remote processor
- * @rsc: the resource descriptor
- * @avail: size of available data (for sanity checking the image)
- *
- * The existence of this virtio hdr resource entry means that the firmware
- * of this @rproc supports this virtio device.
- *
- * Currently we support only a single virtio device of type VIRTIO_ID_RPMSG,
- * but the plan is to remove this limitation and support any number
- * of virtio devices (and of any type). We'll also add support for dynamically
- * adding (and removing) virtio devices over the rpmsg bus, but simple
- * firmwares that doesn't want to get involved with rpmsg will be able
- * to simply use the resource table for this.
- *
- * Returns 0 on success, or an appropriate error code otherwise
- */
-static int rproc_handle_early_vdev(struct rproc *rproc, struct fw_rsc_vdev *rsc,
-								int avail)
+static int
+__rproc_handle_vring(struct rproc_vdev *rvdev, struct fw_rsc_vdev *rsc, int i)
 {
-	struct rproc_vdev *rvdev;
+	struct rproc *rproc = rvdev->rproc;
+	struct device *dev = rproc->dev;
+	struct fw_rsc_vdev_vring *vring = &rsc->vring[i];
+	dma_addr_t dma;
+	void *va;
+	int ret, size, notifyid;
 
-	/* make sure resource isn't truncated */
-	if (sizeof(*rsc) > avail) {
-		dev_err(rproc->dev, "vdev rsc is truncated\n");
+	dev_dbg(dev, "vdev rsc: vring%d: da %x, qsz %d, align %d\n",
+				i, vring->da, vring->num, vring->align);
+
+	/* make sure reserved bytes are zeroes */
+	if (vring->reserved) {
+		dev_err(dev, "vring rsc has non zero reserved bytes\n");
 		return -EINVAL;
 	}
 
-	/* we only support VIRTIO_ID_RPMSG devices for now */
-	if (rsc->id != VIRTIO_ID_RPMSG) {
-		dev_warn(rproc->dev, "unsupported vdev: %d\n", rsc->id);
+	/* the firmware must provide the expected queue size */
+	if (!vring->num) {
+		dev_err(dev, "invalid qsz (%d)\n", vring->num);
 		return -EINVAL;
 	}
 
-	/* we only support a single vdev per rproc for now */
-	if (rproc->rvdev) {
-		dev_warn(rproc->dev, "redundant vdev entry\n");
+	/* actual size of vring (in bytes) */
+	size = PAGE_ALIGN(vring_size(vring->num, AMP_VRING_ALIGN));
+
+	if (!idr_pre_get(&rproc->notifyids, GFP_KERNEL)) {
+		dev_err(dev, "idr_pre_get failed\n");
+		return -ENOMEM;
+	}
+
+	/*
+	 * Allocate non-cacheable memory for the vring. In the future
+	 * this call will also configure the IOMMU for us
+	 */
+	va = dma_alloc_coherent(dev, size, &dma, GFP_KERNEL);
+	if (!va) {
+		dev_err(dev, "dma_alloc_coherent failed\n");
 		return -EINVAL;
 	}
 
-	rvdev = kzalloc(sizeof(struct rproc_vdev), GFP_KERNEL);
-	if (!rvdev)
-		return -ENOMEM;
+	/* assign an rproc-wide unique index for this vring */
+	/* TODO: assign a notifyid for rvdev updates as well */
+	ret = idr_get_new(&rproc->notifyids, &rvdev->vring[i], &notifyid);
+	if (ret) {
+		dev_err(dev, "idr_get_new failed: %d\n", ret);
+		dma_free_coherent(dev, size, va, dma);
+		return ret;
+	}
 
-	/* remember the device features */
-	rvdev->dfeatures = rsc->dfeatures;
+	/* let the rproc know the da and notifyid of this vring */
+	/* TODO: expose this to remote processor */
+	vring->da = dma;
+	vring->notifyid = notifyid;
 
-	rproc->rvdev = rvdev;
-	rvdev->rproc = rproc;
+	dev_dbg(dev, "vring%d: va %p dma %x size %x idr %d\n", i, va,
+					dma, size, notifyid);
+
+	rvdev->vring[i].len = vring->num;
+	rvdev->vring[i].va = va;
+	rvdev->vring[i].dma = dma;
+	rvdev->vring[i].notifyid = notifyid;
+	rvdev->vring[i].rvdev = rvdev;
 
 	return 0;
 }
 
+static void __rproc_free_vrings(struct rproc_vdev *rvdev, int i)
+{
+	struct rproc *rproc = rvdev->rproc;
+
+	for (i--; i > 0; i--) {
+		struct rproc_vring *rvring = &rvdev->vring[i];
+		int size = PAGE_ALIGN(vring_size(rvring->len, AMP_VRING_ALIGN));
+
+		dma_free_coherent(rproc->dev, size, rvring->va, rvring->dma);
+		idr_remove(&rproc->notifyids, rvring->notifyid);
+	}
+}
+
 /**
  * rproc_handle_vdev() - handle a vdev fw resource
  * @rproc: the remote processor
  * @rsc: the vring resource descriptor
  * @avail: size of available data (for sanity checking the image)
  *
- * This resource entry requires allocation of non-cacheable memory
- * for a virtio vring. Currently we only support two vrings per remote
- * processor, required for the virtio rpmsg device.
- *
- * The 'len' member of @rsc should contain the number of buffers this vring
- * support and 'da' should either contain the device address where
- * the remote processor is expecting the vring, or indicate that
- * dynamically allocation of the vring's device address is supported.
- *
- * Note: 'da' is currently not handled. This will be revised when the generic
- * iommu-based DMA API will arrive, or a dynanic & non-iommu use case show
- * up. Meanwhile, statically-addressed iommu-based images should use
- * RSC_DEVMEM resource entries to map their require 'da' to the physical
- * address of their base CMA region.
+ * This resource entry requests the host to statically register a virtio
+ * device (vdev), and setup everything needed to support it. It contains
+ * everything needed to make it possible: the virtio device id, virtio
+ * device features, vrings information, virtio config space, etc...
+ *
+ * Before registering the vdev, the vrings are allocated from non-cacheable
+ * physically contiguous memory. Currently we only support two vrings per
+ * remote processor (temporary limitation). We might also want to consider
+ * doing the vring allocation only later when ->find_vqs() is invoked, and
+ * then release them upon ->del_vqs().
+ *
+ * Note: @da is currently not really handled correctly: we dynamically
+ * allocate it using the DMA API, ignoring requested hard coded addresses,
+ * and we don't take care of any required IOMMU programming. This is all
+ * going to be taken care of when the generic iommu-based DMA API will be
+ * merged. Meanwhile, statically-addressed iommu-based firmware images should
+ * use RSC_DEVMEM resource entries to map their required @da to the physical
+ * address of their base CMA region (ouch, hacky!).
  *
  * Returns 0 on success, or an appropriate error code otherwise
  */
@@ -360,8 +392,8 @@ static int rproc_handle_vdev(struct rproc *rproc, struct fw_rsc_vdev *rsc,
 								int avail)
 {
 	struct device *dev = rproc->dev;
-	struct rproc_vdev *rvdev = rproc->rvdev;
-	int i;
+	struct rproc_vdev *rvdev;
+	int i, ret;
 
 	/* make sure resource isn't truncated */
 	if (sizeof(*rsc) + rsc->num_of_vrings * sizeof(struct fw_rsc_vdev_vring)
@@ -379,61 +411,41 @@ static int rproc_handle_vdev(struct rproc *rproc, struct fw_rsc_vdev *rsc,
 	dev_dbg(dev, "vdev rsc: id %d, dfeatures %x, cfg len %d, %d vrings\n",
 		rsc->id, rsc->dfeatures, rsc->config_len, rsc->num_of_vrings);
 
-	/* no vdev is in place ? */
-	if (!rvdev) {
-		dev_err(dev, "vring requested without a virtio dev entry\n");
-		return -EINVAL;
-	}
-
-	/* we currently support two vrings per rproc (for rx and tx) */
-	if (rsc->num_of_vrings != ARRAY_SIZE(rvdev->vring)) {
+	/* we currently support only two vrings per rvdev */
+	if (rsc->num_of_vrings > ARRAY_SIZE(rvdev->vring)) {
 		dev_err(dev, "too many vrings: %d\n", rsc->num_of_vrings);
 		return -EINVAL;
 	}
 
-	/* initialize the vrings */
-	for (i = 0; i < rsc->num_of_vrings; i++) {
-		struct fw_rsc_vdev_vring *vring = &rsc->vring[i];
-		dma_addr_t dma;
-		int size;
-		void *va;
-
-		/* make sure reserved bytes are zeroes */
-		if (vring->reserved) {
-			dev_err(dev, "vring rsc has non zero reserved bytes\n");
-			return -EINVAL;
-		}
+	rvdev = kzalloc(sizeof(struct rproc_vdev), GFP_KERNEL);
+	if (!rvdev)
+		return -ENOMEM;
 
-		/* the firmware must provide the expected queue size */
-		if (!vring->num) {
-			dev_err(dev, "missing expected queue size\n");
-			/* potential cleanups are taken care of later on */
-			return -EINVAL;
-		}
+	rvdev->rproc = rproc;
 
-		/* actual size of vring (in bytes) */
-		size = PAGE_ALIGN(vring_size(vring->num, AMP_VRING_ALIGN));
+	/* allocate the vrings */
+	for (i = 0; i < rsc->num_of_vrings; i++) {
+		ret = __rproc_handle_vring(rvdev, rsc, i);
+		if (ret)
+			goto free_vrings;
+	}
 
-		/*
-		 * Allocate non-cacheable memory for the vring. In the future
-		 * this call will also configure the IOMMU for us
-		 */
-		va = dma_alloc_coherent(dev, size, &dma, GFP_KERNEL);
-		if (!va) {
-			dev_err(dev, "dma_alloc_coherent failed\n");
-			/* potential cleanups are taken care of later on */
-			return -EINVAL;
-		}
+	/* remember the device features */
+	rvdev->dfeatures = rsc->dfeatures;
 
-		dev_dbg(dev, "vring%d: va %p dma %x qsz %d ring size %x\n", i,
-						va, dma, vring->num, size);
+	list_add_tail(&rvdev->node, &rproc->rvdevs);
 
-		rvdev->vring[i].len = vring->num;
-		rvdev->vring[i].va = va;
-		rvdev->vring[i].dma = dma;
-	}
+	/* it is now safe to add the virtio device */
+	ret = rproc_add_virtio_dev(rvdev, rsc->id);
+	if (ret)
+		goto free_vrings;
 
 	return 0;
+
+free_vrings:
+	__rproc_free_vrings(rvdev, i);
+	kfree(rvdev);
+	return ret;
 }
 
 /**
@@ -731,7 +743,7 @@ static rproc_handle_resource_t rproc_handle_rsc[] = {
 	[RSC_CARVEOUT] = (rproc_handle_resource_t)rproc_handle_carveout,
 	[RSC_DEVMEM] = (rproc_handle_resource_t)rproc_handle_devmem,
 	[RSC_TRACE] = (rproc_handle_resource_t)rproc_handle_trace,
-	[RSC_VDEV] = (rproc_handle_resource_t)rproc_handle_vdev,
+	[RSC_VDEV] = NULL, /* VDEVs were handled upon registrarion */
 };
 
 /* handle firmware resource entries before booting the remote processor */
@@ -784,6 +796,7 @@ rproc_handle_virtio_rsc(struct rproc *rproc, struct resource_table *table, int l
 		int offset = table->offset[i];
 		struct fw_rsc_hdr *hdr = (void *)table + offset;
 		int avail = len - offset - sizeof(*hdr);
+		struct fw_rsc_vdev *vrsc;
 
 		/* make sure table isn't truncated */
 		if (avail < 0) {
@@ -793,12 +806,14 @@ rproc_handle_virtio_rsc(struct rproc *rproc, struct resource_table *table, int l
 
 		dev_dbg(dev, "%s: rsc type %d\n", __func__, hdr->type);
 
-		if (hdr->type == RSC_VDEV) {
-			struct fw_rsc_vdev *vrsc =
-					(struct fw_rsc_vdev *)hdr->data;
-			ret = rproc_handle_early_vdev(rproc, vrsc, avail);
+		if (hdr->type != RSC_VDEV)
+			continue;
+
+		vrsc = (struct fw_rsc_vdev *)hdr->data;
+
+		ret = rproc_handle_vdev(rproc, vrsc, avail);
+		if (ret)
 			break;
-		}
 	}
 
 	return ret;
@@ -889,14 +904,12 @@ static int rproc_handle_resources(struct rproc *rproc, const u8 *elf_data,
  * @rproc: rproc handle
  *
  * This function will free all resources acquired for @rproc, and it
- * is called when @rproc shuts down, or just failed booting.
+ * is called whenever @rproc either shuts down or fails to boot.
  */
 static void rproc_resource_cleanup(struct rproc *rproc)
 {
 	struct rproc_mem_entry *entry, *tmp;
 	struct device *dev = rproc->dev;
-	struct rproc_vdev *rvdev = rproc->rvdev;
-	int i;
 
 	/* clean up debugfs trace entries */
 	list_for_each_entry_safe(entry, tmp, &rproc->traces, node) {
@@ -906,23 +919,6 @@ static void rproc_resource_cleanup(struct rproc *rproc)
 		kfree(entry);
 	}
 
-	/* free the coherent memory allocated for the vrings */
-	for (i = 0; rvdev && i < ARRAY_SIZE(rvdev->vring); i++) {
-		int qsz = rvdev->vring[i].len;
-		void *va = rvdev->vring[i].va;
-		int dma = rvdev->vring[i].dma;
-
-		/* virtqueue size is expressed in number of buffers supported */
-		if (qsz) {
-			/* how many bytes does this vring really occupy ? */
-			int size = PAGE_ALIGN(vring_size(qsz, AMP_VRING_ALIGN));
-
-			dma_free_coherent(rproc->dev, size, va, dma);
-
-			rvdev->vring[i].len = 0;
-		}
-	}
-
 	/* clean up carveout allocations */
 	list_for_each_entry_safe(entry, tmp, &rproc->carveouts, node) {
 		dma_free_coherent(dev, entry->len, entry->va, entry->dma);
@@ -1100,11 +1096,6 @@ static void rproc_fw_config_virtio(const struct firmware *fw, void *context)
 		goto out;
 	}
 
-	/* add the virtio device (currently only rpmsg vdevs are supported) */
-	ret = rproc_add_rpmsg_vdev(rproc);
-	if (ret)
-		goto out;
-
 out:
 	if (fw)
 		release_firmware(fw);
@@ -1266,13 +1257,23 @@ EXPORT_SYMBOL(rproc_shutdown);
 void rproc_release(struct kref *kref)
 {
 	struct rproc *rproc = container_of(kref, struct rproc, refcount);
+	struct rproc_vdev *rvdev, *rvtmp;
 
 	dev_info(rproc->dev, "removing %s\n", rproc->name);
 
 	rproc_delete_debug_dir(rproc);
 
-	/* at this point no one holds a reference to rproc anymore */
-	kfree(rproc);
+	/* clean up remote vdev entries */
+	list_for_each_entry_safe(rvdev, rvtmp, &rproc->rvdevs, node) {
+		__rproc_free_vrings(rvdev, RVDEV_NUM_VRINGS);
+		list_del(&rvdev->node);
+	}
+
+	/*
+	 * At this point no one holds a reference to rproc anymore,
+	 * so we can directly unroll rproc_alloc()
+	 */
+	rproc_free(rproc);
 }
 
 /* will be called when an rproc is added to the rprocs klist */
@@ -1316,7 +1317,7 @@ static struct rproc *next_rproc(struct klist_iter *i)
  * use rproc_put() to decrement it back once rproc isn't needed anymore.
  *
  * Note: currently this function (and its counterpart rproc_put()) are not
- * used anymore by the rpmsg subsystem. We need to scrutinize the use cases
+ * being used. We need to scrutinize the use cases
  * that still need them, and see if we can migrate them to use the non
  * name-based boot/shutdown interface.
  */
@@ -1391,11 +1392,8 @@ EXPORT_SYMBOL(rproc_put);
  * firmware.
  *
  * If found, those virtio devices will be created and added, so as a result
- * of registering this remote processor, additional virtio drivers will be
+ * of registering this remote processor, additional virtio drivers might be
  * probed.
- *
- * Currently, though, we only support a single RPMSG virtio vdev per remote
- * processor.
  */
 int rproc_register(struct rproc *rproc)
 {
@@ -1418,7 +1416,7 @@ int rproc_register(struct rproc *rproc)
 
 	/*
 	 * We must retrieve early virtio configuration info from
-	 * the firmware (e.g. whether to register a virtio rpmsg device,
+	 * the firmware (e.g. whether to register a virtio device,
 	 * what virtio features does it support, ...).
 	 *
 	 * We're initiating an asynchronous firmware loading, so we can
@@ -1487,9 +1485,12 @@ struct rproc *rproc_alloc(struct device *dev, const char *name,
 
 	mutex_init(&rproc->lock);
 
+	idr_init(&rproc->notifyids);
+
 	INIT_LIST_HEAD(&rproc->carveouts);
 	INIT_LIST_HEAD(&rproc->mappings);
 	INIT_LIST_HEAD(&rproc->traces);
+	INIT_LIST_HEAD(&rproc->rvdevs);
 
 	rproc->state = RPROC_OFFLINE;
 
@@ -1509,6 +1510,9 @@ EXPORT_SYMBOL(rproc_alloc);
  */
 void rproc_free(struct rproc *rproc)
 {
+	idr_remove_all(&rproc->notifyids);
+	idr_destroy(&rproc->notifyids);
+
 	kfree(rproc);
 }
 EXPORT_SYMBOL(rproc_free);
@@ -1535,18 +1539,22 @@ EXPORT_SYMBOL(rproc_free);
  */
 int rproc_unregister(struct rproc *rproc)
 {
+	struct rproc_vdev *rvdev;
+
 	if (!rproc)
 		return -EINVAL;
 
 	/* if rproc is just being registered, wait */
 	wait_for_completion(&rproc->firmware_loading_complete);
 
-	/* was an rpmsg vdev created ? */
-	if (rproc->rvdev)
-		rproc_remove_rpmsg_vdev(rproc);
+	/* clean up remote vdev entries */
+	list_for_each_entry(rvdev, &rproc->rvdevs, node)
+		rproc_remove_virtio_dev(rvdev);
 
-	klist_remove(&rproc->node);
+	/* the rproc is downref'ed as soon as it's removed from the klist */
+	klist_del(&rproc->node);
 
+	/* the rproc will only be released after its refcount drops to zero */
 	kref_put(&rproc->refcount, rproc_release);
 
 	return 0;
diff --git a/drivers/remoteproc/remoteproc_internal.h b/drivers/remoteproc/remoteproc_internal.h
index 8b2fc40..9f336d6 100644
--- a/drivers/remoteproc/remoteproc_internal.h
+++ b/drivers/remoteproc/remoteproc_internal.h
@@ -28,9 +28,9 @@ struct rproc;
 void rproc_release(struct kref *kref);
 irqreturn_t rproc_vq_interrupt(struct rproc *rproc, int vq_id);
 
-/* from remoteproc_rpmsg.c */
-int rproc_add_rpmsg_vdev(struct rproc *);
-void rproc_remove_rpmsg_vdev(struct rproc *rproc);
+/* from remoteproc_virtio.c */
+int rproc_add_virtio_dev(struct rproc_vdev *rvdev, int id);
+void rproc_remove_virtio_dev(struct rproc_vdev *rvdev);
 
 /* from remoteproc_debugfs.c */
 void rproc_remove_trace_file(struct dentry *tfile);
diff --git a/drivers/remoteproc/remoteproc_virtio.c b/drivers/remoteproc/remoteproc_virtio.c
index 78d8527..0700410 100644
--- a/drivers/remoteproc/remoteproc_virtio.c
+++ b/drivers/remoteproc/remoteproc_virtio.c
@@ -19,7 +19,6 @@
 
 #include <linux/export.h>
 #include <linux/remoteproc.h>
-#include <linux/rpmsg.h>
 #include <linux/virtio.h>
 #include <linux/virtio_config.h>
 #include <linux/virtio_ids.h>
@@ -30,45 +29,41 @@
 
 #include "remoteproc_internal.h"
 
-/**
- * struct rproc_virtio_vq_info - virtqueue state
- * @vq_id: a unique index of this virtqueue (unique for this @rproc)
- * @rproc: handle to the remote processor
- *
- * Such a struct will be maintained for every virtqueue we're
- * using to communicate with the remote processor
- */
-struct rproc_virtio_vq_info {
-	__u16 vq_id;
-	struct rproc *rproc;
-};
-
 /* kick the remote processor, and let it know which virtqueue to poke at */
 static void rproc_virtio_notify(struct virtqueue *vq)
 {
-	struct rproc_virtio_vq_info *rpvq = vq->priv;
-	struct rproc *rproc = rpvq->rproc;
+	struct rproc_vring *rvring = vq->priv;
+	struct rproc *rproc = rvring->rvdev->rproc;
+	int notifyid = rvring->notifyid;
 
-	dev_dbg(rproc->dev, "kicking vq id: %d\n", rpvq->vq_id);
+	dev_dbg(rproc->dev, "kicking vq index: %d\n", notifyid);
 
-	rproc->ops->kick(rproc, rpvq->vq_id);
+	rproc->ops->kick(rproc, notifyid);
 }
 
 /**
  * rproc_vq_interrupt() - tell remoteproc that a virtqueue is interrupted
  * @rproc: handle to the remote processor
- * @vq_id: index of the signalled virtqueue
+ * @notifyid: index of the signalled virtqueue (unique per this @rproc)
  *
  * This function should be called by the platform-specific rproc driver,
  * when the remote processor signals that a specific virtqueue has pending
  * messages available.
  *
- * Returns IRQ_NONE if no message was found in the @vq_id virtqueue,
+ * Returns IRQ_NONE if no message was found in the @notifyid virtqueue,
  * and otherwise returns IRQ_HANDLED.
  */
-irqreturn_t rproc_vq_interrupt(struct rproc *rproc, int vq_id)
+irqreturn_t rproc_vq_interrupt(struct rproc *rproc, int notifyid)
 {
-	return vring_interrupt(0, rproc->rvdev->vq[vq_id]);
+	struct rproc_vring *rvring;
+
+	dev_dbg(rproc->dev, "vq index %d is interrupted\n", notifyid);
+
+	rvring = idr_find(&rproc->notifyids, notifyid);
+	if (!rvring || !rvring->vq)
+		return IRQ_NONE;
+
+	return vring_interrupt(0, rvring->vq);
 }
 EXPORT_SYMBOL(rproc_vq_interrupt);
 
@@ -77,24 +72,28 @@ static struct virtqueue *rp_find_vq(struct virtio_device *vdev,
 				    void (*callback)(struct virtqueue *vq),
 				    const char *name)
 {
+	struct rproc_vdev *rvdev = vdev_to_rvdev(vdev);
 	struct rproc *rproc = vdev_to_rproc(vdev);
-	struct rproc_vdev *rvdev = rproc->rvdev;
-	struct rproc_virtio_vq_info *rpvq;
+	struct rproc_vring *rvring;
 	struct virtqueue *vq;
 	void *addr;
-	int ret, len;
+	int len, size;
 
-	rpvq = kmalloc(sizeof(*rpvq), GFP_KERNEL);
-	if (!rpvq)
-		return ERR_PTR(-ENOMEM);
+	/* we're temporarily limited to two virtqueues per rvdev */
+	if (id >= ARRAY_SIZE(rvdev->vring))
+		return ERR_PTR(-EINVAL);
+
+	rvring = &rvdev->vring[id];
 
-	rpvq->rproc = rproc;
-	rpvq->vq_id = id;
+	addr = rvring->va;
+	len = rvring->len;
 
-	addr = rvdev->vring[id].va;
-	len = rvdev->vring[id].len;
+	/* zero vring */
+	size = vring_size(len, rvring->align);
+	memset(addr, 0, size);
 
-	dev_dbg(rproc->dev, "vring%d: va %p qsz %d\n", id, addr, len);
+	dev_dbg(rproc->dev, "vring%d: va %p qsz %d notifyid %d\n",
+					id, addr, len, rvring->notifyid);
 
 	/*
 	 * Create the new vq, and tell virtio we're not interested in
@@ -104,32 +103,28 @@ static struct virtqueue *rp_find_vq(struct virtio_device *vdev,
 					rproc_virtio_notify, callback, name);
 	if (!vq) {
 		dev_err(rproc->dev, "vring_new_virtqueue %s failed\n", name);
-		ret = -ENOMEM;
-		goto free_rpvq;
+		return ERR_PTR(-ENOMEM);
 	}
 
-	rvdev->vq[id] = vq;
-	vq->priv = rpvq;
+	rvring->vq = vq;
+	vq->priv = rvring;
 
 	return vq;
-
-free_rpvq:
-	kfree(rpvq);
-	return ERR_PTR(ret);
 }
 
 static void rproc_virtio_del_vqs(struct virtio_device *vdev)
 {
 	struct virtqueue *vq, *n;
 	struct rproc *rproc = vdev_to_rproc(vdev);
+	struct rproc_vring *rvring;
 
 	/* power down the remote processor before deleting vqs */
 	rproc_shutdown(rproc);
 
 	list_for_each_entry_safe(vq, n, &vdev->vqs, list) {
-		struct rproc_virtio_vq_info *rpvq = vq->priv;
+		rvring = vq->priv;
+		rvring->vq = NULL;
 		vring_del_virtqueue(vq);
-		kfree(rpvq);
 	}
 }
 
@@ -141,10 +136,6 @@ static int rproc_virtio_find_vqs(struct virtio_device *vdev, unsigned nvqs,
 	struct rproc *rproc = vdev_to_rproc(vdev);
 	int i, ret;
 
-	/* we maintain two virtqueues per remote processor (for RX and TX) */
-	if (nvqs != 2)
-		return -EINVAL;
-
 	for (i = 0; i < nvqs; ++i) {
 		vqs[i] = rp_find_vq(vdev, i, callbacks[i], names[i]);
 		if (IS_ERR(vqs[i])) {
@@ -170,7 +161,7 @@ error:
 /*
  * We don't support yet real virtio status semantics.
  *
- * The plan is to provide this via the VIRTIO HDR resource entry
+ * The plan is to provide this via the VDEV resource entry
  * which is part of the firmware: this way the remote processor
  * will be able to access the status values as set by us.
  */
@@ -181,7 +172,7 @@ static u8 rproc_virtio_get_status(struct virtio_device *vdev)
 
 static void rproc_virtio_set_status(struct virtio_device *vdev, u8 status)
 {
-	dev_dbg(&vdev->dev, "new status: %d\n", status);
+	dev_dbg(&vdev->dev, "status: %d\n", status);
 }
 
 static void rproc_virtio_reset(struct virtio_device *vdev)
@@ -192,15 +183,14 @@ static void rproc_virtio_reset(struct virtio_device *vdev)
 /* provide the vdev features as retrieved from the firmware */
 static u32 rproc_virtio_get_features(struct virtio_device *vdev)
 {
-	struct rproc *rproc = vdev_to_rproc(vdev);
+	struct rproc_vdev *rvdev = vdev_to_rvdev(vdev);
 
-	/* we only support a single vdev device for now */
-	return rproc->rvdev->dfeatures;
+	return rvdev->dfeatures;
 }
 
 static void rproc_virtio_finalize_features(struct virtio_device *vdev)
 {
-	struct rproc *rproc = vdev_to_rproc(vdev);
+	struct rproc_vdev *rvdev = vdev_to_rvdev(vdev);
 
 	/* Give virtio_ring a chance to accept features */
 	vring_transport_features(vdev);
@@ -214,7 +204,7 @@ static void rproc_virtio_finalize_features(struct virtio_device *vdev)
 	 * fixed as part of a small resource table overhaul and then an
 	 * extension of the virtio resource entries.
 	 */
-	rproc->rvdev->gfeatures = vdev->features[0];
+	rvdev->gfeatures = vdev->features[0];
 }
 
 static struct virtio_config_ops rproc_virtio_config_ops = {
@@ -244,26 +234,25 @@ static void rproc_vdev_release(struct device *dev)
 }
 
 /**
- * rproc_add_rpmsg_vdev() - create an rpmsg virtio device
- * @rproc: the rproc handle
+ * rproc_add_virtio_dev() - register an rproc-induced virtio device
+ * @rvdev: the remote vdev
  *
- * This function is called if virtio rpmsg support was found in the
- * firmware of the remote processor.
+ * This function registers a virtio device. This vdev's partent is
+ * the rproc device.
  *
- * Today we only support creating a single rpmsg vdev (virtio device),
- * but the plan is to remove this limitation. At that point this interface
- * will be revised/extended.
+ * Returns 0 on success or an appropriate error value otherwise.
  */
-int rproc_add_rpmsg_vdev(struct rproc *rproc)
+int rproc_add_virtio_dev(struct rproc_vdev *rvdev, int id)
 {
+	struct rproc *rproc = rvdev->rproc;
 	struct device *dev = rproc->dev;
-	struct rproc_vdev *rvdev = rproc->rvdev;
+	struct virtio_device *vdev = &rvdev->vdev;
 	int ret;
 
-	rvdev->vdev.id.device	= VIRTIO_ID_RPMSG,
-	rvdev->vdev.config	= &rproc_virtio_config_ops,
-	rvdev->vdev.dev.parent	= dev;
-	rvdev->vdev.dev.release	= rproc_vdev_release;
+	vdev->id.device	= id,
+	vdev->config = &rproc_virtio_config_ops,
+	vdev->dev.parent = dev;
+	vdev->dev.release = rproc_vdev_release;
 
 	/*
 	 * We're indirectly making a non-temporary copy of the rproc pointer
@@ -275,25 +264,26 @@ int rproc_add_rpmsg_vdev(struct rproc *rproc)
 	 */
 	kref_get(&rproc->refcount);
 
-	ret = register_virtio_device(&rvdev->vdev);
+	ret = register_virtio_device(vdev);
 	if (ret) {
 		kref_put(&rproc->refcount, rproc_release);
 		dev_err(dev, "failed to register vdev: %d\n", ret);
+		goto out;
 	}
 
+	dev_info(dev, "registered %s (type %d)\n", dev_name(&vdev->dev), id);
+
+out:
 	return ret;
 }
 
 /**
- * rproc_remove_rpmsg_vdev() - remove an rpmsg vdev device
- * @rproc: the rproc handle
+ * rproc_remove_virtio_dev() - remove an rproc-induced virtio device
+ * @rvdev: the remote vdev
  *
- * This function is called whenever @rproc is removed _iff_ an rpmsg
- * vdev was created beforehand.
+ * This function unregisters an existing virtio device.
  */
-void rproc_remove_rpmsg_vdev(struct rproc *rproc)
+void rproc_remove_virtio_dev(struct rproc_vdev *rvdev)
 {
-	struct rproc_vdev *rvdev = rproc->rvdev;
-
 	unregister_virtio_device(&rvdev->vdev);
 }
diff --git a/include/linux/remoteproc.h b/include/linux/remoteproc.h
index 6040f83..7750d8a 100644
--- a/include/linux/remoteproc.h
+++ b/include/linux/remoteproc.h
@@ -41,6 +41,7 @@
 #include <linux/mutex.h>
 #include <linux/virtio.h>
 #include <linux/completion.h>
+#include <linux/idr.h>
 
 /*
  * The alignment between the consumer and producer parts of the vring.
@@ -387,7 +388,8 @@ enum rproc_state {
  * @mappings: list of iommu mappings we initiated, needed on shutdown
  * @firmware_loading_complete: marks e/o asynchronous firmware loading
  * @bootaddr: address of first instruction to boot rproc with (optional)
- * @rvdev: virtio device (we only support a single rpmsg virtio device for now)
+ * @rvdevs: list of remote virtio devices
+ * @notifyids: idr for dynamically assigning rproc-wide unique notify ids
  */
 struct rproc {
 	struct klist_node node;
@@ -408,23 +410,47 @@ struct rproc {
 	struct list_head mappings;
 	struct completion firmware_loading_complete;
 	u32 bootaddr;
+	struct list_head rvdevs;
+	struct idr notifyids;
+};
+
+/* we currently support only two vrings per rvdev */
+#define RVDEV_NUM_VRINGS 2
+
+/**
+ * struct rproc_vring - remoteproc vring state
+ * @va:	virtual address
+ * @dma: dma address
+ * @len: length, in bytes
+ * @da: device address
+ * @notifyid: rproc-specific unique vring index
+ * @rvdev: remote vdev
+ * @vq: the virtqueue of this vring
+ */
+struct rproc_vring {
+	void *va;
+	dma_addr_t dma;
+	int len;
+	u32 da;
+	int notifyid;
 	struct rproc_vdev *rvdev;
+	struct virtqueue *vq;
 };
 
 /**
  * struct rproc_vdev - remoteproc state for a supported virtio device
+ * @node: list node
  * @rproc: the rproc handle
  * @vdev: the virio device
- * @vq: the virtqueues for this vdev
  * @vring: the vrings for this vdev
  * @dfeatures: virtio device features
  * @gfeatures: virtio guest features
  */
 struct rproc_vdev {
+	struct list_head node;
 	struct rproc *rproc;
 	struct virtio_device vdev;
-	struct virtqueue *vq[2];
-	struct rproc_mem_entry vring[2];
+	struct rproc_vring vring[RVDEV_NUM_VRINGS];
 	unsigned long dfeatures;
 	unsigned long gfeatures;
 };
@@ -442,9 +468,14 @@ int rproc_unregister(struct rproc *rproc);
 int rproc_boot(struct rproc *rproc);
 void rproc_shutdown(struct rproc *rproc);
 
+static inline struct rproc_vdev *vdev_to_rvdev(struct virtio_device *vdev)
+{
+	return container_of(vdev, struct rproc_vdev, vdev);
+}
+
 static inline struct rproc *vdev_to_rproc(struct virtio_device *vdev)
 {
-	struct rproc_vdev *rvdev = container_of(vdev, struct rproc_vdev, vdev);
+	struct rproc_vdev *rvdev = vdev_to_rvdev(vdev);
 
 	return rvdev->rproc;
 }
-- 
1.7.5.4

