Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754661Ab1FOWnl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jun 2011 18:43:41 -0400
Received: from mga09.intel.com ([134.134.136.24]:47093 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753482Ab1FOWnk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jun 2011 18:43:40 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.65,371,1304319600"; 
   d="scan'208";a="14025997"
Date: Wed, 15 Jun 2011 15:43:38 -0700
From: Sarah Sharp <sarah.a.sharp@linux.intel.com>
To: Maarten Lankhorst <m.b.lankhorst@gmail.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-usb@vger.kernel.org, Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [PATCH v2] xhci: Add reset on resume quirk for asrock p67 host
Message-ID: <20110615224338.GA8705@xanatos>
References: <4DF92869.50105@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4DF92869.50105@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

No attached patches, just inline ones please. :)  I've fixed this up for
now, since your first patch was inline.

Sarah Sharp

On Wed, Jun 15, 2011 at 11:47:21PM +0200, Maarten Lankhorst wrote:
> The asrock p67 xhci controller completely dies on resume, add a
> quirk for this, to bring the host back online after a suspend.
> 
> This should be backported to stable kernels up until 2.6.37.
> 
> Signed-off-by: Maarten Lankhorst <m.b.lankhorst@gmail.com>
> Cc: stable@kernel.org
> ---
> V2: Fix inversed logic, and correct kernel version
> 
> diff --git a/drivers/usb/host/xhci-pci.c b/drivers/usb/host/xhci-pci.c
> index 17541d0..cb16de2 100644
> --- a/drivers/usb/host/xhci-pci.c
> +++ b/drivers/usb/host/xhci-pci.c
> @@ -29,6 +29,9 @@
>  #define PCI_VENDOR_ID_FRESCO_LOGIC	0x1b73
>  #define PCI_DEVICE_ID_FRESCO_LOGIC_PDK	0x1000
>  
> +#define PCI_VENDOR_ID_ETRON		0x1b6f
> +#define PCI_DEVICE_ID_ASROCK_P67	0x7023
> +
>  static const char hcd_name[] = "xhci_hcd";
>  
>  /* called after powerup, by probe or system-pm "wakeup" */
> @@ -134,6 +137,11 @@ static int xhci_pci_setup(struct usb_hcd *hcd)
>  		xhci->quirks |= XHCI_EP_LIMIT_QUIRK;
>  		xhci->limit_active_eps = 64;
>  	}
> +	if (pdev->vendor == PCI_VENDOR_ID_ETRON &&
> +			pdev->device == PCI_DEVICE_ID_ASROCK_P67) {
> +		xhci->quirks |= XHCI_RESET_ON_RESUME;
> +		xhci_dbg(xhci, "QUIRK: Resetting on resume\n");
> +	}
>  
>  	/* Make sure the HC is halted. */
>  	retval = xhci_halt(xhci);
> diff --git a/drivers/usb/host/xhci.c b/drivers/usb/host/xhci.c
> index 06e7023..17a0a08 100644
> --- a/drivers/usb/host/xhci.c
> +++ b/drivers/usb/host/xhci.c
> @@ -759,6 +759,8 @@ int xhci_resume(struct xhci_hcd *xhci, bool hibernated)
>  		msleep(100);
>  
>  	spin_lock_irq(&xhci->lock);
> +	if (xhci->quirks & XHCI_RESET_ON_RESUME)
> +		hibernated = true;
>  
>  	if (!hibernated) {
>  		/* step 1: restore register */
> diff --git a/drivers/usb/host/xhci.h b/drivers/usb/host/xhci.h
> index 7d1ea3b..b769a75 100644
> --- a/drivers/usb/host/xhci.h
> +++ b/drivers/usb/host/xhci.h
> @@ -1308,6 +1308,7 @@ struct xhci_hcd {
>   */
>  #define XHCI_EP_LIMIT_QUIRK	(1 << 5)
>  #define XHCI_BROKEN_MSI		(1 << 6)
> +#define XHCI_RESET_ON_RESUME	(1 << 7)
>  	unsigned int		num_active_eps;
>  	unsigned int		limit_active_eps;
>  	/* There are two roothubs to keep track of bus suspend info for */
> 
> 


