Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755432Ab1FTV2Q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jun 2011 17:28:16 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:43224 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751352Ab1FTV2N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jun 2011 17:28:13 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [PATCH] PCI / PM: Block races between runtime PM and system sleep
Date: Mon, 20 Jun 2011 23:28:53 +0200
User-Agent: KMail/1.13.6 (Linux/3.0.0-rc3+; KDE/4.6.0; x86_64; ; )
Cc: Linux PM mailing list <linux-pm@lists.linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>
References: <Pine.LNX.4.44L0.1106201651270.2113-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.1106201651270.2113-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201106202328.54100.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, June 20, 2011, Alan Stern wrote:
> On Mon, 20 Jun 2011, Rafael J. Wysocki wrote:
> 
> > > Furthermore, since we're going to disable runtime PM as soon as the
> > > suspend callback returns anyway, why not increment usage_count before
> > > invoking the callback?  This will prevent runtime suspends from 
> > > occurring while the callback runs, so no changes will be needed in the 
> > > PCI or USB subsystems.
> > 
> > The PCI case is different from the USB one.  PCI needs to resume devices
> > before calling their drivers' .suspend() callbacks, so it does that in
> > .prepare().  If the core acquired a reference to every device  before executing
> > the subsystem .suspend(), then pm_runtime_resume() could be moved from
> > pci_pm_prepare() to pci_prepare_suspend(), but then additionally it would
> > have to be called from pci_pm_freeze() and pci_pm_poweroff().  It simply is
> > more efficient to call it once from pci_pm_prepare(), but then PCI needs to
> > take the reference by itself.
> 
> Ah, okay.  The PCI part makes sense then.

OK, so the appended patch is a modification of the $subject one using
pm_runtime_put_sync() instead of pm_runtime_put_noidle().

> > > It also will prevent Kevin from calling pm_runtime_suspend from within
> > > his suspend callbacks, but you have already determined that subsystems
> > > and drivers should never do that in any case.
> > 
> > Then reverting commit e8665002477f0278f84f898145b1f141ba26ee26 would be
> > even better. :-)
> 
> See below.
> 
> 
> > > As I see it, we never want a suspend or suspend_noirq callback to call 
> > > pm_runtime_suspend().  However it's okay for the suspend callback to 
> > > invoke pm_runtime_resume(), as long as this is all done in subsystem 
> > > code.
> > 
> > First off, I don't really see a reason for a subsystem to call
> > pm_runtime_resume() from its .suspend_noirq() callback.
> 
> I was referring to .suspend(), not .suspend_noirq().
> 
> >  Now, if
> > pm_runtime_resume() is to be called concurrently with the subsystem's
> > .suspend_noirq() callback, I'd rather won't let that happen. :-)
> 
> Me too.  But I see no reason to prevent pm_runtime_resume() from being 
> called by .suspend().

Hmm.

> > > And in between the prepare and suspend callbacks, runtime PM should be
> > > more or less fully functional, right?  For most devices it will never
> > > be triggered, because it has to run in process context and both
> > > userspace and pm_wq are frozen.  It may trigger for devices marked as
> > > IRQ-safe, though.
> > 
> > It also may trigger for drivers using non-freezable workqueues and calling
> > runtime PM synchronously from there.
> 
> Right.  So we shouldn't ignore this window.

So, your point is that while .suspend() or .resume() are running, the
synchronization between runtime PM and system suspend/resume should be the
subsystem's problem, right?

> > > Maybe the barrier should be moved into __device_suspend().
> > 
> > I _really_ think that the initial approach, i.e. before commit
> > e8665002477f0278f84f898145b1f141ba26ee26, made the most sense.  It didn't
> > cover the "pm_runtime_resume() called during system suspend" case, but
> > it did cover everything else.
> 
> But it prevented runtime PM from working during the window between 
> .prepare() and .suspend(), and also between .resume() and .complete().
> If a subsystem like PCI wants to rule out runtime PM during those 
> windows, then fine -- it can do whatever it wants.  But the PM core 
> shouldn't do this.

I actually see a reason for doing this.  Namely, I don't really think
driver writers should be bothered with preventing races between different
PM callbacks from happening.  Runtime PM takes care of that at run time,
the design of the system suspend/resume code ensures that the callbacks
for the same device are executed sequentially, but if we allow runtime PM
callbacks to be executed in parallel with system suspend/resume callbacks,
someone has to prevent those callbacks from racing with each other.

Now, if you agree that that shouldn't be a driver's task, then it has to
be the subsystem's one and I'm not sure what a subsystem can do other than
disabling runtime PM or at least taking a reference on every device before
calling device drivers' .suspend() callbacks.

Please note, I think that .prepare() and .complete() are somewhat special,
so perhaps we should allow those to race with runtime PM callbacks, but IMO
allowing .suspend() and .resume() to race with .runtime_suspend() and
.runtime_resume() is not a good idea.

> > So, I think there are serious technical arguments for reverting that commit.
> > 
> > I think we went really far trying to avoid that, but I'm not sure I want to go
> > any further.
> 
> What I'm suggesting is to revert the commit but at the same time,
> move the get_noresume() into __device_suspend() and the put_sync() into 
> device_resume().

What about doing pm_runtime_get_noresume() and the pm_runtime_barrier()
in dpm_prepare(), but _after_ calling device_prepare() and doing
pm_runtime_put_noidle() in dpm_complete() _before_ calling .complete()
from the subsystem (a _put_sync() at this point will likely invoke
.runtime_idle() from the subsystem before executing .complete(), which may
not be desirable)?

Rafael

---
From: Rafael J. Wysocki <rjw@sisk.pl>
Subject: PCI / PM: Block races between runtime PM and system sleep

After commit e8665002477f0278f84f898145b1f141ba26ee26
(PM: Allow pm_runtime_suspend() to succeed during system suspend) it
is possible that a device resumed by the pm_runtime_resume(dev) in
pci_pm_prepare() will be suspended immediately from a work item,
timer function or otherwise, defeating the very purpose of calling
pm_runtime_resume(dev) from there.  To prevent that from happening
it is necessary to increment the runtime PM usage counter of the
device by replacing pm_runtime_resume() with pm_runtime_get_sync().
Moreover, the incremented runtime PM usage counter has to be
decremented by the corresponding pci_pm_complete(), via
pm_runtime_put_sync().

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
Cc: stable@kernel.org
---
 drivers/pci/pci-driver.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

Index: linux-2.6/drivers/pci/pci-driver.c
===================================================================
--- linux-2.6.orig/drivers/pci/pci-driver.c
+++ linux-2.6/drivers/pci/pci-driver.c
@@ -624,7 +624,7 @@ static int pci_pm_prepare(struct device
 	 * system from the sleep state, we'll have to prevent it from signaling
 	 * wake-up.
 	 */
-	pm_runtime_resume(dev);
+	pm_runtime_get_sync(dev);
 
 	if (drv && drv->pm && drv->pm->prepare)
 		error = drv->pm->prepare(dev);
@@ -638,6 +638,8 @@ static void pci_pm_complete(struct devic
 
 	if (drv && drv->pm && drv->pm->complete)
 		drv->pm->complete(dev);
+
+	pm_runtime_put_sync(dev);
 }
 
 #else /* !CONFIG_PM_SLEEP */
