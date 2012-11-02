Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934617Ab2KBSOm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Nov 2012 14:14:42 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:12253 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934464Ab2KBSOh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Nov 2012 14:14:37 -0400
X-Authority-Analysis: v=2.0 cv=NLdXCjGg c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=qWQ6ToEvV_EA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=34e-6U6Lcm0A:10 a=20KFwNOVAAAA:8 a=YUzPu192CTCCxpvUx-wA:9 a=QEXdDO2ut3YA:10 a=jEp0ucaQiEUA:10 a=Zh68SRI7RUMA:10 a=jeBq3FmKZ4MA:10 a=5Y99hyYVELZKbid7NvgA:9 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.115.198
Message-Id: <20121102181432.641654144@goodmis.org>
User-Agent: quilt/0.60-1
Date: Fri, 02 Nov 2012 14:13:47 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 16/19] tracing: Make tracing_enabled be equal to tracing_on
References: <20121102181331.513782854@goodmis.org>
Content-Disposition: inline; filename=0016-tracing-Make-tracing_enabled-be-equal-to-tracing_on.patch
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="00GvhwF7k39YY"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--00GvhwF7k39YY
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

From: Steven Rostedt <srostedt@redhat.com>

The tracing_enabled file has been deprecated as it never was able
to serve its purpose well. The tracing_on file has taken over.
Instead of having code to keep tracing_enabled, have the tracing_enabled
file just set tracing_on, and remove the tracing_enabled variable.

This allows us to remove the tracing_enabled file. The reason that
the remove is in a different change set and not removed here is
in case we find some lonely userspace tool that requires the file
to exist. Then the removal patch will get reverted, but this one
will not.

Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/trace.c          |   79 +++----------------------------------=
----
 kernel/trace/trace_selftest.c |   12 -------
 2 files changed, 5 insertions(+), 86 deletions(-)

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index d1d8039..3c9b96a 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -205,20 +205,9 @@ static struct trace_array	max_tr;
=20
 static DEFINE_PER_CPU(struct trace_array_cpu, max_tr_data);
=20
-/* tracer_enabled is used to toggle activation of a tracer */
-static int			tracer_enabled =3D 1;
-
-/**
- * tracing_is_enabled - return tracer_enabled status
- *
- * This function is used by other tracers to know the status
- * of the tracer_enabled flag.  Tracers may use this function
- * to know if it should enable their features when starting
- * up. See irqsoff tracer for an example (start_irqsoff_tracer).
- */
 int tracing_is_enabled(void)
 {
-	return tracer_enabled;
+	return tracing_is_on();
 }
=20
 /*
@@ -1112,8 +1101,7 @@ void trace_find_cmdline(int pid, char comm[])
=20
 void tracing_record_cmdline(struct task_struct *tsk)
 {
-	if (atomic_read(&trace_record_cmdline_disabled) || !tracer_enabled ||
-	    !tracing_is_on())
+	if (atomic_read(&trace_record_cmdline_disabled) || !tracing_is_on())
 		return;
=20
 	if (!__this_cpu_read(trace_cmdline_save))
@@ -2967,56 +2955,6 @@ static const struct file_operations tracing_saved_cm=
dlines_fops =3D {
 };
=20
 static ssize_t
-tracing_ctrl_read(struct file *filp, char __user *ubuf,
-		  size_t cnt, loff_t *ppos)
-{
-	char buf[64];
-	int r;
-
-	r =3D sprintf(buf, "%u\n", tracer_enabled);
-	return simple_read_from_buffer(ubuf, cnt, ppos, buf, r);
-}
-
-static ssize_t
-tracing_ctrl_write(struct file *filp, const char __user *ubuf,
-		   size_t cnt, loff_t *ppos)
-{
-	struct trace_array *tr =3D filp->private_data;
-	unsigned long val;
-	int ret;
-
-	ret =3D kstrtoul_from_user(ubuf, cnt, 10, &val);
-	if (ret)
-		return ret;
-
-	val =3D !!val;
-
-	mutex_lock(&trace_types_lock);
-	if (tracer_enabled ^ val) {
-
-		/* Only need to warn if this is used to change the state */
-		WARN_ONCE(1, "tracing_enabled is deprecated. Use tracing_on");
-
-		if (val) {
-			tracer_enabled =3D 1;
-			if (current_trace->start)
-				current_trace->start(tr);
-			tracing_start();
-		} else {
-			tracer_enabled =3D 0;
-			tracing_stop();
-			if (current_trace->stop)
-				current_trace->stop(tr);
-		}
-	}
-	mutex_unlock(&trace_types_lock);
-
-	*ppos +=3D cnt;
-
-	return cnt;
-}
-
-static ssize_t
 tracing_set_trace_read(struct file *filp, char __user *ubuf,
 		       size_t cnt, loff_t *ppos)
 {
@@ -3469,7 +3407,7 @@ static int tracing_wait_pipe(struct file *filp)
 			return -EINTR;
=20
 		/*
-		 * We block until we read something and tracing is disabled.
+		 * We block until we read something and tracing is enabled.
 		 * We still block if tracing is disabled, but we have never
 		 * read anything. This allows a user to cat this file, and
 		 * then enable tracing. But after we have read something,
@@ -3477,7 +3415,7 @@ static int tracing_wait_pipe(struct file *filp)
 		 *
 		 * iter->pos will be 0 if we haven't read anything.
 		 */
-		if (!tracer_enabled && iter->pos)
+		if (tracing_is_enabled() && iter->pos)
 			break;
 	}
=20
@@ -4076,13 +4014,6 @@ static const struct file_operations tracing_max_lat_=
fops =3D {
 	.llseek		=3D generic_file_llseek,
 };
=20
-static const struct file_operations tracing_ctrl_fops =3D {
-	.open		=3D tracing_open_generic,
-	.read		=3D tracing_ctrl_read,
-	.write		=3D tracing_ctrl_write,
-	.llseek		=3D generic_file_llseek,
-};
-
 static const struct file_operations set_tracer_fops =3D {
 	.open		=3D tracing_open_generic,
 	.read		=3D tracing_set_trace_read,
@@ -4858,7 +4789,7 @@ static __init int tracer_init_debugfs(void)
 	d_tracer =3D tracing_init_dentry();
=20
 	trace_create_file("tracing_enabled", 0644, d_tracer,
-			&global_trace, &tracing_ctrl_fops);
+			  &global_trace, &rb_simple_fops);
=20
 	trace_create_file("trace_options", 0644, d_tracer,
 			NULL, &tracing_iter_fops);
diff --git a/kernel/trace/trace_selftest.c b/kernel/trace/trace_selftest.c
index 2c00a69..091b815 100644
--- a/kernel/trace/trace_selftest.c
+++ b/kernel/trace/trace_selftest.c
@@ -320,7 +320,6 @@ int trace_selftest_startup_dynamic_tracing(struct trace=
r *trace,
 					   int (*func)(void))
 {
 	int save_ftrace_enabled =3D ftrace_enabled;
-	int save_tracer_enabled =3D tracer_enabled;
 	unsigned long count;
 	char *func_name;
 	int ret;
@@ -331,7 +330,6 @@ int trace_selftest_startup_dynamic_tracing(struct trace=
r *trace,
=20
 	/* enable tracing, and record the filter function */
 	ftrace_enabled =3D 1;
-	tracer_enabled =3D 1;
=20
 	/* passed in by parameter to fool gcc from optimizing */
 	func();
@@ -395,7 +393,6 @@ int trace_selftest_startup_dynamic_tracing(struct trace=
r *trace,
=20
  out:
 	ftrace_enabled =3D save_ftrace_enabled;
-	tracer_enabled =3D save_tracer_enabled;
=20
 	/* Enable tracing on all functions again */
 	ftrace_set_global_filter(NULL, 0, 1);
@@ -452,7 +449,6 @@ static int
 trace_selftest_function_recursion(void)
 {
 	int save_ftrace_enabled =3D ftrace_enabled;
-	int save_tracer_enabled =3D tracer_enabled;
 	char *func_name;
 	int len;
 	int ret;
@@ -465,7 +461,6 @@ trace_selftest_function_recursion(void)
=20
 	/* enable tracing, and record the filter function */
 	ftrace_enabled =3D 1;
-	tracer_enabled =3D 1;
=20
 	/* Handle PPC64 '.' name */
 	func_name =3D "*" __stringify(DYN_FTRACE_TEST_NAME);
@@ -534,7 +529,6 @@ trace_selftest_function_recursion(void)
 	ret =3D 0;
 out:
 	ftrace_enabled =3D save_ftrace_enabled;
-	tracer_enabled =3D save_tracer_enabled;
=20
 	return ret;
 }
@@ -569,7 +563,6 @@ static int
 trace_selftest_function_regs(void)
 {
 	int save_ftrace_enabled =3D ftrace_enabled;
-	int save_tracer_enabled =3D tracer_enabled;
 	char *func_name;
 	int len;
 	int ret;
@@ -586,7 +579,6 @@ trace_selftest_function_regs(void)
=20
 	/* enable tracing, and record the filter function */
 	ftrace_enabled =3D 1;
-	tracer_enabled =3D 1;
=20
 	/* Handle PPC64 '.' name */
 	func_name =3D "*" __stringify(DYN_FTRACE_TEST_NAME);
@@ -648,7 +640,6 @@ trace_selftest_function_regs(void)
 	ret =3D 0;
 out:
 	ftrace_enabled =3D save_ftrace_enabled;
-	tracer_enabled =3D save_tracer_enabled;
=20
 	return ret;
 }
@@ -662,7 +653,6 @@ int
 trace_selftest_startup_function(struct tracer *trace, struct trace_array *=
tr)
 {
 	int save_ftrace_enabled =3D ftrace_enabled;
-	int save_tracer_enabled =3D tracer_enabled;
 	unsigned long count;
 	int ret;
=20
@@ -671,7 +661,6 @@ trace_selftest_startup_function(struct tracer *trace, s=
truct trace_array *tr)
=20
 	/* start the tracing */
 	ftrace_enabled =3D 1;
-	tracer_enabled =3D 1;
=20
 	ret =3D tracer_init(trace, tr);
 	if (ret) {
@@ -708,7 +697,6 @@ trace_selftest_startup_function(struct tracer *trace, s=
truct trace_array *tr)
 	ret =3D trace_selftest_function_regs();
  out:
 	ftrace_enabled =3D save_ftrace_enabled;
-	tracer_enabled =3D save_tracer_enabled;
=20
 	/* kill ftrace totally if we failed */
 	if (ret)
--=20
1.7.10.4



--00GvhwF7k39YY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQEcBAABAgAGBQJQlA2IAAoJEOdOSU1xswtMGAEH/iY//jQijJrPyUg7x4FVNDKb
UhPBid4lL4DYpbXhYJopef30TMo5Ol4HyPRWGtXYN1R2U2dJS1ZEGrTw0M55k33k
xJiYjwS6vn3FeUNGrywemPhKxJoD1DQZbktNuBBcqqPnFDxWSoaB8tqmd9rNQ4tD
d30Qrp1ienvQTdSlmQaaGyPYZjNlGamxuCKkE4+W1JNXjyymPCFXNPhEsXNgXVYe
xHQK595Afs/q1Apd+nIXVGCHlY2F0AUZEZRmMSMH5OZsPwVAmR0cGWRmNfDZDT+O
CusmY1zHmEFKzMAJdMav2wovv4SdfFc7dk6moU5oH1ZK3v6g4X65Oc9tn0twC9E=
=glhz
-----END PGP SIGNATURE-----

--00GvhwF7k39YY--
