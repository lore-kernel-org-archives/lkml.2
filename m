Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932851Ab1INNk0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Sep 2011 09:40:26 -0400
Received: from merlin.infradead.org ([205.233.59.134]:46872 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932756Ab1INNkB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Sep 2011 09:40:01 -0400
Message-Id: <20110914133750.916911903@chello.nl>
User-Agent: quilt/0.48-1
Date: Wed, 14 Sep 2011 15:30:37 +0200
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org, Steven Rostedt <rostedt@goodmis.org>,
        Darren Hart <dvhart@linux.intel.com>,
        Manfred Spraul <manfred@colorfullife.com>,
        David Miller <davem@davemloft.net>,
        Eric Dumazet <eric.dumazet@gmail.com>, Mike Galbraith <efault@gmx.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [RFC][PATCH 3/3] ipc/sem: Rework wakeup scheme
References: <20110914133034.687048806@chello.nl>
Content-Disposition: inline; filename=sem-wakeup-list.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The current, convoluted, wakeup scheme exists to avoid two races:

 - if queue.status is set after wake_up_process, then the woken up idle
   thread could race forward and try (and fail) to acquire sma->lock
   before update_queue had a chance to set queue.status
 - if queue.status is written before wake_up_process and if the
   blocked process is woken up by a signal between writing
   queue.status and the wake_up_process, then the woken up
   process could return from semtimedop and die by calling
   sys_exit before wake_up_process is called. Then wake_up_process
   will oops, because the task structure is already invalid.
   (yes, this happened on s390 with sysv msg).

However, we can avoid the latter by keeping a ref on the task struct,
and can thus use the new wake_list infrastructure to issue the wakeups
and set q->status before the wakeup.

This removes the home-brew busy-wait and the requirement to keep
preemption disabled.

Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Manfred Spraul <manfred@colorfullife.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 ipc/sem.c |  155 ++++++++++++++++++--------------------------------------------
 1 file changed, 45 insertions(+), 110 deletions(-)
Index: linux-2.6/ipc/sem.c
===================================================================
--- linux-2.6.orig/ipc/sem.c
+++ linux-2.6/ipc/sem.c
@@ -60,9 +60,6 @@
  *   anything - not even acquiring a lock or dropping a refcount.
  * - A woken up task may not even touch the semaphore array anymore, it may
  *   have been destroyed already by a semctl(RMID).
- * - The synchronizations between wake-ups due to a timeout/signal and a
- *   wake-up due to a completed semaphore operation is achieved by using an
- *   intermediate state (IN_WAKEUP).
  * - UNDO values are stored in an array (one per process and per
  *   semaphore array, lazily allocated). For backwards compatibility, multiple
  *   modes for the UNDO variables are supported (per process, per thread)
@@ -199,33 +196,18 @@ static inline void sem_rmid(struct ipc_n
  * - queue.status is initialized to -EINTR before blocking.
  * - wakeup is performed by
  *	* unlinking the queue entry from sma->sem_pending
- *	* setting queue.status to IN_WAKEUP
+ *	* adding the q->sleeper to the wake_list
+ *	* setting queue.status to error
  *	  This is the notification for the blocked thread that a
  *	  result value is imminent.
- *	* call wake_up_process
- *	* set queue.status to the final value.
+ *
  * - the previously blocked thread checks queue.status:
- *   	* if it's IN_WAKEUP, then it must wait until the value changes
  *   	* if it's not -EINTR, then the operation was completed by
  *   	  update_queue. semtimedop can return queue.status without
  *   	  performing any operation on the sem array.
  *   	* otherwise it must acquire the spinlock and check what's up.
  *
- * The two-stage algorithm is necessary to protect against the following
- * races:
- * - if queue.status is set after wake_up_process, then the woken up idle
- *   thread could race forward and try (and fail) to acquire sma->lock
- *   before update_queue had a chance to set queue.status
- * - if queue.status is written before wake_up_process and if the
- *   blocked process is woken up by a signal between writing
- *   queue.status and the wake_up_process, then the woken up
- *   process could return from semtimedop and die by calling
- *   sys_exit before wake_up_process is called. Then wake_up_process
- *   will oops, because the task structure is already invalid.
- *   (yes, this happened on s390 with sysv msg).
- *
  */
-#define IN_WAKEUP	1
 
 /**
  * newary - Create a new semaphore set
@@ -406,51 +388,39 @@ static int try_atomic_semop (struct sem_
 	return result;
 }
 
-/** wake_up_sem_queue_prepare(q, error): Prepare wake-up
+/** wake_up_sem_queue_prepare(wake_list, q, error): Prepare wake-up
+ * @wake_list: list to queue the to be woken task on
  * @q: queue entry that must be signaled
  * @error: Error value for the signal
  *
  * Prepare the wake-up of the queue entry q.
  */
-static void wake_up_sem_queue_prepare(struct list_head *pt,
+static void wake_up_sem_queue_prepare(struct wake_list_head *wake_list,
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
+	struct task_struct *p = ACCESS_ONCE(q->sleeper);
 
-	list_add_tail(&q->simple_list, pt);
+	get_task_struct(p);
+	q->status = error;
+	/*
+	 * implies a full barrier
+	 */
+	wake_list_add(wake_list, p);
+	put_task_struct(p);
 }
 
 /**
- * wake_up_sem_queue_do(pt) - do the actual wake-up
- * @pt: list of tasks to be woken up
+ * wake_up_sem_queue_do(wake_list) - do the actual wake-up
+ * @wake_list: list of tasks to be woken up
  *
  * Do the actual wake-up.
  * The function is called without any locks held, thus the semaphore array
  * could be destroyed already and the tasks can disappear as soon as the
  * status is set to the actual return code.
  */
-static void wake_up_sem_queue_do(struct list_head *pt)
+static void wake_up_sem_queue_do(struct wake_list_head *wake_list)
 {
-	struct sem_queue *q, *t;
-	int did_something;
-
-	did_something = !list_empty(pt);
-	list_for_each_entry_safe(q, t, pt, simple_list) {
-		wake_up_process(q->sleeper);
-		/* q can disappear immediately after writing q->status. */
-		smp_wmb();
-		q->status = q->pid;
-	}
-	if (did_something)
-		preempt_enable();
+	wake_up_list(wake_list, TASK_ALL);
 }
 
 static void unlink_queue(struct sem_array *sma, struct sem_queue *q)
@@ -527,19 +497,20 @@ static int check_restart(struct sem_arra
 
 
 /**
- * update_queue(sma, semnum): Look for tasks that can be completed.
+ * update_queue(sma, semnum, wake_list): Look for tasks that can be completed.
  * @sma: semaphore array.
  * @semnum: semaphore that was modified.
- * @pt: list head for the tasks that must be woken up.
+ * @wake_list: list for the tasks that must be woken up.
  *
  * update_queue must be called after a semaphore in a semaphore array
  * was modified. If multiple semaphore were modified, then @semnum
  * must be set to -1.
- * The tasks that must be woken up are added to @pt. The return code
+ * The tasks that must be woken up are added to @wake_list. The return code
  * is stored in q->pid.
  * The function return 1 if at least one semop was completed successfully.
  */
-static int update_queue(struct sem_array *sma, int semnum, struct list_head *pt)
+static int
+update_queue(struct sem_array *sma, int semnum, struct wake_list_head *wake_list)
 {
 	struct sem_queue *q;
 	struct list_head *walk;
@@ -597,7 +568,7 @@ static int update_queue(struct sem_array
 			restart = check_restart(sma, q);
 		}
 
-		wake_up_sem_queue_prepare(pt, q, error);
+		wake_up_sem_queue_prepare(wake_list, q, error);
 		if (restart)
 			goto again;
 	}
@@ -605,26 +576,26 @@ static int update_queue(struct sem_array
 }
 
 /**
- * do_smart_update(sma, sops, nsops, otime, pt) - optimized update_queue
+ * do_smart_update(sma, sops, nsops, otime, wake_list) - optimized update_queue
  * @sma: semaphore array
  * @sops: operations that were performed
  * @nsops: number of operations
  * @otime: force setting otime
- * @pt: list head of the tasks that must be woken up.
+ * @wake_list: list of the tasks that must be woken up.
  *
  * do_smart_update() does the required called to update_queue, based on the
  * actual changes that were performed on the semaphore array.
  * Note that the function does not do the actual wake-up: the caller is
- * responsible for calling wake_up_sem_queue_do(@pt).
+ * responsible for calling wake_up_sem_queue_do(@wake_list).
  * It is safe to perform this call after dropping all locks.
  */
 static void do_smart_update(struct sem_array *sma, struct sembuf *sops, int nsops,
-			int otime, struct list_head *pt)
+			int otime, struct wake_list_head *wake_list)
 {
 	int i;
 
 	if (sma->complex_count || sops == NULL) {
-		if (update_queue(sma, -1, pt))
+		if (update_queue(sma, -1, wake_list))
 			otime = 1;
 		goto done;
 	}
@@ -633,7 +604,7 @@ static void do_smart_update(struct sem_a
 		if (sops[i].sem_op > 0 ||
 			(sops[i].sem_op < 0 &&
 				sma->sem_base[sops[i].sem_num].semval == 0))
-			if (update_queue(sma, sops[i].sem_num, pt))
+			if (update_queue(sma, sops[i].sem_num, wake_list))
 				otime = 1;
 	}
 done:
@@ -698,7 +669,7 @@ static void freeary(struct ipc_namespace
 	struct sem_undo *un, *tu;
 	struct sem_queue *q, *tq;
 	struct sem_array *sma = container_of(ipcp, struct sem_array, sem_perm);
-	struct list_head tasks;
+	WAKE_LIST(wake_list);
 
 	/* Free the existing undo structures for this semaphore set.  */
 	assert_spin_locked(&sma->sem_perm.lock);
@@ -712,17 +683,16 @@ static void freeary(struct ipc_namespace
 	}
 
 	/* Wake up all pending processes and let them fail with EIDRM. */
-	INIT_LIST_HEAD(&tasks);
 	list_for_each_entry_safe(q, tq, &sma->sem_pending, list) {
 		unlink_queue(sma, q);
-		wake_up_sem_queue_prepare(&tasks, q, -EIDRM);
+		wake_up_sem_queue_prepare(&wake_list, q, -EIDRM);
 	}
 
 	/* Remove the semaphore set from the IDR */
 	sem_rmid(ns, sma);
 	sem_unlock(sma);
 
-	wake_up_sem_queue_do(&tasks);
+	wake_up_sem_queue_do(&wake_list);
 	ns->used_sems -= sma->sem_nsems;
 	security_sem_free(sma);
 	ipc_rcu_putref(sma);
@@ -846,13 +816,12 @@ static int semctl_main(struct ipc_namesp
 	ushort fast_sem_io[SEMMSL_FAST];
 	ushort* sem_io = fast_sem_io;
 	int nsems;
-	struct list_head tasks;
+	WAKE_LIST(wake_list);
 
 	sma = sem_lock_check(ns, semid);
 	if (IS_ERR(sma))
 		return PTR_ERR(sma);
 
-	INIT_LIST_HEAD(&tasks);
 	nsems = sma->sem_nsems;
 
 	err = -EACCES;
@@ -941,7 +910,7 @@ static int semctl_main(struct ipc_namesp
 		}
 		sma->sem_ctime = get_seconds();
 		/* maybe some queued-up processes were waiting for this */
-		do_smart_update(sma, NULL, 0, 0, &tasks);
+		do_smart_update(sma, NULL, 0, 0, &wake_list);
 		err = 0;
 		goto out_unlock;
 	}
@@ -983,14 +952,14 @@ static int semctl_main(struct ipc_namesp
 		curr->sempid = task_tgid_vnr(current);
 		sma->sem_ctime = get_seconds();
 		/* maybe some queued-up processes were waiting for this */
-		do_smart_update(sma, NULL, 0, 0, &tasks);
+		do_smart_update(sma, NULL, 0, 0, &wake_list);
 		err = 0;
 		goto out_unlock;
 	}
 	}
 out_unlock:
 	sem_unlock(sma);
-	wake_up_sem_queue_do(&tasks);
+	wake_up_sem_queue_do(&wake_list);
 
 out_free:
 	if(sem_io != fast_sem_io)
@@ -1255,32 +1224,6 @@ static struct sem_undo *find_alloc_undo(
 }
 
 
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
@@ -1293,7 +1236,7 @@ SYSCALL_DEFINE4(semtimedop, int, semid, 
 	struct sem_queue queue;
 	unsigned long jiffies_left = 0;
 	struct ipc_namespace *ns;
-	struct list_head tasks;
+	WAKE_LIST(wake_list);
 
 	ns = current->nsproxy->ipc_ns;
 
@@ -1342,8 +1285,6 @@ SYSCALL_DEFINE4(semtimedop, int, semid, 
 	} else
 		un = NULL;
 
-	INIT_LIST_HEAD(&tasks);
-
 	sma = sem_lock_check(ns, semid);
 	if (IS_ERR(sma)) {
 		if (un)
@@ -1392,7 +1333,7 @@ SYSCALL_DEFINE4(semtimedop, int, semid, 
 	error = try_atomic_semop (sma, sops, nsops, un, task_tgid_vnr(current));
 	if (error <= 0) {
 		if (alter && error == 0)
-			do_smart_update(sma, sops, nsops, 1, &tasks);
+			do_smart_update(sma, sops, nsops, 1, &wake_list);
 
 		goto out_unlock_free;
 	}
@@ -1434,8 +1375,7 @@ SYSCALL_DEFINE4(semtimedop, int, semid, 
 	else
 		schedule();
 
-	error = get_queue_result(&queue);
-
+	error = queue.status;
 	if (error != -EINTR) {
 		/* fast path: update_queue already obtained all requested
 		 * resources.
@@ -1450,11 +1390,7 @@ SYSCALL_DEFINE4(semtimedop, int, semid, 
 	}
 
 	sma = sem_lock(ns, semid);
-
-	/*
-	 * Wait until it's guaranteed that no wakeup_sem_queue_do() is ongoing.
-	 */
-	error = get_queue_result(&queue);
+	error = queue.status;
 
 	/*
 	 * Array removed? If yes, leave without sem_unlock().
@@ -1484,7 +1420,7 @@ SYSCALL_DEFINE4(semtimedop, int, semid, 
 out_unlock_free:
 	sem_unlock(sma);
 
-	wake_up_sem_queue_do(&tasks);
+	wake_up_sem_queue_do(&wake_list);
 out_free:
 	if(sops != fast_sops)
 		kfree(sops);
@@ -1545,7 +1481,7 @@ void exit_sem(struct task_struct *tsk)
 	for (;;) {
 		struct sem_array *sma;
 		struct sem_undo *un;
-		struct list_head tasks;
+		WAKE_LIST(wake_list);
 		int semid;
 		int i;
 
@@ -1610,10 +1546,9 @@ void exit_sem(struct task_struct *tsk)
 			}
 		}
 		/* maybe some queued-up processes were waiting for this */
-		INIT_LIST_HEAD(&tasks);
-		do_smart_update(sma, NULL, 0, 1, &tasks);
+		do_smart_update(sma, NULL, 0, 1, &wake_list);
 		sem_unlock(sma);
-		wake_up_sem_queue_do(&tasks);
+		wake_up_sem_queue_do(&wake_list);
 
 		kfree_rcu(un, rcu);
 	}


