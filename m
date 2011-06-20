Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755573Ab1FTVAG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jun 2011 17:00:06 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:40893 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755307Ab1FTVAD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jun 2011 17:00:03 -0400
Date: Mon, 20 Jun 2011 17:00:03 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: Linux PM mailing list <linux-pm@lists.linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>
Subject: Re: [PATCH] PCI / PM: Block races between runtime PM and system
 sleep
In-Reply-To: <201106202142.45802.rjw@sisk.pl>
Message-ID: <Pine.LNX.4.44L0.1106201651270.2113-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 20 Jun 2011, Rafael J. Wysocki wrote:

> > Furthermore, since we're going to disable runtime PM as soon as the
> > suspend callback returns anyway, why not increment usage_count before
> > invoking the callback?  This will prevent runtime suspends from 
> > occurring while the callback runs, so no changes will be needed in the 
> > PCI or USB subsystems.
> 
> The PCI case is different from the USB one.  PCI needs to resume devices
> before calling their drivers' .suspend() callbacks, so it does that in
> .prepare().  If the core acquired a reference to every device  before executing
> the subsystem .suspend(), then pm_runtime_resume() could be moved from
> pci_pm_prepare() to pci_prepare_suspend(), but then additionally it would
> have to be called from pci_pm_freeze() and pci_pm_poweroff().  It simply is
> more efficient to call it once from pci_pm_prepare(), but then PCI needs to
> take the reference by itself.

Ah, okay.  The PCI part makes sense then.

> > It also will prevent Kevin from calling pm_runtime_suspend from within
> > his suspend callbacks, but you have already determined that subsystems
> > and drivers should never do that in any case.
> 
> Then reverting commit e8665002477f0278f84f898145b1f141ba26ee26 would be
> even better. :-)

See below.


> > As I see it, we never want a suspend or suspend_noirq callback to call 
> > pm_runtime_suspend().  However it's okay for the suspend callback to 
> > invoke pm_runtime_resume(), as long as this is all done in subsystem 
> > code.
> 
> First off, I don't really see a reason for a subsystem to call
> pm_runtime_resume() from its .suspend_noirq() callback.

I was referring to .suspend(), not .suspend_noirq().

>  Now, if
> pm_runtime_resume() is to be called concurrently with the subsystem's
> .suspend_noirq() callback, I'd rather won't let that happen. :-)

Me too.  But I see no reason to prevent pm_runtime_resume() from being 
called by .suspend().

> > And in between the prepare and suspend callbacks, runtime PM should be
> > more or less fully functional, right?  For most devices it will never
> > be triggered, because it has to run in process context and both
> > userspace and pm_wq are frozen.  It may trigger for devices marked as
> > IRQ-safe, though.
> 
> It also may trigger for drivers using non-freezable workqueues and calling
> runtime PM synchronously from there.

Right.  So we shouldn't ignore this window.

> > Maybe the barrier should be moved into __device_suspend().
> 
> I _really_ think that the initial approach, i.e. before commit
> e8665002477f0278f84f898145b1f141ba26ee26, made the most sense.  It didn't
> cover the "pm_runtime_resume() called during system suspend" case, but
> it did cover everything else.

But it prevented runtime PM from working during the window between 
.prepare() and .suspend(), and also between .resume() and .complete().
If a subsystem like PCI wants to rule out runtime PM during those 
windows, then fine -- it can do whatever it wants.  But the PM core 
shouldn't do this.

> So, I think there are serious technical arguments for reverting that commit.
> 
> I think we went really far trying to avoid that, but I'm not sure I want to go
> any further.

What I'm suggesting is to revert the commit but at the same time,
move the get_noresume() into __device_suspend() and the put_sync() into 
device_resume().

Alan Stern

