Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753828Ab0F2DLs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jun 2010 23:11:48 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:47269 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753230Ab0F2DKr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jun 2010 23:10:47 -0400
X-Authority-Analysis: v=1.1 cv=hVjE12FRt4v4sD2HVuppbi620CRC5en4UNTr7KPd1ng= c=1 sm=0 a=qDim2ODCznUA:10 a=yQWWgrYGNuUA:10 a=GzHTLUccyWwA:10 a=gMqfjgEr1zLu/65IO0LwxA==:17 a=omOdbC7AAAAA:8 a=meVymXHHAAAA:8 a=5jufeMnQdlb9OGeKkMwA:9 a=bYQTyiJwAjKS_BZpZxEA:7 a=ft-7fl4Zji7q1mKd3ubpGOiC-UYA:4 a=jeBq3FmKZ4MA:10 a=gMqfjgEr1zLu/65IO0LwxA==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.89.75
Message-Id: <20100629031044.409356329@goodmis.org>
User-Agent: quilt/0.48-1
Date: Mon, 28 Jun 2010 23:08:43 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Li Zefan <lizf@cn.fujitsu.com>
Subject: [PATCH 7/9] tracing: Remove open-coded __trace_add_event_call()
References: <20100629030836.222433712@goodmis.org>
Content-Disposition: inline; filename=0007-tracing-Remove-open-coded-__trace_add_event_call.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Li Zefan <lizf@cn.fujitsu.com>

Let trace_module_add_events() and event_trace_init() call
__trace_add_event_call().

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
LKML-Reference: <4BFA37E9.1020106@cn.fujitsu.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/trace_events.c |   70 +++++++++++-------------------------------
 1 files changed, 19 insertions(+), 51 deletions(-)

diff --git a/kernel/trace/trace_events.c b/kernel/trace/trace_events.c
index 5bad9cb..69bee4c 100644
--- a/kernel/trace/trace_events.c
+++ b/kernel/trace/trace_events.c
@@ -1009,11 +1009,17 @@ event_create_dir(struct ftrace_event_call *call, struct dentry *d_events,
 	return 0;
 }
 
-static int __trace_add_event_call(struct ftrace_event_call *call)
+static int
+__trace_add_event_call(struct ftrace_event_call *call, struct module *mod,
+		       const struct file_operations *id,
+		       const struct file_operations *enable,
+		       const struct file_operations *filter,
+		       const struct file_operations *format)
 {
 	struct dentry *d_events;
 	int ret;
 
+	/* The linker may leave blanks */
 	if (!call->name)
 		return -EINVAL;
 
@@ -1021,8 +1027,8 @@ static int __trace_add_event_call(struct ftrace_event_call *call)
 		ret = call->class->raw_init(call);
 		if (ret < 0) {
 			if (ret != -ENOSYS)
-				pr_warning("Could not initialize trace "
-				"events/%s\n", call->name);
+				pr_warning("Could not initialize trace events/%s\n",
+					   call->name);
 			return ret;
 		}
 	}
@@ -1031,11 +1037,10 @@ static int __trace_add_event_call(struct ftrace_event_call *call)
 	if (!d_events)
 		return -ENOENT;
 
-	ret = event_create_dir(call, d_events, &ftrace_event_id_fops,
-				&ftrace_enable_fops, &ftrace_event_filter_fops,
-				&ftrace_event_format_fops);
+	ret = event_create_dir(call, d_events, id, enable, filter, format);
 	if (!ret)
 		list_add(&call->list, &ftrace_events);
+	call->mod = mod;
 
 	return ret;
 }
@@ -1045,7 +1050,10 @@ int trace_add_event_call(struct ftrace_event_call *call)
 {
 	int ret;
 	mutex_lock(&event_mutex);
-	ret = __trace_add_event_call(call);
+	ret = __trace_add_event_call(call, NULL, &ftrace_event_id_fops,
+				     &ftrace_enable_fops,
+				     &ftrace_event_filter_fops,
+				     &ftrace_event_format_fops);
 	mutex_unlock(&event_mutex);
 	return ret;
 }
@@ -1162,8 +1170,6 @@ static void trace_module_add_events(struct module *mod)
 {
 	struct ftrace_module_file_ops *file_ops = NULL;
 	struct ftrace_event_call *call, *start, *end;
-	struct dentry *d_events;
-	int ret;
 
 	start = mod->trace_events;
 	end = mod->trace_events + mod->num_trace_events;
@@ -1171,38 +1177,14 @@ static void trace_module_add_events(struct module *mod)
 	if (start == end)
 		return;
 
-	d_events = event_trace_events_dir();
-	if (!d_events)
+	file_ops = trace_create_file_ops(mod);
+	if (!file_ops)
 		return;
 
 	for_each_event(call, start, end) {
-		/* The linker may leave blanks */
-		if (!call->name)
-			continue;
-		if (call->class->raw_init) {
-			ret = call->class->raw_init(call);
-			if (ret < 0) {
-				if (ret != -ENOSYS)
-					pr_warning("Could not initialize trace "
-					"point events/%s\n", call->name);
-				continue;
-			}
-		}
-		/*
-		 * This module has events, create file ops for this module
-		 * if not already done.
-		 */
-		if (!file_ops) {
-			file_ops = trace_create_file_ops(mod);
-			if (!file_ops)
-				return;
-		}
-		call->mod = mod;
-		ret = event_create_dir(call, d_events,
+		__trace_add_event_call(call, mod,
 				       &file_ops->id, &file_ops->enable,
 				       &file_ops->filter, &file_ops->format);
-		if (!ret)
-			list_add(&call->list, &ftrace_events);
 	}
 }
 
@@ -1333,24 +1315,10 @@ static __init int event_trace_init(void)
 		pr_warning("tracing: Failed to allocate common fields");
 
 	for_each_event(call, __start_ftrace_events, __stop_ftrace_events) {
-		/* The linker may leave blanks */
-		if (!call->name)
-			continue;
-		if (call->class->raw_init) {
-			ret = call->class->raw_init(call);
-			if (ret < 0) {
-				if (ret != -ENOSYS)
-					pr_warning("Could not initialize trace "
-					"point events/%s\n", call->name);
-				continue;
-			}
-		}
-		ret = event_create_dir(call, d_events, &ftrace_event_id_fops,
+		__trace_add_event_call(call, NULL, &ftrace_event_id_fops,
 				       &ftrace_enable_fops,
 				       &ftrace_event_filter_fops,
 				       &ftrace_event_format_fops);
-		if (!ret)
-			list_add(&call->list, &ftrace_events);
 	}
 
 	while (true) {
-- 
1.7.1


