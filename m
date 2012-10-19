Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030428Ab2JSDBf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2012 23:01:35 -0400
Received: from mail.kernel.org ([198.145.19.201]:52178 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964915Ab2JSCsy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2012 22:48:54 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Alex Williamson <alex.williamson@redhat.com>
Subject: [ 34/76] vfio: Move PCI INTx eventfd setting earlier
Date: Thu, 18 Oct 2012 19:46:58 -0700
Message-Id: <20121019024355.613584683@linuxfoundation.org>
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

commit 9dbdfd23b7638d054f3b0e70c64dfb9f297f2a9f upstream.

We need to be ready to recieve an interrupt as soon as we call
request_irq, so our eventfd context setting needs to be moved
earlier.  Without this, an interrupt from our device or one
sharing the interrupt line can pass a NULL into eventfd_signal
and oops.

Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/vfio/pci/vfio_pci_intrs.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/drivers/vfio/pci/vfio_pci_intrs.c
+++ b/drivers/vfio/pci/vfio_pci_intrs.c
@@ -400,19 +400,20 @@ static int vfio_intx_set_signal(struct v
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


