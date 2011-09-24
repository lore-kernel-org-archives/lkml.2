Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752189Ab1IXRap (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Sep 2011 13:30:45 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:48729 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752101Ab1IXRan (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Sep 2011 13:30:43 -0400
From: Manfred Spraul <manfred@colorfullife.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Mike Galbraith <efault@gmx.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Manfred Spraul <manfred@colorfullife.com>
Subject: [PATCH 3/3] [RFC] ipc/sem.c: replace busy loop with completion
Date: Sat, 24 Sep 2011 19:37:18 +0200
Message-Id: <1316885838-12026-1-git-send-email-manfred@colorfullife.com>
X-Mailer: git-send-email 1.7.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ipc/sem.c uses a custom busy loop to handle a rare race and short
race condition (typically the loop is shorter than one wake_up_process()).

Unfortunately this loop is broken on -rt, thus this patch converts the
code to use a completion instead.

The patch introduces a small performance reduction:
- every semtimedop() does two additional spin_lock_irq()/spin_unlock_irq()
  instead of just an smp_wmb() [one in the waking thread, one in the
  woken up thread]
- If the race happens, then the woken up thread does an additional schedule()
  loop.

What do you think?

Peter:
I'd prefer something like this instead of moving wake_up_process() under sem_lock().

Suggested-by: Thomas Gleixner <tglx@linutronix.de>
Reported-by: Mike Galbraith <efault@gmx.de>
Signed-off-by: Manfred Spraul <manfred@colorfullife.com>
---
 include/linux/sem.h |    2 +
 ipc/sem.c           |   89 ++++++++++++++++-----------------------------------
 2 files changed, 30 insertions(+), 61 deletions(-)

diff --git a/include/linux/sem.h b/include/linux/sem.h
index 1feb2de..bac6b39 100644
--- a/include/linux/sem.h
+++ b/include/linux/sem.h
@@ -80,6 +80,7 @@ struct  seminfo {
 #include <linux/atomic.h>
 #include <linux/rcupdate.h>
 #include <linux/cache.h>
+#include <linux/completion.h>
 
 struct task_struct;
 
@@ -114,6 +115,7 @@ struct sem_queue {
 	struct sembuf		*sops;	 /* array of pending operations */
 	int			nsops;	 /* number of operations */
 	int			alter;   /* does the operation alter the array? */
+	struct completion	done;	 /* wakeup completion */
 };
 
 /* Each task has a list of undo requests. They are executed automatically
diff --git a/ipc/sem.c b/ipc/sem.c
index 227948f..57fdf60 100644
--- a/ipc/sem.c
+++ b/ipc/sem.c
@@ -61,8 +61,8 @@
  * - A woken up task may not even touch the semaphore array anymore, it may
  *   have been destroyed already by a semctl(RMID).
  * - The synchronizations between wake-ups due to a timeout/signal and a
- *   wake-up due to a completed semaphore operation is achieved by using an
- *   intermediate state (IN_WAKEUP).
+ *   wake-up due to a completed semaphore operation is achieved by using a
+ *   completion.
  * - UNDO values are stored in an array (one per process and per
  *   semaphore array, lazily allocated). For backwards compatibility, multiple
  *   modes for the UNDO variables are supported (per process, per thread)
@@ -199,19 +199,20 @@ static inline void sem_rmid(struct ipc_namespace *ns, struct sem_array *s)
  * - queue.status is initialized to -EINTR before blocking.
  * - wakeup is performed by
  *	* unlinking the queue entry from sma->sem_pending
- *	* setting queue.status to IN_WAKEUP
+ *	* setting queue.status to the actual result code
  *	  This is the notification for the blocked thread that a
  *	  result value is imminent.
  *	* call wake_up_process
- *	* set queue.status to the final value.
+ *	* complete_all(&q->done);
  * - the previously blocked thread checks queue.status:
- *   	* if it's IN_WAKEUP, then it must wait until the value changes
- *   	* if it's not -EINTR, then the operation was completed by
+ *   	* if it's not -EINTR, then it must wait on q->done.
+ *   	* After the completion was signaled:
+ *   	  - if it's not -EINTR, then the operation was completed by
  *   	  update_queue. semtimedop can return queue.status without
  *   	  performing any operation on the sem array.
- *   	* otherwise it must acquire the spinlock and check what's up.
+ *   	  - otherwise it must acquire the spinlock and do the cleanup
  *
- * The two-stage algorithm is necessary to protect against the following
+ * The completion is necessary to protect against the following
  * races:
  * - if queue.status is set after wake_up_process, then the woken up idle
  *   thread could race forward and try (and fail) to acquire sma->lock
@@ -225,7 +226,6 @@ static inline void sem_rmid(struct ipc_namespace *ns, struct sem_array *s)
  *   (yes, this happened on s390 with sysv msg).
  *
  */
-#define IN_WAKEUP	1
 
 /**
  * newary - Create a new semaphore set
@@ -415,15 +415,7 @@ undo:
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
+	q->status = error;
 
 	list_add_tail(&q->simple_list, pt);
 }
@@ -440,17 +432,12 @@ static void wake_up_sem_queue_prepare(struct list_head *pt,
 static void wake_up_sem_queue_do(struct list_head *pt)
 {
 	struct sem_queue *q, *t;
-	int did_something;
 
-	did_something = !list_empty(pt);
 	list_for_each_entry_safe(q, t, pt, simple_list) {
 		wake_up_process(q->sleeper);
-		/* q can disappear immediately after writing q->status. */
-		smp_wmb();
-		q->status = q->pid;
+		/* q can disappear immediately after completing q->done */
+		complete_all(&q->done);
 	}
-	if (did_something)
-		preempt_enable();
 }
 
 static void unlink_queue(struct sem_array *sma, struct sem_queue *q)
@@ -1254,33 +1241,6 @@ out:
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
@@ -1426,6 +1386,7 @@ SYSCALL_DEFINE4(semtimedop, int, semid, struct sembuf __user *, tsops,
 
 	queue.status = -EINTR;
 	queue.sleeper = current;
+	init_completion(&queue.done);
 
 sleep_again:
 	current->state = TASK_INTERRUPTIBLE;
@@ -1436,17 +1397,14 @@ sleep_again:
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
+		wait_for_completion(&queue.done);
 
 		goto out_free;
 	}
@@ -1456,8 +1414,17 @@ sleep_again:
 	/*
 	 * Wait until it's guaranteed that no wakeup_sem_queue_do() is ongoing.
 	 */
-	error = get_queue_result(&queue);
-
+	error = queue.status;
+	if (error != -EINTR) {
+		/* If there is a return code, then we can leave immediately. */
+		if (!IS_ERR(sma)) {
+			sem_unlock(sma);
+		}
+		/* Except that we must wait for the hands-off */
+		wait_for_completion(&queue.done);
+		goto out_free;
+	}
+ 
 	/*
 	 * Array removed? If yes, leave without sem_unlock().
 	 */
-- 
1.7.6

