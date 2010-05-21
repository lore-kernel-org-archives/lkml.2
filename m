Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754578Ab0EUKlV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 May 2010 06:41:21 -0400
Received: from casper.infradead.org ([85.118.1.10]:35907 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753353Ab0EUKlU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 May 2010 06:41:20 -0400
Subject: [PATCH 02b/10] perf, trace: Fix probe unregister race
From: Peter Zijlstra <peterz@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Paul Mackerras <paulus@samba.org>,
       Arnaldo Carvalho de Melo <acme@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20100521090710.473188012@chello.nl>
References: <20100521090201.326791353@chello.nl>
	 <20100521090710.473188012@chello.nl>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 21 May 2010 12:41:16 +0200
Message-ID: <1274438476.1674.1702.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

tracepoint_probe_unregister() does not synchronize against the probe callbacks,
so do that explicitly. This properly serializes the callbacks and the free of
the data used therein.

Also, use this_cpu_ptr() where possible.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 include/trace/ftrace.h          |    2 +-
 kernel/trace/trace_event_perf.c |   10 ++++++++--
 kernel/trace/trace_kprobe.c     |    4 ++--
 kernel/trace/trace_syscalls.c   |    4 ++--
 4 files changed, 13 insertions(+), 7 deletions(-)

Index: linux-2.6/include/trace/ftrace.h
===================================================================
--- linux-2.6.orig/include/trace/ftrace.h
+++ linux-2.6/include/trace/ftrace.h
@@ -791,7 +791,7 @@ perf_trace_templ_##call(struct ftrace_ev
 									\
 	{ assign; }							\
 									\
-	head = per_cpu_ptr(event_call->perf_events, smp_processor_id());\
+	head = this_cpu_ptr(event_call->perf_events);			\
 	perf_trace_buf_submit(entry, __entry_size, rctx, __addr,	\
 		__count, __regs, head);					\
 }
Index: linux-2.6/kernel/trace/trace_event_perf.c
===================================================================
--- linux-2.6.orig/kernel/trace/trace_event_perf.c
+++ linux-2.6/kernel/trace/trace_event_perf.c
@@ -109,7 +109,7 @@ int perf_trace_enable(struct perf_event 
 	if (WARN_ON_ONCE(!list))
 		return -EINVAL;
 
-	list = per_cpu_ptr(list, smp_processor_id());
+	list = this_cpu_ptr(list);
 	hlist_add_head_rcu(&p_event->hlist_entry, list);
 
 	return 0;
@@ -130,6 +130,12 @@ void perf_trace_destroy(struct perf_even
 
 	tp_event->perf_event_disable(tp_event);
 
+	/*
+	 * Ensure our callback won't be called anymore. See
+	 * tracepoint_probe_unregister() and __DO_TRACE().
+	 */
+	synchronize_sched();
+
 	free_percpu(tp_event->perf_events);
 	tp_event->perf_events = NULL;
 
@@ -156,7 +162,7 @@ __kprobes void *perf_trace_buf_prepare(i
 	if (*rctxp < 0)
 		return NULL;
 
-	raw_data = per_cpu_ptr(perf_trace_buf[*rctxp], smp_processor_id());
+	raw_data = this_cpu_ptr(perf_trace_buf[*rctxp]);
 
 	/* zero the dead bytes from align to not leak stack to user */
 	memset(&raw_data[size - sizeof(u64)], 0, sizeof(u64));
Index: linux-2.6/kernel/trace/trace_kprobe.c
===================================================================
--- linux-2.6.orig/kernel/trace/trace_kprobe.c
+++ linux-2.6/kernel/trace/trace_kprobe.c
@@ -1362,7 +1362,7 @@ static __kprobes void kprobe_perf_func(s
 	for (i = 0; i < tp->nr_args; i++)
 		call_fetch(&tp->args[i].fetch, regs, data + tp->args[i].offset);
 
-	head = per_cpu_ptr(call->perf_events, smp_processor_id());
+	head = this_cpu_ptr(call->perf_events);
 	perf_trace_buf_submit(entry, size, rctx, entry->ip, 1, regs, head);
 }
 
@@ -1395,7 +1395,7 @@ static __kprobes void kretprobe_perf_fun
 	for (i = 0; i < tp->nr_args; i++)
 		call_fetch(&tp->args[i].fetch, regs, data + tp->args[i].offset);
 
-	head = per_cpu_ptr(call->perf_events, smp_processor_id());
+	head = this_cpu_ptr(call->perf_events);
 	perf_trace_buf_submit(entry, size, rctx, entry->ret_ip, 1, regs, head);
 }
 
Index: linux-2.6/kernel/trace/trace_syscalls.c
===================================================================
--- linux-2.6.orig/kernel/trace/trace_syscalls.c
+++ linux-2.6/kernel/trace/trace_syscalls.c
@@ -469,7 +469,7 @@ static void perf_syscall_enter(struct pt
 	syscall_get_arguments(current, regs, 0, sys_data->nb_args,
 			       (unsigned long *)&rec->args);
 
-	head = per_cpu_ptr(sys_data->enter_event->perf_events, smp_processor_id());
+	head = this_cpu_ptr(sys_data->enter_event->perf_events);
 	perf_trace_buf_submit(rec, size, rctx, 0, 1, regs, head);
 }
 
@@ -545,7 +545,7 @@ static void perf_syscall_exit(struct pt_
 	rec->nr = syscall_nr;
 	rec->ret = syscall_get_return_value(current, regs);
 
-	head = per_cpu_ptr(sys_data->exit_event->perf_events, smp_processor_id());
+	head = this_cpu_ptr(sys_data->exit_event->perf_events);
 	perf_trace_buf_submit(rec, size, rctx, 0, 1, regs, head);
 }
 


