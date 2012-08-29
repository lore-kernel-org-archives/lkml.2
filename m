Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754338Ab2H2Qul (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Aug 2012 12:50:41 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:30177 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1754204Ab2H2Qua (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Aug 2012 12:50:30 -0400
X-IronPort-AV: E=Sophos;i="4.80,335,1344182400"; 
   d="scan'208";a="5748909"
From: Lai Jiangshan <laijs@cn.fujitsu.com>
To: Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>
Subject: [PATCH 2/9 V3] workqueue: fix deadlock in rebind_workers()
Date: Thu, 30 Aug 2012 00:51:53 +0800
Message-Id: <1346259120-6216-3-git-send-email-laijs@cn.fujitsu.com>
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


Current idle_worker_rebind() has a bug.

idle_worker_rebind() path			HOTPLUG path
						online
							rebind_workers()
wait_event(gcwq->rebind_hold)
	woken up but no scheduled			rebind_workers() returns (*)
						the same cpu offline
						the same cpu online again
							rebind_workers()
								set WORKER_REBIND
	scheduled,see the WORKER_REBIND
	wait rebind_workers() clear it    <--bug-->		wait idle_worker_rebind()
								rebound.

The two thread wait each other. It is bug.

This fix focuses in (*), rebind_workers() can't returns until all idles
finish waiting on gcwq->rebind_hold(aka: until all idles release the reference
of gcwq->rebind_hold). We add a ref_done to do it. rebind_workers() will
waits on ref_done for all idles to finish wait.

It is now tree-times-hand-shake.

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
---
 kernel/workqueue.c |   61 ++++++++++++++++++++++++++++++++++++++++-----------
 1 files changed, 48 insertions(+), 13 deletions(-)

diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index 4f252d0..1363b39 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -1305,8 +1305,22 @@ __acquires(&gcwq->lock)
 }
 
 struct idle_rebind {
-	int			cnt;		/* # workers to be rebound */
-	struct completion	done;		/* all workers rebound */
+	int		  idle_cnt;	/* # idle workers to be rebound */
+	struct completion idle_done;	/* all idle workers rebound */
+
+	/*
+	 * notify the rebind_workers() that:
+	 * 0. All worker leave rebind_hold:
+	 * 1. All idle workers are rebound.
+	 * 2. No idle worker has ref to this struct
+	 *
+	 * @ref_cnt: # idle workers has ref to this struct
+	 * @ref_done: any idle workers has no ref to this struct,
+	 *	      nor rebind_hold.
+	 *	      it also implies that all idle workers are rebound.
+	 */
+	int		  ref_cnt;
+	struct completion ref_done;
 };
 
 /*
@@ -1320,12 +1334,18 @@ static void idle_worker_rebind(struct worker *worker)
 
 	/* CPU must be online at this point */
 	WARN_ON(!worker_maybe_bind_and_lock(worker));
-	if (!--worker->idle_rebind->cnt)
-		complete(&worker->idle_rebind->done);
+	if (!--worker->idle_rebind->idle_cnt)
+		complete(&worker->idle_rebind->idle_done);
 	spin_unlock_irq(&worker->pool->gcwq->lock);
 
 	/* we did our part, wait for rebind_workers() to finish up */
 	wait_event(gcwq->rebind_hold, !(worker->flags & WORKER_REBIND));
+
+	/* noify if all idle worker are done(rebond & wait) */
+	spin_lock_irq(&worker->pool->gcwq->lock);
+	if (!--worker->idle_rebind->ref_cnt)
+		complete(&worker->idle_rebind->ref_done);
+	spin_unlock_irq(&worker->pool->gcwq->lock);
 }
 
 /*
@@ -1384,14 +1404,18 @@ static void rebind_workers(struct global_cwq *gcwq)
 		lockdep_assert_held(&pool->manager_mutex);
 
 	/*
-	 * Rebind idle workers.  Interlocked both ways.  We wait for
-	 * workers to rebind via @idle_rebind.done.  Workers will wait for
-	 * us to finish up by watching %WORKER_REBIND.
+	 * Rebind idle workers.  Interlocked both ways in triple waits.
+	 * We wait for workers to rebind via @idle_rebind.idle_done.
+	 * Workers will wait for us to finish up by watching %WORKER_REBIND.
+	 * And them we wait for workers to leave rebind_hold
+	 * via @idle_rebind.ref_done.
 	 */
-	init_completion(&idle_rebind.done);
+	init_completion(&idle_rebind.idle_done);
+	init_completion(&idle_rebind.ref_done);
+	idle_rebind.ref_cnt = 1;
 retry:
-	idle_rebind.cnt = 1;
-	INIT_COMPLETION(idle_rebind.done);
+	idle_rebind.idle_cnt = 1;
+	INIT_COMPLETION(idle_rebind.idle_done);
 
 	/* set REBIND and kick idle ones, we'll wait for these later */
 	for_each_worker_pool(pool, gcwq) {
@@ -1403,7 +1427,8 @@ retry:
 			worker->flags &= ~WORKER_UNBOUND;
 			worker->flags |= WORKER_REBIND;
 
-			idle_rebind.cnt++;
+			idle_rebind.idle_cnt++;
+			idle_rebind.ref_cnt++;
 			worker->idle_rebind = &idle_rebind;
 
 			/* worker_thread() will call idle_worker_rebind() */
@@ -1411,9 +1436,9 @@ retry:
 		}
 	}
 
-	if (--idle_rebind.cnt) {
+	if (--idle_rebind.idle_cnt) {
 		spin_unlock_irq(&gcwq->lock);
-		wait_for_completion(&idle_rebind.done);
+		wait_for_completion(&idle_rebind.idle_done);
 		spin_lock_irq(&gcwq->lock);
 		/* busy ones might have become idle while waiting, retry */
 		goto retry;
@@ -1452,6 +1477,16 @@ retry:
 			    worker->scheduled.next,
 			    work_color_to_flags(WORK_NO_COLOR));
 	}
+
+	/*
+	 * we will leave rebind_workers(), have to wait until no worker
+	 * has ref to this idle_rebind nor rebind_hold.
+	 */
+	if (--idle_rebind.ref_cnt) {
+		spin_unlock_irq(&gcwq->lock);
+		wait_for_completion(&idle_rebind.ref_done);
+		spin_lock_irq(&gcwq->lock);
+	}
 }
 
 static struct worker *alloc_worker(void)
-- 
1.7.4.4

