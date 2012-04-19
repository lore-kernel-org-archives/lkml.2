Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932713Ab2DSVHF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2012 17:07:05 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:7223 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932670Ab2DSVHA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2012 17:07:00 -0400
X-Authority-Analysis: v=2.0 cv=MNHiabll c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=dCnVzci9uaIA:10 a=5SG0PmZfjMsA:10 a=VwQbUJbxAAAA:8 a=20KFwNOVAAAA:8 a=meVymXHHAAAA:8 a=fa0A10gxbljJTfN8tNEA:9 a=PUjeQqilurYA:10 a=jEp0ucaQiEUA:10 a=jeBq3FmKZ4MA:10 a=5qJRDmzxYd9-oOvm7YkA:9 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1334869614.28106.72.camel@gandalf.stny.rr.com>
Subject: [PATCH][GIT PULL][v3.4] tracing: Fix stacktrace of latency tracers
 (irqsoff and friends)
From: Steven Rostedt <rostedt@goodmis.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        stable <stable@vger.kernel.org>
Date: Thu, 19 Apr 2012 17:06:54 -0400
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-k/bHwk2+FsPcT6OjqZaA"
X-Mailer: Evolution 3.2.2-1 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-k/bHwk2+FsPcT6OjqZaA
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: quoted-printable


Ingo,

Found another stacktrace bug. This is on top of the last pull request I
made.

-- Steve


Please pull the latest tip/perf/urgent-2 tree, which can be found at:

  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-trace.git
tip/perf/urgent-2

Head SHA1: db4c75cbebd7e5910cd3bcb6790272fcc3042857


Steven Rostedt (1):
      tracing: Fix stacktrace of latency tracers (irqsoff and friends)

----
 kernel/trace/trace_output.c |    5 +++++
 1 file changed, 5 insertions(+)
---------------------------
commit db4c75cbebd7e5910cd3bcb6790272fcc3042857
Author: Steven Rostedt <srostedt@redhat.com>
Date:   Thu Apr 19 10:31:47 2012 -0400

    tracing: Fix stacktrace of latency tracers (irqsoff and friends)
   =20
    While debugging a latency with someone on IRC (mirage335) on #linux-rt =
(OFTC),
    we discovered that the stacktrace output of the latency tracers
    (preemptirqsoff) was empty.
   =20
    This bug was caused by the creation of the dynamic length stack trace
    again (like commit 12b5da3 "tracing: Fix ent_size in trace output" was)=
.
   =20
    This bug is caused by the latency tracers requiring the next event
    to determine the time between the current event and the next. But by
    grabbing the next event, the iter->ent_size is set to the next event
    instead of the current one. As the stacktrace event is the last event,
    this makes the ent_size zero and causes nothing to be printed for
    the stack trace. The dynamic stacktrace uses the ent_size to determine
    how much of the stack can be printed. The ent_size of zero means
    no stack.
   =20
    The simple fix is to save the iter->ent_size before finding the next ev=
ent.
   =20
    Note, mirage335 asked to remain anonymous from LKML and git, so I will
    not add the Reported-by and Tested-by tags, even though he did report
    the issue and tested the fix.
   =20
    Cc: stable@vger.kernel.org # 3.1+
    Signed-off-by: Steven Rostedt <rostedt@goodmis.org>

diff --git a/kernel/trace/trace_output.c b/kernel/trace/trace_output.c
index 859fae6..df611a0 100644
--- a/kernel/trace/trace_output.c
+++ b/kernel/trace/trace_output.c
@@ -652,6 +652,8 @@ int trace_print_lat_context(struct trace_iterator *iter=
)
 {
 	u64 next_ts;
 	int ret;
+	/* trace_find_next_entry will reset ent_size */
+	int ent_size =3D iter->ent_size;
 	struct trace_seq *s =3D &iter->seq;
 	struct trace_entry *entry =3D iter->ent,
 			   *next_entry =3D trace_find_next_entry(iter, NULL,
@@ -660,6 +662,9 @@ int trace_print_lat_context(struct trace_iterator *iter=
)
 	unsigned long abs_usecs =3D ns2usecs(iter->ts - iter->tr->time_start);
 	unsigned long rel_usecs;
=20
+	/* Restore the original ent_size */
+	iter->ent_size =3D ent_size;
+
 	if (!next_entry)
 		next_ts =3D iter->ts;
 	rel_usecs =3D ns2usecs(next_ts - iter->ts);


--=-k/bHwk2+FsPcT6OjqZaA
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAABAgAGBQJPkH5uAAoJEIy3vGnGbaoA2kYP/1w38J+pWyFSfctshbgaPHuF
0satJgXCObaVpbO/lVsajBhqj7UT/ITITnELrzZsz6bH3ONjoghYhlDc8dJmJmvI
w8U9+wS/4eF6Rpwk2vqn3Ydt21Epr67Ntt20JLcQInyed/oqEO4N7sIV74tuvHhO
PBMF7jjaUnCt1onfIiAH6EcxECzSwRK8YX+EbnV878Yq2cikcCCtKQODqNTxDdm3
9x2bLApLWRs+0hsjcnnh/v/B+YNO1p6JboajOoyMHX4j+LAm/XxV8NQfGHd3xRJF
ure2xzi6LbluePnBai0VbpDThx1lNE+vG08ytklvNj2SseFE4CAEfAtriFuxD0f9
Fm09S+7RvWrGcadVoQ2JA5HwhCf+6TtYMzVi0/fGzBmEBFFpeuzK7RcR1MPKv+zn
51kIsn78YFqJo02DvGFXsfNSEUQuKUCfq6bdBk3lAoawCWPz4lxqGDZ9b9+MX2pO
+iBgPnKp5P/kC+qe+M8H3hAE2DgueBB/OJjpSrNRLzl/PCV4zGz0XuiYIZ2pawd+
G7tVCEUSyjL8qIuAXFXcYM6CLBP+k6qJKR9d4IKpXkAujwTdoftDVFYPNY7nVfLK
D4Iw5AlrrQLX4YXdEJwU0OVH94MKC5gpIpvTK4ktjFTesVWIWDu0J3erYOnet51U
SSlWpPC6Uv7GX43iZpoF
=d4FR
-----END PGP SIGNATURE-----

--=-k/bHwk2+FsPcT6OjqZaA--

