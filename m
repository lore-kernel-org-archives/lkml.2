Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753994Ab1FNUut (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jun 2011 16:50:49 -0400
Received: from e8.ny.us.ibm.com ([32.97.182.138]:44086 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751074Ab1FNUuq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jun 2011 16:50:46 -0400
Date: Tue, 14 Jun 2011 13:50:42 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Shaohua Li <shaohua.li@intel.com>
Cc: Ingo Molnar <mingo@elte.hu>, lkml <linux-kernel@vger.kernel.org>,
        "Chen, Tim C" <tim.c.chen@intel.com>, "Shi, Alex" <alex.shi@intel.com>
Subject: Re: rcu: performance regression
Message-ID: <20110614205042.GA3826@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <1308029185.15392.147.camel@sli10-conroe>
 <20110614124323.GC2264@linux.vnet.ibm.com>
 <20110614164804.GA613@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110614164804.GA613@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 14, 2011 at 09:48:04AM -0700, Paul E. McKenney wrote:
> On Tue, Jun 14, 2011 at 05:43:23AM -0700, Paul E. McKenney wrote:
> > On Tue, Jun 14, 2011 at 01:26:25PM +0800, Shaohua Li wrote:
> > > Commit a26ac2455ffcf3(rcu: move TREE_RCU from softirq to kthread)
> > > introduced performance regression. In our AIM7 test, this commit caused
> > > about 40% regression.
> > > The commit runs rcu callbacks in a kthread instead of softirq. We
> > > observed high rate of context switch which is caused by this. Out test
> > > system has 64 CPUs and HZ is 1000, so we saw more than 64k context
> > > switch per second which is caused by the rcu thread.
> > > I also did trace and found when rcy thread is woken up, most time the
> > > thread doesn't handle any callbacks actually, it just initializes new gp
> > > or end one gp or similar.
> > > >From my understanding, the purpose to make rcu runs in kthread is to
> > > speed up rcu callbacks run (with help of rtmutex PI), not for end gp and
> > > so on, which runs pretty fast actually and doesn't need boost.
> > > To verify my findings, I had below debug patch applied. It still handles
> > > rcu callbacks in kthread if there is any pending callbacks, but other
> > > things are still running in softirq. this completely solved our
> > > regression. I thought this can still boost callbacks run. but I'm not
> > > expert in the area, so please help.
> > 
> > Hello, Shaohua,
> > 
> > Could you please try the following patch?  In the meantime, I will
> > also look over the patch that you sent.
> 
> OK, your patch looks quite good!  And I appear to have left off the
> patch from my earlier email, which is just as well, as I don't think
> it would help.  I am now testing your patch, and if it passes, I
> will push it to Ingo for inclusion in 3.0.
> 
> I found the following issues with the patch, one of which I fixed
> and the others of which are not critical:
> 
> o	rcu_check_callbacks() still calls invoke_rcu_cpu_kthread(),
> 	which would only invoke callbacks, and would fail to advance the
> 	grace period.  I updated the commit so that rcu_check_callbacks()
> 	calls __invoke_rcu_cpu_kthread() instead, so please let me know
> 	if you see a problem with this.

And this was completely bogus, adding some force to my comment below
about naming of functions.

Please ignore the patch below.

							Thanx, Paul

> o	At least one of my later commits need adjustment, which I will
> 	take care of.  Not a big deal.
> 
> o	The -rt patchset moves softirq processing to kthread context,
> 	so this patch will not help -rt run efficiently on 64-CPU
> 	systems.  But that is a problem for another day, even assuming
> 	that people do want to run -rt on 64-CPU systems.
> 
> o	This change invalidates some of my design for merging SRCU into
> 	TREE_PREEMPT_RCU, but that will be my problem to solve.  Probably
> 	won't be that hard to fix.  (Famous last words...)
> 
> o	Some other softirq could have lots of work, which would push
> 	processing to ksoftirqd, which cannot reasonably be priority
> 	boosted, which in turn could defeat RCU priority boosting.
> 	However, by keeping callback processing in kthread context, a
> 	major source of softirq work has been eliminated in comparison
> 	with 2.6.39.  So while I don't particularly like this, it seems
> 	a lot better than bottlenecking in the scheduler.
> 
> 	Longer term, this problem will be fixed once threaded softirqs
> 	hit mainline.
> 
> o	I will fix the function naming for 3.1 to something like
> 	invoke_rcu_core() instead of __invoke_rcu_kthread().  However,
> 	this clearly is not a critical problem, and any attempt to fix
> 	the naming right now would increase both the size of the patch
> 	and the chances of error.
> 
> So if the attached patch still addresses the performance regressions
> seen by Shaohua and Alex, I will push it.
> 
> 							Thanx, Paul
> 
> PS.  I added your "Signed-off-by".  Please let me know if there is
>      any problem with my doing that.
> 
> ------------------------------------------------------------------------
> 
> rcu: Use softirq to address performance regression
> 
> Commit a26ac2455ffcf3(rcu: move TREE_RCU from softirq to kthread)
> introduced performance regression. In an AIM7 test, this commit degraded
> performance by about 40%.
> 
> The commit runs rcu callbacks in a kthread instead of softirq. We observed
> high rate of context switch which is caused by this. Out test system has
> 64 CPUs and HZ is 1000, so we saw more than 64k context switch per second
> which is caused by RCU's per-CPU kthread.  A trace showed that most of
> the time the RCU per-CPU kthread doesn't actually handle any callbacks,
> but instead just does a very small amount of work handling grace periods.
> This means that RCU's per-CPU kthreads are making the scheduler do quite
> a bit of work in order to allow a very small amount of RCU-related
> processing to be done.
> 
> Alex Shi's analysis determined that this slowdown is due to lock
> contention within the scheduler.  Unfortunately, the scheduler's real-time
> semantics require global action, which means that this contention is
> inherent in real-time scheduling.  (Yes, perhaps someone will come up
> with a workaround -- otherwise, -rt is not going to do well on large SMP
> systems -- but this patch will work around this issue in the meantime.
> And "the meantime" might well be forever.)
> 
> This patch therefore re-introduces softirq processing to RCU, but only
> for core RCU work.  RCU callbacks are still executed in kthread context,
> so that only a small amount of RCU work runs in softirq context in the
> common case.  This should minimize ksoftirqd execution, allowing us to
> skip boosting of ksoftirqd for CONFIG_RCU_BOOST=y kernels.
> 
> Signed-off-by: Shaohua Li <shaohua.li@intel.com>
> Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> 
> diff --git a/Documentation/filesystems/proc.txt b/Documentation/filesystems/proc.txt
> index f481780..db3b1ab 100644
> --- a/Documentation/filesystems/proc.txt
> +++ b/Documentation/filesystems/proc.txt
> @@ -843,6 +843,7 @@ Provides counts of softirq handlers serviced since boot time, for each cpu.
>   TASKLET:          0          0          0        290
>     SCHED:      27035      26983      26971      26746
>   HRTIMER:          0          0          0          0
> +     RCU:       1678       1769       2178       2250
>  
>  
>  1.3 IDE devices in /proc/ide
> diff --git a/include/linux/interrupt.h b/include/linux/interrupt.h
> index 6c12989..f6efed0 100644
> --- a/include/linux/interrupt.h
> +++ b/include/linux/interrupt.h
> @@ -414,6 +414,7 @@ enum
>  	TASKLET_SOFTIRQ,
>  	SCHED_SOFTIRQ,
>  	HRTIMER_SOFTIRQ,
> +	RCU_SOFTIRQ,    /* Preferable RCU should always be the last softirq */
>  
>  	NR_SOFTIRQS
>  };
> diff --git a/include/trace/events/irq.h b/include/trace/events/irq.h
> index ae045ca..1c09820 100644
> --- a/include/trace/events/irq.h
> +++ b/include/trace/events/irq.h
> @@ -20,7 +20,8 @@ struct softirq_action;
>  			 softirq_name(BLOCK_IOPOLL),	\
>  			 softirq_name(TASKLET),		\
>  			 softirq_name(SCHED),		\
> -			 softirq_name(HRTIMER))
> +			 softirq_name(HRTIMER),		\
> +			 softirq_name(RCU))
>  
>  /**
>   * irq_handler_entry - called immediately before the irq action handler
> diff --git a/kernel/rcutree.c b/kernel/rcutree.c
> index 5d6b845..ed9dadd 100644
> --- a/kernel/rcutree.c
> +++ b/kernel/rcutree.c
> @@ -100,6 +100,7 @@ static char rcu_kthreads_spawnable;
>  
>  static void rcu_node_kthread_setaffinity(struct rcu_node *rnp, int outgoingcpu);
>  static void invoke_rcu_cpu_kthread(void);
> +static void __invoke_rcu_cpu_kthread(void);
>  
>  #define RCU_KTHREAD_PRIO 1	/* RT priority for per-CPU kthreads. */
>  
> @@ -1330,7 +1331,7 @@ void rcu_check_callbacks(int cpu, int user)
>  	}
>  	rcu_preempt_check_callbacks(cpu);
>  	if (rcu_pending(cpu))
> -		invoke_rcu_cpu_kthread();
> +		__invoke_rcu_cpu_kthread();
>  }
>  
>  #ifdef CONFIG_SMP
> @@ -1495,13 +1496,21 @@ __rcu_process_callbacks(struct rcu_state *rsp, struct rcu_data *rdp)
>  	}
>  
>  	/* If there are callbacks ready, invoke them. */
> -	rcu_do_batch(rsp, rdp);
> +	if (cpu_has_callbacks_ready_to_invoke(rdp))
> +		__invoke_rcu_cpu_kthread();
> +}
> +
> +static void rcu_kthread_do_work(void)
> +{
> +	rcu_do_batch(&rcu_sched_state, &__get_cpu_var(rcu_sched_data));
> +	rcu_do_batch(&rcu_bh_state, &__get_cpu_var(rcu_bh_data));
> +	rcu_preempt_do_callbacks();
>  }
>  
>  /*
>   * Do softirq processing for the current CPU.
>   */
> -static void rcu_process_callbacks(void)
> +static void rcu_process_callbacks(struct softirq_action *unused)
>  {
>  	__rcu_process_callbacks(&rcu_sched_state,
>  				&__get_cpu_var(rcu_sched_data));
> @@ -1518,7 +1527,7 @@ static void rcu_process_callbacks(void)
>   * the current CPU with interrupts disabled, the rcu_cpu_kthread_task
>   * cannot disappear out from under us.
>   */
> -static void invoke_rcu_cpu_kthread(void)
> +static void __invoke_rcu_cpu_kthread(void)
>  {
>  	unsigned long flags;
>  
> @@ -1530,6 +1539,11 @@ static void invoke_rcu_cpu_kthread(void)
>  	local_irq_restore(flags);
>  }
>  
> +static void invoke_rcu_cpu_kthread(void)
> +{
> +	raise_softirq(RCU_SOFTIRQ);
> +}
> +
>  /*
>   * Wake up the specified per-rcu_node-structure kthread.
>   * Because the per-rcu_node kthreads are immortal, we don't need
> @@ -1664,7 +1678,7 @@ static int rcu_cpu_kthread(void *arg)
>  		*workp = 0;
>  		local_irq_restore(flags);
>  		if (work)
> -			rcu_process_callbacks();
> +			rcu_kthread_do_work();
>  		local_bh_enable();
>  		if (*workp != 0)
>  			spincnt++;
> @@ -2423,6 +2437,7 @@ void __init rcu_init(void)
>  	rcu_init_one(&rcu_sched_state, &rcu_sched_data);
>  	rcu_init_one(&rcu_bh_state, &rcu_bh_data);
>  	__rcu_init_preempt();
> +	 open_softirq(RCU_SOFTIRQ, rcu_process_callbacks);
>  
>  	/*
>  	 * We don't need protection against CPU-hotplug here because
> diff --git a/kernel/rcutree.h b/kernel/rcutree.h
> index 4238f63..eb57b94 100644
> --- a/kernel/rcutree.h
> +++ b/kernel/rcutree.h
> @@ -443,6 +443,7 @@ static void rcu_preempt_offline_cpu(int cpu);
>  #endif /* #ifdef CONFIG_HOTPLUG_CPU */
>  static void rcu_preempt_check_callbacks(int cpu);
>  static void rcu_preempt_process_callbacks(void);
> +static void rcu_preempt_do_callbacks(void);
>  void call_rcu(struct rcu_head *head, void (*func)(struct rcu_head *rcu));
>  #if defined(CONFIG_HOTPLUG_CPU) || defined(CONFIG_TREE_PREEMPT_RCU)
>  static void rcu_report_exp_rnp(struct rcu_state *rsp, struct rcu_node *rnp);
> diff --git a/kernel/rcutree_plugin.h b/kernel/rcutree_plugin.h
> index 37caa15..b1cdc21 100644
> --- a/kernel/rcutree_plugin.h
> +++ b/kernel/rcutree_plugin.h
> @@ -602,6 +602,11 @@ static void rcu_preempt_process_callbacks(void)
>  				&__get_cpu_var(rcu_preempt_data));
>  }
>  
> +static void rcu_preempt_do_callbacks(void)
> +{
> +	rcu_do_batch(&rcu_preempt_state, &__get_cpu_var(rcu_preempt_data));
> +}
> +
>  /*
>   * Queue a preemptible-RCU callback for invocation after a grace period.
>   */
> @@ -988,6 +993,10 @@ static void rcu_preempt_process_callbacks(void)
>  {
>  }
>  
> +static void rcu_preempt_do_callbacks(void)
> +{
> +}
> +
>  /*
>   * Wait for an rcu-preempt grace period, but make it happen quickly.
>   * But because preemptible RCU does not exist, map to rcu-sched.
> diff --git a/kernel/softirq.c b/kernel/softirq.c
> index 1396017..40cf63d 100644
> --- a/kernel/softirq.c
> +++ b/kernel/softirq.c
> @@ -58,7 +58,7 @@ DEFINE_PER_CPU(struct task_struct *, ksoftirqd);
>  
>  char *softirq_to_name[NR_SOFTIRQS] = {
>  	"HI", "TIMER", "NET_TX", "NET_RX", "BLOCK", "BLOCK_IOPOLL",
> -	"TASKLET", "SCHED", "HRTIMER"
> +	"TASKLET", "SCHED", "HRTIMER", "RCU"
>  };
>  
>  /*
> diff --git a/tools/perf/util/trace-event-parse.c b/tools/perf/util/trace-event-parse.c
> index 1e88485..0a7ed5b 100644
> --- a/tools/perf/util/trace-event-parse.c
> +++ b/tools/perf/util/trace-event-parse.c
> @@ -2187,6 +2187,7 @@ static const struct flag flags[] = {
>  	{ "TASKLET_SOFTIRQ", 6 },
>  	{ "SCHED_SOFTIRQ", 7 },
>  	{ "HRTIMER_SOFTIRQ", 8 },
> +	{ "RCU_SOFTIRQ", 9 },
>  
>  	{ "HRTIMER_NORESTART", 0 },
>  	{ "HRTIMER_RESTART", 1 },
