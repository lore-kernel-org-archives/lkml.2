Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754812Ab1DSUdU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Apr 2011 16:33:20 -0400
Received: from mx1.redhat.com ([209.132.183.28]:59027 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754434Ab1DSUdQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Apr 2011 16:33:16 -0400
From: Alex Williamson <alex.williamson@redhat.com>
Subject: [PATCH] vfio: Add an ioctl to reset the device
To: pugs@ieee.org
Cc: alex.williamson@redhat.com, linux-kernel@vger.kernel.org,
        linux-pci@vger.kernel.org, qemu-devel@nongnu.org, chrisw@redhat.com,
        aafabbri@cisco.com, dwang2@cisco.com, benve@cisco.com
Date: Tue, 19 Apr 2011 14:32:59 -0600
Message-ID: <20110419203234.4254.94914.stgit@s20.home>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When using VFIO to assign a device to a guest, we want to make sure
the device is quiesced on VM reset to stop all DMA within the guest
mapped memory.  Add an ioctl which just calls pci_reset_function()
and returns whether it succeeds.

Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
---

We've recently needed to add this functionality for current KVM
based device assignment, VFIO should provide a way to do this too.
An example of it being used in the Qemu VFIO driver can be found
here:

https://github.com/awilliam/qemu-vfio/blob/vfio/hw/vfio.c

 drivers/vfio/vfio_main.c |    4 ++++
 include/linux/vfio.h     |    3 +++
 2 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/drivers/vfio/vfio_main.c b/drivers/vfio/vfio_main.c
index 7e427fc..b9bb692 100644
--- a/drivers/vfio/vfio_main.c
+++ b/drivers/vfio/vfio_main.c
@@ -490,6 +490,10 @@ static long vfio_unl_ioctl(struct file *filep,
 		ret = vfio_irq_eoi_eventfd(vdev, fd);
 		break;
 
+	case VFIO_RESET_FUNCTION:
+		ret = pci_reset_function(vdev->pdev);
+		break;
+
 	default:
 		return -EINVAL;
 	}
diff --git a/include/linux/vfio.h b/include/linux/vfio.h
index f07d8fe..47d9bb9 100644
--- a/include/linux/vfio.h
+++ b/include/linux/vfio.h
@@ -215,6 +215,9 @@ struct vfio_dma_map {
 /* Re-enable INTx via eventfd */
 #define	VFIO_IRQ_EOI_EVENTFD	_IOW(';', 110, int)
 
+/* Reset PCI function */
+#define VFIO_RESET_FUNCTION	_IO(';', 111)
+
 /*
  * Reads, writes, and mmaps determine which PCI BAR (or config space)
  * from the high level bits of the file offset

