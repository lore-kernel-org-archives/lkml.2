Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754580Ab2K2BZn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2012 20:25:43 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:3897 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753030Ab2K2BYc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2012 20:24:32 -0500
X-Authority-Analysis: v=2.0 cv=dttZ+ic4 c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=z4Yeo2GzAioA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=xajs8tCxkMIA:10 a=3nbZYyFuAAAA:8 a=VwQbUJbxAAAA:8 a=MzguKVtCqhweqWCpJrIA:9 a=QEXdDO2ut3YA:10 a=EvKJbDF4Ut8A:10 a=jeBq3FmKZ4MA:10 a=B6zJDFm1CaSTPJDJRFYA:9 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20121129012431.134667189@goodmis.org>
User-Agent: quilt/0.60-1
Date: Wed, 28 Nov 2012 20:23:41 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Hiraku Toyooka <hiraku.toyooka.gu@hitachi.com>
Subject: [PATCH 1/3] tracing: Add a resize function to make one buffer equivalent to
 another buffer
References: <20121129012340.602023062@goodmis.org>
Content-Disposition: inline; filename=0001-tracing-Add-a-resize-function-to-make-one-buffer-equ.patch
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="00GvhwF7k39YY"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--00GvhwF7k39YY
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

From: Hiraku Toyooka <hiraku.toyooka.gu@hitachi.com>

Trace buffer size is now per-cpu, so that there are the following two
patterns in resizing of buffers.

  (1) resize per-cpu buffers to same given size
  (2) resize per-cpu buffers to another trace_array's buffer size
      for each CPU (such as preparing the max_tr which is equivalent
      to the global_trace's size)

__tracing_resize_ring_buffer() can be used for (1), and had
implemented (2) inside it for resetting the global_trace to the
original size.

(2) was also implemented in another place. So this patch assembles
them in a new function - resize_buffer_duplicate_size().

Link: http://lkml.kernel.org/r/20121017025616.2627.91226.stgit@falsita

Signed-off-by: Hiraku Toyooka <hiraku.toyooka.gu@hitachi.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/trace.c |   58 +++++++++++++++++++++++++++-------------------=
----
 1 file changed, 31 insertions(+), 27 deletions(-)

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index b69cc38..64ad9bc 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -3034,6 +3034,31 @@ static void set_buffer_entries(struct trace_array *t=
r, unsigned long val)
 		tr->data[cpu]->entries =3D val;
 }
=20
+/* resize @tr's buffer to the size of @size_tr's entries */
+static int resize_buffer_duplicate_size(struct trace_array *tr,
+					struct trace_array *size_tr, int cpu_id)
+{
+	int cpu, ret =3D 0;
+
+	if (cpu_id =3D=3D RING_BUFFER_ALL_CPUS) {
+		for_each_tracing_cpu(cpu) {
+			ret =3D ring_buffer_resize(tr->buffer,
+					size_tr->data[cpu]->entries, cpu);
+			if (ret < 0)
+				break;
+			tr->data[cpu]->entries =3D size_tr->data[cpu]->entries;
+		}
+	} else {
+		ret =3D ring_buffer_resize(tr->buffer,
+					size_tr->data[cpu_id]->entries, cpu_id);
+		if (ret =3D=3D 0)
+			tr->data[cpu_id]->entries =3D
+				size_tr->data[cpu_id]->entries;
+	}
+
+	return ret;
+}
+
 static int __tracing_resize_ring_buffer(unsigned long size, int cpu)
 {
 	int ret;
@@ -3058,23 +3083,8 @@ static int __tracing_resize_ring_buffer(unsigned lon=
g size, int cpu)
=20
 	ret =3D ring_buffer_resize(max_tr.buffer, size, cpu);
 	if (ret < 0) {
-		int r =3D 0;
-
-		if (cpu =3D=3D RING_BUFFER_ALL_CPUS) {
-			int i;
-			for_each_tracing_cpu(i) {
-				r =3D ring_buffer_resize(global_trace.buffer,
-						global_trace.data[i]->entries,
-						i);
-				if (r < 0)
-					break;
-			}
-		} else {
-			r =3D ring_buffer_resize(global_trace.buffer,
-						global_trace.data[cpu]->entries,
-						cpu);
-		}
-
+		int r =3D resize_buffer_duplicate_size(&global_trace,
+						     &global_trace, cpu);
 		if (r < 0) {
 			/*
 			 * AARGH! We are left with different
@@ -3212,17 +3222,11 @@ static int tracing_set_tracer(const char *buf)
=20
 	topts =3D create_trace_option_files(t);
 	if (t->use_max_tr) {
-		int cpu;
 		/* we need to make per cpu buffer sizes equivalent */
-		for_each_tracing_cpu(cpu) {
-			ret =3D ring_buffer_resize(max_tr.buffer,
-						global_trace.data[cpu]->entries,
-						cpu);
-			if (ret < 0)
-				goto out;
-			max_tr.data[cpu]->entries =3D
-					global_trace.data[cpu]->entries;
-		}
+		ret =3D resize_buffer_duplicate_size(&max_tr, &global_trace,
+						   RING_BUFFER_ALL_CPUS);
+		if (ret < 0)
+			goto out;
 	}
=20
 	if (t->init) {
--=20
1.7.10.4



--00GvhwF7k39YY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQEcBAABAgAGBQJQtrlPAAoJEOdOSU1xswtMVmYIAKEx4G9Xxp9uvzr9khL7LzaS
Cu1OEJJisQCjvCCqUiZNkMi7l5Z/JOPCt2wkN8YP41UROWw5tUOPUxcYPAxCLnNh
lWp5PJriFcFasbKbPf1U5S45yvbn0gLBz/zfgiKaCZ1dxNpM8U3cJKYe5N1ztC5a
qoxBNY1gkX/52Pd6WO1pFEch7AgNbmD7lvXFAWgN4+n+UZVGYBlGvvT01FeMHiLB
YRT5dtNXLF+3CLwMW/oBH0PWp5EvkRKGpjsSDyENVKjKFGWORDSdKaI5PuOrJREQ
kEpOPZkZ+NoLirMMpvT2Ez3b3fXq2xedTriMXDy7El+JtNWBhsx7YUn0msbI8xU=
=xaMg
-----END PGP SIGNATURE-----

--00GvhwF7k39YY--
