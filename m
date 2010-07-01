Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756916Ab0GAPhY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jul 2010 11:37:24 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:64120 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756674Ab0GAPgC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jul 2010 11:36:02 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:x-mailer-version
         :in-reply-to:references;
        b=emxWAszVsu60GrIheiVfk66ybXD7HJSJIbnpZxG+pK+vm2sAOfHShworHbqoU16qOr
         w303RmVmI2A2uW1ErvUBDgQkAn1+pZli4N2nD8KGjq2Z8C28TrKAP2iwDyzPjHOvIO5r
         tqMpLrDEj2A4I3zmkg+Q3urFLLjfnVEy3LgVU=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Paul Mackerras <paulus@samba.org>,
       Stephane Eranian <eranian@google.com>,
       Will Deacon <will.deacon@arm.com>, Paul Mundt <lethal@linux-sh.org>,
       David Miller <davem@davemloft.net>, Borislav Petkov <bp@amd64.org>
Subject: [RFC PATCH 5/6] perf: Fix race in callchains
Date: Thu,  1 Jul 2010 17:36:01 +0200
Message-Id: <1277998562-21366-6-git-send-regression-fweisbec@gmail.com>
X-Mailer: git-send-regression
X-Mailer-version: 0.1, "The maintainer couldn't reproduce after one week full time debugging" special version.
In-Reply-To: <1277998562-21366-1-git-send-regression-fweisbec@gmail.com>
References: <1277998562-21366-1-git-send-regression-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now that software events don't have interrupt disabled anymore in
the event path, callchains can nest on any context. So seperating
nmi and others contexts in two buffers has become racy.

Fix this by providing one buffer per nesting level. Given the size
of the callchain entries (2040 bytes * 4), we now need to allocate
them dynamically.

(The guest checks in x86 should probably be moved elsewhere).

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Stephane Eranian <eranian@google.com>
Cc: Will Deacon <will.deacon@arm.com>
Cc: Paul Mundt <lethal@linux-sh.org>
Cc: David Miller <davem@davemloft.net>
Cc: Borislav Petkov <bp@amd64.org>
---
 arch/x86/kernel/cpu/perf_event.c |   22 ++--
 include/linux/perf_event.h       |    1 -
 kernel/perf_event.c              |  265 ++++++++++++++++++++++++++++----------
 3 files changed, 205 insertions(+), 83 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
index a3c9222..8e91cf3 100644
--- a/arch/x86/kernel/cpu/perf_event.c
+++ b/arch/x86/kernel/cpu/perf_event.c
@@ -1608,6 +1608,11 @@ static const struct stacktrace_ops backtrace_ops = {
 void
 perf_callchain_kernel(struct perf_callchain_entry *entry, struct pt_regs *regs)
 {
+	if (perf_guest_cbs && perf_guest_cbs->is_in_guest()) {
+		/* TODO: We don't support guest os callchain now */
+		return NULL;
+	}
+
 	perf_callchain_store(entry, regs->ip);
 
 	dump_trace(NULL, regs, NULL, regs->bp, &backtrace_ops, entry);
@@ -1656,6 +1661,10 @@ perf_callchain_user(struct perf_callchain_entry *entry, struct pt_regs *regs)
 	struct stack_frame frame;
 	const void __user *fp;
 
+	if (perf_guest_cbs && perf_guest_cbs->is_in_guest()) {
+		/* TODO: We don't support guest os callchain now */
+		return NULL;
+	}
 
 	fp = (void __user *)regs->bp;
 
@@ -1681,19 +1690,6 @@ perf_callchain_user(struct perf_callchain_entry *entry, struct pt_regs *regs)
 	}
 }
 
-struct perf_callchain_entry *perf_callchain_buffer(void)
-{
-	if (perf_guest_cbs && perf_guest_cbs->is_in_guest()) {
-		/* TODO: We don't support guest os callchain now */
-		return NULL;
-	}
-
-	if (in_nmi())
-		return &__get_cpu_var(perf_callchain_entry_nmi);
-
-	return &__get_cpu_var(perf_callchain_entry);
-}
-
 unsigned long perf_instruction_pointer(struct pt_regs *regs)
 {
 	unsigned long ip;
diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index 4db61dd..d7e8ea6 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -983,7 +983,6 @@ extern void perf_callchain_user(struct perf_callchain_entry *entry,
 				struct pt_regs *regs);
 extern void perf_callchain_kernel(struct perf_callchain_entry *entry,
 				  struct pt_regs *regs);
-extern struct perf_callchain_entry *perf_callchain_buffer(void);
 
 
 static inline void
diff --git a/kernel/perf_event.c b/kernel/perf_event.c
index 615d024..b6e854f 100644
--- a/kernel/perf_event.c
+++ b/kernel/perf_event.c
@@ -1764,6 +1764,183 @@ static u64 perf_event_read(struct perf_event *event)
 }
 
 /*
+ * Callchain support
+ */
+
+struct perf_callchain_entry_cpus {
+	struct perf_callchain_entry	__percpu *entries;
+	struct rcu_head				  rcu_head;
+};
+
+static DEFINE_PER_CPU(int, callchain_recursion);
+static int nr_callchain_events;
+static DEFINE_MUTEX(callchain_mutex);
+static struct perf_callchain_entry_cpus *callchain_entries[4];
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
+static int get_callchain_buffers(void)
+{
+	int i;
+	int err = 0;
+	struct perf_callchain_entry_cpus *buf;
+
+	mutex_lock(&callchain_mutex);
+
+	if (WARN_ON_ONCE(++nr_callchain_events < 1)) {
+		err = -EINVAL;
+		goto exit;
+	}
+
+	if (nr_callchain_events > 1)
+		goto exit;
+
+	for (i = 0; i < 4; i++) {
+		buf = kzalloc(sizeof(*buf), GFP_KERNEL);
+		/* free_event() will clean the rest */
+		if (!buf) {
+			err = -ENOMEM;
+			goto exit;
+		}
+		buf->entries = alloc_percpu(struct perf_callchain_entry);
+		if (!buf->entries) {
+			kfree(buf);
+			err = -ENOMEM;
+			goto exit;
+		}
+		rcu_assign_pointer(callchain_entries[i], buf);
+	}
+
+exit:
+	mutex_unlock(&callchain_mutex);
+
+	return err;
+}
+
+static void release_callchain_buffers(struct rcu_head *head)
+{
+	struct perf_callchain_entry_cpus *entry;
+
+	entry = container_of(head, struct perf_callchain_entry_cpus, rcu_head);
+	free_percpu(entry->entries);
+	kfree(entry);
+}
+
+static void put_callchain_buffers(void)
+{
+	int i;
+	struct perf_callchain_entry_cpus *entry;
+
+	mutex_lock(&callchain_mutex);
+
+	if (WARN_ON_ONCE(--nr_callchain_events < 0))
+		goto exit;
+
+	if (nr_callchain_events > 0)
+		goto exit;
+
+	for (i = 0; i < 4; i++) {
+		entry = callchain_entries[i];
+		if (entry) {
+			callchain_entries[i] = NULL;
+			call_rcu(&entry->rcu_head, release_callchain_buffers);
+		}
+	}
+
+exit:
+	mutex_unlock(&callchain_mutex);
+}
+
+static int get_recursion_context(int *recursion)
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
+static struct perf_callchain_entry *get_callchain_entry(int *rctx)
+{
+	struct perf_callchain_entry_cpus *cpu_entries;
+
+	*rctx = get_recursion_context(&__get_cpu_var(callchain_recursion));
+	if (*rctx == -1)
+		return NULL;
+
+	cpu_entries = rcu_dereference(callchain_entries[*rctx]);
+	if (!cpu_entries)
+		return NULL;
+
+	return this_cpu_ptr(cpu_entries->entries);
+}
+
+static void
+put_callchain_entry(int rctx)
+{
+	put_recursion_context(&__get_cpu_var(callchain_recursion), rctx);
+}
+
+static struct perf_callchain_entry *perf_callchain(struct pt_regs *regs)
+{
+	int rctx;
+	struct perf_callchain_entry *entry;
+
+
+	entry = get_callchain_entry(&rctx);
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
+
+/*
  * Initialize the perf_event context in a task_struct:
  */
 static void
@@ -1895,6 +2072,8 @@ static void free_event(struct perf_event *event)
 			atomic_dec(&nr_comm_events);
 		if (event->attr.task)
 			atomic_dec(&nr_task_events);
+		if (event->attr.sample_type & PERF_SAMPLE_CALLCHAIN)
+			put_callchain_buffers();
 	}
 
 	if (event->buffer) {
@@ -2937,55 +3116,6 @@ void perf_event_do_pending(void)
 	__perf_pending_run();
 }
 
-DEFINE_PER_CPU(struct perf_callchain_entry, perf_callchain_entry);
-
-/*
- * Callchain support -- arch specific
- */
-
-__weak struct perf_callchain_entry *perf_callchain_buffer(void)
-{
-	return &__get_cpu_var(perf_callchain_entry);
-}
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
-static struct perf_callchain_entry *perf_callchain(struct pt_regs *regs)
-{
-	struct perf_callchain_entry *entry;
-
-	entry = perf_callchain_buffer();
-	if (!entry)
-		return NULL;
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
-	return entry;
-}
-
-
 /*
  * We assume there is only KVM supporting the callbacks.
  * Later on, we might change it to a list if there is
@@ -3480,14 +3610,20 @@ static void perf_event_output(struct perf_event *event, int nmi,
 	struct perf_output_handle handle;
 	struct perf_event_header header;
 
+	/* protect the callchain buffers */
+	rcu_read_lock();
+
 	perf_prepare_sample(&header, data, event, regs);
 
 	if (perf_output_begin(&handle, event, header.size, nmi, 1))
-		return;
+		goto exit;
 
 	perf_output_sample(&handle, &header, data, event);
 
 	perf_output_end(&handle);
+
+exit:
+	rcu_read_unlock();
 }
 
 /*
@@ -4243,32 +4379,16 @@ end:
 int perf_swevent_get_recursion_context(void)
 {
 	struct perf_cpu_context *cpuctx = &__get_cpu_var(perf_cpu_context);
-	int rctx;
 
-	if (in_nmi())
-		rctx = 3;
-	else if (in_irq())
-		rctx = 2;
-	else if (in_softirq())
-		rctx = 1;
-	else
-		rctx = 0;
-
-	if (cpuctx->recursion[rctx])
-		return -1;
-
-	cpuctx->recursion[rctx]++;
-	barrier();
-
-	return rctx;
+	return get_recursion_context(cpuctx->recursion);
 }
 EXPORT_SYMBOL_GPL(perf_swevent_get_recursion_context);
 
 void inline perf_swevent_put_recursion_context(int rctx)
 {
 	struct perf_cpu_context *cpuctx = &__get_cpu_var(perf_cpu_context);
-	barrier();
-	cpuctx->recursion[rctx]--;
+
+	put_recursion_context(cpuctx->recursion, rctx);
 }
 
 void __perf_sw_event(u32 event_id, u64 nr, int nmi,
@@ -4968,6 +5088,13 @@ done:
 			atomic_inc(&nr_comm_events);
 		if (event->attr.task)
 			atomic_inc(&nr_task_events);
+		if (event->attr.sample_type & PERF_SAMPLE_CALLCHAIN) {
+			err = get_callchain_buffers();
+			if (err) {
+				free_event(event);
+				return ERR_PTR(err);
+			}
+		}
 	}
 
 	return event;
-- 
1.6.2.3

