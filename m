Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759603Ab2CUQWn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2012 12:22:43 -0400
Received: from mx1.redhat.com ([209.132.183.28]:34415 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753142Ab2CUQWm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2012 12:22:42 -0400
Date: Wed, 21 Mar 2012 17:22:35 +0100
From: Alexander Gordeev <agordeev@redhat.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org
Subject: [RESEND PATCH 2/3] genirq: Get rid of unneeded force parameter in
 irq_finalize_oneshot()
Message-ID: <20120321162234.GP24806@dhcp-26-207.brq.redhat.com>
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
since PF_EXITING is set for this thread already. So irq_finalize_oneshot()
will drop the thread's bit in threads_oneshot anyway and hence the force
parameter is superfluous.

Signed-off-by: Alexander Gordeev <agordeev@redhat.com>
---
 kernel/irq/manage.c |   10 +++++-----
 1 files changed, 5 insertions(+), 5 deletions(-)

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

