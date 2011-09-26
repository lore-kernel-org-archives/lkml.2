Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751828Ab1IZPz1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Sep 2011 11:55:27 -0400
Received: from mailhub.sw.ru ([195.214.232.25]:16000 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751661Ab1IZPzZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Sep 2011 11:55:25 -0400
From: Andrew Vagin <avagin@openvz.org>
To: linux-kernel@vger.kernel.org
Cc: Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>, avagin@openvz.org
Subject: [PATCH 2/4] trace: prepare to collect call chains of non-current task.
Date: Mon, 26 Sep 2011 19:55:33 +0400
Message-Id: <1317052535-1765247-3-git-send-email-avagin@openvz.org>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1317052535-1765247-1-git-send-email-avagin@openvz.org>
References: <1317052535-1765247-1-git-send-email-avagin@openvz.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds argument "task" to all functions between perf_tp_event()
and perf_callchain(). All logic is in the next patch.

We need "task" and "regs" simultaneously, because regs contains
state of current task, before it entered in perf code. Task contains
pointer to task_struct and it will be used for collecting call chains
and filling event data, if task isn't current.

Signed-off-by: Andrew Vagin <avagin@openvz.org>
---
 arch/arm/kernel/perf_event.c              |    6 +++-
 arch/mips/kernel/perf_event.c             |   13 ++++++---
 arch/powerpc/kernel/perf_callchain.c      |    6 +++-
 arch/sh/kernel/perf_callchain.c           |    6 +++-
 arch/sparc/kernel/perf_event.c            |    5 +++-
 arch/x86/kernel/cpu/perf_event.c          |    6 +++-
 arch/x86/kernel/cpu/perf_event_intel_ds.c |    2 +-
 include/linux/ftrace_event.h              |    2 +-
 include/linux/perf_event.h                |    8 +++--
 include/trace/ftrace.h                    |    4 +-
 kernel/events/core.c                      |   43 ++++++++++++++++-------------
 11 files changed, 66 insertions(+), 35 deletions(-)

diff --git a/arch/arm/kernel/perf_event.c b/arch/arm/kernel/perf_event.c
index 53c9c26..0cb8d44 100644
--- a/arch/arm/kernel/perf_event.c
+++ b/arch/arm/kernel/perf_event.c
@@ -769,10 +769,14 @@ callchain_trace(struct stackframe *fr,
 }
 
 void
-perf_callchain_kernel(struct perf_callchain_entry *entry, struct pt_regs *regs)
+perf_callchain_kernel(struct perf_callchain_entry *entry,
+			struct task_struct *tsk, struct pt_regs *regs)
 {
 	struct stackframe fr;
 
+	if (!regs)
+		return;
+
 	fr.fp = regs->ARM_fp;
 	fr.sp = regs->ARM_sp;
 	fr.lr = regs->ARM_lr;
diff --git a/arch/mips/kernel/perf_event.c b/arch/mips/kernel/perf_event.c
index 0aee944..c216182 100644
--- a/arch/mips/kernel/perf_event.c
+++ b/arch/mips/kernel/perf_event.c
@@ -559,12 +559,17 @@ static void save_raw_perf_callchain(struct perf_callchain_entry *entry,
 }
 
 void perf_callchain_kernel(struct perf_callchain_entry *entry,
-		      struct pt_regs *regs)
+			struct task_struct *tsk, struct pt_regs *regs)
 {
-	unsigned long sp = regs->regs[29];
+	unsigned long sp, ra, pc;
+
+	if (!regs)
+		return;
+
+	sp = regs->regs[29];
 #ifdef CONFIG_KALLSYMS
-	unsigned long ra = regs->regs[31];
-	unsigned long pc = regs->cp0_epc;
+	ra = regs->regs[31];
+	pc = regs->cp0_epc;
 
 	if (raw_show_trace || !__kernel_text_address(pc)) {
 		unsigned long stack_page =
diff --git a/arch/powerpc/kernel/perf_callchain.c b/arch/powerpc/kernel/perf_callchain.c
index 564c1d8..a39369c 100644
--- a/arch/powerpc/kernel/perf_callchain.c
+++ b/arch/powerpc/kernel/perf_callchain.c
@@ -47,7 +47,8 @@ static int valid_next_sp(unsigned long sp, unsigned long prev_sp)
 }
 
 void
-perf_callchain_kernel(struct perf_callchain_entry *entry, struct pt_regs *regs)
+perf_callchain_kernel(struct perf_callchain_entry *entry,
+			struct task_struct *tsk, struct pt_regs *regs)
 {
 	unsigned long sp, next_sp;
 	unsigned long next_ip;
@@ -55,6 +56,9 @@ perf_callchain_kernel(struct perf_callchain_entry *entry, struct pt_regs *regs)
 	long level = 0;
 	unsigned long *fp;
 
+	if (!regs)
+		return;
+
 	lr = regs->link;
 	sp = regs->gpr[1];
 	perf_callchain_store(entry, regs->nip);
diff --git a/arch/sh/kernel/perf_callchain.c b/arch/sh/kernel/perf_callchain.c
index cc80b61..d755c0e 100644
--- a/arch/sh/kernel/perf_callchain.c
+++ b/arch/sh/kernel/perf_callchain.c
@@ -33,8 +33,12 @@ static const struct stacktrace_ops callchain_ops = {
 };
 
 void
-perf_callchain_kernel(struct perf_callchain_entry *entry, struct pt_regs *regs)
+perf_callchain_kernel(struct perf_callchain_entry *entry,
+			struct task_struct *tsk, struct pt_regs *regs)
 {
+	if (!regs)
+		return;
+
 	perf_callchain_store(entry, regs->pc);
 
 	unwind_stack(NULL, regs, NULL, &callchain_ops, entry);
diff --git a/arch/sparc/kernel/perf_event.c b/arch/sparc/kernel/perf_event.c
index 614da62..e0bf3d3 100644
--- a/arch/sparc/kernel/perf_event.c
+++ b/arch/sparc/kernel/perf_event.c
@@ -1370,13 +1370,16 @@ int __init init_hw_perf_events(void)
 early_initcall(init_hw_perf_events);
 
 void perf_callchain_kernel(struct perf_callchain_entry *entry,
-			   struct pt_regs *regs)
+			struct task_struct *tsk, struct pt_regs *regs)
 {
 	unsigned long ksp, fp;
 #ifdef CONFIG_FUNCTION_GRAPH_TRACER
 	int graph = 0;
 #endif
 
+	if (!regs)
+		return;
+
 	stack_trace_flush();
 
 	perf_callchain_store(entry, regs->tpc);
diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
index cfa62ec..c3d229d 100644
--- a/arch/x86/kernel/cpu/perf_event.c
+++ b/arch/x86/kernel/cpu/perf_event.c
@@ -1836,8 +1836,12 @@ static const struct stacktrace_ops backtrace_ops = {
 };
 
 void
-perf_callchain_kernel(struct perf_callchain_entry *entry, struct pt_regs *regs)
+perf_callchain_kernel(struct perf_callchain_entry *entry,
+			struct task_struct *tsk, struct pt_regs *regs)
 {
+	if (!regs)
+		return;
+
 	if (perf_guest_cbs && perf_guest_cbs->is_in_guest()) {
 		/* TODO: We don't support guest os callchain now */
 		return;
diff --git a/arch/x86/kernel/cpu/perf_event_intel_ds.c b/arch/x86/kernel/cpu/perf_event_intel_ds.c
index 1b1ef3a..2631ebb 100644
--- a/arch/x86/kernel/cpu/perf_event_intel_ds.c
+++ b/arch/x86/kernel/cpu/perf_event_intel_ds.c
@@ -338,7 +338,7 @@ static int intel_pmu_drain_bts_buffer(void)
 	 * We will overwrite the from and to address before we output
 	 * the sample.
 	 */
-	perf_prepare_sample(&header, &data, event, &regs);
+	perf_prepare_sample(&header, &data, event, current, &regs);
 
 	if (perf_output_begin(&handle, event, header.size * (top - at)))
 		return 1;
diff --git a/include/linux/ftrace_event.h b/include/linux/ftrace_event.h
index 96efa67..5097f9a 100644
--- a/include/linux/ftrace_event.h
+++ b/include/linux/ftrace_event.h
@@ -294,7 +294,7 @@ static inline void
 perf_trace_buf_submit(void *raw_data, int size, int rctx, u64 addr,
 		       u64 count, struct pt_regs *regs, void *head)
 {
-	perf_tp_event(addr, count, raw_data, size, regs, head, rctx);
+	perf_tp_event(addr, count, raw_data, size, current, regs, head, rctx);
 }
 #endif
 
diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index c816075..db5acb3 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -1003,6 +1003,7 @@ extern void perf_output_sample(struct perf_output_handle *handle,
 extern void perf_prepare_sample(struct perf_event_header *header,
 				struct perf_sample_data *data,
 				struct perf_event *event,
+				struct task_struct *tsk,
 				struct pt_regs *regs);
 
 extern int perf_event_overflow(struct perf_event *event,
@@ -1089,7 +1090,8 @@ extern void perf_event_fork(struct task_struct *tsk);
 DECLARE_PER_CPU(struct perf_callchain_entry, perf_callchain_entry);
 
 extern void perf_callchain_user(struct perf_callchain_entry *entry, struct pt_regs *regs);
-extern void perf_callchain_kernel(struct perf_callchain_entry *entry, struct pt_regs *regs);
+extern void perf_callchain_kernel(struct perf_callchain_entry *entry,
+			struct task_struct *tsk, struct pt_regs *regs);
 
 static inline void perf_callchain_store(struct perf_callchain_entry *entry, u64 ip)
 {
@@ -1121,8 +1123,8 @@ static inline bool perf_paranoid_kernel(void)
 }
 
 extern void perf_event_init(void);
-extern void perf_tp_event(u64 addr, u64 count, void *record,
-			  int entry_size, struct pt_regs *regs,
+extern void perf_tp_event(u64 addr, u64 count, void *record, int entry_size,
+			  struct task_struct *tsk, struct pt_regs *regs,
 			  struct hlist_head *head, int rctx);
 extern void perf_bp_event(struct perf_event *event, void *data);
 
diff --git a/include/trace/ftrace.h b/include/trace/ftrace.h
index 7697249..5e4c72a 100644
--- a/include/trace/ftrace.h
+++ b/include/trace/ftrace.h
@@ -750,8 +750,8 @@ perf_trace_##call(void *__data, proto)					\
 	{ assign; }							\
 									\
 	head = this_cpu_ptr(event_call->perf_events);			\
-	perf_trace_buf_submit(entry, __entry_size, rctx, __addr,	\
-		__count, &__regs, head);				\
+	perf_tp_event(__addr, __count, entry, __entry_size,		\
+				current, &__regs, head, rctx);		\
 }
 
 /*
diff --git a/kernel/events/core.c b/kernel/events/core.c
index 0f85778..41ce4db 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -2584,7 +2584,7 @@ struct callchain_cpus_entries *callchain_cpus_entries;
 
 
 __weak void perf_callchain_kernel(struct perf_callchain_entry *entry,
-				  struct pt_regs *regs)
+			struct task_struct *tsk, struct pt_regs *regs)
 {
 }
 
@@ -2742,12 +2742,12 @@ put_callchain_entry(int rctx)
 	put_recursion_context(__get_cpu_var(callchain_recursion), rctx);
 }
 
-static struct perf_callchain_entry *perf_callchain(struct pt_regs *regs)
+static struct perf_callchain_entry
+		*perf_callchain(struct task_struct *tsk, struct pt_regs *regs)
 {
 	int rctx;
 	struct perf_callchain_entry *entry;
 
-
 	entry = get_callchain_entry(&rctx);
 	if (rctx == -1)
 		return NULL;
@@ -2759,7 +2759,7 @@ static struct perf_callchain_entry *perf_callchain(struct pt_regs *regs)
 
 	if (!user_mode(regs)) {
 		perf_callchain_store(entry, PERF_CONTEXT_KERNEL);
-		perf_callchain_kernel(entry, regs);
+		perf_callchain_kernel(entry, tsk, regs);
 		if (current->mm)
 			regs = task_pt_regs(current);
 		else
@@ -3991,6 +3991,7 @@ void perf_output_sample(struct perf_output_handle *handle,
 void perf_prepare_sample(struct perf_event_header *header,
 			 struct perf_sample_data *data,
 			 struct perf_event *event,
+			 struct task_struct *tsk,
 			 struct pt_regs *regs)
 {
 	u64 sample_type = event->attr.sample_type;
@@ -4009,7 +4010,7 @@ void perf_prepare_sample(struct perf_event_header *header,
 	if (sample_type & PERF_SAMPLE_CALLCHAIN) {
 		int size = 1;
 
-		data->callchain = perf_callchain(regs);
+		data->callchain = perf_callchain(tsk, regs);
 
 		if (data->callchain)
 			size += data->callchain->nr;
@@ -4032,6 +4033,7 @@ void perf_prepare_sample(struct perf_event_header *header,
 
 static void perf_event_output(struct perf_event *event,
 				struct perf_sample_data *data,
+				struct task_struct *tsk,
 				struct pt_regs *regs)
 {
 	struct perf_output_handle handle;
@@ -4040,7 +4042,7 @@ static void perf_event_output(struct perf_event *event,
 	/* protect the callchain buffers */
 	rcu_read_lock();
 
-	perf_prepare_sample(&header, data, event, regs);
+	perf_prepare_sample(&header, data, event, tsk, regs);
 
 	if (perf_output_begin(&handle, event, header.size))
 		goto exit;
@@ -4619,6 +4621,7 @@ static void perf_log_throttle(struct perf_event *event, int enable)
 
 static int __perf_event_overflow(struct perf_event *event,
 				   int throttle, struct perf_sample_data *data,
+				   struct task_struct *tsk,
 				   struct pt_regs *regs)
 {
 	int events = atomic_read(&event->event_limit);
@@ -4667,7 +4670,7 @@ static int __perf_event_overflow(struct perf_event *event,
 	if (event->overflow_handler)
 		event->overflow_handler(event, data, regs);
 	else
-		perf_event_output(event, data, regs);
+		perf_event_output(event, data, tsk, regs);
 
 	if (event->fasync && event->pending_kill) {
 		event->pending_wakeup = 1;
@@ -4681,7 +4684,7 @@ int perf_event_overflow(struct perf_event *event,
 			  struct perf_sample_data *data,
 			  struct pt_regs *regs)
 {
-	return __perf_event_overflow(event, 1, data, regs);
+	return __perf_event_overflow(event, 1, data, current, regs);
 }
 
 /*
@@ -4731,6 +4734,7 @@ again:
 
 static void perf_swevent_overflow(struct perf_event *event, u64 overflow,
 				    struct perf_sample_data *data,
+				    struct task_struct *tsk,
 				    struct pt_regs *regs)
 {
 	struct hw_perf_event *hwc = &event->hw;
@@ -4745,7 +4749,7 @@ static void perf_swevent_overflow(struct perf_event *event, u64 overflow,
 
 	for (; overflow; overflow--) {
 		if (__perf_event_overflow(event, throttle,
-					    data, regs)) {
+					    data, tsk, regs)) {
 			/*
 			 * We inhibit the overflow from happening when
 			 * hwc->interrupts == MAX_INTERRUPTS.
@@ -4758,25 +4762,26 @@ static void perf_swevent_overflow(struct perf_event *event, u64 overflow,
 
 static void perf_swevent_event(struct perf_event *event, u64 nr,
 			       struct perf_sample_data *data,
+			       struct task_struct *tsk,
 			       struct pt_regs *regs)
 {
 	struct hw_perf_event *hwc = &event->hw;
 
 	local64_add(nr, &event->count);
 
-	if (!regs)
+	if (!tsk && !regs)
 		return;
 
 	if (!is_sampling_event(event))
 		return;
 
 	if (nr == 1 && hwc->sample_period == 1 && !event->attr.freq)
-		return perf_swevent_overflow(event, 1, data, regs);
+		return perf_swevent_overflow(event, 1, data, tsk, regs);
 
 	if (local64_add_negative(nr, &hwc->period_left))
 		return;
 
-	perf_swevent_overflow(event, 0, data, regs);
+	perf_swevent_overflow(event, 0, data, tsk, regs);
 }
 
 static int perf_exclude_event(struct perf_event *event,
@@ -4880,7 +4885,7 @@ static void do_perf_sw_event(enum perf_type_id type, u32 event_id,
 
 	hlist_for_each_entry_rcu(event, node, head, hlist_entry) {
 		if (perf_swevent_match(event, type, event_id, data, regs))
-			perf_swevent_event(event, nr, data, regs);
+			perf_swevent_event(event, nr, data, current, regs);
 	}
 end:
 	rcu_read_unlock();
@@ -5127,8 +5132,7 @@ static int perf_tp_filter_match(struct perf_event *event,
 }
 
 static int perf_tp_event_match(struct perf_event *event,
-				struct perf_sample_data *data,
-				struct pt_regs *regs)
+				struct perf_sample_data *data)
 {
 	if (event->hw.state & PERF_HES_STOPPED)
 		return 0;
@@ -5145,7 +5149,8 @@ static int perf_tp_event_match(struct perf_event *event,
 }
 
 void perf_tp_event(u64 addr, u64 count, void *record, int entry_size,
-		   struct pt_regs *regs, struct hlist_head *head, int rctx)
+			struct task_struct *tsk, struct pt_regs *regs,
+			struct hlist_head *head, int rctx)
 {
 	struct perf_sample_data data;
 	struct perf_event *event;
@@ -5160,8 +5165,8 @@ void perf_tp_event(u64 addr, u64 count, void *record, int entry_size,
 	data.raw = &raw;
 
 	hlist_for_each_entry_rcu(event, node, head, hlist_entry) {
-		if (perf_tp_event_match(event, &data, regs))
-			perf_swevent_event(event, count, &data, regs);
+		if (perf_tp_event_match(event, &data))
+			perf_swevent_event(event, count, &data, tsk, regs);
 	}
 
 	perf_swevent_put_recursion_context(rctx);
@@ -5254,7 +5259,7 @@ void perf_bp_event(struct perf_event *bp, void *data)
 	perf_sample_data_init(&sample, bp->attr.bp_addr);
 
 	if (!bp->hw.state && !perf_exclude_event(bp, regs))
-		perf_swevent_event(bp, 1, &sample, regs);
+		perf_swevent_event(bp, 1, &sample, current, regs);
 }
 #endif
 
-- 
1.7.1

