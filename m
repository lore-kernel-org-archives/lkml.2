Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754151Ab0ELDWM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 May 2010 23:22:12 -0400
Received: from smtp-out.google.com ([74.125.121.35]:52250 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752200Ab0ELDWG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 May 2010 23:22:06 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
	b=b1RJ84HS/3ovWIwqHi7Thf9eL4aPtT83FUO/H7nQU6c1pJqudOrfg0JH5SweiXDff
	egjLC2YTkO5Um1Nr22QAg==
From: Michel Lespinasse <walken@google.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       David Howells <dhowells@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Mike Waychison <mikew@google.com>,
       Suleiman Souhlal <suleiman@google.com>, Ying Han <yinghan@google.com>,
       Michel Lespinasse <walken@google.com>
Subject: [PATCH 08/12] rwsem: smaller wrappers around rwsem_down_failed_common
Date: Tue, 11 May 2010 20:20:58 -0700
Message-Id: <1273634462-2672-9-git-send-email-walken@google.com>
X-Mailer: git-send-email 1.7.0.1
In-Reply-To: <1273634462-2672-1-git-send-email-walken@google.com>
References: <1273634462-2672-1-git-send-email-walken@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

More code can be pushed from rwsem_down_read_failed and
rwsem_down_write_failed into rwsem_down_failed_common.

Following change also enjoys having flags available in a register rather
than having to fish it out in the struct rwsem_waiter...

Signed-off-by: Michel Lespinasse <walken@google.com>
---
 lib/rwsem.c |   23 +++++++++--------------
 1 files changed, 9 insertions(+), 14 deletions(-)

diff --git a/lib/rwsem.c b/lib/rwsem.c
index 84bbc55..1702524 100644
--- a/lib/rwsem.c
+++ b/lib/rwsem.c
@@ -158,8 +158,9 @@ __rwsem_do_wake(struct rw_semaphore *sem, int wake_type)
  */
 static struct rw_semaphore __sched *
 rwsem_down_failed_common(struct rw_semaphore *sem,
-			struct rwsem_waiter *waiter, signed long adjustment)
+			 unsigned int flags, signed long adjustment)
 {
+	struct rwsem_waiter waiter;
 	struct task_struct *tsk = current;
 	signed long count;
 
@@ -167,7 +168,8 @@ rwsem_down_failed_common(struct rw_semaphore *sem,
 
 	/* set up my own style of waitqueue */
 	spin_lock_irq(&sem->wait_lock);
-	waiter->task = tsk;
+	waiter.task = tsk;
+	waiter.flags = flags;
 	get_task_struct(tsk);
 
 	if (list_empty(&sem->wait_list))
@@ -192,7 +194,7 @@ rwsem_down_failed_common(struct rw_semaphore *sem,
 
 	/* wait to be given the lock */
 	for (;;) {
-		if (!waiter->task)
+		if (!waiter.task)
 			break;
 		schedule();
 		set_task_state(tsk, TASK_UNINTERRUPTIBLE);
@@ -209,11 +211,8 @@ rwsem_down_failed_common(struct rw_semaphore *sem,
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
@@ -222,12 +221,8 @@ rwsem_down_read_failed(struct rw_semaphore *sem)
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

