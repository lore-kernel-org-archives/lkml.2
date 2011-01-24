Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752672Ab1AXLuj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jan 2011 06:50:39 -0500
Received: from mx1.redhat.com ([209.132.183.28]:61503 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752242Ab1AXLui (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jan 2011 06:50:38 -0500
Date: Mon, 24 Jan 2011 12:42:34 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        Alan Stern <stern@rowland.harvard.edu>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Paul Mackerras <paulus@samba.org>, Prasad <prasad@linux.vnet.ibm.com>,
        Roland McGrath <roland@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: Q: perf_install_in_context/perf_event_enable are racy?
Message-ID: <20110124114234.GA12166@redhat.com>
References: <20101108145647.GA3426@redhat.com> <20101108145725.GA3434@redhat.com> <20110119182141.GA12183@redhat.com> <20110120193033.GA13924@redhat.com> <1295611905.28776.269.camel@laptop> <20110121130323.GA12900@elte.hu> <1295617185.28776.273.camel@laptop> <20110121142616.GA31165@redhat.com> <1295622304.28776.293.camel@laptop> <20110121204014.GA2870@nowhere>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110121204014.GA2870@nowhere>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/21, Frederic Weisbecker wrote:
>
> +static DEFINE_PER_CPU(int, task_events_schedulable);

Yes, I think this can work. I thought about this too. The only problem,
this doesn't make the whole code more understandable ;)

> @@ -1587,6 +1594,8 @@ void __perf_event_task_sched_in(struct task_struct *task)
>  	struct perf_event_context *ctx;
>  	int ctxn;
>
> +	__get_cpu_var(task_events_schedulable) = 1;
> +
>  	for_each_task_context_nr(ctxn) {
>  		ctx = task->perf_event_ctxp[ctxn];
>  		if (likely(!ctx))

This doesn't look right. We should set task_events_schedulable
_after_ perf_event_context_sched_in(), otherwise we have the similar
race with next.

rq->curr and current_task were already updated. __perf_install_in_context
should not set "cpuctx->task_ctx = next" before perf_event_context_sched_in(),
it does nothing if cpuctx->task_ctx == ctx.

OTOH, if we set task_events_schedulable after for_each_task_context_nr(),
then we have another race with next, but this race is minor. If
find_get_context() + perf_install_in_context() happen in this window,
the new event won't be scheduled until next reschedules itself.

> +	/*
> +	 * Every pending sched switch must finish so that
> +	 * we ensure every pending calls to perf_event_task_sched_in/out are
> +	 * finished. We ensure the next ones will correctly handle the
> +	 * perf_task_events label and then the task_events_schedulable
> +	 * state. So perf_install_in_context() won't install events
> +	 * in the tiny race window between perf_event_task_sched_out()
> +	 * and perf_event_task_sched_in() in the __ARCH_WANT_INTERRUPTS_ON_CTXSW
> +	 * case.
> +	 */
> +	synchronize_sched();

Yes, if perf_task_events was zero before perf_event_alloc(), then it
is possible that task_events_schedulable == 1 while schedule() is in
progress. perf_event_create_kernel_counter() needs this too.



Frederic, All, can't we simplify this?

First, we modify __perf_install_in_context() so that it never tries
to install the event into !is_active context. IOW, it never tries
to set cpuctx->task_ctx = ctx.

Then we add the new trivial helper stop_resched_task(task) which
simply wakeups the stop thread on task_cpu(task), and thus forces
this task to reschedule.

Now,

	static void
	perf_install_in_context(struct perf_event_context *ctx,
				struct perf_event *event,
				int cpu)
	{
		struct task_struct *task = ctx->task;

		event->ctx = ctx;

		if (!task) {
			/*
			 * Per cpu events are installed via an smp call and
			 * the install is always successful.
			 */
			smp_call_function_single(cpu, __perf_install_in_context,
						 event, 1);
			return;
		}

		for (;;) {
			bool done, need_resched = false;

			raw_spin_lock_irq(&ctx->lock);
			done = !list_empty(&event->group_entry);
			if (!done && !ctx->is_active) {
				add_event_to_ctx(event, ctx);
				need_resched = task_running(task);
				done = true;
			}
			raw_spin_unlock_irq(&ctx->lock);

			if (done) {
				if (need_resched)
					stop_resched_task(task);
				break;
			}

			task_oncpu_function_call(task, __perf_install_in_context,
						event);
		}
	}

Yes, stop_resched_task() can't help if this task itself is the stop thread.
But the stop thread shouldn't run for a long time without rescheduling,
otherwise we already have the problems.

Do you all think this makes any sense?

Oleg.

