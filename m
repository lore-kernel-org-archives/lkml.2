Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754281Ab2H2Qug (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Aug 2012 12:50:36 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:60837 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1754206Ab2H2Qub (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Aug 2012 12:50:31 -0400
X-IronPort-AV: E=Sophos;i="4.80,335,1344182400"; 
   d="scan'208";a="5748913"
From: Lai Jiangshan <laijs@cn.fujitsu.com>
To: Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>
Subject: [PATCH 6/9 V3] workqueue: simple clear WORKER_REBIND
Date: Thu, 30 Aug 2012 00:51:57 +0800
Message-Id: <1346259120-6216-7-git-send-email-laijs@cn.fujitsu.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1346259120-6216-1-git-send-email-laijs@cn.fujitsu.com>
References: <1346259120-6216-1-git-send-email-laijs@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/08/30 00:50:15,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/08/30 00:50:15,
	Serialize complete at 2012/08/30 00:50:15
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

WORKER_REBIND is not used for other purpose,
idle_worker_rebind() can directly clear it.

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
---
 kernel/workqueue.c |   13 ++-----------
 1 files changed, 2 insertions(+), 11 deletions(-)

diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index eeb5752..d88aa2e 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -1350,6 +1350,7 @@ static void idle_worker_rebind(struct worker *worker)
 {
 	/* CPU must be online at this point */
 	WARN_ON(!worker_maybe_bind_and_lock(worker));
+	worker_clr_flags(worker, WORKER_REBIND);
 	if (!--worker->idle_rebind->idle_cnt)
 		complete(&worker->idle_rebind->idle_done);
 	spin_unlock_irq(&worker->pool->gcwq->lock);
@@ -1437,7 +1438,7 @@ retry:
 	/* set REBIND and kick idle ones, we'll wait for these later */
 	for_each_worker_pool(pool, gcwq) {
 		list_for_each_entry(worker, &pool->idle_list, entry) {
-			if (worker->flags & WORKER_REBIND)
+			if (!(worker->flags & WORKER_UNBOUND))
 				continue;
 
 			/* morph UNBOUND to REBIND */
@@ -1461,16 +1462,6 @@ retry:
 		goto retry;
 	}
 
-	/*
-	 * All idle workers are rebound and waiting for %WORKER_REBIND to
-	 * be cleared inside idle_worker_rebind().  Clear and release.
-	 * Clearing %WORKER_REBIND from this foreign context is safe
-	 * because these workers are still guaranteed to be idle.
-	 */
-	for_each_worker_pool(pool, gcwq)
-		list_for_each_entry(worker, &pool->idle_list, entry)
-			worker->flags &= ~WORKER_REBIND;
-
 	complete_all(&idle_rebind.rebind_hold);
 
 	/* rebind busy workers */
-- 
1.7.4.4

