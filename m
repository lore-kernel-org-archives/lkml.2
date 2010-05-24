Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758051Ab0EXUdO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 May 2010 16:33:14 -0400
Received: from smtp-out.google.com ([216.239.44.51]:5582 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757077Ab0EXUb6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 May 2010 16:31:58 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:
	references:x-system-of-record;
	b=ZYXfl4iCgm7hS8CbBdur1hRTJM5sJvRqi3od1xIIM1cglObDai7+TbaEQRFTquSGJ
	TwfWLI781YDQf2EJmU6AQ==
From: Michel Lespinasse <walken@google.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       David Howells <dhowells@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Mike Waychison <mikew@google.com>,
       Suleiman Souhlal <suleiman@google.com>, Ying Han <yinghan@google.com>,
       David Howells <dhowells@redhat.com>
Subject: [PATCH 09/11] rwsem: down_read_critical infrastructure support
Date: Mon, 24 May 2010 13:31:19 -0700
Message-Id: <1274733081-4623-10-git-send-email-walken@google.com>
X-Mailer: git-send-email 1.7.0.1
In-Reply-To: <1274733081-4623-1-git-send-email-walken@google.com>
References: <1274733081-4623-1-git-send-email-walken@google.com>
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add rwsem_down_read_unfair_failed() function in the non-generic rwsem
library code, similar to  rwsem_down_read_failed() except that blocked
threads are placed at the head of the queue.

Make the waiter type an enumeration rather than a bitmask.

Signed-off-by: Michel Lespinasse <walken@google.com>
Signed-off-by: David Howells <dhowells@redhat.com>
---
 lib/rwsem.c |   40 +++++++++++++++++++++++++++++++---------
 1 files changed, 31 insertions(+), 9 deletions(-)

diff --git a/lib/rwsem.c b/lib/rwsem.c
index f236d7c..72454f4 100644
--- a/lib/rwsem.c
+++ b/lib/rwsem.c
@@ -28,12 +28,16 @@ void __init_rwsem(struct rw_semaphore *sem, const char *name,
 
 EXPORT_SYMBOL(__init_rwsem);
 
+enum rwsem_waiter_type {
+	RWSEM_WAITING_FOR_WRITE,
+	RWSEM_WAITING_FOR_READ,
+	RWSEM_WAITING_FOR_UNFAIR_READ
+};
+
 struct rwsem_waiter {
 	struct list_head list;
 	struct task_struct *task;
-	unsigned int flags;
-#define RWSEM_WAITING_FOR_READ	0x00000001
-#define RWSEM_WAITING_FOR_WRITE	0x00000002
+	enum rwsem_waiter_type type;
 };
 
 /* Wake types for __rwsem_do_wake().  Note that RWSEM_WAKE_NO_ACTIVE and
@@ -63,7 +67,7 @@ __rwsem_do_wake(struct rw_semaphore *sem, int wake_type)
 	signed long oldcount, woken, loop, adjustment;
 
 	waiter = list_entry(sem->wait_list.next, struct rwsem_waiter, list);
-	if (!(waiter->flags & RWSEM_WAITING_FOR_WRITE))
+	if (waiter->type != RWSEM_WAITING_FOR_WRITE)
 		goto readers_only;
 
 	if (wake_type == RWSEM_WAKE_READ_OWNED)
@@ -132,10 +136,10 @@ __rwsem_do_wake(struct rw_semaphore *sem, int wake_type)
 		waiter = list_entry(waiter->list.next,
 					struct rwsem_waiter, list);
 
-	} while (waiter->flags & RWSEM_WAITING_FOR_READ);
+	} while (waiter->type != RWSEM_WAITING_FOR_WRITE);
 
 	adjustment = woken * RWSEM_ACTIVE_READ_BIAS;
-	if (waiter->flags & RWSEM_WAITING_FOR_READ)
+	if (waiter->type != RWSEM_WAITING_FOR_WRITE)
 		/* hit end of list above */
 		adjustment -= RWSEM_WAITING_BIAS;
 
@@ -171,7 +175,7 @@ __rwsem_do_wake(struct rw_semaphore *sem, int wake_type)
  */
 static struct rw_semaphore __sched *
 rwsem_down_failed_common(struct rw_semaphore *sem,
-			 unsigned int flags, signed long adjustment)
+			 enum rwsem_waiter_type type, signed long adjustment)
 {
 	struct rwsem_waiter waiter;
 	struct task_struct *tsk = current;
@@ -182,12 +186,16 @@ rwsem_down_failed_common(struct rw_semaphore *sem,
 	/* set up my own style of waitqueue */
 	spin_lock_irq(&sem->wait_lock);
 	waiter.task = tsk;
-	waiter.flags = flags;
+	waiter.type = type;
 	get_task_struct(tsk);
 
 	if (list_empty(&sem->wait_list))
 		adjustment += RWSEM_WAITING_BIAS;
-	list_add_tail(&waiter.list, &sem->wait_list);
+
+	if (type == RWSEM_WAITING_FOR_UNFAIR_READ)
+		list_add(&waiter.list, &sem->wait_list);
+	else
+		list_add_tail(&waiter.list, &sem->wait_list);
 
 	/* we're now waiting on the lock, but no longer actively locking */
 	count = rwsem_atomic_update(adjustment, sem);
@@ -229,6 +237,20 @@ rwsem_down_read_failed(struct rw_semaphore *sem)
 					-RWSEM_ACTIVE_READ_BIAS);
 }
 
+#ifdef __HAVE_DOWN_READ_UNFAIR
+
+/*
+ * wait for the read lock to be granted - skip waiting threads
+ */
+asmregparm struct rw_semaphore __sched *
+rwsem_down_read_unfair_failed(struct rw_semaphore *sem)
+{
+	return rwsem_down_failed_common(sem, RWSEM_WAITING_FOR_UNFAIR_READ,
+					-RWSEM_ACTIVE_READ_BIAS);
+}
+
+#endif
+
 /*
  * wait for the write lock to be granted
  */
-- 
1.7.0.1

