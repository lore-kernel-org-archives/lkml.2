Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754339Ab1FHM67 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jun 2011 08:58:59 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:62205 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753220Ab1FHM65 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jun 2011 08:58:57 -0400
X-Authority-Analysis: v=1.1 cv=5asQ6euaRPJxDdFxwvXsn6JDb7fmFbz8qWDLMfa45gU= c=1 sm=0 a=XYJHFtupD_QA:10 a=ZvcZoPE4s-wA:10 a=5SG0PmZfjMsA:10 a=kj9zAlcOel0A:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=pGLkceISAAAA:8 a=VwQbUJbxAAAA:8 a=W0vUJOdyAAAA:8 a=_7W7YLPc3uET5Bux7bgA:9 a=sJFxa5VS3gcwFNBiWkQA:7 a=CjuIK1q_8ugA:10 a=x8gzFH9gYPwA:10 a=MSl-tDqOz04A:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Date: Wed, 8 Jun 2011 08:58:55 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Hillf Danton <dhillf@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH] sched: remove unreliable pointer in
 mutex_spin_on_owner()
Message-ID: <20110608125855.GE27245@home.goodmis.org>
References: <BANLkTim9cr6H9fTik8-yQ4E0j1yFAOt-7g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BANLkTim9cr6H9fTik8-yQ4E0j1yFAOt-7g@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 08, 2011 at 08:49:53PM +0800, Hillf Danton wrote:
> The dereference of unreliable owner pointer is unnecessary in owner_running(),
> though under RCU protection, because the true result is only determined by
> checking the validity of lock owner, as the comment says, due to likely heavy
> lock contention, which has little to do with whether owner->on_cpu is false.
> 
> If owner->on_cpu is really false, only the owner_running loop is shortened,
> but also returns incorrect result, since the lock owner is not changed, though
> maybe changed soon.
> 

Hillf, have you read anything that I posted before?

We don't want to spin if the owner of the lock sleeps. If it sleeps,
then the owner's on_cpu will be zero. That's the point of checking it.

The patch you just added would devastate the performance of the system.
Now if we have contention on a lock, and the owner sleeps, we continue
to spin. If the spinner is an RT task, this could also cause a deadlock,
especially if the owner is bound to the same CPU that the RT task is on.

-- Steve


> Signed-off-by: Hillf Danton <dhillf@gmail.com>
> ---
>  kernel/sched.c |   36 +-----------------------------------
>  1 files changed, 1 insertions(+), 35 deletions(-)
> 
> diff --git a/kernel/sched.c b/kernel/sched.c
> index fd18f39..2c32616 100644
> --- a/kernel/sched.c
> +++ b/kernel/sched.c
> @@ -4293,52 +4293,18 @@ EXPORT_SYMBOL(schedule);
> 
>  #ifdef CONFIG_MUTEX_SPIN_ON_OWNER
> 
> -static inline bool owner_running(struct mutex *lock, struct task_struct *owner)
> -{
> -	bool ret = false;
> -
> -	rcu_read_lock();
> -	if (lock->owner != owner)
> -		goto fail;
> -
> -	/*
> -	 * Ensure we emit the owner->on_cpu, dereference _after_ checking
> -	 * lock->owner still matches owner, if that fails, owner might
> -	 * point to free()d memory, if it still matches, the rcu_read_lock()
> -	 * ensures the memory stays valid.
> -	 */
> -	barrier();
> -
> -	ret = owner->on_cpu;
> -fail:
> -	rcu_read_unlock();
> -
> -	return ret;
> -}
> -
> -/*
> - * Look out! "owner" is an entirely speculative pointer
> - * access and not reliable.
> - */
>  int mutex_spin_on_owner(struct mutex *lock, struct task_struct *owner)
>  {
>  	if (!sched_feat(OWNER_SPIN))
>  		return 0;
> 
> -	while (owner_running(lock, owner)) {
> +	while (lock->owner != NULL) {
>  		if (need_resched())
>  			return 0;
> 
>  		arch_mutex_cpu_relax();
>  	}
> 
> -	/*
> -	 * If the owner changed to another task there is likely
> -	 * heavy contention, stop spinning.
> -	 */
> -	if (lock->owner)
> -		return 0;
> -
>  	return 1;
>  }
>  #endif
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
