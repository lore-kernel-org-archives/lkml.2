Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031702Ab2CSO7F (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2012 10:59:05 -0400
Received: from mx1.redhat.com ([209.132.183.28]:16438 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030697Ab2CSO7A (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2012 10:59:00 -0400
Date: Mon, 19 Mar 2012 15:58:49 +0100
From: Alexander Gordeev <agordeev@redhat.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 1/3] genirq: Get rid of unneeded force parameter in
 irq_finalize_oneshot()
Message-ID: <20120319145848.GG2147@dhcp-26-207.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The only place irq_finalize_oneshot() is called with force parameter set
is the threaded handler error exit path. But IRQTF_RUNTHREAD is dropped
at this point and irq_wake_thread() is not going to reset it again,
since PF_EXITING is set for this thread already. So we will drop the
thread's bit in threads_oneshot anyway and the force parameter is
superfluous.

Also, the orded or checking PF_EXITING and IRQTF_RUNTHREAD flags in
irq_wake_thread() is important now, so escalate it more visibly in the
source code.
---
 kernel/irq/handle.c |   16 ++++++++++------
 kernel/irq/manage.c |   10 +++++-----
 2 files changed, 15 insertions(+), 11 deletions(-)

diff --git a/kernel/irq/handle.c b/kernel/irq/handle.c
index 6ff84e6..bdb1803 100644
--- a/kernel/irq/handle.c
+++ b/kernel/irq/handle.c
@@ -54,14 +54,18 @@ static void warn_no_thread(unsigned int irq, struct irqaction *action)
 static void irq_wake_thread(struct irq_desc *desc, struct irqaction *action)
 {
 	/*
-	 * Wake up the handler thread for this action. In case the
-	 * thread crashed and was killed we just pretend that we
-	 * handled the interrupt. The hardirq handler has disabled the
-	 * device interrupt, so no irq storm is lurking. If the
+	 * In case the thread crashed and was killed we just pretend that
+	 * we handled the interrupt. The hardirq handler has disabled the
+	 * device interrupt, so no irq storm is lurking.
+	 */
+	if (action->thread->flags & PF_EXITING)
+		return;
+
+	/*
+	 * Wake up the handler thread for this action. If the
 	 * RUNTHREAD bit is already set, nothing to do.
 	 */
-	if ((action->thread->flags & PF_EXITING) ||
-	    test_and_set_bit(IRQTF_RUNTHREAD, &action->thread_flags))
+	if (test_and_set_bit(IRQTF_RUNTHREAD, &action->thread_flags))
 		return;
 
 	/*
diff --git a/kernel/irq/manage.c b/kernel/irq/manage.c
index b0ccd1a..bf606a5 100644
--- a/kernel/irq/manage.c
+++ b/kernel/irq/manage.c
@@ -645,7 +645,7 @@ static int irq_wait_for_interrupt(struct irqaction *action)
  * is marked MASKED.
  */
 static void irq_finalize_oneshot(struct irq_desc *desc,
-				 struct irqaction *action, bool force)
+				 struct irqaction *action)
 {
 	if (!(desc->istate & IRQS_ONESHOT))
 		return;
@@ -679,7 +679,7 @@ again:
 	 * we would clear the threads_oneshot bit of this thread which
 	 * was just set.
 	 */
-	if (!force && test_bit(IRQTF_RUNTHREAD, &action->thread_flags))
+	if (test_bit(IRQTF_RUNTHREAD, &action->thread_flags))
 		goto out_unlock;
 
 	desc->threads_oneshot &= ~action->thread_mask;
@@ -739,7 +739,7 @@ irq_forced_thread_fn(struct irq_desc *desc, struct irqaction *action)
 
 	local_bh_disable();
 	ret = action->thread_fn(action->irq, action->dev_id);
-	irq_finalize_oneshot(desc, action, false);
+	irq_finalize_oneshot(desc, action);
 	local_bh_enable();
 	return ret;
 }
@@ -755,7 +755,7 @@ static irqreturn_t irq_thread_fn(struct irq_desc *desc,
 	irqreturn_t ret;
 
 	ret = action->thread_fn(action->irq, action->dev_id);
-	irq_finalize_oneshot(desc, action, false);
+	irq_finalize_oneshot(desc, action);
 	return ret;
 }
 
@@ -844,7 +844,7 @@ void exit_irq_thread(void)
 		wake_threads_waitq(desc);
 
 	/* Prevent a stale desc->threads_oneshot */
-	irq_finalize_oneshot(desc, action, true);
+	irq_finalize_oneshot(desc, action);
 }
 
 static void irq_setup_forced_threading(struct irqaction *new)
-- 
1.7.7.6

