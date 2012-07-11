Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758026Ab2GKPGM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2012 11:06:12 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:52241 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753265Ab2GKPGK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2012 11:06:10 -0400
Date: Wed, 11 Jul 2012 08:06:04 -0700
From: "'Greg KH'" <gregkh@linuxfoundation.org>
To: Alexis Cortes <alexis.cortes@ti.com>
Cc: "'Sarah Sharp'" <sarah.a.sharp@linux.intel.com>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, "'Quach, Brian'" <brian.quach@ti.com>,
        "'Llamas, Jorge'" <jorge.llamas@ti.com>
Subject: Re: [PATCH] usb: host: xhci: Compliance Mode port recovery
Message-ID: <20120711150604.GB22382@kroah.com>
References: <002801cd4e68$a4b4f3a0$ee1edae0$@cortes@ti.com>
 <20120619223928.GD21104@xanatos>
 <004101cd4f33$755e8eb0$601bac10$@cortes@ti.com>
 <20120621000734.GB32743@xanatos>
 <003701cd4fde$fd969290$f8c3b7b0$@cortes@ti.com>
 <20120622163214.GC629@xanatos>
 <20120622164704.GA6896@kroah.com>
 <4fe9f0c8.04c1b60a.11cc.3ca4SMTPIN_ADDED@mx.google.com>
 <20120626175121.GA2831@kroah.com>
 <4ffcad84.6710b60a.2b1a.0065SMTPIN_ADDED@mx.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4ffcad84.6710b60a.2b1a.0065SMTPIN_ADDED@mx.google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 10, 2012 at 05:32:35PM -0500, Alexis Cortes wrote:
> Hi Sarah & Greg,
> 
> I made another patch for this issue following your recommendations. The only
> thing that is left is the way the patch is going to be implemented on the
> kernel (module parameter, sysfs...), which is still in discussion. The
> changes I made for this patch are as follows:
> 
> * Changed #define COMP_MODE_RCVRY_TIMEOUT 2 by #define COMP_MODE_RCVRY_MSECS
> 2000.
> * Timer implemented as a Slack Timer.
> * Stop and Restart the timer when the host is suspended.
> * Let the USB core handle the warm reset.
> * Stop timer when all ports have entered U0.

That's a much nicer version, thanks.

Few minor corrections below:

> [PATCH] usb: host: xhci: Compliance Mode Port Recovery

Better subject: "Fix compliance mode on SN65LVPE502CP hardware"?

As this is a fix for broken hardware, right?

> +	} else {
> +		/* If CAS bit isn't set but the Port is already at
> +		 * Compliance Mode, fake a connection so the USB core
> +		 * notices the Compliance state and resets the port

Add "This resolves an issue with the..." describing the hardware
problem?

> +					xhci_dbg(xhci, "Compliance Mode
> Recovery Timer "
> +						       "Deleted. All USB3
> ports have "
> +						       "entered U0 at least
> once.\n");

Keep the string all on one line.

> +/*Compliance Mode Recovery Patch*/

Why is this comment needed?

> +static void compliance_mode_rcvry(unsigned long arg)

Vowels are free, please use them :)

> +{
> +	struct xhci_hcd *xhci;
> +	struct usb_hcd *hcd;
> +	u32 temp;
> +	int i;
> +
> +	xhci = (struct xhci_hcd *) arg;

No space needed before "arg".

> +
> +	for (i = 0; i < xhci->num_usb3_ports; i++) {
> +		temp = xhci_readl(xhci, xhci->usb3_ports[i]);
> +		if ((temp & PORT_PLS_MASK) == USB_SS_PORT_LS_COMP_MOD) {
> +			/* Compliance Mode Detected. Letting USB Core handle
> +			 * the Warm Reset */

Multi-line comments are usually in this form:
			/*
			 * Compliance Mode Detected. Letting USB Core handle
			 * the Warm Reset.
			 */

> +			xhci_dbg(xhci, "Compliance Mode Detected on port %d!
> "
> +					"Attempting recovery routine.\n", i

Don't spread strings across lines, it makes it harder to grep for them.

> +static void compliance_mode_rcvry_timer_init(struct xhci_hcd *xhci)
> +{
> +	xhci->port_status_u0 = 0;
> +	init_timer(&xhci->comp_mode_rcvry_timer);
> +	xhci->comp_mode_rcvry_timer.data = (unsigned long) xhci;
> +	xhci->comp_mode_rcvry_timer.function = compliance_mode_rcvry;
> +	xhci->comp_mode_rcvry_timer.expires = jiffies +
> +		msecs_to_jiffies(COMP_MODE_RCVRY_MSECS);
> +	set_timer_slack(&xhci->comp_mode_rcvry_timer, HZ);

That seems like a pretty strict slack time.  Can't you make it much
larger?  Like at least COMP_MODE_RCVRY_MSECS?  You don't need a precise
timer here at all, so give it as much room to be delayed as possible.

> +	add_timer(&xhci->comp_mode_rcvry_timer);
> +	xhci_dbg(xhci, "Compliance Mode Recovery Timer Initialized.\n");
> +}
> +
>  /*
>   * Initialize memory for HCD and xHC (one-time init).
>   *
> @@ -420,6 +464,9 @@ int xhci_init(struct usb_hcd *hcd)
>  	retval = xhci_mem_init(xhci, GFP_KERNEL);
>  	xhci_dbg(xhci, "Finished xhci_init\n");
>  
> +	/* Initializing Compliance Mode Recovery Data */
> +	compliance_mode_rcvry_timer_init(xhci);

There's really no way we can detect this based on the hardware on the
system?  Firmware version number?  PCI ids?  DMI strings?  BIOS
versions?  Hardware platform types?  Processor types?  Something?
Anything?

What did Microsoft say in your proposal to them to add this timer for
every Windows system using xhci?

thanks,

greg k-h
