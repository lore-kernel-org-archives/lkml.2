Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755853Ab2IBCNV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Sep 2012 22:13:21 -0400
Received: from relay3-d.mail.gandi.net ([217.70.183.195]:56376 "EHLO
	relay3-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754662Ab2IBCNU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Sep 2012 22:13:20 -0400
X-Originating-IP: 217.70.178.148
X-Originating-IP: 50.43.46.74
Date: Sat, 1 Sep 2012 19:13:12 -0700
From: Josh Triplett <josh@joshtriplett.org>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@polymtl.ca, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        fweisbec@gmail.com, sbw@mit.edu, patches@linaro.org,
        "Paul E. McKenney" <paul.mckenney@linaro.org>
Subject: Re: [PATCH tip/core/rcu 07/23] rcu: Provide OOM handler to motivate
 lazy RCU callbacks
Message-ID: <20120902021312.GG5713@leaf>
References: <20120830181811.GA29154@linux.vnet.ibm.com>
 <1346350718-30937-1-git-send-email-paulmck@linux.vnet.ibm.com>
 <1346350718-30937-7-git-send-email-paulmck@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1346350718-30937-7-git-send-email-paulmck@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 30, 2012 at 11:18:22AM -0700, Paul E. McKenney wrote:
> From: "Paul E. McKenney" <paul.mckenney@linaro.org>
> 
> In kernels built with CONFIG_RCU_FAST_NO_HZ=y, CPUs can accumulate a
> large number of lazy callbacks, which as the name implies will be slow
> to be invoked.  This can be a problem on small-memory systems, where the
> default 6-second sleep for CPUs having only lazy RCU callbacks could well
> be fatal.  This commit therefore installs an OOM hander that ensures that
> every CPU with non-lazy callbacks has at least one non-lazy callback,
> in turn ensuring timely advancement for these callbacks.

Did you mean "every CPU with lazy callbacks" here?

> Signed-off-by: Paul E. McKenney <paul.mckenney@linaro.org>
> Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> Tested-by: Sasha Levin <levinsasha928@gmail.com>

Reviewed-by: Josh Triplett <josh@joshtriplett.org>

>  kernel/rcutree.h        |    5 ++-
>  kernel/rcutree_plugin.h |   80 +++++++++++++++++++++++++++++++++++++++++++++++
>  2 files changed, 84 insertions(+), 1 deletions(-)
> 
> diff --git a/kernel/rcutree.h b/kernel/rcutree.h
> index 117a150..effb273 100644
> --- a/kernel/rcutree.h
> +++ b/kernel/rcutree.h
> @@ -315,8 +315,11 @@ struct rcu_data {
>  	unsigned long n_rp_need_fqs;
>  	unsigned long n_rp_need_nothing;
>  
> -	/* 6) _rcu_barrier() callback. */
> +	/* 6) _rcu_barrier() and OOM callbacks. */
>  	struct rcu_head barrier_head;
> +#ifdef CONFIG_RCU_FAST_NO_HZ
> +	struct rcu_head oom_head;
> +#endif /* #ifdef CONFIG_RCU_FAST_NO_HZ */
>  
>  	int cpu;
>  	struct rcu_state *rsp;
> diff --git a/kernel/rcutree_plugin.h b/kernel/rcutree_plugin.h
> index 7f3244c..bac8cc1 100644
> --- a/kernel/rcutree_plugin.h
> +++ b/kernel/rcutree_plugin.h
> @@ -25,6 +25,7 @@
>   */
>  
>  #include <linux/delay.h>
> +#include <linux/oom.h>
>  
>  #define RCU_KTHREAD_PRIO 1
>  
> @@ -2112,6 +2113,85 @@ static void rcu_idle_count_callbacks_posted(void)
>  	__this_cpu_add(rcu_dynticks.nonlazy_posted, 1);
>  }
>  
> +/*
> + * Data for flushing lazy RCU callbacks at OOM time.
> + */
> +static atomic_t oom_callback_count;
> +static DECLARE_WAIT_QUEUE_HEAD(oom_callback_wq);
> +
> +/*
> + * RCU OOM callback -- decrement the outstanding count and deliver the
> + * wake-up if we are the last one.
> + */
> +static void rcu_oom_callback(struct rcu_head *rhp)
> +{
> +	if (atomic_dec_and_test(&oom_callback_count))
> +		wake_up(&oom_callback_wq);
> +}
> +
> +/*
> + * Post an rcu_oom_notify callback on the current CPU if it has at
> + * least one lazy callback.  This will unnecessarily post callbacks
> + * to CPUs that already have a non-lazy callback at the end of their
> + * callback list, but this is an infrequent operation, so accept some
> + * extra overhead to keep things simple.
> + */
> +static void rcu_oom_notify_cpu(void *flavor)
> +{
> +	struct rcu_state *rsp = flavor;
> +	struct rcu_data *rdp = __this_cpu_ptr(rsp->rda);
> +
> +	if (rdp->qlen_lazy != 0) {
> +		atomic_inc(&oom_callback_count);
> +		rsp->call(&rdp->oom_head, rcu_oom_callback);
> +	}
> +}
> +
> +/*
> + * If low on memory, ensure that each CPU has a non-lazy callback.
> + * This will wake up CPUs that have only lazy callbacks, in turn
> + * ensuring that they free up the corresponding memory in a timely manner.
> + */
> +static int rcu_oom_notify(struct notifier_block *self,
> +			  unsigned long notused, void *nfreed)
> +{
> +	int cpu;
> +	struct rcu_state *rsp;
> +
> +	/* Wait for callbacks from earlier instance to complete. */
> +	wait_event(oom_callback_wq, atomic_read(&oom_callback_count) == 0);
> +
> +	/*
> +	 * Prevent premature wakeup: ensure that all increments happen
> +	 * before there is a chance of the counter reaching zero.
> +	 */
> +	atomic_set(&oom_callback_count, 1);
> +
> +	get_online_cpus();
> +	for_each_online_cpu(cpu)
> +		for_each_rcu_flavor(rsp)
> +			smp_call_function_single(cpu, rcu_oom_notify_cpu,
> +						 rsp, 1);
> +	put_online_cpus();
> +
> +	/* Unconditionally decrement: no need to wake ourselves up. */
> +	atomic_dec(&oom_callback_count);
> +
> +	*(unsigned long *)nfreed = 1;
> +	return NOTIFY_OK;
> +}
> +
> +static struct notifier_block rcu_oom_nb = {
> +	.notifier_call = rcu_oom_notify
> +};
> +
> +static int __init rcu_register_oom_notifier(void)
> +{
> +	register_oom_notifier(&rcu_oom_nb);
> +	return 0;
> +}
> +early_initcall(rcu_register_oom_notifier);
> +
>  #endif /* #else #if !defined(CONFIG_RCU_FAST_NO_HZ) */
>  
>  #ifdef CONFIG_RCU_CPU_STALL_INFO
> -- 
> 1.7.8
> 
