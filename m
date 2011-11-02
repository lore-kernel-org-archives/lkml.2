Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754022Ab1KBXah (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Nov 2011 19:30:37 -0400
Received: from mx1.redhat.com ([209.132.183.28]:61082 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752614Ab1KBXag (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Nov 2011 19:30:36 -0400
Date: Thu, 3 Nov 2011 01:31:11 +0200
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Sasha Levin <levinsasha928@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Alexey Kardashevskiy <aik@ozlabs.ru>, Amit Shah <amit.shah@redhat.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Krishna Kumar <krkumar2@in.ibm.com>, Pawel Moll <pawel.moll@arm.com>,
        Wang Sheng-Hui <shhuiw@gmail.com>,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        virtualization@lists.linux-foundation.org, kvm@vger.kernel.org
Subject: [PATCH RFC] virtio-pci: flexible configuration layout
Message-ID: <20111102233110.GA20289@redhat.com>
References: <87wrbkvh3v.fsf@rustcorp.com.au>
 <20111101114542.GA13434@redhat.com>
 <1320150813.3847.24.camel@lappy>
 <20111101124223.GA14060@redhat.com>
 <8739e7uy87.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8739e7uy87.fsf@rustcorp.com.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a flexible mechanism to specify virtio configuration layout, using
pci vendor-specific capability.  A separate capability is used for each
of common, device specific and data-path accesses.

Warning: compiled only.
This patch also needs to be split up, pci_iomap changes
also need arch updates for non-x86.

We also will need to update the spec.

See the first chunk for layout documentation.

Posting here for early feedback.

In particular:

Do we need to require offset to be aligned?
Does iowrite16 work with unaligned accesses on all architectures?
Does using ioread/write as we do add overhead as compared to
plain PIO accesses?

Jesse - are you OK with the pci_iomap_range API proposed here
(see last chunks)?
I noticed lots of architectures duplicate the implementation
of pci_iomap - makes sense to clean that up?

Thanks,

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>

---

diff --git a/include/linux/virtio_pci.h b/include/linux/virtio_pci.h
index ea66f3f..b8a9de2 100644
--- a/include/linux/virtio_pci.h
+++ b/include/linux/virtio_pci.h
@@ -92,4 +92,38 @@
 /* The alignment to use between consumer and producer parts of vring.
  * x86 pagesize again. */
 #define VIRTIO_PCI_VRING_ALIGN		4096
+
+/*
+ * Layout for Virtio PCI vendor specific capability (little-endian):
+ * 5 bit virtio capability id.
+ * 3 bit BAR index register, specifying which BAR to use.
+ * 4 byte cfg offset within the BAR.
+ * 4 byte cfg size.
+ */
+
+/* A single virtio device has multiple vendor specific capabilities, we use the
+ * 5 bit ID field to distinguish between these. */
+#define VIRTIO_PCI_CAP_ID		3
+#define VIRTIO_PCI_CAP_ID_MASK		0x1f
+#define VIRTIO_PCI_CAP_ID_SHIFT		0
+
+/* IDs for different capabilities. If a specific configuration
+ * is missing, legacy PIO path is used. */
+/* Common configuration */
+#define VIRTIO_PCI_CAP_COMMON_CFG	0
+/* Device specific confiuration */
+#define VIRTIO_PCI_CAP_DEVICE_CFG	1
+/* Notifications and ISR access */
+#define VIRTIO_PCI_CAP_NOTIFY_CFG	2
+
+/* Index of the BAR including this configuration */
+#define VIRTIO_PCI_CAP_CFG_BIR		3
+#define VIRTIO_PCI_CAP_CFG_BIR_MASK	(0x7)
+#define VIRTIO_PCI_CAP_CFG_BIR_SHIFT	5
+
+/* Offset within the BAR */
+#define VIRTIO_PCI_CAP_CFG_OFF		4
+/* Size of the configuration space */
+#define VIRTIO_PCI_CAP_CFG_SIZE		8
+
 #endif
diff --git a/drivers/virtio/virtio_pci.c b/drivers/virtio/virtio_pci.c
index 4bcc8b8..d4ed130 100644
--- a/drivers/virtio/virtio_pci.c
+++ b/drivers/virtio/virtio_pci.c
@@ -37,8 +37,12 @@ struct virtio_pci_device
 	struct virtio_device vdev;
 	struct pci_dev *pci_dev;
 
-	/* the IO mapping for the PCI config space */
+	/* the IO address for the common PCI config space */
 	void __iomem *ioaddr;
+	/* the IO address for device specific config */
+	void __iomem *ioaddr_device;
+	/* the IO address to use for notifications operations */
+	void __iomem *ioaddr_notify;
 
 	/* a list of queues so we can dispatch IRQs */
 	spinlock_t lock;
@@ -57,8 +61,142 @@ struct virtio_pci_device
 	unsigned msix_used_vectors;
 	/* Whether we have vector per vq */
 	bool per_vq_vectors;
+
+	/* Various IO mappings: used for resource tracking only. */
+
+	/* Legacy BAR0: typically PIO. */
+	void __iomem *legacy_map;
+
+	/* Mappings specified by device capabilities: typically in MMIO */
+	void __iomem *notify_map;
+	void __iomem *common_map;
+	void __iomem *device_map;
 };
 
+/*
+ * With PIO, device-specific config moves as MSI-X is enabled/disabled.
+ * Use this accessor to keep pointer to that config in sync.
+ */
+static void virtio_pci_set_msix_enabled(struct virtio_pci_device *vp_dev, int enabled)
+{
+	vp_dev->msix_enabled = enabled;
+	if (vp_dev->device_map)
+		vp_dev->ioaddr_device = vp_dev->device_map;
+	else
+		vp_dev->ioaddr_device = vp_dev->legacy_map +
+			VIRTIO_PCI_CONFIG(vp_dev);
+}
+
+static void __iomem *virtio_pci_map_cfg(struct virtio_pci_device *vp_dev, u8 cap_id)
+{
+        u32 size;
+        u32 offset;
+        u8 bir;
+        u8 cap_len;
+	int pos;
+	struct pci_dev *dev = vp_dev->pci_dev;
+	void __iomem *p;
+
+	for (pos = pci_find_capability(dev, PCI_CAP_ID_VNDR);
+	     pos > 0;
+	     pos = pci_find_next_capability(dev, pos, PCI_CAP_ID_VNDR)) {
+		u8 id;
+		pci_read_config_byte(dev, pos + PCI_VNDR_CAP_LEN, &cap_len);
+		if (cap_len < VIRTIO_PCI_CAP_ID + 1)
+			continue;
+		pci_read_config_byte(dev, pos + VIRTIO_PCI_CAP_ID, &id);
+		id >>= VIRTIO_PCI_CAP_ID_SHIFT;
+		id &= VIRTIO_PCI_CAP_ID_MASK;
+		if (id == cap_id)
+			break;
+	}
+
+	if (pos <= 0)
+		return NULL;
+
+	if (cap_len < VIRTIO_PCI_CAP_CFG_BIR + 1)
+		goto err;
+        pci_read_config_byte(dev, pos + VIRTIO_PCI_CAP_CFG_BIR, &bir);
+	if (cap_len < VIRTIO_PCI_CAP_CFG_OFF + 4)
+		goto err;
+        pci_read_config_dword(dev, pos + VIRTIO_PCI_CAP_CFG_OFF, &offset);
+	if (cap_len < VIRTIO_PCI_CAP_CFG_SIZE + 4)
+		goto err;
+        pci_read_config_dword(dev, pos + VIRTIO_PCI_CAP_CFG_SIZE, &size);
+        bir >>= VIRTIO_PCI_CAP_CFG_BIR_SHIFT;
+        bir &= VIRTIO_PCI_CAP_CFG_BIR_MASK;
+
+	/* It's possible for a device to supply a huge config space,
+	 * but we'll never need to map more than a page ATM. */
+	p = pci_iomap_range(dev, bir, offset, size, PAGE_SIZE);
+	if (!p)
+		dev_err(&vp_dev->vdev.dev, "Unable to map virtio pci memory");
+	return p;
+err:
+	dev_err(&vp_dev->vdev.dev, "Unable to parse virtio pci capability");
+	return NULL;
+}
+
+static void virtio_pci_iounmap(struct virtio_pci_device *vp_dev)
+{
+	if (vp_dev->legacy_map)
+		pci_iounmap(vp_dev->pci_dev, vp_dev->legacy_map);
+	if (vp_dev->notify_map)
+		pci_iounmap(vp_dev->pci_dev, vp_dev->notify_map);
+	if (vp_dev->common_map)
+		pci_iounmap(vp_dev->pci_dev, vp_dev->common_map);
+	if (vp_dev->device_map)
+		pci_iounmap(vp_dev->pci_dev, vp_dev->device_map);
+}
+
+static int virtio_pci_iomap(struct virtio_pci_device *vp_dev)
+{
+	vp_dev->notify_map = virtio_pci_map_cfg(vp_dev,
+						     VIRTIO_PCI_CAP_NOTIFY_CFG);
+	vp_dev->common_map = virtio_pci_map_cfg(vp_dev,
+						     VIRTIO_PCI_CAP_COMMON_CFG);
+	vp_dev->device_map = virtio_pci_map_cfg(vp_dev,
+						     VIRTIO_PCI_CAP_DEVICE_CFG);
+
+	if (!vp_dev->notify_map || !vp_dev->common_map ||
+	    !vp_dev->device_map) {
+		/*
+		 * If not all capabilities present, map legacy PIO.
+		 * Legacy access is at BAR 0. We never need to map
+		 * more than 256 bytes there, since legacy config space
+		 * used PIO which has this size limit.
+		 * */
+		vp_dev->legacy_map = pci_iomap(vp_dev->pci_dev, 0, 256);
+		if (!vp_dev->legacy_map) {
+			dev_err(&vp_dev->vdev.dev, "Unable to map legacy PIO");
+			goto err;
+		}
+	}
+
+	/* Prefer MMIO if available. If not, fallback to legacy PIO. */
+	if (vp_dev->common_map)
+		vp_dev->ioaddr = vp_dev->common_map;
+	else
+		vp_dev->ioaddr = vp_dev->legacy_map;
+
+	if (vp_dev->device_map)
+		vp_dev->ioaddr_device = vp_dev->device_map;
+	else
+		vp_dev->ioaddr_device = vp_dev->legacy_map +
+			VIRTIO_PCI_CONFIG(vp_dev);
+
+	if (vp_dev->notify_map)
+		vp_dev->ioaddr_notify = vp_dev->notify_map;
+	else
+		vp_dev->ioaddr_notify = vp_dev->legacy_map +
+			VIRTIO_PCI_QUEUE_NOTIFY;
+
+	return 0;
+err:
+	virtio_pci_iounmap(vp_dev);
+	return -EINVAL;
+}
+
 /* Constants for MSI-X */
 /* Use first vector for configuration changes, second and the rest for
  * virtqueues Thus, we need at least 2 vectors for MSI. */
@@ -130,8 +268,7 @@ static void vp_get(struct virtio_device *vdev, unsigned offset,
 		   void *buf, unsigned len)
 {
 	struct virtio_pci_device *vp_dev = to_vp_device(vdev);
-	void __iomem *ioaddr = vp_dev->ioaddr +
-				VIRTIO_PCI_CONFIG(vp_dev) + offset;
+	void __iomem *ioaddr = vp_dev->ioaddr_device + offset;
 	u8 *ptr = buf;
 	int i;
 
@@ -145,8 +282,7 @@ static void vp_set(struct virtio_device *vdev, unsigned offset,
 		   const void *buf, unsigned len)
 {
 	struct virtio_pci_device *vp_dev = to_vp_device(vdev);
-	void __iomem *ioaddr = vp_dev->ioaddr +
-				VIRTIO_PCI_CONFIG(vp_dev) + offset;
+	void __iomem *ioaddr = vp_dev->ioaddr_device + offset;
 	const u8 *ptr = buf;
 	int i;
 
@@ -184,7 +320,7 @@ static void vp_notify(struct virtqueue *vq)
 
 	/* we write the queue's selector into the notification register to
 	 * signal the other end */
-	iowrite16(info->queue_index, vp_dev->ioaddr + VIRTIO_PCI_QUEUE_NOTIFY);
+	iowrite16(info->queue_index, vp_dev->ioaddr_notify);
 }
 
 /* Handle a configuration change: Tell driver if it wants to know. */
@@ -231,7 +367,8 @@ static irqreturn_t vp_interrupt(int irq, void *opaque)
 
 	/* reading the ISR has the effect of also clearing it so it's very
 	 * important to save off the value. */
-	isr = ioread8(vp_dev->ioaddr + VIRTIO_PCI_ISR);
+	isr = ioread8(vp_dev->ioaddr_notify +
+		      VIRTIO_PCI_ISR - VIRTIO_PCI_QUEUE_NOTIFY);
 
 	/* It's definitely not us if the ISR was not high */
 	if (!isr)
@@ -265,7 +402,7 @@ static void vp_free_vectors(struct virtio_device *vdev)
 		ioread16(vp_dev->ioaddr + VIRTIO_MSI_CONFIG_VECTOR);
 
 		pci_disable_msix(vp_dev->pci_dev);
-		vp_dev->msix_enabled = 0;
+                virtio_pci_set_msix_enabled(vp_dev, 0);
 		vp_dev->msix_vectors = 0;
 	}
 
@@ -303,7 +440,7 @@ static int vp_request_msix_vectors(struct virtio_device *vdev, int nvectors,
 	if (err)
 		goto error;
 	vp_dev->msix_vectors = nvectors;
-	vp_dev->msix_enabled = 1;
+        virtio_pci_set_msix_enabled(vp_dev, 1);
 
 	/* Set the vector used for configuration */
 	v = vp_dev->msix_used_vectors;
@@ -447,7 +584,10 @@ static void vp_del_vq(struct virtqueue *vq)
 		iowrite16(VIRTIO_MSI_NO_VECTOR,
 			  vp_dev->ioaddr + VIRTIO_MSI_QUEUE_VECTOR);
 		/* Flush the write out to device */
-		ioread8(vp_dev->ioaddr + VIRTIO_PCI_ISR);
+		ioread8(vp_dev->ioaddr + VIRTIO_MSI_QUEUE_VECTOR);
+		/* And clear ISR: TODO: really needed? */
+		ioread8(vp_dev->ioaddr_notify +
+		      VIRTIO_PCI_ISR - VIRTIO_PCI_QUEUE_NOTIFY);
 	}
 
 	vring_del_virtqueue(vq);
@@ -638,8 +778,8 @@ static int __devinit virtio_pci_probe(struct pci_dev *pci_dev,
 	if (err)
 		goto out_enable_device;
 
-	vp_dev->ioaddr = pci_iomap(pci_dev, 0, 0);
-	if (vp_dev->ioaddr == NULL)
+	err = virtio_pci_iomap(vp_dev);
+	if (err)
 		goto out_req_regions;
 
 	pci_set_drvdata(pci_dev, vp_dev);
@@ -661,7 +801,7 @@ static int __devinit virtio_pci_probe(struct pci_dev *pci_dev,
 
 out_set_drvdata:
 	pci_set_drvdata(pci_dev, NULL);
-	pci_iounmap(pci_dev, vp_dev->ioaddr);
+	virtio_pci_iounmap(vp_dev);
 out_req_regions:
 	pci_release_regions(pci_dev);
 out_enable_device:
@@ -679,7 +819,7 @@ static void __devexit virtio_pci_remove(struct pci_dev *pci_dev)
 
 	vp_del_vqs(&vp_dev->vdev);
 	pci_set_drvdata(pci_dev, NULL);
-	pci_iounmap(pci_dev, vp_dev->ioaddr);
+	virtio_pci_iounmap(vp_dev);
 	pci_release_regions(pci_dev);
 	pci_disable_device(pci_dev);
 }
diff --git a/include/asm-generic/io.h b/include/asm-generic/io.h
index 9120887..3cf1787 100644
--- a/include/asm-generic/io.h
+++ b/include/asm-generic/io.h
@@ -286,6 +286,10 @@ static inline void writesb(const void __iomem *addr, const void *buf, int len)
 /* Create a virtual mapping cookie for a PCI BAR (memory or IO) */
 struct pci_dev;
 extern void __iomem *pci_iomap(struct pci_dev *dev, int bar, unsigned long max);
+extern void __iomem *pci_iomap_range(struct pci_dev *dev, int bar,
+                                     unsigned offset,
+                                     unsigned long minlen,
+                                     unsigned long maxlen);
 static inline void pci_iounmap(struct pci_dev *dev, void __iomem *p)
 {
 }
diff --git a/include/asm-generic/iomap.h b/include/asm-generic/iomap.h
index 98dcd76..6f192d4 100644
--- a/include/asm-generic/iomap.h
+++ b/include/asm-generic/iomap.h
@@ -70,8 +70,19 @@ extern void ioport_unmap(void __iomem *);
 /* Create a virtual mapping cookie for a PCI BAR (memory or IO) */
 struct pci_dev;
 extern void __iomem *pci_iomap(struct pci_dev *dev, int bar, unsigned long max);
+extern void __iomem *pci_iomap_range(struct pci_dev *dev, int bar,
+                                     unsigned offset,
+                                     unsigned long minlen,
+                                     unsigned long maxlen);
 extern void pci_iounmap(struct pci_dev *dev, void __iomem *);
 #else
+static inline void __iomem *pci_iomap_range(struct pci_dev *dev, int bar,
+                                            unsigned offset,
+                                            unsigned long minlen,
+                                            unsigned long maxlen)
+{
+	return NULL;
+}
 struct pci_dev;
 static inline void __iomem *pci_iomap(struct pci_dev *dev, int bar, unsigned long max)
 {
diff --git a/include/linux/pci_regs.h b/include/linux/pci_regs.h
index e884096..2ec9f81 100644
--- a/include/linux/pci_regs.h
+++ b/include/linux/pci_regs.h
@@ -375,6 +375,10 @@
 #define  PCI_X_STATUS_266MHZ	0x40000000	/* 266 MHz capable */
 #define  PCI_X_STATUS_533MHZ	0x80000000	/* 533 MHz capable */
 
+/* Vendor specific capability */
+#define PCI_VNDR_CAP_LEN	2	/* Capability length (8 bits), including
+					   bytes: ID, NEXT and LEN itself. */
+
 /* PCI Bridge Subsystem ID registers */
 
 #define PCI_SSVID_VENDOR_ID     4	/* PCI-Bridge subsystem vendor id register */
diff --git a/lib/iomap.c b/lib/iomap.c
index 5dbcb4b..f28720e 100644
--- a/lib/iomap.c
+++ b/lib/iomap.c
@@ -243,26 +243,36 @@ EXPORT_SYMBOL(ioport_unmap);
 
 #ifdef CONFIG_PCI
 /**
- * pci_iomap - create a virtual mapping cookie for a PCI BAR
+ * pci_iomap_range - create a virtual mapping cookie for a PCI BAR
  * @dev: PCI device that owns the BAR
  * @bar: BAR number
- * @maxlen: length of the memory to map
+ * @offset: map memory at the given offset in BAR
+ * @minlen: min length of the memory to map
+ * @maxlen: max length of the memory to map
  *
  * Using this function you will get a __iomem address to your device BAR.
  * You can access it using ioread*() and iowrite*(). These functions hide
  * the details if this is a MMIO or PIO address space and will just do what
  * you expect from them in the correct way.
  *
+ * @minlen specifies the minimum length to map. We check that BAR is
+ * large enough.
  * @maxlen specifies the maximum length to map. If you want to get access to
- * the complete BAR without checking for its length first, pass %0 here.
+ * the complete BAR from offset to the end, pass %0 here.
  * */
-void __iomem *pci_iomap(struct pci_dev *dev, int bar, unsigned long maxlen)
+void __iomem *pci_iomap_range(struct pci_dev *dev, int bar,
+                              unsigned offset,
+                              unsigned long minlen,
+                              unsigned long maxlen)
 {
 	resource_size_t start = pci_resource_start(dev, bar);
 	resource_size_t len = pci_resource_len(dev, bar);
 	unsigned long flags = pci_resource_flags(dev, bar);
 
-	if (!len || !start)
+	if (len <= offset || !start)
+		return NULL;
+        len -= offset;
+        if (len < minlen)
 		return NULL;
 	if (maxlen && len > maxlen)
 		len = maxlen;
@@ -277,10 +287,30 @@ void __iomem *pci_iomap(struct pci_dev *dev, int bar, unsigned long maxlen)
 	return NULL;
 }
 
+/**
+ * pci_iomap - create a virtual mapping cookie for a PCI BAR
+ * @dev: PCI device that owns the BAR
+ * @bar: BAR number
+ * @maxlen: length of the memory to map
+ *
+ * Using this function you will get a __iomem address to your device BAR.
+ * You can access it using ioread*() and iowrite*(). These functions hide
+ * the details if this is a MMIO or PIO address space and will just do what
+ * you expect from them in the correct way.
+ *
+ * @maxlen specifies the maximum length to map. If you want to get access to
+ * the complete BAR without checking for its length first, pass %0 here.
+ * */
+void __iomem *pci_iomap(struct pci_dev *dev, int bar, unsigned long maxlen)
+{
+    return pci_iomap_range(dev, bar, 0, 0, maxlen);
+}
+
 void pci_iounmap(struct pci_dev *dev, void __iomem * addr)
 {
 	IO_COND(addr, /* nothing */, iounmap(addr));
 }
 EXPORT_SYMBOL(pci_iomap);
+EXPORT_SYMBOL(pci_iomap_range);
 EXPORT_SYMBOL(pci_iounmap);
 #endif /* CONFIG_PCI */

-- 
MST
