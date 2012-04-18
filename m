Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754013Ab2DRBFp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2012 21:05:45 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:4960 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753297Ab2DRBFn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2012 21:05:43 -0400
X-Authority-Analysis: v=2.0 cv=XbcLPfF5 c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=Ciwy3NGCPMMA:10 a=ekSuxOojKg4A:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=20KFwNOVAAAA:8 a=meVymXHHAAAA:8 a=KCTpZHmJFqEIPncglpwA:9 a=QEXdDO2ut3YA:10 a=jEp0ucaQiEUA:10 a=jeBq3FmKZ4MA:10 a=zSwTCKdnOtiE2KHINVwA:9 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-Id: <20120418010541.978906412@goodmis.org>
User-Agent: quilt/0.60-1
Date: Tue, 17 Apr 2012 21:05:07 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 2/2] tracing: Fix regression with tracing_on
References: <20120418010505.756823546@goodmis.org>
Content-Disposition: inline; filename=0002-tracing-Fix-regression-with-tracing_on.patch
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="00GvhwF7k39YY"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--00GvhwF7k39YY
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

From: Steven Rostedt <srostedt@redhat.com>

The change to make tracing_on affect only the ftrace ring buffer, caused
a bug where it wont affect any ring buffer. The problem was that the buffer
of the trace_array was passed to the write function and not the trace array
itself.

The trace_array can change the buffer when running a latency tracer. If this
happens, then the buffer being disabled may not be the buffer currently used
by ftrace. This will cause the tracing_on file to become useless.

The simple fix is to pass the trace_array to the write function instead of
the buffer. Then the actual buffer may be changed.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/trace.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index ed7b5d1..2a22255 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -4629,7 +4629,8 @@ static ssize_t
 rb_simple_read(struct file *filp, char __user *ubuf,
 	       size_t cnt, loff_t *ppos)
 {
-	struct ring_buffer *buffer =3D filp->private_data;
+	struct trace_array *tr =3D filp->private_data;
+	struct ring_buffer *buffer =3D tr->buffer;
 	char buf[64];
 	int r;
=20
@@ -4647,7 +4648,8 @@ static ssize_t
 rb_simple_write(struct file *filp, const char __user *ubuf,
 		size_t cnt, loff_t *ppos)
 {
-	struct ring_buffer *buffer =3D filp->private_data;
+	struct trace_array *tr =3D filp->private_data;
+	struct ring_buffer *buffer =3D tr->buffer;
 	unsigned long val;
 	int ret;
=20
@@ -4734,7 +4736,7 @@ static __init int tracer_init_debugfs(void)
 			  &trace_clock_fops);
=20
 	trace_create_file("tracing_on", 0644, d_tracer,
-			    global_trace.buffer, &rb_simple_fops);
+			    &global_trace, &rb_simple_fops);
=20
 #ifdef CONFIG_DYNAMIC_FTRACE
 	trace_create_file("dyn_ftrace_total_info", 0444, d_tracer,
--=20
1.7.9.5



--00GvhwF7k39YY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAABAgAGBQJPjhNmAAoJEIy3vGnGbaoAtA4P/jb0IIYU59vFakF9VHh1GINy
Gaz5hB3ulDwEKp5ro/YHswjX2t399oopRLxTZ6fxPtcklDs2GeWiO0g4f1lWuKov
+z8nuSsENhNDe984taoCPRA8w/ILi+kerTaZfOO+dpoRkxg1LD063G6hqtom3pVI
uAYRd2zodxj62qPs1ndDJKbfC42NyA6ihjzBYzxZzUJU633HnDO8DtERVTIoJ2BQ
l8C7QWeWYvUsGpqs+XK6vSnFTaU4q7oS0Rku9S5Z7IifNhIjP+o3bWGPrqv8KgvI
0dM3OrJTnVvyWEHgSxDyttK3E6WZxAK9DoD7wWabrXna2JIB4wVqXbnXRVl77Kcw
EAIO3QEwWf60OvvuxSJtbO8Vg/5tCzHrUVJFBV5L1TOx1SiVqUjQwmCC4PTvLN/1
tXru+wuSFOp47coCV/SHLl+yAzascbz06739Lkvh71py9UHW0EROKCC5VwAocpzH
klzV/NG0HZflqTjOsX7nu9nFJKES78OqRYIkwO82uXcUGd9APf0/kH7wGOZRBPOu
p0ZGE11fbY2NyYqGdUsEdJXeozaixXJOdktxptsDXz+FZKimNz5KtpiU0aLd3oYr
6GJfua1erK5E4SmgSXpgKl/LjkbuVbAfhCa39z7MoLGazuilhKTLYnzPXOPKgU39
XmjPCpIbK9Zq5PrURqqH
=yWjg
-----END PGP SIGNATURE-----

--00GvhwF7k39YY--
