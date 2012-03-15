Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760202Ab2COO31 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2012 10:29:27 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:47354 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1759489Ab2COO3X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2012 10:29:23 -0400
Date: Thu, 15 Mar 2012 10:29:22 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Alex Shi <alex.shi@intel.com>
cc: gregkh <gregkh@linuxfoundation.org>, <sarah.a.sharp@linux.intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-usb <linux-usb@vger.kernel.org>
Subject: Re: [PATCH] usb/core: skip unnecessary line IRQ request for USB3
In-Reply-To: <1331786904.2979.64.camel@debian>
Message-ID: <Pine.LNX.4.44L0.1203151025300.1366-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 15 Mar 2012, Alex Shi wrote:

> USB3 requests line IRQ here but will disable it
> in later driver->start function and try MSI first.
> 
> xhci_hcd 0000:02:00.0: irq 18, io mem 0xfe500000
> xhci_hcd 0000:02:00.0: irq 45 for MSI/MSI-X
> xhci_hcd 0000:02:00.0: irq 46 for MSI/MSI-X
> 
> So it is better to remove the redundant request here. And
> save a little time in booting.
> 
> Signed-off-by: Alex Shi <alex.shi@intel.com>
> ---
>  drivers/usb/core/hcd.c |    3 ++-
>  1 files changed, 2 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/usb/core/hcd.c b/drivers/usb/core/hcd.c
> index e128232..5b09825 100644
> --- a/drivers/usb/core/hcd.c
> +++ b/drivers/usb/core/hcd.c
> @@ -2450,7 +2450,8 @@ int usb_add_hcd(struct usb_hcd *hcd,
>  	/* enable irqs just before we start the controller,
>  	 * if the BIOS provides legacy PCI irqs.
>  	 */
> -	if (usb_hcd_is_primary_hcd(hcd) && irqnum) {
> +	if (usb_hcd_is_primary_hcd(hcd) && irqnum
> +		&& (hcd->driver->flags & HCD_MASK) != HCD_USB3) {
>  		retval = usb_hcd_request_irqs(hcd, irqnum, irqflags);
>  		if (retval)
>  			goto err_request_irq;

This is not a good idea.  What happens if some USB-3 controller 
(perhaps a non-xHCI USB-3 controller) doesn't use MSI?

The right way to avoid registering a legacy interrupt handler is to 
call usb_add_hcd() with irqnum equal to 0.

Alan Stern

