Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755673Ab2IARpz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Sep 2012 13:45:55 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:59081 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753628Ab2IARod (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Sep 2012 13:44:33 -0400
X-IronPort-AV: E=Sophos;i="4.80,353,1344182400"; 
   d="scan'208";a="5764900"
From: Lai Jiangshan <laijs@cn.fujitsu.com>
To: Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>
Subject: [PATCH 06/10 V4] workqueue: simple clear WORKER_REBIND
Date: Sun, 2 Sep 2012 00:28:24 +0800
Message-Id: <1346516916-1991-7-git-send-email-laijs@cn.fujitsu.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1346516916-1991-1-git-send-email-laijs@cn.fujitsu.com>
References: <1346516916-1991-1-git-send-email-laijs@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/09/02 00:27:25,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/09/02 00:28:32,
	Serialize complete at 2012/09/02 00:28:32
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
index 55864d1..9466d91 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -1332,6 +1332,7 @@ static void idle_worker_rebind(struct worker *worker)
 {
 	/* CPU must be online at this point */
 	WARN_ON(!worker_maybe_bind_and_lock(worker));
+	worker_clr_flags(worker, WORKER_REBIND);
 	++worker->idle_rebind->ref_cnt;
 	if (!--worker->idle_rebind->idle_cnt)
 		complete(&worker->idle_rebind->idle_done);
@@ -1420,7 +1421,7 @@ retry:
 	/* set REBIND and kick idle ones, we'll wait for these later */
 	for_each_worker_pool(pool, gcwq) {
 		list_for_each_entry(worker, &pool->idle_list, entry) {
-			if (worker->flags & WORKER_REBIND)
+			if (!(worker->flags & WORKER_UNBOUND))
 				continue;
 
 			/* morph UNBOUND to REBIND */
@@ -1443,16 +1444,6 @@ retry:
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

