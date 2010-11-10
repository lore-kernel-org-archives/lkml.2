Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756231Ab0KJUwX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Nov 2010 15:52:23 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:39143 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753603Ab0KJUwW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Nov 2010 15:52:22 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [linux-pm] [GIT PULL] One more power management fix for 2.6.37
Date: Wed, 10 Nov 2010 21:51:22 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.37-rc1-rjw+; KDE/4.4.4; x86_64; ; )
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Dominik Brodowski <linux@dominikbrodowski.net>,
        "Linux-pm mailing list" <linux-pm@lists.linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>
References: <Pine.LNX.4.44L0.1011092144340.14099-100000@netrider.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.1011092144340.14099-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201011102151.22552.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, November 10, 2010, Alan Stern wrote:
> On Tue, 9 Nov 2010, Linus Torvalds wrote:
> 
> > On Tue, Nov 9, 2010 at 3:39 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> > >
> > > So, what about the patch below?
> 
> The "transition_started" thing is a little odd.  I get the feeling that
> it shouldn't be set back to false during dpm_resume_noirq() at all.  
> Maybe I'm not quite thinking straight just now...

No, I think you're right.  I rethought that particular thing in the meantime
and came to the conclusion that it'd be better to keep it where it was.

> > I think it looks saner, but I also think that it would be saner yet to
> > have a separate list entirely, and *not* do this crazy "move things
> > back and forth between 'dpm_list'" thing.
> > 
> > So I would seriously suggest that the design should aim for each
> > suspend event to move things between two lists, and as devices go
> > through the suspend phases, they'd move to/from lists that also
> > indicate which suspend level they are at.
> > 
> > So why not introduce a new list called "dpm_list_suspended", and in
> > "dpm_suspend_noirq()" you move devices one at a time from the
> > "dpm_list" to the "dmp_list_suspended".
> > 
> > And then in "dpm_resume_noirq()" you move them back.
> > 
> > Wouldn't that be nice?
> > 
> > (Optimally, you'd have separate lists for "active", "suspended", and
> > "irq-suspended")
> > 
> > But regardless, your patch does seem to at least match what we
> > currently do in the regular suspend/resume code (ie the
> > non-irq's-disabled case). So I don't mind it. I just think that it
> > would be cleaner to not take things off one list only to put them back
> > on the same list again.
> > 
> > In particular, _if_ device add events can happen concurrently with
> > this,
> 
> They can.  We explicitly allow new devices to be registered during the 
> final "complete" phase, and we grudgingly allow it even during the 
> "resume" phase, if the parent has already been resumed.
> 
> The "prepare" traversal is ordered in the forward direction so that if
> a child is registered beneath a device during that device's ->prepare
> callback, it will end up in the right place (i.e., after the parent in
> the list).  The "complete" traversal should work out the same way, only
> in reverse.  Which means we should _start_ with everything on the other
> list, and move each device onto the dpm_list just _before_ invoking its
> ->complete callback.
> 
> The way the code is now, it looks like a child registered during the
> parent's callback will end up in the wrong place.
> 
> >  I don't understand how that would maintain the depth-first order
> > of the list. In contrast, if you do it with separate lists, then you
> > know that if a device is on the "suspended" list, then it by
> > definition has to be "after" all devices that are on the non-suspended
> > list, since you cannot have a non-suspended device that depends on a
> > suspended one.
> 
> The situation isn't quite as bad as it seems, if you assume that a 
> child will never be registered at a time when its parent is still 
> suspended.  Right now we warn if such a thing happens but we don't 
> prevent it.
> 
> > So having separate lists with state should also be very sensible from
> > a device topology standpoint - while doing that "list_splice()" back
> > on the same list is _not_ at all obviously correct from a topological
> > standpoint (I'm not sure I'm explaining this well).
> 
> I don't see anything wrong with changing over to multiple list heads.  
> It might even allow us to remove the dev->power.status field.

I guess it would allow us to do that, but that's going to be a major change.

What about applying the patch below now and moving to the multiple list heads
approach in the next cycle?

Rafael

---
From: Rafael J. Wysocki <rjw@sisk.pl>
Subject: PM: Allow devices to be removed during late suspend and early resume

Holding dpm_list_mtx across late suspend and early resume of devices
is problematic for the PCMCIA subsystem and doesn't allow device
objects to be removed by late suspend and early resume driver
callbacks.  This appears to be overly restrictive, as drivers are
generally allowed to remove device objects in other phases of suspend
and resume.  Therefore rework dpm_{suspend|resume}_noirq() so that
they don't have to hold dpm_list_mtx all the time.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 drivers/base/power/main.c |   34 ++++++++++++++++++++++++++++++----
 1 file changed, 30 insertions(+), 4 deletions(-)

Index: linux-2.6/drivers/base/power/main.c
===================================================================
--- linux-2.6.orig/drivers/base/power/main.c
+++ linux-2.6/drivers/base/power/main.c
@@ -475,20 +475,33 @@ End:
  */
 void dpm_resume_noirq(pm_message_t state)
 {
-	struct device *dev;
+	struct list_head list;
 	ktime_t starttime = ktime_get();
 
+	INIT_LIST_HEAD(&list);
 	mutex_lock(&dpm_list_mtx);
 	transition_started = false;
-	list_for_each_entry(dev, &dpm_list, power.entry)
+	while (!list_empty(&dpm_list)) {
+		struct device *dev = to_device(dpm_list.next);
+
+		get_device(dev);
 		if (dev->power.status > DPM_OFF) {
 			int error;
 
 			dev->power.status = DPM_OFF;
+			mutex_unlock(&dpm_list_mtx);
+
 			error = device_resume_noirq(dev, state);
+
+			mutex_lock(&dpm_list_mtx);
 			if (error)
 				pm_dev_err(dev, state, " early", error);
 		}
+		if (!list_empty(&dev->power.entry))
+			list_move_tail(&dev->power.entry, &list);
+		put_device(dev);
+	}
+	list_splice(&list, &dpm_list);
 	mutex_unlock(&dpm_list_mtx);
 	dpm_show_time(starttime, state, "early");
 	resume_device_irqs();
@@ -789,20 +802,33 @@ End:
  */
 int dpm_suspend_noirq(pm_message_t state)
 {
-	struct device *dev;
+	struct list_head list;
 	ktime_t starttime = ktime_get();
 	int error = 0;
 
+	INIT_LIST_HEAD(&list);
 	suspend_device_irqs();
 	mutex_lock(&dpm_list_mtx);
-	list_for_each_entry_reverse(dev, &dpm_list, power.entry) {
+	while (!list_empty(&dpm_list)) {
+		struct device *dev = to_device(dpm_list.prev);
+
+		get_device(dev);
+		mutex_unlock(&dpm_list_mtx);
+
 		error = device_suspend_noirq(dev, state);
+
+		mutex_lock(&dpm_list_mtx);
 		if (error) {
 			pm_dev_err(dev, state, " late", error);
+			put_device(dev);
 			break;
 		}
 		dev->power.status = DPM_OFF_IRQ;
+		if (!list_empty(&dev->power.entry))
+			list_move(&dev->power.entry, &list);
+		put_device(dev);
 	}
+	list_splice_tail(&list, &dpm_list);
 	mutex_unlock(&dpm_list_mtx);
 	if (error)
 		dpm_resume_noirq(resume_event(state));
