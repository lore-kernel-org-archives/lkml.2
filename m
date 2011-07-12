Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754929Ab1GLTDa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jul 2011 15:03:30 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:64204 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754126Ab1GLTDG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jul 2011 15:03:06 -0400
X-Authority-Analysis: v=1.1 cv=IOX921YOuPvYFce5aSLzPVIStpiCPR9M8R83dyHW74w= c=1 sm=0 a=vhdKIqpQuCYA:10 a=ovd7dP4hBxQA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=20KFwNOVAAAA:8 a=meVymXHHAAAA:8 a=pi2WgRGS0xrBYJmfHvoA:9 a=f3ZL9hyYS4wTPz5Opk0A:7 a=jEp0ucaQiEUA:10 a=Zh68SRI7RUMA:10 a=jeBq3FmKZ4MA:10 a=gsavC37neZqsaDin:21 a=pXq_jtlNwx2dqj18:21 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Message-Id: <20110712190302.136843904@goodmis.org>
User-Agent: quilt/0.48-1
Date: Tue, 12 Jul 2011 14:51:32 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: [RFC][PATCH 1/3] ftrace: Make ret_stack usable by other than function graph
References: <20110712185131.698851699@goodmis.org>
Content-Disposition: inline; filename=0001-ftrace-Make-ret_stack-usable-by-other-than-function-.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

Move the ret_stack code out of the CONFIG_FUNCTION_GRAPH_TRACER
macro section to enable it to be usable by other function tracers.

Requested-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 include/linux/ftrace.h |   17 ++--
 include/linux/sched.h  |   10 +-
 kernel/fork.c          |    4 +-
 kernel/sched.c         |    2 +-
 kernel/trace/ftrace.c  |  278 +++++++++++++++++++++++++++---------------------
 kernel/trace/trace.h   |    6 +
 6 files changed, 181 insertions(+), 136 deletions(-)

diff --git a/include/linux/ftrace.h b/include/linux/ftrace.h
index 9d88e1c..60e38c0 100644
--- a/include/linux/ftrace.h
+++ b/include/linux/ftrace.h
@@ -99,6 +99,10 @@ void clear_ftrace_function(void);
 
 extern void ftrace_stub(unsigned long a0, unsigned long a1);
 
+extern void ftrace_init_task(struct task_struct *t);
+extern void ftrace_exit_task(struct task_struct *t);
+extern void ftrace_init_idle_task(struct task_struct *t, int cpu);
+
 #else /* !CONFIG_FUNCTION_TRACER */
 /*
  * (un)register_ftrace_function must be a macro since the ops parameter
@@ -110,6 +114,11 @@ static inline void clear_ftrace_function(void) { }
 static inline void ftrace_kill(void) { }
 static inline void ftrace_stop(void) { }
 static inline void ftrace_start(void) { }
+
+static inline void ftrace_init_task(struct task_struct *t) { }
+static inline void ftrace_exit_task(struct task_struct *t) { }
+static inline void ftrace_init_idle_task(struct task_struct *t, int cpu) { }
+
 #endif /* CONFIG_FUNCTION_TRACER */
 
 #ifdef CONFIG_STACK_TRACER
@@ -443,10 +452,6 @@ extern trace_func_graph_ent_t ftrace_graph_entry;
 
 extern void unregister_ftrace_graph(void);
 
-extern void ftrace_graph_init_task(struct task_struct *t);
-extern void ftrace_graph_exit_task(struct task_struct *t);
-extern void ftrace_graph_init_idle_task(struct task_struct *t, int cpu);
-
 static inline int task_curr_ret_stack(struct task_struct *t)
 {
 	return t->curr_ret_stack;
@@ -467,10 +472,6 @@ static inline void unpause_graph_tracing(void)
 #define __irq_entry
 #define INIT_FTRACE_GRAPH
 
-static inline void ftrace_graph_init_task(struct task_struct *t) { }
-static inline void ftrace_graph_exit_task(struct task_struct *t) { }
-static inline void ftrace_graph_init_idle_task(struct task_struct *t, int cpu) { }
-
 static inline int register_ftrace_graph(trace_func_graph_ret_t retfunc,
 			  trace_func_graph_ent_t entryfunc)
 {
diff --git a/include/linux/sched.h b/include/linux/sched.h
index 496770a..c61b5bd 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1530,10 +1530,6 @@ struct task_struct {
 
 	struct list_head	*scm_work_list;
 #ifdef CONFIG_FUNCTION_GRAPH_TRACER
-	/* Index of current stored address in ret_stack */
-	int curr_ret_stack;
-	/* Stack of return addresses for return function tracing */
-	struct ftrace_ret_stack	*ret_stack;
 	/* time stamp for last schedule */
 	unsigned long long ftrace_timestamp;
 	/*
@@ -1544,6 +1540,12 @@ struct task_struct {
 	/* Pause for the tracing */
 	atomic_t tracing_graph_pause;
 #endif
+#ifdef CONFIG_FUNCTION_TRACER
+	/* Index of current stored address in ret_stack */
+	int curr_ret_stack;
+	/* Stack of return addresses for return function tracing */
+	struct ftrace_ret_stack	*ret_stack;
+#endif
 #ifdef CONFIG_TRACING
 	/* state flags for use by tracers */
 	unsigned long trace;
diff --git a/kernel/fork.c b/kernel/fork.c
index 0276c30..8516893e 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -167,7 +167,7 @@ void free_task(struct task_struct *tsk)
 	account_kernel_stack(tsk->stack, -1);
 	free_thread_info(tsk->stack);
 	rt_mutex_debug_task_free(tsk);
-	ftrace_graph_exit_task(tsk);
+	ftrace_exit_task(tsk);
 	free_task_struct(tsk);
 }
 EXPORT_SYMBOL(free_task);
@@ -1095,7 +1095,7 @@ static struct task_struct *copy_process(unsigned long clone_flags,
 	if (!p)
 		goto fork_out;
 
-	ftrace_graph_init_task(p);
+	ftrace_init_task(p);
 
 	rt_mutex_init_task(p);
 
diff --git a/kernel/sched.c b/kernel/sched.c
index 9769c75..6059180 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -5903,7 +5903,7 @@ void __cpuinit init_idle(struct task_struct *idle, int cpu)
 	 * The idle tasks have their own, simple scheduling class:
 	 */
 	idle->sched_class = &idle_sched_class;
-	ftrace_graph_init_idle_task(idle, cpu);
+	ftrace_init_idle_task(idle, cpu);
 }
 
 /*
diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index 908038f..20bdbd6 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -3895,20 +3895,88 @@ ftrace_enable_sysctl(struct ctl_table *table, int write,
 	return ret;
 }
 
+static int ret_stack_active;
+static DEFINE_PER_CPU(struct ftrace_ret_stack *, idle_ret_stack);
+static DEFINE_MUTEX(ret_stack_mutex);
+
+static void
+trace_init_task(struct task_struct *t, struct ftrace_ret_stack *ret_stack)
+{
 #ifdef CONFIG_FUNCTION_GRAPH_TRACER
+	atomic_set(&t->tracing_graph_pause, 0);
+	atomic_set(&t->trace_overrun, 0);
+	t->ftrace_timestamp = 0;
+#endif
+	/* make curr_ret_stack visible before we add the ret_stack */
+	smp_wmb();
+	t->ret_stack = ret_stack;
+}
 
-static int ftrace_graph_active;
-static struct notifier_block ftrace_suspend_notifier;
+/*
+ * Allocate a return stack for the idle task. May be the first
+ * time through, or it may be done by CPU hotplug online.
+ */
+void ftrace_init_idle_task(struct task_struct *t, int cpu)
+{
+	t->curr_ret_stack = -1;
+	/*
+	 * The idle task has no parent, it either has its own
+	 * stack or no stack at all.
+	 */
+	if (t->ret_stack)
+		WARN_ON(t->ret_stack != per_cpu(idle_ret_stack, cpu));
 
-int ftrace_graph_entry_stub(struct ftrace_graph_ent *trace)
+	/*
+	 * We don't care about races with ret_stack_active
+	 * being cleared here. If we allocate one too many, so
+	 * be it. The allocated stacks stay for the life of the
+	 * task anyway.
+	 */
+	if (ret_stack_active) {
+		struct ftrace_ret_stack *ret_stack;
+
+		ret_stack = per_cpu(idle_ret_stack, cpu);
+		if (!ret_stack) {
+			ret_stack = kmalloc(FTRACE_RETFUNC_DEPTH
+					    * sizeof(struct ftrace_ret_stack),
+					    GFP_KERNEL);
+			if (!ret_stack)
+				return;
+			per_cpu(idle_ret_stack, cpu) = ret_stack;
+		}
+		trace_init_task(t, ret_stack);
+	}
+}
+
+/* Allocate a return stack for newly created task */
+void ftrace_init_task(struct task_struct *t)
 {
-	return 0;
+	/* Make sure we do not use the parent ret_stack */
+	t->ret_stack = NULL;
+	t->curr_ret_stack = -1;
+
+	if (ret_stack_active) {
+		struct ftrace_ret_stack *ret_stack;
+
+		ret_stack = kmalloc(FTRACE_RETFUNC_DEPTH
+				* sizeof(struct ftrace_ret_stack),
+				GFP_KERNEL);
+		if (!ret_stack)
+			return;
+		trace_init_task(t, ret_stack);
+	}
 }
 
-/* The callbacks that hook a function */
-trace_func_graph_ret_t ftrace_graph_return =
-			(trace_func_graph_ret_t)ftrace_stub;
-trace_func_graph_ent_t ftrace_graph_entry = ftrace_graph_entry_stub;
+void ftrace_exit_task(struct task_struct *t)
+{
+	struct ftrace_ret_stack	*ret_stack = t->ret_stack;
+
+	t->ret_stack = NULL;
+	/* NULL must become visible to IRQs before we free it: */
+	barrier();
+
+	kfree(ret_stack);
+}
 
 /* Try to assign a return stack array on FTRACE_RETSTACK_ALLOC_SIZE tasks. */
 static int alloc_retstack_tasklist(struct ftrace_ret_stack **ret_stack_list)
@@ -3939,12 +4007,8 @@ static int alloc_retstack_tasklist(struct ftrace_ret_stack **ret_stack_list)
 		}
 
 		if (t->ret_stack == NULL) {
-			atomic_set(&t->tracing_graph_pause, 0);
-			atomic_set(&t->trace_overrun, 0);
 			t->curr_ret_stack = -1;
-			/* Make sure the tasks see the -1 first: */
-			smp_wmb();
-			t->ret_stack = ret_stack_list[start++];
+			trace_init_task(t, ret_stack_list[start++]);
 		}
 	} while_each_thread(g, t);
 
@@ -3956,6 +4020,73 @@ free:
 	return ret;
 }
 
+/* Allocate a return stack for each task */
+int trace_ret_stack_enable(void)
+{
+	struct ftrace_ret_stack **ret_stack_list;
+	int ret = -EBUSY;
+	int cpu;
+
+	mutex_lock(&ret_stack_mutex);
+
+	if (ret_stack_active)
+		goto out_unlock;
+
+	/* set ret_stack_active, as some functions need it set now */
+	ret_stack_active = 1;
+
+	ret_stack_list = kmalloc(FTRACE_RETSTACK_ALLOC_SIZE *
+				sizeof(struct ftrace_ret_stack *),
+				GFP_KERNEL);
+
+	if (!ret_stack_list) {
+		ret_stack_active = 0;
+		ret = -ENOMEM;
+		goto out_unlock;
+	}
+
+	/* The cpu_boot init_task->ret_stack will never be freed */
+	for_each_online_cpu(cpu) {
+		if (!idle_task(cpu)->ret_stack)
+			ftrace_init_idle_task(idle_task(cpu), cpu);
+	}
+
+	do {
+		ret = alloc_retstack_tasklist(ret_stack_list);
+	} while (ret == -EAGAIN);
+
+	if (ret)
+		ret_stack_active = 0;
+
+	kfree(ret_stack_list);
+ out_unlock:
+	mutex_unlock(&ret_stack_mutex);
+	return ret;
+}
+
+/* Does not free anything. Only makes new tasks not create a ret_stack */
+void trace_ret_stack_disable(void)
+{
+	mutex_lock(&ret_stack_mutex);
+	ret_stack_active = 0;
+	mutex_unlock(&ret_stack_mutex);
+}
+
+#ifdef CONFIG_FUNCTION_GRAPH_TRACER
+
+static int ftrace_graph_active;
+static struct notifier_block ftrace_suspend_notifier;
+
+int ftrace_graph_entry_stub(struct ftrace_graph_ent *trace)
+{
+	return 0;
+}
+
+/* The callbacks that hook a function */
+trace_func_graph_ret_t ftrace_graph_return =
+			(trace_func_graph_ret_t)ftrace_stub;
+trace_func_graph_ent_t ftrace_graph_entry = ftrace_graph_entry_stub;
+
 static void
 ftrace_graph_probe_sched_switch(void *ignore,
 			struct task_struct *prev, struct task_struct *next)
@@ -3988,40 +4119,6 @@ ftrace_graph_probe_sched_switch(void *ignore,
 		next->ret_stack[index].calltime += timestamp;
 }
 
-/* Allocate a return stack for each task */
-static int start_graph_tracing(void)
-{
-	struct ftrace_ret_stack **ret_stack_list;
-	int ret, cpu;
-
-	ret_stack_list = kmalloc(FTRACE_RETSTACK_ALLOC_SIZE *
-				sizeof(struct ftrace_ret_stack *),
-				GFP_KERNEL);
-
-	if (!ret_stack_list)
-		return -ENOMEM;
-
-	/* The cpu_boot init_task->ret_stack will never be freed */
-	for_each_online_cpu(cpu) {
-		if (!idle_task(cpu)->ret_stack)
-			ftrace_graph_init_idle_task(idle_task(cpu), cpu);
-	}
-
-	do {
-		ret = alloc_retstack_tasklist(ret_stack_list);
-	} while (ret == -EAGAIN);
-
-	if (!ret) {
-		ret = register_trace_sched_switch(ftrace_graph_probe_sched_switch, NULL);
-		if (ret)
-			pr_info("ftrace_graph: Couldn't activate tracepoint"
-				" probe to kernel_sched_switch\n");
-	}
-
-	kfree(ret_stack_list);
-	return ret;
-}
-
 /*
  * Hibernation protection.
  * The state of the current task is too much unstable during
@@ -4060,12 +4157,23 @@ int register_ftrace_graph(trace_func_graph_ret_t retfunc,
 	register_pm_notifier(&ftrace_suspend_notifier);
 
 	ftrace_graph_active++;
-	ret = start_graph_tracing();
+	ret = trace_ret_stack_enable();
+
+	if (!ret) {
+		ret = register_trace_sched_switch(ftrace_graph_probe_sched_switch, NULL);
+		if (ret) {
+			pr_info("ftrace_graph: Couldn't activate tracepoint"
+				" probe to kernel_sched_switch\n");
+			trace_ret_stack_disable();
+		}
+	}
+
 	if (ret) {
 		ftrace_graph_active--;
 		goto out;
 	}
 
+
 	ftrace_graph_return = retfunc;
 	ftrace_graph_entry = entryfunc;
 
@@ -4083,6 +4191,7 @@ void unregister_ftrace_graph(void)
 	if (unlikely(!ftrace_graph_active))
 		goto out;
 
+	trace_ret_stack_disable();
 	ftrace_graph_active--;
 	ftrace_graph_return = (trace_func_graph_ret_t)ftrace_stub;
 	ftrace_graph_entry = ftrace_graph_entry_stub;
@@ -4094,79 +4203,6 @@ void unregister_ftrace_graph(void)
 	mutex_unlock(&ftrace_lock);
 }
 
-static DEFINE_PER_CPU(struct ftrace_ret_stack *, idle_ret_stack);
-
-static void
-graph_init_task(struct task_struct *t, struct ftrace_ret_stack *ret_stack)
-{
-	atomic_set(&t->tracing_graph_pause, 0);
-	atomic_set(&t->trace_overrun, 0);
-	t->ftrace_timestamp = 0;
-	/* make curr_ret_stack visible before we add the ret_stack */
-	smp_wmb();
-	t->ret_stack = ret_stack;
-}
-
-/*
- * Allocate a return stack for the idle task. May be the first
- * time through, or it may be done by CPU hotplug online.
- */
-void ftrace_graph_init_idle_task(struct task_struct *t, int cpu)
-{
-	t->curr_ret_stack = -1;
-	/*
-	 * The idle task has no parent, it either has its own
-	 * stack or no stack at all.
-	 */
-	if (t->ret_stack)
-		WARN_ON(t->ret_stack != per_cpu(idle_ret_stack, cpu));
-
-	if (ftrace_graph_active) {
-		struct ftrace_ret_stack *ret_stack;
-
-		ret_stack = per_cpu(idle_ret_stack, cpu);
-		if (!ret_stack) {
-			ret_stack = kmalloc(FTRACE_RETFUNC_DEPTH
-					    * sizeof(struct ftrace_ret_stack),
-					    GFP_KERNEL);
-			if (!ret_stack)
-				return;
-			per_cpu(idle_ret_stack, cpu) = ret_stack;
-		}
-		graph_init_task(t, ret_stack);
-	}
-}
-
-/* Allocate a return stack for newly created task */
-void ftrace_graph_init_task(struct task_struct *t)
-{
-	/* Make sure we do not use the parent ret_stack */
-	t->ret_stack = NULL;
-	t->curr_ret_stack = -1;
-
-	if (ftrace_graph_active) {
-		struct ftrace_ret_stack *ret_stack;
-
-		ret_stack = kmalloc(FTRACE_RETFUNC_DEPTH
-				* sizeof(struct ftrace_ret_stack),
-				GFP_KERNEL);
-		if (!ret_stack)
-			return;
-		graph_init_task(t, ret_stack);
-	}
-}
-
-void ftrace_graph_exit_task(struct task_struct *t)
-{
-	struct ftrace_ret_stack	*ret_stack = t->ret_stack;
-
-	t->ret_stack = NULL;
-	/* NULL must become visible to IRQs before we free it: */
-	barrier();
-
-	kfree(ret_stack);
-}
-
 void ftrace_graph_stop(void)
 {
 	ftrace_stop();
diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
index 229f859..fa439f0 100644
--- a/kernel/trace/trace.h
+++ b/kernel/trace/trace.h
@@ -537,11 +537,17 @@ static inline int ftrace_trace_task(struct task_struct *task)
 
 	return test_tsk_trace_trace(task);
 }
+
+int trace_ret_stack_enable(void);
+void trace_ret_stack_disable(void);
+
 #else
 static inline int ftrace_trace_task(struct task_struct *task)
 {
 	return 1;
 }
+static inline int trace_ret_stack_enable(void) { return -ENODEV; }
+static inline void trace_ret_stack_disable(void) { }
 #endif
 
 /*
-- 
1.7.5.4


