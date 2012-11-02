Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762814Ab2KBNkt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Nov 2012 09:40:49 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:13170 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754427Ab2KBNfA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Nov 2012 09:35:00 -0400
X-Authority-Analysis: v=2.0 cv=NLdXCjGg c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=rwujNx8EuewA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=SBossOA68FoA:10 a=20KFwNOVAAAA:8 a=WQqCqm03t6rCDpb6H4EA:9 a=QEXdDO2ut3YA:10 a=jEp0ucaQiEUA:10 a=Zh68SRI7RUMA:10 a=jeBq3FmKZ4MA:10 a=zO9riWeAB3XJYW8DH9oA:9 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.115.198
Message-Id: <20121102133458.193210698@goodmis.org>
User-Agent: quilt/0.60-1
Date: Fri, 02 Nov 2012 09:32:54 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 02/22] tracing: Allow tracers to start at core initcall
References: <20121102133251.998500247@goodmis.org>
Content-Disposition: inline; filename=0002-tracing-Allow-tracers-to-start-at-core-initcall.patch
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="00GvhwF7k39YY"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--00GvhwF7k39YY
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

From: Steven Rostedt <srostedt@redhat.com>

There's times during debugging that it is helpful to see traces of early
boot functions. But the tracers are initialized at device_initcall()
which is quite late during the boot process. Setting the kernel command
line parameter ftrace=3Dfunction will not show anything until the function
tracer is initialized. This prevents being able to trace functions before
device_initcall().

There's no reason that the tracers need to be initialized so late in the
boot process. Move them up to core_initcall() as they still need to come
after early_initcall() which initializes the tracing buffers.

Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/ftrace.c                |    4 ++--
 kernel/trace/trace_branch.c          |    2 +-
 kernel/trace/trace_functions.c       |    3 +--
 kernel/trace/trace_functions_graph.c |    2 +-
 kernel/trace/trace_irqsoff.c         |    2 +-
 kernel/trace/trace_sched_wakeup.c    |    2 +-
 6 files changed, 7 insertions(+), 8 deletions(-)

diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index 60ad606..4451aa3 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -2868,7 +2868,7 @@ static int __init ftrace_mod_cmd_init(void)
 {
 	return register_ftrace_command(&ftrace_mod_cmd);
 }
-device_initcall(ftrace_mod_cmd_init);
+core_initcall(ftrace_mod_cmd_init);
=20
 static void function_trace_probe_call(unsigned long ip, unsigned long pare=
nt_ip,
 				      struct ftrace_ops *op, struct pt_regs *pt_regs)
@@ -4055,7 +4055,7 @@ static int __init ftrace_nodyn_init(void)
 	ftrace_enabled =3D 1;
 	return 0;
 }
-device_initcall(ftrace_nodyn_init);
+core_initcall(ftrace_nodyn_init);
=20
 static inline int ftrace_init_dyn_debugfs(struct dentry *d_tracer) { retur=
n 0; }
 static inline void ftrace_startup_enable(int command) { }
diff --git a/kernel/trace/trace_branch.c b/kernel/trace/trace_branch.c
index 8d3538b..bd3e0ee 100644
--- a/kernel/trace/trace_branch.c
+++ b/kernel/trace/trace_branch.c
@@ -199,7 +199,7 @@ __init static int init_branch_tracer(void)
 	}
 	return register_tracer(&branch_trace);
 }
-device_initcall(init_branch_tracer);
+core_initcall(init_branch_tracer);
=20
 #else
 static inline
diff --git a/kernel/trace/trace_functions.c b/kernel/trace/trace_functions.c
index 618dcf8..bb227e3 100644
--- a/kernel/trace/trace_functions.c
+++ b/kernel/trace/trace_functions.c
@@ -411,5 +411,4 @@ static __init int init_function_trace(void)
 	init_func_cmd_traceon();
 	return register_tracer(&function_trace);
 }
-device_initcall(init_function_trace);
-
+core_initcall(init_function_trace);
diff --git a/kernel/trace/trace_functions_graph.c b/kernel/trace/trace_func=
tions_graph.c
index 99b4378..a84b558 100644
--- a/kernel/trace/trace_functions_graph.c
+++ b/kernel/trace/trace_functions_graph.c
@@ -1474,4 +1474,4 @@ static __init int init_graph_trace(void)
 	return register_tracer(&graph_trace);
 }
=20
-device_initcall(init_graph_trace);
+core_initcall(init_graph_trace);
diff --git a/kernel/trace/trace_irqsoff.c b/kernel/trace/trace_irqsoff.c
index d98ee82..11edebd 100644
--- a/kernel/trace/trace_irqsoff.c
+++ b/kernel/trace/trace_irqsoff.c
@@ -698,4 +698,4 @@ __init static int init_irqsoff_tracer(void)
=20
 	return 0;
 }
-device_initcall(init_irqsoff_tracer);
+core_initcall(init_irqsoff_tracer);
diff --git a/kernel/trace/trace_sched_wakeup.c b/kernel/trace/trace_sched_w=
akeup.c
index 02170c0..2f6af78 100644
--- a/kernel/trace/trace_sched_wakeup.c
+++ b/kernel/trace/trace_sched_wakeup.c
@@ -637,4 +637,4 @@ __init static int init_wakeup_tracer(void)
=20
 	return 0;
 }
-device_initcall(init_wakeup_tracer);
+core_initcall(init_wakeup_tracer);
--=20
1.7.10.4



--00GvhwF7k39YY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQEcBAABAgAGBQJQk8wCAAoJEOdOSU1xswtMQZwIAKWAyrxwJhVdMD8xALgCFMNK
G2i79BUqukp4bHmC2FFO5D5LiW2MQem4Gj4XEBlcteDTlBoSDPRtFzItuMEfL3hX
zy2p2bpotCgU0B6F44cbE4VyPcK60BsW3nvOqxCmdTN3m7YnABFh6NdOY33HwiBn
M/1rVHLIAU8nFSB74kCxL4Sj01pMIvhmlwOy1h9Cyb1UYrTMIsFGo003PKW2sPK8
QWZ/kXjcx1v/7FqR7Od8g7Y00zOX3g7Slg/1hqJ4t1TZ5mcWULT0gs0ff9mWb4Ij
mlZGibvEiOSeoQQVz3QscisNHXPu4Cz9EvDD9JG2HKP62dYBf6SWIGjsX1E3i/k=
=VIBv
-----END PGP SIGNATURE-----

--00GvhwF7k39YY--
