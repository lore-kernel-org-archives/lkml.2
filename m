Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932637Ab1LERX3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Dec 2011 12:23:29 -0500
Received: from mx1.redhat.com ([209.132.183.28]:55978 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932625Ab1LERX0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Dec 2011 12:23:26 -0500
From: Jiri Olsa <jolsa@redhat.com>
To: rostedt@goodmis.org, fweisbec@gmail.com, mingo@redhat.com,
        paulus@samba.org, acme@ghostprotocols.net, a.p.zijlstra@chello.nl
Cc: linux-kernel@vger.kernel.org, aarapov@redhat.com,
        Jiri Olsa <jolsa@redhat.com>
Subject: [PATCHv2 09/10] ftrace, perf: Add filter support for function trace event
Date: Mon,  5 Dec 2011 18:22:55 +0100
Message-Id: <1323105776-26961-10-git-send-email-jolsa@redhat.com>
In-Reply-To: <1323105776-26961-1-git-send-email-jolsa@redhat.com>
References: <1322417074-5834-1-git-send-email-jolsa@redhat.com>
 <1323105776-26961-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adding support to filter function trace event via perf
interface. It is now possible to use filter interface
in the perf tool like:

  perf record -e ftrace:function --filter="(ip == mm_*)" ls

The filter syntax is restricted to the the 'ip' field only,
and following operators are accepted '==' '!=' '||', ending
up with the filter strings like:

  "ip == f1 f2 ..." || "ip != f3 f4 ..." ...

The '==' operator adds trace filter with same effect as would
be added via set_ftrace_filter file.

The '!=' operator adds trace filter with same effect as would
be added via set_ftrace_notrace file.

The right side of the '!=', '==' operators is list of functions
or regexp. to be added to filter separated by space. Same syntax
is supported/required as for the set_ftrace_filter and
set_ftrace_notrace files.

The '||' operator is used for connecting multiple filter definitions
together. It is possible to have more than one '==' and '!='
operators within one filter string.

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
---
 kernel/trace/trace.h               |    2 -
 kernel/trace/trace_events_filter.c |  113 +++++++++++++++++++++++++++++++++---
 2 files changed, 105 insertions(+), 10 deletions(-)

diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
index 4199916..9b7a004 100644
--- a/kernel/trace/trace.h
+++ b/kernel/trace/trace.h
@@ -769,9 +769,7 @@ struct filter_pred {
 	u64 			val;
 	struct regex		regex;
 	unsigned short		*ops;
-#ifdef CONFIG_FTRACE_STARTUP_TEST
 	struct ftrace_event_field *field;
-#endif
 	int 			offset;
 	int 			not;
 	int 			op;
diff --git a/kernel/trace/trace_events_filter.c b/kernel/trace/trace_events_filter.c
index 7b0b04c..479b40b 100644
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
@@ -1339,10 +1353,8 @@ static struct filter_pred *create_pred(struct filter_parse_state *ps,
 
 	strcpy(pred.regex.pattern, operand2);
 	pred.regex.len = strlen(pred.regex.pattern);
-
-#ifdef CONFIG_FTRACE_STARTUP_TEST
 	pred.field = field;
-#endif
+
 	return init_pred(ps, field, &pred) ? NULL : &pred;
 }
 
@@ -1894,6 +1906,83 @@ void ftrace_profile_free_filter(struct perf_event *event)
 	__free_filter(filter);
 }
 
+struct function_filter_data {
+	struct ftrace_ops *ops;
+	int first_filter;
+	int first_notrace;
+};
+
+static int __ftrace_function_set_filter(int filter, char *buf, int len,
+					struct function_filter_data *data)
+{
+	int *reset, ret;
+
+	reset = filter ? &data->first_filter : &data->first_notrace;
+
+	if (filter)
+		ret = ftrace_set_filter(data->ops, buf, len, *reset);
+	else
+		ret = ftrace_set_notrace(data->ops, buf, len, *reset);
+
+	if (*reset)
+		*reset = 0;
+
+	return ret;
+}
+
+static int ftrace_function_check_pred(struct filter_pred *pred)
+{
+	struct ftrace_event_field *field = pred->field;
+
+	/*
+	  Check the predicate for function trace, verify:
+	   - only '==' and '!=' is used
+	   - the 'ip' field is used
+	*/
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
@@ -1901,6 +1990,7 @@ int ftrace_profile_set_filter(struct perf_event *event, int event_id,
 	struct event_filter *filter;
 	struct filter_parse_state *ps;
 	struct ftrace_event_call *call;
+	struct filter_op *fops = filter_ops;
 
 	mutex_lock(&event_mutex);
 
@@ -1925,14 +2015,21 @@ int ftrace_profile_set_filter(struct perf_event *event, int event_id,
 	if (!ps)
 		goto free_filter;
 
-	parse_init(ps, filter_ops, filter_str);
+	if (ftrace_event_is_function(call))
+		fops = filter_ftrace_ops;
+
+	parse_init(ps, fops, filter_str);
 	err = filter_parse(ps);
 	if (err)
 		goto free_ps;
 
 	err = replace_preds(call, filter, ps, filter_str, false);
-	if (!err)
-		event->filter = filter;
+	if (!err) {
+		if (ftrace_event_is_function(call))
+			err = ftrace_function_set_filter(event, filter);
+		else
+			event->filter = filter;
+	}
 
 free_ps:
 	filter_opstack_clear(ps);
@@ -1940,7 +2037,7 @@ free_ps:
 	kfree(ps);
 
 free_filter:
-	if (err)
+	if (err || ftrace_event_is_function(call))
 		__free_filter(filter);
 
 out_unlock:
-- 
1.7.1

