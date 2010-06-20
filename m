Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754901Ab0FTVwR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jun 2010 17:52:17 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:58448 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753681Ab0FTVwO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jun 2010 17:52:14 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [RFC][PATCH] PM: Avoid losing wakeup events during suspend
Date: Sun, 20 Jun 2010 23:50:26 +0200
User-Agent: KMail/1.13.3 (Linux/2.6.35-rc3-rjw+; KDE/4.4.3; x86_64; ; )
Cc: linux-pm@lists.linux-foundation.org, Matthew Garrett <mjg59@srcf.ucam.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Arve =?iso-8859-1?q?Hj=F8nnev=E5g?= <arve@android.com>,
       Neil Brown <neilb@suse.de>, mark gross <640e9920@gmail.com>
References: <Pine.LNX.4.44L0.1006201153420.22272-100000@netrider.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.1006201153420.22272-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201006202350.27143.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, June 20, 2010, Alan Stern wrote:
> On Sun, 20 Jun 2010, Rafael J. Wysocki wrote:
> 
> > Hi,
> > 
> > One of the arguments during the suspend blockers discussion was that the
> > mainline kernel didn't contain any mechanisms allowing it to avoid losing
> > wakeup events during system suspend.
> > 
> > Generally, there are two problems in that area.  First, if a wakeup event
> > occurs exactly at the same time when /sys/power/state is being written to,
> > the even may be delivered to user space right before the freezing of it,
> > in which case the user space consumer of the event may not be able to process
> > it before the system is suspended.
> 
> Indeed, the same problem arises if the event isn't delivered to
> userspace until after userspace is frozen.

In that case the kernel should abort the suspend so that the event can be
delivered to the user space.

> Of course, the underlying issue here is that the kernel has no direct way
> to know when userspace has finished processing an event.  Userspace would
> have to tell it, which generally would mean rewriting some large number of user
> programs.

I'm not sure of that.  If the kernel doesn't initiate suspend, it doesn't
really need to know whether or not user space has already consumed the event.

> >  Second, if a wakeup event occurs after user
> > space has been frozen and that event is not a wakeup interrupt, the kernel will
> > not react to it and the system will be suspended.
> 
> I don't quite understand what you mean here.  "Reacting" to an event
> involves more than one action.  The kernel has to tell the hardware to
> stop generating the wakeup signal, and it has to handle the event
> somehow.

Yes.  I meant that the event wouldn't cause the suspend to be aborted.

> If the kernel doesn't tell the hardware to stop generating the wakeup 
> signal, the signal will continue to be active until the system goes to 
> sleep.  At that point it will cause the system to wake up immediately,
> so there won't be any problem.
>
> The real problem arises when the hardware stops generating the wakeup
> signal but the kernel suspends before it finishes handling the event.  
> For example, an interrupt handler might receive the event and start
> processing it by calling pm_request_resume() -- but if the pm workqueue
> thread is already frozen then the processing won't finish until
> something else wakes the system up.  (IMO this is a potential bug which
> could be fixed without too much effort.)

That's why I put pm_wakeup_event() into the PCI runtime wakeup code, which
doesn't run from the PM workqueue.
 
> > The following patch illustrates my idea of how these two problems may be
> > addressed.  It introduces a new global sysfs attribute,
> > /sys/power/wakeup_count, associated with a running counter of wakeup events
> > and a helper function, pm_wakeup_event(), that may be used by kernel subsystems
> > to increment the wakeup events counter.
> 
> In what way is this better than suspend blockers?

It doesn't add any new framework and it doesn't require the users of
pm_wakeup_event() to "unblock" suspend, so it is simpler.  It also doesn't add
the user space interface that caused so much opposition to appear.

> > /sys/power/wakeup_count may be read from or written to by user space.  Reads
> > will always succeed and return the current value of the wakeup events counter.
> > Writes, however, will only succeed if the written number is equal to the
> > current value of the wakeup events counter.  If a write is successful, it will
> > cause the kernel to save the current value of the wakeup events counter and
> > to compare the saved number with the current value of the counter at certain
> > points of the subsequent suspend (or hibernate) sequence.  If the two values
> > don't match, the suspend will be aborted just as though a wakeup interrupt
> > happened.  Reading from /sys/power/wakeup_count again will turn that mechanism
> > off.
> > 
> > The assumption is that there's a user space power manager that will first
> > read from /sys/power/wakeup_count.  Then it will check all user space consumers
> > of wakeup events known to it for unprocessed events.
> 
> What happens if an event arrives just before you read
> /sys/power/wakeup_count, but the userspace consumer doesn't realize
> there is a new unprocessed event until after the power manager checks
> it?  Your plan is missing a critical step: the "handoff" whereby 
> responsibility for handling an event passes from the kernel to 
> userspace.

I think this is not the kernel's problem.  In this approach the kernel makes it
possible for the user space to avoid the race.  Whether or not the user space
will use this opportunity is a different matter.

> With suspend blockers, this handoff occurs when an event queue is 
> emptied and its associate suspend blocker is deactivated.  Or with some 
> kinds of events for which the Android people have not written an 
> explicit handoff, it occurs when a timer expires (timed suspend 
> blockers).

Well, quite frankly, I don't see any difference here.  In either case there is
a possibility for user space to mess up things and the kernel can't really help
that.

> >  If there are any, it will
> > wait for them to be processed and repeat.  In turn, if there are not any,
> > it will try to write to /sys/power/wakeup_count and if the write is successful,
> > it will write to /sys/power/state to start suspend, so if any wakeup events
> > accur past that point, they will be noticed by the kernel and will eventually
> > cause the suspend to be aborted.
> 
> This shares with the other alternatives posted recently the need for a
> central power-manager process.  And like in-kernel suspend blockers, it
> requires changes to wakeup-capable drivers (the wakeup-events counter
> has to be incremented).

It doesn't really require changes to drivers, but to code that knows of wakeup
events, like the PCI runtime wakeup code.  Moreover, it doesn't require kernel
subsystems to know or even care when it is reasonable to allow suspend to
happen.  The only thing they need to do is to call pm_wakeup_event() whenever
they see a wakeup event.  I don't really think it is too much of a requirement
(and quite frnakly I can't imagine anything simpler than that).

> One advantage of the suspend-blocker approach is that it essentially
> uses a single tool to handle both kinds of races (event not fully
> handled by the kernel, or event not fully handled by userspace).  
> Things aren't quite this simple, because of the need for a special API
> to implement userspace suspend blockers, but this does avoid the need
> for a power-manager process.

Yes, it does, but I have an idea about how to implement such a power manager
and I'm going to actually try it.

> > In addition to the above, the patch adds a wakeup events counter to the
> > power member of struct device and makes these per-device wakeup event counters
> > available via sysfs, so that it's possible to check the activity of various
> > wakeup event sources within the kernel.
> > 
> > To illustrate how subsystems can use pm_wakeup_event(), I added it to the
> > PCI runtime PM wakeup-handling code.
> > 
> > At the moment the patch only contains code changes (ie. no documentation),
> > but I'm going to add comments etc. if people like the idea.
> > 
> > Please tell me what you think.
> 
> While this isn't a bad idea, I don't see how it is superior to the 
> other alternatives that have been proposed.

I don't think any of the approaches that don't use suspend blockers allows
one to avoid the race between the process that writes to /sys/power/state
and a wakeup event happening at the same time.  They attempt to address another
issue, which is how to prevent untrusted user space processes from keeping the
system out of idle, but that is a different story.

My patch is all about the (system-wide) suspend mechanism, regardless of
whether or not it is used for opportunistic suspending.

Rafael
