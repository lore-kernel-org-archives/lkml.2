Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756590Ab0J3RAN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Oct 2010 13:00:13 -0400
Received: from mx1.redhat.com ([209.132.183.28]:43756 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756027Ab0J3Q7u (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Oct 2010 12:59:50 -0400
From: Alex Williamson <alex.williamson@redhat.com>
Subject: [PATCH 4/5] vfio: Add support for non-PCI 2.3 compliant devices
To: pugs@cisco.com
Cc: linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        kvm@vger.kernel.org, avi@redhat.com, chrisw@redhat.com, mst@redhat.com,
        alex.williamson@redhat.com
Date: Sat, 30 Oct 2010 10:59:48 -0600
Message-ID: <20101030165944.885.7174.stgit@s20.home>
In-Reply-To: <20101030164626.885.89216.stgit@s20.home>
References: <20101030164626.885.89216.stgit@s20.home>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

PCI 2.3 added the interrupt disable bit, which provides us with a
generic way of squelching the device interrupt, and allowing us
to support devices that share interrupts.  We can however support
non-PCI 2.3 devices so long as they can acquire a non-shared
interrupt.  This allows us to use the generic enable/disable_irq
routines and achieve the same goal.

Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
---

 drivers/vfio/vfio_intrs.c |   77 +++++++++++++++++++++++++++++----------------
 drivers/vfio/vfio_main.c  |   13 ++++----
 include/linux/vfio.h      |    2 +
 3 files changed, 57 insertions(+), 35 deletions(-)

diff --git a/drivers/vfio/vfio_intrs.c b/drivers/vfio/vfio_intrs.c
index a57d5aa..4d5a7f8 100644
--- a/drivers/vfio/vfio_intrs.c
+++ b/drivers/vfio/vfio_intrs.c
@@ -52,32 +52,44 @@ irqreturn_t vfio_interrupt(int irq, void *dev_id)
 	u16 origcmd, newcmd, status;
 
 	spin_lock_irq(&vdev->irqlock);
-	pci_block_user_cfg_access(pdev);
-
-	/* Read both command and status registers in a single 32-bit operation.
-	 * Note: we could cache the value for command and move the status read
-	 * out of the lock if there was a way to get notified of user changes
-	 * to command register through sysfs. Should be good for shared irqs. */
-	pci_read_config_dword(pdev, PCI_COMMAND, &cmd_status_dword);
-	origcmd = cmd_status_dword;
-	status = cmd_status_dword >> 16;
-
-	/* Check interrupt status register to see whether our device
-	 * triggered the interrupt. */
-	if (!(status & PCI_STATUS_INTERRUPT))
-		goto done;
-
-	/* We triggered the interrupt, disable it. */
-	newcmd = origcmd | PCI_COMMAND_INTX_DISABLE;
-	if (newcmd != origcmd)
-		pci_write_config_word(pdev, PCI_COMMAND, newcmd);
-
-	ret = IRQ_HANDLED;
+
+	if (vdev->pci_2_3) {
+		pci_block_user_cfg_access(pdev);
+
+		/* Read both command and status registers in a single 32-bit
+		 * operation. Note: we could cache the value for command and
+		 * move the status read out of the lock if there was a way to
+		 * get notified of user changes to command register through
+		 * sysfs. Should be good for shared irqs. */
+		pci_read_config_dword(pdev, PCI_COMMAND, &cmd_status_dword);
+		origcmd = cmd_status_dword;
+		status = cmd_status_dword >> 16;
+
+		/* Check interrupt status register to see whether our device
+	 	* triggered the interrupt. */
+		if (!(status & PCI_STATUS_INTERRUPT))
+			goto done;
+
+		/* We triggered the interrupt, disable it. */
+		newcmd = origcmd | PCI_COMMAND_INTX_DISABLE;
+		if (newcmd != origcmd)
+			pci_write_config_word(pdev, PCI_COMMAND, newcmd);
+
+		ret = IRQ_HANDLED;
 done:
-	pci_unblock_user_cfg_access(pdev);
+		pci_unblock_user_cfg_access(pdev);
+	} else {
+		disable_irq_nosync(pdev->irq);
+		ret = IRQ_HANDLED;
+	}
+
+	vdev->irq_disabled = (ret == IRQ_HANDLED);
+
 	spin_unlock_irq(&vdev->irqlock);
+
 	if (ret != IRQ_HANDLED)
 		return ret;
+
 	if (vdev->ev_irq)
 		eventfd_signal(vdev->ev_irq, 1);
 	return ret;
@@ -86,16 +98,25 @@ done:
 int vfio_irq_eoi(struct vfio_dev *vdev)
 {
 	struct pci_dev *pdev = vdev->pdev;
-	u16 cmd;
 
 	spin_lock_irq(&vdev->irqlock);
-	pci_block_user_cfg_access(pdev);
 
-	pci_read_config_word(pdev, PCI_COMMAND, &cmd);
-	cmd &= ~PCI_COMMAND_INTX_DISABLE;
-	pci_write_config_word(pdev, PCI_COMMAND, cmd);
+	if (vdev->irq_disabled) {
+		if (vdev->pci_2_3) {
+			u16 cmd;
+			pci_block_user_cfg_access(pdev);
+
+			pci_read_config_word(pdev, PCI_COMMAND, &cmd);
+			cmd &= ~PCI_COMMAND_INTX_DISABLE;
+			pci_write_config_word(pdev, PCI_COMMAND, cmd);
+
+			pci_unblock_user_cfg_access(pdev);
+		} else
+			enable_irq(pdev->irq);
+
+		vdev->irq_disabled = false;
+	}
 
-	pci_unblock_user_cfg_access(pdev);
 	spin_unlock_irq(&vdev->irqlock);
 	return 0;
 }
diff --git a/drivers/vfio/vfio_main.c b/drivers/vfio/vfio_main.c
index 72db79c..cf2e671 100644
--- a/drivers/vfio/vfio_main.c
+++ b/drivers/vfio/vfio_main.c
@@ -401,7 +401,8 @@ static long vfio_unl_ioctl(struct file *filep,
 				if (vdev->ev_irq)
 					ret = request_irq(pdev->irq,
 						vfio_interrupt,
-						IRQF_SHARED, vdev->name, vdev);
+						vdev->pci_2_3 ? IRQF_SHARED : 0,
+						vdev->name, vdev);
 				else
 					ret = -EINVAL;
 			}
@@ -567,8 +568,8 @@ static int verify_pci_2_3(struct pci_dev *pdev)
 		return -EBUSY;
 	}
 	if (!((new ^ orig) & PCI_COMMAND_INTX_DISABLE)) {
-		dev_warn(&pdev->dev, "Device does not support "
-			 "disabling interrupts: unable to bind.\n");
+		dev_warn(&pdev->dev, "Device does not support disabling "
+			 "interrupts, exclusive interrupt required.\n");
 		return -ENODEV;
 	}
 	/* Now restore the original value. */
@@ -589,15 +590,13 @@ static int vfio_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	if ((type & 0x7F) != PCI_HEADER_TYPE_NORMAL)
 		return -EINVAL;
 
-	err = verify_pci_2_3(pdev);
-	if (err)
-		return err;
-
 	vdev = kzalloc(sizeof(struct vfio_dev), GFP_KERNEL);
 	if (!vdev)
 		return -ENOMEM;
 	vdev->pdev = pdev;
 
+	vdev->pci_2_3 = (verify_pci_2_3(pdev) == 0);
+
 	mutex_init(&vdev->lgate);
 	mutex_init(&vdev->dgate);
 	mutex_init(&vdev->igate);
diff --git a/include/linux/vfio.h b/include/linux/vfio.h
index 73d7e84..f7e51ff 100644
--- a/include/linux/vfio.h
+++ b/include/linux/vfio.h
@@ -77,6 +77,8 @@ struct vfio_dev {
 	u8		msi_qmax;
 	u8		bardirty;
 	struct perm_bits	*msi_perm;
+	bool		pci_2_3;
+	bool		irq_disabled;
 };
 
 struct vfio_listener {

