Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754831Ab2COGhz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2012 02:37:55 -0400
Received: from mga01.intel.com ([192.55.52.88]:33166 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753155Ab2COGhy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2012 02:37:54 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="139151754"
Subject: RE: [PATCH] usb/core: skip unnecessary line IRQ request for USB3
From: Alex Shi <alex.shi@intel.com>
To: "Xu, Andiry" <Andiry.Xu@amd.com>
Cc: "stern@rowland.harvard.edu" <stern@rowland.harvard.edu>,
        gregkh <gregkh@linuxfoundation.org>,
        "sarah.a.sharp@linux.intel.com" <sarah.a.sharp@linux.intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-usb <linux-usb@vger.kernel.org>
In-Reply-To: <2A76B9D36150BE4293842BC2FE8FF16503320F@SCYBEXDAG04.amd.com>
References: <1331786904.2979.64.camel@debian>
	 <2A76B9D36150BE4293842BC2FE8FF16503320F@SCYBEXDAG04.amd.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 15 Mar 2012 14:37:47 +0800
Message-ID: <1331793467.2979.86.camel@debian>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> 
> You may also remove the unregister the legacy interrupt part in
> xhci_try_enable_msi().

Sure, thanks!

>From 6ae16651ae33ea1841984f3a5eb4a691ed730a19 Mon Sep 17 00:00:00 2001
From: Alex Shi <alex.shi@intel.com>
Date: Thu, 15 Mar 2012 08:12:47 +0800
Subject: [PATCH] usb/core: skip unnecessary line IRQ request for USB3

USB3(only xhci driver) requests line IRQ here but will disable it
in later driver->start function and try MSI first:

xhci_hcd 0000:02:00.0: irq 18, io mem 0xfe500000
xhci_hcd 0000:02:00.0: irq 45 for MSI/MSI-X
xhci_hcd 0000:02:00.0: irq 46 for MSI/MSI-X

So it is better to remove the redundant request here.

Signed-off-by: Alex Shi <alex.shi@intel.com>
---
 drivers/usb/core/hcd.c  |    3 ++-
 drivers/usb/host/xhci.c |    3 ---
 2 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/usb/core/hcd.c b/drivers/usb/core/hcd.c
index e128232..5b09825 100644
--- a/drivers/usb/core/hcd.c
+++ b/drivers/usb/core/hcd.c
@@ -2450,7 +2450,8 @@ int usb_add_hcd(struct usb_hcd *hcd,
 	/* enable irqs just before we start the controller,
 	 * if the BIOS provides legacy PCI irqs.
 	 */
-	if (usb_hcd_is_primary_hcd(hcd) && irqnum) {
+	if (usb_hcd_is_primary_hcd(hcd) && irqnum
+		&& (hcd->driver->flags & HCD_MASK) != HCD_USB3) {
 		retval = usb_hcd_request_irqs(hcd, irqnum, irqflags);
 		if (retval)
 			goto err_request_irq;
diff --git a/drivers/usb/host/xhci.c b/drivers/usb/host/xhci.c
index c939f5f..64979c2 100644
--- a/drivers/usb/host/xhci.c
+++ b/drivers/usb/host/xhci.c
@@ -338,9 +338,6 @@ static int xhci_try_enable_msi(struct usb_hcd *hcd)
 	if (xhci->quirks & XHCI_BROKEN_MSI)
 		return 0;
 
-	/* unregister the legacy interrupt */
-	if (hcd->irq)
-		free_irq(hcd->irq, hcd);
 	hcd->irq = -1;
 
 	ret = xhci_setup_msix(xhci);
-- 
1.6.3.3


> 
> In fact, I think all the MSI related codes should be moved to xhci-pci.c,
> Since MSI is PCI-only.

A patch moving MSI from xhci to USB core is in reviewing. That walks
far. :) https://lkml.org/lkml/2012/2/20/76 


