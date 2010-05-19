Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752481Ab0ESI70 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 May 2010 04:59:26 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:60050 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751394Ab0ESI7Y convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 May 2010 04:59:24 -0400
Subject: Re: [tip:perf/core] perf/ftrace: Optimize perf/tracepoint
 interaction for single events
From: Peter Zijlstra <peterz@infradead.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: mingo@redhat.com, hpa@zytor.com, paulus@samba.org, acme@redhat.com,
       linux-kernel@vger.kernel.org, efault@gmx.de, rostedt@goodmis.org,
       tglx@linutronix.de, mingo@elte.hu, linux-tip-commits@vger.kernel.org
In-Reply-To: <20100519082335.GG5704@nowhere>
References: <tip-4f41c013f553957765902fb01475972f0af3e8e7@git.kernel.org>
	 <20100519075804.GF5704@nowhere> <1274257123.5605.10260.camel@twins>
	 <20100519082335.GG5704@nowhere>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Wed, 19 May 2010 10:58:45 +0200
Message-ID: <1274259525.5605.10352.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

How about something like the below?


---
Subject: perf, trace: Remove IRQ-disable from perf/tracepoint interaction
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
Date: Wed May 19 10:52:27 CEST 2010



Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 include/linux/ftrace_event.h    |    9 +----
 include/trace/ftrace.h          |   17 ++++------
 kernel/trace/trace_event_perf.c |   67 ++++++++++++++++------------------------
 kernel/trace/trace_kprobe.c     |   10 ++---
 kernel/trace/trace_syscalls.c   |   10 ++---
 5 files changed, 46 insertions(+), 67 deletions(-)

Index: linux-2.6/include/linux/ftrace_event.h
===================================================================
--- linux-2.6.orig/include/linux/ftrace_event.h
+++ linux-2.6/include/linux/ftrace_event.h
@@ -197,20 +197,17 @@ extern void perf_trace_disable(int event
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
 
Index: linux-2.6/include/trace/ftrace.h
===================================================================
--- linux-2.6.orig/include/trace/ftrace.h
+++ linux-2.6/include/trace/ftrace.h
@@ -768,7 +768,6 @@ perf_trace_templ_##call(struct ftrace_ev
 	struct ftrace_data_offsets_##call __maybe_unused __data_offsets;\
 	struct ftrace_raw_##call *entry;				\
 	u64 __addr = 0, __count = 1;					\
-	unsigned long irq_flags;					\
 	int __entry_size;						\
 	int __data_size;						\
 	int rctx;							\
@@ -781,17 +780,18 @@ perf_trace_templ_##call(struct ftrace_ev
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
@@ -799,13 +799,10 @@ perf_trace_templ_##call(struct ftrace_ev
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
Index: linux-2.6/kernel/trace/trace_event_perf.c
===================================================================
--- linux-2.6.orig/kernel/trace/trace_event_perf.c
+++ linux-2.6/kernel/trace/trace_event_perf.c
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
@@ -38,17 +34,16 @@ static int perf_trace_event_enable(struc
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
@@ -60,10 +55,12 @@ static int perf_trace_event_enable(struc
 
 fail_buf_nmi:
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
 fail_buf:
 	event->perf_refcount--;
@@ -99,11 +96,13 @@ static void perf_trace_event_disable(str
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
@@ -111,8 +110,8 @@ static void perf_trace_event_disable(str
 		 */
 		synchronize_sched();
 
-		free_percpu(buf);
-		free_percpu(nmi_buf);
+		for (i = 0; i < 4; i++)
+			free_percpu(buf[i]);
 	}
 }
 
@@ -132,47 +131,37 @@ void perf_trace_disable(int event_id)
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
Index: linux-2.6/kernel/trace/trace_kprobe.c
===================================================================
--- linux-2.6.orig/kernel/trace/trace_kprobe.c
+++ linux-2.6/kernel/trace/trace_kprobe.c
@@ -1343,7 +1343,6 @@ static __kprobes void kprobe_perf_func(s
 	struct kprobe_trace_entry_head *entry;
 	u8 *data;
 	int size, __size, i;
-	unsigned long irq_flags;
 	int rctx;
 
 	__size = sizeof(*entry) + tp->size;
@@ -1353,7 +1352,7 @@ static __kprobes void kprobe_perf_func(s
 		     "profile buffer not large enough"))
 		return;
 
-	entry = perf_trace_buf_prepare(size, call->id, &rctx, &irq_flags);
+	entry = perf_trace_buf_prepare(size, call->id, regs, &rctx);
 	if (!entry)
 		return;
 
@@ -1362,7 +1361,7 @@ static __kprobes void kprobe_perf_func(s
 	for (i = 0; i < tp->nr_args; i++)
 		call_fetch(&tp->args[i].fetch, regs, data + tp->args[i].offset);
 
-	perf_trace_buf_submit(entry, size, rctx, entry->ip, 1, irq_flags, regs, call->perf_data);
+	perf_trace_buf_submit(entry, size, rctx, entry->ip, 1, regs, call->perf_data);
 }
 
 /* Kretprobe profile handler */
@@ -1374,7 +1373,6 @@ static __kprobes void kretprobe_perf_fun
 	struct kretprobe_trace_entry_head *entry;
 	u8 *data;
 	int size, __size, i;
-	unsigned long irq_flags;
 	int rctx;
 
 	__size = sizeof(*entry) + tp->size;
@@ -1384,7 +1382,7 @@ static __kprobes void kretprobe_perf_fun
 		     "profile buffer not large enough"))
 		return;
 
-	entry = perf_trace_buf_prepare(size, call->id, &rctx, &irq_flags);
+	entry = perf_trace_buf_prepare(size, call->id, regs, &rctx);
 	if (!entry)
 		return;
 
@@ -1395,7 +1393,7 @@ static __kprobes void kretprobe_perf_fun
 		call_fetch(&tp->args[i].fetch, regs, data + tp->args[i].offset);
 
 	perf_trace_buf_submit(entry, size, rctx, entry->ret_ip, 1,
-			       irq_flags, regs, call->perf_data);
+			      regs, call->perf_data);
 }
 
 static int probe_perf_enable(struct ftrace_event_call *call)
Index: linux-2.6/kernel/trace/trace_syscalls.c
===================================================================
--- linux-2.6.orig/kernel/trace/trace_syscalls.c
+++ linux-2.6/kernel/trace/trace_syscalls.c
@@ -438,7 +438,6 @@ static void perf_syscall_enter(struct pt
 {
 	struct syscall_metadata *sys_data;
 	struct syscall_trace_enter *rec;
-	unsigned long flags;
 	int syscall_nr;
 	int rctx;
 	int size;
@@ -461,14 +460,14 @@ static void perf_syscall_enter(struct pt
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
 
@@ -511,7 +510,6 @@ static void perf_syscall_exit(struct pt_
 {
 	struct syscall_metadata *sys_data;
 	struct syscall_trace_exit *rec;
-	unsigned long flags;
 	int syscall_nr;
 	int rctx;
 	int size;
@@ -537,14 +535,14 @@ static void perf_syscall_exit(struct pt_
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
 

