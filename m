Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753992Ab1LUMkf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Dec 2011 07:40:35 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:35463 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753648Ab1LUMiL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Dec 2011 07:38:11 -0500
X-Authority-Analysis: v=2.0 cv=A5HuztqG c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=vhdKIqpQuCYA:10 a=oqbw5PpjbzwA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=20KFwNOVAAAA:8 a=meVymXHHAAAA:8 a=uo6j3UcqH6TWYrfRSasA:9 a=QEXdDO2ut3YA:10 a=jEp0ucaQiEUA:10 a=jeBq3FmKZ4MA:10 a=BoWe6-c-TeEec66ASQYA:9 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-Id: <20111221123807.707783878@goodmis.org>
User-Agent: quilt/0.48-1
Date: Wed, 21 Dec 2011 07:36:33 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 09/16] ftrace: Fix ftrace hash record update with notrace
References: <20111221123624.193898256@goodmis.org>
Content-Disposition: inline; filename=0009-ftrace-Fix-ftrace-hash-record-update-with-notrace.patch
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="00GvhwF7k39YY"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--00GvhwF7k39YY
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

From: Steven Rostedt <srostedt@redhat.com>

When disabling the "notrace" records, that means we want to trace them.
If the notrace_hash is zero, it means that we want to trace all
records. But to disable a zero notrace_hash means nothing.

The check for the notrace_hash count was incorrect with:

	if (hash && !hash->count)
		return

With the correct comment above it that states that we do nothing
if the notrace_hash has zero count. But !hash also means that
the notrace hash has zero count. I think this was done to
protect against dereferencing NULL. But if !hash is true, then
we go through the following loop without doing a single thing.

Fix it to:

	if (!hash || !hash->count)
		return;

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/ftrace.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index dcd3a81..a383d6c 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -1381,7 +1381,7 @@ static void __ftrace_hash_rec_update(struct ftrace_op=
s *ops,
 		 * If the notrace hash has no items,
 		 * then there's nothing to do.
 		 */
-		if (hash && !hash->count)
+		if (!hash || !hash->count)
 			return;
 	}
=20
--=20
1.7.7.3



--00GvhwF7k39YY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAABAgAGBQJO8dMvAAoJEIy3vGnGbaoA1CsP/32FYkyPa2sq4XmLopP4jTWj
rOVEM+tRSE7id6dpYo40ebsfocFRRCpmNjPEI0dTEIR+Cp0SYdfyyAcoUA9jClB5
Jiz48MB4JCgHB7NtNHIkgyogLNhUHMGYJYaO/wp5cPYedI0VqhrDyrp7yqJBBmgX
l1QBhh2etX6N2dkUHXSl4XwNlvWwddZwlGcp90Hzk3vs54d2IDOmvhecLfnAro3g
5SLVf0EeZSKa1t1PbpN6I0vAHYAqyHlW2GoonmA3yjcDIUqPT7C0vO3f4K0RTmN2
dq0ljCnsHZYQGrG5yHioDi4D3Shey0MVk1PXa3WCZKRRpy0/i6AmBi0Fe3Q5aRPu
DZ9dv1thRdEy08QvxgF+bn6ppqe4TyXvhjgpw/jRqzlMOyVKXMhfx1ac8jeogehj
8R94Q/HylFGv7HDaWV8elT0l42yciJIR10f4yRyUciaWnKBdHLkW0CkCyNiczHZt
sqpgo7cWiw+LKdXfDQhQkS8JHFTl2WHVIg2+hlMIYF4YMAPKh24dMAp8vTW1iwwR
/kzCsq+5tH1//+Pv4LLDLYx+5r7wana3oabvqBdIGL4jVpq87hEAF6yuBhyTZX39
xDLE+m7T8XGRzM0Boak4LMzxcasZc1wzvsQp+vTiEdrP+WzhmbVEabCNPHY9ciPD
gnDcMqI9ARJTFow+ALGM
=jckm
-----END PGP SIGNATURE-----

--00GvhwF7k39YY--
