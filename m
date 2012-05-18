Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946062Ab2ERNOe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2012 09:14:34 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:11861 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933560Ab2ERNKt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2012 09:10:49 -0400
X-Authority-Analysis: v=2.0 cv=ae7jbGUt c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=Ciwy3NGCPMMA:10 a=ywWJNneiDasA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=20KFwNOVAAAA:8 a=3l64SMW71gT11OxZrvoA:9 a=f6jF9BK8LNa4HawJVS0A:7 a=QEXdDO2ut3YA:10 a=jEp0ucaQiEUA:10 a=jeBq3FmKZ4MA:10 a=h1XabGe5imIz-vxy8oMA:9 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-Id: <20120518131047.200332925@goodmis.org>
User-Agent: quilt/0.60-1
Date: Fri, 18 May 2012 09:08:59 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 01/15] tracing: Clean up tracing_mark_write()
References: <20120518130858.392919640@goodmis.org>
Content-Disposition: inline; filename=0001-tracing-Clean-up-tracing_mark_write.patch
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="00GvhwF7k39YY"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--00GvhwF7k39YY
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

From: Steven Rostedt <srostedt@redhat.com>

On gcc 4.5 the function tracing_mark_write() would give a warning
of page2 being uninitialized. This is due to a bug in gcc because
the logic prevents page2 from being used uninitialized, and
gcc 4.6+ does not complain (correctly).

Instead of adding a "unitialized" around page2, which could show
a bug later on, I combined page1 and page2 into an array map_pages[].
This binds the two and the two are modified according to nr_pages
(what gcc 4.5 seems to ignore). This no longer gives a warning with
gcc 4.5 nor with gcc 4.6.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/trace.c |   24 +++++++++++-------------
 1 file changed, 11 insertions(+), 13 deletions(-)

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 48ef496..d1b3469 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -3875,14 +3875,14 @@ tracing_mark_write(struct file *filp, const char __=
user *ubuf,
 	struct print_entry *entry;
 	unsigned long irq_flags;
 	struct page *pages[2];
+	void *map_page[2];
 	int nr_pages =3D 1;
 	ssize_t written;
-	void *page1;
-	void *page2;
 	int offset;
 	int size;
 	int len;
 	int ret;
+	int i;
=20
 	if (tracing_disabled)
 		return -EINVAL;
@@ -3921,9 +3921,8 @@ tracing_mark_write(struct file *filp, const char __us=
er *ubuf,
 		goto out;
 	}
=20
-	page1 =3D kmap_atomic(pages[0]);
-	if (nr_pages =3D=3D 2)
-		page2 =3D kmap_atomic(pages[1]);
+	for (i =3D 0; i < nr_pages; i++)
+		map_page[i] =3D kmap_atomic(pages[i]);
=20
 	local_save_flags(irq_flags);
 	size =3D sizeof(*entry) + cnt + 2; /* possible \n added */
@@ -3941,10 +3940,10 @@ tracing_mark_write(struct file *filp, const char __=
user *ubuf,
=20
 	if (nr_pages =3D=3D 2) {
 		len =3D PAGE_SIZE - offset;
-		memcpy(&entry->buf, page1 + offset, len);
-		memcpy(&entry->buf[len], page2, cnt - len);
+		memcpy(&entry->buf, map_page[0] + offset, len);
+		memcpy(&entry->buf[len], map_page[1], cnt - len);
 	} else
-		memcpy(&entry->buf, page1 + offset, cnt);
+		memcpy(&entry->buf, map_page[0] + offset, cnt);
=20
 	if (entry->buf[cnt - 1] !=3D '\n') {
 		entry->buf[cnt] =3D '\n';
@@ -3959,11 +3958,10 @@ tracing_mark_write(struct file *filp, const char __=
user *ubuf,
 	*fpos +=3D written;
=20
  out_unlock:
-	if (nr_pages =3D=3D 2)
-		kunmap_atomic(page2);
-	kunmap_atomic(page1);
-	while (nr_pages > 0)
-		put_page(pages[--nr_pages]);
+	for (i =3D 0; i < nr_pages; i++){
+		kunmap_atomic(map_page[i]);
+		put_page(pages[i]);
+	}
  out:
 	return written;
 }
--=20
1.7.10



--00GvhwF7k39YY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAABAgAGBQJPtkpXAAoJEIy3vGnGbaoAGmYP/3n/e1LbmajlRMd/GxOpb6jq
WTmWZPNBEKHNSbHQJ8i/UBKmyS1T0ddFzdOWLjxO9o/mSgvyTCk6xdezC1EgVIAi
u0v04LkvTk/vv6AnIHAb51Pq6G3XakrmrX1o1IN9TE9hOKyZ6s7LX4D7Q6zDOKKK
OeijYtuIj7jmYxVY+pMfq2OdDTMrNGsXQYETKVP49N0fqtj9Jx6dcXRmr4QI3IuC
8uAv8P3iE6TUAz0d2YL3iARvJA2AuDsknwd/J2CiHsmApzuuk2RoHhYitl2HnPzi
AFPDSvfGn/vfxLNdbQK4JaX2fbh1uE1XFQEmebx1LixjzGkRQpij7bNyf8TIRb93
G9rlnsjnD7396KNVmE0gDxCpKuCiZCitcFWne4HUNhRhv117wIbYkJw6bA4OZSb7
VmZSbkOArWVdlevAm8lgcm3w9Dgulv5j3DT8P0xvG0pFUnz1IZIafdGl/+OV/EJM
kd1lVkxFOWjzCl4fF7AfJAnp/yxTO3+2UW8DhYbPHWXkTJH99SNCBcjrahHo1YUU
dsrT2MRZIH2gSYwSceJhmNgOnqscjTOGgyjYTHQsxtCVNRUTiUsA477Udl0tZ/+b
cMOnhkTMwS1VcHxo1ct9Fn4gAO3p03dABnvT+6vVKRKWxJcTIEvrLsxmimOCGvme
oNo+xSZxk04fyjOi+GIt
=1jUr
-----END PGP SIGNATURE-----

--00GvhwF7k39YY--
