Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933266Ab2GDJIx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jul 2012 05:08:53 -0400
Received: from mailhub.sw.ru ([195.214.232.25]:12073 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754033Ab2GDJIv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jul 2012 05:08:51 -0400
From: Andrew Vagin <avagin@openvz.org>
To: linux-kernel@vger.kernel.org
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Paul Mackerras <paulus@samba.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Arun Sharma <asharma@fb.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Andrew Vagin <avagin@openvz.org>
Subject: [PATCH] trace: add ability to set a target task for events
Date: Wed,  4 Jul 2012 13:08:31 +0400
Message-Id: <1341392911-1888300-1-git-send-email-avagin@openvz.org>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Peter Zijlstra <a.p.zijlstra@chello.nl>

A few events are interesting not only for a current task.
For example, sched_stat_* are interesting to a task, which
wake up. For this reason, it will be good, if such events will
be delivered to a target task too.

Now a target task can be set by using __perf_task().

The original idea and a draft patch belongs to Peter Zijlstra.

Inspired-by: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Arun Sharma <asharma@fb.com>
Signed-off-by: Andrew Vagin <avagin@openvz.org>
---
 include/linux/ftrace_event.h    |    5 +++--
 include/linux/perf_event.h      |    3 ++-
 include/trace/events/sched.h    |    1 +
 include/trace/ftrace.h          |    6 +++++-
 kernel/events/core.c            |   26 +++++++++++++++++++++++++-
 kernel/trace/trace_event_perf.c |    2 +-
 kernel/trace/trace_kprobe.c     |    4 ++--
 kernel/trace/trace_syscalls.c   |    4 ++--
 8 files changed, 41 insertions(+), 10 deletions(-)

diff --git a/include/linux/ftrace_event.h b/include/linux/ftrace_event.h
index 176a939..55b96e3 100644
--- a/include/linux/ftrace_event.h
+++ b/include/linux/ftrace_event.h
@@ -303,9 +303,10 @@ extern void *perf_trace_buf_prepare(int size, unsigned short type,
 
 static inline void
 perf_trace_buf_submit(void *raw_data, int size, int rctx, u64 addr,
-		       u64 count, struct pt_regs *regs, void *head)
+		       u64 count, struct pt_regs *regs, void *head,
+		       struct task_struct *task)
 {
-	perf_tp_event(addr, count, raw_data, size, regs, head, rctx);
+	perf_tp_event(addr, count, raw_data, size, regs, head, rctx, task);
 }
 #endif
 
diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index 45db49f..14acc5d 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -1269,7 +1269,8 @@ static inline bool perf_paranoid_kernel(void)
 extern void perf_event_init(void);
 extern void perf_tp_event(u64 addr, u64 count, void *record,
 			  int entry_size, struct pt_regs *regs,
-			  struct hlist_head *head, int rctx);
+			  struct hlist_head *head, int rctx,
+			  struct task_struct *task);
 extern void perf_bp_event(struct perf_event *event, void *data);
 
 #ifndef perf_misc_flags
diff --git a/include/trace/events/sched.h b/include/trace/events/sched.h
index ea7a203..9e3999a 100644
--- a/include/trace/events/sched.h
+++ b/include/trace/events/sched.h
@@ -325,6 +325,7 @@ DECLARE_EVENT_CLASS(sched_stat_template,
 	)
 	TP_perf_assign(
 		__perf_count(delay);
+		__perf_task(tsk);
 	),
 
 	TP_printk("comm=%s pid=%d delay=%Lu [ns]",
diff --git a/include/trace/ftrace.h b/include/trace/ftrace.h
index 7697249..db14daf 100644
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
 
@@ -724,6 +727,7 @@ perf_trace_##call(void *__data, proto)					\
 	struct ftrace_raw_##call *entry;				\
 	struct pt_regs __regs;						\
 	u64 __addr = 0, __count = 1;					\
+	struct task_struct *__task = NULL;				\
 	struct hlist_head *head;					\
 	int __entry_size;						\
 	int __data_size;						\
@@ -751,7 +755,7 @@ perf_trace_##call(void *__data, proto)					\
 									\
 	head = this_cpu_ptr(event_call->perf_events);			\
 	perf_trace_buf_submit(entry, __entry_size, rctx, __addr,	\
-		__count, &__regs, head);				\
+		__count, &__regs, head, __task);			\
 }
 
 /*
diff --git a/kernel/events/core.c b/kernel/events/core.c
index d7d71d6..164c309 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -5207,7 +5207,8 @@ static int perf_tp_event_match(struct perf_event *event,
 }
 
 void perf_tp_event(u64 addr, u64 count, void *record, int entry_size,
-		   struct pt_regs *regs, struct hlist_head *head, int rctx)
+		   struct pt_regs *regs, struct hlist_head *head, int rctx,
+		   struct task_struct *task)
 {
 	struct perf_sample_data data;
 	struct perf_event *event;
@@ -5226,6 +5227,29 @@ void perf_tp_event(u64 addr, u64 count, void *record, int entry_size,
 			perf_swevent_event(event, count, &data, regs);
 	}
 
+	/*
+	 * If we got specified a target task, also iterate its context and
+	 * deliver this event there too.
+	 */
+	if (task && task != current) {
+		struct perf_event_context *ctx;
+		struct trace_entry *entry = record;
+
+		rcu_read_lock();
+		ctx = rcu_dereference(task->perf_event_ctxp[perf_sw_context]);
+		if (!ctx)
+			goto unlock;
+
+		list_for_each_entry_rcu(event, &ctx->event_list, event_entry) {
+			if (entry->type != event->attr.config)
+				continue;
+			if (perf_tp_event_match(event, &data, regs))
+				perf_swevent_event(event, count, &data, regs);
+		}
+unlock:
+		rcu_read_unlock();
+	}
+
 	perf_swevent_put_recursion_context(rctx);
 }
 EXPORT_SYMBOL_GPL(perf_tp_event);
diff --git a/kernel/trace/trace_event_perf.c b/kernel/trace/trace_event_perf.c
index fee3752..8a6d2ee 100644
--- a/kernel/trace/trace_event_perf.c
+++ b/kernel/trace/trace_event_perf.c
@@ -281,7 +281,7 @@ perf_ftrace_function_call(unsigned long ip, unsigned long parent_ip)
 
 	head = this_cpu_ptr(event_function.perf_events);
 	perf_trace_buf_submit(entry, ENTRY_SIZE, rctx, 0,
-			      1, &regs, head);
+			      1, &regs, head, NULL);
 
 #undef ENTRY_SIZE
 }
diff --git a/kernel/trace/trace_kprobe.c b/kernel/trace/trace_kprobe.c
index b31d3d5..2feeaa0 100644
--- a/kernel/trace/trace_kprobe.c
+++ b/kernel/trace/trace_kprobe.c
@@ -1002,7 +1002,7 @@ static __kprobes void kprobe_perf_func(struct kprobe *kp,
 	store_trace_args(sizeof(*entry), tp, regs, (u8 *)&entry[1], dsize);
 
 	head = this_cpu_ptr(call->perf_events);
-	perf_trace_buf_submit(entry, size, rctx, entry->ip, 1, regs, head);
+	perf_trace_buf_submit(entry, size, rctx, entry->ip, 1, regs, head, NULL);
 }
 
 /* Kretprobe profile handler */
@@ -1033,7 +1033,7 @@ static __kprobes void kretprobe_perf_func(struct kretprobe_instance *ri,
 	store_trace_args(sizeof(*entry), tp, regs, (u8 *)&entry[1], dsize);
 
 	head = this_cpu_ptr(call->perf_events);
-	perf_trace_buf_submit(entry, size, rctx, entry->ret_ip, 1, regs, head);
+	perf_trace_buf_submit(entry, size, rctx, entry->ret_ip, 1, regs, head, NULL);
 }
 #endif	/* CONFIG_PERF_EVENTS */
 
diff --git a/kernel/trace/trace_syscalls.c b/kernel/trace/trace_syscalls.c
index 96fc733..60e4d78 100644
--- a/kernel/trace/trace_syscalls.c
+++ b/kernel/trace/trace_syscalls.c
@@ -532,7 +532,7 @@ static void perf_syscall_enter(void *ignore, struct pt_regs *regs, long id)
 			       (unsigned long *)&rec->args);
 
 	head = this_cpu_ptr(sys_data->enter_event->perf_events);
-	perf_trace_buf_submit(rec, size, rctx, 0, 1, regs, head);
+	perf_trace_buf_submit(rec, size, rctx, 0, 1, regs, head, NULL);
 }
 
 int perf_sysenter_enable(struct ftrace_event_call *call)
@@ -608,7 +608,7 @@ static void perf_syscall_exit(void *ignore, struct pt_regs *regs, long ret)
 	rec->ret = syscall_get_return_value(current, regs);
 
 	head = this_cpu_ptr(sys_data->exit_event->perf_events);
-	perf_trace_buf_submit(rec, size, rctx, 0, 1, regs, head);
+	perf_trace_buf_submit(rec, size, rctx, 0, 1, regs, head, NULL);
 }
 
 int perf_sysexit_enable(struct ftrace_event_call *call)
-- 
1.7.1

