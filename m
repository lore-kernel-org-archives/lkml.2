Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754276Ab2BWIlU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Feb 2012 03:41:20 -0500
Received: from mga03.intel.com ([143.182.124.21]:14756 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752202Ab2BWIlT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Feb 2012 03:41:19 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="109806849"
Subject: Re: [PATCH 2/3] usb: enable pci MSI/MSIX in usb core
From: "Alex,Shi" <alex.shi@intel.com>
To: Sarah Sharp <sarah.a.sharp@linux.intel.com>
Cc: Felipe Balbi <balbi@ti.com>, gregkh@linuxfoundation.org,
        stern@rowland.harvard.edu, linux-usb@vger.kernel.org,
        andiry.xu@amd.com, clemens@ladisch.de, linux-kernel@vger.kernel.org
In-Reply-To: <20120223034147.GD27250@xanatos>
References: <1329728733-32419-1-git-send-email-alex.shi@intel.com>
	 <1329728733-32419-2-git-send-email-alex.shi@intel.com>
	 <1329728733-32419-3-git-send-email-alex.shi@intel.com>
	 <20120223034147.GD27250@xanatos>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 23 Feb 2012 16:39:44 +0800
Message-ID: <1329986384.21053.165.camel@debian>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> This PCI device and vendor ID is now used in two drivers (xhci and USB
> core).  Please create a separate patch to add this ID to the pci_ids.h
> file, and remove the reference here and in the xHCI driver.

Yes, should be. 
> Why don't you rename hcd_no_msi() to hcd_supports_msi() and remove the
> negation of the return value?

OK. 
> 
> > 
> > +		/* register hc_driver's msix_irq handler */
> > +		for (i = 0; i < hcd->msix_count; i++) {
> > +			retval = request_irq(hcd->msix_entries[i].vector,
> > +					(irq_handler_t)hcd->driver->msix_irq,
> > +					0, hcd->driver->description, hcd);
> 
> I really think you need to allow the host controller driver to set
> different pointers for the msix data pointer.  It's something that we
> need to figure out, so that we can have the infrastructure in place for
> multiple event rings.
> 
> I'm not sure whether the new get MSIX count needs to allow the xHCI
> driver to return an array of pointers, or if the driver can modify the
> irq pointer later?  I don't think you can modify the irq data pointer
> after it's been requested (that would lead to all kinds of race
> conditions, I think).
> 
> It's probably better to allow the xHCI driver to pass this function the
> pointers it needs for each MSI-X vector.  You'll always call
> usb_hcd_request_msi_msix_irqs() after you call xhci_init(), correct?  At
> that point, we should have allocated the multiple event rings, so it
> should be easy to pass the pointers to this function.

What do you mean: there is a relation between event rings
msix_entries.vectors.  and we need to presents this relationships in the
msix interrupt handler? 

So does the following mode you like?

request_irq(hcd->msix_entries[i].vector, msix_irq_handler, 0, "",
hcd->ring_handler[i]);

Or another way to do it if we know which ring will handle the irq, like:

irqreturn_t xhci_msi_irq(int irq, struct usb_hcd *hcd)

	switch (irq2ring(irq))
	case ring0: driver_handle_ring(ring0);
	case ring1: driver_handle_ring(ring1);

In fact, since there is no actual usage of multiple rings now, I have no
much idea of the relationships. 

BTW, if it is possible do this change to another patch? 
> 
> > @@ -888,7 +696,11 @@ int xhci_resume(struct xhci_hcd *xhci, bool hibernated)
> >  		if (retval)
> >  			return retval;
> >  		xhci_dbg(xhci, "Start the primary HCD\n");
> > -		retval = xhci_run(hcd->primary_hcd);
> > +		if (dev_is_pci(hcd->self.controller))
> > +			retval = usb_hcd_register_msi_msix_irqs(
> > +						hcd->primary_hcd);
> 
> Why not change this function to take a count of msix vectors and
> pointers for data?  Then you don't need the new usb_hcd driver method
> for getting the msix count.
> 

Uh, the key is msix vector numbers maybe changed after be freed in
suspend and re-get here. Are there examples to keep the vector number in
suspending?

