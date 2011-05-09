Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751284Ab1EIJTU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 May 2011 05:19:20 -0400
Received: from na3sys009aog114.obsmtp.com ([74.125.149.211]:58806 "EHLO
	na3sys009aog114.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750707Ab1EIJTS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 May 2011 05:19:18 -0400
Date: Mon, 9 May 2011 12:19:10 +0300
From: Felipe Balbi <balbi@ti.com>
To: Tatyana Brokhman <tlinder@codeaurora.org>
Cc: greg@kroah.com, linux-usb@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        balbi@ti.com, ablay@codeaurora.org,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v9 4/7] usb:gadget: Add SuperSpeed support to the Gadget
 Framework
Message-ID: <20110509091904.GE1254@legolas.emea.dhcp.ti.com>
Reply-To: balbi@ti.com
References: <1304853414-10234-1-git-send-email-tlinder@codeaurora.org>
 <1304853414-10234-5-git-send-email-tlinder@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1304853414-10234-5-git-send-email-tlinder@codeaurora.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 08, 2011 at 02:16:45PM +0300, Tatyana Brokhman wrote:
> This patch adds the SuperSpeed functionality to the gadget framework.
> Support for new SuperSpeed BOS descriptor was added.
> Support for SET_FEATURE and GET_STATUS requests in SuperSpeed mode was
> added.
> 
> Signed-off-by: Tatyana Brokhman <tlinder@codeaurora.org>
> 
> ---
>  drivers/usb/gadget/Kconfig      |   11 ++
>  drivers/usb/gadget/composite.c  |  234 ++++++++++++++++++++++++++++++++++++---
>  drivers/usb/gadget/epautoconf.c |    7 +-
>  include/linux/usb/ch9.h         |    2 -
>  include/linux/usb/composite.h   |   16 +++
>  include/linux/usb/gadget.h      |   34 ++++++
>  6 files changed, 284 insertions(+), 20 deletions(-)
> 
> diff --git a/drivers/usb/gadget/Kconfig b/drivers/usb/gadget/Kconfig
> index 4c02b9f..4c4ba47 100644
> --- a/drivers/usb/gadget/Kconfig
> +++ b/drivers/usb/gadget/Kconfig
> @@ -623,6 +623,17 @@ config USB_GADGET_DUALSPEED
>  	  Means that gadget drivers should include extra descriptors
>  	  and code to handle dual-speed controllers.
>  
> +config USB_GADGET_SUPERSPEED
> +	boolean "Gadget operating in Super Speed"
> +	depends on USB_GADGET
> +	depends on USB_GADGET_DUALSPEED
> +	help
> +	  Enabling this feature enables Super Speed support in the Gadget
> +	  driver. It means that gadget drivers should provide extra (SuperSpeed)
> +	  descriptors to the host.
> +	  For composite devices: if SuperSpeed descriptors weren't supplied by
> +	  the FD, they will be automatically generated with default values.
> +
>  #
>  # USB Gadget Drivers
>  #
> diff --git a/drivers/usb/gadget/composite.c b/drivers/usb/gadget/composite.c
> index b94e573..a622af5 100644
> --- a/drivers/usb/gadget/composite.c
> +++ b/drivers/usb/gadget/composite.c
> @@ -129,6 +129,9 @@ int config_ep_by_speed(struct usb_gadget *g,
>  	struct usb_endpoint_descriptor *chosen_desc = NULL;
>  	struct usb_descriptor_header **speed_desc = NULL;
>  
> +	struct usb_ss_ep_comp_descriptor *comp_desc = NULL;
> +	int want_comp_desc = 0;
> +
>  	struct usb_descriptor_header **d_spd; /* cursor for speed desc */
>  
>  	if (!g || !f || !_ep)
> @@ -136,6 +139,13 @@ int config_ep_by_speed(struct usb_gadget *g,
>  
>  	/* select desired speed */
>  	switch (g->speed) {
> +	case USB_SPEED_SUPER:
> +		if (gadget_is_superspeed(g)) {
> +			speed_desc = f->ss_descriptors;
> +			want_comp_desc = 1;
> +			break;
> +		}
> +		/* else: Fall trough */
>  	case USB_SPEED_HIGH:
>  		if (gadget_is_dualspeed(g)) {
>  			speed_desc = f->hs_descriptors;
> @@ -157,7 +167,31 @@ ep_found:
>  	/* commit results */
>  	_ep->maxpacket = le16_to_cpu(chosen_desc->wMaxPacketSize);
>  	_ep->desc = chosen_desc;
> -
> +	_ep->comp_desc = NULL;
> +	_ep->maxburst = 0;
> +	_ep->mult = 0;
> +	if (want_comp_desc) {
> +		/*
> +		 * Companion descriptor should follow EP descriptor
> +		 * USB 3.0 spec, #9.6.7
> +		 */
> +		comp_desc = (struct usb_ss_ep_comp_descriptor *)*(++d_spd);
> +		if (!comp_desc ||
> +		    (comp_desc->bDescriptorType != USB_DT_SS_ENDPOINT_COMP))
> +			return -EIO;
> +		_ep->comp_desc = comp_desc;
> +		if (g->speed == USB_SPEED_SUPER) {
> +			int xfer_type = _ep->bEndpointAddress &
> +				USB_ENDPOINT_XFERTYPE_MASK ;

how about something liks:

switch (usb_endpoint_type(_ep->desc) {
case USB_ENDPOINT_XFER_BULK:
case USB_ENDPOINT_XFER_INT:
	_ep->maxburst = comp_desc->bMaxBurst;
	break;
case USB_ENDPOINT_XFER_ISOC:
	_ep->mult = comp_desc->bmAttributes & 0x03;
	break;
default:
	/* nothing to do for control endpoints */
	break;
}

-- 
balbi
