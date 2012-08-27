Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754125Ab2H0R6X (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Aug 2012 13:58:23 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:50072 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1754024Ab2H0R5r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Aug 2012 13:57:47 -0400
X-IronPort-AV: E=Sophos;i="4.77,837,1336320000"; 
   d="scan'208";a="5733852"
From: Lai Jiangshan <laijs@cn.fujitsu.com>
To: Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>
Subject: [PATCH 7/7] workqueue: static idle_rebind
Date: Tue, 28 Aug 2012 01:58:27 +0800
Message-Id: <1346090307-3020-8-git-send-email-laijs@cn.fujitsu.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1346090307-3020-1-git-send-email-laijs@cn.fujitsu.com>
References: <1346090307-3020-1-git-send-email-laijs@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/08/28 01:57:34,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/08/28 01:57:34,
	Serialize complete at 2012/08/28 01:57:34
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

rebind_workers() is protected by cpu_hotplug lock,
so struct idle_rebind is also proteced by it.

And we can use a compile time allocated idle_rebind instead
of allocating it from the stack. it makes code clean.

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
---
 kernel/workqueue.c |   28 +++++++++++-----------------
 1 files changed, 11 insertions(+), 17 deletions(-)

diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index 9f38a65..a9bdf9c 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -125,7 +125,6 @@ enum {
 
 struct global_cwq;
 struct worker_pool;
-struct idle_rebind;
 
 /*
  * The poor guys doing the actual heavy lifting.  All on-duty workers
@@ -149,7 +148,6 @@ struct worker {
 	int			id;		/* I: worker id */
 
 	/* for rebinding worker to CPU */
-	struct idle_rebind	*idle_rebind;	/* L: for idle worker */
 	struct work_struct	rebind_work;	/* L: for busy worker */
 };
 
@@ -1302,10 +1300,8 @@ __acquires(&gcwq->lock)
 	}
 }
 
-struct idle_rebind {
-	int			cnt;		/* # workers to be rebound */
-	struct completion	done;		/* all workers rebound */
-};
+static int idle_rebind_cnt;			/* # workers to be rebound */
+static struct completion idle_rebind_done;	/* all workers rebound */
 
 /*
  * Rebind an idle @worker to its CPU.  During CPU onlining, this has to
@@ -1317,8 +1313,8 @@ static void idle_worker_rebind(struct worker *worker)
 	/* CPU must be online at this point */
 	WARN_ON(!worker_maybe_bind_and_lock(worker));
 	worker_clr_flags(worker, WORKER_REBIND);
-	if (!--worker->idle_rebind->cnt)
-		complete(&worker->idle_rebind->done);
+	if (!--idle_rebind_cnt)
+		complete(&idle_rebind_done);
 	spin_unlock_irq(&worker->pool->gcwq->lock);
 
 	/* we did our part, wait for rebind_workers() to finish up */
@@ -1377,7 +1373,6 @@ static void busy_worker_rebind_fn(struct work_struct *work)
 static void rebind_workers(struct global_cwq *gcwq)
 	__releases(&gcwq->lock) __acquires(&gcwq->lock)
 {
-	struct idle_rebind idle_rebind;
 	struct worker_pool *pool;
 	struct worker *worker;
 	struct hlist_node *pos;
@@ -1390,12 +1385,12 @@ static void rebind_workers(struct global_cwq *gcwq)
 
 	/*
 	 * Rebind idle workers.  Interlocked both ways.  We wait for
-	 * workers to rebind via @idle_rebind.done.  Workers will wait for
+	 * workers to rebind via @idle_rebind_done.  Workers will wait for
 	 * us to finish up by competing on pool->manager_mutex.
 	 */
-	init_completion(&idle_rebind.done);
-	idle_rebind.cnt = 0;
-	INIT_COMPLETION(idle_rebind.done);
+	init_completion(&idle_rebind_done);
+	idle_rebind_cnt = 0;
+	INIT_COMPLETION(idle_rebind_done);
 
 	/* set REBIND and kick idle ones, we'll wait for these later */
 	for_each_worker_pool(pool, gcwq) {
@@ -1404,8 +1399,7 @@ static void rebind_workers(struct global_cwq *gcwq)
 			worker->flags &= ~WORKER_UNBOUND;
 			worker->flags |= WORKER_REBIND;
 
-			idle_rebind.cnt++;
-			worker->idle_rebind = &idle_rebind;
+			idle_rebind_cnt++;
 
 			/* worker_thread() will call idle_worker_rebind() */
 			wake_up_process(worker->task);
@@ -1435,9 +1429,9 @@ static void rebind_workers(struct global_cwq *gcwq)
 	}
 
 	/* waiting for all idle workers to be rebound */
-	if (idle_rebind.cnt) {
+	if (idle_rebind_cnt) {
 		spin_unlock_irq(&gcwq->lock);
-		wait_for_completion(&idle_rebind.done);
+		wait_for_completion(&idle_rebind_done);
 		spin_lock_irq(&gcwq->lock);
 	}
 }
-- 
1.7.4.4

