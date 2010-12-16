Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757412Ab0LPUzQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Dec 2010 15:55:16 -0500
Received: from mga02.intel.com ([134.134.136.20]:38854 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752620Ab0LPUzN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Dec 2010 15:55:13 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.59,356,1288594800"; 
   d="scan'208";a="584447188"
Message-ID: <4D0A7CB5.1030406@linux.intel.com>
Date: Thu, 16 Dec 2010 12:55:17 -0800
From: Darren Hart <dvhart@linux.intel.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101208 Lightning/1.0b2 Thunderbird/3.1.7
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: Lai Jiangshan <laijs@cn.fujitsu.com>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Steven Rostedt <rostedt@goodmis.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Dave Young <hidave.darkstar@gmail.com>,
        Namhyung Kim <namhyung@gmail.com>, LKML <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH] rtmutex: multiple candidate owners without unrelated
 boosting
References: <4D07330A.7020600@cn.fujitsu.com> <alpine.LFD.2.00.1012141850460.12146@localhost6.localdomain6>
In-Reply-To: <alpine.LFD.2.00.1012141850460.12146@localhost6.localdomain6>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/14/2010 12:07 PM, Thomas Gleixner wrote:
> B1;2401;0cOn Tue, 14 Dec 2010, Lai Jiangshan wrote:
>> Not advantage nor disadvantage
>> 1) Even we support multiple candidate owners, we hardly cause "thundering herd"
>>     the number of candidate owners is likely 1.
> 
> I'm not convinced about that function, see comments below
> 
>> 2) two APIs are changed.
>>     rt_mutex_owner() will not return pending owner
>>     rt_mutex_next_owner() always return the top owner, it is a candidate owner.
>> 	will not return NULL if we only have a pending owner.
>>     I have fixed the code that use these APIs.
> 
> I think we want a separate function which can be used by futex code,
> but that's a detail.


We do use both functions in the futex code.


> @@ -778,15 +778,6 @@ static int wake_futex_pi(u32 __user *uaddr, u32 uval, struct futex_q *this)
>  	new_owner = rt_mutex_next_owner(&pi_state->pi_mutex);
>  
>  	/*
> -	 * This happens when we have stolen the lock and the original
> -	 * pending owner did not enqueue itself back on the rt_mutex.
> -	 * Thats not a tragedy. We know that way, that a lock waiter
> -	 * is on the fly. We make the futex_q waiter the pending owner.
> -	 */
> -	if (!new_owner)
> -		new_owner = this->task;
> -


If I'm reading Lai's statement above correctly, the change actually just
eliminates the need for the !new_owner check, as in that case it will
return current. Is this correct? And indeed, Lai's patch removes it.
This looks correct to me.


> @@ -1647,18 +1638,20 @@ static int fixup_owner(u32 __user *uaddr, int fshared, struct futex_q *q,
>  		/*
>  		 * pi_state is incorrect, some other task did a lock steal and
>  		 * we returned due to timeout or signal without taking the
> -		 * rt_mutex. Too late. We can access the rt_mutex_owner without
> -		 * locking, as the other task is now blocked on the hash bucket
> -		 * lock. Fix the state up.


How does this patch change this behavior? Removing the comment and
adding the lock says that "the other task is now able to contend for the
pi_mutex".


> +		 * rt_mutex. Too late.
>  		 */
> +		raw_spin_lock(&q->pi_state->pi_mutex.wait_lock);
>  		owner = rt_mutex_owner(&q->pi_state->pi_mutex);
> +		if (!owner)
> +			owner = rt_mutex_next_owner(&q->pi_state->pi_mutex);
> +		raw_spin_unlock(&q->pi_state->pi_mutex.wait_lock);
>  		ret = fixup_pi_state_owner(uaddr, q, owner, fshared);
>  		goto out;
>  	}
>  
>  	/*
>  	 * Paranoia check. If we did not take the lock, then we should not be
> -	 * the owner, nor the pending owner, of the rt_mutex.
> +	 * the owner of the rt_mutex.


Is this changed because we could now be a "candidate owner" ?


>  	 */
>  	if (rt_mutex_owner(&q->pi_state->pi_mutex) == current)
>  		printk(KERN_ERR "fixup_owner: ret = %d pi-mutex: %p "


The other uses of rt_mutex_owner in futex.c don't appear to be impacted
by the change in API described above as they just compare the result to
current (futex_lock_pi and futex_wait_requeue_pi).


-- 
Darren Hart
Yocto Linux Kernel
