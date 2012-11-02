Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762770Ab2KBNfQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Nov 2012 09:35:16 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:31921 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761847Ab2KBNfG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Nov 2012 09:35:06 -0400
X-Authority-Analysis: v=2.0 cv=YP4dOG6x c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=hIr3gGMCrQoA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=8NfjhqtxbRUA:10 a=20KFwNOVAAAA:8 a=pGLkceISAAAA:8 a=_qPsntVjMZ1W3upfS7sA:9 a=QEXdDO2ut3YA:10 a=jEp0ucaQiEUA:10 a=MSl-tDqOz04A:10 a=Zh68SRI7RUMA:10 a=jeBq3FmKZ4MA:10 a=IkoFultx1_pCP4euwKEA:9 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.115.198
Message-Id: <20121102133502.054547751@goodmis.org>
User-Agent: quilt/0.60-1
Date: Fri, 02 Nov 2012 09:33:14 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 22/22] tracing: Add trace_options kernel command line parameter
References: <20121102133251.998500247@goodmis.org>
Content-Disposition: inline; filename=0022-tracing-Add-trace_options-kernel-command-line-parame.patch
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="00GvhwF7k39YY"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--00GvhwF7k39YY
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

From: Steven Rostedt <srostedt@redhat.com>

Add trace_options to the kernel command line parameter to be able to
set options at early boot. For example, to enable stack dumps of
events, add the following:

  trace_options=3Dstacktrace

This along with the trace_event option, you can get not only
traces of the events but also the stack dumps with them.

Requested-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 Documentation/kernel-parameters.txt |   16 +++++++++++
 kernel/trace/trace.c                |   54 +++++++++++++++++++++++++------=
----
 2 files changed, 55 insertions(+), 15 deletions(-)

diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-par=
ameters.txt
index 9776f06..2b48c52 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -2859,6 +2859,22 @@ bytes respectively. Such letter suffixes can also be=
 entirely omitted.
 			to facilitate early boot debugging.
 			See also Documentation/trace/events.txt
=20
+	trace_options=3D[option-list]
+			[FTRACE] Enable or disable tracer options at boot.
+			The option-list is a comma delimited list of options
+			that can be enabled or disabled just as if you were
+			to echo the option name into
+
+			    /sys/kernel/debug/tracing/trace_options
+
+			For example, to enable stacktrace option (to dump the
+			stack trace of each event), add to the command line:
+
+			      trace_options=3Dstacktrace
+
+			See also Documentation/trace/ftrace.txt "trace options"
+			section.
+
 	transparent_hugepage=3D
 			[KNL]
 			Format: [always|madvise|never]
diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index d5f5997..b69cc38 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -155,6 +155,18 @@ static int __init set_ftrace_dump_on_oops(char *str)
 }
 __setup("ftrace_dump_on_oops", set_ftrace_dump_on_oops);
=20
+
+static char trace_boot_options_buf[MAX_TRACER_SIZE] __initdata;
+static char *trace_boot_options __initdata;
+
+static int __init set_trace_boot_options(char *str)
+{
+	strncpy(trace_boot_options_buf, str, MAX_TRACER_SIZE);
+	trace_boot_options =3D trace_boot_options_buf;
+	return 0;
+}
+__setup("trace_options=3D", set_trace_boot_options);
+
 unsigned long long ns2usecs(cycle_t nsec)
 {
 	nsec +=3D 500;
@@ -2844,24 +2856,14 @@ static void set_tracer_flags(unsigned int mask, int=
 enabled)
 		trace_printk_start_stop_comm(enabled);
 }
=20
-static ssize_t
-tracing_trace_options_write(struct file *filp, const char __user *ubuf,
-			size_t cnt, loff_t *ppos)
+static int trace_set_options(char *option)
 {
-	char buf[64];
 	char *cmp;
 	int neg =3D 0;
-	int ret;
+	int ret =3D 0;
 	int i;
=20
-	if (cnt >=3D sizeof(buf))
-		return -EINVAL;
-
-	if (copy_from_user(&buf, ubuf, cnt))
-		return -EFAULT;
-
-	buf[cnt] =3D 0;
-	cmp =3D strstrip(buf);
+	cmp =3D strstrip(option);
=20
 	if (strncmp(cmp, "no", 2) =3D=3D 0) {
 		neg =3D 1;
@@ -2880,10 +2882,25 @@ tracing_trace_options_write(struct file *filp, cons=
t char __user *ubuf,
 		mutex_lock(&trace_types_lock);
 		ret =3D set_tracer_option(current_trace, cmp, neg);
 		mutex_unlock(&trace_types_lock);
-		if (ret)
-			return ret;
 	}
=20
+	return ret;
+}
+
+static ssize_t
+tracing_trace_options_write(struct file *filp, const char __user *ubuf,
+			size_t cnt, loff_t *ppos)
+{
+	char buf[64];
+
+	if (cnt >=3D sizeof(buf))
+		return -EINVAL;
+
+	if (copy_from_user(&buf, ubuf, cnt))
+		return -EFAULT;
+
+	trace_set_options(buf);
+
 	*ppos +=3D cnt;
=20
 	return cnt;
@@ -5154,6 +5171,13 @@ __init static int tracer_alloc_buffers(void)
=20
 	register_die_notifier(&trace_die_notifier);
=20
+	while (trace_boot_options) {
+		char *option;
+
+		option =3D strsep(&trace_boot_options, ",");
+		trace_set_options(option);
+	}
+
 	return 0;
=20
 out_free_cpumask:
--=20
1.7.10.4



--00GvhwF7k39YY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQEcBAABAgAGBQJQk8wGAAoJEOdOSU1xswtMI5gH/2degfLHDLixBgHNjZqN0OfO
/rwtqhF5L5QO9IYZK8abbRIam1vD4hUPdCz/0Pf4YD4whGlFuM8H7b1nNOlgtRU1
/5Yyn2ky7pd/xomES3b1nykWd3MaXipKzWRv+W3UsyYfOTq7Aj8H2zV8kKyk1TWC
/TX+bZlfGaFZE7xAb6+5R5C8j0NClmBilxgW0efKnvC9xJyjE8vJdNPKS/r6YCBJ
S/WJ+0uXT8nfuS3eg2fkpux73UV2DPVXCo0S/QCxlbL/RLzBnE6RXcHUgxB7igWq
JqE3h/86SUr9XGqYz60ZMEem27mm6qIMT0E9MI7y7/KWDM2PXaG1L4vdghEEFhM=
=HQJN
-----END PGP SIGNATURE-----

--00GvhwF7k39YY--
