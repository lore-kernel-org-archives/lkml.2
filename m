Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757015Ab1EXSSL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 May 2011 14:18:11 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:41014 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755736Ab1EXSRY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 May 2011 14:17:24 -0400
X-Authority-Analysis: v=1.1 cv=ou1QuR4lBR9YeJgEH9ccYmbAdaWqVVq3lOvCKJtMpGM= c=1 sm=0 a=vhdKIqpQuCYA:10 a=7k0d-ZIhJYIA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=20KFwNOVAAAA:8 a=meVymXHHAAAA:8 a=dsnFOJNUReSOVdIJBxQA:9 a=HkCJI2x4HqHXiI6saZgA:7 a=jEp0ucaQiEUA:10 a=jeBq3FmKZ4MA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Message-Id: <20110524181721.625944403@goodmis.org>
User-Agent: quilt/0.48-1
Date: Tue, 24 May 2011 14:10:42 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 10/12] ftrace: Have ftrace_startup() return failure code
References: <20110524181032.382259739@goodmis.org>
Content-Disposition: inline; filename=0010-ftrace-Have-ftrace_startup-return-failure-code.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

The register_ftrace_function() returns an error code on failure
except if the call to ftrace_startup() fails. Add a error return to
ftrace_startup() if it fails to start, allowing register_ftrace_funtion()
to return a proper error value.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/ftrace.c |   14 ++++++++------
 1 files changed, 8 insertions(+), 6 deletions(-)

diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index d017c2c..bebbc95 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -1638,12 +1638,12 @@ static void ftrace_startup_enable(int command)
 	ftrace_run_update_code(command);
 }
 
-static void ftrace_startup(struct ftrace_ops *ops, int command)
+static int ftrace_startup(struct ftrace_ops *ops, int command)
 {
 	bool hash_enable = true;
 
 	if (unlikely(ftrace_disabled))
-		return;
+		return -ENODEV;
 
 	ftrace_start_up++;
 	command |= FTRACE_ENABLE_CALLS;
@@ -1662,6 +1662,8 @@ static void ftrace_startup(struct ftrace_ops *ops, int command)
 		ftrace_hash_rec_enable(ops, 1);
 
 	ftrace_startup_enable(command);
+
+	return 0;
 }
 
 static void ftrace_shutdown(struct ftrace_ops *ops, int command)
@@ -2501,7 +2503,7 @@ static void __enable_ftrace_function_probe(void)
 
 	ret = __register_ftrace_function(&trace_probe_ops);
 	if (!ret)
-		ftrace_startup(&trace_probe_ops, 0);
+		ret = ftrace_startup(&trace_probe_ops, 0);
 
 	ftrace_probe_registered = 1;
 }
@@ -3466,7 +3468,7 @@ device_initcall(ftrace_nodyn_init);
 static inline int ftrace_init_dyn_debugfs(struct dentry *d_tracer) { return 0; }
 static inline void ftrace_startup_enable(int command) { }
 /* Keep as macros so we do not need to define the commands */
-# define ftrace_startup(ops, command)	do { } while (0)
+# define ftrace_startup(ops, command)	({0;})
 # define ftrace_shutdown(ops, command)	do { } while (0)
 # define ftrace_startup_sysctl()	do { } while (0)
 # define ftrace_shutdown_sysctl()	do { } while (0)
@@ -3799,7 +3801,7 @@ int register_ftrace_function(struct ftrace_ops *ops)
 
 	ret = __register_ftrace_function(ops);
 	if (!ret)
-		ftrace_startup(ops, 0);
+		ret = ftrace_startup(ops, 0);
 
 
  out_unlock:
@@ -4045,7 +4047,7 @@ int register_ftrace_graph(trace_func_graph_ret_t retfunc,
 	ftrace_graph_return = retfunc;
 	ftrace_graph_entry = entryfunc;
 
-	ftrace_startup(&global_ops, FTRACE_START_FUNC_RET);
+	ret = ftrace_startup(&global_ops, FTRACE_START_FUNC_RET);
 
 out:
 	mutex_unlock(&ftrace_lock);
-- 
1.7.4.4


