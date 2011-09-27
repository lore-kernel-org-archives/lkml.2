Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753111Ab1I0W5I (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Sep 2011 18:57:08 -0400
Received: from e34.co.us.ibm.com ([32.97.110.152]:54455 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752039Ab1I0W5F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Sep 2011 18:57:05 -0400
Subject: Re: [PATCH 0/6] [RFC] Proposal for optimistic suspend idea.
From: John Stultz <john.stultz@linaro.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: lkml <linux-kernel@vger.kernel.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        arve@android.com, markgross@thegnar.org,
        Alan Stern <stern@rowland.harvard.edu>, amit.kucheria@linaro.org,
        farrowg@sg.ibm.com, "Dmitry Fink (Palm GBU)" <Dmitry.Fink@palm.com>,
        linux-pm@lists.linux-foundation.org, khilman@ti.com,
        Magnus Damm <damm@opensource.se>, mjg@redhat.com,
        Thomas Gleixner <tglx@linutronix.de>
In-Reply-To: <1317119870.15383.29.camel@twins>
References: <1317064434-1829-1-git-send-email-john.stultz@linaro.org>
	 <1317068164.1763.39.camel@twins> <1317076065.3112.539.camel@work-vm>
	 <1317119870.15383.29.camel@twins>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 27 Sep 2011 15:56:55 -0700
Message-ID: <1317164216.3112.711.camel@work-vm>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-09-27 at 12:37 +0200, Peter Zijlstra wrote:
> On Mon, 2011-09-26 at 15:27 -0700, John Stultz wrote:
> > On Mon, 2011-09-26 at 22:16 +0200, Peter Zijlstra wrote:
> > > On Mon, 2011-09-26 at 12:13 -0700, John Stultz wrote:
> > > > 
> > > > For now, I'd just be interested in what folks think about the concept with
> > > > regards to the wakelock discussions. Where it might not be sufficient? Or
> > > > what other disadvantages might it have? Are there any varients to this
> > > > idea that would be better? 
> > > 
> > > I would like to know why people still think wakelocks are remotely sane?
> > > 
> > > From where I'm sitting they're utter crap.. _WHY_ do you need to suspend
> > > anything? What's wrong with regular idle?
> > 
> > Well. Regular idle still takes up more power with my desktop then I
> > could save with suspend.
> 
> Blame Intel ;-) Personally I loathe suspend because it kills all my
> network links.
> 
> > My personal use case: I do nightly backups with rdiff-backup. I'd like
> > to schedule those  backup using an alarm-timer, so I could suspend my
> > system when I'm not using it. So far, so good, that all works. 
> > 
> > However, if my system tries to suspend itself after 15 minutes of X
> > input idle, and my backup at 2am takes more then 15 minutes, then the
> > backup gets interrupted. Because rdiff-backup is more of a transactional
> > style backup, it then has to roll back any incomplete changes and try
> > again the next night, which will surely take more then 15 minutes, etc.
> 
> So your fail is to tie suspend to the input inactivity instead of the
> completion of your backup thingy.

Well, its both. If the backup runs very long, and I'm using the machine
in the morning, I don't want the end of my backup to suspend the system.


> > I could try to inhibit suspend by making requests to my desktop
> > environment, so the desktop-specific power management daemon won't
> > trigger suspend. But given recent behavior, I don't trust that not to
> > break when I upgrade my system, or if I get frustrated with one desktop
> > environment, that I won't have to use a different api for whatever other
> > environment I pick next.
> 
> Kick the friggin Desktop folks already for messing up. I mean, because
> userspace is incompetent this needs to go in the kernel? Ere long we'll
> have a kernel based GUI if we go that route.

Well, to be fair to the desktop guys, they have been working to try to
provide a DBUS api to handle this.

But even with a proper DBUS api, there's still the race when I walk away
from my computer 15 minutes before the backup starts. 

In that case, my backup application's alarm timer fires and schedules
the backup, but then before the backup application runs and sends its
DBUS message to block suspend, the suspend occurs. And yea, that's
probably not a problem for my use, but it limits any similar power
savings from an environment where reliability might actually matter. 

Read that last bit again, as it has seemingly been missed over and over
in these discussions. This ability to make sure wake up events are
consumed by userland before suspending again is key.


> > Another use case I've heard about are systems that have firmware updates
> > that are remotely triggered. Should the system go into suspend while the
> > firmware update is going on, you end up with a brick.
[snip]
> > Having to have multiple distro/release specific quirks to get the
> > power-management-daemon to inhibit suspend is annoying enough, but then
> > you also have to deal with custom changes by administrator, or remote
> > power management systems like power nap, which might also echo "mem"
> > into /sys/power/state when you're not expecting it. A kernel method to
> > really block suspend would be nice. While this doesn't necessarily need
> > to be conflated with wakelock style suspend, there is some need to allow
> > userland to block suspend at the kernel level, and once you have that, I
> > can't imagine folks not trying to stretch that into something like
> > wakelocks. So you might as well at least try to design it reasonably
> > well to start.
> 
> How about you create a daemon tasked with managing /sys/power/state and
> change /sys/power/state such that it can be opened only once, then that
> daemon can keep the fd open and everything else trying to poke at it
> will get a fail.

That's actually pretty interesting. It doesn't handle the race issues
between wakeup event and event consumption by userland, but not a bad
tool to have in the toolbox as we look at other approaches.


> > And again, this doesn't have to be suspend specific. As I mentioned, one
> > way of reducing power drain by increasing timer slack, or just not
> > scheduling processes for some chunk of time. However, there really isn't
> > any good scheduler primitives that allow userspace to communicate when
> > that is ok or not. 
> 
> I'm probably stupid, but what?! Why would the scheduler want to care
> about this nonsense?

For the same reason it cares about SCHED_FIFO.

> What you should do (and what Android should have done) is change the
> runtime so you mandate power aware apps, and anything violating the
> runtime gets killed.
> 
> For Desktop apps this probably involves D-Bus or whatnot, where the
> system tells the apps what state it is in. Apps should then respect this
> state.

Sure, and real-time tasks should coordinate with all of userland to just
make sure no one gets in the way! And those applications should respect
that! Why is all that *useless* code in the kernel!? :)

> For instance anybody trying to draw to an X surface after they've been
> told the screen is off should get kicked. (And before people go whinge
> about d-bus having to wake all tasks to get the msgs across, which
> wastes power; if you fix the runtime up far enough the attempt of
> drawing could return this information.)
> 
> I'm not quite sure how timer-slack comes into this, because every app
> receiving random wakeups (no matter what slack) after its been told it
> should quiesce is a fail, with the exception of the wakeup for telling
> it its good to go again (but that comes _after_ the system policy
> change, so its fine).

So you're suggesting we rewrite everything in the debian package
archives to use DBUS and abide by some sort of userland power policy?

I'll admit its a terrible straw-man, but this starts to sound like: "We
don't need protected memory! Just rewrite all the apps so they don't
accidentally overwrite kernel structures!"

Don't get me wrong, I do think that there are power-optimizations to be
had using more "runtime" regulated behavior. You're right, when the
screen is powered off, the clock applet shouldn't be trying to make X
calls to update itself every minute.

But I think once you get away from some theoretical system, containing
only properly behaving apps, having some tools in the kernel to enforce
a certain type of behavior (and having the kernel's ability to handle
more complex cases like importance inheritance) might be helpful.

> > I personally think there is a growing need for a more power-aware
> > scheduling class.  In talking with others, I've said I sometimes think
> > of my proposal as a form of "opportunistic scheduling", where the system
> > is only going to spend power to allow specific tasks to run. Since those
> > important tasks will do things that block for short amounts of time
> > (disk io, etc), less-important tasks can opportunistically use the idle
> > cycles of the active task. But when the active tasks are finished, we
> > stop scheduling anyone else. There are some folks looking at trying to
> > use cgroups for this sort of prioritizing, but that has issues with
> > priority inversion style issues when sharing resources across cgroups.
> 
> That's just insane.. why bother running anything but the 'important'
> tasks. Idle is more power aware than running random crap tasks that have
> no business running in the first place.

Its really not that different conceptually from aligning timers. Making
sure that when we fire, we expire as many timers as we can in one go,
and run all the tasks that need to run, so we can go back to idle for as
long as possible.

But instead of idling "until the next timer group", we split stuff we
don't care that much about (but needs to be there), and stuff we do care
about, and only schedule the hardware to fire for the events we do care
about.

> IOW you should stop tasks from being runnable in the first place, once
> you're in a situation where you've got random runnable processes you've
> failed.

Consider your desktop. Consider servers. Are really ontop of every task
and are sure its not inefficient, or doesn't have some edge case bug
where it just flips out and chews cpu (I'm looking at you flashplayer!).
The real world is filled with crap.


> Nothing the scheduler can do about that.

I disagree. Why are the inmates running the asylum? The scheduler
decides what runs when and where. We're not at the mercy of bad
applications, they're at the mercy of the scheduler.


> Also, this is a fucked up definition of power-aware scheduling. Normally
> power-aware scheduling is about optimizing throughput/watt, and that's a
> hard enough problem. No reason to conflate the issue with shitty
> userspace that doesn't know what the fuck its doing.

And I do get that its a hard enough problem, and have nothing but
respect for your work there. But I suspect its likely to get harder as
it gets more important. Once the throughput side is maxed out, being
able to further reduce the watt side of the equation is going to have
value. And being able to do that without rewriting all of userland is
compelling to folks. That is why suspend is being exploited in a number
of these cases (in more or less hackish ways, depending).

Its like using sleeping spinlocks instead of having to rewrite every
driver so that they didn't have any long held critical sections. One
works in practice and the other is better in theory.


> > But while I understand you see this as crap, I'd be interested if you
> > think the approach is maybe an improvement or not over prior attempts?
> 
> No its still wakelocks, its still trying to force a shitty bunch of
> userspace that doesn't know shit into half-way behaving.
> 
> And from experience (having an Android phone) it simply doesn't work
> worth shit.. there's plenty apps out there that suck battery like
> nobodies business, so clearly all the wakelock crap in the world doesn't
> help one whit.

One can configure a Linux system to run like crap, therefore everyone's
focus on performance didn't help one whit?   Come on, nothing is a
cure-all. But that's not really an argument against improving something
or providing necessary tools to allow for certain types of
optimizations.

And don't take me for an Android apologist. I think the poor battery
anecdotes that pervade are a big problem.  One issue I suspect with
Android's wakelocks is that many are timeout based, which keeps things
active for longer then necessary. Additionally, since all wakelock-izing
of drivers happens out of the tree, there's no sanity reviewing, so
extending those timeouts to avoid issues are quick fixes that get phones
out the door, but at the price of battery life.

I believe that one of the benefits of my proposal is that it avoids the
need for such timeouts.  But I realize at this point in the conversation
comparing apples vs oranges probably isn't productive if you're argument
is "round things suck". :)


> So stop fucking about and start fixing the runtime.
> 
> > While I'm not picky about the specific API being sched_setscheduler, I
> > see a conceptual benefit to this approach, as it provides information to
> > the scheduler that would allow the scheduler to make other informed
> > decisions.
> 
> Where I'm sitting, the moment you need to scheduler to interfere you've
> already failed. Tasks that you don't want to run shouldn't be runnable,
> full stop.


SIGSTOP the world? (and melt^H^H^H^Hfreeze with you!)

You want them to run, its just a matter of when. 


> > Where as other attempts which really didn't involve the scheduler at
> > all, and just suspended based only on if there were any active critical
> > sections. Causing some to charge that it created a second-scheduler.
> 
> That only because they're shit, see above.
> 
> > For my proposal, there could also be other cases that might parallel the
> > priority inheritance code, where a "important" task A is blocked waiting
> > on some resource held by a non-important task B which is blocked on a
> > device that is backed by a wakeup source. In that case, you could maybe
> > pass the "importance" from task A to task B, then allowing B to be
> > deboosted while blocked on the wakeup source, and allow suspend to
> > safely occur. Granted, this gets pretty complex, and isn't really
> > necessary, but I can imagine interested folks could hole up in academia
> > for awhile on similar approaches.
> > 
> > So with these sorts of parallels, it seems this sort of thing should be
> > connected in the scheduler in some way, no?
> 
> No, clearly B was runnable to begin with, someone forced its ass to
> sleep, they fail. Never allow a task to go into indefinite sleep while
> holding a resource.
>
> Same for the kernel, we don't allow a return to userspace with a kernel
> lock held, or a call into the freezer while holding a lock. Why would
> you want to allow this for userspace.

Maybe the word "resource" was too general. Consider circular buffer
semaphores used to sync producer/consumer with my earlier example above.
Tasks waiting on tasks waiting on input are not an uncommon pattern. 

Thanks again for the feedback and critique. I recognize you are very
passionate in your distaste for wakelocks and similar ideas, and I don't
mean to wind you up too much arguing with you. 

I'll happily admit that my proposal and the vision I see of how the
scheduler could function here may have real issues and might add
unnecessary complexity. 

But I also want to separate my specific solution from the problem at
large. I do think that there are issues that my proposal and wakelocks
address that the hand-wavy "just do it in userspace" rebuttals don't
deal with (again specifically: wakeup event consumption in userland
before the next suspend).

I do think my idea is neat, so we can spend/burn time debating it, but
if you have viable suggestions (and honestly, I think rewriting all of
userland isn't viable) on solving the larger problem, I'm all ears.

thanks again!
-john


