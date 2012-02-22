Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753243Ab2BVOnP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Feb 2012 09:43:15 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:21149 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752894Ab2BVOmP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Feb 2012 09:42:15 -0500
X-Authority-Analysis: v=2.0 cv=M9vP2lMs c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=UBy9sU4F98IA:10 a=tneeT07oBvEA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=20KFwNOVAAAA:8 a=VwQbUJbxAAAA:8 a=meVymXHHAAAA:8 a=gcz1SOduef3g2IXHqjQA:9 a=l36-n2SHbqBaXGvfOgEA:7 a=QEXdDO2ut3YA:10 a=YTw0oxLd7MoA:10 a=jEp0ucaQiEUA:10 a=jeBq3FmKZ4MA:10 a=57anIX6a6QJWPe-tR6MA:9 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-Id: <20120222144211.815180136@goodmis.org>
User-Agent: quilt/0.50-1
Date: Wed, 22 Feb 2012 09:40:45 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Jiri Olsa <jolsa@redhat.com>
Subject: [PATCH 9/9] ftrace, perf: Add filter support for function trace event
References: <20120222144036.824378742@goodmis.org>
Content-Disposition: inline; filename=0009-ftrace-perf-Add-filter-support-for-function-trace-ev.patch
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="00GvhwF7k39YY"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--00GvhwF7k39YY
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

From: Jiri Olsa <jolsa@redhat.com>

Adding support to filter function trace event via perf
interface. It is now possible to use filter interface
in the perf tool like:

  perf record -e ftrace:function --filter=3D"(ip =3D=3D mm_*)" ls

The filter syntax is restricted to the the 'ip' field only,
and following operators are accepted '=3D=3D' '!=3D' '||', ending
up with the filter strings like:

  ip =3D=3D f1[, ]f2 ... || ip !=3D f3[, ]f4 ...

with comma ',' or space ' ' as a function separator. If the
space ' ' is used as a separator, the right side of the
assignment needs to be enclosed in double quotes '"', e.g.:

  perf record -e ftrace:function --filter '(ip =3D=3D do_execve,sys_*,ext*)=
' ls
  perf record -e ftrace:function --filter '(ip =3D=3D "do_execve,sys_*,ext*=
")' ls
  perf record -e ftrace:function --filter '(ip =3D=3D "do_execve sys_* ext*=
")' ls

The '=3D=3D' operator adds trace filter with same effect as would
be added via set_ftrace_filter file.

The '!=3D' operator adds trace filter with same effect as would
be added via set_ftrace_notrace file.

The right side of the '!=3D', '=3D=3D' operators is list of functions
or regexp. to be added to filter separated by space.

The '||' operator is used for connecting multiple filter definitions
together. It is possible to have more than one '=3D=3D' and '!=3D'
operators within one filter string.

Link: http://lkml.kernel.org/r/1329317514-8131-8-git-send-email-jolsa@redha=
t.com

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 include/linux/ftrace.h             |    7 +-
 kernel/trace/ftrace.c              |    6 ++
 kernel/trace/trace.h               |    2 -
 kernel/trace/trace_event_perf.c    |    4 +-
 kernel/trace/trace_events_filter.c |  165 ++++++++++++++++++++++++++++++++=
++--
 5 files changed, 172 insertions(+), 12 deletions(-)

diff --git a/include/linux/ftrace.h b/include/linux/ftrace.h
index 64a309d..72a6cab 100644
--- a/include/linux/ftrace.h
+++ b/include/linux/ftrace.h
@@ -250,6 +250,7 @@ int ftrace_set_notrace(struct ftrace_ops *ops, unsigned=
 char *buf,
 			int len, int reset);
 void ftrace_set_global_filter(unsigned char *buf, int len, int reset);
 void ftrace_set_global_notrace(unsigned char *buf, int len, int reset);
+void ftrace_free_filter(struct ftrace_ops *ops);
=20
 int register_ftrace_command(struct ftrace_func_command *cmd);
 int unregister_ftrace_command(struct ftrace_func_command *cmd);
@@ -380,9 +381,6 @@ extern void ftrace_enable_daemon(void);
 #else
 static inline int skip_trace(unsigned long ip) { return 0; }
 static inline int ftrace_force_update(void) { return 0; }
-static inline void ftrace_set_filter(unsigned char *buf, int len, int rese=
t)
-{
-}
 static inline void ftrace_disable_daemon(void) { }
 static inline void ftrace_enable_daemon(void) { }
 static inline void ftrace_release_mod(struct module *mod) {}
@@ -406,6 +404,9 @@ static inline int ftrace_text_reserved(void *start, voi=
d *end)
  */
 #define ftrace_regex_open(ops, flag, inod, file) ({ -ENODEV; })
 #define ftrace_set_early_filter(ops, buf, enable) do { } while (0)
+#define ftrace_set_filter(ops, buf, len, reset) ({ -ENODEV; })
+#define ftrace_set_notrace(ops, buf, len, reset) ({ -ENODEV; })
+#define ftrace_free_filter(ops) do { } while (0)
=20
 static inline ssize_t ftrace_filter_write(struct file *file, const char __=
user *ubuf,
 			    size_t cnt, loff_t *ppos) { return -ENODEV; }
diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index f615f97..867bd1d 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -1186,6 +1186,12 @@ static void free_ftrace_hash_rcu(struct ftrace_hash =
*hash)
 	call_rcu_sched(&hash->rcu, __free_ftrace_hash_rcu);
 }
=20
+void ftrace_free_filter(struct ftrace_ops *ops)
+{
+	free_ftrace_hash(ops->filter_hash);
+	free_ftrace_hash(ops->notrace_hash);
+}
+
 static struct ftrace_hash *alloc_ftrace_hash(int size_bits)
 {
 	struct ftrace_hash *hash;
diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
index 29f93cd..54faec7 100644
--- a/kernel/trace/trace.h
+++ b/kernel/trace/trace.h
@@ -776,9 +776,7 @@ struct filter_pred {
 	u64 			val;
 	struct regex		regex;
 	unsigned short		*ops;
-#ifdef CONFIG_FTRACE_STARTUP_TEST
 	struct ftrace_event_field *field;
-#endif
 	int 			offset;
 	int 			not;
 	int 			op;
diff --git a/kernel/trace/trace_event_perf.c b/kernel/trace/trace_event_per=
f.c
index fdeeb5c..fee3752 100644
--- a/kernel/trace/trace_event_perf.c
+++ b/kernel/trace/trace_event_perf.c
@@ -298,7 +298,9 @@ static int perf_ftrace_function_register(struct perf_ev=
ent *event)
 static int perf_ftrace_function_unregister(struct perf_event *event)
 {
 	struct ftrace_ops *ops =3D &event->ftrace_ops;
-	return unregister_ftrace_function(ops);
+	int ret =3D unregister_ftrace_function(ops);
+	ftrace_free_filter(ops);
+	return ret;
 }
=20
 static void perf_ftrace_function_enable(struct perf_event *event)
diff --git a/kernel/trace/trace_events_filter.c b/kernel/trace/trace_events=
_filter.c
index 3da3d0e..431dba8 100644
--- a/kernel/trace/trace_events_filter.c
+++ b/kernel/trace/trace_events_filter.c
@@ -81,6 +81,7 @@ enum {
 	FILT_ERR_TOO_MANY_PREDS,
 	FILT_ERR_MISSING_FIELD,
 	FILT_ERR_INVALID_FILTER,
+	FILT_ERR_IP_FIELD_ONLY,
 };
=20
 static char *err_text[] =3D {
@@ -96,6 +97,7 @@ static char *err_text[] =3D {
 	"Too many terms in predicate expression",
 	"Missing field name and/or value",
 	"Meaningless filter expression",
+	"Only 'ip' field is supported for function trace",
 };
=20
 struct opstack_op {
@@ -991,7 +993,12 @@ static int init_pred(struct filter_parse_state *ps,
 			fn =3D filter_pred_strloc;
 		else
 			fn =3D filter_pred_pchar;
-	} else if (!is_function_field(field)) {
+	} else if (is_function_field(field)) {
+		if (strcmp(field->name, "ip")) {
+			parse_error(ps, FILT_ERR_IP_FIELD_ONLY, 0);
+			return -EINVAL;
+		}
+	} else {
 		if (field->is_signed)
 			ret =3D strict_strtoll(pred->regex.pattern, 0, &val);
 		else
@@ -1338,10 +1345,7 @@ static struct filter_pred *create_pred(struct filter=
_parse_state *ps,
=20
 	strcpy(pred.regex.pattern, operand2);
 	pred.regex.len =3D strlen(pred.regex.pattern);
-
-#ifdef CONFIG_FTRACE_STARTUP_TEST
 	pred.field =3D field;
-#endif
 	return init_pred(ps, field, &pred) ? NULL : &pred;
 }
=20
@@ -1954,6 +1958,148 @@ void ftrace_profile_free_filter(struct perf_event *=
event)
 	__free_filter(filter);
 }
=20
+struct function_filter_data {
+	struct ftrace_ops *ops;
+	int first_filter;
+	int first_notrace;
+};
+
+#ifdef CONFIG_FUNCTION_TRACER
+static char **
+ftrace_function_filter_re(char *buf, int len, int *count)
+{
+	char *str, *sep, **re;
+
+	str =3D kstrndup(buf, len, GFP_KERNEL);
+	if (!str)
+		return NULL;
+
+	/*
+	 * The argv_split function takes white space
+	 * as a separator, so convert ',' into spaces.
+	 */
+	while ((sep =3D strchr(str, ',')))
+		*sep =3D ' ';
+
+	re =3D argv_split(GFP_KERNEL, str, count);
+	kfree(str);
+	return re;
+}
+
+static int ftrace_function_set_regexp(struct ftrace_ops *ops, int filter,
+				      int reset, char *re, int len)
+{
+	int ret;
+
+	if (filter)
+		ret =3D ftrace_set_filter(ops, re, len, reset);
+	else
+		ret =3D ftrace_set_notrace(ops, re, len, reset);
+
+	return ret;
+}
+
+static int __ftrace_function_set_filter(int filter, char *buf, int len,
+					struct function_filter_data *data)
+{
+	int i, re_cnt, ret;
+	int *reset;
+	char **re;
+
+	reset =3D filter ? &data->first_filter : &data->first_notrace;
+
+	/*
+	 * The 'ip' field could have multiple filters set, separated
+	 * either by space or comma. We first cut the filter and apply
+	 * all pieces separatelly.
+	 */
+	re =3D ftrace_function_filter_re(buf, len, &re_cnt);
+	if (!re)
+		return -EINVAL;
+
+	for (i =3D 0; i < re_cnt; i++) {
+		ret =3D ftrace_function_set_regexp(data->ops, filter, *reset,
+						 re[i], strlen(re[i]));
+		if (ret)
+			break;
+
+		if (*reset)
+			*reset =3D 0;
+	}
+
+	argv_free(re);
+	return ret;
+}
+
+static int ftrace_function_check_pred(struct filter_pred *pred, int leaf)
+{
+	struct ftrace_event_field *field =3D pred->field;
+
+	if (leaf) {
+		/*
+		 * Check the leaf predicate for function trace, verify:
+		 *  - only '=3D=3D' and '!=3D' is used
+		 *  - the 'ip' field is used
+		 */
+		if ((pred->op !=3D OP_EQ) && (pred->op !=3D OP_NE))
+			return -EINVAL;
+
+		if (strcmp(field->name, "ip"))
+			return -EINVAL;
+	} else {
+		/*
+		 * Check the non leaf predicate for function trace, verify:
+		 *  - only '||' is used
+		*/
+		if (pred->op !=3D OP_OR)
+			return -EINVAL;
+	}
+
+	return 0;
+}
+
+static int ftrace_function_set_filter_cb(enum move_type move,
+					 struct filter_pred *pred,
+					 int *err, void *data)
+{
+	/* Checking the node is valid for function trace. */
+	if ((move !=3D MOVE_DOWN) ||
+	    (pred->left !=3D FILTER_PRED_INVALID)) {
+		*err =3D ftrace_function_check_pred(pred, 0);
+	} else {
+		*err =3D ftrace_function_check_pred(pred, 1);
+		if (*err)
+			return WALK_PRED_ABORT;
+
+		*err =3D __ftrace_function_set_filter(pred->op =3D=3D OP_EQ,
+						    pred->regex.pattern,
+						    pred->regex.len,
+						    data);
+	}
+
+	return (*err) ? WALK_PRED_ABORT : WALK_PRED_DEFAULT;
+}
+
+static int ftrace_function_set_filter(struct perf_event *event,
+				      struct event_filter *filter)
+{
+	struct function_filter_data data =3D {
+		.first_filter  =3D 1,
+		.first_notrace =3D 1,
+		.ops           =3D &event->ftrace_ops,
+	};
+
+	return walk_pred_tree(filter->preds, filter->root,
+			      ftrace_function_set_filter_cb, &data);
+}
+#else
+static int ftrace_function_set_filter(struct perf_event *event,
+				      struct event_filter *filter)
+{
+	return -ENODEV;
+}
+#endif /* CONFIG_FUNCTION_TRACER */
+
 int ftrace_profile_set_filter(struct perf_event *event, int event_id,
 			      char *filter_str)
 {
@@ -1974,9 +2120,16 @@ int ftrace_profile_set_filter(struct perf_event *eve=
nt, int event_id,
 		goto out_unlock;
=20
 	err =3D create_filter(call, filter_str, false, &filter);
-	if (!err)
-		event->filter =3D filter;
+	if (err)
+		goto free_filter;
+
+	if (ftrace_event_is_function(call))
+		err =3D ftrace_function_set_filter(event, filter);
 	else
+		event->filter =3D filter;
+
+free_filter:
+	if (err || ftrace_event_is_function(call))
 		__free_filter(filter);
=20
 out_unlock:
--=20
1.7.8.3



--00GvhwF7k39YY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAABAgAGBQJPRP7DAAoJEIy3vGnGbaoAc/sQAL5ZNeHL6QruBZv4cAbpmhZw
INPYpKaE6uu5JEvPsk3I9OKj5cwiVqgESAQlqA51upImmSE8Dh8qFXrWFo6/d5do
O7MeWV49fEnXcCe+0bclJ9b/vZiGlyW0IEwVas8ovmeUGcCllzqez6Cspt8wZKEc
NJRdTVMX1V3rVs1DcBpOlleSAJJGzbfbt9/opfVxyb9auqvgXWdEDUkimIlyeN6T
pcDa/9ToOtIrhvGYVsGqQqYC3rk6gqD6XpZZk76DzGVp9z4MY2FBPL4DeMdk9KmQ
ytp5d8+qhVEvDoSWIi3oaeVR4dQ0MzUcVmkUthaynJTxzQjv4JKiMd5z/sMQj2SH
Yl+WIOk5Ox5lLGLtSY1d6ZKufzg1djFD+a4RsO+OdPDJuek/KEcAOjTJiHF6QPZR
oYOXHtHm1BONpWmHma+ybN6l7cBpNjinA5FkV7ZxcUDE3vYnKmhsdnT91v9tAfkl
dAb+MbheaD1dD0u5zbdcuf5AvZ9kEZwc0nH2Gb4hV1wStgxmRRHdkYxccNwlO99G
xFvnTKZ0rvAlP/Ow6yzrBGyLgyoI6eB+hR2iqe0cwsFAHMcN/emuDLztSQaHw+qX
Mc11xcxnxttDq3toMKUtWZfu7oJOhQ+8j73yWKv7EZKIMxD13ukqc/IoyFmNVs/X
CAoMYPmeVplB6K+Pdut2
=Vq28
-----END PGP SIGNATURE-----

--00GvhwF7k39YY--
