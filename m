Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754596Ab0ELDWa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 May 2010 23:22:30 -0400
Received: from smtp-out.google.com ([74.125.121.35]:52306 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754365Ab0ELDWY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 May 2010 23:22:24 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
	b=QH9J6qOq5t6GE+iqVPZAOo3QbJMCNezC/RlpzIZZXT3Gma4yPGJKtpoWRvhqDzRCO
	a8mmQn2Vs7t8AT90MI18A==
From: Michel Lespinasse <walken@google.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       David Howells <dhowells@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Mike Waychison <mikew@google.com>,
       Suleiman Souhlal <suleiman@google.com>, Ying Han <yinghan@google.com>,
       Michel Lespinasse <walken@google.com>
Subject: [PATCH 02/12] rwsem: use single atomic update for sem count when waking up readers.
Date: Tue, 11 May 2010 20:20:52 -0700
Message-Id: <1273634462-2672-3-git-send-email-walken@google.com>
X-Mailer: git-send-email 1.7.0.1
In-Reply-To: <1273634462-2672-1-git-send-email-walken@google.com>
References: <1273634462-2672-1-git-send-email-walken@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When waking up queued readers, __rwsem_do_wake was using a pair of atomic
operations (one before looking at the first queued thread and one after
having looped through all readers). Restructure code to use a single
atomic operation instead.

Signed-off-by: Michel Lespinasse <walken@google.com>
---
 lib/rwsem.c |   52 ++++++++++++++++++++++++++--------------------------
 1 files changed, 26 insertions(+), 26 deletions(-)

diff --git a/lib/rwsem.c b/lib/rwsem.c
index 8d6a13e..caee9b7 100644
--- a/lib/rwsem.c
+++ b/lib/rwsem.c
@@ -41,7 +41,7 @@ struct rwsem_waiter {
  * - if we come here from up_xxxx(), then:
  *   - the 'active part' of count (&0x0000ffff) reached 0 (but may have changed)
  *   - the 'waiting part' of count (&0xffff0000) is -ve (and will still be so)
- *   - there must be someone on the queue
+ * - there must be someone on the queue
  * - the spinlock must be held by the caller
  * - woken process blocks are discarded from the list after having task zeroed
  * - writers are only woken if downgrading is false
@@ -54,26 +54,26 @@ __rwsem_do_wake(struct rw_semaphore *sem, int downgrading)
 	struct list_head *next;
 	signed long oldcount, woken, loop;
 
+	waiter = list_entry(sem->wait_list.next, struct rwsem_waiter, list);
+	if (!(waiter->flags & RWSEM_WAITING_FOR_WRITE))
+		goto readers_only;
+
 	if (downgrading)
-		goto dont_wake_writers;
+		/* Caller's lock is still active, so we can't possibly
+		 * succeed waking writers.
+		 */
+		goto out;
 
-	/* if we came through an up_xxxx() call, we only only wake someone up
+	/* There's a writer at the front of the queue - try to grant it the
+	 * write lock. However, we only only wake someone up
 	 * if we can transition the active part of the count from 0 -> 1
 	 */
- try_again:
+ retry_writer:
 	oldcount = rwsem_atomic_update(RWSEM_ACTIVE_BIAS, sem)
 						- RWSEM_ACTIVE_BIAS;
 	if (oldcount & RWSEM_ACTIVE_MASK)
-		goto undo;
-
-	waiter = list_entry(sem->wait_list.next, struct rwsem_waiter, list);
-
-	/* try to grant a single write lock if there's a writer at the front
-	 * of the queue - note we leave the 'active part' of the count
-	 * incremented by 1 and the waiting part incremented by 0x00010000
-	 */
-	if (!(waiter->flags & RWSEM_WAITING_FOR_WRITE))
-		goto readers_only;
+		/* Someone grabbed the sem already */
+		goto undo_writer;
 
 	/* We must be careful not to touch 'waiter' after we set ->task = NULL.
 	 * It is an allocated on the waiter's stack and may become invalid at
@@ -87,12 +87,6 @@ __rwsem_do_wake(struct rw_semaphore *sem, int downgrading)
 	put_task_struct(tsk);
 	goto out;
 
-	/* don't want to wake any writers */
- dont_wake_writers:
-	waiter = list_entry(sem->wait_list.next, struct rwsem_waiter, list);
-	if (waiter->flags & RWSEM_WAITING_FOR_WRITE)
-		goto out;
-
 	/* grant an infinite number of read locks to the readers at the front
 	 * of the queue
 	 * - note we increment the 'active part' of the count by the number of
@@ -113,11 +107,12 @@ __rwsem_do_wake(struct rw_semaphore *sem, int downgrading)
 
 	loop = woken;
 	woken *= RWSEM_ACTIVE_BIAS - RWSEM_WAITING_BIAS;
-	if (!downgrading)
-		/* we'd already done one increment earlier */
-		woken -= RWSEM_ACTIVE_BIAS;
 
-	rwsem_atomic_add(woken, sem);
+ retry_readers:
+	oldcount = rwsem_atomic_update(woken, sem) - woken;
+	if (!downgrading && (oldcount & RWSEM_ACTIVE_MASK))
+		/* Someone grabbed the sem already */
+		goto undo_readers;
 
 	next = sem->wait_list.next;
 	for (; loop > 0; loop--) {
@@ -137,10 +132,15 @@ __rwsem_do_wake(struct rw_semaphore *sem, int downgrading)
 	return sem;
 
 	/* undo the change to count, but check for a transition 1->0 */
- undo:
+ undo_writer:
 	if (rwsem_atomic_update(-RWSEM_ACTIVE_BIAS, sem) & RWSEM_ACTIVE_MASK)
 		goto out;
-	goto try_again;
+	goto retry_writer;
+
+ undo_readers:
+	if (rwsem_atomic_update(-woken, sem) & RWSEM_ACTIVE_MASK)
+		goto out;
+	goto retry_readers;
 }
 
 /*
-- 
1.7.0.1

