Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753224Ab2IJRLT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2012 13:11:19 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:49024 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751947Ab2IJRLS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2012 13:11:18 -0400
Date: Mon, 10 Sep 2012 10:11:13 -0700
From: Tejun Heo <tj@kernel.org>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH wq/for-3.6-fixes 2/2] workqueue: fix possible idle worker
 depletion across CPU hotplug
Message-ID: <20120910171113.GB14103@google.com>
References: <1347243085-2510-1-git-send-email-laijs@cn.fujitsu.com>
 <1347243085-2510-2-git-send-email-laijs@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1347243085-2510-2-git-send-email-laijs@cn.fujitsu.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From ee378aa49b594da9bda6a2c768cc5b2ad585f911 Mon Sep 17 00:00:00 2001
From: Lai Jiangshan <laijs@cn.fujitsu.com>
Date: Mon, 10 Sep 2012 10:03:44 -0700

To simplify both normal and CPU hotplug paths, worker management is
prevented while CPU hoplug is in progress.  This is achieved by CPU
hotplug holding the same exclusion mechanism used by workers to ensure
there's only one manager per pool.

If someone else seems to be performing the manager role, workers
proceed to execute work items.  CPU hotplug using the same mechanism
can lead to idle worker depletion because all workers could proceed to
execute work items while CPU hotplug is in progress and CPU hotplug
itself wouldn't actually perform the worker management duty - it
doesn't guarantee that there's an idle worker left when it releases
management.

This idle worker depletion, under extreme circumstances, can break
forward-progress guarantee and thus lead to deadlock.

This patch fixes the bug by using separate mechanisms for manager
exclusion among workers and hotplug exclusion.  For manager exclusion,
POOL_MANAGING_WORKERS which was restored by the previous patch is
used.  pool->manager_mutex is now only used for exclusion between the
elected manager and CPU hotplug.  The elected manager won't proceed
without holding pool->manager_mutex.

This ensures that the worker which won the manager position can't skip
managing while CPU hotplug is in progress.  It will block on
manager_mutex and perform management after CPU hotplug is complete.

Note that hotplug may happen while waiting for manager_mutex.  A
manager isn't either on idle or busy list and thus the hoplug code
can't unbind/rebind it.  Make the manager handle its own un/rebinding.

tj: Updated comment and description.

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
Signed-off-by: Tejun Heo <tj@kernel.org>
---
Applied to wq/for-3.6-fixes w/ comment and patch description updated.
Sorry about hacking up your comment / description but this is a tricky
issue and I thought a bit more verbosity is a good idea.

Thanks a lot for fixing the issue and the persistence!

 kernel/workqueue.c |   37 ++++++++++++++++++++++++++++++++++++-
 1 files changed, 36 insertions(+), 1 deletions(-)

diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index 383548e..1e1373b 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -1825,10 +1825,45 @@ static bool manage_workers(struct worker *worker)
 	struct worker_pool *pool = worker->pool;
 	bool ret = false;
 
-	if (!mutex_trylock(&pool->manager_mutex))
+	if (pool->flags & POOL_MANAGING_WORKERS)
 		return ret;
 
 	pool->flags |= POOL_MANAGING_WORKERS;
+
+	/*
+	 * To simplify both worker management and CPU hotplug, hold off
+	 * management while hotplug is in progress.  CPU hotplug path can't
+	 * grab %POOL_MANAGING_WORKERS to achieve this because that can
+	 * lead to idle worker depletion (all become busy thinking someone
+	 * else is managing) which in turn can result in deadlock under
+	 * extreme circumstances.  Use @pool->manager_mutex to synchronize
+	 * manager against CPU hotplug.
+	 *
+	 * manager_mutex would always be free unless CPU hotplug is in
+	 * progress.  trylock first without dropping @gcwq->lock.
+	 */
+	if (unlikely(!mutex_trylock(&pool->manager_mutex))) {
+		spin_unlock_irq(&pool->gcwq->lock);
+		mutex_lock(&pool->manager_mutex);
+		/*
+		 * CPU hotplug could have happened while we were waiting
+		 * for manager_mutex.  Hotplug itself can't handle us
+		 * because manager isn't either on idle or busy list, and
+		 * @gcwq's state and ours could have deviated.
+		 *
+		 * As hotplug is now excluded via manager_mutex, we can
+		 * simply try to bind.  It will succeed or fail depending
+		 * on @gcwq's current state.  Try it and adjust
+		 * %WORKER_UNBOUND accordingly.
+		 */
+		if (worker_maybe_bind_and_lock(worker))
+			worker->flags &= ~WORKER_UNBOUND;
+		else
+			worker->flags |= WORKER_UNBOUND;
+
+		ret = true;
+	}
+
 	pool->flags &= ~POOL_MANAGE_WORKERS;
 
 	/*
-- 
1.7.7.3

