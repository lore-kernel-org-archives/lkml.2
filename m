Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756114Ab1ILQ4K (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Sep 2011 12:56:10 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:54790 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755361Ab1ILQ4H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Sep 2011 12:56:07 -0400
From: Pawel Moll <pawel.moll@arm.com>
To: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        virtualization@lists.linux-foundation.org
Cc: Pawel Moll <pawel.moll@arm.com>, Rusty Russell <rusty@rustcorp.com.au>,
        Anthony Liguori <aliguori@us.ibm.com>,
        "Michael S.Tsirkin" <mst@redhat.com>,
        Magnus Damm <magnus.damm@gmail.com>
Subject: [RFC v2] arm: Add platform bus driver for virtio device
Date: Mon, 12 Sep 2011 17:51:41 +0100
Message-Id: <1315846301-13892-1-git-send-email-pawel.moll@arm.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1315845956.3297.7.camel@hornet.cambridge.arm.com>
References: <1315845956.3297.7.camel@hornet.cambridge.arm.com>
X-OriginalArrivalTime: 12 Sep 2011 16:51:54.0737 (UTC) FILETIME=[46EEE610:01CC716C]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch, based on virtio PCI driver, adds support for memory
mapped (platform) virtio  device. This should allow environments
like qemu to use virtio-based block & network devices.

One can define and register a platform device which resources
will describe memory mapped control registers and "mailbox"
interrupt. Such device can be also instantiated using the Device
Tree node with compatible property equal "virtio,platform".

Note: Work in progress...

Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Anthony Liguori <aliguori@us.ibm.com>
Cc: Michael S.Tsirkin <mst@redhat.com>
Cc: Magnus Damm <magnus.damm@gmail.com>
Signed-off-by: Pawel Moll <pawel.moll@arm.com>
---
 drivers/virtio/Kconfig           |   11 +
 drivers/virtio/Makefile          |    1 +
 drivers/virtio/virtio_platform.c |  424 ++++++++++++++++++++++++++++++++++++++
 include/linux/virtio_platform.h  |   62 ++++++
 4 files changed, 498 insertions(+), 0 deletions(-)
 create mode 100644 drivers/virtio/virtio_platform.c
 create mode 100644 include/linux/virtio_platform.h

diff --git a/drivers/virtio/Kconfig b/drivers/virtio/Kconfig
index 57e493b..63edf72 100644
--- a/drivers/virtio/Kconfig
+++ b/drivers/virtio/Kconfig
@@ -35,4 +35,15 @@ config VIRTIO_BALLOON
 
 	 If unsure, say M.
 
+ config VIRTIO_PLATFORM
+ 	tristate "Platform bus driver for virtio devices (EXPERIMENTAL)"
+ 	depends on EXPERIMENTAL
+ 	select VIRTIO
+ 	select VIRTIO_RING
+ 	---help---
+ 	 This drivers provides support for memory mapped (platform) virtio
+	 based paravirtual device driver.
+
+ 	 If unsure, say N.
+
 endmenu
diff --git a/drivers/virtio/Makefile b/drivers/virtio/Makefile
index 6738c44..4d175c0 100644
--- a/drivers/virtio/Makefile
+++ b/drivers/virtio/Makefile
@@ -1,4 +1,5 @@
 obj-$(CONFIG_VIRTIO) += virtio.o
 obj-$(CONFIG_VIRTIO_RING) += virtio_ring.o
+obj-$(CONFIG_VIRTIO_PLATFORM) += virtio_platform.o
 obj-$(CONFIG_VIRTIO_PCI) += virtio_pci.o
 obj-$(CONFIG_VIRTIO_BALLOON) += virtio_balloon.o
diff --git a/drivers/virtio/virtio_platform.c b/drivers/virtio/virtio_platform.c
new file mode 100644
index 0000000..b16027b
--- /dev/null
+++ b/drivers/virtio/virtio_platform.c
@@ -0,0 +1,424 @@
+/*
+ * Virtio platform device driver
+ *
+ * Copyright 2011, ARM Ltd.
+ *
+ * This module allows virtio devices to be used over a virtual platform device.
+ *
+ * Registers layout:
+ *
+ * offset width name          description
+ * ------ ----- ------------- -----------------
+ *
+ *  0x000   32  MagicValue    Magic value "virt" (0x74726976 LE)
+ *  0x004   32  DeviceID      Virtio device ID
+ *  0x008   32  VendorID      Virtio vendor ID
+ *
+ *  0x010   32  HostFeatures  Features supported by the host
+ *  0x020   32  GuestFeatures Features activated by the guest
+ *
+ *  0x030   32  QueuePFN      PFN for the currently selected queue
+ *  0x034   32  QueueNum      Queue size for the currently selected queue
+ *  0x038   32  QueueSel      Queue selector
+ *  0x03c   32  QueueNotify   Queue notifier
+ *
+ *  0x040   32  InterruptACK  Interrupt acknowledge register
+ *  0x050    8  Status        Device status register
+ *
+ *  0x100
+ *   ...                      Device-specific configuration space
+ *  0xfff
+ *
+ * Based on Virtio PCI driver by Anthony Liguori, copyright IBM Corp. 2007
+ *
+ * This work is licensed under the terms of the GNU GPL, version 2 or later.
+ * See the COPYING file in the top-level directory.
+ */
+
+#include <linux/highmem.h>
+#include <linux/interrupt.h>
+#include <linux/io.h>
+#include <linux/list.h>
+#include <linux/module.h>
+#include <linux/platform_device.h>
+#include <linux/slab.h>
+#include <linux/spinlock.h>
+#include <linux/virtio.h>
+#include <linux/virtio_config.h>
+#include <linux/virtio_platform.h>
+#include <linux/virtio_ring.h>
+
+
+
+#define to_virtio_plat_device(_plat_dev) \
+	container_of(_plat_dev, struct virtio_plat_device, vdev)
+
+struct virtio_plat_device {
+	struct virtio_device vdev;
+	struct platform_device *pdev;
+
+	void __iomem *base;
+
+	/* a list of queues so we can dispatch IRQs */
+	spinlock_t lock;
+	struct list_head virtqueues;
+};
+
+struct virtio_plat_vq_info {
+	/* the actual virtqueue */
+	struct virtqueue *vq;
+
+	/* the number of entries in the queue */
+	int num;
+
+	/* the index of the queue */
+	int queue_index;
+
+	/* the virtual address of the ring queue */
+	void *queue;
+
+	/* the list node for the virtqueues list */
+	struct list_head node;
+};
+
+
+
+/* Configuration interface */
+
+static u32 va_get_features(struct virtio_device *vdev)
+{
+	struct virtio_plat_device *vpdev = to_virtio_plat_device(vdev);
+
+	/* When someone needs more than 32 feature bits, we'll need to
+	 * steal a bit to indicate that the rest are somewhere else. */
+	return readl(vpdev->base + VIRTIO_PLAT_HOST_FEATURES);
+}
+
+static void va_finalize_features(struct virtio_device *vdev)
+{
+	struct virtio_plat_device *vpdev = to_virtio_plat_device(vdev);
+
+	/* Give virtio_ring a chance to accept features. */
+	vring_transport_features(vdev);
+
+	/* We only support 32 feature bits. */
+	BUILD_BUG_ON(ARRAY_SIZE(vdev->features) != 1);
+	writel(vdev->features[0], vpdev->base + VIRTIO_PLAT_GUEST_FEATURES);
+}
+
+static void va_get(struct virtio_device *vdev, unsigned offset,
+		   void *buf, unsigned len)
+{
+	struct virtio_plat_device *vpdev = to_virtio_plat_device(vdev);
+	u8 *ptr = buf;
+	int i;
+
+	for (i = 0; i < len; i++)
+		ptr[i] = readb(vpdev->base + VIRTIO_PLAT_CONFIG + offset + i);
+}
+
+static void va_set(struct virtio_device *vdev, unsigned offset,
+		   const void *buf, unsigned len)
+{
+	struct virtio_plat_device *vpdev = to_virtio_plat_device(vdev);
+	const u8 *ptr = buf;
+	int i;
+
+	for (i = 0; i < len; i++)
+		writeb(ptr[i], vpdev->base + VIRTIO_PLAT_CONFIG + offset + i);
+}
+
+static u8 va_get_status(struct virtio_device *vdev)
+{
+	struct virtio_plat_device *vpdev = to_virtio_plat_device(vdev);
+
+	return readb(vpdev->base + VIRTIO_PLAT_STATUS) & 0xff;
+}
+
+static void va_set_status(struct virtio_device *vdev, u8 status)
+{
+	struct virtio_plat_device *vpdev = to_virtio_plat_device(vdev);
+
+	/* We should never be setting status to 0. */
+	BUG_ON(status == 0);
+
+	writeb(status, vpdev->base + VIRTIO_PLAT_STATUS);
+}
+
+static void va_reset(struct virtio_device *vdev)
+{
+	struct virtio_plat_device *vpdev = to_virtio_plat_device(vdev);
+
+	/* 0 status means a reset. */
+	writeb(0, vpdev->base + VIRTIO_PLAT_STATUS);
+}
+
+
+
+/* Transport interface */
+
+/* the notify function used when creating a virt queue */
+static void va_notify(struct virtqueue *vq)
+{
+	struct virtio_plat_device *vpdev = to_virtio_plat_device(vq->vdev);
+	struct virtio_plat_vq_info *info = vq->priv;
+
+	/* We write the queue's selector into the notification register to
+	 * signal the other end */
+	writel(info->queue_index, vpdev->base + VIRTIO_PLAT_QUEUE_NOTIFY);
+}
+
+/* Notify all virtqueues on an interrupt. */
+static irqreturn_t va_interrupt(int irq, void *opaque)
+{
+	struct virtio_plat_device *vpdev = opaque;
+	struct virtio_plat_vq_info *info;
+	irqreturn_t ret = IRQ_NONE;
+	unsigned long flags;
+
+	writel(1, vpdev->base + VIRTIO_PLAT_INTERRUPT_ACK);
+
+	spin_lock_irqsave(&vpdev->lock, flags);
+	list_for_each_entry(info, &vpdev->virtqueues, node) {
+		if (vring_interrupt(irq, info->vq) == IRQ_HANDLED)
+			ret = IRQ_HANDLED;
+	}
+	spin_unlock_irqrestore(&vpdev->lock, flags);
+
+	return ret;
+}
+
+
+
+static void va_del_vq(struct virtqueue *vq)
+{
+	struct virtio_plat_device *vpdev = to_virtio_plat_device(vq->vdev);
+	struct virtio_plat_vq_info *info = vq->priv;
+	unsigned long flags, size;
+
+	spin_lock_irqsave(&vpdev->lock, flags);
+	list_del(&info->node);
+	spin_unlock_irqrestore(&vpdev->lock, flags);
+
+	writel(info->queue_index, vpdev->base + VIRTIO_PLAT_QUEUE_SEL);
+
+	vring_del_virtqueue(vq);
+
+	/* Select and deactivate the queue */
+	writel(0, vpdev->base + VIRTIO_PLAT_QUEUE_PFN);
+
+	size = PAGE_ALIGN(vring_size(info->num, VIRTIO_PLAT_VRING_ALIGN));
+	free_pages_exact(info->queue, size);
+	kfree(info);
+}
+
+static void va_del_vqs(struct virtio_device *vdev)
+{
+	struct virtio_plat_device *vpdev = to_virtio_plat_device(vdev);
+	struct virtqueue *vq, *n;
+
+	list_for_each_entry_safe(vq, n, &vdev->vqs, list)
+		va_del_vq(vq);
+
+	free_irq(platform_get_irq(vpdev->pdev, 0), vpdev);
+}
+
+
+
+static struct virtqueue *va_setup_vq(struct virtio_device *vdev, unsigned index,
+				  void (*callback)(struct virtqueue *vq),
+				  const char *name)
+{
+	struct virtio_plat_device *vpdev = to_virtio_plat_device(vdev);
+	struct virtio_plat_vq_info *info;
+	struct virtqueue *vq;
+	unsigned long flags, size;
+	u16 num;
+	int err;
+
+	/* Select the queue we're interested in */
+	writel(index, vpdev->base + VIRTIO_PLAT_QUEUE_SEL);
+
+	/* Check if queue is either not available or already active. */
+	num = readl(vpdev->base + VIRTIO_PLAT_QUEUE_NUM);
+	if (!num || readl(vpdev->base + VIRTIO_PLAT_QUEUE_PFN)) {
+		err = -ENOENT;
+		goto error_available;
+	}
+
+	/* Allocate and fill out our structure the represents an active
+	 * queue */
+	info = kmalloc(sizeof(struct virtio_plat_vq_info), GFP_KERNEL);
+	if (!info) {
+		err = -ENOMEM;
+		goto error_kmalloc;
+	}
+
+	info->queue_index = index;
+	info->num = num;
+
+	size = PAGE_ALIGN(vring_size(num, VIRTIO_PLAT_VRING_ALIGN));
+	info->queue = alloc_pages_exact(size, GFP_KERNEL | __GFP_ZERO);
+	if (info->queue == NULL) {
+		err = -ENOMEM;
+		goto error_alloc_pages;
+	}
+
+	/* Activate the queue */
+	writel(virt_to_phys(info->queue) >> VIRTIO_PLAT_QUEUE_ADDR_SHIFT,
+		  vpdev->base + VIRTIO_PLAT_QUEUE_PFN);
+
+	/* Create the vring */
+	vq = vring_new_virtqueue(info->num, VIRTIO_PLAT_VRING_ALIGN,
+				 vdev, info->queue, va_notify, callback, name);
+	if (!vq) {
+		err = -ENOMEM;
+		goto error_new_virtqueue;
+	}
+
+	vq->priv = info;
+	info->vq = vq;
+
+	spin_lock_irqsave(&vpdev->lock, flags);
+	list_add(&info->node, &vpdev->virtqueues);
+	spin_unlock_irqrestore(&vpdev->lock, flags);
+
+	return vq;
+
+error_new_virtqueue:
+	writel(0, vpdev->base + VIRTIO_PLAT_QUEUE_PFN);
+	free_pages_exact(info->queue, size);
+error_alloc_pages:
+	kfree(info);
+error_kmalloc:
+error_available:
+	return ERR_PTR(err);
+}
+
+static int va_find_vqs(struct virtio_device *vdev, unsigned nvqs,
+		       struct virtqueue *vqs[],
+		       vq_callback_t *callbacks[],
+		       const char *names[])
+{
+	struct virtio_plat_device *vpdev = to_virtio_plat_device(vdev);
+	unsigned int irq = platform_get_irq(vpdev->pdev, 0);
+	int i, err;
+
+	err = request_irq(irq, va_interrupt, IRQF_SHARED,
+			dev_name(&vdev->dev), vpdev);
+	if (err)
+		return err;
+
+	for (i = 0; i < nvqs; ++i) {
+		vqs[i] = va_setup_vq(vdev, i, callbacks[i], names[i]);
+		if (IS_ERR(vqs[i])) {
+			va_del_vqs(vdev);
+			free_irq(irq, vpdev);
+			return PTR_ERR(vqs[i]);
+		}
+	}
+
+	return 0;
+}
+
+
+
+static struct virtio_config_ops virtio_plat_config_ops = {
+	.get		= va_get,
+	.set		= va_set,
+	.get_status	= va_get_status,
+	.set_status	= va_set_status,
+	.reset		= va_reset,
+	.find_vqs	= va_find_vqs,
+	.del_vqs	= va_del_vqs,
+	.get_features	= va_get_features,
+	.finalize_features = va_finalize_features,
+};
+
+
+
+/* Platform device */
+
+static int __devinit virtio_plat_probe(struct platform_device *pdev)
+{
+	struct virtio_plat_device *vpdev;
+	struct resource *mem;
+
+	mem = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	if (!mem)
+		return -EINVAL;
+
+	if (!devm_request_mem_region(&pdev->dev, mem->start,
+			resource_size(mem), pdev->name))
+		return -EBUSY;
+
+	vpdev = devm_kzalloc(&pdev->dev, sizeof(struct virtio_plat_device),
+			GFP_KERNEL);
+	if (!vpdev)
+		return  -ENOMEM;
+
+	vpdev->vdev.dev.parent = &pdev->dev;
+	vpdev->vdev.config = &virtio_plat_config_ops;
+	vpdev->pdev = pdev;
+	INIT_LIST_HEAD(&vpdev->virtqueues);
+	spin_lock_init(&vpdev->lock);
+
+	vpdev->base = devm_ioremap(&pdev->dev, mem->start, resource_size(mem));
+	if (vpdev->base == NULL)
+		return -EFAULT;
+
+	/* TODO: check magic value (VIRTIO_PLAT_MAGIC_VALUE) */
+
+	vpdev->vdev.id.device = readl(vpdev->base + VIRTIO_PLAT_DEVICE_ID);
+	vpdev->vdev.id.vendor = readl(vpdev->base + VIRTIO_PLAT_VENDOR_ID);
+
+	platform_set_drvdata(pdev, vpdev);
+
+	return register_virtio_device(&vpdev->vdev);
+}
+
+static int __devexit virtio_plat_remove(struct platform_device *pdev)
+{
+	struct virtio_plat_device *vpdev = platform_get_drvdata(pdev);
+
+	unregister_virtio_device(&vpdev->vdev);
+
+	return 0;
+}
+
+
+
+/* Platform driver */
+
+static struct of_device_id virtio_plat_match[] = {
+	{ .compatible = "virtio,platform", },
+	{},
+};
+MODULE_DEVICE_TABLE(of, virtio_plat_match);
+
+static struct platform_driver virtio_plat_driver = {
+	.probe		= virtio_plat_probe,
+	.remove		= __devexit_p(virtio_plat_remove),
+	.driver		= {
+		.name	= "virtio-platform",
+		.owner	= THIS_MODULE,
+		.of_match_table	= virtio_plat_match,
+	},
+};
+
+static int __init virtio_plat_init(void)
+{
+	return platform_driver_register(&virtio_plat_driver);
+}
+
+static void __exit virtio_plat_exit(void)
+{
+	platform_driver_unregister(&virtio_plat_driver);
+}
+
+module_init(virtio_plat_init);
+module_exit(virtio_plat_exit);
+
+MODULE_AUTHOR("Pawel Moll <pawel.moll@arm.com>");
+MODULE_DESCRIPTION("Platform bus driver for virtio devices");
+MODULE_LICENSE("GPL");
diff --git a/include/linux/virtio_platform.h b/include/linux/virtio_platform.h
new file mode 100644
index 0000000..d4b26f1
--- /dev/null
+++ b/include/linux/virtio_platform.h
@@ -0,0 +1,62 @@
+/*
+ * Virtio platform device driver
+ *
+ * Copyright 2011, ARM Ltd.
+ *
+ * Based on Virtio PCI driver by Anthony Liguori, copyright IBM Corp. 2007
+ *
+ * This header is BSD licensed so anyone can use the definitions to implement
+ * compatible drivers/servers.
+ */
+
+#ifndef _LINUX_VIRTIO_PLATFORM_H
+#define _LINUX_VIRTIO_PLATFORM_H
+
+/* Magic value ("virt" string == 0x74726976 Little Endian word */
+#define VIRTIO_PLAT_MAGIC_VALUE		0x000
+
+/* Virtio device ID */
+#define VIRTIO_PLAT_DEVICE_ID		0x004
+
+/* Virtio vendor ID */
+#define VIRTIO_PLAT_VENDOR_ID		0x008
+
+/* Bitmask of the features supported by the host (32-bit register) */
+#define VIRTIO_PLAT_HOST_FEATURES	0x010
+
+/* Bitmask of features activated by the guest (32-bit register) */
+#define VIRTIO_PLAT_GUEST_FEATURES	0x020
+
+/* PFN for the currently selected queue (32-bit register) */
+#define VIRTIO_PLAT_QUEUE_PFN		0x030
+
+/* Queue size for the currently selected queue (32-bit register) */
+#define VIRTIO_PLAT_QUEUE_NUM		0x034
+
+/* Queue selector (32-bit register) */
+#define VIRTIO_PLAT_QUEUE_SEL		0x038
+
+/* Queue notifier (32-bit register) */
+#define VIRTIO_PLAT_QUEUE_NOTIFY	0x03c
+
+/* Interrupt acknowledge (32-bit register) */
+#define VIRTIO_PLAT_INTERRUPT_ACK	0x040
+
+/* Device status register (8-bit register) */
+#define VIRTIO_PLAT_STATUS		0x050
+
+/* The config space is defined by each driver as
+ * the per-driver configuration space */
+#define VIRTIO_PLAT_CONFIG		0x100
+
+
+
+/* How many bits to shift physical queue address written to QUEUE_PFN.
+ * 12 is historical, and due to 4kb page size. */
+#define VIRTIO_PLAT_QUEUE_ADDR_SHIFT	12
+
+/* The alignment to use between consumer and producer parts of vring.
+ * Page size again. */
+#define VIRTIO_PLAT_VRING_ALIGN		4096
+
+#endif
-- 
1.6.3.3

