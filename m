Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753246Ab2IOIr2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Sep 2012 04:47:28 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:35845 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751608Ab2IOIp2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Sep 2012 04:45:28 -0400
X-IronPort-AV: E=Sophos;i="4.80,427,1344182400"; 
   d="scan'208";a="5850810"
From: Lai Jiangshan <laijs@cn.fujitsu.com>
To: Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>
Subject: [PATCH 2/6] workqueue: new day don't need WORKER_REBIND for busy rebinding
Date: Sat, 15 Sep 2012 16:13:35 +0800
Message-Id: <1347696825-24622-3-git-send-email-laijs@cn.fujitsu.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1347696825-24622-1-git-send-email-laijs@cn.fujitsu.com>
References: <1347696825-24622-1-git-send-email-laijs@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/09/15 16:12:50,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/09/15 16:12:52,
	Serialize complete at 2012/09/15 16:12:52
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
 kernel/workqueue.c |    8 +-------
 1 files changed, 1 insertions(+), 7 deletions(-)

diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index e8b28d6..4b1ff46 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -1641,7 +1641,7 @@ static void busy_worker_rebind_fn(struct work_struct *work)
 	struct global_cwq *gcwq = worker->pool->gcwq;
 
 	if (worker_maybe_bind_and_lock(worker))
-		worker_clr_flags(worker, WORKER_REBIND);
+		worker_clr_flags(worker, WORKER_UNBOUND);
 
 	spin_unlock_irq(&gcwq->lock);
 }
@@ -1696,15 +1696,9 @@ static void rebind_workers(struct global_cwq *gcwq)
 
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

