Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758112Ab2ARSo4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jan 2012 13:44:56 -0500
Received: from mx1.redhat.com ([209.132.183.28]:10772 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758066Ab2ARSox (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jan 2012 13:44:53 -0500
From: Jiri Olsa <jolsa@redhat.com>
To: rostedt@goodmis.org, fweisbec@gmail.com, mingo@redhat.com,
        paulus@samba.org, acme@ghostprotocols.net, a.p.zijlstra@chello.nl
Cc: linux-kernel@vger.kernel.org, aarapov@redhat.com,
        Jiri Olsa <jolsa@redhat.com>
Subject: [PATCH 2/7] ftrace: Add enable/disable ftrace_ops control interface
Date: Wed, 18 Jan 2012 19:44:30 +0100
Message-Id: <1326912275-26405-3-git-send-email-jolsa@redhat.com>
In-Reply-To: <1326912275-26405-1-git-send-email-jolsa@redhat.com>
References: <1325495060-6402-1-git-send-email-jolsa@redhat.com>
 <1326912275-26405-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adding a way to temporarily enable/disable ftrace_ops. The change
follows the same way as 'global' ftrace_ops are done.

Introducing 2 global ftrace_ops - control_ops and ftrace_control_list
which take over all ftrace_ops registered with FTRACE_OPS_FL_CONTROL
flag. In addition new per cpu flag called 'disabled' is also added to
ftrace_ops to provide the control information for each cpu.

When ftrace_ops with FTRACE_OPS_FL_CONTROL is registered, it is
set as disabled for all cpus.

The ftrace_control_list contains all the registered 'control' ftrace_ops.
The control_ops provides function which iterates ftrace_control_list
and does the check for 'disabled' flag on current cpu.

Adding 2 inline functions ftrace_function_enable/ftrace_function_disable,
which enable/disable the ftrace_ops for given cpu.

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
---
 include/linux/ftrace.h |   56 ++++++++++++++++++++++
 kernel/trace/ftrace.c  |  119 +++++++++++++++++++++++++++++++++++++++++++++---
 kernel/trace/trace.h   |    2 +
 3 files changed, 170 insertions(+), 7 deletions(-)

diff --git a/include/linux/ftrace.h b/include/linux/ftrace.h
index f33fb3b..d3f529c 100644
--- a/include/linux/ftrace.h
+++ b/include/linux/ftrace.h
@@ -31,16 +31,32 @@ ftrace_enable_sysctl(struct ctl_table *table, int write,
 
 typedef void (*ftrace_func_t)(unsigned long ip, unsigned long parent_ip);
 
+/*
+ * FTRACE_OPS_FL_* bits denote the state of ftrace_ops struct and are
+ * set in the flags member.
+ *
+ * ENABLED - set/unset when ftrace_ops is registered/unregistered
+ * GLOBAL  - set manualy by ftrace_ops user to denote the ftrace_ops
+ *           is part of the global tracers sharing the same filter
+ *           via set_ftrace_* debugfs files.
+ * DYNAMIC - set when ftrace_ops is registered to denote dynamically
+ *           allocated ftrace_ops which need special care
+ * CONTROL - set manualy by ftrace_ops user to denote the ftrace_ops
+ *           could be controled by following calls:
+ *           ftrace_function_enable, ftrace_function_disable
+ */
 enum {
 	FTRACE_OPS_FL_ENABLED		= 1 << 0,
 	FTRACE_OPS_FL_GLOBAL		= 1 << 1,
 	FTRACE_OPS_FL_DYNAMIC		= 1 << 2,
+	FTRACE_OPS_FL_CONTROL		= 1 << 3,
 };
 
 struct ftrace_ops {
 	ftrace_func_t			func;
 	struct ftrace_ops		*next;
 	unsigned long			flags;
+	void __percpu			*disabled;
 #ifdef CONFIG_DYNAMIC_FTRACE
 	struct ftrace_hash		*notrace_hash;
 	struct ftrace_hash		*filter_hash;
@@ -97,6 +113,46 @@ int register_ftrace_function(struct ftrace_ops *ops);
 int unregister_ftrace_function(struct ftrace_ops *ops);
 void clear_ftrace_function(void);
 
+/**
+ * ftrace_function_enable - enable controlled ftrace_ops on given cpu
+ *
+ * This function enables tracing on given cpu by decreasing
+ * the per cpu control variable.
+ * It must be called with preemption disabled and only on
+ * ftrace_ops registered with FTRACE_OPS_FL_CONTROL.
+ */
+static inline void ftrace_function_enable(struct ftrace_ops *ops, int cpu)
+{
+	atomic_t *disabled;
+
+	if (WARN_ON_ONCE(!(ops->flags & FTRACE_OPS_FL_CONTROL) ||
+			 !preempt_count()))
+		return;
+
+	disabled = per_cpu_ptr(ops->disabled, cpu);
+	atomic_dec(disabled);
+}
+
+/**
+ * ftrace_function_disable - enable controlled ftrace_ops on given cpu
+ *
+ * This function enables tracing on given cpu by decreasing
+ * the per cpu control variable.
+ * It must be called with preemption disabled and only on
+ * ftrace_ops registered with FTRACE_OPS_FL_CONTROL.
+ */
+static inline void ftrace_function_disable(struct ftrace_ops *ops, int cpu)
+{
+	atomic_t *disabled;
+
+	if (WARN_ON_ONCE(!(ops->flags & FTRACE_OPS_FL_CONTROL) ||
+			 !preempt_count()))
+		return;
+
+	disabled = per_cpu_ptr(ops->disabled, cpu);
+	atomic_inc(disabled);
+}
+
 extern void ftrace_stub(unsigned long a0, unsigned long a1);
 
 #else /* !CONFIG_FUNCTION_TRACER */
diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index e2e0597..45c9b0c 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -62,6 +62,8 @@
 #define FTRACE_HASH_DEFAULT_BITS 10
 #define FTRACE_HASH_MAX_BITS 12
 
+#define FL_GLOBAL_CONTROL_MASK (FTRACE_OPS_FL_GLOBAL | FTRACE_OPS_FL_CONTROL)
+
 /* ftrace_enabled is a method to turn ftrace on or off */
 int ftrace_enabled __read_mostly;
 static int last_ftrace_enabled;
@@ -89,12 +91,14 @@ static struct ftrace_ops ftrace_list_end __read_mostly = {
 };
 
 static struct ftrace_ops *ftrace_global_list __read_mostly = &ftrace_list_end;
+static struct ftrace_ops *ftrace_control_list __read_mostly = &ftrace_list_end;
 static struct ftrace_ops *ftrace_ops_list __read_mostly = &ftrace_list_end;
 ftrace_func_t ftrace_trace_function __read_mostly = ftrace_stub;
 static ftrace_func_t __ftrace_trace_function_delay __read_mostly = ftrace_stub;
 ftrace_func_t __ftrace_trace_function __read_mostly = ftrace_stub;
 ftrace_func_t ftrace_pid_function __read_mostly = ftrace_stub;
 static struct ftrace_ops global_ops;
+static struct ftrace_ops control_ops;
 
 static void
 ftrace_ops_list_func(unsigned long ip, unsigned long parent_ip);
@@ -168,6 +172,38 @@ static void ftrace_test_stop_func(unsigned long ip, unsigned long parent_ip)
 }
 #endif
 
+static void control_ops_disable_all(struct ftrace_ops *ops)
+{
+	int cpu;
+
+	for_each_possible_cpu(cpu)
+		atomic_set(per_cpu_ptr(ops->disabled, cpu), 1);
+}
+
+static int control_ops_alloc(struct ftrace_ops *ops)
+{
+	atomic_t *disabled;
+
+	disabled = alloc_percpu(atomic_t);
+	if (!disabled)
+		return -ENOMEM;
+
+	ops->disabled = disabled;
+	control_ops_disable_all(ops);
+	return 0;
+}
+
+static void control_ops_free(struct ftrace_ops *ops)
+{
+	free_percpu(ops->disabled);
+}
+
+static int control_ops_is_disabled(struct ftrace_ops *ops, int cpu)
+{
+	atomic_t *disabled = per_cpu_ptr(ops->disabled, cpu);
+	return atomic_read(disabled);
+}
+
 static void update_global_ops(void)
 {
 	ftrace_func_t func;
@@ -259,6 +295,26 @@ static int remove_ftrace_ops(struct ftrace_ops **list, struct ftrace_ops *ops)
 	return 0;
 }
 
+static void add_ftrace_list_ops(struct ftrace_ops **list,
+				struct ftrace_ops *main_ops,
+				struct ftrace_ops *ops)
+{
+	int first = *list == &ftrace_list_end;
+	add_ftrace_ops(list, ops);
+	if (first)
+		add_ftrace_ops(&ftrace_ops_list, main_ops);
+}
+
+static int remove_ftrace_list_ops(struct ftrace_ops **list,
+				  struct ftrace_ops *main_ops,
+				  struct ftrace_ops *ops)
+{
+	int ret = remove_ftrace_ops(list, ops);
+	if (!ret && *list == &ftrace_list_end)
+		ret = remove_ftrace_ops(&ftrace_ops_list, main_ops);
+	return ret;
+}
+
 static int __register_ftrace_function(struct ftrace_ops *ops)
 {
 	if (ftrace_disabled)
@@ -270,15 +326,20 @@ static int __register_ftrace_function(struct ftrace_ops *ops)
 	if (WARN_ON(ops->flags & FTRACE_OPS_FL_ENABLED))
 		return -EBUSY;
 
+	/* We don't support both control and global flags set. */
+	if ((ops->flags & FL_GLOBAL_CONTROL_MASK) == FL_GLOBAL_CONTROL_MASK)
+		return -EINVAL;
+
 	if (!core_kernel_data((unsigned long)ops))
 		ops->flags |= FTRACE_OPS_FL_DYNAMIC;
 
 	if (ops->flags & FTRACE_OPS_FL_GLOBAL) {
-		int first = ftrace_global_list == &ftrace_list_end;
-		add_ftrace_ops(&ftrace_global_list, ops);
+		add_ftrace_list_ops(&ftrace_global_list, &global_ops, ops);
 		ops->flags |= FTRACE_OPS_FL_ENABLED;
-		if (first)
-			add_ftrace_ops(&ftrace_ops_list, &global_ops);
+	} else if (ops->flags & FTRACE_OPS_FL_CONTROL) {
+		if (control_ops_alloc(ops))
+			return -ENOMEM;
+		add_ftrace_list_ops(&ftrace_control_list, &control_ops, ops);
 	} else
 		add_ftrace_ops(&ftrace_ops_list, ops);
 
@@ -302,11 +363,23 @@ static int __unregister_ftrace_function(struct ftrace_ops *ops)
 		return -EINVAL;
 
 	if (ops->flags & FTRACE_OPS_FL_GLOBAL) {
-		ret = remove_ftrace_ops(&ftrace_global_list, ops);
-		if (!ret && ftrace_global_list == &ftrace_list_end)
-			ret = remove_ftrace_ops(&ftrace_ops_list, &global_ops);
+		ret = remove_ftrace_list_ops(&ftrace_global_list,
+					     &global_ops, ops);
 		if (!ret)
 			ops->flags &= ~FTRACE_OPS_FL_ENABLED;
+	} else if (ops->flags & FTRACE_OPS_FL_CONTROL) {
+		ret = remove_ftrace_list_ops(&ftrace_control_list,
+					     &control_ops, ops);
+		if (!ret) {
+			/*
+			 * The ftrace_ops is now removed from the list,
+			 * so there'll be no new users. We must ensure
+			 * all current users are done before we free
+			 * the control data.
+			 */
+			synchronize_sched();
+			control_ops_free(ops);
+		}
 	} else
 		ret = remove_ftrace_ops(&ftrace_ops_list, ops);
 
@@ -3874,6 +3947,38 @@ ftrace_ops_test(struct ftrace_ops *ops, unsigned long ip)
 #endif /* CONFIG_DYNAMIC_FTRACE */
 
 static void
+ftrace_ops_control_func(unsigned long ip, unsigned long parent_ip)
+{
+	struct ftrace_ops *op;
+	int cpu;
+
+	if (unlikely(trace_recursion_test(TRACE_CONTROL_BIT)))
+		return;
+
+	/*
+	 * Some of the ops may be dynamically allocated,
+	 * they must be freed after a synchronize_sched().
+	 */
+	preempt_disable_notrace();
+	trace_recursion_set(TRACE_CONTROL_BIT);
+	cpu = smp_processor_id();
+	op = rcu_dereference_raw(ftrace_control_list);
+	while (op != &ftrace_list_end) {
+		if (!control_ops_is_disabled(op, cpu) &&
+		    ftrace_ops_test(op, ip))
+			op->func(ip, parent_ip);
+
+		op = rcu_dereference_raw(op->next);
+	};
+	trace_recursion_clear(TRACE_CONTROL_BIT);
+	preempt_enable_notrace();
+}
+
+static struct ftrace_ops control_ops = {
+	.func = ftrace_ops_control_func,
+};
+
+static void
 ftrace_ops_list_func(unsigned long ip, unsigned long parent_ip)
 {
 	struct ftrace_ops *op;
diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
index 2c26574..41c54e3 100644
--- a/kernel/trace/trace.h
+++ b/kernel/trace/trace.h
@@ -288,6 +288,8 @@ struct tracer {
 /* for function tracing recursion */
 #define TRACE_INTERNAL_BIT		(1<<11)
 #define TRACE_GLOBAL_BIT		(1<<12)
+#define TRACE_CONTROL_BIT		(1<<13)
+
 /*
  * Abuse of the trace_recursion.
  * As we need a way to maintain state if we are tracing the function
-- 
1.7.1

