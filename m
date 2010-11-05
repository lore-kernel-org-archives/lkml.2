Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754717Ab0KERbQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Nov 2010 13:31:16 -0400
Received: from mx1.redhat.com ([209.132.183.28]:20995 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753176Ab0KERbN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Nov 2010 13:31:13 -0400
From: Alex Williamson <alex.williamson@redhat.com>
Subject: [PATCH 2/2] vfio: Virtualize PCI_COMMAND_INTX_DISABLE
To: pugs@cisco.com
Cc: linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        kvm@vger.kernel.org, alex.williamson@redhat.com
Date: Fri, 05 Nov 2010 11:31:11 -0600
Message-ID: <20101105173046.1638.57539.stgit@s20.home>
In-Reply-To: <20101105171624.1638.33349.stgit@s20.home>
References: <20101105171624.1638.33349.stgit@s20.home>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As we use this internally for interrupt control, it's dangerous
to let the user manipulate it.  Instead, virtualize it.  Also,
de-assert INTX_DISABLE when device is opened, the device reset
doesn't seem to clear this.

Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
---

 drivers/vfio/vfio_intrs.c      |   38 +++++++++++++++++++++++++++-----------
 drivers/vfio/vfio_main.c       |   14 +++++++++++++-
 drivers/vfio/vfio_pci_config.c |   13 +++++++++++--
 include/linux/vfio.h           |    4 ++++
 4 files changed, 55 insertions(+), 14 deletions(-)

diff --git a/drivers/vfio/vfio_intrs.c b/drivers/vfio/vfio_intrs.c
index 73e3deb..ace0195 100644
--- a/drivers/vfio/vfio_intrs.c
+++ b/drivers/vfio/vfio_intrs.c
@@ -47,23 +47,22 @@
 /*
  * vfio_interrupt - IRQ hardware interrupt handler
  */
-irqreturn_t vfio_interrupt(int irq, void *dev_id)
+irqreturn_t vfio_disable_intx(struct vfio_dev *vdev)
 {
-	struct vfio_dev *vdev = dev_id;
 	struct pci_dev *pdev = vdev->pdev;
 	irqreturn_t ret = IRQ_NONE;
-	u32 cmd_status_dword;
-	u16 origcmd, newcmd, status;
 
 	spin_lock_irq(&vdev->irqlock);
 
-	/* INTX disabled interrupts can still be shared */
 	if (vdev->irq_disabled) {
 		spin_unlock_irq(&vdev->irqlock);
 		return ret;
 	}
 
 	if (vdev->pci_2_3) {
+		u32 cmd_status_dword;
+		u16 origcmd, newcmd, status;
+
 		pci_block_user_cfg_access(pdev);
 
 		/* Read both command and status registers in a single 32-bit
@@ -98,15 +97,10 @@ done:
 
 	spin_unlock_irq(&vdev->irqlock);
 
-	if (ret != IRQ_HANDLED)
-		return ret;
-
-	if (vdev->ev_irq)
-		eventfd_signal(vdev->ev_irq, 1);
 	return ret;
 }
 
-int vfio_irq_eoi(struct vfio_dev *vdev)
+void vfio_enable_intx(struct vfio_dev *vdev)
 {
 	struct pci_dev *pdev = vdev->pdev;
 
@@ -129,6 +123,28 @@ int vfio_irq_eoi(struct vfio_dev *vdev)
 	}
 
 	spin_unlock_irq(&vdev->irqlock);
+}
+
+irqreturn_t vfio_interrupt(int irq, void *dev_id)
+{
+	struct vfio_dev *vdev = dev_id;
+	irqreturn_t ret = vfio_disable_intx(vdev);
+
+	if (ret != IRQ_HANDLED)
+		return ret;
+
+	if (vdev->ev_irq)
+		eventfd_signal(vdev->ev_irq, 1);
+	return ret;
+}
+
+int vfio_irq_eoi(struct vfio_dev *vdev)
+{
+	/* EOI shouldn't re-enable intx if disabled by INTX_DISABLE */
+	if (vdev->vconfig[PCI_COMMAND+1] & PCI_CMD_INTX_DISABLE_BYTE)
+		return 0;
+
+	vfio_enable_intx(vdev);
 	return 0;
 }
 
diff --git a/drivers/vfio/vfio_main.c b/drivers/vfio/vfio_main.c
index 3cd3cb8..3f51eae 100644
--- a/drivers/vfio/vfio_main.c
+++ b/drivers/vfio/vfio_main.c
@@ -110,8 +110,14 @@ static int vfio_open(struct inode *inode, struct file *filep)
 	listener->vdev = vdev;
 	INIT_LIST_HEAD(&listener->dm_list);
 	if (vdev->listeners == 0) {
+		u16 cmd;
 		(void) pci_reset_function(vdev->pdev);
 		msleep(100);	/* 100ms for reset recovery */
+		pci_read_config_word(vdev->pdev, PCI_COMMAND, &cmd);
+		if (vdev->pci_2_3 && (cmd & PCI_COMMAND_INTX_DISABLE)) {
+			cmd &= ~PCI_COMMAND_INTX_DISABLE;
+			pci_write_config_word(vdev->pdev, PCI_COMMAND, cmd);
+		}
 		ret = pci_enable_device(vdev->pdev);
 	}
 	if (!ret) {
@@ -172,6 +178,7 @@ static int vfio_release(struct inode *inode, struct file *filep)
 			free_irq(vdev->pdev->irq, vdev);
 			eventfd_ctx_put(vdev->ev_irq);
 			vdev->ev_irq = NULL;
+			vdev->irq_disabled = false;
 		}
 		kfree(vdev->vconfig);
 		vdev->vconfig = NULL;
@@ -391,6 +398,7 @@ static long vfio_unl_ioctl(struct file *filep,
 		if (vdev->ev_irq) {
 			eventfd_ctx_put(vdev->ev_irq);
 			free_irq(pdev->irq, vdev);
+			vdev->irq_disabled = false;
 			vdev->ev_irq = NULL;
 		}
 		if (vdev->ev_msi) {	/* irq and msi both use pdev->irq */
@@ -398,11 +406,15 @@ static long vfio_unl_ioctl(struct file *filep,
 		} else {
 			if (fd >= 0) {
 				vdev->ev_irq = eventfd_ctx_fdget(fd);
-				if (vdev->ev_irq)
+				if (vdev->ev_irq) {
 					ret = request_irq(pdev->irq,
 						vfio_interrupt,
 						vdev->pci_2_3 ? IRQF_SHARED : 0,
 						vdev->name, vdev);
+					if (vdev->vconfig[PCI_COMMAND+1] &
+					    PCI_CMD_INTX_DISABLE_BYTE)
+						vfio_disable_intx(vdev);
+				}
 				else
 					ret = -EINVAL;
 			}
diff --git a/drivers/vfio/vfio_pci_config.c b/drivers/vfio/vfio_pci_config.c
index bb38dbe..6257070 100644
--- a/drivers/vfio/vfio_pci_config.c
+++ b/drivers/vfio/vfio_pci_config.c
@@ -185,8 +185,8 @@ static int __init init_pci_cap_basic_perm(struct perm_bits *perm)
 
 	/* for catching resume-after-reset */
 	p_setw(perm, PCI_COMMAND,
-			PCI_COMMAND_MEMORY + PCI_COMMAND_IO,
-			ALL_WRITE);
+		PCI_COMMAND_MEMORY + PCI_COMMAND_IO + PCI_COMMAND_INTX_DISABLE,
+		ALL_WRITE);
 
 	/* no harm to write */
 	p_setb(perm, PCI_CACHE_LINE_SIZE,	NO_VIRT,  ALL_WRITE);
@@ -849,6 +849,15 @@ static void vfio_virt_basic(struct vfio_dev *vdev, int write,
 			vfio_write_config_byte(vdev, pos, newval);
 		}
 		break;
+	case PCI_COMMAND + 1:
+		if (write) {
+			if ((newval & PCI_CMD_INTX_DISABLE_BYTE) &&
+			    !(val & PCI_CMD_INTX_DISABLE_BYTE))
+				vfio_disable_intx(vdev);
+			if (!(newval & PCI_CMD_INTX_DISABLE_BYTE) &&
+			    (val & PCI_CMD_INTX_DISABLE_BYTE))
+				vfio_enable_intx(vdev);
+		}
 	case PCI_BASE_ADDRESS_0 ... PCI_BASE_ADDRESS_5 + 3:
 	case PCI_ROM_ADDRESS ... PCI_ROM_ADDRESS + 3:
 		if (write) {
diff --git a/include/linux/vfio.h b/include/linux/vfio.h
index c26f3b3..28da636 100644
--- a/include/linux/vfio.h
+++ b/include/linux/vfio.h
@@ -163,6 +163,10 @@ int vfio_irq_eoi(struct vfio_dev *);
 int vfio_irq_eoi_eventfd(struct vfio_dev *, int);
 int vfio_eoi_module_init(void);
 void vfio_eoi_module_exit(void);
+irqreturn_t vfio_disable_intx(struct vfio_dev *vdev);
+void vfio_enable_intx(struct vfio_dev *vdev);
+
+#define PCI_CMD_INTX_DISABLE_BYTE (PCI_COMMAND_INTX_DISABLE >> 8)
 
 #endif	/* __KERNEL__ */
 

