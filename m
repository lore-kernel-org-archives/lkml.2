Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752680Ab2BTRcJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Feb 2012 12:32:09 -0500
Received: from mx1.redhat.com ([209.132.183.28]:36125 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751778Ab2BTRcG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Feb 2012 12:32:06 -0500
Date: Mon, 20 Feb 2012 18:31:57 +0100
From: Alexander Gordeev <agordeev@redhat.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Oleg Nesterov <oleg@redhat.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 5/5] genirq: Mark IRQ thread handlers with irq_thread flag
Message-ID: <20120220173156.GE9313@dhcp-26-207.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently irq_thread flag in task_struct is used to make possible safe
termination of a IRQ threaded handler, especially clearing bits in
desc->threads_oneshot mask. The flag is cleared once the thread stops
servicing interrupts.

This fix converts irq_thread flag into a new per process flag that
indicates that thread is actually a IRQ threaded handler. Besides thread
handlers become distinguishable, this fix resolves few existing issues:

- A bit in desc->threads_oneshot mask is forced off in two exit paths in a
way that is rather not obvious. This fix cleans up the code and turns off
the bit in a single code path.

- Unlike normal IRQ thread handlers, if a forced IRQ thread handler calls
do_exit() it will lead to a kernel panic. By contrast, normal IRQ thread
handlers do not necessarily cause that kernel panic and could terminate.
With this fix any IRQ thread handler will try its best to terminate.

- The fact a threaded handler is servicing interrupts is encoded in
irq_thread flag and in kthread's should_stop flag. This fix eliminates
the duplicate by assigning irq_thread a different semantics and checking
should_stop flag only.

Signed-off-by: Alexander Gordeev <agordeev@redhat.com>
---
 kernel/exit.c       |    2 +-
 kernel/irq/manage.c |   16 +++++-----------
 2 files changed, 6 insertions(+), 12 deletions(-)

diff --git a/kernel/exit.c b/kernel/exit.c
index 752d2c0..0bd1745 100644
--- a/kernel/exit.c
+++ b/kernel/exit.c
@@ -896,7 +896,7 @@ void do_exit(long code)
 
 	WARN_ON(blk_needs_flush_plug(tsk));
 
-	if (unlikely(in_interrupt()))
+	if (unlikely(!tsk->irq_thread && in_interrupt()))
 		panic("Aiee, killing interrupt handler!");
 	if (unlikely(!tsk->pid))
 		panic("Attempted to kill the idle task!");
diff --git a/kernel/irq/manage.c b/kernel/irq/manage.c
index a94466d..d02d4f6 100644
--- a/kernel/irq/manage.c
+++ b/kernel/irq/manage.c
@@ -814,14 +814,6 @@ static int irq_thread(void *data)
 			wake_up(&desc->wait_for_threads);
 	}
 
-	/* Prevent a stale desc->threads_oneshot */
-	irq_finalize_oneshot(desc, action, true);
-
-	/*
-	 * Clear irq_thread. Otherwise exit_irq_thread() would make
-	 * fuzz about an active irq thread going into nirvana.
-	 */
-	current->irq_thread = 0;
 	return 0;
 }
 
@@ -839,9 +831,11 @@ void exit_irq_thread(void)
 
 	action = kthread_data(tsk);
 
-	printk(KERN_ERR
-	       "exiting task \"%s\" (%d) is an active IRQ thread (irq %d)\n",
-	       tsk->comm ? tsk->comm : "", tsk->pid, action->irq);
+	if (!kthread_should_stop())
+		printk(KERN_ERR
+		       "exiting task \"%s\" (%d) "
+		       "is an active IRQ thread (irq %d)\n",
+		       tsk->comm ? tsk->comm : "", tsk->pid, action->irq);
 
 	desc = irq_to_desc(action->irq);
 
-- 
1.7.7.6

