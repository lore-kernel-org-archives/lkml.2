Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753283Ab1JHRNo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Oct 2011 13:13:44 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:50824 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752853Ab1JHRNC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Oct 2011 13:13:02 -0400
X-Authority-Analysis: v=1.1 cv=cSzO76bR5tCkfUT9bEmBgR3d7VUusRLeq08eKGxa4EU= c=1 sm=0 a=vhdKIqpQuCYA:10 a=xm4YKOMRY8kA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=cahJxx6UZF3xCAIBq47FAQ==:17 a=20KFwNOVAAAA:8 a=meVymXHHAAAA:8 a=0ZBM4dR05S5mST3eIOQA:9 a=aBWfFuo2RQfISOlUPgoA:7 a=QEXdDO2ut3YA:10 a=jEp0ucaQiEUA:10 a=jeBq3FmKZ4MA:10 a=0AX2TPWgKv3WhOpiwI4A:9 a=cahJxx6UZF3xCAIBq47FAQ==:117
X-Cloudmark-Score: 0
X-Originating-IP: 69.204.222.235
Message-Id: <20111008171259.907742070@goodmis.org>
User-Agent: quilt/0.48-1
Date: Sat, 08 Oct 2011 13:02:30 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 3/3][RFC] tracing: Add config to permanently have trace_printk() use percpu
References: <20111008170227.792806635@goodmis.org>
Content-Disposition: inline; filename=0003-tracing-Add-config-to-permanently-have-trace_printk-.patch
 buffers
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="00GvhwF7k39YY"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--00GvhwF7k39YY
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

From: Steven Rostedt <srostedt@redhat.com>

For those that do a lot of developing, and use trace_printk() often.
There is no need to have a switch to change between percpu buffers and
a locked protected buffer. Just have the percpu buffers permanently
allocated via a config option and keep a fast and non-intrusive
tracing mechanism that can handle tracing in NMIs, but sacrifices
memory overhead. But developers don't mind that.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/Kconfig |   18 ++++++++++++++++++
 kernel/trace/trace.c |   41 ++++++++++++++++++++++++++++++++++++-----
 2 files changed, 54 insertions(+), 5 deletions(-)

diff --git a/kernel/trace/Kconfig b/kernel/trace/Kconfig
index 2ad39e5..18bd377 100644
--- a/kernel/trace/Kconfig
+++ b/kernel/trace/Kconfig
@@ -223,6 +223,24 @@ config SCHED_TRACER
 	  This tracer tracks the latency of the highest priority task
 	  to be scheduled in, starting from the point it has woken up.
=20
+config TRACE_PRINTK_PERCPU
+	bool "Allocate trace_printk() per_cpu buffers"
+	depends on TRACING
+	 help
+	  By default trace_printk() uses a singe 1KB buffer protected
+	  with a spinlock. It also may lose trace data from NMIs, if an
+	  NMI happens on a CPU that a trace is being recorded on.
+
+	  By default, per_cpu buffers can be allocated either by
+	  setting trace_printk_percpu on the kernel command line,
+	  or by enabling the trace option trace_printk_percpu.
+
+	  For developers that want it always set, by enabling this
+	  config, per_cpu buffers will be permanently set, removing
+	  any logic to check between single and per cpu buffers
+	  adding less impact to tracing with the added cost of more
+	  memory overhead.
+
 config ENABLE_DEFAULT_TRACERS
 	bool "Trace process context switches and events"
 	depends on !GENERIC_TRACER
diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index c59ab4c..b245a4e 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -338,7 +338,11 @@ static DECLARE_WAIT_QUEUE_HEAD(trace_wait);
 /* trace_flags holds trace_options default values */
 unsigned long trace_flags =3D TRACE_ITER_PRINT_PARENT | TRACE_ITER_PRINTK |
 	TRACE_ITER_ANNOTATE | TRACE_ITER_CONTEXT_INFO | TRACE_ITER_SLEEP_TIME |
-	TRACE_ITER_GRAPH_TIME | TRACE_ITER_RECORD_CMD | TRACE_ITER_OVERWRITE;
+	TRACE_ITER_GRAPH_TIME | TRACE_ITER_RECORD_CMD | TRACE_ITER_OVERWRITE
+#ifdef CONFIG_TRACE_PRINTK_PERCPU
+	| TRACE_ITER_PRINTK_PERCPU
+#endif
+	;
=20
 static int trace_stop_count;
 static DEFINE_SPINLOCK(tracing_start_lock);
@@ -1450,15 +1454,32 @@ static void __trace_userstack(struct trace_array *t=
r, unsigned long flags)
=20
 #endif /* CONFIG_STACKTRACE */
=20
-static char trace_buf[TRACE_BUF_SIZE];
-static arch_spinlock_t trace_buf_lock =3D
-	(arch_spinlock_t)__ARCH_SPIN_LOCK_UNLOCKED;
-
 /* created for use with alloc_percpu */
 struct trace_buffer_struct {
 	char buffer[TRACE_BUF_SIZE];
 };
=20
+#ifdef CONFIG_TRACE_PRINTK_PERCPU
+static DEFINE_PER_CPU(struct trace_buffer_struct, trace_buffers);
+static DEFINE_PER_CPU(struct trace_buffer_struct, trace_nmi_buffers);
+
+static inline char *get_trace_buf(struct trace_array *tr, int *put)
+{
+	if (in_nmi())
+		return __get_cpu_var(trace_nmi_buffers).buffer;
+	else
+		return __get_cpu_var(trace_buffers).buffer;
+}
+
+static inline void put_trace_buf(struct trace_array *tr, int put)
+{
+}
+
+#else
+static char trace_buf[TRACE_BUF_SIZE];
+static arch_spinlock_t trace_buf_lock =3D
+	(arch_spinlock_t)__ARCH_SPIN_LOCK_UNLOCKED;
+
 static struct trace_buffer_struct *trace_percpu_buffer;
 static struct trace_buffer_struct *trace_percpu_nmi_buffer;
=20
@@ -1526,6 +1547,7 @@ static void put_trace_buf(struct trace_array *tr, int=
 put)
 	arch_spin_unlock(&trace_buf_lock);
 	atomic_dec_return(&data->disabled);
 }
+#endif /* CONFIG_TRACE_PRINTK_PERCPU */
=20
 /**
  * trace_vbprintk - write binary msg to tracing buffer
@@ -2708,6 +2730,7 @@ static int set_tracer_option(struct tracer *trace, ch=
ar *cmp, int neg)
 	return -EINVAL;
 }
=20
+#ifndef CONFIG_TRACE_PRINTK_PERCPU
 static void alloc_percpu_trace_buffer(void)
 {
 	struct trace_buffer_struct *buffers;
@@ -2752,6 +2775,14 @@ static void free_percpu_trace_buffer(void)
 	free_percpu(buffers);
 	free_percpu(nmi_buffers);
 }
+#else
+static void alloc_percpu_trace_buffer(void) { }
+static void free_percpu_trace_buffer(void)
+{
+	/* trace_printk() buffers are permanently on */
+	trace_flags |=3D TRACE_ITER_PRINTK_PERCPU;
+}
+#endif
=20
 static void set_tracer_flags(unsigned int mask, int enabled)
 {
--=20
1.7.6.3



--00GvhwF7k39YY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAABAgAGBQJOkIScAAoJEIy3vGnGbaoAsWoP/jSq1kgXIz6fLbqfJ1ZacKmE
sc8ZtvQZOUdAKYKhpjkfR2AdeY1gdop4m/nN8O1RZLpzz7Mwo/SXuydfxEQ4J1qz
2XIIeNe/LEe8H0zCapHFmiqJ1UapqX5fFVle1TnCBpBFhSs0+v6d3HI1LtT5kJ1h
aN4Qbp3g0IjC/mxmK89CQD2lQWdp5ZYr7m7ILlpmod+FJDKnZhqQjS4bS7uo2cRq
cO60RCtN+MGrAFIs8SOalr2X1qvKwZpDB9wwPgwQrcnctmDNZ8gTuIak5Ew+IoCr
CoY3rBsV25gS0k2fZfPLEeINow6bBjLYBgS5W0P1ql8B2FPAIIz37onu7rwjAaOT
JNyrUOIizHEEQlvDm+pxyr8u/WpqyRJ+vaHOiAeCwbogH6tkMtuQmJSfZcplMjgZ
dp9aWostOADq58UzDew5oHJFXCKb3P8/lNPi1xX67C7DJ8BKtl2Dd1ze61znjajm
de6BFmpKDoVn6Otk2Hg9HKXN0aNvhxYoyODCIoa5KPF55h0aqk4nppQ+Lz+eigwG
mAIGC/JWNrIRn59lnsbh2LwXWj84LQg+nScKLRJA7yxTwdVEriPfn3RtCxMJeRGC
jTJhL79EMbB1UYwtl48lTpeiyUou5SKB14peNNuSdWk1oHb3tXYaMmqLEGTQo/Ec
iYub/AGKGryeUKRc44lf
=tw2J
-----END PGP SIGNATURE-----

--00GvhwF7k39YY--
