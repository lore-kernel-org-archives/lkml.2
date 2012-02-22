Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753301Ab2BVOnx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Feb 2012 09:43:53 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:20168 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752612Ab2BVOmM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Feb 2012 09:42:12 -0500
X-Authority-Analysis: v=2.0 cv=d9t3OGfE c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=UBy9sU4F98IA:10 a=nQ_jQYrkZpsA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=20KFwNOVAAAA:8 a=VwQbUJbxAAAA:8 a=pGLkceISAAAA:8 a=meVymXHHAAAA:8 a=NILdcEk01FAhFbNACT0A:9 a=Atfja4VAAEtiHyCl7ZMA:7 a=QEXdDO2ut3YA:10 a=lSinr4eg3GwA:10 a=jEp0ucaQiEUA:10 a=MSl-tDqOz04A:10 a=jeBq3FmKZ4MA:10 a=s7DVk-ij5g_JwkgA:21 a=B1n0NkIEKwqnxqLy:21 a=zIKN_dvzcsdt_n5g6GoA:9 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-Id: <20120222144211.184947039@goodmis.org>
User-Agent: quilt/0.50-1
Date: Wed, 22 Feb 2012 09:40:43 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Jiri Olsa <jolsa@redhat.com>
Subject: [PATCH 7/9] ftrace, perf: Add support to use function tracepoint in perf
References: <20120222144036.824378742@goodmis.org>
Content-Disposition: inline; filename=0007-ftrace-perf-Add-support-to-use-function-tracepoint-i.patch
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="00GvhwF7k39YY"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--00GvhwF7k39YY
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

From: Jiri Olsa <jolsa@redhat.com>

Adding perf registration support for the ftrace function event,
so it is now possible to register it via perf interface.

The perf_event struct statically contains ftrace_ops as a handle
for function tracer. The function tracer is registered/unregistered
in open/close actions.

To be efficient, we enable/disable ftrace_ops each time the traced
process is scheduled in/out (via TRACE_REG_PERF_(ADD|DELL) handlers).
This way tracing is enabled only when the process is running.
Intentionally using this way instead of the event's hw state
PERF_HES_STOPPED, which would not disable the ftrace_ops.

It is now possible to use function trace within perf commands
like:

  perf record -e ftrace:function ls
  perf stat -e ftrace:function ls

Allowed only for root.

Link: http://lkml.kernel.org/r/1329317514-8131-6-git-send-email-jolsa@redha=
t.com

Acked-by: Frederic Weisbecker <fweisbec@gmail.com>
Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 include/linux/perf_event.h      |    3 +
 kernel/trace/trace.h            |   11 +++++
 kernel/trace/trace_entries.h    |    6 ++-
 kernel/trace/trace_event_perf.c |   86 +++++++++++++++++++++++++++++++++++=
++++
 kernel/trace/trace_export.c     |    5 ++
 5 files changed, 109 insertions(+), 2 deletions(-)

diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index 412b790..92a056f 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -859,6 +859,9 @@ struct perf_event {
 #ifdef CONFIG_EVENT_TRACING
 	struct ftrace_event_call	*tp_event;
 	struct event_filter		*filter;
+#ifdef CONFIG_FUNCTION_TRACER
+	struct ftrace_ops               ftrace_ops;
+#endif
 #endif
=20
 #ifdef CONFIG_CGROUP_PERF
diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
index 638476a..76a1c50 100644
--- a/kernel/trace/trace.h
+++ b/kernel/trace/trace.h
@@ -595,6 +595,8 @@ static inline int ftrace_trace_task(struct task_struct =
*task)
 static inline int ftrace_is_dead(void) { return 0; }
 #endif
=20
+int ftrace_event_is_function(struct ftrace_event_call *call);
+
 /*
  * struct trace_parser - servers for reading the user input separated by s=
paces
  * @cont: set if the input is not complete - no final space char was found
@@ -832,4 +834,13 @@ extern const char *__stop___trace_bprintk_fmt[];
 	FTRACE_ENTRY(call, struct_name, id, PARAMS(tstruct), PARAMS(print))
 #include "trace_entries.h"
=20
+#ifdef CONFIG_PERF_EVENTS
+#ifdef CONFIG_FUNCTION_TRACER
+int perf_ftrace_event_register(struct ftrace_event_call *call,
+			       enum trace_reg type, void *data);
+#else
+#define perf_ftrace_event_register NULL
+#endif /* CONFIG_FUNCTION_TRACER */
+#endif /* CONFIG_PERF_EVENTS */
+
 #endif /* _LINUX_KERNEL_TRACE_H */
diff --git a/kernel/trace/trace_entries.h b/kernel/trace/trace_entries.h
index 9336590..47db7ed 100644
--- a/kernel/trace/trace_entries.h
+++ b/kernel/trace/trace_entries.h
@@ -55,7 +55,7 @@
 /*
  * Function trace entry - function address and parent function address:
  */
-FTRACE_ENTRY(function, ftrace_entry,
+FTRACE_ENTRY_REG(function, ftrace_entry,
=20
 	TRACE_FN,
=20
@@ -64,7 +64,9 @@ FTRACE_ENTRY(function, ftrace_entry,
 		__field(	unsigned long,	parent_ip	)
 	),
=20
-	F_printk(" %lx <-- %lx", __entry->ip, __entry->parent_ip)
+	F_printk(" %lx <-- %lx", __entry->ip, __entry->parent_ip),
+
+	perf_ftrace_event_register
 );
=20
 /* Function call entry */
diff --git a/kernel/trace/trace_event_perf.c b/kernel/trace/trace_event_per=
f.c
index d72af0b..fdeeb5c 100644
--- a/kernel/trace/trace_event_perf.c
+++ b/kernel/trace/trace_event_perf.c
@@ -24,6 +24,11 @@ static int	total_ref_count;
 static int perf_trace_event_perm(struct ftrace_event_call *tp_event,
 				 struct perf_event *p_event)
 {
+	/* The ftrace function trace is allowed only for root. */
+	if (ftrace_event_is_function(tp_event) &&
+	    perf_paranoid_kernel() && !capable(CAP_SYS_ADMIN))
+		return -EPERM;
+
 	/* No tracing, just counting, so no obvious leak */
 	if (!(p_event->attr.sample_type & PERF_SAMPLE_RAW))
 		return 0;
@@ -250,3 +255,84 @@ __kprobes void *perf_trace_buf_prepare(int size, unsig=
ned short type,
 	return raw_data;
 }
 EXPORT_SYMBOL_GPL(perf_trace_buf_prepare);
+
+#ifdef CONFIG_FUNCTION_TRACER
+static void
+perf_ftrace_function_call(unsigned long ip, unsigned long parent_ip)
+{
+	struct ftrace_entry *entry;
+	struct hlist_head *head;
+	struct pt_regs regs;
+	int rctx;
+
+#define ENTRY_SIZE (ALIGN(sizeof(struct ftrace_entry) + sizeof(u32), \
+		    sizeof(u64)) - sizeof(u32))
+
+	BUILD_BUG_ON(ENTRY_SIZE > PERF_MAX_TRACE_SIZE);
+
+	perf_fetch_caller_regs(&regs);
+
+	entry =3D perf_trace_buf_prepare(ENTRY_SIZE, TRACE_FN, NULL, &rctx);
+	if (!entry)
+		return;
+
+	entry->ip =3D ip;
+	entry->parent_ip =3D parent_ip;
+
+	head =3D this_cpu_ptr(event_function.perf_events);
+	perf_trace_buf_submit(entry, ENTRY_SIZE, rctx, 0,
+			      1, &regs, head);
+
+#undef ENTRY_SIZE
+}
+
+static int perf_ftrace_function_register(struct perf_event *event)
+{
+	struct ftrace_ops *ops =3D &event->ftrace_ops;
+
+	ops->flags |=3D FTRACE_OPS_FL_CONTROL;
+	ops->func =3D perf_ftrace_function_call;
+	return register_ftrace_function(ops);
+}
+
+static int perf_ftrace_function_unregister(struct perf_event *event)
+{
+	struct ftrace_ops *ops =3D &event->ftrace_ops;
+	return unregister_ftrace_function(ops);
+}
+
+static void perf_ftrace_function_enable(struct perf_event *event)
+{
+	ftrace_function_local_enable(&event->ftrace_ops);
+}
+
+static void perf_ftrace_function_disable(struct perf_event *event)
+{
+	ftrace_function_local_disable(&event->ftrace_ops);
+}
+
+int perf_ftrace_event_register(struct ftrace_event_call *call,
+			       enum trace_reg type, void *data)
+{
+	switch (type) {
+	case TRACE_REG_REGISTER:
+	case TRACE_REG_UNREGISTER:
+		break;
+	case TRACE_REG_PERF_REGISTER:
+	case TRACE_REG_PERF_UNREGISTER:
+		return 0;
+	case TRACE_REG_PERF_OPEN:
+		return perf_ftrace_function_register(data);
+	case TRACE_REG_PERF_CLOSE:
+		return perf_ftrace_function_unregister(data);
+	case TRACE_REG_PERF_ADD:
+		perf_ftrace_function_enable(data);
+		return 0;
+	case TRACE_REG_PERF_DEL:
+		perf_ftrace_function_disable(data);
+		return 0;
+	}
+
+	return -EINVAL;
+}
+#endif /* CONFIG_FUNCTION_TRACER */
diff --git a/kernel/trace/trace_export.c b/kernel/trace/trace_export.c
index f74de86..a3dbee6 100644
--- a/kernel/trace/trace_export.c
+++ b/kernel/trace/trace_export.c
@@ -184,4 +184,9 @@ __attribute__((section("_ftrace_events"))) *__event_##c=
all =3D &event_##call;
 	FTRACE_ENTRY_REG(call, struct_name, etype,			\
 			 PARAMS(tstruct), PARAMS(print), NULL)
=20
+int ftrace_event_is_function(struct ftrace_event_call *call)
+{
+	return call =3D=3D &event_function;
+}
+
 #include "trace_entries.h"
--=20
1.7.8.3



--00GvhwF7k39YY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAABAgAGBQJPRP7DAAoJEIy3vGnGbaoArrwQAL6LyydPB8idbab90+iWWb/0
dG9MI6u+EsBOXHYLTvwUBGFKFSHx8jxKJVBpAGCsRNRL6U72VjOwu5JVS5LYVfYA
KzfooUHLUMicSHWKK0r/X/nHKFVOosxiu/y+NT/N7YR1sUxviR0SxZRqe66+fp8z
p9ai7MpawPwNL8gXLJszNCs1VLO7PZSoDsKvuXkjRHbJSS+JLy2VT+VZtrFHEDff
ud830Df4xFJxtqG3eL3mtB2LmKWYD/BR3XzYyG27fP7t3pEmBiTnmgo+N3YL4e/y
F/1oHAdRx7oJ5/lj+vWExxwPSfL99IGsWi44mr850SpdW3d+7vFH7cugzTLy0Re9
2uj3Rq4dbvt1TGwbndokeo01foE4nRQgHHVQJG9utN7FW2uqR/pwJW5tujq3DZkB
N/qRK3UhkWcOXlOa75sdDJZHjK2va0fsRybdS+4FLykm386LRpjAnNtDLRHJu94m
X8nMrsGro3Xlecyky09NilHZnZbz1/EFweUZyOeXs7nHHbXaHOtx7Wiv4niRhT5q
mqMpvx86XWZXNzlIRcoFUw7aSQodRO79XbdYxUc0OrsWlK2MAMz+IMSis5zetEze
hxnTrjiKjECC6Y/1vpib8E7kJz2FdCbyj9dVN3JbQC05uy9CLKy1Bc45Z7Kceixg
flS0uyhQlKkLq8GK5CTo
=GckI
-----END PGP SIGNATURE-----

--00GvhwF7k39YY--
