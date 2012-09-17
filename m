Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932243Ab2IQPpA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2012 11:45:00 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:57880 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1756847Ab2IQPox (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2012 11:44:53 -0400
X-IronPort-AV: E=Sophos;i="4.80,437,1344182400"; 
   d="scan'208";a="5859718"
From: Lai Jiangshan <laijs@cn.fujitsu.com>
To: Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>
Subject: [V2 for-next PATCH 3/7] workqueue: new day don't need WORKER_REBIND for busy rebinding
Date: Mon, 17 Sep 2012 23:46:44 +0800
Message-Id: <1347896808-2398-4-git-send-email-laijs@cn.fujitsu.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1347896808-2398-1-git-send-email-laijs@cn.fujitsu.com>
References: <1347896808-2398-1-git-send-email-laijs@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/09/17 23:45:06,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/09/17 23:45:06,
	Serialize complete at 2012/09/17 23:45:06
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

because old busy_worker_rebind_fn() have to wait until all idle worker finish.
so we have to use two flags WORKER_UNBOUND and WORKER_REBIND to avoid
prematurely clear all NOT_RUNNING bit when highly frequent offline/online.

but current code don't need to wait idle workers nor release gcwq->lock
when it is doing rebind in rebind_workers(), so we don't need to use two flags,
just one is enough. remove WORKER_REBIND from busy rebinding.

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
---
 kernel/workqueue.c |   19 ++-----------------
 1 files changed, 2 insertions(+), 17 deletions(-)

diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index dbc942e..6b643df 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -1642,17 +1642,8 @@ static void busy_worker_rebind_fn(struct work_struct *work)
 	struct worker *worker = container_of(work, struct worker, rebind_work);
 	struct global_cwq *gcwq = worker->pool->gcwq;
 
-	worker_maybe_bind_and_lock(worker);
-
-	/*
-	 * If hotplug has happened after rebind_workers(), a new %UNBOUND will
-	 * have been set in worker->flags, so we can clear WORKER_REBIND
-	 * unconditionaly(even the above worker_maybe_bind_and_lock() failed).
-	 *
-	 * And we must clear this WORKER_REBIND before return, otherwise
-	 * this worker may go to call idle_worker_rebind() wrongly.
-	 */
-	worker_clr_flags(worker, WORKER_REBIND);
+	if (worker_maybe_bind_and_lock(worker))
+		worker_clr_flags(worker, WORKER_UNBOUND);
 
 	spin_unlock_irq(&gcwq->lock);
 }
@@ -1727,15 +1718,9 @@ static void rebind_workers(struct global_cwq *gcwq)
 
 	/* rebind busy workers */
 	for_each_busy_worker(worker, i, pos, gcwq) {
-		unsigned long worker_flags = worker->flags;
 		struct work_struct *rebind_work = &worker->rebind_work;
 		struct workqueue_struct *wq;
 
-		/* morph UNBOUND to REBIND atomically */
-		worker_flags &= ~WORKER_UNBOUND;
-		worker_flags |= WORKER_REBIND;
-		ACCESS_ONCE(worker->flags) = worker_flags;
-
 		if (test_and_set_bit(WORK_STRUCT_PENDING_BIT,
 				     work_data_bits(rebind_work)))
 			continue;
-- 
1.7.4.4

