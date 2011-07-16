Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754528Ab1GPL0P (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Jul 2011 07:26:15 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:61337 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753537Ab1GPLWy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Jul 2011 07:22:54 -0400
X-Authority-Analysis: v=1.1 cv=IOX921YOuPvYFce5aSLzPVIStpiCPR9M8R83dyHW74w= c=1 sm=0 a=vhdKIqpQuCYA:10 a=tpeXPjjy7K0A:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=20KFwNOVAAAA:8 a=meVymXHHAAAA:8 a=N-S-364DWvpOpsW6GvwA:9 a=k7iRHsbmjbCg8c4RAuYA:7 a=jEp0ucaQiEUA:10 a=jeBq3FmKZ4MA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Message-Id: <20110716112252.536093524@goodmis.org>
User-Agent: quilt/0.48-1
Date: Sat, 16 Jul 2011 07:22:05 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 05/20] ftrace: Fix dynamic selftest failure on some archs
References: <20110716112200.096203519@goodmis.org>
Content-Disposition: inline; filename=0005-ftrace-Fix-dynamic-selftest-failure-on-some-archs.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

Archs that do not implement CONFIG_HAVE_FUNCTION_TRACE_MCOUNT_TEST, will
fail the dynamic ftrace selftest.

The function tracer has a quick 'off' variable that will prevent
the call back functions from being called. This variable is called
function_trace_stop. In x86, this is implemented directly in the mcount
assembly, but for other archs, an intermediate function is used called
ftrace_test_stop_func().

In dynamic ftrace, the function pointer variable ftrace_trace_function is
used to update the caller code in the mcount caller. But for archs that
do not have CONFIG_HAVE_FUNCTION_TRACE_MCOUNT_TEST set, it only calls
ftrace_test_stop_func() instead, which in turn calls __ftrace_trace_function.

When more than one ftrace_ops is registered, the function it calls is
ftrace_ops_list_func(), which will iterate over all registered ftrace_ops
and call the callbacks that have their hash matching.

The issue happens when two ftrace_ops are registered for different functions
and one is then unregistered. The __ftrace_trace_function is then pointed
to the remaining ftrace_ops callback function directly. This mean it will
be called for all functions that were registered to trace by both ftrace_ops
that were registered.

This is not an issue for archs with CONFIG_HAVE_FUNCTION_TRACE_MCOUNT_TEST,
because the update of ftrace_trace_function doesn't happen until after all
functions have been updated, and then the mcount caller is updated. But
for those archs that do use the ftrace_test_stop_func(), the update is
immediate.

The dynamic selftest fails because it hits this situation, and the
ftrace_ops that it registers fails to only trace what it was suppose to
and instead traces all other functions.

The solution is to delay the setting of __ftrace_trace_function until
after all the functions have been updated according to the registered
ftrace_ops. Also, function_trace_stop is set during the update to prevent
function tracing from calling code that is caused by the function tracer
itself.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/ftrace.c |   26 ++++++++++++++++++++++++++
 1 files changed, 26 insertions(+), 0 deletions(-)

diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index a0dc0de..62e26d9 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -88,6 +88,7 @@ static struct ftrace_ops ftrace_list_end __read_mostly = {
 static struct ftrace_ops *ftrace_global_list __read_mostly = &ftrace_list_end;
 static struct ftrace_ops *ftrace_ops_list __read_mostly = &ftrace_list_end;
 ftrace_func_t ftrace_trace_function __read_mostly = ftrace_stub;
+static ftrace_func_t __ftrace_trace_function_delay __read_mostly = ftrace_stub;
 ftrace_func_t __ftrace_trace_function __read_mostly = ftrace_stub;
 ftrace_func_t ftrace_pid_function __read_mostly = ftrace_stub;
 static struct ftrace_ops global_ops;
@@ -146,9 +147,11 @@ void clear_ftrace_function(void)
 {
 	ftrace_trace_function = ftrace_stub;
 	__ftrace_trace_function = ftrace_stub;
+	__ftrace_trace_function_delay = ftrace_stub;
 	ftrace_pid_function = ftrace_stub;
 }
 
+#undef CONFIG_HAVE_FUNCTION_TRACE_MCOUNT_TEST
 #ifndef CONFIG_HAVE_FUNCTION_TRACE_MCOUNT_TEST
 /*
  * For those archs that do not test ftrace_trace_stop in their
@@ -208,7 +211,12 @@ static void update_ftrace_function(void)
 #ifdef CONFIG_HAVE_FUNCTION_TRACE_MCOUNT_TEST
 	ftrace_trace_function = func;
 #else
+#ifdef CONFIG_DYNAMIC_FTRACE
+	/* do not update till all functions have been modified */
+	__ftrace_trace_function_delay = func;
+#else
 	__ftrace_trace_function = func;
+#endif
 	ftrace_trace_function = ftrace_test_stop_func;
 #endif
 }
@@ -1607,6 +1615,12 @@ static int __ftrace_modify_code(void *data)
 {
 	int *command = data;
 
+	/*
+	 * Do not call function tracer while we update the code.
+	 * We are in stop machine, no worrying about races.
+	 */
+	function_trace_stop++;
+
 	if (*command & FTRACE_ENABLE_CALLS)
 		ftrace_replace_code(1);
 	else if (*command & FTRACE_DISABLE_CALLS)
@@ -1620,6 +1634,18 @@ static int __ftrace_modify_code(void *data)
 	else if (*command & FTRACE_STOP_FUNC_RET)
 		ftrace_disable_ftrace_graph_caller();
 
+#ifndef CONFIG_HAVE_FUNCTION_TRACE_MCOUNT_TEST
+	/*
+	 * For archs that call ftrace_test_stop_func(), we must
+	 * wait till after we update all the function callers
+	 * before we update the callback. This keeps different
+	 * ops that record different functions from corrupting
+	 * each other.
+	 */
+	__ftrace_trace_function = __ftrace_trace_function_delay;
+#endif
+	function_trace_stop--;
+
 	return 0;
 }
 
-- 
1.7.5.4


