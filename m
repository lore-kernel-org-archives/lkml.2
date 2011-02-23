Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932198Ab1BWQxN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Feb 2011 11:53:13 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:62260 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755134Ab1BWQxM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Feb 2011 11:53:12 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=OnRs0+Cxu6ooynxonOF8COz8Ji0lmNFTb+iB8eIgAXoDlG98y01pb3P7g3FXmbPb8o
         TdRfZa9WKgvFOGAToFaw+hxg6/CeOrkMGYrC60qFoShjDY9wZSZEhep5tQLwxiKSJQc+
         Y/YnWWCOCQ5+4pRMDdrKqpXujy5coTO8ahu2g=
Date: Wed, 23 Feb 2011 17:50:46 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@polymtl.ca, josh@joshtriplett.org, niv@us.ibm.com,
        tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
        Valdis.Kletnieks@vt.edu, dhowells@redhat.com, eric.dumazet@gmail.com,
        darren@dvhart.com, "Paul E. McKenney" <paul.mckenney@linaro.org>
Subject: Re: [PATCH RFC tip/core/rcu 11/11] rcu: move TREE_RCU from softirq
 to kthread
Message-ID: <20110223165043.GA2529@nowhere>
References: <20110223013917.GA20996@linux.vnet.ibm.com>
 <1298425183-21265-11-git-send-email-paulmck@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1298425183-21265-11-git-send-email-paulmck@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 22, 2011 at 05:39:40PM -0800, Paul E. McKenney wrote:
> +}
> +
> +/*
> + * Drop to non-real-time priority and yield, but only after posting a
> + * timer that will cause us to regain our real-time priority if we
> + * remain preempted.  Either way, we restore our real-time priority
> + * before returning.
> + */
> +static void rcu_yield(int cpu)
> +{
> +	struct rcu_data *rdp = per_cpu_ptr(rcu_sched_state.rda, cpu);
> +	struct sched_param sp;
> +	struct timer_list yield_timer;
> +
> +	setup_timer(&yield_timer, rcu_cpu_kthread_timer, (unsigned long)rdp);
> +	mod_timer(&yield_timer, jiffies + 2);
> +	sp.sched_priority = 0;
> +	sched_setscheduler_nocheck(current, SCHED_NORMAL, &sp);
> +	schedule();
> +	sp.sched_priority = RCU_KTHREAD_PRIO;
> +	sched_setscheduler_nocheck(current, SCHED_FIFO, &sp);
> +	del_timer(&yield_timer);
> +}
> +
> +/*
> + * Handle cases where the rcu_cpu_kthread() ends up on the wrong CPU.
> + * This can happen while the corresponding CPU is either coming online
> + * or going offline.  We cannot wait until the CPU is fully online
> + * before starting the kthread, because the various notifier functions
> + * can wait for RCU grace periods.  So we park rcu_cpu_kthread() until
> + * the corresponding CPU is online.
> + *
> + * Return 1 if the kthread needs to stop, 0 otherwise.
> + *
> + * Caller must disable bh.  This function can momentarily enable it.
> + */
> +static int rcu_cpu_kthread_should_stop(int cpu)
> +{
> +	while (cpu_is_offline(cpu) || smp_processor_id() != cpu) {
> +		if (kthread_should_stop())
> +			return 1;
> +		local_bh_enable();
> +		schedule_timeout_uninterruptible(1);

Why is it uninterruptible? Well that doesn't change much anyway.
It can be a problem for long time sleeping kernel threads because of
the hung task detector, but certainly not for 1 jiffy.

> +		if (smp_processor_id() != cpu)
> +			set_cpus_allowed_ptr(current, cpumask_of(cpu));
> +		local_bh_disable();
> +	}
> +	return 0;
> +}
> +
> +/*
> + * Per-CPU kernel thread that invokes RCU callbacks.  This replaces the
> + * earlier RCU softirq.
> + */
> +static int rcu_cpu_kthread(void *arg)
> +{
> +	int cpu = (int)(long)arg;
> +	unsigned long flags;
> +	int spincnt = 0;
> +	wait_queue_head_t *wqp = &per_cpu(rcu_cpu_wq, cpu);
> +	char work;
> +	char *workp = &per_cpu(rcu_cpu_has_work, cpu);
> +
> +	for (;;) {
> +		wait_event_interruptible(*wqp,
> +					 *workp != 0 || kthread_should_stop());
> +		local_bh_disable();
> +		if (rcu_cpu_kthread_should_stop(cpu)) {
> +			local_bh_enable();
> +			break;
> +		}
> +		local_irq_save(flags);
> +		work = *workp;
> +		*workp = 0;
> +		local_irq_restore(flags);
> +		if (work)
> +			rcu_process_callbacks();
> +		local_bh_enable();
> +		if (*workp != 0)
> +			spincnt++;
> +		else
> +			spincnt = 0;
> +		if (spincnt > 10) {
> +			rcu_yield(cpu);
> +			spincnt = 0;
> +		}
> +	}
> +	return 0;
> +}
> +
> +/*
> + * Per-rcu_node kthread, which is in charge of waking up the per-CPU
> + * kthreads when needed.
> + */
> +static int rcu_node_kthread(void *arg)
> +{
> +	int cpu;
> +	unsigned long flags;
> +	unsigned long mask;
> +	struct rcu_node *rnp = (struct rcu_node *)arg;
> +	struct sched_param sp;
> +	struct task_struct *t;
> +
> +	for (;;) {
> +		wait_event_interruptible(rnp->node_wq, rnp->wakemask != 0 ||
> +						       kthread_should_stop());
> +		if (kthread_should_stop())
> +			break;
> +		raw_spin_lock_irqsave(&rnp->lock, flags);
> +		mask = rnp->wakemask;
> +		rnp->wakemask = 0;
> +		raw_spin_unlock_irqrestore(&rnp->lock, flags);
> +		for (cpu = rnp->grplo; cpu <= rnp->grphi; cpu++, mask <<= 1) {
> +			if ((mask & 0x1) == 0)
> +				continue;
> +			preempt_disable();
> +			per_cpu(rcu_cpu_has_work, cpu) = 1;
> +			t = per_cpu(rcu_cpu_kthread_task, cpu);
> +			if (t == NULL) {
> +				preempt_enable();
> +				continue;
> +			}
> +			sp.sched_priority = RCU_KTHREAD_PRIO;
> +			sched_setscheduler_nocheck(t, cpu, &sp);
> +			wake_up_process(t);

My (mis?)understanding of the picture is this node kthread is there to
wake up cpu threads that called rcu_yield(). But actually rcu_yield()
doesn't make the cpu thread sleeping, instead it switches to SCHED_NORMAL,
to avoid starving the system with callbacks.

So I wonder if this wake_up_process() is actually relevant.
sched_setscheduler_nocheck() already handles the per sched policy rq migration
and the process is not sleeping.

That said, by the time the process may have gone to sleep, because if no other
SCHED_NORMAL task was there, it has just continued and may have flushed
every callbacks. So this wake_up_process() may actually wake up the task
but it will sleep again right away due to the condition in wait_event_interruptible()
of the cpu thread.

Right?

> +			preempt_enable();
> +		}
> +	}
> +	return 0;
> +}
