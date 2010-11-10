Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754394Ab0KJBJS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Nov 2010 20:09:18 -0500
Received: from sj-iport-5.cisco.com ([171.68.10.87]:1943 "EHLO
	sj-iport-5.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753665Ab0KJBJO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Nov 2010 20:09:14 -0500
Authentication-Results: sj-iport-5.cisco.com; dkim=neutral (message not signed) header.i=none
X-IronPort-AV: E=Sophos;i="4.59,176,1288569600"; 
   d="scan'208";a="283653732"
Date: Tue, 09 Nov 2010 17:09:42 -0800
From: Tom Lyon <pugs@cisco.com>
To: alex.williamson@redhat.com
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Subject: [PATCH] vfio: fix config virtualization, esp command byte
Message-ID: <4cd9f0d6.jnHBr6PBphKwDwhM%pugs@cisco.com>
User-Agent: Heirloom mailx 12.2 01/07/07
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cleans up config space virtualization, especialy handling of bytes
which have some virtual and some real bits, like PCI_COMMAND.

Alex, I hope you can test this with your setups.

Signed-off-by: Tom Lyon <pugs@cisco.com>
---
 drivers/vfio/vfio_pci_config.c |  166 +++++++++++++---------------------------
 1 files changed, 53 insertions(+), 113 deletions(-)

diff --git a/drivers/vfio/vfio_pci_config.c b/drivers/vfio/vfio_pci_config.c
index 8304316..7132ac4 100644
--- a/drivers/vfio/vfio_pci_config.c
+++ b/drivers/vfio/vfio_pci_config.c
@@ -745,6 +745,8 @@ static int vfio_virt_init(struct vfio_dev *vdev)
  */
 static void vfio_bar_restore(struct vfio_dev *vdev)
 {
+	if (vdev->pdev->is_virtfn)
+		return;
 	printk(KERN_WARNING "%s: reset recovery - restoring bars\n", __func__);
 
 #define do_bar(off, which) \
@@ -815,26 +817,15 @@ static inline int vfio_read_config_byte(struct vfio_dev *vdev,
 static inline int vfio_write_config_byte(struct vfio_dev *vdev,
 					int pos, u8 val)
 {
-	vdev->vconfig[pos] = val;
 	return pci_user_write_config_byte(vdev->pdev, pos, val);
 }
 
 /* handle virtualized fields in the basic config space */
-static u8 vfio_virt_basic(struct vfio_dev *vdev, int write,
-				u16 pos, u16 off, u8 val, u8 newval)
+static void vfio_virt_basic(struct vfio_dev *vdev, int write, u16 pos, u8 *rbp)
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
+	u8 val;
+
+	switch (pos) {
 	case PCI_COMMAND:
 		/*
 		 * If the real mem or IO enable bits are zero
@@ -842,100 +833,58 @@ static u8 vfio_virt_basic(struct vfio_dev *vdev, int write,
 		 * Restore the real BARs before allowing those
 		 * bits to re-enable
 		 */
+		val = vdev->vconfig[pos];
 		if (vdev->pdev->is_virtfn)
 			val |= PCI_COMMAND_MEMORY;
 		if (write) {
-			int upd = 0;
-
-			upd = (newval & PCI_COMMAND_MEMORY) >
-			      (val & PCI_COMMAND_MEMORY);
-			upd += (newval & PCI_COMMAND_IO) >
-			       (val & PCI_COMMAND_IO);
-			if (upd)
-				vfio_bar_restore(vdev);
-			vfio_write_config_byte(vdev, pos, newval);
-		}
-		break;
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
-		if (write) {
-			vdev->vconfig[pos] = newval;
-			vdev->bardirty = 1;
-		} else {
-			if (vdev->bardirty)
-				vfio_bar_fixup(vdev);
-			val = vdev->vconfig[pos];
+
+			if (((val & PCI_COMMAND_MEMORY) >
+				(*rbp & PCI_COMMAND_MEMORY)) ||
+			    ((val & PCI_COMMAND_IO) >
+				(*rbp & PCI_COMMAND_IO)))
+					vfio_bar_restore(vdev);
+			*rbp &= ~(PCI_COMMAND_MEMORY + PCI_COMMAND_IO);
+			*rbp |= val & (PCI_COMMAND_MEMORY + PCI_COMMAND_IO);
 		}
+		vdev->vconfig[pos] = val;
 		break;
-	default:
+	case PCI_BASE_ADDRESS_0 ... PCI_BASE_ADDRESS_5 + 3:
+	case PCI_ROM_ADDRESS ... PCI_ROM_ADDRESS + 3:
 		if (write)
-			vdev->vconfig[pos] = newval;
-		else
-			val = vdev->vconfig[pos];
+			vdev->bardirty = 1;
+		else if (vdev->bardirty)
+			vfio_bar_fixup(vdev);
 		break;
 	}
-	return val;
 }
 
 /*
  * handle virtualized fields in msi capability
  * easy, except for multiple-msi fields in flags byte
  */
-static u8 vfio_virt_msi(struct vfio_dev *vdev, int write,
-				u16 pos, u16 off, u8 val, u8 newval)
+static void vfio_virt_msi(struct vfio_dev *vdev, int write,
+				u16 pos, u16 off, u8 *rbp)
 {
-	if (off == PCI_MSI_FLAGS) {
-		u8 num;
+	u8 val;
+	u8 num;
 
+	val = vdev->vconfig[pos];
+	if (off == PCI_MSI_FLAGS) {
 		if (write) {
 			if (!vdev->ev_msi)
-				newval &= ~PCI_MSI_FLAGS_ENABLE;
-			num = (newval & PCI_MSI_FLAGS_QSIZE) >> 4;
+				val &= ~PCI_MSI_FLAGS_ENABLE;
+			num = (val & PCI_MSI_FLAGS_QSIZE) >> 4;
 			if (num > vdev->msi_qmax)
 				num = vdev->msi_qmax;
-			newval &= ~PCI_MSI_FLAGS_QSIZE;
-			newval |= num << 4;
-			vfio_write_config_byte(vdev, pos, newval);
+			val &= ~PCI_MSI_FLAGS_QSIZE;
+			val |= num << 4;
+			*rbp = val;
 		} else {
-			if (vfio_read_config_byte(vdev, pos, &val) < 0)
-				return 0;
 			val &= ~PCI_MSI_FLAGS_QMASK;
 			val |= vdev->msi_qmax << 1;
 		}
-		return val;
 	}
-
-	if (write)
-		vdev->vconfig[pos] = newval;
-	else
-		val = vdev->vconfig[pos];
-	return val;
+	vdev->vconfig[pos] = val;
 }
 
 static int vfio_config_rwbyte(int write,
@@ -950,6 +899,7 @@ static int vfio_config_rwbyte(int write,
 	struct perm_bits *perm;
 	u8 wr, virt;
 	int ret;
+	u8 realbits = 0;
 
 	cap = map[pos];
 	if (cap == 0xFF) {	/* unknown region */
@@ -989,7 +939,7 @@ static int vfio_config_rwbyte(int write,
 	}
 	if (write && !wr)		/* no writeable bits */
 		return 0;
-	if (!virt) {
+	if (!virt) {			/* no virtual bits */
 		if (write) {
 			if (copy_from_user(&val, buf, 1))
 				return -EFAULT;
@@ -1018,54 +968,44 @@ static int vfio_config_rwbyte(int write,
 		if (copy_from_user(&newval, buf, 1))
 			return -EFAULT;
 	}
-	/*
-	 * We get here if there are some virt bits
-	 * handle remaining real bits, if any
-	 */
-	if (~virt) {
-		u8 rbits = (~virt) & wr;
 
-		ret = vfio_read_config_byte(vdev, pos, &val);
+	if (~virt) {	/* mix of real and virt bits */
+		/* update vconfig with latest hw bits */
+		ret = vfio_read_config_byte(vdev, pos, &realbits);
 		if (ret < 0)
 			return ret;
-		if (write && rbits) {
-			val &= ~rbits;
-			val |= (newval & rbits);
-			vfio_write_config_byte(vdev, pos, val);
-		}
+		vdev->vconfig[pos] =
+			(vdev->vconfig[pos] & virt) | (realbits & ~virt);
 	}
+
+	/* update vconfig with writeable bits */
+	vdev->vconfig[pos] =
+		(vdev->vconfig[pos] & ~wr) | (newval & wr);
+
 	/*
-	 * Now handle entirely virtual fields
+	 * Now massage virtual fields
 	 */
 	if (pos < PCI_CFG_SPACE_SIZE) {
 		switch (cap) {
 		case PCI_CAP_ID_BASIC:	/* virtualize BARs */
-			val = vfio_virt_basic(vdev, write,
-						pos, off, val, newval);
+			vfio_virt_basic(vdev, write, pos, &realbits);
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
+			vfio_virt_msi(vdev, write, pos, off, &realbits);
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
+	if (write && ~virt) {
+		realbits = (realbits & virt) | (vdev->vconfig[pos] & ~virt);
+		vfio_write_config_byte(vdev, pos, realbits);
+	}
+	if (!write && copy_to_user(buf, &vdev->vconfig[pos], 1))
 		return -EFAULT;
 	return 0;
 }
-- 
1.6.0.2

