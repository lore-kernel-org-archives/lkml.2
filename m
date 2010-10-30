Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755878Ab0J3Q7o (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Oct 2010 12:59:44 -0400
Received: from mx1.redhat.com ([209.132.183.28]:16681 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755698Ab0J3Q7k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Oct 2010 12:59:40 -0400
From: Alex Williamson <alex.williamson@redhat.com>
Subject: [PATCH 3/5] vfio: Add ioctl to re-enable interrupts
To: pugs@cisco.com
Cc: linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        kvm@vger.kernel.org, avi@redhat.com, chrisw@redhat.com, mst@redhat.com,
        alex.williamson@redhat.com
Date: Sat, 30 Oct 2010 10:59:38 -0600
Message-ID: <20101030165929.885.47408.stgit@s20.home>
In-Reply-To: <20101030164626.885.89216.stgit@s20.home>
References: <20101030164626.885.89216.stgit@s20.home>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Clearing the INTx disable bit from userspace requires two ioctls,
we can do it from vfio with only one.  This also better defines the
API and allows us to support non-PCI-2.3 compliant devices.

Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
---

 drivers/vfio/vfio_intrs.c |   17 +++++++++++++++++
 drivers/vfio/vfio_main.c  |    4 ++++
 include/linux/vfio.h      |    3 +++
 3 files changed, 24 insertions(+), 0 deletions(-)

diff --git a/drivers/vfio/vfio_intrs.c b/drivers/vfio/vfio_intrs.c
index aaee175..a57d5aa 100644
--- a/drivers/vfio/vfio_intrs.c
+++ b/drivers/vfio/vfio_intrs.c
@@ -83,6 +83,23 @@ done:
 	return ret;
 }
 
+int vfio_irq_eoi(struct vfio_dev *vdev)
+{
+	struct pci_dev *pdev = vdev->pdev;
+	u16 cmd;
+
+	spin_lock_irq(&vdev->irqlock);
+	pci_block_user_cfg_access(pdev);
+
+	pci_read_config_word(pdev, PCI_COMMAND, &cmd);
+	cmd &= ~PCI_COMMAND_INTX_DISABLE;
+	pci_write_config_word(pdev, PCI_COMMAND, cmd);
+
+	pci_unblock_user_cfg_access(pdev);
+	spin_unlock_irq(&vdev->irqlock);
+	return 0;
+}
+
 /*
  * MSI and MSI-X Interrupt handler.
  * Just signal an event
diff --git a/drivers/vfio/vfio_main.c b/drivers/vfio/vfio_main.c
index f671795..72db79c 100644
--- a/drivers/vfio/vfio_main.c
+++ b/drivers/vfio/vfio_main.c
@@ -464,6 +464,10 @@ static long vfio_unl_ioctl(struct file *filep,
 		ret = vfio_domain_unset(vdev);
 		break;
 
+	case VFIO_IRQ_EOI:
+		ret = vfio_irq_eoi(vdev);
+		break;
+
 	default:
 		return -EINVAL;
 	}
diff --git a/include/linux/vfio.h b/include/linux/vfio.h
index c491180..73d7e84 100644
--- a/include/linux/vfio.h
+++ b/include/linux/vfio.h
@@ -155,6 +155,7 @@ void vfio_error_resume(struct pci_dev *);
 #define VFIO_SUSPEND_REPLY_TIMEOUT	(5*HZ)
 
 irqreturn_t vfio_interrupt(int, void *);
+int vfio_irq_eoi(struct vfio_dev *);
 
 #endif	/* __KERNEL__ */
 
@@ -198,6 +199,8 @@ struct vfio_dma_map {
 /* Unset the IOMMU domain */
 #define	VFIO_DOMAIN_UNSET	_IO(';', 108)
 
+/* Re-enable INTx */
+#define	VFIO_IRQ_EOI		_IO(';', 109)
 /*
  * Reads, writes, and mmaps determine which PCI BAR (or config space)
  * from the high level bits of the file offset

