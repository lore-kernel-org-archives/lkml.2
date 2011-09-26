Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752026Ab1IZPzs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Sep 2011 11:55:48 -0400
Received: from mailhub.sw.ru ([195.214.232.25]:35888 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751697Ab1IZPz0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Sep 2011 11:55:26 -0400
From: Andrew Vagin <avagin@openvz.org>
To: linux-kernel@vger.kernel.org
Cc: Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>, avagin@openvz.org
Subject: [PATCH 3/4] trace: add ability to collect call chain of non-current task.
Date: Mon, 26 Sep 2011 19:55:34 +0400
Message-Id: <1317052535-1765247-4-git-send-email-avagin@openvz.org>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1317052535-1765247-1-git-send-email-avagin@openvz.org>
References: <1317052535-1765247-1-git-send-email-avagin@openvz.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

An event may requires call chain of non-current task.  E.g. You may want
to know where and how long a task is sleeping. A time slice is known
when the task wakes up.  We can send event in this moment, but a target
task isn't "current".

The macro __perf_task set a task for which a call chain will be
collected.

Know issues:
* Now call chains for non-current tasks are collected on x86 only,
  but it may be done for other architectures simply.
* It collects only kernel call chains, because we can't get direct
  access to memory of other processes and this operation should be
  fast enough.

Signed-off-by: Andrew Vagin <avagin@openvz.org>
---
 arch/x86/kernel/cpu/perf_event.c |    8 +++-----
 include/trace/ftrace.h           |   11 +++++++++--
 kernel/events/core.c             |   30 ++++++++++++++++++------------
 3 files changed, 30 insertions(+), 19 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
index c3d229d..18817a8 100644
--- a/arch/x86/kernel/cpu/perf_event.c
+++ b/arch/x86/kernel/cpu/perf_event.c
@@ -1839,17 +1839,15 @@ void
 perf_callchain_kernel(struct perf_callchain_entry *entry,
 			struct task_struct *tsk, struct pt_regs *regs)
 {
-	if (!regs)
-		return;
-
 	if (perf_guest_cbs && perf_guest_cbs->is_in_guest()) {
 		/* TODO: We don't support guest os callchain now */
 		return;
 	}
 
-	perf_callchain_store(entry, regs->ip);
+	if (regs)
+		perf_callchain_store(entry, regs->ip);
 
-	dump_trace(NULL, regs, NULL, 0, &backtrace_ops, entry);
+	dump_trace(tsk, regs, NULL, 0, &backtrace_ops, entry);
 }
 
 #ifdef CONFIG_COMPAT
diff --git a/include/trace/ftrace.h b/include/trace/ftrace.h
index 5e4c72a..d03e926 100644
--- a/include/trace/ftrace.h
+++ b/include/trace/ftrace.h
@@ -711,6 +711,9 @@ __attribute__((section("_ftrace_events"))) *__event_##call = &event_##call
 #undef __perf_count
 #define __perf_count(c) __count = (c)
 
+#undef __perf_task
+#define __perf_task(t) __task = (t)
+
 #undef TP_perf_assign
 #define TP_perf_assign(args...) args
 
@@ -722,7 +725,8 @@ perf_trace_##call(void *__data, proto)					\
 	struct ftrace_event_call *event_call = __data;			\
 	struct ftrace_data_offsets_##call __maybe_unused __data_offsets;\
 	struct ftrace_raw_##call *entry;				\
-	struct pt_regs __regs;						\
+	struct pt_regs __regs, *__pregs = &__regs;			\
+	struct task_struct *__task = current;				\
 	u64 __addr = 0, __count = 1;					\
 	struct hlist_head *head;					\
 	int __entry_size;						\
@@ -749,9 +753,12 @@ perf_trace_##call(void *__data, proto)					\
 									\
 	{ assign; }							\
 									\
+	if (__task != current)						\
+		__pregs = NULL;						\
+									\
 	head = this_cpu_ptr(event_call->perf_events);			\
 	perf_tp_event(__addr, __count, entry, __entry_size,		\
-				current, &__regs, head, rctx);		\
+				__task, __pregs, head, rctx);		\
 }
 
 /*
diff --git a/kernel/events/core.c b/kernel/events/core.c
index 41ce4db..2dce0f9 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -2757,16 +2757,16 @@ static struct perf_callchain_entry
 
 	entry->nr = 0;
 
-	if (!user_mode(regs)) {
+	if (!regs || !user_mode(regs)) {
 		perf_callchain_store(entry, PERF_CONTEXT_KERNEL);
 		perf_callchain_kernel(entry, tsk, regs);
-		if (current->mm)
-			regs = task_pt_regs(current);
+		if (tsk->mm)
+			regs = task_pt_regs(tsk);
 		else
 			regs = NULL;
 	}
 
-	if (regs) {
+	if (tsk == current && regs) {
 		perf_callchain_store(entry, PERF_CONTEXT_USER);
 		perf_callchain_user(entry, regs);
 	}
@@ -3746,7 +3746,8 @@ EXPORT_SYMBOL_GPL(perf_unregister_guest_info_callbacks);
 
 static void __perf_event_header__init_id(struct perf_event_header *header,
 					 struct perf_sample_data *data,
-					 struct perf_event *event)
+					 struct perf_event *event,
+					 struct task_struct *tsk)
 {
 	u64 sample_type = event->attr.sample_type;
 
@@ -3755,8 +3756,8 @@ static void __perf_event_header__init_id(struct perf_event_header *header,
 
 	if (sample_type & PERF_SAMPLE_TID) {
 		/* namespace issues */
-		data->tid_entry.pid = perf_event_pid(event, current);
-		data->tid_entry.tid = perf_event_tid(event, current);
+		data->tid_entry.pid = perf_event_pid(event, tsk);
+		data->tid_entry.tid = perf_event_tid(event, tsk);
 	}
 
 	if (sample_type & PERF_SAMPLE_TIME)
@@ -3779,7 +3780,7 @@ void perf_event_header__init_id(struct perf_event_header *header,
 				struct perf_event *event)
 {
 	if (event->attr.sample_id_all)
-		__perf_event_header__init_id(header, data, event);
+		__perf_event_header__init_id(header, data, event, current);
 }
 
 static void __perf_event__output_id_sample(struct perf_output_handle *handle,
@@ -4000,12 +4001,17 @@ void perf_prepare_sample(struct perf_event_header *header,
 	header->size = sizeof(*header) + event->header_size;
 
 	header->misc = 0;
-	header->misc |= perf_misc_flags(regs);
 
-	__perf_event_header__init_id(header, data, event);
+	__perf_event_header__init_id(header, data, event, tsk);
 
-	if (sample_type & PERF_SAMPLE_IP)
-		data->ip = perf_instruction_pointer(regs);
+	if (regs) {
+		header->misc |= perf_misc_flags(regs);
+		if (sample_type & PERF_SAMPLE_IP)
+			data->ip = perf_instruction_pointer(regs);
+	} else {
+		header->misc |= PERF_RECORD_MISC_KERNEL;
+		data->ip = 0;
+	}
 
 	if (sample_type & PERF_SAMPLE_CALLCHAIN) {
 		int size = 1;
-- 
1.7.1

