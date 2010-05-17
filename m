Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756261Ab0EQW1e (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 May 2010 18:27:34 -0400
Received: from smtp-out.google.com ([74.125.121.35]:25679 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756228Ab0EQW1a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 May 2010 18:27:30 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
	b=jtVOtkpfKptbejrT+NuIb+yfORikRbr1sJzY/g8HckjJh6pEX378PAJLqNglSw9yi
	ETsEx0tdg04EbbLqTChiw==
From: Michel Lespinasse <walken@google.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       David Howells <dhowells@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Mike Waychison <mikew@google.com>,
       Suleiman Souhlal <suleiman@google.com>, Ying Han <yinghan@google.com>,
       Michel Lespinasse <walken@google.com>
Subject: [PATCH 03/10] rwsem: lighter active count checks when waking up readers
Date: Mon, 17 May 2010 15:25:47 -0700
Message-Id: <1274135154-24082-4-git-send-email-walken@google.com>
X-Mailer: git-send-email 1.7.0.1
In-Reply-To: <1274135154-24082-1-git-send-email-walken@google.com>
References: <1274135154-24082-1-git-send-email-walken@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In __rwsem_do_wake(), we can skip the active count check unless we come
there from up_xxxx(). Also when checking the active count, it is not
actually necessary to increment it; this allows us to get rid of the
read side undo code and simplify the calculation of the final rwsem count
adjustment once we've counted the reader threads to wake.

The basic observation is the following. When there are waiter threads
on a rwsem and the spinlock is held, other threads can only increment the
active count by trying to grab the rwsem in up_xxxx(). However up_xxxx()
will notice there are waiter threads and take the down_failed path,
blocking to acquire the spinlock on the way there. Therefore, a thread
observing an active count of zero with waiters queued and the spinlock held,
is protected against other threads acquiring the rwsem until it wakes the
last waiter or releases the spinlock.

Signed-off-by: Michel Lespinasse <walken@google.com>
---
 lib/rwsem.c |   60 ++++++++++++++++++++++++++++++++--------------------------
 1 files changed, 33 insertions(+), 27 deletions(-)

diff --git a/lib/rwsem.c b/lib/rwsem.c
index 874c0c1..ab0d306 100644
--- a/lib/rwsem.c
+++ b/lib/rwsem.c
@@ -36,6 +36,14 @@ struct rwsem_waiter {
 #define RWSEM_WAITING_FOR_WRITE	0x00000002
 };
 
+/* Wake types for __rwsem_do_wake().  Note that RWSEM_WAKE_NO_ACTIVE and
+ * RWSEM_WAKE_READ_OWNED imply that the spinlock must have been kept held
+ * since the rwsem value was observed.
+ */
+#define RWSEM_WAKE_ANY        0 /* Wake whatever's at head of wait list */
+#define RWSEM_WAKE_NO_ACTIVE  1 /* rwsem was observed with no active thread */
+#define RWSEM_WAKE_READ_OWNED 2 /* rwsem was observed to be read owned */
+
 /*
  * handle the lock release when processes blocked on it that can now run
  * - if we come here from up_xxxx(), then:
@@ -46,8 +54,8 @@ struct rwsem_waiter {
  * - woken process blocks are discarded from the list after having task zeroed
  * - writers are only woken if downgrading is false
  */
-static inline struct rw_semaphore *
-__rwsem_do_wake(struct rw_semaphore *sem, int downgrading)
+static struct rw_semaphore *
+__rwsem_do_wake(struct rw_semaphore *sem, int wake_type)
 {
 	struct rwsem_waiter *waiter;
 	struct task_struct *tsk;
@@ -58,7 +66,7 @@ __rwsem_do_wake(struct rw_semaphore *sem, int downgrading)
 	if (!(waiter->flags & RWSEM_WAITING_FOR_WRITE))
 		goto readers_only;
 
-	if (downgrading)
+	if (wake_type == RWSEM_WAKE_READ_OWNED)
 		goto out;
 
 	/* There's a writer at the front of the queue - try to grant it the
@@ -85,19 +93,24 @@ __rwsem_do_wake(struct rw_semaphore *sem, int downgrading)
 	goto out;
 
  readers_only:
-	if (!downgrading) {
-
-		/* if we came through an up_xxxx() call, we only only wake
-		 * someone up if we can transition the active part of the
-		 * count from 0 -> 1
-		 */
- try_again_read:
-		oldcount = rwsem_atomic_update(RWSEM_ACTIVE_BIAS, sem)
-							- RWSEM_ACTIVE_BIAS;
-		if (oldcount & RWSEM_ACTIVE_MASK)
-			/* Someone grabbed the sem already */
-			goto undo_read;
-	}
+	/* If we come here from up_xxxx(), another thread might have reached
+	 * rwsem_down_failed_common() before we acquired the spinlock and
+	 * woken up an active locker.  We prefer to check for this first in
+	 * order to not spend too much time with the spinlock held if we're
+	 * not going to be able to wake up readers in the end.
+	 *
+	 * Note that we do not need to update the rwsem count: any writer
+	 * trying to acquire rwsem will run rwsem_down_write_failed() due
+	 * to the waiting threads, and block trying to acquire the spinlock.
+	 *
+	 * We use a dummy atomic update in order to acquire the cache line
+	 * exclusively since we expect to succeed and run the final rwsem
+	 * count adjustment pretty soon.
+	 */
+	if (wake_type == RWSEM_WAKE_ANY &&
+	    rwsem_atomic_update(0, sem) & RWSEM_ACTIVE_MASK)
+		/* Someone grabbed the sem already */
+		goto out;
 
 	/* Grant an infinite number of read locks to the readers at the front
 	 * of the queue.  Note we increment the 'active part' of the count by
@@ -117,9 +130,6 @@ __rwsem_do_wake(struct rw_semaphore *sem, int downgrading)
 
 	loop = woken;
 	woken *= RWSEM_ACTIVE_BIAS - RWSEM_WAITING_BIAS;
-	if (!downgrading)
-		/* we'd already done one increment earlier */
-		woken -= RWSEM_ACTIVE_BIAS;
 
 	rwsem_atomic_add(woken, sem);
 
@@ -146,10 +156,6 @@ __rwsem_do_wake(struct rw_semaphore *sem, int downgrading)
 	if (rwsem_atomic_update(-RWSEM_ACTIVE_BIAS, sem) & RWSEM_ACTIVE_MASK)
 		goto out;
 	goto try_again;
- undo_read:
-	if (rwsem_atomic_update(-RWSEM_ACTIVE_BIAS, sem) & RWSEM_ACTIVE_MASK)
-		goto out;
-	goto try_again_read;
 }
 
 /*
@@ -171,12 +177,12 @@ rwsem_down_failed_common(struct rw_semaphore *sem,
 
 	list_add_tail(&waiter->list, &sem->wait_list);
 
-	/* we're now waiting on the lock, but no longer actively read-locking */
+	/* we're now waiting on the lock, but no longer actively locking */
 	count = rwsem_atomic_update(adjustment, sem);
 
 	/* if there are no active locks, wake the front queued process(es) up */
 	if (!(count & RWSEM_ACTIVE_MASK))
-		sem = __rwsem_do_wake(sem, 0);
+		sem = __rwsem_do_wake(sem, RWSEM_WAKE_NO_ACTIVE);
 
 	spin_unlock_irq(&sem->wait_lock);
 
@@ -233,7 +239,7 @@ asmregparm struct rw_semaphore *rwsem_wake(struct rw_semaphore *sem)
 
 	/* do nothing if list empty */
 	if (!list_empty(&sem->wait_list))
-		sem = __rwsem_do_wake(sem, 0);
+		sem = __rwsem_do_wake(sem, RWSEM_WAKE_ANY);
 
 	spin_unlock_irqrestore(&sem->wait_lock, flags);
 
@@ -253,7 +259,7 @@ asmregparm struct rw_semaphore *rwsem_downgrade_wake(struct rw_semaphore *sem)
 
 	/* do nothing if list empty */
 	if (!list_empty(&sem->wait_list))
-		sem = __rwsem_do_wake(sem, 1);
+		sem = __rwsem_do_wake(sem, RWSEM_WAKE_READ_OWNED);
 
 	spin_unlock_irqrestore(&sem->wait_lock, flags);
 
-- 
1.7.0.1

