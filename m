Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757508Ab2C0DDf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Mar 2012 23:03:35 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:20696 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756875Ab2C0DDd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Mar 2012 23:03:33 -0400
X-Authority-Analysis: v=2.0 cv=Z8Fu7QtA c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=zb4Bl8YQdJYA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=20KFwNOVAAAA:8 a=meVymXHHAAAA:8 a=vMFpCa-iGLila6ozqqYA:9 a=MIaVOy4vE3SYvc5jpJYA:7 a=PUjeQqilurYA:10 a=jEp0ucaQiEUA:10 a=jeBq3FmKZ4MA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1332817411.23924.121.camel@gandalf.stny.rr.com>
Subject: [PATCH][RFC] tracing: Add percpu buffers for trace_printk()
From: Steven Rostedt <rostedt@goodmis.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>
Date: Mon, 26 Mar 2012 23:03:31 -0400
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.2.2-1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This is a new version of the trace_printk() lockless code.

Previously, I posted an RFC patch set that convert the trace_printk() to
use per-cpu buffers. Two sets, one for normal context (with interrupts
disabled) and the other for NMI.

But this required the user to set a flag to say they wanted per-cpu
buffers. Peter did not care for this and wanted them on by default.

My reluctance was due to the per cpu buffers wasting space for a debug
item (adding a trace_printk). Currently, there are no users of
trace_printk() so to handle this, I made both the static format and
dynamic format trace_printks add to the trace_printk_fmt section (the
static uses trace_bprintk). By doing this, at boot up we can determine
if a trace_printk has been used, and if so, we allocate the per_cpu
buffers for it. A check is also done at module load.

This patch goes a bit further, as Peter has requested. It allocates 4
sets of trace_printk per-cpu buffers. A normal, softirq, hardirq, and
NMI context buffers. The trace printk will look to see what context it
is in, and use the appropriate buffer. This removes the need for both
locks as well as disabling interrupts.

Once the buffers are allocated, they stay around until the machine is
rebooted.

Thoughts?

-- Steve


----
 include/linux/kernel.h      |   13 ++--
 kernel/trace/trace.c        |  184 +++++++++++++++++++++++++++++++------------
 kernel/trace/trace.h        |    2 +
 kernel/trace/trace_printk.c |    4 +
 4 files changed, 148 insertions(+), 55 deletions(-)
---------------------------
commit a4d1457ed059a668a2d5fa7dfba741ae086df10f
Author: Steven Rostedt <srostedt@redhat.com>
Date:   Thu Sep 22 14:01:55 2011 -0400

    tracing: Add percpu buffers for trace_printk()
    
    Currently, trace_printk() uses a single buffer to write into
    to calculate the size and format needed to save the trace. To
    do this safely in an SMP environment, a spin_lock() is taken
    to only allow one writer at a time to the buffer. But this could
    also affect what is being traced, and add synchronization that
    would not be there otherwise.
    
    Ideally, using percpu buffers would be useful, but since trace_printk()
    is only used in development, having per cpu buffers for something
    never used is a waste of space. Thus, the use of the trace_bprintk()
    format section is changed to be used for static fmts as well as dynamic ones.
    Then at boot up, we can check if the section that holds the trace_printk
    formats is non-empty, and if it does contain something, then we
    know a trace_printk() has been added to the kernel. At this time
    the trace_printk per cpu buffers are allocated. A check is also
    done at module load time in case a module is added that contains a
    trace_printk().
    
    Once the buffers are allocated, they are never freed. If you use
    a trace_printk() then you should know what you are doing.
    
    A buffer is made for each type of context:
    
      normal
      softirq
      irq
      nmi
    
    The context is checked and the appropriate buffer is used.
    This allows for totally lockless usage of trace_printk(),
    and they no longer even disable interrupts.
    
    Requested-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
    Signed-off-by: Steven Rostedt <rostedt@goodmis.org>

diff --git a/include/linux/kernel.h b/include/linux/kernel.h
index e8b1597..b3701ba 100644
--- a/include/linux/kernel.h
+++ b/include/linux/kernel.h
@@ -464,15 +464,16 @@ do {									\
 
 #define trace_printk(fmt, args...)					\
 do {									\
+	static const char *trace_printk_fmt				\
+		__attribute__((section("__trace_printk_fmt"))) =	\
+		__builtin_constant_p(fmt) ? fmt : NULL;			\
+									\
 	__trace_printk_check_format(fmt, ##args);			\
-	if (__builtin_constant_p(fmt)) {				\
-		static const char *trace_printk_fmt			\
-		  __attribute__((section("__trace_printk_fmt"))) =	\
-			__builtin_constant_p(fmt) ? fmt : NULL;		\
 									\
+	if (__builtin_constant_p(fmt))					\
 		__trace_bprintk(_THIS_IP_, trace_printk_fmt, ##args);	\
-	} else								\
-		__trace_printk(_THIS_IP_, fmt, ##args);		\
+	else								\
+		__trace_printk(_THIS_IP_, fmt, ##args);			\
 } while (0)
 
 extern __printf(2, 3)
diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index f2bd275..dfa57a3 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -1442,25 +1442,119 @@ static void __trace_userstack(struct trace_array *tr, unsigned long flags)
 
 #endif /* CONFIG_STACKTRACE */
 
+/* created for use with alloc_percpu */
+struct trace_buffer_struct {
+	char buffer[TRACE_BUF_SIZE];
+};
+
+static struct trace_buffer_struct *trace_percpu_buffer;
+static struct trace_buffer_struct *trace_percpu_sirq_buffer;
+static struct trace_buffer_struct *trace_percpu_irq_buffer;
+static struct trace_buffer_struct *trace_percpu_nmi_buffer;
+
+/*
+ * The buffer used is dependent on the context. There is a per cpu
+ * buffer for normal context, softirq contex, hard irq context and
+ * for NMI context. Thise allows for lockless recording.
+ *
+ * Note, if the buffers failed to be allocated, then this returns NULL
+ */
+static char *get_trace_buf(void)
+{
+	struct trace_buffer_struct *percpu_buffer;
+	struct trace_buffer_struct *buffer;
+
+	/*
+	 * If we have allocated per cpu buffers, then we do not
+	 * need to do any locking.
+	 */
+	if (in_nmi())
+		percpu_buffer = trace_percpu_nmi_buffer;
+	else if (in_irq())
+		percpu_buffer = trace_percpu_irq_buffer;
+	else if (in_softirq())
+		percpu_buffer = trace_percpu_sirq_buffer;
+	else
+		percpu_buffer = trace_percpu_buffer;
+
+	if (!percpu_buffer)
+		return NULL;
+
+	buffer = per_cpu_ptr(percpu_buffer, smp_processor_id());
+
+	return buffer->buffer;
+}
+
+static int alloc_percpu_trace_buffer(void)
+{
+	struct trace_buffer_struct *buffers;
+	struct trace_buffer_struct *sirq_buffers;
+	struct trace_buffer_struct *irq_buffers;
+	struct trace_buffer_struct *nmi_buffers;
+
+	buffers = alloc_percpu(struct trace_buffer_struct);
+	if (!buffers)
+		goto err_warn;
+
+	sirq_buffers = alloc_percpu(struct trace_buffer_struct);
+	if (!sirq_buffers)
+		goto err_sirq;
+
+	irq_buffers = alloc_percpu(struct trace_buffer_struct);
+	if (!irq_buffers)
+		goto err_irq;
+
+	nmi_buffers = alloc_percpu(struct trace_buffer_struct);
+	if (!nmi_buffers)
+		goto err_nmi;
+
+	trace_percpu_buffer = buffers;
+	trace_percpu_sirq_buffer = sirq_buffers;
+	trace_percpu_irq_buffer = irq_buffers;
+	trace_percpu_nmi_buffer = nmi_buffers;
+
+	return 0;
+
+ err_nmi:
+	free_percpu(irq_buffers);
+ err_irq:
+	free_percpu(sirq_buffers);
+ err_sirq:
+	free_percpu(buffers);
+ err_warn:
+	WARN(1, "Could not allocate percpu trace_printk buffer");
+	return -ENOMEM;
+}
+
+void trace_printk_init_buffers(void)
+{
+	static int buffers_allocated;
+
+	if (buffers_allocated)
+		return;
+
+	if (alloc_percpu_trace_buffer())
+		return;
+
+	pr_info("ftrace: Allocated trace_printk buffers\n");
+
+	buffers_allocated = 1;
+}
+
 /**
  * trace_vbprintk - write binary msg to tracing buffer
  *
  */
 int trace_vbprintk(unsigned long ip, const char *fmt, va_list args)
 {
-	static arch_spinlock_t trace_buf_lock =
-		(arch_spinlock_t)__ARCH_SPIN_LOCK_UNLOCKED;
-	static u32 trace_buf[TRACE_BUF_SIZE];
-
 	struct ftrace_event_call *call = &event_bprint;
 	struct ring_buffer_event *event;
 	struct ring_buffer *buffer;
 	struct trace_array *tr = &global_trace;
-	struct trace_array_cpu *data;
 	struct bprint_entry *entry;
 	unsigned long flags;
-	int disable;
-	int cpu, len = 0, size, pc;
+	char *tbuffer;
+	int len = 0, size, pc;
 
 	if (unlikely(tracing_selftest_running || tracing_disabled))
 		return 0;
@@ -1470,43 +1564,36 @@ int trace_vbprintk(unsigned long ip, const char *fmt, va_list args)
 
 	pc = preempt_count();
 	preempt_disable_notrace();
-	cpu = raw_smp_processor_id();
-	data = tr->data[cpu];
 
-	disable = atomic_inc_return(&data->disabled);
-	if (unlikely(disable != 1))
+	tbuffer = get_trace_buf();
+	if (!tbuffer) {
+		len = 0;
 		goto out;
+	}
 
-	/* Lockdep uses trace_printk for lock tracing */
-	local_irq_save(flags);
-	arch_spin_lock(&trace_buf_lock);
-	len = vbin_printf(trace_buf, TRACE_BUF_SIZE, fmt, args);
+	len = vbin_printf((u32 *)tbuffer, TRACE_BUF_SIZE/sizeof(int), fmt, args);
 
-	if (len > TRACE_BUF_SIZE || len < 0)
-		goto out_unlock;
+	if (len > TRACE_BUF_SIZE/sizeof(int) || len < 0)
+		goto out;
 
+	local_save_flags(flags);
 	size = sizeof(*entry) + sizeof(u32) * len;
 	buffer = tr->buffer;
 	event = trace_buffer_lock_reserve(buffer, TRACE_BPRINT, size,
 					  flags, pc);
 	if (!event)
-		goto out_unlock;
+		goto out;
 	entry = ring_buffer_event_data(event);
 	entry->ip			= ip;
 	entry->fmt			= fmt;
 
-	memcpy(entry->buf, trace_buf, sizeof(u32) * len);
+	memcpy(entry->buf, tbuffer, sizeof(u32) * len);
 	if (!filter_check_discard(call, entry, buffer, event)) {
 		ring_buffer_unlock_commit(buffer, event);
 		ftrace_trace_stack(buffer, flags, 6, pc);
 	}
 
-out_unlock:
-	arch_spin_unlock(&trace_buf_lock);
-	local_irq_restore(flags);
-
 out:
-	atomic_dec_return(&data->disabled);
 	preempt_enable_notrace();
 	unpause_graph_tracing();
 
@@ -1532,58 +1619,53 @@ int trace_array_printk(struct trace_array *tr,
 int trace_array_vprintk(struct trace_array *tr,
 			unsigned long ip, const char *fmt, va_list args)
 {
-	static arch_spinlock_t trace_buf_lock = __ARCH_SPIN_LOCK_UNLOCKED;
-	static char trace_buf[TRACE_BUF_SIZE];
-
 	struct ftrace_event_call *call = &event_print;
 	struct ring_buffer_event *event;
 	struct ring_buffer *buffer;
-	struct trace_array_cpu *data;
-	int cpu, len = 0, size, pc;
+	int len = 0, size, pc;
 	struct print_entry *entry;
-	unsigned long irq_flags;
-	int disable;
+	unsigned long flags;
+	char *tbuffer;
 
 	if (tracing_disabled || tracing_selftest_running)
 		return 0;
 
+	/* Don't pollute graph traces with trace_vprintk internals */
+	pause_graph_tracing();
+
 	pc = preempt_count();
 	preempt_disable_notrace();
-	cpu = raw_smp_processor_id();
-	data = tr->data[cpu];
 
-	disable = atomic_inc_return(&data->disabled);
-	if (unlikely(disable != 1))
+
+	tbuffer = get_trace_buf();
+	if (!tbuffer) {
+		len = 0;
 		goto out;
+	}
 
-	pause_graph_tracing();
-	raw_local_irq_save(irq_flags);
-	arch_spin_lock(&trace_buf_lock);
-	len = vsnprintf(trace_buf, TRACE_BUF_SIZE, fmt, args);
+	len = vsnprintf(tbuffer, TRACE_BUF_SIZE, fmt, args);
+	if (len > TRACE_BUF_SIZE)
+		goto out;
 
+	local_save_flags(flags);
 	size = sizeof(*entry) + len + 1;
 	buffer = tr->buffer;
 	event = trace_buffer_lock_reserve(buffer, TRACE_PRINT, size,
-					  irq_flags, pc);
+					  flags, pc);
 	if (!event)
-		goto out_unlock;
+		goto out;
 	entry = ring_buffer_event_data(event);
 	entry->ip = ip;
 
-	memcpy(&entry->buf, trace_buf, len);
+	memcpy(&entry->buf, tbuffer, len);
 	entry->buf[len] = '\0';
 	if (!filter_check_discard(call, entry, buffer, event)) {
 		ring_buffer_unlock_commit(buffer, event);
-		ftrace_trace_stack(buffer, irq_flags, 6, pc);
+		ftrace_trace_stack(buffer, flags, 6, pc);
 	}
-
- out_unlock:
-	arch_spin_unlock(&trace_buf_lock);
-	raw_local_irq_restore(irq_flags);
-	unpause_graph_tracing();
  out:
-	atomic_dec_return(&data->disabled);
 	preempt_enable_notrace();
+	unpause_graph_tracing();
 
 	return len;
 }
@@ -4790,6 +4872,10 @@ __init static int tracer_alloc_buffers(void)
 	if (!alloc_cpumask_var(&tracing_cpumask, GFP_KERNEL))
 		goto out_free_buffer_mask;
 
+	/* Only allocate trace_printk buffers if a trace_printk exists */
+	if (__stop___trace_bprintk_fmt != __start___trace_bprintk_fmt)
+		trace_printk_init_buffers();
+
 	/* To save memory, keep the ring buffer size to its minimum */
 	if (ring_buffer_expanded)
 		ring_buf_size = trace_buf_size;
diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
index 092e1f8..64b04e2 100644
--- a/kernel/trace/trace.h
+++ b/kernel/trace/trace.h
@@ -815,6 +815,8 @@ extern struct list_head ftrace_events;
 extern const char *__start___trace_bprintk_fmt[];
 extern const char *__stop___trace_bprintk_fmt[];
 
+void trace_printk_init_buffers(void);
+
 #undef FTRACE_ENTRY
 #define FTRACE_ENTRY(call, struct_name, id, tstruct, print)		\
 	extern struct ftrace_event_call					\
diff --git a/kernel/trace/trace_printk.c b/kernel/trace/trace_printk.c
index 6fd4ffd..a9077c1 100644
--- a/kernel/trace/trace_printk.c
+++ b/kernel/trace/trace_printk.c
@@ -51,6 +51,10 @@ void hold_module_trace_bprintk_format(const char **start, const char **end)
 	const char **iter;
 	char *fmt;
 
+	/* allocate the trace_printk per cpu buffers */
+	if (start != end)
+		trace_printk_init_buffers();
+
 	mutex_lock(&btrace_mutex);
 	for (iter = start; iter < end; iter++) {
 		struct trace_bprintk_fmt *tb_fmt = lookup_format(*iter);


