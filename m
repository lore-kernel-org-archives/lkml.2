Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753140Ab2IHRLa (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Sep 2012 13:11:30 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:18308 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752516Ab2IHRLT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Sep 2012 13:11:19 -0400
X-IronPort-AV: E=Sophos;i="4.80,392,1344182400"; 
   d="scan'208";a="5807476"
From: Lai Jiangshan <laijs@cn.fujitsu.com>
To: Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>
Subject: [PATCH 3/7 V6] workqueue:  add manager pointer for worker_pool
Date: Sun, 9 Sep 2012 01:12:52 +0800
Message-Id: <1347124383-18723-4-git-send-email-laijs@cn.fujitsu.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1347124383-18723-1-git-send-email-laijs@cn.fujitsu.com>
References: <1347124383-18723-1-git-send-email-laijs@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/09/09 01:10:47,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/09/09 01:10:48,
	Serialize complete at 2012/09/09 01:10:48
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We have this plan for manage_workers(): if failed to grab
manager_mutex via mutex_trylock(), we will release gcwq->lock and then
grab manager_mutex again.

This plan will open a hole: hotplug is running after we release gcwq->lock,
and it will not handle the binding of manager. so we add ->manager
on worker_pool and let hotplug code(gcwq_unbind_fn()) handle it.

also fix too_many_workers() to use this pointer.

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
---
 kernel/workqueue.c |   12 ++++++++++--
 1 files changed, 10 insertions(+), 2 deletions(-)

diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index 3dd7ce2..b203806 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -165,6 +165,7 @@ struct worker_pool {
 	struct timer_list	idle_timer;	/* L: worker idle timeout */
 	struct timer_list	mayday_timer;	/* L: SOS timer for workers */
 
+	struct worker		*manager;	/* L: manager worker */
 	struct mutex		manager_mutex;	/* mutex manager should hold */
 	struct ida		worker_ida;	/* L: for worker IDs */
 };
@@ -680,7 +681,7 @@ static bool need_to_manage_workers(struct worker_pool *pool)
 /* Do we have too many workers and should some go away? */
 static bool too_many_workers(struct worker_pool *pool)
 {
-	bool managing = mutex_is_locked(&pool->manager_mutex);
+	bool managing = !!pool->manager;
 	int nr_idle = pool->nr_idle + managing; /* manager is considered idle */
 	int nr_busy = pool->nr_workers - nr_idle;
 
@@ -2066,6 +2067,7 @@ static bool manage_workers(struct worker *worker)
 	if (!mutex_trylock(&pool->manager_mutex))
 		return ret;
 
+	pool->manager = worker;
 	pool->flags &= ~POOL_MANAGE_WORKERS;
 
 	/*
@@ -2076,6 +2078,8 @@ static bool manage_workers(struct worker *worker)
 	ret |= maybe_create_worker(pool);
 
 	mutex_unlock(&pool->manager_mutex);
+	pool->manager = NULL;
+
 	return ret;
 }
 
@@ -3438,9 +3442,12 @@ static void gcwq_unbind_fn(struct work_struct *work)
 	 * ones which are still executing works from before the last CPU
 	 * down must be on the cpu.  After this, they may become diasporas.
 	 */
-	for_each_worker_pool(pool, gcwq)
+	for_each_worker_pool(pool, gcwq) {
 		list_for_each_entry(worker, &pool->idle_list, entry)
 			worker->flags |= WORKER_UNBOUND;
+		if (pool->manager)
+			pool->manager->flags |= WORKER_UNBOUND;
+	}
 
 	for_each_busy_worker(worker, i, pos, gcwq)
 		worker->flags |= WORKER_UNBOUND;
@@ -3760,6 +3767,7 @@ static int __init init_workqueues(void)
 			setup_timer(&pool->mayday_timer, gcwq_mayday_timeout,
 				    (unsigned long)pool);
 
+			pool->manager = NULL;
 			mutex_init(&pool->manager_mutex);
 			ida_init(&pool->worker_ida);
 		}
-- 
1.7.4.4

