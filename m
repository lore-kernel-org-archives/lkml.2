Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754067Ab1AZSZa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jan 2011 13:25:30 -0500
Received: from mx1.redhat.com ([209.132.183.28]:14418 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753852Ab1AZSZ2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jan 2011 13:25:28 -0500
Date: Wed, 26 Jan 2011 18:53:22 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        Alan Stern <stern@rowland.harvard.edu>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Paul Mackerras <paulus@samba.org>, Prasad <prasad@linux.vnet.ibm.com>,
        Roland McGrath <roland@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: Q: perf_install_in_context/perf_event_enable are racy?
Message-ID: <20110126175322.GA28617@redhat.com>
References: <20101108145725.GA3434@redhat.com> <20110119182141.GA12183@redhat.com> <20110120193033.GA13924@redhat.com> <1295611905.28776.269.camel@laptop> <20110121130323.GA12900@elte.hu> <1295617185.28776.273.camel@laptop> <20110121142616.GA31165@redhat.com> <1295622304.28776.293.camel@laptop> <20110121204014.GA2870@nowhere> <20110124114234.GA12166@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110124114234.GA12166@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/24, Oleg Nesterov wrote:
>
> Frederic, All, can't we simplify this?

Well, to clarify, it looks simpler to me ;)

But if you don't like this approach, lets use task_events_schedulable flag.

> First, we modify __perf_install_in_context() so that it never tries
> to install the event into !is_active context. IOW, it never tries
> to set cpuctx->task_ctx = ctx.
>
> Then we add the new trivial helper stop_resched_task(task) which
> simply wakeups the stop thread on task_cpu(task), and thus forces
> this task to reschedule.
>
> ...
>
> Yes, stop_resched_task() can't help if this task itself is the stop thread.
> But the stop thread shouldn't run for a long time without rescheduling,
> otherwise we already have the problems.

Please see the untested patch below. It doesn't change perf_event_enable(),
only perf_install_in_context(). Just for early review to know your opinion.
To simplify the reading, here is the code:

	void task_force_schedule(struct task_struct *p)
	{
		struct rq *rq;

		preempt_disable();
		rq = task_rq(p);
		if (rq->curr == p)
			wake_up_process(rq->stop);
		preempt_enable();
	}

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
			raw_spin_lock_irq(&ctx->lock);
			/*
			 * The lock prevents that this context is
			 * scheduled in, we can add the event safely.
			 */
			if (!ctx->is_active)
				add_event_to_ctx(event, ctx);
			raw_spin_unlock_irq(&ctx->lock);

			if (event->attach_state & PERF_ATTACH_CONTEXT) {
				task_force_schedule(task);
				break;
			}

			task_oncpu_function_call(task, __perf_install_in_context,
							event);
			if (event->attach_state & PERF_ATTACH_CONTEXT)
				break;
		}
	}

Oleg.

 include/linux/sched.h |    1 +
 kernel/sched.c        |   11 +++++++++++
 kernel/perf_event.c   |   49 +++++++++++++++++++++----------------------------
 3 files changed, 33 insertions(+), 28 deletions(-)

--- perf/include/linux/sched.h~1_force_resched	2011-01-14 18:21:04.000000000 +0100
+++ perf/include/linux/sched.h	2011-01-26 17:54:28.000000000 +0100
@@ -2584,6 +2584,7 @@ static inline void inc_syscw(struct task
 extern void task_oncpu_function_call(struct task_struct *p,
 				     void (*func) (void *info), void *info);
 
+extern void task_force_schedule(struct task_struct *p);
 
 #ifdef CONFIG_MM_OWNER
 extern void mm_update_next_owner(struct mm_struct *mm);
--- perf/kernel/sched.c~1_force_resched	2011-01-20 20:37:11.000000000 +0100
+++ perf/kernel/sched.c	2011-01-26 17:52:42.000000000 +0100
@@ -1968,6 +1968,17 @@ void sched_set_stop_task(int cpu, struct
 	}
 }
 
+void task_force_schedule(struct task_struct *p)
+{
+	struct rq *rq;
+
+	preempt_disable();
+	rq = task_rq(p);
+	if (rq->curr == p)
+		wake_up_process(rq->stop);
+	preempt_enable();
+}
+
 /*
  * __normal_prio - return the priority that is based on the static prio
  */
--- perf/kernel/perf_event.c~2_install_ctx_via_resched	2011-01-21 18:41:02.000000000 +0100
+++ perf/kernel/perf_event.c	2011-01-26 18:32:30.000000000 +0100
@@ -943,16 +943,10 @@ static void __perf_install_in_context(vo
 
 	/*
 	 * If this is a task context, we need to check whether it is
-	 * the current task context of this cpu. If not it has been
-	 * scheduled out before the smp call arrived.
-	 * Or possibly this is the right context but it isn't
-	 * on this cpu because it had no events.
+	 * the current task context of this cpu.
 	 */
-	if (ctx->task && cpuctx->task_ctx != ctx) {
-		if (cpuctx->task_ctx || ctx->task != current)
-			return;
-		cpuctx->task_ctx = ctx;
-	}
+	if (ctx->task && cpuctx->task_ctx != ctx)
+		return;
 
 	raw_spin_lock(&ctx->lock);
 	ctx->is_active = 1;
@@ -1030,27 +1024,26 @@ perf_install_in_context(struct perf_even
 		return;
 	}
 
-retry:
-	task_oncpu_function_call(task, __perf_install_in_context,
-				 event);
-
-	raw_spin_lock_irq(&ctx->lock);
-	/*
-	 * we need to retry the smp call.
-	 */
-	if (ctx->is_active && list_empty(&event->group_entry)) {
+	for (;;) {
+		raw_spin_lock_irq(&ctx->lock);
+		/*
+		 * The lock prevents that this context is
+		 * scheduled in, we can add the event safely.
+		 */
+		if (!ctx->is_active)
+			add_event_to_ctx(event, ctx);
 		raw_spin_unlock_irq(&ctx->lock);
-		goto retry;
-	}
 
-	/*
-	 * The lock prevents that this context is scheduled in so we
-	 * can add the event safely, if it the call above did not
-	 * succeed.
-	 */
-	if (list_empty(&event->group_entry))
-		add_event_to_ctx(event, ctx);
-	raw_spin_unlock_irq(&ctx->lock);
+		if (event->attach_state & PERF_ATTACH_CONTEXT) {
+			task_force_schedule(task);
+			break;
+		}
+
+		task_oncpu_function_call(task, __perf_install_in_context,
+						event);
+		if (event->attach_state & PERF_ATTACH_CONTEXT)
+			break;
+	}
 }
 
 /*

