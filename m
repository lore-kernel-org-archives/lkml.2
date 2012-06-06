Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752038Ab2FFEAX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2012 00:00:23 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:16197 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750711Ab2FFEAP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2012 00:00:15 -0400
X-Authority-Analysis: v=2.0 cv=NbpkJh/4 c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=Ciwy3NGCPMMA:10 a=MQMIIIl7aBkA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=20KFwNOVAAAA:8 a=dwWg9rdAu8B17VaaaNQA:9 a=jEp0ucaQiEUA:10 a=jeBq3FmKZ4MA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-Id: <20120606040013.715582739@goodmis.org>
User-Agent: quilt/0.60-1
Date: Tue, 05 Jun 2012 23:51:00 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: [RFC][PATCH 02/12] ftrace: Consolidate arch dependent functions with list function
References: <20120606035058.108720095@goodmis.org>
Content-Disposition: inline; filename=0002-ftrace-Consolidate-arch-dependent-functions-with-lis.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

As the function tracer starts to get more features, the support for
theses features will spread out throughout the different architectures
over time. These features boil down to what each arch does in the
mcount trampoline (the ftrace_caller).

Currently there's two features that are not the same throughout the
archs.

 1) Support to stop function tracing before the callback
 2) passing of the ftrace ops

Both of these require placing an indirect function to support the
features if the mcount trampoline does not.

On a side note, for all architectures, when more than one callback
is registered to the function tracer, an intermediate 'list' function
is called by the mcount trampoline to iterate through the callbacks
that are registered.

Instead of making a separate function for each of these features,
and requiring several indirect calls, just use the single 'list' function
as the intermediate, to handle all cases. If an arch does not support
the 'stop function tracing' or the passing of ftrace ops, just force
it to use the list function that will handle the features required.

This makes the code cleaner and simpler and removes a lot of
 #ifdefs in the code.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 include/linux/ftrace.h |   13 +++++++++++++
 kernel/trace/ftrace.c  |   45 ++++-----------------------------------------
 2 files changed, 17 insertions(+), 41 deletions(-)

diff --git a/include/linux/ftrace.h b/include/linux/ftrace.h
index 2d59641..3651fdc 100644
--- a/include/linux/ftrace.h
+++ b/include/linux/ftrace.h
@@ -27,6 +27,19 @@
 #define ARCH_SUPPORTS_FTRACE_OPS 0
 #endif
 
+/*
+ * If the arch's mcount caller does not support all of ftrace's
+ * features, then it must call an indirect function that
+ * does. Or at least does enough to prevent any unwelcomed side effects.
+ */
+#if !defined(CONFIG_HAVE_FUNCTION_TRACE_MCOUNT_TEST) || \
+	!ARCH_SUPPORTS_FTRACE_OPS
+# define FTRACE_FORCE_LIST_FUNC 1
+#else
+# define FTRACE_FORCE_LIST_FUNC 0
+#endif
+
+
 struct module;
 struct ftrace_hash;
 
diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index 9b82242..24654a2 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -97,8 +97,6 @@ static struct ftrace_ops *ftrace_global_list __read_mostly = &ftrace_list_end;
 static struct ftrace_ops *ftrace_control_list __read_mostly = &ftrace_list_end;
 static struct ftrace_ops *ftrace_ops_list __read_mostly = &ftrace_list_end;
 ftrace_func_t ftrace_trace_function __read_mostly = ftrace_stub;
-static ftrace_func_t __ftrace_trace_function_delay __read_mostly = ftrace_stub;
-ftrace_func_t __ftrace_trace_function __read_mostly = ftrace_stub;
 ftrace_func_t ftrace_pid_function __read_mostly = ftrace_stub;
 static struct ftrace_ops global_ops;
 static struct ftrace_ops control_ops;
@@ -162,26 +160,9 @@ static void set_ftrace_pid_function(ftrace_func_t func)
 void clear_ftrace_function(void)
 {
 	ftrace_trace_function = ftrace_stub;
-	__ftrace_trace_function = ftrace_stub;
-	__ftrace_trace_function_delay = ftrace_stub;
 	ftrace_pid_function = ftrace_stub;
 }
 
-#ifndef CONFIG_HAVE_FUNCTION_TRACE_MCOUNT_TEST
-/*
- * For those archs that do not test ftrace_trace_stop in their
- * mcount call site, we need to do it from C.
- */
-static void ftrace_test_stop_func(unsigned long ip, unsigned long parent_ip,
-				  struct ftrace_ops *op)
-{
-	if (function_trace_stop)
-		return;
-
-	__ftrace_trace_function(ip, parent_ip, op);
-}
-#endif
-
 static void control_ops_disable_all(struct ftrace_ops *ops)
 {
 	int cpu;
@@ -246,7 +227,7 @@ static void update_ftrace_function(void)
 	if (ftrace_ops_list == &ftrace_list_end ||
 	    (ftrace_ops_list->next == &ftrace_list_end &&
 	     !(ftrace_ops_list->flags & FTRACE_OPS_FL_DYNAMIC) &&
-	     ARCH_SUPPORTS_FTRACE_OPS)) {
+	     !FTRACE_FORCE_LIST_FUNC)) {
 		/* Set the ftrace_ops that the arch callback uses */
 		if (ftrace_ops_list == &global_ops)
 			function_trace_op = ftrace_global_list;
@@ -259,18 +240,7 @@ static void update_ftrace_function(void)
 		func = ftrace_ops_list_func;
 	}
 
-#ifdef CONFIG_HAVE_FUNCTION_TRACE_MCOUNT_TEST
 	ftrace_trace_function = func;
-#else
-#ifdef CONFIG_DYNAMIC_FTRACE
-	/* do not update till all functions have been modified */
-	__ftrace_trace_function_delay = func;
-#else
-	__ftrace_trace_function = func;
-#endif
-	ftrace_trace_function =
-		(func == ftrace_stub) ? func : ftrace_test_stop_func;
-#endif
 }
 
 static void add_ftrace_ops(struct ftrace_ops **list, struct ftrace_ops *ops)
@@ -1902,16 +1872,6 @@ static void ftrace_run_update_code(int command)
 	 */
 	arch_ftrace_update_code(command);
 
-#ifndef CONFIG_HAVE_FUNCTION_TRACE_MCOUNT_TEST
-	/*
-	 * For archs that call ftrace_test_stop_func(), we must
-	 * wait till after we update all the function callers
-	 * before we update the callback. This keeps different
-	 * ops that record different functions from corrupting
-	 * each other.
-	 */
-	__ftrace_trace_function = __ftrace_trace_function_delay;
-#endif
 	function_trace_stop--;
 
 	ret = ftrace_arch_code_modify_post_process();
@@ -3996,6 +3956,9 @@ __ftrace_ops_list_func(unsigned long ip, unsigned long parent_ip,
 {
 	struct ftrace_ops *op;
 
+	if (function_trace_stop)
+		return;
+
 	if (unlikely(trace_recursion_test(TRACE_INTERNAL_BIT)))
 		return;
 
-- 
1.7.10


