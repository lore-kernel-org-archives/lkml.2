Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964792Ab2CATEs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2012 14:04:48 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:11468 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756479Ab2CATDt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2012 14:03:49 -0500
X-Authority-Analysis: v=2.0 cv=Xp94yC59 c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=UBy9sU4F98IA:10 a=F1KfcCDaTgQA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=JPQJig8JYuhD0utrOU0A:9 a=YKmmSzRvNwn0uV3sB1UA:7 a=jeBq3FmKZ4MA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-Id: <20120301190346.450438474@goodmis.org>
User-Agent: quilt/0.50-1
Date: Thu, 01 Mar 2012 13:55:35 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org,
        linux-rt-users <linux-rt-users@vger.kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Carsten Emde <C.Emde@osadl.org>,
        John Kacur <jkacur@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        Clark Williams <clark.williams@gmail.com>
Subject: [PATCH RT 8/9][RFC] [PATCH 8/9] workqueue: Revert workqueue: Fix PF_THREAD_BOUND abuse
References: <20120301185527.064629423@goodmis.org>
Content-Disposition: inline; filename=0008-workqueue-Revert-workqueue-Fix-PF_THREAD_BOUND-abuse.patch
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
---
 kernel/workqueue.c |   29 +++++++++--------------------
 1 files changed, 9 insertions(+), 20 deletions(-)

diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index e7f3e79..3b53135 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -1286,14 +1286,8 @@ __acquires(&gcwq->lock)
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
@@ -1307,18 +1301,6 @@ __acquires(&gcwq->lock)
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
@@ -1381,9 +1363,15 @@ static struct worker *create_worker(struct global_cwq *gcwq, bool bind)
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
@@ -2060,7 +2048,7 @@ repeat:
 		if (keep_working(gcwq))
 			wake_up_worker(gcwq);
 
-		worker_unbind_and_unlock(rescuer);
+		spin_unlock_irq(&gcwq->lock);
 	}
 
 	schedule();
@@ -3009,6 +2997,7 @@ struct workqueue_struct *__alloc_workqueue_key(const char *name,
 		if (IS_ERR(rescuer->task))
 			goto err;
 
+		rescuer->task->flags |= PF_THREAD_BOUND;
 		wake_up_process(rescuer->task);
 	}
 
-- 
1.7.3.4


