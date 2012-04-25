Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757939Ab2DYSth (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2012 14:49:37 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:2926 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757882Ab2DYSte (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2012 14:49:34 -0400
X-Authority-Analysis: v=2.0 cv=V/z/IJbi c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=Ciwy3NGCPMMA:10 a=jEHyhkAEZh8A:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=20KFwNOVAAAA:8 a=meVymXHHAAAA:8 a=CvPWs_5VRSp_t6NkI3oA:9 a=m_b-szZ-scpbMQCeQIYA:7 a=QEXdDO2ut3YA:10 a=jEp0ucaQiEUA:10 a=jeBq3FmKZ4MA:10 a=L36kMp9mAhrv5-dBYPkA:9 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-Id: <20120425184929.746880706@goodmis.org>
User-Agent: quilt/0.60-1
Date: Wed, 25 Apr 2012 14:48:31 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 1/5] tracing: Add percpu buffers for trace_printk()
References: <20120425184830.325105778@goodmis.org>
Content-Disposition: inline; filename=0001-tracing-Add-percpu-buffers-for-trace_printk.patch
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="00GvhwF7k39YY"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--00GvhwF7k39YY
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

From: Steven Rostedt <srostedt@redhat.com>

Currently, trace_printk() uses a single buffer to write into
to calculate the size and format needed to save the trace. To
do this safely in an SMP environment, a spin_lock() is taken
to only allow one writer at a time to the buffer. But this could
also affect what is being traced, and add synchronization that
would not be there otherwise.

Ideally, using percpu buffers would be useful, but since trace_printk()
is only used in development, having per cpu buffers for something
never used is a waste of space. Thus, the use of the trace_bprintk()
format section is changed to be used for static fmts as well as dynamic one=
s.
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
---
 include/linux/kernel.h      |   13 +--
 kernel/trace/trace.c        |  184 +++++++++++++++++++++++++++++++--------=
----
 kernel/trace/trace.h        |    2 +
 kernel/trace/trace_printk.c |    4 +
 4 files changed, 148 insertions(+), 55 deletions(-)

diff --git a/include/linux/kernel.h b/include/linux/kernel.h
index 645231c..c0d3442 100644
--- a/include/linux/kernel.h
+++ b/include/linux/kernel.h
@@ -480,15 +480,16 @@ do {									\
=20
 #define trace_printk(fmt, args...)					\
 do {									\
+	static const char *trace_printk_fmt				\
+		__attribute__((section("__trace_printk_fmt"))) =3D	\
+		__builtin_constant_p(fmt) ? fmt : NULL;			\
+									\
 	__trace_printk_check_format(fmt, ##args);			\
-	if (__builtin_constant_p(fmt)) {				\
-		static const char *trace_printk_fmt			\
-		  __attribute__((section("__trace_printk_fmt"))) =3D	\
-			__builtin_constant_p(fmt) ? fmt : NULL;		\
 									\
+	if (__builtin_constant_p(fmt))					\
 		__trace_bprintk(_THIS_IP_, trace_printk_fmt, ##args);	\
-	} else								\
-		__trace_printk(_THIS_IP_, fmt, ##args);		\
+	else								\
+		__trace_printk(_THIS_IP_, fmt, ##args);			\
 } while (0)
=20
 extern __printf(2, 3)
diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index ed7b5d1..1ab8e35 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -1498,25 +1498,119 @@ static void __trace_userstack(struct trace_array *=
tr, unsigned long flags)
=20
 #endif /* CONFIG_STACKTRACE */
=20
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
+		percpu_buffer =3D trace_percpu_nmi_buffer;
+	else if (in_irq())
+		percpu_buffer =3D trace_percpu_irq_buffer;
+	else if (in_softirq())
+		percpu_buffer =3D trace_percpu_sirq_buffer;
+	else
+		percpu_buffer =3D trace_percpu_buffer;
+
+	if (!percpu_buffer)
+		return NULL;
+
+	buffer =3D per_cpu_ptr(percpu_buffer, smp_processor_id());
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
+	buffers =3D alloc_percpu(struct trace_buffer_struct);
+	if (!buffers)
+		goto err_warn;
+
+	sirq_buffers =3D alloc_percpu(struct trace_buffer_struct);
+	if (!sirq_buffers)
+		goto err_sirq;
+
+	irq_buffers =3D alloc_percpu(struct trace_buffer_struct);
+	if (!irq_buffers)
+		goto err_irq;
+
+	nmi_buffers =3D alloc_percpu(struct trace_buffer_struct);
+	if (!nmi_buffers)
+		goto err_nmi;
+
+	trace_percpu_buffer =3D buffers;
+	trace_percpu_sirq_buffer =3D sirq_buffers;
+	trace_percpu_irq_buffer =3D irq_buffers;
+	trace_percpu_nmi_buffer =3D nmi_buffers;
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
+	buffers_allocated =3D 1;
+}
+
 /**
  * trace_vbprintk - write binary msg to tracing buffer
  *
  */
 int trace_vbprintk(unsigned long ip, const char *fmt, va_list args)
 {
-	static arch_spinlock_t trace_buf_lock =3D
-		(arch_spinlock_t)__ARCH_SPIN_LOCK_UNLOCKED;
-	static u32 trace_buf[TRACE_BUF_SIZE];
-
 	struct ftrace_event_call *call =3D &event_bprint;
 	struct ring_buffer_event *event;
 	struct ring_buffer *buffer;
 	struct trace_array *tr =3D &global_trace;
-	struct trace_array_cpu *data;
 	struct bprint_entry *entry;
 	unsigned long flags;
-	int disable;
-	int cpu, len =3D 0, size, pc;
+	char *tbuffer;
+	int len =3D 0, size, pc;
=20
 	if (unlikely(tracing_selftest_running || tracing_disabled))
 		return 0;
@@ -1526,43 +1620,36 @@ int trace_vbprintk(unsigned long ip, const char *fm=
t, va_list args)
=20
 	pc =3D preempt_count();
 	preempt_disable_notrace();
-	cpu =3D raw_smp_processor_id();
-	data =3D tr->data[cpu];
=20
-	disable =3D atomic_inc_return(&data->disabled);
-	if (unlikely(disable !=3D 1))
+	tbuffer =3D get_trace_buf();
+	if (!tbuffer) {
+		len =3D 0;
 		goto out;
+	}
=20
-	/* Lockdep uses trace_printk for lock tracing */
-	local_irq_save(flags);
-	arch_spin_lock(&trace_buf_lock);
-	len =3D vbin_printf(trace_buf, TRACE_BUF_SIZE, fmt, args);
+	len =3D vbin_printf((u32 *)tbuffer, TRACE_BUF_SIZE/sizeof(int), fmt, args=
);
=20
-	if (len > TRACE_BUF_SIZE || len < 0)
-		goto out_unlock;
+	if (len > TRACE_BUF_SIZE/sizeof(int) || len < 0)
+		goto out;
=20
+	local_save_flags(flags);
 	size =3D sizeof(*entry) + sizeof(u32) * len;
 	buffer =3D tr->buffer;
 	event =3D trace_buffer_lock_reserve(buffer, TRACE_BPRINT, size,
 					  flags, pc);
 	if (!event)
-		goto out_unlock;
+		goto out;
 	entry =3D ring_buffer_event_data(event);
 	entry->ip			=3D ip;
 	entry->fmt			=3D fmt;
=20
-	memcpy(entry->buf, trace_buf, sizeof(u32) * len);
+	memcpy(entry->buf, tbuffer, sizeof(u32) * len);
 	if (!filter_check_discard(call, entry, buffer, event)) {
 		ring_buffer_unlock_commit(buffer, event);
 		ftrace_trace_stack(buffer, flags, 6, pc);
 	}
=20
-out_unlock:
-	arch_spin_unlock(&trace_buf_lock);
-	local_irq_restore(flags);
-
 out:
-	atomic_dec_return(&data->disabled);
 	preempt_enable_notrace();
 	unpause_graph_tracing();
=20
@@ -1588,58 +1675,53 @@ int trace_array_printk(struct trace_array *tr,
 int trace_array_vprintk(struct trace_array *tr,
 			unsigned long ip, const char *fmt, va_list args)
 {
-	static arch_spinlock_t trace_buf_lock =3D __ARCH_SPIN_LOCK_UNLOCKED;
-	static char trace_buf[TRACE_BUF_SIZE];
-
 	struct ftrace_event_call *call =3D &event_print;
 	struct ring_buffer_event *event;
 	struct ring_buffer *buffer;
-	struct trace_array_cpu *data;
-	int cpu, len =3D 0, size, pc;
+	int len =3D 0, size, pc;
 	struct print_entry *entry;
-	unsigned long irq_flags;
-	int disable;
+	unsigned long flags;
+	char *tbuffer;
=20
 	if (tracing_disabled || tracing_selftest_running)
 		return 0;
=20
+	/* Don't pollute graph traces with trace_vprintk internals */
+	pause_graph_tracing();
+
 	pc =3D preempt_count();
 	preempt_disable_notrace();
-	cpu =3D raw_smp_processor_id();
-	data =3D tr->data[cpu];
=20
-	disable =3D atomic_inc_return(&data->disabled);
-	if (unlikely(disable !=3D 1))
+
+	tbuffer =3D get_trace_buf();
+	if (!tbuffer) {
+		len =3D 0;
 		goto out;
+	}
=20
-	pause_graph_tracing();
-	raw_local_irq_save(irq_flags);
-	arch_spin_lock(&trace_buf_lock);
-	len =3D vsnprintf(trace_buf, TRACE_BUF_SIZE, fmt, args);
+	len =3D vsnprintf(tbuffer, TRACE_BUF_SIZE, fmt, args);
+	if (len > TRACE_BUF_SIZE)
+		goto out;
=20
+	local_save_flags(flags);
 	size =3D sizeof(*entry) + len + 1;
 	buffer =3D tr->buffer;
 	event =3D trace_buffer_lock_reserve(buffer, TRACE_PRINT, size,
-					  irq_flags, pc);
+					  flags, pc);
 	if (!event)
-		goto out_unlock;
+		goto out;
 	entry =3D ring_buffer_event_data(event);
 	entry->ip =3D ip;
=20
-	memcpy(&entry->buf, trace_buf, len);
+	memcpy(&entry->buf, tbuffer, len);
 	entry->buf[len] =3D '\0';
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
=20
 	return len;
 }
@@ -4955,6 +5037,10 @@ __init static int tracer_alloc_buffers(void)
 	if (!alloc_cpumask_var(&tracing_cpumask, GFP_KERNEL))
 		goto out_free_buffer_mask;
=20
+	/* Only allocate trace_printk buffers if a trace_printk exists */
+	if (__stop___trace_bprintk_fmt !=3D __start___trace_bprintk_fmt)
+		trace_printk_init_buffers();
+
 	/* To save memory, keep the ring buffer size to its minimum */
 	if (ring_buffer_expanded)
 		ring_buf_size =3D trace_buf_size;
diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
index 95059f0..f9d8550 100644
--- a/kernel/trace/trace.h
+++ b/kernel/trace/trace.h
@@ -826,6 +826,8 @@ extern struct list_head ftrace_events;
 extern const char *__start___trace_bprintk_fmt[];
 extern const char *__stop___trace_bprintk_fmt[];
=20
+void trace_printk_init_buffers(void);
+
 #undef FTRACE_ENTRY
 #define FTRACE_ENTRY(call, struct_name, id, tstruct, print, filter)	\
 	extern struct ftrace_event_call					\
diff --git a/kernel/trace/trace_printk.c b/kernel/trace/trace_printk.c
index 6fd4ffd..a9077c1 100644
--- a/kernel/trace/trace_printk.c
+++ b/kernel/trace/trace_printk.c
@@ -51,6 +51,10 @@ void hold_module_trace_bprintk_format(const char **start=
, const char **end)
 	const char **iter;
 	char *fmt;
=20
+	/* allocate the trace_printk per cpu buffers */
+	if (start !=3D end)
+		trace_printk_init_buffers();
+
 	mutex_lock(&btrace_mutex);
 	for (iter =3D start; iter < end; iter++) {
 		struct trace_bprintk_fmt *tb_fmt =3D lookup_format(*iter);
--=20
1.7.9.5



--00GvhwF7k39YY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAABAgAGBQJPmEc5AAoJEIy3vGnGbaoATQAP/1Ncuy1xVhPrTUB7MqtQ+FkJ
6N5eQ+6KTWs3RnOJ9z5q/FZn4jnUdOoKrsGl2tbPmRKbN0o0D3oOEFRcg58XdXzX
EGXU93vBRh967GC+8tu6YkYazbRhxE9M34oSeDztScGzsITcVQKR5kRFcOnnew+b
PCDStf1ip1QSEhKoinqhbsFwkvTz+Ylsv3A3ItS0hWManpOgMG5ruD4H37sGfgCD
FMhciADAc39jixKosQBzYi/mfqOm1utaUJO3Q39PHrvISJhFZDwJdKpPzFcD80oD
fEwIQDESQArbB+x91sbaueQ+3XqlzowqHRXZ22dyeUQ03PeGzW/4dD0Ob72HAd6e
/PU/du8/hrT9w3KVJXXk33GfvOXOlAXCGIfSjVn/f+IBpedD3HDuPURrc6A9g1Cc
/8xPaAD2TIPraNc18ItLjYJkrfMFme7vSahqoC6aOp/v+CHUthpm68gm2U/jYz7Y
TeVE+iw+0AKK4sS+9NHWsVkDUdXyOtvsR7izyMTdOlYvr1r+7iHyQW9j0/AF/XHW
DS9wqZx3MTUeSf8wIOiYxErKCrSgwYSjI4wUFe6upQVCyRNacJcJ8xh1vU+G9e/F
5G5bhf7AjObjhVsURokFQCWihfzC+VG0o4w7ThrtiUI0Ns0Es3DXFvVbPZmZa1HA
qVroWmicsGmdSL+YBOhU
=I+mV
-----END PGP SIGNATURE-----

--00GvhwF7k39YY--
