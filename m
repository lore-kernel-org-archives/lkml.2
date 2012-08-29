Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754325Ab2H2QxR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Aug 2012 12:53:17 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:60837 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1754219Ab2H2Quc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Aug 2012 12:50:32 -0400
X-IronPort-AV: E=Sophos;i="4.80,335,1344182400"; 
   d="scan'208";a="5748916"
From: Lai Jiangshan <laijs@cn.fujitsu.com>
To: Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>
Subject: [PATCH 9/9 V3] workqueue: merge the role of rebind_hold to idle_done
Date: Thu, 30 Aug 2012 00:52:00 +0800
Message-Id: <1346259120-6216-10-git-send-email-laijs@cn.fujitsu.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1346259120-6216-1-git-send-email-laijs@cn.fujitsu.com>
References: <1346259120-6216-1-git-send-email-laijs@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/08/30 00:50:15,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/08/30 00:50:16,
	Serialize complete at 2012/08/30 00:50:16
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently is single pass, we can wait on idle_done instead wait on rebind_hold.
So we can remove rebind_hold and make the code simpler.

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
---
 kernel/workqueue.c |   25 +++++++++----------------
 1 files changed, 9 insertions(+), 16 deletions(-)

diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index 7e6145b..8253727 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -1325,9 +1325,6 @@ struct idle_rebind {
 	int		  idle_cnt;	/* # idle workers to be rebound */
 	struct completion idle_done;	/* all idle workers rebound */
 
-	/* idle workers wait all idles to be rebound */
-	struct completion rebind_hold;
-
 	/*
 	 * notify the rebind_workers() that:
 	 * 1. All idle workers are rebound.
@@ -1352,11 +1349,11 @@ static void idle_worker_rebind(struct worker *worker)
 	WARN_ON(!worker_maybe_bind_and_lock(worker));
 	worker_clr_flags(worker, WORKER_REBIND);
 	if (!--worker->idle_rebind->idle_cnt)
-		complete(&worker->idle_rebind->idle_done);
+		complete_all(&worker->idle_rebind->idle_done);
 	spin_unlock_irq(&worker->pool->gcwq->lock);
 
-	/* we did our part, wait for rebind_workers() to finish up */
-	wait_for_completion(&worker->idle_rebind->rebind_hold);
+	/* It did its part, wait for all other idles to finish up */
+	wait_for_completion(&worker->idle_rebind->idle_done);
 
 	/* noify if all idle worker are done(rebond & wait) */
 	spin_lock_irq(&worker->pool->gcwq->lock);
@@ -1427,14 +1424,12 @@ static void rebind_workers(struct global_cwq *gcwq)
 		lockdep_assert_held(&pool->manager_mutex);
 
 	/*
-	 * Rebind idle workers.  Interlocked both ways in triple waits.
-	 * We wait for workers to rebind via @idle_rebind.idle_done.
-	 * Workers will wait for us via @idle_rebind.rebind_hold.
-	 * And them we wait for workers to leave rebind_hold
-	 * via @idle_rebind.ref_done.
+	 * Rebind idle workers.
+	 * Workers wait each other to rebind via @idle_rebind.idle_done.
+	 * We wait for all idle workers to 1) rebind and 2) finish wait
+	 * and 3) release the ref of @idle_rebind via @idle_rebind.ref_done.
 	 */
 	init_completion(&idle_rebind.idle_done);
-	init_completion(&idle_rebind.rebind_hold);
 	init_completion(&idle_rebind.ref_done);
 	idle_rebind.ref_cnt = 1;
 	idle_rebind.idle_cnt = 1;
@@ -1478,14 +1473,12 @@ static void rebind_workers(struct global_cwq *gcwq)
 	}
 
 	/*
-	 * we will leave rebind_workers(), have to wait until no worker
-	 * has ref to this idle_rebind.
+	 * we will leave rebind_workers(), have to wait until all idles
+	 * are rebound and finish wait.
 	 */
 	if (--idle_rebind.ref_cnt) {
 		--idle_rebind.idle_cnt;
 		spin_unlock_irq(&gcwq->lock);
-		wait_for_completion(&idle_rebind.idle_done);
-		complete_all(&idle_rebind.rebind_hold);
 		wait_for_completion(&idle_rebind.ref_done);
 		spin_lock_irq(&gcwq->lock);
 	}
-- 
1.7.4.4

