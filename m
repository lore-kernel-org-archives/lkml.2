Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752370Ab1IZW17 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Sep 2011 18:27:59 -0400
Received: from e6.ny.us.ibm.com ([32.97.182.146]:48635 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751528Ab1IZW16 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Sep 2011 18:27:58 -0400
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
In-Reply-To: <1317068164.1763.39.camel@twins>
References: <1317064434-1829-1-git-send-email-john.stultz@linaro.org>
	 <1317068164.1763.39.camel@twins>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 26 Sep 2011 15:27:45 -0700
Message-ID: <1317076065.3112.539.camel@work-vm>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-09-26 at 22:16 +0200, Peter Zijlstra wrote:
> On Mon, 2011-09-26 at 12:13 -0700, John Stultz wrote:
> > 
> > For now, I'd just be interested in what folks think about the concept with
> > regards to the wakelock discussions. Where it might not be sufficient? Or
> > what other disadvantages might it have? Are there any varients to this
> > idea that would be better? 
> 
> I would like to know why people still think wakelocks are remotely sane?
> 
> From where I'm sitting they're utter crap.. _WHY_ do you need to suspend
> anything? What's wrong with regular idle?

Well. Regular idle still takes up more power with my desktop then I
could save with suspend.

My personal use case: I do nightly backups with rdiff-backup. I'd like
to schedule those  backup using an alarm-timer, so I could suspend my
system when I'm not using it. So far, so good, that all works. 

However, if my system tries to suspend itself after 15 minutes of X
input idle, and my backup at 2am takes more then 15 minutes, then the
backup gets interrupted. Because rdiff-backup is more of a transactional
style backup, it then has to roll back any incomplete changes and try
again the next night, which will surely take more then 15 minutes, etc.

I could try to inhibit suspend by making requests to my desktop
environment, so the desktop-specific power management daemon won't
trigger suspend. But given recent behavior, I don't trust that not to
break when I upgrade my system, or if I get frustrated with one desktop
environment, that I won't have to use a different api for whatever other
environment I pick next.

Another use case I've heard about are systems that have firmware updates
that are remotely triggered. Should the system go into suspend while the
firmware update is going on, you end up with a brick.

Having to have multiple distro/release specific quirks to get the
power-management-daemon to inhibit suspend is annoying enough, but then
you also have to deal with custom changes by administrator, or remote
power management systems like power nap, which might also echo "mem"
into /sys/power/state when you're not expecting it. A kernel method to
really block suspend would be nice. While this doesn't necessarily need
to be conflated with wakelock style suspend, there is some need to allow
userland to block suspend at the kernel level, and once you have that, I
can't imagine folks not trying to stretch that into something like
wakelocks. So you might as well at least try to design it reasonably
well to start.

And again, this doesn't have to be suspend specific. As I mentioned, one
way of reducing power drain by increasing timer slack, or just not
scheduling processes for some chunk of time. However, there really isn't
any good scheduler primitives that allow userspace to communicate when
that is ok or not. 

I personally think there is a growing need for a more power-aware
scheduling class.  In talking with others, I've said I sometimes think
of my proposal as a form of "opportunistic scheduling", where the system
is only going to spend power to allow specific tasks to run. Since those
important tasks will do things that block for short amounts of time
(disk io, etc), less-important tasks can opportunistically use the idle
cycles of the active task. But when the active tasks are finished, we
stop scheduling anyone else. There are some folks looking at trying to
use cgroups for this sort of prioritizing, but that has issues with
priority inversion style issues when sharing resources across cgroups.

> So no, you've got a massive major NAK for anything touching the
> scheduler for this utter braindamage.

Fair enough, I didn't really expect a warm welcome from you on this. :)
So I'll take my lumps.

But while I understand you see this as crap, I'd be interested if you
think the approach is maybe an improvement or not over prior attempts?
While I'm not picky about the specific API being sched_setscheduler, I
see a conceptual benefit to this approach, as it provides information to
the scheduler that would allow the scheduler to make other informed
decisions.

Where as other attempts which really didn't involve the scheduler at
all, and just suspended based only on if there were any active critical
sections. Causing some to charge that it created a second-scheduler.

For my proposal, there could also be other cases that might parallel the
priority inheritance code, where a "important" task A is blocked waiting
on some resource held by a non-important task B which is blocked on a
device that is backed by a wakeup source. In that case, you could maybe
pass the "importance" from task A to task B, then allowing B to be
deboosted while blocked on the wakeup source, and allow suspend to
safely occur. Granted, this gets pretty complex, and isn't really
necessary, but I can imagine interested folks could hole up in academia
for awhile on similar approaches.

So with these sorts of parallels, it seems this sort of thing should be
connected in the scheduler in some way, no?

And again, I'm not sending these patches to push for inclusion, but only
just to communicate the idea and to get folks discussing the merits and
faults of this implementation compared with wakelocks or other
alternatives they might have. 

thanks
-john


