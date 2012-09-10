Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756791Ab2IJCJr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Sep 2012 22:09:47 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:58940 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1756399Ab2IJCJh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Sep 2012 22:09:37 -0400
X-IronPort-AV: E=Sophos;i="4.80,396,1344182400"; 
   d="scan'208";a="5810271"
From: Lai Jiangshan <laijs@cn.fujitsu.com>
To: Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>
Subject: [PATCH 2/2 V7 for-3.6-fixes] workqueue: fix idle worker depletion
Date: Mon, 10 Sep 2012 10:11:25 +0800
Message-Id: <1347243085-2510-2-git-send-email-laijs@cn.fujitsu.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1347243085-2510-1-git-send-email-laijs@cn.fujitsu.com>
References: <1347243085-2510-1-git-send-email-laijs@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/09/10 10:09:04,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/09/10 10:09:05,
	Serialize complete at 2012/09/10 10:09:05
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If hotplug code grabbed the manager_mutex and worker_thread try to create
a worker, the manage_worker() will return false and worker_thread go to
process work items. Now, on the CPU, all workers are processing work items,
no idle_worker left/ready for managing. It breaks the concept of workqueue
and it is bug.

So when manage_worker() failed to grab the manager_mutex, it should
release gcwq->lock and then grab manager_mutex.

After gcwq->lock is released, hotplug can happen. but the hoplug code
can't unbind/rebind the manager, so the manager should try to rebind
itself unconditionaly, if it fails, unbind itself.

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
---
 kernel/workqueue.c |   31 ++++++++++++++++++++++++++++++-
 1 files changed, 30 insertions(+), 1 deletions(-)

diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index 383548e..74434c8 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -1825,10 +1825,39 @@ static bool manage_workers(struct worker *worker)
 	struct worker_pool *pool = worker->pool;
 	bool ret = false;
 
-	if (!mutex_trylock(&pool->manager_mutex))
+	if (pool->flags & POOL_MANAGING_WORKERS)
 		return ret;
 
 	pool->flags |= POOL_MANAGING_WORKERS;
+
+	if (unlikely(!mutex_trylock(&pool->manager_mutex))) {
+		/*
+		 * Ouch! rebind_workers() or gcwq_unbind_fn() beats it.
+		 * it can't return false here, otherwise it will lead to
+		 * worker depletion. So we release gcwq->lock and then
+		 * grab manager_mutex again.
+		 */
+		spin_unlock_irq(&pool->gcwq->lock);
+		mutex_lock(&pool->manager_mutex);
+
+		/*
+		 * The hotplug had happened after the previous releasing
+		 * of gcwq->lock. So we can't assume that this worker is
+		 * still associated or not. And we have to try to rebind it
+		 * via worker_maybe_bind_and_lock(). If it returns false,
+		 * we can conclude that the whole gcwq is disassociated,
+		 * and we must unbind this worker. (hotplug code can't
+		 * unbind/rebind the manager, because hotplug code can't
+		 * iterate the manager)
+		 */
+		if (worker_maybe_bind_and_lock(worker))
+			worker->flags &= ~WORKER_UNBOUND;
+		else
+			worker->flags |= WORKER_UNBOUND;
+
+		ret = true;
+	}
+
 	pool->flags &= ~POOL_MANAGE_WORKERS;
 
 	/*
-- 
1.7.4.4

