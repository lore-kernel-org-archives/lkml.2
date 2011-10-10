Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754254Ab1JJNls (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Oct 2011 09:41:48 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:60188 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754216Ab1JJNlp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Oct 2011 09:41:45 -0400
X-Authority-Analysis: v=1.1 cv=lfM0d0QHaVz67dfwwr9cyIw6NbaGR/pZhMD6XWNi0kk= c=1 sm=0 a=vhdKIqpQuCYA:10 a=A6kiQwnZC_gA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=20KFwNOVAAAA:8 a=VwQbUJbxAAAA:8 a=meVymXHHAAAA:8 a=jOOXinVO_LwNU6Y9pboA:9 a=0koemw8sjFzc9QQDx-8A:7 a=QEXdDO2ut3YA:10 a=DHQQ7jDAcw4A:10 a=jEp0ucaQiEUA:10 a=jeBq3FmKZ4MA:10 a=bFQ0jpE-kuiVGYruPXgA:9 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-Id: <20111010134143.379954523@goodmis.org>
User-Agent: quilt/0.48-1
Date: Mon, 10 Oct 2011 09:39:05 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>
Subject: [PATCH 13/20] tracing/filter: Add startup tests for events filter
References: <20111010133852.829771373@goodmis.org>
Content-Disposition: inline; filename=0013-tracing-filter-Add-startup-tests-for-events-filter.patch
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="00GvhwF7k39YY"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--00GvhwF7k39YY
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

From: Jiri Olsa <jolsa@redhat.com>

Adding automated tests running as late_initcall. Tests are
compiled in with CONFIG_FTRACE_STARTUP_TEST option.

Adding test event "ftrace_test_filter" used to simulate
filter processing during event occurance.

String filters are compiled and tested against several
test events with different values.

Also testing that evaluation of explicit predicates is ommited
due to the lazy filter evaluation.

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Link: http://lkml.kernel.org/r/1313072754-4620-11-git-send-email-jolsa@redh=
at.com
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/Makefile                   |    2 +
 kernel/trace/trace.h                    |    3 +
 kernel/trace/trace_events_filter.c      |  209 +++++++++++++++++++++++++++=
++++
 kernel/trace/trace_events_filter_test.h |   50 ++++++++
 4 files changed, 264 insertions(+), 0 deletions(-)
 create mode 100644 kernel/trace/trace_events_filter_test.h

diff --git a/kernel/trace/Makefile b/kernel/trace/Makefile
index 761c510..b384ed5 100644
--- a/kernel/trace/Makefile
+++ b/kernel/trace/Makefile
@@ -15,6 +15,8 @@ ifdef CONFIG_TRACING_BRANCHES
 KBUILD_CFLAGS +=3D -DDISABLE_BRANCH_PROFILING
 endif
=20
+CFLAGS_trace_events_filter.o :=3D -I$(src)
+
 #
 # Make the trace clocks available generally: it's infrastructure
 # relied on by ptrace for example:
diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
index 2eb3cf6..4c7540a 100644
--- a/kernel/trace/trace.h
+++ b/kernel/trace/trace.h
@@ -762,6 +762,9 @@ struct filter_pred {
 	u64 			val;
 	struct regex		regex;
 	unsigned short		*ops;
+#ifdef CONFIG_FTRACE_STARTUP_TEST
+	struct ftrace_event_field *field;
+#endif
 	int 			offset;
 	int 			not;
 	int 			op;
diff --git a/kernel/trace/trace_events_filter.c b/kernel/trace/trace_events=
_filter.c
index 319c3ca..6a642e2 100644
--- a/kernel/trace/trace_events_filter.c
+++ b/kernel/trace/trace_events_filter.c
@@ -1329,6 +1329,9 @@ static struct filter_pred *create_pred(struct filter_=
parse_state *ps,
 	strcpy(pred.regex.pattern, operand2);
 	pred.regex.len =3D strlen(pred.regex.pattern);
=20
+#ifdef CONFIG_FTRACE_STARTUP_TEST
+	pred.field =3D field;
+#endif
 	return init_pred(ps, field, &pred) ? NULL : &pred;
 }
=20
@@ -1926,3 +1929,209 @@ out_unlock:
=20
 #endif /* CONFIG_PERF_EVENTS */
=20
+#ifdef CONFIG_FTRACE_STARTUP_TEST
+
+#include <linux/types.h>
+#include <linux/tracepoint.h>
+
+#define CREATE_TRACE_POINTS
+#include "trace_events_filter_test.h"
+
+static int test_get_filter(char *filter_str, struct ftrace_event_call *cal=
l,
+			   struct event_filter **pfilter)
+{
+	struct event_filter *filter;
+	struct filter_parse_state *ps;
+	int err =3D -ENOMEM;
+
+	filter =3D __alloc_filter();
+	if (!filter)
+		goto out;
+
+	ps =3D kzalloc(sizeof(*ps), GFP_KERNEL);
+	if (!ps)
+		goto free_filter;
+
+	parse_init(ps, filter_ops, filter_str);
+	err =3D filter_parse(ps);
+	if (err)
+		goto free_ps;
+
+	err =3D replace_preds(call, filter, ps, filter_str, false);
+	if (!err)
+		*pfilter =3D filter;
+
+ free_ps:
+	filter_opstack_clear(ps);
+	postfix_clear(ps);
+	kfree(ps);
+
+ free_filter:
+	if (err)
+		__free_filter(filter);
+
+ out:
+	return err;
+}
+
+#define DATA_REC(m, va, vb, vc, vd, ve, vf, vg, vh, nvisit) \
+{ \
+	.filter =3D FILTER, \
+	.rec    =3D { .a =3D va, .b =3D vb, .c =3D vc, .d =3D vd, \
+		    .e =3D ve, .f =3D vf, .g =3D vg, .h =3D vh }, \
+	.match  =3D m, \
+	.not_visited =3D nvisit, \
+}
+#define YES 1
+#define NO  0
+
+static struct test_filter_data_t {
+	char *filter;
+	struct ftrace_raw_ftrace_test_filter rec;
+	int match;
+	char *not_visited;
+} test_filter_data[] =3D {
+#define FILTER "a =3D=3D 1 && b =3D=3D 1 && c =3D=3D 1 && d =3D=3D 1 && " \
+	       "e =3D=3D 1 && f =3D=3D 1 && g =3D=3D 1 && h =3D=3D 1"
+	DATA_REC(YES, 1, 1, 1, 1, 1, 1, 1, 1, ""),
+	DATA_REC(NO,  0, 1, 1, 1, 1, 1, 1, 1, "bcdefgh"),
+	DATA_REC(NO,  1, 1, 1, 1, 1, 1, 1, 0, ""),
+#undef FILTER
+#define FILTER "a =3D=3D 1 || b =3D=3D 1 || c =3D=3D 1 || d =3D=3D 1 || " \
+	       "e =3D=3D 1 || f =3D=3D 1 || g =3D=3D 1 || h =3D=3D 1"
+	DATA_REC(NO,  0, 0, 0, 0, 0, 0, 0, 0, ""),
+	DATA_REC(YES, 0, 0, 0, 0, 0, 0, 0, 1, ""),
+	DATA_REC(YES, 1, 0, 0, 0, 0, 0, 0, 0, "bcdefgh"),
+#undef FILTER
+#define FILTER "(a =3D=3D 1 || b =3D=3D 1) && (c =3D=3D 1 || d =3D=3D 1) &=
& " \
+	       "(e =3D=3D 1 || f =3D=3D 1) && (g =3D=3D 1 || h =3D=3D 1)"
+	DATA_REC(NO,  0, 0, 1, 1, 1, 1, 1, 1, "dfh"),
+	DATA_REC(YES, 0, 1, 0, 1, 0, 1, 0, 1, ""),
+	DATA_REC(YES, 1, 0, 1, 0, 0, 1, 0, 1, "bd"),
+	DATA_REC(NO,  1, 0, 1, 0, 0, 1, 0, 0, "bd"),
+#undef FILTER
+#define FILTER "(a =3D=3D 1 && b =3D=3D 1) || (c =3D=3D 1 && d =3D=3D 1) |=
| " \
+	       "(e =3D=3D 1 && f =3D=3D 1) || (g =3D=3D 1 && h =3D=3D 1)"
+	DATA_REC(YES, 1, 0, 1, 1, 1, 1, 1, 1, "efgh"),
+	DATA_REC(YES, 0, 0, 0, 0, 0, 0, 1, 1, ""),
+	DATA_REC(NO,  0, 0, 0, 0, 0, 0, 0, 1, ""),
+#undef FILTER
+#define FILTER "(a =3D=3D 1 && b =3D=3D 1) && (c =3D=3D 1 && d =3D=3D 1) &=
& " \
+	       "(e =3D=3D 1 && f =3D=3D 1) || (g =3D=3D 1 && h =3D=3D 1)"
+	DATA_REC(YES, 1, 1, 1, 1, 1, 1, 0, 0, "gh"),
+	DATA_REC(NO,  0, 0, 0, 0, 0, 0, 0, 1, ""),
+	DATA_REC(YES, 1, 1, 1, 1, 1, 0, 1, 1, ""),
+#undef FILTER
+#define FILTER "((a =3D=3D 1 || b =3D=3D 1) || (c =3D=3D 1 || d =3D=3D 1) =
|| " \
+	       "(e =3D=3D 1 || f =3D=3D 1)) && (g =3D=3D 1 || h =3D=3D 1)"
+	DATA_REC(YES, 1, 1, 1, 1, 1, 1, 0, 1, "bcdef"),
+	DATA_REC(NO,  0, 0, 0, 0, 0, 0, 0, 0, ""),
+	DATA_REC(YES, 1, 1, 1, 1, 1, 0, 1, 1, "h"),
+#undef FILTER
+#define FILTER "((((((((a =3D=3D 1) && (b =3D=3D 1)) || (c =3D=3D 1)) && (=
d =3D=3D 1)) || " \
+	       "(e =3D=3D 1)) && (f =3D=3D 1)) || (g =3D=3D 1)) && (h =3D=3D 1))"
+	DATA_REC(YES, 1, 1, 1, 1, 1, 1, 1, 1, "ceg"),
+	DATA_REC(NO,  0, 1, 0, 1, 0, 1, 0, 1, ""),
+	DATA_REC(NO,  1, 0, 1, 0, 1, 0, 1, 0, ""),
+#undef FILTER
+#define FILTER "((((((((a =3D=3D 1) || (b =3D=3D 1)) && (c =3D=3D 1)) || (=
d =3D=3D 1)) && " \
+	       "(e =3D=3D 1)) || (f =3D=3D 1)) && (g =3D=3D 1)) || (h =3D=3D 1))"
+	DATA_REC(YES, 1, 1, 1, 1, 1, 1, 1, 1, "bdfh"),
+	DATA_REC(YES, 0, 1, 0, 1, 0, 1, 0, 1, ""),
+	DATA_REC(YES, 1, 0, 1, 0, 1, 0, 1, 0, "bdfh"),
+};
+
+#undef DATA_REC
+#undef FILTER
+#undef YES
+#undef NO
+
+#define DATA_CNT (sizeof(test_filter_data)/sizeof(struct test_filter_data_=
t))
+
+static int test_pred_visited;
+
+static int test_pred_visited_fn(struct filter_pred *pred, void *event)
+{
+	struct ftrace_event_field *field =3D pred->field;
+
+	test_pred_visited =3D 1;
+	printk(KERN_INFO "\npred visited %s\n", field->name);
+	return 1;
+}
+
+static int test_walk_pred_cb(enum move_type move, struct filter_pred *pred,
+			     int *err, void *data)
+{
+	char *fields =3D data;
+
+	if ((move =3D=3D MOVE_DOWN) &&
+	    (pred->left =3D=3D FILTER_PRED_INVALID)) {
+		struct ftrace_event_field *field =3D pred->field;
+
+		if (!field) {
+			WARN(1, "all leafs should have field defined");
+			return WALK_PRED_DEFAULT;
+		}
+		if (!strchr(fields, *field->name))
+			return WALK_PRED_DEFAULT;
+
+		WARN_ON(!pred->fn);
+		pred->fn =3D test_pred_visited_fn;
+	}
+	return WALK_PRED_DEFAULT;
+}
+
+static __init int ftrace_test_event_filter(void)
+{
+	int i;
+
+	printk(KERN_INFO "Testing ftrace filter: ");
+
+	for (i =3D 0; i < DATA_CNT; i++) {
+		struct event_filter *filter =3D NULL;
+		struct test_filter_data_t *d =3D &test_filter_data[i];
+		int err;
+
+		err =3D test_get_filter(d->filter, &event_ftrace_test_filter,
+				      &filter);
+		if (err) {
+			printk(KERN_INFO
+			       "Failed to get filter for '%s', err %d\n",
+			       d->filter, err);
+			break;
+		}
+
+		if (*d->not_visited)
+			walk_pred_tree(filter->preds, filter->root,
+				       test_walk_pred_cb,
+				       d->not_visited);
+
+		test_pred_visited =3D 0;
+		err =3D filter_match_preds(filter, &d->rec);
+
+		__free_filter(filter);
+
+		if (test_pred_visited) {
+			printk(KERN_INFO
+			       "Failed, unwanted pred visited for filter %s\n",
+			       d->filter);
+			break;
+		}
+
+		if (err !=3D d->match) {
+			printk(KERN_INFO
+			       "Failed to match filter '%s', expected %d\n",
+			       d->filter, d->match);
+			break;
+		}
+	}
+
+	if (i =3D=3D DATA_CNT)
+		printk(KERN_CONT "OK\n");
+
+	return 0;
+}
+
+late_initcall(ftrace_test_event_filter);
+
+#endif /* CONFIG_FTRACE_STARTUP_TEST */
diff --git a/kernel/trace/trace_events_filter_test.h b/kernel/trace/trace_e=
vents_filter_test.h
new file mode 100644
index 0000000..bfd4dba
--- /dev/null
+++ b/kernel/trace/trace_events_filter_test.h
@@ -0,0 +1,50 @@
+#undef TRACE_SYSTEM
+#define TRACE_SYSTEM test
+
+#if !defined(_TRACE_TEST_H) || defined(TRACE_HEADER_MULTI_READ)
+#define _TRACE_TEST_H
+
+#include <linux/tracepoint.h>
+
+TRACE_EVENT(ftrace_test_filter,
+
+	TP_PROTO(int a, int b, int c, int d, int e, int f, int g, int h),
+
+	TP_ARGS(a, b, c, d, e, f, g, h),
+
+	TP_STRUCT__entry(
+		__field(int, a)
+		__field(int, b)
+		__field(int, c)
+		__field(int, d)
+		__field(int, e)
+		__field(int, f)
+		__field(int, g)
+		__field(int, h)
+	),
+
+	TP_fast_assign(
+		__entry->a =3D a;
+		__entry->b =3D b;
+		__entry->c =3D c;
+		__entry->d =3D d;
+		__entry->e =3D e;
+		__entry->f =3D f;
+		__entry->g =3D g;
+		__entry->h =3D h;
+	),
+
+	TP_printk("a %d, b %d, c %d, d %d, e %d, f %d, g %d, h %d",
+		  __entry->a, __entry->b, __entry->c, __entry->d,
+		  __entry->e, __entry->f, __entry->g, __entry->h)
+);
+
+#endif /* _TRACE_TEST_H || TRACE_HEADER_MULTI_READ */
+
+#undef TRACE_INCLUDE_PATH
+#undef TRACE_INCLUDE_FILE
+#define TRACE_INCLUDE_PATH .
+#define TRACE_INCLUDE_FILE trace_events_filter_test
+
+/* This part must be outside protection */
+#include <trace/define_trace.h>
--=20
1.7.6.3



--00GvhwF7k39YY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAABAgAGBQJOkvYXAAoJEIy3vGnGbaoAv9YQAK2R0UROoOgFCv9tgd0AnUqj
QBn47ujYzXasAPTJeKRAMWLXgJHXpl71DbadV0FjDqvBOZNGCjFiEgMI5Sb7mXIS
t0QJBNxTU4rdkzfcatA1L0XagkbgGt9ohwTKWd5GWUDsC9K3SQqTeNGPYHvzfTca
pBs5/joWnrrDa8wODk5WrwIEitfOtDzBsz57u01zAtqpGzxCoo0hjNzQeekR++t+
Ja+Ff7TYd93+kSoMTwzvJr5KrBNfyy01K6oqXoG66dXU6W7lasf3PQrpXZGzNVVS
0hAOWb9HN7e9+wLft8kWE+zNGp8NLlbmFipyvxjXMRXNj3qk4K4U2960YbT0wS8R
xeY8i/eL+XbuNHTcZfwEpu81fFO91+dB6uldKZpfwMsuhwa4MoCJrKdprWD2x0uN
vh02YqgbLz9ZgugJC+N7OUQy4MDucsVV/rrBUqNwBjq+j738Upsy58IA4ism/Jj6
0pYDpUWEXEU/Gjm8uN545xVtcJhjTcRKkYLQUUPhS/dkEmpzBUoA+7b1SzOD2fL8
NdXzbmyF+CPosns6V0/mr7p6TIbIeNsPwEbxYuIo0FSyXr2jp7jWSt3j49aAX/IU
NqUQO5V4C12klzLcINpnIH5IhVmKvCOol39/944SKZaYhgeLOx5PX0ZTJAxJPl1/
YrfAjV4I9Ura21lazPmv
=Yjbt
-----END PGP SIGNATURE-----

--00GvhwF7k39YY--
