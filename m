Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753359Ab1A0O1q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jan 2011 09:27:46 -0500
Received: from casper.infradead.org ([85.118.1.10]:44117 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753087Ab1A0O1p convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jan 2011 09:27:45 -0500
Subject: Re: Q: perf_install_in_context/perf_event_enable are racy?
From: Peter Zijlstra <peterz@infradead.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Alan Stern <stern@rowland.harvard.edu>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Paul Mackerras <paulus@samba.org>, Prasad <prasad@linux.vnet.ibm.com>,
        Roland McGrath <roland@redhat.com>, linux-kernel@vger.kernel.org
In-Reply-To: <1296134077.15234.161.camel@laptop>
References: <20101108145725.GA3434@redhat.com>
	 <20110119182141.GA12183@redhat.com> <20110120193033.GA13924@redhat.com>
	 <1295611905.28776.269.camel@laptop> <20110121130323.GA12900@elte.hu>
	 <1295617185.28776.273.camel@laptop> <20110121142616.GA31165@redhat.com>
	 <1295622304.28776.293.camel@laptop> <20110121204014.GA2870@nowhere>
	 <20110124114234.GA12166@redhat.com>  <20110126175322.GA28617@redhat.com>
	 <1296134077.15234.161.camel@laptop>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Thu, 27 Jan 2011 15:28:23 +0100
Message-ID: <1296138503.15234.220.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-01-27 at 14:14 +0100, Peter Zijlstra wrote:
> 
> With, however, things are more interesting. 2 seems to be adequately
> covered by the patch I just send, the IPI will bail and the next
> sched-in of the relevant task will pick matters up. 1 otoh doesn't seem
> covered, the IPI will bail, leaving us stranded. 

blergh, so the race condition specific for perf can be cured by putting
the ->in_ctxsw = 0, under the local_irq_disable(). When we hit early,
the perf_event_task_sched_in() will do the job and we can simply bail in
the IPI. If he hit late, the IPI will be delayed until after, and we'll
be case 3 again.

More generic task_oncpu_function_call() users, say using preempt
notifiers will have to deal with the fact that the sched_in notifier
runs after we unlock/enable irqs.

<crazy idea here> 

So I was contemplating if we could make things work by placing
rq->nr_switches++; _after_ context_switch() and use:

rq->curr != current
mb() /* implied by ctxsw? */
rq->nr_switches++

to do something like:

nr_switches = rq->nr_switches;
smp_rmb();
if (rq->curr != current) {
  smp_rmb();
  while (rq->nr_switches == nr_switches)
    cpu_relax();
}

to synchronize things, but then my head hurt.. mostly because you can
only use rq->curr != current on the local cpu, in which case spinning
will deadlock you.

The 'solution' seemed to be to do that test from an IPI, and return the
state in struct task_function_call, then spin on the other cpu..

So I've likely fallen off a cliff somewhere along the line, but just in
case, here's the patch:
---

 kernel/sched.c |   57 ++++++++++++++++++++++++++++++++++++++++++++++++-------
 1 files changed, 49 insertions(+), 8 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index 18d38e4..31f8d75 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -2265,6 +2265,30 @@ void kick_process(struct task_struct *p)
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
+	if (rq->curr != current) {
+		tfc->ret = 1;
+		return;
+	}
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
@@ -2277,12 +2301,30 @@ EXPORT_SYMBOL_GPL(kick_process);
 void task_oncpu_function_call(struct task_struct *p,
 			      void (*func) (void *info), void *info)
 {
+	struct task_function_call data = {
+		.p = p,
+		.func = func,
+		.info = info,
+	};
+	unsigned long nr_switches;
+	struct rq *rq;
 	int cpu;
 
 	preempt_disable();
-	cpu = task_cpu(p);
-	if (task_curr(p))
-		smp_call_function_single(cpu, func, info, 1);
+again:
+	data.ret = 0;
+	rq = task_rq(p);
+	nr_switches = rq->nr_switches;
+	smp_rmb();
+	if (task_curr(p)) {
+		smp_call_function_single(cpu_of(rq), 
+				task_function_trampoline, &data, 1);
+		if (data.ret == 1) {
+			while (rq->nr_switches == nr_switches)
+				cpu_relax();
+			goto again;
+		}
+	}
 	preempt_enable();
 }
 
@@ -2776,9 +2818,12 @@ static inline void
 prepare_task_switch(struct rq *rq, struct task_struct *prev,
 		    struct task_struct *next)
 {
+	sched_info_switch(prev, next);
+	perf_event_task_sched_out(prev, next);
 	fire_sched_out_preempt_notifiers(prev, next);
 	prepare_lock_switch(rq, next);
 	prepare_arch_switch(next);
+	trace_sched_switch(prev, next);
 }
 
 /**
@@ -2911,7 +2956,6 @@ context_switch(struct rq *rq, struct task_struct *prev,
 	struct mm_struct *mm, *oldmm;
 
 	prepare_task_switch(rq, prev, next);
-	trace_sched_switch(prev, next);
 	mm = next->mm;
 	oldmm = prev->active_mm;
 	/*
@@ -3989,10 +4033,6 @@ need_resched_nonpreemptible:
 	rq->skip_clock_update = 0;
 
 	if (likely(prev != next)) {
-		sched_info_switch(prev, next);
-		perf_event_task_sched_out(prev, next);
-
-		rq->nr_switches++;
 		rq->curr = next;
 		++*switch_count;
 
@@ -4005,6 +4045,7 @@ need_resched_nonpreemptible:
 		 */
 		cpu = smp_processor_id();
 		rq = cpu_rq(cpu);
+		rq->nr_switches++;
 	} else
 		raw_spin_unlock_irq(&rq->lock);
 

