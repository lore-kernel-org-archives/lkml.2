Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754083Ab2H0R5t (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Aug 2012 13:57:49 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:6203 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753988Ab2H0R5p (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Aug 2012 13:57:45 -0400
X-IronPort-AV: E=Sophos;i="4.77,837,1336320000"; 
   d="scan'208";a="5733848"
From: Lai Jiangshan <laijs@cn.fujitsu.com>
To: Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>
Subject: [PATCH 4/7] workqueue: single pass rebind_workers
Date: Tue, 28 Aug 2012 01:58:24 +0800
Message-Id: <1346090307-3020-5-git-send-email-laijs@cn.fujitsu.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1346090307-3020-1-git-send-email-laijs@cn.fujitsu.com>
References: <1346090307-3020-1-git-send-email-laijs@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/08/28 01:57:34,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/08/28 01:57:34,
	Serialize complete at 2012/08/28 01:57:34
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

busy_worker_rebind_fn() can't return until all idle workers are rebound,
the code of busy_worker_rebind_fn() ensure this.

So we can change the order of the code of rebind_workers(),
and make it a single pass do the rebind_workers().

It makes the code much clean and better readability.

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
---
 kernel/workqueue.c |   19 +++++++------------
 1 files changed, 7 insertions(+), 12 deletions(-)

diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index f6e4394..96485c0 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -1394,16 +1394,12 @@ static void rebind_workers(struct global_cwq *gcwq)
 	 * us to finish up by competing on pool->manager_mutex.
 	 */
 	init_completion(&idle_rebind.done);
-retry:
 	idle_rebind.cnt = 1;
 	INIT_COMPLETION(idle_rebind.done);
 
 	/* set REBIND and kick idle ones, we'll wait for these later */
 	for_each_worker_pool(pool, gcwq) {
 		list_for_each_entry(worker, &pool->idle_list, entry) {
-			if (!(worker->flags & WORKER_UNBOUND))
-				continue;
-
 			/* morph UNBOUND to REBIND */
 			worker->flags &= ~WORKER_UNBOUND;
 			worker->flags |= WORKER_REBIND;
@@ -1416,14 +1412,6 @@ retry:
 		}
 	}
 
-	if (--idle_rebind.cnt) {
-		spin_unlock_irq(&gcwq->lock);
-		wait_for_completion(&idle_rebind.done);
-		spin_lock_irq(&gcwq->lock);
-		/* busy ones might have become idle while waiting, retry */
-		goto retry;
-	}
-
 	/* rebind busy workers */
 	for_each_busy_worker(worker, i, pos, gcwq) {
 		struct work_struct *rebind_work = &worker->rebind_work;
@@ -1442,6 +1430,13 @@ retry:
 			    worker->scheduled.next,
 			    work_color_to_flags(WORK_NO_COLOR));
 	}
+
+	/* waiting for all idle workers to be rebound */
+	if (--idle_rebind.cnt) {
+		spin_unlock_irq(&gcwq->lock);
+		wait_for_completion(&idle_rebind.done);
+		spin_lock_irq(&gcwq->lock);
+	}
 }
 
 static struct worker *alloc_worker(void)
-- 
1.7.4.4

