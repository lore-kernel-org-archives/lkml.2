Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756201Ab0EQW12 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 May 2010 18:27:28 -0400
Received: from smtp-out.google.com ([216.239.44.51]:12835 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756140Ab0EQW1Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 May 2010 18:27:24 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
	b=xTfIz0hlJBLizi0XJgav8SbCxiKL/7PgAVgL0e43xjBQ2DUpBqBXUXuHZOT7ti1Aq
	SBkcbZ7+UzUMrDRYS57ww==
From: Michel Lespinasse <walken@google.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       David Howells <dhowells@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Mike Waychison <mikew@google.com>,
       Suleiman Souhlal <suleiman@google.com>, Ying Han <yinghan@google.com>,
       Michel Lespinasse <walken@google.com>
Subject: [PATCH 06/10] rwsem: smaller wrappers around rwsem_down_failed_common
Date: Mon, 17 May 2010 15:25:50 -0700
Message-Id: <1274135154-24082-7-git-send-email-walken@google.com>
X-Mailer: git-send-email 1.7.0.1
In-Reply-To: <1274135154-24082-1-git-send-email-walken@google.com>
References: <1274135154-24082-1-git-send-email-walken@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

More code can be pushed from rwsem_down_read_failed and
rwsem_down_write_failed into rwsem_down_failed_common.

Following change adding down_read_unfair infrastructure support also
enjoys having flags available in a register rather than having to
fish it out in the struct rwsem_waiter...

Signed-off-by: Michel Lespinasse <walken@google.com>
---
 lib/rwsem.c |   25 ++++++++++---------------
 1 files changed, 10 insertions(+), 15 deletions(-)

diff --git a/lib/rwsem.c b/lib/rwsem.c
index 89cd8b3..d8764e0 100644
--- a/lib/rwsem.c
+++ b/lib/rwsem.c
@@ -171,8 +171,9 @@ __rwsem_do_wake(struct rw_semaphore *sem, int wake_type)
  */
 static struct rw_semaphore __sched *
 rwsem_down_failed_common(struct rw_semaphore *sem,
-			struct rwsem_waiter *waiter, signed long adjustment)
+			 unsigned int flags, signed long adjustment)
 {
+	struct rwsem_waiter waiter;
 	struct task_struct *tsk = current;
 	signed long count;
 
@@ -180,12 +181,13 @@ rwsem_down_failed_common(struct rw_semaphore *sem,
 
 	/* set up my own style of waitqueue */
 	spin_lock_irq(&sem->wait_lock);
-	waiter->task = tsk;
+	waiter.task = tsk;
+	waiter.flags = flags;
 	get_task_struct(tsk);
 
 	if (list_empty(&sem->wait_list))
 		adjustment += RWSEM_WAITING_BIAS;
-	list_add_tail(&waiter->list, &sem->wait_list);
+	list_add_tail(&waiter.list, &sem->wait_list);
 
 	/* we're now waiting on the lock, but no longer actively locking */
 	count = rwsem_atomic_update(adjustment, sem);
@@ -206,7 +208,7 @@ rwsem_down_failed_common(struct rw_semaphore *sem,
 
 	/* wait to be given the lock */
 	for (;;) {
-		if (!waiter->task)
+		if (!waiter.task)
 			break;
 		schedule();
 		set_task_state(tsk, TASK_UNINTERRUPTIBLE);
@@ -223,11 +225,8 @@ rwsem_down_failed_common(struct rw_semaphore *sem,
 asmregparm struct rw_semaphore __sched *
 rwsem_down_read_failed(struct rw_semaphore *sem)
 {
-	struct rwsem_waiter waiter;
-
-	waiter.flags = RWSEM_WAITING_FOR_READ;
-	rwsem_down_failed_common(sem, &waiter, -RWSEM_ACTIVE_READ_BIAS);
-	return sem;
+	return rwsem_down_failed_common(sem, RWSEM_WAITING_FOR_READ,
+					-RWSEM_ACTIVE_READ_BIAS);
 }
 
 /*
@@ -236,12 +235,8 @@ rwsem_down_read_failed(struct rw_semaphore *sem)
 asmregparm struct rw_semaphore __sched *
 rwsem_down_write_failed(struct rw_semaphore *sem)
 {
-	struct rwsem_waiter waiter;
-
-	waiter.flags = RWSEM_WAITING_FOR_WRITE;
-	rwsem_down_failed_common(sem, &waiter, -RWSEM_ACTIVE_WRITE_BIAS);
-
-	return sem;
+	return rwsem_down_failed_common(sem, RWSEM_WAITING_FOR_WRITE,
+					-RWSEM_ACTIVE_WRITE_BIAS);
 }
 
 /*
-- 
1.7.0.1

