Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755414Ab0F1VLL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jun 2010 17:11:11 -0400
Received: from hera.kernel.org ([140.211.167.34]:42868 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755277Ab0F1VGT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jun 2010 17:06:19 -0400
From: Tejun Heo <tj@kernel.org>
To: torvalds@linux-foundation.org, mingo@elte.hu, linux-kernel@vger.kernel.org,
       jeff@garzik.org, akpm@linux-foundation.org, rusty@rustcorp.com.au,
       cl@linux-foundation.org, dhowells@redhat.com, arjan@linux.intel.com,
       oleg@redhat.com, axboe@kernel.dk, fweisbec@gmail.com,
       dwalker@codeaurora.org, stefanr@s5r6.in-berlin.de, florian@mickler.org,
       andi@firstfloor.org, mst@redhat.com, randy.dunlap@oracle.com
Cc: Tejun Heo <tj@kernel.org>
Subject: [PATCH 01/35] kthread: implement kthread_worker
Date: Mon, 28 Jun 2010 23:03:49 +0200
Message-Id: <1277759063-24607-2-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.6.4.2
In-Reply-To: <1277759063-24607-1-git-send-email-tj@kernel.org>
References: <1277759063-24607-1-git-send-email-tj@kernel.org>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Mon, 28 Jun 2010 21:05:00 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Implement simple work processor for kthread.  This is to ease using
kthread.  Single thread workqueue used to be used for things like this
but workqueue won't guarantee fixed kthread association anymore to
enable worker sharing.

This can be used in cases where specific kthread association is
necessary, for example, when it should have RT priority or be assigned
to certain cgroup.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
---
 include/linux/kthread.h |   64 ++++++++++++++++++++
 kernel/kthread.c        |  149 +++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 213 insertions(+), 0 deletions(-)

diff --git a/include/linux/kthread.h b/include/linux/kthread.h
index aabc8a1..f93cb69 100644
--- a/include/linux/kthread.h
+++ b/include/linux/kthread.h
@@ -34,4 +34,68 @@ int kthread_should_stop(void);
 int kthreadd(void *unused);
 extern struct task_struct *kthreadd_task;
 
+/*
+ * Simple work processor based on kthread.
+ *
+ * This provides easier way to make use of kthreads.  A kthread_work
+ * can be queued and flushed using queue/flush_kthread_work()
+ * respectively.  Queued kthread_works are processed by a kthread
+ * running kthread_worker_fn().
+ *
+ * A kthread_work can't be freed while it is executing.
+ */
+struct kthread_work;
+typedef void (*kthread_work_func_t)(struct kthread_work *work);
+
+struct kthread_worker {
+	spinlock_t		lock;
+	struct list_head	work_list;
+	struct task_struct	*task;
+};
+
+struct kthread_work {
+	struct list_head	node;
+	kthread_work_func_t	func;
+	wait_queue_head_t	done;
+	atomic_t		flushing;
+	int			queue_seq;
+	int			done_seq;
+};
+
+#define KTHREAD_WORKER_INIT(worker)	{				\
+	.lock = SPIN_LOCK_UNLOCKED,					\
+	.work_list = LIST_HEAD_INIT((worker).work_list),		\
+	}
+
+#define KTHREAD_WORK_INIT(work, fn)	{				\
+	.node = LIST_HEAD_INIT((work).node),				\
+	.func = (fn),							\
+	.done = __WAIT_QUEUE_HEAD_INITIALIZER((work).done),		\
+	.flushing = ATOMIC_INIT(0),					\
+	}
+
+#define DEFINE_KTHREAD_WORKER(worker)					\
+	struct kthread_worker worker = KTHREAD_WORKER_INIT(worker)
+
+#define DEFINE_KTHREAD_WORK(work, fn)					\
+	struct kthread_work work = KTHREAD_WORK_INIT(work, fn)
+
+static inline void init_kthread_worker(struct kthread_worker *worker)
+{
+	*worker = (struct kthread_worker)KTHREAD_WORKER_INIT(*worker);
+}
+
+static inline void init_kthread_work(struct kthread_work *work,
+				     kthread_work_func_t fn)
+{
+	*work = (struct kthread_work)KTHREAD_WORK_INIT(*work, fn);
+}
+
+int kthread_worker_fn(void *worker_ptr);
+
+bool queue_kthread_work(struct kthread_worker *worker,
+			struct kthread_work *work);
+void flush_kthread_work(struct kthread_work *work);
+void flush_kthread_worker(struct kthread_worker *worker);
+
 #endif /* _LINUX_KTHREAD_H */
diff --git a/kernel/kthread.c b/kernel/kthread.c
index 83911c7..8b63c7f 100644
--- a/kernel/kthread.c
+++ b/kernel/kthread.c
@@ -14,6 +14,8 @@
 #include <linux/file.h>
 #include <linux/module.h>
 #include <linux/mutex.h>
+#include <linux/slab.h>
+#include <linux/freezer.h>
 #include <trace/events/sched.h>
 
 static DEFINE_SPINLOCK(kthread_create_lock);
@@ -247,3 +249,150 @@ int kthreadd(void *unused)
 
 	return 0;
 }
+
+/**
+ * kthread_worker_fn - kthread function to process kthread_worker
+ * @worker_ptr: pointer to initialized kthread_worker
+ *
+ * This function can be used as @threadfn to kthread_create() or
+ * kthread_run() with @worker_ptr argument pointing to an initialized
+ * kthread_worker.  The started kthread will process work_list until
+ * the it is stopped with kthread_stop().  A kthread can also call
+ * this function directly after extra initialization.
+ *
+ * Different kthreads can be used for the same kthread_worker as long
+ * as there's only one kthread attached to it at any given time.  A
+ * kthread_worker without an attached kthread simply collects queued
+ * kthread_works.
+ */
+int kthread_worker_fn(void *worker_ptr)
+{
+	struct kthread_worker *worker = worker_ptr;
+	struct kthread_work *work;
+
+	WARN_ON(worker->task);
+	worker->task = current;
+repeat:
+	set_current_state(TASK_INTERRUPTIBLE);	/* mb paired w/ kthread_stop */
+
+	if (kthread_should_stop()) {
+		__set_current_state(TASK_RUNNING);
+		spin_lock_irq(&worker->lock);
+		worker->task = NULL;
+		spin_unlock_irq(&worker->lock);
+		return 0;
+	}
+
+	work = NULL;
+	spin_lock_irq(&worker->lock);
+	if (!list_empty(&worker->work_list)) {
+		work = list_first_entry(&worker->work_list,
+					struct kthread_work, node);
+		list_del_init(&work->node);
+	}
+	spin_unlock_irq(&worker->lock);
+
+	if (work) {
+		__set_current_state(TASK_RUNNING);
+		work->func(work);
+		smp_wmb();	/* wmb worker-b0 paired with flush-b1 */
+		work->done_seq = work->queue_seq;
+		smp_mb();	/* mb worker-b1 paired with flush-b0 */
+		if (atomic_read(&work->flushing))
+			wake_up_all(&work->done);
+	} else if (!freezing(current))
+		schedule();
+
+	try_to_freeze();
+	goto repeat;
+}
+EXPORT_SYMBOL_GPL(kthread_worker_fn);
+
+/**
+ * queue_kthread_work - queue a kthread_work
+ * @worker: target kthread_worker
+ * @work: kthread_work to queue
+ *
+ * Queue @work to work processor @task for async execution.  @task
+ * must have been created with kthread_worker_create().  Returns %true
+ * if @work was successfully queued, %false if it was already pending.
+ */
+bool queue_kthread_work(struct kthread_worker *worker,
+			struct kthread_work *work)
+{
+	bool ret = false;
+	unsigned long flags;
+
+	spin_lock_irqsave(&worker->lock, flags);
+	if (list_empty(&work->node)) {
+		list_add_tail(&work->node, &worker->work_list);
+		work->queue_seq++;
+		if (likely(worker->task))
+			wake_up_process(worker->task);
+		ret = true;
+	}
+	spin_unlock_irqrestore(&worker->lock, flags);
+	return ret;
+}
+EXPORT_SYMBOL_GPL(queue_kthread_work);
+
+/**
+ * flush_kthread_work - flush a kthread_work
+ * @work: work to flush
+ *
+ * If @work is queued or executing, wait for it to finish execution.
+ */
+void flush_kthread_work(struct kthread_work *work)
+{
+	int seq = work->queue_seq;
+
+	atomic_inc(&work->flushing);
+
+	/*
+	 * mb flush-b0 paired with worker-b1, to make sure either
+	 * worker sees the above increment or we see done_seq update.
+	 */
+	smp_mb__after_atomic_inc();
+
+	/* A - B <= 0 tests whether B is in front of A regardless of overflow */
+	wait_event(work->done, seq - work->done_seq <= 0);
+	atomic_dec(&work->flushing);
+
+	/*
+	 * rmb flush-b1 paired with worker-b0, to make sure our caller
+	 * sees every change made by work->func().
+	 */
+	smp_mb__after_atomic_dec();
+}
+EXPORT_SYMBOL_GPL(flush_kthread_work);
+
+struct kthread_flush_work {
+	struct kthread_work	work;
+	struct completion	done;
+};
+
+static void kthread_flush_work_fn(struct kthread_work *work)
+{
+	struct kthread_flush_work *fwork =
+		container_of(work, struct kthread_flush_work, work);
+	complete(&fwork->done);
+}
+
+/**
+ * flush_kthread_worker - flush all current works on a kthread_worker
+ * @worker: worker to flush
+ *
+ * Wait until all currently executing or pending works on @worker are
+ * finished.
+ */
+void flush_kthread_worker(struct kthread_worker *worker)
+{
+	struct kthread_flush_work fwork = {
+		KTHREAD_WORK_INIT(fwork.work, kthread_flush_work_fn),
+		COMPLETION_INITIALIZER_ONSTACK(fwork.done),
+	};
+
+	queue_kthread_work(worker, &fwork.work);
+	wait_for_completion(&fwork.done);
+}
+EXPORT_SYMBOL_GPL(flush_kthread_worker);
-- 
1.6.4.2

