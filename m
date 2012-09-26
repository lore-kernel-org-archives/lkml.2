Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757809Ab2IZRTF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2012 13:19:05 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:59288 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1757637Ab2IZRSr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2012 13:18:47 -0400
X-IronPort-AV: E=Sophos;i="4.80,492,1344182400"; 
   d="scan'208";a="5922250"
From: Lai Jiangshan <laijs@cn.fujitsu.com>
To: Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>
Subject: [PATCH 06/12] workqueue: destroy_worker() can only destory idle worker not just created worker
Date: Thu, 27 Sep 2012 01:20:37 +0800
Message-Id: <1348680043-5077-7-git-send-email-laijs@cn.fujitsu.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1348680043-5077-1-git-send-email-laijs@cn.fujitsu.com>
References: <1348680043-5077-1-git-send-email-laijs@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/09/27 01:18:45,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/09/27 01:18:46,
	Serialize complete at 2012/09/27 01:18:46
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

After we reimpletment hotplug code, we will not destroy just newly
created worker, all created worker will enter idle soon.
And destroy_worker() is not used to destroy just newly created worker,
it always destory idle worker, so we need to fix destroy_worker()
and update the comments.

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
---
 kernel/workqueue.c |   14 +++++++-------
 1 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index 6c339bf..fe3b1d3 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -1756,8 +1756,7 @@ static struct worker *alloc_worker(void)
  * @pool: pool the new worker will belong to
  *
  * Create a new worker which is bound to @pool.  The returned worker
- * can be started by calling start_worker() or destroyed using
- * destroy_worker().
+ * can be started by calling start_worker();
  *
  * CONTEXT:
  * Might sleep.  Does GFP_KERNEL allocations.
@@ -1847,7 +1846,7 @@ static void start_worker(struct worker *worker)
 }
 
 /**
- * destroy_worker - destroy a workqueue worker
+ * destroy_worker - destroy a idle workqueue worker
  * @worker: worker to be destroyed
  *
  * Destroy @worker and adjust @gcwq stats accordingly.
@@ -1864,11 +1863,12 @@ static void destroy_worker(struct worker *worker)
 	/* sanity check frenzy */
 	BUG_ON(worker->current_work);
 	BUG_ON(!list_empty(&worker->scheduled));
+	BUG_ON(!(worker->flags & WORKER_STARTED));
+	BUG_ON(!(worker->flags & WORKER_IDLE));
+	BUG_ON(list_empty(&worker->entry));
 
-	if (worker->flags & WORKER_STARTED)
-		pool->nr_workers--;
-	if (worker->flags & WORKER_IDLE)
-		pool->nr_idle--;
+	pool->nr_workers--;
+	pool->nr_idle--;
 
 	list_del_init(&worker->entry);
 	worker->flags |= WORKER_DIE;
-- 
1.7.7.6

