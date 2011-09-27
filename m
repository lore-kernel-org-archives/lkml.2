Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752962Ab1I0Ki4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Sep 2011 06:38:56 -0400
Received: from merlin.infradead.org ([205.233.59.134]:34026 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752594Ab1I0Kiy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Sep 2011 06:38:54 -0400
Subject: Re: [PATCH 0/6] [RFC] Proposal for optimistic suspend idea.
From: Peter Zijlstra <peterz@infradead.org>
To: John Stultz <john.stultz@linaro.org>
Cc: lkml <linux-kernel@vger.kernel.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        arve@android.com, markgross@thegnar.org,
        Alan Stern <stern@rowland.harvard.edu>, amit.kucheria@linaro.org,
        farrowg@sg.ibm.com, "Dmitry Fink (Palm GBU)" <Dmitry.Fink@palm.com>,
        linux-pm@lists.linux-foundation.org, khilman@ti.com,
        Magnus Damm <damm@opensource.se>, mjg@redhat.com,
        Thomas Gleixner <tglx@linutronix.de>
Date: Tue, 27 Sep 2011 12:37:50 +0200
In-Reply-To: <1317076065.3112.539.camel@work-vm>
References: <1317064434-1829-1-git-send-email-john.stultz@linaro.org>
	 <1317068164.1763.39.camel@twins> <1317076065.3112.539.camel@work-vm>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.0.3- 
Message-ID: <1317119870.15383.29.camel@twins>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-09-26 at 15:27 -0700, John Stultz wrote:
> On Mon, 2011-09-26 at 22:16 +0200, Peter Zijlstra wrote:
> > On Mon, 2011-09-26 at 12:13 -0700, John Stultz wrote:
> > > 
> > > For now, I'd just be interested in what folks think about the concept with
> > > regards to the wakelock discussions. Where it might not be sufficient? Or
> > > what other disadvantages might it have? Are there any varients to this
> > > idea that would be better? 
> > 
> > I would like to know why people still think wakelocks are remotely sane?
> > 
> > From where I'm sitting they're utter crap.. _WHY_ do you need to suspend
> > anything? What's wrong with regular idle?
> 
> Well. Regular idle still takes up more power with my desktop then I
> could save with suspend.

Blame Intel ;-) Personally I loathe suspend because it kills all my
network links.

> My personal use case: I do nightly backups with rdiff-backup. I'd like
> to schedule those  backup using an alarm-timer, so I could suspend my
> system when I'm not using it. So far, so good, that all works. 
> 
> However, if my system tries to suspend itself after 15 minutes of X
> input idle, and my backup at 2am takes more then 15 minutes, then the
> backup gets interrupted. Because rdiff-backup is more of a transactional
> style backup, it then has to roll back any incomplete changes and try
> again the next night, which will surely take more then 15 minutes, etc.

So your fail is to tie suspend to the input inactivity instead of the
completion of your backup thingy.

> I could try to inhibit suspend by making requests to my desktop
> environment, so the desktop-specific power management daemon won't
> trigger suspend. But given recent behavior, I don't trust that not to
> break when I upgrade my system, or if I get frustrated with one desktop
> environment, that I won't have to use a different api for whatever other
> environment I pick next.

Kick the friggin Desktop folks already for messing up. I mean, because
userspace is incompetent this needs to go in the kernel? Ere long we'll
have a kernel based GUI if we go that route.

> Another use case I've heard about are systems that have firmware updates
> that are remotely triggered. Should the system go into suspend while the
> firmware update is going on, you end up with a brick.

Bricks are good for throwing at those Desktop folks ;-)

> Having to have multiple distro/release specific quirks to get the
> power-management-daemon to inhibit suspend is annoying enough, but then
> you also have to deal with custom changes by administrator, or remote
> power management systems like power nap, which might also echo "mem"
> into /sys/power/state when you're not expecting it. A kernel method to
> really block suspend would be nice. While this doesn't necessarily need
> to be conflated with wakelock style suspend, there is some need to allow
> userland to block suspend at the kernel level, and once you have that, I
> can't imagine folks not trying to stretch that into something like
> wakelocks. So you might as well at least try to design it reasonably
> well to start.

How about you create a daemon tasked with managing /sys/power/state and
change /sys/power/state such that it can be opened only once, then that
daemon can keep the fd open and everything else trying to poke at it
will get a fail.

Then fix up the fallout.

> And again, this doesn't have to be suspend specific. As I mentioned, one
> way of reducing power drain by increasing timer slack, or just not
> scheduling processes for some chunk of time. However, there really isn't
> any good scheduler primitives that allow userspace to communicate when
> that is ok or not. 

I'm probably stupid, but what?! Why would the scheduler want to care
about this nonsense?

What you should do (and what Android should have done) is change the
runtime so you mandate power aware apps, and anything violating the
runtime gets killed.

For Desktop apps this probably involves D-Bus or whatnot, where the
system tells the apps what state it is in. Apps should then respect this
state.

For instance anybody trying to draw to an X surface after they've been
told the screen is off should get kicked. (And before people go whinge
about d-bus having to wake all tasks to get the msgs across, which
wastes power; if you fix the runtime up far enough the attempt of
drawing could return this information.)

I'm not quite sure how timer-slack comes into this, because every app
receiving random wakeups (no matter what slack) after its been told it
should quiesce is a fail, with the exception of the wakeup for telling
it its good to go again (but that comes _after_ the system policy
change, so its fine).

> I personally think there is a growing need for a more power-aware
> scheduling class.  In talking with others, I've said I sometimes think
> of my proposal as a form of "opportunistic scheduling", where the system
> is only going to spend power to allow specific tasks to run. Since those
> important tasks will do things that block for short amounts of time
> (disk io, etc), less-important tasks can opportunistically use the idle
> cycles of the active task. But when the active tasks are finished, we
> stop scheduling anyone else. There are some folks looking at trying to
> use cgroups for this sort of prioritizing, but that has issues with
> priority inversion style issues when sharing resources across cgroups.

That's just insane.. why bother running anything but the 'important'
tasks. Idle is more power aware than running random crap tasks that have
no business running in the first place.

IOW you should stop tasks from being runnable in the first place, once
you're in a situation where you've got random runnable processes you've
failed.

Nothing the scheduler can do about that.

Also, this is a fucked up definition of power-aware scheduling. Normally
power-aware scheduling is about optimizing throughput/watt, and that's a
hard enough problem. No reason to conflate the issue with shitty
userspace that doesn't know what the fuck its doing.

> > So no, you've got a massive major NAK for anything touching the
> > scheduler for this utter braindamage.
> 
> Fair enough, I didn't really expect a warm welcome from you on this. :)
> So I'll take my lumps.
> 
> But while I understand you see this as crap, I'd be interested if you
> think the approach is maybe an improvement or not over prior attempts?

No its still wakelocks, its still trying to force a shitty bunch of
userspace that doesn't know shit into half-way behaving.

And from experience (having an Android phone) it simply doesn't work
worth shit.. there's plenty apps out there that suck battery like
nobodies business, so clearly all the wakelock crap in the world doesn't
help one whit.

So stop fucking about and start fixing the runtime.

> While I'm not picky about the specific API being sched_setscheduler, I
> see a conceptual benefit to this approach, as it provides information to
> the scheduler that would allow the scheduler to make other informed
> decisions.

Where I'm sitting, the moment you need to scheduler to interfere you've
already failed. Tasks that you don't want to run shouldn't be runnable,
full stop.

> Where as other attempts which really didn't involve the scheduler at
> all, and just suspended based only on if there were any active critical
> sections. Causing some to charge that it created a second-scheduler.

That only because they're shit, see above.

> For my proposal, there could also be other cases that might parallel the
> priority inheritance code, where a "important" task A is blocked waiting
> on some resource held by a non-important task B which is blocked on a
> device that is backed by a wakeup source. In that case, you could maybe
> pass the "importance" from task A to task B, then allowing B to be
> deboosted while blocked on the wakeup source, and allow suspend to
> safely occur. Granted, this gets pretty complex, and isn't really
> necessary, but I can imagine interested folks could hole up in academia
> for awhile on similar approaches.
> 
> So with these sorts of parallels, it seems this sort of thing should be
> connected in the scheduler in some way, no?

No, clearly B was runnable to begin with, someone forced its ass to
sleep, they fail. Never allow a task to go into indefinite sleep while
holding a resource.

Same for the kernel, we don't allow a return to userspace with a kernel
lock held, or a call into the freezer while holding a lock. Why would
you want to allow this for userspace.

> And again, I'm not sending these patches to push for inclusion, but only
> just to communicate the idea and to get folks discussing the merits and
> faults of this implementation compared with wakelocks or other
> alternatives they might have. 

I think I've made my position clear.

