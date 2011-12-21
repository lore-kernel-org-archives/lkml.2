Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753900Ab1LUMjL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Dec 2011 07:39:11 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:35463 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753686Ab1LUMiO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Dec 2011 07:38:14 -0500
X-Authority-Analysis: v=2.0 cv=A5HuztqG c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=vhdKIqpQuCYA:10 a=YCxzgicll9YA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=20KFwNOVAAAA:8 a=meVymXHHAAAA:8 a=_wwVt6tWESORWGkiu94A:9 a=QEXdDO2ut3YA:10 a=jEp0ucaQiEUA:10 a=jeBq3FmKZ4MA:10 a=mBfTnuZ8jrjetzmSSvIA:9 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-Id: <20111221123810.270598913@goodmis.org>
User-Agent: quilt/0.48-1
Date: Wed, 21 Dec 2011 07:36:37 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 13/16] tracing: Have stack_tracer use a separate list of functions
References: <20111221123624.193898256@goodmis.org>
Content-Disposition: inline; filename=0013-tracing-Have-stack_tracer-use-a-separate-list-of-fun.patch
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="00GvhwF7k39YY"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--00GvhwF7k39YY
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

From: Steven Rostedt <srostedt@redhat.com>

The stack_tracer is used to look at every function and check
if the current stack is bigger than the last recorded max stack size.
When a new max is found, then it saves that stack off.

Currently the stack tracer is limited by the global_ops of
the function tracer. As the stack tracer has nothing to do with
the ftrace function tracer, except that it uses it as its internal
engine, the stack tracer should have its own list.

A new file is added to the tracing debugfs directory called:

  stack_trace_filter

that can be used to select which functions you want to check the stack
on.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/trace_stack.c |   19 ++++++++++++++++++-
 1 files changed, 18 insertions(+), 1 deletions(-)

diff --git a/kernel/trace/trace_stack.c b/kernel/trace/trace_stack.c
index 77575b3..0398b7c 100644
--- a/kernel/trace/trace_stack.c
+++ b/kernel/trace/trace_stack.c
@@ -133,7 +133,6 @@ stack_trace_call(unsigned long ip, unsigned long parent=
_ip)
 static struct ftrace_ops trace_ops __read_mostly =3D
 {
 	.func =3D stack_trace_call,
-	.flags =3D FTRACE_OPS_FL_GLOBAL,
 };
=20
 static ssize_t
@@ -311,6 +310,21 @@ static const struct file_operations stack_trace_fops =
=3D {
 	.release	=3D seq_release,
 };
=20
+static int
+stack_trace_filter_open(struct inode *inode, struct file *file)
+{
+	return ftrace_regex_open(&trace_ops, FTRACE_ITER_FILTER,
+				 inode, file);
+}
+
+static const struct file_operations stack_trace_filter_fops =3D {
+	.open =3D stack_trace_filter_open,
+	.read =3D seq_read,
+	.write =3D ftrace_filter_write,
+	.llseek =3D ftrace_regex_lseek,
+	.release =3D ftrace_regex_release,
+};
+
 int
 stack_trace_sysctl(struct ctl_table *table, int write,
 		   void __user *buffer, size_t *lenp,
@@ -358,6 +372,9 @@ static __init int stack_trace_init(void)
 	trace_create_file("stack_trace", 0444, d_tracer,
 			NULL, &stack_trace_fops);
=20
+	trace_create_file("stack_trace_filter", 0444, d_tracer,
+			NULL, &stack_trace_filter_fops);
+
 	if (stack_tracer_enabled)
 		register_ftrace_function(&trace_ops);
=20
--=20
1.7.7.3



--00GvhwF7k39YY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAABAgAGBQJO8dMyAAoJEIy3vGnGbaoASxUP/isF8lBgEBS6Xdhqt/BRCGM4
/iHE2nzjgkPjO5KAxB/y76dYLr+OsKNi1UYRNuUbkz3UTGdVLJA3jhoiySV38x/l
Uq5avLUEMCuKWWRiBFC61QZ/NHjGIywmAVPdb/thnS52Bwdx2vLqyc+Rjyt71Aqz
7vPXn+QGUickzIe2YpV4w1ONWVBn8n/wL/56D7L7AaiTKavj/1x+VYulMOL+DRl7
6uCTrIhp1csDyZ113eAR1hz/Q9u6JuuP2j6+6CxUqfYrqPmr6x8Ml6bvvz6yJ12y
gKN3dZWZ0lut9oAngKCoPqIDG4dwSrxV+EB9l4+UaTsbifp1qf0D5o4fGuPylTJc
/z0f5qu4gWzt6jFe4bJJeugljPlAC5rb5zsUh3IllCQJfeXPWE1besVw9M4MsCjz
iKR5RggihHWfJ4qEQB+qL6KqrqnWEjNuf9Fs0vYSII+AGKKInoxOkijSVGMfM4Fv
Yd8K6ISrHcdfi0Fm7Bys7HLeMP/CZVQupltPdWsDlc0K54kYGjLagp4u1gw3pEJP
0oBMeaM74wh4v4BTYoQJmjNDJqDgaGuJrUNbwtZrEiYx2k7cRqG7cn9As/tHAzGv
Os6br+7QBrmHku+I4qeSFQy2dXkkhhzKpaxjh0iY+2ljTWF8uCnhQYrrVf08Ot8W
LPZ2hdWYu3TmYc5NaJWu
=4Dr+
-----END PGP SIGNATURE-----

--00GvhwF7k39YY--
