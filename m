Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759749Ab0LNRBA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Dec 2010 12:01:00 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:58356 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759317Ab0LNRA7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Dec 2010 12:00:59 -0500
X-Authority-Analysis: v=1.1 cv=+c36koQ5Dcj/1qolKHjtkYAGXvrVJRRiKMp+84F5sLg= c=1 sm=0 a=wum_O5HyHpgA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=meVymXHHAAAA:8 a=h06OvW9OKaF0Ctqxn_sA:9 a=qs1aRt_D4UXdlWs_9-4A:7 a=kBx_5aRwDK-tJoQjUpjUOaSwYJIA:4 a=PUjeQqilurYA:10 a=jeBq3FmKZ4MA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [PATCH] rtmutex: multiple candidate owners without unrelated
 boosting
From: Steven Rostedt <rostedt@goodmis.org>
To: Lai Jiangshan <eag0628@gmail.com>
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Andrew Morton <akpm@linux-foundation.org>,
        Dave Young <hidave.darkstar@gmail.com>,
        Darren Hart <dvhart@linux.intel.com>,
        Namhyung Kim <namhyung@gmail.com>, LKML <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
In-Reply-To: <AANLkTi=Ui3mUsi0wHxRYasGsS20tuTfEi8xzMT3o9g+F@mail.gmail.com>
References: <4D07330A.7020600@cn.fujitsu.com>
	 <1292335269.5015.1798.camel@gandalf.stny.rr.com>
	 <AANLkTi=Ui3mUsi0wHxRYasGsS20tuTfEi8xzMT3o9g+F@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Tue, 14 Dec 2010 12:00:55 -0500
Message-ID: <1292346055.5015.1815.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-12-15 at 00:44 +0800, Lai Jiangshan wrote:
> On Tue, Dec 14, 2010 at 10:01 PM, Steven Rostedt <rostedt@goodmis.org> wrote:
> 
> >
> >>
> >> This is the motivation of this patch.
> >>
> >> An approach(wrong): when C's priority become higher and B, we deprive
> >> the pending ownership from B and give it to C and wakeup C.
> >> But this approach may lead to livelock.
> >
> > I'm curious to how this can cause a livelock. I'm not doubting you, but
> > I just woke up, and I'm only half way through my first cup of coffee.
> >
> 
> if B is deprived, B has go to sleep again. In rare condition,
> B,C 's priority are changed frequent, the pending ownership is
> given to B/ deprived from B and given to C/ deprived from C and given to B
> ......
> 
> No task can go forward, it is a kind of livelock.

Hmm, to have C and B change prios frequently, they will need to either
have someone in some for loop doing chrt on them (which is just bad), or
have lots of RT tasks constantly blocking on tasks that they own, which
is also bad. I find this far from a livelock, and any case that does
this would have more issues than causing a livelock here.

> 
> >>
> >> So my approach: just give pending ownership(candidate ownership)
> >> to C and wakeup C. Thus we have multiple candidate owners(B and C).
> >> Any candidate owner is not boosted until it really owns the rtmutex.
> >>
> >> The candidate ownership is assigned to the top waiter always when
> >> 1) unlock time
> >> 2) the top waiter is changed
> >
> > (not looking at the code itself yet) How is a candidate ownership
> > changed when the top waiter is changed?
> 
> candidate ownerships will not changed until some task really owns it.
> when the top waiter is changed, the top waiter is also assigned
> candidate ownership. The candidate ownerships are not stored in
> struct rtmutex, they are store in the corresponding waiters.
> 
> > Or is that only when the lock
> > has been unlocked and the current candidate hasn't taken it yet?
> 
> Yes, the current candidate hasn't taken it yet, it is just woken up.
> 
> >
> >>
> >> If any candidate owner is running and calls try_to_take_rt_mutex(),
> >> it will win unconditionally and really own the lock.
> >
> > (still not looking at code :-)  What happens if another high prio
> > process comes along and tries to take the lock before the candidate gets
> > there. That high prio task should still steal the lock. The candidate
> > will lose it then.
> 
> Another higher prio task will steal the lock before the candidate
> gets there. The candidates will go to sleep again.
> 
> >
> >>
> >> How to indicate a candidate owner?
> >> 1) add a variable can_seq in the struct rtmutex, it is increased
> >>    when unlock (with waiters queued).
> >> 2) when a waiter is assigned candidate ownership:
> >>    waiter->cand_seq = rtmutex->cand_seq, waiter->cand_owner = 1;
> >> So a waiter is candidate owner when if and only if
> >> (waiter->cand_owner && waiter->cand_seq == lock->cand_seq)
> >
> > Again, what happens when another high prio task comes along and takes
> > the lock? Does cand_owner turn to zero? (Almost done with my coffee,
> > then I'll look at code. Or maybe after a second cup, rtmutex requires
> > two cups to review code).
> 
> After this lucky high prio task release the lock, the lock->cand_seq
> is increased. so there is no candidate owner until we assign new
> candidate owners. (we will assign a new one immediately)

When the lock was released the first time, we got a cand_owner, right?
In which case, lock->cand_seq is set.

But before the cand_owner gets the lock, a high prio task steals it. I
guess that sets lock->cand_seq back to zero. (I really need to go down
and look at the patch ;-)

> 
> 
> >
> >>
> >> Other advantage of this patch:
> >> 1) The states of a rtmutex are reduced a half, easier to read the code.
> >
> > This is good.
> >
> >> 2) the codes become shorter.
> >
> > This is also good.
> >
> >> 3) pending owner is not dequeued: they will retain FIFO when it is stolen.
> >
> > I don't quite understand this part.
> 
> if B C have the some priority and are queued in the waitlist of
> a lock which is owned by A. A release it. B is assigned pending
> ownership and dequeued. But D steal the lock and B is enqueued.
> Now, the top waiter is C, not B. It breaks FIFO.

Ah, thanks for the explanation. I remember this issue.

> 
> >
> >> 4) like normal mutex, unlock path just do very little work and wakeup candidate owner.
> >>    candidate owner dequeue its waiter when it wins the lock.
> >
> > Hmm, this seems tricky. I kind of remember going this path and hitting
> > issues before.
> 
> if we have only one pending owner, we must do something for
> the pending owner and prepared it to be boosted when needed, so it's
> not possible that the unlock path just do very little work.
> 
> multiple candidates make things simpler.

I'm almost done with my third cup of coffee, I guess that may give me
the energy to review this patch.

-- Steve


