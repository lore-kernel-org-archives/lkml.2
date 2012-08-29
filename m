Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754260Ab2H2Que (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Aug 2012 12:50:34 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:20121 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751578Ab2H2Qua (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Aug 2012 12:50:30 -0400
X-IronPort-AV: E=Sophos;i="4.80,335,1344182400"; 
   d="scan'208";a="5748911"
From: Lai Jiangshan <laijs@cn.fujitsu.com>
To: Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>
Subject: [PATCH 4/9 V3] workqueue: add non_manager_role_manager_mutex_unlock()
Date: Thu, 30 Aug 2012 00:51:55 +0800
Message-Id: <1346259120-6216-5-git-send-email-laijs@cn.fujitsu.com>
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

If hotplug code grabbed the manager_mutex and worker_thread try to create
a worker, the manage_worker() will return false and worker_thread go to
process work items. Now, on the CPU, all workers are processing work items,
no idle_worker left/ready for managing. It breaks the concept of workqueue
and it is bug.

So when this case happens, the last idle should not go to process work,
it should go to sleep as usual and wait normal events. but it should
also be notified by the event that hotplug code release the manager_mutex.

So we add non_manager_role_manager_mutex_unlock() to do this notify.

By the way, if manager_mutex is grabbed by a real manager,
POOL_MANAGING_WORKERS will be set, the last idle can go to process work.

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
---
 kernel/workqueue.c |   42 ++++++++++++++++++++++++++++++++++--------
 1 files changed, 34 insertions(+), 8 deletions(-)

diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index 0673598..e40898a 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -1305,6 +1305,24 @@ __acquires(&gcwq->lock)
 	}
 }
 
+/*
+ * Release pool->manager_mutex which grabbed by current thread but manager
+ *
+ * Current thread has held the manager_mutex and it may caused
+ * the worker_thread who tried to create worker go to sleep,
+ * wake one and let it try to create worker again or proccess work.
+ *
+ * CONTEXT:
+ *  spin_lock_irq(gcwq->lock).
+ */
+static void non_manager_role_manager_mutex_unlock(struct worker_pool *pool)
+{
+	mutex_unlock(&pool->manager_mutex);
+
+	if (need_more_worker(pool))
+		wake_up_worker(pool);
+}
+
 struct idle_rebind {
 	int		  idle_cnt;	/* # idle workers to be rebound */
 	struct completion idle_done;	/* all idle workers rebound */
@@ -2136,11 +2154,12 @@ woke_up:
 recheck:
 	/* no more worker necessary? */
 	if (!need_more_worker(pool))
-		goto sleep;
+		goto manage;
 
 	/* do we need to manage? */
-	if (unlikely(!may_start_working(pool)) && manage_workers(worker))
-		goto recheck;
+	if (unlikely(!may_start_working(pool)) &&
+	    !(pool->flags & POOL_MANAGING_WORKERS))
+		goto manage;
 
 	/*
 	 * ->scheduled list can only be filled while a worker is
@@ -2173,13 +2192,20 @@ recheck:
 	} while (keep_working(pool));
 
 	worker_set_flags(worker, WORKER_PREP, false);
-sleep:
+manage:
 	if (unlikely(need_to_manage_workers(pool)) && manage_workers(worker))
 		goto recheck;
 
 	/*
-	 * gcwq->lock is held and there's no work to process and no
-	 * need to manage, sleep.  Workers are woken up only while
+	 * gcwq->lock is held and it will leave when one of these cases:
+	 * case1) there's no work to process and no need to manage, sleep.
+	 * case2) there are works to process but it is the last idle and
+	 *        failed to grab manager_lock to create worker. also sleep!
+	 *        current manager_lock owner will wake up it to
+	 *        process work or do manage.
+	 *        See non_manager_role_manager_mutex_unlock().
+	 *
+	 * Workers are woken up only while
 	 * holding gcwq->lock or from local cpu, so setting the
 	 * current state before releasing gcwq->lock is enough to
 	 * prevent losing any event.
@@ -3419,9 +3445,9 @@ static void gcwq_release_management_and_unlock(struct global_cwq *gcwq)
 {
 	struct worker_pool *pool;
 
-	spin_unlock_irq(&gcwq->lock);
 	for_each_worker_pool(pool, gcwq)
-		mutex_unlock(&pool->manager_mutex);
+		non_manager_role_manager_mutex_unlock(pool);
+	spin_unlock_irq(&gcwq->lock);
 }
 
 static void gcwq_unbind_fn(struct work_struct *work)
-- 
1.7.4.4

