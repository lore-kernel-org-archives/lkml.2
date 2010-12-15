Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754850Ab0LOHtC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Dec 2010 02:49:02 -0500
Received: from www.tglx.de ([62.245.132.106]:49151 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752766Ab0LOHtA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Dec 2010 02:49:00 -0500
Date: Wed, 15 Dec 2010 08:47:38 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Steven Rostedt <rostedt@goodmis.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Dave Young <hidave.darkstar@gmail.com>,
        Darren Hart <dvhart@linux.intel.com>,
        Namhyung Kim <namhyung@gmail.com>, LKML <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH] rtmutex: multiple candidate owners without unrelated
 boosting
In-Reply-To: <4D083900.1050801@cn.fujitsu.com>
Message-ID: <alpine.LFD.2.00.1012150826230.12146@localhost6.localdomain6>
References: <4D07330A.7020600@cn.fujitsu.com> <alpine.LFD.2.00.1012141850460.12146@localhost6.localdomain6> <4D083900.1050801@cn.fujitsu.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 15 Dec 2010, Lai Jiangshan wrote:
> On 12/15/2010 04:07 AM, Thomas Gleixner wrote:
> >> +		 */
> >> +		if (top_waiter != rt_mutex_top_waiter(lock)) {
> > 
> > Shouldn't this:
> > 
> >   - clear cand_owner on the previous top_waiter ?
> >   - increment the cand_seq ?
> > 
> > If we increment cand_seq, then we can get rid of cand_owner completely
> > as waiter->cand_seq == lock->cand_seq should be sufficient. And it
> > would automatically prefer the new top waiter and not give the lock to
> > some random on the fly task.
> 
> 
> If we increment cand_seq, we do deprive candidate ownership from the
> original one and we have only one candidate owner.

Which is good.
 
> If we have just one candidate owner at most, we don't need
> cand_seq either. we can save it in lock->owner, (like pending owner).

Even better.
 
> But this may lead to livelock if we do deprive candidate ownership
> as I mentioned (the mail I reply to Steven)

I think that's a non realistic scenario. If you have something which
is changing the priority of multiple waiters with high frequency, then
the rtmutex code is the least of your worries.

> Any random on the fly task is a reasonable task for the owner in this
> patch.
> 
> A(assigned the first candidate ownership), B, C, D, E... are in the
> waitlist. But before new owner really take the lock, B, D 's priority
> are raised and they became the top waiter at least once,
> (D is the top at the end, D, B, A, C, E....) B and D are also
> candidate owners. In my patch, A, B, D have the chance to compete
> the lock, they are all reasonable because they are candidate owners,
> including A!
> 
> OK, let's consider the same case but without this patch.
> A is assigned the pending ownership. B, C, D, E... are in the
> waitlist, But before new owner really take the lock, B, D 's priority
> are raised. In the end, only A can complete the lock, B and D
> just do boost A and help A. only A!

You mean with the current code. Right, that's not pretty but not
really an issue either. I inustrumented that on RT and the situation
happens twice out of 12 Mio.

I'm way more interested in simplifying the code than in handling this
corner case.
 
> Summary, the reason I will give the lock to some random on the fly task
> which is one of the candidate owners:
> 1) avoid livelock

There is none.

> 2) no worse than the code without this patch.

That's not an argument at all.
 
> >> -static int try_to_take_rt_mutex(struct rt_mutex *lock)
> >> +static int try_to_take_rt_mutex(struct rt_mutex *lock, struct task_struct *task,
> >> +		struct rt_mutex_waiter *waiter)
> >>  {
> >>  	/*
> >>  	 * We have to be careful here if the atomic speedups are
> >> @@ -390,15 +335,73 @@ static int try_to_take_rt_mutex(struct rt_mutex *lock)
> >>  	 */
> >>  	mark_rt_mutex_waiters(lock);
> >>  
> >> -	if (rt_mutex_owner(lock) && !try_to_steal_lock(lock, current))
> >> +	if (rt_mutex_owner(lock))
> >>  		return 0;
> >>  
> >> +	/*
> >> +	 * It is a queued waiter.
> >> +	 *
> >> +	 * Is it a candidate owner? If it is, it will win unconditionally.
> >> +	 * And it defeats the other candidate owner(s) (if any) and
> >> +	 * steal lock from them.
> > 
> > Why ? If the boost code changes the top waiter and wakes up the new
> > candidate, then this new one really should get the lock and the old on
> > the fly candidate should queue itself back.
> 
> See above, all candidate owner have the chance to compete the lock.
> It is required for avoiding the livelock.
> 
> If we have other way to avoiding the livelock, we will use only
> one candidate owner, you, Steven and I will very happy.

Have you ever been able to observe that live lock ? If yes, what did
it take to produce it ?
 
> >> +	/*
> >> +	 * Does it defeat the candidate owner(s) and steal lock from them?
> >> +	 *
> >> +	 * Note: in the rare case of a task is boosted but its waiter has not
> >> +	 * been requeued in the lock's wait list yet, thus it can also steal
> >> +	 * the lock.
> > 
> > How should this happen with the new code ? The waiter remains in the
> > wait list and boosting does not change that. So that comment is
> > misleading.
> 
> When someone boosted current task p, but it fail to take the p->pi_block_on->lock->wait_lock,
> and current task p success take it and call try_to_take_rt_mutex()
> before p->pi_block_on is requeued in the waitlist.
> current task should also have chance to win the lock even it is
> not candidate owner/top waiter. It will win when it has the higher
> priority than the top waiter.
 
Err? If it's not getting the lock then P is hardly the top waiter
simply because the requeue in lock->wait_list did not happen
yet. That's fully serialized.
 
> >> +		/*
> >> +		 * We have to enqueue the top waiter(if have) into
> >> +		 * task->pi_waiters list and would get boost from it.
> >> +		 */
> >> +		if (rt_mutex_has_waiters(lock)) {
> >> +			top = rt_mutex_top_waiter(lock);
> >> +			top->pi_list_entry.prio = top->list_entry.prio;
> >> +			plist_add(&top->pi_list_entry, &task->pi_waiters);
> >> +			__rt_mutex_adjust_prio(task);
> > 
> > Why should we boost ? Because we can have several candidates on the
> > fly and we don't care which one is the highest prio candidate? That
> > looks wrong.
> 
> A really owner should (be boosted)/(prepare to be booted) by the waiters.
> such code is also needed in original code.

No, that's only necessary because you allow multiple possible owners
and you can end up with a lock owner which has less priority than the
highest priority waiter. If you restrict that to the highest prio
waiter then no boosting is necessary at all.

Thanks,

	tglx


