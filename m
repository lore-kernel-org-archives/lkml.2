Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753285Ab2B0JhI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Feb 2012 04:37:08 -0500
Received: from terminus.zytor.com ([198.137.202.10]:44822 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750704Ab2B0JhF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Feb 2012 04:37:05 -0500
Date: Mon, 27 Feb 2012 01:36:32 -0800
From: tip-bot for Jiri Olsa <jolsa@redhat.com>
Message-ID: <tip-ced39002f5ea736b716ae233fb68b26d59783912@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        fweisbec@gmail.com, rostedt@goodmis.org, tglx@linutronix.de,
        jolsa@redhat.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        fweisbec@gmail.com, rostedt@goodmis.org, tglx@linutronix.de,
        jolsa@redhat.com
In-Reply-To: <1329317514-8131-6-git-send-email-jolsa@redhat.com>
References: <1329317514-8131-6-git-send-email-jolsa@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] ftrace, perf:
  Add support to use function tracepoint in perf
Git-Commit-ID: ced39002f5ea736b716ae233fb68b26d59783912
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Mon, 27 Feb 2012 01:36:58 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  ced39002f5ea736b716ae233fb68b26d59783912
Gitweb:     http://git.kernel.org/tip/ced39002f5ea736b716ae233fb68b26d59783912
Author:     Jiri Olsa <jolsa@redhat.com>
AuthorDate: Wed, 15 Feb 2012 15:51:52 +0100
Committer:  Steven Rostedt <rostedt@goodmis.org>
CommitDate: Tue, 21 Feb 2012 11:08:27 -0500

ftrace, perf: Add support to use function tracepoint in perf

Adding perf registration support for the ftrace function event,
so it is now possible to register it via perf interface.

The perf_event struct statically contains ftrace_ops as a handle
for function tracer. The function tracer is registered/unregistered
in open/close actions.

To be efficient, we enable/disable ftrace_ops each time the traced
process is scheduled in/out (via TRACE_REG_PERF_(ADD|DELL) handlers).
This way tracing is enabled only when the process is running.
Intentionally using this way instead of the event's hw state
PERF_HES_STOPPED, which would not disable the ftrace_ops.

It is now possible to use function trace within perf commands
like:

  perf record -e ftrace:function ls
  perf stat -e ftrace:function ls

Allowed only for root.

Link: http://lkml.kernel.org/r/1329317514-8131-6-git-send-email-jolsa@redhat.com

Acked-by: Frederic Weisbecker <fweisbec@gmail.com>
Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 include/linux/perf_event.h      |    3 +
 kernel/trace/trace.h            |   11 +++++
 kernel/trace/trace_entries.h    |    6 ++-
 kernel/trace/trace_event_perf.c |   86 +++++++++++++++++++++++++++++++++++++++
 kernel/trace/trace_export.c     |    5 ++
 5 files changed, 109 insertions(+), 2 deletions(-)

diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index 412b790..92a056f 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -859,6 +859,9 @@ struct perf_event {
 #ifdef CONFIG_EVENT_TRACING
 	struct ftrace_event_call	*tp_event;
 	struct event_filter		*filter;
+#ifdef CONFIG_FUNCTION_TRACER
+	struct ftrace_ops               ftrace_ops;
+#endif
 #endif
 
 #ifdef CONFIG_CGROUP_PERF
diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
index 638476a..76a1c50 100644
--- a/kernel/trace/trace.h
+++ b/kernel/trace/trace.h
@@ -595,6 +595,8 @@ static inline int ftrace_trace_task(struct task_struct *task)
 static inline int ftrace_is_dead(void) { return 0; }
 #endif
 
+int ftrace_event_is_function(struct ftrace_event_call *call);
+
 /*
  * struct trace_parser - servers for reading the user input separated by spaces
  * @cont: set if the input is not complete - no final space char was found
@@ -832,4 +834,13 @@ extern const char *__stop___trace_bprintk_fmt[];
 	FTRACE_ENTRY(call, struct_name, id, PARAMS(tstruct), PARAMS(print))
 #include "trace_entries.h"
 
+#ifdef CONFIG_PERF_EVENTS
+#ifdef CONFIG_FUNCTION_TRACER
+int perf_ftrace_event_register(struct ftrace_event_call *call,
+			       enum trace_reg type, void *data);
+#else
+#define perf_ftrace_event_register NULL
+#endif /* CONFIG_FUNCTION_TRACER */
+#endif /* CONFIG_PERF_EVENTS */
+
 #endif /* _LINUX_KERNEL_TRACE_H */
diff --git a/kernel/trace/trace_entries.h b/kernel/trace/trace_entries.h
index 9336590..47db7ed 100644
--- a/kernel/trace/trace_entries.h
+++ b/kernel/trace/trace_entries.h
@@ -55,7 +55,7 @@
 /*
  * Function trace entry - function address and parent function address:
  */
-FTRACE_ENTRY(function, ftrace_entry,
+FTRACE_ENTRY_REG(function, ftrace_entry,
 
 	TRACE_FN,
 
@@ -64,7 +64,9 @@ FTRACE_ENTRY(function, ftrace_entry,
 		__field(	unsigned long,	parent_ip	)
 	),
 
-	F_printk(" %lx <-- %lx", __entry->ip, __entry->parent_ip)
+	F_printk(" %lx <-- %lx", __entry->ip, __entry->parent_ip),
+
+	perf_ftrace_event_register
 );
 
 /* Function call entry */
diff --git a/kernel/trace/trace_event_perf.c b/kernel/trace/trace_event_perf.c
index d72af0b..fdeeb5c 100644
--- a/kernel/trace/trace_event_perf.c
+++ b/kernel/trace/trace_event_perf.c
@@ -24,6 +24,11 @@ static int	total_ref_count;
 static int perf_trace_event_perm(struct ftrace_event_call *tp_event,
 				 struct perf_event *p_event)
 {
+	/* The ftrace function trace is allowed only for root. */
+	if (ftrace_event_is_function(tp_event) &&
+	    perf_paranoid_kernel() && !capable(CAP_SYS_ADMIN))
+		return -EPERM;
+
 	/* No tracing, just counting, so no obvious leak */
 	if (!(p_event->attr.sample_type & PERF_SAMPLE_RAW))
 		return 0;
@@ -250,3 +255,84 @@ __kprobes void *perf_trace_buf_prepare(int size, unsigned short type,
 	return raw_data;
 }
 EXPORT_SYMBOL_GPL(perf_trace_buf_prepare);
+
+#ifdef CONFIG_FUNCTION_TRACER
+static void
+perf_ftrace_function_call(unsigned long ip, unsigned long parent_ip)
+{
+	struct ftrace_entry *entry;
+	struct hlist_head *head;
+	struct pt_regs regs;
+	int rctx;
+
+#define ENTRY_SIZE (ALIGN(sizeof(struct ftrace_entry) + sizeof(u32), \
+		    sizeof(u64)) - sizeof(u32))
+
+	BUILD_BUG_ON(ENTRY_SIZE > PERF_MAX_TRACE_SIZE);
+
+	perf_fetch_caller_regs(&regs);
+
+	entry = perf_trace_buf_prepare(ENTRY_SIZE, TRACE_FN, NULL, &rctx);
+	if (!entry)
+		return;
+
+	entry->ip = ip;
+	entry->parent_ip = parent_ip;
+
+	head = this_cpu_ptr(event_function.perf_events);
+	perf_trace_buf_submit(entry, ENTRY_SIZE, rctx, 0,
+			      1, &regs, head);
+
+#undef ENTRY_SIZE
+}
+
+static int perf_ftrace_function_register(struct perf_event *event)
+{
+	struct ftrace_ops *ops = &event->ftrace_ops;
+
+	ops->flags |= FTRACE_OPS_FL_CONTROL;
+	ops->func = perf_ftrace_function_call;
+	return register_ftrace_function(ops);
+}
+
+static int perf_ftrace_function_unregister(struct perf_event *event)
+{
+	struct ftrace_ops *ops = &event->ftrace_ops;
+	return unregister_ftrace_function(ops);
+}
+
+static void perf_ftrace_function_enable(struct perf_event *event)
+{
+	ftrace_function_local_enable(&event->ftrace_ops);
+}
+
+static void perf_ftrace_function_disable(struct perf_event *event)
+{
+	ftrace_function_local_disable(&event->ftrace_ops);
+}
+
+int perf_ftrace_event_register(struct ftrace_event_call *call,
+			       enum trace_reg type, void *data)
+{
+	switch (type) {
+	case TRACE_REG_REGISTER:
+	case TRACE_REG_UNREGISTER:
+		break;
+	case TRACE_REG_PERF_REGISTER:
+	case TRACE_REG_PERF_UNREGISTER:
+		return 0;
+	case TRACE_REG_PERF_OPEN:
+		return perf_ftrace_function_register(data);
+	case TRACE_REG_PERF_CLOSE:
+		return perf_ftrace_function_unregister(data);
+	case TRACE_REG_PERF_ADD:
+		perf_ftrace_function_enable(data);
+		return 0;
+	case TRACE_REG_PERF_DEL:
+		perf_ftrace_function_disable(data);
+		return 0;
+	}
+
+	return -EINVAL;
+}
+#endif /* CONFIG_FUNCTION_TRACER */
diff --git a/kernel/trace/trace_export.c b/kernel/trace/trace_export.c
index f74de86..a3dbee6 100644
--- a/kernel/trace/trace_export.c
+++ b/kernel/trace/trace_export.c
@@ -184,4 +184,9 @@ __attribute__((section("_ftrace_events"))) *__event_##call = &event_##call;
 	FTRACE_ENTRY_REG(call, struct_name, etype,			\
 			 PARAMS(tstruct), PARAMS(print), NULL)
 
+int ftrace_event_is_function(struct ftrace_event_call *call)
+{
+	return call == &event_function;
+}
+
 #include "trace_entries.h"
