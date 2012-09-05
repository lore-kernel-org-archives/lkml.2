Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758672Ab2IEKhl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2012 06:37:41 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:18290 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1758491Ab2IEKgS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2012 06:36:18 -0400
X-IronPort-AV: E=Sophos;i="4.80,373,1344182400"; 
   d="scan'208";a="5789514"
From: Lai Jiangshan <laijs@cn.fujitsu.com>
To: Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>
Subject: [PATCH 08/11 V5] workqueue: unbind newly created worker
Date: Wed, 5 Sep 2012 18:37:45 +0800
Message-Id: <1346841475-4422-9-git-send-email-laijs@cn.fujitsu.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1346841475-4422-1-git-send-email-laijs@cn.fujitsu.com>
References: <1346841475-4422-1-git-send-email-laijs@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/09/05 18:35:50,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/09/05 18:35:51,
	Serialize complete at 2012/09/05 18:35:51
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

unbind newly created worker when manager is unbound.

It just prepares, this code is useless until
"we unbind/rebind without manager_mutex"

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
---
 kernel/workqueue.c |   23 ++++++++++++++++++++++-
 1 files changed, 22 insertions(+), 1 deletions(-)

diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index e9fc065..223d128 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -74,6 +74,8 @@ enum {
 	WORKER_NOT_RUNNING	= WORKER_PREP | WORKER_UNBOUND |
 				  WORKER_CPU_INTENSIVE,
 
+	WORKER_COPY_FLAGS	= WORKER_UNBOUND,
+
 	NR_WORKER_POOLS		= 2,		/* # worker pools per gcwq */
 
 	BUSY_WORKER_HASH_ORDER	= 6,		/* 64 pointers */
@@ -1820,6 +1822,25 @@ static void start_worker(struct worker *worker)
 }
 
 /**
+ * manager_start_worker - start a newly created worker by manager
+ * @worker: worker to start
+ * @manager: the manager
+ *
+ * Make the gcwq aware of @worker and start it.
+ * Fix the newly created worker's binding.
+ *
+ * CONTEXT:
+ * spin_lock_irq(gcwq->lock).
+ */
+static void manager_start_worker(struct worker *worker, struct worker *manager)
+{
+	start_worker(worker);
+
+	/* copy the flags. also unbind the worker if the manager is unbound */
+	worker->flags |= manager->flags & WORKER_COPY_FLAGS;
+}
+
+/**
  * destroy_worker - destroy a workqueue worker
  * @worker: worker to be destroyed
  *
@@ -1976,7 +1997,7 @@ restart:
 		if (worker) {
 			del_timer_sync(&pool->mayday_timer);
 			spin_lock_irq(&gcwq->lock);
-			start_worker(worker);
+			manager_start_worker(worker, pool->manager);
 			BUG_ON(need_to_create_worker(pool));
 			return true;
 		}
-- 
1.7.4.4

