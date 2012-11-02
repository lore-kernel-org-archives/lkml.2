Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934946Ab2KBSSt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Nov 2012 14:18:49 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:22935 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934118Ab2KBSOc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Nov 2012 14:14:32 -0400
X-Authority-Analysis: v=2.0 cv=YP4dOG6x c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=D8Cbal5kKz4A:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=pwcfKUQqO6QA:10 a=20KFwNOVAAAA:8 a=a5u33tJDVs5hvKNU0BwA:9 a=QEXdDO2ut3YA:10 a=jEp0ucaQiEUA:10 a=Zh68SRI7RUMA:10 a=jeBq3FmKZ4MA:10 a=33YU7I0fTJW0T1c_98IA:9 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.115.198
Message-Id: <20121102181430.701143035@goodmis.org>
User-Agent: quilt/0.60-1
Date: Fri, 02 Nov 2012 14:13:36 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 05/19] tracing: Expand ring buffer when trace_printk() is used
References: <20121102181331.513782854@goodmis.org>
Content-Disposition: inline; filename=0005-tracing-Expand-ring-buffer-when-trace_printk-is-used.patch
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="00GvhwF7k39YY"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--00GvhwF7k39YY
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

From: Steven Rostedt <srostedt@redhat.com>

Since tracing is not used by 99% of Linux users, even though tracing
may be configured in, it does not make sense to allocate 1.4 Megs
per CPU for the ring buffers if they are not used. Thus, on boot up
the ring buffers are set to a minimal size until something needs the
and they are expanded.

This works well for events and tracers (function, etc), but for the
asynchronous use of trace_printk() which can write to the ring buffer
at any time, does not expand the buffers.

On boot up a check is made to see if any trace_printk() is used to
see if the trace_printk() temp buffer pages should be allocated. This
same code can be used to expand the buffers as well.

Suggested-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/trace.c |    7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 36c213f..a5411b7 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -1571,6 +1571,9 @@ void trace_printk_init_buffers(void)
=20
 	pr_info("ftrace: Allocated trace_printk buffers\n");
=20
+	/* Expand the buffers to set size */
+	tracing_update_buffers();
+
 	buffers_allocated =3D 1;
 }
=20
@@ -3030,6 +3033,10 @@ static int __tracing_resize_ring_buffer(unsigned lon=
g size, int cpu)
 	 */
 	ring_buffer_expanded =3D 1;
=20
+	/* May be called before buffers are initialized */
+	if (!global_trace.buffer)
+		return 0;
+
 	ret =3D ring_buffer_resize(global_trace.buffer, size, cpu);
 	if (ret < 0)
 		return ret;
--=20
1.7.10.4



--00GvhwF7k39YY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQEcBAABAgAGBQJQlA2GAAoJEOdOSU1xswtMdusIALfHSUyviBehR6a+DdrlNOWy
LTZVzdjRfyN1SUoAeEzDBmiDIrXC3MFV+f1qSKzTI3+WJSVJtF0jLPnAdYo/vyRP
a0Sh/JCvsp7+77t8vUDP1I7jS29fYg1RVu4Rh0YGOFVLl3S0dt4iXyO+R0Sy3G+q
OrS9dt1aX8BaUB/ERF5MQYZdMurPiVwnbjhE1WNHxu033tpXMHVgQTX5imUVv1r2
k5ymW/1dTDPTEJ0pN51U00qcB7qajV89fMy8ysqV1uSOJqvI9PxbIReDGyfZG4Y5
BCwrYjHGI67fv2TAprVE4+9uhNVMzBSStsiBrvWjYWPXJpRVPgfizGPGrjhwdd0=
=x4Ja
-----END PGP SIGNATURE-----

--00GvhwF7k39YY--
