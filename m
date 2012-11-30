Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755251Ab2K3QNi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2012 11:13:38 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:31642 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754794Ab2K3QNf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2012 11:13:35 -0500
X-Authority-Analysis: v=2.0 cv=EshQXFgA c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=eC57RPd7L5cA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=uXSjbnlxps4A:10 a=20KFwNOVAAAA:8 a=VwQbUJbxAAAA:8 a=wDAzwacqOiJ7wvIdIqAA:9 a=QEXdDO2ut3YA:10 a=jEp0ucaQiEUA:10 a=jeBq3FmKZ4MA:10 a=EJzWNDzxMEWny7dhMFIA:9 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20121130161333.983378567@goodmis.org>
User-Agent: quilt/0.60-1
Date: Fri, 30 Nov 2012 11:12:39 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 1/2] ring-buffer: Fix NULL pointer if rb_set_head_page() fails
References: <20121130161238.909829067@goodmis.org>
Content-Disposition: inline; filename=0001-ring-buffer-Fix-NULL-pointer-if-rb_set_head_page-fai.patch
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="00GvhwF7k39YY"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--00GvhwF7k39YY
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

From: Steven Rostedt <srostedt@redhat.com>

The function rb_set_head_page() searches the list of ring buffer
pages for a the page that has the HEAD page flag set. If it does
not find it, it will do a WARN_ON(), disable the ring buffer and
return NULL, as this should never happen.

But if this bug happens to happen, not all callers of this function
can handle a NULL pointer being returned from it. That needs to be
fixed.

Cc: stable@vger.kernel.org # 3.0+
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/ring_buffer.c |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/kernel/trace/ring_buffer.c b/kernel/trace/ring_buffer.c
index b979426..ec01803 100644
--- a/kernel/trace/ring_buffer.c
+++ b/kernel/trace/ring_buffer.c
@@ -1396,6 +1396,8 @@ rb_insert_pages(struct ring_buffer_per_cpu *cpu_buffe=
r)
 		struct list_head *head_page_with_bit;
=20
 		head_page =3D &rb_set_head_page(cpu_buffer)->list;
+		if (!head_page)
+			break;
 		prev_page =3D head_page->prev;
=20
 		first_page =3D pages->next;
@@ -2934,7 +2936,7 @@ unsigned long ring_buffer_oldest_event_ts(struct ring=
_buffer *buffer, int cpu)
 	unsigned long flags;
 	struct ring_buffer_per_cpu *cpu_buffer;
 	struct buffer_page *bpage;
-	unsigned long ret;
+	unsigned long ret =3D 0;
=20
 	if (!cpumask_test_cpu(cpu, buffer->cpumask))
 		return 0;
@@ -2949,7 +2951,8 @@ unsigned long ring_buffer_oldest_event_ts(struct ring=
_buffer *buffer, int cpu)
 		bpage =3D cpu_buffer->reader_page;
 	else
 		bpage =3D rb_set_head_page(cpu_buffer);
-	ret =3D bpage->page->time_stamp;
+	if (bpage)
+		ret =3D bpage->page->time_stamp;
 	raw_spin_unlock_irqrestore(&cpu_buffer->reader_lock, flags);
=20
 	return ret;
@@ -3260,6 +3263,8 @@ rb_get_reader_page(struct ring_buffer_per_cpu *cpu_bu=
ffer)
 	 * Splice the empty reader page into the list around the head.
 	 */
 	reader =3D rb_set_head_page(cpu_buffer);
+	if (!reader)
+		goto out;
 	cpu_buffer->reader_page->list.next =3D rb_list_head(reader->list.next);
 	cpu_buffer->reader_page->list.prev =3D reader->list.prev;
=20
--=20
1.7.10.4



--00GvhwF7k39YY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQEcBAABAgAGBQJQuNsuAAoJEOdOSU1xswtMrMYH/2jLT4yVqVJu6ZYlTGrFHaby
FlvQgcniFfMrUU2KNCdxqZyWNLXSXUM+oug6JimNBmarK3Pa+LwHpRV9uvZswpjK
kXQ6SXyuCV3CAyEgN8Zrfl9uZjk5SlHqPIK4SMQC/22AlQDzHWeH7UZstEL/9NO3
KARy/WLdHe244E92ilh0Y4QnN5DTxqMTFTUM1klDyN4IR2U+N+6MArLFjNrmFMCj
ipaSzWSep3g37zKT3qOLx8TL91qFixwU7kIGwNnywXUOop/rZCZepOtyCug+wqLY
ZdtqTnrfaS+x7QFH1g32FLiDJ81HJnT3BLJfnEVRpca2aGVuKPW/a8sF4lmif+U=
=OGWc
-----END PGP SIGNATURE-----

--00GvhwF7k39YY--
