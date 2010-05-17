Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756410Ab0EQW1z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 May 2010 18:27:55 -0400
Received: from smtp-out.google.com ([216.239.44.51]:12993 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756391Ab0EQW1w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 May 2010 18:27:52 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
	b=gZpxbihyP6wlXQ8QTl6L9Y2FXJaZevDely1Eu1ry56+wfEaSaj+Izrd4yN4Xqkxl1
	6LwEu/mM+vGiz1NFbMTBg==
From: Michel Lespinasse <walken@google.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       David Howells <dhowells@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Mike Waychison <mikew@google.com>,
       Suleiman Souhlal <suleiman@google.com>, Ying Han <yinghan@google.com>,
       Michel Lespinasse <walken@google.com>
Subject: [PATCH 04/10] rwsem: let RWSEM_WAITING_BIAS represent any number of waiting threads
Date: Mon, 17 May 2010 15:25:48 -0700
Message-Id: <1274135154-24082-5-git-send-email-walken@google.com>
X-Mailer: git-send-email 1.7.0.1
In-Reply-To: <1274135154-24082-1-git-send-email-walken@google.com>
References: <1274135154-24082-1-git-send-email-walken@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Previously each waiting thread added a bias of RWSEM_WAITING_BIAS. With this
change, the bias is added only once when the wait list is non-empty.

This has a few nice properties which will be used in following changes:
- when the spinlock is held and the waiter list is known to be non-empty,
  count < RWSEM_WAITING_BIAS  <=>  there is an active writer on that sem
- count == RWSEM_WAITING_BIAS  <=>  there are waiting threads and no
                                     active readers/writers on that sem

Signed-off-by: Michel Lespinasse <walken@google.com>
---
 lib/rwsem.c |   28 +++++++++++++++++-----------
 1 files changed, 17 insertions(+), 11 deletions(-)

diff --git a/lib/rwsem.c b/lib/rwsem.c
index ab0d306..b2dde5a 100644
--- a/lib/rwsem.c
+++ b/lib/rwsem.c
@@ -60,7 +60,7 @@ __rwsem_do_wake(struct rw_semaphore *sem, int wake_type)
 	struct rwsem_waiter *waiter;
 	struct task_struct *tsk;
 	struct list_head *next;
-	signed long oldcount, woken, loop;
+	signed long oldcount, woken, loop, adjustment;
 
 	waiter = list_entry(sem->wait_list.next, struct rwsem_waiter, list);
 	if (!(waiter->flags & RWSEM_WAITING_FOR_WRITE))
@@ -73,9 +73,12 @@ __rwsem_do_wake(struct rw_semaphore *sem, int wake_type)
 	 * write lock.  However, we only wake this writer if we can transition
 	 * the active part of the count from 0 -> 1
 	 */
+	adjustment = RWSEM_ACTIVE_WRITE_BIAS;
+	if (waiter->list.next == &sem->wait_list)
+		adjustment -= RWSEM_WAITING_BIAS;
+
  try_again:
-	oldcount = rwsem_atomic_update(RWSEM_ACTIVE_BIAS, sem)
-						- RWSEM_ACTIVE_BIAS;
+	oldcount = rwsem_atomic_update(adjustment, sem) - adjustment;
 	if (oldcount & RWSEM_ACTIVE_MASK)
 		/* Someone grabbed the sem already */
 		goto undo;
@@ -128,13 +131,15 @@ __rwsem_do_wake(struct rw_semaphore *sem, int wake_type)
 
 	} while (waiter->flags & RWSEM_WAITING_FOR_READ);
 
-	loop = woken;
-	woken *= RWSEM_ACTIVE_BIAS - RWSEM_WAITING_BIAS;
+	adjustment = woken * RWSEM_ACTIVE_READ_BIAS;
+	if (waiter->flags & RWSEM_WAITING_FOR_READ)
+		/* hit end of list above */
+		adjustment -= RWSEM_WAITING_BIAS;
 
-	rwsem_atomic_add(woken, sem);
+	rwsem_atomic_add(adjustment, sem);
 
 	next = sem->wait_list.next;
-	for (; loop > 0; loop--) {
+	for (loop = woken; loop > 0; loop--) {
 		waiter = list_entry(next, struct rwsem_waiter, list);
 		next = waiter->list.next;
 		tsk = waiter->task;
@@ -153,7 +158,7 @@ __rwsem_do_wake(struct rw_semaphore *sem, int wake_type)
 	/* undo the change to the active count, but check for a transition
 	 * 1->0 */
  undo:
-	if (rwsem_atomic_update(-RWSEM_ACTIVE_BIAS, sem) & RWSEM_ACTIVE_MASK)
+	if (rwsem_atomic_update(-adjustment, sem) & RWSEM_ACTIVE_MASK)
 		goto out;
 	goto try_again;
 }
@@ -175,6 +180,8 @@ rwsem_down_failed_common(struct rw_semaphore *sem,
 	waiter->task = tsk;
 	get_task_struct(tsk);
 
+	if (list_empty(&sem->wait_list))
+		adjustment += RWSEM_WAITING_BIAS;
 	list_add_tail(&waiter->list, &sem->wait_list);
 
 	/* we're now waiting on the lock, but no longer actively locking */
@@ -208,8 +215,7 @@ rwsem_down_read_failed(struct rw_semaphore *sem)
 	struct rwsem_waiter waiter;
 
 	waiter.flags = RWSEM_WAITING_FOR_READ;
-	rwsem_down_failed_common(sem, &waiter,
-				RWSEM_WAITING_BIAS - RWSEM_ACTIVE_BIAS);
+	rwsem_down_failed_common(sem, &waiter, -RWSEM_ACTIVE_READ_BIAS);
 	return sem;
 }
 
@@ -222,7 +228,7 @@ rwsem_down_write_failed(struct rw_semaphore *sem)
 	struct rwsem_waiter waiter;
 
 	waiter.flags = RWSEM_WAITING_FOR_WRITE;
-	rwsem_down_failed_common(sem, &waiter, -RWSEM_ACTIVE_BIAS);
+	rwsem_down_failed_common(sem, &waiter, -RWSEM_ACTIVE_WRITE_BIAS);
 
 	return sem;
 }
-- 
1.7.0.1

