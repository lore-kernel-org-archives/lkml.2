Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756696Ab0D1TGd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Apr 2010 15:06:33 -0400
Received: from fg-out-1718.google.com ([72.14.220.153]:60231 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756630Ab0D1TGX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Apr 2010 15:06:23 -0400
From: Manfred Spraul <manfred@colorfullife.com>
To: LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: Chris Mason <chris.mason@oracle.com>, Zach Brown <zach.brown@oracle.com>,
       Jens Axboe <jens.axboe@oracle.com>, Nick Piggin <npiggin@suse.de>,
       Manfred Spraul <manfred@colorfullife.com>
Subject: [PATCH 2/2] ipc/sem.c: move wake_up_process out of the spinlock section
Date: Wed, 28 Apr 2010 21:06:27 +0200
Message-Id: <1272481588-1941-3-git-send-email-manfred@colorfullife.com>
X-Mailer: git-send-email 1.6.6.1
In-Reply-To: <1272481588-1941-2-git-send-email-manfred@colorfullife.com>
References: <1272481588-1941-1-git-send-email-manfred@colorfullife.com>
 <1272481588-1941-2-git-send-email-manfred@colorfullife.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The wake-up part of semtimedop() consists out of two steps:
- the right tasks must be identified.
- they must be woken up.

Right now, both steps run while the array spinlock is held.
This patch reorders the code and moves the actual wake_up_process()
behind the point where the spinlock is dropped.

The code also moves setting sem->sem_otime to one place: It does not
make sense to set the last modify time multiple times.

Signed-off-by: Manfred Spraul <manfred@colorfullife.com>
---
 ipc/sem.c |  117 +++++++++++++++++++++++++++++++++++++++++++++----------------
 1 files changed, 87 insertions(+), 30 deletions(-)

diff --git a/ipc/sem.c b/ipc/sem.c
index 3f6d781..c263309 100644
--- a/ipc/sem.c
+++ b/ipc/sem.c
@@ -381,7 +381,6 @@ static int try_atomic_semop (struct sem_array * sma, struct sembuf * sops,
 		sop--;
 	}
 	
-	sma->sem_otime = get_seconds();
 	return 0;
 
 out_of_range:
@@ -404,25 +403,50 @@ undo:
 	return result;
 }
 
-/*
- * Wake up a process waiting on the sem queue with a given error.
- * The queue is invalid (may not be accessed) after the function returns.
+/** wake_up_sem_queue_prepare(q, error): Prepare wake-up
+ * @q: queue entry that must be signaled
+ * @error: Error value for the signal
+ *
+ * Prepare the wake-up of the queue entry q.
  */
-static void wake_up_sem_queue(struct sem_queue *q, int error)
+static void wake_up_sem_queue_prepare(struct list_head *pt,
+				struct sem_queue *q, int error)
 {
-	/*
-	 * Hold preempt off so that we don't get preempted and have the
-	 * wakee busy-wait until we're scheduled back on. We're holding
-	 * locks here so it may not strictly be needed, however if the
-	 * locks become preemptible then this prevents such a problem.
-	 */
-	preempt_disable();
+	if (list_empty(pt)) {
+		/*
+		 * Hold preempt off so that we don't get preempted and have the
+		 * wakee busy-wait until we're scheduled back on.
+		 */
+		preempt_disable();
+	}
 	q->status = IN_WAKEUP;
-	wake_up_process(q->sleeper);
-	/* hands-off: q can disappear immediately after writing q->status. */
-	smp_wmb();
-	q->status = error;
-	preempt_enable();
+	q->pid = error;
+
+	list_add_tail(&q->simple_list, pt);
+}
+
+/** wake_up_sem_queue_do(pt): Do the actual wake-up
+ * @pt: list of tasks to be woken up
+ *
+ * Do the actual wake-up.
+ * The function is called without any locks held, thus the semaphore array
+ * could be destroyed already and the tasks can disappear as soon as the
+ * status is set to the actual return code.
+ */
+static void wake_up_sem_queue_do(struct list_head *pt)
+{
+	struct sem_queue *q, *t;
+	int did_something;
+
+	did_something = !list_empty(pt);
+	list_for_each_entry_safe(q, t, pt, simple_list) {
+		wake_up_process(q->sleeper);
+		/* q can disappear immediately after writing q->status. */
+		smp_wmb();
+		q->status = q->pid;
+	}
+	if (did_something)
+		preempt_enable();
 }
 
 static void unlink_queue(struct sem_array *sma, struct sem_queue *q)
@@ -502,17 +526,22 @@ static int check_restart(struct sem_array *sma, struct sem_queue *q)
  * update_queue(sma, semnum): Look for tasks that can be completed.
  * @sma: semaphore array.
  * @semnum: semaphore that was modified.
+ * @pt: list head for the tasks that must be woken up.
  *
  * update_queue must be called after a semaphore in a semaphore array
  * was modified. If multiple semaphore were modified, then @semnum
  * must be set to -1.
+ * The tasks that must be woken up are added to @pt. The return code
+ * is stored in q->pid.
+ * The function return 1 if at least one array variable was modified.
  */
-static void update_queue(struct sem_array *sma, int semnum)
+static int update_queue(struct sem_array *sma, int semnum, struct list_head *pt)
 {
 	struct sem_queue *q;
 	struct list_head *walk;
 	struct list_head *pending_list;
 	int offset;
+	int retval;
 
 	/* if there are complex operations around, then knowing the semaphore
 	 * that was modified doesn't help us. Assume that multiple semaphores
@@ -556,41 +585,55 @@ again:
 			continue;
 
 		unlink_queue(sma, q);
+		if (q->alter)
+			retval = 1;
 
 		if (error)
 			restart = 0;
 		else
 			restart = check_restart(sma, q);
 
-		wake_up_sem_queue(q, error);
+		wake_up_sem_queue_prepare(pt, q, error);
 		if (restart)
 			goto again;
 	}
+	return retval;
 }
 
-/** do_smart_update(sma, sops, nsops): Optimized update_queue
+/** do_smart_update(sma, sops, nsops, otime, pt): Optimized update_queue
  * @sma: semaphore array
  * @sops: operations that were performed
  * @nsops: number of operations
+ * @otime: force setting otime
+ * @pt: list head of the tasks that must be woken up.
  *
  * do_smart_update() does the required called to update_queue, based on the
  * actual changes that were performed on the semaphore array.
+ * Note that the function does not do the actual wake-up: the caller is
+ * responsible for calling wake_up_sem_queue_do(@pt).
+ * It is safe to perform this call after dropping all locks.
  */
-void do_smart_update(struct sem_array *sma, struct sembuf *sops, int nsops)
+void do_smart_update(struct sem_array *sma, struct sembuf *sops, int nsops,
+			int otime, struct list_head *pt)
 {
 	int i;
 
 	if (sma->complex_count || sops == NULL) {
-		update_queue(sma, -1);
-		return;
+		if (update_queue(sma, -1, pt))
+			otime = 1;
+		goto done;
 	}
 
 	for (i = 0; i < nsops; i++) {
 		if (sops[i].sem_op > 0 ||
 			(sops[i].sem_op < 0 &&
 				sma->sem_base[sops[i].sem_num].semval == 0))
-			update_queue(sma, sops[i].sem_num);
+			if (update_queue(sma, sops[i].sem_num, pt))
+				otime = 1;
 	}
+done:
+	if (otime)
+		sma->sem_otime = get_seconds();
 }
 
 
@@ -656,6 +699,7 @@ static void freeary(struct ipc_namespace *ns, struct kern_ipc_perm *ipcp)
 	struct sem_undo *un, *tu;
 	struct sem_queue *q, *tq;
 	struct sem_array *sma = container_of(ipcp, struct sem_array, sem_perm);
+	struct list_head tasks;
 
 	/* Free the existing undo structures for this semaphore set.  */
 	assert_spin_locked(&sma->sem_perm.lock);
@@ -669,15 +713,17 @@ static void freeary(struct ipc_namespace *ns, struct kern_ipc_perm *ipcp)
 	}
 
 	/* Wake up all pending processes and let them fail with EIDRM. */
+	INIT_LIST_HEAD(&tasks);
 	list_for_each_entry_safe(q, tq, &sma->sem_pending, list) {
 		unlink_queue(sma, q);
-		wake_up_sem_queue(q, -EIDRM);
+		wake_up_sem_queue_prepare(&tasks, q, -EIDRM);
 	}
 
 	/* Remove the semaphore set from the IDR */
 	sem_rmid(ns, sma);
 	sem_unlock(sma);
 
+	wake_up_sem_queue_do(&tasks);
 	ns->used_sems -= sma->sem_nsems;
 	security_sem_free(sma);
 	ipc_rcu_putref(sma);
@@ -799,11 +845,13 @@ static int semctl_main(struct ipc_namespace *ns, int semid, int semnum,
 	ushort fast_sem_io[SEMMSL_FAST];
 	ushort* sem_io = fast_sem_io;
 	int nsems;
+	struct list_head tasks;
 
 	sma = sem_lock_check(ns, semid);
 	if (IS_ERR(sma))
 		return PTR_ERR(sma);
 
+	INIT_LIST_HEAD(&tasks);
 	nsems = sma->sem_nsems;
 
 	err = -EACCES;
@@ -891,7 +939,7 @@ static int semctl_main(struct ipc_namespace *ns, int semid, int semnum,
 		}
 		sma->sem_ctime = get_seconds();
 		/* maybe some queued-up processes were waiting for this */
-		update_queue(sma, -1);
+		do_smart_update(sma, NULL, 0, 0, &tasks);
 		err = 0;
 		goto out_unlock;
 	}
@@ -933,13 +981,15 @@ static int semctl_main(struct ipc_namespace *ns, int semid, int semnum,
 		curr->sempid = task_tgid_vnr(current);
 		sma->sem_ctime = get_seconds();
 		/* maybe some queued-up processes were waiting for this */
-		update_queue(sma, semnum);
+		do_smart_update(sma, NULL, 0, 0, &tasks);
 		err = 0;
 		goto out_unlock;
 	}
 	}
 out_unlock:
 	sem_unlock(sma);
+	wake_up_sem_queue_do(&tasks);
+
 out_free:
 	if(sem_io != fast_sem_io)
 		ipc_free(sem_io, sizeof(ushort)*nsems);
@@ -1213,6 +1263,7 @@ SYSCALL_DEFINE4(semtimedop, int, semid, struct sembuf __user *, tsops,
 	struct sem_queue queue;
 	unsigned long jiffies_left = 0;
 	struct ipc_namespace *ns;
+	struct list_head tasks;
 
 	ns = current->nsproxy->ipc_ns;
 
@@ -1261,6 +1312,8 @@ SYSCALL_DEFINE4(semtimedop, int, semid, struct sembuf __user *, tsops,
 	} else
 		un = NULL;
 
+	INIT_LIST_HEAD(&tasks);
+
 	sma = sem_lock_check(ns, semid);
 	if (IS_ERR(sma)) {
 		if (un)
@@ -1309,7 +1362,7 @@ SYSCALL_DEFINE4(semtimedop, int, semid, struct sembuf __user *, tsops,
 	error = try_atomic_semop (sma, sops, nsops, un, task_tgid_vnr(current));
 	if (error <= 0) {
 		if (alter && error == 0)
-			do_smart_update(sma, sops, nsops);
+			do_smart_update(sma, sops, nsops, 1, &tasks);
 
 		goto out_unlock_free;
 	}
@@ -1386,6 +1439,8 @@ SYSCALL_DEFINE4(semtimedop, int, semid, struct sembuf __user *, tsops,
 
 out_unlock_free:
 	sem_unlock(sma);
+
+	wake_up_sem_queue_do(&tasks);
 out_free:
 	if(sops != fast_sops)
 		kfree(sops);
@@ -1446,6 +1501,7 @@ void exit_sem(struct task_struct *tsk)
 	for (;;) {
 		struct sem_array *sma;
 		struct sem_undo *un;
+		struct list_head tasks;
 		int semid;
 		int i;
 
@@ -1509,10 +1565,11 @@ void exit_sem(struct task_struct *tsk)
 				semaphore->sempid = task_tgid_vnr(current);
 			}
 		}
-		sma->sem_otime = get_seconds();
 		/* maybe some queued-up processes were waiting for this */
-		update_queue(sma, -1);
+		INIT_LIST_HEAD(&tasks);
+		do_smart_update(sma, NULL, 0, 1, &tasks);
 		sem_unlock(sma);
+		wake_up_sem_queue_do(&tasks);
 
 		call_rcu(&un->rcu, free_un);
 	}
-- 
1.6.6.1

