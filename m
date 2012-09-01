Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755630Ab2IARpu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Sep 2012 13:45:50 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:59081 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1755560Ab2IARof (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Sep 2012 13:44:35 -0400
X-IronPort-AV: E=Sophos;i="4.80,353,1344182400"; 
   d="scan'208";a="5764906"
From: Lai Jiangshan <laijs@cn.fujitsu.com>
To: Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>
Subject: [PATCH 04/10 V4] workqueue: add manage_workers_slowpath()
Date: Sun, 2 Sep 2012 00:28:22 +0800
Message-Id: <1346516916-1991-5-git-send-email-laijs@cn.fujitsu.com>
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

If hotplug code grabbed the manager_mutex and worker_thread try to create
a worker, the manage_worker() will return false and worker_thread go to
process work items. Now, on the CPU, all workers are processing work items,
no idle_worker left/ready for managing. It breaks the concept of workqueue
and it is bug.

So when manage_worker() failed to grab the manager_mutex, it should
try to enter normal process contex and then compete on the manager_mutex
instead of return false.

To safely do this, we add manage_workers_slowpath() and the worker
go to process work items mode to do the managing jobs. thus
managing jobs are processed via work item and can free to compete
on manager_mutex.

After this patch, manager_mutex can be grabbed anywhere if needed,
it will not cause the CPU consumes all the idle worker_threads.

By the way, POOL_MANAGING_WORKERS is still need to tell us
why manage_workers() failed to grab the manage_mutex.

This slowpath is hard to trigger, so I change
"if (unlikely(!mutex_trylock(&pool->manager_mutex)))"
to "if (1 || unlikely(!mutex_trylock(&pool->manager_mutex)))"
when testing, it uses manage_workers_slowpath() always.


Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
---
 kernel/workqueue.c |   89 ++++++++++++++++++++++++++++++++++++++++++++++++++-
 1 files changed, 87 insertions(+), 2 deletions(-)

diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index 979ef4f..d40e8d7 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -1808,6 +1808,81 @@ static bool maybe_destroy_workers(struct worker_pool *pool)
 	return ret;
 }
 
+/* manage workers via work item */
+static void manage_workers_slowpath_fn(struct work_struct *work)
+{
+	struct worker *worker = kthread_data(current);
+	struct worker_pool *pool = worker->pool;
+
+	mutex_lock(&pool->manager_mutex);
+	spin_lock_irq(&pool->gcwq->lock);
+
+	pool->flags &= ~POOL_MANAGE_WORKERS;
+	maybe_destroy_workers(pool);
+	maybe_create_worker(pool);
+
+	spin_unlock_irq(&pool->gcwq->lock);
+	mutex_unlock(&pool->manager_mutex);
+}
+
+static void process_scheduled_works(struct worker *worker);
+
+/*
+ * manage_workers_slowpath - manage worker pool via work item
+ * @worker: self
+ *
+ * manage workers when rebind_workers() or gcwq_unbind_fn() beat us down
+ * on manage_mutex. The worker can't release the gcwq->lock and then
+ * compete on manage_mutex, because any worker must have at least one of:
+ * 	1) with gcwq->lock held
+ * 	2) with pool->manage_mutex held (manage_workers() fast path)
+ * 	3) queued on idle_list
+ * 	4) processing work item and queued on busy hash table
+ *
+ * So we move the managing worker job to a work item and process it,
+ * thus the manage_workers_slowpath_fn() has full ability to compete
+ * on manage_mutex.
+ *
+ * CONTEXT:
+ * with WORKER_PREP bit set
+ * spin_lock_irq(gcwq->lock) which will be released and regrabbed
+ * multiple times.  Does GFP_KERNEL allocations.
+ */
+static void manage_workers_slowpath(struct worker *worker)
+{
+	struct worker_pool *pool = worker->pool;
+	struct work_struct manage_work;
+	int cpu = pool->gcwq->cpu;
+	struct cpu_workqueue_struct *cwq;
+
+	pool->flags |= POOL_MANAGING_WORKERS;
+
+	INIT_WORK_ONSTACK(&manage_work, manage_workers_slowpath_fn);
+	__set_bit(WORK_STRUCT_PENDING_BIT, work_data_bits(&manage_work));
+
+	/* see the comment of the same statement of worker_thread() */
+	BUG_ON(!list_empty(&worker->scheduled));
+
+	/* wq doesn't matter, use the default one */
+	if (cpu == WORK_CPU_UNBOUND)
+		cwq = get_cwq(cpu, system_unbound_wq);
+	else
+		cwq = get_cwq(cpu, system_wq);
+
+	/* insert the work to the worker's own scheduled list */
+	debug_work_activate(&manage_work);
+	insert_work(cwq, &manage_work, &worker->scheduled,
+		    work_color_to_flags(WORK_NO_COLOR));
+
+	/*
+	 * Do manage workers. And may also proccess busy_worker_rebind_fn()
+	 * queued by rebind_workers().
+	 */
+	process_scheduled_works(worker);
+
+	pool->flags &= ~POOL_MANAGING_WORKERS;
+}
+
 /**
  * manage_workers - manage worker pool
  * @worker: self
@@ -1833,8 +1908,18 @@ static bool manage_workers(struct worker *worker)
 	struct worker_pool *pool = worker->pool;
 	bool ret = false;
 
-	if (!mutex_trylock(&pool->manager_mutex))
-		return ret;
+	if (pool->flags & POOL_MANAGING_WORKERS)
+		return false;
+
+	if (unlikely(!mutex_trylock(&pool->manager_mutex))) {
+		/*
+		 * Ouch! rebind_workers() or gcwq_unbind_fn() beats we,
+		 * but we can't return without making any progress.
+		 * Fall back to manage_workers_slowpath().
+		 */
+		manage_workers_slowpath(worker);
+		return true;
+	}
 
 	pool->flags &= ~POOL_MANAGE_WORKERS;
 	pool->flags |= POOL_MANAGING_WORKERS;
-- 
1.7.4.4

