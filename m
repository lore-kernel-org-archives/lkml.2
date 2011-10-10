Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754377Ab1JJNoF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Oct 2011 09:44:05 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:49686 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754162Ab1JJNlo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Oct 2011 09:41:44 -0400
X-Authority-Analysis: v=1.1 cv=XWD5/VRj2HUJOhsR8cgmvPBlhMACpZXxseY1Kn/ehQI= c=1 sm=0 a=vhdKIqpQuCYA:10 a=SHEEq54kMnAA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=20KFwNOVAAAA:8 a=VwQbUJbxAAAA:8 a=meVymXHHAAAA:8 a=ZLtMC68xly990H2G1H4A:9 a=JL6kCci4qb1n2pGOnEYA:7 a=QEXdDO2ut3YA:10 a=DHQQ7jDAcw4A:10 a=jEp0ucaQiEUA:10 a=jeBq3FmKZ4MA:10 a=J8SBAF9lk6HmygIKOeoA:9 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-Id: <20111010134142.760718007@goodmis.org>
User-Agent: quilt/0.48-1
Date: Mon, 10 Oct 2011 09:39:04 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>
Subject: [PATCH 12/20] tracing/filter: Change filter_match_preds function to use
References: <20111010133852.829771373@goodmis.org>
Content-Disposition: inline; filename=0012-tracing-filter-Change-filter_match_preds-function-to.patch
 walk_pred_tree
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="00GvhwF7k39YY"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--00GvhwF7k39YY
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

From: Jiri Olsa <jolsa@redhat.com>

Changing filter_match_preds function to use unified predicates tree
processing.

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Link: http://lkml.kernel.org/r/1313072754-4620-10-git-send-email-jolsa@redh=
at.com
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/trace_events_filter.c |  124 +++++++++++++++++---------------=
----
 1 files changed, 58 insertions(+), 66 deletions(-)

diff --git a/kernel/trace/trace_events_filter.c b/kernel/trace/trace_events=
_filter.c
index f44e68b..319c3ca 100644
--- a/kernel/trace/trace_events_filter.c
+++ b/kernel/trace/trace_events_filter.c
@@ -467,99 +467,91 @@ static int process_ops(struct filter_pred *preds,
=20
 	for (i =3D 0; i < op->val; i++) {
 		pred =3D &preds[op->ops[i]];
-		match =3D pred->fn(pred, rec);
+		if (!WARN_ON_ONCE(!pred->fn))
+			match =3D pred->fn(pred, rec);
 		if (!!match =3D=3D type)
 			return match;
 	}
 	return match;
 }
=20
+struct filter_match_preds_data {
+	struct filter_pred *preds;
+	int match;
+	void *rec;
+};
+
+static int filter_match_preds_cb(enum move_type move, struct filter_pred *=
pred,
+				 int *err, void *data)
+{
+	struct filter_match_preds_data *d =3D data;
+
+	*err =3D 0;
+	switch (move) {
+	case MOVE_DOWN:
+		/* only AND and OR have children */
+		if (pred->left !=3D FILTER_PRED_INVALID) {
+			/* If ops is set, then it was folded. */
+			if (!pred->ops)
+				return WALK_PRED_DEFAULT;
+			/* We can treat folded ops as a leaf node */
+			d->match =3D process_ops(d->preds, pred, d->rec);
+		} else {
+			if (!WARN_ON_ONCE(!pred->fn))
+				d->match =3D pred->fn(pred, d->rec);
+		}
+
+		return WALK_PRED_PARENT;
+	case MOVE_UP_FROM_LEFT:
+		/*
+		 * Check for short circuits.
+		 *
+		 * Optimization: !!match =3D=3D (pred->op =3D=3D OP_OR)
+		 *   is the same as:
+		 * if ((match && pred->op =3D=3D OP_OR) ||
+		 *     (!match && pred->op =3D=3D OP_AND))
+		 */
+		if (!!d->match =3D=3D (pred->op =3D=3D OP_OR))
+			return WALK_PRED_PARENT;
+		break;
+	case MOVE_UP_FROM_RIGHT:
+		break;
+	}
+
+	return WALK_PRED_DEFAULT;
+}
+
 /* return 1 if event matches, 0 otherwise (discard) */
 int filter_match_preds(struct event_filter *filter, void *rec)
 {
-	int match =3D -1;
-	enum move_type move =3D MOVE_DOWN;
 	struct filter_pred *preds;
-	struct filter_pred *pred;
 	struct filter_pred *root;
-	int n_preds;
-	int done =3D 0;
+	struct filter_match_preds_data data =3D {
+		/* match is currently meaningless */
+		.match =3D -1,
+		.rec   =3D rec,
+	};
+	int n_preds, ret;
=20
 	/* no filter is considered a match */
 	if (!filter)
 		return 1;
=20
 	n_preds =3D filter->n_preds;
-
 	if (!n_preds)
 		return 1;
=20
 	/*
 	 * n_preds, root and filter->preds are protect with preemption disabled.
 	 */
-	preds =3D rcu_dereference_sched(filter->preds);
 	root =3D rcu_dereference_sched(filter->root);
 	if (!root)
 		return 1;
=20
-	pred =3D root;
-
-	/* match is currently meaningless */
-	match =3D -1;
-
-	do {
-		switch (move) {
-		case MOVE_DOWN:
-			/* only AND and OR have children */
-			if (pred->left !=3D FILTER_PRED_INVALID) {
-				/* If ops is set, then it was folded. */
-				if (!pred->ops) {
-					/* keep going to down the left side */
-					pred =3D &preds[pred->left];
-					continue;
-				}
-				/* We can treat folded ops as a leaf node */
-				match =3D process_ops(preds, pred, rec);
-			} else
-				match =3D pred->fn(pred, rec);
-			/* If this pred is the only pred */
-			if (pred =3D=3D root)
-				break;
-			pred =3D get_pred_parent(pred, preds,
-					       pred->parent, &move);
-			continue;
-		case MOVE_UP_FROM_LEFT:
-			/*
-			 * Check for short circuits.
-			 *
-			 * Optimization: !!match =3D=3D (pred->op =3D=3D OP_OR)
-			 *   is the same as:
-			 * if ((match && pred->op =3D=3D OP_OR) ||
-			 *     (!match && pred->op =3D=3D OP_AND))
-			 */
-			if (!!match =3D=3D (pred->op =3D=3D OP_OR)) {
-				if (pred =3D=3D root)
-					break;
-				pred =3D get_pred_parent(pred, preds,
-						       pred->parent, &move);
-				continue;
-			}
-			/* now go down the right side of the tree. */
-			pred =3D &preds[pred->right];
-			move =3D MOVE_DOWN;
-			continue;
-		case MOVE_UP_FROM_RIGHT:
-			/* We finished this equation. */
-			if (pred =3D=3D root)
-				break;
-			pred =3D get_pred_parent(pred, preds,
-					       pred->parent, &move);
-			continue;
-		}
-		done =3D 1;
-	} while (!done);
-
-	return match;
+	data.preds =3D preds =3D rcu_dereference_sched(filter->preds);
+	ret =3D walk_pred_tree(preds, root, filter_match_preds_cb, &data);
+	WARN_ON(ret);
+	return data.match;
 }
 EXPORT_SYMBOL_GPL(filter_match_preds);
=20
--=20
1.7.6.3



--00GvhwF7k39YY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAABAgAGBQJOkvYXAAoJEIy3vGnGbaoA4WQQAKQdrkDiOPQW/SKggm3CDQ61
klzzKBGPsYl//MuyZJoQSHEH3cVdyVIOqoeBkV9VqP8vh6TUO1B3E37IzDCbOkKy
gSVNvI/ZribBt2hvVI50bfpc6vtkeBV71C0jpRYTTYMhyOEBq8aVGnJFMfJcoHx7
TZeNSag0lccO1UnSKFJJ6nAMvVxGHxZwVHx77kYbxMBzMx3fEzS7coVI68IaUeST
EpFHhnq5CdC9vkU2K46jJXq5Jok8s1RYi2MhXReVrSVblUoO8ktSAUsIwc+MLw6E
Sm+mxhhCd9nqIT9XJSqsrU+z6hVKiFSVPUL7enCaD9DKkZi10pDecSDkioocynZj
qvjkYholhKsYOEuUG/ojutKxZOUE1aSc+Z8j3KHxEjgmHfTfYVWveIU+fwy7fXEd
9mVYj8tp+kwV9vgF4hX2vyzO+R8OunkYN3bhY58qe68M0rFhSQxVUQDH39cfULQ+
LYb9XnXUYeZ0JRvUFBl47sNABtJa29Qx1Krp4wplwo89JsVSMc61FNm7IsvMbAi5
TUZSxkWZO+KdL2l2qCLO9RSEQATEqwUgN4Uo1tgIvz9fVO4QPcZn+B+3Ud95gMgA
0DdgsZxDeGp8pichB5goSb+tnN12YWfxAgWoRdr1yHO4MN2yAEq5E9phv+hA2ZW0
br0NRXR5PvRl2VlVo60F
=V7uM
-----END PGP SIGNATURE-----

--00GvhwF7k39YY--
