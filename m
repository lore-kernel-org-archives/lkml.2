Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754388Ab1JJNpp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Oct 2011 09:45:45 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:60233 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754153Ab1JJNll (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Oct 2011 09:41:41 -0400
X-Authority-Analysis: v=1.1 cv=agqPq5NoKwAPC9P66H7dbYUCjxvmT73as08i4x3aqAA= c=1 sm=0 a=vhdKIqpQuCYA:10 a=WJDs0hhh-dAA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=20KFwNOVAAAA:8 a=VwQbUJbxAAAA:8 a=meVymXHHAAAA:8 a=q_iu5iEAGgpD4jx2qzUA:9 a=dfp8IjMbZrS_kIwK43kA:7 a=QEXdDO2ut3YA:10 a=DHQQ7jDAcw4A:10 a=jEp0ucaQiEUA:10 a=jeBq3FmKZ4MA:10 a=qZChSBH0zHxC0y8gSpgA:9 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-Id: <20111010134138.896815699@goodmis.org>
User-Agent: quilt/0.48-1
Date: Mon, 10 Oct 2011 09:38:56 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>
Subject: [PATCH 04/20] tracing/filter: Use static allocation for filter predicates
References: <20111010133852.829771373@goodmis.org>
Content-Disposition: inline; filename=0004-tracing-filter-Use-static-allocation-for-filter-pred.patch
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="00GvhwF7k39YY"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--00GvhwF7k39YY
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

From: Jiri Olsa <jolsa@redhat.com>

Don't dynamically allocate filter_pred struct, use static memory.
This way we can get rid of the code managing the dynamic filter_pred
struct object.

The create_pred function integrates create_logical_pred function.
This way the static predicate memory is returned only from
one place.

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Link: http://lkml.kernel.org/r/1313072754-4620-2-git-send-email-jolsa@redha=
t.com
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/trace_events_filter.c |   57 ++++++++++----------------------=
----
 1 files changed, 16 insertions(+), 41 deletions(-)

diff --git a/kernel/trace/trace_events_filter.c b/kernel/trace/trace_events=
_filter.c
index 256764e..cb295a1 100644
--- a/kernel/trace/trace_events_filter.c
+++ b/kernel/trace/trace_events_filter.c
@@ -630,11 +630,7 @@ find_event_field(struct ftrace_event_call *call, char =
*name)
=20
 static void filter_free_pred(struct filter_pred *pred)
 {
-	if (!pred)
-		return;
-
 	kfree(pred->field_name);
-	kfree(pred);
 }
=20
 static void filter_clear_pred(struct filter_pred *pred)
@@ -1302,39 +1298,30 @@ parse_operand:
 	return 0;
 }
=20
-static struct filter_pred *create_pred(int op, char *operand1, char *opera=
nd2)
+static struct filter_pred *create_pred(struct filter_parse_state *ps,
+				       int op, char *operand1, char *operand2)
 {
-	struct filter_pred *pred;
+	static struct filter_pred pred;
=20
-	pred =3D kzalloc(sizeof(*pred), GFP_KERNEL);
-	if (!pred)
-		return NULL;
+	memset(&pred, 0, sizeof(pred));
+	pred.op =3D op;
=20
-	pred->field_name =3D kstrdup(operand1, GFP_KERNEL);
-	if (!pred->field_name) {
-		kfree(pred);
+	if (op =3D=3D OP_AND || op =3D=3D OP_OR)
+		return &pred;
+
+	if (!operand1 || !operand2) {
+		parse_error(ps, FILT_ERR_MISSING_FIELD, 0);
 		return NULL;
 	}
=20
-	strcpy(pred->regex.pattern, operand2);
-	pred->regex.len =3D strlen(pred->regex.pattern);
-
-	pred->op =3D op;
-
-	return pred;
-}
-
-static struct filter_pred *create_logical_pred(int op)
-{
-	struct filter_pred *pred;
-
-	pred =3D kzalloc(sizeof(*pred), GFP_KERNEL);
-	if (!pred)
+	pred.field_name =3D kstrdup(operand1, GFP_KERNEL);
+	if (!pred.field_name)
 		return NULL;
=20
-	pred->op =3D op;
+	strcpy(pred.regex.pattern, operand2);
+	pred.regex.len =3D strlen(pred.regex.pattern);
=20
-	return pred;
+	return &pred;
 }
=20
 static int check_preds(struct filter_parse_state *ps)
@@ -1643,19 +1630,7 @@ static int replace_preds(struct ftrace_event_call *c=
all,
 			goto fail;
 		}
=20
-		if (elt->op =3D=3D OP_AND || elt->op =3D=3D OP_OR) {
-			pred =3D create_logical_pred(elt->op);
-			goto add_pred;
-		}
-
-		if (!operand1 || !operand2) {
-			parse_error(ps, FILT_ERR_MISSING_FIELD, 0);
-			err =3D -EINVAL;
-			goto fail;
-		}
-
-		pred =3D create_pred(elt->op, operand1, operand2);
-add_pred:
+		pred =3D create_pred(ps, elt->op, operand1, operand2);
 		if (!pred) {
 			err =3D -ENOMEM;
 			goto fail;
--=20
1.7.6.3



--00GvhwF7k39YY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAABAgAGBQJOkvYTAAoJEIy3vGnGbaoAtGYP/iThV2w2HPD/5bh93mnF+Nwl
ah8wcCmTD3eWFxDcIjl3cJQ7b51P5apmbW3Y76xZXSnqfTWOx0FcihNMfzdfHkta
IylMDgfPIyFf2F1iSqyvQNz6uC+3JtUZGuKVZn+wETBHZfJW0vu2bVfgETmj2PFc
1/313532HWpfZE1HDA3MZiYAZvA9ZllSSOZkHcUks0XHEO4pYIrZqIQzhbhdp56t
vJI9KcrDTqvWQd2rFn5jZE3YV61j43903pXO2t55hc9uKYVezZEks6RV1VV7zYWr
ZNB0MvL7mXaV/qH4xbHzkekIzCIb02vhfhLxulVJmpc3zxWZwT5b5ZdHyN5mUZWy
YgW6ET/c1r4aQeeWJjosuT86IQs33g8S+gZmcbk6zhBd2/2Hp+UG6MNX9svlpyiz
E0M4SBa8Bqys8AgTfGMPbD1lKijwCDbfHwrzYluazBD7oBObxS3miGoy7mXrHOVr
ssqX39UT1kOhxmQBRT2GLtY3WS8NvjZ5re/wJCOaBqn18RRRQ/cq/OwUaaFPukTi
AjQNdQ+XUpDoDrX72Aa/W/X3A4BsbOz6KgvbvGUN68AMjX0SzFmbe7HwDLNlFvxa
UzUAWWWFVamAEUqHYSreI6TZXKKz4AFAGQfTNh75qfsdZs4WSulxDov3hMkLzOFH
+uUn+zk+Z/0GWwaXHaFP
=JIu4
-----END PGP SIGNATURE-----

--00GvhwF7k39YY--
