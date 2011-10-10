Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754407Ab1JJNoi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Oct 2011 09:44:38 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:57520 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754190Ab1JJNlm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Oct 2011 09:41:42 -0400
X-Authority-Analysis: v=1.1 cv=cSzO76bR5tCkfUT9bEmBgR3d7VUusRLeq08eKGxa4EU= c=1 sm=0 a=vhdKIqpQuCYA:10 a=AgGSS-sALaIA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=20KFwNOVAAAA:8 a=VwQbUJbxAAAA:8 a=meVymXHHAAAA:8 a=FEx_p1iwbj3s_r-WGeIA:9 a=QEXdDO2ut3YA:10 a=DHQQ7jDAcw4A:10 a=jEp0ucaQiEUA:10 a=jeBq3FmKZ4MA:10 a=4qDJOpy_O5iEuikC9NEA:9 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-Id: <20111010134141.176917065@goodmis.org>
User-Agent: quilt/0.48-1
Date: Mon, 10 Oct 2011 09:39:01 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>
Subject: [PATCH 09/20] tracing/filter: Change count_leafs function to use walk_pred_tree
References: <20111010133852.829771373@goodmis.org>
Content-Disposition: inline; filename=0009-tracing-filter-Change-count_leafs-function-to-use-wa.patch
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="00GvhwF7k39YY"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--00GvhwF7k39YY
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

From: Jiri Olsa <jolsa@redhat.com>

Changing count_leafs function to use unified predicates tree
processing.

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Link: http://lkml.kernel.org/r/1313072754-4620-7-git-send-email-jolsa@redha=
t.com
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/trace_events_filter.c |   47 ++++++++++----------------------=
---
 1 files changed, 14 insertions(+), 33 deletions(-)

diff --git a/kernel/trace/trace_events_filter.c b/kernel/trace/trace_events=
_filter.c
index 5b889d4..ebbb261 100644
--- a/kernel/trace/trace_events_filter.c
+++ b/kernel/trace/trace_events_filter.c
@@ -1418,43 +1418,24 @@ static int check_pred_tree(struct event_filter *fil=
ter,
 			      check_pred_tree_cb, &data);
 }
=20
-static int count_leafs(struct filter_pred *preds, struct filter_pred *root)
+static int count_leafs_cb(enum move_type move, struct filter_pred *pred,
+			  int *err, void *data)
 {
-	struct filter_pred *pred;
-	enum move_type move =3D MOVE_DOWN;
-	int count =3D 0;
-	int done =3D 0;
+	int *count =3D data;
=20
-	pred =3D root;
+	if ((move =3D=3D MOVE_DOWN) &&
+	    (pred->left =3D=3D FILTER_PRED_INVALID))
+		(*count)++;
=20
-	do {
-		switch (move) {
-		case MOVE_DOWN:
-			if (pred->left !=3D FILTER_PRED_INVALID) {
-				pred =3D &preds[pred->left];
-				continue;
-			}
-			/* A leaf at the root is just a leaf in the tree */
-			if (pred =3D=3D root)
-				return 1;
-			count++;
-			pred =3D get_pred_parent(pred, preds,
-					       pred->parent, &move);
-			continue;
-		case MOVE_UP_FROM_LEFT:
-			pred =3D &preds[pred->right];
-			move =3D MOVE_DOWN;
-			continue;
-		case MOVE_UP_FROM_RIGHT:
-			if (pred =3D=3D root)
-				break;
-			pred =3D get_pred_parent(pred, preds,
-					       pred->parent, &move);
-			continue;
-		}
-		done =3D 1;
-	} while (!done);
+	return WALK_PRED_DEFAULT;
+}
+
+static int count_leafs(struct filter_pred *preds, struct filter_pred *root)
+{
+	int count =3D 0, ret;
=20
+	ret =3D walk_pred_tree(preds, root, count_leafs_cb, &count);
+	WARN_ON(ret);
 	return count;
 }
=20
--=20
1.7.6.3



--00GvhwF7k39YY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAABAgAGBQJOkvYVAAoJEIy3vGnGbaoA4d8P/jl+I1e1zy+OHA8rmkfl8dvR
S6jQRlOffwkOuheYBwaGsZ0okCsJNGNQNBbRgoYJdZCr2QRcBqbCfEFJIQKufaxH
qKZ1o8lDA917QrcQ/tbyuPb3R0x8IwVLIU2w13sQ+sFUj9pAXedilfFsJVf4ZCar
FBMiAzKB6H1MGYdSBdLP52NG9hzZ96LUr1Yw/u7Tzt+aStt7NLdSTPKp5es2rXVZ
JMdCO+FPy6nz2bJD29enINzDOLj3b91LH/WPCMKGcONH6LcVQquBPDEdGZGBdPzm
N8IelNGyoSzTcdEymNpZ8HpbMAifSKXiWFqirEb9z3LMvgA9GxXUh2nLAXa57kG3
5l96F10kcwuWMHoN3cdUvoeJ3d8TQ0I8SPggjzBKh3FrEnRfO5ZtYvRX7N+RQSSy
dI/GltJO+wrr4qYGdesJtkqoHK866GOTb3CQB1/a3/AhyMuaFiwvSDzF5LrXROpO
uwtFuRMcXfhz5rNdms3a24gSobx9FRP9H/+i3vgnHQ/IDeeNCArXiPshB6zHUaxm
AWAghKSOO1BU3Bd8l9ZgdnnY9ngIi0UDwTCjcSdtoza0V86xqkrmllZWIRE1H/ql
Tou5MLTTur8degdIMYcbYeRL/08tB2R5Y8ROnvWP2RgTOjgpEkSK2I7JEkxzOojh
xCgUHIAspXSw8/kaHjc7
=0IXJ
-----END PGP SIGNATURE-----

--00GvhwF7k39YY--
