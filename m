Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758143Ab0LBWsT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Dec 2010 17:48:19 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:59999 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758010Ab0LBWsR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Dec 2010 17:48:17 -0500
X-Authority-Analysis: v=1.1 cv=6ptpMFIBtxRk0xdOb6IhJTbTLVRlKjWFes7R4SsWCrA= c=1 sm=0 a=fJAHirxvecoA:10 a=bbbx4UPp9XUA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=20KFwNOVAAAA:8 a=meVymXHHAAAA:8 a=y7tm9AGg_F1CVjwRMcMA:9 a=uxLX2NweVNN_8EgaVocA:7 a=AYpkU7xHj5NAdtDqBLK-rBZ-ZtcA:4 a=jEp0ucaQiEUA:10 a=jeBq3FmKZ4MA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Message-Id: <20101202224815.003521822@goodmis.org>
User-Agent: quilt/0.48-1
Date: Thu, 02 Dec 2010 17:36:56 -0500
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
Subject: [RFC][PATCH 2/2] [PATCH 2/2] tracing: Only trace sched_wakeup if it actually work something up
References: <20101202223654.596106888@goodmis.org>
Content-Disposition: inline; filename=0002-tracing-Only-trace-sched_wakeup-if-it-actually-work-.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

Currently the tracepoint sched_wakeup traces the wakeup event even
if the wakeup failed to wake anything up. This is quite stupid
but it happens because we did not want to add a conditional
to the core kernel code that would just slow down the wakeup events.

This patch changes the wakeup tracepoints to use the

 DECLARE_EVENT_CLASS_CONDITIONAL()

to test the "success" parameter and will only trace the event if
the wakeup was successfull.

The success field in the tracepoint is removed since it is no
longer needed.

Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 include/trace/events/sched.h |   10 +++++-----
 1 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/include/trace/events/sched.h b/include/trace/events/sched.h
index 67456f0..0807a25 100644
--- a/include/trace/events/sched.h
+++ b/include/trace/events/sched.h
@@ -52,17 +52,18 @@ TRACE_EVENT(sched_kthread_stop_ret,
 /*
  * Tracepoint for waking up a task:
  */
-DECLARE_EVENT_CLASS(sched_wakeup_template,
+DECLARE_EVENT_CLASS_CONDITION(sched_wakeup_template,
 
 	TP_PROTO(struct task_struct *p, int success),
 
 	TP_ARGS(p, success),
 
+	TP_CONDITION(success),
+
 	TP_STRUCT__entry(
 		__array(	char,	comm,	TASK_COMM_LEN	)
 		__field(	pid_t,	pid			)
 		__field(	int,	prio			)
-		__field(	int,	success			)
 		__field(	int,	target_cpu		)
 	),
 
@@ -70,13 +71,12 @@ DECLARE_EVENT_CLASS(sched_wakeup_template,
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
 
 DEFINE_EVENT(sched_wakeup_template, sched_wakeup,
-- 
1.7.2.3


