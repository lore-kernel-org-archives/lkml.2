Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933499Ab2JDRA5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2012 13:00:57 -0400
Received: from mx1.redhat.com ([209.132.183.28]:9213 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932821Ab2JDRAz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2012 13:00:55 -0400
From: Alex Williamson <alex.williamson@redhat.com>
Subject: [PATCH 1/2] vfio: Move PCI INTx eventfd setting earlier
To: alex.williamson@redhat.com
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Thu, 04 Oct 2012 11:00:54 -0600
Message-ID: <20121004170054.4014.52217.stgit@bling.home>
In-Reply-To: <20121004165917.4014.13849.stgit@bling.home>
References: <20121004165917.4014.13849.stgit@bling.home>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We need to be ready to recieve an interrupt as soon as we call
request_irq, so our eventfd context setting needs to be moved
earlier.  Without this, an interrupt from our device or one
sharing the interrupt line can pass a NULL into eventfd_signal
and oops.

Cc: stable@vger.kernel.org
Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
---

 drivers/vfio/pci/vfio_pci_intrs.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/vfio/pci/vfio_pci_intrs.c b/drivers/vfio/pci/vfio_pci_intrs.c
index d8dedc7..c8139a5 100644
--- a/drivers/vfio/pci/vfio_pci_intrs.c
+++ b/drivers/vfio/pci/vfio_pci_intrs.c
@@ -400,19 +400,20 @@ static int vfio_intx_set_signal(struct vfio_pci_device *vdev, int fd)
 		return PTR_ERR(trigger);
 	}
 
+	vdev->ctx[0].trigger = trigger;
+
 	if (!vdev->pci_2_3)
 		irqflags = 0;
 
 	ret = request_irq(pdev->irq, vfio_intx_handler,
 			  irqflags, vdev->ctx[0].name, vdev);
 	if (ret) {
+		vdev->ctx[0].trigger = NULL;
 		kfree(vdev->ctx[0].name);
 		eventfd_ctx_put(trigger);
 		return ret;
 	}
 
-	vdev->ctx[0].trigger = trigger;
-
 	/*
 	 * INTx disable will stick across the new irq setup,
 	 * disable_irq won't.

