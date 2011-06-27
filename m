Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757520Ab1F1MD2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jun 2011 08:03:28 -0400
Received: from mail9.hitachi.co.jp ([133.145.228.44]:56623 "EHLO
	mail9.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757386Ab1F1L5Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jun 2011 07:57:16 -0400
X-AuditID: b753bd60-a32c7ba000003bac-64-4e09c1988e77
X-AuditID: b753bd60-a32c7ba000003bac-64-4e09c1988e77
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Subject: [PATCH -tip 02/13] [CLEANUP]tracing/kprobes: merge trace probe
 enable/disable functions
To: Steven Rostedt <rostedt@goodmis.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Ingo Molnar <mingo@elte.hu>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
        yrl.pp-manager.tt@hitachi.com,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>
Date: Mon, 27 Jun 2011 16:26:44 +0900
Message-ID: <20110627072644.6528.26910.stgit@fedora15>
In-Reply-To: <20110627072626.6528.41792.stgit@fedora15>
References: <20110627072626.6528.41792.stgit@fedora15>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Merge redundant enable/disable functions into enable_trace_probe()
and disable_trace_probe().

Signed-off-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@redhat.com>
---

 kernel/trace/trace_kprobe.c |   88 +++++++++++++++++--------------------------
 1 files changed, 34 insertions(+), 54 deletions(-)

diff --git a/kernel/trace/trace_kprobe.c b/kernel/trace/trace_kprobe.c
index bad87e9..ce5e6aa 100644
--- a/kernel/trace/trace_kprobe.c
+++ b/kernel/trace/trace_kprobe.c
@@ -683,6 +683,34 @@ static struct trace_probe *find_trace_probe(const char *event,
 	return NULL;
 }
 
+/* Enable trace_probe - @flag must be TP_FLAG_TRACE or TP_FLAG_PROFILE */
+static int enable_trace_probe(struct trace_probe *tp, int flag)
+{
+	int ret = 0;
+
+	tp->flags |= flag;
+	if (tp->flags & (TP_FLAG_TRACE | TP_FLAG_PROFILE)) {
+		if (trace_probe_is_return(tp))
+			ret = enable_kretprobe(&tp->rp);
+		else
+			ret = enable_kprobe(&tp->rp.kp);
+	}
+
+	return ret;
+}
+
+/* Disable trace_probe - @flag must be TP_FLAG_TRACE or TP_FLAG_PROFILE */
+static void disable_trace_probe(struct trace_probe *tp, int flag)
+{
+	tp->flags &= ~flag;
+	if (!(tp->flags & (TP_FLAG_TRACE | TP_FLAG_PROFILE))) {
+		if (trace_probe_is_return(tp))
+			disable_kretprobe(&tp->rp);
+		else
+			disable_kprobe(&tp->rp.kp);
+	}
+}
+
 /* Unregister a trace_probe and probe_event: call with locking probe_lock */
 static void unregister_trace_probe(struct trace_probe *tp)
 {
@@ -1512,30 +1540,6 @@ partial:
 	return TRACE_TYPE_PARTIAL_LINE;
 }
 
-static int probe_event_enable(struct ftrace_event_call *call)
-{
-	struct trace_probe *tp = (struct trace_probe *)call->data;
-
-	tp->flags |= TP_FLAG_TRACE;
-	if (trace_probe_is_return(tp))
-		return enable_kretprobe(&tp->rp);
-	else
-		return enable_kprobe(&tp->rp.kp);
-}
-
-static void probe_event_disable(struct ftrace_event_call *call)
-{
-	struct trace_probe *tp = (struct trace_probe *)call->data;
-
-	tp->flags &= ~TP_FLAG_TRACE;
-	if (!(tp->flags & (TP_FLAG_TRACE | TP_FLAG_PROFILE))) {
-		if (trace_probe_is_return(tp))
-			disable_kretprobe(&tp->rp);
-		else
-			disable_kprobe(&tp->rp.kp);
-	}
-}
-
 #undef DEFINE_FIELD
 #define DEFINE_FIELD(type, item, name, is_signed)			\
 	do {								\
@@ -1714,49 +1718,25 @@ static __kprobes void kretprobe_perf_func(struct kretprobe_instance *ri,
 	head = this_cpu_ptr(call->perf_events);
 	perf_trace_buf_submit(entry, size, rctx, entry->ret_ip, 1, regs, head);
 }
-
-static int probe_perf_enable(struct ftrace_event_call *call)
-{
-	struct trace_probe *tp = (struct trace_probe *)call->data;
-
-	tp->flags |= TP_FLAG_PROFILE;
-
-	if (trace_probe_is_return(tp))
-		return enable_kretprobe(&tp->rp);
-	else
-		return enable_kprobe(&tp->rp.kp);
-}
-
-static void probe_perf_disable(struct ftrace_event_call *call)
-{
-	struct trace_probe *tp = (struct trace_probe *)call->data;
-
-	tp->flags &= ~TP_FLAG_PROFILE;
-
-	if (!(tp->flags & TP_FLAG_TRACE)) {
-		if (trace_probe_is_return(tp))
-			disable_kretprobe(&tp->rp);
-		else
-			disable_kprobe(&tp->rp.kp);
-	}
-}
 #endif	/* CONFIG_PERF_EVENTS */
 
 static __kprobes
 int kprobe_register(struct ftrace_event_call *event, enum trace_reg type)
 {
+	struct trace_probe *tp = (struct trace_probe *)event->data;
+
 	switch (type) {
 	case TRACE_REG_REGISTER:
-		return probe_event_enable(event);
+		return enable_trace_probe(tp, TP_FLAG_TRACE);
 	case TRACE_REG_UNREGISTER:
-		probe_event_disable(event);
+		disable_trace_probe(tp, TP_FLAG_TRACE);
 		return 0;
 
 #ifdef CONFIG_PERF_EVENTS
 	case TRACE_REG_PERF_REGISTER:
-		return probe_perf_enable(event);
+		return enable_trace_probe(tp, TP_FLAG_PROFILE);
 	case TRACE_REG_PERF_UNREGISTER:
-		probe_perf_disable(event);
+		disable_trace_probe(tp, TP_FLAG_PROFILE);
 		return 0;
 #endif
 	}

