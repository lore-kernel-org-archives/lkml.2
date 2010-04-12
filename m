Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753791Ab0DLTVp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Apr 2010 15:21:45 -0400
Received: from acsinet11.oracle.com ([141.146.126.233]:40138 "EHLO
	acsinet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753689Ab0DLTVo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Apr 2010 15:21:44 -0400
From: Chris Mason <chris.mason@oracle.com>
To: chris.mason@oracle.com, zach.brown@oracle.com, jens.axboe@oracle.com,
       linux-kernel@vger.kernel.org, Nick Piggin <npiggin@suse.de>,
       Manfred Spraul <manfred@colorfullife.com>
Subject: [PATCH 1/2] ipc semaphores: reduce ipc_lock contention in semtimedop
Date: Mon, 12 Apr 2010 14:49:22 -0400
Message-Id: <1271098163-3663-2-git-send-email-chris.mason@oracle.com>
X-Mailer: git-send-email 1.7.0.3
In-Reply-To: <1271098163-3663-1-git-send-email-chris.mason@oracle.com>
References: <1271098163-3663-1-git-send-email-chris.mason@oracle.com>
X-Source-IP: acsmt354.oracle.com [141.146.40.154]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090209.4BC36D40.00CA:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

One feature of the ipc semaphores is they are defined to be
atomic for the full set of operations done per syscall.  So if you do a
semtimedop syscall changing 100 semaphores, the kernel needs to try all
100 changes and only apply them when all 100 are able to succeed without
putting the process to sleep.

Today we use a single lock per semaphore array (the ipc lock).  This lock is
held every time we try a set of operations requested by userland, and
when taken again when a process is woken up.

Whenever a given set of changes sent to semtimedop would sleep, that
set is queued up on a big list of pending changes for the entire
semaphore array.

Whenever a semtimedop call changes a single semaphore value, it
walks the entire list of pending operations to see if any of them
can now succeed.  The ipc lock is held for this entire loop.

This change makes two major changes, pushing both the list of pending
operations and a spinlock down to each individual semaphore.  Now:

Whenever a given semaphore modification is going to block, the set of
operations semtimedop wants to do is saved onto that semaphore's list.

Whenever a givem semtimedop call changes a single semaphore value, it
walks the list of pending operations on that single semaphore to see if
they can now succeed.  If any of the operations will block on a
different semaphore, they are moved to that semaphore's list.

The locking is now done per-semaphore.  In order to get the changes done
atomically, the lock of every semaphore being changed is taken while we
test the requested operations.  We sort the operations by semaphore id
to make sure we don't deadlock in the kernel.

I have a microbenchmark to test how quickly we can post and wait in
bulk.  With this change, semtimedop is able do to more than twice
as much work in the same run.  On a large numa machine, it brings
the IPC lock system time (reported by perf) down from 85% to 15%.

Signed-off-by: Chris Mason <chris.mason@oracle.com>
---
 include/linux/sem.h |    4 +-
 ipc/sem.c           |  504 +++++++++++++++++++++++++++++++++++++--------------
 2 files changed, 372 insertions(+), 136 deletions(-)

diff --git a/include/linux/sem.h b/include/linux/sem.h
index 8a4adbe..8b97b51 100644
--- a/include/linux/sem.h
+++ b/include/linux/sem.h
@@ -86,6 +86,7 @@ struct task_struct;
 struct sem {
 	int	semval;		/* current value */
 	int	sempid;		/* pid of last operation */
+	spinlock_t		lock;
 	struct list_head sem_pending; /* pending single-sop operations */
 };
 
@@ -95,15 +96,12 @@ struct sem_array {
 	time_t			sem_otime;	/* last semop time */
 	time_t			sem_ctime;	/* last change time */
 	struct sem		*sem_base;	/* ptr to first semaphore in array */
-	struct list_head	sem_pending;	/* pending operations to be processed */
 	struct list_head	list_id;	/* undo requests on this array */
 	int			sem_nsems;	/* no. of semaphores in array */
-	int			complex_count;	/* pending complex operations */
 };
 
 /* One queue for each sleeping process in the system. */
 struct sem_queue {
-	struct list_head	simple_list; /* queue of pending operations */
 	struct list_head	list;	 /* queue of pending operations */
 	struct task_struct	*sleeper; /* this process */
 	struct sem_undo		*undo;	 /* undo structure */
diff --git a/ipc/sem.c b/ipc/sem.c
index dbef95b..335cd35 100644
--- a/ipc/sem.c
+++ b/ipc/sem.c
@@ -83,6 +83,8 @@
 #include <linux/rwsem.h>
 #include <linux/nsproxy.h>
 #include <linux/ipc_namespace.h>
+#include <linux/sort.h>
+#include <linux/list_sort.h>
 
 #include <asm/uaccess.h>
 #include "util.h"
@@ -195,24 +197,23 @@ static inline void sem_rmid(struct ipc_namespace *ns, struct sem_array *s)
  * Without the check/retry algorithm a lockless wakeup is possible:
  * - queue.status is initialized to -EINTR before blocking.
  * - wakeup is performed by
- *	* unlinking the queue entry from sma->sem_pending
  *	* setting queue.status to IN_WAKEUP
  *	  This is the notification for the blocked thread that a
  *	  result value is imminent.
  *	* call wake_up_process
  *	* set queue.status to the final value.
  * - the previously blocked thread checks queue.status:
- *   	* if it's IN_WAKEUP, then it must wait until the value changes
- *   	* if it's not -EINTR, then the operation was completed by
- *   	  update_queue. semtimedop can return queue.status without
- *   	  performing any operation on the sem array.
- *   	* otherwise it must acquire the spinlock and check what's up.
+ *	* if it's IN_WAKEUP, then it must wait until the value changes
+ *	* if it's not -EINTR, then the operation was completed by
+ *	  update_queue. semtimedop can return queue.status without
+ *	  performing any operation on the sem array.
+ *	* otherwise it must find itself on the list of pending operations.
  *
  * The two-stage algorithm is necessary to protect against the following
  * races:
  * - if queue.status is set after wake_up_process, then the woken up idle
- *   thread could race forward and try (and fail) to acquire sma->lock
- *   before update_queue had a chance to set queue.status
+ *   thread could race forward and not realize its semaphore operation had
+ *   happened.
  * - if queue.status is written before wake_up_process and if the
  *   blocked process is woken up by a signal between writing
  *   queue.status and the wake_up_process, then the woken up
@@ -275,11 +276,11 @@ static int newary(struct ipc_namespace *ns, struct ipc_params *params)
 
 	sma->sem_base = (struct sem *) &sma[1];
 
-	for (i = 0; i < nsems; i++)
+	for (i = 0; i < nsems; i++) {
 		INIT_LIST_HEAD(&sma->sem_base[i].sem_pending);
+		spin_lock_init(&sma->sem_base[i].lock);
+	}
 
-	sma->complex_count = 0;
-	INIT_LIST_HEAD(&sma->sem_pending);
 	INIT_LIST_HEAD(&sma->list_id);
 	sma->sem_nsems = nsems;
 	sma->sem_ctime = get_seconds();
@@ -338,34 +339,115 @@ SYSCALL_DEFINE3(semget, key_t, key, int, nsems, int, semflg)
 }
 
 /*
+ * when a semaphore is modified, we want to retry the series of operations
+ * for anyone that was blocking on that semaphore.  This breaks down into
+ * a few different common operations:
+ *
+ * 1) One modification releases one or more waiters for zero.
+ * 2) Many waiters are trying to get a single lock, only one will get it.
+ * 3) Many modifications to the count will succeed.
+ *
+ * For case one, we copy over anyone waiting for zero when the semval is
+ * zero.  We don't bother copying them over if the semval isn't zero yet.
+ *
+ * For case two, we copy over the first queue trying to modify the semaphore,
+ * assuming it is trying to get a lock.
+ *
+ * For case three, after the first queue trying to change this semaphore is
+ * run, it will call this function again.  It'll find the next queue
+ * that wants to change things at that time.
+ *
+ * The goal behind all of this is to avoid retrying atomic ops that have
+ * no hope of actually completing.  It is optimized for the case where a
+ * call modifies a single semaphore at a time.
+ */
+static void copy_sem_queue(unsigned long semval,
+			   unsigned short sem_num, struct list_head *queue,
+			   struct list_head *dest)
+{
+	struct sem_queue *q;
+	struct sem_queue *safe;
+
+	list_for_each_entry_safe(q, safe, queue, list) {
+		/*
+		 * if this is a complex operation, we don't really know what is
+		 * going on.  Splice the whole list over to preserve the queue
+		 * order.
+		 */
+		if (q->sops[0].sem_num != sem_num) {
+			list_splice_tail_init(queue, dest);
+			break;
+		}
+
+		/*
+		 * they are waiting for zero, leave it on the list if
+		 * we're not at zero yet, otherwise copy it over
+		 */
+		if (q->sops[0].sem_op == 0) {
+			if (semval == 0) {
+				list_del(&q->list);
+				list_add_tail(&q->list, dest);
+			}
+			continue;
+		}
+
+		/*
+		 * at this point we know the first sop in the queue is
+		 * changing this semaphore.  Copy this one queue over
+		 * and leave the rest.  If more than one alter is going
+		 * to succeed, the others will bubble in after each
+		 * one is able to modify the queue.
+		 */
+		list_del(&q->list);
+		list_add_tail(&q->list, dest);
+		break;
+	}
+}
+
+/*
  * Determine whether a sequence of semaphore operations would succeed
  * all at once. Return 0 if yes, 1 if need to sleep, else return error code.
  */
-
-static int try_atomic_semop (struct sem_array * sma, struct sembuf * sops,
-			     int nsops, struct sem_undo *un, int pid)
+static noinline int try_atomic_semop (struct sem_array * sma, struct sembuf * sops,
+			     int nsops, struct sem_undo *un, int pid,
+			     struct list_head *pending, struct sem **blocker)
 {
 	int result, sem_op;
 	struct sembuf *sop;
 	struct sem * curr;
+	int last = 0;
 
 	for (sop = sops; sop < sops + nsops; sop++) {
 		curr = sma->sem_base + sop->sem_num;
+
+		/*
+		 * deal with userland sending the same
+		 * sem_num twice.  Thanks to sort they will
+		 * be adjacent.  We unlock in the loops below.
+		 */
+		if (sop == sops || last != sop->sem_num)
+			spin_lock(&curr->lock);
+
+		last = sop->sem_num;
 		sem_op = sop->sem_op;
 		result = curr->semval;
-  
-		if (!sem_op && result)
+
+		if (!sem_op && result) {
+			*blocker = curr;
 			goto would_block;
+		}
 
 		result += sem_op;
-		if (result < 0)
+		if (result < 0) {
+			*blocker = curr;
 			goto would_block;
+		}
 		if (result > SEMVMX)
 			goto out_of_range;
 		if (sop->sem_flg & SEM_UNDO) {
 			int undo = un->semadj[sop->sem_num] - sem_op;
 			/*
-	 		 *	Exceeding the undo range is an error.
+			 *	Exceeding the undo range is an error.
 			 */
 			if (undo < (-SEMAEM - 1) || undo > SEMAEM)
 				goto out_of_range;
@@ -380,7 +462,27 @@ static int try_atomic_semop (struct sem_array * sma, struct sembuf * sops,
 			un->semadj[sop->sem_num] -= sop->sem_op;
 		sop--;
 	}
-	
+
+	/*
+	 * our operation is going to succeed, do any list splicing
+	 * required so that we can try to wakeup people waiting on the
+	 * sems we've changed.
+	 */
+	for (sop = sops; sop < sops + nsops; sop++) {
+		/* if there are duplicate sem_nums in the list
+		 * we only want to process the first one
+		 */
+		if (sop != sops && last == sop->sem_num)
+			continue;
+
+		curr = sma->sem_base + sop->sem_num;
+		if (sop->sem_op)
+			copy_sem_queue(curr->semval, sop->sem_num,
+				       &curr->sem_pending, pending);
+		spin_unlock(&curr->lock);
+		last = sop->sem_num;
+	}
+
 	sma->sem_otime = get_seconds();
 	return 0;
 
@@ -389,15 +491,32 @@ out_of_range:
 	goto undo;
 
 would_block:
-	if (sop->sem_flg & IPC_NOWAIT)
+	if (sop->sem_flg & IPC_NOWAIT) {
 		result = -EAGAIN;
-	else
+		if (*blocker) {
+			/*
+			 * the blocker doesn't put itself on any
+			 * list for -EAGAIN, unlock it here
+			 */
+			spin_unlock(&(*blocker)->lock);
+			*blocker = NULL;
+		}
+	} else
 		result = 1;
 
 undo:
 	sop--;
 	while (sop >= sops) {
-		sma->sem_base[sop->sem_num].semval -= sop->sem_op;
+		curr = sma->sem_base + sop->sem_num;
+
+		curr->semval -= sop->sem_op;
+		/* we leave the blocker locked, and we make sure not
+		 * to unlock duplicates in the list twice
+		 */
+		if (curr != *blocker &&
+		    (sop == sops || (sop - 1)->sem_num != sop->sem_num)) {
+			spin_unlock(&curr->lock);
+		}
 		sop--;
 	}
 
@@ -425,88 +544,60 @@ static void wake_up_sem_queue(struct sem_queue *q, int error)
 	preempt_enable();
 }
 
-static void unlink_queue(struct sem_array *sma, struct sem_queue *q)
-{
-	list_del(&q->list);
-	if (q->nsops == 1)
-		list_del(&q->simple_list);
-	else
-		sma->complex_count--;
-}
-
-
 /**
  * update_queue(sma, semnum): Look for tasks that can be completed.
  * @sma: semaphore array.
- * @semnum: semaphore that was modified.
+ * @pending_list: list of struct sem_queues to try
  *
  * update_queue must be called after a semaphore in a semaphore array
- * was modified. If multiple semaphore were modified, then @semnum
- * must be set to -1.
+ * was modified.
  */
-static void update_queue(struct sem_array *sma, int semnum)
+static void update_queue(struct sem_array *sma, struct list_head *pending_list)
 {
 	struct sem_queue *q;
-	struct list_head *walk;
-	struct list_head *pending_list;
-	int offset;
+	LIST_HEAD(new_pending);
+	LIST_HEAD(work_list);
 
-	/* if there are complex operations around, then knowing the semaphore
-	 * that was modified doesn't help us. Assume that multiple semaphores
-	 * were modified.
+	/*
+	 * this seems strange, but what we want to do is process everything
+	 * on the pending list, and then process any queues that have a chance
+	 * to finish because of processing the pending list.
+	 *
+	 * So, we send new_pending to try_atomic_semop each time, and it
+	 * splices any additional queues we have to try into new_pending.
+	 * When the work list is empty, we splice new_pending into the
+	 * work list and loop again.
+	 *
+	 * At the end of the whole thing, after we've built the largest
+	 * possible list of tasks to wake up, we wake them in bulk.
 	 */
-	if (sma->complex_count)
-		semnum = -1;
-
-	if (semnum == -1) {
-		pending_list = &sma->sem_pending;
-		offset = offsetof(struct sem_queue, list);
-	} else {
-		pending_list = &sma->sem_base[semnum].sem_pending;
-		offset = offsetof(struct sem_queue, simple_list);
-	}
-
+	list_splice_init(pending_list, &work_list);
 again:
-	walk = pending_list->next;
-	while (walk != pending_list) {
-		int error, alter;
-
-		q = (struct sem_queue *)((char *)walk - offset);
-		walk = walk->next;
-
-		/* If we are scanning the single sop, per-semaphore list of
-		 * one semaphore and that semaphore is 0, then it is not
-		 * necessary to scan the "alter" entries: simple increments
-		 * that affect only one entry succeed immediately and cannot
-		 * be in the  per semaphore pending queue, and decrements
-		 * cannot be successful if the value is already 0.
-		 */
-		if (semnum != -1 && sma->sem_base[semnum].semval == 0 &&
-				q->alter)
-			break;
+	while (!list_empty(&work_list)) {
+		struct sem *blocker;
+		int error;
 
+		q = list_entry(work_list.next, struct sem_queue, list);
+		list_del_init(&q->list);
+
+		blocker = NULL;
 		error = try_atomic_semop(sma, q->sops, q->nsops,
-					 q->undo, q->pid);
+					 q->undo, q->pid, &new_pending,
+					 &blocker);
 
 		/* Does q->sleeper still need to sleep? */
-		if (error > 0)
+		if (error > 0) {
+			list_add_tail(&q->list, &blocker->sem_pending);
+			spin_unlock(&blocker->lock);
 			continue;
+		}
+		wake_up_sem_queue(q, error);
 
-		unlink_queue(sma, q);
+	}
 
-		/*
-		 * The next operation that must be checked depends on the type
-		 * of the completed operation:
-		 * - if the operation modified the array, then restart from the
-		 *   head of the queue and check for threads that might be
-		 *   waiting for the new semaphore values.
-		 * - if the operation didn't modify the array, then just
-		 *   continue.
-		 */
-		alter = q->alter;
-		wake_up_sem_queue(q, error);
-		if (alter && !error)
-			goto again;
+	if (!list_empty(&new_pending)) {
+		list_splice_init(&new_pending, &work_list);
+		goto again;
 	}
 }
 
@@ -523,9 +614,11 @@ static int count_semncnt (struct sem_array * sma, ushort semnum)
 {
 	int semncnt;
 	struct sem_queue * q;
+	struct sem *curr;
 
+	curr = &sma->sem_base[semnum];
 	semncnt = 0;
-	list_for_each_entry(q, &sma->sem_pending, list) {
+	list_for_each_entry(q, &curr->sem_pending, list) {
 		struct sembuf * sops = q->sops;
 		int nsops = q->nsops;
 		int i;
@@ -542,9 +635,12 @@ static int count_semzcnt (struct sem_array * sma, ushort semnum)
 {
 	int semzcnt;
 	struct sem_queue * q;
+	struct sem *curr;
+
+	curr = &sma->sem_base[semnum];
 
 	semzcnt = 0;
-	list_for_each_entry(q, &sma->sem_pending, list) {
+	list_for_each_entry(q, &curr->sem_pending, list) {
 		struct sembuf * sops = q->sops;
 		int nsops = q->nsops;
 		int i;
@@ -572,6 +668,7 @@ static void freeary(struct ipc_namespace *ns, struct kern_ipc_perm *ipcp)
 	struct sem_undo *un, *tu;
 	struct sem_queue *q, *tq;
 	struct sem_array *sma = container_of(ipcp, struct sem_array, sem_perm);
+	int i;
 
 	/* Free the existing undo structures for this semaphore set.  */
 	assert_spin_locked(&sma->sem_perm.lock);
@@ -584,10 +681,15 @@ static void freeary(struct ipc_namespace *ns, struct kern_ipc_perm *ipcp)
 		call_rcu(&un->rcu, free_un);
 	}
 
-	/* Wake up all pending processes and let them fail with EIDRM. */
-	list_for_each_entry_safe(q, tq, &sma->sem_pending, list) {
-		unlink_queue(sma, q);
-		wake_up_sem_queue(q, -EIDRM);
+
+	for (i = 0; i < sma->sem_nsems; i++) {
+		struct sem *curr = sma->sem_base + i;
+		spin_lock(&curr->lock);
+		list_for_each_entry_safe(q, tq, &curr->sem_pending, list) {
+			list_del_init(&q->list);
+			wake_up_sem_queue(q, -EIDRM);
+		}
+		spin_unlock(&curr->lock);
 	}
 
 	/* Remove the semaphore set from the IDR */
@@ -766,6 +868,7 @@ static int semctl_main(struct ipc_namespace *ns, int semid, int semnum,
 	{
 		int i;
 		struct sem_undo *un;
+		LIST_HEAD(pending);
 
 		sem_getref_and_unlock(sma);
 
@@ -797,8 +900,15 @@ static int semctl_main(struct ipc_namespace *ns, int semid, int semnum,
 			goto out_free;
 		}
 
-		for (i = 0; i < nsems; i++)
-			sma->sem_base[i].semval = sem_io[i];
+		for (i = 0; i < nsems; i++) {
+			curr = &sma->sem_base[i];
+
+			spin_lock(&curr->lock);
+			curr->semval = sem_io[i];
+			copy_sem_queue(curr->semval, i,
+				       &curr->sem_pending, &pending);
+			spin_unlock(&curr->lock);
+		}
 
 		assert_spin_locked(&sma->sem_perm.lock);
 		list_for_each_entry(un, &sma->list_id, list_id) {
@@ -807,7 +917,7 @@ static int semctl_main(struct ipc_namespace *ns, int semid, int semnum,
 		}
 		sma->sem_ctime = get_seconds();
 		/* maybe some queued-up processes were waiting for this */
-		update_queue(sma, -1);
+		update_queue(sma, &pending);
 		err = 0;
 		goto out_unlock;
 	}
@@ -836,6 +946,7 @@ static int semctl_main(struct ipc_namespace *ns, int semid, int semnum,
 	{
 		int val = arg.val;
 		struct sem_undo *un;
+		LIST_HEAD(pending);
 
 		err = -ERANGE;
 		if (val > SEMVMX || val < 0)
@@ -845,11 +956,16 @@ static int semctl_main(struct ipc_namespace *ns, int semid, int semnum,
 		list_for_each_entry(un, &sma->list_id, list_id)
 			un->semadj[semnum] = 0;
 
+		spin_lock(&curr->lock);
 		curr->semval = val;
+		copy_sem_queue(curr->semval, semnum,
+				       &curr->sem_pending, &pending);
 		curr->sempid = task_tgid_vnr(current);
+		spin_unlock(&curr->lock);
+
 		sma->sem_ctime = get_seconds();
 		/* maybe some queued-up processes were waiting for this */
-		update_queue(sma, semnum);
+		update_queue(sma, &pending);
 		err = 0;
 		goto out_unlock;
 	}
@@ -1117,6 +1233,67 @@ out:
 	return un;
 }
 
+/*
+ * since we take spinlocks on the semaphores based on the
+ * values from userland, we have to sort them to make sure
+ * we lock them in order
+ */
+static int sembuf_compare(const void *a, const void *b)
+{
+	const struct sembuf *abuf = a;
+	const struct sembuf *bbuf = b;
+
+	if (abuf->sem_num < bbuf->sem_num)
+		return -1;
+	if (abuf->sem_num > bbuf->sem_num)
+		return 1;
+	return 0;
+}
+
+/*
+ * if a process wakes up on its own while on a semaphore list
+ * we have to take it off the list before that process can exit.
+ *
+ * We check all the semaphore's the sem_queue was trying to modify
+ * and if we find the sem_queue, we remove it and return.
+ *
+ * If we don't find the sem_queue its because someone is about to
+ * wake us up, and they have removed us from the list.
+ * We schedule and try again in hopes that they do it real soon now.
+ *
+ * We check queue->status to detect if someone did actually manage to
+ * wake us up.
+ */
+static int remove_queue_from_lists(struct sem_array *sma,
+				   struct sem_queue *queue)
+{
+	struct sembuf *sops = queue->sops;
+	struct sembuf *sop;
+	struct sem * curr;
+	struct sem_queue *test;
+
+again:
+	for (sop = sops; sop < sops + queue->nsops; sop++) {
+		curr = sma->sem_base + sop->sem_num;
+		spin_lock(&curr->lock);
+		list_for_each_entry(test, &curr->sem_pending, list) {
+			if (test == queue) {
+				list_del(&test->list);
+				spin_unlock(&curr->lock);
+				goto found;
+			}
+		}
+		spin_unlock(&curr->lock);
+	}
+	if (queue->status == -EINTR) {
+		set_current_state(TASK_RUNNING);
+		schedule();
+		goto again;
+	}
+found:
+	return 0;
+}
+
 SYSCALL_DEFINE4(semtimedop, int, semid, struct sembuf __user *, tsops,
 		unsigned, nsops, const struct timespec __user *, timeout)
 {
@@ -1129,6 +1306,8 @@ SYSCALL_DEFINE4(semtimedop, int, semid, struct sembuf __user *, tsops,
 	struct sem_queue queue;
 	unsigned long jiffies_left = 0;
 	struct ipc_namespace *ns;
+	struct sem *blocker = NULL;
+	LIST_HEAD(pending);
 
 	ns = current->nsproxy->ipc_ns;
 
@@ -1168,6 +1347,14 @@ SYSCALL_DEFINE4(semtimedop, int, semid, struct sembuf __user *, tsops,
 			alter = 1;
 	}
 
+	/*
+	 * try_atomic_semop takes all the locks of all the semaphores in
+	 * the sops array.  We have to make sure we don't deadlock if userland
+	 * happens to send them out of order, so we sort them by semnum.
+	 */
+	if (nsops > 1)
+		sort(sops, nsops, sizeof(*sops), sembuf_compare, NULL);
+
 	if (undos) {
 		un = find_alloc_undo(ns, semid);
 		if (IS_ERR(un)) {
@@ -1222,45 +1409,52 @@ SYSCALL_DEFINE4(semtimedop, int, semid, struct sembuf __user *, tsops,
 	if (error)
 		goto out_unlock_free;
 
-	error = try_atomic_semop (sma, sops, nsops, un, task_tgid_vnr(current));
+	/*
+	 * undos are scary, keep the lock if we have to deal with undos.
+	 * Otherwise, drop the big fat ipc lock and use the fine grained
+	 * per-semaphore locks instead.
+	 */
+	if (!un)
+		sem_getref_and_unlock(sma);
+
+	error = try_atomic_semop (sma, sops, nsops, un, task_tgid_vnr(current),
+				  &pending, &blocker);
 	if (error <= 0) {
 		if (alter && error == 0)
-			update_queue(sma, (nsops == 1) ? sops[0].sem_num : -1);
-
-		goto out_unlock_free;
+			update_queue(sma, &pending);
+		if (un)
+			goto out_unlock_free;
+		else
+			goto out_putref;
 	}
 
 	/* We need to sleep on this operation, so we put the current
 	 * task into the pending queue and go to sleep.
 	 */
-		
+
 	queue.sops = sops;
 	queue.nsops = nsops;
 	queue.undo = un;
 	queue.pid = task_tgid_vnr(current);
 	queue.alter = alter;
-	if (alter)
-		list_add_tail(&queue.list, &sma->sem_pending);
-	else
-		list_add(&queue.list, &sma->sem_pending);
-
-	if (nsops == 1) {
-		struct sem *curr;
-		curr = &sma->sem_base[sops->sem_num];
-
-		if (alter)
-			list_add_tail(&queue.simple_list, &curr->sem_pending);
-		else
-			list_add(&queue.simple_list, &curr->sem_pending);
-	} else {
-		INIT_LIST_HEAD(&queue.simple_list);
-		sma->complex_count++;
-	}
-
 	queue.status = -EINTR;
 	queue.sleeper = current;
+
 	current->state = TASK_INTERRUPTIBLE;
-	sem_unlock(sma);
+
+	/*
+	 * we could be woken up at any time after we add ourselves to the
+	 * blocker's list and unlock the spinlock.  So, all queue setup
+	 * must be done before this point
+	 */
+	if (alter)
+		list_add_tail(&queue.list, &blocker->sem_pending);
+	else
+		list_add(&queue.list, &blocker->sem_pending);
+	spin_unlock(&blocker->lock);
+
+	if (un)
+		sem_getref_and_unlock(sma);
 
 	if (timeout)
 		jiffies_left = schedule_timeout(jiffies_left);
@@ -1268,40 +1462,76 @@ SYSCALL_DEFINE4(semtimedop, int, semid, struct sembuf __user *, tsops,
 		schedule();
 
 	error = queue.status;
+
 	while(unlikely(error == IN_WAKEUP)) {
 		cpu_relax();
 		error = queue.status;
 	}
 
-	if (error != -EINTR) {
+	/*
+	 * we are lock free right here, and we could have timed out or
+	 * gotten a signal, so we need to be really careful with how we
+	 * play with queue.status.  It has three possible states:
+	 *
+	 * -EINTR, which means nobody has changed it since we slept.  This
+	 * means we woke up on our own.
+	 *
+	 * IN_WAKEUP, someone is currently waking us up.  We need to loop
+	 * here until they change it to the operation error value.  If
+	 * we don't loop, our process could exit before they are done waking us
+	 *
+	 * operation error value: we've been properly woken up and can exit
+	 * at any time.
+	 *
+	 * If queue.status is currently -EINTR, we are still being processed
+	 * by the semtimedop core.  Someone either has us on a list head
+	 * or is currently poking our queue struct.  We need to find that
+	 * reference and remove it, which is what remove_queue_from_lists
+	 * does.
+	 *
+	 * We always check for both -EINTR and IN_WAKEUP because we have no
+	 * locks held.  Someone could change us from -EINTR to IN_WAKEUP at
+	 * any time.
+	 */
+	if (error != -EINTR && error != IN_WAKEUP) {
 		/* fast path: update_queue already obtained all requested
 		 * resources */
-		goto out_free;
-	}
-
-	sma = sem_lock(ns, semid);
-	if (IS_ERR(sma)) {
-		error = -EIDRM;
-		goto out_free;
+		goto out_putref;
 	}
 
 	/*
-	 * If queue.status != -EINTR we are woken up by another process
+	 * Someone has a reference on us, lets find it.
 	 */
+	remove_queue_from_lists(sma, &queue);
+
+	/* check the status again in case we were woken up */
 	error = queue.status;
-	if (error != -EINTR) {
-		goto out_unlock_free;
+	while(unlikely(error == IN_WAKEUP)) {
+		cpu_relax();
+		error = queue.status;
 	}
 
 	/*
+	 * at this point we know nobody can possibly wake us up, if error
+	 * isn't -EINTR, the wakeup did happen and our semaphore operation is
+	 * complete.  Otherwise, we return -EAGAIN.
+	 */
+	if (error != -EINTR)
+		goto out_putref;
+
+	/*
 	 * If an interrupt occurred we have to clean up the queue
 	 */
 	if (timeout && jiffies_left == 0)
 		error = -EAGAIN;
-	unlink_queue(sma, &queue);
+
+out_putref:
+	sem_putref(sma);
+	goto out_free;
 
 out_unlock_free:
 	sem_unlock(sma);
+
 out_free:
 	if(sops != fast_sops)
 		kfree(sops);
@@ -1360,11 +1590,14 @@ void exit_sem(struct task_struct *tsk)
 		return;
 
 	for (;;) {
+		struct list_head pending;
 		struct sem_array *sma;
 		struct sem_undo *un;
 		int semid;
 		int i;
 
+		INIT_LIST_HEAD(&pending);
+
 		rcu_read_lock();
 		un = list_entry_rcu(ulp->list_proc.next,
 				    struct sem_undo, list_proc);
@@ -1404,6 +1637,7 @@ void exit_sem(struct task_struct *tsk)
 		for (i = 0; i < sma->sem_nsems; i++) {
 			struct sem * semaphore = &sma->sem_base[i];
 			if (un->semadj[i]) {
+				spin_lock(&semaphore->lock);
 				semaphore->semval += un->semadj[i];
 				/*
 				 * Range checks of the new semaphore value,
@@ -1423,11 +1657,15 @@ void exit_sem(struct task_struct *tsk)
 				if (semaphore->semval > SEMVMX)
 					semaphore->semval = SEMVMX;
 				semaphore->sempid = task_tgid_vnr(current);
+				copy_sem_queue(semaphore->semval, i,
+					       &semaphore->sem_pending,
+					       &pending);
+				spin_unlock(&semaphore->lock);
 			}
 		}
 		sma->sem_otime = get_seconds();
 		/* maybe some queued-up processes were waiting for this */
-		update_queue(sma, -1);
+		update_queue(sma, &pending);
 		sem_unlock(sma);
 
 		call_rcu(&un->rcu, free_un);
-- 
1.7.0.3

