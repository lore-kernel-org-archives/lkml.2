Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946219Ab2I1VRb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 17:17:31 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:51975 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759322Ab2I1Uij (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 16:38:39 -0400
X-Sasl-enc: gC28+NWJt4nBCxHg1ixvo32ET9gCyNM4AwTta7RMHQ7r 1348864718
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Tejun Heo <tj@kernel.org>, Colin Cross <ccross@google.com>
Subject: [ 209/218] kthread_worker: reimplement flush_kthread_work() to allow freeing the work item being executed
Date: Fri, 28 Sep 2012 13:17:06 -0700
Message-Id: <20120928201525.576907313@linuxfoundation.org>
X-Mailer: git-send-email 1.7.12.1.428.g652398a
In-Reply-To: <20120928201501.208384923@linuxfoundation.org>
References: <20120928201501.208384923@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tejun Heo <tj@kernel.org>

commit 46f3d976213452350f9d10b0c2780c2681f7075b upstream.

kthread_worker provides minimalistic workqueue-like interface for
users which need a dedicated worker thread (e.g. for realtime
priority).  It has basic queue, flush_work, flush_worker operations
which mostly match the workqueue counterparts; however, due to the way
flush_work() is implemented, it has a noticeable difference of not
allowing work items to be freed while being executed.

While the current users of kthread_worker are okay with the current
behavior, the restriction does impede some valid use cases.  Also,
removing this difference isn't difficult and actually makes the code
easier to understand.

This patch reimplements flush_kthread_work() such that it uses a
flush_work item instead of queue/done sequence numbers.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Colin Cross <ccross@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 include/linux/kthread.h |    8 +------
 kernel/kthread.c        |   52 ++++++++++++++++++++++++++----------------------
 2 files changed, 31 insertions(+), 29 deletions(-)

--- a/include/linux/kthread.h
+++ b/include/linux/kthread.h
@@ -49,8 +49,6 @@ extern int tsk_fork_get_node(struct task
  * can be queued and flushed using queue/flush_kthread_work()
  * respectively.  Queued kthread_works are processed by a kthread
  * running kthread_worker_fn().
- *
- * A kthread_work can't be freed while it is executing.
  */
 struct kthread_work;
 typedef void (*kthread_work_func_t)(struct kthread_work *work);
@@ -59,15 +57,14 @@ struct kthread_worker {
 	spinlock_t		lock;
 	struct list_head	work_list;
 	struct task_struct	*task;
+	struct kthread_work	*current_work;
 };
 
 struct kthread_work {
 	struct list_head	node;
 	kthread_work_func_t	func;
 	wait_queue_head_t	done;
-	atomic_t		flushing;
-	int			queue_seq;
-	int			done_seq;
+	struct kthread_worker	*worker;
 };
 
 #define KTHREAD_WORKER_INIT(worker)	{				\
@@ -79,7 +76,6 @@ struct kthread_work {
 	.node = LIST_HEAD_INIT((work).node),				\
 	.func = (fn),							\
 	.done = __WAIT_QUEUE_HEAD_INITIALIZER((work).done),		\
-	.flushing = ATOMIC_INIT(0),					\
 	}
 
 #define DEFINE_KTHREAD_WORKER(worker)					\
--- a/kernel/kthread.c
+++ b/kernel/kthread.c
@@ -360,16 +360,12 @@ repeat:
 					struct kthread_work, node);
 		list_del_init(&work->node);
 	}
+	worker->current_work = work;
 	spin_unlock_irq(&worker->lock);
 
 	if (work) {
 		__set_current_state(TASK_RUNNING);
 		work->func(work);
-		smp_wmb();	/* wmb worker-b0 paired with flush-b1 */
-		work->done_seq = work->queue_seq;
-		smp_mb();	/* mb worker-b1 paired with flush-b0 */
-		if (atomic_read(&work->flushing))
-			wake_up_all(&work->done);
 	} else if (!freezing(current))
 		schedule();
 
@@ -386,7 +382,7 @@ static void insert_kthread_work(struct k
 	lockdep_assert_held(&worker->lock);
 
 	list_add_tail(&work->node, pos);
-	work->queue_seq++;
+	work->worker = worker;
 	if (likely(worker->task))
 		wake_up_process(worker->task);
 }
@@ -436,25 +432,35 @@ static void kthread_flush_work_fn(struct
  */
 void flush_kthread_work(struct kthread_work *work)
 {
-	int seq = work->queue_seq;
+	struct kthread_flush_work fwork = {
+		KTHREAD_WORK_INIT(fwork.work, kthread_flush_work_fn),
+		COMPLETION_INITIALIZER_ONSTACK(fwork.done),
+	};
+	struct kthread_worker *worker;
+	bool noop = false;
+
+retry:
+	worker = work->worker;
+	if (!worker)
+		return;
+
+	spin_lock_irq(&worker->lock);
+	if (work->worker != worker) {
+		spin_unlock_irq(&worker->lock);
+		goto retry;
+	}
+
+	if (!list_empty(&work->node))
+		insert_kthread_work(worker, &fwork.work, work->node.next);
+	else if (worker->current_work == work)
+		insert_kthread_work(worker, &fwork.work, worker->work_list.next);
+	else
+		noop = true;
 
-	atomic_inc(&work->flushing);
+	spin_unlock_irq(&worker->lock);
 
-	/*
-	 * mb flush-b0 paired with worker-b1, to make sure either
-	 * worker sees the above increment or we see done_seq update.
-	 */
-	smp_mb__after_atomic_inc();
-
-	/* A - B <= 0 tests whether B is in front of A regardless of overflow */
-	wait_event(work->done, seq - work->done_seq <= 0);
-	atomic_dec(&work->flushing);
-
-	/*
-	 * rmb flush-b1 paired with worker-b0, to make sure our caller
-	 * sees every change made by work->func().
-	 */
-	smp_mb__after_atomic_dec();
+	if (!noop)
+		wait_for_completion(&fwork.done);
 }
 EXPORT_SYMBOL_GPL(flush_kthread_work);
 


