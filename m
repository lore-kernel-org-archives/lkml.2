Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757576Ab0EUOmc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 May 2010 10:42:32 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:58742 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757473Ab0EUOm3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 May 2010 10:42:29 -0400
X-Authority-Analysis: v=1.1 cv=APwCx09NCuKDvl2mjFwkKdJZScS8XOZHPgx3WG6BpL0= c=1 sm=0 a=YBAhgft_hbgA:10 a=uEzv4HemXiYA:10 a=7U3hwN5JcxgA:10 a=Q9fys5e9bTEA:10 a=gMqfjgEr1zLu/65IO0LwxA==:17 a=LUFoA7kCwt7_OS-wxqsA:9 a=anBja23IOrk3AGDqLxIA:7 a=9E4lc_TtL_DhEZ4zJShn_uzCDv4A:4 a=PUjeQqilurYA:10 a=gMqfjgEr1zLu/65IO0LwxA==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.89.75
Subject: Re: [GIT] merge conflicts of tip/tracing/core and latest perf/core
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
In-Reply-To: <1274452246.26328.3782.camel@gandalf.stny.rr.com>
References: <1274452246.26328.3782.camel@gandalf.stny.rr.com>
Content-Type: text/plain; charset="ISO-8859-15"
Organization: Kihon Technologies Inc.
Date: Fri, 21 May 2010 10:42:27 -0400
Message-ID: <1274452947.26328.3799.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-05-21 at 10:30 -0400, Steven Rostedt wrote:
> Once again I resolved the conflicts between tracing/core and the new
> changes of perf/core.
> 
> Here's the diff, can you please give acks.

For those that can't read git conflict diffs. Here's the:

  git diff HEAD

Which shows all of Peter's changes + mine on top. I only included the
files that conflicted:

# Changed but not updated:
#   (use "git add <file>..." to update what will be committed)
#   (use "git checkout -- <file>..." to discard changes in working directory)
#
#	unmerged:   include/linux/ftrace_event.h
#	unmerged:   include/trace/ftrace.h
#	unmerged:   kernel/trace/trace_event_perf.c
#	unmerged:   kernel/trace/trace_kprobe.c
#	unmerged:   kernel/trace/trace_syscalls.c
#


Note, I did add the #ifdef CONFIG_PERF_EVENTS in the event structure.

-- Steve

diff --git a/include/linux/ftrace_event.h b/include/linux/ftrace_event.h
index dc7fc64..ee8a841 100644
--- a/include/linux/ftrace_event.h
+++ b/include/linux/ftrace_event.h
@@ -180,7 +180,10 @@ struct ftrace_event_call {
 	 */
 	unsigned int		flags;
 
+#ifdef CONFIG_PERF_EVENTS
 	int			perf_refcount;
+	struct hlist_head	*perf_events;
+#endif
 };
 
 #define PERF_MAX_TRACE_SIZE	2048
@@ -237,24 +240,22 @@ struct perf_event;
 
 DECLARE_PER_CPU(struct pt_regs, perf_trace_regs);
 
-extern int perf_trace_enable(int event_id);
-extern void perf_trace_disable(int event_id);
-extern int ftrace_profile_set_filter(struct perf_event *event, int event_id,
+extern int  perf_trace_init(struct perf_event *event);
+extern void perf_trace_destroy(struct perf_event *event);
+extern int  perf_trace_enable(struct perf_event *event);
+extern void perf_trace_disable(struct perf_event *event);
+extern int  ftrace_profile_set_filter(struct perf_event *event, int event_id,
 				     char *filter_str);
 extern void ftrace_profile_free_filter(struct perf_event *event);
-extern void *
-perf_trace_buf_prepare(int size, unsigned short type, int *rctxp,
-			 unsigned long *irq_flags);
+extern void *perf_trace_buf_prepare(int size, unsigned short type,
+				    struct pt_regs *regs, int *rctxp);
 
 static inline void
 perf_trace_buf_submit(void *raw_data, int size, int rctx, u64 addr,
-		       u64 count, unsigned long irq_flags, struct pt_regs *regs)
+		       u64 count, struct pt_regs *regs, void *head)
 {
-	struct trace_entry *entry = raw_data;
-
-	perf_tp_event(entry->type, addr, count, raw_data, size, regs);
+	perf_tp_event(addr, count, raw_data, size, regs, head);
 	perf_swevent_put_recursion_context(rctx);
-	local_irq_restore(irq_flags);
 }
 #endif
 
diff --git a/include/trace/ftrace.h b/include/trace/ftrace.h
index e0e8daa..0152b86 100644
--- a/include/trace/ftrace.h
+++ b/include/trace/ftrace.h
@@ -695,14 +695,14 @@ perf_trace_##call(void *__data, proto)					\
 	struct ftrace_event_call *event_call = __data;			\
 	struct ftrace_data_offsets_##call __maybe_unused __data_offsets;\
 	struct ftrace_raw_##call *entry;				\
-	struct pt_regs *__regs = &get_cpu_var(perf_trace_regs);		\
+	struct pt_regs __regs;						\
 	u64 __addr = 0, __count = 1;					\
-	unsigned long irq_flags;					\
+	struct hlist_head *head;					\
 	int __entry_size;						\
 	int __data_size;						\
 	int rctx;							\
 									\
-	perf_fetch_caller_regs(__regs, 1);				\
+	perf_fetch_caller_regs(&__regs, 1);				\
 									\
 	__data_size = ftrace_get_offsets_##call(&__data_offsets, args); \
 	__entry_size = ALIGN(__data_size + sizeof(*entry) + sizeof(u32),\
@@ -711,19 +711,20 @@ perf_trace_##call(void *__data, proto)					\
 									\
 	if (WARN_ONCE(__entry_size > PERF_MAX_TRACE_SIZE,		\
 		      "profile buffer not large enough"))		\
-		goto out;						\
+		return;							\
+									\
 	entry = (struct ftrace_raw_##call *)perf_trace_buf_prepare(	\
-		__entry_size, event_call->event.type, &rctx, &irq_flags); \
+		__entry_size, event_call->event.type, &__regs, &rctx);	\
 	if (!entry)							\
-		goto out;						\
+		return;							\
+									\
 	tstruct								\
 									\
 	{ assign; }							\
 									\
+	head = per_cpu_ptr(event_call->perf_events, smp_processor_id());\
 	perf_trace_buf_submit(entry, __entry_size, rctx, __addr,	\
-			       __count, irq_flags, __regs);		\
- out:									\
-	put_cpu_var(perf_trace_regs);					\
+		__count, &__regs, head);				\
 }
 
 /*
@@ -736,7 +737,6 @@ perf_trace_##call(void *__data, proto)					\
 static inline void perf_test_probe_##call(void)				\
 {									\
 	check_trace_callback_type_##call(perf_trace_##template);	\
-									\
 }
 
 
diff --git a/kernel/trace/trace_event_perf.c b/kernel/trace/trace_event_perf.c
index 0a47e8d..26b8607 100644
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
@@ -27,63 +23,82 @@ typedef typeof(unsigned long [PERF_MAX_TRACE_SIZE / sizeof(unsigned long)])
 /* Count the events in use (per event id, not per instance) */
 static int	total_ref_count;
 
-static int perf_trace_event_enable(struct ftrace_event_call *event)
+static int perf_trace_event_init(struct ftrace_event_call *tp_event,
+				 struct perf_event *p_event)
 {
-	char *buf;
+	struct hlist_head *list;
 	int ret = -ENOMEM;
+	int cpu;
 
-	if (event->perf_refcount++ > 0)
+	p_event->tp_event = tp_event;
+	if (tp_event->perf_refcount++ > 0)
 		return 0;
 
-	if (!total_ref_count) {
-		buf = (char *)alloc_percpu(perf_trace_t);
-		if (!buf)
-			goto fail_buf;
+	list = alloc_percpu(struct hlist_head);
+	if (!list)
+		goto fail;
+
+	for_each_possible_cpu(cpu)
+		INIT_HLIST_HEAD(per_cpu_ptr(list, cpu));
 
-		rcu_assign_pointer(perf_trace_buf, buf);
+	tp_event->perf_events = list;
+
+	if (!total_ref_count) {
+		char *buf;
+		int i;
 
-		buf = (char *)alloc_percpu(perf_trace_t);
-		if (!buf)
-			goto fail_buf_nmi;
+		for (i = 0; i < 4; i++) {
+			buf = (char *)alloc_percpu(perf_trace_t);
+			if (!buf)
+				goto fail;
 
-		rcu_assign_pointer(perf_trace_buf_nmi, buf);
+			perf_trace_buf[i] = buf;
+		}
 	}
 
-	if (event->class->reg)
-		ret = event->class->reg(event, TRACE_REG_PERF_REGISTER);
+	if (tp_event->class->reg)
+		ret = tp_event->class->reg(tp_event, TRACE_REG_PERF_REGISTER);
 	else
-		ret = tracepoint_probe_register(event->name,
-						event->class->perf_probe,
-						event);
-	if (!ret) {
-		total_ref_count++;
-		return 0;
-	}
+		ret = tracepoint_probe_register(tp_event->name,
+						tp_event->class->perf_probe,
+						tp_event);
+
+	if (ret)
+		goto fail;
 
-fail_buf_nmi:
+	total_ref_count++;
+	return 0;
+
+fail:
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
+	}
+
+	if (!--tp_event->perf_refcount) {
+		free_percpu(tp_event->perf_events);
+		tp_event->perf_events = NULL;
 	}
-fail_buf:
-	event->perf_refcount--;
 
 	return ret;
 }
 
-int perf_trace_enable(int event_id)
+int perf_trace_init(struct perf_event *p_event)
 {
-	struct ftrace_event_call *event;
+	struct ftrace_event_call *tp_event;
+	int event_id = p_event->attr.config;
 	int ret = -EINVAL;
 
 	mutex_lock(&event_mutex);
-	list_for_each_entry(event, &ftrace_events, list) {
-		if (event->event.type == event_id &&
-		    event->class && event->class->perf_probe &&
-		    try_module_get(event->mod)) {
-			ret = perf_trace_event_enable(event);
+	list_for_each_entry(tp_event, &ftrace_events, list) {
+		if (tp_event->event.type == event_id &&
+		    tp_event->class && tp_event->class->perf_probe &&
+		    try_module_get(tp_event->mod)) {
+			ret = perf_trace_event_init(tp_event, p_event);
 			break;
 		}
 	}
@@ -92,93 +107,76 @@ int perf_trace_enable(int event_id)
 	return ret;
 }
 
-static void perf_trace_event_disable(struct ftrace_event_call *event)
+int perf_trace_enable(struct perf_event *p_event)
 {
-	char *buf, *nmi_buf;
-
-	if (--event->perf_refcount > 0)
-		return;
-
-	if (event->class->reg)
-		event->class->reg(event, TRACE_REG_PERF_UNREGISTER);
-	else
-		tracepoint_probe_unregister(event->name, event->class->perf_probe, event);
+	struct ftrace_event_call *tp_event = p_event->tp_event;
+	struct hlist_head *list;
 
-	if (!--total_ref_count) {
-		buf = perf_trace_buf;
-		rcu_assign_pointer(perf_trace_buf, NULL);
+	list = tp_event->perf_events;
+	if (WARN_ON_ONCE(!list))
+		return -EINVAL;
 
-		nmi_buf = perf_trace_buf_nmi;
-		rcu_assign_pointer(perf_trace_buf_nmi, NULL);
+	list = per_cpu_ptr(list, smp_processor_id());
+	hlist_add_head_rcu(&p_event->hlist_entry, list);
 
-		/*
-		 * Ensure every events in profiling have finished before
-		 * releasing the buffers
-		 */
-		synchronize_sched();
+	return 0;
+}
 
-		free_percpu(buf);
-		free_percpu(nmi_buf);
-	}
+void perf_trace_disable(struct perf_event *p_event)
+{
+	hlist_del_rcu(&p_event->hlist_entry);
 }
 
-void perf_trace_disable(int event_id)
+void perf_trace_destroy(struct perf_event *p_event)
 {
-	struct ftrace_event_call *event;
+	struct ftrace_event_call *tp_event = p_event->tp_event;
+	int i;
 
-	mutex_lock(&event_mutex);
-	list_for_each_entry(event, &ftrace_events, list) {
-		if (event->event.type == event_id) {
-			perf_trace_event_disable(event);
-			module_put(event->mod);
-			break;
+	if (--tp_event->perf_refcount > 0)
+		return;
+
+	if (tp_event->class->reg)
+		tp_event->class->reg(tp_event, TRACE_REG_PERF_UNREGISTER);
+	else
+		tracepoint_probe_unregister(tp_event->name,
+					    tp_event->class->perf_probe,
+					    tp_event);
+
+	free_percpu(tp_event->perf_events);
+	tp_event->perf_events = NULL;
+
+	if (!--total_ref_count) {
+		for (i = 0; i < 4; i++) {
+			free_percpu(perf_trace_buf[i]);
+			perf_trace_buf[i] = NULL;
 		}
 	}
-	mutex_unlock(&event_mutex);
 }
 
 __kprobes void *perf_trace_buf_prepare(int size, unsigned short type,
-				       int *rctxp, unsigned long *irq_flags)
+				       struct pt_regs *regs, int *rctxp)
 {
 	struct trace_entry *entry;
-	char *trace_buf, *raw_data;
-	int pc, cpu;
+	char *raw_data;
+	int pc;
 
 	BUILD_BUG_ON(PERF_MAX_TRACE_SIZE % sizeof(unsigned long));
 
 	pc = preempt_count();
 
-	/* Protect the per cpu buffer, begin the rcu read side */
-	local_irq_save(*irq_flags);
-
 	*rctxp = perf_swevent_get_recursion_context();
 	if (*rctxp < 0)
-		goto err_recursion;
-
-	cpu = smp_processor_id();
-
-	if (in_nmi())
-		trace_buf = rcu_dereference_sched(perf_trace_buf_nmi);
-	else
-		trace_buf = rcu_dereference_sched(perf_trace_buf);
-
-	if (!trace_buf)
-		goto err;
+		return NULL;
 
-	raw_data = per_cpu_ptr(trace_buf, cpu);
+	raw_data = per_cpu_ptr(perf_trace_buf[*rctxp], smp_processor_id());
 
 	/* zero the dead bytes from align to not leak stack to user */
 	memset(&raw_data[size - sizeof(u64)], 0, sizeof(u64));
 
 	entry = (struct trace_entry *)raw_data;
-	tracing_generic_entry_update(entry, *irq_flags, pc);
+	tracing_generic_entry_update(entry, regs->flags, pc);
 	entry->type = type;
 
 	return raw_data;
-err:
-	perf_swevent_put_recursion_context(*rctxp);
-err_recursion:
-	local_irq_restore(*irq_flags);
-	return NULL;
 }
 EXPORT_SYMBOL_GPL(perf_trace_buf_prepare);
diff --git a/kernel/trace/trace_kprobe.c b/kernel/trace/trace_kprobe.c
index 9a082bb..faf7cef 100644
--- a/kernel/trace/trace_kprobe.c
+++ b/kernel/trace/trace_kprobe.c
@@ -1338,9 +1338,9 @@ static __kprobes void kprobe_perf_func(struct kprobe *kp,
 	struct trace_probe *tp = container_of(kp, struct trace_probe, rp.kp);
 	struct ftrace_event_call *call = &tp->call;
 	struct kprobe_trace_entry_head *entry;
+	struct hlist_head *head;
 	u8 *data;
 	int size, __size, i;
-	unsigned long irq_flags;
 	int rctx;
 
 	__size = sizeof(*entry) + tp->size;
@@ -1350,8 +1350,7 @@ static __kprobes void kprobe_perf_func(struct kprobe *kp,
 		     "profile buffer not large enough"))
 		return;
 
-	entry = perf_trace_buf_prepare(size, call->event.type,
-				       &rctx, &irq_flags);
+	entry = perf_trace_buf_prepare(size, call->event.type, regs, &rctx);
 	if (!entry)
 		return;
 
@@ -1360,7 +1359,8 @@ static __kprobes void kprobe_perf_func(struct kprobe *kp,
 	for (i = 0; i < tp->nr_args; i++)
 		call_fetch(&tp->args[i].fetch, regs, data + tp->args[i].offset);
 
-	perf_trace_buf_submit(entry, size, rctx, entry->ip, 1, irq_flags, regs);
+	head = per_cpu_ptr(call->perf_events, smp_processor_id());
+	perf_trace_buf_submit(entry, size, rctx, entry->ip, 1, regs, head);
 }
 
 /* Kretprobe profile handler */
@@ -1370,9 +1370,9 @@ static __kprobes void kretprobe_perf_func(struct kretprobe_instance *ri,
 	struct trace_probe *tp = container_of(ri->rp, struct trace_probe, rp);
 	struct ftrace_event_call *call = &tp->call;
 	struct kretprobe_trace_entry_head *entry;
+	struct hlist_head *head;
 	u8 *data;
 	int size, __size, i;
-	unsigned long irq_flags;
 	int rctx;
 
 	__size = sizeof(*entry) + tp->size;
@@ -1382,8 +1382,7 @@ static __kprobes void kretprobe_perf_func(struct kretprobe_instance *ri,
 		     "profile buffer not large enough"))
 		return;
 
-	entry = perf_trace_buf_prepare(size, call->event.type,
-				       &rctx, &irq_flags);
+	entry = perf_trace_buf_prepare(size, call->event.type, regs, &rctx);
 	if (!entry)
 		return;
 
@@ -1393,8 +1392,8 @@ static __kprobes void kretprobe_perf_func(struct kretprobe_instance *ri,
 	for (i = 0; i < tp->nr_args; i++)
 		call_fetch(&tp->args[i].fetch, regs, data + tp->args[i].offset);
 
-	perf_trace_buf_submit(entry, size, rctx, entry->ret_ip, 1,
-			       irq_flags, regs);
+	head = per_cpu_ptr(call->perf_events, smp_processor_id());
+	perf_trace_buf_submit(entry, size, rctx, entry->ret_ip, 1, regs, head);
 }
 
 static int probe_perf_enable(struct ftrace_event_call *call)
diff --git a/kernel/trace/trace_syscalls.c b/kernel/trace/trace_syscalls.c
index 9d35830..d2c859c 100644
--- a/kernel/trace/trace_syscalls.c
+++ b/kernel/trace/trace_syscalls.c
@@ -488,7 +488,7 @@ static void perf_syscall_enter(void *ignore, struct pt_regs *regs, long id)
 {
 	struct syscall_metadata *sys_data;
 	struct syscall_trace_enter *rec;
-	unsigned long flags;
+	struct hlist_head *head;
 	int syscall_nr;
 	int rctx;
 	int size;
@@ -511,15 +511,16 @@ static void perf_syscall_enter(void *ignore, struct pt_regs *regs, long id)
 		return;
 
 	rec = (struct syscall_trace_enter *)perf_trace_buf_prepare(size,
-				sys_data->enter_event->event.type,
-				&rctx, &flags);
+				sys_data->enter_event->event.type, regs, &rctx);
 	if (!rec)
 		return;
 
 	rec->nr = syscall_nr;
 	syscall_get_arguments(current, regs, 0, sys_data->nb_args,
 			       (unsigned long *)&rec->args);
-	perf_trace_buf_submit(rec, size, rctx, 0, 1, flags, regs);
+
+	head = per_cpu_ptr(sys_data->enter_event->perf_events, smp_processor_id());
+	perf_trace_buf_submit(rec, size, rctx, 0, 1, regs, head);
 }
 
 int perf_sysenter_enable(struct ftrace_event_call *call)
@@ -561,7 +562,7 @@ static void perf_syscall_exit(void *ignore, struct pt_regs *regs, long ret)
 {
 	struct syscall_metadata *sys_data;
 	struct syscall_trace_exit *rec;
-	unsigned long flags;
+	struct hlist_head *head;
 	int syscall_nr;
 	int rctx;
 	int size;
@@ -587,15 +588,15 @@ static void perf_syscall_exit(void *ignore, struct pt_regs *regs, long ret)
 		return;
 
 	rec = (struct syscall_trace_exit *)perf_trace_buf_prepare(size,
-				sys_data->exit_event->event.type,
-				&rctx, &flags);
+				sys_data->exit_event->event.type, regs, &rctx);
 	if (!rec)
 		return;
 
 	rec->nr = syscall_nr;
 	rec->ret = syscall_get_return_value(current, regs);
 
-	perf_trace_buf_submit(rec, size, rctx, 0, 1, flags, regs);
+	head = per_cpu_ptr(sys_data->exit_event->perf_events, smp_processor_id());
+	perf_trace_buf_submit(rec, size, rctx, 0, 1, regs, head);
 }
 
 int perf_sysexit_enable(struct ftrace_event_call *call)


