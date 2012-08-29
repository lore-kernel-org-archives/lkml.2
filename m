Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754406Ab2H2Qup (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Aug 2012 12:50:45 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:30177 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1754211Ab2H2Quc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Aug 2012 12:50:32 -0400
X-IronPort-AV: E=Sophos;i="4.80,335,1344182400"; 
   d="scan'208";a="5748915"
From: Lai Jiangshan <laijs@cn.fujitsu.com>
To: Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>
Subject: [PATCH 8/9 V3] workqueue: single pass rebind_workers
Date: Thu, 30 Aug 2012 00:51:59 +0800
Message-Id: <1346259120-6216-9-git-send-email-laijs@cn.fujitsu.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1346259120-6216-1-git-send-email-laijs@cn.fujitsu.com>
References: <1346259120-6216-1-git-send-email-laijs@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/08/30 00:50:15,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/08/30 00:50:16,
	Serialize complete at 2012/08/30 00:50:16
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

busy_worker_rebind_fn() can't return until all idle workers are rebound,
the code of busy_worker_rebind_fn() ensure this.

So we can change the order of the code of rebind_workers(),
and make it is a single pass to do the rebind_workers().

It makes the code much clean and better readability.

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
---
 kernel/workqueue.c |   18 +++---------------
 1 files changed, 3 insertions(+), 15 deletions(-)

diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index 719d6ec..7e6145b 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -1437,16 +1437,11 @@ static void rebind_workers(struct global_cwq *gcwq)
 	init_completion(&idle_rebind.rebind_hold);
 	init_completion(&idle_rebind.ref_done);
 	idle_rebind.ref_cnt = 1;
-retry:
 	idle_rebind.idle_cnt = 1;
-	INIT_COMPLETION(idle_rebind.idle_done);
 
 	/* set REBIND and kick idle ones, we'll wait for these later */
 	for_each_worker_pool(pool, gcwq) {
 		list_for_each_entry(worker, &pool->idle_list, entry) {
-			if (!(worker->flags & WORKER_UNBOUND))
-				continue;
-
 			/* morph UNBOUND to REBIND */
 			worker->flags &= ~WORKER_UNBOUND;
 			worker->flags |= WORKER_REBIND;
@@ -1460,16 +1455,6 @@ retry:
 		}
 	}
 
-	if (--idle_rebind.idle_cnt) {
-		spin_unlock_irq(&gcwq->lock);
-		wait_for_completion(&idle_rebind.idle_done);
-		spin_lock_irq(&gcwq->lock);
-		/* busy ones might have become idle while waiting, retry */
-		goto retry;
-	}
-
-	complete_all(&idle_rebind.rebind_hold);
-
 	/* rebind busy workers */
 	for_each_busy_worker(worker, i, pos, gcwq) {
 		struct work_struct *rebind_work = &worker->rebind_work;
@@ -1497,7 +1482,10 @@ retry:
 	 * has ref to this idle_rebind.
 	 */
 	if (--idle_rebind.ref_cnt) {
+		--idle_rebind.idle_cnt;
 		spin_unlock_irq(&gcwq->lock);
+		wait_for_completion(&idle_rebind.idle_done);
+		complete_all(&idle_rebind.rebind_hold);
 		wait_for_completion(&idle_rebind.ref_done);
 		spin_lock_irq(&gcwq->lock);
 	}
-- 
1.7.4.4

