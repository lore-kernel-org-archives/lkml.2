Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754021Ab2H0R5p (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Aug 2012 13:57:45 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:17857 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752261Ab2H0R5n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Aug 2012 13:57:43 -0400
X-IronPort-AV: E=Sophos;i="4.77,837,1336320000"; 
   d="scan'208";a="5733846"
From: Lai Jiangshan <laijs@cn.fujitsu.com>
To: Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>
Subject: [PATCH 1/7] workqueue: wait on manager_mutex instead of rebind_hold
Date: Tue, 28 Aug 2012 01:58:21 +0800
Message-Id: <1346090307-3020-2-git-send-email-laijs@cn.fujitsu.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1346090307-3020-1-git-send-email-laijs@cn.fujitsu.com>
References: <1346090307-3020-1-git-send-email-laijs@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/08/28 01:57:33,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/08/28 01:57:33,
	Serialize complete at 2012/08/28 01:57:33
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Current idle_worker_rebind() has a bug.

Worker thread:					The seconed CPU_ONLINE thread
idle_worker_rebind()
  wait_event(gcwq->rebind_hold)
    test for WORKER_REBIND and fails
    sleeping...

    #the first CPU_ONLINE is wokenup,
    #finish its later work and gone.

    this thread is also wokenup, but it is
    not scheduled, it is still sleeping
    sleeping...

    #the cpu is offline again
    #the cpu is online again,
    #the online code do notify(CPU_ONLINE)	call rebind_workers()
    #I name this is the seconed CPU_ONLINE	  set WORKER_REBIND to idle workers
    #thread, see the right.			  .
						  .
    this thread is finally scheduled,		  .
    sees the WORKER_REBIND is not cleared,	  .
    go to sleep again waiting for (another)	  .
    rebind_workers() to wake up me.	<--bug->  waiting for the idles' ACK.

The two thread wait each other. It is bug.

This fix:
The idle_worker_rebind() don't wait on rebind_hold, it waits on manager_mutex
instead. When mutex_lock(manager_mutex) returns, the idles know that
the corresponding rebind_workers() is finish up, the idle_worker_rebind() can
returns.

This fix has an advantage: WORKER_REBIND is not used for wait_event(),
so we can clear it in idle_worker_rebind().(next patch)

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
---
 kernel/workqueue.c |   13 +++----------
 1 files changed, 3 insertions(+), 10 deletions(-)

diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index 692d976..5872c31 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -184,8 +184,6 @@ struct global_cwq {
 						/* L: hash of busy workers */
 
 	struct worker_pool	pools[2];	/* normal and highpri pools */
-
-	wait_queue_head_t	rebind_hold;	/* rebind hold wait */
 } ____cacheline_aligned_in_smp;
 
 /*
@@ -1316,8 +1314,6 @@ struct idle_rebind {
  */
 static void idle_worker_rebind(struct worker *worker)
 {
-	struct global_cwq *gcwq = worker->pool->gcwq;
-
 	/* CPU must be online at this point */
 	WARN_ON(!worker_maybe_bind_and_lock(worker));
 	if (!--worker->idle_rebind->cnt)
@@ -1325,7 +1321,8 @@ static void idle_worker_rebind(struct worker *worker)
 	spin_unlock_irq(&worker->pool->gcwq->lock);
 
 	/* we did our part, wait for rebind_workers() to finish up */
-	wait_event(gcwq->rebind_hold, !(worker->flags & WORKER_REBIND));
+	mutex_lock(&worker->pool->manager_mutex);
+	mutex_unlock(&worker->pool->manager_mutex);
 }
 
 /*
@@ -1386,7 +1383,7 @@ static void rebind_workers(struct global_cwq *gcwq)
 	/*
 	 * Rebind idle workers.  Interlocked both ways.  We wait for
 	 * workers to rebind via @idle_rebind.done.  Workers will wait for
-	 * us to finish up by watching %WORKER_REBIND.
+	 * us to finish up by competing on pool->manager_mutex.
 	 */
 	init_completion(&idle_rebind.done);
 retry:
@@ -1429,8 +1426,6 @@ retry:
 		list_for_each_entry(worker, &pool->idle_list, entry)
 			worker->flags &= ~WORKER_REBIND;
 
-	wake_up_all(&gcwq->rebind_hold);
-
 	/* rebind busy workers */
 	for_each_busy_worker(worker, i, pos, gcwq) {
 		struct work_struct *rebind_work = &worker->rebind_work;
@@ -3722,8 +3717,6 @@ static int __init init_workqueues(void)
 			mutex_init(&pool->manager_mutex);
 			ida_init(&pool->worker_ida);
 		}
-
-		init_waitqueue_head(&gcwq->rebind_hold);
 	}
 
 	/* create the initial worker */
-- 
1.7.4.4

