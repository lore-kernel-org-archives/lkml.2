Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932081Ab2IJCJi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Sep 2012 22:09:38 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:58940 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1756352Ab2IJCJg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Sep 2012 22:09:36 -0400
X-IronPort-AV: E=Sophos;i="4.80,396,1344182400"; 
   d="scan'208";a="5810270"
From: Lai Jiangshan <laijs@cn.fujitsu.com>
To: Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>
Subject: [PATCH 1/2 V7 for-3.6-fixes] workqueue: add POOL_MANAGING_WORKERS
Date: Mon, 10 Sep 2012 10:11:24 +0800
Message-Id: <1347243085-2510-1-git-send-email-laijs@cn.fujitsu.com>
X-Mailer: git-send-email 1.7.4.4
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/09/10 10:09:04,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/09/10 10:09:05,
	Serialize complete at 2012/09/10 10:09:05
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When hotplug happens, the plug code will also grab the manager_mutex,
it will break too_many_workers()'s assumption, and make too_many_workers()
ugly(kick the timer wrongly, no found bug).

To avoid assumption-coruption, we add the original POOL_MANAGING_WORKERS back.

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
---
 kernel/workqueue.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index dc7b845..383548e 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -66,6 +66,7 @@ enum {
 
 	/* pool flags */
 	POOL_MANAGE_WORKERS	= 1 << 0,	/* need to manage workers */
+	POOL_MANAGING_WORKERS   = 1 << 1,       /* managing workers */
 
 	/* worker flags */
 	WORKER_STARTED		= 1 << 0,	/* started */
@@ -652,7 +653,7 @@ static bool need_to_manage_workers(struct worker_pool *pool)
 /* Do we have too many workers and should some go away? */
 static bool too_many_workers(struct worker_pool *pool)
 {
-	bool managing = mutex_is_locked(&pool->manager_mutex);
+	bool managing = pool->flags & POOL_MANAGING_WORKERS;
 	int nr_idle = pool->nr_idle + managing; /* manager is considered idle */
 	int nr_busy = pool->nr_workers - nr_idle;
 
@@ -1827,6 +1828,7 @@ static bool manage_workers(struct worker *worker)
 	if (!mutex_trylock(&pool->manager_mutex))
 		return ret;
 
+	pool->flags |= POOL_MANAGING_WORKERS;
 	pool->flags &= ~POOL_MANAGE_WORKERS;
 
 	/*
@@ -1836,6 +1838,7 @@ static bool manage_workers(struct worker *worker)
 	ret |= maybe_destroy_workers(pool);
 	ret |= maybe_create_worker(pool);
 
+	pool->flags &= ~POOL_MANAGING_WORKERS;
 	mutex_unlock(&pool->manager_mutex);
 	return ret;
 }
-- 
1.7.4.4

