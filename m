Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757661Ab0JUQQh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Oct 2010 12:16:37 -0400
Received: from e4.ny.us.ibm.com ([32.97.182.144]:56857 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751479Ab0JUQQg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Oct 2010 12:16:36 -0400
Date: Thu, 21 Oct 2010 09:16:27 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2 v2] rcu,cleanup: move synchronize_sched_expedited()
 out of sched.c
Message-ID: <20101021161627.GA8004@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <4CBE886A.7010509@cn.fujitsu.com>
 <20101020191512.GG2386@linux.vnet.ibm.com>
 <20101021001928.GA24855@linux.vnet.ibm.com>
 <4CBFB381.50601@cn.fujitsu.com>
 <20101021043953.GC2545@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101021043953.GC2545@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 20, 2010 at 09:39:53PM -0700, Paul E. McKenney wrote:
> On Thu, Oct 21, 2010 at 11:29:05AM +0800, Lai Jiangshan wrote:
> > On 10/21/2010 08:19 AM, Paul E. McKenney wrote:
> > > On Wed, Oct 20, 2010 at 12:15:12PM -0700, Paul E. McKenney wrote:
> > >> On Wed, Oct 20, 2010 at 02:12:58PM +0800, Lai Jiangshan wrote:
> > >>> The first version of synchronize_sched_expedited() use the migration code
> > >>> of the scheduler code, so it have to be implemented in sched.c
> > >>>
> > >>> but now, the synchronize_sched_expedited() does not use such code,
> > >>> it is time to move it out of sched.c.
> > >>>
> > >>> Different rcu implementation' synchronize_sched_expedited() are also
> > >>> different. so we move synchronize_sched_expedited() to kernel/rcutree_plugin.h
> > >>> or include/linux/rcutiny.h instead of kerenl/rcupdate.c
> > >>
> > >> Queued, thank you!!!
> > > 
> > > Hello again, Lai,
> > > 
> > > I hit the following build error during testing:
> > > 
> > > kernel/built-in.o: In function `.synchronize_rcu_expedited':
> > > (.text+0x787d8): undefined reference to `.synchronize_sched_expedited'
> > > kernel/built-in.o:(.toc1+0x1fe0): undefined reference to `synchronize_sched_expedited'
> > > 
> > > This build uses defconfig with the following applied:
> > > 
> > > CONFIG_RCU_TRACE=y
> > > CONFIG_RCU_FAST_NO_HZ=y
> > > CONFIG_NO_HZ=y
> > > CONFIG_RCU_CPU_STALL_DETECTOR=y
> > > CONFIG_SMP=y
> > > CONFIG_RCU_FANOUT=8
> > > CONFIG_NR_CPUS=8
> > > CONFIG_RCU_FANOUT_EXACT=n
> > > CONFIG_HOTPLUG_CPU=y
> > > CONFIG_PREEMPT_NONE=y
> > > CONFIG_PREEMPT_VOLUNTARY=n
> > > CONFIG_PREEMPT=n
> > > CONFIG_TREE_RCU=y
> > > CONFIG_TREE_PREEMPT_RCU=n
> > > CONFIG_RCU_TORTURE_TEST=m
> > > CONFIG_MODULE_UNLOAD=y
> > > CONFIG_SYSFS_DEPRECATED_V2=y
> > > CONFIG_IKCONFIG=y
> > > CONFIG_IKCONFIG_PROC=y
> > > 
> > > Thoughts?
> > > 
> > > 							Thanx, Paul
> > > 
> > > 
> > 
> > I moved the code into CONFIG_TREE_PREEMPT_RCU=y codes. fixed version:
> 
> Thank you, queued and am retesting.

And the new version works much better, thank you!  Any news on the
cpumask_any() issue?

							Thanx, Paul

> > Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
> > ---
> > diff --git a/include/linux/rcupdate.h b/include/linux/rcupdate.h
> > index 0d0b640..ead36da 100644
> > --- a/include/linux/rcupdate.h
> > +++ b/include/linux/rcupdate.h
> > @@ -66,7 +66,6 @@ extern void call_rcu_sched(struct rcu_head *head,
> >  extern void synchronize_sched(void);
> >  extern void rcu_barrier_bh(void);
> >  extern void rcu_barrier_sched(void);
> > -extern void synchronize_sched_expedited(void);
> >  extern int sched_expedited_torture_stats(char *page);
> > 
> >  static inline void __rcu_read_lock_bh(void)
> > diff --git a/include/linux/rcutiny.h b/include/linux/rcutiny.h
> > index 13877cb..4d84452 100644
> > --- a/include/linux/rcutiny.h
> > +++ b/include/linux/rcutiny.h
> > @@ -58,6 +58,11 @@ static inline void synchronize_rcu_bh_expedited(void)
> >  	synchronize_sched();
> >  }
> > 
> > +static inline void synchronize_sched_expedited(void)
> > +{
> > +	synchronize_sched();
> > +}
> > +
> >  #ifdef CONFIG_TINY_RCU
> > 
> >  static inline void rcu_preempt_note_context_switch(void)
> > diff --git a/include/linux/rcutree.h b/include/linux/rcutree.h
> > index 95518e6..9a1fd6c 100644
> > --- a/include/linux/rcutree.h
> > +++ b/include/linux/rcutree.h
> > @@ -47,6 +47,7 @@ static inline void exit_rcu(void)
> >  #endif /* #else #ifdef CONFIG_TREE_PREEMPT_RCU */
> > 
> >  extern void synchronize_rcu_bh(void);
> > +extern void synchronize_sched_expedited(void);
> >  extern void synchronize_rcu_expedited(void);
> > 
> >  static inline void synchronize_rcu_bh_expedited(void)
> > diff --git a/kernel/rcutree_plugin.h b/kernel/rcutree_plugin.h
> > index 0e75d60..0de359b 100644
> > --- a/kernel/rcutree_plugin.h
> > +++ b/kernel/rcutree_plugin.h
> > @@ -25,6 +25,7 @@
> >   */
> > 
> >  #include <linux/delay.h>
> > +#include <linux/stop_machine.h>
> > 
> >  /*
> >   * Check the RCU kernel configuration parameters and print informative
> > @@ -1014,6 +1015,76 @@ static void __init __rcu_init_preempt(void)
> > 
> >  #endif /* #else #ifdef CONFIG_TREE_PREEMPT_RCU */
> > 
> > +#ifndef CONFIG_SMP
> > +
> > +void synchronize_sched_expedited(void)
> > +{
> > +	cond_resched();
> > +}
> > +EXPORT_SYMBOL_GPL(synchronize_sched_expedited);
> > +
> > +#else /* #ifndef CONFIG_SMP */
> > +
> > +static atomic_t synchronize_sched_expedited_count = ATOMIC_INIT(0);
> > +
> > +static int synchronize_sched_expedited_cpu_stop(void *data)
> > +{
> > +	/*
> > +	 * There must be a full memory barrier on each affected CPU
> > +	 * between the time that try_stop_cpus() is called and the
> > +	 * time that it returns.
> > +	 *
> > +	 * In the current initial implementation of cpu_stop, the
> > +	 * above condition is already met when the control reaches
> > +	 * this point and the following smp_mb() is not strictly
> > +	 * necessary.  Do smp_mb() anyway for documentation and
> > +	 * robustness against future implementation changes.
> > +	 */
> > +	smp_mb(); /* See above comment block. */
> > +	return 0;
> > +}
> > +
> > +/*
> > + * Wait for an rcu-sched grace period to elapse, but use "big hammer"
> > + * approach to force grace period to end quickly.  This consumes
> > + * significant time on all CPUs, and is thus not recommended for
> > + * any sort of common-case code.
> > + *
> > + * Note that it is illegal to call this function while holding any
> > + * lock that is acquired by a CPU-hotplug notifier.  Failing to
> > + * observe this restriction will result in deadlock.
> > + */
> > +void synchronize_sched_expedited(void)
> > +{
> > +	int snap, trycount = 0;
> > +
> > +	smp_mb();  /* ensure prior mod happens before capturing snap. */
> > +	snap = atomic_read(&synchronize_sched_expedited_count) + 1;
> > +	get_online_cpus();
> > +	while (try_stop_cpus(cpu_online_mask,
> > +			     synchronize_sched_expedited_cpu_stop,
> > +			     NULL) == -EAGAIN) {
> > +		put_online_cpus();
> > +		if (trycount++ < 10)
> > +			udelay(trycount * num_online_cpus());
> > +		else {
> > +			synchronize_sched();
> > +			return;
> > +		}
> > +		if (atomic_read(&synchronize_sched_expedited_count) - snap > 0) {
> > +			smp_mb(); /* ensure test happens before caller kfree */
> > +			return;
> > +		}
> > +		get_online_cpus();
> > +	}
> > +	atomic_inc(&synchronize_sched_expedited_count);
> > +	smp_mb__after_atomic_inc(); /* ensure post-GP actions seen after GP. */
> > +	put_online_cpus();
> > +}
> > +EXPORT_SYMBOL_GPL(synchronize_sched_expedited);
> > +
> > +#endif /* #else #ifndef CONFIG_SMP */
> > +
> >  #if !defined(CONFIG_RCU_FAST_NO_HZ)
> > 
> >  /*
> > diff --git a/kernel/sched.c b/kernel/sched.c
> > index abf8440..9dc7775 100644
> > --- a/kernel/sched.c
> > +++ b/kernel/sched.c
> > @@ -9332,72 +9332,3 @@ struct cgroup_subsys cpuacct_subsys = {
> >  };
> >  #endif	/* CONFIG_CGROUP_CPUACCT */
> > 
> > -#ifndef CONFIG_SMP
> > -
> > -void synchronize_sched_expedited(void)
> > -{
> > -	barrier();
> > -}
> > -EXPORT_SYMBOL_GPL(synchronize_sched_expedited);
> > -
> > -#else /* #ifndef CONFIG_SMP */
> > -
> > -static atomic_t synchronize_sched_expedited_count = ATOMIC_INIT(0);
> > -
> > -static int synchronize_sched_expedited_cpu_stop(void *data)
> > -{
> > -	/*
> > -	 * There must be a full memory barrier on each affected CPU
> > -	 * between the time that try_stop_cpus() is called and the
> > -	 * time that it returns.
> > -	 *
> > -	 * In the current initial implementation of cpu_stop, the
> > -	 * above condition is already met when the control reaches
> > -	 * this point and the following smp_mb() is not strictly
> > -	 * necessary.  Do smp_mb() anyway for documentation and
> > -	 * robustness against future implementation changes.
> > -	 */
> > -	smp_mb(); /* See above comment block. */
> > -	return 0;
> > -}
> > -
> > -/*
> > - * Wait for an rcu-sched grace period to elapse, but use "big hammer"
> > - * approach to force grace period to end quickly.  This consumes
> > - * significant time on all CPUs, and is thus not recommended for
> > - * any sort of common-case code.
> > - *
> > - * Note that it is illegal to call this function while holding any
> > - * lock that is acquired by a CPU-hotplug notifier.  Failing to
> > - * observe this restriction will result in deadlock.
> > - */
> > -void synchronize_sched_expedited(void)
> > -{
> > -	int snap, trycount = 0;
> > -
> > -	smp_mb();  /* ensure prior mod happens before capturing snap. */
> > -	snap = atomic_read(&synchronize_sched_expedited_count) + 1;
> > -	get_online_cpus();
> > -	while (try_stop_cpus(cpu_online_mask,
> > -			     synchronize_sched_expedited_cpu_stop,
> > -			     NULL) == -EAGAIN) {
> > -		put_online_cpus();
> > -		if (trycount++ < 10)
> > -			udelay(trycount * num_online_cpus());
> > -		else {
> > -			synchronize_sched();
> > -			return;
> > -		}
> > -		if (atomic_read(&synchronize_sched_expedited_count) - snap > 0) {
> > -			smp_mb(); /* ensure test happens before caller kfree */
> > -			return;
> > -		}
> > -		get_online_cpus();
> > -	}
> > -	atomic_inc(&synchronize_sched_expedited_count);
> > -	smp_mb__after_atomic_inc(); /* ensure post-GP actions seen after GP. */
> > -	put_online_cpus();
> > -}
> > -EXPORT_SYMBOL_GPL(synchronize_sched_expedited);
> > -
> > -#endif /* #else #ifndef CONFIG_SMP */
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > Please read the FAQ at  http://www.tux.org/lkml/
