Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756915Ab1D2OnY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Apr 2011 10:43:24 -0400
Received: from mx1.redhat.com ([209.132.183.28]:18617 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754220Ab1D2OnW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Apr 2011 10:43:22 -0400
From: Jiri Olsa <jolsa@redhat.com>
To: rostedt@goodmis.org, fweisbec@gmail.com
Cc: linux-kernel@vger.kernel.org
Subject: [RFC 1/3] tracing: function tracer registration
Date: Fri, 29 Apr 2011 16:43:12 +0200
Message-Id: <1304088194-6214-2-git-send-email-jolsa@redhat.com>
In-Reply-To: <1304088194-6214-1-git-send-email-jolsa@redhat.com>
References: <1304088194-6214-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

adding ID and default tracer support for function
tracer registration

---
 arch/x86/include/asm/ftrace.h     |    2 +
 arch/x86/kernel/entry_64.S        |    6 +-
 arch/x86/kernel/ftrace.c          |   13 --
 include/linux/ftrace.h            |    9 +-
 kernel/trace/ftrace.c             |  290 +++++++++++++++----------------------
 kernel/trace/trace_events.c       |    1 +
 kernel/trace/trace_functions.c    |    2 +
 kernel/trace/trace_irqsoff.c      |    1 +
 kernel/trace/trace_sched_wakeup.c |    1 +
 kernel/trace/trace_stack.c        |    1 +
 10 files changed, 136 insertions(+), 190 deletions(-)

diff --git a/arch/x86/include/asm/ftrace.h b/arch/x86/include/asm/ftrace.h
index db24c22..45ae1fa 100644
--- a/arch/x86/include/asm/ftrace.h
+++ b/arch/x86/include/asm/ftrace.h
@@ -1,6 +1,8 @@
 #ifndef _ASM_X86_FTRACE_H
 #define _ASM_X86_FTRACE_H
 
+#define FTRACE_TRACERS_MAX 4
+
 #ifdef __ASSEMBLY__
 
 	.macro MCOUNT_SAVE_FRAME
diff --git a/arch/x86/kernel/entry_64.S b/arch/x86/kernel/entry_64.S
index 8a445a0..e0ba7d9 100644
--- a/arch/x86/kernel/entry_64.S
+++ b/arch/x86/kernel/entry_64.S
@@ -79,8 +79,10 @@ ENTRY(ftrace_caller)
 	movq 8(%rbp), %rsi
 	subq $MCOUNT_INSN_SIZE, %rdi
 
-GLOBAL(ftrace_call)
-	call ftrace_stub
+	/* by default call all registered handlers */
+	movq $-1, %rdx
+
+	call ftrace_call
 
 	MCOUNT_RESTORE_FRAME
 
diff --git a/arch/x86/kernel/ftrace.c b/arch/x86/kernel/ftrace.c
index 0ba15a6..dc92378 100644
--- a/arch/x86/kernel/ftrace.c
+++ b/arch/x86/kernel/ftrace.c
@@ -321,19 +321,6 @@ int ftrace_make_call(struct dyn_ftrace *rec, unsigned long addr)
 	return ftrace_modify_code(rec->ip, old, new);
 }
 
-int ftrace_update_ftrace_func(ftrace_func_t func)
-{
-	unsigned long ip = (unsigned long)(&ftrace_call);
-	unsigned char old[MCOUNT_INSN_SIZE], *new;
-	int ret;
-
-	memcpy(old, &ftrace_call, MCOUNT_INSN_SIZE);
-	new = ftrace_call_replace(ip, (unsigned long)func);
-	ret = ftrace_modify_code(ip, old, new);
-
-	return ret;
-}
-
 int __init ftrace_dyn_arch_init(void *data)
 {
 	/* The return code is retured via data */
diff --git a/include/linux/ftrace.h b/include/linux/ftrace.h
index ca29e03..b7ab09d 100644
--- a/include/linux/ftrace.h
+++ b/include/linux/ftrace.h
@@ -30,8 +30,9 @@ ftrace_enable_sysctl(struct ctl_table *table, int write,
 typedef void (*ftrace_func_t)(unsigned long ip, unsigned long parent_ip);
 
 struct ftrace_ops {
-	ftrace_func_t	  func;
-	struct ftrace_ops *next;
+	char *name;
+	int   id;
+	ftrace_func_t func;
 };
 
 extern int function_trace_stop;
@@ -175,9 +176,9 @@ int unregister_ftrace_command(struct ftrace_func_command *cmd);
 /* defined in arch */
 extern int ftrace_ip_converted(unsigned long ip);
 extern int ftrace_dyn_arch_init(void *data);
-extern int ftrace_update_ftrace_func(ftrace_func_t func);
 extern void ftrace_caller(void);
-extern void ftrace_call(void);
+extern void ftrace_call(unsigned long ip, unsigned long parent_ip,
+			unsigned long flags);
 extern void mcount_call(void);
 
 #ifndef FTRACE_ADDR
diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index ee24fa1..f1eedda 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -76,62 +76,12 @@ static int ftrace_disabled __read_mostly;
 
 static DEFINE_MUTEX(ftrace_lock);
 
-static struct ftrace_ops ftrace_list_end __read_mostly =
-{
-	.func		= ftrace_stub,
-};
-
-static struct ftrace_ops *ftrace_list __read_mostly = &ftrace_list_end;
-ftrace_func_t ftrace_trace_function __read_mostly = ftrace_stub;
-ftrace_func_t __ftrace_trace_function __read_mostly = ftrace_stub;
-ftrace_func_t ftrace_pid_function __read_mostly = ftrace_stub;
-
-/*
- * Traverse the ftrace_list, invoking all entries.  The reason that we
- * can use rcu_dereference_raw() is that elements removed from this list
- * are simply leaked, so there is no need to interact with a grace-period
- * mechanism.  The rcu_dereference_raw() calls are needed to handle
- * concurrent insertions into the ftrace_list.
- *
- * Silly Alpha and silly pointer-speculation compiler optimizations!
- */
-static void ftrace_list_func(unsigned long ip, unsigned long parent_ip)
-{
-	struct ftrace_ops *op = rcu_dereference_raw(ftrace_list); /*see above*/
-
-	while (op != &ftrace_list_end) {
-		op->func(ip, parent_ip);
-		op = rcu_dereference_raw(op->next); /*see above*/
-	};
-}
-
-static void ftrace_pid_func(unsigned long ip, unsigned long parent_ip)
-{
-	if (!test_tsk_trace_trace(current))
-		return;
-
-	ftrace_pid_function(ip, parent_ip);
-}
+static struct ftrace_ops *ftrace_tracers[FTRACE_TRACERS_MAX];
+static DECLARE_BITMAP(ftrace_tracers_bm, FTRACE_TRACERS_MAX);
+static int ftrace_tracers_cur = -1;
 
-static void set_ftrace_pid_function(ftrace_func_t func)
-{
-	/* do not set ftrace_pid_function to itself! */
-	if (func != ftrace_pid_func)
-		ftrace_pid_function = func;
-}
-
-/**
- * clear_ftrace_function - reset the ftrace function
- *
- * This NULLs the ftrace function and in essence stops
- * tracing.  There may be lag
- */
-void clear_ftrace_function(void)
-{
-	ftrace_trace_function = ftrace_stub;
-	__ftrace_trace_function = ftrace_stub;
-	ftrace_pid_function = ftrace_stub;
-}
+#define for_each_tracer(id, bm) \
+	for_each_set_bit(id, bm, FTRACE_TRACERS_MAX)
 
 #ifndef CONFIG_HAVE_FUNCTION_TRACE_MCOUNT_TEST
 /*
@@ -147,114 +97,82 @@ static void ftrace_test_stop_func(unsigned long ip, unsigned long parent_ip)
 }
 #endif
 
-static int __register_ftrace_function(struct ftrace_ops *ops)
-{
-	ops->next = ftrace_list;
-	/*
-	 * We are entering ops into the ftrace_list but another
-	 * CPU might be walking that list. We need to make sure
-	 * the ops->next pointer is valid before another CPU sees
-	 * the ops pointer included into the ftrace_list.
-	 */
-	rcu_assign_pointer(ftrace_list, ops);
 
-	if (ftrace_enabled) {
-		ftrace_func_t func;
+void ftrace_call(unsigned long ip, unsigned long parent_ip,
+		 unsigned long flags)
+{
+	int id;
 
-		if (ops->next == &ftrace_list_end)
-			func = ops->func;
-		else
-			func = ftrace_list_func;
+	if (!list_empty(&ftrace_pids) &&
+	    !test_tsk_trace_trace(current))
+		return;
 
-		if (!list_empty(&ftrace_pids)) {
-			set_ftrace_pid_function(func);
-			func = ftrace_pid_func;
-		}
+	rcu_read_lock();
+	for_each_tracer(id, &flags) {
+		struct ftrace_ops *ops = rcu_dereference(ftrace_tracers[id]);
+		if (!ops)
+			continue;
 
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
+		ops->func(ip, parent_ip);
 	}
-
-	return 0;
+	rcu_read_unlock();
 }
 
-static int __unregister_ftrace_function(struct ftrace_ops *ops)
+static int __register_ftrace_function(struct ftrace_ops *ops)
 {
-	struct ftrace_ops **p;
+	int id;
 
-	/*
-	 * If we are removing the last function, then simply point
-	 * to the ftrace_stub.
-	 */
-	if (ftrace_list == ops && ops->next == &ftrace_list_end) {
-		ftrace_trace_function = ftrace_stub;
-		ftrace_list = &ftrace_list_end;
-		return 0;
-	}
+	id = find_first_zero_bit(ftrace_tracers_bm, FTRACE_TRACERS_MAX);
+	if (id >= FTRACE_TRACERS_MAX)
+		return -ENOSPC;
 
-	for (p = &ftrace_list; *p != &ftrace_list_end; p = &(*p)->next)
-		if (*p == ops)
-			break;
+	ops->id = id;
+	set_bit(id, ftrace_tracers_bm);
+	ftrace_tracers_cur = id;
+	rcu_assign_pointer(ftrace_tracers[id], ops);
+	return 0;
+}
 
-	if (*p != ops)
-		return -1;
+static int __unregister_ftrace_function(struct ftrace_ops *ops)
+{
+	int id = ops->id;
 
-	*p = (*p)->next;
+	clear_bit(id, ftrace_tracers_bm);
+	BUG_ON(ops != ftrace_tracers[id]);
+	rcu_assign_pointer(ftrace_tracers[id], NULL);
 
-	if (ftrace_enabled) {
-		/* If we only have one func left, then call that directly */
-		if (ftrace_list->next == &ftrace_list_end) {
-			ftrace_func_t func = ftrace_list->func;
+	if (ftrace_tracers_cur != id)
+		return 0;
 
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
+	/* find another default tracer */
+	ftrace_tracers_cur = find_first_bit(ftrace_tracers_bm,
+					    FTRACE_TRACERS_MAX);
+	if (ftrace_tracers_cur >= FTRACE_TRACERS_MAX)
+		ftrace_tracers_cur = -1;
 
 	return 0;
 }
 
-static void ftrace_update_pid_func(void)
+static int ftrace_tracer_default(char *name)
 {
-	ftrace_func_t func;
+	int id, ret = -EINVAL;
 
-	if (ftrace_trace_function == ftrace_stub)
-		return;
+	mutex_lock(&ftrace_lock);
+	for_each_tracer(id, ftrace_tracers_bm) {
+		struct ftrace_ops *ops = ftrace_tracers[id];
+		BUG_ON(!ops);
 
-#ifdef CONFIG_HAVE_FUNCTION_TRACE_MCOUNT_TEST
-	func = ftrace_trace_function;
-#else
-	func = __ftrace_trace_function;
-#endif
+		if (!strcmp(name, ops->name))
+			break;
+	}
 
-	if (!list_empty(&ftrace_pids)) {
-		set_ftrace_pid_function(func);
-		func = ftrace_pid_func;
-	} else {
-		if (func == ftrace_pid_func)
-			func = ftrace_pid_function;
+	if (id < FTRACE_TRACERS_MAX) {
+		ftrace_tracers_cur = id;
+		ret = 0;
 	}
 
-#ifdef CONFIG_HAVE_FUNCTION_TRACE_MCOUNT_TEST
-	ftrace_trace_function = func;
-#else
-	__ftrace_trace_function = func;
-#endif
+	mutex_unlock(&ftrace_lock);
+	return ret;
 }
 
 #ifdef CONFIG_FUNCTION_PROFILER
@@ -717,6 +635,7 @@ static void unregister_ftrace_profiler(void)
 #else
 static struct ftrace_ops ftrace_profile_ops __read_mostly =
 {
+	.name		= "trace_profile",
 	.func		= function_profile_call,
 };
 
@@ -1143,9 +1062,6 @@ static int __ftrace_modify_code(void *data)
 	else if (*command & FTRACE_DISABLE_CALLS)
 		ftrace_replace_code(0);
 
-	if (*command & FTRACE_UPDATE_TRACE_FUNC)
-		ftrace_update_ftrace_func(ftrace_trace_function);
-
 	if (*command & FTRACE_START_FUNC_RET)
 		ftrace_enable_ftrace_graph_caller();
 	else if (*command & FTRACE_STOP_FUNC_RET)
@@ -1174,11 +1090,6 @@ static int ftrace_start_up;
 
 static void ftrace_startup_enable(int command)
 {
-	if (saved_ftrace_func != ftrace_trace_function) {
-		saved_ftrace_func = ftrace_trace_function;
-		command |= FTRACE_UPDATE_TRACE_FUNC;
-	}
-
 	if (!command || !ftrace_enabled)
 		return;
 
@@ -1212,11 +1123,6 @@ static void ftrace_shutdown(int command)
 	if (!ftrace_start_up)
 		command |= FTRACE_DISABLE_CALLS;
 
-	if (saved_ftrace_func != ftrace_trace_function) {
-		saved_ftrace_func = ftrace_trace_function;
-		command |= FTRACE_UPDATE_TRACE_FUNC;
-	}
-
 	if (!command || !ftrace_enabled)
 		return;
 
@@ -1732,6 +1638,53 @@ ftrace_regex_lseek(struct file *file, loff_t offset, int origin)
 	return ret;
 }
 
+static int ftrace_tracers_show(struct seq_file *seq, void *v)
+{
+	int id;
+
+	mutex_lock(&ftrace_lock);
+	for_each_tracer(id, ftrace_tracers_bm) {
+		struct ftrace_ops *ops = ftrace_tracers[id];
+
+		BUG_ON(!ops);
+		seq_printf(seq, "%s%s\n",
+			ftrace_tracers_cur == id ? "*" : " ",
+			ops->name);
+	}
+
+	mutex_unlock(&ftrace_lock);
+	return 0;
+}
+
+static int
+ftrace_tracers_open(struct inode *inode, struct file *file)
+{
+	return single_open(file, ftrace_tracers_show, NULL);
+}
+
+static ssize_t
+ftrace_tracers_write(struct file *filp, const char __user *ubuf, size_t cnt,
+		     loff_t *ppos)
+{
+	char buf[64];
+	int i;
+
+	if (cnt >= sizeof(buf))
+		return -EINVAL;
+
+	if (copy_from_user(&buf, ubuf, cnt))
+		return -EFAULT;
+
+	buf[cnt] = 0;
+	for (i = cnt - 1; i > 0 && isspace(buf[i]); i--)
+		buf[i] = 0;
+
+	if (ftrace_tracer_default(buf))
+		return -EINVAL;
+
+	return cnt;
+}
+
 static int ftrace_match(char *str, char *regex, int len, int type)
 {
 	int matched = 0;
@@ -1952,6 +1905,7 @@ function_trace_probe_call(unsigned long ip, unsigned long parent_ip)
 
 static struct ftrace_ops trace_probe_ops __read_mostly =
 {
+	.name		= "trace_probe",
 	.func		= function_trace_probe_call,
 };
 
@@ -2467,6 +2421,14 @@ static const struct file_operations ftrace_notrace_fops = {
 	.release = ftrace_notrace_release,
 };
 
+static const struct file_operations ftrace_tracers_fops = {
+	.open		= ftrace_tracers_open,
+	.read		= seq_read,
+	.release	= single_release,
+	.llseek		= seq_lseek,
+	.write          = ftrace_tracers_write,
+};
+
 #ifdef CONFIG_FUNCTION_GRAPH_TRACER
 
 static DEFINE_MUTEX(graph_lock);
@@ -2688,6 +2650,9 @@ static __init int ftrace_init_dyn_debugfs(struct dentry *d_tracer)
 	trace_create_file("set_ftrace_notrace", 0644, d_tracer,
 				    NULL, &ftrace_notrace_fops);
 
+	trace_create_file("function_tracers", 0644, d_tracer,
+				    NULL, &ftrace_tracers_fops);
+
 #ifdef CONFIG_FUNCTION_GRAPH_TRACER
 	trace_create_file("set_graph_function", 0444, d_tracer,
 				    NULL,
@@ -2950,7 +2915,6 @@ static int ftrace_pid_add(int p)
 
 	set_ftrace_pid_task(pid);
 
-	ftrace_update_pid_func();
 	ftrace_startup_enable(0);
 
 	mutex_unlock(&ftrace_lock);
@@ -2979,7 +2943,6 @@ static void ftrace_pid_reset(void)
 		kfree(fpid);
 	}
 
-	ftrace_update_pid_func();
 	ftrace_startup_enable(0);
 
 	mutex_unlock(&ftrace_lock);
@@ -3127,7 +3090,6 @@ void ftrace_kill(void)
 {
 	ftrace_disabled = 1;
 	ftrace_enabled = 0;
-	clear_ftrace_function();
 }
 
 /**
@@ -3194,24 +3156,10 @@ ftrace_enable_sysctl(struct ctl_table *table, int write,
 
 	last_ftrace_enabled = !!ftrace_enabled;
 
-	if (ftrace_enabled) {
-
+	if (ftrace_enabled)
 		ftrace_startup_sysctl();
-
-		/* we are starting ftrace again */
-		if (ftrace_list != &ftrace_list_end) {
-			if (ftrace_list->next == &ftrace_list_end)
-				ftrace_trace_function = ftrace_list->func;
-			else
-				ftrace_trace_function = ftrace_list_func;
-		}
-
-	} else {
-		/* stopping ftrace calls (just send to ftrace_stub) */
-		ftrace_trace_function = ftrace_stub;
-
+	else
 		ftrace_shutdown_sysctl();
-	}
 
  out:
 	mutex_unlock(&ftrace_lock);
diff --git a/kernel/trace/trace_events.c b/kernel/trace/trace_events.c
index e88f74f..43600a1 100644
--- a/kernel/trace/trace_events.c
+++ b/kernel/trace/trace_events.c
@@ -1651,6 +1651,7 @@ function_test_events_call(unsigned long ip, unsigned long parent_ip)
 
 static struct ftrace_ops trace_ops __initdata  =
 {
+	.name = "trace_event",
 	.func = function_test_events_call,
 };
 
diff --git a/kernel/trace/trace_functions.c b/kernel/trace/trace_functions.c
index 16aee4d..a991743 100644
--- a/kernel/trace/trace_functions.c
+++ b/kernel/trace/trace_functions.c
@@ -148,11 +148,13 @@ function_stack_trace_call(unsigned long ip, unsigned long parent_ip)
 
 static struct ftrace_ops trace_ops __read_mostly =
 {
+	.name = "trace",
 	.func = function_trace_call,
 };
 
 static struct ftrace_ops trace_stack_ops __read_mostly =
 {
+	.name = "trace_stack",
 	.func = function_stack_trace_call,
 };
 
diff --git a/kernel/trace/trace_irqsoff.c b/kernel/trace/trace_irqsoff.c
index a4969b4..6983594 100644
--- a/kernel/trace/trace_irqsoff.c
+++ b/kernel/trace/trace_irqsoff.c
@@ -152,6 +152,7 @@ irqsoff_tracer_call(unsigned long ip, unsigned long parent_ip)
 
 static struct ftrace_ops trace_ops __read_mostly =
 {
+	.name = "trace_irqs",
 	.func = irqsoff_tracer_call,
 };
 #endif /* CONFIG_FUNCTION_TRACER */
diff --git a/kernel/trace/trace_sched_wakeup.c b/kernel/trace/trace_sched_wakeup.c
index 7319559..f8b4622 100644
--- a/kernel/trace/trace_sched_wakeup.c
+++ b/kernel/trace/trace_sched_wakeup.c
@@ -128,6 +128,7 @@ wakeup_tracer_call(unsigned long ip, unsigned long parent_ip)
 
 static struct ftrace_ops trace_ops __read_mostly =
 {
+	.name = "trace_wakeup",
 	.func = wakeup_tracer_call,
 };
 #endif /* CONFIG_FUNCTION_TRACER */
diff --git a/kernel/trace/trace_stack.c b/kernel/trace/trace_stack.c
index 4c5dead..31f361e 100644
--- a/kernel/trace/trace_stack.c
+++ b/kernel/trace/trace_stack.c
@@ -132,6 +132,7 @@ stack_trace_call(unsigned long ip, unsigned long parent_ip)
 
 static struct ftrace_ops trace_ops __read_mostly =
 {
+	.name = "trace_stack",
 	.func = stack_trace_call,
 };
 
-- 
1.7.1

