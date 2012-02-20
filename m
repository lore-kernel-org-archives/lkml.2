Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752536Ab2BTRb1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Feb 2012 12:31:27 -0500
Received: from mx1.redhat.com ([209.132.183.28]:54377 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751987Ab2BTRbY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Feb 2012 12:31:24 -0500
Date: Mon, 20 Feb 2012 18:31:15 +0100
From: Alexander Gordeev <agordeev@redhat.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Oleg Nesterov <oleg@redhat.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 2/5] genirq: Get rid of unnecessary irqaction field in
 task_struct
Message-ID: <20120220173115.GB9313@dhcp-26-207.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When a new thread handler is created, an irqaction is passed to it as
data. Not only that irqaction is stored in task_struct by the handler
for later use, but also a structure associated with the kernel thread
keeps this value as long as the thread exists.

This fix kicks irqaction out off task_struct. Yes, I introduce new bit
field. But it allows not only to eliminate the duplicate, but also
shortens size of task_struct.

Reported-by: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Alexander Gordeev <agordeev@redhat.com>
---
 include/linux/sched.h |   10 +++++-----
 kernel/irq/manage.c   |   19 +++++++++++--------
 2 files changed, 16 insertions(+), 13 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index 7d379a6..07f537a 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1319,6 +1319,11 @@ struct task_struct {
 	unsigned sched_reset_on_fork:1;
 	unsigned sched_contributes_to_load:1;
 
+#ifdef CONFIG_GENERIC_HARDIRQS
+	/* IRQ handler threads */
+	unsigned irq_thread:1;
+#endif
+
 	pid_t pid;
 	pid_t tgid;
 
@@ -1427,11 +1432,6 @@ struct task_struct {
  * mempolicy */
 	spinlock_t alloc_lock;
 
-#ifdef CONFIG_GENERIC_HARDIRQS
-	/* IRQ handler threads */
-	struct irqaction *irqaction;
-#endif
-
 	/* Protection of the PI data structures: */
 	raw_spinlock_t pi_lock;
 
diff --git a/kernel/irq/manage.c b/kernel/irq/manage.c
index c0730ad..0fa3ce9 100644
--- a/kernel/irq/manage.c
+++ b/kernel/irq/manage.c
@@ -780,7 +780,7 @@ static int irq_thread(void *data)
 		handler_fn = irq_thread_fn;
 
 	sched_setscheduler(current, SCHED_FIFO, &param);
-	current->irqaction = action;
+	current->irq_thread = 1;
 
 	while (!irq_wait_for_interrupt(action)) {
 
@@ -818,10 +818,10 @@ static int irq_thread(void *data)
 	irq_finalize_oneshot(desc, action, true);
 
 	/*
-	 * Clear irqaction. Otherwise exit_irq_thread() would make
+	 * Clear irq_thread. Otherwise exit_irq_thread() would make
 	 * fuzz about an active irq thread going into nirvana.
 	 */
-	current->irqaction = NULL;
+	current->irq_thread = 0;
 	return 0;
 }
 
@@ -832,27 +832,30 @@ void exit_irq_thread(void)
 {
 	struct task_struct *tsk = current;
 	struct irq_desc *desc;
+	struct irqaction *action;
 
-	if (!tsk->irqaction)
+	if (!tsk->irq_thread)
 		return;
 
+	action = kthread_data(tsk);
+
 	printk(KERN_ERR
 	       "exiting task \"%s\" (%d) is an active IRQ thread (irq %d)\n",
-	       tsk->comm ? tsk->comm : "", tsk->pid, tsk->irqaction->irq);
+	       tsk->comm ? tsk->comm : "", tsk->pid, action->irq);
 
-	desc = irq_to_desc(tsk->irqaction->irq);
+	desc = irq_to_desc(action->irq);
 
 	/*
 	 * Prevent a stale desc->threads_oneshot. Must be called
 	 * before setting the IRQTF_DIED flag.
 	 */
-	irq_finalize_oneshot(desc, tsk->irqaction, true);
+	irq_finalize_oneshot(desc, action, true);
 
 	/*
 	 * Set the THREAD DIED flag to prevent further wakeups of the
 	 * soon to be gone threaded handler.
 	 */
-	set_bit(IRQTF_DIED, &tsk->irqaction->flags);
+	set_bit(IRQTF_DIED, &action->flags);
 }
 
 static void irq_setup_forced_threading(struct irqaction *new)
-- 
1.7.7.6

