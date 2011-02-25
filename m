Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933005Ab1BYUc3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Feb 2011 15:32:29 -0500
Received: from e34.co.us.ibm.com ([32.97.110.152]:40602 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932957Ab1BYUc1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Feb 2011 15:32:27 -0500
Date: Fri, 25 Feb 2011 12:32:19 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        "Paul E. McKenney" <paul.mckenney@linaro.org>
Subject: Re: [PATCH RFC tip/core/rcu 11/11] rcu: move TREE_RCU from softirq
 to kthread
Message-ID: <20110225203219.GD2269@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20110223013917.GA20996@linux.vnet.ibm.com>
 <1298425183-21265-11-git-send-email-paulmck@linux.vnet.ibm.com>
 <4D6765B6.1030401@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D6765B6.1030401@cn.fujitsu.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 25, 2011 at 04:17:58PM +0800, Lai Jiangshan wrote:
> On 02/23/2011 09:39 AM, Paul E. McKenney wrote:
> > From: Paul E. McKenney <paul.mckenney@linaro.org>
> > 
> > If RCU priority boosting is to be meaningful, callback invocation must
> > be boosted in addition to preempted RCU readers.  Otherwise, in presence
> > of CPU real-time threads, the grace period ends, but the callbacks don't
> > get invoked.  If the callbacks don't get invoked, the associated memory
> > doesn't get freed, so the system is still subject to OOM.
> > 
> > But it is not reasonable to priority-boost RCU_SOFTIRQ, so this commit
> > moves the callback invocations to a kthread, which can be boosted easily.
> > 
> > Signed-off-by: Paul E. McKenney <paul.mckenney@linaro.org>
> > Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> > ---
> >  include/linux/interrupt.h           |    1 -
> >  include/trace/events/irq.h          |    3 +-
> >  kernel/rcutree.c                    |  324 ++++++++++++++++++++++++++++++++++-
> >  kernel/rcutree.h                    |    8 +
> >  kernel/rcutree_plugin.h             |    4 +-
> >  tools/perf/util/trace-event-parse.c |    1 -
> >  6 files changed, 331 insertions(+), 10 deletions(-)
> > 
> > diff --git a/include/linux/interrupt.h b/include/linux/interrupt.h
> > index 79d0c4f..ed47deb 100644
> > --- a/include/linux/interrupt.h
> > +++ b/include/linux/interrupt.h
> > @@ -385,7 +385,6 @@ enum
> >  	TASKLET_SOFTIRQ,
> >  	SCHED_SOFTIRQ,
> >  	HRTIMER_SOFTIRQ,
> > -	RCU_SOFTIRQ,	/* Preferable RCU should always be the last softirq */
> >  
> >  	NR_SOFTIRQS
> >  };
> > diff --git a/include/trace/events/irq.h b/include/trace/events/irq.h
> > index 1c09820..ae045ca 100644
> > --- a/include/trace/events/irq.h
> > +++ b/include/trace/events/irq.h
> > @@ -20,8 +20,7 @@ struct softirq_action;
> >  			 softirq_name(BLOCK_IOPOLL),	\
> >  			 softirq_name(TASKLET),		\
> >  			 softirq_name(SCHED),		\
> > -			 softirq_name(HRTIMER),		\
> > -			 softirq_name(RCU))
> > +			 softirq_name(HRTIMER))
> >  
> >  /**
> >   * irq_handler_entry - called immediately before the irq action handler
> > diff --git a/kernel/rcutree.c b/kernel/rcutree.c
> > index 0ac1cc0..2241f28 100644
> > --- a/kernel/rcutree.c
> > +++ b/kernel/rcutree.c
> > @@ -47,6 +47,8 @@
> >  #include <linux/mutex.h>
> >  #include <linux/time.h>
> >  #include <linux/kernel_stat.h>
> > +#include <linux/wait.h>
> > +#include <linux/kthread.h>
> >  
> >  #include "rcutree.h"
> >  
> > @@ -82,6 +84,18 @@ DEFINE_PER_CPU(struct rcu_data, rcu_bh_data);
> >  int rcu_scheduler_active __read_mostly;
> >  EXPORT_SYMBOL_GPL(rcu_scheduler_active);
> >  
> > +/* Control variables for per-CPU and per-rcu_node kthreads. */
> 
> I think "per-leaf-rcu_node" is better. It seems that only the leaf rcu_node
> of rcu_sched are used for rcu_node kthreads and they also serve for
> other rcu domains(rcu_bh, rcu_preempt)? I think we need to add some
> comments for it.

There is a per-root_rcu_node kthread that is added with priority boosting.

Good point on the scope of the kthreads.  I have changed the above
comment to read:

/*
 * Control variables for per-CPU and per-rcu_node kthreads.  These
 * handle all flavors of RCU.
 */

Seem reasonable?

> > +/*
> > + * Timer handler to initiate the waking up of per-CPU kthreads that
> > + * have yielded the CPU due to excess numbers of RCU callbacks.
> > + */
> > +static void rcu_cpu_kthread_timer(unsigned long arg)
> > +{
> > +	unsigned long flags;
> > +	struct rcu_data *rdp = (struct rcu_data *)arg;
> > +	struct rcu_node *rnp = rdp->mynode;
> > +	struct task_struct *t;
> > +
> > +	raw_spin_lock_irqsave(&rnp->lock, flags);
> > +	rnp->wakemask |= rdp->grpmask;
> 
> I think there is no reason that the rnp->lock also protects the
> rnp->node_kthread_task. "raw_spin_unlock_irqrestore(&rnp->lock, flags);"
> can be moved up here.

If I am not too confused, the lock needs to cover the statements below
in order to correctly handle races with concurrent CPU-hotplug operations.

> > +	t = rnp->node_kthread_task;
> > +	if (t == NULL) {
> > +		raw_spin_unlock_irqrestore(&rnp->lock, flags);
> > +		return;
> > +	}
> > +	wake_up_process(t);
> > +	raw_spin_unlock_irqrestore(&rnp->lock, flags);
> > +}
> > +
> > +/*
> > + * Drop to non-real-time priority and yield, but only after posting a
> > + * timer that will cause us to regain our real-time priority if we
> > + * remain preempted.  Either way, we restore our real-time priority
> > + * before returning.
> > + */
> > +static void rcu_yield(int cpu)
> > +{
> > +	struct rcu_data *rdp = per_cpu_ptr(rcu_sched_state.rda, cpu);
> > +	struct sched_param sp;
> > +	struct timer_list yield_timer;
> > +
> > +	setup_timer(&yield_timer, rcu_cpu_kthread_timer, (unsigned long)rdp);
> > +	mod_timer(&yield_timer, jiffies + 2);
> > +	sp.sched_priority = 0;
> > +	sched_setscheduler_nocheck(current, SCHED_NORMAL, &sp);
> > +	schedule();
> > +	sp.sched_priority = RCU_KTHREAD_PRIO;
> > +	sched_setscheduler_nocheck(current, SCHED_FIFO, &sp);
> > +	del_timer(&yield_timer);
> > +}
> > +
> > +/*
> > + * Handle cases where the rcu_cpu_kthread() ends up on the wrong CPU.
> > + * This can happen while the corresponding CPU is either coming online
> > + * or going offline.  We cannot wait until the CPU is fully online
> > + * before starting the kthread, because the various notifier functions
> > + * can wait for RCU grace periods.  So we park rcu_cpu_kthread() until
> > + * the corresponding CPU is online.
> > + *
> > + * Return 1 if the kthread needs to stop, 0 otherwise.
> > + *
> > + * Caller must disable bh.  This function can momentarily enable it.
> > + */
> > +static int rcu_cpu_kthread_should_stop(int cpu)
> > +{
> > +	while (cpu_is_offline(cpu) || smp_processor_id() != cpu) {
> > +		if (kthread_should_stop())
> > +			return 1;
> > +		local_bh_enable();
> > +		schedule_timeout_uninterruptible(1);
> > +		if (smp_processor_id() != cpu)
> > +			set_cpus_allowed_ptr(current, cpumask_of(cpu));
> 
> The current task is PF_THREAD_BOUND,
> Why do "set_cpus_allowed_ptr(current, cpumask_of(cpu));" ?

Because I have seen CPU hotplug operations unbind PF_THREAD_BOUND threads.
In addition, I end up having to spawn the kthread at CPU_UP_PREPARE time,
at which point the thread must run unbound because its CPU isn't online
yet.  I cannot invoke kthread_create() within the stop-machine handler
(right?).  I cannot wait until CPU_ONLINE time because that results in
hangs when other CPU notifiers wait for grace periods.

Yes, I did find out about the hangs the hard way.  Why do you ask?  ;-)

Please feel free to suggest improvements in the header comment above
for rcu_cpu_kthread_should_stop(), which is my apparently insufficient
attempt to explain this.

> > +		local_bh_disable();
> > +	}
> > +	return 0;
> > +}
> > +
> > +/*
> > + * Per-CPU kernel thread that invokes RCU callbacks.  This replaces the
> > + * earlier RCU softirq.
> > + */
> > +static int rcu_cpu_kthread(void *arg)
> > +{
> > +	int cpu = (int)(long)arg;
> > +	unsigned long flags;
> > +	int spincnt = 0;
> > +	wait_queue_head_t *wqp = &per_cpu(rcu_cpu_wq, cpu);
> > +	char work;
> > +	char *workp = &per_cpu(rcu_cpu_has_work, cpu);
> > +
> > +	for (;;) {
> > +		wait_event_interruptible(*wqp,
> > +					 *workp != 0 || kthread_should_stop());
> > +		local_bh_disable();
> > +		if (rcu_cpu_kthread_should_stop(cpu)) {
> > +			local_bh_enable();
> > +			break;
> > +		}
> > +		local_irq_save(flags);
> > +		work = *workp;
> > +		*workp = 0;
> > +		local_irq_restore(flags);
> > +		if (work)
> > +			rcu_process_callbacks();
> > +		local_bh_enable();
> > +		if (*workp != 0)
> > +			spincnt++;
> > +		else
> > +			spincnt = 0;
> > +		if (spincnt > 10) {
> 
> "10" is a magic number here.

It is indeed.  Suggestions for a cpp macro name to hide it behind?

> > +			rcu_yield(cpu);
> > +			spincnt = 0;
> > +		}
> > +	}
> > +	return 0;
> > +}
> > +
> 
> 
> > +/*
> > + * Per-rcu_node kthread, which is in charge of waking up the per-CPU
> > + * kthreads when needed.
> > + */
> > +static int rcu_node_kthread(void *arg)
> > +{
> > +	int cpu;
> > +	unsigned long flags;
> > +	unsigned long mask;
> > +	struct rcu_node *rnp = (struct rcu_node *)arg;
> > +	struct sched_param sp;
> > +	struct task_struct *t;
> > +
> > +	for (;;) {
> > +		wait_event_interruptible(rnp->node_wq, rnp->wakemask != 0 ||
> > +						       kthread_should_stop());
> > +		if (kthread_should_stop())
> > +			break;
> > +		raw_spin_lock_irqsave(&rnp->lock, flags);
> > +		mask = rnp->wakemask;
> > +		rnp->wakemask = 0;
> > +		raw_spin_unlock_irqrestore(&rnp->lock, flags);
> > +		for (cpu = rnp->grplo; cpu <= rnp->grphi; cpu++, mask <<= 1) {
> > +			if ((mask & 0x1) == 0)
> > +				continue;
> > +			preempt_disable();
> > +			per_cpu(rcu_cpu_has_work, cpu) = 1;
> > +			t = per_cpu(rcu_cpu_kthread_task, cpu);
> > +			if (t == NULL) {
> > +				preempt_enable();
> > +				continue;
> > +			}
> 
> Obviously preempt_disable() is not for protecting remote percpu data.
> Is it for disabling cpu hotplug? I am afraid the @t may leave
> and become invalid.

Indeed, acquiring the rnp->lock is safer, except that I don't trust
calling sched_setscheduler_nocheck() in that state.  So I need to check
for the CPU being online after the preempt_disable().  This means that
I ignore requests to do work after CPU_DYING time, but that is OK because
force_quiescent_state() will figure out that the CPU is in fact offline.

Make sense?

In any case, good catch!!!

							Thanx, Paul
