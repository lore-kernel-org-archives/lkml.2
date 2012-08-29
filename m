Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754301Ab2H2Quh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Aug 2012 12:50:37 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:20121 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1754207Ab2H2Qub (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Aug 2012 12:50:31 -0400
X-IronPort-AV: E=Sophos;i="4.80,335,1344182400"; 
   d="scan'208";a="5748914"
From: Lai Jiangshan <laijs@cn.fujitsu.com>
To: Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>
Subject: [PATCH 7/9 V3] workqueue: explicit way to wait for idles workers to finish
Date: Thu, 30 Aug 2012 00:51:58 +0800
Message-Id: <1346259120-6216-8-git-send-email-laijs@cn.fujitsu.com>
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

busy_worker_rebind_fn() can't return until all idle workers are rebound.
This order is ensured by rebind_workers() currently.

We use mutex_lock(&worker->pool->manager_mutex) to wait for all idle workers
to be rebound. this is an explicit way and it will ease the pain of
the rebind_workers().

The sleeping mutex_lock(&worker->pool->manager_mutex) must be put in the top of
busy_worker_rebind_fn(), because this busy worker thread can sleep
before the WORKER_REBIND is cleared, but can't sleep after
the WORKER_REBIND cleared.

It adds a small overhead to the unlikely path.

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
---
 kernel/workqueue.c |    8 +++++++-
 1 files changed, 7 insertions(+), 1 deletions(-)

diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index d88aa2e..719d6ec 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -1376,9 +1376,15 @@ static void busy_worker_rebind_fn(struct work_struct *work)
 	struct worker *worker = container_of(work, struct worker, rebind_work);
 	struct global_cwq *gcwq = worker->pool->gcwq;
 
+	/*
+	 * Waiting all idle workers are rebound by competing on
+	 * pool->manager_mutex.
+	 */
+	mutex_lock(&worker->pool->manager_mutex);
+
 	if (worker_maybe_bind_and_lock(worker))
 		worker_clr_flags(worker, WORKER_REBIND);
-
+	non_manager_role_manager_mutex_unlock(worker->pool);
 	spin_unlock_irq(&gcwq->lock);
 }
 
-- 
1.7.4.4

