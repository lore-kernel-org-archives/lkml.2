Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754699Ab0EUL2b (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 May 2010 07:28:31 -0400
Received: from hera.kernel.org ([140.211.167.34]:58498 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752896Ab0EUL23 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 May 2010 07:28:29 -0400
Date: Fri, 21 May 2010 11:27:55 GMT
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-kernel@vger.kernel.org, paulus@samba.org, acme@redhat.com,
       hpa@zytor.com, mingo@redhat.com, a.p.zijlstra@chello.nl, efault@gmx.de,
       fweisbec@gmail.com, rostedt@goodmis.org, tglx@linutronix.de,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, acme@redhat.com, paulus@samba.org,
       linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl, efault@gmx.de,
       fweisbec@gmail.com, rostedt@goodmis.org, tglx@linutronix.de,
       mingo@elte.hu
In-Reply-To: <1274259525.5605.10352.camel@twins>
References: <1274259525.5605.10352.camel@twins>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf, trace: Optimize tracepoints by removing IRQ-disable from perf/tracepoint interaction
Message-ID: <tip-b7e2ecef92d2e7785e6d76b41e5ba8bcbc45259d@git.kernel.org>
Git-Commit-ID: b7e2ecef92d2e7785e6d76b41e5ba8bcbc45259d
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 21 May 2010 11:27:57 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  b7e2ecef92d2e7785e6d76b41e5ba8bcbc45259d
Gitweb:     http://git.kernel.org/tip/b7e2ecef92d2e7785e6d76b41e5ba8bcbc45259d
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Wed, 19 May 2010 10:52:27 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 21 May 2010 11:37:56 +0200

perf, trace: Optimize tracepoints by removing IRQ-disable from perf/tracepoint interaction

Improves performance.

Acked-by: Frederic Weisbecker <fweisbec@gmail.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Steven Rostedt <rostedt@goodmis.org>
LKML-Reference: <1274259525.5605.10352.camel@twins>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 include/linux/ftrace_event.h    |    9 ++---
 include/trace/ftrace.h          |   17 ++++-----
 kernel/trace/trace_event_perf.c |   73 +++++++++++++++-----------------------
 kernel/trace/trace_kprobe.c     |   10 ++---
 kernel/trace/trace_syscalls.c   |   10 ++---
 5 files changed, 47 insertions(+), 72 deletions(-)

diff --git a/include/linux/ftrace_event.h b/include/linux/ftrace_event.h
index a9775dd..126071b 100644
--- a/include/linux/ftrace_event.h
+++ b/include/linux/ftrace_event.h
@@ -197,20 +197,17 @@ extern void perf_trace_disable(int event_id);
 extern int ftrace_profile_set_filter(struct perf_event *event, int event_id,
 				     char *filter_str);
 extern void ftrace_profile_free_filter(struct perf_event *event);
-extern void *
-perf_trace_buf_prepare(int size, unsigned short type, int *rctxp,
-			 unsigned long *irq_flags);
+extern void *perf_trace_buf_prepare(int size, unsigned short type,
+				    struct pt_regs *regs, int *rctxp);
 
 static inline void
 perf_trace_buf_submit(void *raw_data, int size, int rctx, u64 addr,
-		       u64 count, unsigned long irq_flags, struct pt_regs *regs,
-		       void *event)
+		       u64 count, struct pt_regs *regs, void *event)
 {
 	struct trace_entry *entry = raw_data;
 
 	perf_tp_event(entry->type, addr, count, raw_data, size, regs, event);
 	perf_swevent_put_recursion_context(rctx);
-	local_irq_restore(irq_flags);
 }
 #endif
 
diff --git a/include/trace/ftrace.h b/include/trace/ftrace.h
index 1016b21..f282885 100644
--- a/include/trace/ftrace.h
+++ b/include/trace/ftrace.h
@@ -768,7 +768,6 @@ perf_trace_templ_##call(struct ftrace_event_call *event_call,		\
 	struct ftrace_data_offsets_##call __maybe_unused __data_offsets;\
 	struct ftrace_raw_##call *entry;				\
 	u64 __addr = 0, __count = 1;					\
-	unsigned long irq_flags;					\
 	int __entry_size;						\
 	int __data_size;						\
 	int rctx;							\
@@ -781,17 +780,18 @@ perf_trace_templ_##call(struct ftrace_event_call *event_call,		\
 	if (WARN_ONCE(__entry_size > PERF_MAX_TRACE_SIZE,		\
 		      "profile buffer not large enough"))		\
 		return;							\
+									\
 	entry = (struct ftrace_raw_##call *)perf_trace_buf_prepare(	\
-		__entry_size, event_call->id, &rctx, &irq_flags);	\
+		__entry_size, event_call->id, __regs, &rctx);		\
 	if (!entry)							\
 		return;							\
+									\
 	tstruct								\
 									\
 	{ assign; }							\
 									\
 	perf_trace_buf_submit(entry, __entry_size, rctx, __addr,	\
-			       __count, irq_flags, __regs, 		\
-			      event_call->perf_data);			\
+			       __count, __regs, event_call->perf_data);	\
 }
 
 #undef DEFINE_EVENT
@@ -799,13 +799,10 @@ perf_trace_templ_##call(struct ftrace_event_call *event_call,		\
 static notrace void perf_trace_##call(proto)				\
 {									\
 	struct ftrace_event_call *event_call = &event_##call;		\
-	struct pt_regs *__regs = &get_cpu_var(perf_trace_regs);		\
-									\
-	perf_fetch_caller_regs(__regs, 1);				\
-									\
-	perf_trace_templ_##template(event_call, __regs, args);		\
+	struct pt_regs __regs;						\
 									\
-	put_cpu_var(perf_trace_regs);					\
+	perf_fetch_caller_regs(&__regs, 1);				\
+	perf_trace_templ_##template(event_call, &__regs, args);		\
 }
 
 #undef DEFINE_EVENT_PRINT
diff --git a/kernel/trace/trace_event_perf.c b/kernel/trace/trace_event_perf.c
index 89b780a..a1304f8 100644
--- a/kernel/trace/trace_event_perf.c
+++ b/kernel/trace/trace_event_perf.c
@@ -9,13 +9,9 @@
 #include <linux/kprobes.h>
 #include "trace.h"
 
-DEFINE_PER_CPU(struct pt_regs, perf_trace_regs);
-EXPORT_PER_CPU_SYMBOL_GPL(perf_trace_regs);
-
 EXPORT_SYMBOL_GPL(perf_arch_fetch_caller_regs);
 
-static char *perf_trace_buf;
-static char *perf_trace_buf_nmi;
+static char *perf_trace_buf[4];
 
 /*
  * Force it to be aligned to unsigned long to avoid misaligned accesses
@@ -29,7 +25,6 @@ static int	total_ref_count;
 
 static int perf_trace_event_enable(struct ftrace_event_call *event, void *data)
 {
-	char *buf;
 	int ret = -ENOMEM;
 
 	if (event->perf_refcount++ > 0) {
@@ -38,17 +33,16 @@ static int perf_trace_event_enable(struct ftrace_event_call *event, void *data)
 	}
 
 	if (!total_ref_count) {
-		buf = (char *)alloc_percpu(perf_trace_t);
-		if (!buf)
-			goto fail_buf;
-
-		rcu_assign_pointer(perf_trace_buf, buf);
+		char *buf;
+		int i;
 
-		buf = (char *)alloc_percpu(perf_trace_t);
-		if (!buf)
-			goto fail_buf_nmi;
+		for (i = 0; i < 4; i++) {
+			buf = (char *)alloc_percpu(perf_trace_t);
+			if (!buf)
+				goto fail_buf;
 
-		rcu_assign_pointer(perf_trace_buf_nmi, buf);
+			rcu_assign_pointer(perf_trace_buf[i], buf);
+		}
 	}
 
 	ret = event->perf_event_enable(event);
@@ -58,14 +52,15 @@ static int perf_trace_event_enable(struct ftrace_event_call *event, void *data)
 		return 0;
 	}
 
-fail_buf_nmi:
+fail_buf:
 	if (!total_ref_count) {
-		free_percpu(perf_trace_buf_nmi);
-		free_percpu(perf_trace_buf);
-		perf_trace_buf_nmi = NULL;
-		perf_trace_buf = NULL;
+		int i;
+
+		for (i = 0; i < 4; i++) {
+			free_percpu(perf_trace_buf[i]);
+			perf_trace_buf[i] = NULL;
+		}
 	}
-fail_buf:
 	event->perf_refcount--;
 
 	return ret;
@@ -91,19 +86,19 @@ int perf_trace_enable(int event_id, void *data)
 
 static void perf_trace_event_disable(struct ftrace_event_call *event)
 {
-	char *buf, *nmi_buf;
-
 	if (--event->perf_refcount > 0)
 		return;
 
 	event->perf_event_disable(event);
 
 	if (!--total_ref_count) {
-		buf = perf_trace_buf;
-		rcu_assign_pointer(perf_trace_buf, NULL);
+		char *buf[4];
+		int i;
 
-		nmi_buf = perf_trace_buf_nmi;
-		rcu_assign_pointer(perf_trace_buf_nmi, NULL);
+		for (i = 0; i < 4; i++) {
+			buf[i] = perf_trace_buf[i];
+			rcu_assign_pointer(perf_trace_buf[i], NULL);
+		}
 
 		/*
 		 * Ensure every events in profiling have finished before
@@ -111,8 +106,8 @@ static void perf_trace_event_disable(struct ftrace_event_call *event)
 		 */
 		synchronize_sched();
 
-		free_percpu(buf);
-		free_percpu(nmi_buf);
+		for (i = 0; i < 4; i++)
+			free_percpu(buf[i]);
 	}
 }
 
@@ -132,47 +127,37 @@ void perf_trace_disable(int event_id)
 }
 
 __kprobes void *perf_trace_buf_prepare(int size, unsigned short type,
-				       int *rctxp, unsigned long *irq_flags)
+				       struct pt_regs *regs, int *rctxp)
 {
 	struct trace_entry *entry;
 	char *trace_buf, *raw_data;
-	int pc, cpu;
+	int pc;
 
 	BUILD_BUG_ON(PERF_MAX_TRACE_SIZE % sizeof(unsigned long));
 
 	pc = preempt_count();
 
-	/* Protect the per cpu buffer, begin the rcu read side */
-	local_irq_save(*irq_flags);
-
 	*rctxp = perf_swevent_get_recursion_context();
 	if (*rctxp < 0)
 		goto err_recursion;
 
-	cpu = smp_processor_id();
-
-	if (in_nmi())
-		trace_buf = rcu_dereference_sched(perf_trace_buf_nmi);
-	else
-		trace_buf = rcu_dereference_sched(perf_trace_buf);
-
+	trace_buf = rcu_dereference_sched(perf_trace_buf[*rctxp]);
 	if (!trace_buf)
 		goto err;
 
-	raw_data = per_cpu_ptr(trace_buf, cpu);
+	raw_data = per_cpu_ptr(trace_buf, smp_processor_id());
 
 	/* zero the dead bytes from align to not leak stack to user */
 	memset(&raw_data[size - sizeof(u64)], 0, sizeof(u64));
 
 	entry = (struct trace_entry *)raw_data;
-	tracing_generic_entry_update(entry, *irq_flags, pc);
+	tracing_generic_entry_update(entry, regs->flags, pc);
 	entry->type = type;
 
 	return raw_data;
 err:
 	perf_swevent_put_recursion_context(*rctxp);
 err_recursion:
-	local_irq_restore(*irq_flags);
 	return NULL;
 }
 EXPORT_SYMBOL_GPL(perf_trace_buf_prepare);
diff --git a/kernel/trace/trace_kprobe.c b/kernel/trace/trace_kprobe.c
index 2d7bf41..20c96de 100644
--- a/kernel/trace/trace_kprobe.c
+++ b/kernel/trace/trace_kprobe.c
@@ -1343,7 +1343,6 @@ static __kprobes void kprobe_perf_func(struct kprobe *kp,
 	struct kprobe_trace_entry_head *entry;
 	u8 *data;
 	int size, __size, i;
-	unsigned long irq_flags;
 	int rctx;
 
 	__size = sizeof(*entry) + tp->size;
@@ -1353,7 +1352,7 @@ static __kprobes void kprobe_perf_func(struct kprobe *kp,
 		     "profile buffer not large enough"))
 		return;
 
-	entry = perf_trace_buf_prepare(size, call->id, &rctx, &irq_flags);
+	entry = perf_trace_buf_prepare(size, call->id, regs, &rctx);
 	if (!entry)
 		return;
 
@@ -1362,7 +1361,7 @@ static __kprobes void kprobe_perf_func(struct kprobe *kp,
 	for (i = 0; i < tp->nr_args; i++)
 		call_fetch(&tp->args[i].fetch, regs, data + tp->args[i].offset);
 
-	perf_trace_buf_submit(entry, size, rctx, entry->ip, 1, irq_flags, regs, call->perf_data);
+	perf_trace_buf_submit(entry, size, rctx, entry->ip, 1, regs, call->perf_data);
 }
 
 /* Kretprobe profile handler */
@@ -1374,7 +1373,6 @@ static __kprobes void kretprobe_perf_func(struct kretprobe_instance *ri,
 	struct kretprobe_trace_entry_head *entry;
 	u8 *data;
 	int size, __size, i;
-	unsigned long irq_flags;
 	int rctx;
 
 	__size = sizeof(*entry) + tp->size;
@@ -1384,7 +1382,7 @@ static __kprobes void kretprobe_perf_func(struct kretprobe_instance *ri,
 		     "profile buffer not large enough"))
 		return;
 
-	entry = perf_trace_buf_prepare(size, call->id, &rctx, &irq_flags);
+	entry = perf_trace_buf_prepare(size, call->id, regs, &rctx);
 	if (!entry)
 		return;
 
@@ -1395,7 +1393,7 @@ static __kprobes void kretprobe_perf_func(struct kretprobe_instance *ri,
 		call_fetch(&tp->args[i].fetch, regs, data + tp->args[i].offset);
 
 	perf_trace_buf_submit(entry, size, rctx, entry->ret_ip, 1,
-			       irq_flags, regs, call->perf_data);
+			      regs, call->perf_data);
 }
 
 static int probe_perf_enable(struct ftrace_event_call *call)
diff --git a/kernel/trace/trace_syscalls.c b/kernel/trace/trace_syscalls.c
index 9eff1a4..a657cef 100644
--- a/kernel/trace/trace_syscalls.c
+++ b/kernel/trace/trace_syscalls.c
@@ -438,7 +438,6 @@ static void perf_syscall_enter(struct pt_regs *regs, long id)
 {
 	struct syscall_metadata *sys_data;
 	struct syscall_trace_enter *rec;
-	unsigned long flags;
 	int syscall_nr;
 	int rctx;
 	int size;
@@ -461,14 +460,14 @@ static void perf_syscall_enter(struct pt_regs *regs, long id)
 		return;
 
 	rec = (struct syscall_trace_enter *)perf_trace_buf_prepare(size,
-				sys_data->enter_event->id, &rctx, &flags);
+				sys_data->enter_event->id, regs, &rctx);
 	if (!rec)
 		return;
 
 	rec->nr = syscall_nr;
 	syscall_get_arguments(current, regs, 0, sys_data->nb_args,
 			       (unsigned long *)&rec->args);
-	perf_trace_buf_submit(rec, size, rctx, 0, 1, flags, regs,
+	perf_trace_buf_submit(rec, size, rctx, 0, 1, regs,
 			sys_data->enter_event->perf_data);
 }
 
@@ -511,7 +510,6 @@ static void perf_syscall_exit(struct pt_regs *regs, long ret)
 {
 	struct syscall_metadata *sys_data;
 	struct syscall_trace_exit *rec;
-	unsigned long flags;
 	int syscall_nr;
 	int rctx;
 	int size;
@@ -537,14 +535,14 @@ static void perf_syscall_exit(struct pt_regs *regs, long ret)
 		return;
 
 	rec = (struct syscall_trace_exit *)perf_trace_buf_prepare(size,
-				sys_data->exit_event->id, &rctx, &flags);
+				sys_data->exit_event->id, regs, &rctx);
 	if (!rec)
 		return;
 
 	rec->nr = syscall_nr;
 	rec->ret = syscall_get_return_value(current, regs);
 
-	perf_trace_buf_submit(rec, size, rctx, 0, 1, flags, regs,
+	perf_trace_buf_submit(rec, size, rctx, 0, 1, regs,
 			sys_data->exit_event->perf_data);
 }
 
