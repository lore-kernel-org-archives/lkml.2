Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752659Ab2BTRbx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Feb 2012 12:31:53 -0500
Received: from mx1.redhat.com ([209.132.183.28]:17519 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751987Ab2BTRbv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Feb 2012 12:31:51 -0500
Date: Mon, 20 Feb 2012 18:31:47 +0100
From: Alexander Gordeev <agordeev@redhat.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Oleg Nesterov <oleg@redhat.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 4/5] genirq: Get rid of unnecessary IRQTF_DIED flag
Message-ID: <20120220173146.GD9313@dhcp-26-207.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently IRQTF_DIED flag is set when a IRQ thread handler calls do_exit()
But also PF_EXITING per process flag gets set when a thread exits. This
fix eliminates the duplicate by using PF_EXITING flag.

Also, there is a race condition in exit_irq_thread(). In case a thread's
bit is cleared in desc->threads_oneshot (and the IRQ line gets unmasked),
but before IRQTF_DIED flag is set, a new interrupt might come in and set
just cleared bit again, this time forever. This fix throws IRQTF_DIED flag
away, eliminating the race as a result.

Reported-by: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Alexander Gordeev <agordeev@redhat.com>
---
 kernel/exit.c          |    4 ++--
 kernel/irq/handle.c    |    4 ++--
 kernel/irq/internals.h |    2 --
 kernel/irq/manage.c    |   11 +----------
 4 files changed, 5 insertions(+), 16 deletions(-)

diff --git a/kernel/exit.c b/kernel/exit.c
index 4b4042f..752d2c0 100644
--- a/kernel/exit.c
+++ b/kernel/exit.c
@@ -935,8 +935,6 @@ void do_exit(long code)
 		schedule();
 	}
 
-	exit_irq_thread();
-
 	exit_signals(tsk);  /* sets PF_EXITING */
 	/*
 	 * tsk->flags are checked in the futex code to protect against
@@ -945,6 +943,8 @@ void do_exit(long code)
 	smp_mb();
 	raw_spin_unlock_wait(&tsk->pi_lock);
 
+	exit_irq_thread();
+
 	if (unlikely(in_atomic()))
 		printk(KERN_INFO "note: %s[%d] exited with preempt_count %d\n",
 				current->comm, task_pid_nr(current),
diff --git a/kernel/irq/handle.c b/kernel/irq/handle.c
index 470d08c..42a32ec 100644
--- a/kernel/irq/handle.c
+++ b/kernel/irq/handle.c
@@ -60,8 +60,8 @@ static void irq_wake_thread(struct irq_desc *desc, struct irqaction *action)
 	 * device interrupt, so no irq storm is lurking. If the
 	 * RUNTHREAD bit is already set, nothing to do.
 	 */
-	if (test_bit(IRQTF_DIED, &action->thread_flags) ||
-	    test_and_set_bit(IRQTF_RUNTHREAD, &action->thread_flags))
+	if (test_and_set_bit(IRQTF_RUNTHREAD, &action->thread_flags) ||
+	    (action->thread->flags & PF_EXITING))
 		return;
 
 	/*
diff --git a/kernel/irq/internals.h b/kernel/irq/internals.h
index b795231..5c233e0 100644
--- a/kernel/irq/internals.h
+++ b/kernel/irq/internals.h
@@ -20,14 +20,12 @@ extern bool noirqdebug;
 /*
  * Bits used by threaded handlers:
  * IRQTF_RUNTHREAD - signals that the interrupt handler thread should run
- * IRQTF_DIED      - handler thread died
  * IRQTF_WARNED    - warning "IRQ_WAKE_THREAD w/o thread_fn" has been printed
  * IRQTF_AFFINITY  - irq thread is requested to adjust affinity
  * IRQTF_FORCED_THREAD  - irq action is force threaded
  */
 enum {
 	IRQTF_RUNTHREAD,
-	IRQTF_DIED,
 	IRQTF_WARNED,
 	IRQTF_AFFINITY,
 	IRQTF_FORCED_THREAD,
diff --git a/kernel/irq/manage.c b/kernel/irq/manage.c
index 3feab4a..a94466d 100644
--- a/kernel/irq/manage.c
+++ b/kernel/irq/manage.c
@@ -845,17 +845,8 @@ void exit_irq_thread(void)
 
 	desc = irq_to_desc(action->irq);
 
-	/*
-	 * Prevent a stale desc->threads_oneshot. Must be called
-	 * before setting the IRQTF_DIED flag.
-	 */
+	/* Prevent a stale desc->threads_oneshot */
 	irq_finalize_oneshot(desc, action, true);
-
-	/*
-	 * Set the THREAD DIED flag to prevent further wakeups of the
-	 * soon to be gone threaded handler.
-	 */
-	set_bit(IRQTF_DIED, &action->flags);
 }
 
 static void irq_setup_forced_threading(struct irqaction *new)
-- 
1.7.7.6

