Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754030Ab2H0R7H (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Aug 2012 13:59:07 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:17857 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753963Ab2H0R5p (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Aug 2012 13:57:45 -0400
X-IronPort-AV: E=Sophos;i="4.77,837,1336320000"; 
   d="scan'208";a="5733847"
From: Lai Jiangshan <laijs@cn.fujitsu.com>
To: Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>
Subject: [PATCH 2/7] workqueue: simple clear WORKER_REBIND
Date: Tue, 28 Aug 2012 01:58:22 +0800
Message-Id: <1346090307-3020-3-git-send-email-laijs@cn.fujitsu.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1346090307-3020-1-git-send-email-laijs@cn.fujitsu.com>
References: <1346090307-3020-1-git-send-email-laijs@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/08/28 01:57:33,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/08/28 01:57:34,
	Serialize complete at 2012/08/28 01:57:34
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
index 5872c31..90ada8f 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -1316,6 +1316,7 @@ static void idle_worker_rebind(struct worker *worker)
 {
 	/* CPU must be online at this point */
 	WARN_ON(!worker_maybe_bind_and_lock(worker));
+	worker_clr_flags(worker, WORKER_REBIND);
 	if (!--worker->idle_rebind->cnt)
 		complete(&worker->idle_rebind->done);
 	spin_unlock_irq(&worker->pool->gcwq->lock);
@@ -1393,7 +1394,7 @@ retry:
 	/* set REBIND and kick idle ones, we'll wait for these later */
 	for_each_worker_pool(pool, gcwq) {
 		list_for_each_entry(worker, &pool->idle_list, entry) {
-			if (worker->flags & WORKER_REBIND)
+			if (!(worker->flags & WORKER_UNBOUND))
 				continue;
 
 			/* morph UNBOUND to REBIND */
@@ -1416,16 +1417,6 @@ retry:
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
 	/* rebind busy workers */
 	for_each_busy_worker(worker, i, pos, gcwq) {
 		struct work_struct *rebind_work = &worker->rebind_work;
-- 
1.7.4.4

