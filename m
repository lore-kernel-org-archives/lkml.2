Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751259Ab1IPJQu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Sep 2011 05:16:50 -0400
Received: from casper.infradead.org ([85.118.1.10]:54311 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750815Ab1IPJQt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Sep 2011 05:16:49 -0400
Subject: [PATCH] sched,trace: Show PREEMPT_ACTIVE state in trace_sched_switch
From: Peter Zijlstra <peterz@infradead.org>
To: mingo <mingo@redhat.com>
Cc: rostedt <rostedt@goodmis.org>, Thomas Gleixner <tglx@linutronix.de>,
        linux-kernel <linux-kernel@vger.kernel.org>
Date: Fri, 16 Sep 2011 11:16:43 +0200
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.0.3- 
Message-ID: <1316164603.10174.11.camel@twins>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


We had need to see the difference between scheduling a runnable task and
a runnable task being involuntarily preempted.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 include/trace/events/sched.h |    9 +++++----
 1 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/include/trace/events/sched.h b/include/trace/events/sched.h
index f633478..959ff18 100644
--- a/include/trace/events/sched.h
+++ b/include/trace/events/sched.h
@@ -100,7 +100,7 @@ static inline long __trace_sched_switch_state(struct task_struct *p)
 	 * For all intents and purposes a preempted task is a running task.
 	 */
 	if (task_thread_info(p)->preempt_count & PREEMPT_ACTIVE)
-		state = TASK_RUNNING;
+		state = TASK_RUNNING | TASK_STATE_MAX;
 #endif
 
 	return state;
@@ -137,13 +137,14 @@ TRACE_EVENT(sched_switch,
 		__entry->next_prio	= next->prio;
 	),
 
-	TP_printk("prev_comm=%s prev_pid=%d prev_prio=%d prev_state=%s ==> next_comm=%s next_pid=%d next_prio=%d",
+	TP_printk("prev_comm=%s prev_pid=%d prev_prio=%d prev_state=%s%s ==> next_comm=%s next_pid=%d next_prio=%d",
 		__entry->prev_comm, __entry->prev_pid, __entry->prev_prio,
-		__entry->prev_state ?
-		  __print_flags(__entry->prev_state, "|",
+		__entry->prev_state & (TASK_STATE_MAX-1) ?
+		  __print_flags(__entry->prev_state & (TASK_STATE_MAX-1), "|",
 				{ 1, "S"} , { 2, "D" }, { 4, "T" }, { 8, "t" },
 				{ 16, "Z" }, { 32, "X" }, { 64, "x" },
 				{ 128, "W" }) : "R",
+		__entry->prev_state & TASK_STATE_MAX ? "+" : "",
 		__entry->next_comm, __entry->next_pid, __entry->next_prio)
 );
 

