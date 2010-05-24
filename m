Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756814Ab0EXIW4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 May 2010 04:22:56 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:62810 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753783Ab0EXIWy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 May 2010 04:22:54 -0400
Message-ID: <4BFA37E9.1020106@cn.fujitsu.com>
Date: Mon, 24 May 2010 16:25:13 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 8/8] tracing: Remove open-coded __trace_add_event_call()
References: <4BFA3728.3000701@cn.fujitsu.com>
In-Reply-To: <4BFA3728.3000701@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Let trace_module_add_events() and event_trace_init() call
__trace_add_event_call().

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
---
 kernel/trace/trace_events.c |   70 +++++++++++-------------------------------
 1 files changed, 19 insertions(+), 51 deletions(-)

diff --git a/kernel/trace/trace_events.c b/kernel/trace/trace_events.c
index b5d5b73..f4dbce1 100644
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
1.6.3

