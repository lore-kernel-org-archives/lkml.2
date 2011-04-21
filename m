Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753215Ab1DUKlf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Apr 2011 06:41:35 -0400
Received: from mx1.redhat.com ([209.132.183.28]:30222 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750935Ab1DUKlL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Apr 2011 06:41:11 -0400
From: Jiri Olsa <jolsa@redhat.com>
To: rostedt@goodmis.org, fweisbec@gmail.com, mingo@redhat.com,
        a.p.zijlstra@chello.nl
Cc: linux-kernel@vger.kernel.org
Subject: [RFC,PATCH 2/3] trace,perf: add support for registering ftrace/function tracepoint event via perf
Date: Thu, 21 Apr 2011 12:40:57 +0200
Message-Id: <1303382458-11072-3-git-send-email-jolsa@redhat.com>
In-Reply-To: <1303382458-11072-1-git-send-email-jolsa@redhat.com>
References: <1303382458-11072-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Added support to enable ftrace/function tracepoint via perf interface.

wbr,
jirka
---
 kernel/trace/ftrace.c |   34 +++++++++++++++++++++++++++++++++-
 1 files changed, 33 insertions(+), 1 deletions(-)

diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index 00fe267..49fbc8c 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -3228,10 +3228,41 @@ ftrace_function_call_trace(unsigned long ip, unsigned long parent_ip)
 	local_irq_restore(flags);
 }
 
+static void
+ftrace_function_call_perf(unsigned long ip, unsigned long parent_ip)
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
 static struct ftrace_ops ftrace_trace_ops __read_mostly = {
 	.func = ftrace_function_call_trace,
 };
 
+static struct ftrace_ops ftrace_perf_ops __read_mostly = {
+	.func = ftrace_function_call_perf,
+};
+
 int ftrace_event_class_register(struct ftrace_event_call *call,
 				enum trace_reg type)
 {
@@ -3246,8 +3277,9 @@ int ftrace_event_class_register(struct ftrace_event_call *call,
 	case TRACE_REG_UNREGISTER:
 		return unregister_ftrace_function(&ftrace_trace_ops);
 	case TRACE_REG_PERF_REGISTER:
+		return register_ftrace_function(&ftrace_perf_ops);
 	case TRACE_REG_PERF_UNREGISTER:
-		break;
+		return unregister_ftrace_function(&ftrace_perf_ops);
 	}
 
 	return -EINVAL;
-- 
1.7.1

