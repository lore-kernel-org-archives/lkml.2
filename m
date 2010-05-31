Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756380Ab0EaHUS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 May 2010 03:20:18 -0400
Received: from hera.kernel.org ([140.211.167.34]:44427 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756349Ab0EaHUN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 May 2010 03:20:13 -0400
Date: Mon, 31 May 2010 07:19:48 GMT
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       fweisbec@gmail.com, a.p.zijlstra@chello.nl, tglx@linutronix.de,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       fweisbec@gmail.com, a.p.zijlstra@chello.nl, tglx@linutronix.de,
       mingo@elte.hu
In-Reply-To: <1274438476.1674.1702.camel@laptop>
References: <1274438476.1674.1702.camel@laptop>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf_events, trace: Fix probe unregister race
Message-ID: <tip-3771f0771154675d4a0ca780be2411f3cc357208@git.kernel.org>
Git-Commit-ID: 3771f0771154675d4a0ca780be2411f3cc357208
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Mon, 31 May 2010 07:19:48 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  3771f0771154675d4a0ca780be2411f3cc357208
Gitweb:     http://git.kernel.org/tip/3771f0771154675d4a0ca780be2411f3cc357208
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Fri, 21 May 2010 12:31:09 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Mon, 31 May 2010 08:46:09 +0200

perf_events, trace: Fix probe unregister race

tracepoint_probe_unregister() does not synchronize against the probe
callbacks, so do that explicitly. This properly serializes the callbacks
and the free of the data used therein.

Also, use this_cpu_ptr() where possible.

Acked-by: Frederic Weisbecker <fweisbec@gmail.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <1274438476.1674.1702.camel@laptop>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 include/trace/ftrace.h          |    2 +-
 kernel/trace/trace_event_perf.c |   10 ++++++++--
 kernel/trace/trace_kprobe.c     |    4 ++--
 kernel/trace/trace_syscalls.c   |    4 ++--
 4 files changed, 13 insertions(+), 7 deletions(-)

diff --git a/include/trace/ftrace.h b/include/trace/ftrace.h
index 3d685d1..5a64905 100644
--- a/include/trace/ftrace.h
+++ b/include/trace/ftrace.h
@@ -725,7 +725,7 @@ perf_trace_##call(void *__data, proto)					\
 									\
 	{ assign; }							\
 									\
-	head = per_cpu_ptr(event_call->perf_events, smp_processor_id());\
+	head = this_cpu_ptr(event_call->perf_events);			\
 	perf_trace_buf_submit(entry, __entry_size, rctx, __addr,	\
 		__count, &__regs, head);				\
 }
diff --git a/kernel/trace/trace_event_perf.c b/kernel/trace/trace_event_perf.c
index cb6f365..49c7abf 100644
--- a/kernel/trace/trace_event_perf.c
+++ b/kernel/trace/trace_event_perf.c
@@ -116,7 +116,7 @@ int perf_trace_enable(struct perf_event *p_event)
 	if (WARN_ON_ONCE(!list))
 		return -EINVAL;
 
-	list = per_cpu_ptr(list, smp_processor_id());
+	list = this_cpu_ptr(list);
 	hlist_add_head_rcu(&p_event->hlist_entry, list);
 
 	return 0;
@@ -142,6 +142,12 @@ void perf_trace_destroy(struct perf_event *p_event)
 					    tp_event->class->perf_probe,
 					    tp_event);
 
+	/*
+	 * Ensure our callback won't be called anymore. See
+	 * tracepoint_probe_unregister() and __DO_TRACE().
+	 */
+	synchronize_sched();
+
 	free_percpu(tp_event->perf_events);
 	tp_event->perf_events = NULL;
 
@@ -169,7 +175,7 @@ __kprobes void *perf_trace_buf_prepare(int size, unsigned short type,
 	if (*rctxp < 0)
 		return NULL;
 
-	raw_data = per_cpu_ptr(perf_trace_buf[*rctxp], smp_processor_id());
+	raw_data = this_cpu_ptr(perf_trace_buf[*rctxp]);
 
 	/* zero the dead bytes from align to not leak stack to user */
 	memset(&raw_data[size - sizeof(u64)], 0, sizeof(u64));
diff --git a/kernel/trace/trace_kprobe.c b/kernel/trace/trace_kprobe.c
index faf7cef..f52b5f5 100644
--- a/kernel/trace/trace_kprobe.c
+++ b/kernel/trace/trace_kprobe.c
@@ -1359,7 +1359,7 @@ static __kprobes void kprobe_perf_func(struct kprobe *kp,
 	for (i = 0; i < tp->nr_args; i++)
 		call_fetch(&tp->args[i].fetch, regs, data + tp->args[i].offset);
 
-	head = per_cpu_ptr(call->perf_events, smp_processor_id());
+	head = this_cpu_ptr(call->perf_events);
 	perf_trace_buf_submit(entry, size, rctx, entry->ip, 1, regs, head);
 }
 
@@ -1392,7 +1392,7 @@ static __kprobes void kretprobe_perf_func(struct kretprobe_instance *ri,
 	for (i = 0; i < tp->nr_args; i++)
 		call_fetch(&tp->args[i].fetch, regs, data + tp->args[i].offset);
 
-	head = per_cpu_ptr(call->perf_events, smp_processor_id());
+	head = this_cpu_ptr(call->perf_events);
 	perf_trace_buf_submit(entry, size, rctx, entry->ret_ip, 1, regs, head);
 }
 
diff --git a/kernel/trace/trace_syscalls.c b/kernel/trace/trace_syscalls.c
index d2c859c..34e3580 100644
--- a/kernel/trace/trace_syscalls.c
+++ b/kernel/trace/trace_syscalls.c
@@ -519,7 +519,7 @@ static void perf_syscall_enter(void *ignore, struct pt_regs *regs, long id)
 	syscall_get_arguments(current, regs, 0, sys_data->nb_args,
 			       (unsigned long *)&rec->args);
 
-	head = per_cpu_ptr(sys_data->enter_event->perf_events, smp_processor_id());
+	head = this_cpu_ptr(sys_data->enter_event->perf_events);
 	perf_trace_buf_submit(rec, size, rctx, 0, 1, regs, head);
 }
 
@@ -595,7 +595,7 @@ static void perf_syscall_exit(void *ignore, struct pt_regs *regs, long ret)
 	rec->nr = syscall_nr;
 	rec->ret = syscall_get_return_value(current, regs);
 
-	head = per_cpu_ptr(sys_data->exit_event->perf_events, smp_processor_id());
+	head = this_cpu_ptr(sys_data->exit_event->perf_events);
 	perf_trace_buf_submit(rec, size, rctx, 0, 1, regs, head);
 }
 
