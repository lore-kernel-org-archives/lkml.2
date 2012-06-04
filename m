Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760489Ab2FDMlP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2012 08:41:15 -0400
Received: from merlin.infradead.org ([205.233.59.134]:51103 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753520Ab2FDMlM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2012 08:41:12 -0400
Message-ID: <1338813658.28282.43.camel@twins>
Subject: Re: [RFC] [PATCH 0/5] Teach perf tool to profile sleep times (V4)
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Andrew Vagin <avagin@openvz.org>
Cc: Arun Sharma <asharma@fb.com>, Oleg Strikov <OSTRIKOV@nvidia.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, linux-kernel@vger.kernel.org
Date: Mon, 04 Jun 2012 14:40:58 +0200
In-Reply-To: <1338797382-287275-1-git-send-email-avagin@openvz.org>
References: <1338797382-287275-1-git-send-email-avagin@openvz.org>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-06-04 at 12:09 +0400, Andrew Vagin wrote:
> This series resolves a problem with events filtering and non-root users.
> Before I tried to use sched_stat* events, but it occurs in a context of
> another task. For this case logic of perf_event_context* doesn't work.
> 
> This series adds one more event sched:sched_switch_finish, it's sent
> when a task starts executing on a cpu. When a task goes out from cpu,
> sched:sched_switch is sent.
> 
> The time difference between sched_switch and sched_switch_finish is a time
> when a task wasn't being executed on a cpu.


So I really don't like this stuff either.. :-)

Mostly because it adds very similar stuff to what's already there and
then doesn't try and consolidate things.

And partly because you're measuring the 'wrong' thing, the delay between
sched-out and sched-in includes a number of things, only one part of
that is the delay due to blocking.

And as a result you need that hideous prev_state crap.


Would something like the below work?

The one thing I'm not entirely sure of is if this is a sekjoerity issue
or not.. anybody? I would think a task was entitled to know who woke it
and wherefrom etc..

---
 include/linux/ftrace_event.h |    5 +++--
 include/linux/perf_event.h   |    3 ++-
 include/trace/events/sched.h |    4 ++++
 include/trace/ftrace.h       |    6 +++++-
 kernel/events/core.c         |   19 ++++++++++++++++++-
 kernel/sched/core.c          |    2 +-
 6 files changed, 33 insertions(+), 6 deletions(-)

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
index f325786..a3d7b90 100644
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
index ea7a203..31da561 100644
--- a/include/trace/events/sched.h
+++ b/include/trace/events/sched.h
@@ -75,6 +75,10 @@ DECLARE_EVENT_CLASS(sched_wakeup_template,
 		__entry->target_cpu	= task_cpu(p);
 	),
 
+	TP_perf_assign(
+		__perf_task(p);
+	),
+
 	TP_printk("comm=%s pid=%d prio=%d success=%d target_cpu=%03d",
 		  __entry->comm, __entry->pid, __entry->prio,
 		  __entry->success, __entry->target_cpu)
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
index 5b06cbb..cb84cbd6 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -5204,7 +5204,8 @@ static int perf_tp_event_match(struct perf_event *event,
 }
 
 void perf_tp_event(u64 addr, u64 count, void *record, int entry_size,
-		   struct pt_regs *regs, struct hlist_head *head, int rctx)
+		   struct pt_regs *regs, struct hlist_head *head, int rctx,
+		   struct task_struct *task)
 {
 	struct perf_sample_data data;
 	struct perf_event *event;
@@ -5223,6 +5224,22 @@ void perf_tp_event(u64 addr, u64 count, void *record, int entry_size,
 			perf_swevent_event(event, count, &data, regs);
 	}
 
+	/*
+	 * If we got specified a target task, also iterate its context and
+	 * deliver this event there too.
+	 */
+	if (task) {
+		struct perf_event_context *ctx;
+
+		rcu_read_lock();
+		ctx = rcu_dereference(task->perf_event_ctxp[perf_sw_context]);
+		list_for_each_entry_rcu(event, &ctx->event_list, event_entry) {
+			if (perf_tp_event_match(event, &data, regs))
+				perf_swevent_event(event, count, &data, regs);
+		}
+		rcu_read_unlock();
+	}
+
 	perf_swevent_put_recursion_context(rctx);
 }
 EXPORT_SYMBOL_GPL(perf_tp_event);
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 420e118..8ac193c 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -1912,11 +1912,11 @@ prepare_task_switch(struct rq *rq, struct task_struct *prev,
 		    struct task_struct *next)
 {
 	sched_info_switch(prev, next);
+	trace_sched_switch(prev, next); /* before we flip the trace context */
 	perf_event_task_sched_out(prev, next);
 	fire_sched_out_preempt_notifiers(prev, next);
 	prepare_lock_switch(rq, next);
 	prepare_arch_switch(next);
-	trace_sched_switch(prev, next);
 }
 
 /**

