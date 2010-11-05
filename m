Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754646Ab0KERao (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Nov 2010 13:30:44 -0400
Received: from mx1.redhat.com ([209.132.183.28]:19219 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752924Ab0KERam (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Nov 2010 13:30:42 -0400
From: Alex Williamson <alex.williamson@redhat.com>
Subject: [PATCH 1/2] vfio: Fix config space virtualization
To: pugs@cisco.com
Cc: linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        kvm@vger.kernel.org, alex.williamson@redhat.com
Date: Fri, 05 Nov 2010 11:30:40 -0600
Message-ID: <20101105173021.1638.59462.stgit@s20.home>
In-Reply-To: <20101105171624.1638.33349.stgit@s20.home>
References: <20101105171624.1638.33349.stgit@s20.home>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We're currently masking out virtualized bits when updating both
physical device registers and vconfig.  I think we really want
vconfig to track virtualized bits, otherwise they're not much
different that unwritable bits.

Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
---

 drivers/vfio/vfio_pci_config.c |  118 ++++++++++------------------------------
 1 files changed, 29 insertions(+), 89 deletions(-)

diff --git a/drivers/vfio/vfio_pci_config.c b/drivers/vfio/vfio_pci_config.c
index 8304316..bb38dbe 100644
--- a/drivers/vfio/vfio_pci_config.c
+++ b/drivers/vfio/vfio_pci_config.c
@@ -820,21 +820,10 @@ static inline int vfio_write_config_byte(struct vfio_dev *vdev,
 }
 
 /* handle virtualized fields in the basic config space */
-static u8 vfio_virt_basic(struct vfio_dev *vdev, int write,
+static void vfio_virt_basic(struct vfio_dev *vdev, int write,
 				u16 pos, u16 off, u8 val, u8 newval)
 {
-	switch (off) {
-	/*
-	 * vendor and device are virt because they don't
-	 * show up otherwise for sr-iov vfs
-	 */
-	case PCI_VENDOR_ID:
-	case PCI_VENDOR_ID + 1:
-	case PCI_DEVICE_ID:
-	case PCI_DEVICE_ID + 1:
-		/* read only */
-		val = vdev->vconfig[pos];
-		break;
+	switch (pos) {
 	case PCI_COMMAND:
 		/*
 		 * If the real mem or IO enable bits are zero
@@ -842,11 +831,15 @@ static u8 vfio_virt_basic(struct vfio_dev *vdev, int write,
 		 * Restore the real BARs before allowing those
 		 * bits to re-enable
 		 */
-		if (vdev->pdev->is_virtfn)
-			val |= PCI_COMMAND_MEMORY;
 		if (write) {
 			int upd = 0;
 
+			if (vfio_read_config_byte(vdev, pos, &val) < 0)
+				return;
+
+			if (vdev->pdev->is_virtfn)
+				val |= PCI_COMMAND_MEMORY;
+
 			upd = (newval & PCI_COMMAND_MEMORY) >
 			      (val & PCI_COMMAND_MEMORY);
 			upd += (newval & PCI_COMMAND_IO) >
@@ -856,61 +849,26 @@ static u8 vfio_virt_basic(struct vfio_dev *vdev, int write,
 			vfio_write_config_byte(vdev, pos, newval);
 		}
 		break;
-	case PCI_BASE_ADDRESS_0:
-	case PCI_BASE_ADDRESS_0+1:
-	case PCI_BASE_ADDRESS_0+2:
-	case PCI_BASE_ADDRESS_0+3:
-	case PCI_BASE_ADDRESS_1:
-	case PCI_BASE_ADDRESS_1+1:
-	case PCI_BASE_ADDRESS_1+2:
-	case PCI_BASE_ADDRESS_1+3:
-	case PCI_BASE_ADDRESS_2:
-	case PCI_BASE_ADDRESS_2+1:
-	case PCI_BASE_ADDRESS_2+2:
-	case PCI_BASE_ADDRESS_2+3:
-	case PCI_BASE_ADDRESS_3:
-	case PCI_BASE_ADDRESS_3+1:
-	case PCI_BASE_ADDRESS_3+2:
-	case PCI_BASE_ADDRESS_3+3:
-	case PCI_BASE_ADDRESS_4:
-	case PCI_BASE_ADDRESS_4+1:
-	case PCI_BASE_ADDRESS_4+2:
-	case PCI_BASE_ADDRESS_4+3:
-	case PCI_BASE_ADDRESS_5:
-	case PCI_BASE_ADDRESS_5+1:
-	case PCI_BASE_ADDRESS_5+2:
-	case PCI_BASE_ADDRESS_5+3:
-	case PCI_ROM_ADDRESS:
-	case PCI_ROM_ADDRESS+1:
-	case PCI_ROM_ADDRESS+2:
-	case PCI_ROM_ADDRESS+3:
+	case PCI_BASE_ADDRESS_0 ... PCI_BASE_ADDRESS_5 + 3:
+	case PCI_ROM_ADDRESS ... PCI_ROM_ADDRESS + 3:
 		if (write) {
-			vdev->vconfig[pos] = newval;
 			vdev->bardirty = 1;
 		} else {
 			if (vdev->bardirty)
 				vfio_bar_fixup(vdev);
-			val = vdev->vconfig[pos];
 		}
 		break;
-	default:
-		if (write)
-			vdev->vconfig[pos] = newval;
-		else
-			val = vdev->vconfig[pos];
-		break;
 	}
-	return val;
 }
 
 /*
  * handle virtualized fields in msi capability
  * easy, except for multiple-msi fields in flags byte
  */
-static u8 vfio_virt_msi(struct vfio_dev *vdev, int write,
+static void vfio_virt_msi(struct vfio_dev *vdev, int write,
 				u16 pos, u16 off, u8 val, u8 newval)
 {
-	if (off == PCI_MSI_FLAGS) {
+	if (pos == PCI_MSI_FLAGS) {
 		u8 num;
 
 		if (write) {
@@ -924,18 +882,12 @@ static u8 vfio_virt_msi(struct vfio_dev *vdev, int write,
 			vfio_write_config_byte(vdev, pos, newval);
 		} else {
 			if (vfio_read_config_byte(vdev, pos, &val) < 0)
-				return 0;
+				return;
 			val &= ~PCI_MSI_FLAGS_QMASK;
 			val |= vdev->msi_qmax << 1;
+			vdev->vconfig[pos] = val;
 		}
-		return val;
 	}
-
-	if (write)
-		vdev->vconfig[pos] = newval;
-	else
-		val = vdev->vconfig[pos];
-	return val;
 }
 
 static int vfio_config_rwbyte(int write,
@@ -1014,25 +966,25 @@ static int vfio_config_rwbyte(int write,
 		return 0;
 	}
 
+	val = vdev->vconfig[pos];
 	if (write) {
+		u8 pval, rbits = (~virt) & wr;
+
 		if (copy_from_user(&newval, buf, 1))
 			return -EFAULT;
-	}
-	/*
-	 * We get here if there are some virt bits
-	 * handle remaining real bits, if any
-	 */
-	if (~virt) {
-		u8 rbits = (~virt) & wr;
 
-		ret = vfio_read_config_byte(vdev, pos, &val);
+		ret = vfio_read_config_byte(vdev, pos, &pval);
 		if (ret < 0)
 			return ret;
-		if (write && rbits) {
-			val &= ~rbits;
-			val |= (newval & rbits);
-			vfio_write_config_byte(vdev, pos, val);
+
+		if (rbits) {
+			pval &= ~rbits;
+			pval |= (newval & rbits);
+			pci_user_write_config_byte(vdev->pdev, pos, pval);
 		}
+		vdev->vconfig[pos] = (pval & ~(virt | wr)) |
+				     (val & (virt & ~wr)) |
+				     (newval & wr);
 	}
 	/*
 	 * Now handle entirely virtual fields
@@ -1040,32 +992,20 @@ static int vfio_config_rwbyte(int write,
 	if (pos < PCI_CFG_SPACE_SIZE) {
 		switch (cap) {
 		case PCI_CAP_ID_BASIC:	/* virtualize BARs */
-			val = vfio_virt_basic(vdev, write,
-						pos, off, val, newval);
+			vfio_virt_basic(vdev, write, pos, off, val, newval);
 			break;
 		case PCI_CAP_ID_MSI:	/* virtualize (parts of) MSI */
-			val = vfio_virt_msi(vdev, write,
-						pos, off, val, newval);
-			break;
-		default:
-			if (write)
-				vdev->vconfig[pos] = newval;
-			else
-				val = vdev->vconfig[pos];
+			vfio_virt_msi(vdev, write, pos, off, val, newval);
 			break;
 		}
 	} else {
 		/* no virt fields yet in ecaps */
 		switch (cap) {	/* extended capabilities */
 		default:
-			if (write)
-				vdev->vconfig[pos] = newval;
-			else
-				val = vdev->vconfig[pos];
 			break;
 		}
 	}
-	if (!write && copy_to_user(buf, &val, 1))
+	if (!write && copy_to_user(buf, &vdev->vconfig[pos], 1))
 		return -EFAULT;
 	return 0;
 }

