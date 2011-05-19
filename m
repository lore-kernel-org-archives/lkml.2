Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932247Ab1ESCOv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 May 2011 22:14:51 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:48926 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756019Ab1ESCM5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 May 2011 22:12:57 -0400
X-Authority-Analysis: v=1.1 cv=NmbQexcdgr4rtO3OwYGrP5Q3rTMpacrTPhuaXkv4uP8= c=1 sm=0 a=vhdKIqpQuCYA:10 a=x6KSG09zUXMA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=20KFwNOVAAAA:8 a=meVymXHHAAAA:8 a=XvmY4zP1pyBlY3_fnRIA:9 a=g7NeYGFmlUwW5WA1RJYA:7 a=jEp0ucaQiEUA:10 a=jeBq3FmKZ4MA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Message-Id: <20110519021256.229981824@goodmis.org>
User-Agent: quilt/0.48-1
Date: Wed, 18 May 2011 22:11:58 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>
Subject: [PATCH 07/13] ftrace: Add ops parameter to ftrace_startup/shutdown functions
References: <20110519021151.600991800@goodmis.org>
Content-Disposition: inline; filename=0007-ftrace-Add-ops-parameter-to-ftrace_startup-shutdown-.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

In order to allow different ops to enable different functions,
the ftrace_startup() and ftrace_shutdown() functions need the
ops parameter passed to them.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/ftrace.c |   28 ++++++++++++++--------------
 1 files changed, 14 insertions(+), 14 deletions(-)

diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index 065f1e6..8fef1d9 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -1522,10 +1522,8 @@ static void ftrace_startup_enable(int command)
 	ftrace_run_update_code(command);
 }
 
-static void ftrace_startup(int command)
+static void ftrace_startup(struct ftrace_ops *ops, int command)
 {
-	struct ftrace_ops *ops = &global_ops;
-
 	if (unlikely(ftrace_disabled))
 		return;
 
@@ -1539,10 +1537,8 @@ static void ftrace_startup(int command)
 	ftrace_startup_enable(command);
 }
 
-static void ftrace_shutdown(int command)
+static void ftrace_shutdown(struct ftrace_ops *ops, int command)
 {
-	struct ftrace_ops *ops = &global_ops;
-
 	if (unlikely(ftrace_disabled))
 		return;
 
@@ -2362,7 +2358,7 @@ static void __enable_ftrace_function_probe(void)
 		return;
 
 	__register_ftrace_function(&trace_probe_ops);
-	ftrace_startup(0);
+	ftrace_startup(&global_ops, 0);
 	ftrace_probe_registered = 1;
 }
 
@@ -2381,7 +2377,7 @@ static void __disable_ftrace_function_probe(void)
 
 	/* no more funcs left */
 	__unregister_ftrace_function(&trace_probe_ops);
-	ftrace_shutdown(0);
+	ftrace_shutdown(&global_ops, 0);
 	ftrace_probe_registered = 0;
 }
 
@@ -3267,6 +3263,10 @@ void __init ftrace_init(void)
 
 #else
 
+struct ftrace_ops global_ops = {
+	.func			= ftrace_stub,
+};
+
 static int __init ftrace_nodyn_init(void)
 {
 	ftrace_enabled = 1;
@@ -3277,8 +3277,8 @@ device_initcall(ftrace_nodyn_init);
 static inline int ftrace_init_dyn_debugfs(struct dentry *d_tracer) { return 0; }
 static inline void ftrace_startup_enable(int command) { }
 /* Keep as macros so we do not need to define the commands */
-# define ftrace_startup(command)	do { } while (0)
-# define ftrace_shutdown(command)	do { } while (0)
+# define ftrace_startup(ops, command)	do { } while (0)
+# define ftrace_shutdown(ops, command)	do { } while (0)
 # define ftrace_startup_sysctl()	do { } while (0)
 # define ftrace_shutdown_sysctl()	do { } while (0)
 #endif /* CONFIG_DYNAMIC_FTRACE */
@@ -3583,7 +3583,7 @@ int register_ftrace_function(struct ftrace_ops *ops)
 		goto out_unlock;
 
 	ret = __register_ftrace_function(ops);
-	ftrace_startup(0);
+	ftrace_startup(&global_ops, 0);
 
  out_unlock:
 	mutex_unlock(&ftrace_lock);
@@ -3602,7 +3602,7 @@ int unregister_ftrace_function(struct ftrace_ops *ops)
 
 	mutex_lock(&ftrace_lock);
 	ret = __unregister_ftrace_function(ops);
-	ftrace_shutdown(0);
+	ftrace_shutdown(&global_ops, 0);
 	mutex_unlock(&ftrace_lock);
 
 	return ret;
@@ -3825,7 +3825,7 @@ int register_ftrace_graph(trace_func_graph_ret_t retfunc,
 	ftrace_graph_return = retfunc;
 	ftrace_graph_entry = entryfunc;
 
-	ftrace_startup(FTRACE_START_FUNC_RET);
+	ftrace_startup(&global_ops, FTRACE_START_FUNC_RET);
 
 out:
 	mutex_unlock(&ftrace_lock);
@@ -3842,7 +3842,7 @@ void unregister_ftrace_graph(void)
 	ftrace_graph_active--;
 	ftrace_graph_return = (trace_func_graph_ret_t)ftrace_stub;
 	ftrace_graph_entry = ftrace_graph_entry_stub;
-	ftrace_shutdown(FTRACE_STOP_FUNC_RET);
+	ftrace_shutdown(&global_ops, FTRACE_STOP_FUNC_RET);
 	unregister_pm_notifier(&ftrace_suspend_notifier);
 	unregister_trace_sched_switch(ftrace_graph_probe_sched_switch, NULL);
 
-- 
1.7.4.4


