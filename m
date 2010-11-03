Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755607Ab0KCURj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Nov 2010 16:17:39 -0400
Received: from mx1.redhat.com ([209.132.183.28]:12109 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754825Ab0KCURh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Nov 2010 16:17:37 -0400
From: Alex Williamson <alex.williamson@redhat.com>
Subject: [PATCH] vfio: Fix PCI 2.3 shared interrupt
To: pugs@cisco.com
Cc: linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        kvm@vger.kernel.org, alex.williamson@redhat.com
Date: Wed, 03 Nov 2010 14:17:33 -0600
Message-ID: <20101103201732.7400.28058.stgit@s20.home>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Trying to be too clever with setting the irq_disabled flag.  PCI 2.3
disabled devices can still share IRQs, which can lead to clearing
the irq_disabled flag, preventing the EOI from registering, and leaving
the device without interrupts.  Interrupt handler should only ever
set irq_disabled and we can exit earlier to avoid the config space
access if we know we're disabled.

Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
---

 drivers/vfio/vfio_intrs.c |    9 ++++++++-
 1 files changed, 8 insertions(+), 1 deletions(-)

diff --git a/drivers/vfio/vfio_intrs.c b/drivers/vfio/vfio_intrs.c
index 604082c..73e3deb 100644
--- a/drivers/vfio/vfio_intrs.c
+++ b/drivers/vfio/vfio_intrs.c
@@ -57,6 +57,12 @@ irqreturn_t vfio_interrupt(int irq, void *dev_id)
 
 	spin_lock_irq(&vdev->irqlock);
 
+	/* INTX disabled interrupts can still be shared */
+	if (vdev->irq_disabled) {
+		spin_unlock_irq(&vdev->irqlock);
+		return ret;
+	}
+
 	if (vdev->pci_2_3) {
 		pci_block_user_cfg_access(pdev);
 
@@ -87,7 +93,8 @@ done:
 		ret = IRQ_HANDLED;
 	}
 
-	vdev->irq_disabled = (ret == IRQ_HANDLED);
+	if (ret == IRQ_HANDLED)
+		vdev->irq_disabled = true;
 
 	spin_unlock_irq(&vdev->irqlock);
 

