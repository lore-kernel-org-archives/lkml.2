Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753376Ab2HUPEE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2012 11:04:04 -0400
Received: from terminus.zytor.com ([198.137.202.10]:59207 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753008Ab2HUPEA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2012 11:04:00 -0400
Date: Tue, 21 Aug 2012 07:59:17 -0700
From: tip-bot for Steven Rostedt <srostedt@redhat.com>
Message-ID: <tip-ccf3672d530170c98c734dfc5db07d64bcbad2ad@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        masami.hiramatsu.pt@hitachi.com, rostedt@goodmis.org,
        srostedt@redhat.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        masami.hiramatsu.pt@hitachi.com, rostedt@goodmis.org,
        srostedt@redhat.com, tglx@linutronix.de
In-Reply-To: <20120612225424.495625483@goodmis.org>
References: <20120612225424.495625483@goodmis.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] ftrace: Consolidate arch dependent functions with 
 'list' function
Git-Commit-ID: ccf3672d530170c98c734dfc5db07d64bcbad2ad
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Tue, 21 Aug 2012 07:59:22 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  ccf3672d530170c98c734dfc5db07d64bcbad2ad
Gitweb:     http://git.kernel.org/tip/ccf3672d530170c98c734dfc5db07d64bcbad2ad
Author:     Steven Rostedt <srostedt@redhat.com>
AuthorDate: Tue, 5 Jun 2012 09:44:25 -0400
Committer:  Steven Rostedt <rostedt@goodmis.org>
CommitDate: Thu, 19 Jul 2012 13:18:22 -0400

ftrace: Consolidate arch dependent functions with 'list' function

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

Link: http://lkml.kernel.org/r/20120612225424.495625483@goodmis.org

Reviewed-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
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
index 4f2ab93..4cbca2e 100644
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
 
