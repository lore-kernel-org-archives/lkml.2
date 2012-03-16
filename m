Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1032617Ab2CPIG1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2012 04:06:27 -0400
Received: from mga03.intel.com ([143.182.124.21]:27748 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964997Ab2CPIGS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2012 04:06:18 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="78275929"
Subject: Re: [PATCH] usb/core: skip unnecessary line IRQ request for USB3
From: Alex Shi <alex.shi@intel.com>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: gregkh <gregkh@linuxfoundation.org>, sarah.a.sharp@linux.intel.com,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-usb <linux-usb@vger.kernel.org>
In-Reply-To: <4F61FF28.8000505@intel.com>
References: <Pine.LNX.4.44L0.1203151025300.1366-100000@iolanthe.rowland.org>
	 <4F61FF28.8000505@intel.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 16 Mar 2012 16:05:54 +0800
Message-ID: <1331885154.2979.181.camel@debian>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-03-15 at 22:39 +0800, Alex Shi wrote:
> > 
> > This is not a good idea.  What happens if some USB-3 controller 
> > (perhaps a non-xHCI USB-3 controller) doesn't use MSI?
> > 
> 
> 
> current usb3 driver just xhci. but sure it need to modify if non-xhci
> usb pops up.
> 
> > The right way to avoid registering a legacy interrupt handler is to 
> > call usb_add_hcd() with irqnum equal to 0.
> 
> 
> a good trick! will try it tomorrow.

Do you mean the following patch? It tested. :) 
------------
>From 5ae9a6fe88752495af6da6182cad26620f1ab190 Mon Sep 17 00:00:00 2001
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
 drivers/usb/core/hcd-pci.c |    5 ++++-
 drivers/usb/host/xhci.c    |    3 ---
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/usb/core/hcd-pci.c b/drivers/usb/core/hcd-pci.c
index 81e2c0d..7b73c74 100644
--- a/drivers/usb/core/hcd-pci.c
+++ b/drivers/usb/core/hcd-pci.c
@@ -245,7 +245,10 @@ int usb_hcd_pci_probe(struct pci_dev *dev, const struct pci_device_id *id)
 
 	pci_set_master(dev);
 
-	retval = usb_add_hcd(hcd, dev->irq, IRQF_SHARED);
+	if ((driver->flags & HCD_MASK) != HCD_USB3)
+		retval = usb_add_hcd(hcd, dev->irq, IRQF_SHARED);
+	else
+		retval = usb_add_hcd(hcd, 0, IRQF_SHARED);
 	if (retval != 0)
 		goto unmap_registers;
 	set_hs_companion(dev, hcd);
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
> > 
> > Alan Stern
> > 
> 
> 
> 
> 


