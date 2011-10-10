Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754363Ab1JJNnv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Oct 2011 09:43:51 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:57520 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754061Ab1JJNlo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Oct 2011 09:41:44 -0400
X-Authority-Analysis: v=1.1 cv=cSzO76bR5tCkfUT9bEmBgR3d7VUusRLeq08eKGxa4EU= c=1 sm=0 a=vhdKIqpQuCYA:10 a=vgUQD53szWUA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=20KFwNOVAAAA:8 a=VwQbUJbxAAAA:8 a=meVymXHHAAAA:8 a=k6WyHbhKYv5p59E922cA:9 a=QEXdDO2ut3YA:10 a=DHQQ7jDAcw4A:10 a=jEp0ucaQiEUA:10 a=jeBq3FmKZ4MA:10 a=9e7T0-pliCAU_udhO7wA:9 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-Id: <20111010134142.324517041@goodmis.org>
User-Agent: quilt/0.48-1
Date: Mon, 10 Oct 2011 09:39:03 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>
Subject: [PATCH 11/20] tracing/filter: Change fold_pred function to use walk_pred_tree
References: <20111010133852.829771373@goodmis.org>
Content-Disposition: inline; filename=0011-tracing-filter-Change-fold_pred-function-to-use-walk.patch
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
Link: http://lkml.kernel.org/r/1313072754-4620-9-git-send-email-jolsa@redha=
t.com
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/trace_events_filter.c |   68 +++++++++++++++++---------------=
---
 1 files changed, 33 insertions(+), 35 deletions(-)

diff --git a/kernel/trace/trace_events_filter.c b/kernel/trace/trace_events=
_filter.c
index d8aa100..f44e68b 100644
--- a/kernel/trace/trace_events_filter.c
+++ b/kernel/trace/trace_events_filter.c
@@ -1439,13 +1439,40 @@ static int count_leafs(struct filter_pred *preds, s=
truct filter_pred *root)
 	return count;
 }
=20
+struct fold_pred_data {
+	struct filter_pred *root;
+	int count;
+	int children;
+};
+
+static int fold_pred_cb(enum move_type move, struct filter_pred *pred,
+			int *err, void *data)
+{
+	struct fold_pred_data *d =3D data;
+	struct filter_pred *root =3D d->root;
+
+	if (move !=3D MOVE_DOWN)
+		return WALK_PRED_DEFAULT;
+	if (pred->left !=3D FILTER_PRED_INVALID)
+		return WALK_PRED_DEFAULT;
+
+	if (WARN_ON(d->count =3D=3D d->children)) {
+		*err =3D -EINVAL;
+		return WALK_PRED_ABORT;
+	}
+
+	pred->index &=3D ~FILTER_PRED_FOLD;
+	root->ops[d->count++] =3D pred->index;
+	return WALK_PRED_DEFAULT;
+}
+
 static int fold_pred(struct filter_pred *preds, struct filter_pred *root)
 {
-	struct filter_pred *pred;
-	enum move_type move =3D MOVE_DOWN;
-	int count =3D 0;
+	struct fold_pred_data data =3D {
+		.root  =3D root,
+		.count =3D 0,
+	};
 	int children;
-	int done =3D 0;
=20
 	/* No need to keep the fold flag */
 	root->index &=3D ~FILTER_PRED_FOLD;
@@ -1463,37 +1490,8 @@ static int fold_pred(struct filter_pred *preds, stru=
ct filter_pred *root)
 		return -ENOMEM;
=20
 	root->val =3D children;
-
-	pred =3D root;
-	do {
-		switch (move) {
-		case MOVE_DOWN:
-			if (pred->left !=3D FILTER_PRED_INVALID) {
-				pred =3D &preds[pred->left];
-				continue;
-			}
-			if (WARN_ON(count =3D=3D children))
-				return -EINVAL;
-			pred->index &=3D ~FILTER_PRED_FOLD;
-			root->ops[count++] =3D pred->index;
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
+	data.children =3D children;
+	return walk_pred_tree(preds, root, fold_pred_cb, &data);
 }
=20
 static int fold_pred_tree_cb(enum move_type move, struct filter_pred *pred,
--=20
1.7.6.3



--00GvhwF7k39YY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAABAgAGBQJOkvYWAAoJEIy3vGnGbaoAsQ0P+wYuxDOo0Eir6ULWfQa7DmWy
r2rlsP6q7mxCgnoyOawk+FykY50roKUVKlCmNyHS68ueIvs2nQtEt+SP+muxsD3S
8YFx41/3fPLJS8d73AF7lq2IWzCXXgsbIGUL2hW9AjkT7MehFMaaeHUcHz46vbPk
9JV4I978V3OrQfCxbjvccDLxwMs1h44LL4Y6AfYUv2s9uqlht9uKZO+8WoUcUppv
gOWAW54L1pffUrD7icoAHlpKoYhy7d2smUL+FhVzLRGV2oUOej1SGpKZMedtRghX
mWd8xqdu3sHVN2MnDPhUR9hepnAmvxalhj2jv0rELXinG4RX9vOjz9bQ+b/4szOA
w6txOA5fmjg0k48OokLA0ZJjj2Ukcyw56R+r5WpM6ILMAQyrHlCzL/XoZJMcFpHV
+sFe36b3InlseOuqdO93tGtDaxgNeezD93c+xOIz4/hte5EHlb/jVW3znUR83sWA
lPco4wxee58CF0PWbGC9IiMqBBfPEEm/PCAJPiJ89oR2QYijzfco1GDBWvhZ4qCE
g+10Thm/FpWTwDu1NUNF7C27gP29JvRO71Zp0PkJAXReEfK4mhXke3yR7E4s9TCb
PL1sMZD3MQ/U+Bv/TkLAF8I1U3S+lDIq8kdLY1ruUbb1GdoV4HMA5r/YCwVSgFmG
4XEF233BPfRQ0FLEowp3
=hrWo
-----END PGP SIGNATURE-----

--00GvhwF7k39YY--
