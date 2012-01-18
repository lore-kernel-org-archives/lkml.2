Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757538Ab2ARNpv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jan 2012 08:45:51 -0500
Received: from mx1.redhat.com ([209.132.183.28]:35479 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757519Ab2ARNpu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jan 2012 08:45:50 -0500
Date: Wed, 18 Jan 2012 14:45:36 +0100
From: Jiri Olsa <jolsa@redhat.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: fweisbec@gmail.com, mingo@redhat.com, paulus@samba.org,
        acme@ghostprotocols.net, a.p.zijlstra@chello.nl,
        linux-kernel@vger.kernel.org, aarapov@redhat.com
Subject: Re: [PATCH 7/7] ftrace, perf: Add filter support for function trace
 event
Message-ID: <20120118134536.GE19019@m.redhat.com>
References: <1324493791-5688-1-git-send-email-jolsa@redhat.com>
 <1325495060-6402-1-git-send-email-jolsa@redhat.com>
 <1325495060-6402-8-git-send-email-jolsa@redhat.com>
 <1326758348.7642.179.camel@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1326758348.7642.179.camel@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 16, 2012 at 06:59:08PM -0500, Steven Rostedt wrote:
> On Mon, 2012-01-02 at 10:04 +0100, Jiri Olsa wrote:
> > Adding support to filter function trace event via perf
> > interface. It is now possible to use filter interface
> > in the perf tool like:
> > 
> >   perf record -e ftrace:function --filter="(ip == mm_*)" ls
> > 
> > The filter syntax is restricted to the the 'ip' field only,
> > and following operators are accepted '==' '!=' '||', ending
> > up with the filter strings like:
> > 
> >   ip == f1[, ]f2 ... || ip != f3[, ]f4 ...
> > 
> > with comma ',' or space ' ' as a function separator. If the
> > space ' ' is used as a separator, the right side of the
> > assignment needs to be enclosed in double quotes '"'.
> > 
> > The '==' operator adds trace filter with same effect as would
> > be added via set_ftrace_filter file.
> > 
> > The '!=' operator adds trace filter with same effect as would
> > be added via set_ftrace_notrace file.
> > 
> > The right side of the '!=', '==' operators is list of functions
> > or regexp. to be added to filter separated by space.
> > 
> > The '||' operator is used for connecting multiple filter definitions
> > together. It is possible to have more than one '==' and '!='
> > operators within one filter string.
> 
> Hate to ask you this, but can you rebase this patch against latest
> tip/perf/core? Things have changed that cause this patch not to apply.

yep, attaching rebased patch ;)

thanks,
jirka


---
Adding support to filter function trace event via perf
interface. It is now possible to use filter interface
in the perf tool like:

  perf record -e ftrace:function --filter="(ip == mm_*)" ls

The filter syntax is restricted to the the 'ip' field only,
and following operators are accepted '==' '!=' '||', ending
up with the filter strings like:

  ip == f1[, ]f2 ... || ip != f3[, ]f4 ...

with comma ',' or space ' ' as a function separator. If the
space ' ' is used as a separator, the right side of the
assignment needs to be enclosed in double quotes '"'.

The '==' operator adds trace filter with same effect as would
be added via set_ftrace_filter file.

The '!=' operator adds trace filter with same effect as would
be added via set_ftrace_notrace file.

The right side of the '!=', '==' operators is list of functions
or regexp. to be added to filter separated by space.

The '||' operator is used for connecting multiple filter definitions
together. It is possible to have more than one '==' and '!='
operators within one filter string.

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
---
 include/linux/ftrace.h             |    1 +
 kernel/trace/ftrace.c              |    6 ++
 kernel/trace/trace.h               |    2 -
 kernel/trace/trace_event_perf.c    |    4 +-
 kernel/trace/trace_events_filter.c |  169 +++++++++++++++++++++++++++++++++---
 5 files changed, 168 insertions(+), 14 deletions(-)

diff --git a/include/linux/ftrace.h b/include/linux/ftrace.h
index 2a6d9af..797a5a5 100644
--- a/include/linux/ftrace.h
+++ b/include/linux/ftrace.h
@@ -226,6 +226,7 @@ int ftrace_set_notrace(struct ftrace_ops *ops, unsigned char *buf,
 			int len, int reset);
 void ftrace_set_global_filter(unsigned char *buf, int len, int reset);
 void ftrace_set_global_notrace(unsigned char *buf, int len, int reset);
+void ftrace_free_filter(struct ftrace_ops *ops);
 
 int register_ftrace_command(struct ftrace_func_command *cmd);
 int unregister_ftrace_command(struct ftrace_func_command *cmd);
diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index 45c9b0c..9935a2a 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -1192,6 +1192,12 @@ static void free_ftrace_hash_rcu(struct ftrace_hash *hash)
 	call_rcu_sched(&hash->rcu, __free_ftrace_hash_rcu);
 }
 
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
index e88e58a..4ec6d18 100644
--- a/kernel/trace/trace.h
+++ b/kernel/trace/trace.h
@@ -770,9 +770,7 @@ struct filter_pred {
 	u64 			val;
 	struct regex		regex;
 	unsigned short		*ops;
-#ifdef CONFIG_FTRACE_STARTUP_TEST
 	struct ftrace_event_field *field;
-#endif
 	int 			offset;
 	int 			not;
 	int 			op;
diff --git a/kernel/trace/trace_event_perf.c b/kernel/trace/trace_event_perf.c
index 57eb232..220b50a 100644
--- a/kernel/trace/trace_event_perf.c
+++ b/kernel/trace/trace_event_perf.c
@@ -298,7 +298,9 @@ static int perf_ftrace_function_register(struct perf_event *event)
 static int perf_ftrace_function_unregister(struct perf_event *event)
 {
 	struct ftrace_ops *ops = &event->ftrace_ops;
-	return unregister_ftrace_function(ops);
+	int ret = unregister_ftrace_function(ops);
+	ftrace_free_filter(ops);
+	return ret;
 }
 
 static void perf_ftrace_function_enable(struct perf_event *event)
diff --git a/kernel/trace/trace_events_filter.c b/kernel/trace/trace_events_filter.c
index eb04a2a..c8a64ec 100644
--- a/kernel/trace/trace_events_filter.c
+++ b/kernel/trace/trace_events_filter.c
@@ -54,6 +54,13 @@ struct filter_op {
 	int precedence;
 };
 
+static struct filter_op filter_ftrace_ops[] = {
+	{ OP_OR,	"||",		1 },
+	{ OP_NE,	"!=",		2 },
+	{ OP_EQ,	"==",		2 },
+	{ OP_NONE,	"OP_NONE",	0 },
+};
+
 static struct filter_op filter_ops[] = {
 	{ OP_OR,	"||",		1 },
 	{ OP_AND,	"&&",		2 },
@@ -81,6 +88,7 @@ enum {
 	FILT_ERR_TOO_MANY_PREDS,
 	FILT_ERR_MISSING_FIELD,
 	FILT_ERR_INVALID_FILTER,
+	FILT_ERR_IP_FIELD_ONLY,
 };
 
 static char *err_text[] = {
@@ -96,6 +104,7 @@ static char *err_text[] = {
 	"Too many terms in predicate expression",
 	"Missing field name and/or value",
 	"Meaningless filter expression",
+	"Only 'ip' field is supported for function trace",
 };
 
 struct opstack_op {
@@ -992,7 +1001,12 @@ static int init_pred(struct filter_parse_state *ps,
 			fn = filter_pred_strloc;
 		else
 			fn = filter_pred_pchar;
-	} else if (!is_function_field(field)) {
+	} else if (is_function_field(field)) {
+		if (strcmp(field->name, "ip")) {
+			parse_error(ps, FILT_ERR_IP_FIELD_ONLY, 0);
+			return -EINVAL;
+		}
+	} else {
 		if (field->is_signed)
 			ret = strict_strtoll(pred->regex.pattern, 0, &val);
 		else
@@ -1339,10 +1353,7 @@ static struct filter_pred *create_pred(struct filter_parse_state *ps,
 
 	strcpy(pred.regex.pattern, operand2);
 	pred.regex.len = strlen(pred.regex.pattern);
-
-#ifdef CONFIG_FTRACE_STARTUP_TEST
 	pred.field = field;
-#endif
 	return init_pred(ps, field, &pred) ? NULL : &pred;
 }
 
@@ -1743,8 +1754,8 @@ static int replace_system_preds(struct event_subsystem *system,
 	return -ENOMEM;
 }
 
-static int create_filter_start(char *filter_str, bool set_str,
-			       struct filter_parse_state **psp,
+static int create_filter_start(char *filter_str, struct filter_op *fops,
+			       bool set_str, struct filter_parse_state **psp,
 			       struct event_filter **filterp)
 {
 	struct event_filter *filter;
@@ -1770,7 +1781,7 @@ static int create_filter_start(char *filter_str, bool set_str,
 	*filterp = filter;
 	*psp = ps;
 
-	parse_init(ps, filter_ops, filter_str);
+	parse_init(ps, fops, filter_str);
 	err = filter_parse(ps);
 	if (err && set_str)
 		append_filter_err(ps, filter);
@@ -1808,9 +1819,13 @@ static int create_filter(struct ftrace_event_call *call,
 {
 	struct event_filter *filter = NULL;
 	struct filter_parse_state *ps = NULL;
+	struct filter_op *fops = filter_ops;
 	int err;
 
-	err = create_filter_start(filter_str, set_str, &ps, &filter);
+	if (ftrace_event_is_function(call))
+		fops = filter_ftrace_ops;
+
+	err = create_filter_start(filter_str, fops, set_str, &ps, &filter);
 	if (!err) {
 		err = replace_preds(call, filter, ps, filter_str, false);
 		if (err && set_str)
@@ -1838,7 +1853,7 @@ static int create_system_filter(struct event_subsystem *system,
 	struct filter_parse_state *ps = NULL;
 	int err;
 
-	err = create_filter_start(filter_str, true, &ps, &filter);
+	err = create_filter_start(filter_str, filter_ops, true, &ps, &filter);
 	if (!err) {
 		err = replace_system_preds(system, ps, filter_str);
 		if (!err) {
@@ -1955,6 +1970,131 @@ void ftrace_profile_free_filter(struct perf_event *event)
 	__free_filter(filter);
 }
 
+struct function_filter_data {
+	struct ftrace_ops *ops;
+	int first_filter;
+	int first_notrace;
+};
+
+static char **
+ftrace_function_filter_re(char *buf, int len, int *count)
+{
+	char *str, *sep, **re;
+
+	str = kstrndup(buf, len, GFP_KERNEL);
+	if (!str)
+		return NULL;
+
+	/*
+	 * The argv_split function takes white space
+	 * as a separator, so convert ',' into spaces.
+	 */
+	while ((sep = strchr(str, ',')))
+		*sep = ' ';
+
+	re = argv_split(GFP_KERNEL, str, count);
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
+		ret = ftrace_set_filter(ops, re, len, reset);
+	else
+		ret = ftrace_set_notrace(ops, re, len, reset);
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
+	reset = filter ? &data->first_filter : &data->first_notrace;
+
+	/*
+	 * The 'ip' field could have multiple filters set, separated
+	 * either by space or comma. We first cut the filter and apply
+	 * all pieces separatelly.
+	 */
+	re = ftrace_function_filter_re(buf, len, &re_cnt);
+	if (!re)
+		return -EINVAL;
+
+	for (i = 0; i < re_cnt; i++) {
+		ret = ftrace_function_set_regexp(data->ops, filter, *reset,
+						 re[i], strlen(re[i]));
+		if (ret)
+			break;
+
+		if (*reset)
+			*reset = 0;
+	}
+
+	argv_free(re);
+	return ret;
+}
+
+static int ftrace_function_check_pred(struct filter_pred *pred)
+{
+	struct ftrace_event_field *field = pred->field;
+
+	/*
+	 * Check the predicate for function trace, verify:
+	 *  - only '==' and '!=' is used
+	 *  - the 'ip' field is used
+	 */
+	if (WARN((pred->op != OP_EQ) && (pred->op != OP_NE),
+		 "wrong operator for function filter: %d\n", pred->op))
+		return -EINVAL;
+
+	if (strcmp(field->name, "ip"))
+		return -EINVAL;
+
+	return 0;
+}
+
+static int ftrace_function_set_filter_cb(enum move_type move,
+					 struct filter_pred *pred,
+					 int *err, void *data)
+{
+	if ((move != MOVE_DOWN) ||
+	    (pred->left != FILTER_PRED_INVALID))
+		return WALK_PRED_DEFAULT;
+
+	/* Double checking the predicate is valid for function trace. */
+	*err = ftrace_function_check_pred(pred);
+	if (*err)
+		return WALK_PRED_ABORT;
+
+	*err = __ftrace_function_set_filter(pred->op == OP_EQ,
+					    pred->regex.pattern,
+					    pred->regex.len,
+					    data);
+
+	return (*err) ? WALK_PRED_ABORT : WALK_PRED_DEFAULT;
+}
+
+static int ftrace_function_set_filter(struct perf_event *event,
+				      struct event_filter *filter)
+{
+	struct function_filter_data data = {
+		.first_filter  = 1,
+		.first_notrace = 1,
+		.ops           = &event->ftrace_ops,
+	};
+
+	return walk_pred_tree(filter->preds, filter->root,
+			      ftrace_function_set_filter_cb, &data);
+}
+
 int ftrace_profile_set_filter(struct perf_event *event, int event_id,
 			      char *filter_str)
 {
@@ -1975,9 +2115,16 @@ int ftrace_profile_set_filter(struct perf_event *event, int event_id,
 		goto out_unlock;
 
 	err = create_filter(call, filter_str, false, &filter);
-	if (!err)
-		event->filter = filter;
+	if (err)
+		goto free_filter;
+
+	if (ftrace_event_is_function(call))
+		err = ftrace_function_set_filter(event, filter);
 	else
+		event->filter = filter;
+
+free_filter:
+	if (err ||  ftrace_event_is_function(call))
 		__free_filter(filter);
 
 out_unlock:
-- 
1.7.1

