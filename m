Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758143Ab2ARSpF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jan 2012 13:45:05 -0500
Received: from mx1.redhat.com ([209.132.183.28]:6521 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758063Ab2ARSpC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jan 2012 13:45:02 -0500
From: Jiri Olsa <jolsa@redhat.com>
To: rostedt@goodmis.org, fweisbec@gmail.com, mingo@redhat.com,
        paulus@samba.org, acme@ghostprotocols.net, a.p.zijlstra@chello.nl
Cc: linux-kernel@vger.kernel.org, aarapov@redhat.com,
        Jiri Olsa <jolsa@redhat.com>
Subject: [PATCH 6/7] ftrace, perf: Distinguish ftrace function event field type
Date: Wed, 18 Jan 2012 19:44:34 +0100
Message-Id: <1326912275-26405-7-git-send-email-jolsa@redhat.com>
In-Reply-To: <1326912275-26405-1-git-send-email-jolsa@redhat.com>
References: <1325495060-6402-1-git-send-email-jolsa@redhat.com>
 <1326912275-26405-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adding FILTER_TRACE_FN event field type for function tracepoint
event, so it can be properly recognized within filtering code.

Currently all fields of ftrace subsystem events share the common
field type FILTER_OTHER. Since the function trace fields need special
care within the filtering code we need to recognize it properly,
hence adding the FILTER_TRACE_FN event type.

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
---
 include/linux/ftrace_event.h       |    1 +
 kernel/trace/trace_events_filter.c |    7 ++++++-
 kernel/trace/trace_export.c        |   25 ++++++++++++++++++++-----
 3 files changed, 27 insertions(+), 6 deletions(-)

diff --git a/include/linux/ftrace_event.h b/include/linux/ftrace_event.h
index 2bf677c..dd478fc 100644
--- a/include/linux/ftrace_event.h
+++ b/include/linux/ftrace_event.h
@@ -245,6 +245,7 @@ enum {
 	FILTER_STATIC_STRING,
 	FILTER_DYN_STRING,
 	FILTER_PTR_STRING,
+	FILTER_TRACE_FN,
 };
 
 #define EVENT_STORAGE_SIZE 128
diff --git a/kernel/trace/trace_events_filter.c b/kernel/trace/trace_events_filter.c
index 24aee71..eb04a2a 100644
--- a/kernel/trace/trace_events_filter.c
+++ b/kernel/trace/trace_events_filter.c
@@ -900,6 +900,11 @@ int filter_assign_type(const char *type)
 	return FILTER_OTHER;
 }
 
+static bool is_function_field(struct ftrace_event_field *field)
+{
+	return field->filter_type == FILTER_TRACE_FN;
+}
+
 static bool is_string_field(struct ftrace_event_field *field)
 {
 	return field->filter_type == FILTER_DYN_STRING ||
@@ -987,7 +992,7 @@ static int init_pred(struct filter_parse_state *ps,
 			fn = filter_pred_strloc;
 		else
 			fn = filter_pred_pchar;
-	} else {
+	} else if (!is_function_field(field)) {
 		if (field->is_signed)
 			ret = strict_strtoll(pred->regex.pattern, 0, &val);
 		else
diff --git a/kernel/trace/trace_export.c b/kernel/trace/trace_export.c
index 867653c..46c35e2 100644
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
+				 0, is_signed_type(type), filter_type);\
 	if (ret)							\
 		return ret;
 
+#define FILTER_TYPE_TRACE_FN           FILTER_TRACE_FN
+#define FILTER_TYPE_TRACE_GRAPH_ENT    FILTER_OTHER
+#define FILTER_TYPE_TRACE_GRAPH_RET    FILTER_OTHER
+#define FILTER_TYPE_TRACE_CTX          FILTER_OTHER
+#define FILTER_TYPE_TRACE_WAKE         FILTER_OTHER
+#define FILTER_TYPE_TRACE_STACK                FILTER_OTHER
+#define FILTER_TYPE_TRACE_USER_STACK   FILTER_OTHER
+#define FILTER_TYPE_TRACE_BPRINT       FILTER_OTHER
+#define FILTER_TYPE_TRACE_PRINT                FILTER_OTHER
+#define FILTER_TYPE_TRACE_MMIO_RW      FILTER_OTHER
+#define FILTER_TYPE_TRACE_MMIO_MAP     FILTER_OTHER
+#define FILTER_TYPE_TRACE_BRANCH       FILTER_OTHER
+#define FILTER_TYPE(arg)               FILTER_TYPE_##arg
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
-- 
1.7.1

