Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932196Ab1D3Pcn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Apr 2011 11:32:43 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:59623 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756833Ab1D3PcN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Apr 2011 11:32:13 -0400
X-Authority-Analysis: v=1.1 cv=qyUSAyc82z9xLljZQc9ErY9Tl2GSEfqK/XYZS35I9d8= c=1 sm=0 a=vhdKIqpQuCYA:10 a=7hSBAM6VqisA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=20KFwNOVAAAA:8 a=meVymXHHAAAA:8 a=dW3t-yMiwlCcz2Wr0dQA:9 a=QPj5j7bR6bBypVpaDj4A:7 a=jEp0ucaQiEUA:10 a=jeBq3FmKZ4MA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Message-Id: <20110430153211.938513312@goodmis.org>
User-Agent: quilt/0.48-1
Date: Sat, 30 Apr 2011 11:30:47 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 7/8] ftrace: Consolidate updating of ftrace_trace_function
References: <20110430153040.354378898@goodmis.org>
Content-Disposition: inline; filename=0007-ftrace-Consolidate-updating-of-ftrace_trace_function.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

There are three locations that perform almost identical functions in order
to update the ftrace_trace_function (the ftrace function variable that gets
called by mcount).

Consolidate these into a single function called update_ftrace_function().

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/ftrace.c |   95 +++++++++++++++++-------------------------------
 1 files changed, 34 insertions(+), 61 deletions(-)

diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index 5b758ea..33bcc71 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -151,6 +151,34 @@ static void ftrace_test_stop_func(unsigned long ip, unsigned long parent_ip)
 }
 #endif
 
+static void update_ftrace_function(void)
+{
+	ftrace_func_t func;
+
+	/*
+	 * If there's only one function registered, then call that
+	 * function directly. Otherwise, we need to iterate over the
+	 * registered callers.
+	 */
+	if (ftrace_list == &ftrace_list_end ||
+	    ftrace_list->next == &ftrace_list_end)
+		func = ftrace_list->func;
+	else
+		func = ftrace_list_func;
+
+	/* If we filter on pids, update to use the pid function */
+	if (!list_empty(&ftrace_pids)) {
+		set_ftrace_pid_function(func);
+		func = ftrace_pid_func;
+	}
+#ifdef CONFIG_HAVE_FUNCTION_TRACE_MCOUNT_TEST
+	ftrace_trace_function = func;
+#else
+	__ftrace_trace_function = func;
+	ftrace_trace_function = ftrace_test_stop_func;
+#endif
+}
+
 static int __register_ftrace_function(struct ftrace_ops *ops)
 {
 	ops->next = ftrace_list;
@@ -162,30 +190,8 @@ static int __register_ftrace_function(struct ftrace_ops *ops)
 	 */
 	rcu_assign_pointer(ftrace_list, ops);
 
-	if (ftrace_enabled) {
-		ftrace_func_t func;
-
-		if (ops->next == &ftrace_list_end)
-			func = ops->func;
-		else
-			func = ftrace_list_func;
-
-		if (!list_empty(&ftrace_pids)) {
-			set_ftrace_pid_function(func);
-			func = ftrace_pid_func;
-		}
-
-		/*
-		 * For one func, simply call it directly.
-		 * For more than one func, call the chain.
-		 */
-#ifdef CONFIG_HAVE_FUNCTION_TRACE_MCOUNT_TEST
-		ftrace_trace_function = func;
-#else
-		__ftrace_trace_function = func;
-		ftrace_trace_function = ftrace_test_stop_func;
-#endif
-	}
+	if (ftrace_enabled)
+		update_ftrace_function();
 
 	return 0;
 }
@@ -213,52 +219,19 @@ static int __unregister_ftrace_function(struct ftrace_ops *ops)
 
 	*p = (*p)->next;
 
-	if (ftrace_enabled) {
-		/* If we only have one func left, then call that directly */
-		if (ftrace_list->next == &ftrace_list_end) {
-			ftrace_func_t func = ftrace_list->func;
-
-			if (!list_empty(&ftrace_pids)) {
-				set_ftrace_pid_function(func);
-				func = ftrace_pid_func;
-			}
-#ifdef CONFIG_HAVE_FUNCTION_TRACE_MCOUNT_TEST
-			ftrace_trace_function = func;
-#else
-			__ftrace_trace_function = func;
-#endif
-		}
-	}
+	if (ftrace_enabled)
+		update_ftrace_function();
 
 	return 0;
 }
 
 static void ftrace_update_pid_func(void)
 {
-	ftrace_func_t func;
-
+	/* Only do something if we are tracing something */
 	if (ftrace_trace_function == ftrace_stub)
 		return;
 
-#ifdef CONFIG_HAVE_FUNCTION_TRACE_MCOUNT_TEST
-	func = ftrace_trace_function;
-#else
-	func = __ftrace_trace_function;
-#endif
-
-	if (!list_empty(&ftrace_pids)) {
-		set_ftrace_pid_function(func);
-		func = ftrace_pid_func;
-	} else {
-		if (func == ftrace_pid_func)
-			func = ftrace_pid_function;
-	}
-
-#ifdef CONFIG_HAVE_FUNCTION_TRACE_MCOUNT_TEST
-	ftrace_trace_function = func;
-#else
-	__ftrace_trace_function = func;
-#endif
+	update_ftrace_function();
 }
 
 #ifdef CONFIG_FUNCTION_PROFILER
-- 
1.7.2.3


