Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423327Ab2KNTJw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2012 14:09:52 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:26690 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423247Ab2KNTJq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2012 14:09:46 -0500
X-Authority-Analysis: v=2.0 cv=RoZH3VaK c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=0z6XRCDO-dMA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=fsuvUruio_gA:10 a=3nbZYyFuAAAA:8 a=VwQbUJbxAAAA:8 a=1XWaLZrsAAAA:8 a=pGLkceISAAAA:8 a=20KFwNOVAAAA:8 a=Bn7xxrpYSftJHWeE3oYA:9 a=QEXdDO2ut3YA:10 a=lSinr4eg3GwA:10 a=EvKJbDF4Ut8A:10 a=UTB_XpHje0EA:10 a=MSl-tDqOz04A:10 a=jEp0ucaQiEUA:10 a=jeBq3FmKZ4MA:10 a=NWVoK91CQyQA:10 a=7kC8Gp49yMuiQpxqjkUA:9 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.115.198
Message-Id: <20121114190942.672871201@goodmis.org>
User-Agent: quilt/0.60-1
Date: Wed, 14 Nov 2012 13:53:36 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>,
        Yoshihiro YUNOMAE <yoshihiro.yunomae.ez@hitachi.com>,
        David Sharp <dhsharp@google.com>
Subject: [PATCH 3/4] tracing: Show raw time stamp on stats per cpu using counter or tsc
 mode for trace_clock
References: <20121114185333.818952665@goodmis.org>
Content-Disposition: inline; filename=0003-tracing-Show-raw-time-stamp-on-stats-per-cpu-using-c.patch
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
Link: http://lkml.kernel.org/r/1352837903-32191-3-git-send-email-dhsharp@go=
ogle.com

Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@redhat.com>
Signed-off-by: Yoshihiro YUNOMAE <yoshihiro.yunomae.ez@hitachi.com>
Signed-off-by: David Sharp <dhsharp@google.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/trace.c |   23 +++++++++++++++++------
 1 file changed, 17 insertions(+), 6 deletions(-)

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index d943e69..b69cc38 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -4388,13 +4388,24 @@ tracing_stats_read(struct file *filp, char __user *=
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

iQEcBAABAgAGBQJQo+x2AAoJEOdOSU1xswtMIFMIALHbLCyIV676zFuWvLSw1y9T
o5ClcSMQEfl1lPc+gVYJVlKVN63byE2j85pDr7/Q0nXH54OU5NqjBk4UWR/mHRqX
FPPLsdcfOIAgh2d3agPnHeS3RMg1ccwYJVe1bp7jDfeKuZLaoMADUpKkw456Z9vn
t+uCHSGA00cZJm6PPGc6oKDkL4ihF+0KuisiRRIx2MGBMzOmSuLrQNDkasXQo31i
IP3S8kw+US8KJhFa/Ift9+7aHXJRG2Z6RBEwcytVCSSq1aVKU+eH/neWltArmcgI
p7/niInhIN20Mu47K0B2tphqj8NkD8VHtz762wj4eUa0xgoZu0yBCQd0hVwDtCk=
=+xAQ
-----END PGP SIGNATURE-----

--00GvhwF7k39YY--
