Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751234Ab2LVAsB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Dec 2012 19:48:01 -0500
Received: from mail-pb0-f48.google.com ([209.85.160.48]:55994 "EHLO
	mail-pb0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750800Ab2LVAr6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Dec 2012 19:47:58 -0500
Message-ID: <50D5033A.2070309@gmail.com>
Date: Fri, 21 Dec 2012 16:47:54 -0800
From: David Daney <ddaney.cavm@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Rik van Riel <riel@redhat.com>
CC: linux-kernel@vger.kernel.org, aquini@redhat.com, walken@google.com,
        lwoodman@redhat.com, jeremy@goop.org,
        Jan Beulich <JBeulich@novell.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [RFC PATCH 3/3] x86,smp: auto tune spinlock backoff delay factor
References: <20121221184940.103c31ad@annuminas.surriel.com> <20121221185147.4ae48ab5@annuminas.surriel.com>
In-Reply-To: <20121221185147.4ae48ab5@annuminas.surriel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/21/2012 03:51 PM, Rik van Riel wrote:
> Subject: x86,smp: auto tune spinlock backoff delay factor

Nice work,

A couple of comments...

>
> Many spinlocks are embedded in data structures; having many CPUs
> pounce on the cache line the lock is in will slow down the lock
> holder, and can cause system performance to fall off a cliff.
>
> The paper "Non-scalable locks are dangerous" is a good reference:
>
> 	http://pdos.csail.mit.edu/papers/linux:lock.pdf
>
> In the Linux kernel, spinlocks are optimized for the case of
> there not being contention. After all, if there is contention,
> the data structure can be improved to reduce or eliminate
> lock contention.
>
> Likewise, the spinlock API should remain simple, and the
> common case of the lock not being contended should remain
> as fast as ever.
>
> However, since spinlock contention should be fairly uncommon,
> we can add functionality into the spinlock slow path that keeps
> system performance from falling off a cliff when there is lock
> contention.
>
> Proportional delay in ticket locks is delaying the time between
> checking the ticket based on a delay factor, and the number of
> CPUs ahead of us in the queue for this lock. Checking the lock
> less often allows the lock holder to continue running, resulting
> in better throughput and preventing performance from dropping
> off a cliff.
>
> Proportional spinlock delay with a high delay factor works well
> when there is lots contention on a lock. Likewise, a smaller
> delay factor works well when a lock is lightly contended.
>
> Making the code auto-tune the delay factor results in a system
> that performs well with both light and heavy lock contention.
>
> Signed-off-by: Rik van Riel <riel@redhat.com>
> ---
>   arch/x86/kernel/smp.c |   49 ++++++++++++++++++++++++++++++++++++++++++++++---
>   1 files changed, 46 insertions(+), 3 deletions(-)
>
> diff --git a/arch/x86/kernel/smp.c b/arch/x86/kernel/smp.c
> index 1c1eb02..8786476 100644
> --- a/arch/x86/kernel/smp.c
> +++ b/arch/x86/kernel/smp.c
> @@ -113,19 +113,62 @@ static atomic_t stopping_cpu = ATOMIC_INIT(-1);
>   static bool smp_no_nmi_ipi = false;
>
>   /*
> - * Wait on a congested ticket spinlock.
> + * Wait on a congested ticket spinlock. Many spinlocks are embedded in
> + * data structures; having many CPUs pounce on the cache line with the
> + * spinlock simultaneously can slow down the lock holder, and the system
> + * as a whole.
> + *
> + * To prevent total performance collapse in case of bad spinlock contention,
> + * perform proportional backoff. The per-cpu value of delay is automatically
> + * tuned to limit the number of times spinning CPUs poll the lock before
> + * obtaining it. This limits the amount of cross-CPU traffic required to obtain
> + * a spinlock, and keeps system performance from dropping off a cliff.
> + *
> + * There is a tradeoff. If we poll too often, the whole system is slowed
> + * down. If we sleep too long, the lock will go unused for a period of
> + * time. Adjusting "delay" to poll, on average, 2.7 times before the
> + * lock is obtained seems to result in low bus traffic. The combination
> + * of aiming for a non-integer amount of average polls, and scaling the
> + * sleep period proportionally to how many CPUs are ahead of us in the
> + * queue for this ticket lock seems to reduce the amount of time spent
> + * "oversleeping" the release of the lock.
>    */
> +#define MIN_SPINLOCK_DELAY 1
> +#define MAX_SPINLOCK_DELAY 1000
> +DEFINE_PER_CPU(int, spinlock_delay) = { MIN_SPINLOCK_DELAY };


This gives the same delay for all locks in the system, but the amount of 
work done under each lock is different.  So, for any given lock, the 
delay is not optimal.

This is an untested idea that came to me after looking at this:

o Assume that for any given lock, the optimal delay is the same for all 
CPUs in the system.

o Store a per-lock delay value in arch_spinlock_t.

o Once a CPU owns the lock it can update the delay as you do for the 
per_cpu version.  Tuning the delay on fewer of the locking operations 
reduces bus traffic, but makes it converge more slowly.

o Bonus points if you can update the delay as part of the releasing store.

>   void ticket_spin_lock_wait(arch_spinlock_t *lock, struct __raw_tickets inc)
>   {
> +	/*
> +	 * Use the raw per-cpu pointer; preemption is disabled in the
> +	 * spinlock code. This avoids put_cpu_var once we have the lock.
> +	 */
> +	int *delay_ptr = &per_cpu(spinlock_delay, smp_processor_id());
> +	int delay = *delay_ptr;
> +
>   	for (;;) {
> -		int loops = 50 * (__ticket_t)(inc.tail - inc.head);
> +		int loops = delay * (__ticket_t)(inc.tail - inc.head);
>   		while (loops--)
>   			cpu_relax();
>
>   		inc.head = ACCESS_ONCE(lock->tickets.head);
> -		if (inc.head == inc.tail)
> +		if (inc.head == inc.tail) {
> +			/* Decrease the delay, since we may have overslept. */
> +			if (delay > MIN_SPINLOCK_DELAY)
> +				delay--;
>   			break;
> +		}
> +
> +		/*
> +		 * The lock is still busy, the delay was not long enough.
> +		 * Going through here 2.7 times will, on average, cancel
> +		 * out the decrement above. Using a non-integer number
> +		 * gets rid of performance artifacts and reduces oversleeping.
> +		 */
> +		if (delay < MAX_SPINLOCK_DELAY &&
> +				(!(inc.head & 3) == 0 || (inc.head & 7) == 1))
> +			delay++;
>   	}
> +	*delay_ptr = delay;
>   }
>
>   /*
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>

