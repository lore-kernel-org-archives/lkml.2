Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754170Ab2IHRLl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Sep 2012 13:11:41 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:18308 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752657Ab2IHRLW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Sep 2012 13:11:22 -0400
X-IronPort-AV: E=Sophos;i="4.80,392,1344182400"; 
   d="scan'208";a="5807479"
From: Lai Jiangshan <laijs@cn.fujitsu.com>
To: Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>
Subject: [PATCH 6/7 V6] workqueue: new day don't need WORKER_REBIND for busy rebinding
Date: Sun, 9 Sep 2012 01:12:55 +0800
Message-Id: <1347124383-18723-7-git-send-email-laijs@cn.fujitsu.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1347124383-18723-1-git-send-email-laijs@cn.fujitsu.com>
References: <1347124383-18723-1-git-send-email-laijs@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/09/09 01:10:48,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/09/09 01:10:48,
	Serialize complete at 2012/09/09 01:10:48
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

because old busy_worker_rebind_fn() have to wait until all idle worker finish.
so we have to use two flags WORKER_UNBOUND and WORKER_REBIND to avoid
prematurely clear all NOT_RUNNING bit when highly frequent offline/online.

but current code don't need to wait idle workers. so we don't need to
use two flags, just one is enough. remove WORKER_REBIND from busy rebinding.

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
---
 kernel/workqueue.c |    9 +--------
 1 files changed, 1 insertions(+), 8 deletions(-)

diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index d9765c4..4863162 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -1639,7 +1639,7 @@ static void busy_worker_rebind_fn(struct work_struct *work)
 	struct global_cwq *gcwq = worker->pool->gcwq;
 
 	if (worker_maybe_bind_and_lock(worker))
-		worker_clr_flags(worker, WORKER_REBIND);
+		worker_clr_flags(worker, WORKER_UNBOUND);
 
 	spin_unlock_irq(&gcwq->lock);
 }
@@ -1692,13 +1692,6 @@ static void rebind_workers(struct global_cwq *gcwq)
 	for_each_busy_worker(worker, i, pos, gcwq) {
 		struct work_struct *rebind_work = &worker->rebind_work;
 		struct workqueue_struct *wq;
-		unsigned long worker_flags = worker->flags;
-
-		/* morph UNBOUND to REBIND */
-		worker_flags &= ~WORKER_UNBOUND;
-		worker_flags |= WORKER_REBIND;
-		/* ensure the wq_worker_sleeping() see the right flags */
-		ACCESS_ONCE(worker->flags) = worker_flags;
 
 		if (test_and_set_bit(WORK_STRUCT_PENDING_BIT,
 				     work_data_bits(rebind_work)))
-- 
1.7.4.4

