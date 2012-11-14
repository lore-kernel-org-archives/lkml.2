Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423353Ab2KNTKf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2012 14:10:35 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:17462 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161151Ab2KNTJo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2012 14:09:44 -0500
X-Authority-Analysis: v=2.0 cv=YP4dOG6x c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=lJ04gs5Fe6AA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=JukZSIYIqacA:10 a=GvQkQWPkAAAA:8 a=pGLkceISAAAA:8 a=VwQbUJbxAAAA:8 a=yxYjK7cJLtiklrPJ8SIA:9 a=QEXdDO2ut3YA:10 a=Wwjp7rKQgkIA:10 a=MSl-tDqOz04A:10 a=jeBq3FmKZ4MA:10 a=NWVoK91CQyQA:10 a=U9J2tyNnI_aM9Vp897kA:9 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.115.198
Message-Id: <20121114190942.849933941@goodmis.org>
User-Agent: quilt/0.60-1
Date: Wed, 14 Nov 2012 13:53:37 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        Shan Wei <davidshan@tencent.com>
Subject: [PATCH 4/4] tracing: Kill unused and puzzled sample code in ftrace.h
References: <20121114185333.818952665@goodmis.org>
Content-Disposition: inline; filename=0004-tracing-Kill-unused-and-puzzled-sample-code-in-ftrac.patch
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="00GvhwF7k39YY"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--00GvhwF7k39YY
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

From: Shan Wei <davidshan@tencent.com>

When doing per-cpu helper optimizing work, find that this code is so puzzle=
d.
1. It's mark as comment text, maybe a sample function for guidelines
   or a todo work.
2. But, this sample code is odd where struct perf_trace_buf is nonexistent.
   commit ce71b9 delete struct perf_trace_buf definition.

   Author: Frederic Weisbecker <fweisbec@gmail.com>
   Date:   Sun Nov 22 05:26:55 2009 +0100

   tracing: Use the perf recursion protection from trace event

Is it necessary to keep there?
just compile test.

Link: http://lkml.kernel.org/r/50949FC9.6050202@gmail.com

Signed-off-by: Shan Wei <davidshan@tencent.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 include/trace/ftrace.h |   73 --------------------------------------------=
----
 1 file changed, 73 deletions(-)

diff --git a/include/trace/ftrace.h b/include/trace/ftrace.h
index 698f2a8..40dc5e8 100644
--- a/include/trace/ftrace.h
+++ b/include/trace/ftrace.h
@@ -619,79 +619,6 @@ __attribute__((section("_ftrace_events"))) *__event_##=
call =3D &event_##call
=20
 #include TRACE_INCLUDE(TRACE_INCLUDE_FILE)
=20
-/*
- * Define the insertion callback to perf events
- *
- * The job is very similar to ftrace_raw_event_<call> except that we don't
- * insert in the ring buffer but in a perf counter.
- *
- * static void ftrace_perf_<call>(proto)
- * {
- *	struct ftrace_data_offsets_<call> __maybe_unused __data_offsets;
- *	struct ftrace_event_call *event_call =3D &event_<call>;
- *	extern void perf_tp_event(int, u64, u64, void *, int);
- *	struct ftrace_raw_##call *entry;
- *	struct perf_trace_buf *trace_buf;
- *	u64 __addr =3D 0, __count =3D 1;
- *	unsigned long irq_flags;
- *	struct trace_entry *ent;
- *	int __entry_size;
- *	int __data_size;
- *	int __cpu
- *	int pc;
- *
- *	pc =3D preempt_count();
- *
- *	__data_size =3D ftrace_get_offsets_<call>(&__data_offsets, args);
- *
- *	// Below we want to get the aligned size by taking into account
- *	// the u32 field that will later store the buffer size
- *	__entry_size =3D ALIGN(__data_size + sizeof(*entry) + sizeof(u32),
- *			     sizeof(u64));
- *	__entry_size -=3D sizeof(u32);
- *
- *	// Protect the non nmi buffer
- *	// This also protects the rcu read side
- *	local_irq_save(irq_flags);
- *	__cpu =3D smp_processor_id();
- *
- *	if (in_nmi())
- *		trace_buf =3D rcu_dereference_sched(perf_trace_buf_nmi);
- *	else
- *		trace_buf =3D rcu_dereference_sched(perf_trace_buf);
- *
- *	if (!trace_buf)
- *		goto end;
- *
- *	trace_buf =3D per_cpu_ptr(trace_buf, __cpu);
- *
- * 	// Avoid recursion from perf that could mess up the buffer
- * 	if (trace_buf->recursion++)
- *		goto end_recursion;
- *
- * 	raw_data =3D trace_buf->buf;
- *
- *	// Make recursion update visible before entering perf_tp_event
- *	// so that we protect from perf recursions.
- *
- *	barrier();
- *
- *	//zero dead bytes from alignment to avoid stack leak to userspace:
- *	*(u64 *)(&raw_data[__entry_size - sizeof(u64)]) =3D 0ULL;
- *	entry =3D (struct ftrace_raw_<call> *)raw_data;
- *	ent =3D &entry->ent;
- *	tracing_generic_entry_update(ent, irq_flags, pc);
- *	ent->type =3D event_call->id;
- *
- *	<tstruct> <- do some jobs with dynamic arrays
- *
- *	<assign>  <- affect our values
- *
- *	perf_tp_event(event_call->id, __addr, __count, entry,
- *		     __entry_size);  <- submit them to perf counter
- *
- * }
- */
=20
 #ifdef CONFIG_PERF_EVENTS
=20
--=20
1.7.10.4



--00GvhwF7k39YY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQEcBAABAgAGBQJQo+x2AAoJEOdOSU1xswtMJFUIAIQJ/dPv3KqSLzrtSfDQ3ChJ
zz+7MGq0ZyvMVQPzCMFzjNMH1LnlTi5aKk9Z7bUS3e64INlhfYiOrsvfLYsI1ZUj
hW9i4hko3VaLWLmlx8Xo1Hez16GX7Jn3OlKWk3nB6vccztSb9LAGBj/MMALO+g6O
6+ITJ94aW6AhkprJE5qA9AghGwf1aIbtpp4uP0PLUy6xDl6HTTh6k9y2o1A6RbcI
i+/z2U/C3PZKIyEF56UTGwCgeVYFdj7q3kb9q5tefQqraD4XEqo6CxHyqzA9GEZL
hFQi+nruII1tdMgG/gLnzUS/HAA9oHm/VJu6Fu/c4Sqbz0PgdPLQ5C7cau1LSrQ=
=yHMt
-----END PGP SIGNATURE-----

--00GvhwF7k39YY--
