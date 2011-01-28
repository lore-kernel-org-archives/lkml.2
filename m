Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754965Ab1A1O46 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jan 2011 09:56:58 -0500
Received: from casper.infradead.org ([85.118.1.10]:53561 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754723Ab1A1O45 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jan 2011 09:56:57 -0500
Subject: Re: Q: perf_install_in_context/perf_event_enable are racy?
From: Peter Zijlstra <peterz@infradead.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Alan Stern <stern@rowland.harvard.edu>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Paul Mackerras <paulus@samba.org>, Prasad <prasad@linux.vnet.ibm.com>,
        Roland McGrath <roland@redhat.com>, linux-kernel@vger.kernel.org
In-Reply-To: <1296215577.15234.333.camel@laptop>
References: <20110121130323.GA12900@elte.hu>
	 <1295617185.28776.273.camel@laptop> <20110121142616.GA31165@redhat.com>
	 <1295622304.28776.293.camel@laptop> <20110121204014.GA2870@nowhere>
	 <20110124114234.GA12166@redhat.com> <20110126175322.GA28617@redhat.com>
	 <1296134077.15234.161.camel@laptop> <20110127165712.GC25060@redhat.com>
	 <1296148294.15234.242.camel@laptop>  <20110127221856.GA10539@redhat.com>
	 <1296215577.15234.333.camel@laptop>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 28 Jan 2011 15:57:47 +0100
Message-ID: <1296226667.15234.337.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-01-28 at 12:52 +0100, Peter Zijlstra wrote:
> Right, so in case the perf_event_task_sched_in() missed the assignment
> of ->perf_event_ctxp[n], then our above story falls flat on its face.
> 
> Because then we can not rely on ->in_active being set for running tasks.
> 
> So we need a task_curr() test under that lock, which would need
> perf_event_task_sched_out() to be done _before_ we set rq->curr = next,
> I _think_. 


Ok, so how about something like this:

if task_oncpu_function_call() managed to execute the function proper,
we're done. Otherwise, if while holding the lock, task_curr() is true,
it means the task is now current and we should try again, if its not, it
cannot become current because us holding ctx->lock blocks
perf_event_task_sched_in().

Hmm?

---
 include/linux/sched.h |    4 +-
 kernel/perf_event.c   |   23 ++++++++++-------
 kernel/sched.c        |   65 +++++++++++++++++++++++++++++++++++++++++++------
 3 files changed, 73 insertions(+), 19 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index d747f94..b147d73 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -2581,8 +2581,8 @@ static inline void inc_syscw(struct task_struct *tsk)
 /*
  * Call the function if the target task is executing on a CPU right now:
  */
-extern void task_oncpu_function_call(struct task_struct *p,
-				     void (*func) (void *info), void *info);
+extern int task_oncpu_function_call(struct task_struct *p,
+				    void (*func) (void *info), void *info);
 
 
 #ifdef CONFIG_MM_OWNER
diff --git a/kernel/perf_event.c b/kernel/perf_event.c
index 852ae8c..0d988b8 100644
--- a/kernel/perf_event.c
+++ b/kernel/perf_event.c
@@ -1017,6 +1017,7 @@ perf_install_in_context(struct perf_event_context *ctx,
 			int cpu)
 {
 	struct task_struct *task = ctx->task;
+	int ret;
 
 	event->ctx = ctx;
 
@@ -1031,25 +1032,29 @@ perf_install_in_context(struct perf_event_context *ctx,
 	}
 
 retry:
-	task_oncpu_function_call(task, __perf_install_in_context,
-				 event);
+	ret = task_oncpu_function_call(task, 
+			__perf_install_in_context, event);
+
+	if (!ret)
+		return;
 
 	raw_spin_lock_irq(&ctx->lock);
+
 	/*
-	 * we need to retry the smp call.
+	 * If the task_oncpu_function_call() failed, re-check task_curr() now
+	 * that we hold ctx->lock(), if it is running retry the IPI.
 	 */
-	if (ctx->is_active && list_empty(&event->group_entry)) {
+	if (task_curr(task)) {
 		raw_spin_unlock_irq(&ctx->lock);
 		goto retry;
 	}
 
 	/*
-	 * The lock prevents that this context is scheduled in so we
-	 * can add the event safely, if it the call above did not
-	 * succeed.
+	 * Otherwise the lock prevents that this context is scheduled in so we
+	 * can add the event safely, if it the call above did not succeed.
 	 */
-	if (list_empty(&event->group_entry))
-		add_event_to_ctx(event, ctx);
+	add_event_to_ctx(event, ctx);
+
 	raw_spin_unlock_irq(&ctx->lock);
 }
 
diff --git a/kernel/sched.c b/kernel/sched.c
index 18d38e4..3686dce 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -490,7 +490,10 @@ struct rq {
 	struct task_struct *curr, *idle, *stop;
 	unsigned long next_balance;
 	struct mm_struct *prev_mm;
-
+#ifdef __ARCH_WANT_INTERRUPTS_ON_CTXSW
+	int in_ctxsw;
+#endif
+	
 	u64 clock;
 	u64 clock_task;
 
@@ -2265,6 +2268,34 @@ void kick_process(struct task_struct *p)
 EXPORT_SYMBOL_GPL(kick_process);
 #endif /* CONFIG_SMP */
 
+struct task_function_call {
+	struct task_struct *p;
+	void (*func)(void *info);
+	void *info;
+	int ret;
+};
+
+void task_function_trampoline(void *data)
+{
+	struct task_function_call *tfc = data;
+	struct task_struct *p = tfc->p;
+	struct rq *rq = this_rq();
+
+	tfc->ret = -EAGAIN;
+
+#ifdef __ARCH_WANT_INTERRUPTS_ON_CTXSW
+	if (rq->in_ctxsw)
+		return;
+#endif
+
+	if (rq->curr != p)
+		return;
+
+	tfc->ret = 0;
+
+	tfc->func(tfc->info);
+}
+
 /**
  * task_oncpu_function_call - call a function on the cpu on which a task runs
  * @p:		the task to evaluate
@@ -2273,17 +2304,31 @@ EXPORT_SYMBOL_GPL(kick_process);
  *
  * Calls the function @func when the task is currently running. This might
  * be on the current CPU, which just calls the function directly
+ *
+ * returns: 0 when @func got called
  */
-void task_oncpu_function_call(struct task_struct *p,
+int task_oncpu_function_call(struct task_struct *p,
 			      void (*func) (void *info), void *info)
 {
+	struct task_function_call data = {
+		.p = p,
+		.func = func,
+		.info = info,
+	};
 	int cpu;
 
 	preempt_disable();
+again:
+	data.ret = -ESRCH; /* No such (running) process */
 	cpu = task_cpu(p);
-	if (task_curr(p))
-		smp_call_function_single(cpu, func, info, 1);
+	if (task_curr(p)) {
+		smp_call_function_single(cpu, task_function_trampoline, &data, 1);
+		if (data.ret == -EAGAIN)
+			goto again;
+	}
 	preempt_enable();
+
+	return data.ret;
 }
 
 #ifdef CONFIG_SMP
@@ -2776,9 +2821,15 @@ static inline void
 prepare_task_switch(struct rq *rq, struct task_struct *prev,
 		    struct task_struct *next)
 {
+#ifdef __ARCH_WANT_INTERRUPTS_ON_CTXSW
+	rq->in_ctxsw = 1;
+#endif
+	sched_info_switch(prev, next);
+	perf_event_task_sched_out(prev, next);
 	fire_sched_out_preempt_notifiers(prev, next);
 	prepare_lock_switch(rq, next);
 	prepare_arch_switch(next);
+	trace_sched_switch(prev, next);
 }
 
 /**
@@ -2822,6 +2873,7 @@ static void finish_task_switch(struct rq *rq, struct task_struct *prev)
 #endif /* __ARCH_WANT_INTERRUPTS_ON_CTXSW */
 	perf_event_task_sched_in(current);
 #ifdef __ARCH_WANT_INTERRUPTS_ON_CTXSW
+	rq->in_ctxsw = 0;
 	local_irq_enable();
 #endif /* __ARCH_WANT_INTERRUPTS_ON_CTXSW */
 	finish_lock_switch(rq, prev);
@@ -2911,7 +2963,7 @@ context_switch(struct rq *rq, struct task_struct *prev,
 	struct mm_struct *mm, *oldmm;
 
 	prepare_task_switch(rq, prev, next);
-	trace_sched_switch(prev, next);
+
 	mm = next->mm;
 	oldmm = prev->active_mm;
 	/*
@@ -3989,9 +4041,6 @@ need_resched_nonpreemptible:
 	rq->skip_clock_update = 0;
 
 	if (likely(prev != next)) {
-		sched_info_switch(prev, next);
-		perf_event_task_sched_out(prev, next);
-
 		rq->nr_switches++;
 		rq->curr = next;
 		++*switch_count;


