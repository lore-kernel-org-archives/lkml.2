Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757179Ab0EZULs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 May 2010 16:11:48 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:56938 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752795Ab0EZULn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 May 2010 16:11:43 -0400
X-Authority-Analysis: v=1.1 cv=muTmBHIsIIrvj5np50lvqqEF3x9MmSj/zDSU9q1ni6E= c=1 sm=0 a=DCbEiKiKWNoA:10 a=1CvaPgNKC-EA:10 a=GzHTLUccyWwA:10 a=gMqfjgEr1zLu/65IO0LwxA==:17 a=omOdbC7AAAAA:8 a=meVymXHHAAAA:8 a=RJRfROfsBm-YRHWv2s4A:9 a=wgxL-MbnI8c7QK60T6oA:7 a=Zquu_Kzzt_1T7wxLR7vT53n8I9QA:4 a=jeBq3FmKZ4MA:10 a=gMqfjgEr1zLu/65IO0LwxA==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.89.75
Message-Id: <20100526201141.021346784@goodmis.org>
User-Agent: quilt/0.48-1
Date: Wed, 26 May 2010 16:10:38 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Li Zefan <lizf@cn.fujitsu.com>
Subject: [PATCH 2/7] tracing: Dont allocate common fields for every trace events
References: <20100526201036.951395509@goodmis.org>
Content-Disposition: inline; filename=0002-tracing-Don-t-allocate-common-fields-for-every-trace.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Li Zefan <lizf@cn.fujitsu.com>

Every event has the same common fields, so it's a big waste of
memory to have a copy of those fields for every event.

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
LKML-Reference: <4BFA3759.30105@cn.fujitsu.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/trace.h               |    2 +
 kernel/trace/trace_events.c        |  113 ++++++++++++++++++++----------------
 kernel/trace/trace_events_filter.c |   18 +++++-
 3 files changed, 81 insertions(+), 52 deletions(-)

diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
index 2cd9639..0a91ab0 100644
--- a/kernel/trace/trace.h
+++ b/kernel/trace/trace.h
@@ -766,6 +766,8 @@ struct filter_pred {
 	int 			pop_n;
 };
 
+extern struct list_head ftrace_common_fields;
+
 extern enum regex_type
 filter_parse_regex(char *buff, int len, char **search, int *not);
 extern void print_event_filter(struct ftrace_event_call *call,
diff --git a/kernel/trace/trace_events.c b/kernel/trace/trace_events.c
index 53cffc0..efe1ffd 100644
--- a/kernel/trace/trace_events.c
+++ b/kernel/trace/trace_events.c
@@ -28,6 +28,7 @@
 DEFINE_MUTEX(event_mutex);
 
 LIST_HEAD(ftrace_events);
+LIST_HEAD(ftrace_common_fields);
 
 struct list_head *
 trace_get_fields(struct ftrace_event_call *event_call)
@@ -37,15 +38,11 @@ trace_get_fields(struct ftrace_event_call *event_call)
 	return event_call->class->get_fields(event_call);
 }
 
-int trace_define_field(struct ftrace_event_call *call, const char *type,
-		       const char *name, int offset, int size, int is_signed,
-		       int filter_type)
+static int __trace_define_field(struct list_head *head, const char *type,
+				const char *name, int offset, int size,
+				int is_signed, int filter_type)
 {
 	struct ftrace_event_field *field;
-	struct list_head *head;
-
-	if (WARN_ON(!call->class))
-		return 0;
 
 	field = kzalloc(sizeof(*field), GFP_KERNEL);
 	if (!field)
@@ -68,7 +65,6 @@ int trace_define_field(struct ftrace_event_call *call, const char *type,
 	field->size = size;
 	field->is_signed = is_signed;
 
-	head = trace_get_fields(call);
 	list_add(&field->link, head);
 
 	return 0;
@@ -80,17 +76,32 @@ err:
 
 	return -ENOMEM;
 }
+
+int trace_define_field(struct ftrace_event_call *call, const char *type,
+		       const char *name, int offset, int size, int is_signed,
+		       int filter_type)
+{
+	struct list_head *head;
+
+	if (WARN_ON(!call->class))
+		return 0;
+
+	head = trace_get_fields(call);
+	return __trace_define_field(head, type, name, offset, size,
+				    is_signed, filter_type);
+}
 EXPORT_SYMBOL_GPL(trace_define_field);
 
 #define __common_field(type, item)					\
-	ret = trace_define_field(call, #type, "common_" #item,		\
-				 offsetof(typeof(ent), item),		\
-				 sizeof(ent.item),			\
-				 is_signed_type(type), FILTER_OTHER);	\
+	ret = __trace_define_field(&ftrace_common_fields, #type,	\
+				   "common_" #item,			\
+				   offsetof(typeof(ent), item),		\
+				   sizeof(ent.item),			\
+				   is_signed_type(type), FILTER_OTHER);	\
 	if (ret)							\
 		return ret;
 
-static int trace_define_common_fields(struct ftrace_event_call *call)
+static int trace_define_common_fields(void)
 {
 	int ret;
 	struct trace_entry ent;
@@ -544,32 +555,10 @@ out:
 	return ret;
 }
 
-static ssize_t
-event_format_read(struct file *filp, char __user *ubuf, size_t cnt,
-		  loff_t *ppos)
+static void print_event_fields(struct trace_seq *s, struct list_head *head)
 {
-	struct ftrace_event_call *call = filp->private_data;
 	struct ftrace_event_field *field;
-	struct list_head *head;
-	struct trace_seq *s;
-	int common_field_count = 5;
-	char *buf;
-	int r = 0;
-
-	if (*ppos)
-		return 0;
-
-	s = kmalloc(sizeof(*s), GFP_KERNEL);
-	if (!s)
-		return -ENOMEM;
-
-	trace_seq_init(s);
 
-	trace_seq_printf(s, "name: %s\n", call->name);
-	trace_seq_printf(s, "ID: %d\n", call->event.type);
-	trace_seq_printf(s, "format:\n");
-
-	head = trace_get_fields(call);
 	list_for_each_entry_reverse(field, head, link) {
 		/*
 		 * Smartly shows the array type(except dynamic array).
@@ -584,29 +573,54 @@ event_format_read(struct file *filp, char __user *ubuf, size_t cnt,
 			array_descriptor = NULL;
 
 		if (!array_descriptor) {
-			r = trace_seq_printf(s, "\tfield:%s %s;\toffset:%u;"
+			trace_seq_printf(s, "\tfield:%s %s;\toffset:%u;"
 					"\tsize:%u;\tsigned:%d;\n",
 					field->type, field->name, field->offset,
 					field->size, !!field->is_signed);
 		} else {
-			r = trace_seq_printf(s, "\tfield:%.*s %s%s;\toffset:%u;"
+			trace_seq_printf(s, "\tfield:%.*s %s%s;\toffset:%u;"
 					"\tsize:%u;\tsigned:%d;\n",
 					(int)(array_descriptor - field->type),
 					field->type, field->name,
 					array_descriptor, field->offset,
 					field->size, !!field->is_signed);
 		}
+	}
+}
 
-		if (--common_field_count == 0)
-			r = trace_seq_printf(s, "\n");
+static ssize_t
+event_format_read(struct file *filp, char __user *ubuf, size_t cnt,
+		  loff_t *ppos)
+{
+	struct ftrace_event_call *call = filp->private_data;
+	struct list_head *head;
+	struct trace_seq *s;
+	char *buf;
+	int r;
 
-		if (!r)
-			break;
-	}
+	if (*ppos)
+		return 0;
 
-	if (r)
-		r = trace_seq_printf(s, "\nprint fmt: %s\n",
-				call->print_fmt);
+	s = kmalloc(sizeof(*s), GFP_KERNEL);
+	if (!s)
+		return -ENOMEM;
+
+	trace_seq_init(s);
+
+	trace_seq_printf(s, "name: %s\n", call->name);
+	trace_seq_printf(s, "ID: %d\n", call->event.type);
+	trace_seq_printf(s, "format:\n");
+
+	/* print common fields */
+	print_event_fields(s, &ftrace_common_fields);
+
+	trace_seq_putc(s, '\n');
+
+	/* print event specific fields */
+	head = trace_get_fields(call);
+	print_event_fields(s, head);
+
+	r = trace_seq_printf(s, "\nprint fmt: %s\n", call->print_fmt);
 
 	if (!r) {
 		/*
@@ -980,9 +994,7 @@ event_create_dir(struct ftrace_event_call *call, struct dentry *d_events,
 		 */
 		head = trace_get_fields(call);
 		if (list_empty(head)) {
-			ret = trace_define_common_fields(call);
-			if (!ret)
-				ret = call->class->define_fields(call);
+			ret = call->class->define_fields(call);
 			if (ret < 0) {
 				pr_warning("Could not initialize trace point"
 					   " events/%s\n", call->name);
@@ -1319,6 +1331,9 @@ static __init int event_trace_init(void)
 	trace_create_file("enable", 0644, d_events,
 			  NULL, &ftrace_system_enable_fops);
 
+	if (trace_define_common_fields())
+		pr_warning("tracing: Failed to allocate common fields");
+
 	for_each_event(call, __start_ftrace_events, __stop_ftrace_events) {
 		/* The linker may leave blanks */
 		if (!call->name)
diff --git a/kernel/trace/trace_events_filter.c b/kernel/trace/trace_events_filter.c
index 57bb1bb..330fefd 100644
--- a/kernel/trace/trace_events_filter.c
+++ b/kernel/trace/trace_events_filter.c
@@ -497,12 +497,10 @@ void print_subsystem_event_filter(struct event_subsystem *system,
 }
 
 static struct ftrace_event_field *
-find_event_field(struct ftrace_event_call *call, char *name)
+__find_event_field(struct list_head *head, char *name)
 {
 	struct ftrace_event_field *field;
-	struct list_head *head;
 
-	head = trace_get_fields(call);
 	list_for_each_entry(field, head, link) {
 		if (!strcmp(field->name, name))
 			return field;
@@ -511,6 +509,20 @@ find_event_field(struct ftrace_event_call *call, char *name)
 	return NULL;
 }
 
+static struct ftrace_event_field *
+find_event_field(struct ftrace_event_call *call, char *name)
+{
+	struct ftrace_event_field *field;
+	struct list_head *head;
+
+	field = __find_event_field(&ftrace_common_fields, name);
+	if (field)
+		return field;
+
+	head = trace_get_fields(call);
+	return __find_event_field(head, name);
+}
+
 static void filter_free_pred(struct filter_pred *pred)
 {
 	if (!pred)
-- 
1.7.0


