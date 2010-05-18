Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758311Ab0ERRQX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 May 2010 13:16:23 -0400
Received: from hera.kernel.org ([140.211.167.34]:60645 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754955Ab0ERRQU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 May 2010 13:16:20 -0400
Date: Tue, 18 May 2010 17:15:42 GMT
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-kernel@vger.kernel.org, acme@redhat.com, paulus@samba.org,
       hpa@zytor.com, mingo@redhat.com, a.p.zijlstra@chello.nl, efault@gmx.de,
       fweisbec@gmail.com, rostedt@goodmis.org, tglx@linutronix.de,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org, acme@redhat.com,
       linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl, efault@gmx.de,
       fweisbec@gmail.com, rostedt@goodmis.org, tglx@linutronix.de,
       mingo@elte.hu
In-Reply-To: <new-submission>
References: <new-submission>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf/ftrace: Optimize perf/tracepoint interaction for single events
Message-ID: <tip-4f41c013f553957765902fb01475972f0af3e8e7@git.kernel.org>
Git-Commit-ID: 4f41c013f553957765902fb01475972f0af3e8e7
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Tue, 18 May 2010 17:15:45 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  4f41c013f553957765902fb01475972f0af3e8e7
Gitweb:     http://git.kernel.org/tip/4f41c013f553957765902fb01475972f0af3e8e7
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Tue, 18 May 2010 18:08:32 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 18 May 2010 18:35:46 +0200

perf/ftrace: Optimize perf/tracepoint interaction for single events

When we've got but a single event per tracepoint
there is no reason to try and multiplex it so don't.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Tested-by: Ingo Molnar <mingo@elte.hu>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
LKML-Reference: <new-submission>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 include/linux/ftrace_event.h    |    8 +++++---
 include/linux/perf_event.h      |    2 +-
 include/trace/ftrace.h          |    3 ++-
 kernel/perf_event.c             |   15 ++++++++++-----
 kernel/trace/trace_event_perf.c |   11 +++++++----
 kernel/trace/trace_kprobe.c     |    4 ++--
 kernel/trace/trace_syscalls.c   |    6 ++++--
 7 files changed, 31 insertions(+), 18 deletions(-)

diff --git a/include/linux/ftrace_event.h b/include/linux/ftrace_event.h
index c0f4b36..c809100 100644
--- a/include/linux/ftrace_event.h
+++ b/include/linux/ftrace_event.h
@@ -132,6 +132,7 @@ struct ftrace_event_call {
 	void			*data;
 
 	int			perf_refcount;
+	void			*perf_data;
 	int			(*perf_event_enable)(struct ftrace_event_call *);
 	void			(*perf_event_disable)(struct ftrace_event_call *);
 };
@@ -190,7 +191,7 @@ struct perf_event;
 
 DECLARE_PER_CPU(struct pt_regs, perf_trace_regs);
 
-extern int perf_trace_enable(int event_id);
+extern int perf_trace_enable(int event_id, void *data);
 extern void perf_trace_disable(int event_id);
 extern int ftrace_profile_set_filter(struct perf_event *event, int event_id,
 				     char *filter_str);
@@ -201,11 +202,12 @@ perf_trace_buf_prepare(int size, unsigned short type, int *rctxp,
 
 static inline void
 perf_trace_buf_submit(void *raw_data, int size, int rctx, u64 addr,
-		       u64 count, unsigned long irq_flags, struct pt_regs *regs)
+		       u64 count, unsigned long irq_flags, struct pt_regs *regs,
+		       void *event)
 {
 	struct trace_entry *entry = raw_data;
 
-	perf_tp_event(entry->type, addr, count, raw_data, size, regs);
+	perf_tp_event(entry->type, addr, count, raw_data, size, regs, event);
 	perf_swevent_put_recursion_context(rctx);
 	local_irq_restore(irq_flags);
 }
diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index 3fd5c82..0b521fc 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -994,7 +994,7 @@ static inline bool perf_paranoid_kernel(void)
 
 extern void perf_event_init(void);
 extern void perf_tp_event(int event_id, u64 addr, u64 count, void *record,
-			  int entry_size, struct pt_regs *regs);
+			  int entry_size, struct pt_regs *regs, void *event);
 extern void perf_bp_event(struct perf_event *event, void *data);
 
 #ifndef perf_misc_flags
diff --git a/include/trace/ftrace.h b/include/trace/ftrace.h
index 882c648..0a29df0 100644
--- a/include/trace/ftrace.h
+++ b/include/trace/ftrace.h
@@ -785,7 +785,8 @@ perf_trace_templ_##call(struct ftrace_event_call *event_call,		\
 	{ assign; }							\
 									\
 	perf_trace_buf_submit(entry, __entry_size, rctx, __addr,	\
-			       __count, irq_flags, __regs);		\
+			       __count, irq_flags, __regs, 		\
+			      event_call->perf_data);			\
 }
 
 #undef DEFINE_EVENT
diff --git a/kernel/perf_event.c b/kernel/perf_event.c
index a4fa381..17ac47f 100644
--- a/kernel/perf_event.c
+++ b/kernel/perf_event.c
@@ -4468,8 +4468,9 @@ static int swevent_hlist_get(struct perf_event *event)
 #ifdef CONFIG_EVENT_TRACING
 
 void perf_tp_event(int event_id, u64 addr, u64 count, void *record,
-		   int entry_size, struct pt_regs *regs)
+		   int entry_size, struct pt_regs *regs, void *event)
 {
+	const int type = PERF_TYPE_TRACEPOINT;
 	struct perf_sample_data data;
 	struct perf_raw_record raw = {
 		.size = entry_size,
@@ -4479,9 +4480,13 @@ void perf_tp_event(int event_id, u64 addr, u64 count, void *record,
 	perf_sample_data_init(&data, addr);
 	data.raw = &raw;
 
-	/* Trace events already protected against recursion */
-	do_perf_sw_event(PERF_TYPE_TRACEPOINT, event_id, count, 1,
-			 &data, regs);
+	if (!event) {
+		do_perf_sw_event(type, event_id, count, 1, &data, regs);
+		return;
+	}
+
+	if (perf_swevent_match(event, type, event_id, &data, regs))
+		perf_swevent_add(event, count, 1, &data, regs);
 }
 EXPORT_SYMBOL_GPL(perf_tp_event);
 
@@ -4514,7 +4519,7 @@ static const struct pmu *tp_perf_event_init(struct perf_event *event)
 			!capable(CAP_SYS_ADMIN))
 		return ERR_PTR(-EPERM);
 
-	if (perf_trace_enable(event->attr.config))
+	if (perf_trace_enable(event->attr.config, event))
 		return NULL;
 
 	event->destroy = tp_perf_event_destroy;
diff --git a/kernel/trace/trace_event_perf.c b/kernel/trace/trace_event_perf.c
index 0565bb4..89b780a 100644
--- a/kernel/trace/trace_event_perf.c
+++ b/kernel/trace/trace_event_perf.c
@@ -27,13 +27,15 @@ typedef typeof(unsigned long [PERF_MAX_TRACE_SIZE / sizeof(unsigned long)])
 /* Count the events in use (per event id, not per instance) */
 static int	total_ref_count;
 
-static int perf_trace_event_enable(struct ftrace_event_call *event)
+static int perf_trace_event_enable(struct ftrace_event_call *event, void *data)
 {
 	char *buf;
 	int ret = -ENOMEM;
 
-	if (event->perf_refcount++ > 0)
+	if (event->perf_refcount++ > 0) {
+		event->perf_data = NULL;
 		return 0;
+	}
 
 	if (!total_ref_count) {
 		buf = (char *)alloc_percpu(perf_trace_t);
@@ -51,6 +53,7 @@ static int perf_trace_event_enable(struct ftrace_event_call *event)
 
 	ret = event->perf_event_enable(event);
 	if (!ret) {
+		event->perf_data = data;
 		total_ref_count++;
 		return 0;
 	}
@@ -68,7 +71,7 @@ fail_buf:
 	return ret;
 }
 
-int perf_trace_enable(int event_id)
+int perf_trace_enable(int event_id, void *data)
 {
 	struct ftrace_event_call *event;
 	int ret = -EINVAL;
@@ -77,7 +80,7 @@ int perf_trace_enable(int event_id)
 	list_for_each_entry(event, &ftrace_events, list) {
 		if (event->id == event_id && event->perf_event_enable &&
 		    try_module_get(event->mod)) {
-			ret = perf_trace_event_enable(event);
+			ret = perf_trace_event_enable(event, data);
 			break;
 		}
 	}
diff --git a/kernel/trace/trace_kprobe.c b/kernel/trace/trace_kprobe.c
index a751432..2d7bf41 100644
--- a/kernel/trace/trace_kprobe.c
+++ b/kernel/trace/trace_kprobe.c
@@ -1362,7 +1362,7 @@ static __kprobes void kprobe_perf_func(struct kprobe *kp,
 	for (i = 0; i < tp->nr_args; i++)
 		call_fetch(&tp->args[i].fetch, regs, data + tp->args[i].offset);
 
-	perf_trace_buf_submit(entry, size, rctx, entry->ip, 1, irq_flags, regs);
+	perf_trace_buf_submit(entry, size, rctx, entry->ip, 1, irq_flags, regs, call->perf_data);
 }
 
 /* Kretprobe profile handler */
@@ -1395,7 +1395,7 @@ static __kprobes void kretprobe_perf_func(struct kretprobe_instance *ri,
 		call_fetch(&tp->args[i].fetch, regs, data + tp->args[i].offset);
 
 	perf_trace_buf_submit(entry, size, rctx, entry->ret_ip, 1,
-			       irq_flags, regs);
+			       irq_flags, regs, call->perf_data);
 }
 
 static int probe_perf_enable(struct ftrace_event_call *call)
diff --git a/kernel/trace/trace_syscalls.c b/kernel/trace/trace_syscalls.c
index 4d6d711..9eff1a4 100644
--- a/kernel/trace/trace_syscalls.c
+++ b/kernel/trace/trace_syscalls.c
@@ -468,7 +468,8 @@ static void perf_syscall_enter(struct pt_regs *regs, long id)
 	rec->nr = syscall_nr;
 	syscall_get_arguments(current, regs, 0, sys_data->nb_args,
 			       (unsigned long *)&rec->args);
-	perf_trace_buf_submit(rec, size, rctx, 0, 1, flags, regs);
+	perf_trace_buf_submit(rec, size, rctx, 0, 1, flags, regs,
+			sys_data->enter_event->perf_data);
 }
 
 int perf_sysenter_enable(struct ftrace_event_call *call)
@@ -543,7 +544,8 @@ static void perf_syscall_exit(struct pt_regs *regs, long ret)
 	rec->nr = syscall_nr;
 	rec->ret = syscall_get_return_value(current, regs);
 
-	perf_trace_buf_submit(rec, size, rctx, 0, 1, flags, regs);
+	perf_trace_buf_submit(rec, size, rctx, 0, 1, flags, regs,
+			sys_data->exit_event->perf_data);
 }
 
 int perf_sysexit_enable(struct ftrace_event_call *call)
