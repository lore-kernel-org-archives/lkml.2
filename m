Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757657Ab0IRTop (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Sep 2010 15:44:45 -0400
Received: from kroah.org ([198.145.64.141]:51617 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755884Ab0IRTCB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Sep 2010 15:02:01 -0400
X-Mailbox-Line: From gregkh@clark.site Sat Sep 18 11:59:59 2010
Message-Id: <20100918185959.406378512@clark.site>
User-Agent: quilt/0.48-11.2
Date: Sat, 18 Sep 2010 11:58:41 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Greg KH <greg@kroah.com>, Mike Galbraith <efault@gmx.de>
Subject: [077/123] sched: Use TASK_WAKING for fork wakups
References: <20100918185724.290702750@clark.site>
Content-Disposition: inline; filename=sched-use-task_waking-for-fork-wakups.patch
In-Reply-To: <20100918190024.GA14388@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Peter Zijlstra <a.p.zijlstra@chello.nl>

commit 06b83b5fbea273672822b6ee93e16781046553ec upstream

For later convenience use TASK_WAKING for fresh tasks.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Mike Galbraith <efault@gmx.de>
LKML-Reference: <20091216170517.732561278@chello.nl>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Mike Galbraith <efault@gmx.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 kernel/sched.c |   18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -2538,14 +2538,6 @@ static void __sched_fork(struct task_str
 #ifdef CONFIG_PREEMPT_NOTIFIERS
 	INIT_HLIST_HEAD(&p->preempt_notifiers);
 #endif
-
-	/*
-	 * We mark the process as running here, but have not actually
-	 * inserted it onto the runqueue yet. This guarantees that
-	 * nobody will actually run it, and a signal or other external
-	 * event cannot wake it up and insert it on the runqueue either.
-	 */
-	p->state = TASK_RUNNING;
 }
 
 /*
@@ -2556,6 +2548,12 @@ void sched_fork(struct task_struct *p, i
 	int cpu = get_cpu();
 
 	__sched_fork(p);
+	/*
+	 * We mark the process as waking here. This guarantees that
+	 * nobody will actually run it, and a signal or other external
+	 * event cannot wake it up and insert it on the runqueue either.
+	 */
+	p->state = TASK_WAKING;
 
 	/*
 	 * Revert to default priority/policy on fork if requested.
@@ -2624,7 +2622,8 @@ void wake_up_new_task(struct task_struct
 	struct rq *rq;
 
 	rq = task_rq_lock(p, &flags);
-	BUG_ON(p->state != TASK_RUNNING);
+	BUG_ON(p->state != TASK_WAKING);
+	p->state = TASK_RUNNING;
 	update_rq_clock(rq);
 	activate_task(rq, p, 0);
 	trace_sched_wakeup_new(rq, p, 1);
@@ -7034,6 +7033,7 @@ void __cpuinit init_idle(struct task_str
 	spin_lock_irqsave(&rq->lock, flags);
 
 	__sched_fork(idle);
+	idle->state = TASK_RUNNING;
 	idle->se.exec_start = sched_clock();
 
 	cpumask_copy(&idle->cpus_allowed, cpumask_of(cpu));


