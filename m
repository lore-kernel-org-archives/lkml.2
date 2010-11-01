Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752873Ab0KATxE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Nov 2010 15:53:04 -0400
Received: from netrider.rowland.org ([192.131.102.5]:37677 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752392Ab0KATxB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Nov 2010 15:53:01 -0400
Date: Mon, 1 Nov 2010 15:53:00 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: Tatyana Brokhman <tlinder@codeaurora.org>
cc: USB list <linux-usb@vger.kernel.org>, Greg Kroah-Hartman <gregkh@suse.de>,
        Michal Nazarewicz <m.nazarewicz@samsung.com>,
        Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: [RFC/PATCH v3 1/4] usb: Add usb_endpoint_descriptor to be part
 of the struct usb_ep
In-Reply-To: <1288624285-32355-2-git-send-email-tlinder@codeaurora.org>
Message-ID: <Pine.LNX.4.44L0.1011011546190.21608-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 1 Nov 2010, Tatyana Brokhman wrote:

> Change usb_ep_enable() prototype to use endpoint descriptor from usb_ep.
> This optimization spares the FDs from saving the endpoint chosen
> descriptor. This optimization is not full though. To fully exploit this
> change one needs to update all the UDCs as well since in the current
> implementation each of them saves the endpoint descriptor in it's
> internal (and extended) endpoint structure.
> 
> Signed-off-by: Tatyana Brokhman <tlinder@codeaurora.org>


> diff --git a/drivers/usb/gadget/file_storage.c b/drivers/usb/gadget/file_storage.c
> index a857b7a..edd8727 100644
> --- a/drivers/usb/gadget/file_storage.c
> +++ b/drivers/usb/gadget/file_storage.c
> @@ -2745,7 +2745,8 @@ static int enable_endpoint(struct fsg_dev *fsg, struct usb_ep *ep,
>  	int	rc;
>  
>  	ep->driver_data = fsg;
> -	rc = usb_ep_enable(ep, d);
> +	ep->desc = (struct usb_endpoint_descriptor *)d;
> +	rc = usb_ep_enable(ep);
>  	if (rc)
>  		ERROR(fsg, "can't enable %s, result %d\n", ep->name, rc);
>  	return rc;

Instead of casting the variable, you should remove the "const"  
qualifiers here and in the callers.  After all, if usb_ep_enable is 
going to change the descriptor then we shouldn't call it "const".

Alternatively, if usb_ep_enable _isn't_ going to change the descriptor 
then perhaps the new pointer added to usb_ep should be declared 
"const".

Alan Stern

