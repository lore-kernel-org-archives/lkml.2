Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757064Ab1LBQYZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Dec 2011 11:24:25 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:52518 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757006Ab1LBQYY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Dec 2011 11:24:24 -0500
From: Ido Yariv <ido@wizery.com>
To: Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
Cc: Ido Yariv <ido@wizery.com>
Subject: [RFC] genirq: Flush the irq thread on synchronization
Date: Fri,  2 Dec 2011 18:24:12 +0200
Message-Id: <1322843052-7166-1-git-send-email-ido@wizery.com>
X-Mailer: git-send-email 1.7.7.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The current implementation does not always flush the threaded handler
when disabling the irq. In case the irq handler was called, but the
threaded handler hasn't started running yet, the interrupt will be
flagged as pending, and the handler will not run. This implementation
has some issues:

First, if the interrupt is a wake source and flagged as pending, the
system will not be able to suspend.

Second, when quickly disabling and re-enabling the irq, the threaded
handler might continue to run after the irq is re-enabled without the
irq handler being called first. This might be an unexpected behavior.

In addition, it might be counter-intuitive that the threaded handler
will not be called even though the irq handler was called and returned
IRQ_WAKE_THREAD.

Fix this by always waiting for the threaded handler to complete in
synchronize_irq().

Signed-off-by: Ido Yariv <ido@wizery.com>
---
 kernel/irq/handle.c |   10 ++++++++++
 kernel/irq/manage.c |   48 ++++++++++++++++++++++--------------------------
 2 files changed, 32 insertions(+), 26 deletions(-)

diff --git a/kernel/irq/handle.c b/kernel/irq/handle.c
index 470d08c..28f54d1 100644
--- a/kernel/irq/handle.c
+++ b/kernel/irq/handle.c
@@ -110,6 +110,16 @@ static void irq_wake_thread(struct irq_desc *desc, struct irqaction *action)
 	 * threads_oneshot untouched and runs the thread another time.
 	 */
 	desc->threads_oneshot |= action->thread_mask;
+
+	/*
+	 * If threads_active is increased by the thread, synchronize_irq()
+	 * might be called after the thread has been woken up, but before it
+	 * has had a chance to increase threads_active. In this case,
+	 * synchronize_irq() will return even though the thread is still
+	 * running. Thus, increase threads_active here.
+	 */
+	atomic_inc(&desc->threads_active);
+
 	wake_up_process(action->thread);
 }
 
diff --git a/kernel/irq/manage.c b/kernel/irq/manage.c
index 1da999f..896658f 100644
--- a/kernel/irq/manage.c
+++ b/kernel/irq/manage.c
@@ -759,6 +759,16 @@ static irqreturn_t irq_thread_fn(struct irq_desc *desc,
 	return ret;
 }
 
+static void wake_threads_waitq(struct irq_desc *desc)
+{
+	int wake;
+
+	wake = atomic_dec_and_test(&desc->threads_active);
+
+	if (wake && waitqueue_active(&desc->wait_for_threads))
+		wake_up(&desc->wait_for_threads);
+}
+
 /*
  * Interrupt handler thread
  */
@@ -771,7 +781,6 @@ static int irq_thread(void *data)
 	struct irq_desc *desc = irq_to_desc(action->irq);
 	irqreturn_t (*handler_fn)(struct irq_desc *desc,
 			struct irqaction *action);
-	int wake;
 
 	if (force_irqthreads & test_bit(IRQTF_FORCED_THREAD,
 					&action->thread_flags))
@@ -783,37 +792,24 @@ static int irq_thread(void *data)
 	current->irqaction = action;
 
 	while (!irq_wait_for_interrupt(action)) {
+		irqreturn_t action_ret;
 
 		irq_thread_check_affinity(desc, action);
 
-		atomic_inc(&desc->threads_active);
-
-		raw_spin_lock_irq(&desc->lock);
-		if (unlikely(irqd_irq_disabled(&desc->irq_data))) {
-			/*
-			 * CHECKME: We might need a dedicated
-			 * IRQ_THREAD_PENDING flag here, which
-			 * retriggers the thread in check_irq_resend()
-			 * but AFAICT IRQS_PENDING should be fine as it
-			 * retriggers the interrupt itself --- tglx
-			 */
-			desc->istate |= IRQS_PENDING;
-			raw_spin_unlock_irq(&desc->lock);
-		} else {
-			irqreturn_t action_ret;
-
-			raw_spin_unlock_irq(&desc->lock);
-			action_ret = handler_fn(desc, action);
-			if (!noirqdebug)
-				note_interrupt(action->irq, desc, action_ret);
-		}
-
-		wake = atomic_dec_and_test(&desc->threads_active);
+		action_ret = handler_fn(desc, action);
+		if (!noirqdebug)
+			note_interrupt(action->irq, desc, action_ret);
 
-		if (wake && waitqueue_active(&desc->wait_for_threads))
-			wake_up(&desc->wait_for_threads);
+		wake_threads_waitq(desc);
 	}
 
+	/*
+	 * In case the thread was woken up, threads_active is already
+	 * increased. Decrease it and wake up any waiting tasks.
+	 */
+	if (test_and_clear_bit(IRQTF_RUNTHREAD, &action->thread_flags))
+		wake_threads_waitq(desc);
+
 	/* Prevent a stale desc->threads_oneshot */
 	irq_finalize_oneshot(desc, action, true);
 
-- 
1.7.7.3

