Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753513Ab1AXQcj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jan 2011 11:32:39 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:42214 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753397Ab1AXQch (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jan 2011 11:32:37 -0500
Date: Mon, 24 Jan 2011 11:32:36 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Robert Morell <rmorell@nvidia.com>
cc: David Brownell <dbrownell@users.sourceforge.net>,
        Greg Kroah-Hartman <gregkh@suse.de>, Benoit Goby <benoit@android.com>,
        Sarah Sharp <sarah.a.sharp@linux.intel.com>,
        Matthew Wilcox <willy@linux.intel.com>,
        Ming Lei <tom.leiming@gmail.com>, Jacob Pan <jacob.jun.pan@intel.com>,
        Oliver Neukum <oliver@neukum.org>, Olof Johansson <olof@lixom.net>,
        Erik Gilling <konkers@android.com>, Colin Cross <ccross@android.com>,
        <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 1/2] USB: HCD: Add driver hooks for (un)?map_urb_for_dma
In-Reply-To: <1295559715-14264-2-git-send-email-rmorell@nvidia.com>
Message-ID: <Pine.LNX.4.44L0.1101241126220.2030-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 20 Jan 2011, Robert Morell wrote:

> Provide optional hooks for the host controller driver to override the
> default DMA mapping and unmapping routines.  In general, these shouldn't
> be necessary unless the host controller has special DMA requirements,
> such as alignment contraints.  If these are not specified, the
> general usb_hcd_(un)?map_urb_for_dma functions will be used instead.
> Also, pass the status to unmap_urb_for_dma so it can know whether the
> DMA buffer has been overwritten.
> 
> Finally, add a flag to be used by these implementations if they
> allocated a temporary buffer so it can be freed properly when unmapping.

Overall this looks fine.

> Signed-off-by: Robert Morell <rmorell@nvidia.com>
> ---
> 
> The original patches renamed the exported symbols from
> (un)?map_urb_setup_for_dma to usb_hcd_(un)?map_urb_setup_for_dma, and continued
> to use the ones not prefixed by "usb_hcd" internally.  However, due to commit
> 1dae423dd9b which already exported unmap_urb_setup_for_dma as-is, I reworked
> this to export both unchanged and switch to the hooked_ prefix internally.

In fact, it would be preferable to have the "usb_" or "usb_hcd_" prefix
on exported symbols.  Can you write a third patch to go before these
two, which changes the existing usages?  I think there aren't too many.

> diff --git a/include/linux/usb/hcd.h b/include/linux/usb/hcd.h
> index 0b6e751..dc487ff 100644
> --- a/include/linux/usb/hcd.h
> +++ b/include/linux/usb/hcd.h
> @@ -233,6 +233,18 @@ struct hc_driver {
>  	int	(*urb_dequeue)(struct usb_hcd *hcd,
>  				struct urb *urb, int status);
>  
> +	/* (optional) these hooks allow an HCD to override the default DMA
> +	 * mapping and unmapping routines.  In general, they shouldn't be
> +	 * necessary unless the host controller has special DMA requirements,
> +	 * such as alignment contraints.  If these are not specified, the
> +         * general (un)?map_urb_for_dma functions will be used instead (and it
> +         * may be a good idea to call these functions in your HCD
> +         * implementation) */

Leading tabs vs. spaces.  Also, the style rules (not always rigorously
followed, but we may as well try) require the /* and */ to be on their
own lines.

Alan Stern

