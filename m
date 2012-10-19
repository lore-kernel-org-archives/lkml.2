Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964939Ab2JSCtA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2012 22:49:00 -0400
Received: from mail.kernel.org ([198.145.19.201]:52187 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964870Ab2JSCs4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2012 22:48:56 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Alex Williamson <alex.williamson@redhat.com>
Subject: [ 35/76] vfio: Fix PCI INTx disable consistency
Date: Thu, 18 Oct 2012 19:46:59 -0700
Message-Id: <20121019024355.778895474@linuxfoundation.org>
X-Mailer: git-send-email 1.8.0.rc0.18.gf84667d
In-Reply-To: <20121019024350.087156547@linuxfoundation.org>
References: <20121019024350.087156547@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Williamson <alex.williamson@redhat.com>

commit 899649b7d4ead76c19e39251ca886eebe3f811a8 upstream.

The virq_disabled flag tracks the userspace view of INTx masking
across interrupt mode changes, but we're not consistently applying
this to the interrupt and masking handler notion of the device.
Currently if the user sets DisINTx while in MSI or MSIX mode, then
returns to INTx mode (ex. rebooting a qemu guest), the hardware has
DisINTx+, but the management of INTx thinks it's enabled, making it
impossible to actually clear DisINTx.  Fix this by updating the
handler state when INTx is re-enabled.

Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/vfio/pci/vfio_pci_intrs.c |   13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

--- a/drivers/vfio/pci/vfio_pci_intrs.c
+++ b/drivers/vfio/pci/vfio_pci_intrs.c
@@ -366,6 +366,17 @@ static int vfio_intx_enable(struct vfio_
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
@@ -419,7 +430,7 @@ static int vfio_intx_set_signal(struct v
 	 * disable_irq won't.
 	 */
 	spin_lock_irqsave(&vdev->irqlock, flags);
-	if (!vdev->pci_2_3 && (vdev->ctx[0].masked || vdev->virq_disabled))
+	if (!vdev->pci_2_3 && vdev->ctx[0].masked)
 		disable_irq_nosync(pdev->irq);
 	spin_unlock_irqrestore(&vdev->irqlock, flags);
 


