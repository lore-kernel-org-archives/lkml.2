Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752339Ab2FKUrM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2012 16:47:12 -0400
Received: from mga09.intel.com ([134.134.136.24]:28785 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751640Ab2FKUrK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2012 16:47:10 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="scan'208";a="151548832"
Date: Mon, 11 Jun 2012 13:47:09 -0700
From: Sarah Sharp <sarah.a.sharp@linux.intel.com>
To: Alex Shi <alex.shi@intel.com>
Cc: gregkh <gregkh@linuxfoundation.org>,
        "Sharp, Sarah A" <sarah.a.sharp@intel.com>,
        Alan stern <stern@rowland.harvard.edu>, Felipe Balbi <balbi@ti.com>,
        linux-usb <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] usb/xhci: unify parameter of xhci_msi_irq
Message-ID: <20120611204709.GC5742@xanatos>
References: <1331787186.2979.71.camel@debian>
 <20120315145743.GA7928@kroah.com>
 <4F6204B7.5010908@intel.com>
 <20120315175608.GA6077@xanatos>
 <4FC5D04E.5040907@intel.com>
 <4FD59AD8.1050109@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4FD59AD8.1050109@intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Alex,

This got lost in the 3.5 push, but I think it's a good candidate for
3.6.  I think Greg is accepting 3.6 patches now, and I'll send this off
to him.

Sarah Sharp

On Mon, Jun 11, 2012 at 03:14:32PM +0800, Alex Shi wrote:
> On 05/30/2012 03:46 PM, Alex Shi wrote:
> 
> > 
> >>>> Is this needed in my -next tree now?  Or is it something for later?
> >>>
> >>>
> >>> Appreciate if it can be in -next tree. :)
> >>>
> >>>>
> >>>> Any reason you did not put Sarah on the To: line here?  She's the one
> >>>> that needs to ack it before I can accept it.
> >>>
> >>>
> >>> Sarah, would you like to give some comments here?
> >>
> >> Looks fine.  I'll send a pull request to Greg with this patch after I
> >> verify it doesn't generate new warnings.
> >>
> > 
> > 
> > Sarah, any further comments for this patch? :)
> 
> 
> 
> 
> 
> Just try on 3.5-rc2 kernel, find it still works.
> Sarah, do you mind to give some comments for this?
> 
> -------------
> 
> 
> From 6ae1b9e71f9b14be5774ae9c1b4cf57cd4e747ac Mon Sep 17 00:00:00 2001
> From: Alex Shi <alex.shi@intel.com>
> Date: Mon, 11 Jun 2012 15:10:18 +0800
> Subject: [PATCH] usb/xhci: unify parameter of xhci_msi_irq
> 
> According to Felipe and Alan's comments the second parameter of irq
> handler should be 'void *' not a specific structure pointer.
> So fix it.
> 
> Signed-off-by: Alex Shi <alex.shi@intel.com>
> Acked-by: Felipe Balbi <balbi@ti.com>
> ---
>  drivers/usb/host/xhci-ring.c |    2 +-
>  drivers/usb/host/xhci.c      |    4 ++--
>  drivers/usb/host/xhci.h      |    2 +-
>  3 files changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/usb/host/xhci-ring.c b/drivers/usb/host/xhci-ring.c
> index 23b4aef..cc8a52f 100644
> --- a/drivers/usb/host/xhci-ring.c
> +++ b/drivers/usb/host/xhci-ring.c
> @@ -2479,7 +2479,7 @@ hw_died:
>  	return IRQ_HANDLED;
>  }
>  
> -irqreturn_t xhci_msi_irq(int irq, struct usb_hcd *hcd)
> +irqreturn_t xhci_msi_irq(int irq, void *hcd)
>  {
>  	return xhci_irq(hcd);
>  }
> diff --git a/drivers/usb/host/xhci.c b/drivers/usb/host/xhci.c
> index afdc73e..f7d40c1 100644
> --- a/drivers/usb/host/xhci.c
> +++ b/drivers/usb/host/xhci.c
> @@ -215,7 +215,7 @@ static int xhci_setup_msi(struct xhci_hcd *xhci)
>  		return ret;
>  	}
>  
> -	ret = request_irq(pdev->irq, (irq_handler_t)xhci_msi_irq,
> +	ret = request_irq(pdev->irq, xhci_msi_irq,
>  				0, "xhci_hcd", xhci_to_hcd(xhci));
>  	if (ret) {
>  		xhci_dbg(xhci, "disable MSI interrupt\n");
> @@ -287,7 +287,7 @@ static int xhci_setup_msix(struct xhci_hcd *xhci)
>  
>  	for (i = 0; i < xhci->msix_count; i++) {
>  		ret = request_irq(xhci->msix_entries[i].vector,
> -				(irq_handler_t)xhci_msi_irq,
> +				xhci_msi_irq,
>  				0, "xhci_hcd", xhci_to_hcd(xhci));
>  		if (ret)
>  			goto disable_msix;
> diff --git a/drivers/usb/host/xhci.h b/drivers/usb/host/xhci.h
> index de3d6e3..737ef54 100644
> --- a/drivers/usb/host/xhci.h
> +++ b/drivers/usb/host/xhci.h
> @@ -1710,7 +1710,7 @@ int xhci_resume(struct xhci_hcd *xhci, bool hibernated);
>  
>  int xhci_get_frame(struct usb_hcd *hcd);
>  irqreturn_t xhci_irq(struct usb_hcd *hcd);
> -irqreturn_t xhci_msi_irq(int irq, struct usb_hcd *hcd);
> +irqreturn_t xhci_msi_irq(int irq, void *hcd);
>  int xhci_alloc_dev(struct usb_hcd *hcd, struct usb_device *udev);
>  void xhci_free_dev(struct usb_hcd *hcd, struct usb_device *udev);
>  int xhci_alloc_tt_info(struct xhci_hcd *xhci,
> -- 
> 1.7.5.4
> 
