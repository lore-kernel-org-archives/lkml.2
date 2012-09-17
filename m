Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932192Ab2IQPox (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2012 11:44:53 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:57880 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1756762Ab2IQPow (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2012 11:44:52 -0400
X-IronPort-AV: E=Sophos;i="4.80,437,1344182400"; 
   d="scan'208";a="5859716"
From: Lai Jiangshan <laijs@cn.fujitsu.com>
To: Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>
Subject: [V2 for-3.6-fixes PATCH 1/7] workqueue: clear WORKER_REBIND unconditionaly in busy_worker_rebind_fn()
Date: Mon, 17 Sep 2012 23:46:42 +0800
Message-Id: <1347896808-2398-2-git-send-email-laijs@cn.fujitsu.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1347896808-2398-1-git-send-email-laijs@cn.fujitsu.com>
References: <1347896808-2398-1-git-send-email-laijs@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/09/17 23:45:05,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/09/17 23:45:06,
	Serialize complete at 2012/09/17 23:45:06
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We must clear this WORKER_REBIND before busy_worker_rebind_fn() returns,
otherise the worker may go to call idle_worker_rebind() wrongly, which
may access to the invalid ->idle_rebind and sleep forever in ->rebind_hold.

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
---
 kernel/workqueue.c |   16 ++++++++++++----
 1 files changed, 12 insertions(+), 4 deletions(-)

diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index 7b91332..cc49593 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -1655,8 +1655,17 @@ static void busy_worker_rebind_fn(struct work_struct *work)
 	struct worker *worker = container_of(work, struct worker, rebind_work);
 	struct global_cwq *gcwq = worker->pool->gcwq;
 
-	if (worker_maybe_bind_and_lock(worker))
-		worker_clr_flags(worker, WORKER_REBIND);
+	worker_maybe_bind_and_lock(worker);
+
+	/*
+	 * If hotplug has happened after rebind_workers(), a new %UNBOUND will
+	 * have been set in worker->flags, so we can clear WORKER_REBIND
+	 * unconditionaly(even the above worker_maybe_bind_and_lock() failed).
+	 *
+	 * And we must clear this WORKER_REBIND before return, otherwise
+	 * this worker may go to call idle_worker_rebind() wrongly.
+	 */
+	worker_clr_flags(worker, WORKER_REBIND);
 
 	spin_unlock_irq(&gcwq->lock);
 }
@@ -2362,8 +2371,7 @@ woke_up:
 	spin_lock_irq(&gcwq->lock);
 
 	/*
-	 * DIE can be set only while idle and REBIND set while busy has
-	 * @worker->rebind_work scheduled.  Checking here is enough.
+	 * DIE or REBIND can be set only while idle.  Checking here is enough.
 	 */
 	if (unlikely(worker->flags & (WORKER_REBIND | WORKER_DIE))) {
 		spin_unlock_irq(&gcwq->lock);
-- 
1.7.4.4

