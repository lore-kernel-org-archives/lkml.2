Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761553Ab2BOOwb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Feb 2012 09:52:31 -0500
Received: from mx1.redhat.com ([209.132.183.28]:18986 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761524Ab2BOOwW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Feb 2012 09:52:22 -0500
From: Jiri Olsa <jolsa@redhat.com>
To: rostedt@goodmis.org, fweisbec@gmail.com, mingo@redhat.com,
        paulus@samba.org, acme@ghostprotocols.net, a.p.zijlstra@chello.nl
Cc: linux-kernel@vger.kernel.org, aarapov@redhat.com,
        Jiri Olsa <jolsa@redhat.com>
Subject: [PATCH 7/7] ftrace, perf: Add filter support for function trace event
Date: Wed, 15 Feb 2012 15:51:54 +0100
Message-Id: <1329317514-8131-8-git-send-email-jolsa@redhat.com>
In-Reply-To: <1329317514-8131-1-git-send-email-jolsa@redhat.com>
References: <1329317514-8131-1-git-send-email-jolsa@redhat.com>
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

  ip == f1[, ]f2 ... || ip != f3[, ]f4 ...

with comma ',' or space ' ' as a function separator. If the
space ' ' is used as a separator, the right side of the
assignment needs to be enclosed in double quotes '"', e.g.:

  perf record -e ftrace:function --filter '(ip == do_execve,sys_*,ext*)' ls
  perf record -e ftrace:function --filter '(ip == "do_execve,sys_*,ext*")' ls
  perf record -e ftrace:function --filter '(ip == "do_execve sys_* ext*")' ls

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
 include/linux/ftrace.h             |    7 +-
 kernel/trace/ftrace.c              |    6 ++
 kernel/trace/trace.h               |    2 -
 kernel/trace/trace_event_perf.c    |    4 +-
 kernel/trace/trace_events_filter.c |  165 ++++++++++++++++++++++++++++++++++--
 5 files changed, 172 insertions(+), 12 deletions(-)

diff --git a/include/linux/ftrace.h b/include/linux/ftrace.h
index 64a309d..72a6cab 100644
--- a/include/linux/ftrace.h
+++ b/include/linux/ftrace.h
@@ -250,6 +250,7 @@ int ftrace_set_notrace(struct ftrace_ops *ops, unsigned char *buf,
 			int len, int reset);
 void ftrace_set_global_filter(unsigned char *buf, int len, int reset);
 void ftrace_set_global_notrace(unsigned char *buf, int len, int reset);
+void ftrace_free_filter(struct ftrace_ops *ops);
 
 int register_ftrace_command(struct ftrace_func_command *cmd);
 int unregister_ftrace_command(struct ftrace_func_command *cmd);
@@ -380,9 +381,6 @@ extern void ftrace_enable_daemon(void);
 #else
 static inline int skip_trace(unsigned long ip) { return 0; }
 static inline int ftrace_force_update(void) { return 0; }
-static inline void ftrace_set_filter(unsigned char *buf, int len, int reset)
-{
-}
 static inline void ftrace_disable_daemon(void) { }
 static inline void ftrace_enable_daemon(void) { }
 static inline void ftrace_release_mod(struct module *mod) {}
@@ -406,6 +404,9 @@ static inline int ftrace_text_reserved(void *start, void *end)
  */
 #define ftrace_regex_open(ops, flag, inod, file) ({ -ENODEV; })
 #define ftrace_set_early_filter(ops, buf, enable) do { } while (0)
+#define ftrace_set_filter(ops, buf, len, reset) ({ -ENODEV; })
+#define ftrace_set_notrace(ops, buf, len, reset) ({ -ENODEV; })
+#define ftrace_free_filter(ops) do { } while (0)
 
 static inline ssize_t ftrace_filter_write(struct file *file, const char __user *ubuf,
 			    size_t cnt, loff_t *ppos) { return -ENODEV; }
diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index c8d2af2..239b94a 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -1186,6 +1186,12 @@ static void free_ftrace_hash_rcu(struct ftrace_hash *hash)
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
diff --git a/kernel/trace/trace_event_perf.c b/kernel/trace/trace_event_perf.c
index fdeeb5c..fee3752 100644
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
index eb04a2a..4d7ac74 100644
--- a/kernel/trace/trace_events_filter.c
+++ b/kernel/trace/trace_events_filter.c
@@ -81,6 +81,7 @@ enum {
 	FILT_ERR_TOO_MANY_PREDS,
 	FILT_ERR_MISSING_FIELD,
 	FILT_ERR_INVALID_FILTER,
+	FILT_ERR_IP_FIELD_ONLY,
 };
 
 static char *err_text[] = {
@@ -96,6 +97,7 @@ static char *err_text[] = {
 	"Too many terms in predicate expression",
 	"Missing field name and/or value",
 	"Meaningless filter expression",
+	"Only 'ip' field is supported for function trace",
 };
 
 struct opstack_op {
@@ -992,7 +994,12 @@ static int init_pred(struct filter_parse_state *ps,
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
@@ -1339,10 +1346,7 @@ static struct filter_pred *create_pred(struct filter_parse_state *ps,
 
 	strcpy(pred.regex.pattern, operand2);
 	pred.regex.len = strlen(pred.regex.pattern);
-
-#ifdef CONFIG_FTRACE_STARTUP_TEST
 	pred.field = field;
-#endif
 	return init_pred(ps, field, &pred) ? NULL : &pred;
 }
 
@@ -1955,6 +1959,148 @@ void ftrace_profile_free_filter(struct perf_event *event)
 	__free_filter(filter);
 }
 
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
+static int ftrace_function_check_pred(struct filter_pred *pred, int leaf)
+{
+	struct ftrace_event_field *field = pred->field;
+
+	if (leaf) {
+		/*
+		 * Check the leaf predicate for function trace, verify:
+		 *  - only '==' and '!=' is used
+		 *  - the 'ip' field is used
+		 */
+		if ((pred->op != OP_EQ) && (pred->op != OP_NE))
+			return -EINVAL;
+
+		if (strcmp(field->name, "ip"))
+			return -EINVAL;
+	} else {
+		/*
+		 * Check the non leaf predicate for function trace, verify:
+		 *  - only '||' is used
+		*/
+		if (pred->op != OP_OR)
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
+	if ((move != MOVE_DOWN) ||
+	    (pred->left != FILTER_PRED_INVALID)) {
+		*err = ftrace_function_check_pred(pred, 0);
+	} else {
+		*err = ftrace_function_check_pred(pred, 1);
+		if (*err)
+			return WALK_PRED_ABORT;
+
+		*err = __ftrace_function_set_filter(pred->op == OP_EQ,
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
+	struct function_filter_data data = {
+		.first_filter  = 1,
+		.first_notrace = 1,
+		.ops           = &event->ftrace_ops,
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
@@ -1975,9 +2121,16 @@ int ftrace_profile_set_filter(struct perf_event *event, int event_id,
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
+	if (err || ftrace_event_is_function(call))
 		__free_filter(filter);
 
 out_unlock:
-- 
1.7.1

