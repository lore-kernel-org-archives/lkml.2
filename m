Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758699Ab2IEKiP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2012 06:38:15 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:55811 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752860Ab2IEKgR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2012 06:36:17 -0400
X-IronPort-AV: E=Sophos;i="4.80,373,1344182400"; 
   d="scan'208";a="5789512"
From: Lai Jiangshan <laijs@cn.fujitsu.com>
To: Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>
Subject: [PATCH 06/11 V5] workqueue: unbind manager
Date: Wed, 5 Sep 2012 18:37:43 +0800
Message-Id: <1346841475-4422-7-git-send-email-laijs@cn.fujitsu.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1346841475-4422-1-git-send-email-laijs@cn.fujitsu.com>
References: <1346841475-4422-1-git-send-email-laijs@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/09/05 18:35:50,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/09/05 18:35:50,
	Serialize complete at 2012/09/05 18:35:50
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

add ->manager to make gcwq_unbind_fn() knows the manager and unbind it.

It just prepares, this code is useless until
"we unbind/rebind without manager_mutex"

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
---
 kernel/workqueue.c |   10 +++++++++-
 1 files changed, 9 insertions(+), 1 deletions(-)

diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index 1946be4..9f4dd20 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -160,6 +160,7 @@ struct worker_pool {
 	struct timer_list	idle_timer;	/* L: worker idle timeout */
 	struct timer_list	mayday_timer;	/* L: SOS timer for workers */
 
+	struct worker		*manager;	/* L: manager worker */
 	struct mutex		manager_mutex;	/* mutex manager should hold */
 	struct ida		worker_ida;	/* L: for worker IDs */
 };
@@ -2055,6 +2056,7 @@ static bool manage_workers(struct worker *worker)
 	if (!mutex_trylock(&pool->manager_mutex))
 		return ret;
 
+	pool->manager = worker;
 	pool->flags &= ~POOL_MANAGE_WORKERS;
 
 	/*
@@ -2065,6 +2067,8 @@ static bool manage_workers(struct worker *worker)
 	ret |= maybe_create_worker(pool);
 
 	mutex_unlock(&pool->manager_mutex);
+	pool->manager = NULL;
+
 	return ret;
 }
 
@@ -3426,9 +3430,12 @@ static void gcwq_unbind_fn(struct work_struct *work)
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
@@ -3748,6 +3755,7 @@ static int __init init_workqueues(void)
 			setup_timer(&pool->mayday_timer, gcwq_mayday_timeout,
 				    (unsigned long)pool);
 
+			pool->manager = NULL;
 			mutex_init(&pool->manager_mutex);
 			ida_init(&pool->worker_ida);
 		}
-- 
1.7.4.4

