Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757469Ab1FFSXn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jun 2011 14:23:43 -0400
Received: from casper.infradead.org ([85.118.1.10]:50889 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757085Ab1FFSXl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jun 2011 14:23:41 -0400
Subject: Re: [PATCH] perf, core: Fix initial task_ctx/event installation
From: Peter Zijlstra <peterz@infradead.org>
To: Jiri Olsa <jolsa@redhat.com>
Cc: paulus@samba.org, mingo@elte.hu, linux-kernel@vger.kernel.org,
        oleg@redhat.com
In-Reply-To: <1307382026.2322.226.camel@twins>
References: <1307371095-10141-1-git-send-email-jolsa@redhat.com>
	 <1307382026.2322.226.camel@twins>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 06 Jun 2011 20:27:17 +0200
Message-ID: <1307384837.2497.738.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-06-06 at 19:40 +0200, Peter Zijlstra wrote:
> It helps if you actually use the right email address for me ;-)
> 
> On Mon, 2011-06-06 at 16:38 +0200, Jiri Olsa wrote:
> > hi,
> > 
> > I think I found a bug in the __perf_install_in_context. The attached
> > patch fixies the problem for me, but I'm not sure it did not break
> > anything else.. ;)
> > 
> > thanks,
> > jirka
> > 
> > ---
> > The __perf_install_in_context function does not install context
> > events in case there's no active task context.
> > 
> > This might cause incorrect counts if application opens counter
> > in its own task context. 
> > 
> > Following scenario leads to wrong counts:
> > (this is the case for "perf test - test__open_syscall_event
> > which counts sys_enter_open calls)
> > 
> > 1  - application is scheduled in
> > 2  - application enters perf_event_open syscall with its own pid
> > 3  - event/context is created
> > 4  - __perf_install_in_context is called
> > 5  - cpuctx->task_ctx is NULL
> > 6  - perf_event_sched_in gets called with ctx == NULL, new event is not scheduled in
> > 7  - application leaves the perf_event_open syscall
> > 8  - application running code leading to increment the event counter
> >      !!! this is where we lost the counts, since the event is not scheduled in !!!
> > 9  - application is scheduled out
> > 11 - application is scheduled in
> > 12 - event is properly sceduled in
> > 13 - event counter is now incremented
> > 
> > If the task is scheduled out and back in after the context is installed,
> > but before it exits the perf_event_open syscall, the task_ctx gets
> > properly set and event is properly scheduled in. In this case
> > the perf test returns proper counts.
> > 
> > Attached patch changed this behaviour to install new task_ctx
> > even if the current task_ctx is NULL.
> > 
> > Tested by succesfully running perf test command.
> 
> Right, so I have those bits as per https://lkml.org/lkml/2011/4/10/17,
> they got lost in the commit due to a quilt refresh boo-boo.
> 
> With these bits it works on my dual core, but I still get lockups on my
> 24-cpu wsm machine.

That is, with the below, while running
validation/simple_overflow_leader, from:
http://web.eecs.utk.edu/~vweaver1/projects/perf-events/validation.html

my machine still explodes.

---
diff --git a/kernel/events/core.c b/kernel/events/core.c
index ba89f40..570c604 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -1123,6 +1123,7 @@ static int __perf_remove_from_context(void *info)
 	if (!ctx->nr_events && cpuctx->task_ctx == ctx) {
 		ctx->is_active = 0;
 		cpuctx->task_ctx = NULL;
+		trace_printk("%p->task_ctx = NULL\n", cpuctx);
 	}
 	raw_spin_unlock(&ctx->lock);
 
@@ -1197,6 +1198,7 @@ static int __perf_event_disable(void *info)
 	 * Can trigger due to concurrent perf_event_context_sched_out()
 	 * flipping contexts around.
 	 */
+	trace_printk("%p %p %p\n", ctx->task, cpuctx->task_ctx, ctx);
 	if (ctx->task && cpuctx->task_ctx != ctx)
 		return -EINVAL;
 
@@ -1217,6 +1219,8 @@ static int __perf_event_disable(void *info)
 		event->state = PERF_EVENT_STATE_OFF;
 	}
 
+	trace_printk("%d\n", event->state);
+
 	raw_spin_unlock(&ctx->lock);
 
 	return 0;
@@ -1249,6 +1253,7 @@ void perf_event_disable(struct perf_event *event)
 	}
 
 retry:
+	trace_printk("%p %p %p\n", task, event, ctx);
 	if (!task_function_call(task, __perf_event_disable, event))
 		return;
 
@@ -1256,6 +1261,7 @@ retry:
 	/*
 	 * If the event is still active, we need to retry the cross-call.
 	 */
+	trace_printk("%d\n", event->state);
 	if (event->state == PERF_EVENT_STATE_ACTIVE) {
 		raw_spin_unlock_irq(&ctx->lock);
 		/*
@@ -1505,25 +1511,31 @@ static int  __perf_install_in_context(void *info)
 	struct perf_event_context *task_ctx = cpuctx->task_ctx;
 	struct task_struct *task = current;
 
-	perf_ctx_lock(cpuctx, cpuctx->task_ctx);
+	perf_ctx_lock(cpuctx, task_ctx);
 	perf_pmu_disable(cpuctx->ctx.pmu);
 
 	/*
 	 * If there was an active task_ctx schedule it out.
 	 */
-	if (task_ctx) {
+	if (task_ctx)
 		task_ctx_sched_out(task_ctx);
-		/*
-		 * If the context we're installing events in is not the
-		 * active task_ctx, flip them.
-		 */
-		if (ctx->task && task_ctx != ctx) {
-			raw_spin_unlock(&cpuctx->ctx.lock);
-			raw_spin_lock(&ctx->lock);
-			cpuctx->task_ctx = task_ctx = ctx;
-		}
-		task = task_ctx->task;
+
+	/*
+	 * If the context we're installing events in is not the
+	 * active task_ctx, flip them.
+	 */
+	if (ctx->task && task_ctx != ctx) {
+		if (task_ctx)
+			raw_spin_unlock(&task_ctx->lock);
+		raw_spin_lock(&ctx->lock);
+		task_ctx = ctx;
+		cpuctx->task_ctx = task_ctx;
+		trace_printk("%p->task_ctx = %p\n", cpuctx, task_ctx);
 	}
+
+	if (task_ctx)
+		task = task_ctx->task;
+
 	cpu_ctx_sched_out(cpuctx, EVENT_ALL);
 
 	update_context_time(ctx);
@@ -1946,6 +1958,7 @@ static void perf_event_context_sched_out(struct task_struct *task, int ctxn,
 		raw_spin_lock(&ctx->lock);
 		ctx_sched_out(ctx, cpuctx, EVENT_ALL);
 		cpuctx->task_ctx = NULL;
+		trace_printk("%p->task_ctx = NULL\n", cpuctx);
 		raw_spin_unlock(&ctx->lock);
 	}
 }
@@ -1993,6 +2006,7 @@ static void task_ctx_sched_out(struct perf_event_context *ctx)
 
 	ctx_sched_out(ctx, cpuctx, EVENT_ALL);
 	cpuctx->task_ctx = NULL;
+	trace_printk("%p->task_ctx = NULL\n", cpuctx);
 }
 
 /*
@@ -2121,6 +2135,7 @@ static void perf_event_context_sched_in(struct perf_event_context *ctx,
 	perf_event_sched_in(cpuctx, ctx, task);
 
 	cpuctx->task_ctx = ctx;
+	trace_printk("%p->task_ctx = %p\n", cpuctx, ctx);
 
 	perf_pmu_enable(ctx->pmu);
 	perf_ctx_unlock(cpuctx, ctx);


