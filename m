Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760120Ab2EJPhd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2012 11:37:33 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:39897 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750902Ab2EJPhc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2012 11:37:32 -0400
Date: Thu, 10 May 2012 08:37:28 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Samuel Iglesias =?iso-8859-1?Q?Gons=E1lvez?= 
	<siglesias@igalia.com>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Manohar Vanga <manohar.vanga@cern.ch>,
        Dan Carpenter <dan.carpenter@oracle.com>
Subject: Re: [PATCH v4 1/3] Staging: IndustryPack bus for the Linux Kernel
Message-ID: <20120510153728.GA18574@kroah.com>
References: <1336570041-32724-1-git-send-email-siglesias@igalia.com>
 <20120509211338.GA23322@kroah.com>
 <1336659838.3458.24.camel@fourier.local.igalia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1336659838.3458.24.camel@fourier.local.igalia.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 10, 2012 at 04:23:58PM +0200, Samuel Iglesias Gonsálvez wrote:
> On Wed, 2012-05-09 at 14:13 -0700, Greg Kroah-Hartman wrote:
> > On Wed, May 09, 2012 at 03:27:19PM +0200, Samuel Iglesias Gonsalvez
> wrote:
> > > Add IndustryPack bus support for the Linux Kernel.
> > > 
> > > This is a virtual bus that allows to perform all the operations
> between
> > > carrier and mezzanine boards.
> > 
> > Note, I've accepted this patch, just a few comments that you might
> want
> > to fix up in future patches you send to me:
> > 
> 
> I am learning a lot thanks to your comments. 
> 
> I will fix them and send you the corresponding patches. I can also fix
> these patches directly and resend them, if you prefer that.

I've already accepted these patches into my tree (and you should have
gotten emails about this already), so I need incremental patches on top
of them now.

You should make them on top of my staging-next tree, the link to which
you got in the email when the patch was accepted.

> > > +++ b/drivers/staging/Kconfig
> > > @@ -24,6 +24,8 @@ menuconfig STAGING
> > >  
> > >  if STAGING
> > >  
> > > +source "drivers/staging/ipack/Kconfig"
> > > +
> > >  source "drivers/staging/et131x/Kconfig"
> > >  
> > >  source "drivers/staging/slicoss/Kconfig"
> > 
> > Why put yourself at the front of the list, and not at the end?
> 
> 
> My fault. I don't know if it is better to fix the patch or send another
> one adding myself at the end.
> 
> What do you think?

Please move it to the end.

> > > +static int ipack_assign_bus_number(void)
> > > +{
> > > +   int busnum;
> > > +
> > > +   mutex_lock(&ipack_mutex);
> > > +   busnum = find_next_zero_bit(busmap.busmap, IPACK_MAXBUS, 1);
> > 
> > Nice, but you also can use the ics interface as well, that keeps you
> > from having to have MAXBUS busses, if you want to.
> > 
> 
> I didn't know about the ics interface. The find_next_zero_bit and busmap
> code was taken from drivers/usb/core/hcd.c because it does the same I
> want to.

Ok, if the max number of busses is limited, then this is acceptable.
But if it isn't, then please use ics instead.

> > > +static void ipack_device_release(struct device *dev)
> > > +{
> > > +}
> > 
> > Weee.  As per the in-kernel documentation, I get to publically mock
> you
> > for doing something as foolish as thinking you are smarter than the
> > kernel by just creating an empty function for the release callback.
> > 
> > Did you think this really is the solution for when the kernel is
> > complaining to you about the fact that you need a callback function
> > here?  Surely I didn't just put that logic in the core for no good
> > reason now, right?
> > 
> > Please fix this up NOW.
> 
> OK, I will fix it. However reading my code, I don't see the need to
> kfree anything here, like in other drivers, for example.

Then your code is designed wrong.  You must free the memory here.  The
problem is that your "core" is not doing the allocation, but are relying
on the driver to do it instead.  Don't do that, the driver should not
have to do any of this at all.  Look at other busses for examples.

> Is it OK to have a pr_info notifying the release of the device or should
> I think again about it? 

You should never have a pr_info() call anywhere, what would a user do
with such a message?  That seems pretty pointless, right?

Also, please always use dev_*() calls instead of pr_*() calls, as you
should always have access to a struct device in your code.

> > > +++ b/drivers/staging/ipack/ipack.h
> > > @@ -0,0 +1,183 @@
> > > +/*
> > > + * Industry-pack bus.
> > > + *
> > > + * (C) 2011 Samuel Iglesias Gonsalvez <siglesia@cern.ch>, CERN
> > > + * (C) 2012 Samuel Iglesias Gonsalvez <siglesias@igalia.com>,
> Igalia
> > > + *
> > > + * This program is free software; you can redistribute it and/or
> modify it
> > > + * under the terms of the GNU General Public License as published
> by the Free
> > > + * Software Foundation; either version 2 of the License, or (at
> your option)
> > > + * any later version.
> > 
> > Again, "any later version", are you sure?  Be very sure about this
> > please.
> > 
> > > +struct ipack_device {
> > > +   char board_name[IPACK_BOARD_NAME_SIZE];
> > 
> > Why not use dev->name?
> 
> May I be wrong, do you refer rename it to "name"?

rename what?  Why do you need a board name for a device?  Shouldn't that
just be the "name" for the device?  And as such, just use the field you
already have.

> > > +   char bus_name[IPACK_BOARD_NAME_SIZE];

And, why do you need a bus name?  Shouldn't that be implied based on
what bus the device is attached to?

greg k-h
