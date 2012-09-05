Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758707Ab2IEKg5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2012 06:36:57 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:55811 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1758548Ab2IEKgS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2012 06:36:18 -0400
X-IronPort-AV: E=Sophos;i="4.80,373,1344182400"; 
   d="scan'208";a="5789515"
From: Lai Jiangshan <laijs@cn.fujitsu.com>
To: Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>
Subject: [PATCH 07/11 V5] workqueue: rebind manager
Date: Wed, 5 Sep 2012 18:37:44 +0800
Message-Id: <1346841475-4422-8-git-send-email-laijs@cn.fujitsu.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1346841475-4422-1-git-send-email-laijs@cn.fujitsu.com>
References: <1346841475-4422-1-git-send-email-laijs@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/09/05 18:35:50,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/09/05 18:35:51,
	Serialize complete at 2012/09/05 18:35:51
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Because the %UNBOUND bit of manager can't be cleared while it
is manage workers. maybe_rebind_manager() will be noticed and
will do rebind when needed.

It just prepares, this code is useless until
"we unbind/rebind without manager_mutex"

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
---
 kernel/workqueue.c |   23 +++++++++++++++++++++++
 1 files changed, 23 insertions(+), 0 deletions(-)

diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index 9f4dd20..e9fc065 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -1540,6 +1540,14 @@ static void worker_leave_idle(struct worker *worker)
 	list_del_init(&worker->entry);
 }
 
+/* Does this worker need to be rebound */
+static bool need_to_rebind_worker(struct worker *worker)
+{
+	bool assoc = !(worker->pool->gcwq->flags & GCWQ_DISASSOCIATED);
+
+	return assoc && (worker->flags & WORKER_UNBOUND);
+}
+
 /**
  * worker_maybe_bind_and_lock - bind worker to its cpu if possible and lock gcwq
  * @worker: self
@@ -2028,6 +2036,20 @@ static bool maybe_destroy_workers(struct worker_pool *pool)
 	return ret;
 }
 
+static bool maybe_rebind_manager(struct worker *manager)
+{
+	if (unlikely(need_to_rebind_worker(manager))) {
+		spin_unlock_irq(&manager->pool->gcwq->lock);
+
+		if (worker_maybe_bind_and_lock(manager))
+			worker_clr_flags(manager, WORKER_UNBOUND);
+
+		return true;
+	}
+
+	return false;
+}
+
 /**
  * manage_workers - manage worker pool
  * @worker: self
@@ -2065,6 +2087,7 @@ static bool manage_workers(struct worker *worker)
 	 */
 	ret |= maybe_destroy_workers(pool);
 	ret |= maybe_create_worker(pool);
+	ret |= maybe_rebind_manager(worker);
 
 	mutex_unlock(&pool->manager_mutex);
 	pool->manager = NULL;
-- 
1.7.4.4

