Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754395Ab1IVWLg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Sep 2011 18:11:36 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:33361 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754260Ab1IVWKe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Sep 2011 18:10:34 -0400
X-Authority-Analysis: v=1.1 cv=XWD5/VRj2HUJOhsR8cgmvPBlhMACpZXxseY1Kn/ehQI= c=1 sm=0 a=vhdKIqpQuCYA:10 a=V23adcgCdw0A:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=17wjrS5wAhQaEczCPkpxpQ==:17 a=20KFwNOVAAAA:8 a=meVymXHHAAAA:8 a=fZNi1hEqrG8KUWg3HJkA:9 a=lu8teYfTEM4DeYI-IV8A:7 a=jEp0ucaQiEUA:10 a=jeBq3FmKZ4MA:10 a=17wjrS5wAhQaEczCPkpxpQ==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.83.30
Message-Id: <20110922221030.111078233@goodmis.org>
User-Agent: quilt/0.48-1
Date: Thu, 22 Sep 2011 18:09:56 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 21/21] tracing: Add optional percpu buffers for trace_printk()
References: <20110922220935.537134016@goodmis.org>
Content-Disposition: inline; filename=0021-tracing-Add-optional-percpu-buffers-for-trace_printk.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

Currently, trace_printk() uses a single buffer to write into
to calculate the size and format needed to save the trace. To
do this safely in an SMP environment, a spin_lock() is taken
to only allow one writer at a time to the buffer. But this could
also affect what is being traced, and add synchronization that
would not be there otherwise.

Ideally, using percpu buffers would be useful, but since trace_printk()
is only used in development, having per cpu buffers for something
never used is a waste of space. We could make this a compile option
but trace_print() may also be used for developing modules, on a
distro kernel.

The approach taken here is to dynamically allocate percpu buffers
with a new tracing/options switch "trace_printk_percpu". It can
be allocated and freed at runtime, or "trace_printk_percpu" may also
be specified on the command line and it will be allocated at boot up.

This allows a developer to create percpu buffers for trace_printk()
on a running system, and also free them when not in used.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 Documentation/kernel-parameters.txt |   11 ++++
 kernel/trace/trace.c                |  105 ++++++++++++++++++++++++++++++++---
 kernel/trace/trace.h                |    1 +
 3 files changed, 108 insertions(+), 9 deletions(-)

diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index e279b72..8fc3e58 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -2521,6 +2521,17 @@ bytes respectively. Such letter suffixes can also be entirely omitted.
 			to facilitate early boot debugging.
 			See also Documentation/trace/events.txt
 
+	trace_printk_percpu
+			[FTRACE] When using trace_printk(), by default the
+			temporary buffer is a single instance with a spinlock
+			to protect it. By adding this switch or enabling it at
+			runtime with:
+			echo 1 > /sys/kernel/debug/tracing/options/trace_printk_percpu
+			Per CPU buffers are allocated and trace_printk() will write
+			to them without taking any locks. Echo 0 into the above
+			file, and the percpu buffers will safely be freed.
+			Even if they were allocated with this kernel command line.
+
 	tsc=		Disable clocksource stability checks for TSC.
 			Format: <string>
 			[x86] reliable: mark tsc clocksource as reliable, this
diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index e463125..8975461 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -343,6 +343,13 @@ unsigned long trace_flags = TRACE_ITER_PRINT_PARENT | TRACE_ITER_PRINTK |
 static int trace_stop_count;
 static DEFINE_SPINLOCK(tracing_start_lock);
 
+static int __init set_percpu_trace_buffer(char *str)
+{
+	trace_flags |= TRACE_ITER_PRINTK_PERCPU;
+	return 1;
+}
+__setup("trace_printk_percpu", set_percpu_trace_buffer);
+
 static void wakeup_work_handler(struct work_struct *work)
 {
 	wake_up(&trace_wait);
@@ -426,6 +433,7 @@ static const char *trace_options[] = {
 	"record-cmd",
 	"overwrite",
 	"disable_on_free",
+	"trace_printk_percpu",
 	NULL
 };
 
@@ -1449,6 +1457,45 @@ static arch_spinlock_t trace_buf_lock =
 	(arch_spinlock_t)__ARCH_SPIN_LOCK_UNLOCKED;
 static DEFINE_MUTEX(trace_ubuf_mutex);
 
+/* created for use with alloc_percpu */
+struct trace_buffer_struct {
+	char buffer[TRACE_BUF_SIZE];
+};
+
+static struct trace_buffer_struct *trace_percpu_buffer;
+
+/*
+ * Since the buffers may be freed, we access the trace_percpu_buffer
+ * once, and then use it or not depending on if it exists.
+ * The code that frees it will NULL out trace_percpu_buffer first
+ * and then performa a synchronize_sched() to ensure all users
+ * are done with it.
+ *
+ * Interrupts are disabled around the get and put operations below.
+ */
+static char *get_trace_buf(int *put)
+{
+	struct trace_buffer_struct *percpu_buffer =
+		rcu_dereference_raw(trace_percpu_buffer);
+	struct trace_buffer_struct *buffer;
+
+	if (percpu_buffer) {
+		*put = 1;
+		buffer = per_cpu_ptr(percpu_buffer, smp_processor_id());
+		return buffer->buffer;
+	}
+	*put = 0;
+	arch_spin_lock(&trace_buf_lock);
+	return trace_buf;
+}
+
+static void put_trace_buf(int put)
+{
+	if (put)
+		return;
+	arch_spin_unlock(&trace_buf_lock);
+}
+
 /**
  * trace_vbprintk - write binary msg to tracing buffer
  *
@@ -1462,9 +1509,11 @@ int trace_vbprintk(unsigned long ip, const char *fmt, va_list args)
 	struct trace_array *tr = &global_trace;
 	struct trace_array_cpu *data;
 	struct bprint_entry *entry;
+	char *tbuffer;
 	unsigned long flags;
 	int disable;
 	int cpu, len = 0, size, pc;
+	int put;
 
 	if (unlikely(tracing_selftest_running || tracing_disabled))
 		return 0;
@@ -1483,8 +1532,8 @@ int trace_vbprintk(unsigned long ip, const char *fmt, va_list args)
 
 	/* Lockdep uses trace_printk for lock tracing */
 	local_irq_save(flags);
-	arch_spin_lock(&trace_buf_lock);
-	len = vbin_printf((u32 *)trace_buf, TRACE_BUF_SIZE/sizeof(int), fmt, args);
+	tbuffer = get_trace_buf(&put);
+	len = vbin_printf((u32 *)tbuffer, TRACE_BUF_SIZE/sizeof(int), fmt, args);
 
 	if (len > TRACE_BUF_SIZE || len < 0)
 		goto out_unlock;
@@ -1499,14 +1548,14 @@ int trace_vbprintk(unsigned long ip, const char *fmt, va_list args)
 	entry->ip			= ip;
 	entry->fmt			= fmt;
 
-	memcpy(entry->buf, trace_buf, sizeof(u32) * len);
+	memcpy(entry->buf, tbuffer, sizeof(u32) * len);
 	if (!filter_check_discard(call, entry, buffer, event)) {
 		ring_buffer_unlock_commit(buffer, event);
 		ftrace_trace_stack(buffer, flags, 6, pc);
 	}
 
 out_unlock:
-	arch_spin_unlock(&trace_buf_lock);
+	put_trace_buf(put);
 	local_irq_restore(flags);
 
 out:
@@ -1543,7 +1592,9 @@ int trace_array_vprintk(struct trace_array *tr,
 	int cpu, len = 0, size, pc;
 	struct print_entry *entry;
 	unsigned long irq_flags;
+	char *tbuffer;
 	int disable;
+	int put;
 
 	if (tracing_disabled || tracing_selftest_running)
 		return 0;
@@ -1559,19 +1610,19 @@ int trace_array_vprintk(struct trace_array *tr,
 
 	pause_graph_tracing();
 	raw_local_irq_save(irq_flags);
-	arch_spin_lock(&trace_buf_lock);
-	len = vsnprintf(trace_buf, TRACE_BUF_SIZE, fmt, args);
+	tbuffer = get_trace_buf(&put);
+	len = vsnprintf(tbuffer, TRACE_BUF_SIZE, fmt, args);
 
 	size = sizeof(*entry) + len + 1;
 	buffer = tr->buffer;
-	event = trace_buffer_lock_reserve(buffer, TRACE_PRINT, size,
+	event = trace_buffer_lock_reserve(tbuffer, TRACE_PRINT, size,
 					  irq_flags, pc);
 	if (!event)
 		goto out_unlock;
 	entry = ring_buffer_event_data(event);
 	entry->ip = ip;
 
-	memcpy(&entry->buf, trace_buf, len);
+	memcpy(&entry->buf, tbuffer, len);
 	entry->buf[len] = '\0';
 	if (!filter_check_discard(call, entry, buffer, event)) {
 		ring_buffer_unlock_commit(buffer, event);
@@ -1579,7 +1630,7 @@ int trace_array_vprintk(struct trace_array *tr,
 	}
 
  out_unlock:
-	arch_spin_unlock(&trace_buf_lock);
+	put_trace_buf(put);
 	raw_local_irq_restore(irq_flags);
 	unpause_graph_tracing();
  out:
@@ -2621,6 +2672,32 @@ static int set_tracer_option(struct tracer *trace, char *cmp, int neg)
 	return -EINVAL;
 }
 
+static void alloc_percpu_trace_buffer(void)
+{
+	struct trace_buffer_struct *buffers;
+
+	if (!(trace_flags & TRACE_ITER_PRINTK_PERCPU))
+		return; /* Warn? */
+
+	buffers = alloc_percpu(struct trace_buffer_struct);
+	if (WARN(!buffers, "Could not allocate percpu trace_printk buffer")) {
+		trace_flags &= ~TRACE_ITER_PRINTK_PERCPU;
+		return;
+	}
+
+	trace_percpu_buffer = buffers;
+}
+
+static void free_percpu_trace_buffer(void)
+{
+	struct trace_buffer_struct *buffers;
+
+	buffers = trace_percpu_buffer;
+	trace_percpu_buffer = NULL;
+	synchronize_sched();
+	free_percpu(buffers);
+}
+
 static void set_tracer_flags(unsigned int mask, int enabled)
 {
 	/* do nothing if flag is already set */
@@ -2637,6 +2714,13 @@ static void set_tracer_flags(unsigned int mask, int enabled)
 
 	if (mask == TRACE_ITER_OVERWRITE)
 		ring_buffer_change_overwrite(global_trace.buffer, enabled);
+
+	if (mask == TRACE_ITER_PRINTK_PERCPU) {
+		if (enabled)
+			alloc_percpu_trace_buffer();
+		else
+			free_percpu_trace_buffer();
+	}
 }
 
 static ssize_t
@@ -4766,6 +4850,9 @@ __init static int tracer_alloc_buffers(void)
 	/* All seems OK, enable tracing */
 	tracing_disabled = 0;
 
+	if (trace_flags & TRACE_ITER_PRINTK_PERCPU)
+		alloc_percpu_trace_buffer();
+
 	atomic_notifier_chain_register(&panic_notifier_list,
 				       &trace_panic_notifier);
 
diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
index 4c7540a..ca4df2b 100644
--- a/kernel/trace/trace.h
+++ b/kernel/trace/trace.h
@@ -652,6 +652,7 @@ enum trace_iterator_flags {
 	TRACE_ITER_RECORD_CMD		= 0x100000,
 	TRACE_ITER_OVERWRITE		= 0x200000,
 	TRACE_ITER_STOP_ON_FREE		= 0x400000,
+	TRACE_ITER_PRINTK_PERCPU	= 0x800000,
 };
 
 /*
-- 
1.7.5.4


