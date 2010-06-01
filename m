Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753979Ab0FAJNe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jun 2010 05:13:34 -0400
Received: from hera.kernel.org ([140.211.167.34]:48126 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752096Ab0FAJNc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jun 2010 05:13:32 -0400
Date: Tue, 1 Jun 2010 09:13:00 GMT
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       rostedt@goodmis.org, a.p.zijlstra@chello.nl, tglx@linutronix.de,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       a.p.zijlstra@chello.nl, rostedt@goodmis.org, tglx@linutronix.de,
       mingo@elte.hu
In-Reply-To: <1275322715.27810.23323.camel@twins>
References: <1275322715.27810.23323.camel@twins>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/urgent] sched, trace: Fix sched_switch() prev_state argument
Message-ID: <tip-02f726949f2be0967aa4871dd4e47d3967779b26@git.kernel.org>
Git-Commit-ID: 02f726949f2be0967aa4871dd4e47d3967779b26
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Tue, 01 Jun 2010 09:13:01 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  02f726949f2be0967aa4871dd4e47d3967779b26
Gitweb:     http://git.kernel.org/tip/02f726949f2be0967aa4871dd4e47d3967779b26
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Mon, 31 May 2010 18:13:25 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 1 Jun 2010 09:27:17 +0200

sched, trace: Fix sched_switch() prev_state argument

For CONFIG_PREEMPT=y kernels the sched_switch(.prev_state) argument isn't
useful because we can get preempted with current->state != TASK_RUNNING
without actually getting removed from the runqueue.

Cure this by treating all preempted tasks as runnable from the tracer's
point of view.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cautiously-acked-by: Steven Rostedt <rostedt@goodmis.org>
LKML-Reference: <1275322715.27810.23323.camel@twins>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 include/trace/events/sched.h |   19 ++++++++++++++++++-
 1 files changed, 18 insertions(+), 1 deletions(-)

diff --git a/include/trace/events/sched.h b/include/trace/events/sched.h
index 4f733ec..b9e1dd6 100644
--- a/include/trace/events/sched.h
+++ b/include/trace/events/sched.h
@@ -115,6 +115,23 @@ DEFINE_EVENT(sched_wakeup_template, sched_wakeup_new,
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
