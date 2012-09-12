Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759613Ab2ILOsW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2012 10:48:22 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:44065 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755891Ab2ILOsT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2012 10:48:19 -0400
From: Ezequiel Garcia <elezegarcia@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>, <linux-kernel@vger.kernel.org>
Cc: Tim Bird <tim.bird@am.sony.com>, Pekka Enberg <penberg@kernel.org>,
        Ingo Molnar <mingo@redhat.com>,
        Ezequiel Garcia <elezegarcia@gmail.com>
Subject: [PATCH v4] trace: Move trace event enable from fs_initcall to core_initcall
Date: Wed, 12 Sep 2012 11:47:57 -0300
Message-Id: <1347461277-25302-1-git-send-email-elezegarcia@gmail.com>
X-Mailer: git-send-email 1.7.8.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch splits trace event initialization in two stages:
 * ftrace enable
 * sysfs event entry creation

This allows to capture trace events from an earlier point
by using 'trace_event' kernel parameter and is important
to trace boot-up allocations.

Note that, in order to enable events at core_initcall,
it's necessary to move init_ftrace_syscalls() from
core_initcall to early_initcall.

Cc: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Ezequiel Garcia <elezegarcia@gmail.com>
---
Changes from v1:
  * Rework code as requested by Steven.

Changes from v2:
   * Move init_ftrace_syscalls() to early_initcall,
     so syscalls self-test pass.

Changes from v3:
   * Fix issue reported by Steven:
     event_trace_init() now iterates on added events (instead of full array).
     This way we don't create an event dir for events that failed to enable.

 kernel/trace/trace_events.c   |  108 +++++++++++++++++++++++++++--------------
 kernel/trace/trace_syscalls.c |    2 +-
 2 files changed, 73 insertions(+), 37 deletions(-)

diff --git a/kernel/trace/trace_events.c b/kernel/trace/trace_events.c
index 29111da..437202d 100644
--- a/kernel/trace/trace_events.c
+++ b/kernel/trace/trace_events.c
@@ -1199,6 +1199,31 @@ event_create_dir(struct ftrace_event_call *call, struct dentry *d_events,
 	return 0;
 }
 
+static void event_remove(struct ftrace_event_call *call)
+{
+	ftrace_event_enable_disable(call, 0);
+	if (call->event.funcs)
+		__unregister_ftrace_event(&call->event);
+	list_del(&call->list);
+}
+
+static int event_init(struct ftrace_event_call *call)
+{
+	int ret = 0;
+
+	if (WARN_ON(!call->name))
+		return -EINVAL;
+
+	if (call->class->raw_init) {
+		ret = call->class->raw_init(call);
+		if (ret < 0 && ret != -ENOSYS)
+			pr_warn("Could not initialize trace events/%s\n",
+				call->name);
+	}
+
+	return ret;
+}
+
 static int
 __trace_add_event_call(struct ftrace_event_call *call, struct module *mod,
 		       const struct file_operations *id,
@@ -1209,19 +1234,9 @@ __trace_add_event_call(struct ftrace_event_call *call, struct module *mod,
 	struct dentry *d_events;
 	int ret;
 
-	/* The linker may leave blanks */
-	if (!call->name)
-		return -EINVAL;
-
-	if (call->class->raw_init) {
-		ret = call->class->raw_init(call);
-		if (ret < 0) {
-			if (ret != -ENOSYS)
-				pr_warning("Could not initialize trace events/%s\n",
-					   call->name);
-			return ret;
-		}
-	}
+	ret = event_init(call);
+	if (ret < 0)
+		return ret;
 
 	d_events = event_trace_events_dir();
 	if (!d_events)
@@ -1272,13 +1287,10 @@ static void remove_subsystem_dir(const char *name)
  */
 static void __trace_remove_event_call(struct ftrace_event_call *call)
 {
-	ftrace_event_enable_disable(call, 0);
-	if (call->event.funcs)
-		__unregister_ftrace_event(&call->event);
-	debugfs_remove_recursive(call->dir);
-	list_del(&call->list);
+	event_remove(call);
 	trace_destroy_fields(call);
 	destroy_preds(call);
+	debugfs_remove_recursive(call->dir);
 	remove_subsystem_dir(call->class->system);
 }
 
@@ -1450,15 +1462,43 @@ static __init int setup_trace_event(char *str)
 }
 __setup("trace_event=", setup_trace_event);
 
+static __init int event_trace_enable(void)
+{
+	struct ftrace_event_call **iter, *call;
+	char *buf = bootup_event_buf;
+	char *token;
+	int ret;
+
+	for_each_event(iter, __start_ftrace_events, __stop_ftrace_events) {
+
+		call = *iter;
+		ret = event_init(call);
+		if (!ret)
+			list_add(&call->list, &ftrace_events);
+	}
+
+	while (true) {
+		token = strsep(&buf, ",");
+
+		if (!token)
+			break;
+		if (!*token)
+			continue;
+
+		ret = ftrace_set_clr_event(token, 1);
+		if (ret)
+			pr_warn("Failed to enable trace event: %s\n", token);
+	}
+	return 0;
+}
+
 static __init int event_trace_init(void)
 {
-	struct ftrace_event_call **call;
+	struct ftrace_event_call *call;
 	struct dentry *d_tracer;
 	struct dentry *entry;
 	struct dentry *d_events;
 	int ret;
-	char *buf = bootup_event_buf;
-	char *token;
 
 	d_tracer = tracing_init_dentry();
 	if (!d_tracer)
@@ -1497,24 +1537,19 @@ static __init int event_trace_init(void)
 	if (trace_define_common_fields())
 		pr_warning("tracing: Failed to allocate common fields");
 
-	for_each_event(call, __start_ftrace_events, __stop_ftrace_events) {
-		__trace_add_event_call(*call, NULL, &ftrace_event_id_fops,
+	/*
+	 * Early initialization already enabled ftrace event.
+	 * Now it's only necessary to create the event directory.
+	 */
+	list_for_each_entry(call, &ftrace_events, list) {
+
+		ret = event_create_dir(call, d_events,
+				       &ftrace_event_id_fops,
 				       &ftrace_enable_fops,
 				       &ftrace_event_filter_fops,
 				       &ftrace_event_format_fops);
-	}
-
-	while (true) {
-		token = strsep(&buf, ",");
-
-		if (!token)
-			break;
-		if (!*token)
-			continue;
-
-		ret = ftrace_set_clr_event(token, 1);
-		if (ret)
-			pr_warning("Failed to enable trace event: %s\n", token);
+		if (ret < 0)
+			event_remove(call);
 	}
 
 	ret = register_module_notifier(&trace_module_nb);
@@ -1523,6 +1558,7 @@ static __init int event_trace_init(void)
 
 	return 0;
 }
+core_initcall(event_trace_enable);
 fs_initcall(event_trace_init);
 
 #ifdef CONFIG_FTRACE_STARTUP_TEST
diff --git a/kernel/trace/trace_syscalls.c b/kernel/trace/trace_syscalls.c
index 96fc733..07b4e5a 100644
--- a/kernel/trace/trace_syscalls.c
+++ b/kernel/trace/trace_syscalls.c
@@ -487,7 +487,7 @@ int __init init_ftrace_syscalls(void)
 
 	return 0;
 }
-core_initcall(init_ftrace_syscalls);
+early_initcall(init_ftrace_syscalls);
 
 #ifdef CONFIG_PERF_EVENTS
 
-- 
1.7.8.6

