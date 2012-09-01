Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755288Ab2IARp6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Sep 2012 13:45:58 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:3195 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753181Ab2IARod (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Sep 2012 13:44:33 -0400
X-IronPort-AV: E=Sophos;i="4.80,353,1344182400"; 
   d="scan'208";a="5764899"
From: Lai Jiangshan <laijs@cn.fujitsu.com>
To: Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>
Subject: [PATCH 08/10 V4] workqueue: explicit way to wait for idles workers to finish
Date: Sun, 2 Sep 2012 00:28:26 +0800
Message-Id: <1346516916-1991-9-git-send-email-laijs@cn.fujitsu.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1346516916-1991-1-git-send-email-laijs@cn.fujitsu.com>
References: <1346516916-1991-1-git-send-email-laijs@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/09/02 00:27:26,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/09/02 00:28:32,
	Serialize complete at 2012/09/02 00:28:32
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

busy_worker_rebind_fn() can't return until all idle workers are rebound.
This order is ensured by rebind_workers() currently.

We use synchronize_all_idles_rebound() to wait for all idle workers
to be rebound. this is an explicit way and it will ease the pain of
the rebind_workers().

The sleeping synchronize_all_idles_rebound() must be called before
the WORKER_REBIND has been cleared.

It adds a small overhead to the unlikely path.

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
---
 kernel/workqueue.c |   16 +++++++++++++++-
 1 files changed, 15 insertions(+), 1 deletions(-)

diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index c875951..16bcd84 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -1387,9 +1387,23 @@ static void busy_worker_rebind_fn(struct work_struct *work)
 {
 	struct worker *worker = container_of(work, struct worker, rebind_work);
 	struct global_cwq *gcwq = worker->pool->gcwq;
+	struct idle_rebind *idle_rebind;
+
+	if (worker_maybe_bind_and_lock(worker)) {
+		/* Is idle-rebinding still in progress? */
+		if ((idle_rebind = gcwq->idle_rebind) != NULL) {
+			/* get reference */
+			BUG_ON(idle_rebind->ref_cnt <= 0);
+			idle_rebind->ref_cnt++;
+			spin_unlock_irq(&gcwq->lock);
+
+			synchronize_all_idles_rebound(gcwq, idle_rebind);
+
+			spin_lock_irq(&gcwq->lock);
+		}
 
-	if (worker_maybe_bind_and_lock(worker))
 		worker_clr_flags(worker, WORKER_REBIND);
+	}
 
 	spin_unlock_irq(&gcwq->lock);
 }
-- 
1.7.4.4

