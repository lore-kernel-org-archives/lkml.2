Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751909Ab2GRCF3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2012 22:05:29 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:21633 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751420Ab2GRCFM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2012 22:05:12 -0400
X-Authority-Analysis: v=2.0 cv=AtpsLZBP c=1 sm=0 a=s5Htg7xnQOKvHEu9STBOug==:17 a=OpT9cpI26MMA:10 a=Ciwy3NGCPMMA:10 a=5OmRh1dPbYsA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=20KFwNOVAAAA:8 a=ayC55rCoAAAA:8 a=tHCmuXCLoTawAq-C0sgA:9 a=E6k37eg1NvgA:10 a=jEp0ucaQiEUA:10 a=jeBq3FmKZ4MA:10 a=Zh68SRI7RUMA:10 a=s5Htg7xnQOKvHEu9STBOug==:117
X-Cloudmark-Score: 0
X-Originating-IP: 72.230.195.127
Message-Id: <20120718020510.959371775@goodmis.org>
User-Agent: quilt/0.60-1
Date: Tue, 17 Jul 2012 22:04:30 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org,
        linux-rt-users <linux-rt-users@vger.kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Carsten Emde <C.Emde@osadl.org>,
        John Kacur <jkacur@redhat.com>
Subject: [PATCH RT 3/5] workqueue: Revert workqueue: Fix PF_THREAD_BOUND abuse
References: <20120718020427.338763317@goodmis.org>
Content-Disposition: inline; filename=0003-workqueue-Revert-workqueue-Fix-PF_THREAD_BOUND-abuse.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

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
 1 file changed, 9 insertions(+), 20 deletions(-)

diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index 674d783..5179143 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -1288,14 +1288,8 @@ __acquires(&gcwq->lock)
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
@@ -1309,18 +1303,6 @@ __acquires(&gcwq->lock)
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
@@ -1383,9 +1365,15 @@ static struct worker *create_worker(struct global_cwq *gcwq, bool bind)
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
@@ -2062,7 +2050,7 @@ repeat:
 		if (keep_working(gcwq))
 			wake_up_worker(gcwq);
 
-		worker_unbind_and_unlock(rescuer);
+		spin_unlock_irq(&gcwq->lock);
 	}
 
 	schedule();
@@ -3011,6 +2999,7 @@ struct workqueue_struct *__alloc_workqueue_key(const char *name,
 		if (IS_ERR(rescuer->task))
 			goto err;
 
+		rescuer->task->flags |= PF_THREAD_BOUND;
 		wake_up_process(rescuer->task);
 	}
 
-- 
1.7.10.4


