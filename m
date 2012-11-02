Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934524Ab2KBSOj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Nov 2012 14:14:39 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:22935 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934115Ab2KBSOh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Nov 2012 14:14:37 -0400
X-Authority-Analysis: v=2.0 cv=YP4dOG6x c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=4wpv6kYUfLYA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=SEJFRMVsQgQA:10 a=20KFwNOVAAAA:8 a=Fjapi_lNa2L97Yh5HBIA:9 a=QEXdDO2ut3YA:10 a=jEp0ucaQiEUA:10 a=jeBq3FmKZ4MA:10 a=-AU2fn0SZKyox4TPGZkA:9 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.115.198
Message-Id: <20121102181433.042369602@goodmis.org>
User-Agent: quilt/0.60-1
Date: Fri, 02 Nov 2012 14:13:49 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 18/19] tracing: Use irq_work for wake ups and remove *_nowake_*() functions
References: <20121102181331.513782854@goodmis.org>
Content-Disposition: inline; filename=0018-tracing-Use-irq_work-for-wake-ups-and-remove-_nowake.patch
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="00GvhwF7k39YY"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--00GvhwF7k39YY
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

From: Steven Rostedt <srostedt@redhat.com>

Have the ring buffer commit function use the irq_work infrastructure to
wake up any waiters waiting on the ring buffer for new data. The irq_work
was created for such a purpose, where doing the actual wake up at the
time of adding data is too dangerous, as an event or function trace may
be in the midst of the work queue locks and cause deadlocks. The irq_work
will either delay the action to the next timer interrupt, or trigger an IPI
to itself forcing an interrupt to do the work (in a safe location).

With irq_work, all ring buffer commits can safely do wakeups, removing
the need for the ring buffer commit "nowake" variants, which were used
by events and function tracing. All commits can now safely use the
normal commit, and the "nowake" variants can be removed.

Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 include/linux/ftrace_event.h      |   14 ++---
 include/trace/ftrace.h            |    3 +-
 kernel/trace/Kconfig              |    1 +
 kernel/trace/trace.c              |  121 +++++++++++++++++++++------------=
----
 kernel/trace/trace.h              |    5 --
 kernel/trace/trace_events.c       |    2 +-
 kernel/trace/trace_kprobe.c       |    8 +--
 kernel/trace/trace_sched_switch.c |    2 +-
 kernel/trace/trace_selftest.c     |    1 +
 9 files changed, 84 insertions(+), 73 deletions(-)

diff --git a/include/linux/ftrace_event.h b/include/linux/ftrace_event.h
index 642928c..b80c8dd 100644
--- a/include/linux/ftrace_event.h
+++ b/include/linux/ftrace_event.h
@@ -127,13 +127,13 @@ trace_current_buffer_lock_reserve(struct ring_buffer =
**current_buffer,
 void trace_current_buffer_unlock_commit(struct ring_buffer *buffer,
 					struct ring_buffer_event *event,
 					unsigned long flags, int pc);
-void trace_nowake_buffer_unlock_commit(struct ring_buffer *buffer,
-				       struct ring_buffer_event *event,
-					unsigned long flags, int pc);
-void trace_nowake_buffer_unlock_commit_regs(struct ring_buffer *buffer,
-					    struct ring_buffer_event *event,
-					    unsigned long flags, int pc,
-					    struct pt_regs *regs);
+void trace_buffer_unlock_commit(struct ring_buffer *buffer,
+				struct ring_buffer_event *event,
+				unsigned long flags, int pc);
+void trace_buffer_unlock_commit_regs(struct ring_buffer *buffer,
+				     struct ring_buffer_event *event,
+				     unsigned long flags, int pc,
+				     struct pt_regs *regs);
 void trace_current_buffer_discard_commit(struct ring_buffer *buffer,
 					 struct ring_buffer_event *event);
=20
diff --git a/include/trace/ftrace.h b/include/trace/ftrace.h
index a763888..698f2a8 100644
--- a/include/trace/ftrace.h
+++ b/include/trace/ftrace.h
@@ -545,8 +545,7 @@ ftrace_raw_event_##call(void *__data, proto)				\
 	{ assign; }							\
 									\
 	if (!filter_current_check_discard(buffer, event_call, entry, event)) \
-		trace_nowake_buffer_unlock_commit(buffer,		\
-						  event, irq_flags, pc); \
+		trace_buffer_unlock_commit(buffer, event, irq_flags, pc); \
 }
 /*
  * The ftrace_test_probe is compiled out, it is only here as a build time =
check
diff --git a/kernel/trace/Kconfig b/kernel/trace/Kconfig
index 4cea4f4..5d89335 100644
--- a/kernel/trace/Kconfig
+++ b/kernel/trace/Kconfig
@@ -119,6 +119,7 @@ config TRACING
 	select BINARY_PRINTF
 	select EVENT_TRACING
 	select TRACE_CLOCK
+	select IRQ_WORK
=20
 config GENERIC_TRACER
 	bool
diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index d5cbc0d..37d1c70 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -19,6 +19,7 @@
 #include <linux/seq_file.h>
 #include <linux/notifier.h>
 #include <linux/irqflags.h>
+#include <linux/irq_work.h>
 #include <linux/debugfs.h>
 #include <linux/pagemap.h>
 #include <linux/hardirq.h>
@@ -85,6 +86,14 @@ static int dummy_set_flag(u32 old_flags, u32 bit, int se=
t)
 static DEFINE_PER_CPU(bool, trace_cmdline_save);
=20
 /*
+ * When a reader is waiting for data, then this variable is
+ * set to true.
+ */
+static bool trace_wakeup_needed;
+
+static struct irq_work trace_work_wakeup;
+
+/*
  * Kill all tracing for good (never come back).
  * It is initialized to 1 but will turn to zero if the initialization
  * of the tracer is successful. But that is the only place that sets
@@ -329,12 +338,18 @@ unsigned long trace_flags =3D TRACE_ITER_PRINT_PARENT=
 | TRACE_ITER_PRINTK |
 static int trace_stop_count;
 static DEFINE_RAW_SPINLOCK(tracing_start_lock);
=20
-static void wakeup_work_handler(struct work_struct *work)
+/**
+ * trace_wake_up - wake up tasks waiting for trace input
+ *
+ * Schedules a delayed work to wake up any task that is blocked on the
+ * trace_wait queue. These is used with trace_poll for tasks polling the
+ * trace.
+ */
+static void trace_wake_up(struct irq_work *work)
 {
-	wake_up(&trace_wait);
-}
+	wake_up_all(&trace_wait);
=20
-static DECLARE_DELAYED_WORK(wakeup_work, wakeup_work_handler);
+}
=20
 /**
  * tracing_on - enable tracing buffers
@@ -389,22 +404,6 @@ int tracing_is_on(void)
 }
 EXPORT_SYMBOL_GPL(tracing_is_on);
=20
-/**
- * trace_wake_up - wake up tasks waiting for trace input
- *
- * Schedules a delayed work to wake up any task that is blocked on the
- * trace_wait queue. These is used with trace_poll for tasks polling the
- * trace.
- */
-void trace_wake_up(void)
-{
-	const unsigned long delay =3D msecs_to_jiffies(2);
-
-	if (trace_flags & TRACE_ITER_BLOCK)
-		return;
-	schedule_delayed_work(&wakeup_work, delay);
-}
-
 static int __init set_buf_size(char *str)
 {
 	unsigned long buf_size;
@@ -753,6 +752,40 @@ update_max_tr_single(struct trace_array *tr, struct ta=
sk_struct *tsk, int cpu)
 }
 #endif /* CONFIG_TRACER_MAX_TRACE */
=20
+static void default_wait_pipe(struct trace_iterator *iter)
+{
+	DEFINE_WAIT(wait);
+
+	prepare_to_wait(&trace_wait, &wait, TASK_INTERRUPTIBLE);
+
+	/*
+	 * The events can happen in critical sections where
+	 * checking a work queue can cause deadlocks.
+	 * After adding a task to the queue, this flag is set
+	 * only to notify events to try to wake up the queue
+	 * using irq_work.
+	 *
+	 * We don't clear it even if the buffer is no longer
+	 * empty. The flag only causes the next event to run
+	 * irq_work to do the work queue wake up. The worse
+	 * that can happen if we race with !trace_empty() is that
+	 * an event will cause an irq_work to try to wake up
+	 * an empty queue.
+	 *
+	 * There's no reason to protect this flag either, as
+	 * the work queue and irq_work logic will do the necessary
+	 * synchronization for the wake ups. The only thing
+	 * that is necessary is that the wake up happens after
+	 * a task has been queued. It's OK for spurious wake ups.
+	 */
+	trace_wakeup_needed =3D true;
+
+	if (trace_empty(iter))
+		schedule();
+
+	finish_wait(&trace_wait, &wait);
+}
+
 /**
  * register_tracer - register a tracer with the ftrace system.
  * @type - the plugin for the tracer
@@ -1156,30 +1189,32 @@ void
 __buffer_unlock_commit(struct ring_buffer *buffer, struct ring_buffer_even=
t *event)
 {
 	__this_cpu_write(trace_cmdline_save, true);
+	if (trace_wakeup_needed) {
+		trace_wakeup_needed =3D false;
+		/* irq_work_queue() supplies it's own memory barriers */
+		irq_work_queue(&trace_work_wakeup);
+	}
 	ring_buffer_unlock_commit(buffer, event);
 }
=20
 static inline void
 __trace_buffer_unlock_commit(struct ring_buffer *buffer,
 			     struct ring_buffer_event *event,
-			     unsigned long flags, int pc,
-			     int wake)
+			     unsigned long flags, int pc)
 {
 	__buffer_unlock_commit(buffer, event);
=20
 	ftrace_trace_stack(buffer, flags, 6, pc);
 	ftrace_trace_userstack(buffer, flags, pc);
-
-	if (wake)
-		trace_wake_up();
 }
=20
 void trace_buffer_unlock_commit(struct ring_buffer *buffer,
 				struct ring_buffer_event *event,
 				unsigned long flags, int pc)
 {
-	__trace_buffer_unlock_commit(buffer, event, flags, pc, 1);
+	__trace_buffer_unlock_commit(buffer, event, flags, pc);
 }
+EXPORT_SYMBOL_GPL(trace_buffer_unlock_commit);
=20
 struct ring_buffer_event *
 trace_current_buffer_lock_reserve(struct ring_buffer **current_rb,
@@ -1196,29 +1231,21 @@ void trace_current_buffer_unlock_commit(struct ring=
_buffer *buffer,
 					struct ring_buffer_event *event,
 					unsigned long flags, int pc)
 {
-	__trace_buffer_unlock_commit(buffer, event, flags, pc, 1);
+	__trace_buffer_unlock_commit(buffer, event, flags, pc);
 }
 EXPORT_SYMBOL_GPL(trace_current_buffer_unlock_commit);
=20
-void trace_nowake_buffer_unlock_commit(struct ring_buffer *buffer,
-				       struct ring_buffer_event *event,
-				       unsigned long flags, int pc)
-{
-	__trace_buffer_unlock_commit(buffer, event, flags, pc, 0);
-}
-EXPORT_SYMBOL_GPL(trace_nowake_buffer_unlock_commit);
-
-void trace_nowake_buffer_unlock_commit_regs(struct ring_buffer *buffer,
-					    struct ring_buffer_event *event,
-					    unsigned long flags, int pc,
-					    struct pt_regs *regs)
+void trace_buffer_unlock_commit_regs(struct ring_buffer *buffer,
+				     struct ring_buffer_event *event,
+				     unsigned long flags, int pc,
+				     struct pt_regs *regs)
 {
 	__buffer_unlock_commit(buffer, event);
=20
 	ftrace_trace_stack_regs(buffer, flags, 0, pc, regs);
 	ftrace_trace_userstack(buffer, flags, pc);
 }
-EXPORT_SYMBOL_GPL(trace_nowake_buffer_unlock_commit_regs);
+EXPORT_SYMBOL_GPL(trace_buffer_unlock_commit_regs);
=20
 void trace_current_buffer_discard_commit(struct ring_buffer *buffer,
 					 struct ring_buffer_event *event)
@@ -3354,19 +3381,6 @@ tracing_poll_pipe(struct file *filp, poll_table *pol=
l_table)
 	}
 }
=20
-
-void default_wait_pipe(struct trace_iterator *iter)
-{
-	DEFINE_WAIT(wait);
-
-	prepare_to_wait(&trace_wait, &wait, TASK_INTERRUPTIBLE);
-
-	if (trace_empty(iter))
-		schedule();
-
-	finish_wait(&trace_wait, &wait);
-}
-
 /*
  * This is a make-shift waitqueue.
  * A tracer might use this callback on some rare cases:
@@ -5107,6 +5121,7 @@ __init static int tracer_alloc_buffers(void)
 #endif
=20
 	trace_init_cmdlines();
+	init_irq_work(&trace_work_wakeup, trace_wake_up);
=20
 	register_tracer(&nop_trace);
 	current_trace =3D &nop_trace;
diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
index 3e8a176..55010ed 100644
--- a/kernel/trace/trace.h
+++ b/kernel/trace/trace.h
@@ -327,7 +327,6 @@ trace_buffer_iter(struct trace_iterator *iter, int cpu)
=20
 int tracer_init(struct tracer *t, struct trace_array *tr);
 int tracing_is_enabled(void);
-void trace_wake_up(void);
 void tracing_reset(struct trace_array *tr, int cpu);
 void tracing_reset_online_cpus(struct trace_array *tr);
 void tracing_reset_current(int cpu);
@@ -349,9 +348,6 @@ trace_buffer_lock_reserve(struct ring_buffer *buffer,
 			  unsigned long len,
 			  unsigned long flags,
 			  int pc);
-void trace_buffer_unlock_commit(struct ring_buffer *buffer,
-				struct ring_buffer_event *event,
-				unsigned long flags, int pc);
=20
 struct trace_entry *tracing_get_trace_entry(struct trace_array *tr,
 						struct trace_array_cpu *data);
@@ -370,7 +366,6 @@ void trace_init_global_iter(struct trace_iterator *iter=
);
=20
 void tracing_iter_reset(struct trace_iterator *iter, int cpu);
=20
-void default_wait_pipe(struct trace_iterator *iter);
 void poll_wait_pipe(struct trace_iterator *iter);
=20
 void ftrace(struct trace_array *tr,
diff --git a/kernel/trace/trace_events.c b/kernel/trace/trace_events.c
index cb2df3b..880073d 100644
--- a/kernel/trace/trace_events.c
+++ b/kernel/trace/trace_events.c
@@ -1760,7 +1760,7 @@ function_test_events_call(unsigned long ip, unsigned =
long parent_ip,
 	entry->ip			=3D ip;
 	entry->parent_ip		=3D parent_ip;
=20
-	trace_nowake_buffer_unlock_commit(buffer, event, flags, pc);
+	trace_buffer_unlock_commit(buffer, event, flags, pc);
=20
  out:
 	atomic_dec(&per_cpu(ftrace_test_event_disable, cpu));
diff --git a/kernel/trace/trace_kprobe.c b/kernel/trace/trace_kprobe.c
index 5a3c533..1865d5f 100644
--- a/kernel/trace/trace_kprobe.c
+++ b/kernel/trace/trace_kprobe.c
@@ -751,8 +751,8 @@ static __kprobes void kprobe_trace_func(struct kprobe *=
kp, struct pt_regs *regs)
 	store_trace_args(sizeof(*entry), tp, regs, (u8 *)&entry[1], dsize);
=20
 	if (!filter_current_check_discard(buffer, call, entry, event))
-		trace_nowake_buffer_unlock_commit_regs(buffer, event,
-						       irq_flags, pc, regs);
+		trace_buffer_unlock_commit_regs(buffer, event,
+						irq_flags, pc, regs);
 }
=20
 /* Kretprobe handler */
@@ -784,8 +784,8 @@ static __kprobes void kretprobe_trace_func(struct kretp=
robe_instance *ri,
 	store_trace_args(sizeof(*entry), tp, regs, (u8 *)&entry[1], dsize);
=20
 	if (!filter_current_check_discard(buffer, call, entry, event))
-		trace_nowake_buffer_unlock_commit_regs(buffer, event,
-						       irq_flags, pc, regs);
+		trace_buffer_unlock_commit_regs(buffer, event,
+						irq_flags, pc, regs);
 }
=20
 /* Event entry printers */
diff --git a/kernel/trace/trace_sched_switch.c b/kernel/trace/trace_sched_s=
witch.c
index b0a136a..3374c79 100644
--- a/kernel/trace/trace_sched_switch.c
+++ b/kernel/trace/trace_sched_switch.c
@@ -102,7 +102,7 @@ tracing_sched_wakeup_trace(struct trace_array *tr,
 	entry->next_cpu			=3D task_cpu(wakee);
=20
 	if (!filter_check_discard(call, entry, buffer, event))
-		trace_nowake_buffer_unlock_commit(buffer, event, flags, pc);
+		trace_buffer_unlock_commit(buffer, event, flags, pc);
 }
=20
 static void
diff --git a/kernel/trace/trace_selftest.c b/kernel/trace/trace_selftest.c
index 091b815..4762316 100644
--- a/kernel/trace/trace_selftest.c
+++ b/kernel/trace/trace_selftest.c
@@ -1094,6 +1094,7 @@ trace_selftest_startup_wakeup(struct tracer *trace, s=
truct trace_array *tr)
 	tracing_stop();
 	/* check both trace buffers */
 	ret =3D trace_test_buffer(tr, NULL);
+	printk("ret =3D %d\n", ret);
 	if (!ret)
 		ret =3D trace_test_buffer(&max_tr, &count);
=20
--=20
1.7.10.4



--00GvhwF7k39YY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQEcBAABAgAGBQJQlA2JAAoJEOdOSU1xswtMRuUH/RratXsmy3J1pvAKmeljxbPz
M8mIetwVCjoEgI2h5aq6Ambtkgjo4nYvzBCet+K1h7lMWZGe7Z6sY5peuL1OgWfM
3E3QxJ9hdQi2Gl4a3ajhAUTImQlIoc38SZK4kNzsl9YhdfVeGub5BCyH8P6cdo9a
rrTXSR+lbfNA+qJy14Y9gg+Je2x5unTEU8h7cP4wP2Q6+o4FxAP1xCVkpMzP5EQJ
SImwfETMlXxTQTLi2a6qJCb0EiVb6hxBvndbSPFIYUBp7bGvCvnKyM7nioJGkSbU
r1WvRLcMzO/4RfsVC3Xwm3jjiJOKr+0yBKDJLRdyT+xUflICY7ighqWC2xD6xbA=
=JIC5
-----END PGP SIGNATURE-----

--00GvhwF7k39YY--
