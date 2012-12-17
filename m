Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752630Ab2LQLvt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2012 06:51:49 -0500
Received: from mx1.redhat.com ([209.132.183.28]:58638 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752296Ab2LQLvr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2012 06:51:47 -0500
Date: Mon, 17 Dec 2012 12:51:40 +0100
From: Alexander Gordeev <agordeev@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Subject: [PATCH RFC -tip 1/6] perf/core: IRQ-bound performance events
Message-ID: <530e610d902ea063d4bccf4bb1eda4efe92068e8.1355744680.git.agordeev@redhat.com>
References: <cover.1355744680.git.agordeev@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1355744680.git.agordeev@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make possible counting performance events while a particular
hardware context interrupt handler is running.

Signed-off-by: Alexander Gordeev <agordeev@redhat.com>
---
 include/linux/irq.h             |    8 +++
 include/linux/irqdesc.h         |    3 +
 include/linux/perf_event.h      |   16 ++++++
 include/uapi/linux/perf_event.h |    1 +
 kernel/events/core.c            |   69 +++++++++++++++++++++------
 kernel/irq/Makefile             |    1 +
 kernel/irq/handle.c             |    4 ++
 kernel/irq/irqdesc.c            |   14 +++++
 kernel/irq/perf_event.c         |  100 +++++++++++++++++++++++++++++++++++++++
 9 files changed, 201 insertions(+), 15 deletions(-)
 create mode 100644 kernel/irq/perf_event.c

diff --git a/include/linux/irq.h b/include/linux/irq.h
index 216b0ba..ef0a703 100644
--- a/include/linux/irq.h
+++ b/include/linux/irq.h
@@ -604,6 +604,14 @@ static inline int irq_reserve_irq(unsigned int irq)
 # define irq_reg_readl(addr)		readl(addr)
 #endif
 
+#ifdef CONFIG_PERF_EVENTS
+extern void perf_enable_irq_events(struct irq_desc *desc);
+extern void perf_disable_irq_events(struct irq_desc *desc);
+#else
+static inline void perf_enable_irq_events(struct irq_desc *desc)	{ }
+static inline void perf_disable_irq_events(struct irq_desc *desc)	{ }
+#endif
+
 /**
  * struct irq_chip_regs - register offsets for struct irq_gci
  * @enable:	Enable register offset to reg_base
diff --git a/include/linux/irqdesc.h b/include/linux/irqdesc.h
index 0ba014c..503479e 100644
--- a/include/linux/irqdesc.h
+++ b/include/linux/irqdesc.h
@@ -65,6 +65,9 @@ struct irq_desc {
 #ifdef CONFIG_PROC_FS
 	struct proc_dir_entry	*dir;
 #endif
+#ifdef CONFIG_PERF_EVENTS
+	struct list_head * __percpu event_list;
+#endif
 	struct module		*owner;
 	const char		*name;
 } ____cacheline_internodealigned_in_smp;
diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index 6bfb2faa..ef8a79b 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -197,6 +197,9 @@ struct pmu {
 	void (*pmu_enable)		(struct pmu *pmu); /* optional */
 	void (*pmu_disable)		(struct pmu *pmu); /* optional */
 
+	void (*pmu_enable_irq)		(struct pmu *pmu, int irq); /* opt. */
+	void (*pmu_disable_irq)		(struct pmu *pmu, int irq); /* opt. */
+
 	/*
 	 * Try and initialize the event for this PMU.
 	 * Should return -ENOENT when the @event doesn't match this PMU.
@@ -320,6 +323,7 @@ struct perf_event {
 	struct list_head		group_entry;
 	struct list_head		event_entry;
 	struct list_head		sibling_list;
+	struct list_head		irq_desc_list;
 	struct hlist_node		hlist_entry;
 	int				nr_siblings;
 	int				group_flags;
@@ -392,6 +396,7 @@ struct perf_event {
 
 	int				oncpu;
 	int				cpu;
+	int				irq;
 
 	struct list_head		owner_entry;
 	struct task_struct		*owner;
@@ -544,6 +549,8 @@ extern void perf_event_delayed_put(struct task_struct *task);
 extern void perf_event_print_debug(void);
 extern void perf_pmu_disable(struct pmu *pmu);
 extern void perf_pmu_enable(struct pmu *pmu);
+extern void perf_pmu_disable_irq(struct pmu *pmu, int irq);
+extern void perf_pmu_enable_irq(struct pmu *pmu, int irq);
 extern int perf_event_task_disable(void);
 extern int perf_event_task_enable(void);
 extern int perf_event_refresh(struct perf_event *event, int refresh);
@@ -624,6 +631,11 @@ static inline int is_software_event(struct perf_event *event)
 	return event->pmu->task_ctx_nr == perf_sw_context;
 }
 
+static inline bool is_interrupt_event(struct perf_event *event)
+{
+	return event->irq >= 0;
+}
+
 extern struct static_key perf_swevent_enabled[PERF_COUNT_SW_MAX];
 
 extern void __perf_sw_event(u32, u64, struct pt_regs *, u64);
@@ -753,6 +765,8 @@ extern void perf_event_enable(struct perf_event *event);
 extern void perf_event_disable(struct perf_event *event);
 extern int __perf_event_disable(void *info);
 extern void perf_event_task_tick(void);
+extern int perf_event_irq_add(struct perf_event *event);
+extern int perf_event_irq_del(struct perf_event *event);
 #else
 static inline void
 perf_event_task_sched_in(struct task_struct *prev,
@@ -792,6 +806,8 @@ static inline void perf_event_enable(struct perf_event *event)		{ }
 static inline void perf_event_disable(struct perf_event *event)		{ }
 static inline int __perf_event_disable(void *info)			{ return -1; }
 static inline void perf_event_task_tick(void)				{ }
+extern inline int perf_event_irq_add(struct perf_event *event)	{ return -EINVAL; }
+extern inline int perf_event_irq_del(struct perf_event *event)	{ return -EINVAL; }
 #endif
 
 #define perf_output_put(handle, x) perf_output_copy((handle), &(x), sizeof(x))
diff --git a/include/uapi/linux/perf_event.h b/include/uapi/linux/perf_event.h
index 4f63c05..d4cfacd 100644
--- a/include/uapi/linux/perf_event.h
+++ b/include/uapi/linux/perf_event.h
@@ -611,5 +611,6 @@ enum perf_callchain_context {
 #define PERF_FLAG_FD_NO_GROUP		(1U << 0)
 #define PERF_FLAG_FD_OUTPUT		(1U << 1)
 #define PERF_FLAG_PID_CGROUP		(1U << 2) /* pid=cgroup id, per-cpu mode only */
+#define PERF_FLAG_PID_IRQ		(1U << 3) /* pid=irq number */
 
 #endif /* _UAPI_LINUX_PERF_EVENT_H */
diff --git a/kernel/events/core.c b/kernel/events/core.c
index dbccf83..ca8f489 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -116,8 +116,9 @@ static int cpu_function_call(int cpu, int (*func) (void *info), void *info)
 }
 
 #define PERF_FLAG_ALL (PERF_FLAG_FD_NO_GROUP |\
-		       PERF_FLAG_FD_OUTPUT  |\
-		       PERF_FLAG_PID_CGROUP)
+		       PERF_FLAG_FD_OUTPUT |\
+		       PERF_FLAG_PID_CGROUP |\
+		       PERF_FLAG_PID_IRQ)
 
 /*
  * branch priv levels that need permission checks
@@ -641,6 +642,20 @@ void perf_pmu_enable(struct pmu *pmu)
 		pmu->pmu_enable(pmu);
 }
 
+void perf_pmu_disable_irq(struct pmu *pmu, int irq)
+{
+	int *count = this_cpu_ptr(pmu->pmu_disable_count);
+	if (!(*count)++)
+		pmu->pmu_disable_irq(pmu, irq);
+}
+
+void perf_pmu_enable_irq(struct pmu *pmu, int irq)
+{
+	int *count = this_cpu_ptr(pmu->pmu_disable_count);
+	if (!--(*count))
+		pmu->pmu_enable_irq(pmu, irq);
+}
+
 static DEFINE_PER_CPU(struct list_head, rotation_list);
 
 /*
@@ -5804,6 +5819,10 @@ static void perf_pmu_nop_void(struct pmu *pmu)
 {
 }
 
+static void perf_pmu_int_nop_void(struct pmu *pmu, int irq)
+{
+}
+
 static int perf_pmu_nop_int(struct pmu *pmu)
 {
 	return 0;
@@ -6020,6 +6039,11 @@ got_cpu_context:
 		pmu->pmu_disable = perf_pmu_nop_void;
 	}
 
+	if (!pmu->pmu_enable_irq) {
+		pmu->pmu_enable_irq  = perf_pmu_int_nop_void;
+		pmu->pmu_disable_irq = perf_pmu_int_nop_void;
+	}
+
 	if (!pmu->event_idx)
 		pmu->event_idx = perf_event_idx_default;
 
@@ -6105,7 +6129,7 @@ unlock:
  * Allocate and initialize a event structure
  */
 static struct perf_event *
-perf_event_alloc(struct perf_event_attr *attr, int cpu,
+perf_event_alloc(struct perf_event_attr *attr, int cpu, int irq,
 		 struct task_struct *task,
 		 struct perf_event *group_leader,
 		 struct perf_event *parent_event,
@@ -6118,7 +6142,7 @@ perf_event_alloc(struct perf_event_attr *attr, int cpu,
 	long err;
 
 	if ((unsigned)cpu >= nr_cpu_ids) {
-		if (!task || cpu != -1)
+		if (!task || cpu != -1 || irq < 0)
 			return ERR_PTR(-EINVAL);
 	}
 
@@ -6148,6 +6172,7 @@ perf_event_alloc(struct perf_event_attr *attr, int cpu,
 
 	atomic_long_set(&event->refcount, 1);
 	event->cpu		= cpu;
+	event->irq		= irq;
 	event->attr		= *attr;
 	event->group_leader	= group_leader;
 	event->pmu		= NULL;
@@ -6442,6 +6467,7 @@ SYSCALL_DEFINE5(perf_event_open,
 	struct fd group = {NULL, 0};
 	struct task_struct *task = NULL;
 	struct pmu *pmu;
+	int irq = -1;
 	int event_fd;
 	int move_group = 0;
 	int err;
@@ -6450,6 +6476,27 @@ SYSCALL_DEFINE5(perf_event_open,
 	if (flags & ~PERF_FLAG_ALL)
 		return -EINVAL;
 
+	if ((flags & (PERF_FLAG_PID_CGROUP | PERF_FLAG_PID_IRQ)) ==
+	    (PERF_FLAG_PID_CGROUP | PERF_FLAG_PID_IRQ))
+		return -EINVAL;
+
+	/*
+	 * In irq mode, the pid argument is used to pass irq number.
+	 */
+	if (flags & PERF_FLAG_PID_IRQ) {
+		irq = pid;
+		pid = -1;
+	}
+
+	/*
+	 * In cgroup mode, the pid argument is used to pass the fd
+	 * opened to the cgroup directory in cgroupfs. The cpu argument
+	 * designates the cpu on which to monitor threads from that
+	 * cgroup.
+	 */
+	if ((flags & PERF_FLAG_PID_CGROUP) && (pid == -1 || cpu == -1))
+		return -EINVAL;
+
 	err = perf_copy_attr(attr_uptr, &attr);
 	if (err)
 		return err;
@@ -6464,15 +6511,6 @@ SYSCALL_DEFINE5(perf_event_open,
 			return -EINVAL;
 	}
 
-	/*
-	 * In cgroup mode, the pid argument is used to pass the fd
-	 * opened to the cgroup directory in cgroupfs. The cpu argument
-	 * designates the cpu on which to monitor threads from that
-	 * cgroup.
-	 */
-	if ((flags & PERF_FLAG_PID_CGROUP) && (pid == -1 || cpu == -1))
-		return -EINVAL;
-
 	event_fd = get_unused_fd();
 	if (event_fd < 0)
 		return event_fd;
@@ -6498,7 +6536,7 @@ SYSCALL_DEFINE5(perf_event_open,
 
 	get_online_cpus();
 
-	event = perf_event_alloc(&attr, cpu, task, group_leader, NULL,
+	event = perf_event_alloc(&attr, cpu, irq, task, group_leader, NULL,
 				 NULL, NULL);
 	if (IS_ERR(event)) {
 		err = PTR_ERR(event);
@@ -6698,7 +6736,7 @@ perf_event_create_kernel_counter(struct perf_event_attr *attr, int cpu,
 	 * Get the target context (task or percpu):
 	 */
 
-	event = perf_event_alloc(attr, cpu, task, NULL, NULL,
+	event = perf_event_alloc(attr, cpu, -1, task, NULL, NULL,
 				 overflow_handler, context);
 	if (IS_ERR(event)) {
 		err = PTR_ERR(event);
@@ -7012,6 +7050,7 @@ inherit_event(struct perf_event *parent_event,
 
 	child_event = perf_event_alloc(&parent_event->attr,
 					   parent_event->cpu,
+					   parent_event->irq,
 					   child,
 					   group_leader, parent_event,
 				           NULL, NULL);
diff --git a/kernel/irq/Makefile b/kernel/irq/Makefile
index fff1738..12c81e8 100644
--- a/kernel/irq/Makefile
+++ b/kernel/irq/Makefile
@@ -6,3 +6,4 @@ obj-$(CONFIG_IRQ_DOMAIN) += irqdomain.o
 obj-$(CONFIG_PROC_FS) += proc.o
 obj-$(CONFIG_GENERIC_PENDING_IRQ) += migration.o
 obj-$(CONFIG_PM_SLEEP) += pm.o
+obj-$(CONFIG_PERF_EVENTS) += perf_event.o
diff --git a/kernel/irq/handle.c b/kernel/irq/handle.c
index 131ca17..7542012 100644
--- a/kernel/irq/handle.c
+++ b/kernel/irq/handle.c
@@ -139,7 +139,11 @@ handle_irq_event_percpu(struct irq_desc *desc, struct irqaction *action)
 		irqreturn_t res;
 
 		trace_irq_handler_entry(irq, action);
+		perf_enable_irq_events(desc);
+
 		res = action->handler(irq, action->dev_id);
+
+		perf_disable_irq_events(desc);
 		trace_irq_handler_exit(irq, action, res);
 
 		if (WARN_ONCE(!irqs_disabled(),"irq %u handler %pF enabled interrupts\n",
diff --git a/kernel/irq/irqdesc.c b/kernel/irq/irqdesc.c
index 192a302..2a10214 100644
--- a/kernel/irq/irqdesc.c
+++ b/kernel/irq/irqdesc.c
@@ -131,6 +131,14 @@ static void free_masks(struct irq_desc *desc)
 static inline void free_masks(struct irq_desc *desc) { }
 #endif
 
+#ifdef CONFIG_PERF_EVENTS
+extern int alloc_perf_events(struct irq_desc *desc);
+extern void free_perf_events(struct irq_desc *desc);
+#else
+static inline int alloc_perf_events(struct irq_desc *desc) { return 0; }
+static inline void free_perf_events(struct irq_desc *desc) { }
+#endif
+
 static struct irq_desc *alloc_desc(int irq, int node, struct module *owner)
 {
 	struct irq_desc *desc;
@@ -147,6 +155,9 @@ static struct irq_desc *alloc_desc(int irq, int node, struct module *owner)
 	if (alloc_masks(desc, gfp, node))
 		goto err_kstat;
 
+	if (alloc_perf_events(desc))
+		goto err_masks;
+
 	raw_spin_lock_init(&desc->lock);
 	lockdep_set_class(&desc->lock, &irq_desc_lock_class);
 
@@ -154,6 +165,8 @@ static struct irq_desc *alloc_desc(int irq, int node, struct module *owner)
 
 	return desc;
 
+err_masks:
+	free_masks(desc);
 err_kstat:
 	free_percpu(desc->kstat_irqs);
 err_desc:
@@ -171,6 +184,7 @@ static void free_desc(unsigned int irq)
 	delete_irq_desc(irq);
 	mutex_unlock(&sparse_irq_lock);
 
+	free_perf_events(desc);
 	free_masks(desc);
 	free_percpu(desc->kstat_irqs);
 	kfree(desc);
diff --git a/kernel/irq/perf_event.c b/kernel/irq/perf_event.c
new file mode 100644
index 0000000..007a5bb
--- /dev/null
+++ b/kernel/irq/perf_event.c
@@ -0,0 +1,100 @@
+/*
+ * linux/kernel/irq/perf.c
+ *
+ * Copyright (C) 2012 Alexander Gordeev
+ *
+ * This file contains the code for per-IRQ performance counters
+ */
+
+#include <linux/irq.h>
+#include <linux/cpumask.h>
+#include <linux/perf_event.h>
+
+int alloc_perf_events(struct irq_desc *desc)
+{
+	struct list_head __percpu *head;
+	int cpu;
+
+	desc->event_list = alloc_percpu(struct list_head);
+	if (!desc->event_list)
+		return -ENOMEM;
+
+	for_each_possible_cpu(cpu) {
+		head = per_cpu_ptr(desc->event_list, cpu);
+		INIT_LIST_HEAD(head);
+	}
+
+	return 0;
+}
+
+void free_perf_events(struct irq_desc *desc)
+{
+	struct list_head __percpu *head;
+	int cpu;
+
+	for_each_possible_cpu(cpu) {
+		head = per_cpu_ptr(desc->event_list, cpu);
+		while (!list_empty(head))
+			list_del(head->next);
+	}
+
+	free_percpu(desc->event_list);
+}
+
+int perf_event_irq_add(struct perf_event *event)
+{
+	struct irq_desc *desc = irq_to_desc(event->irq);
+	struct list_head __percpu *head;
+
+	WARN_ON(event->cpu != smp_processor_id());
+
+	if (!desc)
+		return -ENOENT;
+
+	head = per_cpu_ptr(desc->event_list, event->cpu);
+
+	raw_spin_lock(&desc->lock);
+	list_add(&event->irq_desc_list, head);
+	raw_spin_unlock(&desc->lock);
+
+	return 0;
+}
+
+int perf_event_irq_del(struct perf_event *event)
+{
+	struct irq_desc *desc = irq_to_desc(event->irq);
+
+	if (!desc)
+		return -ENOENT;
+
+	WARN_ON(event->cpu != smp_processor_id());
+
+	raw_spin_lock(&desc->lock);
+	list_del(&event->irq_desc_list);
+	raw_spin_unlock(&desc->lock);
+
+	return 0;
+}
+
+static void __enable_irq_events(struct irq_desc *desc, bool enable)
+{
+	struct perf_event *event;
+	struct list_head __percpu *head = this_cpu_ptr(desc->event_list);
+
+	list_for_each_entry(event, head, irq_desc_list) {
+		struct pmu *pmu = event->pmu;
+		void (*func)(struct pmu *, int) =
+			enable ? pmu->pmu_enable_irq : pmu->pmu_disable_irq;
+		func(pmu, desc->irq_data.irq);
+	}
+}
+
+void perf_enable_irq_events(struct irq_desc *desc)
+{
+	__enable_irq_events(desc, true);
+}
+
+void perf_disable_irq_events(struct irq_desc *desc)
+{
+	__enable_irq_events(desc, false);
+}
-- 
1.7.7.6


-- 
Regards,
Alexander Gordeev
agordeev@redhat.com
