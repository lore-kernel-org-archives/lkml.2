Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752109Ab2LVDdr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Dec 2012 22:33:47 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:25609 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751085Ab2LVDdo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Dec 2012 22:33:44 -0500
X-Authority-Analysis: v=2.0 cv=O9a7TWBW c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=wom5GMh1gUkA:10 a=v87cGlukdQQA:10 a=5SG0PmZfjMsA:10 a=kj9zAlcOel0A:10 a=meVymXHHAAAA:8 a=Fx92VpDN7C8A:10 a=VwQbUJbxAAAA:8 a=W0vUJOdyAAAA:8 a=JMYbEAMUqC2qXhJYe4oA:9 a=CjuIK1q_8ugA:10 a=x8gzFH9gYPwA:10 a=prLcnP_l-f2It4yx:21 a=CGG50VC4l2KEnMOf:21 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Date: Fri, 21 Dec 2012 22:33:39 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Rik van Riel <riel@redhat.com>
Cc: linux-kernel@vger.kernel.org, aquini@redhat.com, walken@google.com,
        lwoodman@redhat.com, jeremy@goop.org,
        Jan Beulich <JBeulich@novell.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [RFC PATCH 3/3 -v2] x86,smp: auto tune spinlock backoff delay
 factor
Message-ID: <20121222033339.GF27621@home.goodmis.org>
References: <20121221184940.103c31ad@annuminas.surriel.com>
 <20121221185147.4ae48ab5@annuminas.surriel.com>
 <20121221185613.1f4c9523@annuminas.surriel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121221185613.1f4c9523@annuminas.surriel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 21, 2012 at 06:56:13PM -0500, Rik van Riel wrote:
> diff --git a/arch/x86/kernel/smp.c b/arch/x86/kernel/smp.c
> index 4e44840..e44c56f 100644
> --- a/arch/x86/kernel/smp.c
> +++ b/arch/x86/kernel/smp.c
> @@ -113,19 +113,62 @@ static atomic_t stopping_cpu = ATOMIC_INIT(-1);
>  static bool smp_no_nmi_ipi = false;
>  
>  /*
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
>   */
> +#define MIN_SPINLOCK_DELAY 1
> +#define MAX_SPINLOCK_DELAY 1000
> +DEFINE_PER_CPU(int, spinlock_delay) = { MIN_SPINLOCK_DELAY };
>  void ticket_spin_lock_wait(arch_spinlock_t *lock, struct __raw_tickets inc)
>  {
> +	/*
> +	 * Use the raw per-cpu pointer; preemption is disabled in the
> +	 * spinlock code. This avoids put_cpu_var once we have the lock.
> +	 */
> +	int *delay_ptr = &per_cpu(spinlock_delay, smp_processor_id());
> +	int delay = *delay_ptr;

I'm confused by the above comment. Why not just:

	int delay = this_cpu_read(spinlock_delay);
?

> +
>  	for (;;) {
> -		int loops = 50 * (__ticket_t)(inc.tail - inc.head);
> +		int loops = delay * (__ticket_t)(inc.tail - inc.head);
>  		while (loops--)
>  			cpu_relax();
>  
>  		inc.head = ACCESS_ONCE(lock->tickets.head);
> -		if (inc.head == inc.tail)
> +		if (inc.head == inc.tail) {
> +			/* Decrease the delay, since we may have overslept. */
> +			if (delay > MIN_SPINLOCK_DELAY)
> +				delay--;
>  			break;
> +		}
> +
> +		/*
> +		 * The lock is still busy, the delay was not long enough.
> +		 * Going through here 2.7 times will, on average, cancel
> +		 * out the decrement above. Using a non-integer number
> +		 * gets rid of performance artifacts and reduces oversleeping.
> +		 */
> +		if (delay < MAX_SPINLOCK_DELAY &&
> +				((inc.head & 3) == 0 || (inc.head & 7) == 1))
> +			delay++;
>  	}
> +	*delay_ptr = delay;

	this_cpu_write(spinlock_delay, delay);

Too bad you posted this just before break. I currently have access to a
40 core box, and I would have loved to test this. But right now I have
it testing other things, and hopefully I'll still have access to it
after the break.

-- Steve

>  }
>  
>  /*
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
