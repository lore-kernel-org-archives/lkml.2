Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965124Ab1C3V04 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 17:26:56 -0400
Received: from mga01.intel.com ([192.55.52.88]:14820 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965064Ab1C3VJH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 17:09:07 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.63,270,1299484800"; 
   d="scan'208";a="673447974"
From: Andi Kleen <andi@firstfloor.org>
References: <20110330203.501921634@firstfloor.org>
In-Reply-To: <20110330203.501921634@firstfloor.org>
To: srostedt@redhat.com, rostedt@goodmis.org, gregkh@suse.de,
        ak@linux.intel.com, linux-kernel@vger.kernel.org, stable@kernel.org,
        tim.bird@am.sony.com
Subject: [PATCH] [189/275] ftrace: Fix memory leak with function graph and cpu hotplug
Message-Id: <20110330210712.AFD4D3E1A05@tassilo.jf.intel.com>
Date: Wed, 30 Mar 2011 14:07:12 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------
From: Steven Rostedt <srostedt@redhat.com>

commit 868baf07b1a259f5f3803c1dc2777b6c358f83cf upstream.

When the fuction graph tracer starts, it needs to make a special
stack for each task to save the real return values of the tasks.
All running tasks have this stack created, as well as any new
tasks.

On CPU hot plug, the new idle task will allocate a stack as well
when init_idle() is called. The problem is that cpu hotplug does
not create a new idle_task. Instead it uses the idle task that
existed when the cpu went down.

ftrace_graph_init_task() will add a new ret_stack to the task
that is given to it. Because a clone will make the task
have a stack of its parent it does not check if the task's
ret_stack is already NULL or not. When the CPU hotplug code
starts a CPU up again, it will allocate a new stack even
though one already existed for it.

The solution is to treat the idle_task specially. In fact, the
function_graph code already does, just not at init_idle().
Instead of using the ftrace_graph_init_task() for the idle task,
which that function expects the task to be a clone, have a
separate ftrace_graph_init_idle_task(). Also, we will create a
per_cpu ret_stack that is used by the idle task. When we call
ftrace_graph_init_idle_task() it will check if the idle task's
ret_stack is NULL, if it is, then it will assign it the per_cpu
ret_stack.

Reported-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Suggested-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 include/linux/ftrace.h |    2 +
 kernel/sched.c         |    2 -
 kernel/trace/ftrace.c  |   52 ++++++++++++++++++++++++++++++++++++++++++-------
 3 files changed, 48 insertions(+), 8 deletions(-)

Index: linux-2.6.35.y/include/linux/ftrace.h
===================================================================
--- linux-2.6.35.y.orig/include/linux/ftrace.h	2011-03-29 22:50:45.996081494 -0700
+++ linux-2.6.35.y/include/linux/ftrace.h	2011-03-29 23:03:02.204243769 -0700
@@ -423,6 +423,7 @@
 
 extern void ftrace_graph_init_task(struct task_struct *t);
 extern void ftrace_graph_exit_task(struct task_struct *t);
+extern void ftrace_graph_init_idle_task(struct task_struct *t, int cpu);
 
 static inline int task_curr_ret_stack(struct task_struct *t)
 {
@@ -446,6 +447,7 @@
 
 static inline void ftrace_graph_init_task(struct task_struct *t) { }
 static inline void ftrace_graph_exit_task(struct task_struct *t) { }
+static inline void ftrace_graph_init_idle_task(struct task_struct *t, int cpu) { }
 
 static inline int register_ftrace_graph(trace_func_graph_ret_t retfunc,
 			  trace_func_graph_ent_t entryfunc)
Index: linux-2.6.35.y/kernel/sched.c
===================================================================
--- linux-2.6.35.y.orig/kernel/sched.c	2011-03-29 23:03:00.443288827 -0700
+++ linux-2.6.35.y/kernel/sched.c	2011-03-29 23:03:02.207243691 -0700
@@ -5428,7 +5428,7 @@
 	 * The idle tasks have their own, simple scheduling class:
 	 */
 	idle->sched_class = &idle_sched_class;
-	ftrace_graph_init_task(idle);
+	ftrace_graph_init_idle_task(idle, cpu);
 }
 
 /*
Index: linux-2.6.35.y/kernel/trace/ftrace.c
===================================================================
--- linux-2.6.35.y.orig/kernel/trace/ftrace.c	2011-03-29 22:50:45.996081494 -0700
+++ linux-2.6.35.y/kernel/trace/ftrace.c	2011-03-29 23:03:02.225243230 -0700
@@ -3290,7 +3290,7 @@
 	/* The cpu_boot init_task->ret_stack will never be freed */
 	for_each_online_cpu(cpu) {
 		if (!idle_task(cpu)->ret_stack)
-			ftrace_graph_init_task(idle_task(cpu));
+			ftrace_graph_init_idle_task(idle_task(cpu), cpu);
 	}
 
 	do {
@@ -3380,6 +3380,49 @@
 	mutex_unlock(&ftrace_lock);
 }
 
+static DEFINE_PER_CPU(struct ftrace_ret_stack *, idle_ret_stack);
+
+static void
+graph_init_task(struct task_struct *t, struct ftrace_ret_stack *ret_stack)
+{
+	atomic_set(&t->tracing_graph_pause, 0);
+	atomic_set(&t->trace_overrun, 0);
+	t->ftrace_timestamp = 0;
+	/* make curr_ret_stack visable before we add the ret_stack */
+	smp_wmb();
+	t->ret_stack = ret_stack;
+}
+
+/*
+ * Allocate a return stack for the idle task. May be the first
+ * time through, or it may be done by CPU hotplug online.
+ */
+void ftrace_graph_init_idle_task(struct task_struct *t, int cpu)
+{
+	t->curr_ret_stack = -1;
+	/*
+	 * The idle task has no parent, it either has its own
+	 * stack or no stack at all.
+	 */
+	if (t->ret_stack)
+		WARN_ON(t->ret_stack != per_cpu(idle_ret_stack, cpu));
+
+	if (ftrace_graph_active) {
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
+		graph_init_task(t, ret_stack);
+	}
+}
+
 /* Allocate a return stack for newly created task */
 void ftrace_graph_init_task(struct task_struct *t)
 {
@@ -3395,12 +3438,7 @@
 				GFP_KERNEL);
 		if (!ret_stack)
 			return;
-		atomic_set(&t->tracing_graph_pause, 0);
-		atomic_set(&t->trace_overrun, 0);
-		t->ftrace_timestamp = 0;
-		/* make curr_ret_stack visable before we add the ret_stack */
-		smp_wmb();
-		t->ret_stack = ret_stack;
+		graph_init_task(t, ret_stack);
 	}
 }
 
