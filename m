Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754385Ab2F1XSx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jun 2012 19:18:53 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:32495 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752282Ab2F1XSJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jun 2012 19:18:09 -0400
X-Authority-Analysis: v=2.0 cv=StQSGYy0 c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=Ciwy3NGCPMMA:10 a=LmIDnG_utx8A:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=20KFwNOVAAAA:8 a=VwQbUJbxAAAA:8 a=1XWaLZrsAAAA:8 a=WpTAL2RuoCqbLE9QuwAA:9 a=QEXdDO2ut3YA:10 a=jEp0ucaQiEUA:10 a=UTB_XpHje0EA:10 a=jeBq3FmKZ4MA:10 a=ko2-erweRXh4xfh-ie4A:9 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-Id: <20120628231807.699907647@goodmis.org>
User-Agent: quilt/0.60-1
Date: Thu, 28 Jun 2012 19:16:29 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        David Sharp <dhsharp@google.com>
Subject: [PATCH 4/4] ring-buffer: Fix uninitialized read_stamp
References: <20120628231625.869980334@goodmis.org>
Content-Disposition: inline; filename=0004-ring-buffer-Fix-uninitialized-read_stamp.patch
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="00GvhwF7k39YY"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--00GvhwF7k39YY
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

From: Steven Rostedt <srostedt@redhat.com>

The ring buffer reader page is used to swap a page from the writable
ring buffer. If the writer happens to be on that page, it ends up on the
reader page, but will simply move off of it, back into the writable ring
buffer as writes are added.

The time stamp passed back to the readers is stored in the cpu_buffer per
CPU descriptor. This stamp is updated when a swap of the reader page takes
place, and it reads the current stamp from the page taken from the writable
ring buffer. Everytime a writer goes to a new page, it updates the time sta=
mp
of that page.

The problem happens if a reader reads a page from an empty per CPU ring buf=
fer.
If the buffer is empty, the swap still takes place, placing the writer at t=
he
start of the reader page. If at a later time, a write happens, it updates t=
he
page's time stamp and continues. But the problem is that the read_stamp does
not get updated, because the page was already swapped.

The solution to this was to not swap the page if the ring buffer happens to
be empty. This also removes the side effect that the writes on the reader
page will not get updated because the writer never gets back on the reader
page without a swap. That is, if a read happens on an empty buffer, but then
no reads happen for a while. If a swap took place, and the writer were to s=
tart
writing a lot of data (function tracer), it will start overflowing the ring=
 buffer
and overwrite the older data. But because the writer never goes back onto t=
he
reader page, the data left on the reader page never gets overwritten. This
causes the reader to see really old data, followed by a jump to newer data.

Link: http://lkml.kernel.org/r/1340060577-9112-1-git-send-email-dhsharp@goo=
gle.com
Google-Bug-Id: 6410455
Reported-by: David Sharp <dhsharp@google.com>
tested-by: David Sharp <dhsharp@google.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/ring_buffer.c |    4 ++++
 1 file changed, 4 insertions(+)

diff --git a/kernel/trace/ring_buffer.c b/kernel/trace/ring_buffer.c
index 1d0f6a8..82a3e0c 100644
--- a/kernel/trace/ring_buffer.c
+++ b/kernel/trace/ring_buffer.c
@@ -3239,6 +3239,10 @@ rb_get_reader_page(struct ring_buffer_per_cpu *cpu_b=
uffer)
 	if (cpu_buffer->commit_page =3D=3D cpu_buffer->reader_page)
 		goto out;
=20
+	/* Don't bother swapping if the ring buffer is empty */
+	if (rb_num_of_entries(cpu_buffer) =3D=3D 0)
+		goto out;
+
 	/*
 	 * Reset the reader page to size zero.
 	 */
--=20
1.7.10



--00GvhwF7k39YY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAABAgAGBQJP7OYvAAoJEIy3vGnGbaoAlfkP/1S02Y8LHoUUJyFi0E8chiu3
WzeI0Pvy49sJRdWbXfvOgsI2Qy1dnnrwoEEUXTobCazHXFnjAx9W0MUnC2pXCEp0
SvJUfX8M/JEEj6hdpRZlO0UHuQl/zDYoEWSzsXMPR6IeLWiqFc7CRjwqZSLnOxNu
2P2ivPB1hUtBYDY9ZTBrY2k1GVISIHEnz1DPSHqvBD4Ekymtbj8/nlf2eh+ctwfx
eabqzbfPZ8tt1ijMWyRWeOqdNtI5edoadSas3etDaGJbNJMbJMQMmyZkRsty6ek+
tJ8kow7k8snxk+QQAYDLDH4NOMBldtnzmg7ZneoQu/e2p9B5hYmPaXk+hP6QrkcU
scM4uTkVWdIgmSYben0xsfVefG1JmucD+jRTxHJ6QsmJsjOoMGBVWlwVAEpLo1FK
VUv/iNF09Ysupj5QT3ZbHURv8fgs2Dx3BqXI2LLsfwkp/9ZBPhmHEbY/4aBBsK+h
vSFE8PA9U0bF0SmFpJxRlDvVD2CbnWw8ZFYOfxO9FxfA9CLS3SkNtc6IYfOWXdBW
Fhk0l5RJFVNzBJ++8d8MGq5E15GZ8IaoOERKhQqMrzKCohoLfbX6C3WiI1RaafxT
TLEZZp++zg3f0WgY7esWtl7XtEXL3/GR/vbvw9G4PmX/i7xTna6GR4yXSdcRRWkt
3x4+g7ZMMVLi6vkfGxTw
=Zh5r
-----END PGP SIGNATURE-----

--00GvhwF7k39YY--
