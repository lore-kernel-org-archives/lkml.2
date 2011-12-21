Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752314Ab1LULT2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Dec 2011 06:19:28 -0500
Received: from casper.infradead.org ([85.118.1.10]:43587 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751629Ab1LULSX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Dec 2011 06:18:23 -0500
Message-Id: <20111221111143.568920970@chello.nl>
User-Agent: quilt/0.48-1
Date: Wed, 21 Dec 2011 11:57:44 +0100
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Linus Torvalds <torvalds@linux-foundation.org>, "Ted Ts'o" <tytso@mit.edu>,
        Greg KH <greg@kroah.com>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>, akpm@linux-foundation.org
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [RFC][PATCH 5/7] semaphore: Pull wakeup out from under sem->lock
References: <20111221105739.798864333@chello.nl>
Content-Disposition: inline; filename=sem-vs-printk.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rather horrid patch this, surely there's a better way..

rcuc/1/13 is trying to acquire lock:
 ((console_sem).lock){-.-...}, at:
but task is already holding lock:
 (&rt_rq->rt_runtime_lock){-.....}, at:
which lock already depends on the new lock.

the existing dependency chain (in reverse order) is:

 -> #3 (&rt_rq->rt_runtime_lock){-.....}:
 -> #2 (&rq->lock){-.-.-.}:
 -> #1 (&p->pi_lock){-.-.-.}:
 -> #0 ((console_sem).lock){-.-...}:

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 kernel/semaphore.c |   46 +++++++++++++++++++++++++---------------------
 1 file changed, 25 insertions(+), 21 deletions(-)
--- a/kernel/semaphore.c
+++ b/kernel/semaphore.c
@@ -168,6 +168,14 @@ int down_timeout(struct semaphore *sem, 
 }
 EXPORT_SYMBOL(down_timeout);
 
+/* Functions for the contended case */
+
+struct semaphore_waiter {
+	struct list_head list;
+	struct task_struct *task;
+	int up;
+};
+
 /**
  * up - release the semaphore
  * @sem: the semaphore to release
@@ -177,32 +185,36 @@ EXPORT_SYMBOL(down_timeout);
  */
 void up(struct semaphore *sem)
 {
+	struct semaphore_waiter *waiter;
+	struct task_struct *task;
 	unsigned long flags;
 
 	raw_spin_lock_irqsave(&sem->lock, flags);
-	if (likely(list_empty(&sem->wait_list)))
+	if (likely(list_empty(&sem->wait_list))) {
 		sem->count++;
-	else
-		__up(sem);
+		raw_spin_unlock_irqrestore(&sem->lock, flags);
+		return;
+	}
+
+	waiter = list_first_entry(&sem->wait_list, struct semaphore_waiter, list);
+	task = waiter->task;
+	list_del(&waiter->list);
+	waiter->up = 1;
+	get_task_struct(task);
 	raw_spin_unlock_irqrestore(&sem->lock, flags);
+
+	wake_up_process(task);
+	put_task_struct(task);
 }
 EXPORT_SYMBOL(up);
 
-/* Functions for the contended case */
-
-struct semaphore_waiter {
-	struct list_head list;
-	struct task_struct *task;
-	int up;
-};
-
 /*
  * Because this function is inlined, the 'state' parameter will be
  * constant, and thus optimised away by the compiler.  Likewise the
  * 'timeout' parameter for the cases without timeouts.
  */
-static inline int __sched __down_common(struct semaphore *sem, long state,
-								long timeout)
+static inline
+int __sched __down_common(struct semaphore *sem, long state, long timeout)
 {
 	struct task_struct *task = current;
 	struct semaphore_waiter waiter;
@@ -253,11 +265,3 @@ static noinline int __sched __down_timeo
 	return __down_common(sem, TASK_UNINTERRUPTIBLE, jiffies);
 }
 
-static noinline void __sched __up(struct semaphore *sem)
-{
-	struct semaphore_waiter *waiter = list_first_entry(&sem->wait_list,
-						struct semaphore_waiter, list);
-	list_del(&waiter->list);
-	waiter->up = 1;
-	wake_up_process(waiter->task);
-}


