Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755030Ab0LPKWh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Dec 2010 05:22:37 -0500
Received: from mtagate6.uk.ibm.com ([194.196.100.166]:58063 "EHLO
	mtagate6.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754871Ab0LPKWb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Dec 2010 05:22:31 -0500
Date: Thu, 16 Dec 2010 11:22:34 +0100
From: Cornelia Huck <cornelia.huck@de.ibm.com>
To: Greg KH <gregkh@suse.de>
Cc: Kay Sievers <kay.sievers@vrfy.org>,
        Sebastian Ott <sebott@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC] bind/unbind uevent
Message-ID: <20101216112234.21e47f9e@gondolin>
In-Reply-To: <20101215181854.GA29205@suse.de>
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
	<20101215181854.GA29205@suse.de>
Organization: IBM Deutschland Research & Development GmbH Vorsitzender des
 Aufsichtsrats: Martin Jetter =?ISO-8859-15?Q?Gesch=E4ftsf=FChrung:?= Dirk
 Wittkopp Sitz der Gesellschaft: =?ISO-8859-15?Q?B=F6blingen?=
 Registergericht: Amtsgericht Stuttgart, HRB 243294
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 15 Dec 2010 10:18:54 -0800,
Greg KH <gregkh@suse.de> wrote:

> On Wed, Dec 15, 2010 at 07:08:44PM +0100, Cornelia Huck wrote:
> > On Wed, 15 Dec 2010 18:51:48 +0100,
> > Kay Sievers <kay.sievers@vrfy.org> wrote:
> > 
> > > 2010/12/15 Cornelia Huck <cornelia.huck@de.ibm.com>:
> > > > On Wed, 15 Dec 2010 08:23:16 -0800, Greg KH <gregkh@suse.de> wrote:
> > > >> On Wed, Dec 15, 2010 at 02:21:13PM +0100, Cornelia Huck wrote:
> > > 
> > > >> How about I turn it around for you, please show me how the driver core
> > > >> does _not_ support this today?  If you can prove that this isn't working
> > > >> properly, then great, I'll gladly accept patches to resolve it.
> > > >
> > > > Looking at device_add():
> > > 
> > > ...
> > > 
> > > > This will not be a problem if a device driver registers a child device
> > > > (since it can specify the attributes there).
> > > 
> > > Which is the proper way to do it. No driver should ever mangle a
> > > device which it does not own. It's like adding properties of a block
> > > device directly to a usb_interface device. That just can not work
> > > correctly for many reasons, inside and outside of the kernel.
> > 
> > That's fine for new device drivers.
> 
> No, that's for _all_ drivers, why should yours be "special" and not work
> this way?

Because it would break existing userspace.

> 
> > > > I think the basic problem is that the KOBJ_ADD uevent notifies
> > > > userspace that "a device is there", while the device will only be
> > > > really useable by userspace once a driver has bound to it.
> > > 
> > > This device represents a device on a bus, and can usually do its own
> > > things. A driver can bind to it, but should not mangle it.
> > > 
> > > > A module
> > > > load triggered by KOBJ_ADD is fine, but trying to actually use the
> > > > device after KOBJ_ADD is racy. This will not matter in the usual case,
> > > > since either the matching/probing is fast enough or userspace will wait
> > > > for something like a block device anyway, but we've seen problems on
> > > > s390. A KOBJ_BIND/UNBIND would make a proper distinction between
> > > > "device is there" and "device is usable".
> > > 
> > > We don't rally want any such events. We expect a new child device
> > > being created from the driver, instead of re-using the existing bus
> > > device.
> > 
> > Do we want to force a device driver to create a child device just to
> > notify userspace of the bind?
> 
> That's the way all other buses and drivers work, again, why are your
> devices and drivers "special" here?

?? This has nothing to do with our drivers. Why should a generic driver
that doesn't need extra attributes etc. create a child device? (Well,
if that's the way it's supposed to work...)

> 
> > > > (Besides, what happens on unbind/bind? Shouldn't userspace know that a
> > > > device is now bound to a different driver?)
> > > 
> > > It does that by watching the child devices the driver creates and destroys.
> > > 
> > > We already have enough events to handle on today's boxes, we really
> > > don't want to add new ones, which are only needed to work around such
> > > use cases, which ideally just should be fixed.
> > > 
> > > If you can not change the current drivers to create child devices, the
> > > driver can probably just send change events for the already existing
> > > devices it mangles from the driver.
> > 
> > Since introducing child devices would change the userspace interface, a
> > change event on BUS_NOTIFY_BOUND_DRIVER would probably be the most
> > reasonable for our busses.
> 
> No, you _already_ get those events, and you can add attributes
> automatically when that happens today!

But it is still _after_ the KOBJ_ADD uevent, which makes it still racy,
regardless of who adds the attributes. (And of course we would only do
the change event for our busses, not for everyone.)

Cornelia
