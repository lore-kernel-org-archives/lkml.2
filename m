Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755337Ab2HOPUo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2012 11:20:44 -0400
Received: from mail-gg0-f174.google.com ([209.85.161.174]:35556 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753704Ab2HOPUl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2012 11:20:41 -0400
From: Ezequiel Garcia <elezegarcia@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>, <linux-kernel@vger.kernel.org>
Cc: Pekka Enberg <penberg@kernel.org>, tim.bird@am.sony.com,
        lizefan@huawei.com, Ezequiel Garcia <elezegarcia@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>
Subject: [RFC PATCH 1/1] trace: Move trace event enable from fs_initcall to early_initcall
Date: Wed, 15 Aug 2012 12:18:27 -0300
Message-Id: <1345043907-18299-1-git-send-email-elezegarcia@gmail.com>
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

Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@redhat.com>
Signed-off-by: Ezequiel Garcia <elezegarcia@gmail.com>
---
 kernel/trace/trace_events.c |   71 ++++++++++++++++++++++++++++++++-----------
 1 files changed, 53 insertions(+), 18 deletions(-)

diff --git a/kernel/trace/trace_events.c b/kernel/trace/trace_events.c
index 29111da..3055bc9 100644
--- a/kernel/trace/trace_events.c
+++ b/kernel/trace/trace_events.c
@@ -1450,6 +1450,49 @@ static __init int setup_trace_event(char *str)
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
+
+		/* The linker may leave blanks */
+		if (!call->name)
+			continue;
+
+		if (!call->class->raw_init)
+			continue;
+
+		ret = call->class->raw_init(call);
+		if (ret < 0) {
+			if (ret != -ENOSYS)
+				pr_warning("Could not initialize trace events/%s\n",
+						call->name);
+			continue;
+		}
+		list_add(&call->list, &ftrace_events);
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
+			pr_warning("Failed to enable trace event: %s\n", token);
+	}
+	return 0;
+}
+
 static __init int event_trace_init(void)
 {
 	struct ftrace_event_call **call;
@@ -1457,8 +1500,6 @@ static __init int event_trace_init(void)
 	struct dentry *entry;
 	struct dentry *d_events;
 	int ret;
-	char *buf = bootup_event_buf;
-	char *token;
 
 	d_tracer = tracing_init_dentry();
 	if (!d_tracer)
@@ -1497,24 +1538,17 @@ static __init int event_trace_init(void)
 	if (trace_define_common_fields())
 		pr_warning("tracing: Failed to allocate common fields");
 
+	/*
+	 * Early initialization already enabled ftrace event.
+	 * Now it's only necessary to create the event directory.
+	 */
 	for_each_event(call, __start_ftrace_events, __stop_ftrace_events) {
-		__trace_add_event_call(*call, NULL, &ftrace_event_id_fops,
-				       &ftrace_enable_fops,
-				       &ftrace_event_filter_fops,
-				       &ftrace_event_format_fops);
-	}
-
-	while (true) {
-		token = strsep(&buf, ",");
-
-		if (!token)
-			break;
-		if (!*token)
-			continue;
 
-		ret = ftrace_set_clr_event(token, 1);
-		if (ret)
-			pr_warning("Failed to enable trace event: %s\n", token);
+		event_create_dir(*call, d_events,
+				 &ftrace_event_id_fops,
+				 &ftrace_enable_fops,
+				 &ftrace_event_filter_fops,
+				 &ftrace_event_format_fops);
 	}
 
 	ret = register_module_notifier(&trace_module_nb);
@@ -1523,6 +1557,7 @@ static __init int event_trace_init(void)
 
 	return 0;
 }
+early_initcall(event_trace_enable);
 fs_initcall(event_trace_init);
 
 #ifdef CONFIG_FTRACE_STARTUP_TEST
-- 
1.7.8.6

