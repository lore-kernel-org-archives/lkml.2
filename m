Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752209Ab1LSQ1Z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Dec 2011 11:27:25 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:47268 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751556Ab1LSQ1W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Dec 2011 11:27:22 -0500
Date: Mon, 19 Dec 2011 11:27:21 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Felipe Balbi <balbi@ti.com>
cc: Linux USB Mailing List <linux-usb@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Thomas Dahlmann <dahlmann.thomas@arcor.de>,
        Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>,
        "open list:DESIGNWARE USB3 D..." <linux-omap@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        "open list:AMD GEODE CS5536..." <linux-geode@lists.infradead.org>
Subject: Re: [PATCH 1/9] usb: gadget: add generic map/unmap request utilities
In-Reply-To: <20111219154931.GA30355@legolas.emea.dhcp.ti.com>
Message-ID: <Pine.LNX.4.44L0.1112191116320.1746-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 19 Dec 2011, Felipe Balbi wrote:

> > > +		if (dma_mapping_error(&gadget->dev, req->dma)) {
> > > +			dev_err(&gadget->dev, "failed to map buffer\n");
> > > +			return -EFAULT;
> > > +		}
> > > +	}
> > > +
> > > +	return 0;
> > 
> > You forgot to set req->mapped.
> 
> actually there's no 'mapped' field on struct usb_request. That's a

Whoops, you're right.  It's part of the UDC-private structure.

> nonsense added to all struct my_controller_request just because of that
> DMA_ADDR_INVALID hackery. I'm dropping that completely. There were no
> gadget drivers allocating memory from coherent or mapping requests
> themselves, so req->mapped becomes useless.

There's more to it than that.  A controller might support DMA on some
endpoints but not others, or for certain request lengths but not
others.  Hence when a request finishes, the driver needs to know
whether the request was mapped for DMA.

For example, your net2280 patch needs to be fixed.  Here's how it looks
now:

> --- a/drivers/usb/gadget/net2280.c
> +++ b/drivers/usb/gadget/net2280.c
> @@ -806,12 +806,8 @@ done (struct net2280_ep *ep, struct net2280_request *req, int status)
>  		status = req->req.status;
>  
>  	dev = ep->dev;
> -	if (req->mapped) {
> -		pci_unmap_single (dev->pdev, req->req.dma, req->req.length,
> -			ep->is_in ? PCI_DMA_TODEVICE : PCI_DMA_FROMDEVICE);
> -		req->req.dma = DMA_ADDR_INVALID;
> -		req->mapped = 0;
> -	}
> +	if (req->mapped)
> +		usb_gadget_unmap_request(&dev->gadget, &req->req, ep->is_in);

This code will never be executed because you never set req->mapped.  
And after that's fixed, when the unmapping occurs, req->mapped has to
be set back to 0.

> @@ -857,10 +853,13 @@ net2280_queue (struct usb_ep *_ep, struct usb_request *_req, gfp_t gfp_flags)
>  		return -EOPNOTSUPP;
>  
>  	/* set up dma mapping in case the caller didn't */
> -	if (ep->dma && _req->dma == DMA_ADDR_INVALID) {
> -		_req->dma = pci_map_single (dev->pdev, _req->buf, _req->length,
> -			ep->is_in ? PCI_DMA_TODEVICE : PCI_DMA_FROMDEVICE);
> -		req->mapped = 1;
> +	if (ep->dma) {
> +		int ret;
> +
> +		ret = usb_gadget_map_request(&dev->gadget, &req->req,
> +				ep->is_in);
> +		if (ret)
> +			return ret;

You probably need to set req->mapped right here.  Or rather, avoid 
removing the line that sets it.

>  	}

Alan Stern

