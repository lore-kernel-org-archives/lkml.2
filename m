Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756739Ab1ESCOD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 May 2011 22:14:03 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:48926 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756090Ab1ESCM6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 May 2011 22:12:58 -0400
X-Authority-Analysis: v=1.1 cv=NmbQexcdgr4rtO3OwYGrP5Q3rTMpacrTPhuaXkv4uP8= c=1 sm=0 a=vhdKIqpQuCYA:10 a=vUYgtxGB2ZsA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=20KFwNOVAAAA:8 a=meVymXHHAAAA:8 a=ub5fkPtXNE4uSVaks_IA:9 a=OZ5PjjlgJ_G-0UEiIh0A:7 a=jEp0ucaQiEUA:10 a=jeBq3FmKZ4MA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Message-Id: <20110519021256.450408258@goodmis.org>
User-Agent: quilt/0.48-1
Date: Wed, 18 May 2011 22:11:59 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>
Subject: [PATCH 08/13] ftrace: Have global_ops store the functions that are to be traced
References: <20110519021151.600991800@goodmis.org>
Content-Disposition: inline; filename=0008-ftrace-Have-global_ops-store-the-functions-that-are-.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

This is a step towards each ops structure defining its own set
of functions to trace. As the current code with pid's and such
are specific to the global_ops, it is restructured to be used
with the global ops.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/ftrace.c |   69 +++++++++++++++++++++++++++++++++++++-----------
 1 files changed, 53 insertions(+), 16 deletions(-)

diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index 8fef1d9..dcce0bf 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -91,6 +91,7 @@ static struct ftrace_ops *ftrace_list __read_mostly = &ftrace_list_end;
 ftrace_func_t ftrace_trace_function __read_mostly = ftrace_stub;
 ftrace_func_t __ftrace_trace_function __read_mostly = ftrace_stub;
 ftrace_func_t ftrace_pid_function __read_mostly = ftrace_stub;
+static struct ftrace_ops global_ops;
 
 /*
  * Traverse the ftrace_list, invoking all entries.  The reason that we
@@ -153,7 +154,7 @@ static void ftrace_test_stop_func(unsigned long ip, unsigned long parent_ip)
 }
 #endif
 
-static void update_ftrace_function(void)
+static void update_global_ops(void)
 {
 	ftrace_func_t func;
 
@@ -173,6 +174,18 @@ static void update_ftrace_function(void)
 		set_ftrace_pid_function(func);
 		func = ftrace_pid_func;
 	}
+
+	global_ops.func = func;
+}
+
+static void update_ftrace_function(void)
+{
+	ftrace_func_t func;
+
+	update_global_ops();
+
+	func = global_ops.func;
+
 #ifdef CONFIG_HAVE_FUNCTION_TRACE_MCOUNT_TEST
 	ftrace_trace_function = func;
 #else
@@ -181,24 +194,19 @@ static void update_ftrace_function(void)
 #endif
 }
 
-static int __register_ftrace_function(struct ftrace_ops *ops)
+static void add_ftrace_ops(struct ftrace_ops **list, struct ftrace_ops *ops)
 {
-	ops->next = ftrace_list;
+	ops->next = *list;
 	/*
 	 * We are entering ops into the ftrace_list but another
 	 * CPU might be walking that list. We need to make sure
 	 * the ops->next pointer is valid before another CPU sees
 	 * the ops pointer included into the ftrace_list.
 	 */
-	rcu_assign_pointer(ftrace_list, ops);
-
-	if (ftrace_enabled)
-		update_ftrace_function();
-
-	return 0;
+	rcu_assign_pointer(*list, ops);
 }
 
-static int __unregister_ftrace_function(struct ftrace_ops *ops)
+static int remove_ftrace_ops(struct ftrace_ops **list, struct ftrace_ops *ops)
 {
 	struct ftrace_ops **p;
 
@@ -206,13 +214,12 @@ static int __unregister_ftrace_function(struct ftrace_ops *ops)
 	 * If we are removing the last function, then simply point
 	 * to the ftrace_stub.
 	 */
-	if (ftrace_list == ops && ops->next == &ftrace_list_end) {
-		ftrace_trace_function = ftrace_stub;
-		ftrace_list = &ftrace_list_end;
+	if (*list == ops && ops->next == &ftrace_list_end) {
+		*list = &ftrace_list_end;
 		return 0;
 	}
 
-	for (p = &ftrace_list; *p != &ftrace_list_end; p = &(*p)->next)
+	for (p = list; *p != &ftrace_list_end; p = &(*p)->next)
 		if (*p == ops)
 			break;
 
@@ -220,7 +227,37 @@ static int __unregister_ftrace_function(struct ftrace_ops *ops)
 		return -1;
 
 	*p = (*p)->next;
+	return 0;
+}
+
+static int __register_ftrace_function(struct ftrace_ops *ops)
+{
+	if (ftrace_disabled)
+		return -ENODEV;
+
+	if (FTRACE_WARN_ON(ops == &global_ops))
+		return -EINVAL;
+
+	add_ftrace_ops(&ftrace_list, ops);
+	if (ftrace_enabled)
+		update_ftrace_function();
+
+	return 0;
+}
 
+static int __unregister_ftrace_function(struct ftrace_ops *ops)
+{
+	int ret;
+
+	if (ftrace_disabled)
+		return -ENODEV;
+
+	if (FTRACE_WARN_ON(ops == &global_ops))
+		return -EINVAL;
+
+	ret = remove_ftrace_ops(&ftrace_list, ops);
+	if (ret < 0)
+		return ret;
 	if (ftrace_enabled)
 		update_ftrace_function();
 
@@ -894,7 +931,7 @@ enum {
 	FTRACE_OPS_FL_ENABLED		= 1,
 };
 
-struct ftrace_ops global_ops = {
+static struct ftrace_ops global_ops = {
 	.func			= ftrace_stub,
 	.notrace_hash		= EMPTY_HASH,
 	.filter_hash		= EMPTY_HASH,
@@ -3263,7 +3300,7 @@ void __init ftrace_init(void)
 
 #else
 
-struct ftrace_ops global_ops = {
+static struct ftrace_ops global_ops = {
 	.func			= ftrace_stub,
 };
 
-- 
1.7.4.4


