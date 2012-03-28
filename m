Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933233Ab2C1XGX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2012 19:06:23 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:58632 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932567Ab2C1XGT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2012 19:06:19 -0400
Date: Wed, 28 Mar 2012 16:06:17 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Manfred Spraul <manfred@colorfullife.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Mike Galbraith <efault@gmx.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH 5/5] ipc/sem.c: alternatives to preempt_disable()
Message-Id: <20120328160617.7200b4b3.akpm@linux-foundation.org>
In-Reply-To: <1318684920-2033-1-git-send-email-manfred@colorfullife.com>
References: <1318684920-2033-1-git-send-email-manfred@colorfullife.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bump.

On Sat, 15 Oct 2011 15:22:00 +0200
Manfred Spraul <manfred@colorfullife.com> wrote:

> ipc/sem.c uses a custom wakeup scheme that relies on preempt_disable().
> On -RT, this causes increased latencies and debug warnings.
> 
> The patch adds two additional schemes:
> - one built around a completion - could be better for -RT kernels
> - one built around a spinlock - unfortunately it's broken
> - and the current one
> 
> Mike, Peter: Would the completion work on -rt?
> 
> My preferred solution would be the spinlock implementation:
> RT would use premptible spinlocks, mainline normal spinlocks.
> Thus both get the optimal implementation without any special code in
> ipc/sem.c.
> Unfortunately, I don't see how it could be fixed.

Guys, I'm still babysitting this patch, hoping for some input from RT
people?

Thanks.

From: Manfred Spraul <manfred@colorfullife.com>
Subject: ipc/sem.c: alternatives to preempt_disable()

ipc/sem.c uses a custom wakeup scheme that relies on preempt_disable(). 
On -RT, this causes increased latencies and debug warnings.

The patch adds two additional schemes:
- one built around a completion - could be better for -RT kernels
- one built around a spinlock - unfortunately it's broken
- and the current one

My preferred solution would be the spinlock implementation: RT would use
premptible spinlocks, mainline normal spinlocks.  Thus both get the
optimal implementation without any special code in ipc/sem.c. 
Unfortunately, I don't see how it could be fixed.

Signed-off-by: Manfred Spraul <manfred@colorfullife.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Mike Galbraith <efault@gmx.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 ipc/sem.c |  250 +++++++++++++++++++++++++++++++++++-----------------
 1 file changed, 171 insertions(+), 79 deletions(-)

diff -puN ipc/sem.c~ipc-semc-alternatives-to-preempt_disable ipc/sem.c
--- a/ipc/sem.c~ipc-semc-alternatives-to-preempt_disable
+++ a/ipc/sem.c
@@ -61,8 +61,8 @@
  * - A woken up task may not even touch the semaphore array anymore, it may
  *   have been destroyed already by a semctl(RMID).
  * - The synchronizations between wake-ups due to a timeout/signal and a
- *   wake-up due to a completed semaphore operation is achieved by using an
- *   intermediate state (IN_WAKEUP).
+ *   wake-up due to a completed semaphore operation is achieved by using a
+ *   special wakeup scheme (queuewakeup_wait and support functions)
  * - UNDO values are stored in an array (one per process and per
  *   semaphore array, lazily allocated). For backwards compatibility, multiple
  *   modes for the UNDO variables are supported (per process, per thread)
@@ -90,6 +90,135 @@
 #include <asm/uaccess.h>
 #include "util.h"
 
+
+#ifdef CONFIG_PREEMPT_RT_BASE
+	#define SYSVSEM_COMPLETION 1
+#else
+	#define SYSVSEM_CUSTOM 1
+#endif
+
+#ifdef SYSVSEM_COMPLETION
+	/* Using a completion causes some overhead, but avoids a busy loop
+	 * that increases the worst case latency.
+	 */
+	struct queue_done {
+		struct completion done;
+	};
+
+	static void queuewakeup_prepare(void)
+	{
+		/* no preparation necessary */
+	}
+
+	static void queuewakeup_completed(void)
+	{
+		/* empty */
+	}
+
+	static void queuewakeup_block(struct queue_done *qd)
+	{
+		/* empty */
+	}
+
+	static void queuewakeup_handsoff(struct queue_done *qd)
+	{
+		complete_all(&qd->done);
+	}
+
+	static void queuewakeup_init(struct queue_done *qd)
+	{
+		init_completion(&qd->done);
+	}
+
+	static void queuewakeup_wait(struct queue_done *qd)
+	{
+		wait_for_completion(&qd->done);
+	}
+
+#elif defined(SYSVSEM_SPINLOCK)
+	/* Note: Spinlocks do not work because:
+	 * - lockdep complains [could be fixed]
+	 * - only 255 concurrent spin_lock() calls are permitted, then the
+	 *   preempt-counter overflows
+	 */
+#error SYSVSEM_SPINLOCK is a prove of concept, does not work.
+	struct queue_done {
+		spinlock_t done;
+	};
+
+	static void queuewakeup_prepare(void)
+	{
+		/* empty */
+	}
+
+	static void queuewakeup_completed(void)
+	{
+		/* empty */
+	}
+
+	static void queuewakeup_block(struct queue_done *qd)
+	{
+		BUG_ON(spin_is_locked(&qd->done));
+		spin_lock(&qd->done);
+	}
+
+	static void queuewakeup_handsoff(struct queue_done *qd)
+	{
+		spin_unlock(&qd->done);
+	}
+
+	static void queuewakeup_init(struct queue_done *qd)
+	{
+		spin_lock_init(&qd->done);
+	}
+
+	static void queuewakeup_wait(struct queue_done *qd)
+	{
+		spin_unlock_wait(&qd->done);
+	}
+#else
+	struct queue_done {
+		atomic_t done;
+	};
+
+	static void queuewakeup_prepare(void)
+	{
+		preempt_disable();
+	}
+
+	static void queuewakeup_completed(void)
+	{
+		preempt_enable();
+	}
+
+	static void queuewakeup_block(struct queue_done *qd)
+	{
+		BUG_ON(atomic_read(&qd->done) != 1);
+		atomic_set(&qd->done, 2);
+	}
+
+	static void queuewakeup_handsoff(struct queue_done *qd)
+	{
+		BUG_ON(atomic_read(&qd->done) != 2);
+		smp_mb();
+		atomic_set(&qd->done, 1);
+	}
+
+	static void queuewakeup_init(struct queue_done *qd)
+	{
+		atomic_set(&qd->done, 1);
+	}
+
+	static void queuewakeup_wait(struct queue_done *qd)
+	{
+		while (atomic_read(&qd->done) != 1)
+			cpu_relax();
+
+		smp_mb();
+	}
+#endif
+
+
 /* One semaphore structure for each semaphore in the system. */
 struct sem {
 	int	semval;		/* current value */
@@ -108,6 +237,7 @@ struct sem_queue {
 	struct sembuf		*sops;	 /* array of pending operations */
 	int			nsops;	 /* number of operations */
 	int			alter;	 /* does *sops alter the array? */
+	struct queue_done	done;	 /* completion synchronization */
 };
 
 /* Each task has a list of undo requests. They are executed automatically
@@ -245,23 +375,27 @@ static inline void sem_rmid(struct ipc_n
  * - queue.status is initialized to -EINTR before blocking.
  * - wakeup is performed by
  *	* unlinking the queue entry from sma->sem_pending
- *	* setting queue.status to IN_WAKEUP
- *	  This is the notification for the blocked thread that a
- *	  result value is imminent.
+ *	* setting queue.status to the actual result code
+ *	  This is the notification for the blocked thread that someone
+ *	  (usually: update_queue()) completed the semtimedop() operation.
  *	* call wake_up_process
- *	* set queue.status to the final value.
+ *	* queuewakeup_handsoff(&q->done);
  * - the previously blocked thread checks queue.status:
- *   	* if it's IN_WAKEUP, then it must wait until the value changes
- *   	* if it's not -EINTR, then the operation was completed by
- *   	  update_queue. semtimedop can return queue.status without
- *   	  performing any operation on the sem array.
- *   	* otherwise it must acquire the spinlock and check what's up.
+ *	* if it's not -EINTR, then someone completed the operation.
+ *	  First, queuewakeup_wait() must be called. Afterwards,
+ *	  semtimedop must return queue.status without performing any
+ *	  operation on the sem array.
+ *	  - otherwise it must acquire the spinlock and repeat the test
+ *	  - If it is still -EINTR, then no update_queue() completed the
+ *	    operation, thus semtimedop() can proceed normally.
  *
- * The two-stage algorithm is necessary to protect against the following
+ * queuewakeup_wait() is necessary to protect against the following
  * races:
  * - if queue.status is set after wake_up_process, then the woken up idle
  *   thread could race forward and try (and fail) to acquire sma->lock
- *   before update_queue had a chance to set queue.status
+ *   before update_queue had a chance to set queue.status.
+ *   More importantly, it would mean that wake_up_process must be done
+ *   while holding sma->lock, i.e. this would reduce the scalability.
  * - if queue.status is written before wake_up_process and if the
  *   blocked process is woken up by a signal between writing
  *   queue.status and the wake_up_process, then the woken up
@@ -271,7 +405,6 @@ static inline void sem_rmid(struct ipc_n
  *   (yes, this happened on s390 with sysv msg).
  *
  */
-#define IN_WAKEUP	1
 
 /**
  * newary - Create a new semaphore set
@@ -461,15 +594,11 @@ undo:
 static void wake_up_sem_queue_prepare(struct list_head *pt,
 				struct sem_queue *q, int error)
 {
-	if (list_empty(pt)) {
-		/*
-		 * Hold preempt off so that we don't get preempted and have the
-		 * wakee busy-wait until we're scheduled back on.
-		 */
-		preempt_disable();
-	}
-	q->status = IN_WAKEUP;
-	q->pid = error;
+	if (list_empty(pt))
+		queuewakeup_prepare();
+
+	queuewakeup_block(&q->done);
+	q->status = error;
 
 	list_add_tail(&q->simple_list, pt);
 }
@@ -480,8 +609,8 @@ static void wake_up_sem_queue_prepare(st
  *
  * Do the actual wake-up.
  * The function is called without any locks held, thus the semaphore array
- * could be destroyed already and the tasks can disappear as soon as the
- * status is set to the actual return code.
+ * could be destroyed already and the tasks can disappear as soon as
+ * queuewakeup_handsoff() is called.
  */
 static void wake_up_sem_queue_do(struct list_head *pt)
 {
@@ -491,12 +620,11 @@ static void wake_up_sem_queue_do(struct 
 	did_something = !list_empty(pt);
 	list_for_each_entry_safe(q, t, pt, simple_list) {
 		wake_up_process(q->sleeper);
-		/* q can disappear immediately after writing q->status. */
-		smp_wmb();
-		q->status = q->pid;
+		/* q can disappear immediately after completing q->done */
+		queuewakeup_handsoff(&q->done);
 	}
 	if (did_something)
-		preempt_enable();
+		queuewakeup_completed();
 }
 
 static void unlink_queue(struct sem_array *sma, struct sem_queue *q)
@@ -1300,33 +1428,6 @@ out:
 	return un;
 }
 
-
-/**
- * get_queue_result - Retrieve the result code from sem_queue
- * @q: Pointer to queue structure
- *
- * Retrieve the return code from the pending queue. If IN_WAKEUP is found in
- * q->status, then we must loop until the value is replaced with the final
- * value: This may happen if a task is woken up by an unrelated event (e.g.
- * signal) and in parallel the task is woken up by another task because it got
- * the requested semaphores.
- *
- * The function can be called with or without holding the semaphore spinlock.
- */
-static int get_queue_result(struct sem_queue *q)
-{
-	int error;
-
-	error = q->status;
-	while (unlikely(error == IN_WAKEUP)) {
-		cpu_relax();
-		error = q->status;
-	}
-
-	return error;
-}
-
-
 SYSCALL_DEFINE4(semtimedop, int, semid, struct sembuf __user *, tsops,
 		unsigned, nsops, const struct timespec __user *, timeout)
 {
@@ -1472,6 +1573,7 @@ SYSCALL_DEFINE4(semtimedop, int, semid, 
 
 	queue.status = -EINTR;
 	queue.sleeper = current;
+	queuewakeup_init(&queue.done);
 
 sleep_again:
 	current->state = TASK_INTERRUPTIBLE;
@@ -1482,17 +1584,14 @@ sleep_again:
 	else
 		schedule();
 
-	error = get_queue_result(&queue);
+	error = queue.status;
 
 	if (error != -EINTR) {
 		/* fast path: update_queue already obtained all requested
-		 * resources.
-		 * Perform a smp_mb(): User space could assume that semop()
-		 * is a memory barrier: Without the mb(), the cpu could
-		 * speculatively read in user space stale data that was
-		 * overwritten by the previous owner of the semaphore.
+		 * resources. Just ensure that update_queue completed
+		 * it's access to &queue.
 		 */
-		smp_mb();
+		queuewakeup_wait(&queue.done);
 
 		goto out_free;
 	}
@@ -1502,23 +1601,16 @@ sleep_again:
 	/*
 	 * Wait until it's guaranteed that no wakeup_sem_queue_do() is ongoing.
 	 */
-	error = get_queue_result(&queue);
-
-	/*
-	 * Array removed? If yes, leave without sem_unlock().
-	 */
-	if (IS_ERR(sma)) {
-		goto out_free;
-	}
-
-
-	/*
-	 * If queue.status != -EINTR we are woken up by another process.
-	 * Leave without unlink_queue(), but with sem_unlock().
-	 */
-
+	error = queue.status;
 	if (error != -EINTR) {
-		goto out_unlock_free;
+		/* If there is a return code, then we can leave immediately. */
+		if (!IS_ERR(sma)) {
+			/* sem_lock() succeeded - then unlock */
+			sem_unlock(sma);
+		}
+		/* Except that we must wait for the hands-off */
+		queuewakeup_wait(&queue.done);
+		goto out_free;
 	}
 
 	/*
_

