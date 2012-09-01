Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755691Ab2IARp5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Sep 2012 13:45:57 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:52044 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1755428Ab2IARod (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Sep 2012 13:44:33 -0400
X-IronPort-AV: E=Sophos;i="4.80,353,1344182400"; 
   d="scan'208";a="5764901"
From: Lai Jiangshan <laijs@cn.fujitsu.com>
To: Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>
Subject: [PATCH 03/10 V4] workqueue: add POOL_MANAGING_WORKERS
Date: Sun, 2 Sep 2012 00:28:21 +0800
Message-Id: <1346516916-1991-4-git-send-email-laijs@cn.fujitsu.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1346516916-1991-1-git-send-email-laijs@cn.fujitsu.com>
References: <1346516916-1991-1-git-send-email-laijs@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/09/02 00:27:25,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/09/02 00:28:31,
	Serialize complete at 2012/09/02 00:28:31
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
index 1bfe407..979ef4f 100644
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
 
@@ -1836,6 +1837,7 @@ static bool manage_workers(struct worker *worker)
 		return ret;
 
 	pool->flags &= ~POOL_MANAGE_WORKERS;
+	pool->flags |= POOL_MANAGING_WORKERS;
 
 	/*
 	 * Destroy and then create so that may_start_working() is true
@@ -1844,6 +1846,7 @@ static bool manage_workers(struct worker *worker)
 	ret |= maybe_destroy_workers(pool);
 	ret |= maybe_create_worker(pool);
 
+	pool->flags &= ~POOL_MANAGING_WORKERS;
 	mutex_unlock(&pool->manager_mutex);
 	return ret;
 }
-- 
1.7.4.4

