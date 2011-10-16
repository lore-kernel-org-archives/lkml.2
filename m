Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754652Ab1JPPPM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Oct 2011 11:15:12 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:45165 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753515Ab1JPPPK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Oct 2011 11:15:10 -0400
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Borislav Petkov <borislav.petkov@amd.com>, Ingo Molnar <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Stephane Eranian <eranian@google.com>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: =?UTF-8?q?=5BPATCH=5D=20perf=3A=20Carve=20out=20callchain=20functionality?=
Date: Sun, 16 Oct 2011 17:15:04 +0200
Message-Id: <1318778104-17152-1-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.7.5.4
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <borislav.petkov@amd.com>

Split the callchain code from the perf events core into
a new kernel/events/callchain.c file.

This simplifies a bit the big core.c

Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Stephane Eranian <eranian@google.com>
[keep ctx recursion handling inline and use internal headers]
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
---
 kernel/events/Makefile    |    2 +-
 kernel/events/callchain.c |  191 +++++++++++++++++++++++++++++++++++++++++
 kernel/events/core.c      |  209 ---------------------------------------------
 kernel/events/internal.h  |   39 ++++++++-
 4 files changed, 230 insertions(+), 211 deletions(-)
 create mode 100644 kernel/events/callchain.c

diff --git a/kernel/events/Makefile b/kernel/events/Makefile
index 89e5e8a..22d901f 100644
--- a/kernel/events/Makefile
+++ b/kernel/events/Makefile
@@ -2,5 +2,5 @@ ifdef CONFIG_FUNCTION_TRACER
 CFLAGS_REMOVE_core.o = -pg
 endif
 
-obj-y := core.o ring_buffer.o
+obj-y := core.o ring_buffer.o callchain.o
 obj-$(CONFIG_HAVE_HW_BREAKPOINT) += hw_breakpoint.o
diff --git a/kernel/events/callchain.c b/kernel/events/callchain.c
new file mode 100644
index 0000000..057e24b
--- /dev/null
+++ b/kernel/events/callchain.c
@@ -0,0 +1,191 @@
+/*
+ * Performance events callchain code, extracted from core.c:
+ *
+ *  Copyright (C) 2008 Thomas Gleixner <tglx@linutronix.de>
+ *  Copyright (C) 2008-2011 Red Hat, Inc., Ingo Molnar
+ *  Copyright (C) 2008-2011 Red Hat, Inc., Peter Zijlstra <pzijlstr@redhat.com>
+ *  Copyright  ©  2009 Paul Mackerras, IBM Corp. <paulus@au1.ibm.com>
+ *
+ * For licensing details see kernel-base/COPYING
+ */
+
+#include <linux/perf_event.h>
+#include <linux/slab.h>
+#include "internal.h"
+
+struct callchain_cpus_entries {
+	struct rcu_head			rcu_head;
+	struct perf_callchain_entry	*cpu_entries[0];
+};
+
+static DEFINE_PER_CPU(int, callchain_recursion[PERF_NR_CONTEXTS]);
+static atomic_t nr_callchain_events;
+static DEFINE_MUTEX(callchain_mutex);
+static struct callchain_cpus_entries *callchain_cpus_entries;
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
+static void
+put_callchain_entry(int rctx)
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
index d1a1bee..b991286 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -2570,215 +2570,6 @@ static u64 perf_event_read(struct perf_event *event)
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
diff --git a/kernel/events/internal.h b/kernel/events/internal.h
index 09097dd..be4a43f 100644
--- a/kernel/events/internal.h
+++ b/kernel/events/internal.h
@@ -1,6 +1,10 @@
 #ifndef _KERNEL_EVENTS_INTERNAL_H
 #define _KERNEL_EVENTS_INTERNAL_H
 
+#include <linux/hardirq.h>
+
+/* Buffer handling */
+
 #define RING_BUFFER_WRITABLE		0x01
 
 struct ring_buffer {
@@ -64,7 +68,7 @@ static inline int page_order(struct ring_buffer *rb)
 }
 #endif
 
-static unsigned long perf_data_size(struct ring_buffer *rb)
+static inline unsigned long perf_data_size(struct ring_buffer *rb)
 {
 	return rb->nr_pages << (PAGE_SHIFT + page_order(rb));
 }
@@ -93,4 +97,37 @@ __output_copy(struct perf_output_handle *handle,
 	} while (len);
 }
 
+/* Callchain handling */
+extern struct perf_callchain_entry *perf_callchain(struct pt_regs *regs);
+extern int get_callchain_buffers(void);
+extern void put_callchain_buffers(void);
+
+static inline int get_recursion_context(int *recursion)
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
+static inline void put_recursion_context(int *recursion, int rctx)
+{
+	barrier();
+	recursion[rctx]--;
+}
+
 #endif /* _KERNEL_EVENTS_INTERNAL_H */
-- 
1.7.5.4

