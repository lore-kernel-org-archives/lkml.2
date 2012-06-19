Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753242Ab2FSWjf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2012 18:39:35 -0400
Received: from mga02.intel.com ([134.134.136.20]:38564 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751548Ab2FSWjd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2012 18:39:33 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,351,1309762800"; 
   d="scan'208";a="159741851"
Date: Tue, 19 Jun 2012 15:39:28 -0700
From: Sarah Sharp <sarah.a.sharp@linux.intel.com>
To: Alexis Cortes <alexis.cortes@ti.com>
Cc: gregkh@linuxfoundation.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, "'Quach, Brian'" <brian.quach@ti.com>,
        "'Llamas, Jorge'" <jorge.llamas@ti.com>
Subject: Re: [PATCH] usb: host: xhci: Compliance Mode port recovery
Message-ID: <20120619223928.GD21104@xanatos>
References: <002801cd4e68$a4b4f3a0$ee1edae0$@cortes@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <002801cd4e68$a4b4f3a0$ee1edae0$@cortes@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Alexis,

This is a quirk for your TI host controller because it doesn't properly
give a port status event for the link status change to compliance mode,
correct?

First, you need to add that background to your patch description, and
describe what triggers this behavior and how frequently it can occur.

Second, you need to make a separate xHCI quirk for your host controller,
set it based on the PCI vendor and device ID in xhci-pci.c, and only arm
the timer if the quirk is set.  We don't need this timer for any other
host controllers, so it should run only for your host.

If you need an example, look through the xHCI driver for
XHCI_EP_LIMIT_QUIRK.

On Tue, Jun 19, 2012 at 05:12:39PM -0500, Alexis Cortes wrote:
> This change creates a timer that monitors the PORTSC registers and recovers
> the
> port by issuing a Warm reset everytime Compliance mode is detected.

Your patch is line wrapped and can't be applied.  Please resend with a
mail client that won't mangle your patches.  I personally use mutt, but
you can take a look at Documentation/email-clients.txt for other
suggestions.

> Signed-off-by: Alexis R. Cortes <alexis.cortes@ti.com>
> ---
>  drivers/usb/host/xhci.c |   39 +++++++++++++++++++++++++++++++++++++++
>  drivers/usb/host/xhci.h |    4 ++++
>  2 files changed, 43 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/usb/host/xhci.c b/drivers/usb/host/xhci.c
> index afdc73e..a43e52b 100644
> --- a/drivers/usb/host/xhci.c
> +++ b/drivers/usb/host/xhci.c
> @@ -397,6 +397,39 @@ static void xhci_msix_sync_irqs(struct xhci_hcd *xhci)
>  
>  #endif
>  
> +static void compliance_mode_rcvry(unsigned long arg)
> +{
> +	struct xhci_hcd *xhci;
> +	u32 temp;
> +	int i;
> +
> +	xhci = (struct xhci_hcd *) arg;
> +	for (i = 0; i < xhci->num_usb3_ports; i++) {
> +		temp = xhci_readl(xhci, xhci->usb3_ports[i]);
> +		if ((temp & PORT_PLS_MASK) == USB_SS_PORT_LS_COMP_MOD) {

Um, what happens if the timer fires while the xHCI host is in PCI D3
because it has been auto-suspended?  All the registers read as
0xfffffff.  You should make sure to stop and restart the timer when the
the host is suspended.

> +			temp = xhci_port_state_to_neutral(temp);
> +			temp |= PORT_WR;
> +			xhci_writel(xhci, temp, xhci->usb3_ports[i]);
> +			xhci_dbg(xhci, "Compliance Mode Detected. Warm "
> +				       "reset performed to port %d for "
> +				       "recovery.\n", i + 1);

Instead of doing the warm reset here, you need to let the USB core
handle it. Here, you should kick khubd for the USB 3.0 roothub by
calling usb_hcd_poll_rh_status().  Look at
xhci-ring.c:handle_port_status() for an example.

Then in the xhci-hub.c code that checks for port changes, you should
fake a link status change.  The USB core will notice the status change
and see the port's link status of compliance.  Then the USB core will
take care of issuing the warm reset and doing a proper job of timing it.

You can see this sort of process by looking at the recent CAS patch:
http://marc.info/?l=linux-usb&m=134002582807373&w=2

Your patch will need to be built on top of that one, since that patch
adds support for issuing a warm reset when compliance mode is detected.

> +		}
> +	}
> +	mod_timer(&xhci->comp_mode_rcvry_timer,
> +		  jiffies + msecs_to_jiffies(COMP_MODE_RCVRY_TIMEOUT *
> 1000));

Everywhere you use COMP_MODE_RCVRY_TIMEOUT you multiply it by 1000.  Why
not just rename it to COMP_MODE_RCVRY_MSECS and define it to 2000?

> +}
> +
> +static void compliance_mode_rcvry_timer_init(struct xhci_hcd *xhci)
> +{
> +	init_timer(&xhci->comp_mode_rcvry_timer);
> +	xhci->comp_mode_rcvry_timer.data = (unsigned long) xhci;
> +	xhci->comp_mode_rcvry_timer.function = compliance_mode_rcvry;
> +	xhci->comp_mode_rcvry_timer.expires = jiffies +
> +		msecs_to_jiffies(COMP_MODE_RCVRY_TIMEOUT * 1000);
> +	add_timer(&xhci->comp_mode_rcvry_timer);
> +	xhci_dbg(xhci, "Compliance Mode Recovery Timer Initialized.\n");
> +}
> +

This function should immediately return if your new quirk isn't set.

>  /*
>   * Initialize memory for HCD and xHC (one-time init).
>   *
> @@ -420,6 +453,9 @@ int xhci_init(struct usb_hcd *hcd)
>  	retval = xhci_mem_init(xhci, GFP_KERNEL);
>  	xhci_dbg(xhci, "Finished xhci_init\n");
>  
> +	/* Initializing Compliance Mode Recovery Timer */
> +	compliance_mode_rcvry_timer_init(xhci);
> +
>  	return retval;
>  }
>  
> @@ -628,6 +664,9 @@ void xhci_stop(struct usb_hcd *hcd)
>  	del_timer_sync(&xhci->event_ring_timer);
>  #endif
>  
> +	/* Deleting Compliance Mode Recovery Timer */
> +	del_timer_sync(&xhci->comp_mode_rcvry_timer);
> +

You need to put this into a new function that also returns immediately
if your quirk isn't set.

>  	if (xhci->quirks & XHCI_AMD_PLL_FIX)
>  		usb_amd_dev_put();
>  
> diff --git a/drivers/usb/host/xhci.h b/drivers/usb/host/xhci.h
> index de3d6e3..0f11cb8 100644
> --- a/drivers/usb/host/xhci.h
> +++ b/drivers/usb/host/xhci.h
> @@ -1506,6 +1506,10 @@ struct xhci_hcd {
>  	unsigned		sw_lpm_support:1;
>  	/* support xHCI 1.0 spec USB2 hardware LPM */
>  	unsigned		hw_lpm_support:1;
> +	/* Compliance Mode Recovery Timer */
> +	struct timer_list comp_mode_rcvry_timer;
> +/* Compliance Mode Timer Triggered every 2 seconds */
> +#define COMP_MODE_RCVRY_TIMEOUT 2

How often do you really need this timer to run?  Do you really want to
wake your CPU out of deep C states every two seconds?  Is there any way
you can narrow the scope of when the timer runs so that it doesn't run
that often, or increase this timeout to something like 10 seconds?

Sarah Sharp
