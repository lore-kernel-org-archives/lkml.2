Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752693Ab2GPIIS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2012 04:08:18 -0400
Received: from www.linutronix.de ([62.245.132.108]:51915 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750843Ab2GPIHp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2012 04:07:45 -0400
Message-Id: <20120715091932.150331291@linutronix.de>
User-Agent: quilt/0.48-1
Date: Mon, 16 Jul 2012 08:07:44 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: RT-users <linux-rt-users@vger.kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: [patch RT 2/3] workqueue: Revert workqueue: Fix PF_THREAD_BOUND abuse
References: <20120715090141.942753287@linutronix.de>
Content-Disposition: inline;
 filename=0002-workqueue-Revert-workqueue-Fix-PF_THREAD_BOUND-abuse.patch
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Revert commit

    Author: Peter Zijlstra <a.p.zijlstra@chello.nl>
    Date:   Mon Oct 3 12:43:25 2011 +0200
    workqueue: Fix PF_THREAD_BOUND abuse

As TREAD_BOUND no longer affects cpu down, and this code introduced
a lot of races with taking down a CPU.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 kernel/workqueue.c |   29 +++++++++--------------------
 1 files changed, 9 insertions(+), 20 deletions(-)

diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index bc867e8..1e7f9c7 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -1283,14 +1283,8 @@ __acquires(&gcwq->lock)
 			return false;
 		if (task_cpu(task) == gcwq->cpu &&
 		    cpumask_equal(&current->cpus_allowed,
-				  get_cpu_mask(gcwq->cpu))) {
-			/*
-			 * Since we're binding to a particular cpu and need to
-			 * stay there for correctness, mark us PF_THREAD_BOUND.
-			 */
-			task->flags |= PF_THREAD_BOUND;
+				  get_cpu_mask(gcwq->cpu)))
 			return true;
-		}
 		spin_unlock_irq(&gcwq->lock);
 
 		/*
@@ -1304,18 +1298,6 @@ __acquires(&gcwq->lock)
 	}
 }
 
-static void worker_unbind_and_unlock(struct worker *worker)
-{
-	struct global_cwq *gcwq = worker->gcwq;
-	struct task_struct *task = worker->task;
-
-	/*
-	 * Its no longer required we're PF_THREAD_BOUND, the work is done.
-	 */
-	task->flags &= ~PF_THREAD_BOUND;
-	spin_unlock_irq(&gcwq->lock);
-}
-
 static struct worker *alloc_worker(void)
 {
 	struct worker *worker;
@@ -1378,9 +1360,15 @@ static struct worker *create_worker(struct global_cwq *gcwq, bool bind)
 	if (IS_ERR(worker->task))
 		goto fail;
 
+	/*
+	 * A rogue worker will become a regular one if CPU comes
+	 * online later on.  Make sure every worker has
+	 * PF_THREAD_BOUND set.
+	 */
 	if (bind && !on_unbound_cpu)
 		kthread_bind(worker->task, gcwq->cpu);
 	else {
+		worker->task->flags |= PF_THREAD_BOUND;
 		if (on_unbound_cpu)
 			worker->flags |= WORKER_UNBOUND;
 	}
@@ -2057,7 +2045,7 @@ repeat:
 		if (keep_working(gcwq))
 			wake_up_worker(gcwq);
 
-		worker_unbind_and_unlock(rescuer);
+		spin_unlock_irq(&gcwq->lock);
 	}
 
 	schedule();
@@ -3007,6 +2995,7 @@ struct workqueue_struct *__alloc_workqueue_key(const char *fmt,
 		if (IS_ERR(rescuer->task))
 			goto err;
 
+		rescuer->task->flags |= PF_THREAD_BOUND;
 		wake_up_process(rescuer->task);
 	}
 
-- 
1.7.3.4



