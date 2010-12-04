Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754394Ab0LDCbq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Dec 2010 21:31:46 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:34631 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754169Ab0LDCbo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Dec 2010 21:31:44 -0500
X-Authority-Analysis: v=1.1 cv=kXGwZUU/u1JTMRv8Axk4W0omja+vfTT+sGlOkodD8F8= c=1 sm=0 a=e3zf_k9m_9kA:10 a=bbbx4UPp9XUA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=20KFwNOVAAAA:8 a=meVymXHHAAAA:8 a=7appX6giRh2mzXHeI_gA:9 a=fsaJmgr2YFfB25X6bj4A:7 a=CR5-GmFvIPO5MahWELKs-ZQyijsA:4 a=jEp0ucaQiEUA:10 a=jeBq3FmKZ4MA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Message-Id: <20101204023141.817418425@goodmis.org>
User-Agent: quilt/0.48-1
Date: Fri, 03 Dec 2010 21:17:48 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Theodore Tso <tytso@mit.edu>, Arjan van de Ven <arjan@infradead.org>,
        Mathieu Desnoyers <compudj@krystal.dyndns.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 4/4] tracing: Only trace sched_wakeup if it actually work something up
References: <20101204021744.521599148@goodmis.org>
Content-Disposition: inline; filename=0004-tracing-Only-trace-sched_wakeup-if-it-actually-work-.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

Currently the tracepoint sched_wakeup traces the wakeup event even
if the wakeup failed to wake anything up. This is quite stupid
but it happens because we did not want to add a conditional
to the core kernel code that would just slow down the wakeup events.

This patch changes the wakeup tracepoints to use the

 DEFINE_EVENT_CONDITIONAL()

to test the "success" parameter and will only trace the event if
the wakeup was successfull.

The success field in the tracepoint is removed since it is no
longer needed.

Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 include/trace/events/sched.h |   16 ++++++++--------
 1 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/include/trace/events/sched.h b/include/trace/events/sched.h
index f633478..29e6030 100644
--- a/include/trace/events/sched.h
+++ b/include/trace/events/sched.h
@@ -62,7 +62,6 @@ DECLARE_EVENT_CLASS(sched_wakeup_template,
 		__array(	char,	comm,	TASK_COMM_LEN	)
 		__field(	pid_t,	pid			)
 		__field(	int,	prio			)
-		__field(	int,	success			)
 		__field(	int,	target_cpu		)
 	),
 
@@ -70,25 +69,26 @@ DECLARE_EVENT_CLASS(sched_wakeup_template,
 		memcpy(__entry->comm, p->comm, TASK_COMM_LEN);
 		__entry->pid		= p->pid;
 		__entry->prio		= p->prio;
-		__entry->success	= success;
 		__entry->target_cpu	= task_cpu(p);
 	),
 
-	TP_printk("comm=%s pid=%d prio=%d success=%d target_cpu=%03d",
+	TP_printk("comm=%s pid=%d prio=%d target_cpu=%03d",
 		  __entry->comm, __entry->pid, __entry->prio,
-		  __entry->success, __entry->target_cpu)
+		  __entry->target_cpu)
 );
 
-DEFINE_EVENT(sched_wakeup_template, sched_wakeup,
+DEFINE_EVENT_CONDITION(sched_wakeup_template, sched_wakeup,
 	     TP_PROTO(struct task_struct *p, int success),
-	     TP_ARGS(p, success));
+	     TP_ARGS(p, success),
+	     TP_CONDITION(success));
 
 /*
  * Tracepoint for waking up a new task:
  */
-DEFINE_EVENT(sched_wakeup_template, sched_wakeup_new,
+DEFINE_EVENT_CONDITION(sched_wakeup_template, sched_wakeup_new,
 	     TP_PROTO(struct task_struct *p, int success),
-	     TP_ARGS(p, success));
+	     TP_ARGS(p, success),
+	     TP_CONDITION(success));
 
 #ifdef CREATE_TRACE_POINTS
 static inline long __trace_sched_switch_state(struct task_struct *p)
-- 
1.7.2.3


