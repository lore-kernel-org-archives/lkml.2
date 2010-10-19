Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756589Ab0JSRGv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Oct 2010 13:06:51 -0400
Received: from e7.ny.us.ibm.com ([32.97.182.137]:33126 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756546Ab0JSRGs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Oct 2010 13:06:48 -0400
Date: Tue, 19 Oct 2010 10:06:45 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] rcu,cleanup: move synchronize_sched_expedited()
 out of sched.c
Message-ID: <20101019170645.GB2362@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <4CBD4F48.9070804@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4CBD4F48.9070804@cn.fujitsu.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 19, 2010 at 03:56:56PM +0800, Lai Jiangshan wrote:
> 
> The first version of synchronize_sched_expedited() use the migration code
> of the scheduler code, so it have to be implemented in sched.c
> 
> but now, the synchronize_sched_expedited() does not use such code,
> it is time to move it out of sched.c.
> 
> Different rcu implementation' synchronize_sched_expedited() are also
> different. so we move synchronize_sched_expedited() to kernel/rcu{tree,tiny}_plugin.h
> instead of kerenl/rcupdate.c

Good stuff, Lai!!!

Please see below for one small but important comment.

							Thanx, Paul

> Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
> ---
>  rcutiny_plugin.h |    6 ++++
>  rcutree_plugin.h |   71 +++++++++++++++++++++++++++++++++++++++++++++++++++++++
>  sched.c          |   69 -----------------------------------------------------
>  3 files changed, 77 insertions(+), 69 deletions(-)
> diff --git a/kernel/rcutiny_plugin.h b/kernel/rcutiny_plugin.h
> index 6ceca4f..87e226c 100644
> --- a/kernel/rcutiny_plugin.h
> +++ b/kernel/rcutiny_plugin.h
> @@ -461,6 +461,12 @@ void synchronize_rcu(void)
>  }
>  EXPORT_SYMBOL_GPL(synchronize_rcu);
> 
> +void synchronize_sched_expedited(void)
> +{
> +	barrier();
> +}
> +EXPORT_SYMBOL_GPL(synchronize_sched_expedited);
> +

It would be better to put this in include/linux/rcutiny.h under
#ifdef CONFIG_TINY_PREEMPT_RCU.  The reason is that this would
allow the EXPORT_SYMBOL_GPL() to be dropped, saving significant
memory, at least from a TINY_RCU viewpoint.  Could you please
resubmit with this change?

(The reason we don't do the same for synchronize_sched() is that
it needs cond_resched() in the CONFIG_TINY_RCU case.)

>  static DECLARE_WAIT_QUEUE_HEAD(sync_rcu_preempt_exp_wq);
>  static unsigned long sync_rcu_preempt_exp_count;
>  static DEFINE_MUTEX(sync_rcu_preempt_exp_mutex);
> diff --git a/kernel/rcutree_plugin.h b/kernel/rcutree_plugin.h
> index 71a4147..9e62b01 100644
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
> +	barrier();
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
