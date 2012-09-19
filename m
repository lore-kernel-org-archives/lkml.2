Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751120Ab2ISTfn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2012 15:35:43 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:46912 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750798Ab2ISTfl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2012 15:35:41 -0400
Date: Wed, 19 Sep 2012 20:35:36 +0100
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Joe Perches <joe@perches.com>
Cc: netdev@vger.kernel.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] USB: remove dbg() usage in USB networking drivers
Message-ID: <20120919193536.GA13933@kroah.com>
References: <20120919171316.GA12248@kroah.com>
 <1348077212.22122.13.camel@joe2Laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1348077212.22122.13.camel@joe2Laptop>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 19, 2012 at 10:53:32AM -0700, Joe Perches wrote:
> On Wed, 2012-09-19 at 18:13 +0100, Greg Kroah-Hartman wrote:
> > The dbg() USB macro is so old, it predates me.  The USB networking drivers are
> > the last hold-out using this macro, and we want to get rid of it, so replace
> > the usage of it with the proper netdev_dbg() or dev_dbg() (depending on the
> > context) calls.
> 
> There's a missing newline.

Oops, good catch.

> There are several dev_err(&intf-dev, ...) to dev_err(dev, ...)
> conversions.

That is because there is now a local variable for this, so I fixed the
whole function up to use it at the same time.

> Either those should be in a separate patch or you should mention
> those changes in the commit message.

Ok, let me resend...

> > diff --git a/drivers/net/usb/catc.c b/drivers/net/usb/catc.c
> > index 26c5beb..6bf5672 100644
> > --- a/drivers/net/usb/catc.c
> > +++ b/drivers/net/usb/catc.c
> > @@ -236,7 +236,8 @@ static void catc_rx_done(struct urb *urb)
> >  	}
> >  
> >  	if (status) {
> > -		dbg("rx_done, status %d, length %d", status, urb->actual_length);
> > +		dev_dbg(&urb->dev->dev, "rx_done, status %d, length %d",
> > +			status, urb->actual_length);
> 
> newline
> 
> > @@ -774,7 +783,7 @@ static int catc_probe(struct usb_interface *intf, const struct usb_device_id *id
> >  
> >  	if (usb_set_interface(usbdev,
> >  			intf->altsetting->desc.bInterfaceNumber, 1)) {
> > -                dev_err(&intf->dev, "Can't set altsetting 1.\n");
> > +		dev_err(dev, "Can't set altsetting 1.\n");
> 
> ?  Odd conversion.

We now have the local variable, so use it for all dev_* calls.

I've been doing that with the 30+ other dbg() cleanup patches in the usb
tree recently.

> > diff --git a/drivers/net/usb/kaweth.c b/drivers/net/usb/kaweth.c
> []
> > @@ -787,7 +787,8 @@ static void kaweth_usb_transmit_complete(struct urb *urb)
> >  
> >  	if (unlikely(status != 0))
> >  		if (status != -ENOENT)
> > -			dbg("%s: TX status %d.", kaweth->net->name, status);
> > +			dev_dbg(&urb->dev->dev, "%s: TX status %d.\n",
> > +				kaweth->net->name, status);
> 
> probably
> 			netdev_dbg(kaweth->net, "TX status %d\n", status);
> 
> [] 

It's the status of the urb that we want here, it is what failed, not the
netdev.  That's the way the rest of the kernel handles urb status debug
messages, so I'm trying to be consistant here.

> 
> > @@ -1003,36 +1005,37 @@ static int kaweth_probe(
> >  		const struct usb_device_id *id      /* from id_table */
> >  	)
> >  {
> > -	struct usb_device *dev = interface_to_usbdev(intf);
> > +	struct device *dev = &intf->dev;
> > +	struct usb_device *udev = interface_to_usbdev(intf);
> 
> Miscellaneous renaming.

Consistant renaming :)

> > diff --git a/drivers/net/usb/net1080.c b/drivers/net/usb/net1080.c
> > index 28c4d51..aad7abe 100644
> > --- a/drivers/net/usb/net1080.c
> > +++ b/drivers/net/usb/net1080.c
> > @@ -156,11 +156,11 @@ static void nc_dump_registers(struct usbnet *dev)
> >  	u16	*vp = kmalloc(sizeof (u16));
> >  
> >  	if (!vp) {
> > -		dbg("no memory?");
> > +		netdev_dbg(dev->net, "no memory?\n");
> 
> could delete altogether.

Yeah, will do.

Thanks for the review, let me respin this...

greg k-h
