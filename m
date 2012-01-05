Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758065Ab2AEGgW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jan 2012 01:36:22 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:52261 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751317Ab2AEGgS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jan 2012 01:36:18 -0500
Date: Wed, 4 Jan 2012 22:36:11 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Jan Steinhoff <mail@jan-steinhoff.de>
Cc: Oliver Neukum <oneukum@suse.de>, Jiri Kosina <jkosina@suse.cz>,
        Alessandro Rubini <rubini@cvml.unipv.it>, linux-input@vger.kernel.org,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] input: Synaptics USB device driver
Message-ID: <20120105063611.GB31895@core.coreip.homeip.net>
References: <20120103194033.779cb829@greyhound>
 <201201041020.41795.oneukum@suse.de>
 <20120104094103.GA29069@core.coreip.homeip.net>
 <201201041056.20226.oneukum@suse.de>
 <20120104100553.GA29131@core.coreip.homeip.net>
 <20120105060138.704cfb16@greyhound>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120105060138.704cfb16@greyhound>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 05, 2012 at 06:01:38AM +0000, Jan Steinhoff wrote:
> On Wed, 4 Jan 2012 02:05:53 -0800
> Dmitry Torokhov <dmitry.torokhov@gmail.com> wrote:
> > On Wed, Jan 04, 2012 at 10:56:20AM +0100, Oliver Neukum wrote:
> > > Am Mittwoch, 4. Januar 2012, 10:41:03 schrieb Dmitry Torokhov:
> > > > +static int synusb_probe(struct usb_interface *intf,
> > > > +			const struct usb_device_id *id)
> > > > +{
> [...]
> > > > +	synusb->urb = usb_alloc_urb(0, GFP_KERNEL);
> > > > +	if (!synusb->urb) {
> > > > +		error = -ENOMEM;
> > > > +		goto err_free_mem;
> > > > +	}
> > > > +
> > > > +	synusb->data = usb_alloc_coherent(udev,
> > > > SYNUSB_RECV_SIZE, GFP_KERNEL,
> > > > +
> > > > &synusb->urb->transfer_dma);
> > > > +	if (!synusb->data) {
> > > > +		error = -ENOMEM;
> > > > +		goto err_free_urb;
> > > > +	}
> > > > +
> > > > +	usb_fill_int_urb(synusb->urb, udev,
> > > > +			 usb_rcvintpipe(udev,
> > > > ep->bEndpointAddress),
> > > > +			 synusb->data, SYNUSB_RECV_SIZE,
> > > > +			 synusb_irq, synusb,
> > > > +			 ep->bInterval);
> > > > +	synusb->urb->transfer_flags |= URB_NO_TRANSFER_DMA_MAP;
> > > 
> > > According to the comment in the original driver you must submit the
> > > URB. Are you sure not doing so is save?
> > 
> > Seems to work here...
> 
> Let me comment on this issue in more detail, so you can better judge
> what is the "right" solution here.
> 
> Both ways actually work. But, at least for the cPad, the device will
> pretend it got reconnected if the int urb is not fetched (while not
> suspended, of course). This means it would disconnect if no input device
> is opened (AFAIK most X.org input drivers close the devices when one
> switches to console) and one touches the pad (actually, a slight breeze
> of air might be enough, it is very sensitive!). Another annoying side
> effect in the case of the cPad is that the background light flashes on
> every reconnect.

OK, then maybe we should have cPad start transfers immediately and let
other devices do it in open. There is no reason to do work if nobody
interested in it...

Another option is to move configuring interface to open()?

Thanks.

-- 
Dmitry
