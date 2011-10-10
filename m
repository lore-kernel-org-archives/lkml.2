Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754233Ab1JJNlp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Oct 2011 09:41:45 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:57520 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753031Ab1JJNll (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Oct 2011 09:41:41 -0400
X-Authority-Analysis: v=1.1 cv=cSzO76bR5tCkfUT9bEmBgR3d7VUusRLeq08eKGxa4EU= c=1 sm=0 a=vhdKIqpQuCYA:10 a=onOEZohBQisA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=20KFwNOVAAAA:8 a=VwQbUJbxAAAA:8 a=meVymXHHAAAA:8 a=Ky0D2PmeofUsbvsnH_4A:9 a=jMk1RLzZTtfZIY6f-tAA:7 a=QEXdDO2ut3YA:10 a=DHQQ7jDAcw4A:10 a=jEp0ucaQiEUA:10 a=jeBq3FmKZ4MA:10 a=RxVcRzGCGrCCVzL_GboA:9 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-Id: <20111010134139.749190105@goodmis.org>
User-Agent: quilt/0.48-1
Date: Mon, 10 Oct 2011 09:38:58 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>
Subject: [PATCH 06/20] tracing/filter: Remove field_name from filter_pred struct
References: <20111010133852.829771373@goodmis.org>
Content-Disposition: inline; filename=0006-tracing-filter-Remove-field_name-from-filter_pred-st.patch
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="00GvhwF7k39YY"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--00GvhwF7k39YY
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

From: Jiri Olsa <jolsa@redhat.com>

The field_name was used just for finding event's fields. This way we
don't need to care about field_name allocation/free.

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Link: http://lkml.kernel.org/r/1313072754-4620-4-git-send-email-jolsa@redha=
t.com
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/trace.h               |   11 +-------
 kernel/trace/trace_events_filter.c |   53 ++++++++------------------------=
---
 2 files changed, 13 insertions(+), 51 deletions(-)

diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
index 616846b..2eb3cf6 100644
--- a/kernel/trace/trace.h
+++ b/kernel/trace/trace.h
@@ -761,16 +761,7 @@ struct filter_pred {
 	filter_pred_fn_t 	fn;
 	u64 			val;
 	struct regex		regex;
-	/*
-	 * Leaf nodes use field_name, ops is used by AND and OR
-	 * nodes. The field_name is always freed when freeing a pred.
-	 * We can overload field_name for ops and have it freed
-	 * as well.
-	 */
-	union {
-		char		*field_name;
-		unsigned short	*ops;
-	};
+	unsigned short		*ops;
 	int 			offset;
 	int 			not;
 	int 			op;
diff --git a/kernel/trace/trace_events_filter.c b/kernel/trace/trace_events=
_filter.c
index 61c8dec..97b93f3 100644
--- a/kernel/trace/trace_events_filter.c
+++ b/kernel/trace/trace_events_filter.c
@@ -628,18 +628,6 @@ find_event_field(struct ftrace_event_call *call, char =
*name)
 	return __find_event_field(head, name);
 }
=20
-static void filter_free_pred(struct filter_pred *pred)
-{
-	kfree(pred->field_name);
-}
-
-static void filter_clear_pred(struct filter_pred *pred)
-{
-	kfree(pred->field_name);
-	pred->field_name =3D NULL;
-	pred->regex.len =3D 0;
-}
-
 static int __alloc_pred_stack(struct pred_stack *stack, int n_preds)
 {
 	stack->preds =3D kzalloc(sizeof(*stack->preds)*(n_preds + 1), GFP_KERNEL);
@@ -692,11 +680,6 @@ static int filter_set_pred(struct event_filter *filter,
 	struct filter_pred *right;
=20
 	*dest =3D *src;
-	if (src->field_name) {
-		dest->field_name =3D kstrdup(src->field_name, GFP_KERNEL);
-		if (!dest->field_name)
-			return -ENOMEM;
-	}
 	dest->index =3D idx;
=20
 	if (dest->op =3D=3D OP_OR || dest->op =3D=3D OP_AND) {
@@ -737,11 +720,7 @@ static int filter_set_pred(struct event_filter *filter,
=20
 static void __free_preds(struct event_filter *filter)
 {
-	int i;
-
 	if (filter->preds) {
-		for (i =3D 0; i < filter->a_preds; i++)
-			kfree(filter->preds[i].field_name);
 		kfree(filter->preds);
 		filter->preds =3D NULL;
 	}
@@ -839,16 +818,14 @@ static int filter_add_pred(struct filter_parse_state =
*ps,
 			   struct filter_pred *pred,
 			   struct pred_stack *stack)
 {
-	int idx, err;
+	int err;
=20
 	if (WARN_ON(filter->n_preds =3D=3D filter->a_preds)) {
 		parse_error(ps, FILT_ERR_TOO_MANY_PREDS, 0);
 		return -ENOSPC;
 	}
=20
-	idx =3D filter->n_preds;
-	filter_clear_pred(&filter->preds[idx]);
-	err =3D filter_set_pred(filter, idx, stack, pred);
+	err =3D filter_set_pred(filter, filter->n_preds, stack, pred);
 	if (err)
 		return err;
=20
@@ -930,21 +907,14 @@ static filter_pred_fn_t select_comparison_fn(int op, =
int field_size,
 }
=20
 static int init_pred(struct filter_parse_state *ps,
-		     struct ftrace_event_call *call,
+		     struct ftrace_event_field *field,
 		     struct filter_pred *pred)
=20
 {
-	struct ftrace_event_field *field;
 	filter_pred_fn_t fn =3D filter_pred_none;
 	unsigned long long val;
 	int ret;
=20
-	field =3D find_event_field(call, pred->field_name);
-	if (!field) {
-		parse_error(ps, FILT_ERR_FIELD_NOT_FOUND, 0);
-		return -EINVAL;
-	}
-
 	pred->offset =3D field->offset;
=20
 	if (!is_legal_op(field, pred->op)) {
@@ -1287,6 +1257,7 @@ static struct filter_pred *create_pred(struct filter_=
parse_state *ps,
 				       struct ftrace_event_call *call,
 				       int op, char *operand1, char *operand2)
 {
+	struct ftrace_event_field *field;
 	static struct filter_pred pred;
=20
 	memset(&pred, 0, sizeof(pred));
@@ -1300,14 +1271,16 @@ static struct filter_pred *create_pred(struct filte=
r_parse_state *ps,
 		return NULL;
 	}
=20
-	pred.field_name =3D kstrdup(operand1, GFP_KERNEL);
-	if (!pred.field_name)
+	field =3D find_event_field(call, operand1);
+	if (!field) {
+		parse_error(ps, FILT_ERR_FIELD_NOT_FOUND, 0);
 		return NULL;
+	}
=20
 	strcpy(pred.regex.pattern, operand2);
 	pred.regex.len =3D strlen(pred.regex.pattern);
=20
-	return init_pred(ps, call, &pred) ? NULL : &pred;
+	return init_pred(ps, field, &pred) ? NULL : &pred;
 }
=20
 static int check_preds(struct filter_parse_state *ps)
@@ -1618,18 +1591,16 @@ static int replace_preds(struct ftrace_event_call *=
call,
=20
 		pred =3D create_pred(ps, call, elt->op, operand1, operand2);
 		if (!pred) {
-			err =3D -ENOMEM;
+			err =3D -EINVAL;
 			goto fail;
 		}
+
 		if (!dry_run) {
 			err =3D filter_add_pred(ps, filter, pred, &stack);
-			if (err) {
-				filter_free_pred(pred);
+			if (err)
 				goto fail;
-			}
 		}
=20
-		filter_free_pred(pred);
 		operand1 =3D operand2 =3D NULL;
 	}
=20
--=20
1.7.6.3



--00GvhwF7k39YY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAABAgAGBQJOkvYTAAoJEIy3vGnGbaoAANYQAIlyFyI02E0gcJGgJgsMcB7F
jWaoQ/U7EK11thqHz6e/cFawUHDkHsDYpdKIhDQOSfgs9r7ozsb/KEog/gfZlAlD
kI5qP9joE9oZCgU405eRwLuIMQZ177Mi5CJSnFBnVc14gOY3ySmYuY5tyx+h5kK+
nFSAzo9OU3TQw7Fgc8z/rDByETzkv7G6vb5tZhbaz7d0j7VSks38PLFpeTEnctUh
QHWO4V5NbbKTl+LG6JG8HWehxkpMARAIhAqFxcO2tQyhZ9No+GWhPXCz1wdCLpyT
7pEGnH/eUbU1XRmSuBin/mQmKwseTVKmqLJ2xdRQ//izdOcVVa3OWtO6EAI+VieU
4KWHY47DK/jHkvY5qV4Gds7OA8OPGlC5bORxEMi9e71Qo/RMBPhy+/rdF7FcwUKB
SBBc9HOAjjaSSpDgNF5gDLZgtYDmE10f3ubs8mzYuBjb+aYB+NUdsGxjoRqN9Vbw
YKfa+p9TYFu/erwvMcpbo8X7dfnjFB/LaXhWI5qNo5ux5XFuNsxRLsfkPUB91PkV
KONuNrTeRoF+x9bBruUH7p46EjnElAKxyp0x8rGGR5nX/iuy2zPO2bYmO5i0gIn2
ttBXcIUFhNzAkRl9dxEpBl/tknnsiK08TvGpjs9pvPHgcV/xhggfkpwIxi95tLE4
CjalrkBNMwxS9qIPxSiz
=ah0A
-----END PGP SIGNATURE-----

--00GvhwF7k39YY--
