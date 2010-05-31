Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756779Ab0EaQS1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 May 2010 12:18:27 -0400
Received: from casper.infradead.org ([85.118.1.10]:33148 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751630Ab0EaQS0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 May 2010 12:18:26 -0400
Subject: Re: [PATCH] tracing: Add task activate/deactivate tracepoints
From: Peter Zijlstra <peterz@infradead.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Steven Rostedt <rostedt@goodmis.org>
In-Reply-To: <20100531144820.GB5157@nowhere>
References: <1275056762-13130-1-git-send-regression-fweisbec@gmail.com>
	 <1275059710.27810.9624.camel@twins> <20100531080049.GA435@elte.hu>
	 <1275293544.27810.21478.camel@twins> <1275296099.27810.21622.camel@twins>
	 <20100531143622.GA5157@nowhere> <1275317013.27810.23019.camel@twins>
	 <20100531144820.GB5157@nowhere>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Mon, 31 May 2010 18:18:35 +0200
Message-ID: <1275322715.27810.23323.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-05-31 at 16:48 +0200, Frederic Weisbecker wrote:
> > Should we maybe cure this and rely on sched_switch() to detect sleeps?
> > It seems natural since only the current task can go to sleep, its just
> > that the whole preempt state gets a bit iffy.

How about something like the below?

Steve, is that proper usage of CREATE_TRACE_POINT?

---
Subject: sched, trace: Fix sched_switch() prev_state argument
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
Date: Mon May 31 18:13:25 CEST 2010

For CONFIG_PREEMPT=y kernels the sched_switch(.prev_state) argument
isn't useful because we can get preempted with current->state !=
TASK_RUNNING without actually getting removed from the runqueue.

Cure this by treating all preempted tasks as runnable from the
tracer's point of view.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 include/trace/events/sched.h |   19 ++++++++++++++++++-
 1 file changed, 18 insertions(+), 1 deletion(-)

Index: linux-2.6/include/trace/events/sched.h
===================================================================
--- linux-2.6.orig/include/trace/events/sched.h
+++ linux-2.6/include/trace/events/sched.h
@@ -115,6 +115,23 @@ DEFINE_EVENT(sched_wakeup_template, sche
 	     TP_PROTO(struct task_struct *p, int success),
 	     TP_ARGS(p, success));
 
+#ifdef CREATE_TRACE_POINTS
+static inline long __trace_sched_switch_state(struct task_struct *p)
+{
+	long state = p->state;
+
+#ifdef CONFIG_PREEMPT
+	/*
+	 * For all intents and purposes a preempted task is a running task.
+	 */
+	if (task_thread_info(p)->preempt_count & PREEMPT_ACTIVE)
+		state = TASK_RUNNING;
+#endif
+
+	return state;
+}
+#endif
+
 /*
  * Tracepoint for task switches, performed by the scheduler:
  */
@@ -139,7 +156,7 @@ TRACE_EVENT(sched_switch,
 		memcpy(__entry->next_comm, next->comm, TASK_COMM_LEN);
 		__entry->prev_pid	= prev->pid;
 		__entry->prev_prio	= prev->prio;
-		__entry->prev_state	= prev->state;
+		__entry->prev_state	= __trace_sched_switch_state(prev);
 		memcpy(__entry->prev_comm, prev->comm, TASK_COMM_LEN);
 		__entry->next_pid	= next->pid;
 		__entry->next_prio	= next->prio;

