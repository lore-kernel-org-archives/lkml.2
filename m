Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932745Ab0KSWLy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Nov 2010 17:11:54 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:60833 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932737Ab0KSWLv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Nov 2010 17:11:51 -0500
X-Authority-Analysis: v=1.1 cv=kXGwZUU/u1JTMRv8Axk4W0omja+vfTT+sGlOkodD8F8= c=1 sm=0 a=v0ElcNKzxhIA:10 a=bbbx4UPp9XUA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=20KFwNOVAAAA:8 a=meVymXHHAAAA:8 a=rLogI6DC0sUyjKtDrq4A:9 a=hfe9ecyzOdHrMqBjMT0HRyLjdagA:4 a=jEp0ucaQiEUA:10 a=jeBq3FmKZ4MA:10 a=unMyjGvW7dP-eZMq:21 a=0iFEhcI2_tIRA80d:21 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Message-Id: <20101119221148.584880073@goodmis.org>
User-Agent: quilt/0.48-1
Date: Fri, 19 Nov 2010 17:11:24 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 2/2] tracing/events: Show real number in array fields
References: <20101119221122.946280474@goodmis.org>
Content-Disposition: inline; filename=0002-tracing-events-Show-real-number-in-array-fields.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

Currently we have in something like the sched_switch event:

  field:char prev_comm[TASK_COMM_LEN];	offset:12;	size:16;	signed:1;

When a userspace tool such as perf tries to parse this, the
TASK_COMM_LEN is meaningless. This is done because the TRACE_EVENT() macro
simply uses a #len to show the string of the length. When the length is
an enum, we get a string that means nothing for tools.

By adding a static buffer and a mutex to protect it, we can store the
string into that buffer with snprintf and show the actual number.
Now we get:

  field:char prev_comm[16];       offset:12;      size:16;        signed:1;

Something much more useful.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 include/linux/ftrace_event.h |    4 ++++
 include/trace/ftrace.h       |   14 ++++++++++----
 kernel/trace/trace_events.c  |    6 ++++++
 kernel/trace/trace_export.c  |   14 ++++++++++----
 4 files changed, 30 insertions(+), 8 deletions(-)

diff --git a/include/linux/ftrace_event.h b/include/linux/ftrace_event.h
index 725bf6b..47e3997 100644
--- a/include/linux/ftrace_event.h
+++ b/include/linux/ftrace_event.h
@@ -225,6 +225,10 @@ enum {
 	FILTER_PTR_STRING,
 };
 
+#define EVENT_STORAGE_SIZE 128
+extern struct mutex event_storage_mutex;
+extern char event_storage[EVENT_STORAGE_SIZE];
+
 extern int trace_event_raw_init(struct ftrace_event_call *call);
 extern int trace_define_field(struct ftrace_event_call *call, const char *type,
 			      const char *name, int offset, int size,
diff --git a/include/trace/ftrace.h b/include/trace/ftrace.h
index e718a91..e16610c 100644
--- a/include/trace/ftrace.h
+++ b/include/trace/ftrace.h
@@ -296,13 +296,19 @@ static struct trace_event_functions ftrace_event_type_funcs_##call = {	\
 
 #undef __array
 #define __array(type, item, len)					\
-	BUILD_BUG_ON(len > MAX_FILTER_STR_VAL);				\
-	ret = trace_define_field(event_call, #type "[" #len "]", #item,	\
+	do {								\
+		mutex_lock(&event_storage_mutex);			\
+		BUILD_BUG_ON(len > MAX_FILTER_STR_VAL);			\
+		snprintf(event_storage, sizeof(event_storage),		\
+			 "%s[%d]", #type, len);				\
+		ret = trace_define_field(event_call, event_storage, #item, \
 				 offsetof(typeof(field), item),		\
 				 sizeof(field.item),			\
 				 is_signed_type(type), FILTER_OTHER);	\
-	if (ret)							\
-		return ret;
+		mutex_unlock(&event_storage_mutex);			\
+		if (ret)						\
+			return ret;					\
+	} while (0);
 
 #undef __dynamic_array
 #define __dynamic_array(type, item, len)				       \
diff --git a/kernel/trace/trace_events.c b/kernel/trace/trace_events.c
index 0725eea..35fde09 100644
--- a/kernel/trace/trace_events.c
+++ b/kernel/trace/trace_events.c
@@ -27,6 +27,12 @@
 
 DEFINE_MUTEX(event_mutex);
 
+DEFINE_MUTEX(event_storage_mutex);
+EXPORT_SYMBOL_GPL(event_storage_mutex);
+
+char event_storage[EVENT_STORAGE_SIZE];
+EXPORT_SYMBOL_GPL(event_storage);
+
 LIST_HEAD(ftrace_events);
 LIST_HEAD(ftrace_common_fields);
 
diff --git a/kernel/trace/trace_export.c b/kernel/trace/trace_export.c
index 4ba44de..4b74d71 100644
--- a/kernel/trace/trace_export.c
+++ b/kernel/trace/trace_export.c
@@ -83,13 +83,19 @@ static void __always_unused ____ftrace_check_##name(void)	\
 
 #undef __array
 #define __array(type, item, len)					\
-	BUILD_BUG_ON(len > MAX_FILTER_STR_VAL);				\
-	ret = trace_define_field(event_call, #type "[" #len "]", #item,	\
+	do {								\
+		BUILD_BUG_ON(len > MAX_FILTER_STR_VAL);			\
+		mutex_lock(&event_storage_mutex);			\
+		snprintf(event_storage, sizeof(event_storage),		\
+			 "%s[%d]", #type, len);				\
+		ret = trace_define_field(event_call, event_storage, #item, \
 				 offsetof(typeof(field), item),		\
 				 sizeof(field.item),			\
 				 is_signed_type(type), FILTER_OTHER);	\
-	if (ret)							\
-		return ret;
+		mutex_unlock(&event_storage_mutex);			\
+		if (ret)						\
+			return ret;					\
+	} while (0);
 
 #undef __array_desc
 #define __array_desc(type, container, item, len)			\
-- 
1.7.1


