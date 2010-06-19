Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756410Ab0FSPy6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jun 2010 11:54:58 -0400
Received: from hera.kernel.org ([140.211.167.34]:35172 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756356Ab0FSPy4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jun 2010 11:54:56 -0400
Message-ID: <4C1CE813.8080701@kernel.org>
Date: Sat, 19 Jun 2010 17:53:55 +0200
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.1.10) Gecko/20100512 Thunderbird/3.0.5
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Andy Walls <awalls@md.metrocast.net>,
       Daniel Walker <dwalker@codeaurora.org>, mingo@elte.hu,
       linux-kernel@vger.kernel.org, jeff@garzik.org, rusty@rustcorp.com.au,
       cl@linux-foundation.org, dhowells@redhat.com, arjan@linux.intel.com,
       johannes@sipsolutions.net, oleg@redhat.com, axboe@kernel.dk,
       mst@redhat.com, samudrala.sridhar@gmail.com
Subject: [PATCH] kthread: implement kthread_worker
References: <1276551467-21246-1-git-send-email-tj@kernel.org>	<4C17C598.7070303@kernel.org>	<1276631037.6432.9.camel@c-dwalke-linux.qualcomm.com>	<4C18BF40.40607@kernel.org>	<1276694825.9309.12.camel@m0nster>	<4C18D1FD.9060804@kernel.org>	<1276695665.9309.17.camel@m0nster>	<4C18D574.1040903@kernel.org>	<1276697146.9309.27.camel@m0nster>	<1276776066.2461.15.camel@localhost>	<20100617161619.d3ebd73d.akpm@linux-foundation.org>	<4C1B1D3F.8030509@kernel.org>	<20100618003127.10d9e6c8.akpm@linux-foundation.org>	<4C1B29BF.7080404@kernel.org> <20100618100228.093ec17b.akpm@linux-foundation.org> <4C1BACC6.5020602@kernel.org>
In-Reply-To: <4C1BACC6.5020602@kernel.org>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Sat, 19 Jun 2010 15:53:58 +0000 (UTC)
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
---
So, basically something like this.  This doesn't support all the
features of workqueue but should be enough for most cases and we can
always add missing bits as necessary.  This is basically the same
logic that I wrote for vhost (vhost people cc'd) and vhost should be
able to switch easily.  It's simple but efficient and makes using
kthread a lot easier.

Andrew, does this look like a reasonable compromise?  If so, I'll put
it in the series, convert ivtv and integrate padata and post another
round.

Thanks.

 include/linux/kthread.h |   63 +++++++++++++++++++++++++
 kernel/kthread.c        |  118 ++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 181 insertions(+)

Index: work/kernel/kthread.c
===================================================================
--- work.orig/kernel/kthread.c
+++ work/kernel/kthread.c
@@ -14,6 +14,8 @@
 #include <linux/file.h>
 #include <linux/module.h>
 #include <linux/mutex.h>
+#include <linux/slab.h>
+#include <linux/freezer.h>
 #include <trace/events/sched.h>

 static DEFINE_SPINLOCK(kthread_create_lock);
@@ -247,3 +249,119 @@ int kthreadd(void *unused)

 	return 0;
 }
+
+/**
+ * kthread_worker_fn - kthread function to process kthread_worker
+ * @data: pointer to initialized kthread_worker
+ *
+ * This function can be used as @threadfn to kthread_create() or
+ * kthread_run() with @data argument pointing to an initialized
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
Index: work/include/linux/kthread.h
===================================================================
--- work.orig/include/linux/kthread.h
+++ work/include/linux/kthread.h
@@ -34,4 +34,67 @@ int kthread_should_stop(void);
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
+
 #endif /* _LINUX_KTHREAD_H */
