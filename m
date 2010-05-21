Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755003Ab0EUL2r (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 May 2010 07:28:47 -0400
Received: from hera.kernel.org ([140.211.167.34]:58511 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754442Ab0EUL2o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 May 2010 07:28:44 -0400
Date: Fri, 21 May 2010 11:28:13 GMT
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-kernel@vger.kernel.org, paulus@samba.org, acme@redhat.com,
       hpa@zytor.com, mingo@redhat.com, a.p.zijlstra@chello.nl, efault@gmx.de,
       fweisbec@gmail.com, rostedt@goodmis.org, tglx@linutronix.de,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, acme@redhat.com, paulus@samba.org,
       linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl, efault@gmx.de,
       fweisbec@gmail.com, rostedt@goodmis.org, tglx@linutronix.de,
       mingo@elte.hu
In-Reply-To: <20100521090710.473188012@chello.nl>
References: <20100521090710.473188012@chello.nl>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf, trace: Optimize tracepoints by using per-tracepoint-per-cpu hlist to track events
Message-ID: <tip-1c024eca51fdc965290acf342ae16a476c2189d0@git.kernel.org>
Git-Commit-ID: 1c024eca51fdc965290acf342ae16a476c2189d0
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 21 May 2010 11:28:14 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  1c024eca51fdc965290acf342ae16a476c2189d0
Gitweb:     http://git.kernel.org/tip/1c024eca51fdc965290acf342ae16a476c2189d0
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Wed, 19 May 2010 14:02:22 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 21 May 2010 11:37:56 +0200

perf, trace: Optimize tracepoints by using per-tracepoint-per-cpu hlist to track events

Avoid the swevent hash-table by using per-tracepoint
hlists.

Also, avoid conditionals on the fast path by ordering
with probe unregister so that we should never get on
the callback path without the data being there.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Steven Rostedt <rostedt@goodmis.org>
LKML-Reference: <20100521090710.473188012@chello.nl>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 include/linux/ftrace_event.h    |   16 +++---
 include/linux/perf_event.h      |    6 +-
 include/trace/ftrace.h          |    4 +-
 kernel/perf_event.c             |   94 +++++++++++++++--------------
 kernel/trace/trace_event_perf.c |  127 ++++++++++++++++++++------------------
 kernel/trace/trace_kprobe.c     |    9 ++-
 kernel/trace/trace_syscalls.c   |   11 ++-
 7 files changed, 143 insertions(+), 124 deletions(-)

diff --git a/include/linux/ftrace_event.h b/include/linux/ftrace_event.h
index 126071b..7024b7d 100644
--- a/include/linux/ftrace_event.h
+++ b/include/linux/ftrace_event.h
@@ -133,7 +133,7 @@ struct ftrace_event_call {
 	void			*data;
 
 	int			perf_refcount;
-	void			*perf_data;
+	struct hlist_head	*perf_events;
 	int			(*perf_event_enable)(struct ftrace_event_call *);
 	void			(*perf_event_disable)(struct ftrace_event_call *);
 };
@@ -192,9 +192,11 @@ struct perf_event;
 
 DECLARE_PER_CPU(struct pt_regs, perf_trace_regs);
 
-extern int perf_trace_enable(int event_id, void *data);
-extern void perf_trace_disable(int event_id);
-extern int ftrace_profile_set_filter(struct perf_event *event, int event_id,
+extern int  perf_trace_init(struct perf_event *event);
+extern void perf_trace_destroy(struct perf_event *event);
+extern int  perf_trace_enable(struct perf_event *event);
+extern void perf_trace_disable(struct perf_event *event);
+extern int  ftrace_profile_set_filter(struct perf_event *event, int event_id,
 				     char *filter_str);
 extern void ftrace_profile_free_filter(struct perf_event *event);
 extern void *perf_trace_buf_prepare(int size, unsigned short type,
@@ -202,11 +204,9 @@ extern void *perf_trace_buf_prepare(int size, unsigned short type,
 
 static inline void
 perf_trace_buf_submit(void *raw_data, int size, int rctx, u64 addr,
-		       u64 count, struct pt_regs *regs, void *event)
+		       u64 count, struct pt_regs *regs, void *head)
 {
-	struct trace_entry *entry = raw_data;
-
-	perf_tp_event(entry->type, addr, count, raw_data, size, regs, event);
+	perf_tp_event(addr, count, raw_data, size, regs, head);
 	perf_swevent_put_recursion_context(rctx);
 }
 #endif
diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index fe50347..7cd7b35 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -727,6 +727,7 @@ struct perf_event {
 	perf_overflow_handler_t		overflow_handler;
 
 #ifdef CONFIG_EVENT_TRACING
+	struct ftrace_event_call	*tp_event;
 	struct event_filter		*filter;
 #endif
 
@@ -992,8 +993,9 @@ static inline bool perf_paranoid_kernel(void)
 }
 
 extern void perf_event_init(void);
-extern void perf_tp_event(int event_id, u64 addr, u64 count, void *record,
-			  int entry_size, struct pt_regs *regs, void *event);
+extern void perf_tp_event(u64 addr, u64 count, void *record,
+			  int entry_size, struct pt_regs *regs,
+			  struct hlist_head *head);
 extern void perf_bp_event(struct perf_event *event, void *data);
 
 #ifndef perf_misc_flags
diff --git a/include/trace/ftrace.h b/include/trace/ftrace.h
index f282885..4eb2148 100644
--- a/include/trace/ftrace.h
+++ b/include/trace/ftrace.h
@@ -768,6 +768,7 @@ perf_trace_templ_##call(struct ftrace_event_call *event_call,		\
 	struct ftrace_data_offsets_##call __maybe_unused __data_offsets;\
 	struct ftrace_raw_##call *entry;				\
 	u64 __addr = 0, __count = 1;					\
+	struct hlist_head *head;					\
 	int __entry_size;						\
 	int __data_size;						\
 	int rctx;							\
@@ -790,8 +791,9 @@ perf_trace_templ_##call(struct ftrace_event_call *event_call,		\
 									\
 	{ assign; }							\
 									\
+	head = per_cpu_ptr(event_call->perf_events, smp_processor_id());\
 	perf_trace_buf_submit(entry, __entry_size, rctx, __addr,	\
-			       __count, __regs, event_call->perf_data);	\
+		__count, __regs, head);					\
 }
 
 #undef DEFINE_EVENT
diff --git a/kernel/perf_event.c b/kernel/perf_event.c
index 45b7aec..3f2cc31 100644
--- a/kernel/perf_event.c
+++ b/kernel/perf_event.c
@@ -4005,9 +4005,6 @@ static void perf_swevent_add(struct perf_event *event, u64 nr,
 	perf_swevent_overflow(event, 0, nmi, data, regs);
 }
 
-static int perf_tp_event_match(struct perf_event *event,
-				struct perf_sample_data *data);
-
 static int perf_exclude_event(struct perf_event *event,
 			      struct pt_regs *regs)
 {
@@ -4037,10 +4034,6 @@ static int perf_swevent_match(struct perf_event *event,
 	if (perf_exclude_event(event, regs))
 		return 0;
 
-	if (event->attr.type == PERF_TYPE_TRACEPOINT &&
-	    !perf_tp_event_match(event, data))
-		return 0;
-
 	return 1;
 }
 
@@ -4122,7 +4115,7 @@ end:
 
 int perf_swevent_get_recursion_context(void)
 {
-	struct perf_cpu_context *cpuctx = &get_cpu_var(perf_cpu_context);
+	struct perf_cpu_context *cpuctx = &__get_cpu_var(perf_cpu_context);
 	int rctx;
 
 	if (in_nmi())
@@ -4134,10 +4127,8 @@ int perf_swevent_get_recursion_context(void)
 	else
 		rctx = 0;
 
-	if (cpuctx->recursion[rctx]) {
-		put_cpu_var(perf_cpu_context);
+	if (cpuctx->recursion[rctx])
 		return -1;
-	}
 
 	cpuctx->recursion[rctx]++;
 	barrier();
@@ -4151,7 +4142,6 @@ void perf_swevent_put_recursion_context(int rctx)
 	struct perf_cpu_context *cpuctx = &__get_cpu_var(perf_cpu_context);
 	barrier();
 	cpuctx->recursion[rctx]--;
-	put_cpu_var(perf_cpu_context);
 }
 EXPORT_SYMBOL_GPL(perf_swevent_put_recursion_context);
 
@@ -4162,6 +4152,7 @@ void __perf_sw_event(u32 event_id, u64 nr, int nmi,
 	struct perf_sample_data data;
 	int rctx;
 
+	preempt_disable_notrace();
 	rctx = perf_swevent_get_recursion_context();
 	if (rctx < 0)
 		return;
@@ -4171,6 +4162,7 @@ void __perf_sw_event(u32 event_id, u64 nr, int nmi,
 	do_perf_sw_event(PERF_TYPE_SOFTWARE, event_id, nr, nmi, &data, regs);
 
 	perf_swevent_put_recursion_context(rctx);
+	preempt_enable_notrace();
 }
 
 static void perf_swevent_read(struct perf_event *event)
@@ -4486,11 +4478,43 @@ static int swevent_hlist_get(struct perf_event *event)
 
 #ifdef CONFIG_EVENT_TRACING
 
-void perf_tp_event(int event_id, u64 addr, u64 count, void *record,
-		   int entry_size, struct pt_regs *regs, void *event)
+static const struct pmu perf_ops_tracepoint = {
+	.enable		= perf_trace_enable,
+	.disable	= perf_trace_disable,
+	.read		= perf_swevent_read,
+	.unthrottle	= perf_swevent_unthrottle,
+};
+
+static int perf_tp_filter_match(struct perf_event *event,
+				struct perf_sample_data *data)
+{
+	void *record = data->raw->data;
+
+	if (likely(!event->filter) || filter_match_preds(event->filter, record))
+		return 1;
+	return 0;
+}
+
+static int perf_tp_event_match(struct perf_event *event,
+				struct perf_sample_data *data,
+				struct pt_regs *regs)
+{
+	if (perf_exclude_event(event, regs))
+		return 0;
+
+	if (!perf_tp_filter_match(event, data))
+		return 0;
+
+	return 1;
+}
+
+void perf_tp_event(u64 addr, u64 count, void *record, int entry_size,
+		   struct pt_regs *regs, struct hlist_head *head)
 {
-	const int type = PERF_TYPE_TRACEPOINT;
 	struct perf_sample_data data;
+	struct perf_event *event;
+	struct hlist_node *node;
+
 	struct perf_raw_record raw = {
 		.size = entry_size,
 		.data = record,
@@ -4499,30 +4523,18 @@ void perf_tp_event(int event_id, u64 addr, u64 count, void *record,
 	perf_sample_data_init(&data, addr);
 	data.raw = &raw;
 
-	if (!event) {
-		do_perf_sw_event(type, event_id, count, 1, &data, regs);
-		return;
+	rcu_read_lock();
+	hlist_for_each_entry_rcu(event, node, head, hlist_entry) {
+		if (perf_tp_event_match(event, &data, regs))
+			perf_swevent_add(event, count, 1, &data, regs);
 	}
-
-	if (perf_swevent_match(event, type, event_id, &data, regs))
-		perf_swevent_add(event, count, 1, &data, regs);
+	rcu_read_unlock();
 }
 EXPORT_SYMBOL_GPL(perf_tp_event);
 
-static int perf_tp_event_match(struct perf_event *event,
-				struct perf_sample_data *data)
-{
-	void *record = data->raw->data;
-
-	if (likely(!event->filter) || filter_match_preds(event->filter, record))
-		return 1;
-	return 0;
-}
-
 static void tp_perf_event_destroy(struct perf_event *event)
 {
-	perf_trace_disable(event->attr.config);
-	swevent_hlist_put(event);
+	perf_trace_destroy(event);
 }
 
 static const struct pmu *tp_perf_event_init(struct perf_event *event)
@@ -4538,17 +4550,13 @@ static const struct pmu *tp_perf_event_init(struct perf_event *event)
 			!capable(CAP_SYS_ADMIN))
 		return ERR_PTR(-EPERM);
 
-	if (perf_trace_enable(event->attr.config, event))
+	err = perf_trace_init(event);
+	if (err)
 		return NULL;
 
 	event->destroy = tp_perf_event_destroy;
-	err = swevent_hlist_get(event);
-	if (err) {
-		perf_trace_disable(event->attr.config);
-		return ERR_PTR(err);
-	}
 
-	return &perf_ops_generic;
+	return &perf_ops_tracepoint;
 }
 
 static int perf_event_set_filter(struct perf_event *event, void __user *arg)
@@ -4576,12 +4584,6 @@ static void perf_event_free_filter(struct perf_event *event)
 
 #else
 
-static int perf_tp_event_match(struct perf_event *event,
-				struct perf_sample_data *data)
-{
-	return 1;
-}
-
 static const struct pmu *tp_perf_event_init(struct perf_event *event)
 {
 	return NULL;
diff --git a/kernel/trace/trace_event_perf.c b/kernel/trace/trace_event_perf.c
index a1304f8..39d5ea7 100644
--- a/kernel/trace/trace_event_perf.c
+++ b/kernel/trace/trace_event_perf.c
@@ -23,14 +23,25 @@ typedef typeof(unsigned long [PERF_MAX_TRACE_SIZE / sizeof(unsigned long)])
 /* Count the events in use (per event id, not per instance) */
 static int	total_ref_count;
 
-static int perf_trace_event_enable(struct ftrace_event_call *event, void *data)
+static int perf_trace_event_init(struct ftrace_event_call *tp_event,
+				 struct perf_event *p_event)
 {
+	struct hlist_head *list;
 	int ret = -ENOMEM;
+	int cpu;
 
-	if (event->perf_refcount++ > 0) {
-		event->perf_data = NULL;
+	p_event->tp_event = tp_event;
+	if (tp_event->perf_refcount++ > 0)
 		return 0;
-	}
+
+	list = alloc_percpu(struct hlist_head);
+	if (!list)
+		goto fail;
+
+	for_each_possible_cpu(cpu)
+		INIT_HLIST_HEAD(per_cpu_ptr(list, cpu));
+
+	tp_event->perf_events = list;
 
 	if (!total_ref_count) {
 		char *buf;
@@ -39,20 +50,20 @@ static int perf_trace_event_enable(struct ftrace_event_call *event, void *data)
 		for (i = 0; i < 4; i++) {
 			buf = (char *)alloc_percpu(perf_trace_t);
 			if (!buf)
-				goto fail_buf;
+				goto fail;
 
-			rcu_assign_pointer(perf_trace_buf[i], buf);
+			perf_trace_buf[i] = buf;
 		}
 	}
 
-	ret = event->perf_event_enable(event);
-	if (!ret) {
-		event->perf_data = data;
-		total_ref_count++;
-		return 0;
-	}
+	ret = tp_event->perf_event_enable(tp_event);
+	if (ret)
+		goto fail;
 
-fail_buf:
+	total_ref_count++;
+	return 0;
+
+fail:
 	if (!total_ref_count) {
 		int i;
 
@@ -61,21 +72,26 @@ fail_buf:
 			perf_trace_buf[i] = NULL;
 		}
 	}
-	event->perf_refcount--;
+
+	if (!--tp_event->perf_refcount) {
+		free_percpu(tp_event->perf_events);
+		tp_event->perf_events = NULL;
+	}
 
 	return ret;
 }
 
-int perf_trace_enable(int event_id, void *data)
+int perf_trace_init(struct perf_event *p_event)
 {
-	struct ftrace_event_call *event;
+	struct ftrace_event_call *tp_event;
+	int event_id = p_event->attr.config;
 	int ret = -EINVAL;
 
 	mutex_lock(&event_mutex);
-	list_for_each_entry(event, &ftrace_events, list) {
-		if (event->id == event_id && event->perf_event_enable &&
-		    try_module_get(event->mod)) {
-			ret = perf_trace_event_enable(event, data);
+	list_for_each_entry(tp_event, &ftrace_events, list) {
+		if (tp_event->id == event_id && tp_event->perf_event_enable &&
+		    try_module_get(tp_event->mod)) {
+			ret = perf_trace_event_init(tp_event, p_event);
 			break;
 		}
 	}
@@ -84,53 +100,52 @@ int perf_trace_enable(int event_id, void *data)
 	return ret;
 }
 
-static void perf_trace_event_disable(struct ftrace_event_call *event)
+int perf_trace_enable(struct perf_event *p_event)
 {
-	if (--event->perf_refcount > 0)
-		return;
+	struct ftrace_event_call *tp_event = p_event->tp_event;
+	struct hlist_head *list;
 
-	event->perf_event_disable(event);
+	list = tp_event->perf_events;
+	if (WARN_ON_ONCE(!list))
+		return -EINVAL;
 
-	if (!--total_ref_count) {
-		char *buf[4];
-		int i;
-
-		for (i = 0; i < 4; i++) {
-			buf[i] = perf_trace_buf[i];
-			rcu_assign_pointer(perf_trace_buf[i], NULL);
-		}
+	list = per_cpu_ptr(list, smp_processor_id());
+	hlist_add_head_rcu(&p_event->hlist_entry, list);
 
-		/*
-		 * Ensure every events in profiling have finished before
-		 * releasing the buffers
-		 */
-		synchronize_sched();
+	return 0;
+}
 
-		for (i = 0; i < 4; i++)
-			free_percpu(buf[i]);
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
-		if (event->id == event_id) {
-			perf_trace_event_disable(event);
-			module_put(event->mod);
-			break;
+	if (--tp_event->perf_refcount > 0)
+		return;
+
+	tp_event->perf_event_disable(tp_event);
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
 				       struct pt_regs *regs, int *rctxp)
 {
 	struct trace_entry *entry;
-	char *trace_buf, *raw_data;
+	char *raw_data;
 	int pc;
 
 	BUILD_BUG_ON(PERF_MAX_TRACE_SIZE % sizeof(unsigned long));
@@ -139,13 +154,9 @@ __kprobes void *perf_trace_buf_prepare(int size, unsigned short type,
 
 	*rctxp = perf_swevent_get_recursion_context();
 	if (*rctxp < 0)
-		goto err_recursion;
-
-	trace_buf = rcu_dereference_sched(perf_trace_buf[*rctxp]);
-	if (!trace_buf)
-		goto err;
+		return NULL;
 
-	raw_data = per_cpu_ptr(trace_buf, smp_processor_id());
+	raw_data = per_cpu_ptr(perf_trace_buf[*rctxp], smp_processor_id());
 
 	/* zero the dead bytes from align to not leak stack to user */
 	memset(&raw_data[size - sizeof(u64)], 0, sizeof(u64));
@@ -155,9 +166,5 @@ __kprobes void *perf_trace_buf_prepare(int size, unsigned short type,
 	entry->type = type;
 
 	return raw_data;
-err:
-	perf_swevent_put_recursion_context(*rctxp);
-err_recursion:
-	return NULL;
 }
 EXPORT_SYMBOL_GPL(perf_trace_buf_prepare);
diff --git a/kernel/trace/trace_kprobe.c b/kernel/trace/trace_kprobe.c
index 20c96de..4681f60 100644
--- a/kernel/trace/trace_kprobe.c
+++ b/kernel/trace/trace_kprobe.c
@@ -1341,6 +1341,7 @@ static __kprobes void kprobe_perf_func(struct kprobe *kp,
 	struct trace_probe *tp = container_of(kp, struct trace_probe, rp.kp);
 	struct ftrace_event_call *call = &tp->call;
 	struct kprobe_trace_entry_head *entry;
+	struct hlist_head *head;
 	u8 *data;
 	int size, __size, i;
 	int rctx;
@@ -1361,7 +1362,8 @@ static __kprobes void kprobe_perf_func(struct kprobe *kp,
 	for (i = 0; i < tp->nr_args; i++)
 		call_fetch(&tp->args[i].fetch, regs, data + tp->args[i].offset);
 
-	perf_trace_buf_submit(entry, size, rctx, entry->ip, 1, regs, call->perf_data);
+	head = per_cpu_ptr(call->perf_events, smp_processor_id());
+	perf_trace_buf_submit(entry, size, rctx, entry->ip, 1, regs, head);
 }
 
 /* Kretprobe profile handler */
@@ -1371,6 +1373,7 @@ static __kprobes void kretprobe_perf_func(struct kretprobe_instance *ri,
 	struct trace_probe *tp = container_of(ri->rp, struct trace_probe, rp);
 	struct ftrace_event_call *call = &tp->call;
 	struct kretprobe_trace_entry_head *entry;
+	struct hlist_head *head;
 	u8 *data;
 	int size, __size, i;
 	int rctx;
@@ -1392,8 +1395,8 @@ static __kprobes void kretprobe_perf_func(struct kretprobe_instance *ri,
 	for (i = 0; i < tp->nr_args; i++)
 		call_fetch(&tp->args[i].fetch, regs, data + tp->args[i].offset);
 
-	perf_trace_buf_submit(entry, size, rctx, entry->ret_ip, 1,
-			      regs, call->perf_data);
+	head = per_cpu_ptr(call->perf_events, smp_processor_id());
+	perf_trace_buf_submit(entry, size, rctx, entry->ret_ip, 1, regs, head);
 }
 
 static int probe_perf_enable(struct ftrace_event_call *call)
diff --git a/kernel/trace/trace_syscalls.c b/kernel/trace/trace_syscalls.c
index a657cef..eb769f2 100644
--- a/kernel/trace/trace_syscalls.c
+++ b/kernel/trace/trace_syscalls.c
@@ -438,6 +438,7 @@ static void perf_syscall_enter(struct pt_regs *regs, long id)
 {
 	struct syscall_metadata *sys_data;
 	struct syscall_trace_enter *rec;
+	struct hlist_head *head;
 	int syscall_nr;
 	int rctx;
 	int size;
@@ -467,8 +468,9 @@ static void perf_syscall_enter(struct pt_regs *regs, long id)
 	rec->nr = syscall_nr;
 	syscall_get_arguments(current, regs, 0, sys_data->nb_args,
 			       (unsigned long *)&rec->args);
-	perf_trace_buf_submit(rec, size, rctx, 0, 1, regs,
-			sys_data->enter_event->perf_data);
+
+	head = per_cpu_ptr(sys_data->enter_event->perf_events, smp_processor_id());
+	perf_trace_buf_submit(rec, size, rctx, 0, 1, regs, head);
 }
 
 int perf_sysenter_enable(struct ftrace_event_call *call)
@@ -510,6 +512,7 @@ static void perf_syscall_exit(struct pt_regs *regs, long ret)
 {
 	struct syscall_metadata *sys_data;
 	struct syscall_trace_exit *rec;
+	struct hlist_head *head;
 	int syscall_nr;
 	int rctx;
 	int size;
@@ -542,8 +545,8 @@ static void perf_syscall_exit(struct pt_regs *regs, long ret)
 	rec->nr = syscall_nr;
 	rec->ret = syscall_get_return_value(current, regs);
 
-	perf_trace_buf_submit(rec, size, rctx, 0, 1, regs,
-			sys_data->exit_event->perf_data);
+	head = per_cpu_ptr(sys_data->exit_event->perf_events, smp_processor_id());
+	perf_trace_buf_submit(rec, size, rctx, 0, 1, regs, head);
 }
 
 int perf_sysexit_enable(struct ftrace_event_call *call)
