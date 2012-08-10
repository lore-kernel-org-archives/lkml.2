Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760334Ab2HJDsk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2012 23:48:40 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:14202 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756133Ab2HJDrJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2012 23:47:09 -0400
X-Authority-Analysis: v=2.0 cv=Vb91zSV9 c=1 sm=0 a=s5Htg7xnQOKvHEu9STBOug==:17 a=OpT9cpI26MMA:10 a=Ciwy3NGCPMMA:10 a=GKb4GPu2lTwA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=20KFwNOVAAAA:8 a=e0bjzelqPdkR_-lHGjgA:9 a=jEp0ucaQiEUA:10 a=jeBq3FmKZ4MA:10 a=s5Htg7xnQOKvHEu9STBOug==:117
X-Cloudmark-Score: 0
X-Originating-IP: 72.230.195.127
Message-Id: <20120810034708.084036335@goodmis.org>
User-Agent: quilt/0.60-1
Date: Thu, 09 Aug 2012 23:43:04 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: [RFC][PATCH 2/4] tracing: Move event storage for array from macro to standalone
 function
References: <20120810034302.758092203@goodmis.org>
Content-Disposition: inline; filename=0002-tracing-Move-event-storage-for-array-from-macro-to-s.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

The code that shows array fields for events is defined for all events.
This can add up quite a bit when you have over 700 events.

By making helper functions in the core kernel to do the work
instead, we can shrink the size of the kernel down a little.

With a kernel configured with 707 events, the change in size was:

   text    data     bss     dec     hex filename
19994715        2594648 1945600 24534963        1765fb3 vmlinux-before
19991705        2594648 1945600 24531953        17653f1 vmlinux-after

That's a total of 3010 bytes, which comes down to 4 bytes per event.
Although it's not much, this code is just called at initialization.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 include/linux/ftrace_event.h |    8 ++++----
 include/trace/ftrace.h       |   12 ++++--------
 kernel/trace/trace_events.c  |    6 ------
 kernel/trace/trace_export.c  |   12 ++++--------
 kernel/trace/trace_output.c  |   20 ++++++++++++++++++++
 5 files changed, 32 insertions(+), 26 deletions(-)

diff --git a/include/linux/ftrace_event.h b/include/linux/ftrace_event.h
index 56d1e53..22f5fec 100644
--- a/include/linux/ftrace_event.h
+++ b/include/linux/ftrace_event.h
@@ -144,6 +144,10 @@ int ftrace_output_event(struct trace_iterator *iter, struct ftrace_event_call *e
 
 int ftrace_output_call(struct trace_iterator *iter, char *name, char *fmt, ...);
 
+int ftrace_event_define_field(struct ftrace_event_call *call,
+			      char *type, int len, char *item, int offset,
+			      int field_size, int sign, int filter);
+
 struct event_filter;
 
 enum trace_reg {
@@ -260,10 +264,6 @@ enum {
 	FILTER_TRACE_FN,
 };
 
-#define EVENT_STORAGE_SIZE 128
-extern struct mutex event_storage_mutex;
-extern char event_storage[EVENT_STORAGE_SIZE];
-
 extern int trace_event_raw_init(struct ftrace_event_call *call);
 extern int trace_define_field(struct ftrace_event_call *call, const char *type,
 			      const char *name, int offset, int size,
diff --git a/include/trace/ftrace.h b/include/trace/ftrace.h
index cb85747..95d6704 100644
--- a/include/trace/ftrace.h
+++ b/include/trace/ftrace.h
@@ -293,15 +293,11 @@ static struct trace_event_functions ftrace_event_type_funcs_##call = {	\
 #undef __array
 #define __array(type, item, len)					\
 	do {								\
-		mutex_lock(&event_storage_mutex);			\
 		BUILD_BUG_ON(len > MAX_FILTER_STR_VAL);			\
-		snprintf(event_storage, sizeof(event_storage),		\
-			 "%s[%d]", #type, len);				\
-		ret = trace_define_field(event_call, event_storage, #item, \
-				 offsetof(typeof(field), item),		\
-				 sizeof(field.item),			\
-				 is_signed_type(type), FILTER_OTHER);	\
-		mutex_unlock(&event_storage_mutex);			\
+		ret = ftrace_event_define_field(event_call, #type, len,	\
+				#item, offsetof(typeof(field), item),   \
+				sizeof(field.item),			\
+			 	is_signed_type(type), FILTER_OTHER); \
 		if (ret)						\
 			return ret;					\
 	} while (0);
diff --git a/kernel/trace/trace_events.c b/kernel/trace/trace_events.c
index 6825d83..5c5dc1f 100644
--- a/kernel/trace/trace_events.c
+++ b/kernel/trace/trace_events.c
@@ -27,12 +27,6 @@
 
 DEFINE_MUTEX(event_mutex);
 
-DEFINE_MUTEX(event_storage_mutex);
-EXPORT_SYMBOL_GPL(event_storage_mutex);
-
-char event_storage[EVENT_STORAGE_SIZE];
-EXPORT_SYMBOL_GPL(event_storage);
-
 LIST_HEAD(ftrace_events);
 LIST_HEAD(ftrace_common_fields);
 
diff --git a/kernel/trace/trace_export.c b/kernel/trace/trace_export.c
index e039906..f837e35 100644
--- a/kernel/trace/trace_export.c
+++ b/kernel/trace/trace_export.c
@@ -96,14 +96,10 @@ static void __always_unused ____ftrace_check_##name(void)		\
 #define __array(type, item, len)					\
 	do {								\
 		BUILD_BUG_ON(len > MAX_FILTER_STR_VAL);			\
-		mutex_lock(&event_storage_mutex);			\
-		snprintf(event_storage, sizeof(event_storage),		\
-			 "%s[%d]", #type, len);				\
-		ret = trace_define_field(event_call, event_storage, #item, \
-				 offsetof(typeof(field), item),		\
-				 sizeof(field.item),			\
-				 is_signed_type(type), filter_type);	\
-		mutex_unlock(&event_storage_mutex);			\
+		ret = ftrace_event_define_field(event_call, #type, len,	\
+				#item, offsetof(typeof(field), item),   \
+				sizeof(field.item),			\
+			 	is_signed_type(type), filter_type);	\
 		if (ret)						\
 			return ret;					\
 	} while (0);
diff --git a/kernel/trace/trace_output.c b/kernel/trace/trace_output.c
index b927f45..06f27ab 100644
--- a/kernel/trace/trace_output.c
+++ b/kernel/trace/trace_output.c
@@ -20,6 +20,10 @@ static struct hlist_head event_hash[EVENT_HASHSIZE] __read_mostly;
 
 static int next_event_type = __TRACE_LAST_TYPE + 1;
 
+#define EVENT_STORAGE_SIZE 128
+static DEFINE_MUTEX(event_storage_mutex);
+static char event_storage[EVENT_STORAGE_SIZE];
+
 int trace_print_seq(struct seq_file *m, struct trace_seq *s)
 {
 	int len = s->len >= PAGE_SIZE ? PAGE_SIZE - 1 : s->len;
@@ -441,6 +445,22 @@ int ftrace_output_event(struct trace_iterator *iter, struct ftrace_event_call *e
 }
 EXPORT_SYMBOL_GPL(ftrace_output_event);
 
+int ftrace_event_define_field(struct ftrace_event_call *call,
+			      char *type, int len, char *item, int offset,
+			      int field_size, int sign, int filter)
+{
+	int ret;
+
+	mutex_lock(&event_storage_mutex);
+	snprintf(event_storage, sizeof(event_storage),
+		 "%s[%d]", type, len);
+	ret = trace_define_field(call, event_storage, item, offset,
+				 field_size, sign, filter);
+	mutex_unlock(&event_storage_mutex);
+
+	return ret;
+}
+
 #ifdef CONFIG_KRETPROBES
 static inline const char *kretprobed(const char *name)
 {
-- 
1.7.10.4


