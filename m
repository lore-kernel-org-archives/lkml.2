Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753011Ab1DUKlO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Apr 2011 06:41:14 -0400
Received: from mx1.redhat.com ([209.132.183.28]:54929 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751813Ab1DUKlM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Apr 2011 06:41:12 -0400
From: Jiri Olsa <jolsa@redhat.com>
To: rostedt@goodmis.org, fweisbec@gmail.com, mingo@redhat.com,
        a.p.zijlstra@chello.nl
Cc: linux-kernel@vger.kernel.org
Subject: [RFC,PATCH 3/3] trace,perf: add filter support for ftrace/function tracepoint event
Date: Thu, 21 Apr 2011 12:40:58 +0200
Message-Id: <1303382458-11072-4-git-send-email-jolsa@redhat.com>
In-Reply-To: <1303382458-11072-1-git-send-email-jolsa@redhat.com>
References: <1303382458-11072-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Added support to be able to pass "ip == glob" filter for the ftrace/function
tracepoint.

Respective functions are hot-patched/updated when the filter is set,
and the filter predicate is set to be allways true. Probably missing
several cases.. not sure this is the way.

wbr,
jirka

---
 include/linux/ftrace_event.h       |    3 ++
 kernel/trace/ftrace.c              |   35 ++++++++++++++++++++++++++++
 kernel/trace/trace.h               |    2 +
 kernel/trace/trace_events_filter.c |   45 ++++++++++++++++++++++++++++++++---
 kernel/trace/trace_export.c        |   26 ++++++++++++++++----
 5 files changed, 102 insertions(+), 9 deletions(-)

diff --git a/include/linux/ftrace_event.h b/include/linux/ftrace_event.h
index 22b32af..bbf7cc6 100644
--- a/include/linux/ftrace_event.h
+++ b/include/linux/ftrace_event.h
@@ -144,6 +144,8 @@ struct ftrace_event_class {
 	struct list_head	*(*get_fields)(struct ftrace_event_call *);
 	struct list_head	fields;
 	int			(*raw_init)(struct ftrace_event_call *);
+	void			(*filter)(struct ftrace_event_call *call,
+					  int enable);
 };
 
 extern int ftrace_event_reg(struct ftrace_event_call *event,
@@ -221,6 +223,7 @@ enum {
 	FILTER_STATIC_STRING,
 	FILTER_DYN_STRING,
 	FILTER_PTR_STRING,
+	FILTER_TRACE_FN,
 };
 
 #define EVENT_STORAGE_SIZE 128
diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index 49fbc8c..b52db6e 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -3285,6 +3285,41 @@ int ftrace_event_class_register(struct ftrace_event_call *call,
 	return -EINVAL;
 }
 
+void ftrace_event_tracefn_filter(int enable)
+{
+	char *filter = event_function.data;
+
+	if (enable) {
+		WARN_ON(!filter);
+		if (filter)
+			ftrace_match_records(filter, strlen(filter), 1);
+	} else {
+		ftrace_filter_reset(1);
+		if (filter) {
+			kfree(filter);
+			event_function.data = NULL;
+		}
+	}
+
+	mutex_lock(&ftrace_lock);
+	if (ftrace_enabled)
+		ftrace_run_update_code(FTRACE_ENABLE_CALLS);
+	mutex_unlock(&ftrace_lock);
+}
+
+void ftrace_event_class_filter(struct ftrace_event_call *call, int enable)
+{
+	int etype = call->event.type;
+
+	switch (etype) {
+	case TRACE_FN:
+		ftrace_event_tracefn_filter(enable);
+		break;
+	default:
+		break;
+	}
+}
+
 #ifdef CONFIG_FUNCTION_GRAPH_TRACER
 
 static int ftrace_graph_active;
diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
index 3298333..bc2537e 100644
--- a/kernel/trace/trace.h
+++ b/kernel/trace/trace.h
@@ -780,6 +780,8 @@ extern const char *__stop___trace_bprintk_fmt[];
 
 extern int ftrace_event_class_register(struct ftrace_event_call *call,
 				       enum trace_reg type);
+extern void ftrace_event_class_filter(struct ftrace_event_call *call,
+				      int enable);
 
 #undef FTRACE_ENTRY
 #define FTRACE_ENTRY(call, struct_name, id, tstruct, print)		\
diff --git a/kernel/trace/trace_events_filter.c b/kernel/trace/trace_events_filter.c
index 8008ddc..5a847a5 100644
--- a/kernel/trace/trace_events_filter.c
+++ b/kernel/trace/trace_events_filter.c
@@ -238,6 +238,11 @@ static int filter_pred_none(struct filter_pred *pred, void *event)
 	return 0;
 }
 
+static int filter_pred_all(struct filter_pred *pred, void *event)
+{
+	return 1;
+}
+
 /*
  * regex_match_foo - Basic regex callbacks
  *
@@ -755,8 +760,23 @@ static void __free_preds(struct event_filter *filter)
 	filter->n_preds = 0;
 }
 
+static void filter_enable(struct ftrace_event_call *call)
+{
+	struct ftrace_event_class *class = call->class;
+
+	call->flags |= TRACE_EVENT_FL_FILTERED;
+
+	if (class && class->filter)
+		class->filter(call, 1);
+}
+
 static void filter_disable(struct ftrace_event_call *call)
 {
+	struct ftrace_event_class *class = call->class;
+
+	if (class && class->filter)
+		class->filter(call, 0);
+
 	call->flags &= ~TRACE_EVENT_FL_FILTERED;
 }
 
@@ -883,6 +903,11 @@ static bool is_string_field(struct ftrace_event_field *field)
 	       field->filter_type == FILTER_PTR_STRING;
 }
 
+static bool is_tracefn_field(struct ftrace_event_field *field)
+{
+	return field->filter_type == FILTER_TRACE_FN;
+}
+
 static int is_legal_op(struct ftrace_event_field *field, int op)
 {
 	if (is_string_field(field) &&
@@ -969,7 +994,15 @@ static int filter_add_pred(struct filter_parse_state *ps,
 		return -EINVAL;
 	}
 
-	if (is_string_field(field)) {
+	if (is_tracefn_field(field)) {
+		/* allow only one function trace predicate */
+		if (call->data) {
+			parse_error(ps, FILT_ERR_TOO_MANY_OPERANDS, 0);
+			return -EINVAL;
+		}
+		fn = filter_pred_all;
+		call->data = kstrdup(pred->regex.pattern, GFP_KERNEL);
+	} else if (is_string_field(field)) {
 		filter_build_regex(pred);
 
 		if (field->filter_type == FILTER_STATIC_STRING) {
@@ -1760,7 +1793,7 @@ static int replace_system_preds(struct event_subsystem *system,
 			parse_error(ps, FILT_ERR_BAD_SUBSYS_FILTER, 0);
 			append_filter_err(ps, filter);
 		} else
-			call->flags |= TRACE_EVENT_FL_FILTERED;
+			filter_enable(call);
 		/*
 		 * Regardless of if this returned an error, we still
 		 * replace the filter for the call.
@@ -1853,7 +1886,7 @@ int apply_event_filter(struct ftrace_event_call *call, char *filter_string)
 		filter_disable(call);
 		append_filter_err(ps, filter);
 	} else
-		call->flags |= TRACE_EVENT_FL_FILTERED;
+		filter_enable(call);
 out:
 	/*
 	 * Always swap the call filter with the new filter
@@ -1965,6 +1998,8 @@ int ftrace_profile_set_filter(struct perf_event *event, int event_id,
 	if (&call->list == &ftrace_events)
 		goto out_unlock;
 
+	filter_disable(call);
+
 	err = -EEXIST;
 	if (event->filter)
 		goto out_unlock;
@@ -1986,8 +2021,10 @@ int ftrace_profile_set_filter(struct perf_event *event, int event_id,
 		goto free_ps;
 
 	err = replace_preds(call, filter, ps, filter_str, false);
-	if (!err)
+	if (!err) {
+		filter_enable(call);
 		event->filter = filter;
+	}
 
 free_ps:
 	filter_opstack_clear(ps);
diff --git a/kernel/trace/trace_export.c b/kernel/trace/trace_export.c
index 0b0906a..b1d5301 100644
--- a/kernel/trace/trace_export.c
+++ b/kernel/trace/trace_export.c
@@ -67,7 +67,7 @@ static void __always_unused ____ftrace_check_##name(void)	\
 	ret = trace_define_field(event_call, #type, #item,		\
 				 offsetof(typeof(field), item),		\
 				 sizeof(field.item),			\
-				 is_signed_type(type), FILTER_OTHER);	\
+				 is_signed_type(type), filter_type);	\
 	if (ret)							\
 		return ret;
 
@@ -77,7 +77,7 @@ static void __always_unused ____ftrace_check_##name(void)	\
 				 offsetof(typeof(field),		\
 					  container.item),		\
 				 sizeof(field.container.item),		\
-				 is_signed_type(type), FILTER_OTHER);	\
+				 is_signed_type(type), filter_type);	\
 	if (ret)							\
 		return ret;
 
@@ -91,7 +91,7 @@ static void __always_unused ____ftrace_check_##name(void)	\
 		ret = trace_define_field(event_call, event_storage, #item, \
 				 offsetof(typeof(field), item),		\
 				 sizeof(field.item),			\
-				 is_signed_type(type), FILTER_OTHER);	\
+				 is_signed_type(type), filter_type);	\
 		mutex_unlock(&event_storage_mutex);			\
 		if (ret)						\
 			return ret;					\
@@ -104,7 +104,7 @@ static void __always_unused ____ftrace_check_##name(void)	\
 				 offsetof(typeof(field),		\
 					  container.item),		\
 				 sizeof(field.container.item),		\
-				 is_signed_type(type), FILTER_OTHER);	\
+				 is_signed_type(type), filter_type);	\
 	if (ret)							\
 		return ret;
 
@@ -112,10 +112,24 @@ static void __always_unused ____ftrace_check_##name(void)	\
 #define __dynamic_array(type, item)					\
 	ret = trace_define_field(event_call, #type, #item,		\
 				 offsetof(typeof(field), item),		\
-				 0, is_signed_type(type), FILTER_OTHER);\
+				 0, is_signed_type(type), filter_type);	\
 	if (ret)							\
 		return ret;
 
+#define FILTER_TYPE_TRACE_FN		FILTER_TRACE_FN
+#define FILTER_TYPE_TRACE_GRAPH_ENT	FILTER_OTHER
+#define FILTER_TYPE_TRACE_GRAPH_RET	FILTER_OTHER
+#define FILTER_TYPE_TRACE_CTX		FILTER_OTHER
+#define FILTER_TYPE_TRACE_WAKE		FILTER_OTHER
+#define FILTER_TYPE_TRACE_STACK		FILTER_OTHER
+#define FILTER_TYPE_TRACE_USER_STACK	FILTER_OTHER
+#define FILTER_TYPE_TRACE_BPRINT	FILTER_OTHER
+#define FILTER_TYPE_TRACE_PRINT		FILTER_OTHER
+#define FILTER_TYPE_TRACE_MMIO_RW	FILTER_OTHER
+#define FILTER_TYPE_TRACE_MMIO_MAP	FILTER_OTHER
+#define FILTER_TYPE_TRACE_BRANCH	FILTER_OTHER
+#define FILTER_TYPE(arg)		FILTER_TYPE_##arg
+
 #undef FTRACE_ENTRY
 #define FTRACE_ENTRY(name, struct_name, id, tstruct, print)		\
 int									\
@@ -123,6 +137,7 @@ ftrace_define_fields_##name(struct ftrace_event_call *event_call)	\
 {									\
 	struct struct_name field;					\
 	int ret;							\
+	int filter_type = FILTER_TYPE(id);				\
 									\
 	tstruct;							\
 									\
@@ -160,6 +175,7 @@ struct ftrace_event_class event_class_ftrace_##call = {			\
 	.define_fields		= ftrace_define_fields_##call,		\
 	.fields			= LIST_HEAD_INIT(event_class_ftrace_##call.fields),\
 	.reg			= ftrace_event_class_register,		\
+	.filter			= ftrace_event_class_filter,		\
 };									\
 									\
 struct ftrace_event_call __used event_##call = {			\
-- 
1.7.1

