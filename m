Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754289Ab0GMJ0a (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jul 2010 05:26:30 -0400
Received: from www.tglx.de ([62.245.132.106]:33837 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751207Ab0GMJ02 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jul 2010 05:26:28 -0400
Date: Tue, 13 Jul 2010 11:25:44 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Darren Hart <dvhltc@us.ibm.com>
cc: "lkml, " <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        Eric Dumazet <eric.dumazet@gmail.com>, John Kacur <jkacur@redhat.com>,
        Steven Rostedt <rostedt@goodmis.org>, Mike Galbraith <efault@gmx.de>,
        linux-rt-users <linux-rt-users@vger.kernel.org>
Subject: Re: [PATCH][RT] futex: protect against pi_blocked_on corruption
 during requeue PI
In-Reply-To: <4C3C1DCF.9090509@us.ibm.com>
Message-ID: <alpine.LFD.2.00.1007131041230.3321@localhost.localdomain>
References: <1278478019.10245.77.camel@marge.simson.net> <alpine.LFD.2.00.1007071356480.2604@localhost.localdomain> <4C3C1DCF.9090509@us.ibm.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 13 Jul 2010, Darren Hart wrote:

> Thanks to Thomas, Steven, and Mike for hashing this over me. After an
> IRC discussion with Thomas, I put the following together. It resolves
> the issue for me, Mike please test and let us know if it fixes it for
> you. A couple of points of discussion before we commit this:
> 
> The use of the new state flag, PI_WAKEUP_INPROGRESS, is pretty ugly.
> Would a new task_pi_blocked_on_valid() method be preferred (in
> rtmutex.c)? 
> 
> The new WARN_ON() in task_blocks_on_rt_mutex() is complex. It didn't
> exist before and we've now closed this gap, should we just drop it?

We can simplify it to:

	WARN_ON(task->pi_blocked_on &&
		task->pi_blocked_on != PI_WAKEUP_INPROGRESS);

We check for !=current and PI_WAKEUP_INPROGRESS just above.   
 
> I've added a couple BUG_ON()s in futex_wait_requeue_pi() dealing with
> the race with requeue and q.lock_ptr. I'd like to leave this for the
> time being if nobody strongly objects.
> -
>  	/*
> -	 * In order for us to be here, we know our q.key == key2, and since
> -	 * we took the hb->lock above, we also know that futex_requeue() has
> -	 * completed and we no longer have to concern ourselves with a wakeup
> -	 * race with the atomic proxy lock acquition by the requeue code.
> +	 * Avoid races with requeue and trying to block on two mutexes
> +	 * (hb->lock and uaddr2's rtmutex) by serializing access to
> +	 * pi_blocked_on with pi_lock and setting PI_BLOCKED_ON_PENDING.
> +	 */
> +	raw_spin_lock(&current->pi_lock);

  Needs to be raw_spin_lock_irq()

> +	if (current->pi_blocked_on) {
> +		raw_spin_unlock(&current->pi_lock);
> +	} else {
> +		current->pi_blocked_on = (struct rt_mutex_waiter *)PI_WAKEUP_INPROGRESS;

  #define PI_WAKEUP_INPROGRESS ((struct rt_mutex_waiter *) 1)

  perhaps ? That gets rid of all type casts

> +		raw_spin_unlock(&current->pi_lock);
> +
> +		spin_lock(&hb->lock);

  We need to cleanup current->pi_blocked_on here. If we succeed in the
  hb->lock fast path then we might leak the PI_WAKEUP_INPROGRESS to user space
  and the next requeue will fail.

> diff --git a/kernel/rtmutex.c b/kernel/rtmutex.c
> index 23dd443..0399108 100644
> --- a/kernel/rtmutex.c
> +++ b/kernel/rtmutex.c
> @@ -227,7 +227,7 @@ static int rt_mutex_adjust_prio_chain(struct task_struct *task,
>  	 * reached or the state of the chain has changed while we
>  	 * dropped the locks.
>  	 */
> -	if (!waiter || !waiter->task)
> +	if (!waiter || (long)waiter == PI_WAKEUP_INPROGRESS || !waiter->task)
>  		goto out_unlock_pi;

 Why do we need that check ? Either the requeue succeeded then
 task->pi_blocked_on is set to the real waiter or the wakeup won and
 we are in no lock chain.

 If we ever find a waiter with PI_WAKEUP_INPROGRESS set in
 rt_mutex_adjust_prio_chain() then it's a bug nothing else.

> @@ -469,7 +493,8 @@ static int task_blocks_on_rt_mutex(struct rt_mutex *lock,
>  		plist_add(&waiter->pi_list_entry, &owner->pi_waiters);
>  
>  		__rt_mutex_adjust_prio(owner);
> -		if (owner->pi_blocked_on)
> +		if (owner->pi_blocked_on &&
> +		    (long)owner->pi_blocked_on != PI_WAKEUP_INPROGRESS)

  Again, that can never happen

>  			chain_walk = 1;
>  		raw_spin_unlock(&owner->pi_lock);
>  	}
> @@ -579,9 +604,11 @@ static void wakeup_next_waiter(struct rt_mutex *lock, int savestate)
>  
>  	raw_spin_lock(&pendowner->pi_lock);
>  
> -	WARN_ON(!pendowner->pi_blocked_on);
> -	WARN_ON(pendowner->pi_blocked_on != waiter);
> -	WARN_ON(pendowner->pi_blocked_on->lock != lock);
> + 	if (!WARN_ON(!pendowner->pi_blocked_on) &&
> + 	    !WARN_ON((long)pendowner->pi_blocked_on == PI_WAKEUP_INPROGRESS)) {

  Ditto

> +  		WARN_ON(pendowner->pi_blocked_on != waiter);
> +  		WARN_ON(pendowner->pi_blocked_on->lock != lock);
> +  	}
>  
>  	pendowner->pi_blocked_on = NULL;
>  
> @@ -624,7 +651,8 @@ static void remove_waiter(struct rt_mutex *lock,
>  		}
>  		__rt_mutex_adjust_prio(owner);
>  
> -		if (owner->pi_blocked_on)
> +		if (owner->pi_blocked_on &&
> +		    (long)owner->pi_blocked_on != PI_WAKEUP_INPROGRESS)
>  			chain_walk = 1;

  Same here.			
  
>  		raw_spin_unlock(&owner->pi_lock);
> @@ -658,7 +686,8 @@ void rt_mutex_adjust_pi(struct task_struct *task)
>  	raw_spin_lock_irqsave(&task->pi_lock, flags);
>  
>  	waiter = task->pi_blocked_on;
> -	if (!waiter || waiter->list_entry.prio == task->prio) {
> +	if (!waiter || (long)waiter == PI_WAKEUP_INPROGRESS ||
> +	    waiter->list_entry.prio == task->prio) {

  And here

>  /*
>   * Convert user-nice values [ -20 ... 0 ... 19 ]
>   * to static priority [ MAX_RT_PRIO..MAX_PRIO-1 ],
> @@ -6377,7 +6379,8 @@ void task_setprio(struct task_struct *p, int prio)
>  	 */
>  	if (unlikely(p == rq->idle)) {
>  		WARN_ON(p != rq->curr);
> -		WARN_ON(p->pi_blocked_on);
> +		WARN_ON(p->pi_blocked_on &&
> +		        (long)p->pi_blocked_on != PI_WAKEUP_INPROGRESS);

  Yuck. Paranoia ? If we ever requeue idle, then .....

I'm going to cleanup the stuff and send out a new patch for Mike
to test.

Thanks,

	tglx

