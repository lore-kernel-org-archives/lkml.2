Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756844Ab0DRRIA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Apr 2010 13:08:00 -0400
Received: from fg-out-1718.google.com ([72.14.220.159]:64209 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756047Ab0DRRHr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Apr 2010 13:07:47 -0400
From: Manfred Spraul <manfred@colorfullife.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Chris Mason <chris.mason@oracle.com>, Zach Brown <zach.brown@oracle.com>,
       Jens Axboe <jens.axboe@oracle.com>, Nick Piggin <npiggin@suse.de>,
       Manfred Spraul <manfred@colorfullife.com>
Subject: [PATCH 1/3] [PATCH] ipc/sem.c: Optimize update_queue() for bulk wakeup calls
Date: Sun, 18 Apr 2010 19:07:15 +0200
Message-Id: <1271610437-2312-2-git-send-email-manfred@colorfullife.com>
X-Mailer: git-send-email 1.6.6.1
In-Reply-To: <1271610437-2312-1-git-send-email-manfred@colorfullife.com>
References: <1271610437-2312-1-git-send-email-manfred@colorfullife.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The SysV semaphore code allows to perform multiple operations on
all semaphores in the array as atomic operations.
After a modification, update_queue() checks which of the waiting
tasks can complete.
The algorithm that is used to identify the tasks is O(N^2) in the
worst case.
The patch fixes that for the case of an array where all sleeping
tasks are single sembuf operations and a multi-sembuf operation
is used to wake up multiple tasks.
---
 ipc/sem.c |  112 +++++++++++++++++++++++++++++++++++++++++++++++++++++--------
 1 files changed, 98 insertions(+), 14 deletions(-)

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
-- 
1.6.6.1

