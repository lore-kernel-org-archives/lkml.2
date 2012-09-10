Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752962Ab2IJRJA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2012 13:09:00 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:52771 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752095Ab2IJRI7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2012 13:08:59 -0400
Date: Mon, 10 Sep 2012 10:08:54 -0700
From: Tejun Heo <tj@kernel.org>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH wq/for-3.6-fixes 1/2] workqueue: restore
 POOL_MANAGING_WORKERS
Message-ID: <20120910170854.GA14103@google.com>
References: <1347243085-2510-1-git-send-email-laijs@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1347243085-2510-1-git-send-email-laijs@cn.fujitsu.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 552a37e9360a293cd20e7f8ff1fb326a244c5f1e Mon Sep 17 00:00:00 2001
From: Lai Jiangshan <laijs@cn.fujitsu.com>
Date: Mon, 10 Sep 2012 10:03:33 -0700

This patch restores POOL_MANAGING_WORKERS which was replaced by
pool->manager_mutex by 6037315269 "workqueue: use mutex for global_cwq
manager exclusion".

There's a subtle idle worker depletion bug across CPU hotplug events
and we need to distinguish an actual manager and CPU hotplug
preventing management.  POOL_MANAGING_WORKERS will be used for the
former and manager_mutex the later.

This patch just lays POOL_MANAGING_WORKERS on top of the existing
manager_mutex and doesn't introduce any synchronization changes.  The
next patch will update it.

Note that this patch fixes a non-critical anomaly where
too_many_workers() may return %true spuriously while CPU hotplug is in
progress.  While the issue could schedule idle timer spuriously, it
didn't trigger any actual misbehavior.

tj: Rewrote patch description.

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
Signed-off-by: Tejun Heo <tj@kernel.org>
---
Applied to wq/for-3.6-fixes with rewritten patch description to
explain why it's being restored (to fix idle worker depletion across
CPU hotplug).

Thanks!

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
1.7.7.3

