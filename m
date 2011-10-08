Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753277Ab1JHRN3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Oct 2011 13:13:29 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:53437 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752860Ab1JHRNC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Oct 2011 13:13:02 -0400
X-Authority-Analysis: v=1.1 cv=lfM0d0QHaVz67dfwwr9cyIw6NbaGR/pZhMD6XWNi0kk= c=1 sm=0 a=vhdKIqpQuCYA:10 a=uQewrqOHQAkA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=cahJxx6UZF3xCAIBq47FAQ==:17 a=20KFwNOVAAAA:8 a=meVymXHHAAAA:8 a=OEkD4m_8TuxZba64TuUA:9 a=h4UgYt_RAp_wRoRuaGAA:7 a=QEXdDO2ut3YA:10 a=jEp0ucaQiEUA:10 a=jeBq3FmKZ4MA:10 a=OF1AorPGG-UWEv_aRV0A:9 a=cahJxx6UZF3xCAIBq47FAQ==:117
X-Cloudmark-Score: 0
X-Originating-IP: 69.204.222.235
Message-Id: <20111008171259.462646120@goodmis.org>
User-Agent: quilt/0.48-1
Date: Sat, 08 Oct 2011 13:02:29 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 2/3][RFC] tracing: Add optional percpu buffers for trace_printk()
References: <20111008170227.792806635@goodmis.org>
Content-Disposition: inline; filename=0002-tracing-Add-optional-percpu-buffers-for-trace_printk.patch
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
never used is a waste of space. We could make this a compile option
but trace_printk() may also be used for developing modules, on a
distro kernels or for debugging at customer sites.

The approach taken here is to dynamically allocate percpu buffers
with a new tracing/options switch "trace_printk_percpu". It can
be allocated and freed at runtime, or "trace_printk_percpu" may also
be specified on the command line and it will be allocated at boot up.

This allows a developer to create percpu buffers for trace_printk()
on a running system, and also free them when not in used.

Requested-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 Documentation/kernel-parameters.txt |   11 ++
 kernel/trace/trace.c                |  216 ++++++++++++++++++++++++++++---=
----
 kernel/trace/trace.h                |    1 +
 3 files changed, 187 insertions(+), 41 deletions(-)

diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-par=
ameters.txt
index e279b72..8fc3e58 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -2521,6 +2521,17 @@ bytes respectively. Such letter suffixes can also be=
 entirely omitted.
 			to facilitate early boot debugging.
 			See also Documentation/trace/events.txt
=20
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
 	tsc=3D		Disable clocksource stability checks for TSC.
 			Format: <string>
 			[x86] reliable: mark tsc clocksource as reliable, this
diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index f86efe9..c59ab4c 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -343,6 +343,13 @@ unsigned long trace_flags =3D TRACE_ITER_PRINT_PARENT =
| TRACE_ITER_PRINTK |
 static int trace_stop_count;
 static DEFINE_SPINLOCK(tracing_start_lock);
=20
+static int __init set_percpu_trace_buffer(char *str)
+{
+	trace_flags |=3D TRACE_ITER_PRINTK_PERCPU;
+	return 1;
+}
+__setup("trace_printk_percpu", set_percpu_trace_buffer);
+
 static void wakeup_work_handler(struct work_struct *work)
 {
 	wake_up(&trace_wait);
@@ -426,6 +433,7 @@ static const char *trace_options[] =3D {
 	"record-cmd",
 	"overwrite",
 	"disable_on_free",
+	"trace_printk_percpu",
 	NULL
 };
=20
@@ -1442,25 +1450,98 @@ static void __trace_userstack(struct trace_array *t=
r, unsigned long flags)
=20
 #endif /* CONFIG_STACKTRACE */
=20
+static char trace_buf[TRACE_BUF_SIZE];
+static arch_spinlock_t trace_buf_lock =3D
+	(arch_spinlock_t)__ARCH_SPIN_LOCK_UNLOCKED;
+
+/* created for use with alloc_percpu */
+struct trace_buffer_struct {
+	char buffer[TRACE_BUF_SIZE];
+};
+
+static struct trace_buffer_struct *trace_percpu_buffer;
+static struct trace_buffer_struct *trace_percpu_nmi_buffer;
+
+/*
+ * Since the buffers may be freed, we access the trace_percpu_buffer
+ * once, and then use it or not depending on if it exists.
+ * The code that frees it will NULL out trace_percpu_buffer first
+ * and then perform a synchronize_sched() to ensure all users
+ * are done with it.
+ *
+ * Interrupts are disabled around the get and put operations below.
+ */
+static char *get_trace_buf(struct trace_array *tr, int *put)
+{
+	struct trace_buffer_struct *percpu_buffer;
+	struct trace_buffer_struct *buffer;
+	struct trace_array_cpu *data;
+	int disable;
+	int cpu;
+
+	/*
+	 * If we have allocated per cpu buffers, then we do not
+	 * need to do any locking.
+	 */
+	if (in_nmi())
+		percpu_buffer =3D rcu_dereference_raw(trace_percpu_nmi_buffer);
+	else
+		percpu_buffer =3D rcu_dereference_raw(trace_percpu_buffer);
+
+	if (percpu_buffer) {
+		*put =3D 1;
+		buffer =3D per_cpu_ptr(percpu_buffer, smp_processor_id());
+		return buffer->buffer;
+	}
+
+	/*
+	 * We are using a single buffer, we can lose NMI data too.
+	 */
+	*put =3D 0;
+
+	cpu =3D raw_smp_processor_id();
+	data =3D tr->data[cpu];
+
+	disable =3D atomic_inc_return(&data->disabled);
+	if (unlikely(disable !=3D 1)) {
+		atomic_dec_return(&data->disabled);
+		return NULL;
+	}
+
+	arch_spin_lock(&trace_buf_lock);
+	return trace_buf;
+}
+
+static void put_trace_buf(struct trace_array *tr, int put)
+{
+	struct trace_array_cpu *data;
+	int cpu;
+
+	if (put)
+		return;
+
+	cpu =3D raw_smp_processor_id();
+	data =3D tr->data[cpu];
+
+	arch_spin_unlock(&trace_buf_lock);
+	atomic_dec_return(&data->disabled);
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
+	char *tbuffer;
 	unsigned long flags;
-	int disable;
-	int cpu, len =3D 0, size, pc;
+	int len =3D 0, size, pc;
+	int put;
=20
 	if (unlikely(tracing_selftest_running || tracing_disabled))
 		return 0;
@@ -1470,19 +1551,18 @@ int trace_vbprintk(unsigned long ip, const char *fm=
t, va_list args)
=20
 	pc =3D preempt_count();
 	preempt_disable_notrace();
-	cpu =3D raw_smp_processor_id();
-	data =3D tr->data[cpu];
=20
-	disable =3D atomic_inc_return(&data->disabled);
-	if (unlikely(disable !=3D 1))
+	local_irq_save(flags);
+
+	tbuffer =3D get_trace_buf(tr, &put);
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
+	if (len > TRACE_BUF_SIZE/sizeof(int) || len < 0)
 		goto out_unlock;
=20
 	size =3D sizeof(*entry) + sizeof(u32) * len;
@@ -1495,18 +1575,17 @@ int trace_vbprintk(unsigned long ip, const char *fm=
t, va_list args)
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
 out_unlock:
-	arch_spin_unlock(&trace_buf_lock);
+	put_trace_buf(tr, put);
 	local_irq_restore(flags);
=20
 out:
-	atomic_dec_return(&data->disabled);
 	preempt_enable_notrace();
 	unpause_graph_tracing();
=20
@@ -1532,58 +1611,58 @@ int trace_array_printk(struct trace_array *tr,
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
+	int put;
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
+	local_irq_save(flags);
+
+	tbuffer =3D get_trace_buf(tr, &put);
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
+		goto out_unlock;
=20
 	size =3D sizeof(*entry) + len + 1;
 	buffer =3D tr->buffer;
 	event =3D trace_buffer_lock_reserve(buffer, TRACE_PRINT, size,
-					  irq_flags, pc);
+					  flags, pc);
 	if (!event)
 		goto out_unlock;
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
=20
  out_unlock:
-	arch_spin_unlock(&trace_buf_lock);
-	raw_local_irq_restore(irq_flags);
-	unpause_graph_tracing();
+	put_trace_buf(tr, put);
+	local_irq_restore(flags);
  out:
-	atomic_dec_return(&data->disabled);
 	preempt_enable_notrace();
+	unpause_graph_tracing();
=20
 	return len;
 }
@@ -2629,6 +2708,51 @@ static int set_tracer_option(struct tracer *trace, c=
har *cmp, int neg)
 	return -EINVAL;
 }
=20
+static void alloc_percpu_trace_buffer(void)
+{
+	struct trace_buffer_struct *buffers;
+	struct trace_buffer_struct *nmi_buffers;
+
+	if (!(trace_flags & TRACE_ITER_PRINTK_PERCPU))
+		return; /* Warn? */
+
+	buffers =3D alloc_percpu(struct trace_buffer_struct);
+	if (WARN(!buffers, "Could not allocate percpu trace_printk buffer")) {
+		trace_flags &=3D ~TRACE_ITER_PRINTK_PERCPU;
+		return;
+	}
+
+	nmi_buffers =3D alloc_percpu(struct trace_buffer_struct);
+	if (WARN(!nmi_buffers, "Could not allocate NMI percpu trace_printk buffer=
")) {
+		free_percpu(buffers);
+		trace_flags &=3D ~TRACE_ITER_PRINTK_PERCPU;
+		return;
+	}
+
+	trace_percpu_buffer =3D buffers;
+	trace_percpu_buffer =3D nmi_buffers;
+}
+
+static void free_percpu_trace_buffer(void)
+{
+	struct trace_buffer_struct *buffers;
+	struct trace_buffer_struct *nmi_buffers;
+
+	buffers =3D trace_percpu_buffer;
+	nmi_buffers =3D trace_percpu_nmi_buffer;
+	trace_percpu_buffer =3D NULL;
+	trace_percpu_nmi_buffer =3D NULL;
+	/*
+	 * As the users of these buffers disable preemption
+	 * then check if the buffers exist to use them or not,
+	 * we just need to wait till all tasks have scheduled
+	 * to free them.
+	 */
+	synchronize_sched();
+	free_percpu(buffers);
+	free_percpu(nmi_buffers);
+}
+
 static void set_tracer_flags(unsigned int mask, int enabled)
 {
 	/* do nothing if flag is already set */
@@ -2645,6 +2769,13 @@ static void set_tracer_flags(unsigned int mask, int =
enabled)
=20
 	if (mask =3D=3D TRACE_ITER_OVERWRITE)
 		ring_buffer_change_overwrite(global_trace.buffer, enabled);
+
+	if (mask =3D=3D TRACE_ITER_PRINTK_PERCPU) {
+		if (enabled)
+			alloc_percpu_trace_buffer();
+		else
+			free_percpu_trace_buffer();
+	}
 }
=20
 static ssize_t
@@ -4835,6 +4966,9 @@ __init static int tracer_alloc_buffers(void)
 	/* All seems OK, enable tracing */
 	tracing_disabled =3D 0;
=20
+	if (trace_flags & TRACE_ITER_PRINTK_PERCPU)
+		alloc_percpu_trace_buffer();
+
 	atomic_notifier_chain_register(&panic_notifier_list,
 				       &trace_panic_notifier);
=20
diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
index aa5d94a..d2b7b4c 100644
--- a/kernel/trace/trace.h
+++ b/kernel/trace/trace.h
@@ -654,6 +654,7 @@ enum trace_iterator_flags {
 	TRACE_ITER_RECORD_CMD		=3D 0x100000,
 	TRACE_ITER_OVERWRITE		=3D 0x200000,
 	TRACE_ITER_STOP_ON_FREE		=3D 0x400000,
+	TRACE_ITER_PRINTK_PERCPU	=3D 0x800000,
 };
=20
 /*
--=20
1.7.6.3



--00GvhwF7k39YY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAABAgAGBQJOkISbAAoJEIy3vGnGbaoAo0oP/ipKLE9/RfQJFUAnQsqPFUqs
vsJQVpM6z40NbaAK+sFdKzbumx+BTbVoRwqON1nV+ZvEud6+mZyjALuxfEitJaox
ZzSCkHQYov5LdKQkvuG5FFWWzcmj1Y6XQuTn2ZEBZg4WnZ6pNQiIyIxuMvfmBnAh
8UOQ8QkjvDftYb8oai/gTWyxMTefXm+LTWC8RyH8Oa2X8qRq5zz1Cn48mLIsUQiN
muZlzGsKtMpoaXnAq38n+huOK2WQCIIIazwP+8zcpWaOpwJEnYNlOC80kRwvP+Bm
VtbHMyAWdNI2pUNhY+tDPCVYy9R786GE7wYFuFiK+EOcM2WDNtd7FIdZhJEMyOKh
dxtgcJG8jK5yYoBPYuJ9KUjVWH6qV8LPQ2IVcqwERd9dsEoYaSEw7OILsiET0VQD
bWg5GyhvU9iCMeaFYSRwtEQRp7Iib/zf1BjpvewPhUZ0RwFhAthcH/s1JwvxZEc8
2WWiWDmKkUbW+ErQD4JbGMHL1YF4pXnTPvoZ82mEBKtDw7P5nYqO2icOm8BT+w7x
jactofuFXNGlUoNILJlUC4SEccR5d/o0VMKAFq48xqkag+DfeB7rR0RP0WcaZHoX
1b/K9vhg+SI71EYQ0ICD8Qoygg4uqLjOWlHcFhxU1I3+EPprLrR/+SQR6HoXxzkz
jxBaSd5ILy77qxcyRisn
=vGUk
-----END PGP SIGNATURE-----

--00GvhwF7k39YY--
