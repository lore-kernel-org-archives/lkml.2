Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755277Ab1A1MlJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jan 2011 07:41:09 -0500
Received: from casper.infradead.org ([85.118.1.10]:37672 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753994Ab1A1MlE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jan 2011 07:41:04 -0500
Subject: Re: Q: perf_install_in_context/perf_event_enable are racy?
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Alan Stern <stern@rowland.harvard.edu>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Paul Mackerras <paulus@samba.org>, Prasad <prasad@linux.vnet.ibm.com>,
        Roland McGrath <roland@redhat.com>, linux-kernel@vger.kernel.org
In-Reply-To: <20110127221856.GA10539@redhat.com>
References: <20110121130323.GA12900@elte.hu>
	 <1295617185.28776.273.camel@laptop> <20110121142616.GA31165@redhat.com>
	 <1295622304.28776.293.camel@laptop> <20110121204014.GA2870@nowhere>
	 <20110124114234.GA12166@redhat.com> <20110126175322.GA28617@redhat.com>
	 <1296134077.15234.161.camel@laptop> <20110127165712.GC25060@redhat.com>
	 <1296148294.15234.242.camel@laptop>  <20110127221856.GA10539@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Fri, 28 Jan 2011 12:52:57 +0100
Message-ID: <1296215577.15234.333.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-01-27 at 23:18 +0100, Oleg Nesterov wrote:
> On 01/27, Peter Zijlstra wrote:
> >
> > On Thu, 2011-01-27 at 17:57 +0100, Oleg Nesterov wrote:
> > >
> > > > With, however, things are more interesting. 2 seems to be adequately
> > > > covered by the patch I just send, the IPI will bail and the next
> > > > sched-in of the relevant task will pick matters up. 1 otoh doesn't seem
> > > > covered, the IPI will bail, leaving us stranded.
> > >
> > > Hmm, yes... Strangely, I missed that when I was thinking about in_ctxsw.
> > >
> > > Perhaps, we can change task_oncpu_function_call() so that it returns
> > > -EAGAIN in case it hits in_ctxsw != 0? If the caller sees -EAGAIN, it
> > > should always retry even if !ctx->is_active.
> >
> > That would be very easy to do, we can pass a return value through the
> > task_function_call structure.
> 
> Yes.
> 
> Perhaps task_oncpu_function_call() should retry itself to simplify the
> callers. I wonder if we should also retry if rq->curr != p...

Yes we should, the task could have been migrated and be running on
another cpu..

> Oh. You know, I am starting to think I will never understand this.

Oh, please don't give up, we shall persevere with this until it all
makes perfect sense (or we're both mental and get locked up), it can
only improve matters, right? :-)

> perf_install_in_context() does task_oncpu_function_call() and then
> 
> 
> 	// ctx->is_active == 0
> 
> 	/*
> 	 * The lock prevents that this context is scheduled in so we
> 	 * can add the event safely, if it the call above did not
> 	 * succeed.
> 	 */
> 	if (list_empty(&event->group_entry))
> 		add_event_to_ctx(event, ctx);
> 
> This assumes that the task is not running.
> 
> Why? Because (I guess) we assume that either task_oncpu_function_call()
> should see task_curr() == T, or if the task becomes running after that
> it should see the new ->perf_event_ctxp[ctxn] != NULL. And I do not see
> how we can prove this.

Right, that is the intended logic, lets see if I can make that be true.

So task_oncpu_function_call() as per after the below patch, will loop
until either:

 - the task isn't running, or
 - we executed the function on the cpu during the task's stay there

If it isn't running, it might have scheduled in by the time we've
acquired the ctx->lock, the ->is_active test catches that and retries
the task_oncpu_function_call(), if its still not running, us holding the
ctx->lock ensures its possible schedule-in on another cpu will be held
up at perf_event_task_sched_in().

Now:

> If find_get_context() sets the new context, the only guarantee we have
> is: perf_event_exit_task() can't miss this context. The task, however,
> can be scheduled in and miss the new value in perf_event_ctxp[].
> And, task_oncpu_function_call() can equally miss rq->curr == task.

Right, so in case the perf_event_task_sched_in() missed the assignment
of ->perf_event_ctxp[n], then our above story falls flat on its face.

Because then we can not rely on ->in_active being set for running tasks.

So we need a task_curr() test under that lock, which would need
perf_event_task_sched_out() to be done _before_ we set rq->curr = next,
I _think_.

> But. I think this all falls into the absolutely theoretical category,
> and in the worst case nothing really bad can happen, just event_sched_in()
> will be delayed until this task reshedules.

Still, it would be bad if some HPC workload (1 task per cpu, very sparse
syscalls, hardly no scheduling at all) would go wonky once in a blue
moon.

More importantly I think, it would be best if this code were obvious, it
clearly isn't, so lets hang in here for a little while more.

> So, I think your patch should fix all problems with schedule. Just it
> needs the couple of changes we already discussed:
> 
> 	- finish_task_switch() should clear rq->in_ctxsw before
> 	  local_irq_enable()

check, although I should still add at least a little comment in
task_oncpu_function_call() explaining things.

> 	- task_oncpu_function_call() (or its callers) should always
> 	  retry the "if (task_curr(p))" code if ->in_ctxsw is true.

check.

> If you think we have other problems here please don't tell me,
> I already got lost ;)

Sorry to bother you more, but I think we're actually getting
somewhere...

---
 include/linux/sched.h |    4 +-
 kernel/sched.c        |   64 ++++++++++++++++++++++++++++++++++++++++++------
 2 files changed, 58 insertions(+), 10 deletions(-)

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
diff --git a/kernel/sched.c b/kernel/sched.c
index 18d38e4..9ef760c 100644
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
@@ -2911,7 +2963,6 @@ context_switch(struct rq *rq, struct task_struct *prev,
 	struct mm_struct *mm, *oldmm;
 
 	prepare_task_switch(rq, prev, next);
-	trace_sched_switch(prev, next);
 	mm = next->mm;
 	oldmm = prev->active_mm;
 	/*
@@ -3989,9 +4040,6 @@ need_resched_nonpreemptible:
 	rq->skip_clock_update = 0;
 
 	if (likely(prev != next)) {
-		sched_info_switch(prev, next);
-		perf_event_task_sched_out(prev, next);
-
 		rq->nr_switches++;
 		rq->curr = next;
 		++*switch_count;

