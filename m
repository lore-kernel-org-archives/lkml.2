Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758117Ab0DPL0L (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Apr 2010 07:26:11 -0400
Received: from fg-out-1718.google.com ([72.14.220.152]:21482 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758020Ab0DPL0I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Apr 2010 07:26:08 -0400
Message-ID: <4BC84957.9080608@colorfullife.com>
Date: Fri, 16 Apr 2010 13:26:15 +0200
From: Manfred Spraul <manfred@colorfullife.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100330 Fedora/3.0.4-1.fc12 Thunderbird/3.0.4
MIME-Version: 1.0
To: Chris Mason <chris.mason@oracle.com>
CC: zach.brown@oracle.com, jens.axboe@oracle.com, linux-kernel@vger.kernel.org,
       Nick Piggin <npiggin@suse.de>
Subject: Re: [PATCH 1/2] ipc semaphores: reduce ipc_lock contention in semtimedop
References: <1271098163-3663-1-git-send-email-chris.mason@oracle.com> <1271098163-3663-2-git-send-email-chris.mason@oracle.com>
In-Reply-To: <1271098163-3663-2-git-send-email-chris.mason@oracle.com>
Content-Type: multipart/mixed;
 boundary="------------090900070902010401000803"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------090900070902010401000803
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

On 04/12/2010 08:49 PM, Chris Mason wrote:
> I have a microbenchmark to test how quickly we can post and wait in
> bulk.  With this change, semtimedop is able do to more than twice
> as much work in the same run.  On a large numa machine, it brings
> the IPC lock system time (reported by perf) down from 85% to 15%.
>
>    
Looking at the current code:
- update_queue() can be O(N^2) if only some of the waiting tasks are 
woken up.
Actually: all non-woken up tasks are rescanned after a task that can be 
woken up is found.

- Your test app tests the best case for the current code:
You wake up the tasks in the same order as the called semop().
If you invert the order (i.e.: worklist_add() adds to head instead of 
tail), I would expect an even worse performance of the current code.

The O(N^2) is simple to fix, I've attached a patch.
For your micro-benchmark, the patch does not change much: you wake-up 
in-order, thus the current code does not misbehave.

Do you know how Oracle wakes up the tasks?
FIFO, LIFO, un-ordered?

> 	while(unlikely(error == IN_WAKEUP)) {
>   		cpu_relax();
>   		error = queue.status;
>   	}
>
> -	if (error != -EINTR) {
> +	/*
> +	 * we are lock free right here, and we could have timed out or
> +	 * gotten a signal, so we need to be really careful with how we
> +	 * play with queue.status.  It has three possible states:
> +	 *
> +	 * -EINTR, which means nobody has changed it since we slept.  This
> +	 * means we woke up on our own.
> +	 *
> +	 * IN_WAKEUP, someone is currently waking us up.  We need to loop
> +	 * here until they change it to the operation error value.  If
> +	 * we don't loop, our process could exit before they are done waking us
> +	 *
> +	 * operation error value: we've been properly woken up and can exit
> +	 * at any time.
> +	 *
> +	 * If queue.status is currently -EINTR, we are still being processed
> +	 * by the semtimedop core.  Someone either has us on a list head
> +	 * or is currently poking our queue struct.  We need to find that
> +	 * reference and remove it, which is what remove_queue_from_lists
> +	 * does.
> +	 *
> +	 * We always check for both -EINTR and IN_WAKEUP because we have no
> +	 * locks held.  Someone could change us from -EINTR to IN_WAKEUP at
> +	 * any time.
> +	 */
> +	if (error != -EINTR&&  error != IN_WAKEUP) {
>   		/* fast path: update_queue already obtained all requested
>   		 * resources */
No: The code accesses a local variable. The loop above the comment 
guarantees that the error can't be IN_WAKEUP.

> +
> +out_putref:
> +	sem_putref(sma);
> +	goto out_free;
>    
Is it possible to move the sem_putref into wakeup_sem_queue()?
Right now, the exit path of semtimedop doesn't touch the spinlock.
You remove that optimization.

--
     Manfred

--------------090900070902010401000803
Content-Type: text/plain;
 name="patch-ipc-optimize_bulkwakeup"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="patch-ipc-optimize_bulkwakeup"

diff --git a/ipc/sem.c b/ipc/sem.c
index dbef95b..efadb6d 100644
--- a/ipc/sem.c
+++ b/ipc/sem.c
@@ -434,6 +434,69 @@ static void unlink_queue(struct sem_array *sma, struct sem_queue *q)
 		sma->complex_count--;
 }
 
+/** check_restart(sma, q)
+ * @sma: semaphore array
+ * @q: the operation that just completed
+ *
+ * update_queue is O(N^2) when it restarts scanning the whole queue of
+ * waiting operations. Therefore this function checks if the restart is
+ * really necessary. It is called after a previously waiting operation
+ * was completed.
+ */
+static int check_restart(struct sem_array *sma, struct sem_queue *q)
+{
+	struct sem * curr;
+	struct sem_queue *h;
+
+	/* if the operation didn't modify the array, then no restart */
+	if (q->alter == 0)
+		return 0;
+
+	/* pending complex operations are too difficult to analyse */
+	if (sma->complex_count)
+		return 1;
+
+	/* we were a sleeping complex operation. Too difficult */
+	if (q->nsops > 1)
+		return 1;
+
+	curr = sma->sem_base + q->sops[0].sem_num;
+
+	/* No-one waits on this queue */
+	if (list_empty(&curr->sem_pending))
+		return 0;
+
+	/* the new semaphore value */
+	if (curr->semval) {
+		/* It is impossible that someone waits for the new value:
+		 * - q is a previously sleeping simple operation that
+		 *   altered the array. It must be a decrement, because
+		 *   simple increments never sleep.
+		 * - The value is not 0, thus wait-for-zero won't proceed.
+		 * - If there are older (higher priority) decrements
+		 *   in the queue, then they have observed the original
+		 *   semval value and couldn't proceed. The operation
+		 *   decremented to value - thus they won't proceed either.
+		 */
+		BUG_ON(q->sops[0].sem_op >= 0);
+		return 0;
+	}
+	/*
+	 * semval is 0. Check if there are wait-for-zero semops.
+	 * They must be the first entries in the per-semaphore simple queue
+	 */
+	h=list_first_entry(&curr->sem_pending, struct sem_queue, simple_list);
+	BUG_ON(h->nsops != 1);
+	BUG_ON(h->sops[0].sem_num != q->sops[0].sem_num);
+	
+	/* Yes, there is a wait-for-zero semop. Restart */	
+	if (h->sops[0].sem_op == 0)
+		return 1;
+
+	/* Again - no-one is waiting for the new value. */
+	return 0;
+}		
+
 
 /**
  * update_queue(sma, semnum): Look for tasks that can be completed.
@@ -469,7 +532,7 @@ static void update_queue(struct sem_array *sma, int semnum)
 again:
 	walk = pending_list->next;
 	while (walk != pending_list) {
-		int error, alter;
+		int error, restart;
 
 		q = (struct sem_queue *)((char *)walk - offset);
 		walk = walk->next;
@@ -494,22 +557,42 @@ again:
 
 		unlink_queue(sma, q);
 
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
+		if (error)
+			restart = 0;
+		else
+			restart = check_restart(sma, q);
+
 		wake_up_sem_queue(q, error);
-		if (alter && !error)
+		if (restart)
 			goto again;
 	}
 }
 
+/** do_smart_update(sma, sops, nsops): Optimized update_queue
+ * @sma: semaphore array
+ * @sops: operations that were performed
+ * @nsops: number of operations
+ *
+ * do_smart_update() does the required called to update_queue, based on the
+ * actual changes that were performed on the semaphore array.
+ */
+void do_smart_update(struct sem_array *sma, struct sembuf *sops, int nsops)
+{
+	int i;
+
+	if (sma->complex_count) {
+		update_queue(sma, -1);
+		return;
+	}
+				
+	for (i=0;i<nsops;i++) {
+		if (sops[i].sem_op > 0 ||
+			(sops[i].sem_op < 0 && sma->sem_base[sops[i].sem_num].semval == 0))
+			update_queue(sma, sops[i].sem_num);
+	}
+}
+
+
 /* The following counts are associated to each semaphore:
  *   semncnt        number of tasks waiting on semval being nonzero
  *   semzcnt        number of tasks waiting on semval being zero
@@ -1224,8 +1307,9 @@ SYSCALL_DEFINE4(semtimedop, int, semid, struct sembuf __user *, tsops,
 
 	error = try_atomic_semop (sma, sops, nsops, un, task_tgid_vnr(current));
 	if (error <= 0) {
-		if (alter && error == 0)
-			update_queue(sma, (nsops == 1) ? sops[0].sem_num : -1);
+		if (alter && error == 0) {
+			do_smart_update(sma, sops, nsops);
+		}
 
 		goto out_unlock_free;
 	}

--------------090900070902010401000803--
