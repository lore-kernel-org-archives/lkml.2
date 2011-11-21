Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757330Ab1KUVtR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Nov 2011 16:49:17 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:47679 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1757313Ab1KUVtJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Nov 2011 16:49:09 -0500
Date: Mon, 21 Nov 2011 16:49:09 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: Linux PM list <linux-pm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Randy Dunlap <rdunlap@xenotime.net>
Subject: Re: [PATCH 5] PM: Update comments describing device power management
 callbacks
In-Reply-To: <201111212223.15878.rjw@sisk.pl>
Message-ID: <Pine.LNX.4.44L0.1111211642060.1848-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 21 Nov 2011, Rafael J. Wysocki wrote:

> On Monday, November 21, 2011, Alan Stern wrote:
> > On Mon, 21 Nov 2011, Rafael J. Wysocki wrote:
> > 
> > > > >   * @freeze: Hibernation-specific, executed before creating a hibernation image.
> > > > > - *	Quiesce operations so that a consistent image can be created, but do NOT
> > > > > - *	otherwise put the device into a low power device state and do NOT emit
> > > > > - *	system wakeup events.  Save in main memory the device settings to be
> > > > > - *	used by @restore() during the subsequent resume from hibernation or by
> > > > > - *	the subsequent @thaw(), if the creation of the image or the restoration
> > > > > - *	of main memory contents from it fails.
> > > > > + *	Analogous to @suspend(), but it should not enable the device to signal
> > > > > + *	wakeup events.  The majority of subsystems (with the notable exception
> > > > > + *	of the PCI bus type) expect the driver-level @freeze() to save the
> > > > > + *	device settings in memory to be used by @restore() during the subsequent
> > > > > + *	resume from hibernation.
> > > > > + *	Subsystem-level @freeze() is executed for all devices after invoking
> > > > > + *	subsystem-level @prepare() for all of them.
> > > > 
> > > > The first three lines you removed contain some important points which I
> > > > think should be retained.
> > > 
> > > Well, not really, because in fact what the callback is supposed to do depends
> > > on the subsystem.  For example, on PCI freeze is not supposed to save the
> > > the device state even and generally those routines don't emit any events.
> > 
> > But you removed the part saying that the freeze callback should quiesce
> > the device but doesn't necessarily have to put the device into a
> > low-power state (in fact, it should avoid changing the power state if
> > possible).  And you removed the explanation that this is needed in
> > order to guarantee a consistent memory image.  These two points are
> > true for all subsystems, including PCI.
> 
> I said "Analogous to @suspend()" instead.  I'm not sure why this is not
> sufficient?

Because @suspend() is very different!  Its description basically says 
to do three things:

	Quiesce the device,

	Put it into a low-power state,

	And enable wakeup events.

@freeze() is supposed to do the first but not the second or third.  
This makes it only 33% similar to @suspend().  :-)

Also, the description of @suspend() says nothing about having a
consistent memory image.


> > "A callback routine must NOT try to unregister the device for which it
> > was called, however it may unregister children of that device (for
> > example, if it detects that a child was hot-unplugged while the system
> > was asleep)."
> 
> That sounds good, thanks!
>  
> > > Do you know any situation in which that matters?
> > 
> > Not offhand, but I'm not familiar with too many subsystems.
> 
> Well, it seems quite extreme to me to be honest. :-)

It would matter for the USB subsystem, except that USB registers and
unregisters all its devices from a freezable kernel thread.  It's not
hard to imagine that other subsystems might want to unregister devices
as soon as they are found to be missing, which means during the
parent's resume routine.

Alan Stern

