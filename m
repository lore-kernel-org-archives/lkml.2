Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753010Ab2FGP1E (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2012 11:27:04 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:54837 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751724Ab2FGP1B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2012 11:27:01 -0400
Date: Thu, 7 Jun 2012 11:27:00 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Stefani Seibold <stefani@seibold.net>
cc: Greg KH <gregkh@linuxfoundation.org>, <linux-kernel@vger.kernel.org>,
        <oneukum@suse.de>, <alan@lxorguk.ukuu.org.uk>,
        <linux-usb@vger.kernel.org>
Subject: Re: [PATCH 04/11] remove usb_interface pointer
In-Reply-To: <1339081423.13015.8.camel@wall-e>
Message-ID: <Pine.LNX.4.44L0.1206071118310.1185-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 7 Jun 2012, Stefani Seibold wrote:

> Am Donnerstag, den 07.06.2012, 10:28 -0400 schrieb Alan Stern:
> > On Thu, 7 Jun 2012, Stefani Seibold wrote:
> > 
> > > I tried to implement your idea to kick away the usb_device pointer, but
> > > i think it is impossible. The skel_delete() function needs the
> > > usb_device pointer for calling usb_put, which is called from
> > > skel_disconnect() or skel_release().
> >   
> > Does skel_delete() really need to call usb_put_dev()?  I suspect that  
> > the driver doesn't need to take a reference to either the device or the
> > interface.
> >  
> 
> I think it will be needed, since usb core will decrement the reference
> when the device go away.

But before it decrements the reference, it will unbind the driver.  As 
long as usb-skeleton is careful not to access the device or the 
interface after the disconnect routine returns, it doesn't need to keep 
a reference.

>  Lock every access to the usb core if a tedious
> thing and will waste a lot of code.

With proper design, it's not necessary to lock every access.

> The problem with hotpluging is not the plug, it is the unplug, which can
> happen any time.
> 
> BTW: An interface have no reference count.

Sure it does.  Look at the definitions of usb_get_intf() and 
usb_put_intf() in drivers/usb/core/usb.c.

> > If skel_delete is changed then we don't need the usb_device pointer.
> > 
> 
> I have no idea how to do this. Every USB driver i know stores the
> usb_device pointer.
> 
> Maybe you have an idea?

No, I was wrong.  It turns out we really do need to keep the udev 
pointer, because it gets used in calls to usb_fill_bulk_urb().  However 
there's nothing wrong with keeping pointers to both the device and the 
interface, if there's a good reason for doing so.

(It also gets used in calls to usb_alloc_coherent(), but I would prefer
to get rid of the coherent buffers.  They are rarely useful and don't
belong here.)

Alan Stern

