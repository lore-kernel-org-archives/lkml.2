Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932280Ab0FDBgY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jun 2010 21:36:24 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:43643 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757143Ab0FDBgA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jun 2010 21:36:00 -0400
X-Authority-Analysis: v=1.1 cv=xm0otvE9/LjRWYlyDrHfx7zP0/MGCmNk7gQgTP1ehto= c=1 sm=0 a=-DfFJafm3JAA:10 a=UBIxAjGgU1YA:10 a=GzHTLUccyWwA:10 a=gMqfjgEr1zLu/65IO0LwxA==:17 a=20KFwNOVAAAA:8 a=meVymXHHAAAA:8 a=eQ5TZtYGM6SOQ88XvSMA:9 a=-d0YSdUaCX9GQj2ZFH0A:7 a=eSeE4uJeQutkQWyZWUKxWcIGAFkA:4 a=jEp0ucaQiEUA:10 a=Zh68SRI7RUMA:10 a=jeBq3FmKZ4MA:10 a=vYjZMIoc039njP89:21 a=r6FCoEo_2D_0Uoxo:21 a=gMqfjgEr1zLu/65IO0LwxA==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.89.75
Message-Id: <20100604013557.373837407@goodmis.org>
User-Agent: quilt/0.48-1
Date: Thu, 03 Jun 2010 21:35:08 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 2/2] tracing: Remove ftrace_preempt_disable/enable
References: <20100604013506.159506222@goodmis.org>
Content-Disposition: inline; filename=0002-tracing-Remove-ftrace_preempt_disable-enable.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

The ftrace_preempt_disable/enable functions were to address a
recursive race caused by the function tracer. The function tracer
traces all functions which makes it easily susceptible to recursion.
One area was preempt_enable(). This would call the scheduler and
the schedulre would call the function tracer and loop.
(So was it thought).

The ftrace_preempt_disable/enable was made to protect against recursion
inside the scheduler by storing the NEED_RESCHED flag. If it was
set before the ftrace_preempt_disable() it would not call schedule
on ftrace_preempt_enable(), thinking that if it was set before then
it would have already scheduled unless it was already in the scheduler.

This worked fine except in the case of SMP, where another task would set
the NEED_RESCHED flag for a task on another CPU, and then kick off an
IPI to trigger it. This could cause the NEED_RESCHED to be saved at
ftrace_preempt_disable() but the IPI to arrive in the the preempt
disabled section. The ftrace_preempt_enable() would not call the scheduler
because the flag was already set before entring the section.

This bug would cause a missed preemption check and cause lower latencies.

Investigating further, I found that the recusion caused by the function
tracer was not due to schedule(), but due to preempt_schedule(). Now
that preempt_schedule is completely annotated with notrace, the recusion
no longer is an issue.

Reported-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/ftrace.c             |    5 +--
 kernel/trace/ring_buffer.c        |   38 ++++++-----------------------
 kernel/trace/trace.c              |    5 +--
 kernel/trace/trace.h              |   48 -------------------------------------
 kernel/trace/trace_clock.c        |    5 +--
 kernel/trace/trace_events.c       |    5 +--
 kernel/trace/trace_functions.c    |    6 ++--
 kernel/trace/trace_sched_wakeup.c |    5 +--
 kernel/trace/trace_stack.c        |    6 ++--
 9 files changed, 24 insertions(+), 99 deletions(-)

diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index 6d2cb14..0d88ce9 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -1883,7 +1883,6 @@ function_trace_probe_call(unsigned long ip, unsigned long parent_ip)
 	struct hlist_head *hhd;
 	struct hlist_node *n;
 	unsigned long key;
-	int resched;
 
 	key = hash_long(ip, FTRACE_HASH_BITS);
 
@@ -1897,12 +1896,12 @@ function_trace_probe_call(unsigned long ip, unsigned long parent_ip)
 	 * period. This syncs the hash iteration and freeing of items
 	 * on the hash. rcu_read_lock is too dangerous here.
 	 */
-	resched = ftrace_preempt_disable();
+	preempt_disable_notrace();
 	hlist_for_each_entry_rcu(entry, n, hhd, node) {
 		if (entry->ip == ip)
 			entry->ops->func(ip, parent_ip, &entry->data);
 	}
-	ftrace_preempt_enable(resched);
+	preempt_enable_notrace();
 }
 
 static struct ftrace_ops trace_probe_ops __read_mostly =
diff --git a/kernel/trace/ring_buffer.c b/kernel/trace/ring_buffer.c
index 7f6059c..c3d3cd9 100644
--- a/kernel/trace/ring_buffer.c
+++ b/kernel/trace/ring_buffer.c
@@ -2234,8 +2234,6 @@ static void trace_recursive_unlock(void)
 
 #endif
 
-static DEFINE_PER_CPU(int, rb_need_resched);
-
 /**
  * ring_buffer_lock_reserve - reserve a part of the buffer
  * @buffer: the ring buffer to reserve from
@@ -2256,13 +2254,13 @@ ring_buffer_lock_reserve(struct ring_buffer *buffer, unsigned long length)
 {
 	struct ring_buffer_per_cpu *cpu_buffer;
 	struct ring_buffer_event *event;
-	int cpu, resched;
+	int cpu;
 
 	if (ring_buffer_flags != RB_BUFFERS_ON)
 		return NULL;
 
 	/* If we are tracing schedule, we don't want to recurse */
-	resched = ftrace_preempt_disable();
+	preempt_disable_notrace();
 
 	if (atomic_read(&buffer->record_disabled))
 		goto out_nocheck;
@@ -2287,21 +2285,13 @@ ring_buffer_lock_reserve(struct ring_buffer *buffer, unsigned long length)
 	if (!event)
 		goto out;
 
-	/*
-	 * Need to store resched state on this cpu.
-	 * Only the first needs to.
-	 */
-
-	if (preempt_count() == 1)
-		per_cpu(rb_need_resched, cpu) = resched;
-
 	return event;
 
  out:
 	trace_recursive_unlock();
 
  out_nocheck:
-	ftrace_preempt_enable(resched);
+	preempt_enable_notrace();
 	return NULL;
 }
 EXPORT_SYMBOL_GPL(ring_buffer_lock_reserve);
@@ -2347,13 +2337,7 @@ int ring_buffer_unlock_commit(struct ring_buffer *buffer,
 
 	trace_recursive_unlock();
 
-	/*
-	 * Only the last preempt count needs to restore preemption.
-	 */
-	if (preempt_count() == 1)
-		ftrace_preempt_enable(per_cpu(rb_need_resched, cpu));
-	else
-		preempt_enable_no_resched_notrace();
+	preempt_enable_notrace();
 
 	return 0;
 }
@@ -2461,13 +2445,7 @@ void ring_buffer_discard_commit(struct ring_buffer *buffer,
 
 	trace_recursive_unlock();
 
-	/*
-	 * Only the last preempt count needs to restore preemption.
-	 */
-	if (preempt_count() == 1)
-		ftrace_preempt_enable(per_cpu(rb_need_resched, cpu));
-	else
-		preempt_enable_no_resched_notrace();
+	preempt_enable_notrace();
 
 }
 EXPORT_SYMBOL_GPL(ring_buffer_discard_commit);
@@ -2493,12 +2471,12 @@ int ring_buffer_write(struct ring_buffer *buffer,
 	struct ring_buffer_event *event;
 	void *body;
 	int ret = -EBUSY;
-	int cpu, resched;
+	int cpu;
 
 	if (ring_buffer_flags != RB_BUFFERS_ON)
 		return -EBUSY;
 
-	resched = ftrace_preempt_disable();
+	preempt_disable_notrace();
 
 	if (atomic_read(&buffer->record_disabled))
 		goto out;
@@ -2528,7 +2506,7 @@ int ring_buffer_write(struct ring_buffer *buffer,
 
 	ret = 0;
  out:
-	ftrace_preempt_enable(resched);
+	preempt_enable_notrace();
 
 	return ret;
 }
diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 55e4851..3572714 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -1404,7 +1404,6 @@ int trace_vbprintk(unsigned long ip, const char *fmt, va_list args)
 	struct bprint_entry *entry;
 	unsigned long flags;
 	int disable;
-	int resched;
 	int cpu, len = 0, size, pc;
 
 	if (unlikely(tracing_selftest_running || tracing_disabled))
@@ -1414,7 +1413,7 @@ int trace_vbprintk(unsigned long ip, const char *fmt, va_list args)
 	pause_graph_tracing();
 
 	pc = preempt_count();
-	resched = ftrace_preempt_disable();
+	preempt_disable_notrace();
 	cpu = raw_smp_processor_id();
 	data = tr->data[cpu];
 
@@ -1452,7 +1451,7 @@ out_unlock:
 
 out:
 	atomic_dec_return(&data->disabled);
-	ftrace_preempt_enable(resched);
+	preempt_enable_notrace();
 	unpause_graph_tracing();
 
 	return len;
diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
index 2cd9639..6c45e55 100644
--- a/kernel/trace/trace.h
+++ b/kernel/trace/trace.h
@@ -628,54 +628,6 @@ enum trace_iterator_flags {
 
 extern struct tracer nop_trace;
 
-/**
- * ftrace_preempt_disable - disable preemption scheduler safe
- *
- * When tracing can happen inside the scheduler, there exists
- * cases that the tracing might happen before the need_resched
- * flag is checked. If this happens and the tracer calls
- * preempt_enable (after a disable), a schedule might take place
- * causing an infinite recursion.
- *
- * To prevent this, we read the need_resched flag before
- * disabling preemption. When we want to enable preemption we
- * check the flag, if it is set, then we call preempt_enable_no_resched.
- * Otherwise, we call preempt_enable.
- *
- * The rational for doing the above is that if need_resched is set
- * and we have yet to reschedule, we are either in an atomic location
- * (where we do not need to check for scheduling) or we are inside
- * the scheduler and do not want to resched.
- */
-static inline int ftrace_preempt_disable(void)
-{
-	int resched;
-
-	resched = need_resched();
-	preempt_disable_notrace();
-
-	return resched;
-}
-
-/**
- * ftrace_preempt_enable - enable preemption scheduler safe
- * @resched: the return value from ftrace_preempt_disable
- *
- * This is a scheduler safe way to enable preemption and not miss
- * any preemption checks. The disabled saved the state of preemption.
- * If resched is set, then we are either inside an atomic or
- * are inside the scheduler (we would have already scheduled
- * otherwise). In this case, we do not want to call normal
- * preempt_enable, but preempt_enable_no_resched instead.
- */
-static inline void ftrace_preempt_enable(int resched)
-{
-	if (resched)
-		preempt_enable_no_resched_notrace();
-	else
-		preempt_enable_notrace();
-}
-
 #ifdef CONFIG_BRANCH_TRACER
 extern int enable_branch_tracing(struct trace_array *tr);
 extern void disable_branch_tracing(void);
diff --git a/kernel/trace/trace_clock.c b/kernel/trace/trace_clock.c
index 9d589d8..52fda6c 100644
--- a/kernel/trace/trace_clock.c
+++ b/kernel/trace/trace_clock.c
@@ -32,16 +32,15 @@
 u64 notrace trace_clock_local(void)
 {
 	u64 clock;
-	int resched;
 
 	/*
 	 * sched_clock() is an architecture implemented, fast, scalable,
 	 * lockless clock. It is not guaranteed to be coherent across
 	 * CPUs, nor across CPU idle events.
 	 */
-	resched = ftrace_preempt_disable();
+	preempt_disable_notrace();
 	clock = sched_clock();
-	ftrace_preempt_enable(resched);
+	preempt_enable_notrace();
 
 	return clock;
 }
diff --git a/kernel/trace/trace_events.c b/kernel/trace/trace_events.c
index 53cffc0..a594f9a 100644
--- a/kernel/trace/trace_events.c
+++ b/kernel/trace/trace_events.c
@@ -1524,12 +1524,11 @@ function_test_events_call(unsigned long ip, unsigned long parent_ip)
 	struct ftrace_entry *entry;
 	unsigned long flags;
 	long disabled;
-	int resched;
 	int cpu;
 	int pc;
 
 	pc = preempt_count();
-	resched = ftrace_preempt_disable();
+	preempt_disable_notrace();
 	cpu = raw_smp_processor_id();
 	disabled = atomic_inc_return(&per_cpu(ftrace_test_event_disable, cpu));
 
@@ -1551,7 +1550,7 @@ function_test_events_call(unsigned long ip, unsigned long parent_ip)
 
  out:
 	atomic_dec(&per_cpu(ftrace_test_event_disable, cpu));
-	ftrace_preempt_enable(resched);
+	preempt_enable_notrace();
 }
 
 static struct ftrace_ops trace_ops __initdata  =
diff --git a/kernel/trace/trace_functions.c b/kernel/trace/trace_functions.c
index b3f3776..16aee4d 100644
--- a/kernel/trace/trace_functions.c
+++ b/kernel/trace/trace_functions.c
@@ -54,14 +54,14 @@ function_trace_call_preempt_only(unsigned long ip, unsigned long parent_ip)
 	struct trace_array_cpu *data;
 	unsigned long flags;
 	long disabled;
-	int cpu, resched;
+	int cpu;
 	int pc;
 
 	if (unlikely(!ftrace_function_enabled))
 		return;
 
 	pc = preempt_count();
-	resched = ftrace_preempt_disable();
+	preempt_disable_notrace();
 	local_save_flags(flags);
 	cpu = raw_smp_processor_id();
 	data = tr->data[cpu];
@@ -71,7 +71,7 @@ function_trace_call_preempt_only(unsigned long ip, unsigned long parent_ip)
 		trace_function(tr, ip, parent_ip, flags, pc);
 
 	atomic_dec(&data->disabled);
-	ftrace_preempt_enable(resched);
+	preempt_enable_notrace();
 }
 
 static void
diff --git a/kernel/trace/trace_sched_wakeup.c b/kernel/trace/trace_sched_wakeup.c
index 0e73bc2..c9fd5bd 100644
--- a/kernel/trace/trace_sched_wakeup.c
+++ b/kernel/trace/trace_sched_wakeup.c
@@ -46,7 +46,6 @@ wakeup_tracer_call(unsigned long ip, unsigned long parent_ip)
 	struct trace_array_cpu *data;
 	unsigned long flags;
 	long disabled;
-	int resched;
 	int cpu;
 	int pc;
 
@@ -54,7 +53,7 @@ wakeup_tracer_call(unsigned long ip, unsigned long parent_ip)
 		return;
 
 	pc = preempt_count();
-	resched = ftrace_preempt_disable();
+	preempt_disable_notrace();
 
 	cpu = raw_smp_processor_id();
 	if (cpu != wakeup_current_cpu)
@@ -74,7 +73,7 @@ wakeup_tracer_call(unsigned long ip, unsigned long parent_ip)
  out:
 	atomic_dec(&data->disabled);
  out_enable:
-	ftrace_preempt_enable(resched);
+	preempt_enable_notrace();
 }
 
 static struct ftrace_ops trace_ops __read_mostly =
diff --git a/kernel/trace/trace_stack.c b/kernel/trace/trace_stack.c
index f4bc9b2..056468e 100644
--- a/kernel/trace/trace_stack.c
+++ b/kernel/trace/trace_stack.c
@@ -110,12 +110,12 @@ static inline void check_stack(void)
 static void
 stack_trace_call(unsigned long ip, unsigned long parent_ip)
 {
-	int cpu, resched;
+	int cpu;
 
 	if (unlikely(!ftrace_enabled || stack_trace_disabled))
 		return;
 
-	resched = ftrace_preempt_disable();
+	preempt_disable_notrace();
 
 	cpu = raw_smp_processor_id();
 	/* no atomic needed, we only modify this variable by this cpu */
@@ -127,7 +127,7 @@ stack_trace_call(unsigned long ip, unsigned long parent_ip)
  out:
 	per_cpu(trace_active, cpu)--;
 	/* prevent recursion in schedule */
-	ftrace_preempt_enable(resched);
+	preempt_enable_notrace();
 }
 
 static struct ftrace_ops trace_ops __read_mostly =
-- 
1.7.0


