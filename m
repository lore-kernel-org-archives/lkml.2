Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755635Ab2K3QNj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2012 11:13:39 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:27933 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754800Ab2K3QNf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2012 11:13:35 -0500
X-Authority-Analysis: v=2.0 cv=dttZ+ic4 c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=L9lvSufvUx4A:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=JLtauYlWs2IA:10 a=20KFwNOVAAAA:8 a=VwQbUJbxAAAA:8 a=piAHF6G2a80KgmoAUtoA:9 a=QEXdDO2ut3YA:10 a=jEp0ucaQiEUA:10 a=jeBq3FmKZ4MA:10 a=0nRNa-dxXuvHRjfbHDkA:9 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20121130161334.164485242@goodmis.org>
User-Agent: quilt/0.60-1
Date: Fri, 30 Nov 2012 11:12:40 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 2/2] ring-buffer: Fix race between integrity check and readers
References: <20121130161238.909829067@goodmis.org>
Content-Disposition: inline; filename=0002-ring-buffer-Fix-race-between-integrity-check-and-rea.patch
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="00GvhwF7k39YY"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--00GvhwF7k39YY
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

From: Steven Rostedt <srostedt@redhat.com>

The function rb_check_pages() was added to make sure the ring buffer's
pages were sane. This check is done when the ring buffer size is modified
as well as when the iterator is released (closing the "trace" file),
as that was considered a non fast path and a good place to do a sanity
check.

The problem is that the check does not have any locks around it.
If one process were to read the trace file, and another were to read
the raw binary file, the check could happen while the reader is reading
the file.

The issues with this is that the check requires to clear the HEAD page
before doing the full check and it restores it afterward. But readers
require the HEAD page to exist before it can read the buffer, otherwise
it gives a nasty warning and disables the buffer.

By adding the reader lock around the check, this keeps the race from
happening.

Cc: stable@vger.kernel.org # 3.6
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/ring_buffer.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/kernel/trace/ring_buffer.c b/kernel/trace/ring_buffer.c
index ec01803..4cb5e51 100644
--- a/kernel/trace/ring_buffer.c
+++ b/kernel/trace/ring_buffer.c
@@ -3783,12 +3783,17 @@ void
 ring_buffer_read_finish(struct ring_buffer_iter *iter)
 {
 	struct ring_buffer_per_cpu *cpu_buffer =3D iter->cpu_buffer;
+	unsigned long flags;
=20
 	/*
 	 * Ring buffer is disabled from recording, here's a good place
-	 * to check the integrity of the ring buffer.=20
+	 * to check the integrity of the ring buffer.
+	 * Must prevent readers from trying to read, as the check
+	 * clears the HEAD page and readers require it.
 	 */
+	raw_spin_lock_irqsave(&cpu_buffer->reader_lock, flags);
 	rb_check_pages(cpu_buffer);
+	raw_spin_unlock_irqrestore(&cpu_buffer->reader_lock, flags);
=20
 	atomic_dec(&cpu_buffer->record_disabled);
 	atomic_dec(&cpu_buffer->buffer->resize_disabled);
--=20
1.7.10.4



--00GvhwF7k39YY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQEcBAABAgAGBQJQuNsuAAoJEOdOSU1xswtMmvEIAM487hUT6DHEPgxCJZ1U7Xr9
4dLN8SK6U13Z0UcJV5F70OX8lCsKIa1bKcOCbDMT6COI836aZy7aI+jzxiPbKmJB
KmcO/Ht0kRoGdnCt2r40tYJv//fw+YTk1VFNWBAKoS06yPSwmW1GJXcgwE5L+Hbl
VGSyopbwM05xRqtz0LeeZNDKpbz+w+clJDKvPPDYyQpdoEzUHEY8sFo156XcRNm7
caTRfwnZbtX79BTf572Ag6tIg+Zsk20ue99yMaPuthCmFUCQ/xc0aKYRmCbm8f3V
KYDyAIg+QZjg5lmoZsAub+HCT6L9pMtnduX6GAynXd83sxu+mZa9BdhHrBqyarY=
=jgNC
-----END PGP SIGNATURE-----

--00GvhwF7k39YY--
