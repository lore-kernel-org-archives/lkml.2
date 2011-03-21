Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752476Ab1CUAlT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Mar 2011 20:41:19 -0400
Received: from cantor2.suse.de ([195.135.220.15]:60628 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752181Ab1CUAlQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Mar 2011 20:41:16 -0400
Date: Mon, 21 Mar 2011 01:41:14 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Greg KH <gregkh@suse.de>, Oliver Neukum <oneukum@suse.de>
Cc: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
Subject: Re: "usb_wwan: error case of resume" (16871dcac) is buggy
In-Reply-To: <alpine.LNX.2.00.1103210130260.19969@pobox.suse.cz>
Message-ID: <alpine.LNX.2.00.1103210140530.19969@pobox.suse.cz>
References: <alpine.LNX.2.00.1103210130260.19969@pobox.suse.cz>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


[ fixing Oliver's address in CC ]

On Mon, 21 Mar 2011, Jiri Kosina wrote:

> Hi,
> 
> the commit in subject make the kernel with CONFIG_PM_RUNTIME unset fail 
> during compilation, as struct dev_pm_info doesn't have whole bunch of 
> members in such case.
> 
> The commit in question adds this code:
> 
> 	/* we have to throw away the rest */
> 	do {
> 		unbusy_queued_urb(urb, portdata);
> 		//extremely dirty
> 		atomic_dec(&port->serial->interface->dev.power.usage_count);
> 	} while ((urb = usb_get_from_anchor(&portdata->delayed)));
> 
> The 'extermely dirty' comment makes me a bit nervous whether the patch 
> below is correct or some more thinking would be necessary.
> 
> 
> 
> From: Jiri Kosina <jkosina@suse.cz>
> Subject: [PATCH] USB: usb_wvan: fix compilation for !CONFIG_PM_RUNTIME case
> 
> With CONFIG_PM_RUNTIME unset, struct dev_pm_info doesn't have
> usage count which is used only for run-time power management
> purposes.
> 
> Signed-off-by: Jiri Kosina <jkosina@suse.cz>
> ---
>  drivers/usb/serial/usb_wwan.c |    4 +++-
>  1 files changed, 3 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/usb/serial/usb_wwan.c b/drivers/usb/serial/usb_wwan.c
> index a65ddd5..8b456dc 100644
> --- a/drivers/usb/serial/usb_wwan.c
> +++ b/drivers/usb/serial/usb_wwan.c
> @@ -698,8 +698,10 @@ static void play_delayed(struct usb_serial_port *port)
>  			/* we have to throw away the rest */
>  			do {
>  				unbusy_queued_urb(urb, portdata);
> -				//extremely dirty
> +#ifdef CONFIG_PM_RUNTIME
> +				/* extremely dirty */
>  				atomic_dec(&port->serial->interface->dev.power.usage_count);
> +#endif
>  			} while ((urb = usb_get_from_anchor(&portdata->delayed)));
>  			break;
>  		}
> -- 
> 1.7.3.1
> 
> 

-- 
Jiri Kosina
SUSE Labs, Novell Inc.
