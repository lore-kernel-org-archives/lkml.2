Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757798Ab0EXUcJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 May 2010 16:32:09 -0400
Received: from smtp-out.google.com ([74.125.121.35]:52604 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756845Ab0EXUb4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 May 2010 16:31:56 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:
	references:x-system-of-record;
	b=aw9Zgcne+1TGq72FNl9YF+FDYDQ1/u78gX2u35uaS3SWkWv3JlyA9EMce6yynpehZ
	Q2BF3FGbcpjGe8SBoaJRw==
From: Michel Lespinasse <walken@google.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       David Howells <dhowells@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Mike Waychison <mikew@google.com>,
       Suleiman Souhlal <suleiman@google.com>, Ying Han <yinghan@google.com>
Subject: [PATCH 03/11] rwsem: fully separate code pathes to wake writers vs readers
Date: Mon, 24 May 2010 13:31:13 -0700
Message-Id: <1274733081-4623-4-git-send-email-walken@google.com>
X-Mailer: git-send-email 1.7.0.1
In-Reply-To: <1274733081-4623-1-git-send-email-walken@google.com>
References: <1274733081-4623-1-git-send-email-walken@google.com>
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is in preparation to later changes in the series.

In __rwsem_do_wake(), the first queued waiter is checked first in order
to determine whether it's a writer or a reader. The code paths diverge
at this point. The code that checks and increments the rwsem active count
is duplicated on both sides - the point is that later changes in the
series will be able to independently modify both sides.

Signed-off-by: Michel Lespinasse <walken@google.com>
---
 lib/rwsem.c |   61 ++++++++++++++++++++++++++++++++--------------------------
 1 files changed, 34 insertions(+), 27 deletions(-)

diff --git a/lib/rwsem.c b/lib/rwsem.c
index ceba8e2..917fd94 100644
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
@@ -54,26 +54,23 @@ __rwsem_do_wake(struct rw_semaphore *sem, int downgrading)
 	struct list_head *next;
 	signed long oldcount, woken, loop;
 
+	waiter = list_entry(sem->wait_list.next, struct rwsem_waiter, list);
+	if (!(waiter->flags & RWSEM_WAITING_FOR_WRITE))
+		goto readers_only;
+
 	if (downgrading)
-		goto dont_wake_writers;
+		goto out;
 
-	/* if we came through an up_xxxx() call, we only only wake someone up
-	 * if we can transition the active part of the count from 0 -> 1
+	/* There's a writer at the front of the queue - try to grant it the
+	 * write lock.  However, we only wake this writer if we can transition
+	 * the active part of the count from 0 -> 1
 	 */
- try_again:
+ try_again_write:
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
+		goto undo_write;
 
 	/* We must be careful not to touch 'waiter' after we set ->task = NULL.
 	 * It is an allocated on the waiter's stack and may become invalid at
@@ -87,18 +84,24 @@ __rwsem_do_wake(struct rw_semaphore *sem, int downgrading)
 	put_task_struct(tsk);
 	goto out;
 
-	/* don't want to wake any writers */
- dont_wake_writers:
-	waiter = list_entry(sem->wait_list.next, struct rwsem_waiter, list);
-	if (waiter->flags & RWSEM_WAITING_FOR_WRITE)
-		goto out;
+ readers_only:
+	if (downgrading)
+		goto wake_readers;
+
+	/* if we came through an up_xxxx() call, we only only wake someone up
+	 * if we can transition the active part of the count from 0 -> 1 */
+ try_again_read:
+	oldcount = rwsem_atomic_update(RWSEM_ACTIVE_BIAS, sem)
+						- RWSEM_ACTIVE_BIAS;
+	if (oldcount & RWSEM_ACTIVE_MASK)
+		/* Someone grabbed the sem already */
+		goto undo_read;
 
-	/* grant an infinite number of read locks to the readers at the front
-	 * of the queue
-	 * - note we increment the 'active part' of the count by the number of
-	 *   readers before waking any processes up
+ wake_readers:
+	/* Grant an infinite number of read locks to the readers at the front
+	 * of the queue.  Note we increment the 'active part' of the count by
+	 * the number of readers before waking any processes up.
 	 */
- readers_only:
 	woken = 0;
 	do {
 		woken++;
@@ -138,10 +141,14 @@ __rwsem_do_wake(struct rw_semaphore *sem, int downgrading)
 
 	/* undo the change to the active count, but check for a transition
 	 * 1->0 */
- undo:
+ undo_write:
+	if (rwsem_atomic_update(-RWSEM_ACTIVE_BIAS, sem) & RWSEM_ACTIVE_MASK)
+		goto out;
+	goto try_again_write;
+ undo_read:
 	if (rwsem_atomic_update(-RWSEM_ACTIVE_BIAS, sem) & RWSEM_ACTIVE_MASK)
 		goto out;
-	goto try_again;
+	goto try_again_read;
 }
 
 /*
-- 
1.7.0.1

