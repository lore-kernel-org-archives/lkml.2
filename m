Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932741Ab0EDS1E (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 May 2010 14:27:04 -0400
Received: from casper.infradead.org ([85.118.1.10]:57689 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932249Ab0EDS1B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 May 2010 14:27:01 -0400
Subject: Re: [PATCH 04/12] perf: add @rq to perf_event_task_sched_out()
From: Peter Zijlstra <peterz@infradead.org>
To: rostedt@goodmis.org
Cc: Tejun Heo <tj@kernel.org>, mingo@elte.hu, efault@gmx.de, avi@redhat.com,
       paulus@samba.org, acme@redhat.com, linux-kernel@vger.kernel.org
In-Reply-To: <1272997363.9739.232.camel@gandalf.stny.rr.com>
References: <1272976724-14312-1-git-send-email-tj@kernel.org>
	 <1272976724-14312-5-git-send-email-tj@kernel.org>
	 <1272993090.1642.184.camel@laptop>  <4BE057EB.80604@kernel.org>
	 <1272997363.9739.232.camel@gandalf.stny.rr.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 04 May 2010 20:26:56 +0200
Message-ID: <1272997616.1642.207.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-05-04 at 14:22 -0400, Steven Rostedt wrote:
> On Tue, 2010-05-04 at 19:22 +0200, Tejun Heo wrote:
> > Hello,
> > 
> > On 05/04/2010 07:11 PM, Peter Zijlstra wrote:
> > > On Tue, 2010-05-04 at 14:38 +0200, Tejun Heo wrote:
> > >> Add @rq to perf_event_task_sched_out() so that its argument matches
> > >> those of trace_sched_switch().  This will help unifying notifiers in
> > >> sched.
> > > 
> > > The alternative is dropping rq from the trace events, its not like
> > > anybody outside sched.o can do anything sensible with it anyway.
> > 
> > The comment in include/trace/events/sched.h says...
> > 
> >  * (NOTE: the 'rq' argument is not used by generic trace events,
> >  *        but used by the latency tracer plugin. )
> > 
> > So, I left it there.  It would be great if all those @rq params can be
> > removed tho.  The latency tracer thing needs it, right?
> 
> I believe the rq was used by the original latency tracer code that was
> in the -rt patch set before ftrace. It is most likely there for
> historical purposes. I guess it would be fine to just remove it.

I'm building the below, so far so good... ;-)

---
 include/trace/events/sched.h      |   32 ++++++++++----------------------
 kernel/sched.c                    |    8 ++++----
 kernel/trace/trace_sched_wakeup.c |    5 ++---
 3 files changed, 16 insertions(+), 29 deletions(-)

diff --git a/include/trace/events/sched.h b/include/trace/events/sched.h
index cfceb0b..4f733ec 100644
--- a/include/trace/events/sched.h
+++ b/include/trace/events/sched.h
@@ -51,15 +51,12 @@ TRACE_EVENT(sched_kthread_stop_ret,
 
 /*
  * Tracepoint for waiting on task to unschedule:
- *
- * (NOTE: the 'rq' argument is not used by generic trace events,
- *        but used by the latency tracer plugin. )
  */
 TRACE_EVENT(sched_wait_task,
 
-	TP_PROTO(struct rq *rq, struct task_struct *p),
+	TP_PROTO(struct task_struct *p),
 
-	TP_ARGS(rq, p),
+	TP_ARGS(p),
 
 	TP_STRUCT__entry(
 		__array(	char,	comm,	TASK_COMM_LEN	)
@@ -79,15 +76,12 @@ TRACE_EVENT(sched_wait_task,
 
 /*
  * Tracepoint for waking up a task:
- *
- * (NOTE: the 'rq' argument is not used by generic trace events,
- *        but used by the latency tracer plugin. )
  */
 DECLARE_EVENT_CLASS(sched_wakeup_template,
 
-	TP_PROTO(struct rq *rq, struct task_struct *p, int success),
+	TP_PROTO(struct task_struct *p, int success),
 
-	TP_ARGS(rq, p, success),
+	TP_ARGS(p, success),
 
 	TP_STRUCT__entry(
 		__array(	char,	comm,	TASK_COMM_LEN	)
@@ -111,31 +105,25 @@ DECLARE_EVENT_CLASS(sched_wakeup_template,
 );
 
 DEFINE_EVENT(sched_wakeup_template, sched_wakeup,
-	     TP_PROTO(struct rq *rq, struct task_struct *p, int success),
-	     TP_ARGS(rq, p, success));
+	     TP_PROTO(struct task_struct *p, int success),
+	     TP_ARGS(p, success));
 
 /*
  * Tracepoint for waking up a new task:
- *
- * (NOTE: the 'rq' argument is not used by generic trace events,
- *        but used by the latency tracer plugin. )
  */
 DEFINE_EVENT(sched_wakeup_template, sched_wakeup_new,
-	     TP_PROTO(struct rq *rq, struct task_struct *p, int success),
-	     TP_ARGS(rq, p, success));
+	     TP_PROTO(struct task_struct *p, int success),
+	     TP_ARGS(p, success));
 
 /*
  * Tracepoint for task switches, performed by the scheduler:
- *
- * (NOTE: the 'rq' argument is not used by generic trace events,
- *        but used by the latency tracer plugin. )
  */
 TRACE_EVENT(sched_switch,
 
-	TP_PROTO(struct rq *rq, struct task_struct *prev,
+	TP_PROTO(struct task_struct *prev,
 		 struct task_struct *next),
 
-	TP_ARGS(rq, prev, next),
+	TP_ARGS(prev, next),
 
 	TP_STRUCT__entry(
 		__array(	char,	prev_comm,	TASK_COMM_LEN	)
diff --git a/kernel/sched.c b/kernel/sched.c
index 9a0f37c..2642864 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -2135,7 +2135,7 @@ unsigned long wait_task_inactive(struct task_struct *p, long match_state)
 		 * just go back and repeat.
 		 */
 		rq = task_rq_lock(p, &flags);
-		trace_sched_wait_task(rq, p);
+		trace_sched_wait_task(p);
 		running = task_running(rq, p);
 		on_rq = p->se.on_rq;
 		ncsw = 0;
@@ -2406,7 +2406,7 @@ out_activate:
 	success = 1;
 
 out_running:
-	trace_sched_wakeup(rq, p, success);
+	trace_sched_wakeup(p, success);
 	check_preempt_curr(rq, p, wake_flags);
 
 	p->state = TASK_RUNNING;
@@ -2580,7 +2580,7 @@ void wake_up_new_task(struct task_struct *p, unsigned long clone_flags)
 
 	rq = task_rq_lock(p, &flags);
 	activate_task(rq, p, 0);
-	trace_sched_wakeup_new(rq, p, 1);
+	trace_sched_wakeup_new(p, 1);
 	check_preempt_curr(rq, p, WF_FORK);
 #ifdef CONFIG_SMP
 	if (p->sched_class->task_woken)
@@ -2800,7 +2800,7 @@ context_switch(struct rq *rq, struct task_struct *prev,
 	struct mm_struct *mm, *oldmm;
 
 	prepare_task_switch(rq, prev, next);
-	trace_sched_switch(rq, prev, next);
+	trace_sched_switch(prev, next);
 	mm = next->mm;
 	oldmm = prev->active_mm;
 	/*
diff --git a/kernel/trace/trace_sched_wakeup.c b/kernel/trace/trace_sched_wakeup.c
index 0271742..8052446 100644
--- a/kernel/trace/trace_sched_wakeup.c
+++ b/kernel/trace/trace_sched_wakeup.c
@@ -107,8 +107,7 @@ static void probe_wakeup_migrate_task(struct task_struct *task, int cpu)
 }
 
 static void notrace
-probe_wakeup_sched_switch(struct rq *rq, struct task_struct *prev,
-	struct task_struct *next)
+probe_wakeup_sched_switch(struct task_struct *prev, struct task_struct *next)
 {
 	struct trace_array_cpu *data;
 	cycle_t T0, T1, delta;
@@ -200,7 +199,7 @@ static void wakeup_reset(struct trace_array *tr)
 }
 
 static void
-probe_wakeup(struct rq *rq, struct task_struct *p, int success)
+probe_wakeup(struct task_struct *p, int success)
 {
 	struct trace_array_cpu *data;
 	int cpu = smp_processor_id();


