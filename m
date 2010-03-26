Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754216Ab0CZPJz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Mar 2010 11:09:55 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:49245 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754149Ab0CZPJy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Mar 2010 11:09:54 -0400
Date: Fri, 26 Mar 2010 16:09:43 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] irq fixes
Message-ID: <20100326150943.GA27702@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest irq-fixes-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git irq-fixes-for-linus

 Thanks,

	Ingo

------------------>
Henrik Kretzschmar (1):
      genirq: Move two IRQ functions from .init.text to .text

Thomas Gleixner (2):
      genirq: Prevent oneshot irq thread race
      genirq: Protect access to irq_desc->action in can_request_irq()


 kernel/irq/chip.c   |   35 ++++++++++++++++++++++++-----------
 kernel/irq/manage.c |   22 ++++++++++++++++++++++
 2 files changed, 46 insertions(+), 11 deletions(-)

diff --git a/kernel/irq/chip.c b/kernel/irq/chip.c
index d70394f..3c2d6e7 100644
--- a/kernel/irq/chip.c
+++ b/kernel/irq/chip.c
@@ -359,6 +359,23 @@ static inline void mask_ack_irq(struct irq_desc *desc, int irq)
 		if (desc->chip->ack)
 			desc->chip->ack(irq);
 	}
+	desc->status |= IRQ_MASKED;
+}
+
+static inline void mask_irq(struct irq_desc *desc, int irq)
+{
+	if (desc->chip->mask) {
+		desc->chip->mask(irq);
+		desc->status |= IRQ_MASKED;
+	}
+}
+
+static inline void unmask_irq(struct irq_desc *desc, int irq)
+{
+	if (desc->chip->unmask) {
+		desc->chip->unmask(irq);
+		desc->status &= ~IRQ_MASKED;
+	}
 }
 
 /*
@@ -484,10 +501,8 @@ handle_level_irq(unsigned int irq, struct irq_desc *desc)
 	raw_spin_lock(&desc->lock);
 	desc->status &= ~IRQ_INPROGRESS;
 
-	if (unlikely(desc->status & IRQ_ONESHOT))
-		desc->status |= IRQ_MASKED;
-	else if (!(desc->status & IRQ_DISABLED) && desc->chip->unmask)
-		desc->chip->unmask(irq);
+	if (!(desc->status & (IRQ_DISABLED | IRQ_ONESHOT)))
+		unmask_irq(desc, irq);
 out_unlock:
 	raw_spin_unlock(&desc->lock);
 }
@@ -524,8 +539,7 @@ handle_fasteoi_irq(unsigned int irq, struct irq_desc *desc)
 	action = desc->action;
 	if (unlikely(!action || (desc->status & IRQ_DISABLED))) {
 		desc->status |= IRQ_PENDING;
-		if (desc->chip->mask)
-			desc->chip->mask(irq);
+		mask_irq(desc, irq);
 		goto out;
 	}
 
@@ -593,7 +607,7 @@ handle_edge_irq(unsigned int irq, struct irq_desc *desc)
 		irqreturn_t action_ret;
 
 		if (unlikely(!action)) {
-			desc->chip->mask(irq);
+			mask_irq(desc, irq);
 			goto out_unlock;
 		}
 
@@ -605,8 +619,7 @@ handle_edge_irq(unsigned int irq, struct irq_desc *desc)
 		if (unlikely((desc->status &
 			       (IRQ_PENDING | IRQ_MASKED | IRQ_DISABLED)) ==
 			      (IRQ_PENDING | IRQ_MASKED))) {
-			desc->chip->unmask(irq);
-			desc->status &= ~IRQ_MASKED;
+			unmask_irq(desc, irq);
 		}
 
 		desc->status &= ~IRQ_PENDING;
@@ -716,7 +729,7 @@ set_irq_chip_and_handler_name(unsigned int irq, struct irq_chip *chip,
 	__set_irq_handler(irq, handle, 0, name);
 }
 
-void __init set_irq_noprobe(unsigned int irq)
+void set_irq_noprobe(unsigned int irq)
 {
 	struct irq_desc *desc = irq_to_desc(irq);
 	unsigned long flags;
@@ -731,7 +744,7 @@ void __init set_irq_noprobe(unsigned int irq)
 	raw_spin_unlock_irqrestore(&desc->lock, flags);
 }
 
-void __init set_irq_probe(unsigned int irq)
+void set_irq_probe(unsigned int irq)
 {
 	struct irq_desc *desc = irq_to_desc(irq);
 	unsigned long flags;
diff --git a/kernel/irq/manage.c b/kernel/irq/manage.c
index eb6078c..398fda1 100644
--- a/kernel/irq/manage.c
+++ b/kernel/irq/manage.c
@@ -382,6 +382,7 @@ int can_request_irq(unsigned int irq, unsigned long irqflags)
 {
 	struct irq_desc *desc = irq_to_desc(irq);
 	struct irqaction *action;
+	unsigned long flags;
 
 	if (!desc)
 		return 0;
@@ -389,11 +390,14 @@ int can_request_irq(unsigned int irq, unsigned long irqflags)
 	if (desc->status & IRQ_NOREQUEST)
 		return 0;
 
+	raw_spin_lock_irqsave(&desc->lock, flags);
 	action = desc->action;
 	if (action)
 		if (irqflags & action->flags & IRQF_SHARED)
 			action = NULL;
 
+	raw_spin_unlock_irqrestore(&desc->lock, flags);
+
 	return !action;
 }
 
@@ -483,8 +487,26 @@ static int irq_wait_for_interrupt(struct irqaction *action)
  */
 static void irq_finalize_oneshot(unsigned int irq, struct irq_desc *desc)
 {
+again:
 	chip_bus_lock(irq, desc);
 	raw_spin_lock_irq(&desc->lock);
+
+	/*
+	 * Implausible though it may be we need to protect us against
+	 * the following scenario:
+	 *
+	 * The thread is faster done than the hard interrupt handler
+	 * on the other CPU. If we unmask the irq line then the
+	 * interrupt can come in again and masks the line, leaves due
+	 * to IRQ_INPROGRESS and the irq line is masked forever.
+	 */
+	if (unlikely(desc->status & IRQ_INPROGRESS)) {
+		raw_spin_unlock_irq(&desc->lock);
+		chip_bus_sync_unlock(irq, desc);
+		cpu_relax();
+		goto again;
+	}
+
 	if (!(desc->status & IRQ_DISABLED) && (desc->status & IRQ_MASKED)) {
 		desc->status &= ~IRQ_MASKED;
 		desc->chip->unmask(irq);
