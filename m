Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762787Ab2KBNgm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Nov 2012 09:36:42 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:13170 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761348Ab2KBNfF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Nov 2012 09:35:05 -0400
X-Authority-Analysis: v=2.0 cv=NLdXCjGg c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=cEZLnVLY_d0A:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=fsuvUruio_gA:10 a=3nbZYyFuAAAA:8 a=VwQbUJbxAAAA:8 a=1XWaLZrsAAAA:8 a=pGLkceISAAAA:8 a=Bn7xxrpYSftJHWeE3oYA:9 a=QEXdDO2ut3YA:10 a=lSinr4eg3GwA:10 a=EvKJbDF4Ut8A:10 a=UTB_XpHje0EA:10 a=MSl-tDqOz04A:10 a=jeBq3FmKZ4MA:10 a=Tx9Vf2JQ04_o3j1r65sA:9 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.115.198
Message-Id: <20121102133500.904920696@goodmis.org>
User-Agent: quilt/0.60-1
Date: Fri, 02 Nov 2012 09:33:08 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Yoshihiro YUNOMAE <yoshihiro.yunomae.ez@hitachi.com>,
        David Sharp <dhsharp@google.com>
Subject: [PATCH 16/22] tracing: Show raw time stamp on stats per cpu using counter or tsc
 mode for trace_clock
References: <20121102133251.998500247@goodmis.org>
Content-Disposition: inline; filename=0016-tracing-Show-raw-time-stamp-on-stats-per-cpu-using-c.patch
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="00GvhwF7k39YY"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--00GvhwF7k39YY
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

From: Yoshihiro YUNOMAE <yoshihiro.yunomae.ez@hitachi.com>

Show raw time stamp values for stats per cpu if you choose counter or tsc m=
ode
for trace_clock. Although a unit of tracing time stamp is nsec in local or =
global mode,
the units in counter and TSC mode are tracing counter and cycles respective=
ly.

Link: http://lkml.kernel.org/r/1349998076-15495-6-git-send-email-dhsharp@go=
ogle.com

Cc: Frederic Weisbecker <fweisbec@gmail.com>
Signed-off-by: Yoshihiro YUNOMAE <yoshihiro.yunomae.ez@hitachi.com>
Signed-off-by: David Sharp <dhsharp@google.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/trace.c |   23 +++++++++++++++++------
 1 file changed, 17 insertions(+), 6 deletions(-)

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index e0e7a8d..599b29a 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -4452,13 +4452,24 @@ tracing_stats_read(struct file *filp, char __user *=
ubuf,
 	cnt =3D ring_buffer_bytes_cpu(tr->buffer, cpu);
 	trace_seq_printf(s, "bytes: %ld\n", cnt);
=20
-	t =3D ns2usecs(ring_buffer_oldest_event_ts(tr->buffer, cpu));
-	usec_rem =3D do_div(t, USEC_PER_SEC);
-	trace_seq_printf(s, "oldest event ts: %5llu.%06lu\n", t, usec_rem);
+	if (trace_clocks[trace_clock_id].in_ns) {
+		/* local or global for trace_clock */
+		t =3D ns2usecs(ring_buffer_oldest_event_ts(tr->buffer, cpu));
+		usec_rem =3D do_div(t, USEC_PER_SEC);
+		trace_seq_printf(s, "oldest event ts: %5llu.%06lu\n",
+								t, usec_rem);
+
+		t =3D ns2usecs(ring_buffer_time_stamp(tr->buffer, cpu));
+		usec_rem =3D do_div(t, USEC_PER_SEC);
+		trace_seq_printf(s, "now ts: %5llu.%06lu\n", t, usec_rem);
+	} else {
+		/* counter or tsc mode for trace_clock */
+		trace_seq_printf(s, "oldest event ts: %llu\n",
+				ring_buffer_oldest_event_ts(tr->buffer, cpu));
=20
-	t =3D ns2usecs(ring_buffer_time_stamp(tr->buffer, cpu));
-	usec_rem =3D do_div(t, USEC_PER_SEC);
-	trace_seq_printf(s, "now ts: %5llu.%06lu\n", t, usec_rem);
+		trace_seq_printf(s, "now ts: %llu\n",
+				ring_buffer_time_stamp(tr->buffer, cpu));
+	}
=20
 	cnt =3D ring_buffer_dropped_events_cpu(tr->buffer, cpu);
 	trace_seq_printf(s, "dropped events: %ld\n", cnt);
--=20
1.7.10.4



--00GvhwF7k39YY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQEcBAABAgAGBQJQk8wFAAoJEOdOSU1xswtMrJoH/RQ22Dq5tOOJX2WkZIIODhoV
GpEVjvvNQYCKqlr/QZdVPRhJ+kHsxWN2u15u5HX2PzRIG/C0rMLqWGUwanm4TVRR
d5qsNCs2mPKXjoy0/fYxWut8TkUjlrSE2+R4quF+PE8jEZ6dyj/2MaYOJb9YTPPL
6bJ0wmirPRL+NOvXcAsKxV9+gwdrEY8sYvQyzHLtojcJ1MOsAt14mBbLdmqakb/Y
txKheo4/mgpXttxojNjwhcNc4uybeTXS/MPKYfQrX2y4yH8Czli3kiyGovCWwUKH
gOAeG1ckwfVDmbaBKat7A0fc2nJEpeYzB3bdrSBfPhnHlj6ooFcwD1ah9ogP4GM=
=p5Py
-----END PGP SIGNATURE-----

--00GvhwF7k39YY--
