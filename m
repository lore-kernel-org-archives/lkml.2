Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753344Ab1LSXXr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Dec 2011 18:23:47 -0500
Received: from intmgw002.ash2.facebook.com ([66.220.155.179]:44301 "EHLO
	intmgw001.ash2.facebook.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752690Ab1LSXXf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Dec 2011 18:23:35 -0500
From: Arun Sharma <asharma@fb.com>
To: linux-kernel@vger.kernel.org
Cc: Arun Sharma <asharma@fb.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Steven Rostedt <rostedt@goodmis.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Andrew Vagin <avagin@openvz.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>
Subject: [PATCH 1/2] tracing, sched: move the sched_switch tracepoint
Date: Mon, 19 Dec 2011 15:23:24 -0800
Message-Id: <1324337005-31718-2-git-send-email-asharma@fb.com>
X-Mailer: git-send-email 1.7.4
In-Reply-To: <1324337005-31718-1-git-send-email-asharma@fb.com>
References: <1324337005-31718-1-git-send-email-asharma@fb.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move the tracepoint from prepare_task_switch() to
finish_task_switch().

Without this, the event gets attributed to prev rather
than next. For sleep profiling purposes, we want to collect
the stacktrace of "next".

This also makes the event usable in per-process mode, without
root privileges.

I can't think of this breaking the semantics of the existing
uses of this tracepoint. If there are any concerns, we should
be able to define a new tracepoint usable for sleep profiling.

Signed-off-by: Arun Sharma <asharma@fb.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Arnaldo Carvalho de Melo <acme@infradead.org>
Cc: Andrew Vagin <avagin@openvz.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org
---
 kernel/sched.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index d6b149c..b06b3c6 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -3157,7 +3157,6 @@ prepare_task_switch(struct rq *rq, struct task_struct *prev,
 	fire_sched_out_preempt_notifiers(prev, next);
 	prepare_lock_switch(rq, next);
 	prepare_arch_switch(next);
-	trace_sched_switch(prev, next);
 }
 
 /**
@@ -3205,6 +3204,7 @@ static void finish_task_switch(struct rq *rq, struct task_struct *prev)
 #endif /* __ARCH_WANT_INTERRUPTS_ON_CTXSW */
 	finish_lock_switch(rq, prev);
 
+	trace_sched_switch(prev, current, rq->clock);
 	fire_sched_in_preempt_notifiers(current);
 	if (mm)
 		mmdrop(mm);
-- 
1.7.4

