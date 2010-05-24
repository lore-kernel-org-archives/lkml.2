Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757144Ab0EXUb7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 May 2010 16:31:59 -0400
Received: from smtp-out.google.com ([216.239.44.51]:5571 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756004Ab0EXUb4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 May 2010 16:31:56 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:
	references:x-system-of-record;
	b=ID2pA5Q4Fj0GOIEbtwULjezTObwEuoNvoDfSbzAOopTfC3MLSft52ZwPf9BFkEoQT
	3eF70cGkRBrLP/3C3dW/g==
From: Michel Lespinasse <walken@google.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       David Howells <dhowells@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Mike Waychison <mikew@google.com>,
       Suleiman Souhlal <suleiman@google.com>, Ying Han <yinghan@google.com>
Subject: [PATCH 06/11] rwsem: wake queued readers when writer blocks on active read lock
Date: Mon, 24 May 2010 13:31:16 -0700
Message-Id: <1274733081-4623-7-git-send-email-walken@google.com>
X-Mailer: git-send-email 1.7.0.1
In-Reply-To: <1274733081-4623-1-git-send-email-walken@google.com>
References: <1274733081-4623-1-git-send-email-walken@google.com>
X-System-Of-Record: true
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
 lib/rwsem.c |   19 +++++++++++++++----
 1 files changed, 15 insertions(+), 4 deletions(-)

diff --git a/lib/rwsem.c b/lib/rwsem.c
index a3e68bf..318d435 100644
--- a/lib/rwsem.c
+++ b/lib/rwsem.c
@@ -67,6 +67,9 @@ __rwsem_do_wake(struct rw_semaphore *sem, int wake_type)
 		goto readers_only;
 
 	if (wake_type == RWSEM_WAKE_READ_OWNED)
+		/* Another active reader was observed, so wakeup is not
+		 * likely to succeed. Save the atomic op.
+		 */
 		goto out;
 
 	/* There's a writer at the front of the queue - try to grant it the
@@ -111,8 +114,8 @@ __rwsem_do_wake(struct rw_semaphore *sem, int wake_type)
 	 * count adjustment pretty soon.
 	 */
 	if (wake_type == RWSEM_WAKE_ANY &&
-	    (rwsem_atomic_update(0, sem) & RWSEM_ACTIVE_MASK))
-		/* Someone grabbed the sem already */
+	    rwsem_atomic_update(0, sem) < RWSEM_WAITING_BIAS)
+		/* Someone grabbed the sem for write already */
 		goto out;
 
 	/* Grant an infinite number of read locks to the readers at the front
@@ -187,9 +190,17 @@ rwsem_down_failed_common(struct rw_semaphore *sem,
 	/* we're now waiting on the lock, but no longer actively locking */
 	count = rwsem_atomic_update(adjustment, sem);
 
-	/* if there are no active locks, wake the front queued process(es) up */
-	if (!(count & RWSEM_ACTIVE_MASK))
+	/* If there are no active locks, wake the front queued process(es) up.
+	 *
+	 * Alternatively, if we're called from a failed down_write(), there
+	 * were already threads queued before us and there are no active
+	 * writers, the lock must be read owned; so we try to wake any read
+	 * locks that were queued ahead of us. */
+	if (count == RWSEM_WAITING_BIAS)
 		sem = __rwsem_do_wake(sem, RWSEM_WAKE_NO_ACTIVE);
+	else if (count > RWSEM_WAITING_BIAS &&
+		 adjustment == -RWSEM_ACTIVE_WRITE_BIAS)
+		sem = __rwsem_do_wake(sem, RWSEM_WAKE_READ_OWNED);
 
 	spin_unlock_irq(&sem->wait_lock);
 
-- 
1.7.0.1

