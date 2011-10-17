Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751457Ab1JQRua (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Oct 2011 13:50:30 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:56456 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751076Ab1JQRu2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Oct 2011 13:50:28 -0400
X-Authority-Analysis: v=1.1 cv=G2mrdTwFgeQf4gnIVCGl5REDSA/JVLCrZmxI9r5hHjY= c=1 sm=0 a=vhdKIqpQuCYA:10 a=EEreSC8TPeUA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=20KFwNOVAAAA:8 a=VwQbUJbxAAAA:8 a=meVymXHHAAAA:8 a=ufJ8-FlIoTL3jZGMJyUA:9 a=uj9oJ74vp4gsUVSEL3IA:7 a=QEXdDO2ut3YA:10 a=jEp0ucaQiEUA:10 a=LI9Vle30uBYA:10 a=jeBq3FmKZ4MA:10 a=CtTO1R1YagVIgY8cVdcA:9 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-Id: <20111017175023.569695684@goodmis.org>
User-Agent: quilt/0.48-1
Date: Mon, 17 Oct 2011 13:49:40 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        stable <stable@kernel.org>
Subject: [PATCH 2/2] tracing: Fix returning of duplicate data after EOF in trace_pipe_raw
References: <20111017174938.842273454@goodmis.org>
Content-Disposition: inline; filename=0002-tracing-Fix-returning-of-duplicate-data-after-EOF-in.patch
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="00GvhwF7k39YY"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--00GvhwF7k39YY
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

From: Steven Rostedt <srostedt@redhat.com>

The trace_pipe_raw handler holds a cached page from the time the file
is opened to the time it is closed. The cached page is used to handle
the case of the user space buffer being smaller than what was read from
the ring buffer. The left over buffer is held in the cache so that the
next read will continue where the data left off.

After EOF is returned (no more data in the buffer), the index of
the cached page is set to zero. If a user app reads the page again
after EOF, the check in the buffer will see that the cached page
is less than page size and will return the cached page again. This
will cause reading the trace_pipe_raw again after EOF to return
duplicate data, making the output look like the time went backwards
but instead data is just repeated.

The fix is to not reset the index right after all data is read
from the cache, but to reset it after all data is read and more
data exists in the ring buffer.

Cc: stable <stable@kernel.org>
Reported-by: Jeremy Eder <jeder@redhat.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/trace.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index cea1605..b24a72d 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -3903,8 +3903,6 @@ tracing_buffers_read(struct file *filp, char __user *=
ubuf,
 	if (info->read < PAGE_SIZE)
 		goto read;
=20
-	info->read =3D 0;
-
 	trace_access_lock(info->cpu);
 	ret =3D ring_buffer_read_page(info->tr->buffer,
 				    &info->spare,
@@ -3914,6 +3912,8 @@ tracing_buffers_read(struct file *filp, char __user *=
ubuf,
 	if (ret < 0)
 		return 0;
=20
+	info->read =3D 0;
+
 read:
 	size =3D PAGE_SIZE - info->read;
 	if (size > count)
--=20
1.7.6.3



--00GvhwF7k39YY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAABAgAGBQJOnGrfAAoJEIy3vGnGbaoAVUIP/i9ZdOOizaVdPHXABDq0gco0
LYJxBtrw6SyStbiINYv4NgXlsItuBizRNOMkwSzmmanC0xckV6IpilfWEC7MuAQM
puATGoDQWhyevmPng0EHWu96bcqoaFsUkTBmD6nVD2gkS9J1NRmGbJdENIHwoNP7
QibbFFlO9vseuXrEOetH2Qi0oo43Mf2OEVewIB5D3go7ZBV5ynRNKj9Zm2rhg1xJ
IAu3P8j4ymgeyhFMoJlSYJhLET0ionXk444LAi5AtVp0JjkBIO/wjfI3/Mu3bcyg
abP7htxTABsN3Lc0H3J0AZmX8x54CZ0XtqScnBpQU5vuXAC/GGWFm4YIqLt7X0uY
oq/DKqRPL1tMTNRhiLZzlMJtHAzJY5YGQdNO3YIhyghkZIurkUZJr/Nt+8wx5E8M
Ib0sgbZYNnOzKWYtdpwVf1bQ3Qv4Ump+xj5iFAs8rCOyRqoBx6c752WaKxgifPSi
3desPMyzLVJPOzbY3Er6+Aitq3gRQbu20KvYaJfY2TQBx+bg2Y1v/52j1LLncXjP
z8Q8ZtfoYvkixkPfWyL89DFp7SJ1jFjgD50nsMRSoO2spupNOghCE1YZ5atkJ5fw
cDIcvBRM0fvxD84D0T9ulN275yoi9Whv52xlguVCMIbcyM7EGtHrue0E0+UOF+HW
qRzdWdZGAG0rUbGgSUAn
=XTz9
-----END PGP SIGNATURE-----

--00GvhwF7k39YY--
