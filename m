Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754232Ab0GKPKW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Jul 2010 11:10:22 -0400
Received: from e34.co.us.ibm.com ([32.97.110.152]:44594 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751451Ab0GKPKV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Jul 2010 11:10:21 -0400
Message-ID: <4C39DED6.10502@us.ibm.com>
Date: Sun, 11 Jul 2010 08:10:14 -0700
From: Darren Hart <dvhltc@us.ibm.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.10) Gecko/20100528 Thunderbird/3.0.5
MIME-Version: 1.0
To: Mike Galbraith <mgalbraith@suse.de>
CC: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        Eric Dumazet <eric.dumazet@gmail.com>, John Kacur <jkacur@redhat.com>,
        Steven Rostedt <rostedt@goodmis.org>, linux-rt-users@vger.kernel.org
Subject: Re: [PATCH 4/4] futex: convert hash_bucket locks to raw_spinlock_t
References: <1278714780-788-1-git-send-email-dvhltc@us.ibm.com> <1278714780-788-5-git-send-email-dvhltc@us.ibm.com> <1278790882.7352.101.camel@marge.simson.net> <1278855208.15197.6.camel@marge.simson.net>
In-Reply-To: <1278855208.15197.6.camel@marge.simson.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/11/2010 06:33 AM, Mike Galbraith wrote:
> On Sat, 2010-07-10 at 21:41 +0200, Mike Galbraith wrote:
>> On Fri, 2010-07-09 at 15:33 -0700, Darren Hart wrote:
>
>>> If we can't move the unlock above before set_owner, then we may need a:
>>>
>>> retry:
>>> cur->lock()
>>> top_waiter = get_top_waiter()
>>> cur->unlock()
>>>
>>> double_lock(cur, topwaiter)
>>> if top_waiter != get_top_waiter()
>>> 	double_unlock(cur, topwaiter)
>>> 	goto retry
>>>
>>> Not ideal, but I think I prefer that to making all the hb locks raw.
>
> Another option: only scratch the itchy spot.
>
> futex: non-blocking synchronization point for futex_wait_requeue_pi() and futex_requeue().
>
> Problem analysis by Darren Hart;
> The requeue_pi mechanism introduced proxy locking of the rtmutex.  This creates
> a scenario where a task can wake-up, not knowing it has been enqueued on an
> rtmutex. In order to detect this, the task would have to be able to take either
> task->pi_blocked_on->lock->wait_lock and/or the hb->lock.  Unfortunately,
> without already holding one of these, the pi_blocked_on variable can change
> from NULL to valid or from valid to NULL. Therefor, the task cannot be allowed
> to take a sleeping lock after wakeup or it could end up trying to block on two
> locks, the second overwriting a valid pi_blocked_on value. This obviously
> breaks the pi mechanism.
>
> Rather than convert the bh-lock to a raw spinlock, do so only in the spot where
> blocking cannot be allowed, ie before we know that lock handoff has completed.

I like it. I especially like the change is only evident if you are using 
the code path that introduced the problem in the first place. If you're 
doing a lot of requeue_pi operations, then the waking waiters have an 
advantage over new pending waiters or other tasks with futex keyed on 
the same hash-bucket... but that seems acceptable to me.

I'd like to confirm that holding the pendowner->pi-lock across the 
wakeup in wakeup_next_waiter() isn't feasible first. If it can work, I 
think the impact would be lower. I'll have a look tomorrow.

Nice work Mike.

--
Darrem

> Signed-off-by: Mike Galbraith<efault@gmx.de>
> Cc: Darren Hart<dvhltc@us.ibm.com>
> Cc: Thomas Gleixner<tglx@linutronix.de>
> Cc: Peter Zijlstra<peterz@infradead.org>
> Cc: Ingo Molnar<mingo@elte.hu>
> Cc: Eric Dumazet<eric.dumazet@gmail.com>
> Cc: John Kacur<jkacur@redhat.com>
> Cc: Steven Rostedt<rostedt@goodmis.org>
>
> diff --git a/kernel/futex.c b/kernel/futex.c
> index a6cec32..ef489f3 100644
> --- a/kernel/futex.c
> +++ b/kernel/futex.c
> @@ -2255,7 +2255,14 @@ static int futex_wait_requeue_pi(u32 __user *uaddr, int fshared,
>   	/* Queue the futex_q, drop the hb lock, wait for wakeup. */
>   	futex_wait_queue_me(hb,&q, to);
>
> -	spin_lock(&hb->lock);
> +	/*
> +	 * Non-blocking synchronization point with futex_requeue().
> +	 *
> +	 * We dare not block here because this will alter PI state, possibly
> +	 * before our waker finishes modifying same in wakeup_next_waiter().
> +	 */
> +	while(!spin_trylock(&hb->lock))
> +		cpu_relax();
>   	ret = handle_early_requeue_pi_wakeup(hb,&q,&key2, to);
>   	spin_unlock(&hb->lock);
>   	if (ret)
>
>


-- 
Darren Hart
IBM Linux Technology Center
Real-Time Linux Team
