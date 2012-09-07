Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757343Ab2IGUeW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2012 16:34:22 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:59648 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756915Ab2IGUeT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2012 16:34:19 -0400
Date: Fri, 7 Sep 2012 13:34:14 -0700
From: Tejun Heo <tj@kernel.org>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH wq/for-3.6-fixes 3/3] workqueue: fix possible idle
 worker depletion during CPU_ONLINE
Message-ID: <20120907203414.GI9426@google.com>
References: <20120906200647.GG29092@google.com>
 <20120906200723.GH29092@google.com>
 <20120906200802.GI29092@google.com>
 <504965AA.6090107@cn.fujitsu.com>
 <20120907192939.GF9426@google.com>
 <20120907202249.GH9426@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120907202249.GH9426@google.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 07, 2012 at 01:22:49PM -0700, Tejun Heo wrote:
> So, how about something like the following?
> 
> * Make manage_workers() called outside gcwq->lock (or drop gcwq->lock
>   after checking MANAGING).  worker_thread() can jump back to woke_up:
>   instead.
> 
> * Distinguish synchronization among workers and against hotplug.  Was
>   this what you tried with non_manager_mutex?  Anyways, revive
>   WORKER_MANAGING to synchronize among workers.  If the worker won
>   MANAGING, drop gcwq->lock and mutex_lock() gcwq->hotplug_mutex and
>   then do other stuff.
> 
> This should prevent any idle worker passing through manage_workers()
> while hotplug is in progress.  Do you think it would work?

Something like the following.  Completely untested.  What do you
think?

Thanks.

 kernel/workqueue.c |   63 ++++++++++++++++++++++++-----------------------------
 1 file changed, 29 insertions(+), 34 deletions(-)

diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index dc7b845..4c7502d 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -66,6 +66,7 @@ enum {
 
 	/* pool flags */
 	POOL_MANAGE_WORKERS	= 1 << 0,	/* need to manage workers */
+	POOL_MANAGING_WORKERS	= 1 << 1,
 
 	/* worker flags */
 	WORKER_STARTED		= 1 << 0,	/* started */
@@ -165,7 +166,7 @@ struct worker_pool {
 	struct timer_list	idle_timer;	/* L: worker idle timeout */
 	struct timer_list	mayday_timer;	/* L: SOS timer for workers */
 
-	struct mutex		manager_mutex;	/* mutex manager should hold */
+	struct mutex		hotplug_mutex;	/* mutex manager should hold */
 	struct ida		worker_ida;	/* L: for worker IDs */
 };
 
@@ -652,7 +653,7 @@ static bool need_to_manage_workers(struct worker_pool *pool)
 /* Do we have too many workers and should some go away? */
 static bool too_many_workers(struct worker_pool *pool)
 {
-	bool managing = mutex_is_locked(&pool->manager_mutex);
+	bool managing = pool->flags & POOL_MANAGING_WORKERS;
 	int nr_idle = pool->nr_idle + managing; /* manager is considered idle */
 	int nr_busy = pool->nr_workers - nr_idle;
 
@@ -1390,7 +1391,7 @@ static void rebind_workers(struct global_cwq *gcwq)
 	lockdep_assert_held(&gcwq->lock);
 
 	for_each_worker_pool(pool, gcwq)
-		lockdep_assert_held(&pool->manager_mutex);
+		lockdep_assert_held(&pool->hotplug_mutex);
 
 	/*
 	 * Rebind idle workers.  Interlocked both ways.  We wait for
@@ -1713,22 +1714,16 @@ static void gcwq_mayday_timeout(unsigned long __pool)
  * spin_lock_irq(gcwq->lock) which may be released and regrabbed
  * multiple times.  Does GFP_KERNEL allocations.  Called only from
  * manager.
- *
- * RETURNS:
- * false if no action was taken and gcwq->lock stayed locked, true
- * otherwise.
  */
-static bool maybe_create_worker(struct worker_pool *pool)
-__releases(&gcwq->lock)
-__acquires(&gcwq->lock)
+static void maybe_create_worker(struct worker_pool *pool)
 {
 	struct global_cwq *gcwq = pool->gcwq;
 
+	spin_lock_irq(&gcwq->lock);
 	if (!need_to_create_worker(pool))
-		return false;
+		goto out_unlock;
 restart:
 	spin_unlock_irq(&gcwq->lock);
-
 	/* if we don't make progress in MAYDAY_INITIAL_TIMEOUT, call for help */
 	mod_timer(&pool->mayday_timer, jiffies + MAYDAY_INITIAL_TIMEOUT);
 
@@ -1741,7 +1736,7 @@ restart:
 			spin_lock_irq(&gcwq->lock);
 			start_worker(worker);
 			BUG_ON(need_to_create_worker(pool));
-			return true;
+			goto out_unlock;
 		}
 
 		if (!need_to_create_worker(pool))
@@ -1758,7 +1753,8 @@ restart:
 	spin_lock_irq(&gcwq->lock);
 	if (need_to_create_worker(pool))
 		goto restart;
-	return true;
+out_unlock:
+	spin_unlock_irq(&gcwq->lock);
 }
 
 /**
@@ -1771,15 +1767,9 @@ restart:
  * LOCKING:
  * spin_lock_irq(gcwq->lock) which may be released and regrabbed
  * multiple times.  Called only from manager.
- *
- * RETURNS:
- * false if no action was taken and gcwq->lock stayed locked, true
- * otherwise.
  */
-static bool maybe_destroy_workers(struct worker_pool *pool)
+static void maybe_destroy_workers(struct worker_pool *pool)
 {
-	bool ret = false;
-
 	while (too_many_workers(pool)) {
 		struct worker *worker;
 		unsigned long expires;
@@ -1793,10 +1783,7 @@ static bool maybe_destroy_workers(struct worker_pool *pool)
 		}
 
 		destroy_worker(worker);
-		ret = true;
 	}
-
-	return ret;
 }
 
 /**
@@ -1820,24 +1807,32 @@ static bool maybe_destroy_workers(struct worker_pool *pool)
  * some action was taken.
  */
 static bool manage_workers(struct worker *worker)
+	__releases(&gcwq->lock) __acquires(&gcwq->lock)
 {
 	struct worker_pool *pool = worker->pool;
-	bool ret = false;
+	struct global_cwq *gcwq = pool->gcwq;
 
-	if (!mutex_trylock(&pool->manager_mutex))
-		return ret;
+	if (pool->flags & POOL_MANAGING_WORKERS)
+		return false;
 
 	pool->flags &= ~POOL_MANAGE_WORKERS;
 
+	spin_unlock_irq(&gcwq->lock);
+
+	/* blah blah */
+	mutex_lock(&pool->hotplug_mutex);
+
 	/*
 	 * Destroy and then create so that may_start_working() is true
 	 * on return.
 	 */
-	ret |= maybe_destroy_workers(pool);
-	ret |= maybe_create_worker(pool);
+	maybe_destroy_workers(pool);
+	maybe_create_worker(pool);
 
-	mutex_unlock(&pool->manager_mutex);
-	return ret;
+	mutex_unlock(&pool->hotplug_mutex);
+
+	spin_lock_irq(&gcwq->lock);
+	return true;
 }
 
 /**
@@ -3399,7 +3394,7 @@ static void gcwq_claim_management_and_lock(struct global_cwq *gcwq)
 	struct worker_pool *pool;
 
 	for_each_worker_pool(pool, gcwq)
-		mutex_lock_nested(&pool->manager_mutex, pool - gcwq->pools);
+		mutex_lock_nested(&pool->hotplug_mutex, pool - gcwq->pools);
 	spin_lock_irq(&gcwq->lock);
 }
 
@@ -3410,7 +3405,7 @@ static void gcwq_release_management_and_unlock(struct global_cwq *gcwq)
 
 	spin_unlock_irq(&gcwq->lock);
 	for_each_worker_pool(pool, gcwq)
-		mutex_unlock(&pool->manager_mutex);
+		mutex_unlock(&pool->hotplug_mutex);
 }
 
 static void gcwq_unbind_fn(struct work_struct *work)
@@ -3749,7 +3744,7 @@ static int __init init_workqueues(void)
 			setup_timer(&pool->mayday_timer, gcwq_mayday_timeout,
 				    (unsigned long)pool);
 
-			mutex_init(&pool->manager_mutex);
+			mutex_init(&pool->hotplug_mutex);
 			ida_init(&pool->worker_ida);
 		}
 
