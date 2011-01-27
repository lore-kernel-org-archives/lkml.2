Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753096Ab1A0M3T (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jan 2011 07:29:19 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:57819 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753020Ab1A0M3R convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jan 2011 07:29:17 -0500
Subject: Re: Q: perf_install_in_context/perf_event_enable are racy?
From: Peter Zijlstra <peterz@infradead.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Alan Stern <stern@rowland.harvard.edu>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Paul Mackerras <paulus@samba.org>, Prasad <prasad@linux.vnet.ibm.com>,
        Roland McGrath <roland@redhat.com>, linux-kernel@vger.kernel.org
In-Reply-To: <1296124337.15234.71.camel@laptop>
References: <1295617185.28776.273.camel@laptop>
	 <20110121142616.GA31165@redhat.com> <1295622304.28776.293.camel@laptop>
	 <20110121204014.GA2870@nowhere> <20110124114234.GA12166@redhat.com>
	 <20110126175322.GA28617@redhat.com> <20110126184957.GA32578@redhat.com>
	 <1296068731.15234.6.camel@laptop> <1296070383.15234.10.camel@laptop>
	 <20110126211931.GA6778@redhat.com>  <20110126213317.GA7403@redhat.com>
	 <1296124337.15234.71.camel@laptop>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Thu, 27 Jan 2011 13:29:47 +0100
Message-ID: <1296131387.15234.142.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-01-27 at 11:32 +0100, Peter Zijlstra wrote:
> On Wed, 2011-01-26 at 22:33 +0100, Oleg Nesterov wrote:
> > 
> > This is what I had in mind initially but I didn't dare to add the
> > new member into rq, it is only needed for perf. 
> 
> Right, but its a weakness in the task_oncpu_function_call()
> implementation, wouldn't any user run into this problem eventually?

I can't seem to avoid having to add this rq member, but like you said,
we only need to do that when __ARCH_WANT_INTERRUPTS_ON_CTXSW.
I can't seem to avoid having to add this rq member, but like you said,
we only 

We still need to validate p is actually current when the IPI happens,
the test might return true in task_oncpu_function_call() but be false by
the time we process the IPI.

So this should avoid us calling @func when @p isn't (fully) running.

---
 kernel/sched.c |   46 ++++++++++++++++++++++++++++++++++++++++------
 1 files changed, 40 insertions(+), 6 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index 18d38e4..fbff6a8 100644
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
 
@@ -2265,6 +2268,29 @@ void kick_process(struct task_struct *p)
 EXPORT_SYMBOL_GPL(kick_process);
 #endif /* CONFIG_SMP */
 
+struct task_function_call {
+	struct task_struct *p;
+	void (*func)(void *info);
+	void *info;
+};
+
+void task_function_trampoline(void *data)
+{
+	struct task_function_call *tfc = data;
+	struct task_struct *p = tfc->p;
+	struct rq *rq = this_rq();
+
+#ifdef __ARCH_WANT_INTERRUPTS_ON_CTXSW
+	if (rq->in_ctxsw)
+		return;
+#endif
+
+	if (rq->curr != p)
+		return;
+
+	tfc->func(tfc->info);
+}
+
 /**
  * task_oncpu_function_call - call a function on the cpu on which a task runs
  * @p:		the task to evaluate
@@ -2278,11 +2304,16 @@ void task_oncpu_function_call(struct task_struct *p,
 			      void (*func) (void *info), void *info)
 {
 	int cpu;
+	struct task_function_call data = {
+		.p = p,
+		.func = func,
+		.info = info,
+	};
 
 	preempt_disable();
 	cpu = task_cpu(p);
 	if (task_curr(p))
-		smp_call_function_single(cpu, func, info, 1);
+		smp_call_function_single(cpu, task_function_trampoline, &data, 1);
 	preempt_enable();
 }
 
@@ -2776,9 +2807,15 @@ static inline void
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
@@ -2823,6 +2860,7 @@ static void finish_task_switch(struct rq *rq, struct task_struct *prev)
 	perf_event_task_sched_in(current);
 #ifdef __ARCH_WANT_INTERRUPTS_ON_CTXSW
 	local_irq_enable();
+	rq->in_ctxsw = 0;
 #endif /* __ARCH_WANT_INTERRUPTS_ON_CTXSW */
 	finish_lock_switch(rq, prev);
 
@@ -2911,7 +2949,6 @@ context_switch(struct rq *rq, struct task_struct *prev,
 	struct mm_struct *mm, *oldmm;
 
 	prepare_task_switch(rq, prev, next);
-	trace_sched_switch(prev, next);
 	mm = next->mm;
 	oldmm = prev->active_mm;
 	/*
@@ -3989,9 +4026,6 @@ need_resched_nonpreemptible:
 	rq->skip_clock_update = 0;
 
 	if (likely(prev != next)) {
-		sched_info_switch(prev, next);
-		perf_event_task_sched_out(prev, next);
-
 		rq->nr_switches++;
 		rq->curr = next;
 		++*switch_count;

