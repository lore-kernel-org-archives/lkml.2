Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755293Ab0JTTP0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Oct 2010 15:15:26 -0400
Received: from e2.ny.us.ibm.com ([32.97.182.142]:39441 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753415Ab0JTTPZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Oct 2010 15:15:25 -0400
Date: Wed, 20 Oct 2010 12:15:12 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2 v2] rcu,cleanup: move synchronize_sched_expedited()
 out of sched.c
Message-ID: <20101020191512.GG2386@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <4CBE886A.7010509@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4CBE886A.7010509@cn.fujitsu.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 20, 2010 at 02:12:58PM +0800, Lai Jiangshan wrote:
> The first version of synchronize_sched_expedited() use the migration code
> of the scheduler code, so it have to be implemented in sched.c
> 
> but now, the synchronize_sched_expedited() does not use such code,
> it is time to move it out of sched.c.
> 
> Different rcu implementation' synchronize_sched_expedited() are also
> different. so we move synchronize_sched_expedited() to kernel/rcutree_plugin.h
> or include/linux/rcutiny.h instead of kerenl/rcupdate.c

Queued, thank you!!!

							Thanx, Paul

> Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
> ---
> include/linux/rcupdate.h |    1 
>  include/linux/rcutiny.h  |    5 +++
>  include/linux/rcutree.h  |    1 
>  kernel/rcutree_plugin.h  |   71 +++++++++++++++++++++++++++++++++++++++++++++++
>  kernel/sched.c           |   69 ---------------------------------------------
>  5 files changed, 77 insertions(+), 70 deletions(-)
> diff --git a/include/linux/rcupdate.h b/include/linux/rcupdate.h
> index 0d0b640..ead36da 100644
> --- a/include/linux/rcupdate.h
> +++ b/include/linux/rcupdate.h
> @@ -66,7 +66,6 @@ extern void call_rcu_sched(struct rcu_head *head,
>  extern void synchronize_sched(void);
>  extern void rcu_barrier_bh(void);
>  extern void rcu_barrier_sched(void);
> -extern void synchronize_sched_expedited(void);
>  extern int sched_expedited_torture_stats(char *page);
> 
>  static inline void __rcu_read_lock_bh(void)
> diff --git a/include/linux/rcutiny.h b/include/linux/rcutiny.h
> index 13877cb..4d84452 100644
> --- a/include/linux/rcutiny.h
> +++ b/include/linux/rcutiny.h
> @@ -58,6 +58,11 @@ static inline void synchronize_rcu_bh_expedited(void)
>  	synchronize_sched();
>  }
> 
> +static inline void synchronize_sched_expedited(void)
> +{
> +	synchronize_sched();
> +}
> +
>  #ifdef CONFIG_TINY_RCU
> 
>  static inline void rcu_preempt_note_context_switch(void)
> diff --git a/include/linux/rcutree.h b/include/linux/rcutree.h
> index 95518e6..9a1fd6c 100644
> --- a/include/linux/rcutree.h
> +++ b/include/linux/rcutree.h
> @@ -47,6 +47,7 @@ static inline void exit_rcu(void)
>  #endif /* #else #ifdef CONFIG_TREE_PREEMPT_RCU */
> 
>  extern void synchronize_rcu_bh(void);
> +extern void synchronize_sched_expedited(void);
>  extern void synchronize_rcu_expedited(void);
> 
>  static inline void synchronize_rcu_bh_expedited(void)
> diff --git a/kernel/rcutree_plugin.h b/kernel/rcutree_plugin.h
> index 0e75d60..1f4cb21 100644
> --- a/kernel/rcutree_plugin.h
> +++ b/kernel/rcutree_plugin.h
> @@ -25,6 +25,7 @@
>   */
> 
>  #include <linux/delay.h>
> +#include <linux/stop_machine.h>
> 
>  /*
>   * Check the RCU kernel configuration parameters and print informative
> @@ -581,6 +582,76 @@ void synchronize_rcu(void)
>  }
>  EXPORT_SYMBOL_GPL(synchronize_rcu);
> 
> +#ifndef CONFIG_SMP
> +
> +void synchronize_sched_expedited(void)
> +{
> +	cond_resched();
> +}
> +EXPORT_SYMBOL_GPL(synchronize_sched_expedited);
> +
> +#else /* #ifndef CONFIG_SMP */
> +
> +static atomic_t synchronize_sched_expedited_count = ATOMIC_INIT(0);
> +
> +static int synchronize_sched_expedited_cpu_stop(void *data)
> +{
> +	/*
> +	 * There must be a full memory barrier on each affected CPU
> +	 * between the time that try_stop_cpus() is called and the
> +	 * time that it returns.
> +	 *
> +	 * In the current initial implementation of cpu_stop, the
> +	 * above condition is already met when the control reaches
> +	 * this point and the following smp_mb() is not strictly
> +	 * necessary.  Do smp_mb() anyway for documentation and
> +	 * robustness against future implementation changes.
> +	 */
> +	smp_mb(); /* See above comment block. */
> +	return 0;
> +}
> +
> +/*
> + * Wait for an rcu-sched grace period to elapse, but use "big hammer"
> + * approach to force grace period to end quickly.  This consumes
> + * significant time on all CPUs, and is thus not recommended for
> + * any sort of common-case code.
> + *
> + * Note that it is illegal to call this function while holding any
> + * lock that is acquired by a CPU-hotplug notifier.  Failing to
> + * observe this restriction will result in deadlock.
> + */
> +void synchronize_sched_expedited(void)
> +{
> +	int snap, trycount = 0;
> +
> +	smp_mb();  /* ensure prior mod happens before capturing snap. */
> +	snap = atomic_read(&synchronize_sched_expedited_count) + 1;
> +	get_online_cpus();
> +	while (try_stop_cpus(cpu_online_mask,
> +			     synchronize_sched_expedited_cpu_stop,
> +			     NULL) == -EAGAIN) {
> +		put_online_cpus();
> +		if (trycount++ < 10)
> +			udelay(trycount * num_online_cpus());
> +		else {
> +			synchronize_sched();
> +			return;
> +		}
> +		if (atomic_read(&synchronize_sched_expedited_count) - snap > 0) {
> +			smp_mb(); /* ensure test happens before caller kfree */
> +			return;
> +		}
> +		get_online_cpus();
> +	}
> +	atomic_inc(&synchronize_sched_expedited_count);
> +	smp_mb__after_atomic_inc(); /* ensure post-GP actions seen after GP. */
> +	put_online_cpus();
> +}
> +EXPORT_SYMBOL_GPL(synchronize_sched_expedited);
> +
> +#endif /* #else #ifndef CONFIG_SMP */
> +
>  static DECLARE_WAIT_QUEUE_HEAD(sync_rcu_preempt_exp_wq);
>  static long sync_rcu_preempt_exp_count;
>  static DEFINE_MUTEX(sync_rcu_preempt_exp_mutex);
> diff --git a/kernel/sched.c b/kernel/sched.c
> index abf8440..9dc7775 100644
> --- a/kernel/sched.c
> +++ b/kernel/sched.c
> @@ -9332,72 +9332,3 @@ struct cgroup_subsys cpuacct_subsys = {
>  };
>  #endif	/* CONFIG_CGROUP_CPUACCT */
> 
> -#ifndef CONFIG_SMP
> -
> -void synchronize_sched_expedited(void)
> -{
> -	barrier();
> -}
> -EXPORT_SYMBOL_GPL(synchronize_sched_expedited);
> -
> -#else /* #ifndef CONFIG_SMP */
> -
> -static atomic_t synchronize_sched_expedited_count = ATOMIC_INIT(0);
> -
> -static int synchronize_sched_expedited_cpu_stop(void *data)
> -{
> -	/*
> -	 * There must be a full memory barrier on each affected CPU
> -	 * between the time that try_stop_cpus() is called and the
> -	 * time that it returns.
> -	 *
> -	 * In the current initial implementation of cpu_stop, the
> -	 * above condition is already met when the control reaches
> -	 * this point and the following smp_mb() is not strictly
> -	 * necessary.  Do smp_mb() anyway for documentation and
> -	 * robustness against future implementation changes.
> -	 */
> -	smp_mb(); /* See above comment block. */
> -	return 0;
> -}
> -
> -/*
> - * Wait for an rcu-sched grace period to elapse, but use "big hammer"
> - * approach to force grace period to end quickly.  This consumes
> - * significant time on all CPUs, and is thus not recommended for
> - * any sort of common-case code.
> - *
> - * Note that it is illegal to call this function while holding any
> - * lock that is acquired by a CPU-hotplug notifier.  Failing to
> - * observe this restriction will result in deadlock.
> - */
> -void synchronize_sched_expedited(void)
> -{
> -	int snap, trycount = 0;
> -
> -	smp_mb();  /* ensure prior mod happens before capturing snap. */
> -	snap = atomic_read(&synchronize_sched_expedited_count) + 1;
> -	get_online_cpus();
> -	while (try_stop_cpus(cpu_online_mask,
> -			     synchronize_sched_expedited_cpu_stop,
> -			     NULL) == -EAGAIN) {
> -		put_online_cpus();
> -		if (trycount++ < 10)
> -			udelay(trycount * num_online_cpus());
> -		else {
> -			synchronize_sched();
> -			return;
> -		}
> -		if (atomic_read(&synchronize_sched_expedited_count) - snap > 0) {
> -			smp_mb(); /* ensure test happens before caller kfree */
> -			return;
> -		}
> -		get_online_cpus();
> -	}
> -	atomic_inc(&synchronize_sched_expedited_count);
> -	smp_mb__after_atomic_inc(); /* ensure post-GP actions seen after GP. */
> -	put_online_cpus();
> -}
> -EXPORT_SYMBOL_GPL(synchronize_sched_expedited);
> -
> -#endif /* #else #ifndef CONFIG_SMP */
