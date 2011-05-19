Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756598Ab1ESCOB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 May 2011 22:14:01 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:42133 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756168Ab1ESCM6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 May 2011 22:12:58 -0400
X-Authority-Analysis: v=1.1 cv=ou1QuR4lBR9YeJgEH9ccYmbAdaWqVVq3lOvCKJtMpGM= c=1 sm=0 a=vhdKIqpQuCYA:10 a=-NAxUYnQQTIA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=20KFwNOVAAAA:8 a=meVymXHHAAAA:8 a=pQlb3qSmZVtWkxVqSJUA:9 a=MaoGoWIVhgm_0D8Xek0A:7 a=jEp0ucaQiEUA:10 a=jeBq3FmKZ4MA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Message-Id: <20110519021257.768298253@goodmis.org>
User-Agent: quilt/0.48-1
Date: Wed, 18 May 2011 22:12:04 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>
Subject: [PATCH 13/13] ftrace: Add self-tests for multiple function trace users
References: <20110519021151.600991800@goodmis.org>
Content-Disposition: inline; filename=0013-ftrace-Add-self-tests-for-multiple-function-trace-us.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

Add some basic sanity tests for multiple users of the function
tracer at startup.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/trace.h                  |    2 +
 kernel/trace/trace_selftest.c         |  210 ++++++++++++++++++++++++++++++++-
 kernel/trace/trace_selftest_dynamic.c |    6 +
 3 files changed, 217 insertions(+), 1 deletions(-)

diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
index 5e9dfc6..6b69c4b 100644
--- a/kernel/trace/trace.h
+++ b/kernel/trace/trace.h
@@ -419,6 +419,8 @@ extern void trace_find_cmdline(int pid, char comm[]);
 extern unsigned long ftrace_update_tot_cnt;
 #define DYN_FTRACE_TEST_NAME trace_selftest_dynamic_test_func
 extern int DYN_FTRACE_TEST_NAME(void);
+#define DYN_FTRACE_TEST_NAME2 trace_selftest_dynamic_test_func2
+extern int DYN_FTRACE_TEST_NAME2(void);
 #endif
 
 extern int ring_buffer_expanded;
diff --git a/kernel/trace/trace_selftest.c b/kernel/trace/trace_selftest.c
index 0fa2db3..288541f 100644
--- a/kernel/trace/trace_selftest.c
+++ b/kernel/trace/trace_selftest.c
@@ -101,6 +101,206 @@ static inline void warn_failed_init_tracer(struct tracer *trace, int init_ret)
 
 #ifdef CONFIG_DYNAMIC_FTRACE
 
+static int trace_selftest_test_probe1_cnt;
+static void trace_selftest_test_probe1_func(unsigned long ip,
+					    unsigned long pip)
+{
+	trace_selftest_test_probe1_cnt++;
+}
+
+static int trace_selftest_test_probe2_cnt;
+static void trace_selftest_test_probe2_func(unsigned long ip,
+					    unsigned long pip)
+{
+	trace_selftest_test_probe2_cnt++;
+}
+
+static int trace_selftest_test_probe3_cnt;
+static void trace_selftest_test_probe3_func(unsigned long ip,
+					    unsigned long pip)
+{
+	trace_selftest_test_probe3_cnt++;
+}
+
+static int trace_selftest_test_global_cnt;
+static void trace_selftest_test_global_func(unsigned long ip,
+					    unsigned long pip)
+{
+	trace_selftest_test_global_cnt++;
+}
+
+static int trace_selftest_test_dyn_cnt;
+static void trace_selftest_test_dyn_func(unsigned long ip,
+					 unsigned long pip)
+{
+	trace_selftest_test_dyn_cnt++;
+}
+
+static struct ftrace_ops test_probe1 = {
+	.func			= trace_selftest_test_probe1_func,
+};
+
+static struct ftrace_ops test_probe2 = {
+	.func			= trace_selftest_test_probe2_func,
+};
+
+static struct ftrace_ops test_probe3 = {
+	.func			= trace_selftest_test_probe3_func,
+};
+
+static struct ftrace_ops test_global = {
+	.func			= trace_selftest_test_global_func,
+	.flags			= FTRACE_OPS_FL_GLOBAL,
+};
+
+static void print_counts(void)
+{
+	printk("(%d %d %d %d %d) ",
+	       trace_selftest_test_probe1_cnt,
+	       trace_selftest_test_probe2_cnt,
+	       trace_selftest_test_probe3_cnt,
+	       trace_selftest_test_global_cnt,
+	       trace_selftest_test_dyn_cnt);
+}
+
+static void reset_counts(void)
+{
+	trace_selftest_test_probe1_cnt = 0;
+	trace_selftest_test_probe2_cnt = 0;
+	trace_selftest_test_probe3_cnt = 0;
+	trace_selftest_test_global_cnt = 0;
+	trace_selftest_test_dyn_cnt = 0;
+}
+
+static int trace_selftest_ops(int cnt)
+{
+	int save_ftrace_enabled = ftrace_enabled;
+	struct ftrace_ops *dyn_ops;
+	char *func1_name;
+	char *func2_name;
+	int len1;
+	int len2;
+	int ret = -1;
+
+	printk(KERN_CONT "PASSED\n");
+	pr_info("Testing dynamic ftrace ops #%d: ", cnt);
+
+	ftrace_enabled = 1;
+	reset_counts();
+
+	/* Handle PPC64 '.' name */
+	func1_name = "*" __stringify(DYN_FTRACE_TEST_NAME);
+	func2_name = "*" __stringify(DYN_FTRACE_TEST_NAME2);
+	len1 = strlen(func1_name);
+	len2 = strlen(func2_name);
+
+	/*
+	 * Probe 1 will trace function 1.
+	 * Probe 2 will trace function 2.
+	 * Probe 3 will trace functions 1 and 2.
+	 */
+	ftrace_set_filter(&test_probe1, func1_name, len1, 1);
+	ftrace_set_filter(&test_probe2, func2_name, len2, 1);
+	ftrace_set_filter(&test_probe3, func1_name, len1, 1);
+	ftrace_set_filter(&test_probe3, func2_name, len2, 0);
+
+	register_ftrace_function(&test_probe1);
+	register_ftrace_function(&test_probe2);
+	register_ftrace_function(&test_probe3);
+	register_ftrace_function(&test_global);
+
+	DYN_FTRACE_TEST_NAME();
+
+	print_counts();
+
+	if (trace_selftest_test_probe1_cnt != 1)
+		goto out;
+	if (trace_selftest_test_probe2_cnt != 0)
+		goto out;
+	if (trace_selftest_test_probe3_cnt != 1)
+		goto out;
+	if (trace_selftest_test_global_cnt == 0)
+		goto out;
+
+	DYN_FTRACE_TEST_NAME2();
+
+	print_counts();
+
+	if (trace_selftest_test_probe1_cnt != 1)
+		goto out;
+	if (trace_selftest_test_probe2_cnt != 1)
+		goto out;
+	if (trace_selftest_test_probe3_cnt != 2)
+		goto out;
+
+	/* Add a dynamic probe */
+	dyn_ops = kzalloc(sizeof(*dyn_ops), GFP_KERNEL);
+	if (!dyn_ops) {
+		printk("MEMORY ERROR ");
+		goto out;
+	}
+
+	dyn_ops->func = trace_selftest_test_dyn_func;
+
+	register_ftrace_function(dyn_ops);
+
+	trace_selftest_test_global_cnt = 0;
+
+	DYN_FTRACE_TEST_NAME();
+
+	print_counts();
+
+	if (trace_selftest_test_probe1_cnt != 2)
+		goto out_free;
+	if (trace_selftest_test_probe2_cnt != 1)
+		goto out_free;
+	if (trace_selftest_test_probe3_cnt != 3)
+		goto out_free;
+	if (trace_selftest_test_global_cnt == 0)
+		goto out;
+	if (trace_selftest_test_dyn_cnt == 0)
+		goto out_free;
+
+	DYN_FTRACE_TEST_NAME2();
+
+	print_counts();
+
+	if (trace_selftest_test_probe1_cnt != 2)
+		goto out_free;
+	if (trace_selftest_test_probe2_cnt != 2)
+		goto out_free;
+	if (trace_selftest_test_probe3_cnt != 4)
+		goto out_free;
+
+	ret = 0;
+ out_free:
+	unregister_ftrace_function(dyn_ops);
+	kfree(dyn_ops);
+
+ out:
+	/* Purposely unregister in the same order */
+	unregister_ftrace_function(&test_probe1);
+	unregister_ftrace_function(&test_probe2);
+	unregister_ftrace_function(&test_probe3);
+	unregister_ftrace_function(&test_global);
+
+	/* Make sure everything is off */
+	reset_counts();
+	DYN_FTRACE_TEST_NAME();
+	DYN_FTRACE_TEST_NAME();
+
+	if (trace_selftest_test_probe1_cnt ||
+	    trace_selftest_test_probe2_cnt ||
+	    trace_selftest_test_probe3_cnt ||
+	    trace_selftest_test_global_cnt ||
+	    trace_selftest_test_dyn_cnt)
+		ret = -1;
+
+	ftrace_enabled = save_ftrace_enabled;
+
+	return ret;
+}
+
 /* Test dynamic code modification and ftrace filters */
 int trace_selftest_startup_dynamic_tracing(struct tracer *trace,
 					   struct trace_array *tr,
@@ -166,16 +366,20 @@ int trace_selftest_startup_dynamic_tracing(struct tracer *trace,
 
 	/* check the trace buffer */
 	ret = trace_test_buffer(tr, &count);
-	trace->reset(tr);
 	tracing_start();
 
 	/* we should only have one item */
 	if (!ret && count != 1) {
+		trace->reset(tr);
 		printk(KERN_CONT ".. filter failed count=%ld ..", count);
 		ret = -1;
 		goto out;
 	}
 
+	/* Test the ops with global tracing running */
+	ret = trace_selftest_ops(1);
+	trace->reset(tr);
+
  out:
 	ftrace_enabled = save_ftrace_enabled;
 	tracer_enabled = save_tracer_enabled;
@@ -183,6 +387,10 @@ int trace_selftest_startup_dynamic_tracing(struct tracer *trace,
 	/* Enable tracing on all functions again */
 	ftrace_set_global_filter(NULL, 0, 1);
 
+	/* Test the ops with global tracing off */
+	if (!ret)
+		ret = trace_selftest_ops(2);
+
 	return ret;
 }
 #else
diff --git a/kernel/trace/trace_selftest_dynamic.c b/kernel/trace/trace_selftest_dynamic.c
index 54dd77c..b4c475a 100644
--- a/kernel/trace/trace_selftest_dynamic.c
+++ b/kernel/trace/trace_selftest_dynamic.c
@@ -5,3 +5,9 @@ int DYN_FTRACE_TEST_NAME(void)
 	/* used to call mcount */
 	return 0;
 }
+
+int DYN_FTRACE_TEST_NAME2(void)
+{
+	/* used to call mcount */
+	return 0;
+}
-- 
1.7.4.4


