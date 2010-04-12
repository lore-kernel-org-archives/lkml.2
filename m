Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753658Ab0DLSzV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Apr 2010 14:55:21 -0400
Received: from rcsinet11.oracle.com ([148.87.113.123]:58917 "EHLO
	rcsinet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750776Ab0DLSzU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Apr 2010 14:55:20 -0400
From: Chris Mason <chris.mason@oracle.com>
To: chris.mason@oracle.com, zach.brown@oracle.com, jens.axboe@oracle.com,
       linux-kernel@vger.kernel.org, Nick Piggin <npiggin@suse.de>,
       Manfred Spraul <manfred@colorfullife.com>
Subject: [PATCH 2/2] ipc semaphores: order wakeups based on waiter CPU
Date: Mon, 12 Apr 2010 14:49:23 -0400
Message-Id: <1271098163-3663-3-git-send-email-chris.mason@oracle.com>
X-Mailer: git-send-email 1.7.0.3
In-Reply-To: <1271098163-3663-1-git-send-email-chris.mason@oracle.com>
References: <1271098163-3663-1-git-send-email-chris.mason@oracle.com>
X-Source-IP: acsmt354.oracle.com [141.146.40.154]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090206.4BC36C90.018C:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When IPC semaphores are used in a bulk post and wait system, we
can end up waking a very large number of processes per semtimedop call.
At least one major database will use a single process to kick hundreds
of other processes at a time.

This patch tries to reduce the runqueue lock contention by ordering the
wakeups based on the CPU the waiting process was on when it went to
sleep.

A later patch could add some code in the scheduler to help
wake these up in bulk and take the various runqueue locks less often.

Signed-off-by: Chris Mason <chris.mason@oracle.com>
---
 include/linux/sem.h |    1 +
 ipc/sem.c           |   37 ++++++++++++++++++++++++++++++++++++-
 2 files changed, 37 insertions(+), 1 deletions(-)

diff --git a/include/linux/sem.h b/include/linux/sem.h
index 8b97b51..4a37319 100644
--- a/include/linux/sem.h
+++ b/include/linux/sem.h
@@ -104,6 +104,7 @@ struct sem_array {
 struct sem_queue {
 	struct list_head	list;	 /* queue of pending operations */
 	struct task_struct	*sleeper; /* this process */
+	unsigned long		sleep_cpu;
 	struct sem_undo		*undo;	 /* undo structure */
 	int    			pid;	 /* process id of requesting process */
 	int    			status;	 /* completion status of operation */
diff --git a/ipc/sem.c b/ipc/sem.c
index 335cd35..07fe1d5 100644
--- a/ipc/sem.c
+++ b/ipc/sem.c
@@ -544,6 +544,25 @@ static void wake_up_sem_queue(struct sem_queue *q, int error)
 	preempt_enable();
 }
 
+/*
+ * sorting helper for struct sem_queues in a list.  This is used to
+ * sort by the CPU they are likely to be on when waking them.
+ */
+int list_comp(void *priv, struct list_head *a, struct list_head *b)
+{
+	struct sem_queue *qa;
+	struct sem_queue *qb;
+
+	qa = list_entry(a, struct sem_queue, list);
+	qb = list_entry(b, struct sem_queue, list);
+
+	if (qa->sleep_cpu < qb->sleep_cpu)
+		return -1;
+	if (qa->sleep_cpu > qb->sleep_cpu)
+		return 1;
+	return 0;
+}
+
 /**
  * update_queue(sma, semnum): Look for tasks that can be completed.
  * @sma: semaphore array.
@@ -557,6 +576,7 @@ static void update_queue(struct sem_array *sma, struct list_head *pending_list)
 	struct sem_queue *q;
 	LIST_HEAD(new_pending);
 	LIST_HEAD(work_list);
+	LIST_HEAD(wake_list);
 
 	/*
 	 * this seems strange, but what we want to do is process everything
@@ -591,7 +611,10 @@ again:
 			spin_unlock(&blocker->lock);
 			continue;
 		}
-		wake_up_sem_queue(q, error);
+		if (error)
+			wake_up_sem_queue(q, error);
+		else
+			list_add_tail(&q->list, &wake_list);
 
 	}
 
@@ -599,6 +622,13 @@ again:
 		list_splice_init(&new_pending, &work_list);
 		goto again;
 	}
+
+	list_sort(NULL, &wake_list, list_comp);
+	while (!list_empty(&wake_list)) {
+		q = list_entry(wake_list.next, struct sem_queue, list);
+		list_del_init(&q->list);
+		wake_up_sem_queue(q, 0);
+	}
 }
 
 /* The following counts are associated to each semaphore:
@@ -1440,6 +1470,11 @@ SYSCALL_DEFINE4(semtimedop, int, semid, struct sembuf __user *, tsops,
 	queue.status = -EINTR;
 	queue.sleeper = current;
 
+	/*
+	 * the sleep_cpu number allows sorting by the CPU we expect
+	 * their runqueue entry to be on..hopefully faster for waking up
+	 */
+	queue.sleep_cpu = my_cpu_offset;
 	current->state = TASK_INTERRUPTIBLE;
 
 	/*
-- 
1.7.0.3

