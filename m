Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753681Ab0F2DLg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jun 2010 23:11:36 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:47269 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753299Ab0F2DKs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jun 2010 23:10:48 -0400
X-Authority-Analysis: v=1.1 cv=hVjE12FRt4v4sD2HVuppbi620CRC5en4UNTr7KPd1ng= c=1 sm=0 a=yPhEvipDFfcA:10 a=uEzv4HemXiYA:10 a=GzHTLUccyWwA:10 a=gMqfjgEr1zLu/65IO0LwxA==:17 a=20KFwNOVAAAA:8 a=JfrnYn6hAAAA:8 a=meVymXHHAAAA:8 a=2B0-CabF_5L0lusuArYA:9 a=Bb9ZAv1O_X5XbS6aNQIA:7 a=8kP3wqQM4Ulrt_OKNUCjE97wijMA:4 a=jEp0ucaQiEUA:10 a=3Rfx1nUSh_UA:10 a=jeBq3FmKZ4MA:10 a=gMqfjgEr1zLu/65IO0LwxA==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.89.75
Message-Id: <20100629031045.003988817@goodmis.org>
User-Agent: quilt/0.48-1
Date: Mon, 28 Jun 2010 23:08:45 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Peter Zijlstra <peterz@infradead.org>
Subject: [PATCH 9/9] tracing: Use class->reg() for all registering of events
References: <20100629030836.222433712@goodmis.org>
Content-Disposition: inline; filename=0009-tracing-Use-class-reg-for-all-registering-of-events.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

Because kprobes and syscalls need special processing to register
events, the class->reg() method was created to handle the differences.

But instead of creating a default ->reg for perf and ftrace events,
the code was scattered with:

	if (class->reg)
		class->reg();
	else
		default_reg();

This is messy and can also lead to bugs.

This patch cleans up this code and creates a default reg() entry for
the events allowing for the code to directly call the class->reg()
without the condition.

Reported-by: Peter Zijlstra <peterz@infradead.org>
Acked-by: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 include/linux/ftrace_event.h    |    3 ++
 include/trace/ftrace.h          |    2 +
 kernel/trace/trace_event_perf.c |   19 ++-----------
 kernel/trace/trace_events.c     |   55 +++++++++++++++++++++++++-------------
 4 files changed, 44 insertions(+), 35 deletions(-)

diff --git a/include/linux/ftrace_event.h b/include/linux/ftrace_event.h
index 0af31cd..01df7ca 100644
--- a/include/linux/ftrace_event.h
+++ b/include/linux/ftrace_event.h
@@ -146,6 +146,9 @@ struct ftrace_event_class {
 	int			(*raw_init)(struct ftrace_event_call *);
 };
 
+extern int ftrace_event_reg(struct ftrace_event_call *event,
+			    enum trace_reg type);
+
 enum {
 	TRACE_EVENT_FL_ENABLED_BIT,
 	TRACE_EVENT_FL_FILTERED_BIT,
diff --git a/include/trace/ftrace.h b/include/trace/ftrace.h
index fc013a8..55c1fd1 100644
--- a/include/trace/ftrace.h
+++ b/include/trace/ftrace.h
@@ -439,6 +439,7 @@ static inline notrace int ftrace_get_offsets_##call(			\
  *	.fields			= LIST_HEAD_INIT(event_class_##call.fields),
  *	.raw_init		= trace_event_raw_init,
  *	.probe			= ftrace_raw_event_##call,
+ *	.reg			= ftrace_event_reg,
  * };
  *
  * static struct ftrace_event_call __used
@@ -567,6 +568,7 @@ static struct ftrace_event_class __used event_class_##call = {		\
 	.fields			= LIST_HEAD_INIT(event_class_##call.fields),\
 	.raw_init		= trace_event_raw_init,			\
 	.probe			= ftrace_raw_event_##call,		\
+	.reg			= ftrace_event_reg,			\
 	_TRACE_PERF_INIT(call)						\
 };
 
diff --git a/kernel/trace/trace_event_perf.c b/kernel/trace/trace_event_perf.c
index 6053982..2375165 100644
--- a/kernel/trace/trace_event_perf.c
+++ b/kernel/trace/trace_event_perf.c
@@ -54,13 +54,7 @@ static int perf_trace_event_init(struct ftrace_event_call *tp_event,
 		}
 	}
 
-	if (tp_event->class->reg)
-		ret = tp_event->class->reg(tp_event, TRACE_REG_PERF_REGISTER);
-	else
-		ret = tracepoint_probe_register(tp_event->name,
-						tp_event->class->perf_probe,
-						tp_event);
-
+	ret = tp_event->class->reg(tp_event, TRACE_REG_PERF_REGISTER);
 	if (ret)
 		goto fail;
 
@@ -94,9 +88,7 @@ int perf_trace_init(struct perf_event *p_event)
 	mutex_lock(&event_mutex);
 	list_for_each_entry(tp_event, &ftrace_events, list) {
 		if (tp_event->event.type == event_id &&
-		    tp_event->class &&
-		    (tp_event->class->perf_probe ||
-		     tp_event->class->reg) &&
+		    tp_event->class && tp_event->class->reg &&
 		    try_module_get(tp_event->mod)) {
 			ret = perf_trace_event_init(tp_event, p_event);
 			break;
@@ -136,12 +128,7 @@ void perf_trace_destroy(struct perf_event *p_event)
 	if (--tp_event->perf_refcount > 0)
 		goto out;
 
-	if (tp_event->class->reg)
-		tp_event->class->reg(tp_event, TRACE_REG_PERF_UNREGISTER);
-	else
-		tracepoint_probe_unregister(tp_event->name,
-					    tp_event->class->perf_probe,
-					    tp_event);
+	tp_event->class->reg(tp_event, TRACE_REG_PERF_UNREGISTER);
 
 	/*
 	 * Ensure our callback won't be called anymore. See
diff --git a/kernel/trace/trace_events.c b/kernel/trace/trace_events.c
index 69bee4c..e8e6043 100644
--- a/kernel/trace/trace_events.c
+++ b/kernel/trace/trace_events.c
@@ -141,6 +141,35 @@ int trace_event_raw_init(struct ftrace_event_call *call)
 }
 EXPORT_SYMBOL_GPL(trace_event_raw_init);
 
+int ftrace_event_reg(struct ftrace_event_call *call, enum trace_reg type)
+{
+	switch (type) {
+	case TRACE_REG_REGISTER:
+		return tracepoint_probe_register(call->name,
+						 call->class->probe,
+						 call);
+	case TRACE_REG_UNREGISTER:
+		tracepoint_probe_unregister(call->name,
+					    call->class->probe,
+					    call);
+		return 0;
+
+#ifdef CONFIG_PERF_EVENTS
+	case TRACE_REG_PERF_REGISTER:
+		return tracepoint_probe_register(call->name,
+						 call->class->perf_probe,
+						 call);
+	case TRACE_REG_PERF_UNREGISTER:
+		tracepoint_probe_unregister(call->name,
+					    call->class->perf_probe,
+					    call);
+		return 0;
+#endif
+	}
+	return 0;
+}
+EXPORT_SYMBOL_GPL(ftrace_event_reg);
+
 static int ftrace_event_enable_disable(struct ftrace_event_call *call,
 					int enable)
 {
@@ -151,23 +180,13 @@ static int ftrace_event_enable_disable(struct ftrace_event_call *call,
 		if (call->flags & TRACE_EVENT_FL_ENABLED) {
 			call->flags &= ~TRACE_EVENT_FL_ENABLED;
 			tracing_stop_cmdline_record();
-			if (call->class->reg)
-				call->class->reg(call, TRACE_REG_UNREGISTER);
-			else
-				tracepoint_probe_unregister(call->name,
-							    call->class->probe,
-							    call);
+			call->class->reg(call, TRACE_REG_UNREGISTER);
 		}
 		break;
 	case 1:
 		if (!(call->flags & TRACE_EVENT_FL_ENABLED)) {
 			tracing_start_cmdline_record();
-			if (call->class->reg)
-				ret = call->class->reg(call, TRACE_REG_REGISTER);
-			else
-				ret = tracepoint_probe_register(call->name,
-								call->class->probe,
-								call);
+			ret = call->class->reg(call, TRACE_REG_REGISTER);
 			if (ret) {
 				tracing_stop_cmdline_record();
 				pr_info("event trace: Could not enable event "
@@ -205,8 +224,7 @@ static int __ftrace_set_clr_event(const char *match, const char *sub,
 	mutex_lock(&event_mutex);
 	list_for_each_entry(call, &ftrace_events, list) {
 
-		if (!call->name || !call->class ||
-		    (!call->class->probe && !call->class->reg))
+		if (!call->name || !call->class || !call->class->reg)
 			continue;
 
 		if (match &&
@@ -332,7 +350,7 @@ t_next(struct seq_file *m, void *v, loff_t *pos)
 		 * The ftrace subsystem is for showing formats only.
 		 * They can not be enabled or disabled via the event files.
 		 */
-		if (call->class && (call->class->probe || call->class->reg))
+		if (call->class && call->class->reg)
 			return call;
 	}
 
@@ -485,8 +503,7 @@ system_enable_read(struct file *filp, char __user *ubuf, size_t cnt,
 
 	mutex_lock(&event_mutex);
 	list_for_each_entry(call, &ftrace_events, list) {
-		if (!call->name || !call->class ||
-		    (!call->class->probe && !call->class->reg))
+		if (!call->name || !call->class || !call->class->reg)
 			continue;
 
 		if (system && strcmp(call->class->system, system) != 0)
@@ -977,12 +994,12 @@ event_create_dir(struct ftrace_event_call *call, struct dentry *d_events,
 		return -1;
 	}
 
-	if (call->class->probe || call->class->reg)
+	if (call->class->reg)
 		trace_create_file("enable", 0644, call->dir, call,
 				  enable);
 
 #ifdef CONFIG_PERF_EVENTS
-	if (call->event.type && (call->class->perf_probe || call->class->reg))
+	if (call->event.type && call->class->reg)
 		trace_create_file("id", 0444, call->dir, call,
 		 		  id);
 #endif
-- 
1.7.1


