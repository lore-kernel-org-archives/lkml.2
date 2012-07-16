Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753346Ab2GPQ7a (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2012 12:59:30 -0400
Received: from e9.ny.us.ibm.com ([32.97.182.139]:52150 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751916Ab2GPQ72 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2012 12:59:28 -0400
Date: Mon, 16 Jul 2012 09:59:14 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <peterz@infradead.org>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Namhyung Kim <namhyung@kernel.org>
Subject: Re: [Patch 6/7] rcu: Use smp_hotplug_thread facility for RCUs
 per-CPU kthread
Message-ID: <20120716165914.GA15171@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20120716103749.122800930@linutronix.de>
 <20120716103948.673354828@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120716103948.673354828@linutronix.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12071616-7182-0000-0000-000001FED7AB
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 16, 2012 at 10:42:38AM -0000, Thomas Gleixner wrote:
> From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
> 
> Bring RCU into the new-age CPU-hotplug fold by modifying RCU's per-CPU
> kthread code to use the new smp_hotplug_thread facility.
> 
> [ tglx: Adapted it to use callbacks and to the simplified rcu yield ]

This version does look a lot nicer!

							Thanx, Paul

> Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> ---
>  kernel/rcutree.c        |    4 
>  kernel/rcutree.h        |    8 -
>  kernel/rcutree_plugin.h |  203 +++++++++---------------------------------------
>  kernel/rcutree_trace.c  |    3 
>  4 files changed, 41 insertions(+), 177 deletions(-)
> 
> Index: tip/kernel/rcutree.c
> ===================================================================
> --- tip.orig/kernel/rcutree.c
> +++ tip/kernel/rcutree.c
> @@ -125,7 +125,6 @@ static int rcu_scheduler_fully_active __
>   */
>  static DEFINE_PER_CPU(struct task_struct *, rcu_cpu_kthread_task);
>  DEFINE_PER_CPU(unsigned int, rcu_cpu_kthread_status);
> -DEFINE_PER_CPU(int, rcu_cpu_kthread_cpu);
>  DEFINE_PER_CPU(unsigned int, rcu_cpu_kthread_loops);
>  DEFINE_PER_CPU(char, rcu_cpu_has_work);
> 
> @@ -1458,7 +1457,6 @@ static void rcu_cleanup_dead_cpu(int cpu
>  	struct rcu_node *rnp = rdp->mynode;  /* Outgoing CPU's rdp & rnp. */
> 
>  	/* Adjust any no-longer-needed kthreads. */
> -	rcu_stop_cpu_kthread(cpu);
>  	rcu_boost_kthread_setaffinity(rnp, -1);
> 
>  	/* Remove the dead CPU from the bitmasks in the rcu_node hierarchy. */
> @@ -2514,11 +2512,9 @@ static int __cpuinit rcu_cpu_notify(stru
>  	case CPU_ONLINE:
>  	case CPU_DOWN_FAILED:
>  		rcu_boost_kthread_setaffinity(rnp, -1);
> -		rcu_cpu_kthread_setrt(cpu, 1);
>  		break;
>  	case CPU_DOWN_PREPARE:
>  		rcu_boost_kthread_setaffinity(rnp, cpu);
> -		rcu_cpu_kthread_setrt(cpu, 0);
>  		break;
>  	case CPU_DYING:
>  	case CPU_DYING_FROZEN:
> Index: tip/kernel/rcutree.h
> ===================================================================
> --- tip.orig/kernel/rcutree.h
> +++ tip/kernel/rcutree.h
> @@ -178,12 +178,6 @@ struct rcu_node {
>  				/* Refused to boost: not sure why, though. */
>  				/*  This can happen due to race conditions. */
>  #endif /* #ifdef CONFIG_RCU_BOOST */
> -	struct task_struct *node_kthread_task;
> -				/* kthread that takes care of this rcu_node */
> -				/*  structure, for example, awakening the */
> -				/*  per-CPU kthreads as needed. */
> -	unsigned int node_kthread_status;
> -				/* State of node_kthread_task for tracing. */
>  } ____cacheline_internodealigned_in_smp;
> 
>  /*
> @@ -434,7 +428,6 @@ static int rcu_preempt_blocked_readers_c
>  #ifdef CONFIG_HOTPLUG_CPU
>  static void rcu_report_unblock_qs_rnp(struct rcu_node *rnp,
>  				      unsigned long flags);
> -static void rcu_stop_cpu_kthread(int cpu);
>  #endif /* #ifdef CONFIG_HOTPLUG_CPU */
>  static void rcu_print_detail_task_stall(struct rcu_state *rsp);
>  static int rcu_print_task_stall(struct rcu_node *rnp);
> @@ -467,7 +460,6 @@ static void rcu_preempt_do_callbacks(voi
>  static int __cpuinit rcu_spawn_one_boost_kthread(struct rcu_state *rsp,
>  						 struct rcu_node *rnp);
>  #endif /* #ifdef CONFIG_RCU_BOOST */
> -static void rcu_cpu_kthread_setrt(int cpu, int to_rt);
>  static void __cpuinit rcu_prepare_kthreads(int cpu);
>  static void rcu_prepare_for_idle_init(int cpu);
>  static void rcu_cleanup_after_idle(int cpu);
> Index: tip/kernel/rcutree_plugin.h
> ===================================================================
> --- tip.orig/kernel/rcutree_plugin.h
> +++ tip/kernel/rcutree_plugin.h
> @@ -25,6 +25,7 @@
>   */
> 
>  #include <linux/delay.h>
> +#include <linux/smpboot.h>
> 
>  #define RCU_KTHREAD_PRIO 1
> 
> @@ -1440,25 +1441,6 @@ static int __cpuinit rcu_spawn_one_boost
>  	return 0;
>  }
> 
> -#ifdef CONFIG_HOTPLUG_CPU
> -
> -/*
> - * Stop the RCU's per-CPU kthread when its CPU goes offline,.
> - */
> -static void rcu_stop_cpu_kthread(int cpu)
> -{
> -	struct task_struct *t;
> -
> -	/* Stop the CPU's kthread. */
> -	t = per_cpu(rcu_cpu_kthread_task, cpu);
> -	if (t != NULL) {
> -		per_cpu(rcu_cpu_kthread_task, cpu) = NULL;
> -		kthread_stop(t);
> -	}
> -}
> -
> -#endif /* #ifdef CONFIG_HOTPLUG_CPU */
> -
>  static void rcu_kthread_do_work(void)
>  {
>  	rcu_do_batch(&rcu_sched_state, &__get_cpu_var(rcu_sched_data));
> @@ -1466,59 +1448,22 @@ static void rcu_kthread_do_work(void)
>  	rcu_preempt_do_callbacks();
>  }
> 
> -/*
> - * Set the specified CPU's kthread to run RT or not, as specified by
> - * the to_rt argument.  The CPU-hotplug locks are held, so the task
> - * is not going away.
> - */
> -static void rcu_cpu_kthread_setrt(int cpu, int to_rt)
> +static void rcu_cpu_kthread_setup(unsigned int cpu)
>  {
> -	int policy;
>  	struct sched_param sp;
> -	struct task_struct *t;
> 
> -	t = per_cpu(rcu_cpu_kthread_task, cpu);
> -	if (t == NULL)
> -		return;
> -	if (to_rt) {
> -		policy = SCHED_FIFO;
> -		sp.sched_priority = RCU_KTHREAD_PRIO;
> -	} else {
> -		policy = SCHED_NORMAL;
> -		sp.sched_priority = 0;
> -	}
> -	sched_setscheduler_nocheck(t, policy, &sp);
> +	sp.sched_priority = RCU_KTHREAD_PRIO;
> +	sched_setscheduler_nocheck(current, SCHED_FIFO, &sp);
>  }
> 
> -/*
> - * Handle cases where the rcu_cpu_kthread() ends up on the wrong CPU.
> - * This can happen while the corresponding CPU is either coming online
> - * or going offline.  We cannot wait until the CPU is fully online
> - * before starting the kthread, because the various notifier functions
> - * can wait for RCU grace periods.  So we park rcu_cpu_kthread() until
> - * the corresponding CPU is online.
> - *
> - * Return 1 if the kthread needs to stop, 0 otherwise.
> - *
> - * Caller must disable bh.  This function can momentarily enable it.
> - */
> -static int rcu_cpu_kthread_should_stop(int cpu)
> +static void rcu_cpu_kthread_park(unsigned int cpu)
>  {
> -	while (cpu_is_offline(cpu) ||
> -	       !cpumask_equal(&current->cpus_allowed, cpumask_of(cpu)) ||
> -	       smp_processor_id() != cpu) {
> -		if (kthread_should_stop())
> -			return 1;
> -		per_cpu(rcu_cpu_kthread_status, cpu) = RCU_KTHREAD_OFFCPU;
> -		per_cpu(rcu_cpu_kthread_cpu, cpu) = raw_smp_processor_id();
> -		local_bh_enable();
> -		schedule_timeout_uninterruptible(1);
> -		if (!cpumask_equal(&current->cpus_allowed, cpumask_of(cpu)))
> -			set_cpus_allowed_ptr(current, cpumask_of(cpu));
> -		local_bh_disable();
> -	}
> -	per_cpu(rcu_cpu_kthread_cpu, cpu) = cpu;
> -	return 0;
> +	per_cpu(rcu_cpu_kthread_status, cpu) = RCU_KTHREAD_OFFCPU;
> +}
> +
> +static int rcu_cpu_kthread_should_run(unsigned int cpu)
> +{
> +	return __get_cpu_var(rcu_cpu_has_work);
>  }
> 
>  /*
> @@ -1526,96 +1471,35 @@ static int rcu_cpu_kthread_should_stop(i
>   * RCU softirq used in flavors and configurations of RCU that do not
>   * support RCU priority boosting.
>   */
> -static int rcu_cpu_kthread(void *arg)
> +static void rcu_cpu_kthread(unsigned int cpu)
>  {
> -	int cpu = (int)(long)arg;
> -	unsigned long flags;
> -	int spincnt = 0;
> -	unsigned int *statusp = &per_cpu(rcu_cpu_kthread_status, cpu);
> -	char work;
> -	char *workp = &per_cpu(rcu_cpu_has_work, cpu);
> +	unsigned int *statusp = &__get_cpu_var(rcu_cpu_kthread_status);
> +	char work, *workp = &__get_cpu_var(rcu_cpu_has_work);
> +	int spincnt;
> 
> -	trace_rcu_utilization("Start CPU kthread@init");
> -	for (;;) {
> -		*statusp = RCU_KTHREAD_WAITING;
> -		trace_rcu_utilization("End CPU kthread@rcu_wait");
> -		rcu_wait(*workp != 0 || kthread_should_stop());
> +	for (spincnt = 0; spincnt < 10; spincnt++) {
>  		trace_rcu_utilization("Start CPU kthread@rcu_wait");
>  		local_bh_disable();
> -		if (rcu_cpu_kthread_should_stop(cpu)) {
> -			local_bh_enable();
> -			break;
> -		}
>  		*statusp = RCU_KTHREAD_RUNNING;
> -		per_cpu(rcu_cpu_kthread_loops, cpu)++;
> -		local_irq_save(flags);
> +		this_cpu_inc(rcu_cpu_kthread_loops);
> +		local_irq_disable();
>  		work = *workp;
>  		*workp = 0;
> -		local_irq_restore(flags);
> +		local_irq_enable();
>  		if (work)
>  			rcu_kthread_do_work();
>  		local_bh_enable();
> -		if (*workp != 0)
> -			spincnt++;
> -		else
> -			spincnt = 0;
> -		if (spincnt > 10) {
> -			*statusp = RCU_KTHREAD_YIELDING;
> -			trace_rcu_utilization("End CPU kthread@rcu_yield");
> -			schedule_timeout_interruptible(2);
> -			trace_rcu_utilization("Start CPU kthread@rcu_yield");
> -			spincnt = 0;
> +		if (*workp == 0) {
> +			trace_rcu_utilization("End CPU kthread@rcu_wait");
> +			*statusp = RCU_KTHREAD_WAITING;
> +			return;
>  		}
>  	}
> -	*statusp = RCU_KTHREAD_STOPPED;
> -	trace_rcu_utilization("End CPU kthread@term");
> -	return 0;
> -}
> -
> -/*
> - * Spawn a per-CPU kthread, setting up affinity and priority.
> - * Because the CPU hotplug lock is held, no other CPU will be attempting
> - * to manipulate rcu_cpu_kthread_task.  There might be another CPU
> - * attempting to access it during boot, but the locking in kthread_bind()
> - * will enforce sufficient ordering.
> - *
> - * Please note that we cannot simply refuse to wake up the per-CPU
> - * kthread because kthreads are created in TASK_UNINTERRUPTIBLE state,
> - * which can result in softlockup complaints if the task ends up being
> - * idle for more than a couple of minutes.
> - *
> - * However, please note also that we cannot bind the per-CPU kthread to its
> - * CPU until that CPU is fully online.  We also cannot wait until the
> - * CPU is fully online before we create its per-CPU kthread, as this would
> - * deadlock the system when CPU notifiers tried waiting for grace
> - * periods.  So we bind the per-CPU kthread to its CPU only if the CPU
> - * is online.  If its CPU is not yet fully online, then the code in
> - * rcu_cpu_kthread() will wait until it is fully online, and then do
> - * the binding.
> - */
> -static int __cpuinit rcu_spawn_one_cpu_kthread(int cpu)
> -{
> -	struct sched_param sp;
> -	struct task_struct *t;
> -
> -	if (!rcu_scheduler_fully_active ||
> -	    per_cpu(rcu_cpu_kthread_task, cpu) != NULL)
> -		return 0;
> -	t = kthread_create_on_node(rcu_cpu_kthread,
> -				   (void *)(long)cpu,
> -				   cpu_to_node(cpu),
> -				   "rcuc/%d", cpu);
> -	if (IS_ERR(t))
> -		return PTR_ERR(t);
> -	if (cpu_online(cpu))
> -		kthread_bind(t, cpu);
> -	per_cpu(rcu_cpu_kthread_cpu, cpu) = cpu;
> -	WARN_ON_ONCE(per_cpu(rcu_cpu_kthread_task, cpu) != NULL);
> -	sp.sched_priority = RCU_KTHREAD_PRIO;
> -	sched_setscheduler_nocheck(t, SCHED_FIFO, &sp);
> -	per_cpu(rcu_cpu_kthread_task, cpu) = t;
> -	wake_up_process(t); /* Get to TASK_INTERRUPTIBLE quickly. */
> -	return 0;
> +	*statusp = RCU_KTHREAD_YIELDING;
> +	trace_rcu_utilization("Start CPU kthread@rcu_yield");
> +	schedule_timeout_interruptible(2);
> +	trace_rcu_utilization("End CPU kthread@rcu_yield");
> +	*statusp = RCU_KTHREAD_WAITING;
>  }
> 
>  /*
> @@ -1651,6 +1535,15 @@ static void rcu_boost_kthread_setaffinit
>  	free_cpumask_var(cm);
>  }
> 
> +static struct smp_hotplug_thread rcu_cpu_thread_spec = {
> +	.store			= &rcu_cpu_kthread_task,
> +	.thread_should_run	= rcu_cpu_kthread_should_run,
> +	.thread_fn		= rcu_cpu_kthread,
> +	.thread_comm		= "rcuc/%u",
> +	.setup			= rcu_cpu_kthread_setup,
> +	.park			= rcu_cpu_kthread_park,
> +};
> +
>  /*
>   * Spawn all kthreads -- called as soon as the scheduler is running.
>   */
> @@ -1660,11 +1553,9 @@ static int __init rcu_spawn_kthreads(voi
>  	int cpu;
> 
>  	rcu_scheduler_fully_active = 1;
> -	for_each_possible_cpu(cpu) {
> +	for_each_possible_cpu(cpu)
>  		per_cpu(rcu_cpu_has_work, cpu) = 0;
> -		if (cpu_online(cpu))
> -			(void)rcu_spawn_one_cpu_kthread(cpu);
> -	}
> +	BUG_ON(smpboot_register_percpu_thread(&rcu_cpu_thread_spec));
>  	rnp = rcu_get_root(rcu_state);
>  	(void)rcu_spawn_one_boost_kthread(rcu_state, rnp);
>  	if (NUM_RCU_NODES > 1) {
> @@ -1681,10 +1572,8 @@ static void __cpuinit rcu_prepare_kthrea
>  	struct rcu_node *rnp = rdp->mynode;
> 
>  	/* Fire up the incoming CPU's kthread and leaf rcu_node kthread. */
> -	if (rcu_scheduler_fully_active) {
> -		(void)rcu_spawn_one_cpu_kthread(cpu);
> +	if (rcu_scheduler_fully_active)
>  		(void)rcu_spawn_one_boost_kthread(rcu_state, rnp);
> -	}
>  }
> 
>  #else /* #ifdef CONFIG_RCU_BOOST */
> @@ -1708,22 +1597,10 @@ static void rcu_preempt_boost_start_gp(s
>  {
>  }
> 
> -#ifdef CONFIG_HOTPLUG_CPU
> -
> -static void rcu_stop_cpu_kthread(int cpu)
> -{
> -}
> -
> -#endif /* #ifdef CONFIG_HOTPLUG_CPU */
> -
>  static void rcu_boost_kthread_setaffinity(struct rcu_node *rnp, int outgoingcpu)
>  {
>  }
> 
> -static void rcu_cpu_kthread_setrt(int cpu, int to_rt)
> -{
> -}
> -
>  static int __init rcu_scheduler_really_started(void)
>  {
>  	rcu_scheduler_fully_active = 1;
> Index: tip/kernel/rcutree_trace.c
> ===================================================================
> --- tip.orig/kernel/rcutree_trace.c
> +++ tip/kernel/rcutree_trace.c
> @@ -83,11 +83,10 @@ static void print_one_rcu_data(struct se
>  			rdp->nxttail[RCU_WAIT_TAIL]],
>  		   ".D"[&rdp->nxtlist != rdp->nxttail[RCU_DONE_TAIL]]);
>  #ifdef CONFIG_RCU_BOOST
> -	seq_printf(m, " kt=%d/%c/%d ktl=%x",
> +	seq_printf(m, " kt=%d/%c ktl=%x",
>  		   per_cpu(rcu_cpu_has_work, rdp->cpu),
>  		   convert_kthread_status(per_cpu(rcu_cpu_kthread_status,
>  					  rdp->cpu)),
> -		   per_cpu(rcu_cpu_kthread_cpu, rdp->cpu),
>  		   per_cpu(rcu_cpu_kthread_loops, rdp->cpu) & 0xffff);
>  #endif /* #ifdef CONFIG_RCU_BOOST */
>  	seq_printf(m, " b=%ld", rdp->blimit);
> 
> 

