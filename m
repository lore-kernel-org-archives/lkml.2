Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934641Ab2KBSRj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Nov 2012 14:17:39 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:12253 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934217Ab2KBSOd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Nov 2012 14:14:33 -0400
X-Authority-Analysis: v=2.0 cv=NLdXCjGg c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=lwJ3fPhDQvUA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=N_ud6Yt4TfYA:10 a=20KFwNOVAAAA:8 a=Hu_aRwiWeCxwcz0KctEA:9 a=QEXdDO2ut3YA:10 a=jEp0ucaQiEUA:10 a=Zh68SRI7RUMA:10 a=jeBq3FmKZ4MA:10 a=Jw80OEVvTVgN_fggRQUA:9 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.115.198
Message-Id: <20121102181430.874470137@goodmis.org>
User-Agent: quilt/0.60-1
Date: Fri, 02 Nov 2012 14:13:37 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 06/19] tracing: Enable comm recording if trace_printk() is used
References: <20121102181331.513782854@goodmis.org>
Content-Disposition: inline; filename=0006-tracing-Enable-comm-recording-if-trace_printk-is-use.patch
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="00GvhwF7k39YY"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--00GvhwF7k39YY
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

From: Steven Rostedt <srostedt@redhat.com>

If comm recording is not enabled when trace_printk() is used then
you just get this type of output:

[ adding trace_printk("hello! %d", irq); in do_IRQ ]

           <...>-2843  [001] d.h.    80.812300: do_IRQ: hello! 14
           <...>-2734  [002] d.h2    80.824664: do_IRQ: hello! 14
           <...>-2713  [003] d.h.    80.829971: do_IRQ: hello! 14
           <...>-2814  [000] d.h.    80.833026: do_IRQ: hello! 14

By enabling the comm recorder when trace_printk is enabled:

       hackbench-6715  [001] d.h.   193.233776: do_IRQ: hello! 21
            sshd-2659  [001] d.h.   193.665862: do_IRQ: hello! 21
          <idle>-0     [001] d.h1   193.665996: do_IRQ: hello! 21

Suggested-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/trace.c        |   36 ++++++++++++++++++++++++++++++++++--
 kernel/trace/trace.h        |    1 +
 kernel/trace/trace_events.c |    3 +++
 3 files changed, 38 insertions(+), 2 deletions(-)

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index a5411b7..b90a827 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -1559,10 +1559,10 @@ static int alloc_percpu_trace_buffer(void)
 	return -ENOMEM;
 }
=20
+static int buffers_allocated;
+
 void trace_printk_init_buffers(void)
 {
-	static int buffers_allocated;
-
 	if (buffers_allocated)
 		return;
=20
@@ -1575,6 +1575,34 @@ void trace_printk_init_buffers(void)
 	tracing_update_buffers();
=20
 	buffers_allocated =3D 1;
+
+	/*
+	 * trace_printk_init_buffers() can be called by modules.
+	 * If that happens, then we need to start cmdline recording
+	 * directly here. If the global_trace.buffer is already
+	 * allocated here, then this was called by module code.
+	 */
+	if (global_trace.buffer)
+		tracing_start_cmdline_record();
+}
+
+void trace_printk_start_comm(void)
+{
+	/* Start tracing comms if trace printk is set */
+	if (!buffers_allocated)
+		return;
+	tracing_start_cmdline_record();
+}
+
+static void trace_printk_start_stop_comm(int enabled)
+{
+	if (!buffers_allocated)
+		return;
+
+	if (enabled)
+		tracing_start_cmdline_record();
+	else
+		tracing_stop_cmdline_record();
 }
=20
 /**
@@ -2797,6 +2825,9 @@ static void set_tracer_flags(unsigned int mask, int e=
nabled)
=20
 	if (mask =3D=3D TRACE_ITER_OVERWRITE)
 		ring_buffer_change_overwrite(global_trace.buffer, enabled);
+
+	if (mask =3D=3D TRACE_ITER_PRINTK)
+		trace_printk_start_stop_comm(enabled);
 }
=20
 static ssize_t
@@ -5099,6 +5130,7 @@ __init static int tracer_alloc_buffers(void)
=20
 	/* Only allocate trace_printk buffers if a trace_printk exists */
 	if (__stop___trace_bprintk_fmt !=3D __start___trace_bprintk_fmt)
+		/* Must be called before global_trace.buffer is allocated */
 		trace_printk_init_buffers();
=20
 	/* To save memory, keep the ring buffer size to its minimum */
diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
index c56a233..7824a55 100644
--- a/kernel/trace/trace.h
+++ b/kernel/trace/trace.h
@@ -841,6 +841,7 @@ extern const char *__start___trace_bprintk_fmt[];
 extern const char *__stop___trace_bprintk_fmt[];
=20
 void trace_printk_init_buffers(void);
+void trace_printk_start_comm(void);
=20
 #undef FTRACE_ENTRY
 #define FTRACE_ENTRY(call, struct_name, id, tstruct, print, filter)	\
diff --git a/kernel/trace/trace_events.c b/kernel/trace/trace_events.c
index d608d09..dec47e7 100644
--- a/kernel/trace/trace_events.c
+++ b/kernel/trace/trace_events.c
@@ -1489,6 +1489,9 @@ static __init int event_trace_enable(void)
 		if (ret)
 			pr_warn("Failed to enable trace event: %s\n", token);
 	}
+
+	trace_printk_start_comm();
+
 	return 0;
 }
=20
--=20
1.7.10.4



--00GvhwF7k39YY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQEcBAABAgAGBQJQlA2GAAoJEOdOSU1xswtMAYsH/1m6tvwgJnQeG9M0NvTisl3m
x7CIO1RuMwwtYMOVwvGjEONuTNps0smFAkYRedEcSgHi8478BdU5q9PRkRP//GOV
h7vCRCRCX/cJ2c0Bra2klaGzWQBmplEbqObHkLFVoE/4FWii63nq8Zc3nDdzcYQA
uL+2B61mz7zx4pyvQsSOvI/11vNm9P3O8nJzuRO9+7pMZOWS3UziEXCiYtog4pFA
1MVOrFAGi7kmqHiCnwjlmiqJZRbxrEZlJsdAggwWPmpS1zmoE+/2aWRl9ZAPnQLH
84Kywcv2oeHbrzMUx2tukiN2UKuzgr4TRV2YjDoh/Che2vHbmCq5tQGxzO1msLQ=
=ZTaM
-----END PGP SIGNATURE-----

--00GvhwF7k39YY--
