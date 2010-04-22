Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757034Ab0DVVZv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Apr 2010 17:25:51 -0400
Received: from e5.ny.us.ibm.com ([32.97.182.145]:39980 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756696Ab0DVVZs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Apr 2010 17:25:48 -0400
Date: Thu, 22 Apr 2010 14:25:43 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
       dipankar@in.ibm.com, akpm@linux-foundation.org,
       mathieu.desnoyers@polymtl.ca, josh@joshtriplett.org, dvhltc@us.ibm.com,
       niv@us.ibm.com, tglx@linutronix.de, rostedt@goodmis.org,
       Valdis.Kletnieks@vt.edu, dhowells@redhat.com, eric.dumazet@gmail.com
Subject: Re: [PATCH tip/core/urgent 3/3] sched: protect
 __sched_setscheduler() access to cgroups
Message-ID: <20100422212543.GO2524@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20100422195345.GA9639@linux.vnet.ibm.com>
 <1271966047-9701-3-git-send-email-paulmck@linux.vnet.ibm.com>
 <1271968398.1646.16.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1271968398.1646.16.camel@laptop>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 22, 2010 at 10:33:18PM +0200, Peter Zijlstra wrote:
> On Thu, 2010-04-22 at 12:54 -0700, Paul E. McKenney wrote:
> > A given task's cgroups structures must remain while that task is running
> > due to reference counting, so this is presumably a false positive.
> > Updated to reflect feedback from Tetsuo Handa.
> 
> I think its not a false positive, I think we can race with the task
> being placed in another cgroup. We don't hold task_lock() [our other
> discussion] nor does it hold rq->lock [used by the sched ->attach()
> method].

Ah, I am dropping this patch then.

Ingo, please accept my apologies for the confusion submitting it too soon!

							Thanx, Paul

> That said, we should probably cure the race condition of
> sched_setscheduler() vs ->attach().
> 
> Something like the below perhaps?
> 
> Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
> ---
>  kernel/sched.c |   38 ++++++++++++++++++++++++++------------
>  1 files changed, 26 insertions(+), 12 deletions(-)
> 
> diff --git a/kernel/sched.c b/kernel/sched.c
> index 95eaecc..345df67 100644
> --- a/kernel/sched.c
> +++ b/kernel/sched.c
> @@ -4425,16 +4425,6 @@ recheck:
>  	}
> 
>  	if (user) {
> -#ifdef CONFIG_RT_GROUP_SCHED
> -		/*
> -		 * Do not allow realtime tasks into groups that have no runtime
> -		 * assigned.
> -		 */
> -		if (rt_bandwidth_enabled() && rt_policy(policy) &&
> -				task_group(p)->rt_bandwidth.rt_runtime == 0)
> -			return -EPERM;
> -#endif
> -
>  		retval = security_task_setscheduler(p, policy, param);
>  		if (retval)
>  			return retval;
> @@ -4450,6 +4440,28 @@ recheck:
>  	 * runqueue lock must be held.
>  	 */
>  	rq = __task_rq_lock(p);
> +	retval = 0;
> +#ifdef CONFIG_RT_GROUP_SCHED
> +	if (user) {
> +		/*
> +		 * Do not allow realtime tasks into groups that have no runtime
> +		 * assigned.
> +		 *
> +		 * RCU read lock not strictly required but here for PROVE_RCU,
> +		 * the task is pinned by holding rq->lock which avoids races
> +		 * with ->attach().
> +		 */
> +		rcu_read_lock();
> +		if (rt_bandwidth_enabled() && rt_policy(policy) &&
> +				task_group(p)->rt_bandwidth.rt_runtime == 0)
> +			retval = -EPERM;
> +		rcu_read_unlock();
> +
> +		if (retval)
> +			goto unlock;
> +	}
> +#endif
> +
>  	/* recheck policy now with rq lock held */
>  	if (unlikely(oldpolicy != -1 && oldpolicy != p->policy)) {
>  		policy = oldpolicy = -1;
> @@ -4477,12 +4489,14 @@ recheck:
> 
>  		check_class_changed(rq, p, prev_class, oldprio, running);
>  	}
> +unlock:
>  	__task_rq_unlock(rq);
>  	raw_spin_unlock_irqrestore(&p->pi_lock, flags);
> 
> -	rt_mutex_adjust_pi(p);
> +	if (!retval)
> +		rt_mutex_adjust_pi(p);
> 
> -	return 0;
> +	return retval;
>  }
> 
>  /**
> 
> 
