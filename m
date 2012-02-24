Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753438Ab2BXBsi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Feb 2012 20:48:38 -0500
Received: from mga03.intel.com ([143.182.124.21]:8272 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752535Ab2BXBsh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Feb 2012 20:48:37 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="110182032"
Subject: Re: [PATCH 2/3] usb: enable pci MSI/MSIX in usb core
From: "Alex,Shi" <alex.shi@intel.com>
To: balbi@ti.com
Cc: Sarah Sharp <sarah.a.sharp@linux.intel.com>, gregkh@linuxfoundation.org,
        stern@rowland.harvard.edu, linux-usb@vger.kernel.org,
        andiry.xu@amd.com, clemens@ladisch.de, linux-kernel@vger.kernel.org
In-Reply-To: <20120223124147.GL18463@legolas.emea.dhcp.ti.com>
References: <1329728733-32419-1-git-send-email-alex.shi@intel.com>
	 <1329728733-32419-2-git-send-email-alex.shi@intel.com>
	 <1329728733-32419-3-git-send-email-alex.shi@intel.com>
	 <20120223034147.GD27250@xanatos>
	 <20120223124147.GL18463@legolas.emea.dhcp.ti.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 24 Feb 2012 09:47:08 +0800
Message-ID: <1330048028.21053.1176.camel@debian>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> > Felipe, can you please review this patch for the effects on non-PCI
> > hosts?  I think nothing will change, since this patchset just modifies
> > the USB core PCI initialization flow, but I need your eyes on this. :)
> 
> Sure thing :-)

Thanks a lot!

> > > +/* Check for buggy HCD devices, and driver's expectation for MSI.
> 
> please use the preferred multi-line comment style.

See and thanks!

> > > +			retval = request_irq(hcd->msix_entries[i].vector,
> > > +					(irq_handler_t)hcd->driver->msix_irq,
> 
> do you really need this cast here ?

Yes, otherwise the complain like here:
drivers/usb/core/hcd-pci.c:330: warning: passing argument 2 of ‘request_irq’ from incompatible pointer type
include/linux/interrupt.h:134: note: expected ‘irq_handler_t’ but argument is of type ‘enum irqreturn_t (* const)(int,  struct usb_hcd *)’

> > > +int usb_hcd_request_irqs(struct usb_hcd *hcd, unsigned int irqnum,
> > > +		unsigned long irqflags)
> > > +{
> > > +	int retval = 1;
> > > +
> > > +#ifdef CONFIG_PCI
> > > +	retval = usb_hcd_request_msi_msix_irqs(hcd, irqnum, irqflags);
> > > +#endif
> 
> I would like it better if the #ifdef is in the function body, something
> like:
> 
> int usb_hcd_request_msi_msix_irqs(struct hcd *hcd, int irqnum, int irqflags)
> {
> #ifdef CONFIG_PCI
> 	/* blablabla */
> #else
> 	return -ENODEV;
> #endif
> }

The function usb_hcd_request_msi_msix_irqs() is defined in hcd-pci.c. If
you don't like to see '#ifdef CONFIG_PCI' in hcd.c, maybe we can add a
same name function usb_hcd_request_msi_msix_irqs() in hcd.h for non-pci
environment.  Is that ok of the following? 
------
diff --git a/drivers/usb/core/hcd.c b/drivers/usb/core/hcd.c
index 579cbd3..9bc6568 100644
--- a/drivers/usb/core/hcd.c
+++ b/drivers/usb/core/hcd.c
@@ -2365,12 +2365,9 @@ static int usb_hcd_request_default_irqs(struct usb_hcd *hcd,
 int usb_hcd_request_irqs(struct usb_hcd *hcd, unsigned int irqnum,
                unsigned long irqflags)
 {
-       int retval = 1;
+       int retval = 0;
 
-#ifdef CONFIG_PCI
-       retval = usb_hcd_request_msi_msix_irqs(hcd, irqnum, irqflags);
-#endif
-       if (retval)
+       if (usb_hcd_request_msi_msix_irqs(hcd, irqnum, irqflags))
                retval = usb_hcd_request_default_irqs(hcd, irqnum, irqflags);
 
        return retval;
diff --git a/include/linux/usb/hcd.h b/include/linux/usb/hcd.h
index 5253c02..6743ed8 100644
--- a/include/linux/usb/hcd.h
+++ b/include/linux/usb/hcd.h
@@ -413,6 +413,13 @@ extern int usb_hcd_register_msi_msix_irqs(struct usb_hcd *hcd);
 #ifdef CONFIG_PM_SLEEP
 extern const struct dev_pm_ops usb_hcd_pci_pm_ops;
 #endif
+
+#else
+extern int usb_hcd_request_msi_msix_irqs(struct usb_hcd *hcd,
+               unsigned int irqnum, unsigned long irqflags)
+{
+       return -ENODEV;
+}
 #endif /* CONFIG_PCI */
 
 /* pci-ish (pdev null is ok) buffer alloc/mapping support */

> Yeah, I don't think this will break anything for my non-PCI stuff, but
> the very fact that usbcore knows so much about PCI is quite a bummer. I
> think usbcore should know about USB Devices and HCDs, no matter if it's
> PCI or platform BUS or whatever else, but that's just me and changing
> that would be quite a big re-work.
> 

Thanks again for all comments!

