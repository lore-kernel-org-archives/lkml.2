Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754331Ab1JJNoe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Oct 2011 09:44:34 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:60233 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754199Ab1JJNlm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Oct 2011 09:41:42 -0400
X-Authority-Analysis: v=1.1 cv=agqPq5NoKwAPC9P66H7dbYUCjxvmT73as08i4x3aqAA= c=1 sm=0 a=vhdKIqpQuCYA:10 a=cow84G8iWgsA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=20KFwNOVAAAA:8 a=VwQbUJbxAAAA:8 a=meVymXHHAAAA:8 a=U7k50tahjhb5x0etHIYA:9 a=QEXdDO2ut3YA:10 a=DHQQ7jDAcw4A:10 a=jEp0ucaQiEUA:10 a=jeBq3FmKZ4MA:10 a=HaP957gOqwRccbPWSy0A:9 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-Id: <20111010134141.891528757@goodmis.org>
User-Agent: quilt/0.48-1
Date: Mon, 10 Oct 2011 09:39:02 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>
Subject: [PATCH 10/20] tracing/filter: Change fold_pred_tree function to use walk_pred_tree
References: <20111010133852.829771373@goodmis.org>
Content-Disposition: inline; filename=0010-tracing-filter-Change-fold_pred_tree-function-to-use.patch
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="00GvhwF7k39YY"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--00GvhwF7k39YY
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

From: Jiri Olsa <jolsa@redhat.com>

Changing fold_pred_tree function to use unified predicates tree
processing.

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Link: http://lkml.kernel.org/r/1313072754-4620-8-git-send-email-jolsa@redha=
t.com
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/trace_events_filter.c |   65 +++++++++++---------------------=
----
 1 files changed, 20 insertions(+), 45 deletions(-)

diff --git a/kernel/trace/trace_events_filter.c b/kernel/trace/trace_events=
_filter.c
index ebbb261..d8aa100 100644
--- a/kernel/trace/trace_events_filter.c
+++ b/kernel/trace/trace_events_filter.c
@@ -1496,6 +1496,24 @@ static int fold_pred(struct filter_pred *preds, stru=
ct filter_pred *root)
 	return 0;
 }
=20
+static int fold_pred_tree_cb(enum move_type move, struct filter_pred *pred,
+			     int *err, void *data)
+{
+	struct filter_pred *preds =3D data;
+
+	if (move !=3D MOVE_DOWN)
+		return WALK_PRED_DEFAULT;
+	if (!(pred->index & FILTER_PRED_FOLD))
+		return WALK_PRED_DEFAULT;
+
+	*err =3D fold_pred(preds, pred);
+	if (*err)
+		return WALK_PRED_ABORT;
+
+	/* eveyrhing below is folded, continue with parent */
+	return WALK_PRED_PARENT;
+}
+
 /*
  * To optimize the processing of the ops, if we have several "ors" or
  * "ands" together, we can put them in an array and process them all
@@ -1504,51 +1522,8 @@ static int fold_pred(struct filter_pred *preds, stru=
ct filter_pred *root)
 static int fold_pred_tree(struct event_filter *filter,
 			   struct filter_pred *root)
 {
-	struct filter_pred *preds;
-	struct filter_pred *pred;
-	enum move_type move =3D MOVE_DOWN;
-	int done =3D 0;
-	int err;
-
-	preds =3D filter->preds;
-	if  (!preds)
-		return -EINVAL;
-	pred =3D root;
-
-	do {
-		switch (move) {
-		case MOVE_DOWN:
-			if (pred->index & FILTER_PRED_FOLD) {
-				err =3D fold_pred(preds, pred);
-				if (err)
-					return err;
-				/* Folded nodes are like leafs */
-			} else if (pred->left !=3D FILTER_PRED_INVALID) {
-				pred =3D &preds[pred->left];
-				continue;
-			}
-
-			/* A leaf at the root is just a leaf in the tree */
-			if (pred =3D=3D root)
-				break;
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
-
-	return 0;
+	return walk_pred_tree(filter->preds, root, fold_pred_tree_cb,
+			      filter->preds);
 }
=20
 static int replace_preds(struct ftrace_event_call *call,
--=20
1.7.6.3



--00GvhwF7k39YY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAABAgAGBQJOkvYWAAoJEIy3vGnGbaoAjTsP/RrzIIElMkqmxy+dnFJE8d1w
zOJXTRTH+XnqrtQP6zhgVrVg0rxU3hilT5rvJCVYXpqCs+8SqwYGEdXziDT4mYba
ON8a3VL+12X1jKgJDr8m7/4KZTdo6eHJz901ycfU13mpx+X9SYkcJyZAGR62HUoz
gWbJIAUxvJJecanS/AbtxwwV71+vcYos96/u6jd02ffZwZTYWAxsabQ6cflHHnap
vtDb3et5vKTNHUlO86jiXl7JBM6V3Tv+iaayvaZL93HCXDkGIvYPq529wXjBlQsb
TXHy/Kla7m2aubNu0VMKihd8hgju1y8Gm50C5Rz4ox5S+dIbsMLxDd6Z4uUrdrP7
GBBDZOoWJcCAcmoS10apM5/CnBR3SRZBayKBy7wz0wvHy74lEiRngaPBpzVtGa1+
Rk06Ncmn7qGZ8jgWUdX2LpBWyvcgXvYDBf3I4m5beI7N0vVXZ4/n90+jY07RcLxS
H115NnZQ0M9dOQ2XZPU7kthZQvKlNYI538KiB9o41C74f+xjrL1/neH8HWQgPnYl
IG0hs2nYEycX2JfcbGpQDiGFqJKQbihVKImZVMpzUk3xhR2WHAUihgeCIMpp8F3P
E+wMsDlnlH7jfjy6016OXYoyUCopV09zSzpTUXvliK4+yqzKTyLDhPUc/RYnQIgK
6N4FIlekHBZL2bVFe+ys
=DAFI
-----END PGP SIGNATURE-----

--00GvhwF7k39YY--
