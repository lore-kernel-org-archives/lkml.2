Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755587Ab2IAR7z (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Sep 2012 13:59:55 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:54631 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753707Ab2IAR7y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Sep 2012 13:59:54 -0400
X-IronPort-AV: E=Sophos;i="4.80,353,1344182400"; 
   d="scan'208";a="5764929"
From: Lai Jiangshan <laijs@cn.fujitsu.com>
To: Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>
Subject: [PATCH 07/10 V4] workqueue: move idle_rebind pointer to gcwq
Date: Sun, 2 Sep 2012 00:28:25 +0800
Message-Id: <1346516916-1991-8-git-send-email-laijs@cn.fujitsu.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1346516916-1991-1-git-send-email-laijs@cn.fujitsu.com>
References: <1346516916-1991-1-git-send-email-laijs@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/09/02 00:27:25,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/09/02 00:28:33,
	Serialize complete at 2012/09/02 00:28:33
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

And this pointer helps other workers know the progress of idle-rebinding.
when gcwq->idle_rebind is not NULL, it means the idle-rebinding is still
in progress.

and idle_worker_rebind() is split.

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
---
 kernel/workqueue.c |   67 ++++++++++++++++++++++++++++++++++++++--------------
 1 files changed, 49 insertions(+), 18 deletions(-)

diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index 9466d91..c875951 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -150,7 +150,6 @@ struct worker {
 	int			id;		/* I: worker id */
 
 	/* for rebinding worker to CPU */
-	struct idle_rebind	*idle_rebind;	/* L: for idle worker */
 	struct work_struct	rebind_work;	/* L: for busy worker */
 };
 
@@ -185,6 +184,9 @@ struct global_cwq {
 						/* L: hash of busy workers */
 
 	struct worker_pool	pools[2];	/* normal and highpri pools */
+
+	/* for rebinding worker to CPU */
+	struct idle_rebind	*idle_rebind;	/* L or ref: for idle worker */
 } ____cacheline_aligned_in_smp;
 
 /*
@@ -1313,10 +1315,10 @@ struct idle_rebind {
 	/*
 	 * notify the rebind_workers() that:
 	 * 1. All idle workers are rebound.
-	 * 2. No idle worker has ref to this struct
+	 * 2. No worker has ref to this struct
 	 *
-	 * @ref_cnt: # idle workers which has ref to this struct
-	 * @ref_done: any idle workers has no ref to this struct,
+	 * @ref_cnt: # workers which has ref to this struct
+	 * @ref_done: any worker has no ref to this struct,
 	 *	      it also implies that all idle workers are rebound.
 	 */
 	int		  ref_cnt;
@@ -1324,28 +1326,55 @@ struct idle_rebind {
 };
 
 /*
+ * synchronize_all_idles_rebound: wait until all idles workers are rebound
+ * @gcwq: gcwq of interest
+ * @idle_rebind: the value of @gcwq->idle_rebind, the caller should have
+ * 		 at least one reference to it.
+ *
+ * CONTEXT:
+ * Might sleep.  Called without any lock.
+ * With at least one bit of WORKER_NOT_RUNNING set if called from worker.
+ */
+static void synchronize_all_idles_rebound(struct global_cwq *gcwq,
+		struct idle_rebind *idle_rebind)
+{
+
+	/* wait for rebind_workers() to notify that all idles are rebound */
+	wait_for_completion(&idle_rebind->rebind_hold);
+
+	/* finished synchronizing, put reference */
+	spin_lock_irq(&gcwq->lock);
+	if (!--idle_rebind->ref_cnt) {
+		gcwq->idle_rebind = NULL;
+		complete(&idle_rebind->ref_done);
+	}
+	spin_unlock_irq(&gcwq->lock);
+}
+
+/*
  * Rebind an idle @worker to its CPU.  During CPU onlining, this has to
  * happen synchronously for idle workers.  worker_thread() will test
  * %WORKER_REBIND before leaving idle and call this function.
  */
 static void idle_worker_rebind(struct worker *worker)
 {
+	struct global_cwq *gcwq = worker->pool->gcwq;
+	struct idle_rebind *idle_rebind;
+
 	/* CPU must be online at this point */
 	WARN_ON(!worker_maybe_bind_and_lock(worker));
 	worker_clr_flags(worker, WORKER_REBIND);
-	++worker->idle_rebind->ref_cnt;
-	if (!--worker->idle_rebind->idle_cnt)
-		complete(&worker->idle_rebind->idle_done);
-	spin_unlock_irq(&worker->pool->gcwq->lock);
 
-	/* we did our part, wait for rebind_workers() to finish up */
-	wait_for_completion(&worker->idle_rebind->rebind_hold);
+	/* get reference */
+	idle_rebind = gcwq->idle_rebind;
+	++idle_rebind->ref_cnt;
 
-	/* noify if all idle worker are done(rebond & wait) */
-	spin_lock_irq(&worker->pool->gcwq->lock);
-	if (!--worker->idle_rebind->ref_cnt)
-		complete(&worker->idle_rebind->ref_done);
-	spin_unlock_irq(&worker->pool->gcwq->lock);
+	/* this worker has been rebound */
+	if (!--idle_rebind->idle_cnt)
+		complete(&idle_rebind->idle_done);
+	spin_unlock_irq(&gcwq->lock);
+
+	synchronize_all_idles_rebound(gcwq, idle_rebind);
 }
 
 /*
@@ -1414,6 +1443,7 @@ static void rebind_workers(struct global_cwq *gcwq)
 	init_completion(&idle_rebind.rebind_hold);
 	init_completion(&idle_rebind.ref_done);
 	idle_rebind.ref_cnt = 1;
+	gcwq->idle_rebind = &idle_rebind;
 retry:
 	idle_rebind.idle_cnt = 1;
 	INIT_COMPLETION(idle_rebind.idle_done);
@@ -1429,7 +1459,6 @@ retry:
 			worker->flags |= WORKER_REBIND;
 
 			idle_rebind.idle_cnt++;
-			worker->idle_rebind = &idle_rebind;
 
 			/* worker_thread() will call idle_worker_rebind() */
 			wake_up_process(worker->task);
@@ -1476,6 +1505,8 @@ retry:
 		spin_unlock_irq(&gcwq->lock);
 		wait_for_completion(&idle_rebind.ref_done);
 		spin_lock_irq(&gcwq->lock);
+	} else {
+		gcwq->idle_rebind = NULL;
 	}
 }
 
-- 
1.7.4.4

