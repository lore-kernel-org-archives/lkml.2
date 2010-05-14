Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757532Ab0ENMlk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 May 2010 08:41:40 -0400
Received: from smtp-out.google.com ([216.239.44.51]:19324 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756850Ab0ENMlh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 May 2010 08:41:37 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
	b=moMs0QCvCZ6tJ5RsuOHeWXv3H6QDNM4AabR5K+exSNrsyiqnu7uNhYQFcI+O2QuIZ
	4hRLQWYvNxM0HhnrvWgxQ==
From: Michel Lespinasse <walken@google.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       David Howells <dhowells@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Mike Waychison <mikew@google.com>,
       Suleiman Souhlal <suleiman@google.com>, Ying Han <yinghan@google.com>,
       Michel Lespinasse <walken@google.com>
Subject: [PATCH 05/10] rwsem: wake queued readers when writer blocks on active read lock
Date: Fri, 14 May 2010 05:39:37 -0700
Message-Id: <1273840782-5920-6-git-send-email-walken@google.com>
X-Mailer: git-send-email 1.7.0.1
In-Reply-To: <1273840782-5920-1-git-send-email-walken@google.com>
References: <1273840782-5920-1-git-send-email-walken@google.com>
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
 lib/rwsem.c |   21 ++++++++++++++++-----
 1 files changed, 16 insertions(+), 5 deletions(-)

diff --git a/lib/rwsem.c b/lib/rwsem.c
index 92a133f..6e1200e 100644
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
@@ -98,7 +101,7 @@ __rwsem_do_wake(struct rw_semaphore *sem, int wake_type)
  readers_only:
 	/* If we come here from up_xxxx(), another thread might have reached
 	 * rwsem_down_failed_common() before we acquired the spinlock and
-	 * woken up an active locker.  We prefer to check for this first in
+	 * woken up an active writer.  We prefer to check for this first in
 	 * order to not spend too much time with the spinlock held if we're
 	 * not going to be able to wake up readers in the end.
 	 *
@@ -111,8 +114,8 @@ __rwsem_do_wake(struct rw_semaphore *sem, int wake_type)
 	 * count adjustment pretty soon.
 	 */
 	if (wake_type == RWSEM_WAKE_ANY &&
-	    rwsem_atomic_update(0, sem) & RWSEM_ACTIVE_MASK)
-		/* Someone grabbed the sem already */
+	    rwsem_atomic_update(0, sem) < RWSEM_WAITING_BIAS)
+		/* Someone grabbed the sem for write already */
 		goto out;
 
 	/* Grant an infinite number of read locks to the readers at the front
@@ -186,9 +189,17 @@ rwsem_down_failed_common(struct rw_semaphore *sem,
 	/* we're now waiting on the lock, but no longer actively locking */
 	count = rwsem_atomic_update(adjustment, sem);
 
-	/* if there are no active locks, wake the front queued process(es) up */
-	if (!(count & RWSEM_ACTIVE_MASK))
+	/* If there are no active locks, wake the front queued process(es) up.
+	 *
+	 * Alternatively, if we're called from a failed down_write(), there
+	 * were already threads queued before us, and there are no active
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

