Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757340Ab1EKQlk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 May 2011 12:41:40 -0400
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:57854 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754730Ab1EKPot (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 May 2011 11:44:49 -0400
From: Borislav Petkov <bp@amd64.org>
To: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Borislav Petkov <borislav.petkov@amd.com>
Subject: [PATCH 2/2] perf: Carve out callchain functionality
Date: Wed, 11 May 2011 15:16:56 +0200
Message-Id: <1305119816-26280-3-git-send-email-bp@amd64.org>
X-Mailer: git-send-email 1.7.4.rc2
In-Reply-To: <1305119816-26280-1-git-send-email-bp@amd64.org>
References: <1305119816-26280-1-git-send-email-bp@amd64.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <borislav.petkov@amd.com>

Move callchain-related code into its own module:
kernel/events/callchain.c

No functionality change.

Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
---
 include/linux/perf_event.h |    7 +-
 kernel/events/Makefile     |    2 +-
 kernel/events/callchain.c  |  182 +++++++++++++++++++++++++++++++++
 kernel/events/core.c       |  237 +++++--------------------------------------
 4 files changed, 217 insertions(+), 211 deletions(-)
 create mode 100644 kernel/events/callchain.c

diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index 687f852..7978850 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -961,7 +961,6 @@ enum event_type_t {
 };
 
 #ifdef CONFIG_PERF_EVENTS
-
 extern struct list_head pmus;
 extern int perf_pmu_register(struct pmu *pmu, char *name, int type);
 extern void perf_pmu_unregister(struct pmu *pmu);
@@ -1201,6 +1200,12 @@ static inline void cpu_ctx_sched_in(struct perf_cpu_context *cpuctx,
 extern int
 task_function_call(struct task_struct *p, int (*func) (void *info), void *info);
 extern u64 perf_event_time(struct perf_event *event);
+
+extern int get_recursion_context(int *recursion);
+extern inline void put_recursion_context(int *recursion, int rctx);
+extern void put_callchain_buffers(void);
+extern struct perf_callchain_entry *perf_callchain(struct pt_regs *regs);
+extern int get_callchain_buffers(void);
 #else
 static inline void
 perf_event_task_sched_in(struct task_struct *task)			{ }
diff --git a/kernel/events/Makefile b/kernel/events/Makefile
index 21b7da7..ca16be2 100644
--- a/kernel/events/Makefile
+++ b/kernel/events/Makefile
@@ -2,6 +2,6 @@ ifdef CONFIG_FUNCTION_TRACER
 CFLAGS_REMOVE_core.o = -pg
 endif
 
-obj-y := core.o
+obj-y := core.o callchain.o
 obj-$(CONFIG_HAVE_HW_BREAKPOINT) += hw_breakpoint.o
 obj-$(CONFIG_CGROUP_PERF)	 += cgroup.o
diff --git a/kernel/events/callchain.c b/kernel/events/callchain.c
new file mode 100644
index 0000000..0b495fc
--- /dev/null
+++ b/kernel/events/callchain.c
@@ -0,0 +1,182 @@
+#include <linux/slab.h>
+#include <linux/hardirq.h>
+#include <linux/perf_event.h>
+/*
+ * Callchain support
+ */
+
+struct callchain_cpus_entries {
+	struct rcu_head			rcu_head;
+	struct perf_callchain_entry	*cpu_entries[0];
+};
+
+static DEFINE_PER_CPU(int, callchain_recursion[PERF_NR_CONTEXTS]);
+static atomic_t nr_callchain_events;
+static DEFINE_MUTEX(callchain_mutex);
+struct callchain_cpus_entries *callchain_cpus_entries;
+
+
+__weak void perf_callchain_kernel(struct perf_callchain_entry *entry,
+				  struct pt_regs *regs)
+{
+}
+
+__weak void perf_callchain_user(struct perf_callchain_entry *entry,
+				struct pt_regs *regs)
+{
+}
+
+static void release_callchain_buffers_rcu(struct rcu_head *head)
+{
+	struct callchain_cpus_entries *entries;
+	int cpu;
+
+	entries = container_of(head, struct callchain_cpus_entries, rcu_head);
+
+	for_each_possible_cpu(cpu)
+		kfree(entries->cpu_entries[cpu]);
+
+	kfree(entries);
+}
+
+static void release_callchain_buffers(void)
+{
+	struct callchain_cpus_entries *entries;
+
+	entries = callchain_cpus_entries;
+	rcu_assign_pointer(callchain_cpus_entries, NULL);
+	call_rcu(&entries->rcu_head, release_callchain_buffers_rcu);
+}
+
+static int alloc_callchain_buffers(void)
+{
+	int cpu;
+	int size;
+	struct callchain_cpus_entries *entries;
+
+	/*
+	 * We can't use the percpu allocation API for data that can be
+	 * accessed from NMI. Use a temporary manual per cpu allocation
+	 * until that gets sorted out.
+	 */
+	size = offsetof(struct callchain_cpus_entries, cpu_entries[nr_cpu_ids]);
+
+	entries = kzalloc(size, GFP_KERNEL);
+	if (!entries)
+		return -ENOMEM;
+
+	size = sizeof(struct perf_callchain_entry) * PERF_NR_CONTEXTS;
+
+	for_each_possible_cpu(cpu) {
+		entries->cpu_entries[cpu] = kmalloc_node(size, GFP_KERNEL,
+							 cpu_to_node(cpu));
+		if (!entries->cpu_entries[cpu])
+			goto fail;
+	}
+
+	rcu_assign_pointer(callchain_cpus_entries, entries);
+
+	return 0;
+
+fail:
+	for_each_possible_cpu(cpu)
+		kfree(entries->cpu_entries[cpu]);
+	kfree(entries);
+
+	return -ENOMEM;
+}
+
+int get_callchain_buffers(void)
+{
+	int err = 0;
+	int count;
+
+	mutex_lock(&callchain_mutex);
+
+	count = atomic_inc_return(&nr_callchain_events);
+	if (WARN_ON_ONCE(count < 1)) {
+		err = -EINVAL;
+		goto exit;
+	}
+
+	if (count > 1) {
+		/* If the allocation failed, give up */
+		if (!callchain_cpus_entries)
+			err = -ENOMEM;
+		goto exit;
+	}
+
+	err = alloc_callchain_buffers();
+	if (err)
+		release_callchain_buffers();
+exit:
+	mutex_unlock(&callchain_mutex);
+
+	return err;
+}
+
+void put_callchain_buffers(void)
+{
+	if (atomic_dec_and_mutex_lock(&nr_callchain_events, &callchain_mutex)) {
+		release_callchain_buffers();
+		mutex_unlock(&callchain_mutex);
+	}
+}
+
+static struct perf_callchain_entry *get_callchain_entry(int *rctx)
+{
+	int cpu;
+	struct callchain_cpus_entries *entries;
+
+	*rctx = get_recursion_context(__get_cpu_var(callchain_recursion));
+	if (*rctx == -1)
+		return NULL;
+
+	entries = rcu_dereference(callchain_cpus_entries);
+	if (!entries)
+		return NULL;
+
+	cpu = smp_processor_id();
+
+	return &entries->cpu_entries[cpu][*rctx];
+}
+
+static void put_callchain_entry(int rctx)
+{
+	put_recursion_context(__get_cpu_var(callchain_recursion), rctx);
+}
+
+struct perf_callchain_entry *perf_callchain(struct pt_regs *regs)
+{
+	int rctx;
+	struct perf_callchain_entry *entry;
+
+
+	entry = get_callchain_entry(&rctx);
+	if (rctx == -1)
+		return NULL;
+
+	if (!entry)
+		goto exit_put;
+
+	entry->nr = 0;
+
+	if (!user_mode(regs)) {
+		perf_callchain_store(entry, PERF_CONTEXT_KERNEL);
+		perf_callchain_kernel(entry, regs);
+		if (current->mm)
+			regs = task_pt_regs(current);
+		else
+			regs = NULL;
+	}
+
+	if (regs) {
+		perf_callchain_store(entry, PERF_CONTEXT_USER);
+		perf_callchain_user(entry, regs);
+	}
+
+exit_put:
+	put_callchain_entry(rctx);
+
+	return entry;
+}
diff --git a/kernel/events/core.c b/kernel/events/core.c
index b65905f..364cad6 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -2070,6 +2070,34 @@ out:
 	local_irq_restore(flags);
 }
 
+int get_recursion_context(int *recursion)
+{
+	int rctx;
+
+	if (in_nmi())
+		rctx = 3;
+	else if (in_irq())
+		rctx = 2;
+	else if (in_softirq())
+		rctx = 1;
+	else
+		rctx = 0;
+
+	if (recursion[rctx])
+		return -1;
+
+	recursion[rctx]++;
+	barrier();
+
+	return rctx;
+}
+
+inline void put_recursion_context(int *recursion, int rctx)
+{
+	barrier();
+	recursion[rctx]--;
+}
+
 /*
  * Cross CPU call to read the hardware event
  */
@@ -2136,215 +2164,6 @@ static u64 perf_event_read(struct perf_event *event)
 }
 
 /*
- * Callchain support
- */
-
-struct callchain_cpus_entries {
-	struct rcu_head			rcu_head;
-	struct perf_callchain_entry	*cpu_entries[0];
-};
-
-static DEFINE_PER_CPU(int, callchain_recursion[PERF_NR_CONTEXTS]);
-static atomic_t nr_callchain_events;
-static DEFINE_MUTEX(callchain_mutex);
-struct callchain_cpus_entries *callchain_cpus_entries;
-
-
-__weak void perf_callchain_kernel(struct perf_callchain_entry *entry,
-				  struct pt_regs *regs)
-{
-}
-
-__weak void perf_callchain_user(struct perf_callchain_entry *entry,
-				struct pt_regs *regs)
-{
-}
-
-static void release_callchain_buffers_rcu(struct rcu_head *head)
-{
-	struct callchain_cpus_entries *entries;
-	int cpu;
-
-	entries = container_of(head, struct callchain_cpus_entries, rcu_head);
-
-	for_each_possible_cpu(cpu)
-		kfree(entries->cpu_entries[cpu]);
-
-	kfree(entries);
-}
-
-static void release_callchain_buffers(void)
-{
-	struct callchain_cpus_entries *entries;
-
-	entries = callchain_cpus_entries;
-	rcu_assign_pointer(callchain_cpus_entries, NULL);
-	call_rcu(&entries->rcu_head, release_callchain_buffers_rcu);
-}
-
-static int alloc_callchain_buffers(void)
-{
-	int cpu;
-	int size;
-	struct callchain_cpus_entries *entries;
-
-	/*
-	 * We can't use the percpu allocation API for data that can be
-	 * accessed from NMI. Use a temporary manual per cpu allocation
-	 * until that gets sorted out.
-	 */
-	size = offsetof(struct callchain_cpus_entries, cpu_entries[nr_cpu_ids]);
-
-	entries = kzalloc(size, GFP_KERNEL);
-	if (!entries)
-		return -ENOMEM;
-
-	size = sizeof(struct perf_callchain_entry) * PERF_NR_CONTEXTS;
-
-	for_each_possible_cpu(cpu) {
-		entries->cpu_entries[cpu] = kmalloc_node(size, GFP_KERNEL,
-							 cpu_to_node(cpu));
-		if (!entries->cpu_entries[cpu])
-			goto fail;
-	}
-
-	rcu_assign_pointer(callchain_cpus_entries, entries);
-
-	return 0;
-
-fail:
-	for_each_possible_cpu(cpu)
-		kfree(entries->cpu_entries[cpu]);
-	kfree(entries);
-
-	return -ENOMEM;
-}
-
-static int get_callchain_buffers(void)
-{
-	int err = 0;
-	int count;
-
-	mutex_lock(&callchain_mutex);
-
-	count = atomic_inc_return(&nr_callchain_events);
-	if (WARN_ON_ONCE(count < 1)) {
-		err = -EINVAL;
-		goto exit;
-	}
-
-	if (count > 1) {
-		/* If the allocation failed, give up */
-		if (!callchain_cpus_entries)
-			err = -ENOMEM;
-		goto exit;
-	}
-
-	err = alloc_callchain_buffers();
-	if (err)
-		release_callchain_buffers();
-exit:
-	mutex_unlock(&callchain_mutex);
-
-	return err;
-}
-
-static void put_callchain_buffers(void)
-{
-	if (atomic_dec_and_mutex_lock(&nr_callchain_events, &callchain_mutex)) {
-		release_callchain_buffers();
-		mutex_unlock(&callchain_mutex);
-	}
-}
-
-static int get_recursion_context(int *recursion)
-{
-	int rctx;
-
-	if (in_nmi())
-		rctx = 3;
-	else if (in_irq())
-		rctx = 2;
-	else if (in_softirq())
-		rctx = 1;
-	else
-		rctx = 0;
-
-	if (recursion[rctx])
-		return -1;
-
-	recursion[rctx]++;
-	barrier();
-
-	return rctx;
-}
-
-static inline void put_recursion_context(int *recursion, int rctx)
-{
-	barrier();
-	recursion[rctx]--;
-}
-
-static struct perf_callchain_entry *get_callchain_entry(int *rctx)
-{
-	int cpu;
-	struct callchain_cpus_entries *entries;
-
-	*rctx = get_recursion_context(__get_cpu_var(callchain_recursion));
-	if (*rctx == -1)
-		return NULL;
-
-	entries = rcu_dereference(callchain_cpus_entries);
-	if (!entries)
-		return NULL;
-
-	cpu = smp_processor_id();
-
-	return &entries->cpu_entries[cpu][*rctx];
-}
-
-static void
-put_callchain_entry(int rctx)
-{
-	put_recursion_context(__get_cpu_var(callchain_recursion), rctx);
-}
-
-static struct perf_callchain_entry *perf_callchain(struct pt_regs *regs)
-{
-	int rctx;
-	struct perf_callchain_entry *entry;
-
-
-	entry = get_callchain_entry(&rctx);
-	if (rctx == -1)
-		return NULL;
-
-	if (!entry)
-		goto exit_put;
-
-	entry->nr = 0;
-
-	if (!user_mode(regs)) {
-		perf_callchain_store(entry, PERF_CONTEXT_KERNEL);
-		perf_callchain_kernel(entry, regs);
-		if (current->mm)
-			regs = task_pt_regs(current);
-		else
-			regs = NULL;
-	}
-
-	if (regs) {
-		perf_callchain_store(entry, PERF_CONTEXT_USER);
-		perf_callchain_user(entry, regs);
-	}
-
-exit_put:
-	put_callchain_entry(rctx);
-
-	return entry;
-}
-
-/*
  * Initialize the perf_event context in a task_struct:
  */
 static void __perf_event_init_context(struct perf_event_context *ctx)
-- 
1.7.4.rc2

