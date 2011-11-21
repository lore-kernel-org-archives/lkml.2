Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756854Ab1KUVUb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Nov 2011 16:20:31 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:50192 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752512Ab1KUVUa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Nov 2011 16:20:30 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [PATCH 5] PM: Update comments describing device power management callbacks
Date: Mon, 21 Nov 2011 22:23:15 +0100
User-Agent: KMail/1.13.6 (Linux/3.1.0-rc10+; KDE/4.6.0; x86_64; ; )
Cc: Linux PM list <linux-pm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Randy Dunlap <rdunlap@xenotime.net>
References: <Pine.LNX.4.44L0.1111211552450.1848-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.1111211552450.1848-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201111212223.15878.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, November 21, 2011, Alan Stern wrote:
> On Mon, 21 Nov 2011, Rafael J. Wysocki wrote:
> 
> > > >   * @freeze: Hibernation-specific, executed before creating a hibernation image.
> > > > - *	Quiesce operations so that a consistent image can be created, but do NOT
> > > > - *	otherwise put the device into a low power device state and do NOT emit
> > > > - *	system wakeup events.  Save in main memory the device settings to be
> > > > - *	used by @restore() during the subsequent resume from hibernation or by
> > > > - *	the subsequent @thaw(), if the creation of the image or the restoration
> > > > - *	of main memory contents from it fails.
> > > > + *	Analogous to @suspend(), but it should not enable the device to signal
> > > > + *	wakeup events.  The majority of subsystems (with the notable exception
> > > > + *	of the PCI bus type) expect the driver-level @freeze() to save the
> > > > + *	device settings in memory to be used by @restore() during the subsequent
> > > > + *	resume from hibernation.
> > > > + *	Subsystem-level @freeze() is executed for all devices after invoking
> > > > + *	subsystem-level @prepare() for all of them.
> > > 
> > > The first three lines you removed contain some important points which I
> > > think should be retained.
> > 
> > Well, not really, because in fact what the callback is supposed to do depends
> > on the subsystem.  For example, on PCI freeze is not supposed to save the
> > the device state even and generally those routines don't emit any events.
> 
> But you removed the part saying that the freeze callback should quiesce
> the device but doesn't necessarily have to put the device into a
> low-power state (in fact, it should avoid changing the power state if
> possible).  And you removed the explanation that this is needed in
> order to guarantee a consistent memory image.  These two points are
> true for all subsystems, including PCI.

I said "Analogous to @suspend()" instead.  I'm not sure why this is not
sufficient?

> > > > @@ -174,29 +198,32 @@ typedef struct pm_message {
> > > >   * their children.
> > > >   *
> > > >   * It is allowed to unregister devices while the above callbacks are being
> > > > - * executed.  However, it is not allowed to unregister a device from within any
> > > > - * of its own callbacks.
> > > > + * executed.  However, it is NOT allowed to unregister a device from within any
> > > > + * of its driver's callbacks.
> > > 
> > > Please be a little more precise here.  If driver D manages two devices,
> > > A and B, then D _is_ allowed to unregister A from within a callback for
> > > B (except if A is an ancestor of B or something like that).  It's just
> > > not allowed to unregister B from within a callback for B.
> > 
> > I can leave that as is, but devices (or device objects to be precise) don't
> > have any callbacks.  Their drivers do.
> > 
> > I can add "(unless they are being executed for a different device)" or
> > something like this, but I'm not sure if that makes things any clearer.
> 
> "A callback routine must NOT try to unregister the device for which it
> was called, however it may unregister children of that device (for
> example, if it detects that a child was hot-unplugged while the system
> was asleep)."

That sounds good, thanks!
 
> > Do you know any situation in which that matters?
> 
> Not offhand, but I'm not familiar with too many subsystems.

Well, it seems quite extreme to me to be honest. :-)

Thanks,
Rafael
