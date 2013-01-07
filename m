Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755872Ab3AGWHV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2013 17:07:21 -0500
Received: from mx1.redhat.com ([209.132.183.28]:27100 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755848Ab3AGWHP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2013 17:07:15 -0500
Subject: [PATCH] vfio-pci: [NOT FOR COMMIT] Add support for legacy MMIO &
 I/O port towards VGA support
To: alex.williamson@redhat.com, kvm@vger.kernel.org
From: Alex Williamson <alex.williamson@redhat.com>
Cc: linux-kernel@vger.kernel.org
Date: Mon, 07 Jan 2013 15:07:14 -0700
Message-ID: <20130107220713.8669.32049.stgit@bling.home>
In-Reply-To: <20130107214605.8669.26237.stgit@bling.home>
References: <20130107214605.8669.26237.stgit@bling.home>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Create two new legacy regions, one for MMIO space below 1MB and
another for 64k of I/O port space.  For devices of PCI class VGA
these ranges will be exposed and allow direct access to the device
at the PCI defined VGA addresses, 0xa0000, 0x3b0, 0x3c0.  VFIO
makes use of the host VGA arbiter to manage host chipset config
to route each access to the correct device.

Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
---
 drivers/vfio/pci/vfio_pci.c         |   74 ++++++++++++---
 drivers/vfio/pci/vfio_pci_private.h |    6 +
 drivers/vfio/pci/vfio_pci_rdwr.c    |  170 +++++++++++++++++++++++++++--------
 include/uapi/linux/vfio.h           |    3 +
 4 files changed, 197 insertions(+), 56 deletions(-)

diff --git a/drivers/vfio/pci/vfio_pci.c b/drivers/vfio/pci/vfio_pci.c
index b28e66c..8a09c33 100644
--- a/drivers/vfio/pci/vfio_pci.c
+++ b/drivers/vfio/pci/vfio_pci.c
@@ -223,9 +223,14 @@ static long vfio_pci_ioctl(void *device_data,
 		if (vdev->reset_works)
 			info.flags |= VFIO_DEVICE_FLAGS_RESET;
 
-		info.num_regions = VFIO_PCI_NUM_REGIONS;
+		info.num_regions = VFIO_PCI_CONFIG_REGION_INDEX + 1;
 		info.num_irqs = VFIO_PCI_NUM_IRQS;
 
+		if ((vdev->pdev->class >> 8) == PCI_CLASS_DISPLAY_VGA) {
+			info.flags |= VFIO_DEVICE_FLAGS_VGA;
+			info.num_regions += 2;
+		}
+
 		return copy_to_user((void __user *)arg, &info, minsz);
 
 	} else if (cmd == VFIO_DEVICE_GET_REGION_INFO) {
@@ -285,6 +290,26 @@ static long vfio_pci_ioctl(void *device_data,
 			info.flags = VFIO_REGION_INFO_FLAG_READ;
 			break;
 		}
+		case VFIO_PCI_LEGACY_MMIO_REGION_INDEX:
+			if ((pdev->class >> 8) != PCI_CLASS_DISPLAY_VGA)
+				return -EINVAL;
+
+			info.offset = VFIO_PCI_INDEX_TO_OFFSET(info.index);
+			info.size = 1024 * 1024;
+			info.flags = VFIO_REGION_INFO_FLAG_READ |
+				     VFIO_REGION_INFO_FLAG_WRITE;
+
+			break;
+		case VFIO_PCI_LEGACY_IOPORT_REGION_INDEX:
+			if ((pdev->class >> 8) != PCI_CLASS_DISPLAY_VGA)
+				return -EINVAL;
+
+			info.offset = VFIO_PCI_INDEX_TO_OFFSET(info.index);
+			info.size = 64 * 1024;
+			info.flags = VFIO_REGION_INFO_FLAG_READ |
+				     VFIO_REGION_INFO_FLAG_WRITE;
+
+			break;
 		default:
 			return -EINVAL;
 		}
@@ -376,14 +401,25 @@ static ssize_t vfio_pci_read(void *device_data, char __user *buf,
 	if (index >= VFIO_PCI_NUM_REGIONS)
 		return -EINVAL;
 
-	if (index == VFIO_PCI_CONFIG_REGION_INDEX)
+	switch (index) {
+	case VFIO_PCI_CONFIG_REGION_INDEX:
 		return vfio_pci_config_readwrite(vdev, buf, count, ppos, false);
-	else if (index == VFIO_PCI_ROM_REGION_INDEX)
-		return vfio_pci_mem_readwrite(vdev, buf, count, ppos, false);
-	else if (pci_resource_flags(pdev, index) & IORESOURCE_IO)
-		return vfio_pci_io_readwrite(vdev, buf, count, ppos, false);
-	else if (pci_resource_flags(pdev, index) & IORESOURCE_MEM)
+	case VFIO_PCI_ROM_REGION_INDEX:
 		return vfio_pci_mem_readwrite(vdev, buf, count, ppos, false);
+	case VFIO_PCI_LEGACY_MMIO_REGION_INDEX:
+		return vfio_pci_legacy_mem_readwrite(vdev, buf, count,
+						     ppos, false);
+	case VFIO_PCI_LEGACY_IOPORT_REGION_INDEX:
+		return vfio_pci_legacy_io_readwrite(vdev, buf, count,
+						    ppos, false);
+	default:
+		if (pci_resource_flags(pdev, index) & IORESOURCE_IO)
+			return vfio_pci_io_readwrite(vdev, buf, count,
+						     ppos, false);
+		if (pci_resource_flags(pdev, index) & IORESOURCE_MEM)
+			return vfio_pci_mem_readwrite(vdev, buf, count,
+						      ppos, false);
+	}
 
 	return -EINVAL;
 }
@@ -398,17 +434,25 @@ static ssize_t vfio_pci_write(void *device_data, const char __user *buf,
 	if (index >= VFIO_PCI_NUM_REGIONS)
 		return -EINVAL;
 
-	if (index == VFIO_PCI_CONFIG_REGION_INDEX)
+	switch (index) {
+	case VFIO_PCI_CONFIG_REGION_INDEX:
 		return vfio_pci_config_readwrite(vdev, (char __user *)buf,
 						 count, ppos, true);
-	else if (index == VFIO_PCI_ROM_REGION_INDEX)
+	case VFIO_PCI_ROM_REGION_INDEX:
 		return -EINVAL;
-	else if (pci_resource_flags(pdev, index) & IORESOURCE_IO)
-		return vfio_pci_io_readwrite(vdev, (char __user *)buf,
-					     count, ppos, true);
-	else if (pci_resource_flags(pdev, index) & IORESOURCE_MEM) {
-		return vfio_pci_mem_readwrite(vdev, (char __user *)buf,
-					      count, ppos, true);
+	case VFIO_PCI_LEGACY_MMIO_REGION_INDEX:
+		return vfio_pci_legacy_mem_readwrite(vdev, buf, count,
+						     ppos, false);
+	case VFIO_PCI_LEGACY_IOPORT_REGION_INDEX:
+		return vfio_pci_legacy_io_readwrite(vdev, buf, count,
+						    ppos, false);
+	default:
+		if (pci_resource_flags(pdev, index) & IORESOURCE_IO)
+			return vfio_pci_io_readwrite(vdev, (char __user *)buf,
+						     count, ppos, true);
+		if (pci_resource_flags(pdev, index) & IORESOURCE_MEM)
+			return vfio_pci_mem_readwrite(vdev, (char __user *)buf,
+						      count, ppos, true);
 	}
 
 	return -EINVAL;
diff --git a/drivers/vfio/pci/vfio_pci_private.h b/drivers/vfio/pci/vfio_pci_private.h
index 611827c..203cf03 100644
--- a/drivers/vfio/pci/vfio_pci_private.h
+++ b/drivers/vfio/pci/vfio_pci_private.h
@@ -79,6 +79,12 @@ extern ssize_t vfio_pci_mem_readwrite(struct vfio_pci_device *vdev,
 extern ssize_t vfio_pci_io_readwrite(struct vfio_pci_device *vdev,
 				     char __user *buf, size_t count,
 				     loff_t *ppos, bool iswrite);
+extern ssize_t vfio_pci_legacy_mem_readwrite(struct vfio_pci_device *vdev,
+					     char __user *buf, size_t count,
+					     loff_t *ppos, bool iswrite);
+extern ssize_t vfio_pci_legacy_io_readwrite(struct vfio_pci_device *vdev,
+					    char __user *buf, size_t count,
+					    loff_t *ppos, bool iswrite);
 
 extern int vfio_pci_init_perm_bits(void);
 extern void vfio_pci_uninit_perm_bits(void);
diff --git a/drivers/vfio/pci/vfio_pci_rdwr.c b/drivers/vfio/pci/vfio_pci_rdwr.c
index 4362d9e..e0c905e 100644
--- a/drivers/vfio/pci/vfio_pci_rdwr.c
+++ b/drivers/vfio/pci/vfio_pci_rdwr.c
@@ -17,72 +17,44 @@
 #include <linux/pci.h>
 #include <linux/uaccess.h>
 #include <linux/io.h>
+#include <linux/vgaarb.h>
 
 #include "vfio_pci_private.h"
 
-/* I/O Port BAR access */
-ssize_t vfio_pci_io_readwrite(struct vfio_pci_device *vdev, char __user *buf,
-			      size_t count, loff_t *ppos, bool iswrite)
+static size_t do_io_rw(void __iomem *io, char __user *buf, size_t off,
+		       size_t count, bool iswrite)
 {
-	struct pci_dev *pdev = vdev->pdev;
-	loff_t pos = *ppos & VFIO_PCI_OFFSET_MASK;
-	int bar = VFIO_PCI_OFFSET_TO_INDEX(*ppos);
-	void __iomem *io;
 	size_t done = 0;
 
-	if (!pci_resource_start(pdev, bar))
-		return -EINVAL;
-
-	if (pos + count > pci_resource_len(pdev, bar))
-		return -EINVAL;
-
-	if (!vdev->barmap[bar]) {
-		int ret;
-
-		ret = pci_request_selected_regions(pdev, 1 << bar, "vfio");
-		if (ret)
-			return ret;
-
-		vdev->barmap[bar] = pci_iomap(pdev, bar, 0);
-
-		if (!vdev->barmap[bar]) {
-			pci_release_selected_regions(pdev, 1 << bar);
-			return -EINVAL;
-		}
-	}
-
-	io = vdev->barmap[bar];
-
 	while (count) {
 		int filled;
 
-		if (count >= 3 && !(pos % 4)) {
+		if (count >= 4 && !(off % 4)) {
 			__le32 val;
 
 			if (iswrite) {
 				if (copy_from_user(&val, buf, 4))
 					return -EFAULT;
 
-				iowrite32(le32_to_cpu(val), io + pos);
+				iowrite32(le32_to_cpu(val), io + off);
 			} else {
-				val = cpu_to_le32(ioread32(io + pos));
+				val = cpu_to_le32(ioread32(io + off));
 
 				if (copy_to_user(buf, &val, 4))
 					return -EFAULT;
 			}
 
 			filled = 4;
-
-		} else if ((pos % 2) == 0 && count >= 2) {
+		} else if (count >= 2 && !(off % 2)) {
 			__le16 val;
 
 			if (iswrite) {
 				if (copy_from_user(&val, buf, 2))
 					return -EFAULT;
 
-				iowrite16(le16_to_cpu(val), io + pos);
+				iowrite16(le16_to_cpu(val), io + off);
 			} else {
-				val = cpu_to_le16(ioread16(io + pos));
+				val = cpu_to_le16(ioread16(io + off));
 
 				if (copy_to_user(buf, &val, 2))
 					return -EFAULT;
@@ -96,9 +68,9 @@ ssize_t vfio_pci_io_readwrite(struct vfio_pci_device *vdev, char __user *buf,
 				if (copy_from_user(&val, buf, 1))
 					return -EFAULT;
 
-				iowrite8(val, io + pos);
+				iowrite8(val, io + off);
 			} else {
-				val = ioread8(io + pos);
+				val = ioread8(io + off);
 
 				if (copy_to_user(buf, &val, 1))
 					return -EFAULT;
@@ -109,11 +81,47 @@ ssize_t vfio_pci_io_readwrite(struct vfio_pci_device *vdev, char __user *buf,
 
 		count -= filled;
 		done += filled;
+		off += filled;
 		buf += filled;
-		pos += filled;
 	}
 
-	*ppos += done;
+	return done;
+}
+
+/* I/O Port BAR access */
+ssize_t vfio_pci_io_readwrite(struct vfio_pci_device *vdev, char __user *buf,
+			      size_t count, loff_t *ppos, bool iswrite)
+{
+	struct pci_dev *pdev = vdev->pdev;
+	loff_t pos = *ppos & VFIO_PCI_OFFSET_MASK;
+	int bar = VFIO_PCI_OFFSET_TO_INDEX(*ppos);
+	size_t done;
+
+	if (!pci_resource_start(pdev, bar))
+		return -EINVAL;
+
+	if (pos + count > pci_resource_len(pdev, bar))
+		return -EINVAL;
+
+	if (!vdev->barmap[bar]) {
+		int ret;
+
+		ret = pci_request_selected_regions(pdev, 1 << bar, "vfio");
+		if (ret)
+			return ret;
+
+		vdev->barmap[bar] = pci_iomap(pdev, bar, 0);
+
+		if (!vdev->barmap[bar]) {
+			pci_release_selected_regions(pdev, 1 << bar);
+			return -EINVAL;
+		}
+	}
+
+	done = do_io_rw(vdev->barmap[bar], buf, pos, count, iswrite);
+
+	if (done >= 0)
+		*ppos += done;
 
 	return done;
 }
@@ -267,3 +275,83 @@ out:
 
 	return count ? -EFAULT : done;
 }
+
+ssize_t vfio_pci_legacy_mem_readwrite(struct vfio_pci_device *vdev,
+				      char __user *buf, size_t count,
+				      loff_t *ppos, bool iswrite)
+{
+	int ret;
+	loff_t pos = *ppos & VFIO_PCI_OFFSET_MASK;
+
+	if ((vdev->pdev->class >> 8) == PCI_CLASS_DISPLAY_VGA &&
+            pos >= 0xa0000 && pos < 0xc0000) {
+		void __iomem *mem;
+		size_t done;
+
+		if (pos + count > 0xc0000)
+			count = 0xc0000 - pos;
+
+		mem = ioremap_nocache(pos, count);
+		if (!mem)
+			return -ENOMEM;
+
+		ret = vga_get_interruptible(vdev->pdev, VGA_RSRC_LEGACY_MEM);
+		if (ret) {
+			iounmap(mem);
+			return ret;
+		}
+
+		done = do_io_rw(mem, buf, 0, count, iswrite);
+
+		vga_put(vdev->pdev, VGA_RSRC_LEGACY_MEM);
+		iounmap(mem);
+
+		if (done >= 0)
+			*ppos += done;
+
+		return done;
+	}
+
+	return -EINVAL;
+}
+
+ssize_t vfio_pci_legacy_io_readwrite(struct vfio_pci_device *vdev,
+				     char __user *buf, size_t count,
+				     loff_t *ppos, bool iswrite)
+{
+	int ret;
+	loff_t pos = *ppos & VFIO_PCI_OFFSET_MASK;
+
+	if ((vdev->pdev->class >> 8) == PCI_CLASS_DISPLAY_VGA &&
+            ((pos >= 0x3b0 && pos < 0x3bc) || (pos >= 0x3c0 && pos < 0x3e0))) {
+		void __iomem *io;
+		size_t done;
+
+		if (pos < 0x3bc && pos + count > 0x3bc)
+			count = 0x3bc - pos;
+		if (pos < 0x3e0 && pos + count > 0x3e0)
+			count = 0x3e0 - pos;
+
+		io = ioport_map(pos, count);
+		if (!io)
+			return -ENOMEM;
+
+		ret = vga_get_interruptible(vdev->pdev, VGA_RSRC_LEGACY_IO);
+		if (ret) {
+			ioport_unmap(io);
+			return ret;
+		}
+
+		done = do_io_rw(io, buf, 0, count, iswrite);
+
+		vga_put(vdev->pdev, VGA_RSRC_LEGACY_IO);
+		ioport_unmap(io);
+
+		if (done >= 0)
+			*ppos += done;
+
+		return done;
+	}
+
+	return -EINVAL;
+}
diff --git a/include/uapi/linux/vfio.h b/include/uapi/linux/vfio.h
index 4758d1b..aa15851 100644
--- a/include/uapi/linux/vfio.h
+++ b/include/uapi/linux/vfio.h
@@ -147,6 +147,7 @@ struct vfio_device_info {
 	__u32	flags;
 #define VFIO_DEVICE_FLAGS_RESET	(1 << 0)	/* Device supports reset */
 #define VFIO_DEVICE_FLAGS_PCI	(1 << 1)	/* vfio-pci device */
+#define VFIO_DEVICE_FLAGS_VGA	(1 << 2)	/* Device supports VGA ranges */
 	__u32	num_regions;	/* Max region index + 1 */
 	__u32	num_irqs;	/* Max IRQ index + 1 */
 };
@@ -303,6 +304,8 @@ enum {
 	VFIO_PCI_BAR5_REGION_INDEX,
 	VFIO_PCI_ROM_REGION_INDEX,
 	VFIO_PCI_CONFIG_REGION_INDEX,
+	VFIO_PCI_LEGACY_MMIO_REGION_INDEX,
+	VFIO_PCI_LEGACY_IOPORT_REGION_INDEX,
 	VFIO_PCI_NUM_REGIONS
 };
 

