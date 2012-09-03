Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756169Ab2ICJGq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Sep 2012 05:06:46 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:23169 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1755676Ab2ICJGo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Sep 2012 05:06:44 -0400
X-IronPort-AV: E=Sophos;i="4.80,359,1344182400"; 
   d="scan'208";a="5773560"
Message-ID: <50447388.4080609@cn.fujitsu.com>
Date: Mon, 03 Sep 2012 17:08:24 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc14 Thunderbird/3.1.4
MIME-Version: 1.0
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
CC: linux-kernel@vger.kernel.org, mingo@elte.hu, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        fweisbec@gmail.com, sbw@mit.edu, patches@linaro.org,
        "Paul E. McKenney" <paul.mckenney@linaro.org>,
        David Rientjes <rientjes@google.com>
Subject: Re: [PATCH tip/core/rcu 07/23] rcu: Provide OOM handler to motivate
 lazy RCU callbacks
References: <20120830181811.GA29154@linux.vnet.ibm.com> <1346350718-30937-1-git-send-email-paulmck@linux.vnet.ibm.com> <1346350718-30937-7-git-send-email-paulmck@linux.vnet.ibm.com>
In-Reply-To: <1346350718-30937-7-git-send-email-paulmck@linux.vnet.ibm.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/09/03 17:06:19,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/09/03 17:06:22,
	Serialize complete at 2012/09/03 17:06:22
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/31/2012 02:18 AM, Paul E. McKenney wrote:
> From: "Paul E. McKenney" <paul.mckenney@linaro.org>
> 
> In kernels built with CONFIG_RCU_FAST_NO_HZ=y, CPUs can accumulate a
> large number of lazy callbacks, which as the name implies will be slow
> to be invoked.  This can be a problem on small-memory systems, where the
> default 6-second sleep for CPUs having only lazy RCU callbacks could well
> be fatal.  This commit therefore installs an OOM hander that ensures that
> every CPU with non-lazy callbacks has at least one non-lazy callback,
> in turn ensuring timely advancement for these callbacks.
> 
> Signed-off-by: Paul E. McKenney <paul.mckenney@linaro.org>
> Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> Tested-by: Sasha Levin <levinsasha928@gmail.com>
> ---
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

Hi, Paul

If you consider the above code has free some memory,
you should use *(unsigned long *)nfreed = +1.
                                          ^^

And your code disable OOM actually, because it transfer *nfreed to NON-ZERO
unconditionally.

I did not review the patch nor the whole series carefully.

And if it is possible, could you share the code with rcu_barrier()?

Thanks,
Lai

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

