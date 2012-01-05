Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756802Ab2AECqo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jan 2012 21:46:44 -0500
Received: from unserver.de ([88.198.20.135]:58945 "EHLO unserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754014Ab2AECqm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jan 2012 21:46:42 -0500
Date: Thu, 5 Jan 2012 02:46:34 +0000
From: Jan Steinhoff <mail@jan-steinhoff.de>
To: Oliver Neukum <oneukum@suse.de>
Cc: Alessandro Rubini <rubini@cvml.unipv.it>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        linux-input@vger.kernel.org, Jiri Kosina <jkosina@suse.cz>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] input: Synaptics USB device driver
Message-ID: <20120105024634.5c594566@greyhound>
In-Reply-To: <201201040926.00117.oneukum@suse.de>
References: <20120103194033.779cb829@greyhound>
	<201201040926.00117.oneukum@suse.de>
X-Mailer: Claws Mail 3.7.9 (GTK+ 2.24.6; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 4 Jan 2012 09:25:59 +0100
Oliver Neukum <oneukum@suse.de> wrote:

> Am Dienstag, 3. Januar 2012, 19:40:33 schrieb Jan Steinhoff:  
> > From: Jan Steinhoff <mail@jan-steinhoff.de>
> > 
> > This patch adds a driver for Synaptics USB touchpad or pointing
> > stick devices. These USB devices emulate an USB mouse by default,
> > so one can also use the usbhid driver. However, in combination with
> > special user space drivers this kernel driver allows one to
> > customize the behaviour of the device.  
> 
> Hi,
> 
> thank you for this driver. There are a few issues which I have
> commented on in the text.  

Hi,

I agree with most of the comments, but I have some further
questions/remarks below.

Best,
Jan

[...]
> [..]  
> > +
> > +/*
> > + * initialization of usb data structures
> > + */
> > +
> > +static int synusb_setup_iurb(struct synusb *synusb,
> > +			     struct usb_endpoint_descriptor
> > *endpoint) +{
> > +	char *buf;
> > +
> > +	if (endpoint->wMaxPacketSize < 8)
> > +		return 0;  
> 
> How could this happen?  

The id table can be modified via sysfs, so it is easily possible to try
this driver with officially unsupported devices. (At least for Synaptics
devices, there is a good chance this driver works just the same.) The
condition I put there was the only one I could think of to select when
it is not worth trying.

[...]
> > +static int synusb_suspend(struct usb_interface *intf, pm_message_t
> > message) +{
> > +	struct synusb *synusb = usb_get_intfdata(intf);
> > +
> > +	if (synusb == NULL)
> > +		return 0;  
> 
> How can this happen?  

According to the Documentation this can not happen. However, this check
is present in usb-skeleton.c, so I put it there just in case I
overlooked something.

[...]
> > +static struct usb_driver synusb_driver = {
> > +	.name =		"synaptics_usb",
> > +	.probe =	synusb_probe,
> > +	.disconnect =	synusb_disconnect,
> > +	.id_table =	synusb_idtable,
> > +	.suspend =	synusb_suspend,
> > +	.resume =	synusb_resume,
> > +	.pre_reset =	synusb_pre_reset,
> > +	.post_reset =	synusb_post_reset,
> > +	.reset_resume = synusb_reset_resume,
> > +	.supports_autosuspend = 1,  
> 
> Yet you do not manage the busy state. Do you really want to play
> ping-pong with the power state?  

The last time I tested autosuspend its timer was reseted "automatically"
every time an int urb arrived. Isn't this all that is needed for an
input device?

The autosuspend delay should of course be set to a reasonably large
value. Then there should be no ping-pong with the power state while the
device is actually used/touched. On the other hand, if the pad is not
touched for a while, then no int urb arrives and the device will
autosuspend (and, thanks to remote wakeup, autoresume nicely when
touched again).
