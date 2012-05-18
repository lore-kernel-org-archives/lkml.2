Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933746Ab2ERNOg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2012 09:14:36 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:18139 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933056Ab2ERNKt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2012 09:10:49 -0400
X-Authority-Analysis: v=2.0 cv=cssZYiEi c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=Ciwy3NGCPMMA:10 a=THHcJWpszZQA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=20KFwNOVAAAA:8 a=1XWaLZrsAAAA:8 a=PbOulLW5kl50uvyfZDsA:9 a=QEXdDO2ut3YA:10 a=jEp0ucaQiEUA:10 a=UTB_XpHje0EA:10 a=jeBq3FmKZ4MA:10 a=Sn4alXfo30f3anz2Pt8A:9 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-Id: <20120518131048.332990942@goodmis.org>
User-Agent: quilt/0.60-1
Date: Fri, 18 May 2012 09:09:02 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Vaibhav Nagarnaik <vnagarnaik@google.com>
Subject: [PATCH 04/15] ring-buffer: Add integrity check at end of iter read
References: <20120518130858.392919640@goodmis.org>
Content-Disposition: inline; filename=0004-ring-buffer-Add-integrity-check-at-end-of-iter-read.patch
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="00GvhwF7k39YY"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--00GvhwF7k39YY
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

From: Steven Rostedt <srostedt@redhat.com>

There use to be ring buffer integrity checks after updating the
size of the ring buffer. But now that the ring buffer can modify
the size while the system is running, the integrity checks were
removed, as they require the ring buffer to be disabed to perform
the check.

Move the integrity check to the reading of the ring buffer via the
iterator reads (the "trace" file). As reading via an iterator requires
disabling the ring buffer, it is a perfect place to have it.

If the ring buffer happens to be disabled when updating the size,
we still perform the integrity check.

Cc: Vaibhav Nagarnaik <vnagarnaik@google.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/ring_buffer.c |   29 +++++++++++++++++++++++++++++
 1 file changed, 29 insertions(+)

diff --git a/kernel/trace/ring_buffer.c b/kernel/trace/ring_buffer.c
index d673ef0..e0573c5 100644
--- a/kernel/trace/ring_buffer.c
+++ b/kernel/trace/ring_buffer.c
@@ -1599,6 +1599,29 @@ int ring_buffer_resize(struct ring_buffer *buffer, u=
nsigned long size,
 	}
=20
  out:
+	/*
+	 * The ring buffer resize can happen with the ring buffer
+	 * enabled, so that the update disturbs the tracing as little
+	 * as possible. But if the buffer is disabled, we do not need
+	 * to worry about that, and we can take the time to verify
+	 * that the buffer is not corrupt.
+	 */
+	if (atomic_read(&buffer->record_disabled)) {
+		atomic_inc(&buffer->record_disabled);
+		/*
+		 * Even though the buffer was disabled, we must make sure
+		 * that it is truly disabled before calling rb_check_pages.
+		 * There could have been a race between checking
+		 * record_disable and incrementing it.
+		 */
+		synchronize_sched();
+		for_each_buffer_cpu(buffer, cpu) {
+			cpu_buffer =3D buffer->buffers[cpu];
+			rb_check_pages(cpu_buffer);
+		}
+		atomic_dec(&buffer->record_disabled);
+	}
+
 	mutex_unlock(&buffer->mutex);
 	return size;
=20
@@ -3750,6 +3773,12 @@ ring_buffer_read_finish(struct ring_buffer_iter *ite=
r)
 {
 	struct ring_buffer_per_cpu *cpu_buffer =3D iter->cpu_buffer;
=20
+	/*
+	 * Ring buffer is disabled from recording, here's a good place
+	 * to check the integrity of the ring buffer.=20
+	 */
+	rb_check_pages(cpu_buffer);
+
 	atomic_dec(&cpu_buffer->record_disabled);
 	atomic_dec(&cpu_buffer->buffer->resize_disabled);
 	kfree(iter);
--=20
1.7.10



--00GvhwF7k39YY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAABAgAGBQJPtkpYAAoJEIy3vGnGbaoAiJwQAOYB063u3hC1Th3B5U586Ryk
qGP8vL/IYgqfegfl68Cc3YPOo7DocgQeFdCuZDaM3jcRwfhhdNvCVbLXIQMPxkZ4
p3EP7eqvr5/MfvmgtM17KkMStKg6OFknME6CnFYTpztHWPXnqhXMnybNuVOw3Vld
MuRg6yiszLGMfLDMhUl9OwbxXFh8PSaL1DuYuX3d0L5niUz7g8CBpBD5xIcjGoYI
YEqsCBRNpMYHhhJuQ/vua/gU6Go1Ih9tyFyofbd17zn57EuttvwZ0xP6QhMtvGAS
9igZvu5JP2wwyTtNJQlsWIUwoGNEUBLzyxeabrZohT1o906NYAHg3gwth+oHRvHc
wwYbAsF8P3Vw5GsDhDH4Pb6KOuiKjXkCmzAVkF3Ko9HKPKmkEk9b9dOy15cz45Xr
YQyMMXZHOk27xomI3V6Tz91SPrgKuHRfYXzEv03T6s7BZSe86xBTUnyk5Oxebin/
/aVXOKNWrm8V270blfrBD2EfNoMAqZ2nLF6+BIFnXSZTQ5FES2qqR4tlMBbLjjm0
MaheGUBlYGxC9g82yFAuhJ0sZH2vdrrHWLkdbsYcFlpxIPIPGvAbP2xndcSRhjAg
swqTrz2m3zEHVj4Y3JVcym1F2s25oLy9tnw6+wIEjdvhY2zuSaRTQb9QViPmA5Z7
NxCjQbuInMMIW0/ohWDr
=iU00
-----END PGP SIGNATURE-----

--00GvhwF7k39YY--
