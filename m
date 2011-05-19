Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756726Ab1ESCNs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 May 2011 22:13:48 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:48926 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755944Ab1ESCM7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 May 2011 22:12:59 -0400
X-Authority-Analysis: v=1.1 cv=NmbQexcdgr4rtO3OwYGrP5Q3rTMpacrTPhuaXkv4uP8= c=1 sm=0 a=vhdKIqpQuCYA:10 a=2mBGvGxZ1fgA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=20KFwNOVAAAA:8 a=VnNF1IyMAAAA:8 a=meVymXHHAAAA:8 a=4U_30z4O7CFSvyetWlYA:9 a=hmQQSgqAOSykaJt96f4A:7 a=jEp0ucaQiEUA:10 a=jeBq3FmKZ4MA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Message-Id: <20110519021256.940564310@goodmis.org>
User-Agent: quilt/0.48-1
Date: Wed, 18 May 2011 22:12:01 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH 10/13] ftrace: Implement separate user function filtering
References: <20110519021151.600991800@goodmis.org>
Content-Disposition: inline; filename=0010-ftrace-Implement-separate-user-function-filtering.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

ftrace_ops that are registered to trace functions can now be
agnostic to each other in respect to what functions they trace.
Each ops has their own hash of the functions they want to trace
and a hash to what they do not want to trace. A empty hash for
the functions they want to trace denotes all functions should
be traced that are not in the notrace hash.

Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 include/linux/ftrace.h            |    7 +-
 kernel/trace/ftrace.c             |  193 +++++++++++++++++++++++++++++-------
 kernel/trace/trace_functions.c    |    2 +
 kernel/trace/trace_irqsoff.c      |    1 +
 kernel/trace/trace_sched_wakeup.c |    1 +
 kernel/trace/trace_stack.c        |    1 +
 6 files changed, 166 insertions(+), 39 deletions(-)

diff --git a/include/linux/ftrace.h b/include/linux/ftrace.h
index ab1c46e..4609c0e 100644
--- a/include/linux/ftrace.h
+++ b/include/linux/ftrace.h
@@ -31,13 +31,18 @@ typedef void (*ftrace_func_t)(unsigned long ip, unsigned long parent_ip);
 
 struct ftrace_hash;
 
+enum {
+	FTRACE_OPS_FL_ENABLED		= 1 << 0,
+	FTRACE_OPS_FL_GLOBAL		= 1 << 1,
+};
+
 struct ftrace_ops {
 	ftrace_func_t			func;
 	struct ftrace_ops		*next;
+	unsigned long			flags;
 #ifdef CONFIG_DYNAMIC_FTRACE
 	struct ftrace_hash		*notrace_hash;
 	struct ftrace_hash		*filter_hash;
-	unsigned long			flags;
 #endif
 };
 
diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index 92b6fdf..6c7e1df 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -87,24 +87,29 @@ static struct ftrace_ops ftrace_list_end __read_mostly =
 	.func		= ftrace_stub,
 };
 
-static struct ftrace_ops *ftrace_list __read_mostly = &ftrace_list_end;
+static struct ftrace_ops *ftrace_global_list __read_mostly = &ftrace_list_end;
+static struct ftrace_ops *ftrace_ops_list __read_mostly = &ftrace_list_end;
 ftrace_func_t ftrace_trace_function __read_mostly = ftrace_stub;
 ftrace_func_t __ftrace_trace_function __read_mostly = ftrace_stub;
 ftrace_func_t ftrace_pid_function __read_mostly = ftrace_stub;
 static struct ftrace_ops global_ops;
 
+static void
+ftrace_ops_list_func(unsigned long ip, unsigned long parent_ip);
+
 /*
- * Traverse the ftrace_list, invoking all entries.  The reason that we
+ * Traverse the ftrace_global_list, invoking all entries.  The reason that we
  * can use rcu_dereference_raw() is that elements removed from this list
  * are simply leaked, so there is no need to interact with a grace-period
  * mechanism.  The rcu_dereference_raw() calls are needed to handle
- * concurrent insertions into the ftrace_list.
+ * concurrent insertions into the ftrace_global_list.
  *
  * Silly Alpha and silly pointer-speculation compiler optimizations!
  */
-static void ftrace_list_func(unsigned long ip, unsigned long parent_ip)
+static void ftrace_global_list_func(unsigned long ip,
+				    unsigned long parent_ip)
 {
-	struct ftrace_ops *op = rcu_dereference_raw(ftrace_list); /*see above*/
+	struct ftrace_ops *op = rcu_dereference_raw(ftrace_global_list); /*see above*/
 
 	while (op != &ftrace_list_end) {
 		op->func(ip, parent_ip);
@@ -163,11 +168,11 @@ static void update_global_ops(void)
 	 * function directly. Otherwise, we need to iterate over the
 	 * registered callers.
 	 */
-	if (ftrace_list == &ftrace_list_end ||
-	    ftrace_list->next == &ftrace_list_end)
-		func = ftrace_list->func;
+	if (ftrace_global_list == &ftrace_list_end ||
+	    ftrace_global_list->next == &ftrace_list_end)
+		func = ftrace_global_list->func;
 	else
-		func = ftrace_list_func;
+		func = ftrace_global_list_func;
 
 	/* If we filter on pids, update to use the pid function */
 	if (!list_empty(&ftrace_pids)) {
@@ -184,7 +189,11 @@ static void update_ftrace_function(void)
 
 	update_global_ops();
 
-	func = global_ops.func;
+	if (ftrace_ops_list == &ftrace_list_end ||
+	    ftrace_ops_list->next == &ftrace_list_end)
+		func = ftrace_ops_list->func;
+	else
+		func = ftrace_ops_list_func;
 
 #ifdef CONFIG_HAVE_FUNCTION_TRACE_MCOUNT_TEST
 	ftrace_trace_function = func;
@@ -198,10 +207,10 @@ static void add_ftrace_ops(struct ftrace_ops **list, struct ftrace_ops *ops)
 {
 	ops->next = *list;
 	/*
-	 * We are entering ops into the ftrace_list but another
+	 * We are entering ops into the list but another
 	 * CPU might be walking that list. We need to make sure
 	 * the ops->next pointer is valid before another CPU sees
-	 * the ops pointer included into the ftrace_list.
+	 * the ops pointer included into the list.
 	 */
 	rcu_assign_pointer(*list, ops);
 }
@@ -238,7 +247,18 @@ static int __register_ftrace_function(struct ftrace_ops *ops)
 	if (FTRACE_WARN_ON(ops == &global_ops))
 		return -EINVAL;
 
-	add_ftrace_ops(&ftrace_list, ops);
+	if (WARN_ON(ops->flags & FTRACE_OPS_FL_ENABLED))
+		return -EBUSY;
+
+	if (ops->flags & FTRACE_OPS_FL_GLOBAL) {
+		int first = ftrace_global_list == &ftrace_list_end;
+		add_ftrace_ops(&ftrace_global_list, ops);
+		ops->flags |= FTRACE_OPS_FL_ENABLED;
+		if (first)
+			add_ftrace_ops(&ftrace_ops_list, &global_ops);
+	} else
+		add_ftrace_ops(&ftrace_ops_list, ops);
+
 	if (ftrace_enabled)
 		update_ftrace_function();
 
@@ -252,12 +272,24 @@ static int __unregister_ftrace_function(struct ftrace_ops *ops)
 	if (ftrace_disabled)
 		return -ENODEV;
 
+	if (WARN_ON(!(ops->flags & FTRACE_OPS_FL_ENABLED)))
+		return -EBUSY;
+
 	if (FTRACE_WARN_ON(ops == &global_ops))
 		return -EINVAL;
 
-	ret = remove_ftrace_ops(&ftrace_list, ops);
+	if (ops->flags & FTRACE_OPS_FL_GLOBAL) {
+		ret = remove_ftrace_ops(&ftrace_global_list, ops);
+		if (!ret && ftrace_global_list == &ftrace_list_end)
+			ret = remove_ftrace_ops(&ftrace_ops_list, &global_ops);
+		if (!ret)
+			ops->flags &= ~FTRACE_OPS_FL_ENABLED;
+	} else
+		ret = remove_ftrace_ops(&ftrace_ops_list, ops);
+
 	if (ret < 0)
 		return ret;
+
 	if (ftrace_enabled)
 		update_ftrace_function();
 
@@ -928,10 +960,6 @@ static const struct ftrace_hash empty_hash = {
 };
 #define EMPTY_HASH	((struct ftrace_hash *)&empty_hash)
 
-enum {
-	FTRACE_OPS_FL_ENABLED		= 1,
-};
-
 static struct ftrace_ops global_ops = {
 	.func			= ftrace_stub,
 	.notrace_hash		= EMPTY_HASH,
@@ -1190,6 +1218,40 @@ ftrace_hash_move(struct ftrace_hash **dst, struct ftrace_hash *src)
 }
 
 /*
+ * Test the hashes for this ops to see if we want to call
+ * the ops->func or not.
+ *
+ * It's a match if the ip is in the ops->filter_hash or
+ * the filter_hash does not exist or is empty,
+ *  AND
+ * the ip is not in the ops->notrace_hash.
+ */
+static int
+ftrace_ops_test(struct ftrace_ops *ops, unsigned long ip)
+{
+	struct ftrace_hash *filter_hash;
+	struct ftrace_hash *notrace_hash;
+	int ret;
+
+	/* The hashes are freed with call_rcu_sched() */
+	preempt_disable_notrace();
+
+	filter_hash = rcu_dereference_raw(ops->filter_hash);
+	notrace_hash = rcu_dereference_raw(ops->notrace_hash);
+
+	if ((!filter_hash || !filter_hash->count ||
+	     ftrace_lookup_ip(filter_hash, ip)) &&
+	    (!notrace_hash || !notrace_hash->count ||
+	     !ftrace_lookup_ip(notrace_hash, ip)))
+		ret = 1;
+	else
+		ret = 0;
+	preempt_enable_notrace();
+
+	return ret;
+}
+
+/*
  * This is a double for. Do not use 'break' to break out of the loop,
  * you must use a goto.
  */
@@ -1232,7 +1294,7 @@ static void __ftrace_hash_rec_update(struct ftrace_ops *ops,
 	if (filter_hash) {
 		hash = ops->filter_hash;
 		other_hash = ops->notrace_hash;
-		if (!hash->count)
+		if (!hash || !hash->count)
 			all = 1;
 	} else {
 		inc = !inc;
@@ -1242,7 +1304,7 @@ static void __ftrace_hash_rec_update(struct ftrace_ops *ops,
 		 * If the notrace hash has no items,
 		 * then there's nothing to do.
 		 */
-		if (!hash->count)
+		if (hash && !hash->count)
 			return;
 	}
 
@@ -1256,11 +1318,11 @@ static void __ftrace_hash_rec_update(struct ftrace_ops *ops,
 			 * Only the filter_hash affects all records.
 			 * Update if the record is not in the notrace hash.
 			 */
-			if (!ftrace_lookup_ip(other_hash, rec->ip))
+			if (!other_hash || !ftrace_lookup_ip(other_hash, rec->ip))
 				match = 1;
 		} else {
-			in_hash = !!ftrace_lookup_ip(hash, rec->ip);
-			in_other_hash = !!ftrace_lookup_ip(other_hash, rec->ip);
+			in_hash = hash && !!ftrace_lookup_ip(hash, rec->ip);
+			in_other_hash = other_hash && !!ftrace_lookup_ip(other_hash, rec->ip);
 
 			/*
 			 *
@@ -1546,6 +1608,7 @@ static void ftrace_run_update_code(int command)
 
 static ftrace_func_t saved_ftrace_func;
 static int ftrace_start_up;
+static int global_start_up;
 
 static void ftrace_startup_enable(int command)
 {
@@ -1562,14 +1625,25 @@ static void ftrace_startup_enable(int command)
 
 static void ftrace_startup(struct ftrace_ops *ops, int command)
 {
+	bool hash_enable = true;
+
 	if (unlikely(ftrace_disabled))
 		return;
 
 	ftrace_start_up++;
 	command |= FTRACE_ENABLE_CALLS;
 
+	/* ops marked global share the filter hashes */
+	if (ops->flags & FTRACE_OPS_FL_GLOBAL) {
+		ops = &global_ops;
+		/* Don't update hash if global is already set */
+		if (global_start_up)
+			hash_enable = false;
+		global_start_up++;
+	}
+
 	ops->flags |= FTRACE_OPS_FL_ENABLED;
-	if (ftrace_start_up == 1)
+	if (hash_enable)
 		ftrace_hash_rec_enable(ops, 1);
 
 	ftrace_startup_enable(command);
@@ -1577,6 +1651,8 @@ static void ftrace_startup(struct ftrace_ops *ops, int command)
 
 static void ftrace_shutdown(struct ftrace_ops *ops, int command)
 {
+	bool hash_disable = true;
+
 	if (unlikely(ftrace_disabled))
 		return;
 
@@ -1588,13 +1664,25 @@ static void ftrace_shutdown(struct ftrace_ops *ops, int command)
 	 */
 	WARN_ON_ONCE(ftrace_start_up < 0);
 
-	if (!ftrace_start_up)
+	if (ops->flags & FTRACE_OPS_FL_GLOBAL) {
+		ops = &global_ops;
+		global_start_up--;
+		WARN_ON_ONCE(global_start_up < 0);
+		/* Don't update hash if global still has users */
+		if (global_start_up) {
+			WARN_ON_ONCE(!ftrace_start_up);
+			hash_disable = false;
+		}
+	}
+
+	if (hash_disable)
 		ftrace_hash_rec_disable(ops, 1);
 
-	if (!ftrace_start_up) {
-		command |= FTRACE_DISABLE_CALLS;
+	if (ops != &global_ops || !global_start_up)
 		ops->flags &= ~FTRACE_OPS_FL_ENABLED;
-	}
+
+	if (!ftrace_start_up)
+		command |= FTRACE_DISABLE_CALLS;
 
 	if (saved_ftrace_func != ftrace_trace_function) {
 		saved_ftrace_func = ftrace_trace_function;
@@ -2381,6 +2469,7 @@ static int ftrace_probe_registered;
 
 static void __enable_ftrace_function_probe(void)
 {
+	int ret;
 	int i;
 
 	if (ftrace_probe_registered)
@@ -2395,13 +2484,16 @@ static void __enable_ftrace_function_probe(void)
 	if (i == FTRACE_FUNC_HASHSIZE)
 		return;
 
-	__register_ftrace_function(&trace_probe_ops);
-	ftrace_startup(&global_ops, 0);
+	ret = __register_ftrace_function(&trace_probe_ops);
+	if (!ret)
+		ftrace_startup(&trace_probe_ops, 0);
+
 	ftrace_probe_registered = 1;
 }
 
 static void __disable_ftrace_function_probe(void)
 {
+	int ret;
 	int i;
 
 	if (!ftrace_probe_registered)
@@ -2414,8 +2506,10 @@ static void __disable_ftrace_function_probe(void)
 	}
 
 	/* no more funcs left */
-	__unregister_ftrace_function(&trace_probe_ops);
-	ftrace_shutdown(&global_ops, 0);
+	ret = __unregister_ftrace_function(&trace_probe_ops);
+	if (!ret)
+		ftrace_shutdown(&trace_probe_ops, 0);
+
 	ftrace_probe_registered = 0;
 }
 
@@ -3319,8 +3413,28 @@ static inline void ftrace_startup_enable(int command) { }
 # define ftrace_shutdown(ops, command)	do { } while (0)
 # define ftrace_startup_sysctl()	do { } while (0)
 # define ftrace_shutdown_sysctl()	do { } while (0)
+
+static inline int
+ftrace_ops_test(struct ftrace_ops *ops, unsigned long ip)
+{
+	return 1;
+}
+
 #endif /* CONFIG_DYNAMIC_FTRACE */
 
+static void
+ftrace_ops_list_func(unsigned long ip, unsigned long parent_ip)
+{
+	/* see comment above ftrace_global_list_func */
+	struct ftrace_ops *op = rcu_dereference_raw(ftrace_ops_list);
+
+	while (op != &ftrace_list_end) {
+		if (ftrace_ops_test(op, ip))
+			op->func(ip, parent_ip);
+		op = rcu_dereference_raw(op->next);
+	};
+}
+
 static void clear_ftrace_swapper(void)
 {
 	struct task_struct *p;
@@ -3621,7 +3735,9 @@ int register_ftrace_function(struct ftrace_ops *ops)
 		goto out_unlock;
 
 	ret = __register_ftrace_function(ops);
-	ftrace_startup(&global_ops, 0);
+	if (!ret)
+		ftrace_startup(ops, 0);
+
 
  out_unlock:
 	mutex_unlock(&ftrace_lock);
@@ -3640,7 +3756,8 @@ int unregister_ftrace_function(struct ftrace_ops *ops)
 
 	mutex_lock(&ftrace_lock);
 	ret = __unregister_ftrace_function(ops);
-	ftrace_shutdown(&global_ops, 0);
+	if (!ret)
+		ftrace_shutdown(ops, 0);
 	mutex_unlock(&ftrace_lock);
 
 	return ret;
@@ -3670,11 +3787,11 @@ ftrace_enable_sysctl(struct ctl_table *table, int write,
 		ftrace_startup_sysctl();
 
 		/* we are starting ftrace again */
-		if (ftrace_list != &ftrace_list_end) {
-			if (ftrace_list->next == &ftrace_list_end)
-				ftrace_trace_function = ftrace_list->func;
+		if (ftrace_ops_list != &ftrace_list_end) {
+			if (ftrace_ops_list->next == &ftrace_list_end)
+				ftrace_trace_function = ftrace_ops_list->func;
 			else
-				ftrace_trace_function = ftrace_list_func;
+				ftrace_trace_function = ftrace_ops_list_func;
 		}
 
 	} else {
diff --git a/kernel/trace/trace_functions.c b/kernel/trace/trace_functions.c
index 16aee4d..8d0e1cc 100644
--- a/kernel/trace/trace_functions.c
+++ b/kernel/trace/trace_functions.c
@@ -149,11 +149,13 @@ function_stack_trace_call(unsigned long ip, unsigned long parent_ip)
 static struct ftrace_ops trace_ops __read_mostly =
 {
 	.func = function_trace_call,
+	.flags = FTRACE_OPS_FL_GLOBAL,
 };
 
 static struct ftrace_ops trace_stack_ops __read_mostly =
 {
 	.func = function_stack_trace_call,
+	.flags = FTRACE_OPS_FL_GLOBAL,
 };
 
 /* Our two options */
diff --git a/kernel/trace/trace_irqsoff.c b/kernel/trace/trace_irqsoff.c
index a4969b4..c77424b 100644
--- a/kernel/trace/trace_irqsoff.c
+++ b/kernel/trace/trace_irqsoff.c
@@ -153,6 +153,7 @@ irqsoff_tracer_call(unsigned long ip, unsigned long parent_ip)
 static struct ftrace_ops trace_ops __read_mostly =
 {
 	.func = irqsoff_tracer_call,
+	.flags = FTRACE_OPS_FL_GLOBAL,
 };
 #endif /* CONFIG_FUNCTION_TRACER */
 
diff --git a/kernel/trace/trace_sched_wakeup.c b/kernel/trace/trace_sched_wakeup.c
index 7319559..f029dd4 100644
--- a/kernel/trace/trace_sched_wakeup.c
+++ b/kernel/trace/trace_sched_wakeup.c
@@ -129,6 +129,7 @@ wakeup_tracer_call(unsigned long ip, unsigned long parent_ip)
 static struct ftrace_ops trace_ops __read_mostly =
 {
 	.func = wakeup_tracer_call,
+	.flags = FTRACE_OPS_FL_GLOBAL,
 };
 #endif /* CONFIG_FUNCTION_TRACER */
 
diff --git a/kernel/trace/trace_stack.c b/kernel/trace/trace_stack.c
index 4c5dead..b0b53b8 100644
--- a/kernel/trace/trace_stack.c
+++ b/kernel/trace/trace_stack.c
@@ -133,6 +133,7 @@ stack_trace_call(unsigned long ip, unsigned long parent_ip)
 static struct ftrace_ops trace_ops __read_mostly =
 {
 	.func = stack_trace_call,
+	.flags = FTRACE_OPS_FL_GLOBAL,
 };
 
 static ssize_t
-- 
1.7.4.4


