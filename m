Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756116Ab1EKPz7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 May 2011 11:55:59 -0400
Received: from mx1.redhat.com ([209.132.183.28]:15118 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755364Ab1EKPz4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 May 2011 11:55:56 -0400
From: Avi Kivity <avi@redhat.com>
To: linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Subject: [PATCH v1 1/5] perf: add context parameter to perf_event overflow handler
Date: Wed, 11 May 2011 11:55:29 -0400
Message-Id: <1305129333-7456-2-git-send-email-avi@redhat.com>
In-Reply-To: <1305129333-7456-1-git-send-email-avi@redhat.com>
References: <1305129333-7456-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The perf_event overflow handler does not receive any caller-derived
argument, so many callers need to resort to looking up the perf_event
in their local data structure.  This is ugly and doesn't scale if a
single callback services many perf_events.

Fix by adding a context parameter to perf_event_create_kernel_counter()
(and derived hardware breakpoints APIs) and pass it to the callback.
All callers are updated.

Signed-off-by: Avi Kivity <avi@redhat.com>
---
 arch/arm/kernel/ptrace.c                |   10 ++++++----
 arch/powerpc/kernel/ptrace.c            |    4 ++--
 arch/sh/kernel/ptrace_32.c              |    5 +++--
 arch/x86/kernel/kgdb.c                  |    2 +-
 arch/x86/kernel/ptrace.c                |    5 +++--
 drivers/oprofile/oprofile_perf.c        |    5 +++--
 include/linux/hw_breakpoint.h           |   10 ++++++++--
 include/linux/perf_event.h              |    8 ++++++--
 kernel/events/core.c                    |   24 +++++++++++++++++-------
 kernel/events/hw_breakpoint.c           |   10 +++++++---
 kernel/watchdog.c                       |    7 +++++--
 samples/hw_breakpoint/data_breakpoint.c |    5 +++--
 12 files changed, 64 insertions(+), 31 deletions(-)

diff --git a/arch/arm/kernel/ptrace.c b/arch/arm/kernel/ptrace.c
index 8182f45..1d6c4ae 100644
--- a/arch/arm/kernel/ptrace.c
+++ b/arch/arm/kernel/ptrace.c
@@ -497,9 +497,10 @@ static long ptrace_hbp_idx_to_num(int idx)
 /*
  * Handle hitting a HW-breakpoint.
  */
-static void ptrace_hbptriggered(struct perf_event *bp, int unused,
-				     struct perf_sample_data *data,
-				     struct pt_regs *regs)
+static void ptrace_hbptriggered(void *context,
+				struct perf_event *bp, int unused,
+				struct perf_sample_data *data,
+				struct pt_regs *regs)
 {
 	struct arch_hw_breakpoint *bkpt = counter_arch_bp(bp);
 	long num;
@@ -580,7 +581,8 @@ static struct perf_event *ptrace_hbp_create(struct task_struct *tsk, int type)
 	attr.bp_type	= type;
 	attr.disabled	= 1;
 
-	return register_user_hw_breakpoint(&attr, ptrace_hbptriggered, tsk);
+	return register_user_hw_breakpoint(&attr, ptrace_hbptriggered, NULL,
+					   tsk);
 }
 
 static int ptrace_gethbpregs(struct task_struct *tsk, long num,
diff --git a/arch/powerpc/kernel/ptrace.c b/arch/powerpc/kernel/ptrace.c
index a6ae1cf..4d42f06 100644
--- a/arch/powerpc/kernel/ptrace.c
+++ b/arch/powerpc/kernel/ptrace.c
@@ -878,7 +878,7 @@ void user_disable_single_step(struct task_struct *task)
 }
 
 #ifdef CONFIG_HAVE_HW_BREAKPOINT
-void ptrace_triggered(struct perf_event *bp, int nmi,
+void ptrace_triggered(void *context, struct perf_event *bp, int nmi,
 		      struct perf_sample_data *data, struct pt_regs *regs)
 {
 	struct perf_event_attr attr;
@@ -969,7 +969,7 @@ int ptrace_set_debugreg(struct task_struct *task, unsigned long addr,
 								&attr.bp_type);
 
 	thread->ptrace_bps[0] = bp = register_user_hw_breakpoint(&attr,
-							ptrace_triggered, task);
+					       ptrace_triggered, NULL, task);
 	if (IS_ERR(bp)) {
 		thread->ptrace_bps[0] = NULL;
 		ptrace_put_breakpoints(task);
diff --git a/arch/sh/kernel/ptrace_32.c b/arch/sh/kernel/ptrace_32.c
index 3d7b209..b08c8b0 100644
--- a/arch/sh/kernel/ptrace_32.c
+++ b/arch/sh/kernel/ptrace_32.c
@@ -63,7 +63,7 @@ static inline int put_stack_long(struct task_struct *task, int offset,
 	return 0;
 }
 
-void ptrace_triggered(struct perf_event *bp, int nmi,
+void ptrace_triggered(void *context, struct perf_event *bp, int nmi,
 		      struct perf_sample_data *data, struct pt_regs *regs)
 {
 	struct perf_event_attr attr;
@@ -91,7 +91,8 @@ static int set_single_step(struct task_struct *tsk, unsigned long addr)
 		attr.bp_len = HW_BREAKPOINT_LEN_2;
 		attr.bp_type = HW_BREAKPOINT_R;
 
-		bp = register_user_hw_breakpoint(&attr, ptrace_triggered, tsk);
+		bp = register_user_hw_breakpoint(&attr, ptrace_triggered,
+						 NULL, tsk);
 		if (IS_ERR(bp))
 			return PTR_ERR(bp);
 
diff --git a/arch/x86/kernel/kgdb.c b/arch/x86/kernel/kgdb.c
index 5f9ecff..473ab53 100644
--- a/arch/x86/kernel/kgdb.c
+++ b/arch/x86/kernel/kgdb.c
@@ -638,7 +638,7 @@ void kgdb_arch_late(void)
 	for (i = 0; i < HBP_NUM; i++) {
 		if (breakinfo[i].pev)
 			continue;
-		breakinfo[i].pev = register_wide_hw_breakpoint(&attr, NULL);
+		breakinfo[i].pev = register_wide_hw_breakpoint(&attr, NULL, NULL);
 		if (IS_ERR((void * __force)breakinfo[i].pev)) {
 			printk(KERN_ERR "kgdb: Could not allocate hw"
 			       "breakpoints\nDisabling the kernel debugger\n");
diff --git a/arch/x86/kernel/ptrace.c b/arch/x86/kernel/ptrace.c
index f65e5b5..418f5c6 100644
--- a/arch/x86/kernel/ptrace.c
+++ b/arch/x86/kernel/ptrace.c
@@ -528,7 +528,7 @@ static int genregs_set(struct task_struct *target,
 	return ret;
 }
 
-static void ptrace_triggered(struct perf_event *bp, int nmi,
+static void ptrace_triggered(void *context, struct perf_event *bp, int nmi,
 			     struct perf_sample_data *data,
 			     struct pt_regs *regs)
 {
@@ -715,7 +715,8 @@ static int ptrace_set_breakpoint_addr(struct task_struct *tsk, int nr,
 		attr.bp_type = HW_BREAKPOINT_W;
 		attr.disabled = 1;
 
-		bp = register_user_hw_breakpoint(&attr, ptrace_triggered, tsk);
+		bp = register_user_hw_breakpoint(&attr, ptrace_triggered,
+						 NULL, tsk);
 
 		/*
 		 * CHECKME: the previous code returned -EIO if the addr wasn't
diff --git a/drivers/oprofile/oprofile_perf.c b/drivers/oprofile/oprofile_perf.c
index 9046f7b..68e7f37 100644
--- a/drivers/oprofile/oprofile_perf.c
+++ b/drivers/oprofile/oprofile_perf.c
@@ -31,7 +31,8 @@ static int num_counters;
 /*
  * Overflow callback for oprofile.
  */
-static void op_overflow_handler(struct perf_event *event, int unused,
+static void op_overflow_handler(void *context,
+			struct perf_event *event, int unused,
 			struct perf_sample_data *data, struct pt_regs *regs)
 {
 	int id;
@@ -79,7 +80,7 @@ static int op_create_counter(int cpu, int event)
 
 	pevent = perf_event_create_kernel_counter(&counter_config[event].attr,
 						  cpu, NULL,
-						  op_overflow_handler);
+						  op_overflow_handler, NULL);
 
 	if (IS_ERR(pevent))
 		return PTR_ERR(pevent);
diff --git a/include/linux/hw_breakpoint.h b/include/linux/hw_breakpoint.h
index d1e55fe..6ae9c63 100644
--- a/include/linux/hw_breakpoint.h
+++ b/include/linux/hw_breakpoint.h
@@ -73,6 +73,7 @@ static inline unsigned long hw_breakpoint_len(struct perf_event *bp)
 extern struct perf_event *
 register_user_hw_breakpoint(struct perf_event_attr *attr,
 			    perf_overflow_handler_t triggered,
+			    void *context,
 			    struct task_struct *tsk);
 
 /* FIXME: only change from the attr, and don't unregister */
@@ -85,11 +86,13 @@ modify_user_hw_breakpoint(struct perf_event *bp, struct perf_event_attr *attr);
 extern struct perf_event *
 register_wide_hw_breakpoint_cpu(struct perf_event_attr *attr,
 				perf_overflow_handler_t	triggered,
+				void *context,
 				int cpu);
 
 extern struct perf_event * __percpu *
 register_wide_hw_breakpoint(struct perf_event_attr *attr,
-			    perf_overflow_handler_t triggered);
+			    perf_overflow_handler_t triggered,
+			    void *context);
 
 extern int register_perf_hw_breakpoint(struct perf_event *bp);
 extern int __register_perf_hw_breakpoint(struct perf_event *bp);
@@ -115,6 +118,7 @@ static inline int __init init_hw_breakpoint(void) { return 0; }
 static inline struct perf_event *
 register_user_hw_breakpoint(struct perf_event_attr *attr,
 			    perf_overflow_handler_t triggered,
+			    void *context,
 			    struct task_struct *tsk)	{ return NULL; }
 static inline int
 modify_user_hw_breakpoint(struct perf_event *bp,
@@ -122,10 +126,12 @@ modify_user_hw_breakpoint(struct perf_event *bp,
 static inline struct perf_event *
 register_wide_hw_breakpoint_cpu(struct perf_event_attr *attr,
 				perf_overflow_handler_t	 triggered,
+				void *context,
 				int cpu)		{ return NULL; }
 static inline struct perf_event * __percpu *
 register_wide_hw_breakpoint(struct perf_event_attr *attr,
-			    perf_overflow_handler_t triggered)	{ return NULL; }
+			    perf_overflow_handler_t triggered,
+			    void *context)		{ return NULL; }
 static inline int
 register_perf_hw_breakpoint(struct perf_event *bp)	{ return -ENOSYS; }
 static inline int
diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index 3412684..de346a0 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -709,7 +709,9 @@ struct perf_buffer {
 
 struct perf_sample_data;
 
-typedef void (*perf_overflow_handler_t)(struct perf_event *, int,
+typedef void (*perf_overflow_handler_t)(void *context,
+					struct perf_event *event,
+					int,
 					struct perf_sample_data *,
 					struct pt_regs *regs);
 
@@ -855,6 +857,7 @@ struct perf_event {
 	u64				id;
 
 	perf_overflow_handler_t		overflow_handler;
+	void				*overflow_handler_context;
 
 #ifdef CONFIG_EVENT_TRACING
 	struct ftrace_event_call	*tp_event;
@@ -978,7 +981,8 @@ extern struct perf_event *
 perf_event_create_kernel_counter(struct perf_event_attr *attr,
 				int cpu,
 				struct task_struct *task,
-				perf_overflow_handler_t callback);
+				perf_overflow_handler_t callback,
+				void *context);
 extern u64 perf_event_read_value(struct perf_event *event,
 				 u64 *enabled, u64 *running);
 
diff --git a/kernel/events/core.c b/kernel/events/core.c
index 0fc34a3..f60b81c 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -5032,7 +5032,8 @@ static int __perf_event_overflow(struct perf_event *event, int nmi,
 	}
 
 	if (event->overflow_handler)
-		event->overflow_handler(event, nmi, data, regs);
+		event->overflow_handler(event->overflow_handler_context, event,
+					nmi, data, regs);
 	else
 		perf_event_output(event, nmi, data, regs);
 
@@ -6158,7 +6159,8 @@ perf_event_alloc(struct perf_event_attr *attr, int cpu,
 		 struct task_struct *task,
 		 struct perf_event *group_leader,
 		 struct perf_event *parent_event,
-		 perf_overflow_handler_t overflow_handler)
+		 perf_overflow_handler_t overflow_handler,
+		 void *context)
 {
 	struct pmu *pmu;
 	struct perf_event *event;
@@ -6216,10 +6218,13 @@ perf_event_alloc(struct perf_event_attr *attr, int cpu,
 #endif
 	}
 
-	if (!overflow_handler && parent_event)
+	if (!overflow_handler && parent_event) {
 		overflow_handler = parent_event->overflow_handler;
+		context = parent_event->overflow_handler_context;
+	}
 
 	event->overflow_handler	= overflow_handler;
+	event->overflow_handler_context = context;
 
 	if (attr->disabled)
 		event->state = PERF_EVENT_STATE_OFF;
@@ -6486,7 +6491,8 @@ SYSCALL_DEFINE5(perf_event_open,
 		}
 	}
 
-	event = perf_event_alloc(&attr, cpu, task, group_leader, NULL, NULL);
+	event = perf_event_alloc(&attr, cpu, task, group_leader, NULL,
+				 NULL, NULL);
 	if (IS_ERR(event)) {
 		err = PTR_ERR(event);
 		goto err_task;
@@ -6671,7 +6677,8 @@ err_fd:
 struct perf_event *
 perf_event_create_kernel_counter(struct perf_event_attr *attr, int cpu,
 				 struct task_struct *task,
-				 perf_overflow_handler_t overflow_handler)
+				 perf_overflow_handler_t overflow_handler,
+				 void *context)
 {
 	struct perf_event_context *ctx;
 	struct perf_event *event;
@@ -6681,7 +6688,8 @@ perf_event_create_kernel_counter(struct perf_event_attr *attr, int cpu,
 	 * Get the target context (task or percpu):
 	 */
 
-	event = perf_event_alloc(attr, cpu, task, NULL, NULL, overflow_handler);
+	event = perf_event_alloc(attr, cpu, task, NULL, NULL,
+				 overflow_handler, context);
 	if (IS_ERR(event)) {
 		err = PTR_ERR(event);
 		goto err;
@@ -6965,7 +6973,7 @@ inherit_event(struct perf_event *parent_event,
 					   parent_event->cpu,
 					   child,
 					   group_leader, parent_event,
-					   NULL);
+				           NULL, NULL);
 	if (IS_ERR(child_event))
 		return child_event;
 	get_ctx(child_ctx);
@@ -6992,6 +7000,8 @@ inherit_event(struct perf_event *parent_event,
 
 	child_event->ctx = child_ctx;
 	child_event->overflow_handler = parent_event->overflow_handler;
+	child_event->overflow_handler_context
+		= parent_event->overflow_handler_context;
 
 	/*
 	 * Precalculate sample_data sizes
diff --git a/kernel/events/hw_breakpoint.c b/kernel/events/hw_breakpoint.c
index 086adf2..b7971d6 100644
--- a/kernel/events/hw_breakpoint.c
+++ b/kernel/events/hw_breakpoint.c
@@ -431,9 +431,11 @@ int register_perf_hw_breakpoint(struct perf_event *bp)
 struct perf_event *
 register_user_hw_breakpoint(struct perf_event_attr *attr,
 			    perf_overflow_handler_t triggered,
+			    void *context,
 			    struct task_struct *tsk)
 {
-	return perf_event_create_kernel_counter(attr, -1, tsk, triggered);
+	return perf_event_create_kernel_counter(attr, -1, tsk, triggered,
+						context);
 }
 EXPORT_SYMBOL_GPL(register_user_hw_breakpoint);
 
@@ -502,7 +504,8 @@ EXPORT_SYMBOL_GPL(unregister_hw_breakpoint);
  */
 struct perf_event * __percpu *
 register_wide_hw_breakpoint(struct perf_event_attr *attr,
-			    perf_overflow_handler_t triggered)
+			    perf_overflow_handler_t triggered,
+			    void *context)
 {
 	struct perf_event * __percpu *cpu_events, **pevent, *bp;
 	long err;
@@ -515,7 +518,8 @@ register_wide_hw_breakpoint(struct perf_event_attr *attr,
 	get_online_cpus();
 	for_each_online_cpu(cpu) {
 		pevent = per_cpu_ptr(cpu_events, cpu);
-		bp = perf_event_create_kernel_counter(attr, cpu, NULL, triggered);
+		bp = perf_event_create_kernel_counter(attr, cpu, NULL,
+						      triggered, context);
 
 		*pevent = bp;
 
diff --git a/kernel/watchdog.c b/kernel/watchdog.c
index 14733d4..e4502a9 100644
--- a/kernel/watchdog.c
+++ b/kernel/watchdog.c
@@ -198,7 +198,8 @@ static struct perf_event_attr wd_hw_attr = {
 };
 
 /* Callback function for perf event subsystem */
-static void watchdog_overflow_callback(struct perf_event *event, int nmi,
+static void watchdog_overflow_callback(void *context,
+		 struct perf_event *event, int nmi,
 		 struct perf_sample_data *data,
 		 struct pt_regs *regs)
 {
@@ -360,7 +361,9 @@ static int watchdog_nmi_enable(int cpu)
 	/* Try to register using hardware perf events */
 	wd_attr = &wd_hw_attr;
 	wd_attr->sample_period = hw_nmi_get_sample_period();
-	event = perf_event_create_kernel_counter(wd_attr, cpu, NULL, watchdog_overflow_callback);
+	event = perf_event_create_kernel_counter(wd_attr, cpu, NULL,
+						 watchdog_overflow_callback,
+						 NULL);
 	if (!IS_ERR(event)) {
 		printk(KERN_INFO "NMI watchdog enabled, takes one hw-pmu counter.\n");
 		goto out_save;
diff --git a/samples/hw_breakpoint/data_breakpoint.c b/samples/hw_breakpoint/data_breakpoint.c
index 0636539..0635bf3 100644
--- a/samples/hw_breakpoint/data_breakpoint.c
+++ b/samples/hw_breakpoint/data_breakpoint.c
@@ -41,7 +41,8 @@ module_param_string(ksym, ksym_name, KSYM_NAME_LEN, S_IRUGO);
 MODULE_PARM_DESC(ksym, "Kernel symbol to monitor; this module will report any"
 			" write operations on the kernel symbol");
 
-static void sample_hbp_handler(struct perf_event *bp, int nmi,
+static void sample_hbp_handler(void *context,
+			       struct perf_event *bp, int nmi,
 			       struct perf_sample_data *data,
 			       struct pt_regs *regs)
 {
@@ -60,7 +61,7 @@ static int __init hw_break_module_init(void)
 	attr.bp_len = HW_BREAKPOINT_LEN_4;
 	attr.bp_type = HW_BREAKPOINT_W | HW_BREAKPOINT_R;
 
-	sample_hbp = register_wide_hw_breakpoint(&attr, sample_hbp_handler);
+	sample_hbp = register_wide_hw_breakpoint(&attr, sample_hbp_handler, NULL);
 	if (IS_ERR((void __force *)sample_hbp)) {
 		ret = PTR_ERR((void __force *)sample_hbp);
 		goto fail;
-- 
1.7.4.3

