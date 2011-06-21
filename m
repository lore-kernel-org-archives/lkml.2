Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756258Ab1FUKS2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jun 2011 06:18:28 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:54803 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755353Ab1FUKSY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jun 2011 06:18:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=gOHe2rT7X4Xt19//UKJzKSgvkgykO7JGBA+/5sIGNWcWB3Z46ygjx1rZ9Ghq3PXWGA
         hjd8bi4QYQBUa+GEcEpDTVqUkD3NpUggvKTCzr95C4mIPwEwMInJMhckUSAg7jTs8kvT
         zzdwnis/ZbsiYLGfTQp+XxOV28PhVXMiqi8Us=
From: Magnus Damm <magnus.damm@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: vapier@gentoo.org, linux-sh@vger.kernel.org, rusty@rustcorp.com.au,
        virtualization@lists.linux-foundation.org, horms@verge.net.au,
        mst@redhat.com, Magnus Damm <magnus.damm@gmail.com>,
        iws@ovro.caltech.edu
Date: Tue, 21 Jun 2011 19:26:23 +0900
Message-Id: <20110621102623.1382.71841.sendpatchset@t400s>
In-Reply-To: <20110621102605.1382.90232.sendpatchset@t400s>
References: <20110621102605.1382.90232.sendpatchset@t400s>
Subject: [PATCH 02/02] virtio: Add virtio platform driver
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Magnus Damm <damm@opensource.se>

This patch adds a virtio platform driver. The code is based on
the lguest implementation available in drivers/lguest/lguest_device.c

The iomem resource is used to point out the lguest device descriptor,
and the platform data contains two separate callbacks for notification.

Signed-off-by: Magnus Damm <damm@opensource.se>
---

 drivers/virtio/Kconfig           |   11 +
 drivers/virtio/Makefile          |    1 
 drivers/virtio/virtio_platform.c |  282 ++++++++++++++++++++++++++++++++++++++
 include/linux/virtio_platform.h  |   12 +
 4 files changed, 306 insertions(+)

--- 0002/drivers/virtio/Kconfig
+++ work/drivers/virtio/Kconfig	2011-03-03 15:56:53.000000000 +0900
@@ -35,3 +35,14 @@ config VIRTIO_BALLOON
 
 config VIRTIO_LGUEST
 	tristate
+
+config VIRTIO_PLATFORM
+	tristate "Platform driver for virtio devices (EXPERIMENTAL)"
+	select VIRTIO
+	select VIRTIO_RING
+	select VIRTIO_LGUEST
+	---help---
+	 This drivers provides support for virtio based paravirtual device
+	 drivers over a platform bus.
+
+	 If unsure, say N.
--- 0002/drivers/virtio/Makefile
+++ work/drivers/virtio/Makefile	2011-03-03 15:56:53.000000000 +0900
@@ -3,3 +3,4 @@ obj-$(CONFIG_VIRTIO_RING) += virtio_ring
 obj-$(CONFIG_VIRTIO_PCI) += virtio_pci.o
 obj-$(CONFIG_VIRTIO_BALLOON) += virtio_balloon.o
 obj-$(CONFIG_VIRTIO_LGUEST) += virtio_lguest.o
+obj-$(CONFIG_VIRTIO_PLATFORM) += virtio_platform.o
--- /dev/null
+++ work/drivers/virtio/virtio_platform.c	2011-03-03 16:07:31.000000000 +0900
@@ -0,0 +1,282 @@
+#include <linux/init.h>
+#include <linux/virtio.h>
+#include <linux/virtio_config.h>
+#include <linux/virtio_ring.h>
+#include <linux/lguest_device.h>
+#include <linux/lguest_launcher.h>
+#include <linux/virtio_platform.h>
+#include <linux/platform_device.h>
+#include <linux/interrupt.h>
+#include <linux/err.h>
+#include <linux/slab.h>
+#include <linux/io.h>
+
+static void __iomem *virtio_map(unsigned long phys_addr, unsigned long pages)
+{
+	return ioremap_nocache(phys_addr, PAGE_SIZE*pages);
+}
+
+static void virtio_unmap(void __iomem *addr)
+{
+	iounmap(addr);
+}
+
+static void set_status(struct virtio_device *vdev, u8 status)
+{
+	struct platform_device *pdev = to_platform_device(vdev->dev.parent);
+	struct virtio_platform_data *pdata = pdev->dev.platform_data;
+
+	to_lgdev(vdev)->desc->status = status;
+	pdata->notify_virtio(pdev);
+}
+
+static void lg_set_status(struct virtio_device *vdev, u8 status)
+{
+	BUG_ON(!status);
+	set_status(vdev, status);
+}
+
+static void lg_reset(struct virtio_device *vdev)
+{
+	set_status(vdev, 0);
+}
+
+/*
+ * Virtqueues
+ *
+ * The other piece of infrastructure virtio needs is a "virtqueue": a way of
+ * the Guest device registering buffers for the other side to read from or
+ * write into (ie. send and receive buffers).  Each device can have multiple
+ * virtqueues: for example the console driver uses one queue for sending and
+ * another for receiving.
+ *
+ * Fortunately for us, a very fast shared-memory-plus-descriptors virtqueue
+ * already exists in virtio_ring.c.  We just need to connect it up.
+ *
+ * We start with the information we need to keep about each virtqueue.
+ */
+
+/*D:140 This is the information we remember about each virtqueue. */
+struct lguest_vq_info {
+	/* A copy of the information contained in the device config. */
+	struct lguest_vqconfig config;
+
+	/* The address where we mapped the virtio ring, so we can unmap it. */
+	void __iomem *pages;
+};
+
+/*
+ * When the virtio_ring code wants to prod the Host, it calls us here and we
+ * call the board specific callback.  We hand a pointer to the configuration
+ * so the board code knows which virtqueue we're talking about.
+ */
+static void lg_notify(struct virtqueue *vq)
+{
+	struct platform_device *pdev = to_platform_device(vq->vdev->dev.parent);
+	struct virtio_platform_data *pdata = pdev->dev.platform_data;
+	struct lguest_vq_info *lvq = vq->priv;
+
+	pdata->notify_virtqueue(pdev, &lvq->config);
+}
+
+/*
+ * This routine finds the Nth virtqueue described in the configuration of
+ * this device and sets it up.
+ *
+ * This is kind of an ugly duckling.  It'd be nicer to have a standard
+ * representation of a virtqueue in the configuration space, but it seems that
+ * everyone wants to do it differently.  The KVM coders want the Guest to
+ * allocate its own pages and tell the Host where they are, but for lguest it's
+ * simpler for the Host to simply tell us where the pages are.
+ */
+static struct virtqueue *lg_find_vq(struct virtio_device *vdev,
+				    unsigned index,
+				    void (*callback)(struct virtqueue *vq),
+				    const char *name)
+{
+	struct lguest_device *ldev = to_lgdev(vdev);
+	struct lguest_vq_info *lvq;
+	struct virtqueue *vq;
+	int err;
+
+	/* We must have this many virtqueues. */
+	if (index >= ldev->desc->num_vq)
+		return ERR_PTR(-ENOENT);
+
+	lvq = kmalloc(sizeof(*lvq), GFP_KERNEL);
+	if (!lvq)
+		return ERR_PTR(-ENOMEM);
+
+	/*
+	 * Make a copy of the "struct lguest_vqconfig" entry, which sits after
+	 * the descriptor.  We need a copy because the config space might not
+	 * be aligned correctly.
+	 */
+	memcpy(&lvq->config, lg_vq(ldev->desc)+index, sizeof(lvq->config));
+
+	dev_info(&vdev->dev, "Mapping virtqueue %i addr %lx\n", index,
+		 (unsigned long)lvq->config.pfn << PAGE_SHIFT);
+	/* Figure out how many pages the ring will take, and map that memory */
+	lvq->pages = virtio_map((unsigned long)lvq->config.pfn << PAGE_SHIFT,
+				DIV_ROUND_UP(vring_size(lvq->config.num,
+							LGUEST_VRING_ALIGN),
+					     PAGE_SIZE));
+	if (!lvq->pages) {
+		err = -ENOMEM;
+		goto free_lvq;
+	}
+
+	/*
+	 * OK, tell virtio_ring.c to set up a virtqueue now we know its size
+	 * and we've got a pointer to its pages.
+	 */
+	vq = vring_new_virtqueue(lvq->config.num, LGUEST_VRING_ALIGN,
+				 vdev, lvq->pages, lg_notify, callback, name);
+	if (!vq) {
+		err = -ENOMEM;
+		goto unmap;
+	}
+
+	/*
+	 * Tell the interrupt for this virtqueue to go to the virtio_ring
+	 * interrupt handler.
+	 *
+	 * FIXME: We used to have a flag for the Host to tell us we could use
+	 * the interrupt as a source of randomness: it'd be nice to have that
+	 * back.
+	 */
+	err = request_irq(lvq->config.irq, vring_interrupt, IRQF_SHARED,
+			  dev_name(&vdev->dev), vq);
+	if (err)
+		goto destroy_vring;
+
+	/*
+	 * Last of all we hook up our 'struct lguest_vq_info" to the
+	 * virtqueue's priv pointer.
+	 */
+	vq->priv = lvq;
+	return vq;
+
+destroy_vring:
+	vring_del_virtqueue(vq);
+unmap:
+	virtio_unmap(lvq->pages);
+free_lvq:
+	kfree(lvq);
+	return ERR_PTR(err);
+}
+/*:*/
+
+/* Cleaning up a virtqueue is easy */
+static void lg_del_vq(struct virtqueue *vq)
+{
+	struct lguest_vq_info *lvq = vq->priv;
+
+	/* Release the interrupt */
+	free_irq(lvq->config.irq, vq);
+	/* Tell virtio_ring.c to free the virtqueue. */
+	vring_del_virtqueue(vq);
+	/* Unmap the pages containing the ring. */
+	virtio_unmap(lvq->pages);
+	/* Free our own queue information. */
+	kfree(lvq);
+}
+
+static void lg_del_vqs(struct virtio_device *vdev)
+{
+	struct virtqueue *vq, *n;
+
+	list_for_each_entry_safe(vq, n, &vdev->vqs, list)
+		lg_del_vq(vq);
+}
+
+static int lg_find_vqs(struct virtio_device *vdev, unsigned nvqs,
+		       struct virtqueue *vqs[],
+		       vq_callback_t *callbacks[],
+		       const char *names[])
+{
+	struct lguest_device *ldev = to_lgdev(vdev);
+	int i;
+
+	/* We must have this many virtqueues. */
+	if (nvqs > ldev->desc->num_vq)
+		return -ENOENT;
+
+	for (i = 0; i < nvqs; ++i) {
+		vqs[i] = lg_find_vq(vdev, i, callbacks[i], names[i]);
+		if (IS_ERR(vqs[i]))
+			goto error;
+	}
+	return 0;
+
+error:
+	lg_del_vqs(vdev);
+	return PTR_ERR(vqs[i]);
+}
+
+/* The ops structure which hooks everything together. */
+static struct virtio_config_ops lguest_config_ops = {
+	.get_features = lg_get_features,
+	.finalize_features = lg_finalize_features,
+	.get = lg_get,
+	.set = lg_set,
+	.get_status = lg_get_status,
+	.set_status = lg_set_status,
+	.reset = lg_reset,
+	.find_vqs = lg_find_vqs,
+	.del_vqs = lg_del_vqs,
+};
+
+static int virtio_platform_probe(struct platform_device *pdev)
+{
+	struct virtio_platform_data *pdata = pdev->dev.platform_data;
+	struct resource *res;
+	void *devices;
+
+	if (!pdata) {
+		dev_err(&pdev->dev, "no platform data defined\n");
+		return -EINVAL;
+	}
+
+	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	if (res == NULL) {
+		dev_err(&pdev->dev, "cannot find IO resource\n");
+		return -ENOENT;
+	}
+
+	/* Devices are pointed out using struct resource */
+	devices = virtio_map(res->start, resource_size(res) >> PAGE_SHIFT);
+	lg_scan_devices(devices, &pdev->dev, &lguest_config_ops);
+	return 0;
+}
+
+static int virtio_platform_remove(struct platform_device *pdev)
+{
+	return -ENOTSUPP;
+}
+
+static struct platform_driver virtio_platform_driver = {
+	.driver		= {
+		.name		= "virtio-platform",
+		.owner		= THIS_MODULE,
+	},
+	.probe		= virtio_platform_probe,
+	.remove		= virtio_platform_remove,
+};
+
+static int __init virtio_platform_init(void)
+{
+	return platform_driver_register(&virtio_platform_driver);
+}
+
+static void __exit virtio_platform_exit(void)
+{
+	platform_driver_unregister(&virtio_platform_driver);
+}
+
+module_init(virtio_platform_init);
+module_exit(virtio_platform_exit);
+
+MODULE_DESCRIPTION("VirtIO Platform Driver");
+MODULE_LICENSE("GPL");
+MODULE_ALIAS("platform:virtio-platform");
--- /dev/null
+++ work/include/linux/virtio_platform.h	2011-03-03 15:56:54.000000000 +0900
@@ -0,0 +1,12 @@
+#ifndef _LINUX_VIRTIO_PLATFORM_H
+#define _LINUX_VIRTIO_PLATFORM_H
+#include <linux/platform_device.h>
+#include <linux/lguest_launcher.h>
+
+struct virtio_platform_data {
+	void (*notify_virtio)(struct platform_device *pdev);
+	void (*notify_virtqueue)(struct platform_device *pdev,
+				 struct lguest_vqconfig *config);
+};
+
+#endif /* _LINUX_VIRTIO_PLATFORM_H */
