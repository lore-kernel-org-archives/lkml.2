Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759536Ab1JGIKO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Oct 2011 04:10:14 -0400
Received: from mail-vx0-f174.google.com ([209.85.220.174]:50352 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751682Ab1JGIKI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Oct 2011 04:10:08 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.LFD.2.02.1110070046270.3240@ionos>
References: <alpine.LFD.2.02.1110070046270.3240@ionos>
Date: Fri, 7 Oct 2011 09:10:05 +0100
Message-ID: <CABcS5h3eJGRfzhA3YA0pxm_uyjksTv1uathF6+PwQfVYwaBR_A@mail.gmail.com>
Subject: Re: [ANNOUNCE] 3.0.6-rt17
From: Rolando Martins <rolando.martins@gmail.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>,
        linux-rt-users <linux-rt-users@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
I still experience a huge slowdown when enabling RT_GROUP with
rt_runtime_us=100 and rt_period_us=100.
Something that does not happen with mainline.
I tried with RCU prio boosting enabling and disable, without improvements.
(dmesg does not print anything and system load is near 0)

Thanks for your efforts,
Rolando

On Fri, Oct 7, 2011 at 2:15 AM, Thomas Gleixner <tglx@linutronix.de> wrote:
> Dear RT Folks,
>
> I'm pleased to announce the 3.0.6-rt17 release.
>
> After chasing weird RCU stalls and hung task messages for quite some
> time a massive collaborative effort was able to track down and fix
> this showstopper. Explanation from the changelog:
>
>   net: Avoid livelock in net_tx_action() on RT
>
>   qdisc_lock is taken w/o disabling interrupts or bottom halfs. So code
>   holding a qdisc_lock() can be interrupted and softirqs can run on the
>   return of interrupt in !RT.
>
>   The spin_trylock() in net_tx_action() makes sure, that the softirq
>   does not deadlock. When the lock can't be acquired q is requeued and
>   the NET_TX softirq is raised. That causes the softirq to run over and
>   over.
>
>   That works in mainline as do_softirq() has a retry loop limit and
>   leaves the softirq processing in the interrupt return path and
>   schedules ksoftirqd. The task which holds qdisc_lock cannot be
>   preempted, so the lock is released and either ksoftirqd or the next
>   softirq in the return from interrupt path can proceed. Though it's a
>   bit strange to actually run MAX_SOFTIRQ_RESTART (10) loops before it
>   decides to bail out even if it's clear in the first iteration :)
>
>   On RT all softirq processing is done in a FIFO thread and we don't
>   have a loop limit, so ksoftirqd preempts the lock holder forever and
>   unqueues and requeues until the reset button is hit.
>
>   Due to the forced threading of ksoftirqd on RT we actually cannot
>   deadlock on qdisc_lock because it's a "sleeping lock". So it's safe to
>   replace the spin_trylock() with a spin_lock(). When contended,
>   ksoftirqd is scheduled out and the lock holder can proceed.
>
> Thanks to all involved in chasing that nasty issue down, which was
> unfortunately hard to reproduce. Thanks go to
>
>    - Carsten Emde for providing the initial debug data to narrow it
>      down, coming up with great ways of debugging it and happily
>      testing whatever we came up with
>
>    - Steven Rostedt for coming up with the final debug patches which
>      gave me a clue for decoding the issue and the now applied patch
>      which is much more cleaner than what I hacked together
>
>    - Paul McKenney for spending tons of time to discuss the RCU_BH
>      semantics in the light of RT with me and his findings that we
>      need to bring back my initial patch (with a proper changelog -
>      written by Paul) and some additional fixups
>
>    - Peter Zijlstra for bearing with my bad mood and helping
>      analyzing all the findings. Peter finally decoded the mistery
>      why the RT throttling mechanism did not detect that ksoftirqd
>      went into an infinite loop. As a result he provided an amazingly
>      simple mechanism to make the RT overload detector going from
>      system wide to per cpu. We can now simply set the scheduler
>      feature RT_RUNTIME_SHARE to 0 which enables us to debug cpu
>      local RT hogs.
>
>    - Luis Claudio Goncalves for running whatever tests we came up
>      with on his reproducer machine
>
> Additional thanks go to
>
>     - Frank Rowand who diligently runs each RT release through his
>       seemingly endless supply of configs and testbeds and comes
>       forth with fixes and enhancements with amazing speed!
>
>     - OSADL and Carsten Emde for providing the invaluable service of
>       the RT QA farm
>       (https://www.osadl.org/QA-Farm-Realtime.qa-farm-about.0.html)
>       which provides longterm statistical data and when problems
>       arise always competent and helpful assistance for tracking them
>       down and providing fixes as his times allows.
>
>     - Mike Galbraith for analyzing and decoding itty details all over
>       the place.
>
>     - all those who reported problems and provided debug data and
>       fixes
>
>
> That said, here are the changes from 3.0.6-rt16 to 3.0.6-rt17
>
>  * Fix a livelock in net_tx_action (Steven Rostedt, myself)
>
>  * Bring back RCU_bh modifications with further fixups (Paul McKenney)
>
>  * Fix PF_THREAD_BOUND asymetry in workqueues
>
>  * UP compile fix (Frank Rowand)
>
>  * RT overload debug patch (Peter Zijlstra)
>
>  * Dropped a obsolete RCU protection fixup
>
>  * More IRQF_NO_THREAD annotations for powerpc
>
> Delta patch against 3.0.6-rt16
>
>  https://tglx.de/~tglx/rt/patch-3.0.6-rt16-rt17.patch.gz
>
> also appended below.
>
>
> Patch against 3.0.6 can be found here:
>
>  https://tglx.de/~tglx/rt/patch-3.0.6-rt17.patch.gz
>
>
> The split quilt queue is available at:
>
>  https://tglx.de/~tglx/rt/patches-3.0.6-rt17.tar.gz
>
> Enjoy,
>
>        tglx
>
> --------------->
> Index: linux-2.6/fs/ioprio.c
> ===================================================================
> --- linux-2.6.orig/fs/ioprio.c
> +++ linux-2.6/fs/ioprio.c
> @@ -226,7 +226,6 @@ SYSCALL_DEFINE2(ioprio_get, int, which,
>                        if (!user)
>                                break;
>
> -                       rcu_read_lock();
>                        do_each_thread(g, p) {
>                                if (__task_cred(p)->uid != user->uid)
>                                        continue;
> @@ -238,7 +237,6 @@ SYSCALL_DEFINE2(ioprio_get, int, which,
>                                else
>                                        ret = ioprio_best(ret, tmpio);
>                        } while_each_thread(g, p);
> -                       rcu_read_unlock();
>
>                        if (who)
>                                free_uid(user);
> Index: linux-2.6/include/linux/rcupdate.h
> ===================================================================
> --- linux-2.6.orig/include/linux/rcupdate.h
> +++ linux-2.6/include/linux/rcupdate.h
> @@ -78,7 +78,13 @@ struct rcu_head {
>  extern void call_rcu_sched(struct rcu_head *head,
>                           void (*func)(struct rcu_head *rcu));
>  extern void synchronize_sched(void);
> +
> +#ifdef CONFIG_PREEMPT_RT_FULL
> +# define rcu_barrier_bh                rcu_barrier
> +#else
>  extern void rcu_barrier_bh(void);
> +#endif
> +
>  extern void rcu_barrier_sched(void);
>
>  static inline void __rcu_read_lock_bh(void)
> @@ -229,7 +235,14 @@ static inline int rcu_read_lock_held(voi
>  * rcu_read_lock_bh_held() is defined out of line to avoid #include-file
>  * hell.
>  */
> +#ifdef CONFIG_PREEMPT_RT_FULL
> +static inline int rcu_read_lock_bh_held(void)
> +{
> +       return rcu_read_lock_held();
> +}
> +#else
>  extern int rcu_read_lock_bh_held(void);
> +#endif
>
>  /**
>  * rcu_read_lock_sched_held() - might we be in RCU-sched read-side critical section?
> @@ -638,8 +651,13 @@ static inline void rcu_read_unlock(void)
>  static inline void rcu_read_lock_bh(void)
>  {
>        __rcu_read_lock_bh();
> +
> +#ifdef CONFIG_PREEMPT_RT_FULL
> +       rcu_read_lock();
> +#else
>        __acquire(RCU_BH);
>        rcu_read_acquire_bh();
> +#endif
>  }
>
>  /*
> @@ -649,8 +667,12 @@ static inline void rcu_read_lock_bh(void
>  */
>  static inline void rcu_read_unlock_bh(void)
>  {
> +#ifdef CONFIG_PREEMPT_RT_FULL
> +       rcu_read_unlock();
> +#else
>        rcu_read_release_bh();
>        __release(RCU_BH);
> +#endif
>        __rcu_read_unlock_bh();
>  }
>
> @@ -757,6 +779,9 @@ extern void call_rcu(struct rcu_head *he
>
>  #endif /* #else #ifdef CONFIG_PREEMPT_RCU */
>
> +#ifdef CONFIG_PREEMPT_RT_FULL
> +#define call_rcu_bh    call_rcu
> +#else
>  /**
>  * call_rcu_bh() - Queue an RCU for invocation after a quicker grace period.
>  * @head: structure to be used for queueing the RCU updates.
> @@ -777,6 +802,7 @@ extern void call_rcu(struct rcu_head *he
>  */
>  extern void call_rcu_bh(struct rcu_head *head,
>                        void (*func)(struct rcu_head *head));
> +#endif
>
>  /*
>  * debug_rcu_head_queue()/debug_rcu_head_unqueue() are used internally
> Index: linux-2.6/kernel/rcutree.c
> ===================================================================
> --- linux-2.6.orig/kernel/rcutree.c
> +++ linux-2.6/kernel/rcutree.c
> @@ -166,6 +166,12 @@ void rcu_sched_qs(int cpu)
>        rdp->passed_quiesc = 1;
>  }
>
> +#ifdef CONFIG_PREEMPT_RT_FULL
> +void rcu_bh_qs(int cpu)
> +{
> +       rcu_preempt_qs(cpu);
> +}
> +#else
>  void rcu_bh_qs(int cpu)
>  {
>        struct rcu_data *rdp = &per_cpu(rcu_bh_data, cpu);
> @@ -174,6 +180,7 @@ void rcu_bh_qs(int cpu)
>        barrier();
>        rdp->passed_quiesc = 1;
>  }
> +#endif
>
>  /*
>  * Note a context switch.  This is a quiescent state for RCU-sched,
> @@ -216,6 +223,7 @@ long rcu_batches_completed_sched(void)
>  }
>  EXPORT_SYMBOL_GPL(rcu_batches_completed_sched);
>
> +#ifndef CONFIG_PREEMPT_RT_FULL
>  /*
>  * Return the number of RCU BH batches processed thus far for debug & stats.
>  */
> @@ -233,6 +241,7 @@ void rcu_bh_force_quiescent_state(void)
>        force_quiescent_state(&rcu_bh_state, 0);
>  }
>  EXPORT_SYMBOL_GPL(rcu_bh_force_quiescent_state);
> +#endif
>
>  /*
>  * Record the number of times rcutorture tests have been initiated and
> @@ -1579,6 +1588,7 @@ void call_rcu_sched(struct rcu_head *hea
>  }
>  EXPORT_SYMBOL_GPL(call_rcu_sched);
>
> +#ifndef CONFIG_PREEMPT_RT_FULL
>  /*
>  * Queue an RCU for invocation after a quicker grace period.
>  */
> @@ -1587,6 +1597,7 @@ void call_rcu_bh(struct rcu_head *head,
>        __call_rcu(head, func, &rcu_bh_state);
>  }
>  EXPORT_SYMBOL_GPL(call_rcu_bh);
> +#endif
>
>  /**
>  * synchronize_sched - wait until an rcu-sched grace period has elapsed.
> @@ -1628,6 +1639,7 @@ void synchronize_sched(void)
>  }
>  EXPORT_SYMBOL_GPL(synchronize_sched);
>
> +#ifndef CONFIG_PREEMPT_RT_FULL
>  /**
>  * synchronize_rcu_bh - wait until an rcu_bh grace period has elapsed.
>  *
> @@ -1653,6 +1665,7 @@ void synchronize_rcu_bh(void)
>        destroy_rcu_head_on_stack(&rcu.head);
>  }
>  EXPORT_SYMBOL_GPL(synchronize_rcu_bh);
> +#endif
>
>  /*
>  * Check to see if there is any immediate RCU-related work to be done
> @@ -1806,6 +1819,7 @@ static void _rcu_barrier(struct rcu_stat
>        mutex_unlock(&rcu_barrier_mutex);
>  }
>
> +#ifndef CONFIG_PREEMPT_RT_FULL
>  /**
>  * rcu_barrier_bh - Wait until all in-flight call_rcu_bh() callbacks complete.
>  */
> @@ -1814,6 +1828,7 @@ void rcu_barrier_bh(void)
>        _rcu_barrier(&rcu_bh_state, call_rcu_bh);
>  }
>  EXPORT_SYMBOL_GPL(rcu_barrier_bh);
> +#endif
>
>  /**
>  * rcu_barrier_sched - Wait for in-flight call_rcu_sched() callbacks.
> Index: linux-2.6/kernel/rcutree.h
> ===================================================================
> --- linux-2.6.orig/kernel/rcutree.h
> +++ linux-2.6/kernel/rcutree.h
> @@ -422,6 +422,7 @@ DECLARE_PER_CPU(struct rcu_data, rcu_pre
>  /* Forward declarations for rcutree_plugin.h */
>  static void rcu_bootup_announce(void);
>  long rcu_batches_completed(void);
> +static void rcu_preempt_qs(int cpu);
>  static void rcu_preempt_note_context_switch(int cpu);
>  static int rcu_preempt_blocked_readers_cgp(struct rcu_node *rnp);
>  #ifdef CONFIG_HOTPLUG_CPU
> Index: linux-2.6/kernel/rcutree_plugin.h
> ===================================================================
> --- linux-2.6.orig/kernel/rcutree_plugin.h
> +++ linux-2.6/kernel/rcutree_plugin.h
> @@ -1892,7 +1892,7 @@ EXPORT_SYMBOL_GPL(synchronize_sched_expe
>
>  #endif /* #else #ifndef CONFIG_SMP */
>
> -#if !defined(CONFIG_RCU_FAST_NO_HZ)
> +#if 1 /* !defined(CONFIG_RCU_FAST_NO_HZ) */
>
>  /*
>  * Check to see if any future RCU-related work will need to be done
> Index: linux-2.6/kernel/rtmutex-debug.h
> ===================================================================
> --- linux-2.6.orig/kernel/rtmutex-debug.h
> +++ linux-2.6/kernel/rtmutex-debug.h
> @@ -17,17 +17,17 @@ extern void debug_rt_mutex_free_waiter(s
>  extern void debug_rt_mutex_init(struct rt_mutex *lock, const char *name);
>  extern void debug_rt_mutex_lock(struct rt_mutex *lock);
>  extern void debug_rt_mutex_unlock(struct rt_mutex *lock);
> -extern void
> -debug_rt_mutex_proxy_lock(struct rt_mutex *lock, struct task_struct *powner);
> +extern void debug_rt_mutex_proxy_lock(struct rt_mutex *lock,
> +                                     struct task_struct *powner);
>  extern void debug_rt_mutex_proxy_unlock(struct rt_mutex *lock);
>  extern void debug_rt_mutex_deadlock(int detect, struct rt_mutex_waiter *waiter,
>                                    struct rt_mutex *lock);
>  extern void debug_rt_mutex_print_deadlock(struct rt_mutex_waiter *waiter);
> -# define debug_rt_mutex_reset_waiter(w) \
> +# define debug_rt_mutex_reset_waiter(w)                        \
>        do { (w)->deadlock_lock = NULL; } while (0)
>
> -static inline int
> -debug_rt_mutex_detect_deadlock(struct rt_mutex_waiter *waiter, int detect)
> +static inline int debug_rt_mutex_detect_deadlock(struct rt_mutex_waiter *waiter,
> +                                                int detect)
>  {
> -       return waiter != NULL;
> +       return (waiter != NULL);
>  }
> Index: linux-2.6/kernel/sched.c
> ===================================================================
> --- linux-2.6.orig/kernel/sched.c
> +++ linux-2.6/kernel/sched.c
> @@ -2822,7 +2822,7 @@ static void __sched_fork(struct task_str
>  void sched_fork(struct task_struct *p)
>  {
>        unsigned long flags;
> -       int cpu;
> +       int cpu = get_cpu();
>
>        __sched_fork(p);
>        /*
> @@ -2862,7 +2862,6 @@ void sched_fork(struct task_struct *p)
>        if (!rt_prio(p->prio))
>                p->sched_class = &fair_sched_class;
>
> -       cpu = get_cpu();
>        if (p->sched_class->task_fork)
>                p->sched_class->task_fork(p);
>
> @@ -2874,9 +2873,8 @@ void sched_fork(struct task_struct *p)
>         * Silence PROVE_RCU.
>         */
>        raw_spin_lock_irqsave(&p->pi_lock, flags);
> -       set_task_cpu(p, smp_processor_id());
> +       set_task_cpu(p, cpu);
>        raw_spin_unlock_irqrestore(&p->pi_lock, flags);
> -       put_cpu();
>
>  #if defined(CONFIG_SCHEDSTATS) || defined(CONFIG_TASK_DELAY_ACCT)
>        if (likely(sched_info_on()))
> @@ -2892,6 +2890,8 @@ void sched_fork(struct task_struct *p)
>  #ifdef CONFIG_SMP
>        plist_node_init(&p->pushable_tasks, MAX_PRIO);
>  #endif
> +
> +       put_cpu();
>  }
>
>  /*
> @@ -4207,7 +4207,7 @@ static inline void schedule_debug(struct
>        schedstat_inc(this_rq(), sched_count);
>  }
>
> -#ifdef CONFIG_PREEMPT_RT_FULL
> +#if defined(CONFIG_PREEMPT_RT_FULL) && defined(CONFIG_SMP)
>  #define MIGRATE_DISABLE_SET_AFFIN      (1<<30) /* Can't make a negative */
>  #define migrate_disabled_updated(p)    ((p)->migrate_disable & MIGRATE_DISABLE_SET_AFFIN)
>  #define migrate_disable_count(p)       ((p)->migrate_disable & ~MIGRATE_DISABLE_SET_AFFIN)
> Index: linux-2.6/kernel/sched_features.h
> ===================================================================
> --- linux-2.6.orig/kernel/sched_features.h
> +++ linux-2.6/kernel/sched_features.h
> @@ -76,3 +76,4 @@ SCHED_FEAT(TTWU_QUEUE, 0)
>  #endif
>
>  SCHED_FEAT(FORCE_SD_OVERLAP, 0)
> +SCHED_FEAT(RT_RUNTIME_SHARE, 1)
> Index: linux-2.6/kernel/sched_rt.c
> ===================================================================
> --- linux-2.6.orig/kernel/sched_rt.c
> +++ linux-2.6/kernel/sched_rt.c
> @@ -536,6 +536,9 @@ static int balance_runtime(struct rt_rq
>  {
>        int more = 0;
>
> +       if (!sched_feat(RT_RUNTIME_SHARE))
> +               return more;
> +
>        if (rt_rq->rt_time > rt_rq->rt_runtime) {
>                raw_spin_unlock(&rt_rq->rt_runtime_lock);
>                more = do_balance_runtime(rt_rq);
> Index: linux-2.6/kernel/softirq.c
> ===================================================================
> --- linux-2.6.orig/kernel/softirq.c
> +++ linux-2.6/kernel/softirq.c
> @@ -138,7 +138,7 @@ static void wakeup_softirqd(void)
>                wake_up_process(tsk);
>  }
>
> -static void handle_pending_softirqs(u32 pending, int cpu)
> +static void handle_pending_softirqs(u32 pending, int cpu, int need_rcu_bh_qs)
>  {
>        struct softirq_action *h = softirq_vec;
>        unsigned int prev_count = preempt_count();
> @@ -161,7 +161,8 @@ static void handle_pending_softirqs(u32
>                               prev_count, (unsigned int) preempt_count());
>                        preempt_count() = prev_count;
>                }
> -               rcu_bh_qs(cpu);
> +               if (need_rcu_bh_qs)
> +                       rcu_bh_qs(cpu);
>        }
>        local_irq_disable();
>  }
> @@ -313,7 +314,7 @@ restart:
>        /* Reset the pending bitmask before enabling irqs */
>        set_softirq_pending(0);
>
> -       handle_pending_softirqs(pending, cpu);
> +       handle_pending_softirqs(pending, cpu, 1);
>
>        pending = local_softirq_pending();
>        if (pending && --max_restart)
> @@ -383,7 +384,12 @@ static inline void ksoftirqd_clr_sched_p
>  static DEFINE_LOCAL_IRQ_LOCK(local_softirq_lock);
>  static DEFINE_PER_CPU(struct task_struct *, local_softirq_runner);
>
> -static void __do_softirq(void);
> +static void __do_softirq_common(int need_rcu_bh_qs);
> +
> +void __do_softirq(void)
> +{
> +       __do_softirq_common(0);
> +}
>
>  void __init softirq_early_init(void)
>  {
> @@ -446,7 +452,7 @@ int in_serving_softirq(void)
>  * Called with bh and local interrupts disabled. For full RT cpu must
>  * be pinned.
>  */
> -static void __do_softirq(void)
> +static void __do_softirq_common(int need_rcu_bh_qs)
>  {
>        u32 pending = local_softirq_pending();
>        int cpu = smp_processor_id();
> @@ -460,7 +466,7 @@ static void __do_softirq(void)
>
>        lockdep_softirq_enter();
>
> -       handle_pending_softirqs(pending, cpu);
> +       handle_pending_softirqs(pending, cpu, need_rcu_bh_qs);
>
>        pending = local_softirq_pending();
>        if (pending)
> @@ -499,7 +505,7 @@ static int __thread_do_softirq(int cpu)
>         * schedule!
>         */
>        if (local_softirq_pending())
> -               __do_softirq();
> +               __do_softirq_common(cpu >= 0);
>        local_unlock(local_softirq_lock);
>        unpin_current_cpu();
>        preempt_disable();
> Index: linux-2.6/kernel/workqueue.c
> ===================================================================
> --- linux-2.6.orig/kernel/workqueue.c
> +++ linux-2.6/kernel/workqueue.c
> @@ -1277,22 +1277,22 @@ __acquires(&gcwq->lock)
>                 * it races with cpu hotunplug operation.  Verify
>                 * against GCWQ_DISASSOCIATED.
>                 */
> -               if (!(gcwq->flags & GCWQ_DISASSOCIATED)) {
> -                       /*
> -                        * Since we're binding to a particular cpu and need to
> -                        * stay there for correctness, mark us PF_THREAD_BOUND.
> -                        */
> -                       task->flags |= PF_THREAD_BOUND;
> +               if (!(gcwq->flags & GCWQ_DISASSOCIATED))
>                        set_cpus_allowed_ptr(task, get_cpu_mask(gcwq->cpu));
> -               }
>
>                spin_lock_irq(&gcwq->lock);
>                if (gcwq->flags & GCWQ_DISASSOCIATED)
>                        return false;
>                if (task_cpu(task) == gcwq->cpu &&
>                    cpumask_equal(&current->cpus_allowed,
> -                                 get_cpu_mask(gcwq->cpu)))
> +                                 get_cpu_mask(gcwq->cpu))) {
> +                       /*
> +                        * Since we're binding to a particular cpu and need to
> +                        * stay there for correctness, mark us PF_THREAD_BOUND.
> +                        */
> +                       task->flags |= PF_THREAD_BOUND;
>                        return true;
> +               }
>                spin_unlock_irq(&gcwq->lock);
>
>                /*
> Index: linux-2.6/localversion-rt
> ===================================================================
> --- linux-2.6.orig/localversion-rt
> +++ linux-2.6/localversion-rt
> @@ -1 +1 @@
> --rt16
> +-rt17
> Index: linux-2.6/net/core/dev.c
> ===================================================================
> --- linux-2.6.orig/net/core/dev.c
> +++ linux-2.6/net/core/dev.c
> @@ -2912,6 +2912,36 @@ int netif_rx_ni(struct sk_buff *skb)
>  }
>  EXPORT_SYMBOL(netif_rx_ni);
>
> +#ifdef CONFIG_PREEMPT_RT_FULL
> +/*
> + * RT runs ksoftirqd as a real time thread and the root_lock is a
> + * "sleeping spinlock". If the trylock fails then we can go into an
> + * infinite loop when ksoftirqd preempted the task which actually
> + * holds the lock, because we requeue q and raise NET_TX softirq
> + * causing ksoftirqd to loop forever.
> + *
> + * It's safe to use spin_lock on RT here as softirqs run in thread
> + * context and cannot deadlock against the thread which is holding
> + * root_lock.
> + *
> + * On !RT the trylock might fail, but there we bail out from the
> + * softirq loop after 10 attempts which we can't do on RT. And the
> + * task holding root_lock cannot be preempted, so the only downside of
> + * that trylock is that we need 10 loops to decide that we should have
> + * given up in the first one :)
> + */
> +static inline int take_root_lock(spinlock_t *lock)
> +{
> +       spin_lock(lock);
> +       return 1;
> +}
> +#else
> +static inline int take_root_lock(spinlock_t *lock)
> +{
> +       return spin_trylock(lock);
> +}
> +#endif
> +
>  static void net_tx_action(struct softirq_action *h)
>  {
>        struct softnet_data *sd = &__get_cpu_var(softnet_data);
> @@ -2950,7 +2980,7 @@ static void net_tx_action(struct softirq
>                        head = head->next_sched;
>
>                        root_lock = qdisc_lock(q);
> -                       if (spin_trylock(root_lock)) {
> +                       if (take_root_lock(root_lock)) {
>                                smp_mb__before_clear_bit();
>                                clear_bit(__QDISC_STATE_SCHED,
>                                          &q->state);
> Index: linux-2.6/arch/powerpc/platforms/wsp/opb_pic.c
> ===================================================================
> --- linux-2.6.orig/arch/powerpc/platforms/wsp/opb_pic.c
> +++ linux-2.6/arch/powerpc/platforms/wsp/opb_pic.c
> @@ -320,7 +320,8 @@ void __init opb_pic_init(void)
>                }
>
>                /* Attach opb interrupt handler to new virtual IRQ */
> -               rc = request_irq(virq, opb_irq_handler, 0, "OPB LS Cascade", opb);
> +               rc = request_irq(virq, opb_irq_handler, IRQF_NO_THREAD,
> +                                "OPB LS Cascade", opb);
>                if (rc) {
>                        printk("opb: request_irq failed: %d\n", rc);
>                        continue;
> Index: linux-2.6/arch/powerpc/kernel/smp.c
> ===================================================================
> --- linux-2.6.orig/arch/powerpc/kernel/smp.c
> +++ linux-2.6/arch/powerpc/kernel/smp.c
> @@ -170,7 +170,7 @@ int smp_request_message_ipi(int virq, in
>                return 1;
>        }
>  #endif
> -       err = request_irq(virq, smp_ipi_action[msg], IRQF_DISABLED|IRQF_PERCPU,
> +       err = request_irq(virq, smp_ipi_action[msg], IRQF_NO_THREAD|IRQF_PERCPU,
>                          smp_ipi_name[msg], 0);
>        WARN(err < 0, "unable to request_irq %d for %s (rc %d)\n",
>                virq, smp_ipi_name[msg], err);
> Index: linux-2.6/arch/powerpc/platforms/powermac/smp.c
> ===================================================================
> --- linux-2.6.orig/arch/powerpc/platforms/powermac/smp.c
> +++ linux-2.6/arch/powerpc/platforms/powermac/smp.c
> @@ -200,7 +200,7 @@ static int psurge_secondary_ipi_init(voi
>
>        if (psurge_secondary_virq)
>                rc = request_irq(psurge_secondary_virq, psurge_ipi_intr,
> -                       IRQF_DISABLED|IRQF_PERCPU, "IPI", NULL);
> +                       IRQF_NO_THREAD|IRQF_PERCPU, "IPI", NULL);
>
>        if (rc)
>                pr_err("Failed to setup secondary cpu IPI\n");
> @@ -408,7 +408,7 @@ static int __init smp_psurge_kick_cpu(in
>
>  static struct irqaction psurge_irqaction = {
>        .handler = psurge_ipi_intr,
> -       .flags = IRQF_DISABLED|IRQF_PERCPU,
> +       .flags = IRQF_NO_THREAD|IRQF_PERCPU,
>        .name = "primary IPI",
>  };
>
> Index: linux-2.6/arch/powerpc/sysdev/xics/xics-common.c
> ===================================================================
> --- linux-2.6.orig/arch/powerpc/sysdev/xics/xics-common.c
> +++ linux-2.6/arch/powerpc/sysdev/xics/xics-common.c
> @@ -134,11 +134,11 @@ static void xics_request_ipi(void)
>        BUG_ON(ipi == NO_IRQ);
>
>        /*
> -        * IPIs are marked IRQF_DISABLED as they must run with irqs
> -        * disabled, and PERCPU.  The handler was set in map.
> +        * IPIs are marked PERCPU and also IRQF_NO_THREAD as they must
> +        * run in hard interrupt context. The handler was set in map.
>         */
>        BUG_ON(request_irq(ipi, icp_ops->ipi_action,
> -                          IRQF_DISABLED|IRQF_PERCPU, "IPI", NULL));
> +                          IRQF_NO_THREAD|IRQF_PERCPU, "IPI", NULL));
>  }
>
>  int __init xics_smp_probe(void)
> Index: linux-2.6/include/linux/rcutree.h
> ===================================================================
> --- linux-2.6.orig/include/linux/rcutree.h
> +++ linux-2.6/include/linux/rcutree.h
> @@ -57,7 +57,11 @@ static inline void exit_rcu(void)
>
>  #endif /* #else #ifdef CONFIG_TREE_PREEMPT_RCU */
>
> +#ifndef CONFIG_PREEMPT_RT_FULL
>  extern void synchronize_rcu_bh(void);
> +#else
> +# define synchronize_rcu_bh()  synchronize_rcu()
> +#endif
>  extern void synchronize_sched_expedited(void);
>  extern void synchronize_rcu_expedited(void);
>
> @@ -71,13 +75,19 @@ extern void rcu_barrier(void);
>  extern unsigned long rcutorture_testseq;
>  extern unsigned long rcutorture_vernum;
>  extern long rcu_batches_completed(void);
> -extern long rcu_batches_completed_bh(void);
>  extern long rcu_batches_completed_sched(void);
>
>  extern void rcu_force_quiescent_state(void);
> -extern void rcu_bh_force_quiescent_state(void);
>  extern void rcu_sched_force_quiescent_state(void);
>
> +#ifndef CONFIG_PREEMPT_RT_FULL
> +extern void rcu_bh_force_quiescent_state(void);
> +extern long rcu_batches_completed_bh(void);
> +#else
> +# define rcu_bh_force_quiescent_state  rcu_force_quiescent_state
> +# define rcu_batches_completed_bh      rcu_batches_completed
> +#endif
> +
>  /* A context switch is a grace period for RCU-sched and RCU-bh. */
>  static inline int rcu_blocking_is_gp(void)
>  {
> Index: linux-2.6/kernel/rcupdate.c
> ===================================================================
> --- linux-2.6.orig/kernel/rcupdate.c
> +++ linux-2.6/kernel/rcupdate.c
> @@ -72,6 +72,7 @@ int debug_lockdep_rcu_enabled(void)
>  }
>  EXPORT_SYMBOL_GPL(debug_lockdep_rcu_enabled);
>
> +#ifndef CONFIG_PREEMPT_RT_FULL
>  /**
>  * rcu_read_lock_bh_held() - might we be in RCU-bh read-side critical section?
>  *
> @@ -91,6 +92,7 @@ int rcu_read_lock_bh_held(void)
>        return in_softirq() || irqs_disabled();
>  }
>  EXPORT_SYMBOL_GPL(rcu_read_lock_bh_held);
> +#endif
>
>  #endif /* #ifdef CONFIG_DEBUG_LOCK_ALLOC */
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rt-users" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
