Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754348Ab1JJNpV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Oct 2011 09:45:21 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:60233 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754176Ab1JJNlm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Oct 2011 09:41:42 -0400
X-Authority-Analysis: v=1.1 cv=agqPq5NoKwAPC9P66H7dbYUCjxvmT73as08i4x3aqAA= c=1 sm=0 a=vhdKIqpQuCYA:10 a=ArZFSUn2AfEA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=20KFwNOVAAAA:8 a=VwQbUJbxAAAA:8 a=meVymXHHAAAA:8 a=x6-7Sb3SakYLQiTwuisA:9 a=nWnCZfKfUOW5cm9nBjgA:7 a=QEXdDO2ut3YA:10 a=DHQQ7jDAcw4A:10 a=jEp0ucaQiEUA:10 a=jeBq3FmKZ4MA:10 a=Tw54eyDyP-Gdywl1GGMA:9 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-Id: <20111010134140.649607277@goodmis.org>
User-Agent: quilt/0.48-1
Date: Mon, 10 Oct 2011 09:39:00 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>
Subject: [PATCH 08/20] tracing/filter: Unify predicate tree walking, change check_pred_tree
References: <20111010133852.829771373@goodmis.org>
Content-Disposition: inline; filename=0008-tracing-filter-Unify-predicate-tree-walking-change-c.patch
 function to use it
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="00GvhwF7k39YY"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--00GvhwF7k39YY
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

From: Jiri Olsa <jolsa@redhat.com>

Adding walk_pred_tree function to be used for walking throught
the filter predicates.

For each predicate the callback function is called, allowing
users to add their own functionality or customize their way
through the filter predicates.

Changing check_pred_tree function to use walk_pred_tree.

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Link: http://lkml.kernel.org/r/1313072754-4620-6-git-send-email-jolsa@redha=
t.com
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/trace_events_filter.c |  137 ++++++++++++++++++++++----------=
---
 1 files changed, 86 insertions(+), 51 deletions(-)

diff --git a/kernel/trace/trace_events_filter.c b/kernel/trace/trace_events=
_filter.c
index 0948905..5b889d4 100644
--- a/kernel/trace/trace_events_filter.c
+++ b/kernel/trace/trace_events_filter.c
@@ -381,6 +381,63 @@ get_pred_parent(struct filter_pred *pred, struct filte=
r_pred *preds,
 	return pred;
 }
=20
+enum walk_return {
+	WALK_PRED_ABORT,
+	WALK_PRED_PARENT,
+	WALK_PRED_DEFAULT,
+};
+
+typedef int (*filter_pred_walkcb_t) (enum move_type move,
+				     struct filter_pred *pred,
+				     int *err, void *data);
+
+static int walk_pred_tree(struct filter_pred *preds,
+			  struct filter_pred *root,
+			  filter_pred_walkcb_t cb, void *data)
+{
+	struct filter_pred *pred =3D root;
+	enum move_type move =3D MOVE_DOWN;
+	int done =3D 0;
+
+	if  (!preds)
+		return -EINVAL;
+
+	do {
+		int err =3D 0, ret;
+
+		ret =3D cb(move, pred, &err, data);
+		if (ret =3D=3D WALK_PRED_ABORT)
+			return err;
+		if (ret =3D=3D WALK_PRED_PARENT)
+			goto get_parent;
+
+		switch (move) {
+		case MOVE_DOWN:
+			if (pred->left !=3D FILTER_PRED_INVALID) {
+				pred =3D &preds[pred->left];
+				continue;
+			}
+			goto get_parent;
+		case MOVE_UP_FROM_LEFT:
+			pred =3D &preds[pred->right];
+			move =3D MOVE_DOWN;
+			continue;
+		case MOVE_UP_FROM_RIGHT:
+ get_parent:
+			if (pred =3D=3D root)
+				break;
+			pred =3D get_pred_parent(pred, preds,
+					       pred->parent,
+					       &move);
+			continue;
+		}
+		done =3D 1;
+	} while (!done);
+
+	/* We are fine. */
+	return 0;
+}
+
 /*
  * A series of AND or ORs where found together. Instead of
  * climbing up and down the tree branches, an array of the
@@ -1321,6 +1378,23 @@ static int count_preds(struct filter_parse_state *ps)
 	return n_preds;
 }
=20
+struct check_pred_data {
+	int count;
+	int max;
+};
+
+static int check_pred_tree_cb(enum move_type move, struct filter_pred *pre=
d,
+			      int *err, void *data)
+{
+	struct check_pred_data *d =3D data;
+
+	if (WARN_ON(d->count++ > d->max)) {
+		*err =3D -EINVAL;
+		return WALK_PRED_ABORT;
+	}
+	return WALK_PRED_DEFAULT;
+}
+
 /*
  * The tree is walked at filtering of an event. If the tree is not correct=
ly
  * built, it may cause an infinite loop. Check here that the tree does
@@ -1329,58 +1403,19 @@ static int count_preds(struct filter_parse_state *p=
s)
 static int check_pred_tree(struct event_filter *filter,
 			   struct filter_pred *root)
 {
-	struct filter_pred *preds;
-	struct filter_pred *pred;
-	enum move_type move =3D MOVE_DOWN;
-	int count =3D 0;
-	int done =3D 0;
-	int max;
-
-	/*
-	 * The max that we can hit a node is three times.
-	 * Once going down, once coming up from left, and
-	 * once coming up from right. This is more than enough
-	 * since leafs are only hit a single time.
-	 */
-	max =3D 3 * filter->n_preds;
-
-	preds =3D filter->preds;
-	if  (!preds)
-		return -EINVAL;
-	pred =3D root;
-
-	do {
-		if (WARN_ON(count++ > max))
-			return -EINVAL;
-
-		switch (move) {
-		case MOVE_DOWN:
-			if (pred->left !=3D FILTER_PRED_INVALID) {
-				pred =3D &preds[pred->left];
-				continue;
-			}
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
+	struct check_pred_data data =3D {
+		/*
+		 * The max that we can hit a node is three times.
+		 * Once going down, once coming up from left, and
+		 * once coming up from right. This is more than enough
+		 * since leafs are only hit a single time.
+		 */
+		.max   =3D 3 * filter->n_preds,
+		.count =3D 0,
+	};
=20
-	/* We are fine. */
-	return 0;
+	return walk_pred_tree(filter->preds, root,
+			      check_pred_tree_cb, &data);
 }
=20
 static int count_leafs(struct filter_pred *preds, struct filter_pred *root)
--=20
1.7.6.3



--00GvhwF7k39YY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAABAgAGBQJOkvYUAAoJEIy3vGnGbaoAbM8P/ie7IynTa6ZC3Cdx3PTNxKNA
8SeTw7x8+/DUszQsKqz2cxoN9feXnx/eRYQ736r4I019xwo9qT2gB/EVa+BR9XzG
MU+Rtj+KTJElyTStwXb1h3IpmYjDn3dNF0sb4wGrO+MZAv8p0SpJua/OSHOQvDU7
/6ZMArKtFUIiFeeJkbcNpamNSO6LwqTiGnXZKIwzbrX9dPXSDgWiGehclEPvH1lm
IF+m9JdB+EfqR6BkoLXw5nZPtHHp2F6u2ZLG9HBlNwgd4Gq/x2q7vhCzm4LPEVVk
uVXzESJbvri7PqngwiK7woDaZWRwPv3LTt9jZnME0bv02m27UH5ni04KfNX+swoU
7QkiPAYq1DcqlMXYSzO1exzE2Yvj64iQCQ/69B5utJPjf7Mq7+R5x6hVS/ReCU3Z
gteijN8O/dN2bwZa7PM5TDq+j/ta/uIg2jXbwTxv8HM1BdCSfvTkpn2yTltgvy7r
ZhrXyaDIMhKA+ftHXzMRI+ROC7ggZgbF9HbK4QEo6cMVNXGXT0s3Kv+k1OBht7rF
c8PIKTYKJZpfvNs2pz/MF2OVsLlAVnztcOv4HLOCZJK9YCNZq7QlaBCyOLSBL+i4
AYCumXagoyoKChfdvGepqCL1Y/2DW4GYeb86mSwHYyJS3tZQ8ec5TR3gKM+wX3rD
0Gfwvg6co9qt8x0C2ZUI
=SOCV
-----END PGP SIGNATURE-----

--00GvhwF7k39YY--
