Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754674Ab0ELDWd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 May 2010 23:22:33 -0400
Received: from smtp-out.google.com ([74.125.121.35]:52305 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754361Ab0ELDWY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 May 2010 23:22:24 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
	b=iSQHNvhpUkA5/gyY4mzRW4q77T6jZ151uZxVWTZBw1aux8ZyLGvJ+cNDmTpw2M5aR
	ypbcKpuaS9Iu77J3D0VPw==
From: Michel Lespinasse <walken@google.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       David Howells <dhowells@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Mike Waychison <mikew@google.com>,
       Suleiman Souhlal <suleiman@google.com>, Ying Han <yinghan@google.com>,
       Michel Lespinasse <walken@google.com>
Subject: [PATCH 07/12] rwsem: wake queued readers when writer blocks on active read lock
Date: Tue, 11 May 2010 20:20:57 -0700
Message-Id: <1273634462-2672-8-git-send-email-walken@google.com>
X-Mailer: git-send-email 1.7.0.1
In-Reply-To: <1273634462-2672-1-git-send-email-walken@google.com>
References: <1273634462-2672-1-git-send-email-walken@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This change addresses the following situation:

- Thread A acquires the rwsem for read
- Thread B tries to acquire the rwsem for write, notices there is already
  an active owner for the rwsem.
- Thread C tries to acquire the rwsem for read, notices that thread B already
  tried to acquire it.
- Thread C grabs the spinlock and queues itself on the wait queue.
- Thread B grabs the spinlock and queues itself behind C. At this point A is
  the only remaining active owner on the rwsem.

In this situation thread B could notice that it was the last active writer
on the rwsem, and decide to wake C to let it proceed in parallel with A
since they both only want the rwsem for read.

Signed-off-by: Michel Lespinasse <walken@google.com>
---
 lib/rwsem.c |   32 ++++++++++++++++++++++----------
 1 files changed, 22 insertions(+), 10 deletions(-)

diff --git a/lib/rwsem.c b/lib/rwsem.c
index 9d0899b..84bbc55 100644
--- a/lib/rwsem.c
+++ b/lib/rwsem.c
@@ -36,6 +36,10 @@ struct rwsem_waiter {
 #define RWSEM_WAITING_FOR_WRITE	0x00000002
 };
 
+#define RWSEM_WAKE_ANY        0 /* Wake whatever's at head of wait list */
+#define RWSEM_WAKE_READERS    1 /* Sem is read owned by other thread */
+#define RWSEM_WAKE_READ_OWNED 2 /* Sem is read owned by caller thread */
+
 /*
  * handle the lock release when processes blocked on it that can now run
  * - if we come here from up_xxxx(), then:
@@ -46,8 +50,8 @@ struct rwsem_waiter {
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
@@ -58,9 +62,9 @@ __rwsem_do_wake(struct rw_semaphore *sem, int downgrading)
 	if (!(waiter->flags & RWSEM_WAITING_FOR_WRITE))
 		goto readers_only;
 
-	if (downgrading)
-		/* Caller's lock is still active, so we can't possibly
-		 * succeed waking writers.
+	if (wake_type != RWSEM_WAKE_ANY)
+		/* Another active reader was observed, so wakeup is not
+		 * likely to succeed. Save the atomic op.
 		 */
 		goto out;
 
@@ -115,7 +119,8 @@ __rwsem_do_wake(struct rw_semaphore *sem, int downgrading)
 
  retry_readers:
 	oldcount = rwsem_atomic_update(adjustment, sem) - adjustment;
-	if (!downgrading && (oldcount < RWSEM_WAITING_BIAS))
+	if (wake_type != RWSEM_WAKE_READ_OWNED &&
+	    oldcount < RWSEM_WAITING_BIAS)
 		/* Someone grabbed the sem for write already */
 		goto undo_readers;
 
@@ -172,9 +177,16 @@ rwsem_down_failed_common(struct rw_semaphore *sem,
 	/* we're now waiting on the lock, but no longer actively read-locking */
 	count = rwsem_atomic_update(adjustment, sem);
 
-	/* if there are no active locks, wake the front queued process(es) up */
+	/* if there are no active locks, wake the front queued process(es) up.
+	 *
+	 * or if we're called from a failed down_write(), and there were
+	 * already threads queued before us, and there are no active writers,
+	 * the lock must be read owned; try to wake any read locks that were
+	 * queued ahead of us. */
 	if (!(count & RWSEM_ACTIVE_MASK))
-		sem = __rwsem_do_wake(sem, 0);
+		sem = __rwsem_do_wake(sem, RWSEM_WAKE_ANY);
+	else if (adjustment > 0 && count > RWSEM_WAITING_BIAS)
+		sem = __rwsem_do_wake(sem, RWSEM_WAKE_READERS);
 
 	spin_unlock_irq(&sem->wait_lock);
 
@@ -230,7 +242,7 @@ asmregparm struct rw_semaphore *rwsem_wake(struct rw_semaphore *sem)
 
 	/* do nothing if list empty */
 	if (!list_empty(&sem->wait_list))
-		sem = __rwsem_do_wake(sem, 0);
+		sem = __rwsem_do_wake(sem, RWSEM_WAKE_ANY);
 
 	spin_unlock_irqrestore(&sem->wait_lock, flags);
 
@@ -250,7 +262,7 @@ asmregparm struct rw_semaphore *rwsem_downgrade_wake(struct rw_semaphore *sem)
 
 	/* do nothing if list empty */
 	if (!list_empty(&sem->wait_list))
-		sem = __rwsem_do_wake(sem, 1);
+		sem = __rwsem_do_wake(sem, RWSEM_WAKE_READ_OWNED);
 
 	spin_unlock_irqrestore(&sem->wait_lock, flags);
 
-- 
1.7.0.1

