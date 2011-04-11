Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754127Ab1DKQ4C (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Apr 2011 12:56:02 -0400
Received: from mx1.redhat.com ([209.132.183.28]:5587 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753817Ab1DKQ4A (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Apr 2011 12:56:00 -0400
Date: Mon, 11 Apr 2011 19:55:25 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Rusty Russell <rusty@rustcorp.com.au>, Carsten Otte <cotte@de.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>, linux390@de.ibm.com,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        "Michael S. Tsirkin" <mst@redhat.com>, lguest@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org,
        virtualization@lists.linux-foundation.org
Subject: [RFC][PATCH] virtio: 64 bit features
Message-ID: <20110411165525.GA1395@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Extend features to 64 bit so we can use more
transport bits.

Future patches add two new feature bits which would
exhaust the supply of transport feature bits,
so let's add bit 31 to tell the guest that
there are now 64 worth of features.

For PCI this also changes the config layout.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
---
 drivers/lguest/lguest_device.c |    8 ++++----
 drivers/s390/kvm/kvm_virtio.c  |    6 +++---
 drivers/virtio/virtio.c        |    8 ++++----
 drivers/virtio/virtio_pci.c    |   33 +++++++++++++++++++++++++++------
 include/linux/virtio.h         |    2 +-
 include/linux/virtio_config.h  |   15 +++++++++------
 include/linux/virtio_pci.h     |    9 ++++++++-
 7 files changed, 56 insertions(+), 25 deletions(-)

diff --git a/drivers/lguest/lguest_device.c b/drivers/lguest/lguest_device.c
index 69c84a1..d2d6953 100644
--- a/drivers/lguest/lguest_device.c
+++ b/drivers/lguest/lguest_device.c
@@ -93,17 +93,17 @@ static unsigned desc_size(const struct lguest_device_desc *desc)
 }
 
 /* This gets the device's feature bits. */
-static u32 lg_get_features(struct virtio_device *vdev)
+static u64 lg_get_features(struct virtio_device *vdev)
 {
 	unsigned int i;
-	u32 features = 0;
+	u64 features = 0;
 	struct lguest_device_desc *desc = to_lgdev(vdev)->desc;
 	u8 *in_features = lg_features(desc);
 
 	/* We do this the slow but generic way. */
-	for (i = 0; i < min(desc->feature_len * 8, 32); i++)
+	for (i = 0; i < min(desc->feature_len * 8, 64); i++)
 		if (in_features[i / 8] & (1 << (i % 8)))
-			features |= (1 << i);
+			features |= (1ull << i);
 
 	return features;
 }
diff --git a/drivers/s390/kvm/kvm_virtio.c b/drivers/s390/kvm/kvm_virtio.c
index 414427d..8c976d0 100644
--- a/drivers/s390/kvm/kvm_virtio.c
+++ b/drivers/s390/kvm/kvm_virtio.c
@@ -82,13 +82,13 @@ static unsigned desc_size(const struct kvm_device_desc *desc)
 static u32 kvm_get_features(struct virtio_device *vdev)
 {
 	unsigned int i;
-	u32 features = 0;
+	u64 features = 0;
 	struct kvm_device_desc *desc = to_kvmdev(vdev)->desc;
 	u8 *in_features = kvm_vq_features(desc);
 
-	for (i = 0; i < min(desc->feature_len * 8, 32); i++)
+	for (i = 0; i < min(desc->feature_len * 8, 64); i++)
 		if (in_features[i / 8] & (1 << (i % 8)))
-			features |= (1 << i);
+			features |= (1ull << i);
 	return features;
 }
 
diff --git a/drivers/virtio/virtio.c b/drivers/virtio/virtio.c
index efb35aa..52b24d7 100644
--- a/drivers/virtio/virtio.c
+++ b/drivers/virtio/virtio.c
@@ -112,7 +112,7 @@ static int virtio_dev_probe(struct device *_d)
 	struct virtio_device *dev = container_of(_d,struct virtio_device,dev);
 	struct virtio_driver *drv = container_of(dev->dev.driver,
 						 struct virtio_driver, driver);
-	u32 device_features;
+	u64 device_features;
 
 	/* We have a driver! */
 	add_status(dev, VIRTIO_CONFIG_S_DRIVER);
@@ -124,14 +124,14 @@ static int virtio_dev_probe(struct device *_d)
 	memset(dev->features, 0, sizeof(dev->features));
 	for (i = 0; i < drv->feature_table_size; i++) {
 		unsigned int f = drv->feature_table[i];
-		BUG_ON(f >= 32);
-		if (device_features & (1 << f))
+		BUG_ON(f >= 64);
+		if (device_features & (1ull << f))
 			set_bit(f, dev->features);
 	}
 
 	/* Transport features always preserved to pass to finalize_features. */
 	for (i = VIRTIO_TRANSPORT_F_START; i < VIRTIO_TRANSPORT_F_END; i++)
-		if (device_features & (1 << i))
+		if (device_features & (1ull << i))
 			set_bit(i, dev->features);
 
 	dev->config->finalize_features(dev);
diff --git a/drivers/virtio/virtio_pci.c b/drivers/virtio/virtio_pci.c
index 4fb5b2b..2a2ee72 100644
--- a/drivers/virtio/virtio_pci.c
+++ b/drivers/virtio/virtio_pci.c
@@ -44,6 +44,8 @@ struct virtio_pci_device
 	spinlock_t lock;
 	struct list_head virtqueues;
 
+	/* 64 bit features */
+	int features_hi;
 	/* MSI-X support */
 	int msix_enabled;
 	int intx_enabled;
@@ -103,26 +105,45 @@ static struct virtio_pci_device *to_vp_device(struct virtio_device *vdev)
 }
 
 /* virtio config->get_features() implementation */
-static u32 vp_get_features(struct virtio_device *vdev)
+static u64 vp_get_features(struct virtio_device *vdev)
 {
 	struct virtio_pci_device *vp_dev = to_vp_device(vdev);
+	u32 flo, fhi;
 
-	/* When someone needs more than 32 feature bits, we'll need to
+	/* When someone needs more than 32 feature bits, we need to
 	 * steal a bit to indicate that the rest are somewhere else. */
-	return ioread32(vp_dev->ioaddr + VIRTIO_PCI_HOST_FEATURES);
+	flo = ioread32(vp_dev->ioaddr + VIRTIO_PCI_HOST_FEATURES);
+	if (flo & (0x1 << VIRTIO_F_FEATURES_HI)) {
+		vp_dev->features_hi = 1;
+		iowrite32(0x1 << VIRTIO_F_FEATURES_HI,
+			  vp_dev->ioaddr + VIRTIO_PCI_GUEST_FEATURES_HI);
+	} else {
+		vp_dev->features_hi = 0;
+	}
+	fhi = ioread32(vp_dev->ioaddr + VIRTIO_PCI_HOST_FEATURES_HI);
+	return ((u64)fhi << 32) | flo;
 }
 
 /* virtio config->finalize_features() implementation */
 static void vp_finalize_features(struct virtio_device *vdev)
 {
 	struct virtio_pci_device *vp_dev = to_vp_device(vdev);
+	u32 flo, fhi;
 
 	/* Give virtio_ring a chance to accept features. */
 	vring_transport_features(vdev);
 
-	/* We only support 32 feature bits. */
-	BUILD_BUG_ON(ARRAY_SIZE(vdev->features) != 1);
-	iowrite32(vdev->features[0], vp_dev->ioaddr+VIRTIO_PCI_GUEST_FEATURES);
+	/* We only support 64 feature bits. */
+	BUILD_BUG_ON(ARRAY_SIZE(vdev->features) != 64 / BITS_PER_LONG);
+	flo = vdev->features[0];
+	fhi = vdev->features[64 / BITS_PER_LONG - 1] >> (64 - BITS_PER_LONG);
+	iowrite32(flo, vp_dev->ioaddr + VIRTIO_PCI_GUEST_FEATURES);
+	if (flo & (0x1 << VIRTIO_F_FEATURES_HI)) {
+		vp_dev->features_hi = 1;
+		iowrite32(fhi, vp_dev->ioaddr + VIRTIO_PCI_GUEST_FEATURES_HI);
+	} else {
+		vp_dev->features_hi = 0;
+	}
 }
 
 /* virtio config->get() implementation */
diff --git a/include/linux/virtio.h b/include/linux/virtio.h
index aff5b4f..718336b 100644
--- a/include/linux/virtio.h
+++ b/include/linux/virtio.h
@@ -105,7 +105,7 @@ struct virtio_device {
 	struct virtio_config_ops *config;
 	struct list_head vqs;
 	/* Note that this is a Linux set_bit-style bitmap. */
-	unsigned long features[1];
+	unsigned long features[64 / BITS_PER_LONG];
 	void *priv;
 };
 
diff --git a/include/linux/virtio_config.h b/include/linux/virtio_config.h
index 800617b..b1a1981 100644
--- a/include/linux/virtio_config.h
+++ b/include/linux/virtio_config.h
@@ -18,16 +18,19 @@
 /* We've given up on this device. */
 #define VIRTIO_CONFIG_S_FAILED		0x80
 
-/* Some virtio feature bits (currently bits 28 through 31) are reserved for the
+/* Some virtio feature bits (currently bits 28 through 39) are reserved for the
  * transport being used (eg. virtio_ring), the rest are per-device feature
  * bits. */
 #define VIRTIO_TRANSPORT_F_START	28
-#define VIRTIO_TRANSPORT_F_END		32
+#define VIRTIO_TRANSPORT_F_END		40
 
 /* Do we get callbacks when the ring is completely used, even if we've
  * suppressed them? */
 #define VIRTIO_F_NOTIFY_ON_EMPTY	24
 
+/* Enables feature bits 32 to 63 (only really required for virtio_pci). */
+#define VIRTIO_F_FEATURES_HI		31
+
 #ifdef __KERNEL__
 #include <linux/err.h>
 #include <linux/virtio.h>
@@ -72,7 +75,7 @@
  * @del_vqs: free virtqueues found by find_vqs().
  * @get_features: get the array of feature bits for this device.
  *	vdev: the virtio_device
- *	Returns the first 32 feature bits (all we currently need).
+ *	Returns the first 64 feature bits (all we currently need).
  * @finalize_features: confirm what device features we'll be using.
  *	vdev: the virtio_device
  *	This gives the final feature bits for the device: it can change
@@ -92,7 +95,7 @@ struct virtio_config_ops {
 			vq_callback_t *callbacks[],
 			const char *names[]);
 	void (*del_vqs)(struct virtio_device *);
-	u32 (*get_features)(struct virtio_device *vdev);
+	u64 (*get_features)(struct virtio_device *vdev);
 	void (*finalize_features)(struct virtio_device *vdev);
 };
 
@@ -110,9 +113,9 @@ static inline bool virtio_has_feature(const struct virtio_device *vdev,
 {
 	/* Did you forget to fix assumptions on max features? */
 	if (__builtin_constant_p(fbit))
-		BUILD_BUG_ON(fbit >= 32);
+		BUILD_BUG_ON(fbit >= 64);
 	else
-		BUG_ON(fbit >= 32);
+		BUG_ON(fbit >= 64);
 
 	if (fbit < VIRTIO_TRANSPORT_F_START)
 		virtio_check_driver_offered_feature(vdev, fbit);
diff --git a/include/linux/virtio_pci.h b/include/linux/virtio_pci.h
index 9a3d7c4..035b10e 100644
--- a/include/linux/virtio_pci.h
+++ b/include/linux/virtio_pci.h
@@ -55,9 +55,16 @@
 /* Vector value used to disable MSI for queue */
 #define VIRTIO_MSI_NO_VECTOR            0xffff
 
+/* An extended 32-bit r/o bitmask of the features supported by the host */
+#define VIRTIO_PCI_HOST_FEATURES_HI	0
+
+/* An extended 32-bit r/w bitmask of features activated by the guest */
+#define VIRTIO_PCI_GUEST_FEATURES_HI	4
+
 /* The remaining space is defined by each driver as the per-driver
  * configuration space */
-#define VIRTIO_PCI_CONFIG(dev)		((dev)->msix_enabled ? 24 : 20)
+#define VIRTIO_PCI_CONFIG(dev)		((dev)->features_hi ? 32 : \
+						(dev)->msix_enabled ? 24 : 20)
 
 /* Virtio ABI version, this must match exactly */
 #define VIRTIO_PCI_ABI_VERSION		0
-- 
1.7.5.rc1.1.gc22ff
