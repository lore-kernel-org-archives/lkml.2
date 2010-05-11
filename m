Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758184Ab0EKDK1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 May 2010 23:10:27 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:47611 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757891Ab0EKDJO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 May 2010 23:09:14 -0400
X-Authority-Analysis: v=1.1 cv=RZg5C6NCKrCZril9sGGnsuGk01/OiP2z3O3lo0hXATg= c=1 sm=0 a=VhaA6VXTNn4A:10 a=GzHTLUccyWwA:10 a=gMqfjgEr1zLu/65IO0LwxA==:17 a=20KFwNOVAAAA:8 a=meVymXHHAAAA:8 a=dYdySpNYLOdWUwRrqqYA:9 a=lu4LbzK5qTgBdNRnAy4A:7 a=LPw5pXTQ4cfIDLlP-7YtA4pG4H8A:4 a=jEp0ucaQiEUA:10 a=jeBq3FmKZ4MA:10 a=gMqfjgEr1zLu/65IO0LwxA==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.89.75
Message-Id: <20100511030911.669207217@goodmis.org>
User-Agent: quilt/0.48-1
Date: Mon, 10 May 2010 23:00:29 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Mathieu Desnoyers <compudj@krystal.dyndns.org>,
       Lai Jiangshan <laijs@cn.fujitsu.com>, Li Zefan <lizf@cn.fujitsu.com>,
       Masami Hiramatsu <mhiramat@redhat.com>, Christoph Hellwig <hch@lst.de>
Subject: [PATCH 09/10 -v3][RFC] tracing: Remove duplicate id information in event structure
References: <20100511030020.837892321@goodmis.org>
Content-Disposition: inline; filename=0009-tracing-Remove-duplicate-id-information-in-event-str.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

Now that the trace_event structure is embedded in the ftrace_event_call
structure, there is no need for the ftrace_event_call id field.
The id field is the same as the trace_event type field.

Removing the id and re-arranging the structure brings down the tracepoint
footprint by another 5K.

   text	   data	    bss	    dec	    hex	filename
5788186	1337252	9351592	16477030	 fb6b66	vmlinux.orig
5761154	1268356	9351592	16381102	 f9f4ae	vmlinux.print
5761074	1262596	9351592	16375262	 f9ddde	vmlinux.id

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 include/linux/ftrace_event.h       |    5 ++---
 include/trace/ftrace.h             |   12 ++++++------
 kernel/trace/trace_event_perf.c    |    4 ++--
 kernel/trace/trace_events.c        |    7 +++----
 kernel/trace/trace_events_filter.c |    2 +-
 kernel/trace/trace_export.c        |    4 ++--
 kernel/trace/trace_kprobe.c        |   18 ++++++++++--------
 kernel/trace/trace_syscalls.c      |   14 ++++++++------
 8 files changed, 34 insertions(+), 32 deletions(-)

diff --git a/include/linux/ftrace_event.h b/include/linux/ftrace_event.h
index b1a007d..0be0285 100644
--- a/include/linux/ftrace_event.h
+++ b/include/linux/ftrace_event.h
@@ -149,14 +149,13 @@ struct ftrace_event_call {
 	char			*name;
 	struct dentry		*dir;
 	struct trace_event	event;
-	int			enabled;
-	int			id;
 	const char		*print_fmt;
-	int			filter_active;
 	struct event_filter	*filter;
 	void			*mod;
 	void			*data;
 
+	int			enabled;
+	int			filter_active;
 	int			perf_refcount;
 };
 
diff --git a/include/trace/ftrace.h b/include/trace/ftrace.h
index 839c9fe..d5a61a3 100644
--- a/include/trace/ftrace.h
+++ b/include/trace/ftrace.h
@@ -150,7 +150,7 @@
  *
  *	entry = iter->ent;
  *
- *	if (entry->type != event_<call>.id) {
+ *	if (entry->type != event_<call>->event.type) {
  *		WARN_ON_ONCE(1);
  *		return TRACE_TYPE_UNHANDLED;
  *	}
@@ -221,7 +221,7 @@ ftrace_raw_output_##call(struct trace_iterator *iter, int flags,	\
 									\
 	entry = iter->ent;						\
 									\
-	if (entry->type != event->id) {					\
+	if (entry->type != event->event.type) {				\
 		WARN_ON_ONCE(1);					\
 		return TRACE_TYPE_UNHANDLED;				\
 	}								\
@@ -257,7 +257,7 @@ ftrace_raw_output_##call(struct trace_iterator *iter, int flags,	\
 									\
 	entry = iter->ent;						\
 									\
-	if (entry->type != event_##call.id) {				\
+	if (entry->type != event_##call.event.type) {			\
 		WARN_ON_ONCE(1);					\
 		return TRACE_TYPE_UNHANDLED;				\
 	}								\
@@ -409,7 +409,7 @@ static inline notrace int ftrace_get_offsets_##call(			\
  *	__data_size = ftrace_get_offsets_<call>(&__data_offsets, args);
  *
  *	event = trace_current_buffer_lock_reserve(&buffer,
- *				  event_<call>.id,
+ *				  event_<call>->event.type,
  *				  sizeof(*entry) + __data_size,
  *				  irq_flags, pc);
  *	if (!event)
@@ -510,7 +510,7 @@ ftrace_raw_event_##call(void *__data, proto)				\
 	__data_size = ftrace_get_offsets_##call(&__data_offsets, args); \
 									\
 	event = trace_current_buffer_lock_reserve(&buffer,		\
-				 event_call->id,			\
+				 event_call->event.type,		\
 				 sizeof(*entry) + __data_size,		\
 				 irq_flags, pc);			\
 	if (!event)							\
@@ -711,7 +711,7 @@ perf_trace_##call(void *__data, proto)					\
 		      "profile buffer not large enough"))		\
 		return;							\
 	entry = (struct ftrace_raw_##call *)perf_trace_buf_prepare(	\
-		__entry_size, event_call->id, &rctx, &irq_flags);	\
+		__entry_size, event_call->event.type, &rctx, &irq_flags); \
 	if (!entry)							\
 		return;							\
 	tstruct								\
diff --git a/kernel/trace/trace_event_perf.c b/kernel/trace/trace_event_perf.c
index 196fe9d..0a47e8d 100644
--- a/kernel/trace/trace_event_perf.c
+++ b/kernel/trace/trace_event_perf.c
@@ -80,7 +80,7 @@ int perf_trace_enable(int event_id)
 
 	mutex_lock(&event_mutex);
 	list_for_each_entry(event, &ftrace_events, list) {
-		if (event->id == event_id &&
+		if (event->event.type == event_id &&
 		    event->class && event->class->perf_probe &&
 		    try_module_get(event->mod)) {
 			ret = perf_trace_event_enable(event);
@@ -128,7 +128,7 @@ void perf_trace_disable(int event_id)
 
 	mutex_lock(&event_mutex);
 	list_for_each_entry(event, &ftrace_events, list) {
-		if (event->id == event_id) {
+		if (event->event.type == event_id) {
 			perf_trace_event_disable(event);
 			module_put(event->mod);
 			break;
diff --git a/kernel/trace/trace_events.c b/kernel/trace/trace_events.c
index 82ee590..8a2b370 100644
--- a/kernel/trace/trace_events.c
+++ b/kernel/trace/trace_events.c
@@ -125,7 +125,6 @@ int trace_event_raw_init(struct ftrace_event_call *call)
 	id = register_ftrace_event(&call->event);
 	if (!id)
 		return -ENODEV;
-	call->id = id;
 
 	return 0;
 }
@@ -567,7 +566,7 @@ event_format_read(struct file *filp, char __user *ubuf, size_t cnt,
 	trace_seq_init(s);
 
 	trace_seq_printf(s, "name: %s\n", call->name);
-	trace_seq_printf(s, "ID: %d\n", call->id);
+	trace_seq_printf(s, "ID: %d\n", call->event.type);
 	trace_seq_printf(s, "format:\n");
 
 	head = trace_get_fields(call);
@@ -641,7 +640,7 @@ event_id_read(struct file *filp, char __user *ubuf, size_t cnt, loff_t *ppos)
 		return -ENOMEM;
 
 	trace_seq_init(s);
-	trace_seq_printf(s, "%d\n", call->id);
+	trace_seq_printf(s, "%d\n", call->event.type);
 
 	r = simple_read_from_buffer(ubuf, cnt, ppos,
 				    s->buffer, s->len);
@@ -968,7 +967,7 @@ event_create_dir(struct ftrace_event_call *call, struct dentry *d_events,
 		trace_create_file("enable", 0644, call->dir, call,
 				  enable);
 
-	if (call->id && (call->class->perf_probe || call->class->reg))
+	if (call->event.type && (call->class->perf_probe || call->class->reg))
 		trace_create_file("id", 0444, call->dir, call,
 		 		  id);
 
diff --git a/kernel/trace/trace_events_filter.c b/kernel/trace/trace_events_filter.c
index 961f99b..2702d6b 100644
--- a/kernel/trace/trace_events_filter.c
+++ b/kernel/trace/trace_events_filter.c
@@ -1395,7 +1395,7 @@ int ftrace_profile_set_filter(struct perf_event *event, int event_id,
 	mutex_lock(&event_mutex);
 
 	list_for_each_entry(call, &ftrace_events, list) {
-		if (call->id == event_id)
+		if (call->event.type == event_id)
 			break;
 	}
 
diff --git a/kernel/trace/trace_export.c b/kernel/trace/trace_export.c
index e878d06..8536e2a 100644
--- a/kernel/trace/trace_export.c
+++ b/kernel/trace/trace_export.c
@@ -153,7 +153,7 @@ static int ftrace_raw_init_event(struct ftrace_event_call *call)
 #define F_printk(fmt, args...) #fmt ", "  __stringify(args)
 
 #undef FTRACE_ENTRY
-#define FTRACE_ENTRY(call, struct_name, type, tstruct, print)		\
+#define FTRACE_ENTRY(call, struct_name, etype, tstruct, print)		\
 									\
 struct ftrace_event_class event_class_ftrace_##call = {			\
 	.system			= __stringify(TRACE_SYSTEM),		\
@@ -165,7 +165,7 @@ struct ftrace_event_call __used						\
 __attribute__((__aligned__(4)))						\
 __attribute__((section("_ftrace_events"))) event_##call = {		\
 	.name			= #call,				\
-	.id			= type,					\
+	.event.type		= etype,				\
 	.class			= &event_class_ftrace_##call,		\
 	.print_fmt		= print,				\
 };									\
diff --git a/kernel/trace/trace_kprobe.c b/kernel/trace/trace_kprobe.c
index d8061c3..934078b 100644
--- a/kernel/trace/trace_kprobe.c
+++ b/kernel/trace/trace_kprobe.c
@@ -960,8 +960,8 @@ static __kprobes void kprobe_trace_func(struct kprobe *kp, struct pt_regs *regs)
 
 	size = SIZEOF_KPROBE_TRACE_ENTRY(tp->nr_args);
 
-	event = trace_current_buffer_lock_reserve(&buffer, call->id, size,
-						  irq_flags, pc);
+	event = trace_current_buffer_lock_reserve(&buffer, call->event.type,
+						  size, irq_flags, pc);
 	if (!event)
 		return;
 
@@ -992,8 +992,8 @@ static __kprobes void kretprobe_trace_func(struct kretprobe_instance *ri,
 
 	size = SIZEOF_KRETPROBE_TRACE_ENTRY(tp->nr_args);
 
-	event = trace_current_buffer_lock_reserve(&buffer, call->id, size,
-						  irq_flags, pc);
+	event = trace_current_buffer_lock_reserve(&buffer, call->event.type,
+						  size, irq_flags, pc);
 	if (!event)
 		return;
 
@@ -1228,7 +1228,8 @@ static __kprobes void kprobe_perf_func(struct kprobe *kp,
 		     "profile buffer not large enough"))
 		return;
 
-	entry = perf_trace_buf_prepare(size, call->id, &rctx, &irq_flags);
+	entry = perf_trace_buf_prepare(size, call->event.type,
+				       &rctx, &irq_flags);
 	if (!entry)
 		return;
 
@@ -1258,7 +1259,8 @@ static __kprobes void kretprobe_perf_func(struct kretprobe_instance *ri,
 		     "profile buffer not large enough"))
 		return;
 
-	entry = perf_trace_buf_prepare(size, call->id, &rctx, &irq_flags);
+	entry = perf_trace_buf_prepare(size, call->event.type,
+				       &rctx, &irq_flags);
 	if (!entry)
 		return;
 
@@ -1375,8 +1377,8 @@ static int register_probe_event(struct trace_probe *tp)
 	}
 	if (set_print_fmt(tp) < 0)
 		return -ENOMEM;
-	call->id = register_ftrace_event(&call->event);
-	if (!call->id) {
+	ret = register_ftrace_event(&call->event);
+	if (!ret) {
 		kfree(call->print_fmt);
 		return -ENODEV;
 	}
diff --git a/kernel/trace/trace_syscalls.c b/kernel/trace/trace_syscalls.c
index 7c7cfe9..9d35830 100644
--- a/kernel/trace/trace_syscalls.c
+++ b/kernel/trace/trace_syscalls.c
@@ -117,7 +117,7 @@ print_syscall_enter(struct trace_iterator *iter, int flags,
 	if (!entry)
 		goto end;
 
-	if (entry->enter_event->id != ent->type) {
+	if (entry->enter_event->event.type != ent->type) {
 		WARN_ON_ONCE(1);
 		goto end;
 	}
@@ -173,7 +173,7 @@ print_syscall_exit(struct trace_iterator *iter, int flags,
 		return TRACE_TYPE_HANDLED;
 	}
 
-	if (entry->exit_event->id != ent->type) {
+	if (entry->exit_event->event.type != ent->type) {
 		WARN_ON_ONCE(1);
 		return TRACE_TYPE_UNHANDLED;
 	}
@@ -315,7 +315,7 @@ void ftrace_syscall_enter(void *ignore, struct pt_regs *regs, long id)
 	size = sizeof(*entry) + sizeof(unsigned long) * sys_data->nb_args;
 
 	event = trace_current_buffer_lock_reserve(&buffer,
-			sys_data->enter_event->id, size, 0, 0);
+			sys_data->enter_event->event.type, size, 0, 0);
 	if (!event)
 		return;
 
@@ -347,7 +347,7 @@ void ftrace_syscall_exit(void *ignore, struct pt_regs *regs, long ret)
 		return;
 
 	event = trace_current_buffer_lock_reserve(&buffer,
-			sys_data->exit_event->id, sizeof(*entry), 0, 0);
+			sys_data->exit_event->event.type, sizeof(*entry), 0, 0);
 	if (!event)
 		return;
 
@@ -511,7 +511,8 @@ static void perf_syscall_enter(void *ignore, struct pt_regs *regs, long id)
 		return;
 
 	rec = (struct syscall_trace_enter *)perf_trace_buf_prepare(size,
-				sys_data->enter_event->id, &rctx, &flags);
+				sys_data->enter_event->event.type,
+				&rctx, &flags);
 	if (!rec)
 		return;
 
@@ -586,7 +587,8 @@ static void perf_syscall_exit(void *ignore, struct pt_regs *regs, long ret)
 		return;
 
 	rec = (struct syscall_trace_exit *)perf_trace_buf_prepare(size,
-				sys_data->exit_event->id, &rctx, &flags);
+				sys_data->exit_event->event.type,
+				&rctx, &flags);
 	if (!rec)
 		return;
 
-- 
1.7.0


