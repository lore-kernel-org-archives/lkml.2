Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758010Ab2IZRVV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2012 13:21:21 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:12456 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1757608Ab2IZRSm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2012 13:18:42 -0400
X-IronPort-AV: E=Sophos;i="4.80,492,1344182400"; 
   d="scan'208";a="5922248"
From: Lai Jiangshan <laijs@cn.fujitsu.com>
To: Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>
Subject: [PATCH 04/12] workqueue: simplify is_chained_work()
Date: Thu, 27 Sep 2012 01:20:35 +0800
Message-Id: <1348680043-5077-5-git-send-email-laijs@cn.fujitsu.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1348680043-5077-1-git-send-email-laijs@cn.fujitsu.com>
References: <1348680043-5077-1-git-send-email-laijs@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/09/27 01:18:45,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/09/27 01:18:45,
	Serialize complete at 2012/09/27 01:18:45
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

is_chained_work() is too complicated. we can simply found out
whether current task is worker by PF_WQ_WORKER or wq->rescuer.

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
---
 kernel/workqueue.c |   36 ++++++++++++------------------------
 1 files changed, 12 insertions(+), 24 deletions(-)

diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index e41c562..c718b94 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -1182,34 +1182,22 @@ static void insert_work(struct cpu_workqueue_struct *cwq,
 
 /*
  * Test whether @work is being queued from another work executing on the
- * same workqueue.  This is rather expensive and should only be used from
- * cold paths.
+ * same workqueue.
  */
 static bool is_chained_work(struct workqueue_struct *wq)
 {
-	unsigned long flags;
-	unsigned int cpu;
+	struct worker *worker = NULL;
 
-	for_each_gcwq_cpu(cpu) {
-		struct global_cwq *gcwq = get_gcwq(cpu);
-		struct worker *worker;
-		struct hlist_node *pos;
-		int i;
+	if (wq->rescuer && current == wq->rescuer->task) /* rescuer_thread() */
+		worker = wq->rescuer;
+	else if (current->flags & PF_WQ_WORKER) /* worker_thread() */
+		worker = kthread_data(current);
 
-		spin_lock_irqsave(&gcwq->lock, flags);
-		for_each_busy_worker(worker, i, pos, gcwq) {
-			if (worker->task != current)
-				continue;
-			spin_unlock_irqrestore(&gcwq->lock, flags);
-			/*
-			 * I'm @worker, no locking necessary.  See if @work
-			 * is headed to the same workqueue.
-			 */
-			return worker->current_cwq->wq == wq;
-		}
-		spin_unlock_irqrestore(&gcwq->lock, flags);
-	}
-	return false;
+	/*
+	 * I'm @worker, no locking necessary.  See if @work
+	 * is headed to the same workqueue.
+	 */
+	return worker && worker->current_cwq->wq == wq;
 }
 
 static void __queue_work(unsigned int cpu, struct workqueue_struct *wq,
@@ -1231,7 +1219,7 @@ static void __queue_work(unsigned int cpu, struct workqueue_struct *wq,
 
 	debug_work_activate(work);
 
-	/* if dying, only works from the same workqueue are allowed */
+	/* if draining, only works from the same workqueue are allowed */
 	if (unlikely(wq->flags & WQ_DRAINING) &&
 	    WARN_ON_ONCE(!is_chained_work(wq)))
 		return;
-- 
1.7.7.6

