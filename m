Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758973Ab2IGXmH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2012 19:42:07 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:33344 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756189Ab2IGXmD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2012 19:42:03 -0400
Date: Fri, 7 Sep 2012 16:41:58 -0700
From: Tejun Heo <tj@kernel.org>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH wq/for-3.6-fixes 3/3] workqueue: fix possible idle
 worker depletion during CPU_ONLINE
Message-ID: <20120907234158.GL9426@google.com>
References: <20120906200647.GG29092@google.com>
 <20120906200723.GH29092@google.com>
 <20120906200802.GI29092@google.com>
 <504965AA.6090107@cn.fujitsu.com>
 <20120907192939.GF9426@google.com>
 <20120907202249.GH9426@google.com>
 <20120907203414.GI9426@google.com>
 <20120907230556.GJ9426@google.com>
 <20120907230746.GK9426@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120907230746.GK9426@google.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I think this should do it.  Can you spot any hole with the following
patch?

Thanks.

Index: work/kernel/workqueue.c
===================================================================
--- work.orig/kernel/workqueue.c
+++ work/kernel/workqueue.c
@@ -66,6 +66,7 @@ enum {
 
 	/* pool flags */
 	POOL_MANAGE_WORKERS	= 1 << 0,	/* need to manage workers */
+	POOL_MANAGING_WORKERS   = 1 << 1,       /* managing workers */
 
 	/* worker flags */
 	WORKER_STARTED		= 1 << 0,	/* started */
@@ -165,7 +166,7 @@ struct worker_pool {
 	struct timer_list	idle_timer;	/* L: worker idle timeout */
 	struct timer_list	mayday_timer;	/* L: SOS timer for workers */
 
-	struct mutex		manager_mutex;	/* mutex manager should hold */
+	struct mutex		manager_mutex;	/* manager <-> CPU hotplug */
 	struct ida		worker_ida;	/* L: for worker IDs */
 };
 
@@ -480,6 +481,7 @@ static atomic_t unbound_pool_nr_running[
 };
 
 static int worker_thread(void *__worker);
+static void process_scheduled_works(struct worker *worker);
 
 static int worker_pool_pri(struct worker_pool *pool)
 {
@@ -652,7 +654,7 @@ static bool need_to_manage_workers(struc
 /* Do we have too many workers and should some go away? */
 static bool too_many_workers(struct worker_pool *pool)
 {
-	bool managing = mutex_is_locked(&pool->manager_mutex);
+	bool managing = pool->flags & POOL_MANAGING_WORKERS;
 	int nr_idle = pool->nr_idle + managing; /* manager is considered idle */
 	int nr_busy = pool->nr_workers - nr_idle;
 
@@ -1820,14 +1822,43 @@ static bool maybe_destroy_workers(struct
  * some action was taken.
  */
 static bool manage_workers(struct worker *worker)
+	__releases(&gcwq->lock) __acquires(&gcwq->lock)
 {
 	struct worker_pool *pool = worker->pool;
+	struct global_cwq *gcwq = pool->gcwq;
 	bool ret = false;
 
-	if (!mutex_trylock(&pool->manager_mutex))
-		return ret;
+	if (pool->flags & POOL_MANAGING_WORKERS)
+ 		return ret;
 
 	pool->flags &= ~POOL_MANAGE_WORKERS;
+	pool->flags |= POOL_MANAGING_WORKERS;
+
+	/*
+	 * To simplify both worker management and CPU hotplug, hold off
+	 * management while hotplug is in progress.  CPU hotplug path can't
+	 * grab %POOL_MANAGING_WORKERS to achieve this because that can
+	 * lead to idle worker depletion (all become busy thinking someone
+	 * else is managing) which in turn can result in deadlock under
+	 * extreme circumstances.
+	 *
+	 * manager_mutex would always be free unless CPU hotplug is in
+	 * progress.  trylock first without dropping gcwq->lock.
+	 */
+	if (unlikely(!mutex_trylock(&pool->manager_mutex))) {
+		spin_unlock_irq(&gcwq->lock);
+		mutex_lock(&pool->manager_mutex);
+		spin_lock_irq(&gcwq->lock);
+
+		/*
+		 * CPU hotplug could have scheduled rebind_work while we're
+		 * waiting for manager_mutex.  Rebind before doing anything
+		 * else.  This has to be handled here.  worker_thread()
+		 * will be confused by the unexpected work item.
+		 */
+		process_scheduled_works(worker);
+		ret = true;
+	}
 
 	/*
 	 * Destroy and then create so that may_start_working() is true
@@ -1836,7 +1867,9 @@ static bool manage_workers(struct worker
 	ret |= maybe_destroy_workers(pool);
 	ret |= maybe_create_worker(pool);
 
+	pool->flags &= ~POOL_MANAGING_WORKERS;
 	mutex_unlock(&pool->manager_mutex);
+
 	return ret;
 }
 
@@ -3393,7 +3426,7 @@ EXPORT_SYMBOL_GPL(work_busy);
  * cpu comes back online.
  */
 
-/* claim manager positions of all pools */
+/* claim manager positions of all pools, see manage_workers() for details */
 static void gcwq_claim_management_and_lock(struct global_cwq *gcwq)
 {
 	struct worker_pool *pool;
