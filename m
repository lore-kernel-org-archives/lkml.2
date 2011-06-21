Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756230Ab1FUKSU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jun 2011 06:18:20 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:54803 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755353Ab1FUKSQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jun 2011 06:18:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=a/i0cT9QwybEa94dY/YcENtwZYgJcDH7z0B3Oku+t0DRjCPssMItMd7P7oAyLBOBrZ
         yJQyUQB4bHS/EA1XyU5rohC0JJaJQYzU34qPj0niTYAOvBmmNRtvc90fxtMQpg73mUfT
         bxwrxF1oznA7ndYSB9b/+ltdCKmtsIbk5sC6I=
From: Magnus Damm <magnus.damm@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: vapier@gentoo.org, mst@redhat.com, linux-sh@vger.kernel.org,
        rusty@rustcorp.com.au, virtualization@lists.linux-foundation.org,
        horms@verge.net.au, Magnus Damm <magnus.damm@gmail.com>,
        iws@ovro.caltech.edu
Date: Tue, 21 Jun 2011 19:26:14 +0900
Message-Id: <20110621102614.1382.2547.sendpatchset@t400s>
In-Reply-To: <20110621102605.1382.90232.sendpatchset@t400s>
References: <20110621102605.1382.90232.sendpatchset@t400s>
Subject: [PATCH 01/02] virtio: Break out lguest virtio code to virtio_lguest.c
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Magnus Damm <damm@opensource.se>

This patch breaks out code from lguest_device.c to the new file
virtio_lguest.c. The new file is built when CONFIG_VIRTIO_LGUEST
is selected. The x86 architecture is updated to select this kconfig
variable in the case of lguest.

Needed by the virtio platform driver that shares configuration data
structures with lguest.

Signed-off-by: Magnus Damm <damm@opensource.se>
---

 arch/x86/lguest/Kconfig        |    1 
 drivers/lguest/lguest_device.c |  209 ----------------------------------------
 drivers/virtio/Kconfig         |    2 
 drivers/virtio/Makefile        |    1 
 drivers/virtio/virtio_lguest.c |  205 +++++++++++++++++++++++++++++++++++++++
 include/linux/lguest.h         |    1 
 include/linux/lguest_device.h  |   46 ++++++++
 7 files changed, 258 insertions(+), 207 deletions(-)

--- 0001/arch/x86/lguest/Kconfig
+++ work/arch/x86/lguest/Kconfig	2011-03-03 10:16:11.000000000 +0900
@@ -4,6 +4,7 @@ config LGUEST_GUEST
 	depends on X86_32
 	select VIRTUALIZATION
 	select VIRTIO
+	select VIRTIO_LGUEST
 	select VIRTIO_RING
 	select VIRTIO_CONSOLE
 	help
--- 0001/drivers/lguest/lguest_device.c
+++ work/drivers/lguest/lguest_device.c	2011-03-03 10:16:11.000000000 +0900
@@ -14,6 +14,7 @@
 #include <linux/virtio_config.h>
 #include <linux/interrupt.h>
 #include <linux/virtio_ring.h>
+#include <linux/lguest_device.h>
 #include <linux/err.h>
 #include <linux/slab.h>
 #include <asm/io.h>
@@ -37,137 +38,6 @@ static inline void lguest_unmap(void *ad
 	iounmap((__force void __iomem *)addr);
 }
 
-/*D:100
- * Each lguest device is just a virtio device plus a pointer to its entry
- * in the lguest_devices page.
- */
-struct lguest_device {
-	struct virtio_device vdev;
-
-	/* The entry in the lguest_devices page for this device. */
-	struct lguest_device_desc *desc;
-};
-
-/*
- * Since the virtio infrastructure hands us a pointer to the virtio_device all
- * the time, it helps to have a curt macro to get a pointer to the struct
- * lguest_device it's enclosed in.
- */
-#define to_lgdev(vd) container_of(vd, struct lguest_device, vdev)
-
-/*D:130
- * Device configurations
- *
- * The configuration information for a device consists of one or more
- * virtqueues, a feature bitmap, and some configuration bytes.  The
- * configuration bytes don't really matter to us: the Launcher sets them up, and
- * the driver will look at them during setup.
- *
- * A convenient routine to return the device's virtqueue config array:
- * immediately after the descriptor.
- */
-static struct lguest_vqconfig *lg_vq(const struct lguest_device_desc *desc)
-{
-	return (void *)(desc + 1);
-}
-
-/* The features come immediately after the virtqueues. */
-static u8 *lg_features(const struct lguest_device_desc *desc)
-{
-	return (void *)(lg_vq(desc) + desc->num_vq);
-}
-
-/* The config space comes after the two feature bitmasks. */
-static u8 *lg_config(const struct lguest_device_desc *desc)
-{
-	return lg_features(desc) + desc->feature_len * 2;
-}
-
-/* The total size of the config page used by this device (incl. desc) */
-static unsigned desc_size(const struct lguest_device_desc *desc)
-{
-	return sizeof(*desc)
-		+ desc->num_vq * sizeof(struct lguest_vqconfig)
-		+ desc->feature_len * 2
-		+ desc->config_len;
-}
-
-/* This gets the device's feature bits. */
-static u32 lg_get_features(struct virtio_device *vdev)
-{
-	unsigned int i;
-	u32 features = 0;
-	struct lguest_device_desc *desc = to_lgdev(vdev)->desc;
-	u8 *in_features = lg_features(desc);
-
-	/* We do this the slow but generic way. */
-	for (i = 0; i < min(desc->feature_len * 8, 32); i++)
-		if (in_features[i / 8] & (1 << (i % 8)))
-			features |= (1 << i);
-
-	return features;
-}
-
-/*
- * The virtio core takes the features the Host offers, and copies the ones
- * supported by the driver into the vdev->features array.  Once that's all
- * sorted out, this routine is called so we can tell the Host which features we
- * understand and accept.
- */
-static void lg_finalize_features(struct virtio_device *vdev)
-{
-	unsigned int i, bits;
-	struct lguest_device_desc *desc = to_lgdev(vdev)->desc;
-	/* Second half of bitmap is features we accept. */
-	u8 *out_features = lg_features(desc) + desc->feature_len;
-
-	/* Give virtio_ring a chance to accept features. */
-	vring_transport_features(vdev);
-
-	/*
-	 * The vdev->feature array is a Linux bitmask: this isn't the same as a
-	 * the simple array of bits used by lguest devices for features.  So we
-	 * do this slow, manual conversion which is completely general.
-	 */
-	memset(out_features, 0, desc->feature_len);
-	bits = min_t(unsigned, desc->feature_len, sizeof(vdev->features)) * 8;
-	for (i = 0; i < bits; i++) {
-		if (test_bit(i, vdev->features))
-			out_features[i / 8] |= (1 << (i % 8));
-	}
-}
-
-/* Once they've found a field, getting a copy of it is easy. */
-static void lg_get(struct virtio_device *vdev, unsigned int offset,
-		   void *buf, unsigned len)
-{
-	struct lguest_device_desc *desc = to_lgdev(vdev)->desc;
-
-	/* Check they didn't ask for more than the length of the config! */
-	BUG_ON(offset + len > desc->config_len);
-	memcpy(buf, lg_config(desc) + offset, len);
-}
-
-/* Setting the contents is also trivial. */
-static void lg_set(struct virtio_device *vdev, unsigned int offset,
-		   const void *buf, unsigned len)
-{
-	struct lguest_device_desc *desc = to_lgdev(vdev)->desc;
-
-	/* Check they didn't ask for more than the length of the config! */
-	BUG_ON(offset + len > desc->config_len);
-	memcpy(lg_config(desc) + offset, buf, len);
-}
-
-/*
- * The operations to get and set the status word just access the status field
- * of the device descriptor.
- */
-static u8 lg_get_status(struct virtio_device *vdev)
-{
-	return to_lgdev(vdev)->desc->status;
-}
-
 /*
  * To notify on status updates, we (ab)use the NOTIFY hypercall, with the
  * descriptor address of the device.  A zero status means "reset".
@@ -392,81 +262,6 @@ static struct virtio_config_ops lguest_c
  */
 static struct device *lguest_root;
 
-/*D:120
- * This is the core of the lguest bus: actually adding a new device.
- * It's a separate function because it's neater that way, and because an
- * earlier version of the code supported hotplug and unplug.  They were removed
- * early on because they were never used.
- *
- * As Andrew Tridgell says, "Untested code is buggy code".
- *
- * It's worth reading this carefully: we start with a pointer to the new device
- * descriptor in the "lguest_devices" page, and the offset into the device
- * descriptor page so we can uniquely identify it if things go badly wrong.
- */
-static void add_lguest_device(struct lguest_device_desc *d,
-			      unsigned int offset)
-{
-	struct lguest_device *ldev;
-
-	/* Start with zeroed memory; Linux's device layer counts on it. */
-	ldev = kzalloc(sizeof(*ldev), GFP_KERNEL);
-	if (!ldev) {
-		printk(KERN_EMERG "Cannot allocate lguest dev %u type %u\n",
-		       offset, d->type);
-		return;
-	}
-
-	/* This devices' parent is the lguest/ dir. */
-	ldev->vdev.dev.parent = lguest_root;
-	/*
-	 * The device type comes straight from the descriptor.  There's also a
-	 * device vendor field in the virtio_device struct, which we leave as
-	 * 0.
-	 */
-	ldev->vdev.id.device = d->type;
-	/*
-	 * We have a simple set of routines for querying the device's
-	 * configuration information and setting its status.
-	 */
-	ldev->vdev.config = &lguest_config_ops;
-	/* And we remember the device's descriptor for lguest_config_ops. */
-	ldev->desc = d;
-
-	/*
-	 * register_virtio_device() sets up the generic fields for the struct
-	 * virtio_device and calls device_register().  This makes the bus
-	 * infrastructure look for a matching driver.
-	 */
-	if (register_virtio_device(&ldev->vdev) != 0) {
-		printk(KERN_ERR "Failed to register lguest dev %u type %u\n",
-		       offset, d->type);
-		kfree(ldev);
-	}
-}
-
-/*D:110
- * scan_devices() simply iterates through the device page.  The type 0 is
- * reserved to mean "end of devices".
- */
-static void scan_devices(void)
-{
-	unsigned int i;
-	struct lguest_device_desc *d;
-
-	/* We start at the page beginning, and skip over each entry. */
-	for (i = 0; i < PAGE_SIZE; i += desc_size(d)) {
-		d = lguest_devices + i;
-
-		/* Once we hit a zero, stop. */
-		if (d->type == 0)
-			break;
-
-		printk("Device at %i has size %u\n", i, desc_size(d));
-		add_lguest_device(d, i);
-	}
-}
-
 /*D:105
  * Fairly early in boot, lguest_devices_init() is called to set up the
  * lguest device infrastructure.  We check that we are a Guest by checking
@@ -493,7 +288,7 @@ static int __init lguest_devices_init(vo
 	/* Devices are in a single page above top of "normal" mem */
 	lguest_devices = lguest_map(max_pfn<<PAGE_SHIFT, 1);
 
-	scan_devices();
+	lg_scan_devices(lguest_devices, lguest_root, &lguest_config_ops);
 	return 0;
 }
 /* We do this after core stuff, but before the drivers. */
--- 0001/drivers/virtio/Kconfig
+++ work/drivers/virtio/Kconfig	2011-03-03 10:16:11.000000000 +0900
@@ -33,3 +33,5 @@ config VIRTIO_BALLOON
 
 	 If unsure, say M.
 
+config VIRTIO_LGUEST
+	tristate
--- 0001/drivers/virtio/Makefile
+++ work/drivers/virtio/Makefile	2011-03-03 10:16:11.000000000 +0900
@@ -2,3 +2,4 @@ obj-$(CONFIG_VIRTIO) += virtio.o
 obj-$(CONFIG_VIRTIO_RING) += virtio_ring.o
 obj-$(CONFIG_VIRTIO_PCI) += virtio_pci.o
 obj-$(CONFIG_VIRTIO_BALLOON) += virtio_balloon.o
+obj-$(CONFIG_VIRTIO_LGUEST) += virtio_lguest.o
--- /dev/null
+++ work/drivers/virtio/virtio_lguest.c	2011-03-03 10:16:12.000000000 +0900
@@ -0,0 +1,205 @@
+/*P:050
+ * Lguest guests use a very simple method to describe devices.  It's a
+ * series of device descriptors contained just above the top of normal Guest
+ * memory.
+ *
+ * We use the standard "virtio" device infrastructure, which provides us with a
+ * console, a network and a block driver.  Each one expects some configuration
+ * information and a "virtqueue" or two to send and receive data.
+:*/
+#include <linux/init.h>
+#include <linux/bootmem.h>
+#include <linux/lguest_launcher.h>
+#include <linux/virtio.h>
+#include <linux/virtio_config.h>
+#include <linux/interrupt.h>
+#include <linux/virtio_ring.h>
+#include <linux/lguest_device.h>
+#include <linux/err.h>
+#include <linux/slab.h>
+#include <asm/io.h>
+
+/*D:130
+ * Device configurations
+ *
+ * The configuration information for a device consists of one or more
+ * virtqueues, a feature bitmap, and some configuration bytes.  The
+ * configuration bytes don't really matter to us: the Launcher sets them up, and
+ * the driver will look at them during setup.
+ */
+
+/* The features come immediately after the virtqueues. */
+static u8 *lg_features(const struct lguest_device_desc *desc)
+{
+	return (void *)(lg_vq(desc) + desc->num_vq);
+}
+
+/* The config space comes after the two feature bitmasks. */
+static u8 *lg_config(const struct lguest_device_desc *desc)
+{
+	return lg_features(desc) + desc->feature_len * 2;
+}
+
+/* The total size of the config page used by this device (incl. desc) */
+static unsigned desc_size(const struct lguest_device_desc *desc)
+{
+	return sizeof(*desc)
+		+ desc->num_vq * sizeof(struct lguest_vqconfig)
+		+ desc->feature_len * 2
+		+ desc->config_len;
+}
+
+/* This gets the device's feature bits. */
+u32 lg_get_features(struct virtio_device *vdev)
+{
+	unsigned int i;
+	u32 features = 0;
+	struct lguest_device_desc *desc = to_lgdev(vdev)->desc;
+	u8 *in_features = lg_features(desc);
+
+	/* We do this the slow but generic way. */
+	for (i = 0; i < min(desc->feature_len * 8, 32); i++)
+		if (in_features[i / 8] & (1 << (i % 8)))
+			features |= (1 << i);
+
+	return features;
+}
+
+/*
+ * The virtio core takes the features the Host offers, and copies the ones
+ * supported by the driver into the vdev->features array.  Once that's all
+ * sorted out, this routine is called so we can tell the Host which features we
+ * understand and accept.
+ */
+void lg_finalize_features(struct virtio_device *vdev)
+{
+	unsigned int i, bits;
+	struct lguest_device_desc *desc = to_lgdev(vdev)->desc;
+	/* Second half of bitmap is features we accept. */
+	u8 *out_features = lg_features(desc) + desc->feature_len;
+
+	/* Give virtio_ring a chance to accept features. */
+	vring_transport_features(vdev);
+
+	/*
+	 * The vdev->feature array is a Linux bitmask: this isn't the same as a
+	 * the simple array of bits used by lguest devices for features.  So we
+	 * do this slow, manual conversion which is completely general.
+	 */
+	memset(out_features, 0, desc->feature_len);
+	bits = min_t(unsigned, desc->feature_len, sizeof(vdev->features)) * 8;
+	for (i = 0; i < bits; i++) {
+		if (test_bit(i, vdev->features))
+			out_features[i / 8] |= (1 << (i % 8));
+	}
+}
+
+/* Once they've found a field, getting a copy of it is easy. */
+void lg_get(struct virtio_device *vdev, unsigned int offset,
+	    void *buf, unsigned len)
+{
+	struct lguest_device_desc *desc = to_lgdev(vdev)->desc;
+
+	/* Check they didn't ask for more than the length of the config! */
+	BUG_ON(offset + len > desc->config_len);
+	memcpy(buf, lg_config(desc) + offset, len);
+}
+
+/* Setting the contents is also trivial. */
+void lg_set(struct virtio_device *vdev, unsigned int offset,
+	    const void *buf, unsigned len)
+{
+	struct lguest_device_desc *desc = to_lgdev(vdev)->desc;
+
+	/* Check they didn't ask for more than the length of the config! */
+	BUG_ON(offset + len > desc->config_len);
+	memcpy(lg_config(desc) + offset, buf, len);
+}
+
+/*
+ * The operations to get and set the status word just access the status field
+ * of the device descriptor.
+ */
+u8 lg_get_status(struct virtio_device *vdev)
+{
+	return to_lgdev(vdev)->desc->status;
+}
+
+/*D:120
+ * This is the core of the lguest bus: actually adding a new device.
+ * It's a separate function because it's neater that way, and because an
+ * earlier version of the code supported hotplug and unplug.  They were removed
+ * early on because they were never used.
+ *
+ * As Andrew Tridgell says, "Untested code is buggy code".
+ *
+ * It's worth reading this carefully: we start with a pointer to the new device
+ * descriptor in the "lguest_devices" page, and the offset into the device
+ * descriptor page so we can uniquely identify it if things go badly wrong.
+ */
+static void add_lguest_device(struct lguest_device_desc *d,
+			      unsigned int offset,
+			      struct device *root,
+			      struct virtio_config_ops *ops)
+{
+	struct lguest_device *ldev;
+
+	/* Start with zeroed memory; Linux's device layer counts on it. */
+	ldev = kzalloc(sizeof(*ldev), GFP_KERNEL);
+	if (!ldev) {
+		printk(KERN_EMERG "Cannot allocate lguest dev %u type %u\n",
+		       offset, d->type);
+		return;
+	}
+
+	/* This devices' parent is the lguest/ dir. */
+	ldev->vdev.dev.parent = root;
+	/*
+	 * The device type comes straight from the descriptor.  There's also a
+	 * device vendor field in the virtio_device struct, which we leave as
+	 * 0.
+	 */
+	ldev->vdev.id.device = d->type;
+	/*
+	 * We have a simple set of routines for querying the device's
+	 * configuration information and setting its status.
+	 */
+	ldev->vdev.config = ops;
+	/* And we remember the device's descriptor. */
+	ldev->desc = d;
+
+	/*
+	 * register_virtio_device() sets up the generic fields for the struct
+	 * virtio_device and calls device_register().  This makes the bus
+	 * infrastructure look for a matching driver.
+	 */
+	if (register_virtio_device(&ldev->vdev) != 0) {
+		printk(KERN_ERR "Failed to register lguest dev %u type %u\n",
+		       offset, d->type);
+		kfree(ldev);
+	}
+}
+
+/*D:110
+ * lg_scan_devices() simply iterates through the device page.  The type 0 is
+ * reserved to mean "end of devices".
+ */
+void lg_scan_devices(void *lguest_devices,
+		     struct device *root,
+		     struct virtio_config_ops *ops)
+{
+	unsigned int i;
+	struct lguest_device_desc *d;
+
+	/* We start at the page beginning, and skip over each entry. */
+	for (i = 0; i < PAGE_SIZE; i += desc_size(d)) {
+		d = lguest_devices + i;
+
+		/* Once we hit a zero, stop. */
+		if (d->type == 0)
+			break;
+
+		printk("Device at %i has size %u\n", i, desc_size(d));
+		add_lguest_device(d, i, root, ops);
+	}
+}
--- 0001/include/linux/lguest.h
+++ work/include/linux/lguest.h	2011-03-03 10:16:11.000000000 +0900
@@ -71,5 +71,6 @@ struct lguest_data {
 	unsigned int syscall_vec;
 };
 extern struct lguest_data lguest_data;
+
 #endif /* __ASSEMBLY__ */
 #endif	/* _LINUX_LGUEST_H */
--- /dev/null
+++ work/include/linux/lguest_device.h	2011-03-03 16:07:51.000000000 +0900
@@ -0,0 +1,46 @@
+#ifndef _LINUX_LGUEST_DEVICE_H
+#define _LINUX_LGUEST_DEVICE_H
+
+#include <linux/virtio.h>
+#include <linux/lguest_launcher.h>
+
+/*D:100
+ * Each lguest device is just a virtio device plus a pointer to its entry
+ * in the lguest_devices page.
+ */
+struct lguest_device {
+	struct virtio_device vdev;
+
+	/* The entry in the lguest_devices page for this device. */
+	struct lguest_device_desc *desc;
+};
+
+u32 lg_get_features(struct virtio_device *vdev);
+void lg_finalize_features(struct virtio_device *vdev);
+void lg_get(struct virtio_device *vdev, unsigned int offset,
+	    void *buf, unsigned len);
+void lg_set(struct virtio_device *vdev, unsigned int offset,
+	    const void *buf, unsigned len);
+u8 lg_get_status(struct virtio_device *vdev);
+void lg_scan_devices(void *lguest_devices,
+		     struct device *root,
+		     struct virtio_config_ops *ops);
+
+/*
+ * A convenient routine to return the device's virtqueue config array:
+ * immediately after the descriptor.
+ */
+static inline struct lguest_vqconfig *
+lg_vq(const struct lguest_device_desc *desc)
+{
+	return (void *)(desc + 1);
+}
+
+/*
+ * Since the virtio infrastructure hands us a pointer to the virtio_device all
+ * the time, it helps to have a curt macro to get a pointer to the struct
+ * lguest_device it's enclosed in.
+ */
+#define to_lgdev(vd) container_of(vd, struct lguest_device, vdev)
+
+#endif	/* _LINUX_LGUEST_DEVICE_H */
