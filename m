Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752316Ab2A1TBR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jan 2012 14:01:17 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:38316 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751521Ab2A1TBP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jan 2012 14:01:15 -0500
Message-ID: <4F2445F6.4090201@colorfullife.com>
Date: Sat, 28 Jan 2012 20:01:10 +0100
From: Manfred Spraul <manfred@colorfullife.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:9.0) Gecko/20111222 Thunderbird/9.0
MIME-Version: 1.0
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: LKML <linux-kernel@vger.kernel.org>, Andrew Morton <akpm@google.com>,
        Thomas Gleixner <tglx@linutronix.de>, Mike Galbraith <efault@gmx.de>
Subject: Re: [PATCH 5/5] ipc/sem.c: alternatives to preempt_disable()
References: <1318684920-2033-1-git-send-email-manfred@colorfullife.com> <1327416705.2446.58.camel@twins>
In-Reply-To: <1327416705.2446.58.camel@twins>
Content-Type: multipart/mixed;
 boundary="------------060609070102090302080206"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------060609070102090302080206
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Hi,

On 01/24/2012 03:51 PM, Peter Zijlstra wrote:
> Yes I think it should work, and I'm afraid I have to agree with not 
> being able to make the spinlock thing work properly. Even if you were 
> to use arch_spin_* primitives you can still run into the 256 limit -- 
> although not from the preempt_count in that case. Nor would arch_spin_ 
> do what we need on -rt. 

I've attached an updated patch, with the spinlock version removed.

But: I think the patch belongs into the -RT tree, not into mainline:
CONFIG_PREEMPT_RT_BASE does not exist in mainline.
Additionally, I'm not sure if the completion-scheme is also necessary 
for CONFIG_PREEMPT_RT_FULL

Just to keep everything in perspective:
- if one thread is woken up, the duration of the preempt_disable() block 
is 2.5 microseconds on my 2 GHz Phenom.
- the scaling is nearly linear, i.e. if 256 threads are woken up, then 
the duration is something like 0.5 milliseconds.
   But: I'm not aware of any application that uses sysv sem for bulk 
wakeups.

--
     Manfred


--------------060609070102090302080206
Content-Type: text/x-patch;
 name="0001-ipc-sem.c-Add-RT-compatible-wakeup-scheme.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename*0="0001-ipc-sem.c-Add-RT-compatible-wakeup-scheme.patch"

>From 7fdbcc018b85d5804ea51323f3cefd5fe3032f82 Mon Sep 17 00:00:00 2001
From: Manfred Spraul <manfred@colorfullife.com>
Date: Sat, 28 Jan 2012 18:42:58 +0100
Subject: [PATCH] ipc/sem.c: Add -RT compatible wakeup scheme.

ipc/sem.c uses a custom wakeup scheme that relies on preempt_disable() to
prevent livelocks.
On -RT, this causes increased latencies and debug warnings.

The patch:
- separates the wakeup scheme into helper functions
- adds a scheme built around a completion.

The preferred solution (use a spinlock instead of the completion) does not
work, because there is a limit of at most 256 concurrent spinlocks.

--
        Manfred

Signed-off-by: Manfred Spraul <manfred@colorfullife.com>
---
 ipc/sem.c |  206 +++++++++++++++++++++++++++++++++++++------------------------
 1 files changed, 125 insertions(+), 81 deletions(-)

diff --git a/ipc/sem.c b/ipc/sem.c
index 5215a81..22da15a 100644
--- a/ipc/sem.c
+++ b/ipc/sem.c
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
@@ -90,6 +90,85 @@
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
+#elif defined(SYSVSEM_CUSTOM)
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
+	static void queuewakeup_handsoff(struct queue_done *qd)
+	{
+		BUG_ON(atomic_read(&qd->done) != 2);
+		smp_mb();
+		atomic_set(&qd->done, 1);
+	}
+
+	static void queuewakeup_init(struct queue_done *qd)
+	{
+		atomic_set(&qd->done, 2);
+	}
+
+	static void queuewakeup_wait(struct queue_done *qd)
+	{
+		while (atomic_read(&qd->done) != 1)
+			cpu_relax();
+
+		smp_mb();
+	}
+#else
+#error Unknown locking primitive
+#endif
+
+
 /* One semaphore structure for each semaphore in the system. */
 struct sem {
 	int	semval;		/* current value */
@@ -108,6 +187,7 @@ struct sem_queue {
 	struct sembuf		*sops;	 /* array of pending operations */
 	int			nsops;	 /* number of operations */
 	int			alter;	 /* does *sops alter the array? */
+	struct queue_done	done;	 /* completion synchronization */
 };
 
 /* Each task has a list of undo requests. They are executed automatically
@@ -241,27 +321,34 @@ static inline void sem_rmid(struct ipc_namespace *ns, struct sem_array *s)
 
 /*
  * Lockless wakeup algorithm:
- * Without the check/retry algorithm a lockless wakeup is possible:
+ * The whole task of choosing tasks to wake up is done by the thread that
+ * does the wakeup. For the woken up thread, this makes the following
+ * lockless wakeup possible:
  * - queue.status is initialized to -EINTR before blocking.
  * - wakeup is performed by
- *	* unlinking the queue entry from sma->sem_pending
- *	* setting queue.status to IN_WAKEUP
- *	  This is the notification for the blocked thread that a
- *	  result value is imminent.
+ * 	* call queuewakeup_prepare() once. This is necessary to prevent
+ *	  livelocks.
+ *	* setting queue.status to the actual result code
  *	* call wake_up_process
- *	* set queue.status to the final value.
+ *	* queuewakeup_handsoff(&q->done);
+ *	* call queuewakeup_completed() once.
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
+ *	* otherwise it must acquire the spinlock and repeat the test
+ *	    (including: call queuewakeup_wait() if there is a return code)
+ *	* If it is still -EINTR, then no update_queue() completed the
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
@@ -271,7 +358,6 @@ static inline void sem_rmid(struct ipc_namespace *ns, struct sem_array *s)
  *   (yes, this happened on s390 with sysv msg).
  *
  */
-#define IN_WAKEUP	1
 
 /**
  * newary - Create a new semaphore set
@@ -461,15 +547,10 @@ undo:
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
+	q->status = error;
 
 	list_add_tail(&q->simple_list, pt);
 }
@@ -480,8 +561,8 @@ static void wake_up_sem_queue_prepare(struct list_head *pt,
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
@@ -491,12 +572,11 @@ static void wake_up_sem_queue_do(struct list_head *pt)
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
@@ -1300,33 +1380,6 @@ out:
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
@@ -1472,6 +1525,7 @@ SYSCALL_DEFINE4(semtimedop, int, semid, struct sembuf __user *, tsops,
 
 	queue.status = -EINTR;
 	queue.sleeper = current;
+	queuewakeup_init(&queue.done);
 
 sleep_again:
 	current->state = TASK_INTERRUPTIBLE;
@@ -1482,17 +1536,14 @@ sleep_again:
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
@@ -1502,23 +1553,16 @@ sleep_again:
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
-- 
1.7.7.6



--------------060609070102090302080206--
