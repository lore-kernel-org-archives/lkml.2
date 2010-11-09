Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753986Ab0KIJR5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Nov 2010 04:17:57 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:59548 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753886Ab0KIJRu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Nov 2010 04:17:50 -0500
Message-ID: <4CD912E9.1080907@cn.fujitsu.com>
Date: Tue, 09 Nov 2010 17:22:49 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.9) Gecko/20100423 Thunderbird/3.0.4
MIME-Version: 1.0
To: Joe Korty <joe.korty@ccur.com>
CC: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, fweisbec@gmail.com,
        mathieu.desnoyers@efficios.com, dhowells@redhat.com,
        loic.minier@linaro.org, dhaval.giani@gmail.com, tglx@linutronix.de,
        peterz@infradead.org, linux-kernel@vger.kernel.org,
        josh@joshtriplett.org, houston.jim@comcast.net,
        Lai Jiangshan <laijs@cn.fujitsu.com>
Subject: Re: [PATCH] a local-timer-free version of RCU
References: <20101104232148.GA28037@linux.vnet.ibm.com> <20101105210059.GA27317@tsunami.ccur.com>
In-Reply-To: <20101105210059.GA27317@tsunami.ccur.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2010-11-09 17:18:16,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2010-11-09 17:18:16,
	Serialize complete at 2010-11-09 17:18:16
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sat, Nov 6, 2010 at 5:00 AM, Joe Korty <joe.korty@ccur.com> wrote:
> +}
> +
> +/**
> + * rcu_read_lock - mark the beginning of an RCU read-side critical section.
> + *
> + * When synchronize_rcu() is invoked on one CPU while other CPUs
> + * are within RCU read-side critical sections, then the
> + * synchronize_rcu() is guaranteed to block until after all the other
> + * CPUs exit their critical sections.  Similarly, if call_rcu() is invoked
> + * on one CPU while other CPUs are within RCU read-side critical
> + * sections, invocation of the corresponding RCU callback is deferred
> + * until after the all the other CPUs exit their critical sections.
> + *
> + * Note, however, that RCU callbacks are permitted to run concurrently
> + * with RCU read-side critical sections.  One way that this can happen
> + * is via the following sequence of events: (1) CPU 0 enters an RCU
> + * read-side critical section, (2) CPU 1 invokes call_rcu() to register
> + * an RCU callback, (3) CPU 0 exits the RCU read-side critical section,
> + * (4) CPU 2 enters a RCU read-side critical section, (5) the RCU
> + * callback is invoked.  This is legal, because the RCU read-side critical
> + * section that was running concurrently with the call_rcu() (and which
> + * therefore might be referencing something that the corresponding RCU
> + * callback would free up) has completed before the corresponding
> + * RCU callback is invoked.
> + *
> + * RCU read-side critical sections may be nested.  Any deferred actions
> + * will be deferred until the outermost RCU read-side critical section
> + * completes.
> + *
> + * It is illegal to block while in an RCU read-side critical section.
> + */
> +void __rcu_read_lock(void)
> +{
> +       struct rcu_data *r;
> +
> +       r = &per_cpu(rcu_data, smp_processor_id());
> +       if (r->nest_count++ == 0)
> +               /*
> +                * Set the flags value to show that we are in
> +                * a read side critical section.  The code starting
> +                * a batch uses this to determine if a processor
> +                * needs to participate in the batch.  Including
> +                * a sequence allows the remote processor to tell
> +                * that a critical section has completed and another
> +                * has begun.
> +                */

memory barrier is needed as Paul noted.

> +               r->flags = IN_RCU_READ_LOCK | (r->sequence++ << 2);
> +}
> +EXPORT_SYMBOL(__rcu_read_lock);
> +
> +/**
> + * rcu_read_unlock - marks the end of an RCU read-side critical section.
> + * Check if a RCU batch was started while we were in the critical
> + * section.  If so, call rcu_quiescent() join the rendezvous.
> + *
> + * See rcu_read_lock() for more information.
> + */
> +void __rcu_read_unlock(void)
> +{
> +       struct rcu_data *r;
> +       int     cpu, flags;
> +
> +       cpu = smp_processor_id();
> +       r = &per_cpu(rcu_data, cpu);
> +       if (--r->nest_count == 0) {
> +               flags = xchg(&r->flags, 0);
> +               if (flags & DO_RCU_COMPLETION)
> +                       rcu_quiescent(cpu);
> +       }
> +}
> +EXPORT_SYMBOL(__rcu_read_unlock);

It is hardly acceptable when there are memory barriers or
atomic operations in the fast paths of rcu_read_lock(),
rcu_read_unlock().

We need some thing to drive the completion of GP
(and the callbacks process). There is no free lunch,
if the completion of GP is driven by rcu_read_unlock(),
we very probably need memory barriers or atomic operations
in the fast paths of rcu_read_lock(), rcu_read_unlock().

We need look for some periodic/continuous events of
the kernel for GP-driven, schedule-tick and schedule() are
most ideal events sources in the kernel I think.

schedule-tick and schedule() are not happened when NO_HZ
and dyntick-hpc, so we need some approaches to fix it. I vote up
for the #5 approach of Paul's.

Also, I propose an unmature idea here.

	Don't tell RCU about dyntick-hpc mode, but instead
	stop the RCU function of a CPU when the first time RCU disturbs
	dyntick-hpc mode or NO_HZ mode.

	rcu_read_lock()
		if the RCU function of this CPU is not started, start it and
		start a RCU timer.
		handle rcu_read_lock()

	enter NO_HZ
		if interrupts are just happened very frequently, do nothing, else:
		stop the rcu function and the rcu timer of the current CPU.

	exit interrupt:
		if this interrupt is just caused by RCU timer && it just disrurbs
		dyntick-hpc mode or NO_HZ mode(and will reenter these modes),
		stop the rcu function and stop the rcu timer of the current CPU.

	schedule-tick:
		requeue the rcu timer before it causes an unneeded interrupt.
		handle rcu things.

	+	Not big changes to RCU, use the same code to handle
		dyntick-hpc mode or NO_HZ mode, reuse some code of rcu_offline_cpu()

	+	No need to inform RCU of user/kernel transitions.

	+	No need to turn scheduling-clock interrupts on
		at each user/kernel transition.

	-	carefully handle some critical region which also implies
		rcu critical region.

	-	Introduce some unneeded interrupt, but it is very infrequency.

Thanks,
Lai

> +
> +/**
> + * call_rcu - Queue an RCU callback for invocation after a grace period.
> + * @head: structure to be used for queueing the RCU updates.
> + * @func: actual update function to be invoked after the grace period
> + *
> + * The update function will be invoked some time after a full grace
> + * period elapses, in other words after all currently executing RCU
> + * read-side critical sections have completed.  RCU read-side critical
> + * sections are delimited by rcu_read_lock() and rcu_read_unlock(),
> + * and may be nested.
> + */
> +void call_rcu(struct rcu_head *head, void (*func)(struct rcu_head *rcu))
> +{
> +       struct rcu_data *r;
> +       unsigned long flags;
> +       int cpu;
> +
> +       head->func = func;
> +       head->next = NULL;
> +       local_irq_save(flags);
> +       cpu = smp_processor_id();
> +       r = &per_cpu(rcu_data, cpu);
> +       /*
> +        * Avoid mixing new entries with batches which have already
> +        * completed or have a grace period in progress.
> +        */
> +       if (r->nxt.head && rcu_move_if_done(r))
> +               rcu_wake_daemon(r);
> +
> +       rcu_list_add(&r->nxt, head);
> +       if (r->nxtcount++ == 0) {

memory barrier is needed. (before read the rcu_batch)

> +               r->nxtbatch = (rcu_batch & RCU_BATCH_MASK) + RCU_INCREMENT;
> +               barrier();
> +               if (!rcu_timestamp)
> +                       rcu_timestamp = jiffies ?: 1;
> +       }
> +       /* If we reach the limit start a batch. */
> +       if (r->nxtcount > rcu_max_count) {
> +               if (rcu_set_state(RCU_NEXT_PENDING) == RCU_COMPLETE)
> +                       rcu_start_batch();
> +       }
> +       local_irq_restore(flags);
> +}
> +EXPORT_SYMBOL_GPL(call_rcu);
> +
> +


> +/*
> + * Process the completed RCU callbacks.
> + */
> +static void rcu_process_callbacks(struct rcu_data *r)
> +{
> +       struct rcu_head *list, *next;
> +
> +       local_irq_disable();
> +       rcu_move_if_done(r);
> +       list = r->done.head;
> +       rcu_list_init(&r->done);
> +       local_irq_enable();
> +

memory barrier is needed. (after read the rcu_batch)

> +       while (list) {
> +               next = list->next;
> +               list->func(list);
> +               list = next;
> +       }
> +}
