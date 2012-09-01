Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755657Ab2IARpx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Sep 2012 13:45:53 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:59081 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1755488Ab2IARoe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Sep 2012 13:44:34 -0400
X-IronPort-AV: E=Sophos;i="4.80,353,1344182400"; 
   d="scan'208";a="5764903"
From: Lai Jiangshan <laijs@cn.fujitsu.com>
To: Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>
Subject: [PATCH 10/10 V4] workqueue: merge the role of rebind_hold to idle_done
Date: Sun, 2 Sep 2012 00:28:28 +0800
Message-Id: <1346516916-1991-11-git-send-email-laijs@cn.fujitsu.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1346516916-1991-1-git-send-email-laijs@cn.fujitsu.com>
References: <1346516916-1991-1-git-send-email-laijs@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/09/02 00:27:26,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/09/02 00:28:33,
	Serialize complete at 2012/09/02 00:28:33
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently is single pass, we can wait on idle_done instead wait on rebind_hold.
So we can remove rebind_hold and make the code simpler.

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
---
 kernel/workqueue.c |   35 +++++++++++------------------------
 1 files changed, 11 insertions(+), 24 deletions(-)

diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index 6d68571..6411616 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -1309,9 +1309,6 @@ struct idle_rebind {
 	int		  idle_cnt;	/* # idle workers to be rebound */
 	struct completion idle_done;	/* all idle workers rebound */
 
-	/* idle workers wait all idles to be rebound */
-	struct completion rebind_hold;
-
 	/*
 	 * notify the rebind_workers() that:
 	 * 1. All idle workers are rebound.
@@ -1340,7 +1337,7 @@ static void synchronize_all_idles_rebound(struct global_cwq *gcwq,
 {
 
 	/* wait for rebind_workers() to notify that all idles are rebound */
-	wait_for_completion(&idle_rebind->rebind_hold);
+	wait_for_completion(&idle_rebind->idle_done);
 
 	/* finished synchronizing, put reference */
 	spin_lock_irq(&gcwq->lock);
@@ -1371,7 +1368,7 @@ static void idle_worker_rebind(struct worker *worker)
 
 	/* this worker has been rebound */
 	if (!--idle_rebind->idle_cnt)
-		complete(&idle_rebind->idle_done);
+		complete_all(&idle_rebind->idle_done);
 	spin_unlock_irq(&gcwq->lock);
 
 	synchronize_all_idles_rebound(gcwq, idle_rebind);
@@ -1447,17 +1444,15 @@ static void rebind_workers(struct global_cwq *gcwq)
 		lockdep_assert_held(&pool->manager_mutex);
 
 	/*
-	 * Rebind idle workers.  Interlocked both ways in triple waits.
-	 * We wait for workers to rebind via @idle_rebind.idle_done.
-	 * Workers will wait for us via @idle_rebind.rebind_hold.
-	 * And them we wait for workers to leave rebind_hold
-	 * via @idle_rebind.ref_done.
+	 * Rebind idle workers. Idle workers wait each other to rebind via
+	 * synchronize_all_idles_rebound(). We wait for all idle workers
+	 * to rebind via synchronize_all_idles_rebound() too.
+	 * And them we wait for all workers finish synchronizing and
+	 * release the ref of @idle_rebind via @idle_rebind.ref_done.
 	 */
 	init_completion(&idle_rebind.idle_done);
-	init_completion(&idle_rebind.rebind_hold);
 	init_completion(&idle_rebind.ref_done);
 	idle_rebind.ref_cnt = 1;
-	gcwq->idle_rebind = &idle_rebind;
 	idle_rebind.idle_cnt = 1;
 
 	/* set REBIND and kick idle ones, we'll wait for these later */
@@ -1497,23 +1492,15 @@ static void rebind_workers(struct global_cwq *gcwq)
 	}
 
 	/*
-	 * we will leave rebind_workers(), have to wait until no worker
-	 * has ref to this idle_rebind.
+	 * we will leave rebind_workers(), have to wait until all idles
+	 * are rebound and until no worker has ref to this idle_rebind.
 	 */
 	if (--idle_rebind.idle_cnt) {
+		gcwq->idle_rebind = &idle_rebind;
 		spin_unlock_irq(&gcwq->lock);
-		wait_for_completion(&idle_rebind.idle_done);
-		spin_lock_irq(&gcwq->lock);
-	}
-
-	complete_all(&idle_rebind.rebind_hold);
-
-	if (--idle_rebind.ref_cnt) {
-		spin_unlock_irq(&gcwq->lock);
+		synchronize_all_idles_rebound(gcwq, &idle_rebind);
 		wait_for_completion(&idle_rebind.ref_done);
 		spin_lock_irq(&gcwq->lock);
-	} else {
-		gcwq->idle_rebind = NULL;
 	}
 }
 
-- 
1.7.4.4

