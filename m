Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754606Ab0LOSTK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Dec 2010 13:19:10 -0500
Received: from cantor.suse.de ([195.135.220.2]:48876 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754480Ab0LOSTI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Dec 2010 13:19:08 -0500
Date: Wed, 15 Dec 2010 10:18:54 -0800
From: Greg KH <gregkh@suse.de>
To: Cornelia Huck <cornelia.huck@de.ibm.com>
Cc: Kay Sievers <kay.sievers@vrfy.org>,
        Sebastian Ott <sebott@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC] bind/unbind uevent
Message-ID: <20101215181854.GA29205@suse.de>
References: <20101208160255.GB10313@suse.de>
 <alpine.LFD.2.02.1012132026430.2013@localhost6.localdomain6>
 <20101213193617.GA18262@suse.de>
 <alpine.LFD.2.02.1012141918520.1988@localhost6.localdomain6>
 <20101214192952.GA9106@suse.de>
 <20101215142113.7d416d78@gondolin>
 <20101215162316.GA31141@suse.de>
 <20101215183508.2f0b608b@gondolin>
 <AANLkTikC5hLpam0c-goU0KKLezgQJNBnWFJSKn8kdx0a@mail.gmail.com>
 <20101215190844.2b757eea@gondolin>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20101215190844.2b757eea@gondolin>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 15, 2010 at 07:08:44PM +0100, Cornelia Huck wrote:
> On Wed, 15 Dec 2010 18:51:48 +0100,
> Kay Sievers <kay.sievers@vrfy.org> wrote:
> 
> > 2010/12/15 Cornelia Huck <cornelia.huck@de.ibm.com>:
> > > On Wed, 15 Dec 2010 08:23:16 -0800, Greg KH <gregkh@suse.de> wrote:
> > >> On Wed, Dec 15, 2010 at 02:21:13PM +0100, Cornelia Huck wrote:
> > 
> > >> How about I turn it around for you, please show me how the driver core
> > >> does _not_ support this today?  If you can prove that this isn't working
> > >> properly, then great, I'll gladly accept patches to resolve it.
> > >
> > > Looking at device_add():
> > 
> > ...
> > 
> > > This will not be a problem if a device driver registers a child device
> > > (since it can specify the attributes there).
> > 
> > Which is the proper way to do it. No driver should ever mangle a
> > device which it does not own. It's like adding properties of a block
> > device directly to a usb_interface device. That just can not work
> > correctly for many reasons, inside and outside of the kernel.
> 
> That's fine for new device drivers.

No, that's for _all_ drivers, why should yours be "special" and not work
this way?

> > > I think the basic problem is that the KOBJ_ADD uevent notifies
> > > userspace that "a device is there", while the device will only be
> > > really useable by userspace once a driver has bound to it.
> > 
> > This device represents a device on a bus, and can usually do its own
> > things. A driver can bind to it, but should not mangle it.
> > 
> > > A module
> > > load triggered by KOBJ_ADD is fine, but trying to actually use the
> > > device after KOBJ_ADD is racy. This will not matter in the usual case,
> > > since either the matching/probing is fast enough or userspace will wait
> > > for something like a block device anyway, but we've seen problems on
> > > s390. A KOBJ_BIND/UNBIND would make a proper distinction between
> > > "device is there" and "device is usable".
> > 
> > We don't rally want any such events. We expect a new child device
> > being created from the driver, instead of re-using the existing bus
> > device.
> 
> Do we want to force a device driver to create a child device just to
> notify userspace of the bind?

That's the way all other buses and drivers work, again, why are your
devices and drivers "special" here?

> > > (Besides, what happens on unbind/bind? Shouldn't userspace know that a
> > > device is now bound to a different driver?)
> > 
> > It does that by watching the child devices the driver creates and destroys.
> > 
> > We already have enough events to handle on today's boxes, we really
> > don't want to add new ones, which are only needed to work around such
> > use cases, which ideally just should be fixed.
> > 
> > If you can not change the current drivers to create child devices, the
> > driver can probably just send change events for the already existing
> > devices it mangles from the driver.
> 
> Since introducing child devices would change the userspace interface, a
> change event on BUS_NOTIFY_BOUND_DRIVER would probably be the most
> reasonable for our busses.

No, you _already_ get those events, and you can add attributes
automatically when that happens today!

thanks,

greg k-h
