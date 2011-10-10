Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754195Ab1JJNlm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Oct 2011 09:41:42 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:49686 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754162Ab1JJNlk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Oct 2011 09:41:40 -0400
X-Authority-Analysis: v=1.1 cv=XWD5/VRj2HUJOhsR8cgmvPBlhMACpZXxseY1Kn/ehQI= c=1 sm=0 a=vhdKIqpQuCYA:10 a=8h-0zzHSgXIA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=20KFwNOVAAAA:8 a=VwQbUJbxAAAA:8 a=meVymXHHAAAA:8 a=ZYjOwynZGyMNu8acl1YA:9 a=93tqP-X5tj3QWzmjtksA:7 a=QEXdDO2ut3YA:10 a=DHQQ7jDAcw4A:10 a=jEp0ucaQiEUA:10 a=jeBq3FmKZ4MA:10 a=vUGL45InOBrkHyrh86wA:9 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-Id: <20111010134139.304780747@goodmis.org>
User-Agent: quilt/0.48-1
Date: Mon, 10 Oct 2011 09:38:57 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>
Subject: [PATCH 05/20] tracing/filter: Separate predicate init and filter addition
References: <20111010133852.829771373@goodmis.org>
Content-Disposition: inline; filename=0005-tracing-filter-Separate-predicate-init-and-filter-ad.patch
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="00GvhwF7k39YY"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--00GvhwF7k39YY
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

From: Jiri Olsa <jolsa@redhat.com>

Making the code cleaner by having one function to fully prepare
the predicate (create_pred), and another to add the predicate to
the filter (filter_add_pred).

As a benefit, this way the dry_run flag stays only inside the
replace_preds function and is not passed deeper.

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Link: http://lkml.kernel.org/r/1313072754-4620-3-git-send-email-jolsa@redha=
t.com
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/trace_events_filter.c |   56 +++++++++++++++-----------------=
----
 1 files changed, 23 insertions(+), 33 deletions(-)

diff --git a/kernel/trace/trace_events_filter.c b/kernel/trace/trace_events=
_filter.c
index cb295a1..61c8dec 100644
--- a/kernel/trace/trace_events_filter.c
+++ b/kernel/trace/trace_events_filter.c
@@ -685,8 +685,7 @@ __pop_pred_stack(struct pred_stack *stack)
 static int filter_set_pred(struct event_filter *filter,
 			   int idx,
 			   struct pred_stack *stack,
-			   struct filter_pred *src,
-			   filter_pred_fn_t fn)
+			   struct filter_pred *src)
 {
 	struct filter_pred *dest =3D &filter->preds[idx];
 	struct filter_pred *left;
@@ -698,7 +697,6 @@ static int filter_set_pred(struct event_filter *filter,
 		if (!dest->field_name)
 			return -ENOMEM;
 	}
-	dest->fn =3D fn;
 	dest->index =3D idx;
=20
 	if (dest->op =3D=3D OP_OR || dest->op =3D=3D OP_AND) {
@@ -836,12 +834,10 @@ static void filter_free_subsystem_filters(struct even=
t_subsystem *system)
 	}
 }
=20
-static int filter_add_pred_fn(struct filter_parse_state *ps,
-			      struct ftrace_event_call *call,
-			      struct event_filter *filter,
-			      struct filter_pred *pred,
-			      struct pred_stack *stack,
-			      filter_pred_fn_t fn)
+static int filter_add_pred(struct filter_parse_state *ps,
+			   struct event_filter *filter,
+			   struct filter_pred *pred,
+			   struct pred_stack *stack)
 {
 	int idx, err;
=20
@@ -852,7 +848,7 @@ static int filter_add_pred_fn(struct filter_parse_state=
 *ps,
=20
 	idx =3D filter->n_preds;
 	filter_clear_pred(&filter->preds[idx]);
-	err =3D filter_set_pred(filter, idx, stack, pred, fn);
+	err =3D filter_set_pred(filter, idx, stack, pred);
 	if (err)
 		return err;
=20
@@ -933,25 +929,16 @@ static filter_pred_fn_t select_comparison_fn(int op, =
int field_size,
 	return fn;
 }
=20
-static int filter_add_pred(struct filter_parse_state *ps,
-			   struct ftrace_event_call *call,
-			   struct event_filter *filter,
-			   struct filter_pred *pred,
-			   struct pred_stack *stack,
-			   bool dry_run)
+static int init_pred(struct filter_parse_state *ps,
+		     struct ftrace_event_call *call,
+		     struct filter_pred *pred)
+
 {
 	struct ftrace_event_field *field;
-	filter_pred_fn_t fn;
+	filter_pred_fn_t fn =3D filter_pred_none;
 	unsigned long long val;
 	int ret;
=20
-	fn =3D pred->fn =3D filter_pred_none;
-
-	if (pred->op =3D=3D OP_AND)
-		goto add_pred_fn;
-	else if (pred->op =3D=3D OP_OR)
-		goto add_pred_fn;
-
 	field =3D find_event_field(call, pred->field_name);
 	if (!field) {
 		parse_error(ps, FILT_ERR_FIELD_NOT_FOUND, 0);
@@ -997,9 +984,7 @@ static int filter_add_pred(struct filter_parse_state *p=
s,
 	if (pred->op =3D=3D OP_NE)
 		pred->not =3D 1;
=20
-add_pred_fn:
-	if (!dry_run)
-		return filter_add_pred_fn(ps, call, filter, pred, stack, fn);
+	pred->fn =3D fn;
 	return 0;
 }
=20
@@ -1299,6 +1284,7 @@ parse_operand:
 }
=20
 static struct filter_pred *create_pred(struct filter_parse_state *ps,
+				       struct ftrace_event_call *call,
 				       int op, char *operand1, char *operand2)
 {
 	static struct filter_pred pred;
@@ -1321,7 +1307,7 @@ static struct filter_pred *create_pred(struct filter_=
parse_state *ps,
 	strcpy(pred.regex.pattern, operand2);
 	pred.regex.len =3D strlen(pred.regex.pattern);
=20
-	return &pred;
+	return init_pred(ps, call, &pred) ? NULL : &pred;
 }
=20
 static int check_preds(struct filter_parse_state *ps)
@@ -1630,16 +1616,20 @@ static int replace_preds(struct ftrace_event_call *=
call,
 			goto fail;
 		}
=20
-		pred =3D create_pred(ps, elt->op, operand1, operand2);
+		pred =3D create_pred(ps, call, elt->op, operand1, operand2);
 		if (!pred) {
 			err =3D -ENOMEM;
 			goto fail;
 		}
-		err =3D filter_add_pred(ps, call, filter, pred, &stack, dry_run);
-		filter_free_pred(pred);
-		if (err)
-			goto fail;
+		if (!dry_run) {
+			err =3D filter_add_pred(ps, filter, pred, &stack);
+			if (err) {
+				filter_free_pred(pred);
+				goto fail;
+			}
+		}
=20
+		filter_free_pred(pred);
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

iQIcBAABAgAGBQJOkvYTAAoJEIy3vGnGbaoABp8QAJlxvDSAcbsWqJw0L+B4tLwe
I/OtUca1yoQbT2i0V5PJ7jEGFXPsEYwOAYUmUYUeMuIc7zmI1ZhMXA+KJNQDrNYW
px9kHkgjnKAes94yUoXPGdFTqq+zu655Bi1IQbI4TcgKtXb7zRB4AVX/HyANDhRt
MXAegUm1kbT+yucflYt2K4sHmYGeqGGMUxeV1jcqVbVN4R/jTSwaq6WIlU+4poFb
YslBDUSuDpwSpeCMyj2sggOnEaDXL7kRu3BuWOFWXns4NfWD2QA/tCtatLGdeP6Y
eMYOwtVYhRkX80jmvnd3wiJvIgNNOpqaY3eub58Nai2LiglwIqVL9FhZXYoi6f82
GvPLYbE/nQEIcuKLX57NWO8HcWF+C9ow2oNMj3Sd3TSGYur1tZt7aV+M2dXNjsdH
S4LDfnt0iHsNnuW5wXtvWpd5GkFQOC0GJtJCELTR/oB/7epi/OhhScdimbOxF+sA
mVJSot6Rvl6ZJw7X3FmqC+JyCTiEJxd7N+CynU2NeiGch/19txFBdHmyziv1C6Z7
MxqQb+ILnj7qu58xRQDvr1sgyKvlaDQ8nsfUhPoRbQBWoDL16saFZAbfTDNSP635
TMCrxVpuZJTO8ga67+gZ/6/ZlMNEsCh+fnYjFY2yC8wwLTzmJieiVbaZsU4l5duF
nh0nWrCpMJOZenj9/EOy
=L8s3
-----END PGP SIGNATURE-----

--00GvhwF7k39YY--
