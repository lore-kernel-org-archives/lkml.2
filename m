Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755454Ab1JCKva (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Oct 2011 06:51:30 -0400
Received: from casper.infradead.org ([85.118.1.10]:50037 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752515Ab1JCKvX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Oct 2011 06:51:23 -0400
Subject: Re: [PATCH] sched/kthread: Complain loudly when others violate our
 flags
From: Peter Zijlstra <peterz@infradead.org>
To: Tejun Heo <htejun@gmail.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, LKML <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>
Date: Mon, 03 Oct 2011 12:50:37 +0200
References: <1317158254.26514.55.camel@gandalf.stny.rr.com>
	 <20110930034815.GF10425@mtj.dyndns.org>
	 <1317355529.4588.45.camel@gandalf.stny.rr.com>
	 <20110930041424.GH10425@mtj.dyndns.org> <1317371699.19415.6.camel@twins>
	 <20110930085510.GA23868@mtj.dyndns.org> <1317373473.19415.10.camel@twins>
	 <20111003011506.GE31799@mtj.dyndns.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.0.3- 
Message-ID: <1317639037.20367.17.camel@twins>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-10-03 at 12:20 +0200, Peter Zijlstra wrote:
> I didn't write this change for fun, I actually need to get
> PF_THREAD_BOUND back to sanity, this change alone isn't enough, but it
> gets rid of the worst abuse. 

I think the below patch is sufficient (on top of the previous one), but
I haven't actually build or boot tested it (with the scheduler tests
that yell on a PF_THREAD_BOUND task migrating -- note to self: need to
exclude self migration due to the below)

It also looks like there's some more room for simplification now that we
don't actually need to worry about trying to run on cpus that aren't
there anymore.

---
Index: linux-2.6/kernel/workqueue.c
===================================================================
--- linux-2.6.orig/kernel/workqueue.c
+++ linux-2.6/kernel/workqueue.c
@@ -1285,8 +1285,14 @@ __acquires(&gcwq->lock)
 		 * it races with cpu hotunplug operation.  Verify
 		 * against GCWQ_DISASSOCIATED.
 		 */
-		if (!(gcwq->flags & GCWQ_DISASSOCIATED))
+		if (!(gcwq->flags & GCWQ_DISASSOCIATED)) {
+			/*
+			 * Since we're binding to a particular cpu and need to
+			 * stay there for correctness, mark us PF_THREAD_BOUND.
+			 */
+			task->flags |= PF_THREAD_BOUND;
 			set_cpus_allowed_ptr(task, get_cpu_mask(gcwq->cpu));
+		}
 
 		spin_lock_irq(&gcwq->lock);
 		if (gcwq->flags & GCWQ_DISASSOCIATED)
@@ -1308,6 +1314,18 @@ __acquires(&gcwq->lock)
 	}
 }
 
+static void worker_unbind_and_unlock(struct worker *worker)
+{
+	struct global_cwq *gcwq = worker->gcwq;
+	struct task_struct *task = worker->task;
+
+	/*
+	 * Its no longer required we're PF_THREAD_BOUND, the work is done.
+	 */
+	task->flags &= ~PF_THREAD_BOUND;
+	spin_unlock_irq(&gcwq->lock);
+}
+
 static struct worker *alloc_worker(void)
 {
 	struct worker *worker;
@@ -1370,15 +1388,9 @@ static struct worker *create_worker(stru
 	if (IS_ERR(worker->task))
 		goto fail;
 
-	/*
-	 * A rogue worker will become a regular one if CPU comes
-	 * online later on.  Make sure every worker has
-	 * PF_THREAD_BOUND set.
-	 */
 	if (bind && !on_unbound_cpu)
 		kthread_bind(worker->task, gcwq->cpu);
 	else {
-		worker->task->flags |= PF_THREAD_BOUND;
 		if (on_unbound_cpu)
 			worker->flags |= WORKER_UNBOUND;
 	}
@@ -2055,7 +2067,7 @@ static int rescuer_thread(void *__wq)
 		if (keep_working(gcwq))
 			wake_up_worker(gcwq);
 
-		spin_unlock_irq(&gcwq->lock);
+		worker_unbind_and_unlock(rescuer);
 	}
 
 	schedule();
@@ -3004,7 +3016,6 @@ struct workqueue_struct *__alloc_workque
 		if (IS_ERR(rescuer->task))
 			goto err;
 
-		rescuer->task->flags |= PF_THREAD_BOUND;
 		wake_up_process(rescuer->task);
 	}
 

