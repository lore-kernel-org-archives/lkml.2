Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755644Ab2IARpw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Sep 2012 13:45:52 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:3195 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752721Ab2IARoe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Sep 2012 13:44:34 -0400
X-IronPort-AV: E=Sophos;i="4.80,353,1344182400"; 
   d="scan'208";a="5764902"
From: Lai Jiangshan <laijs@cn.fujitsu.com>
To: Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>
Subject: [PATCH 09/10] workqueue: single pass rebind_workers
Date: Sun, 2 Sep 2012 00:28:27 +0800
Message-Id: <1346516916-1991-10-git-send-email-laijs@cn.fujitsu.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1346516916-1991-1-git-send-email-laijs@cn.fujitsu.com>
References: <1346516916-1991-1-git-send-email-laijs@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/09/02 00:27:26,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/09/02 00:28:33,
	Serialize complete at 2012/09/02 00:28:33
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

busy_worker_rebind_fn() can't return until all idle workers are rebound,
the code of busy_worker_rebind_fn() ensure this.

So we can change the order of the code of rebind_workers(),
and make it is a single pass to do the rebind_workers().

It makes the code much clean and better readability(still need later patch
to improve the readability)

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
---
 kernel/workqueue.c |   23 ++++++++---------------
 1 files changed, 8 insertions(+), 15 deletions(-)

diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index 16bcd84..6d68571 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -1458,16 +1458,11 @@ static void rebind_workers(struct global_cwq *gcwq)
 	init_completion(&idle_rebind.ref_done);
 	idle_rebind.ref_cnt = 1;
 	gcwq->idle_rebind = &idle_rebind;
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
@@ -1479,16 +1474,6 @@ retry:
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
@@ -1515,6 +1500,14 @@ retry:
 	 * we will leave rebind_workers(), have to wait until no worker
 	 * has ref to this idle_rebind.
 	 */
+	if (--idle_rebind.idle_cnt) {
+		spin_unlock_irq(&gcwq->lock);
+		wait_for_completion(&idle_rebind.idle_done);
+		spin_lock_irq(&gcwq->lock);
+	}
+
+	complete_all(&idle_rebind.rebind_hold);
+
 	if (--idle_rebind.ref_cnt) {
 		spin_unlock_irq(&gcwq->lock);
 		wait_for_completion(&idle_rebind.ref_done);
-- 
1.7.4.4

