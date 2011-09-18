Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751205Ab1IREJk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Sep 2011 00:09:40 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:36518 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750753Ab1IREJj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Sep 2011 00:09:39 -0400
Date: Sun, 18 Sep 2011 12:09:23 +0800
From: Yong Zhang <yong.zhang0@gmail.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@polymtl.ca, josh@joshtriplett.org, niv@us.ibm.com,
        tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
        Valdis.Kletnieks@vt.edu, dhowells@redhat.com, eric.dumazet@gmail.com,
        darren@dvhart.com, patches@linaro.org,
        "Paul E. McKenney" <paul.mckenney@linaro.org>
Subject: Re: [PATCH tip/core/rcu 41/55] rcu: Permit rt_mutex_unlock() with
 irqs disabled
Message-ID: <20110918040923.GA2363@zhy>
Reply-To: Yong Zhang <yong.zhang0@gmail.com>
References: <20110906180015.GA2560@linux.vnet.ibm.com>
 <1315332049-2604-41-git-send-email-paulmck@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1315332049-2604-41-git-send-email-paulmck@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 06, 2011 at 11:00:35AM -0700, Paul E. McKenney wrote:
> From: Paul E. McKenney <paul.mckenney@linaro.org>
> 
> Create a separate lockdep class for the rt_mutex used for RCU priority
> boosting and enable use of rt_mutex_lock() with irqs disabled.  This
> prevents RCU priority boosting from falling prey to deadlocks when
> someone begins an RCU read-side critical section in preemptible state,
> but releases it with an irq-disabled lock held.
> 
> Unfortunately, the scheduler's runqueue and priority-inheritance locks
> still must either completely enclose or be completely enclosed by any
> overlapping RCU read-side critical section.
> 
> Signed-off-by: Paul E. McKenney <paul.mckenney@linaro.org>
> Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> ---
>  kernel/rcutree_plugin.h |    6 ++++++
>  kernel/rtmutex.c        |    8 ++++++++
>  2 files changed, 14 insertions(+), 0 deletions(-)
> 
> diff --git a/kernel/rcutree_plugin.h b/kernel/rcutree_plugin.h
> index d3127e8..f6c63ea 100644
> --- a/kernel/rcutree_plugin.h
> +++ b/kernel/rcutree_plugin.h
> @@ -1149,6 +1149,8 @@ static void rcu_initiate_boost_trace(struct rcu_node *rnp)
>  
>  #endif /* #else #ifdef CONFIG_RCU_TRACE */
>  
> +static struct lock_class_key rcu_boost_class;
> +
>  /*
>   * Carry out RCU priority boosting on the task indicated by ->exp_tasks
>   * or ->boost_tasks, advancing the pointer to the next task in the
> @@ -1211,10 +1213,14 @@ static int rcu_boost(struct rcu_node *rnp)
>  	 */
>  	t = container_of(tb, struct task_struct, rcu_node_entry);
>  	rt_mutex_init_proxy_locked(&mtx, t);
> +	/* Avoid lockdep false positives.  This rt_mutex is its own thing. */
> +	lockdep_set_class_and_name(&mtx.wait_lock, &rcu_boost_class,
> +				   "rcu_boost_mutex");
>  	t->rcu_boost_mutex = &mtx;

  	raw_spin_unlock_irqrestore(&rnp->lock, flags);  <====A

>  	rt_mutex_lock(&mtx);  /* Side effect: boosts task t's priority. */
>  	rt_mutex_unlock(&mtx);  /* Keep lockdep happy. */
> +	local_irq_restore(flags);

Does it help here?
irq is enabled at A. So we still call rt_mutex_lock() with irq enabled.

Seems should s/raw_spin_unlock_irqrestore/raw_spin_unlock ?

BTW, since we are in process context, 'flags' is not needed to save,
no?

Thanks,
Yong


>  
>  	return rnp->exp_tasks != NULL || rnp->boost_tasks != NULL;
>  }
> diff --git a/kernel/rtmutex.c b/kernel/rtmutex.c
> index ab44911..2548f44 100644
> --- a/kernel/rtmutex.c
> +++ b/kernel/rtmutex.c
> @@ -579,6 +579,7 @@ __rt_mutex_slowlock(struct rt_mutex *lock, int state,
>  		    struct rt_mutex_waiter *waiter)
>  {
>  	int ret = 0;
> +	int was_disabled;
>  
>  	for (;;) {
>  		/* Try to acquire the lock: */
> @@ -601,10 +602,17 @@ __rt_mutex_slowlock(struct rt_mutex *lock, int state,
>  
>  		raw_spin_unlock(&lock->wait_lock);
>  
> +		was_disabled = irqs_disabled();
> +		if (was_disabled)
> +			local_irq_enable();
> +
>  		debug_rt_mutex_print_deadlock(waiter);
>  
>  		schedule_rt_mutex(lock);
>  
> +		if (was_disabled)
> +			local_irq_disable();
> +
>  		raw_spin_lock(&lock->wait_lock);
>  		set_current_state(state);
>  	}
> -- 
> 1.7.3.2
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
