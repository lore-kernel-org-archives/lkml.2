Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751867Ab1IBMZT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Sep 2011 08:25:19 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:57878 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751476Ab1IBMY6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Sep 2011 08:24:58 -0400
From: Pawel Moll <pawel.moll@arm.com>
To: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Cc: Rusty Russell <rusty@rustcorp.com.au>, Magnus Damm <magnus.damm@gmail.com>
Subject: [RFC 1/2] virtio: Add AMBA bus driver for virtio device
Date: Fri,  2 Sep 2011 13:24:16 +0100
Message-Id: <1314966257-7503-2-git-send-email-pawel.moll@arm.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1314966257-7503-1-git-send-email-pawel.moll@arm.com>
References: <1314966257-7503-1-git-send-email-pawel.moll@arm.com>
X-OriginalArrivalTime: 02 Sep 2011 12:24:23.0424 (UTC) FILETIME=[3F796800:01CC696B]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch, based on virtio PCI driver, adds support for virtio
AMBA device. This should allow environments like qemu to use
virtio-based block & network devices.

For example, one can define and register an AMBA device like
this (emulation environment must of course provide a correctly
mapped "Virtio Block Device Prime Cell"):

struct amba_device virtio_block = {
	.dev.init_name	= "virtio-block",
	.res		= {
		.start	= 0x1c0d0000,
		.end	= 0x1c0d0fff,
		.flags	= IORESOURCE_MEM,
	},
	.irq		= { 73, },
};

This should be soon replaced with Device Tree entry
supplied by the simulation environment.

Signed-off-by: Pawel Moll <pawel.moll@arm.com>
---
 drivers/virtio/Kconfig       |   11 +
 drivers/virtio/Makefile      |    1 +
 drivers/virtio/virtio_amba.c |  443 ++++++++++++++++++++++++++++++++++++++++++
 include/linux/virtio_amba.h  |   62 ++++++
 4 files changed, 517 insertions(+), 0 deletions(-)
 create mode 100644 drivers/virtio/virtio_amba.c
 create mode 100644 include/linux/virtio_amba.h

diff --git a/drivers/virtio/Kconfig b/drivers/virtio/Kconfig
index 57e493b..a8530ab 100644
--- a/drivers/virtio/Kconfig
+++ b/drivers/virtio/Kconfig
@@ -35,4 +35,15 @@ config VIRTIO_BALLOON
 
 	 If unsure, say M.
 
+ config VIRTIO_AMBA
+ 	tristate "AMBA bus driver for virtio devices (EXPERIMENTAL)"
+ 	depends on ARM_AMBA && EXPERIMENTAL
+ 	select VIRTIO
+ 	select VIRTIO_RING
+ 	---help---
+ 	 This drivers provides support for virtio based paravirtual device
+ 	 drivers over an AMBA bus.
+
+ 	 If unsure, say N.
+
 endmenu
diff --git a/drivers/virtio/Makefile b/drivers/virtio/Makefile
index 6738c44..49147cb 100644
--- a/drivers/virtio/Makefile
+++ b/drivers/virtio/Makefile
@@ -1,4 +1,5 @@
 obj-$(CONFIG_VIRTIO) += virtio.o
 obj-$(CONFIG_VIRTIO_RING) += virtio_ring.o
+obj-$(CONFIG_VIRTIO_AMBA) += virtio_amba.o
 obj-$(CONFIG_VIRTIO_PCI) += virtio_pci.o
 obj-$(CONFIG_VIRTIO_BALLOON) += virtio_balloon.o
diff --git a/drivers/virtio/virtio_amba.c b/drivers/virtio/virtio_amba.c
new file mode 100644
index 0000000..0cfbaec
--- /dev/null
+++ b/drivers/virtio/virtio_amba.c
@@ -0,0 +1,443 @@
+/*
+ * Virtio AMBA driver
+ *
+ * Copyright 2011, ARM Ltd.
+ *
+ * This module allows virtio devices to be used over a virtual AMBA device.
+ *
+ * Registers layout:
+ *
+ * offset width name          description
+ * ------ ----- ------------- -----------------
+ *
+ *  0x000   32  HostFeatures  Features supported by the host
+ *  0x004   32  GuestFeatures Features activated by the guest
+ *  0x008   32  QueuePFN      PFN for the currently selected queue
+ *  0x00c   32  QueueNum      Queue size for the currently selected queue
+ *  0x010   32  QueueSel      Queue selector
+ *  0x014   32  QueueNotify   Queue notifier
+ *  0x018   8   InterruptACK  Interrupt acknowledge register
+ *  0x01c   8   Status        Device status register
+ *
+ *  0x020
+ *   ...                      Device-specific configuration space
+ *  0xfdf
+ *
+ *  0xfe0   8   PeriphID0     0x30
+ *  0xfe4   8   PeriphID1     0x17
+ *  0xfe8   8   PeriphID2     0x04
+ *  0xfec   8   PeriphID3     VIRTIO_ID_* (see <linux/virtio_ids.h>)
+ *  0xff0   8   PCellID0      0x0d
+ *  0xff4   8   PCellID1      0xf0
+ *  0xff8   8   PCellID2      0x05
+ *  0xffc   8   PCellID3      0xb1
+ *
+ * Based on Virtio PCI driver by Anthony Liguori, copyright IBM Corp. 2007
+ *
+ * This work is licensed under the terms of the GNU GPL, version 2 or later.
+ * See the COPYING file in the top-level directory.
+ */
+
+#include <linux/module.h>
+#include <linux/list.h>
+#include <linux/slab.h>
+#include <linux/amba/bus.h>
+#include <linux/interrupt.h>
+#include <linux/virtio.h>
+#include <linux/virtio_amba.h>
+#include <linux/virtio_config.h>
+#include <linux/virtio_ring.h>
+#include <linux/highmem.h>
+#include <linux/spinlock.h>
+
+
+
+#define to_virtio_amba_device(_amba_dev) \
+	container_of(_amba_dev, struct virtio_amba_device, vdev)
+
+struct virtio_amba_device {
+	struct virtio_device vdev;
+	struct amba_device *amba_dev;
+
+	void __iomem *base;
+
+	/* a list of queues so we can dispatch IRQs */
+	spinlock_t lock;
+	struct list_head virtqueues;
+};
+
+struct virtio_amba_vq_info {
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
+	struct virtio_amba_device *va_dev = to_virtio_amba_device(vdev);
+
+	/* When someone needs more than 32 feature bits, we'll need to
+	 * steal a bit to indicate that the rest are somewhere else. */
+	return readl(va_dev->base + VIRTIO_AMBA_HOST_FEATURES);
+}
+
+static void va_finalize_features(struct virtio_device *vdev)
+{
+	struct virtio_amba_device *va_dev = to_virtio_amba_device(vdev);
+
+	/* Give virtio_ring a chance to accept features. */
+	vring_transport_features(vdev);
+
+	/* We only support 32 feature bits. */
+	BUILD_BUG_ON(ARRAY_SIZE(vdev->features) != 1);
+	writel(vdev->features[0], va_dev->base + VIRTIO_AMBA_GUEST_FEATURES);
+}
+
+static void va_get(struct virtio_device *vdev, unsigned offset,
+		   void *buf, unsigned len)
+{
+	struct virtio_amba_device *va_dev = to_virtio_amba_device(vdev);
+	u8 *ptr = buf;
+	int i;
+
+	for (i = 0; i < len; i++)
+		ptr[i] = readb(va_dev->base + VIRTIO_AMBA_CONFIG + offset + i);
+}
+
+static void va_set(struct virtio_device *vdev, unsigned offset,
+		   const void *buf, unsigned len)
+{
+	struct virtio_amba_device *va_dev = to_virtio_amba_device(vdev);
+	const u8 *ptr = buf;
+	int i;
+
+	for (i = 0; i < len; i++)
+		writeb(ptr[i], va_dev->base + VIRTIO_AMBA_CONFIG + offset + i);
+}
+
+static u8 va_get_status(struct virtio_device *vdev)
+{
+	struct virtio_amba_device *va_dev = to_virtio_amba_device(vdev);
+
+	return readb(va_dev->base + VIRTIO_AMBA_STATUS) & 0xff;
+}
+
+static void va_set_status(struct virtio_device *vdev, u8 status)
+{
+	struct virtio_amba_device *va_dev = to_virtio_amba_device(vdev);
+
+	/* We should never be setting status to 0. */
+	BUG_ON(status == 0);
+
+	writeb(status, va_dev->base + VIRTIO_AMBA_STATUS);
+}
+
+static void va_reset(struct virtio_device *vdev)
+{
+	struct virtio_amba_device *va_dev = to_virtio_amba_device(vdev);
+
+	/* 0 status means a reset. */
+	writeb(0, va_dev->base + VIRTIO_AMBA_STATUS);
+}
+
+
+
+/* Transport interface */
+
+/* the notify function used when creating a virt queue */
+static void va_notify(struct virtqueue *vq)
+{
+	struct virtio_amba_device *va_dev = to_virtio_amba_device(vq->vdev);
+	struct virtio_amba_vq_info *info = vq->priv;
+
+	/* We write the queue's selector into the notification register to
+	 * signal the other end */
+	writel(info->queue_index, va_dev->base + VIRTIO_AMBA_QUEUE_NOTIFY);
+}
+
+/* Notify all virtqueues on an interrupt. */
+static irqreturn_t va_interrupt(int irq, void *opaque)
+{
+	struct virtio_amba_device *va_dev = opaque;
+	struct virtio_amba_vq_info *info;
+	irqreturn_t ret = IRQ_NONE;
+	unsigned long flags;
+
+	writeb(1, va_dev->base + VIRTIO_AMBA_INTERRUPT_ACK);
+
+	spin_lock_irqsave(&va_dev->lock, flags);
+	list_for_each_entry(info, &va_dev->virtqueues, node) {
+		if (vring_interrupt(irq, info->vq) == IRQ_HANDLED)
+			ret = IRQ_HANDLED;
+	}
+	spin_unlock_irqrestore(&va_dev->lock, flags);
+
+	return ret;
+}
+
+
+
+static void va_del_vq(struct virtqueue *vq)
+{
+	struct virtio_amba_device *va_dev = to_virtio_amba_device(vq->vdev);
+	struct virtio_amba_vq_info *info = vq->priv;
+	unsigned long flags, size;
+
+	spin_lock_irqsave(&va_dev->lock, flags);
+	list_del(&info->node);
+	spin_unlock_irqrestore(&va_dev->lock, flags);
+
+	writel(info->queue_index, va_dev->base + VIRTIO_AMBA_QUEUE_SEL);
+
+	vring_del_virtqueue(vq);
+
+	/* Select and deactivate the queue */
+	writel(0, va_dev->base + VIRTIO_AMBA_QUEUE_PFN);
+
+	size = PAGE_ALIGN(vring_size(info->num, VIRTIO_AMBA_VRING_ALIGN));
+	free_pages_exact(info->queue, size);
+	kfree(info);
+}
+
+static void va_del_vqs(struct virtio_device *vdev)
+{
+	struct virtio_amba_device *va_dev = to_virtio_amba_device(vdev);
+	struct virtqueue *vq, *n;
+
+	list_for_each_entry_safe(vq, n, &vdev->vqs, list)
+		va_del_vq(vq);
+
+	free_irq(va_dev->amba_dev->irq[0], va_dev);
+}
+
+
+
+static struct virtqueue *va_setup_vq(struct virtio_device *vdev, unsigned index,
+				  void (*callback)(struct virtqueue *vq),
+				  const char *name)
+{
+	struct virtio_amba_device *va_dev = to_virtio_amba_device(vdev);
+	struct virtio_amba_vq_info *info;
+	struct virtqueue *vq;
+	unsigned long flags, size;
+	u16 num;
+	int err;
+
+	/* Select the queue we're interested in */
+	writel(index, va_dev->base + VIRTIO_AMBA_QUEUE_SEL);
+
+	/* Check if queue is either not available or already active. */
+	num = readl(va_dev->base + VIRTIO_AMBA_QUEUE_NUM);
+	if (!num || readl(va_dev->base + VIRTIO_AMBA_QUEUE_PFN)) {
+		err = -ENOENT;
+		goto error_available;
+	}
+
+	/* Allocate and fill out our structure the represents an active
+	 * queue */
+	info = kmalloc(sizeof(struct virtio_amba_vq_info), GFP_KERNEL);
+	if (!info) {
+		err = -ENOMEM;
+		goto error_kmalloc;
+	}
+
+	info->queue_index = index;
+	info->num = num;
+
+	size = PAGE_ALIGN(vring_size(num, VIRTIO_AMBA_VRING_ALIGN));
+	info->queue = alloc_pages_exact(size, GFP_KERNEL | __GFP_ZERO);
+	if (info->queue == NULL) {
+		err = -ENOMEM;
+		goto error_alloc_pages;
+	}
+
+	/* Activate the queue */
+	writel(virt_to_phys(info->queue) >> VIRTIO_AMBA_QUEUE_ADDR_SHIFT,
+		  va_dev->base + VIRTIO_AMBA_QUEUE_PFN);
+
+	/* Create the vring */
+	vq = vring_new_virtqueue(info->num, VIRTIO_AMBA_VRING_ALIGN,
+				 vdev, info->queue, va_notify, callback, name);
+	if (!vq) {
+		err = -ENOMEM;
+		goto error_new_virtqueue;
+	}
+
+	vq->priv = info;
+	info->vq = vq;
+
+	spin_lock_irqsave(&va_dev->lock, flags);
+	list_add(&info->node, &va_dev->virtqueues);
+	spin_unlock_irqrestore(&va_dev->lock, flags);
+
+	return vq;
+
+error_new_virtqueue:
+	writel(0, va_dev->base + VIRTIO_AMBA_QUEUE_PFN);
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
+	struct virtio_amba_device *va_dev = to_virtio_amba_device(vdev);
+	int i, err;
+
+	err = request_irq(va_dev->amba_dev->irq[0], va_interrupt,
+			  IRQF_SHARED, dev_name(&vdev->dev), va_dev);
+	if (err)
+		goto error_request_irq;
+
+	for (i = 0; i < nvqs; ++i) {
+		vqs[i] = va_setup_vq(vdev, i, callbacks[i], names[i]);
+		if (IS_ERR(vqs[i])) {
+			err = PTR_ERR(vqs[i]);
+			goto error_va_setup_vq;
+		}
+	}
+
+	return 0;
+
+error_va_setup_vq:
+	va_del_vqs(vdev);
+error_request_irq:
+	return err;
+}
+
+
+
+static struct virtio_config_ops virtio_amba_config_ops = {
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
+/* AMBA device */
+
+static int __devinit virtio_amba_probe(struct amba_device *amba_dev,
+		const struct amba_id *id)
+{
+	struct virtio_amba_device *va_dev;
+	int err;
+
+	va_dev = kzalloc(sizeof(struct virtio_amba_device), GFP_KERNEL);
+	if (va_dev == NULL) {
+		err = -ENOMEM;
+		goto error_kzalloc;
+	}
+
+	va_dev->vdev.dev.parent = &amba_dev->dev;
+	va_dev->vdev.config = &virtio_amba_config_ops;
+	va_dev->amba_dev = amba_dev;
+	INIT_LIST_HEAD(&va_dev->virtqueues);
+	spin_lock_init(&va_dev->lock);
+
+	err = amba_request_regions(amba_dev, "virtio-amba");
+	if (err)
+		goto error_request_regions;
+
+	va_dev->base = ioremap(amba_dev->res.start,
+			resource_size(&amba_dev->res));
+	if (va_dev->base == NULL)
+		goto error_ioremap;
+
+	/* We use the "Configuration" field in Prime Cell ID
+	 * as the virtio device id. */
+	va_dev->vdev.id.device = amba_config(amba_dev);
+
+	amba_set_drvdata(amba_dev, va_dev);
+
+	err = register_virtio_device(&va_dev->vdev);
+	if (err)
+		goto error_register_virtio_device;
+
+	return 0;
+
+error_register_virtio_device:
+	iounmap(va_dev->base);
+error_ioremap:
+	amba_release_regions(amba_dev);
+error_request_regions:
+	kfree(va_dev);
+error_kzalloc:
+	return err;
+}
+
+static int __devexit virtio_amba_remove(struct amba_device *amba_dev)
+{
+	struct virtio_amba_device *va_dev = amba_get_drvdata(amba_dev);
+
+	unregister_virtio_device(&va_dev->vdev);
+
+	iounmap(va_dev->base);
+	amba_release_regions(amba_dev);
+	kfree(va_dev);
+
+	return 0;
+}
+
+
+
+/* AMBA driver */
+
+static struct amba_id virtio_amba_ids[] = {
+	{
+		.id	= 0x00041730,
+		.mask	= 0x000fffff,
+	},
+	{ 0, 0 }
+};
+
+static struct amba_driver virtio_amba_driver = {
+	.drv.name	= "virtio-amba",
+	.probe		= virtio_amba_probe,
+	.remove		= __devexit_p(virtio_amba_remove),
+	.id_table	= virtio_amba_ids,
+};
+
+static int __init virtio_amba_init(void)
+{
+	return amba_driver_register(&virtio_amba_driver);
+}
+
+static void __exit virtio_amba_exit(void)
+{
+	amba_driver_unregister(&virtio_amba_driver);
+}
+
+module_init(virtio_amba_init);
+module_exit(virtio_amba_exit);
+
+MODULE_AUTHOR("Pawel Moll <pawel.moll@arm.com>");
+MODULE_DESCRIPTION("AMBA bus driver for virtio devices");
+MODULE_LICENSE("GPL");
diff --git a/include/linux/virtio_amba.h b/include/linux/virtio_amba.h
new file mode 100644
index 0000000..c754b87
--- /dev/null
+++ b/include/linux/virtio_amba.h
@@ -0,0 +1,62 @@
+/*
+ * Virtio AMBA driver
+ *
+ * Copyright 2011, ARM Ltd.
+ *
+ * Based on Virtio PCI driver by Anthony Liguori, copyright IBM Corp. 2007
+ *
+ * This header is BSD licensed so anyone can use the definitions to implement
+ * compatible drivers/servers.
+ */
+
+#ifndef _LINUX_VIRTIO_AMBA_H
+#define _LINUX_VIRTIO_AMBA_H
+
+/* Bitmask of the features supported by the host (32-bit register) */
+#define VIRTIO_AMBA_HOST_FEATURES	0x000
+
+/* Bitmask of features activated by the guest (32-bit register) */
+#define VIRTIO_AMBA_GUEST_FEATURES	0x004
+
+/* PFN for the currently selected queue (32-bit register) */
+#define VIRTIO_AMBA_QUEUE_PFN		0x008
+
+/* Queue size for the currently selected queue (32-bit register) */
+#define VIRTIO_AMBA_QUEUE_NUM		0x00c
+
+/* Queue selector (32-bit register) */
+#define VIRTIO_AMBA_QUEUE_SEL		0x010
+
+/* Queue notifier (32-bit register) */
+#define VIRTIO_AMBA_QUEUE_NOTIFY	0x014
+
+/* Interrupt acknowledge (8-bit register) */
+#define VIRTIO_AMBA_INTERRUPT_ACK	0x018
+
+/* Device status register (8-bit register) */
+#define VIRTIO_AMBA_STATUS		0x01c
+
+/* The config space is defined by each driver as
+ * the per-driver configuration space */
+#define VIRTIO_AMBA_CONFIG		0x020
+
+/* PrimeCell identification registers (8-bit registers) */
+#define VIRTIO_AMBA_PERIPH_ID0		0xfe0
+#define VIRTIO_AMBA_PERIPH_ID1		0xfe4
+#define VIRTIO_AMBA_PERIPH_ID2		0xfe8
+#define VIRTIO_AMBA_PERIPH_ID3		0xfec
+#define VIRTIO_AMBA_PCELL_ID0		0xff0
+#define VIRTIO_AMBA_PCELL_ID1		0xff4
+#define VIRTIO_AMBA_PCELL_ID2		0xff8
+#define VIRTIO_AMBA_PCELL_ID3		0xffc
+
+
+/* How many bits to shift physical queue address written to QUEUE_PFN.
+ * 12 is historical, and due to 4kb page size. */
+#define VIRTIO_AMBA_QUEUE_ADDR_SHIFT	12
+
+/* The alignment to use between consumer and producer parts of vring.
+ * Page size again. */
+#define VIRTIO_AMBA_VRING_ALIGN		4096
+
+#endif
-- 
1.6.3.3

