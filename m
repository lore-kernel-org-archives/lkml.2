Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751172Ab1EIJ0H (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 May 2011 05:26:07 -0400
Received: from na3sys009aog117.obsmtp.com ([74.125.149.242]:37972 "EHLO
	na3sys009aog117.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750707Ab1EIJ0F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 May 2011 05:26:05 -0400
Date: Mon, 9 May 2011 12:25:58 +0300
From: Felipe Balbi <balbi@ti.com>
To: Tatyana Brokhman <tlinder@codeaurora.org>
Cc: greg@kroah.com, linux-usb@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        balbi@ti.com, ablay@codeaurora.org, Maya Erez <merez@codeaurora.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v9 5/7] usb: Add streams support to the gadget framework
Message-ID: <20110509092555.GF1254@legolas.emea.dhcp.ti.com>
Reply-To: balbi@ti.com
References: <1304853414-10234-1-git-send-email-tlinder@codeaurora.org>
 <1304853414-10234-6-git-send-email-tlinder@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1304853414-10234-6-git-send-email-tlinder@codeaurora.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Sun, May 08, 2011 at 02:16:46PM +0300, Tatyana Brokhman wrote:
> This patch defines necessary fields to support streaming for USB3.0.
> It implements a new function (usb_ep_autoconfig_ss) to be used instead of
> the existing usb_ep_autoconfig when working in SS mode and there is a
> need to search for an endpoint according to the number of required
> streams.
> 
> Signed-off-by: Maya Erez <merez@codeaurora.org>
> Signed-off-by: Tatyana Brokhman <tlinder@codeaurora.org>
> 
> ---
>  drivers/usb/gadget/epautoconf.c |  125 +++++++++++++++++++++++++++++++--------
>  include/linux/usb/gadget.h      |   10 +++
>  2 files changed, 110 insertions(+), 25 deletions(-)
> 
> diff --git a/drivers/usb/gadget/epautoconf.c b/drivers/usb/gadget/epautoconf.c
> index e7e373a..920d1fa 100644
> --- a/drivers/usb/gadget/epautoconf.c
> +++ b/drivers/usb/gadget/epautoconf.c
> @@ -63,13 +63,16 @@ static int
>  ep_matches (
>  	struct usb_gadget		*gadget,
>  	struct usb_ep			*ep,
> -	struct usb_endpoint_descriptor	*desc
> +	struct usb_endpoint_descriptor	*desc,
> +	struct usb_ss_ep_comp_descriptor *ep_comp
>  )
>  {
>  	u8		type;
>  	const char	*tmp;
>  	u16		max;
>  
> +	int		num_req_streams = 0;
> +
>  	/* endpoint already claimed? */
>  	if (NULL != ep->driver_data)
>  		return 0;
> @@ -129,6 +132,22 @@ ep_matches (
>  	}
>  
>  	/*
> +	 * Get the number of required streams from the EP companion
> +	 * descriptor and see if the EP matches it
> +	 */
> +	if (usb_endpoint_xfer_bulk(desc)) {
> +		if (ep_comp) {
> +			num_req_streams = ep_comp->bmAttributes & 0x1f;
> +			if (num_req_streams > ep->max_streams)
> +				return 0;

We would like the gadget drivers to all with all controllers, this would
likely be better to ask from controller driver for N streams but work if
we get less ? Something like:

struct usb_gadget_ops {
	...
	request_stream(struct usb_gadget *g, int max_streams);
};

if (usb_endpoint_xfer_bulk(desc)) {
	if (ep_comp) {
		num_req_streams = usb_gadget_request_streams(gadget,
			ep_comp->bmAttributes & 0x1f);

		/* now patch ep_comp descriptor */
		ep_comp->bmAttributes = num_req_streams;
	}
}

this way, different function drivers can request for a different number
of streams and controller driver is required to keep track of total
number of streams, and number of "busy" streams.

Another approach would be to require function drivers to request the
streams during bind by themselves and only give this layer correct
descriptors, which allow you to make those arguments const.

-- 
balbi
