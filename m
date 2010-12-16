Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756436Ab0LPPPE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Dec 2010 10:15:04 -0500
Received: from canuck.infradead.org ([134.117.69.58]:59341 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756420Ab0LPPPB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Dec 2010 10:15:01 -0500
Message-Id: <20101216150920.866959114@chello.nl>
User-Agent: quilt/0.48-1
Date: Thu, 16 Dec 2010 15:56:05 +0100
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Chris Mason <chris.mason@oracle.com>,
        Frank Rowand <frank.rowand@am.sony.com>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>, Mike Galbraith <efault@gmx.de>,
        Oleg Nesterov <oleg@redhat.com>, Paul Turner <pjt@google.com>,
        Jens Axboe <axboe@kernel.dk>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [RFC][PATCH 3/5] sched: Change the ttwu success details
References: <20101216145602.899838254@chello.nl>
Content-Disposition: inline; filename=sched-change-ttwu-return.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

try_to_wake_up() would only return a success when it would have to
place a task on a rq, change that to every time we change p->state to
TASK_RUNNING, because that's the real measure of wakeups.

This results in that success is always true for the tracepoint, so
remove its success argument.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 include/trace/events/sched.h      |   18 ++++++++----------
 kernel/sched.c                    |   18 ++++++++----------
 kernel/trace/trace_sched_wakeup.c |    3 +--
 3 files changed, 17 insertions(+), 22 deletions(-)

Index: linux-2.6/kernel/sched.c
===================================================================
--- linux-2.6.orig/kernel/sched.c
+++ linux-2.6/kernel/sched.c
@@ -2327,10 +2327,10 @@ static inline void ttwu_activate(struct 
 	activate_task(rq, p, en_flags);
 }
 
-static inline void ttwu_post_activation(struct task_struct *p, struct rq *rq,
-					int wake_flags, bool success)
+static void
+ttwu_post_activation(struct task_struct *p, struct rq *rq, int wake_flags)
 {
-	trace_sched_wakeup(p, success);
+	trace_sched_wakeup(p);
 	check_preempt_curr(rq, p, wake_flags);
 
 	p->state = TASK_RUNNING;
@@ -2350,7 +2350,7 @@ static inline void ttwu_post_activation(
 	}
 #endif
 	/* if a worker is waking up, notify workqueue */
-	if ((p->flags & PF_WQ_WORKER) && success)
+	if (p->flags & PF_WQ_WORKER)
 		wq_worker_waking_up(p, cpu_of(rq));
 }
 
@@ -2449,9 +2449,9 @@ static int try_to_wake_up(struct task_st
 #endif /* CONFIG_SMP */
 	ttwu_activate(p, rq, wake_flags & WF_SYNC, orig_cpu != cpu,
 		      cpu == this_cpu, en_flags);
-	success = 1;
 out_running:
-	ttwu_post_activation(p, rq, wake_flags, success);
+	ttwu_post_activation(p, rq, wake_flags);
+	success = 1;
 out:
 	task_rq_unlock(rq, &flags);
 	put_cpu();
@@ -2470,7 +2470,6 @@ static int try_to_wake_up(struct task_st
 static void try_to_wake_up_local(struct task_struct *p)
 {
 	struct rq *rq = task_rq(p);
-	bool success = false;
 
 	BUG_ON(rq != this_rq());
 	BUG_ON(p == current);
@@ -2485,9 +2484,8 @@ static void try_to_wake_up_local(struct 
 			schedstat_inc(rq, ttwu_local);
 		}
 		ttwu_activate(p, rq, false, false, true, ENQUEUE_WAKEUP);
-		success = true;
 	}
-	ttwu_post_activation(p, rq, 0, success);
+	ttwu_post_activation(p, rq, 0);
 }
 
 /**
@@ -2649,7 +2647,7 @@ void wake_up_new_task(struct task_struct
 
 	rq = task_rq_lock(p, &flags);
 	activate_task(rq, p, 0);
-	trace_sched_wakeup_new(p, 1);
+	trace_sched_wakeup_new(p);
 	check_preempt_curr(rq, p, WF_FORK);
 #ifdef CONFIG_SMP
 	if (p->sched_class->task_woken)
Index: linux-2.6/include/trace/events/sched.h
===================================================================
--- linux-2.6.orig/include/trace/events/sched.h
+++ linux-2.6/include/trace/events/sched.h
@@ -54,15 +54,14 @@ TRACE_EVENT(sched_kthread_stop_ret,
  */
 DECLARE_EVENT_CLASS(sched_wakeup_template,
 
-	TP_PROTO(struct task_struct *p, int success),
+	TP_PROTO(struct task_struct *p),
 
-	TP_ARGS(p, success),
+	TP_ARGS(p),
 
 	TP_STRUCT__entry(
 		__array(	char,	comm,	TASK_COMM_LEN	)
 		__field(	pid_t,	pid			)
 		__field(	int,	prio			)
-		__field(	int,	success			)
 		__field(	int,	target_cpu		)
 	),
 
@@ -70,25 +69,24 @@ DECLARE_EVENT_CLASS(sched_wakeup_templat
 		memcpy(__entry->comm, p->comm, TASK_COMM_LEN);
 		__entry->pid		= p->pid;
 		__entry->prio		= p->prio;
-		__entry->success	= success;
 		__entry->target_cpu	= task_cpu(p);
 	),
 
-	TP_printk("comm=%s pid=%d prio=%d success=%d target_cpu=%03d",
+	TP_printk("comm=%s pid=%d prio=%d target_cpu=%03d",
 		  __entry->comm, __entry->pid, __entry->prio,
-		  __entry->success, __entry->target_cpu)
+		  __entry->target_cpu)
 );
 
 DEFINE_EVENT(sched_wakeup_template, sched_wakeup,
-	     TP_PROTO(struct task_struct *p, int success),
-	     TP_ARGS(p, success));
+	     TP_PROTO(struct task_struct *p),
+	     TP_ARGS(p));
 
 /*
  * Tracepoint for waking up a new task:
  */
 DEFINE_EVENT(sched_wakeup_template, sched_wakeup_new,
-	     TP_PROTO(struct task_struct *p, int success),
-	     TP_ARGS(p, success));
+	     TP_PROTO(struct task_struct *p),
+	     TP_ARGS(p));
 
 #ifdef CREATE_TRACE_POINTS
 static inline long __trace_sched_switch_state(struct task_struct *p)
Index: linux-2.6/kernel/trace/trace_sched_wakeup.c
===================================================================
--- linux-2.6.orig/kernel/trace/trace_sched_wakeup.c
+++ linux-2.6/kernel/trace/trace_sched_wakeup.c
@@ -399,8 +399,7 @@ static void wakeup_reset(struct trace_ar
 	local_irq_restore(flags);
 }
 
-static void
-probe_wakeup(void *ignore, struct task_struct *p, int success)
+static void probe_wakeup(void *ignore, struct task_struct *p)
 {
 	struct trace_array_cpu *data;
 	int cpu = smp_processor_id();
diff --git a/kernel/trace/trace_sched_switch.c b/kernel/trace/trace_sched_switch.c
index 8f758d0..bb1ba50 100644
--- a/kernel/trace/trace_sched_switch.c
+++ b/kernel/trace/trace_sched_switch.c
@@ -108,7 +108,7 @@ tracing_sched_wakeup_trace(struct trace_array *tr,
 }
 
 static void
-probe_sched_wakeup(void *ignore, struct task_struct *wakee, int success)
+probe_sched_wakeup(void *ignore, struct task_struct *wakee)
 {
 	struct trace_array_cpu *data;
 	unsigned long flags;


