Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756753Ab1ESCOG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 May 2011 22:14:06 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:64627 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756076Ab1ESCM6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 May 2011 22:12:58 -0400
X-Authority-Analysis: v=1.1 cv=u/eXSd3k4P+OuNmbl5aZU3ellt6eTxbOnGssQLT4hSY= c=1 sm=0 a=vhdKIqpQuCYA:10 a=lKZuB7dE3qEA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=20KFwNOVAAAA:8 a=meVymXHHAAAA:8 a=GckkNb-raG_haESdMs8A:9 a=26m8CmsyeXpqxFnCyy0A:7 a=jEp0ucaQiEUA:10 a=jeBq3FmKZ4MA:10 a=A6gzGfZxbNdpFYQ4:21 a=JI2GK9ALeDlo_9EF:21 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Message-Id: <20110519021257.386905365@goodmis.org>
User-Agent: quilt/0.48-1
Date: Wed, 18 May 2011 22:12:03 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>
Subject: [PATCH 12/13] ftrace: Modify ftrace_set_filter/notrace to take ops
References: <20110519021151.600991800@goodmis.org>
Content-Disposition: inline; filename=0012-ftrace-Modify-ftrace_set_filter-notrace-to-take-ops.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

Since users of the function tracer can now pick and choose which
functions they want to trace agnostically from other users of the
function tracer, we need to pass the ops struct to the ftrace_set_filter()
functions.

The functions ftrace_set_global_filter() and ftrace_set_global_notrace()
is added to keep the old filter functions which are used to modify
the generic function tracers.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 include/linux/ftrace.h        |    7 +++++-
 kernel/trace/ftrace.c         |   46 +++++++++++++++++++++++++++++++++++++++-
 kernel/trace/trace_selftest.c |    4 +-
 3 files changed, 52 insertions(+), 5 deletions(-)

diff --git a/include/linux/ftrace.h b/include/linux/ftrace.h
index caba694..9d88e1c 100644
--- a/include/linux/ftrace.h
+++ b/include/linux/ftrace.h
@@ -179,7 +179,12 @@ struct dyn_ftrace {
 };
 
 int ftrace_force_update(void);
-void ftrace_set_filter(unsigned char *buf, int len, int reset);
+void ftrace_set_filter(struct ftrace_ops *ops, unsigned char *buf,
+		       int len, int reset);
+void ftrace_set_notrace(struct ftrace_ops *ops, unsigned char *buf,
+			int len, int reset);
+void ftrace_set_global_filter(unsigned char *buf, int len, int reset);
+void ftrace_set_global_notrace(unsigned char *buf, int len, int reset);
 
 int register_ftrace_command(struct ftrace_func_command *cmd);
 int unregister_ftrace_command(struct ftrace_func_command *cmd);
diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index 5b3ee04..d017c2c 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -2826,6 +2826,10 @@ ftrace_set_regex(struct ftrace_ops *ops, unsigned char *buf, int len,
 	struct ftrace_hash *hash;
 	int ret;
 
+	/* All global ops uses the global ops filters */
+	if (ops->flags & FTRACE_OPS_FL_GLOBAL)
+		ops = &global_ops;
+
 	if (unlikely(ftrace_disabled))
 		return -ENODEV;
 
@@ -2856,6 +2860,41 @@ ftrace_set_regex(struct ftrace_ops *ops, unsigned char *buf, int len,
 
 /**
  * ftrace_set_filter - set a function to filter on in ftrace
+ * @ops - the ops to set the filter with
+ * @buf - the string that holds the function filter text.
+ * @len - the length of the string.
+ * @reset - non zero to reset all filters before applying this filter.
+ *
+ * Filters denote which functions should be enabled when tracing is enabled.
+ * If @buf is NULL and reset is set, all functions will be enabled for tracing.
+ */
+void ftrace_set_filter(struct ftrace_ops *ops, unsigned char *buf,
+		       int len, int reset)
+{
+	ftrace_set_regex(ops, buf, len, reset, 1);
+}
+EXPORT_SYMBOL_GPL(ftrace_set_filter);
+
+/**
+ * ftrace_set_notrace - set a function to not trace in ftrace
+ * @ops - the ops to set the notrace filter with
+ * @buf - the string that holds the function notrace text.
+ * @len - the length of the string.
+ * @reset - non zero to reset all filters before applying this filter.
+ *
+ * Notrace Filters denote which functions should not be enabled when tracing
+ * is enabled. If @buf is NULL and reset is set, all functions will be enabled
+ * for tracing.
+ */
+void ftrace_set_notrace(struct ftrace_ops *ops, unsigned char *buf,
+			int len, int reset)
+{
+	ftrace_set_regex(ops, buf, len, reset, 0);
+}
+EXPORT_SYMBOL_GPL(ftrace_set_notrace);
+/**
+ * ftrace_set_filter - set a function to filter on in ftrace
+ * @ops - the ops to set the filter with
  * @buf - the string that holds the function filter text.
  * @len - the length of the string.
  * @reset - non zero to reset all filters before applying this filter.
@@ -2863,13 +2902,15 @@ ftrace_set_regex(struct ftrace_ops *ops, unsigned char *buf, int len,
  * Filters denote which functions should be enabled when tracing is enabled.
  * If @buf is NULL and reset is set, all functions will be enabled for tracing.
  */
-void ftrace_set_filter(unsigned char *buf, int len, int reset)
+void ftrace_set_global_filter(unsigned char *buf, int len, int reset)
 {
 	ftrace_set_regex(&global_ops, buf, len, reset, 1);
 }
+EXPORT_SYMBOL_GPL(ftrace_set_global_filter);
 
 /**
  * ftrace_set_notrace - set a function to not trace in ftrace
+ * @ops - the ops to set the notrace filter with
  * @buf - the string that holds the function notrace text.
  * @len - the length of the string.
  * @reset - non zero to reset all filters before applying this filter.
@@ -2878,10 +2919,11 @@ void ftrace_set_filter(unsigned char *buf, int len, int reset)
  * is enabled. If @buf is NULL and reset is set, all functions will be enabled
  * for tracing.
  */
-void ftrace_set_notrace(unsigned char *buf, int len, int reset)
+void ftrace_set_global_notrace(unsigned char *buf, int len, int reset)
 {
 	ftrace_set_regex(&global_ops, buf, len, reset, 0);
 }
+EXPORT_SYMBOL_GPL(ftrace_set_global_notrace);
 
 /*
  * command line interface to allow users to set filters on boot up.
diff --git a/kernel/trace/trace_selftest.c b/kernel/trace/trace_selftest.c
index 659732e..0fa2db3 100644
--- a/kernel/trace/trace_selftest.c
+++ b/kernel/trace/trace_selftest.c
@@ -131,7 +131,7 @@ int trace_selftest_startup_dynamic_tracing(struct tracer *trace,
 	func_name = "*" __stringify(DYN_FTRACE_TEST_NAME);
 
 	/* filter only on our function */
-	ftrace_set_filter(func_name, strlen(func_name), 1);
+	ftrace_set_global_filter(func_name, strlen(func_name), 1);
 
 	/* enable tracing */
 	ret = tracer_init(trace, tr);
@@ -181,7 +181,7 @@ int trace_selftest_startup_dynamic_tracing(struct tracer *trace,
 	tracer_enabled = save_tracer_enabled;
 
 	/* Enable tracing on all functions again */
-	ftrace_set_filter(NULL, 0, 1);
+	ftrace_set_global_filter(NULL, 0, 1);
 
 	return ret;
 }
-- 
1.7.4.4


