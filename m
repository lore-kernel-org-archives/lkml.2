Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753079Ab1LTWXW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Dec 2011 17:23:22 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:41530 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752216Ab1LTWXU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Dec 2011 17:23:20 -0500
Message-ID: <1324419795.20886.3.camel@raz>
Subject: Subject: [PATCH 2/2] priority System V Semaphores
From: raz ben yehuda <raziebe@gmail.com>
To: linux-rt-users@vger.kernel.org, linux-kernel@vger.kernel.org,
        manfred@colorfullife.com
Cc: Lior Brafman <LBrafman@manz.com>, Torsten Scherer <TScherer@manz.com>,
        Rasty Slutsker <RSlutsker@manz.com>
Date: Wed, 21 Dec 2011 00:23:15 +0200
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 25aa166505aff2561dd715c927c654d0bbb432ba Mon Sep 17 00:00:00 2001
From: raz <raziebe@gmail.com>
Date: Tue, 20 Dec 2011 22:54:56 +0200


Add positioning routine find_pos. find_pos returns
the place where to put the sleeper before.
I sort only rt tasks, OTHER policy is pushed back in
queue. I do not distinct between SCHED_RR and SCHED_FIFO
policies and they are treated as a single policy
for the sorting algorithm.

SETPRIO operates only when user issues a single semop
operation and not an array of opretions.

SETFIFO is the default for backward compatbility.

Signed-off-by: raz <raziebe@gmail.com>
---
 ipc/sem.c |   51 +++++++++++++++++++++++++++++++++++++++++++++++++--
 1 files changed, 49 insertions(+), 2 deletions(-)

diff --git a/ipc/sem.c b/ipc/sem.c
index 90dc5a1..921056d 100644
--- a/ipc/sem.c
+++ b/ipc/sem.c
@@ -1343,6 +1343,51 @@ static int get_queue_result(struct sem_queue *q)
 	return error;
 }
 
+/*
+ * find the best place to put the task sorted by rt prio
+*/
+static struct list_head *find_pos(struct sem *curr, int alter,
+		struct task_struct *p)
+{
+	struct sem_queue *q;
+	struct sem_queue *ret_pos = NULL;
+	struct list_head *tasks_queue = &curr->sem_pending;
+
+	if (!alter)
+		return tasks_queue;
+
+	if (!(curr->flags & PRIO_SEM))
+		return tasks_queue;
+	/*
+	 *  make no effort to sort SCHED_OTHER,
+	 *  just push task to the back of the queue.
+	*/
+	if (!(p->policy == SCHED_FIFO || p->policy == SCHED_RR))
+		return tasks_queue;
+	/*
+	 *  make no distinction between SCHED_FIFO
+	 *  and SCHED_RR policies.
+	 */
+	list_for_each_entry(q, tasks_queue, simple_list) {
+		struct task_struct *t;
+
+		t  = q->sleeper;
+		if (current->rt_priority == t->rt_priority) {
+			/*
+			* push in a FIFO manner
+			* tasks in same priority
+			*/
+			ret_pos = q;
+			continue;
+		}
+		if (current->rt_priority < t->rt_priority)
+			continue;
+		return &q->simple_list;
+	}
+	if (ret_pos)
+		return ret_pos->simple_list.next;
+	return tasks_queue;
+}
 
 SYSCALL_DEFINE4(semtimedop, int, semid, struct sembuf __user *, tsops,
 		unsigned, nsops, const struct timespec __user *, timeout)
@@ -1357,6 +1402,7 @@ SYSCALL_DEFINE4(semtimedop, int, semid, struct sembuf __user *, tsops,
 	unsigned long jiffies_left = 0;
 	struct ipc_namespace *ns;
 	struct list_head tasks;
+	struct list_head *pending_pos;
 
 	ns = current->nsproxy->ipc_ns;
 
@@ -1478,10 +1524,11 @@ SYSCALL_DEFINE4(semtimedop, int, semid, struct sembuf __user *, tsops,
 		struct sem *curr;
 		curr = &sma->sem_base[sops->sem_num];
 
+		pending_pos = find_pos(curr, alter, current);
 		if (alter)
-			list_add_tail(&queue.simple_list, &curr->sem_pending);
+			list_add_tail(&queue.simple_list, pending_pos);
 		else
-			list_add(&queue.simple_list, &curr->sem_pending);
+			list_add(&queue.simple_list, pending_pos);
 	} else {
 		INIT_LIST_HEAD(&queue.simple_list);
 		sma->complex_count++;
-- 
1.7.5.4




