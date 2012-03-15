Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752660Ab2COExP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2012 00:53:15 -0400
Received: from mga03.intel.com ([143.182.124.21]:33074 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751183Ab2COExN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2012 00:53:13 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="77747902"
Subject: [PATCH] usb/xhci: unify parameter of xhci_msi_irq
From: Alex Shi <alex.shi@intel.com>
To: Alan stern <stern@rowland.harvard.edu>,
        gregkh <gregkh@linuxfoundation.org>, Felipe Balbi <balbi@ti.com>
Cc: "Sharp, Sarah A" <sarah.a.sharp@intel.com>,
        linux-usb <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 15 Mar 2012 12:53:06 +0800
Message-ID: <1331787186.2979.71.camel@debian>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


According to Felipe and Alan's comments the second parameter of irq
handler should be 'void *' not a specific structure pointer. 
So change it.

Signed-off-by: Alex Shi <alex.shi@intel.com>
---
 drivers/usb/host/xhci-ring.c |    2 +-
 drivers/usb/host/xhci.c      |    4 ++--
 drivers/usb/host/xhci.h      |    2 +-
 3 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/usb/host/xhci-ring.c b/drivers/usb/host/xhci-ring.c
index b62037b..c5caad3 100644
--- a/drivers/usb/host/xhci-ring.c
+++ b/drivers/usb/host/xhci-ring.c
@@ -2396,7 +2396,7 @@ hw_died:
 	return IRQ_HANDLED;
 }
 
-irqreturn_t xhci_msi_irq(int irq, struct usb_hcd *hcd)
+irqreturn_t xhci_msi_irq(int irq, void *hcd)
 {
 	return xhci_irq(hcd);
 }
diff --git a/drivers/usb/host/xhci.c b/drivers/usb/host/xhci.c
index c939f5f..84706cb 100644
--- a/drivers/usb/host/xhci.c
+++ b/drivers/usb/host/xhci.c
@@ -204,7 +204,7 @@ static int xhci_setup_msi(struct xhci_hcd *xhci)
 		return ret;
 	}
 
-	ret = request_irq(pdev->irq, (irq_handler_t)xhci_msi_irq,
+	ret = request_irq(pdev->irq, xhci_msi_irq,
 				0, "xhci_hcd", xhci_to_hcd(xhci));
 	if (ret) {
 		xhci_dbg(xhci, "disable MSI interrupt\n");
@@ -276,7 +276,7 @@ static int xhci_setup_msix(struct xhci_hcd *xhci)
 
 	for (i = 0; i < xhci->msix_count; i++) {
 		ret = request_irq(xhci->msix_entries[i].vector,
-				(irq_handler_t)xhci_msi_irq,
+				xhci_msi_irq,
 				0, "xhci_hcd", xhci_to_hcd(xhci));
 		if (ret)
 			goto disable_msix;
diff --git a/drivers/usb/host/xhci.h b/drivers/usb/host/xhci.h
index fb99c83..d82cbb6 100644
--- a/drivers/usb/host/xhci.h
+++ b/drivers/usb/host/xhci.h
@@ -1669,7 +1669,7 @@ int xhci_resume(struct xhci_hcd *xhci, bool hibernated);
 
 int xhci_get_frame(struct usb_hcd *hcd);
 irqreturn_t xhci_irq(struct usb_hcd *hcd);
-irqreturn_t xhci_msi_irq(int irq, struct usb_hcd *hcd);
+irqreturn_t xhci_msi_irq(int irq, void *hcd);
 int xhci_alloc_dev(struct usb_hcd *hcd, struct usb_device *udev);
 void xhci_free_dev(struct usb_hcd *hcd, struct usb_device *udev);
 int xhci_alloc_tt_info(struct xhci_hcd *xhci,
-- 
1.6.3.3



