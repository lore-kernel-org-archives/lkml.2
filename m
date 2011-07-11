Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757504Ab1GKNXK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jul 2011 09:23:10 -0400
Received: from mx1.redhat.com ([209.132.183.28]:22328 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757299Ab1GKNXH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jul 2011 09:23:07 -0400
From: Jiri Olsa <jolsa@redhat.com>
To: rostedt@goodmis.org, fweisbec@gmail.com, a.p.zijlstra@chello.nl
Cc: linux-kernel@vger.kernel.org
Subject: [RFC 1/4] perf, ftrace: Add perf support to use function tracepoint
Date: Mon, 11 Jul 2011 15:22:53 +0200
Message-Id: <1310390576-8289-2-git-send-email-jolsa@redhat.com>
In-Reply-To: <1310390576-8289-1-git-send-email-jolsa@redhat.com>
References: <1310390576-8289-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adding perf support to use function tracepoint.

The ftrace:function tracepoint could be now open within the perf and
returns number of processed kernel functions like:

 # ./perf stat -e ftrace:function  sleep 1

 Performance counter stats for 'sleep 1':

             7,488 ftrace:function                                             

       1.002918678 seconds time elapsed

Details:
- added "struct ftrace_ops" into "struct perf_event", so each event
  could define its own filter

- added TRACE_REG_PERF_OPEN/TRACE_REG_PERF_CLOSE in addition to
  TRACE_REG_PERF_REGISTER/TRACE_REG_PERF_UNREGISTER cases.

  The OPEN/CLOSE cases are called within the event init/destroy
  right after the REG/UNREG cases.

  The reason is that REG/UNREG are processed only for for first and last
  events of the same type. While for function trace we need each event
  to get initialized and register the ftrace_ops struct.

- added "void *data" to the class::reg function to pass the "struct perf_event"
  for the ftrace:function register function

---
 include/linux/ftrace_event.h    |    6 +-
 include/linux/perf_event.h      |    1 +
 kernel/trace/trace.h            |    5 +
 kernel/trace/trace_event_perf.c |  183 ++++++++++++++++++++++++++++++---------
 kernel/trace/trace_events.c     |   10 ++-
 kernel/trace/trace_export.c     |   21 +++++
 kernel/trace/trace_kprobe.c     |    6 +-
 kernel/trace/trace_syscalls.c   |   14 ++-
 8 files changed, 195 insertions(+), 51 deletions(-)

diff --git a/include/linux/ftrace_event.h b/include/linux/ftrace_event.h
index b1e69ee..061c267 100644
--- a/include/linux/ftrace_event.h
+++ b/include/linux/ftrace_event.h
@@ -145,6 +145,8 @@ enum trace_reg {
 	TRACE_REG_UNREGISTER,
 	TRACE_REG_PERF_REGISTER,
 	TRACE_REG_PERF_UNREGISTER,
+	TRACE_REG_PERF_OPEN,
+	TRACE_REG_PERF_CLOSE,
 };
 
 struct ftrace_event_call;
@@ -156,7 +158,7 @@ struct ftrace_event_class {
 	void			*perf_probe;
 #endif
 	int			(*reg)(struct ftrace_event_call *event,
-				       enum trace_reg type);
+				       enum trace_reg type, void *data);
 	int			(*define_fields)(struct ftrace_event_call *);
 	struct list_head	*(*get_fields)(struct ftrace_event_call *);
 	struct list_head	fields;
@@ -164,7 +166,7 @@ struct ftrace_event_class {
 };
 
 extern int ftrace_event_reg(struct ftrace_event_call *event,
-			    enum trace_reg type);
+			    enum trace_reg type, void *data);
 
 enum {
 	TRACE_EVENT_FL_ENABLED_BIT,
diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index 3f2711c..bb708d1 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -844,6 +844,7 @@ struct perf_event {
 #ifdef CONFIG_EVENT_TRACING
 	struct ftrace_event_call	*tp_event;
 	struct event_filter		*filter;
+	struct ftrace_ops               ftrace_ops;
 #endif
 
 #ifdef CONFIG_CGROUP_PERF
diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
index 30a94c2..9278d74 100644
--- a/kernel/trace/trace.h
+++ b/kernel/trace/trace.h
@@ -810,4 +810,9 @@ extern const char *__stop___trace_bprintk_fmt[];
 #define trace_recursion_clear(bit)	do { (current)->trace_recursion &= ~(bit); } while (0)
 #define trace_recursion_test(bit)	((current)->trace_recursion & (bit))
 
+#ifdef CONFIG_PERF_EVENTS
+int perf_ftrace_event_register(struct ftrace_event_call *call,
+			       enum trace_reg type, void *data);
+#endif
+
 #endif /* _LINUX_KERNEL_TRACE_H */
diff --git a/kernel/trace/trace_event_perf.c b/kernel/trace/trace_event_perf.c
index 19a359d..2b56b81 100644
--- a/kernel/trace/trace_event_perf.c
+++ b/kernel/trace/trace_event_perf.c
@@ -44,23 +44,17 @@ static int perf_trace_event_perm(struct ftrace_event_call *tp_event,
 	return 0;
 }
 
-static int perf_trace_event_init(struct ftrace_event_call *tp_event,
-				 struct perf_event *p_event)
+static int perf_trace_event_reg(struct ftrace_event_call *tp_event,
+				struct perf_event *p_event)
 {
 	struct hlist_head __percpu *list;
-	int ret;
+	int ret = -ENOMEM;
 	int cpu;
 
-	ret = perf_trace_event_perm(tp_event, p_event);
-	if (ret)
-		return ret;
-
 	p_event->tp_event = tp_event;
 	if (tp_event->perf_refcount++ > 0)
 		return 0;
 
-	ret = -ENOMEM;
-
 	list = alloc_percpu(struct hlist_head);
 	if (!list)
 		goto fail;
@@ -83,7 +77,7 @@ static int perf_trace_event_init(struct ftrace_event_call *tp_event,
 		}
 	}
 
-	ret = tp_event->class->reg(tp_event, TRACE_REG_PERF_REGISTER);
+	ret = tp_event->class->reg(tp_event, TRACE_REG_PERF_REGISTER, NULL);
 	if (ret)
 		goto fail;
 
@@ -108,6 +102,69 @@ fail:
 	return ret;
 }
 
+static void perf_trace_event_unreg(struct perf_event *p_event)
+{
+	struct ftrace_event_call *tp_event = p_event->tp_event;
+	int i;
+
+	if (--tp_event->perf_refcount > 0)
+		goto out;
+
+	tp_event->class->reg(tp_event, TRACE_REG_PERF_UNREGISTER, NULL);
+
+	/*
+	 * Ensure our callback won't be called anymore. The buffers
+	 * will be freed after that.
+	 */
+	tracepoint_synchronize_unregister();
+
+	free_percpu(tp_event->perf_events);
+	tp_event->perf_events = NULL;
+
+	if (!--total_ref_count) {
+		for (i = 0; i < PERF_NR_CONTEXTS; i++) {
+			free_percpu(perf_trace_buf[i]);
+			perf_trace_buf[i] = NULL;
+		}
+	}
+out:
+	module_put(tp_event->mod);
+}
+
+static int perf_trace_event_open(struct perf_event *p_event)
+{
+	struct ftrace_event_call *tp_event = p_event->tp_event;
+	return tp_event->class->reg(tp_event, TRACE_REG_PERF_OPEN, p_event);
+}
+
+static void perf_trace_event_close(struct perf_event *p_event)
+{
+	struct ftrace_event_call *tp_event = p_event->tp_event;
+	tp_event->class->reg(tp_event, TRACE_REG_PERF_CLOSE, p_event);
+}
+
+static int perf_trace_event_init(struct ftrace_event_call *tp_event,
+				 struct perf_event *p_event)
+{
+	int ret;
+
+	ret = perf_trace_event_perm(tp_event, p_event);
+	if (ret)
+		return ret;
+
+	ret = perf_trace_event_reg(tp_event, p_event);
+	if (ret)
+		return ret;
+
+	ret = perf_trace_event_open(p_event);
+	if (ret) {
+		perf_trace_event_unreg(p_event);
+		return ret;
+	}
+
+	return 0;
+}
+
 int perf_trace_init(struct perf_event *p_event)
 {
 	struct ftrace_event_call *tp_event;
@@ -130,6 +187,14 @@ int perf_trace_init(struct perf_event *p_event)
 	return ret;
 }
 
+void perf_trace_destroy(struct perf_event *p_event)
+{
+	mutex_lock(&event_mutex);
+	perf_trace_event_close(p_event);
+	perf_trace_event_unreg(p_event);
+	mutex_unlock(&event_mutex);
+}
+
 int perf_trace_add(struct perf_event *p_event, int flags)
 {
 	struct ftrace_event_call *tp_event = p_event->tp_event;
@@ -154,37 +219,6 @@ void perf_trace_del(struct perf_event *p_event, int flags)
 	hlist_del_rcu(&p_event->hlist_entry);
 }
 
-void perf_trace_destroy(struct perf_event *p_event)
-{
-	struct ftrace_event_call *tp_event = p_event->tp_event;
-	int i;
-
-	mutex_lock(&event_mutex);
-	if (--tp_event->perf_refcount > 0)
-		goto out;
-
-	tp_event->class->reg(tp_event, TRACE_REG_PERF_UNREGISTER);
-
-	/*
-	 * Ensure our callback won't be called anymore. The buffers
-	 * will be freed after that.
-	 */
-	tracepoint_synchronize_unregister();
-
-	free_percpu(tp_event->perf_events);
-	tp_event->perf_events = NULL;
-
-	if (!--total_ref_count) {
-		for (i = 0; i < PERF_NR_CONTEXTS; i++) {
-			free_percpu(perf_trace_buf[i]);
-			perf_trace_buf[i] = NULL;
-		}
-	}
-out:
-	module_put(tp_event->mod);
-	mutex_unlock(&event_mutex);
-}
-
 __kprobes void *perf_trace_buf_prepare(int size, unsigned short type,
 				       struct pt_regs *regs, int *rctxp)
 {
@@ -214,3 +248,70 @@ __kprobes void *perf_trace_buf_prepare(int size, unsigned short type,
 	return raw_data;
 }
 EXPORT_SYMBOL_GPL(perf_trace_buf_prepare);
+
+
+static void
+perf_ftrace_function_call(unsigned long ip, unsigned long parent_ip)
+{
+	struct ftrace_entry *entry;
+	struct hlist_head *head;
+	unsigned long flags;
+	int rctx;
+
+	local_irq_save(flags);
+
+	BUILD_BUG_ON(sizeof(*entry) > PERF_MAX_TRACE_SIZE);
+
+	entry = (struct ftrace_entry *) perf_trace_buf_prepare(sizeof(*entry),
+						TRACE_FN, NULL, &rctx);
+	if (!entry)
+		return;
+
+	entry->ip = ip;
+	entry->parent_ip = parent_ip;
+
+	head = this_cpu_ptr(event_function.perf_events);
+	perf_trace_buf_submit(entry, sizeof(*entry), rctx, 0,
+			      1, NULL, head);
+
+	local_irq_restore(flags);
+}
+
+static int perf_ftrace_function_register(struct ftrace_event_call *call,
+					 struct perf_event *event)
+{
+	struct ftrace_ops *ops = &event->ftrace_ops;
+	ops->func = perf_ftrace_function_call;
+	return register_ftrace_function(ops);
+}
+
+static int perf_ftrace_function_unregister(struct ftrace_event_call *call,
+					   struct perf_event *event)
+{
+	struct ftrace_ops *ops = &event->ftrace_ops;
+	return unregister_ftrace_function(ops);
+}
+
+int perf_ftrace_event_register(struct ftrace_event_call *call,
+			       enum trace_reg type, void *data)
+{
+	int etype = call->event.type;
+
+	if (etype != TRACE_FN)
+		return -EINVAL;
+
+	switch (type) {
+	case TRACE_REG_REGISTER:
+	case TRACE_REG_UNREGISTER:
+		break;
+	case TRACE_REG_PERF_REGISTER:
+	case TRACE_REG_PERF_UNREGISTER:
+		return 0;
+	case TRACE_REG_PERF_OPEN:
+		return perf_ftrace_function_register(call, data);
+	case TRACE_REG_PERF_CLOSE:
+		return perf_ftrace_function_unregister(call, data);
+	}
+
+	return -EINVAL;
+}
diff --git a/kernel/trace/trace_events.c b/kernel/trace/trace_events.c
index 581876f..ad4bf55 100644
--- a/kernel/trace/trace_events.c
+++ b/kernel/trace/trace_events.c
@@ -147,7 +147,8 @@ int trace_event_raw_init(struct ftrace_event_call *call)
 }
 EXPORT_SYMBOL_GPL(trace_event_raw_init);
 
-int ftrace_event_reg(struct ftrace_event_call *call, enum trace_reg type)
+int ftrace_event_reg(struct ftrace_event_call *call,
+		     enum trace_reg type, void *data)
 {
 	switch (type) {
 	case TRACE_REG_REGISTER:
@@ -170,6 +171,9 @@ int ftrace_event_reg(struct ftrace_event_call *call, enum trace_reg type)
 					    call->class->perf_probe,
 					    call);
 		return 0;
+	case TRACE_REG_PERF_OPEN:
+	case TRACE_REG_PERF_CLOSE:
+		return 0;
 #endif
 	}
 	return 0;
@@ -209,7 +213,7 @@ static int ftrace_event_enable_disable(struct ftrace_event_call *call,
 				tracing_stop_cmdline_record();
 				call->flags &= ~TRACE_EVENT_FL_RECORDED_CMD;
 			}
-			call->class->reg(call, TRACE_REG_UNREGISTER);
+			call->class->reg(call, TRACE_REG_UNREGISTER, NULL);
 		}
 		break;
 	case 1:
@@ -218,7 +222,7 @@ static int ftrace_event_enable_disable(struct ftrace_event_call *call,
 				tracing_start_cmdline_record();
 				call->flags |= TRACE_EVENT_FL_RECORDED_CMD;
 			}
-			ret = call->class->reg(call, TRACE_REG_REGISTER);
+			ret = call->class->reg(call, TRACE_REG_REGISTER, NULL);
 			if (ret) {
 				tracing_stop_cmdline_record();
 				pr_info("event trace: Could not enable event "
diff --git a/kernel/trace/trace_export.c b/kernel/trace/trace_export.c
index bbeec31..7b7193c 100644
--- a/kernel/trace/trace_export.c
+++ b/kernel/trace/trace_export.c
@@ -131,6 +131,26 @@ ftrace_define_fields_##name(struct ftrace_event_call *event_call)	\
 
 #include "trace_entries.h"
 
+static int ftrace_event_class_register(struct ftrace_event_call *call,
+				       enum trace_reg type, void *data)
+{
+	switch (type) {
+	case TRACE_REG_PERF_REGISTER:
+	case TRACE_REG_PERF_UNREGISTER:
+		return 0;
+	case TRACE_REG_PERF_OPEN:
+	case TRACE_REG_PERF_CLOSE:
+#ifdef CONFIG_PERF_EVENTS
+		return perf_ftrace_event_register(call, type, data);
+#endif
+	case TRACE_REG_REGISTER:
+	case TRACE_REG_UNREGISTER:
+		break;
+	}
+
+	return -EINVAL;
+}
+
 #undef __entry
 #define __entry REC
 
@@ -159,6 +179,7 @@ struct ftrace_event_class event_class_ftrace_##call = {			\
 	.system			= __stringify(TRACE_SYSTEM),		\
 	.define_fields		= ftrace_define_fields_##call,		\
 	.fields			= LIST_HEAD_INIT(event_class_ftrace_##call.fields),\
+	.reg			= ftrace_event_class_register,		\
 };									\
 									\
 struct ftrace_event_call __used event_##call = {			\
diff --git a/kernel/trace/trace_kprobe.c b/kernel/trace/trace_kprobe.c
index 7db7b68..bfcf609 100644
--- a/kernel/trace/trace_kprobe.c
+++ b/kernel/trace/trace_kprobe.c
@@ -1744,7 +1744,8 @@ static void probe_perf_disable(struct ftrace_event_call *call)
 #endif	/* CONFIG_PERF_EVENTS */
 
 static __kprobes
-int kprobe_register(struct ftrace_event_call *event, enum trace_reg type)
+int kprobe_register(struct ftrace_event_call *event,
+		    enum trace_reg type, void *data)
 {
 	switch (type) {
 	case TRACE_REG_REGISTER:
@@ -1759,6 +1760,9 @@ int kprobe_register(struct ftrace_event_call *event, enum trace_reg type)
 	case TRACE_REG_PERF_UNREGISTER:
 		probe_perf_disable(event);
 		return 0;
+	case TRACE_REG_PERF_OPEN:
+	case TRACE_REG_PERF_CLOSE:
+		return 0;
 #endif
 	}
 	return 0;
diff --git a/kernel/trace/trace_syscalls.c b/kernel/trace/trace_syscalls.c
index ee7b5a0..61ebe6a 100644
--- a/kernel/trace/trace_syscalls.c
+++ b/kernel/trace/trace_syscalls.c
@@ -16,9 +16,9 @@ static DECLARE_BITMAP(enabled_enter_syscalls, NR_syscalls);
 static DECLARE_BITMAP(enabled_exit_syscalls, NR_syscalls);
 
 static int syscall_enter_register(struct ftrace_event_call *event,
-				 enum trace_reg type);
+				 enum trace_reg type, void *data);
 static int syscall_exit_register(struct ftrace_event_call *event,
-				 enum trace_reg type);
+				 enum trace_reg type, void *data);
 
 static int syscall_enter_define_fields(struct ftrace_event_call *call);
 static int syscall_exit_define_fields(struct ftrace_event_call *call);
@@ -648,7 +648,7 @@ void perf_sysexit_disable(struct ftrace_event_call *call)
 #endif /* CONFIG_PERF_EVENTS */
 
 static int syscall_enter_register(struct ftrace_event_call *event,
-				 enum trace_reg type)
+				 enum trace_reg type, void *data)
 {
 	switch (type) {
 	case TRACE_REG_REGISTER:
@@ -663,13 +663,16 @@ static int syscall_enter_register(struct ftrace_event_call *event,
 	case TRACE_REG_PERF_UNREGISTER:
 		perf_sysenter_disable(event);
 		return 0;
+	case TRACE_REG_PERF_OPEN:
+	case TRACE_REG_PERF_CLOSE:
+		return 0;
 #endif
 	}
 	return 0;
 }
 
 static int syscall_exit_register(struct ftrace_event_call *event,
-				 enum trace_reg type)
+				 enum trace_reg type, void *data)
 {
 	switch (type) {
 	case TRACE_REG_REGISTER:
@@ -684,6 +687,9 @@ static int syscall_exit_register(struct ftrace_event_call *event,
 	case TRACE_REG_PERF_UNREGISTER:
 		perf_sysexit_disable(event);
 		return 0;
+	case TRACE_REG_PERF_OPEN:
+	case TRACE_REG_PERF_CLOSE:
+		return 0;
 #endif
 	}
 	return 0;
-- 
1.7.1

