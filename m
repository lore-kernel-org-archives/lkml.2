Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754857Ab0F2JYI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jun 2010 05:24:08 -0400
Received: from hera.kernel.org ([140.211.167.34]:39212 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754191Ab0F2JYC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jun 2010 05:24:02 -0400
Date: Tue, 29 Jun 2010 09:23:40 GMT
From: tip-bot for Li Zefan <lizf@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       rostedt@goodmis.org, lizf@cn.fujitsu.com, tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       lizf@cn.fujitsu.com, rostedt@goodmis.org, tglx@linutronix.de
In-Reply-To: <4BFA37E9.1020106@cn.fujitsu.com>
References: <4BFA37E9.1020106@cn.fujitsu.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] tracing: Remove open-coded __trace_add_event_call()
Message-ID: <tip-67ead0a6ceb001b4cb891d782e440f0e79493ba2@git.kernel.org>
Git-Commit-ID: 67ead0a6ceb001b4cb891d782e440f0e79493ba2
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Tue, 29 Jun 2010 09:23:44 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  67ead0a6ceb001b4cb891d782e440f0e79493ba2
Gitweb:     http://git.kernel.org/tip/67ead0a6ceb001b4cb891d782e440f0e79493ba2
Author:     Li Zefan <lizf@cn.fujitsu.com>
AuthorDate: Mon, 24 May 2010 16:25:13 +0800
Committer:  Steven Rostedt <rostedt@goodmis.org>
CommitDate: Mon, 28 Jun 2010 17:12:55 -0400

tracing: Remove open-coded __trace_add_event_call()

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
