Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752380Ab1KRXgb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Nov 2011 18:36:31 -0500
Received: from terminus.zytor.com ([198.137.202.10]:53384 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751083Ab1KRXga (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Nov 2011 18:36:30 -0500
Date: Fri, 18 Nov 2011 15:36:10 -0800
From: tip-bot for Borislav Petkov <borislav.petkov@amd.com>
Message-ID: <tip-9251f904f95175b4a1d8cbc0449e748f9edd7629@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, acme@redhat.com,
        hpa@zytor.com, mingo@redhat.com, a.p.zijlstra@chello.nl,
        fweisbec@gmail.com, tglx@linutronix.de, mingo@elte.hu,
        borislav.petkov@amd.com
Reply-To: mingo@redhat.com, hpa@zytor.com, acme@redhat.com, eranian@google.com,
        linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
        fweisbec@gmail.com, tglx@linutronix.de, mingo@elte.hu,
        borislav.petkov@amd.com
In-Reply-To: <1318778104-17152-1-git-send-email-fweisbec@gmail.com>
References: <1318778104-17152-1-git-send-email-fweisbec@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf: Carve out callchain functionality
Git-Commit-ID: 9251f904f95175b4a1d8cbc0449e748f9edd7629
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Fri, 18 Nov 2011 15:36:16 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  9251f904f95175b4a1d8cbc0449e748f9edd7629
Gitweb:     http://git.kernel.org/tip/9251f904f95175b4a1d8cbc0449e748f9edd7629
Author:     Borislav Petkov <borislav.petkov@amd.com>
AuthorDate: Sun, 16 Oct 2011 17:15:04 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Mon, 14 Nov 2011 13:31:26 +0100

perf: Carve out callchain functionality

Split the callchain code from the perf events core into
a new kernel/events/callchain.c file.

This simplifies a bit the big core.c

Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Stephane Eranian <eranian@google.com>
[keep ctx recursion handling inline and use internal headers]
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1318778104-17152-1-git-send-email-fweisbec@gmail.com
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/events/Makefile    |    2 +-
 kernel/events/callchain.c |  191 +++++++++++++++++++++++++++++++++++++++++
 kernel/events/core.c      |  209 ---------------------------------------------
 kernel/events/internal.h  |   39 ++++++++-
 4 files changed, 230 insertions(+), 211 deletions(-)

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
index 0e8457d..eadac69 100644
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
