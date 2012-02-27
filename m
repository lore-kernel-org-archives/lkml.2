Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753319Ab2B0JfG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Feb 2012 04:35:06 -0500
Received: from terminus.zytor.com ([198.137.202.10]:44794 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753233Ab2B0JfC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Feb 2012 04:35:02 -0500
Date: Mon, 27 Feb 2012 01:34:09 -0800
From: tip-bot for Jiri Olsa <jolsa@redhat.com>
Message-ID: <tip-ceec0b6fc7cd43b38a40c2d40223f9cd0616f0cd@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        fweisbec@gmail.com, rostedt@goodmis.org, tglx@linutronix.de,
        jolsa@redhat.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        fweisbec@gmail.com, rostedt@goodmis.org, tglx@linutronix.de,
        jolsa@redhat.com
In-Reply-To: <1329317514-8131-3-git-send-email-jolsa@redhat.com>
References: <1329317514-8131-3-git-send-email-jolsa@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] ftrace, perf: Add open/
 close tracepoint perf registration actions
Git-Commit-ID: ceec0b6fc7cd43b38a40c2d40223f9cd0616f0cd
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Mon, 27 Feb 2012 01:34:47 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  ceec0b6fc7cd43b38a40c2d40223f9cd0616f0cd
Gitweb:     http://git.kernel.org/tip/ceec0b6fc7cd43b38a40c2d40223f9cd0616f0cd
Author:     Jiri Olsa <jolsa@redhat.com>
AuthorDate: Wed, 15 Feb 2012 15:51:49 +0100
Committer:  Steven Rostedt <rostedt@goodmis.org>
CommitDate: Tue, 21 Feb 2012 11:08:24 -0500

ftrace, perf: Add open/close tracepoint perf registration actions

Adding TRACE_REG_PERF_OPEN and TRACE_REG_PERF_CLOSE to differentiate
register/unregister from open/close actions.

The register/unregister actions are invoked for the first/last
tracepoint user when opening/closing the event.

The open/close actions are invoked for each tracepoint user when
opening/closing the event.

Link: http://lkml.kernel.org/r/1329317514-8131-3-git-send-email-jolsa@redhat.com

Acked-by: Frederic Weisbecker <fweisbec@gmail.com>
Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 include/linux/ftrace_event.h    |    6 +-
 kernel/trace/trace_event_perf.c |  116 +++++++++++++++++++++++++--------------
 kernel/trace/trace_events.c     |   10 ++-
 kernel/trace/trace_kprobe.c     |    6 ++-
 kernel/trace/trace_syscalls.c   |   14 +++-
 5 files changed, 101 insertions(+), 51 deletions(-)

diff --git a/include/linux/ftrace_event.h b/include/linux/ftrace_event.h
index c3da42d..195e360 100644
--- a/include/linux/ftrace_event.h
+++ b/include/linux/ftrace_event.h
@@ -146,6 +146,8 @@ enum trace_reg {
 	TRACE_REG_UNREGISTER,
 	TRACE_REG_PERF_REGISTER,
 	TRACE_REG_PERF_UNREGISTER,
+	TRACE_REG_PERF_OPEN,
+	TRACE_REG_PERF_CLOSE,
 };
 
 struct ftrace_event_call;
@@ -157,7 +159,7 @@ struct ftrace_event_class {
 	void			*perf_probe;
 #endif
 	int			(*reg)(struct ftrace_event_call *event,
-				       enum trace_reg type);
+				       enum trace_reg type, void *data);
 	int			(*define_fields)(struct ftrace_event_call *);
 	struct list_head	*(*get_fields)(struct ftrace_event_call *);
 	struct list_head	fields;
@@ -165,7 +167,7 @@ struct ftrace_event_class {
 };
 
 extern int ftrace_event_reg(struct ftrace_event_call *event,
-			    enum trace_reg type);
+			    enum trace_reg type, void *data);
 
 enum {
 	TRACE_EVENT_FL_ENABLED_BIT,
diff --git a/kernel/trace/trace_event_perf.c b/kernel/trace/trace_event_perf.c
index 19a359d..0cfcc37 100644
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
diff --git a/kernel/trace/trace_events.c b/kernel/trace/trace_events.c
index c212a7f..5138fea 100644
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
diff --git a/kernel/trace/trace_kprobe.c b/kernel/trace/trace_kprobe.c
index 00d527c..5667f89 100644
--- a/kernel/trace/trace_kprobe.c
+++ b/kernel/trace/trace_kprobe.c
@@ -1892,7 +1892,8 @@ static __kprobes void kretprobe_perf_func(struct kretprobe_instance *ri,
 #endif	/* CONFIG_PERF_EVENTS */
 
 static __kprobes
-int kprobe_register(struct ftrace_event_call *event, enum trace_reg type)
+int kprobe_register(struct ftrace_event_call *event,
+		    enum trace_reg type, void *data)
 {
 	struct trace_probe *tp = (struct trace_probe *)event->data;
 
@@ -1909,6 +1910,9 @@ int kprobe_register(struct ftrace_event_call *event, enum trace_reg type)
 	case TRACE_REG_PERF_UNREGISTER:
 		disable_trace_probe(tp, TP_FLAG_PROFILE);
 		return 0;
+	case TRACE_REG_PERF_OPEN:
+	case TRACE_REG_PERF_CLOSE:
+		return 0;
 #endif
 	}
 	return 0;
diff --git a/kernel/trace/trace_syscalls.c b/kernel/trace/trace_syscalls.c
index 4350015..e23515f 100644
--- a/kernel/trace/trace_syscalls.c
+++ b/kernel/trace/trace_syscalls.c
@@ -17,9 +17,9 @@ static DECLARE_BITMAP(enabled_enter_syscalls, NR_syscalls);
 static DECLARE_BITMAP(enabled_exit_syscalls, NR_syscalls);
 
 static int syscall_enter_register(struct ftrace_event_call *event,
-				 enum trace_reg type);
+				 enum trace_reg type, void *data);
 static int syscall_exit_register(struct ftrace_event_call *event,
-				 enum trace_reg type);
+				 enum trace_reg type, void *data);
 
 static int syscall_enter_define_fields(struct ftrace_event_call *call);
 static int syscall_exit_define_fields(struct ftrace_event_call *call);
@@ -649,7 +649,7 @@ void perf_sysexit_disable(struct ftrace_event_call *call)
 #endif /* CONFIG_PERF_EVENTS */
 
 static int syscall_enter_register(struct ftrace_event_call *event,
-				 enum trace_reg type)
+				 enum trace_reg type, void *data)
 {
 	switch (type) {
 	case TRACE_REG_REGISTER:
@@ -664,13 +664,16 @@ static int syscall_enter_register(struct ftrace_event_call *event,
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
@@ -685,6 +688,9 @@ static int syscall_exit_register(struct ftrace_event_call *event,
 	case TRACE_REG_PERF_UNREGISTER:
 		perf_sysexit_disable(event);
 		return 0;
+	case TRACE_REG_PERF_OPEN:
+	case TRACE_REG_PERF_CLOSE:
+		return 0;
 #endif
 	}
 	return 0;
