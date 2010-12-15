Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760463Ab0LOEQu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Dec 2010 23:16:50 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:46528 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759305Ab0LOEQt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Dec 2010 23:16:49 -0500
X-Authority-Analysis: v=1.1 cv=+c36koQ5Dcj/1qolKHjtkYAGXvrVJRRiKMp+84F5sLg= c=1 sm=0 a=wum_O5HyHpgA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=yhZhzoEtmOLw2PDoeucA:9 a=JYIpu-bck-ZA_0R15U0A:7 a=ZCsik6ciRInDBHSiRJaCTUHgAYMA:4 a=PUjeQqilurYA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [PATCH] rtmutex: multiple candidate owners without unrelated
 boosting
From: Steven Rostedt <rostedt@goodmis.org>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Andrew Morton <akpm@linux-foundation.org>,
        Dave Young <hidave.darkstar@gmail.com>,
        Darren Hart <dvhart@linux.intel.com>,
        Namhyung Kim <namhyung@gmail.com>, LKML <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
In-Reply-To: <4D083900.1050801@cn.fujitsu.com>
References: <4D07330A.7020600@cn.fujitsu.com>
	 <alpine.LFD.2.00.1012141850460.12146@localhost6.localdomain6>
	 <4D083900.1050801@cn.fujitsu.com>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Tue, 14 Dec 2010 23:16:46 -0500
Message-ID: <1292386606.5015.1862.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-12-15 at 11:41 +0800, Lai Jiangshan wrote:

> But this may lead to livelock if we do deprive candidate ownership
> as I mentioned (the mail I reply to Steven)

But I don't really agree with this livelock situation. It seems very
contrived, and as I said in my reply. If something is causing all these
tasks to have their processes boosted (and probably unboosted) there's
much bigger issues at stake here.

> 
> Any random on the fly task is a reasonable task for the owner in this
> patch.

Which I disagree with. The highest priority process should be the only
one that gets it.

> 
> A(assigned the first candidate ownership), B, C, D, E... are in the
> waitlist. But before new owner really take the lock, B, D 's priority
> are raised and they became the top waiter at least once,
> (D is the top at the end, D, B, A, C, E....) B and D are also
> candidate owners. In my patch, A, B, D have the chance to compete
> the lock, they are all reasonable because they are candidate owners,
> including A!

Only the highest prio process in that list should be a candidate.

> 
> OK, let's consider the same case but without this patch.
> A is assigned the pending ownership. B, C, D, E... are in the
> waitlist, But before new owner really take the lock, B, D 's priority
> are raised. In the end, only A can complete the lock, B and D
> just do boost A and help A. only A!

I agree this is wrong, and we welcome the change. But I disagree that if
we wake up both B and D that either one has the chance to get that lock.
If we wake up B and then D gets boosted to a higher priority than B,
then D needs to get that lock. Period! I think you pointed out correctly
that the current code does not do that, but lets not make a "race to the
finish" to get that lock.


> 
> Summary, the reason I will give the lock to some random on the fly task
> which is one of the candidate owners:
> 1) avoid livelock

Which I do not see exist.

> 2) no worse than the code without this patch.

Not an excuse. I think you brought up a good point that the current code
has a poor design in the way it handles a waiting process getting
boosted, it should have fair game to the new task. But I also believe
that if we woke this process up, and its higher prio than the current
pending owner, than it should get the lock. It only makes sense in a RT
environment where fair is not fair, or better said... fair is fair
otherwise (FIFO ;-)


> 
> > 
> >> +			top_waiter = rt_mutex_top_waiter(lock);
> >> +			top_waiter->cand_seq = lock->cand_seq;
> >> +			if (!top_waiter->cand_owner) {
> >> +				top_waiter->cand_owner = 1;
> >> +				wake_up_process(top_waiter->task);
> >> +			}
> >> +		}
> >> +		raw_spin_unlock(&lock->wait_lock);
> >> +		goto out_put_task;
> > 
> > If I understand correctly, then this is the equivalent to the
> > original breakout based on !task->pi_blocked_on, right ?
> 
> Correct, original breakout when !pending_owner_task->pi_bocked_on,
> but candidate owners are still in the waitlist and ->pi_bocked_on
> still pointers to its waiter. Now we breakout when the lock
> has no owner(but has candidate owner(s) on the fly, we don't boost it).
> 
> > 
> >> +	}
> >>  	put_task_struct(task);
> > 
> >>   */
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

There is no livelock!

> 
> If we have other way to avoiding the livelock, we will use only
> one candidate owner, you, Steven and I will very happy.

Explain it again. What you said was:

"In rare condition, B,C 's priority are changed frequent", which is not
something that happens at all. If it does, we have much bigger problems
at stake.

I think your "livelock" scenario is contrived. And its not a livelock
because you will eventual run out of prios to keep boosting B and C.


> 
> > 
> >> +	 */
> >> +	if (waiter) {
> >> +		/* candidate owner? */
> >> +		if (waiter->cand_owner && waiter->cand_seq == lock->cand_seq)
> >> +			goto get_lock;
> >> +
> >> +		/*
> >> +		 * top waiter must be a candidate owner.
> >> +		 * But checking it again is not a bad thing.
> >> +		 */
> >> +		if (waiter == rt_mutex_top_waiter(lock))
> >> +			goto get_lock;
> > 
> > Huch ? This should never happen and therefor this should be a
> > WARN_ON_ONCE(). We really do not put "checking is not a bad thing"
> > code in such a fragile and complex construct. Something is very wrong
> > when you ever hit this.
> > 
> >> +	}
> >> +
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

Nothing boosts p until it has both p->pi_lock and
p->pi_blocked_on->lock->wait_lock, so this scenario does not exist.

> and current task p success take it and call try_to_take_rt_mutex()
> before p->pi_block_on is requeued in the waitlist.
> current task should also have chance to win the lock even it is
> not candidate owner/top waiter. It will win when it has the higher
> priority than the top waiter.

I don't see how this can happen with the way the locks are taken.


> 
> 
> > 
> >> +	 */
> >> +	if (rt_mutex_has_waiters(lock)) {
> >> +		if (task->prio >= rt_mutex_top_waiter(lock)->list_entry.prio)
> >> +			return 0;
> >> +	}
> >> +
> >> +get_lock:
> >> +	if (waiter || rt_mutex_has_waiters(lock)) {
> >> +		unsigned long flags;
> >> +		struct rt_mutex_waiter *top;
> >> +
> >> +		raw_spin_lock_irqsave(&task->pi_lock, flags);
> >> +
> >> +		/* remove the queued waiter. */
> >> +		if (waiter) {
> >> +			plist_del(&waiter->list_entry, &lock->wait_list);
> >> +			task->pi_blocked_on = NULL;
> >> +		}
> >> +
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

No one could have boosted any of the waiters because we have all the
waiters blocked_on->lock->wait_list lock.

Thomas is correct.


> 
> > 
> >> +		}
> >> +		raw_spin_unlock_irqrestore(&task->pi_lock, flags);
> > 
> >> @@ -424,6 +427,7 @@ static int task_blocks_on_rt_mutex(struct rt_mutex *lock,
> >>  	__rt_mutex_adjust_prio(task);
> >>  	waiter->task = task;
> >>  	waiter->lock = lock;
> >> +	waiter->cand_owner = 0;
> > 
> > This should init waiter->cand_seq to RTMUTEX_CAND_SEQ_MAX and get rid
> > of cand_owner.
> 
> good! thanks.

As I said in another email, I think we should keep cand_owner (rename it
though) and get rid of cand_seq. Looks to me that we can simply use the
top_waiter to decide who gets the lock.

-- Steve

> 
> > 
> >> +	waiter->cand_seq = ++lock->cand_seq;
> > 
> > If we make cand_seq an indicator then we need to do
> > 
> >    lock->cand_seq = (lock->cand_seq + 1) & ~RTMUTEX_CAND_SEQ_MAX;
> >  
> >> @@ -1110,12 +1056,11 @@ int rt_mutex_finish_proxy_lock(struct rt_mutex *lock,
> >>  
> >>  	set_current_state(TASK_INTERRUPTIBLE);
> >>  
> >> -	ret = __rt_mutex_slowlock(lock, TASK_INTERRUPTIBLE, to, waiter,
> >> -				  detect_deadlock);
> > 
> > Hmm, so we loose the deadlock detection in that case. Not sure whether
> > it matters though.
> > 
> > All in all I like the idea and I think we should give it a try, but I
> > definitely want to test a patch against -RT, as this will shake out
> > all problems in no time.
> > 
> 
> Thanks,
> Lai


