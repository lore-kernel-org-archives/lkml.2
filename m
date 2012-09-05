Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758690Ab2IEKg4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2012 06:36:56 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:18290 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1758559Ab2IEKgS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2012 06:36:18 -0400
X-IronPort-AV: E=Sophos;i="4.80,373,1344182400"; 
   d="scan'208";a="5789517"
From: Lai Jiangshan <laijs@cn.fujitsu.com>
To: Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>
Subject: [PATCH 11/11 V5] workqueue: remove manager_mutex
Date: Wed, 5 Sep 2012 18:37:48 +0800
Message-Id: <1346841475-4422-12-git-send-email-laijs@cn.fujitsu.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1346841475-4422-1-git-send-email-laijs@cn.fujitsu.com>
References: <1346841475-4422-1-git-send-email-laijs@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/09/05 18:35:51,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/09/05 18:35:51,
	Serialize complete at 2012/09/05 18:35:51
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

no one except manage_workers() use it. remove it.
manage_workers() will use ->manager instead.

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
---
 kernel/workqueue.c |    7 ++-----
 1 files changed, 2 insertions(+), 5 deletions(-)

diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index 5fb712a..eee3fad 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -163,7 +163,6 @@ struct worker_pool {
 	struct timer_list	mayday_timer;	/* L: SOS timer for workers */
 
 	struct worker		*manager;	/* L: manager worker */
-	struct mutex		manager_mutex;	/* mutex manager should hold */
 	struct ida		worker_ida;	/* L: for worker IDs */
 };
 
@@ -678,7 +677,7 @@ static bool need_to_manage_workers(struct worker_pool *pool)
 /* Do we have too many workers and should some go away? */
 static bool too_many_workers(struct worker_pool *pool)
 {
-	bool managing = mutex_is_locked(&pool->manager_mutex);
+	bool managing = !!pool->manager;
 	int nr_idle = pool->nr_idle + managing; /* manager is considered idle */
 	int nr_busy = pool->nr_workers - nr_idle;
 
@@ -2104,7 +2103,7 @@ static bool manage_workers(struct worker *worker)
 	struct worker_pool *pool = worker->pool;
 	bool ret = false;
 
-	if (!mutex_trylock(&pool->manager_mutex))
+	if (pool->manager)
 		return ret;
 
 	pool->manager = worker;
@@ -2118,7 +2117,6 @@ static bool manage_workers(struct worker *worker)
 	ret |= maybe_create_worker(pool);
 	ret |= maybe_rebind_manager(worker);
 
-	mutex_unlock(&pool->manager_mutex);
 	pool->manager = NULL;
 
 	return ret;
@@ -3785,7 +3783,6 @@ static int __init init_workqueues(void)
 				    (unsigned long)pool);
 
 			pool->manager = NULL;
-			mutex_init(&pool->manager_mutex);
 			ida_init(&pool->worker_ida);
 		}
 	}
-- 
1.7.4.4

