Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754236Ab2H2Qud (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Aug 2012 12:50:33 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:30177 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753432Ab2H2Qub (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Aug 2012 12:50:31 -0400
X-IronPort-AV: E=Sophos;i="4.80,335,1344182400"; 
   d="scan'208";a="5748912"
From: Lai Jiangshan <laijs@cn.fujitsu.com>
To: Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>
Subject: [PATCH 5/9 V3] workqueue: move rebind_hold to idle_rebind
Date: Thu, 30 Aug 2012 00:51:56 +0800
Message-Id: <1346259120-6216-6-git-send-email-laijs@cn.fujitsu.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1346259120-6216-1-git-send-email-laijs@cn.fujitsu.com>
References: <1346259120-6216-1-git-send-email-laijs@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/08/30 00:50:15,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/08/30 00:50:15,
	Serialize complete at 2012/08/30 00:50:15
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

By the help of @idle_rebind.ref_done, the life time of idle_rebind
is expanded enough and it can include the whole reference-time
of @rebind_hold, so we can move @rebind_hold from gcwq to idle_rebind.

Also we change it to completion instead. we need to ease the pain of WORKER_REBIND.

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
---
 kernel/workqueue.c |   20 ++++++++------------
 1 files changed, 8 insertions(+), 12 deletions(-)

diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index e40898a..eeb5752 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -185,8 +185,6 @@ struct global_cwq {
 						/* L: hash of busy workers */
 
 	struct worker_pool	pools[2];	/* normal and highpri pools */
-
-	wait_queue_head_t	rebind_hold;	/* rebind hold wait */
 } ____cacheline_aligned_in_smp;
 
 /*
@@ -1327,15 +1325,16 @@ struct idle_rebind {
 	int		  idle_cnt;	/* # idle workers to be rebound */
 	struct completion idle_done;	/* all idle workers rebound */
 
+	/* idle workers wait all idles to be rebound */
+	struct completion rebind_hold;
+
 	/*
 	 * notify the rebind_workers() that:
-	 * 0. All worker leave rebind_hold:
 	 * 1. All idle workers are rebound.
 	 * 2. No idle worker has ref to this struct
 	 *
 	 * @ref_cnt: # idle workers has ref to this struct
 	 * @ref_done: any idle workers has no ref to this struct,
-	 *	      nor rebind_hold.
 	 *	      it also implies that all idle workers are rebound.
 	 */
 	int		  ref_cnt;
@@ -1349,8 +1348,6 @@ struct idle_rebind {
  */
 static void idle_worker_rebind(struct worker *worker)
 {
-	struct global_cwq *gcwq = worker->pool->gcwq;
-
 	/* CPU must be online at this point */
 	WARN_ON(!worker_maybe_bind_and_lock(worker));
 	if (!--worker->idle_rebind->idle_cnt)
@@ -1358,7 +1355,7 @@ static void idle_worker_rebind(struct worker *worker)
 	spin_unlock_irq(&worker->pool->gcwq->lock);
 
 	/* we did our part, wait for rebind_workers() to finish up */
-	wait_event(gcwq->rebind_hold, !(worker->flags & WORKER_REBIND));
+	wait_for_completion(&worker->idle_rebind->rebind_hold);
 
 	/* noify if all idle worker are done(rebond & wait) */
 	spin_lock_irq(&worker->pool->gcwq->lock);
@@ -1425,11 +1422,12 @@ static void rebind_workers(struct global_cwq *gcwq)
 	/*
 	 * Rebind idle workers.  Interlocked both ways in triple waits.
 	 * We wait for workers to rebind via @idle_rebind.idle_done.
-	 * Workers will wait for us to finish up by watching %WORKER_REBIND.
+	 * Workers will wait for us via @idle_rebind.rebind_hold.
 	 * And them we wait for workers to leave rebind_hold
 	 * via @idle_rebind.ref_done.
 	 */
 	init_completion(&idle_rebind.idle_done);
+	init_completion(&idle_rebind.rebind_hold);
 	init_completion(&idle_rebind.ref_done);
 	idle_rebind.ref_cnt = 1;
 retry:
@@ -1473,7 +1471,7 @@ retry:
 		list_for_each_entry(worker, &pool->idle_list, entry)
 			worker->flags &= ~WORKER_REBIND;
 
-	wake_up_all(&gcwq->rebind_hold);
+	complete_all(&idle_rebind.rebind_hold);
 
 	/* rebind busy workers */
 	for_each_busy_worker(worker, i, pos, gcwq) {
@@ -1499,7 +1497,7 @@ retry:
 
 	/*
 	 * we will leave rebind_workers(), have to wait until no worker
-	 * has ref to this idle_rebind nor rebind_hold.
+	 * has ref to this idle_rebind.
 	 */
 	if (--idle_rebind.ref_cnt) {
 		spin_unlock_irq(&gcwq->lock);
@@ -3789,8 +3787,6 @@ static int __init init_workqueues(void)
 			mutex_init(&pool->manager_mutex);
 			ida_init(&pool->worker_ida);
 		}
-
-		init_waitqueue_head(&gcwq->rebind_hold);
 	}
 
 	/* create the initial worker */
-- 
1.7.4.4

