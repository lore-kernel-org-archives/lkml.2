Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754661Ab2IHRLs (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Sep 2012 13:11:48 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:36187 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752527Ab2IHRLV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Sep 2012 13:11:21 -0400
X-IronPort-AV: E=Sophos;i="4.80,392,1344182400"; 
   d="scan'208";a="5807477"
From: Lai Jiangshan <laijs@cn.fujitsu.com>
To: Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>
Subject: [PATCH 4/7 V6] workqueue: fix idle worker depletion
Date: Sun, 9 Sep 2012 01:12:53 +0800
Message-Id: <1347124383-18723-5-git-send-email-laijs@cn.fujitsu.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1347124383-18723-1-git-send-email-laijs@cn.fujitsu.com>
References: <1347124383-18723-1-git-send-email-laijs@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/09/09 01:10:48,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/09/09 01:10:48,
	Serialize complete at 2012/09/09 01:10:48
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If hotplug code grabbed the manager_mutex and worker_thread try to create
a worker, the manage_worker() will return false and worker_thread go to
process work items. Now, on the CPU, all workers are processing work items,
no idle_worker left/ready for managing. It breaks the concept of workqueue
and it is bug.

So when manage_worker() failed to grab the manager_mutex, it should
release gcwq->lock and try again.

After gcwq->lock is released, hotplug can happen. gcwq_unbind_fn() will
do the right thing for manager via ->manager. But rebind_workers()
can't rebind workers directly, worker rebind itself when it is noticed.

Manager worker will be noticed by the bit of GCWQ_DISASSOCIATED and
WORKER_UNBIND. Because the %UNBOUND bit of manager can't be cleared
while it is managing workers. maybe_rebind_manager() will be noticed
when rebind_workers() happens.

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
---
 kernel/workqueue.c |   33 ++++++++++++++++++++++++++++++++-
 1 files changed, 32 insertions(+), 1 deletions(-)

diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index b203806..207b6a1 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -2039,6 +2039,20 @@ static bool maybe_destroy_workers(struct worker_pool *pool)
 	return ret;
 }
 
+/* does the manager need to be rebind after we just release gcwq->lock */
+static void maybe_rebind_manager(struct worker *manager)
+{
+	struct global_cwq *gcwq = manager->pool->gcwq;
+	bool assoc = !(gcwq->flags & GCWQ_DISASSOCIATED);
+
+	if (assoc && (manager->flags & WORKER_UNBOUND)) {
+		spin_unlock_irq(&gcwq->lock);
+
+		if (worker_maybe_bind_and_lock(manager))
+			worker_clr_flags(manager, WORKER_UNBOUND);
+	}
+}
+
 /**
  * manage_workers - manage worker pool
  * @worker: self
@@ -2062,12 +2076,29 @@ static bool maybe_destroy_workers(struct worker_pool *pool)
 static bool manage_workers(struct worker *worker)
 {
 	struct worker_pool *pool = worker->pool;
+	struct global_cwq *gcwq = pool->gcwq;
 	bool ret = false;
 
-	if (!mutex_trylock(&pool->manager_mutex))
+	if (pool->manager)
 		return ret;
 
 	pool->manager = worker;
+	if (unlikely(!mutex_trylock(&pool->manager_mutex))) {
+		/*
+		 * Ouch! rebind_workers() or gcwq_unbind_fn() beats we.
+		 * it can't return false here, otherwise it will lead to
+		 * worker depletion. So we release gcwq->lock and then
+		 * grab manager_mutex again.
+		 */
+		spin_unlock_irq(&gcwq->lock);
+		mutex_lock(&pool->manager_mutex);
+		spin_lock_irq(&gcwq->lock);
+
+		/* rebind_workers() can happen when we release gcwq->lock */
+		maybe_rebind_manager(worker);
+		ret = true;
+	}
+
 	pool->flags &= ~POOL_MANAGE_WORKERS;
 
 	/*
-- 
1.7.4.4

