Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752249Ab1GUKCI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jul 2011 06:02:08 -0400
Received: from hera.kernel.org ([140.211.167.34]:55880 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751408Ab1GUKCF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jul 2011 06:02:05 -0400
Date: Thu, 21 Jul 2011 10:01:36 GMT
From: tip-bot for Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Message-ID: <tip-1538f888f1e793de04e0f90372352ac1b05833cf@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, acme@redhat.com, hpa@zytor.com,
        mingo@redhat.com, peterz@infradead.org,
        masami.hiramatsu.pt@hitachi.com, fweisbec@gmail.com,
        rostedt@goodmis.org, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, acme@redhat.com,
        linux-kernel@vger.kernel.org, fweisbec@gmail.com,
        masami.hiramatsu.pt@hitachi.com, rostedt@goodmis.org,
        peterz@infradead.org, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20110627072644.6528.26910.stgit@fedora15>
References: <20110627072644.6528.26910.stgit@fedora15>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] tracing/kprobes: Merge trace probe enable/disable functions
Git-Commit-ID: 1538f888f1e793de04e0f90372352ac1b05833cf
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 21 Jul 2011 10:01:40 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  1538f888f1e793de04e0f90372352ac1b05833cf
Gitweb:     http://git.kernel.org/tip/1538f888f1e793de04e0f90372352ac1b05833cf
Author:     Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
AuthorDate: Mon, 27 Jun 2011 16:26:44 +0900
Committer:  Steven Rostedt <rostedt@goodmis.org>
CommitDate: Fri, 15 Jul 2011 15:10:58 -0400

tracing/kprobes: Merge trace probe enable/disable functions

Merge redundant enable/disable functions into enable_trace_probe()
and disable_trace_probe().

Signed-off-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: yrl.pp-manager.tt@hitachi.com
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@redhat.com>
Link: http://lkml.kernel.org/r/20110627072644.6528.26910.stgit@fedora15

[ converted kprobe selftest to use  enable_trace_probe ]

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/trace_kprobe.c |   92 +++++++++++++++++--------------------------
 1 files changed, 36 insertions(+), 56 deletions(-)

diff --git a/kernel/trace/trace_kprobe.c b/kernel/trace/trace_kprobe.c
index 14b88ed..3be50c5 100644
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
@@ -1514,30 +1542,6 @@ partial:
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
@@ -1716,49 +1720,25 @@ static __kprobes void kretprobe_perf_func(struct kretprobe_instance *ri,
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
@@ -1905,7 +1885,7 @@ static __init int kprobe_trace_self_tests_init(void)
 			pr_warning("error on getting new probe.\n");
 			warn++;
 		} else
-			probe_event_enable(&tp->call);
+			enable_trace_probe(tp, TP_FLAG_TRACE);
 	}
 
 	ret = command_trace_probe("r:testprobe2 kprobe_trace_selftest_target "
@@ -1920,7 +1900,7 @@ static __init int kprobe_trace_self_tests_init(void)
 			pr_warning("error on getting new probe.\n");
 			warn++;
 		} else
-			probe_event_enable(&tp->call);
+			enable_trace_probe(tp, TP_FLAG_TRACE);
 	}
 
 	if (warn)
