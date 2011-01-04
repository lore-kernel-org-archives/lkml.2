Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752788Ab1ADPOl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jan 2011 10:14:41 -0500
Received: from canuck.infradead.org ([134.117.69.58]:54800 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752067Ab1ADPMH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jan 2011 10:12:07 -0500
Message-Id: <20110104150102.460900901@chello.nl>
User-Agent: quilt/0.48-1
Date: Tue, 04 Jan 2011 15:59:32 +0100
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Chris Mason <chris.mason@oracle.com>,
        Frank Rowand <frank.rowand@am.sony.com>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>, Mike Galbraith <efault@gmx.de>,
        Oleg Nesterov <oleg@redhat.com>, Paul Turner <pjt@google.com>,
        Jens Axboe <axboe@kernel.dk>, Yong Zhang <yong.zhang0@gmail.com>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [RFC][PATCH 03/18] sched: Change the ttwu success details
References: <20110104145929.772813816@chello.nl>
Content-Disposition: inline; filename=sched-change-ttwu-return.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

try_to_wake_up() would only return a success when it would have to
place a task on a rq, change that to every time we change p->state to
TASK_RUNNING, because that's the real measure of wakeups.

This results in that success is always true for the tracepoints.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 kernel/sched.c |   18 ++++++++----------
 1 file changed, 8 insertions(+), 10 deletions(-)

Index: linux-2.6/kernel/sched.c
===================================================================
--- linux-2.6.orig/kernel/sched.c
+++ linux-2.6/kernel/sched.c
@@ -2383,10 +2383,10 @@ static inline void ttwu_activate(struct 
 	activate_task(rq, p, en_flags);
 }
 
-static inline void ttwu_post_activation(struct task_struct *p, struct rq *rq,
-					int wake_flags, bool success)
+static void
+ttwu_post_activation(struct task_struct *p, struct rq *rq, int wake_flags)
 {
-	trace_sched_wakeup(p, success);
+	trace_sched_wakeup(p, true);
 	check_preempt_curr(rq, p, wake_flags);
 
 	p->state = TASK_RUNNING;
@@ -2406,7 +2406,7 @@ static inline void ttwu_post_activation(
 	}
 #endif
 	/* if a worker is waking up, notify workqueue */
-	if ((p->flags & PF_WQ_WORKER) && success)
+	if (p->flags & PF_WQ_WORKER)
 		wq_worker_waking_up(p, cpu_of(rq));
 }
 
@@ -2505,9 +2505,9 @@ static int try_to_wake_up(struct task_st
 #endif /* CONFIG_SMP */
 	ttwu_activate(p, rq, wake_flags & WF_SYNC, orig_cpu != cpu,
 		      cpu == this_cpu, en_flags);
-	success = 1;
 out_running:
-	ttwu_post_activation(p, rq, wake_flags, success);
+	ttwu_post_activation(p, rq, wake_flags);
+	success = 1;
 out:
 	task_rq_unlock(rq, &flags);
 	put_cpu();
@@ -2526,7 +2526,6 @@ static int try_to_wake_up(struct task_st
 static void try_to_wake_up_local(struct task_struct *p)
 {
 	struct rq *rq = task_rq(p);
-	bool success = false;
 
 	BUG_ON(rq != this_rq());
 	BUG_ON(p == current);
@@ -2541,9 +2540,8 @@ static void try_to_wake_up_local(struct 
 			schedstat_inc(rq, ttwu_local);
 		}
 		ttwu_activate(p, rq, false, false, true, ENQUEUE_WAKEUP);
-		success = true;
 	}
-	ttwu_post_activation(p, rq, 0, success);
+	ttwu_post_activation(p, rq, 0);
 }
 
 /**
@@ -2705,7 +2703,7 @@ void wake_up_new_task(struct task_struct
 
 	rq = task_rq_lock(p, &flags);
 	activate_task(rq, p, 0);
-	trace_sched_wakeup_new(p, 1);
+	trace_sched_wakeup_new(p, true);
 	check_preempt_curr(rq, p, WF_FORK);
 #ifdef CONFIG_SMP
 	if (p->sched_class->task_woken)


