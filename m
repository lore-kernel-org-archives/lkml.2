Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933516Ab2JDRBE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2012 13:01:04 -0400
Received: from mx1.redhat.com ([209.132.183.28]:38517 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933501Ab2JDRBC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2012 13:01:02 -0400
From: Alex Williamson <alex.williamson@redhat.com>
Subject: [PATCH 2/2] vfio: Fix PCI INTx disable consistency
To: alex.williamson@redhat.com
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Thu, 04 Oct 2012 11:01:00 -0600
Message-ID: <20121004170100.4014.77626.stgit@bling.home>
In-Reply-To: <20121004165917.4014.13849.stgit@bling.home>
References: <20121004165917.4014.13849.stgit@bling.home>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The virq_disabled flag tracks the userspace view of INTx masking
across interrupt mode changes, but we're not consistently applying
this to the interrupt and masking handler notion of the device.
Currently if the user sets DisINTx while in MSI or MSIX mode, then
returns to INTx mode (ex. rebooting a qemu guest), the hardware has
DisINTx+, but the management of INTx thinks it's enabled, making it
impossible to actually clear DisINTx.  Fix this by updating the
handler state when INTx is re-enabled.

Cc: stable@vger.kernel.org
Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
---

 drivers/vfio/pci/vfio_pci_intrs.c |   13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

diff --git a/drivers/vfio/pci/vfio_pci_intrs.c b/drivers/vfio/pci/vfio_pci_intrs.c
index c8139a5..3639371 100644
--- a/drivers/vfio/pci/vfio_pci_intrs.c
+++ b/drivers/vfio/pci/vfio_pci_intrs.c
@@ -366,6 +366,17 @@ static int vfio_intx_enable(struct vfio_pci_device *vdev)
 		return -ENOMEM;
 
 	vdev->num_ctx = 1;
+
+	/*
+	 * If the virtual interrupt is masked, restore it.  Devices
+	 * supporting DisINTx can be masked at the hardware level
+	 * here, non-PCI-2.3 devices will have to wait until the
+	 * interrupt is enabled.
+	 */
+	vdev->ctx[0].masked = vdev->virq_disabled;
+	if (vdev->pci_2_3)
+		pci_intx(vdev->pdev, !vdev->ctx[0].masked);
+
 	vdev->irq_type = VFIO_PCI_INTX_IRQ_INDEX;
 
 	return 0;
@@ -419,7 +430,7 @@ static int vfio_intx_set_signal(struct vfio_pci_device *vdev, int fd)
 	 * disable_irq won't.
 	 */
 	spin_lock_irqsave(&vdev->irqlock, flags);
-	if (!vdev->pci_2_3 && (vdev->ctx[0].masked || vdev->virq_disabled))
+	if (!vdev->pci_2_3 && vdev->ctx[0].masked)
 		disable_irq_nosync(pdev->irq);
 	spin_unlock_irqrestore(&vdev->irqlock, flags);
 

