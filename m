Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751586Ab2LUNFT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Dec 2012 08:05:19 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:28116 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751729Ab2LUNEa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Dec 2012 08:04:30 -0500
X-Authority-Analysis: v=2.0 cv=QPnqt33L c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=hLV8KNO-s9wA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=_TjlKMzeso4A:10 a=GvQkQWPkAAAA:8 a=VwQbUJbxAAAA:8 a=pGLkceISAAAA:8 a=NufY4J3AAAAA:8 a=lSNQQfP47xnSsY6BjWYA:9 a=QEXdDO2ut3YA:10 a=Wwjp7rKQgkIA:10 a=MSl-tDqOz04A:10 a=re9sYKne76oA:10 a=jeBq3FmKZ4MA:10 a=OPuCKHDGhKn4kWgsPm8A:9 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20121221130426.632458767@goodmis.org>
User-Agent: quilt/0.60-1
Date: Fri, 21 Dec 2012 08:03:24 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        Christoph Lameter <cl@linux.com>, Shan Wei <davidshan@tencent.com>
Subject: [PATCH 1/3] tracing: Use this_cpu_ptr per-cpu helper
References: <20121221130323.940466074@goodmis.org>
Content-Disposition: inline; filename=0001-tracing-Use-this_cpu_ptr-per-cpu-helper.patch
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="00GvhwF7k39YY"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--00GvhwF7k39YY
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

From: Shan Wei <davidshan@tencent.com>

typeof(&buffer) is a pointer to array of 1024 char, or char (*)[1024].
But, typeof(&buffer[0]) is a pointer to char which match the return type of=
 get_trace_buf().
As well-known, the value of &buffer is equal to &buffer[0].
so return this_cpu_ptr(&percpu_buffer->buffer[0]) can avoid type cast.

Link: http://lkml.kernel.org/r/50A1A800.3020102@gmail.com

Reviewed-by: Christoph Lameter <cl@linux.com>
Signed-off-by: Shan Wei <davidshan@tencent.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/blktrace.c |    2 +-
 kernel/trace/trace.c    |    5 +----
 2 files changed, 2 insertions(+), 5 deletions(-)

diff --git a/kernel/trace/blktrace.c b/kernel/trace/blktrace.c
index c0bd030..71259e2 100644
--- a/kernel/trace/blktrace.c
+++ b/kernel/trace/blktrace.c
@@ -147,7 +147,7 @@ void __trace_note_message(struct blk_trace *bt, const c=
har *fmt, ...)
 		return;
=20
 	local_irq_save(flags);
-	buf =3D per_cpu_ptr(bt->msg_data, smp_processor_id());
+	buf =3D this_cpu_ptr(bt->msg_data);
 	va_start(args, fmt);
 	n =3D vscnprintf(buf, BLK_TN_MAX_MSG, fmt, args);
 	va_end(args);
diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 5bc3590..b6c183b 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -1517,7 +1517,6 @@ static struct trace_buffer_struct *trace_percpu_nmi_b=
uffer;
 static char *get_trace_buf(void)
 {
 	struct trace_buffer_struct *percpu_buffer;
-	struct trace_buffer_struct *buffer;
=20
 	/*
 	 * If we have allocated per cpu buffers, then we do not
@@ -1535,9 +1534,7 @@ static char *get_trace_buf(void)
 	if (!percpu_buffer)
 		return NULL;
=20
-	buffer =3D per_cpu_ptr(percpu_buffer, smp_processor_id());
-
-	return buffer->buffer;
+	return this_cpu_ptr(&percpu_buffer->buffer[0]);
 }
=20
 static int alloc_percpu_trace_buffer(void)
--=20
1.7.10.4



--00GvhwF7k39YY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQEcBAABAgAGBQJQ1F5aAAoJEOdOSU1xswtMLJIIAIcMdSYBglvOWvRx93MldwuQ
iOCpNmlHE+2h9KB0fWX4EJ8SMW8jqKW3E4IuSrOXL2HIjGYBNnBJvk3weJhNWXsd
nBYfdJ/GS1nG4yl7Ru+CgxowLJ9M7FcEVkChl8TSQ32WjyYhvRbl22OpjQFNNEf3
fwgN23xgqrZE7GWMqgtxDpDL9FMmiaYAN8EwLZJZB3wokT9ubbjgJOXOlYXICEDN
Uoj+j5mxoVCOxt5Q8i5i9yJ5k+apIsD/ZsvjxGWJt/vD2nI6p975qq578K70AjVD
vDJJcYTaPvEZd//oieX+3FYQacg4iVhwHC8klMRYab0pVa7xWjhc5kf0xhBaN+g=
=lDq/
-----END PGP SIGNATURE-----

--00GvhwF7k39YY--
