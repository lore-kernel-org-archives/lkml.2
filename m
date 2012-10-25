Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932814Ab2JYEep (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2012 00:34:45 -0400
Received: from mga09.intel.com ([134.134.136.24]:48747 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751486Ab2JYEeo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2012 00:34:44 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,645,1344236400"; 
   d="scan'208";a="210523014"
Message-ID: <5088C10C.80503@linux.intel.com>
Date: Wed, 24 Oct 2012 21:33:16 -0700
From: Darren Hart <dvhart@linux.intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121016 Thunderbird/16.0.1
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: Siddhesh Poyarekar <siddhesh.poyarekar@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH] [RESEND 2] Take over futex of dead task only if FUTEX_WAITERS
 is not set
References: <CAAHN_R1O3asyJGXqjs5qt0b_qGR6S6RuM+E_85VaEoWAyAMheQ@mail.gmail.com> <1350876034-22023-1-git-send-email-siddhesh.poyarekar@gmail.com> <5086A3D1.7080709@linux.intel.com> <alpine.LFD.2.02.1210232138540.2756@ionos>
In-Reply-To: <alpine.LFD.2.02.1210232138540.2756@ionos>
X-Enigmail-Version: 1.4.5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 10/23/2012 01:29 PM, Thomas Gleixner wrote:
> Darren, Siddhesh,
> 
> On Tue, 23 Oct 2012, Darren Hart wrote:
> 
>> Hi Siddesh,
>>
>> Thanks for the patch and your work to isolate it in the glibc bug 14076.
>>
>> On 10/21/2012 08:20 PM, Siddhesh Poyarekar wrote:
>>> In futex_lock_pi_atomic, we consider that if the value in the futex
>>> variable is 0 with additional flags, then it is safe for takeover
>>> since the owner of the futex is dead.  However, when FUTEX_WAITERS is
>>> set in the futex value, handle_futex_death calls futex_wake to wake up
>>> one task. 
>>
>> It shouldn't for PI mutexes. It should just set the FUTEX_OWNER_DIED flag,
>> maintaining the FUTEX_WAITERS flag, and exit.
>>
>> int handle_futex_death(...
>> ...
>> 		/*
>> 		 * Wake robust non-PI futexes here. The wakeup of
>> 		 * PI futexes happens in exit_pi_state():
>> 		 */
>> 		if (!pi && (uval & FUTEX_WAITERS))
>> 			futex_wake(uaddr, 1, 1, FUTEX_BITSET_MATCH_ANY);
> 
> Yes, the description of the problem is slightly wrong, but it still
> pinpoints the real wreckage.
> 
>>> Hence the assumption in futex_lock_pi_atomic is not correct.
>>> The correct assumption is that a futex may be considered safe for a
>>> takeover if The FUTEX_OWNER_DIED bit is set, the TID bits are 0 and
>>> the FUTEX_WAITERS bit is not set.
> ...
>>> -	if (unlikely(ownerdied || !(curval & FUTEX_TID_MASK))) {
>>> +	if (unlikely(ownerdied ||
>>> +			!(curval & (FUTEX_TID_MASK | FUTEX_WAITERS)))) {
> 
> This solves the problem at hand, but I'm not too happy with the
> solution. One of the real possible scenarios which expose the problem
> is:
> 
> Futex F is initialized with PTHREAD_PRIO_INHERIT and
> PTHREAD_MUTEX_ROBUST_NP attributes.
> 
> T1 lock_futex_pi(F);
> 
> T2 lock_futex_pi(F);
> 
>    --> T2 blocks on the futex and creates pi_state which is associated
>        to T1.
> 
> T1 exits
> 
>    --> exit_robust_list() runs
> 
>        --> Futex F userspace value TID field is set to 0 and
>            FUTEX_OWNER_DIED bit is set.
>        	   
> T3 lock_futex_pi(F);
> 
>    --> Succeeds due to the check for F's userspace TID field == 0
> 
>    --> Claims ownership of the futex and sets its own TID into the
>        userspace TID field of futex F
> 
>    --> returns to user space  
> 
> T1 --> exit_pi_state_list()
> 
>        --> Transfers pi_state to waiter T2 and wakes T2 via
>        	   rt_mutex_unlock(&pi_state->mutex)
> 
> T2 --> acquires pi_state->mutex and gains real ownership of the
>        pi_state
> 
>    --> Claims ownership of the futex and sets its own TID into the
>        userspace TID field of futex F
> 
>    --> returns to user space  
> 
> T3 --> observes inconsistent state
> 
> This problem is independent of UP/SMP, preemptible/non preemptible
> kernels, or process shared vs. private. The only difference is that
> certain configurations are more likely to expose it.
> 
> So as Siddhesh correctly analyzed the following check in
> futex_lock_pi_atomic() is the culprit:
> 
> 	if (unlikely(ownerdied || !(curval & FUTEX_TID_MASK))) {
> 
> We check the userspace value for a TID value of 0 and take over the
> futex unconditionally if that's true.
> 
> AFAICT this check is there as it is correct for a different corner
> case of futexes: the WAITERS bit became stale.
> 
> Now the proposed change
> 
> -	if (unlikely(ownerdied || !(curval & FUTEX_TID_MASK))) {
> +       if (unlikely(ownerdied ||
> +                       !(curval & (FUTEX_TID_MASK | FUTEX_WAITERS)))) {
> 
> solves the problem, but it's not obvious why and it wreckages the
> "stale WAITERS bit" case.


In what scenario does the WAITERS bit become stale for pi futexes? This
corner case seems rather core to your solution, so I would like to
understand it a bit better.


> 
> What happens is, that due to the WAITERS bit being set (T2 is blocked
> on that futex) it enforces T3 to go through lookup_pi_state(), which
> in the above case returns an existing pi_state and therefor forces T3
> to legitimately fight with T2 over the ownership of the pi_state (via
> pi_state->mutex). Probelm solved!
> 
> Though that does not work for the "WAITERS bit is stale" problem
> because if lookup_pi_state() does not find existing pi_state it
> returns -ERSCH (due to TID == 0) which causes futex_lock_pi() to
> return -ESRCH to user space because the OWNER_DIED bit is not set.
> 
> Now there is a different solution to that problem. Do not look at the
> user space value at all and enforce a lookup of possibly available
> pi_state. If pi_state can be found, then the new incoming locker T3
> blocks on that pi_state and legitimately races with T2 to acquire the
> rt_mutex and the pi_state and therefor the proper ownership of the
> user space futex.


My first concern here is performance impact by forcing the pi_state
lookup, however, if we got this far, we already took the syscall, and
our performance sucks anyway. Correctness obviously trumps performance here.


> 
> lookup_pi_state() has the correct order of checks. It first tries to
> find a pi_state associated with the user space futex and only if that
> fails it checks for futex TID value = 0. If no pi_state is available
> nothing can create new state at that point because this happens with
> the hash bucket lock held.
> 
> So the above scenario changes to:
> 
> T1 lock_futex_pi(F);
> 
> T2 lock_futex_pi(F);
> 
>    --> T2 blocks on the futex and creates pi_state which is associated
>        to T1.
> 
> T1 exits
> 
>    --> exit_robust_list() runs
> 
>        --> Futex F userspace value TID field is set to 0 and
>            FUTEX_OWNER_DIED bit is set.
>        	   
> T3 lock_futex_pi(F);
> 
>    --> Finds pi_state and blocks on pi_state->rt_mutex
> 
> T1 --> exit_pi_state_list()
> 
>        --> Transfers pi_state to waiter T2 and wakes it via
>        	   rt_mutex_unlock(&pi_state->mutex)
> 
> T2 --> acquires pi_state->mutex and gains ownership of the pi_state
> 
>    --> Claims ownership of the futex and sets its own TID into the
>        userspace TID field of futex F
> 
>    --> returns to user space 
> 
> This covers all gazillion points on which T3 might come in between
> T1's exit_robust_list() clearing the TID field and T2 fixing it up. It
> also solves the "WAITERS bit stale" problem by forcing the take over.
> 
> Another benefit of changing the code this way is that it makes it less
> dependent on untrusted user space values and therefor minimizes the
> possible wreckage which might be inflicted.


That's a definite plus!


> As usual after staring for too long at the futex code my brain hurts
> so much that I really want to ditch that whole optimization of
> avoiding the syscall for the non contended case for PI futexes and rip
> out the maze of corner case handling code. Unfortunately we can't as
> user space relies on that existing behaviour, but at least thinking
> about it helps me to preserve my mental sanity. Maybe we should
> nevertheless :)


I was surprised at how fast you were able to page all this in after all
that travel - or is this what you did for 12 hours on the plane?

:-)

--
Darren


> Thanks,
> 
> 	tglx
> 
> -------------->
> 
> Index: linux/kernel/futex.c
> ===================================================================
> --- linux.orig/kernel/futex.c
> +++ linux/kernel/futex.c
> @@ -716,7 +716,7 @@ static int futex_lock_pi_atomic(u32 __us
>  				struct futex_pi_state **ps,
>  				struct task_struct *task, int set_waiters)
>  {
> -	int lock_taken, ret, ownerdied = 0;
> +	int lock_taken, ret, force_take = 0;
>  	u32 uval, newval, curval, vpid = task_pid_vnr(task);
>  
>  retry:
> @@ -755,17 +755,15 @@ retry:
>  	newval = curval | FUTEX_WAITERS;
>  
>  	/*
> -	 * There are two cases, where a futex might have no owner (the
> -	 * owner TID is 0): OWNER_DIED. We take over the futex in this
> -	 * case. We also do an unconditional take over, when the owner
> -	 * of the futex died.
> -	 *
> -	 * This is safe as we are protected by the hash bucket lock !
> +	 * Should we force take the futex? See below.
>  	 */
> -	if (unlikely(ownerdied || !(curval & FUTEX_TID_MASK))) {
> -		/* Keep the OWNER_DIED bit */
> +	if (unlikely(force_take)) {
> +		/*
> +		 * Keep the OWNER_DIED and the WAITERS bit and set the
> +		 * new TID value.
> +		 */
>  		newval = (curval & ~FUTEX_TID_MASK) | vpid;
> -		ownerdied = 0;
> +		force_take = 0;
>  		lock_taken = 1;
>  	}
>  
> @@ -775,7 +773,7 @@ retry:
>  		goto retry;
>  
>  	/*
> -	 * We took the lock due to owner died take over.
> +	 * We took the lock due to forced take over.
>  	 */
>  	if (unlikely(lock_taken))
>  		return 1;
> @@ -790,20 +788,25 @@ retry:
>  		switch (ret) {
>  		case -ESRCH:
>  			/*
> -			 * No owner found for this futex. Check if the
> -			 * OWNER_DIED bit is set to figure out whether
> -			 * this is a robust futex or not.
> +			 * We failed to find an owner for this
> +			 * futex. So we have no pi_state to block
> +			 * on. This can happen in two cases:
> +			 *
> +			 * 1) The owner died
> +			 * 2) A stale FUTEX_WAITERS bit
> +			 *
> +			 * Re-read the futex value.
>  			 */
>  			if (get_futex_value_locked(&curval, uaddr))
>  				return -EFAULT;
>  
>  			/*
> -			 * We simply start over in case of a robust
> -			 * futex. The code above will take the futex
> -			 * and return happy.
> +			 * If the owner died or we have a stale
> +			 * WAITERS bit the owner TID in the user space
> +			 * futex is 0.
>  			 */
> -			if (curval & FUTEX_OWNER_DIED) {
> -				ownerdied = 1;
> +			if (!(curval & FUTEX_TID_MASK)) {
> +				force_take = 1;
>  				goto retry;
>  			}
>  		default:
> 

-- 
Darren Hart
Intel Open Source Technology Center
Yocto Project - Technical Lead - Linux Kernel
