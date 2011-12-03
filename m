Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755249Ab1LCB4n (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Dec 2011 20:56:43 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:63117 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754102Ab1LCB4l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Dec 2011 20:56:41 -0500
X-Authority-Analysis: v=2.0 cv=dOUkaZlb c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=iwpXj59KtUAA:10 a=5SG0PmZfjMsA:10 a=VwQbUJbxAAAA:8 a=1XWaLZrsAAAA:8 a=pGLkceISAAAA:8 a=20KFwNOVAAAA:8 a=meVymXHHAAAA:8 a=_V_zpGV5dmoCMt7CtL0A:9 a=FEmMcp-wLpeZZHpRqskA:7 a=QEXdDO2ut3YA:10 a=LI9Vle30uBYA:10 a=UTB_XpHje0EA:10 a=MSl-tDqOz04A:10 a=jEp0ucaQiEUA:10 a=jeBq3FmKZ4MA:10 a=sl2m2tP-tFcFG2WKpe8A:9 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Subject: [PATCH][GIT PULL][v3.2] trace_events_filter: Use
 rcu_assign_pointer() when setting ftrace_event_call->filter
From: Steven Rostedt <rostedt@goodmis.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@redhat.com>, Andrew Morton <akpm@linux-foundation.org>,
        Tejun Heo <tj@kernel.org>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-dUKei558pZ74FBESM18I"
Date: Fri, 02 Dec 2011 20:56:39 -0500
Message-ID: <1322877399.30977.68.camel@frodo>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 (2.32.3-1.fc14) 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-dUKei558pZ74FBESM18I
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable


Ingo,

Please pull the latest tip/perf/urgent tree, which can be found at:

  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-trace.git
tip/perf/urgent

Head SHA1: d3d9acf646679c1981032b0985b386d12fccc60c


Tejun Heo (1):
      trace_events_filter: Use rcu_assign_pointer() when setting ftrace_eve=
nt_call->filter

----
 kernel/trace/trace_events_filter.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)
---------------------------
commit d3d9acf646679c1981032b0985b386d12fccc60c
Author: Tejun Heo <tj@kernel.org>
Date:   Wed Nov 23 08:49:49 2011 -0800

    trace_events_filter: Use rcu_assign_pointer() when setting ftrace_event=
_call->filter
   =20
    ftrace_event_call->filter is sched RCU protected but didn't use
    rcu_assign_pointer().  Use it.
   =20
    TODO: Add proper __rcu annotation to call->filter and all its users.
   =20
    -v2: Use RCU_INIT_POINTER() for %NULL clearing as suggested by Eric.
   =20
    Link: http://lkml.kernel.org/r/20111123164949.GA29639@google.com
   =20
    Cc: Eric Dumazet <eric.dumazet@gmail.com>
    Cc: Frederic Weisbecker <fweisbec@gmail.com>
    Cc: Jiri Olsa <jolsa@redhat.com>
    Cc: stable@kernel.org # (2.6.39+)
    Signed-off-by: Tejun Heo <tj@kernel.org>
    Signed-off-by: Steven Rostedt <rostedt@goodmis.org>

diff --git a/kernel/trace/trace_events_filter.c b/kernel/trace/trace_events=
_filter.c
index 816d3d0..d6e7926 100644
--- a/kernel/trace/trace_events_filter.c
+++ b/kernel/trace/trace_events_filter.c
@@ -1686,7 +1686,7 @@ static int replace_system_preds(struct event_subsyste=
m *system,
 		 * replace the filter for the call.
 		 */
 		filter =3D call->filter;
-		call->filter =3D filter_item->filter;
+		rcu_assign_pointer(call->filter, filter_item->filter);
 		filter_item->filter =3D filter;
=20
 		fail =3D false;
@@ -1741,7 +1741,7 @@ int apply_event_filter(struct ftrace_event_call *call=
, char *filter_string)
 		filter =3D call->filter;
 		if (!filter)
 			goto out_unlock;
-		call->filter =3D NULL;
+		RCU_INIT_POINTER(call->filter, NULL);
 		/* Make sure the filter is not being used */
 		synchronize_sched();
 		__free_filter(filter);
@@ -1782,7 +1782,7 @@ out:
 	 * string
 	 */
 	tmp =3D call->filter;
-	call->filter =3D filter;
+	rcu_assign_pointer(call->filter, filter);
 	if (tmp) {
 		/* Make sure the call is done with the filter */
 		synchronize_sched();


--=-dUKei558pZ74FBESM18I
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAABAgAGBQJO2YHUAAoJEIy3vGnGbaoAfVMQALnYAxWcTVZjAu9yE6Xj3JIE
0/hCvRtIVebIfMxnJT6ofXts999EcPwkhCeqDfF/TPCx07OblIF5VsLvY8nGz0TK
vQTHzem2oZELNFfLQApxroqJLSvNW+rYs318jU7YqZ+Owi2+DuHeTrFSxZZ8zwUX
jHyKA0vc1D6sazKJWY75/FtGTr2xSvPEfIRWPI/HedGvuIZsaWvMp7Td7aZ/y4HX
4chOuYmLeiv91GEcdvAeAu1OUTVff+ki4QQ4DT2EpA23TpCLxs7/4e+X3018RD7e
WOCfxwX/oKz5TeJ9uVK2dbiSAXAvD9R93HTHLLzr6qdHie3VktlYQSxXDr7bLD38
hFeL/0PA2jETWBNQgNclb5NiCC9M2lcJVl7oxir91CsqNEl9+x/ao8V8sMklUg3h
/x8e0mfSiql2rZ/92cBRGWmwbkJWaGGrMUqtzjinnFowW83UPr1X3oc9qWckwVwq
dr2P4XokjnzAnDjNKu4d9u7lZs7zXw+PAgiUuiiP5HOj7B7h/wq0fWmHxH++xj6z
HkH0lR7LfYO/+9cZRc4kI27RedBPOY0xd10ZcupH/SYpNlA4rmWu2yZNocrANgyt
u76S6kfQTiWXzEWjX+FTPtCQc3FHLaWgqY846Ti5DYS7G7rTZuE3WuLggUcNCDWc
5cfldVCPG69k6Fdru9Cr
=dEcP
-----END PGP SIGNATURE-----

--=-dUKei558pZ74FBESM18I--

