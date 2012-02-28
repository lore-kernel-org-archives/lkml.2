Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756583Ab2B1Bp7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Feb 2012 20:45:59 -0500
Received: from mga09.intel.com ([134.134.136.24]:48356 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756364Ab2B1Bp5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Feb 2012 20:45:57 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,351,1309762800"; 
   d="scan'208";a="115477897"
Subject: Re: [PATCH 2/3] usb: enable pci MSI/MSIX in usb core
From: "Alex,Shi" <alex.shi@intel.com>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Felipe Balbi <balbi@ti.com>, Sarah Sharp <sarah.a.sharp@linux.intel.com>,
        gregkh@linuxfoundation.org, linux-usb@vger.kernel.org,
        andiry.xu@amd.com, clemens@ladisch.de, linux-kernel@vger.kernel.org
In-Reply-To: <Pine.LNX.4.44L0.1202241050520.1168-100000@iolanthe.rowland.org>
References: <Pine.LNX.4.44L0.1202241050520.1168-100000@iolanthe.rowland.org>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 28 Feb 2012 09:43:26 +0800
Message-ID: <1330393406.21053.1248.camel@debian>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-02-24 at 10:59 -0500, Alan Stern wrote:
> On Fri, 24 Feb 2012, Felipe Balbi wrote:
> 
> > > > > > +			retval = request_irq(hcd->msix_entries[i].vector,
> > > > > > +					(irq_handler_t)hcd->driver->msix_irq,
> > > > 
> > > > do you really need this cast here ?
> > > 
> > > Yes, otherwise the complain like here:
> > > drivers/usb/core/hcd-pci.c:330: warning: passing argument 2 of ‘request_irq’ from incompatible pointer type
> > > include/linux/interrupt.h:134: note: expected ‘irq_handler_t’ but argument is of type ‘enum irqreturn_t (* const)(int,  struct usb_hcd *)’
> > 
> > Alan, Sarah, is the definition of the IRQ handler wrong on the hc_driver
> > structure ?
> 
> No.  It is never passed to request_irq().
> 
> > Alex, I think you should fix your definition for the msix_irq handler.
> 
> The second parameter in the prototype is supposed to be void *, not 
> struct usb_hcd *.

Yes, Thanks you all for reviewing! 

Is the following change OK?
=======
diff --git a/drivers/usb/core/hcd-pci.c b/drivers/usb/core/hcd-pci.c
index 3606afe..a198f4d 100644
--- a/drivers/usb/core/hcd-pci.c
+++ b/drivers/usb/core/hcd-pci.c
@@ -265,7 +265,8 @@ free_entries:
 	return ret;
 }
 
-/* Check for buggy HCD devices, and driver's expectation for MSI.
+/*
+ * Check for buggy HCD devices, and driver's expectation for MSI.
  * Now, only xhci driver want it by HCD_MSI_FIRST setting. Other driver
  * like ehci/uhci can follow this setting, if they want.
  */
@@ -326,8 +327,8 @@ int usb_hcd_request_msi_msix_irqs(struct usb_hcd *hcd, unsigned int irqnum,
 		/* register hc_driver's msix_irq handler */
 		for (i = 0; i < hcd->msix_count; i++) {
 			retval = request_irq(hcd->msix_entries[i].vector,
-					(irq_handler_t)hcd->driver->msix_irq,
-					0, hcd->driver->description, hcd);
+					hcd->driver->msix_irq, 0,
+					hcd->driver->description, hcd);
 			if (retval) {
 				hcd_free_msix(hcd);
 				break;
@@ -337,8 +338,7 @@ int usb_hcd_request_msi_msix_irqs(struct usb_hcd *hcd, unsigned int irqnum,
 			hcd->msix_enabled = 1;
 	} else if (hcd->irq == -1 && hcd->driver->msi_irq) {
 		/* register hc_driver's msi_irq handler */
-		retval = request_irq(irqnum,
-					(irq_handler_t)hcd->driver->msi_irq,
+		retval = request_irq(irqnum, hcd->driver->msi_irq,
 					0, hcd->driver->description, hcd);
 		if (retval)
 			hcd_free_msi(hcd);
diff --git a/drivers/usb/core/hcd.c b/drivers/usb/core/hcd.c
index 579cbd3..9bc6568 100644
--- a/drivers/usb/core/hcd.c
+++ b/drivers/usb/core/hcd.c
@@ -2365,12 +2365,9 @@ static int usb_hcd_request_default_irqs(struct usb_hcd *hcd,
 int usb_hcd_request_irqs(struct usb_hcd *hcd, unsigned int irqnum,
 		unsigned long irqflags)
 {
-	int retval = 1;
+	int retval = 0;
 
-#ifdef CONFIG_PCI
-	retval = usb_hcd_request_msi_msix_irqs(hcd, irqnum, irqflags);
-#endif
-	if (retval)
+	if (usb_hcd_request_msi_msix_irqs(hcd, irqnum, irqflags))
 		retval = usb_hcd_request_default_irqs(hcd, irqnum, irqflags);
 
 	return retval;
diff --git a/drivers/usb/host/xhci-ring.c b/drivers/usb/host/xhci-ring.c
index b62037b..c223158 100644
--- a/drivers/usb/host/xhci-ring.c
+++ b/drivers/usb/host/xhci-ring.c
@@ -2396,9 +2396,10 @@ hw_died:
 	return IRQ_HANDLED;
 }
 
-irqreturn_t xhci_msi_irq(int irq, struct usb_hcd *hcd)
+irqreturn_t xhci_msi_irq(int irq, void *hcd)
 {
-	return xhci_irq(hcd);
+	struct usb_hcd *xhci_hcd = hcd;
+	return xhci_irq(xhci_hcd);
 }
 
 /****		Endpoint Ring Operations	****/
diff --git a/drivers/usb/host/xhci.h b/drivers/usb/host/xhci.h
index 8d511dd..6186d12 100644
--- a/drivers/usb/host/xhci.h
+++ b/drivers/usb/host/xhci.h
@@ -1668,7 +1668,7 @@ int xhci_resume(struct xhci_hcd *xhci, bool hibernated);
 
 int xhci_get_frame(struct usb_hcd *hcd);
 irqreturn_t xhci_irq(struct usb_hcd *hcd);
-irqreturn_t xhci_msi_irq(int irq, struct usb_hcd *hcd);
+irqreturn_t xhci_msi_irq(int irq, void *hcd);
 int xhci_alloc_dev(struct usb_hcd *hcd, struct usb_device *udev);
 void xhci_free_dev(struct usb_hcd *hcd, struct usb_device *udev);
 int xhci_alloc_tt_info(struct xhci_hcd *xhci,
diff --git a/include/linux/usb/hcd.h b/include/linux/usb/hcd.h
index 5253c02..2f94c02 100644
--- a/include/linux/usb/hcd.h
+++ b/include/linux/usb/hcd.h
@@ -212,8 +212,8 @@ struct hc_driver {
 
 	/* irq handler */
 	irqreturn_t	(*irq) (struct usb_hcd *hcd);
-	irqreturn_t	(*msi_irq) (int irq, struct usb_hcd *hcd);
-	irqreturn_t	(*msix_irq) (int irq, struct usb_hcd *hcd);
+	irqreturn_t	(*msi_irq) (int irq, void *hcd);
+	irqreturn_t	(*msix_irq) (int irq, void *hcd);
 
 	int	flags;
 #define	HCD_MEMORY	0x0001		/* HC regs use memory (else I/O) */
@@ -413,6 +413,13 @@ extern int usb_hcd_register_msi_msix_irqs(struct usb_hcd *hcd);
 #ifdef CONFIG_PM_SLEEP
 extern const struct dev_pm_ops usb_hcd_pci_pm_ops;
 #endif
+
+#else
+static inline int usb_hcd_request_msi_msix_irqs(struct usb_hcd *hcd,
+		unsigned int irqnum, unsigned long irqflags)
+{
+	return -ENODEV;
+}
 #endif /* CONFIG_PCI */
 
 /* pci-ish (pdev null is ok) buffer alloc/mapping support */


