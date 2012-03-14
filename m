Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753362Ab2CNLIq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2012 07:08:46 -0400
Received: from terminus.zytor.com ([198.137.202.10]:46083 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752002Ab2CNLIn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2012 07:08:43 -0400
Date: Wed, 14 Mar 2012 04:07:30 -0700
From: tip-bot for Ido Yariv <ido@wizery.com>
Message-ID: <tip-7140ea1980f2fae9c7aaeac5f6b35317e1389ee6@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        ido@wizery.com, tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, ido@wizery.com
In-Reply-To: <1322843052-7166-1-git-send-email-ido@wizery.com>
References: <1322843052-7166-1-git-send-email-ido@wizery.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:irq/core] genirq: Flush the irq thread on synchronization
Git-Commit-ID: 7140ea1980f2fae9c7aaeac5f6b35317e1389ee6
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Wed, 14 Mar 2012 04:07:36 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  7140ea1980f2fae9c7aaeac5f6b35317e1389ee6
Gitweb:     http://git.kernel.org/tip/7140ea1980f2fae9c7aaeac5f6b35317e1389ee6
Author:     Ido Yariv <ido@wizery.com>
AuthorDate: Fri, 2 Dec 2011 18:24:12 +0200
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Wed, 14 Mar 2012 11:56:20 +0100

genirq: Flush the irq thread on synchronization

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

[ tglx: Massaged comments, added WARN_ONs and the missing
  	IRQTF_RUNTHREAD check in exit_irq_thread() ]

Signed-off-by: Ido Yariv <ido@wizery.com>
Link: http://lkml.kernel.org/r/1322843052-7166-1-git-send-email-ido@wizery.com
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 kernel/irq/handle.c |   12 ++++++++++
 kernel/irq/manage.c |   60 +++++++++++++++++++++++++++-----------------------
 2 files changed, 44 insertions(+), 28 deletions(-)

diff --git a/kernel/irq/handle.c b/kernel/irq/handle.c
index 500aaf6..6ff84e6 100644
--- a/kernel/irq/handle.c
+++ b/kernel/irq/handle.c
@@ -110,6 +110,18 @@ static void irq_wake_thread(struct irq_desc *desc, struct irqaction *action)
 	 * threads_oneshot untouched and runs the thread another time.
 	 */
 	desc->threads_oneshot |= action->thread_mask;
+
+	/*
+	 * We increment the threads_active counter in case we wake up
+	 * the irq thread. The irq thread decrements the counter when
+	 * it returns from the handler or in the exit path and wakes
+	 * up waiters which are stuck in synchronize_irq() when the
+	 * active count becomes zero. synchronize_irq() is serialized
+	 * against this code (hard irq handler) via IRQS_INPROGRESS
+	 * like the finalize_oneshot() code. See comment above.
+	 */
+	atomic_inc(&desc->threads_active);
+
 	wake_up_process(action->thread);
 }
 
diff --git a/kernel/irq/manage.c b/kernel/irq/manage.c
index 1786cf7..453feed 100644
--- a/kernel/irq/manage.c
+++ b/kernel/irq/manage.c
@@ -759,6 +759,13 @@ static irqreturn_t irq_thread_fn(struct irq_desc *desc,
 	return ret;
 }
 
+static void wake_threads_waitq(struct irq_desc *desc)
+{
+	if (atomic_dec_and_test(&desc->threads_active) &&
+	    waitqueue_active(&desc->wait_for_threads))
+		wake_up(&desc->wait_for_threads);
+}
+
 /*
  * Interrupt handler thread
  */
@@ -771,7 +778,6 @@ static int irq_thread(void *data)
 	struct irq_desc *desc = irq_to_desc(action->irq);
 	irqreturn_t (*handler_fn)(struct irq_desc *desc,
 			struct irqaction *action);
-	int wake;
 
 	if (force_irqthreads && test_bit(IRQTF_FORCED_THREAD,
 					&action->thread_flags))
@@ -783,39 +789,30 @@ static int irq_thread(void *data)
 	current->irq_thread = 1;
 
 	while (!irq_wait_for_interrupt(action)) {
+		irqreturn_t action_ret;
 
 		irq_thread_check_affinity(desc, action);
 
-		atomic_inc(&desc->threads_active);
+		action_ret = handler_fn(desc, action);
+		if (!noirqdebug)
+			note_interrupt(action->irq, desc, action_ret);
 
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
-
-		if (wake && waitqueue_active(&desc->wait_for_threads))
-			wake_up(&desc->wait_for_threads);
+		wake_threads_waitq(desc);
 	}
 
-	/* Prevent a stale desc->threads_oneshot */
-	irq_finalize_oneshot(desc, action, true);
+	/*
+	 * This is the regular exit path. __free_irq() is stopping the
+	 * thread via kthread_stop() after calling
+	 * synchronize_irq(). So neither IRQTF_RUNTHREAD nor the
+	 * oneshot mask bit should be set.
+	 *
+	 * Verify that this is true.
+	 */
+	if (WARN_ON(test_and_clear_bit(IRQTF_RUNTHREAD, &action->thread_flags)))
+		wake_threads_waitq(desc);
+
+	if (WARN_ON(desc->threads_oneshot & action->thread_mask))
+		irq_finalize_oneshot(desc, action, true);
 
 	/*
 	 * Clear irq_thread. Otherwise exit_irq_thread() would make
@@ -845,6 +842,13 @@ void exit_irq_thread(void)
 
 	desc = irq_to_desc(action->irq);
 
+	/*
+	 * If IRQTF_RUNTHREAD is set, we need to decrement
+	 * desc->threads_active and wake possible waiters.
+	 */
+	if (test_and_clear_bit(IRQTF_RUNTHREAD, &action->thread_flags))
+		wake_threads_waitq(desc);
+
 	/* Prevent a stale desc->threads_oneshot */
 	irq_finalize_oneshot(desc, action, true);
 }
