Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754709Ab0ELDWh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 May 2010 23:22:37 -0400
Received: from smtp-out.google.com ([74.125.121.35]:52304 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754359Ab0ELDWX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 May 2010 23:22:23 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
	b=pgAQFu63DpbHbbsSf7zGuB25K274HaLJXo55p3JMZygot2R6Jjbi9L/Pd+w+Voy3k
	ESSMOZF8ee/GhaeDLzVWw==
From: Michel Lespinasse <walken@google.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       David Howells <dhowells@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Mike Waychison <mikew@google.com>,
       Suleiman Souhlal <suleiman@google.com>, Ying Han <yinghan@google.com>,
       Michel Lespinasse <walken@google.com>
Subject: [PATCH 03/12] rwsem: let RWSEM_WAITING_BIAS represent any number of waiting threads
Date: Tue, 11 May 2010 20:20:53 -0700
Message-Id: <1273634462-2672-4-git-send-email-walken@google.com>
X-Mailer: git-send-email 1.7.0.1
In-Reply-To: <1273634462-2672-1-git-send-email-walken@google.com>
References: <1273634462-2672-1-git-send-email-walken@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Previously each waiting thread added a bias of RWSEM_WAITING_BIAS. With this
change, the bias is added only once when the wait list is non-empty.

This has a few nice properties which will be used in following changes:
- when the mutex is held and the waiter list is known to be non-empty,
  count < RWSEM_WAITING_BIAS  <=>  there is an active writer on that sem
- count == RWSEM_WAITING_BIAS  <=>  there are waiting threads and no
                                     active readers/writers on that sem

Signed-off-by: Michel Lespinasse <walken@google.com>
---
 lib/rwsem.c |   23 +++++++++++++++--------
 1 files changed, 15 insertions(+), 8 deletions(-)

diff --git a/lib/rwsem.c b/lib/rwsem.c
index caee9b7..0fb6e38 100644
--- a/lib/rwsem.c
+++ b/lib/rwsem.c
@@ -52,7 +52,7 @@ __rwsem_do_wake(struct rw_semaphore *sem, int downgrading)
 	struct rwsem_waiter *waiter;
 	struct task_struct *tsk;
 	struct list_head *next;
-	signed long oldcount, woken, loop;
+	signed long oldcount, woken, loop, adjustment;
 
 	waiter = list_entry(sem->wait_list.next, struct rwsem_waiter, list);
 	if (!(waiter->flags & RWSEM_WAITING_FOR_WRITE))
@@ -68,9 +68,12 @@ __rwsem_do_wake(struct rw_semaphore *sem, int downgrading)
 	 * write lock. However, we only only wake someone up
 	 * if we can transition the active part of the count from 0 -> 1
 	 */
+	adjustment = RWSEM_ACTIVE_WRITE_BIAS;
+	if (waiter->list.next == &sem->wait_list)
+		adjustment -= RWSEM_WAITING_BIAS;
+
  retry_writer:
-	oldcount = rwsem_atomic_update(RWSEM_ACTIVE_BIAS, sem)
-						- RWSEM_ACTIVE_BIAS;
+	oldcount = rwsem_atomic_update(adjustment, sem) - adjustment;
 	if (oldcount & RWSEM_ACTIVE_MASK)
 		/* Someone grabbed the sem already */
 		goto undo_writer;
@@ -106,7 +109,10 @@ __rwsem_do_wake(struct rw_semaphore *sem, int downgrading)
 	} while (waiter->flags & RWSEM_WAITING_FOR_READ);
 
 	loop = woken;
-	woken *= RWSEM_ACTIVE_BIAS - RWSEM_WAITING_BIAS;
+	woken *= RWSEM_ACTIVE_READ_BIAS;
+	if (waiter->flags & RWSEM_WAITING_FOR_READ)
+		/* hit end of list above */
+		woken -= RWSEM_WAITING_BIAS;
 
  retry_readers:
 	oldcount = rwsem_atomic_update(woken, sem) - woken;
@@ -133,7 +139,7 @@ __rwsem_do_wake(struct rw_semaphore *sem, int downgrading)
 
 	/* undo the change to count, but check for a transition 1->0 */
  undo_writer:
-	if (rwsem_atomic_update(-RWSEM_ACTIVE_BIAS, sem) & RWSEM_ACTIVE_MASK)
+	if (rwsem_atomic_update(-adjustment, sem) & RWSEM_ACTIVE_MASK)
 		goto out;
 	goto retry_writer;
 
@@ -160,6 +166,8 @@ rwsem_down_failed_common(struct rw_semaphore *sem,
 	waiter->task = tsk;
 	get_task_struct(tsk);
 
+	if (list_empty(&sem->wait_list))
+		adjustment += RWSEM_WAITING_BIAS;
 	list_add_tail(&waiter->list, &sem->wait_list);
 
 	/* we're now waiting on the lock, but no longer actively read-locking */
@@ -193,8 +201,7 @@ rwsem_down_read_failed(struct rw_semaphore *sem)
 	struct rwsem_waiter waiter;
 
 	waiter.flags = RWSEM_WAITING_FOR_READ;
-	rwsem_down_failed_common(sem, &waiter,
-				RWSEM_WAITING_BIAS - RWSEM_ACTIVE_BIAS);
+	rwsem_down_failed_common(sem, &waiter, -RWSEM_ACTIVE_READ_BIAS);
 	return sem;
 }
 
@@ -207,7 +214,7 @@ rwsem_down_write_failed(struct rw_semaphore *sem)
 	struct rwsem_waiter waiter;
 
 	waiter.flags = RWSEM_WAITING_FOR_WRITE;
-	rwsem_down_failed_common(sem, &waiter, -RWSEM_ACTIVE_BIAS);
+	rwsem_down_failed_common(sem, &waiter, -RWSEM_ACTIVE_WRITE_BIAS);
 
 	return sem;
 }
-- 
1.7.0.1

