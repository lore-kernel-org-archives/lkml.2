Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754438Ab1BBVmS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Feb 2011 16:42:18 -0500
Received: from www.tglx.de ([62.245.132.106]:38914 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754259Ab1BBVll (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Feb 2011 16:41:41 -0500
Message-Id: <20110202212552.299898447@linutronix.de>
User-Agent: quilt/0.48-1
Date: Wed, 02 Feb 2011 21:41:27 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        Uwe Kleine-Koenig <u.kleine-koenig@pengutronix.de>,
        linux-arm-kernel@lists.infradead.org
Subject: [patch 6/8] arm: ns9xxx: Remove private irq flow handler
References: <20110202212258.546660886@linutronix.de>
Content-Disposition: inline;
	filename=arm-ns9xxx-remove-private-irq-handler.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

handle_prio_irq is almost identical with handle_fasteoi_irq. The
subtle differences are

1) The handler checks for IRQ_DISABLED after the device handler has
   been called. In case it's set it masks the interrupt.

2) When the handler sees IRQ_DISABLED on entry it masks the interupt
   in the same way as handle_fastoei_irq, but does not set the
   IRQ_PENDING flag.

3) Instead of gracefully handling a recursive interrupt it crashes the
   kernel.

#1 is just relevant when a device handler calls disable_irq_nosync()
   and it does not matter whether we mask the interrupt right away or
   not. We handle lazy masking for disable_irq anyway, so there is no
   real reason to have this extra mask in place.

#2 will prevent the resend of a pending interrupt, which can result in
   lost interrupts for edge type interrupts. For level type interrupts
   the resend is a noop in the generic code. According to the
   datasheet all interrupts are level type, so marking them as such
   will result in the exact same behaviour as the private
   handle_prio_irq implementation.

#3 is just stupid. Crashing the kernel instead of handling a problem
   gracefully is just wrong. With the current semantics- all handlers
   run with interrupts disabled - this is even more wrong.

Rename ack to eoi, remove the unused mask_ack, switch to
handle_fasteoi_irq and remove the private function.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Uwe Kleine-Koenig <u.kleine-koenig@pengutronix.de>
Cc: linux-arm-kernel@lists.infradead.org
---
 arch/arm/mach-ns9xxx/irq.c |   58 +++------------------------------------------
 1 file changed, 4 insertions(+), 54 deletions(-)

Index: linux-2.6-tip/arch/arm/mach-ns9xxx/irq.c
===================================================================
--- linux-2.6-tip.orig/arch/arm/mach-ns9xxx/irq.c
+++ linux-2.6-tip/arch/arm/mach-ns9xxx/irq.c
@@ -31,17 +31,11 @@ static void ns9xxx_mask_irq(struct irq_d
 	__raw_writel(ic, SYS_IC(prio / 4));
 }
 
-static void ns9xxx_ack_irq(struct irq_data *d)
+static void ns9xxx_eoi_irq(struct irq_data *d)
 {
 	__raw_writel(0, SYS_ISRADDR);
 }
 
-static void ns9xxx_maskack_irq(struct irq_data *d)
-{
-	ns9xxx_mask_irq(d);
-	ns9xxx_ack_irq(d);
-}
-
 static void ns9xxx_unmask_irq(struct irq_data *d)
 {
 	/* XXX: better use cpp symbols */
@@ -52,56 +46,11 @@ static void ns9xxx_unmask_irq(struct irq
 }
 
 static struct irq_chip ns9xxx_chip = {
-	.irq_ack	= ns9xxx_ack_irq,
+	.irq_eoi	= ns9xxx_eoi_irq,
 	.irq_mask	= ns9xxx_mask_irq,
-	.irq_mask_ack	= ns9xxx_maskack_irq,
 	.irq_unmask	= ns9xxx_unmask_irq,
 };
 
-#if 0
-#define handle_irq handle_level_irq
-#else
-static void handle_prio_irq(unsigned int irq, struct irq_desc *desc)
-{
-	struct irqaction *action;
-	irqreturn_t action_ret;
-
-	raw_spin_lock(&desc->lock);
-
-	BUG_ON(desc->status & IRQ_INPROGRESS);
-
-	desc->status &= ~(IRQ_REPLAY | IRQ_WAITING);
-	kstat_incr_irqs_this_cpu(irq, desc);
-
-	action = desc->action;
-	if (unlikely(!action || (desc->status & IRQ_DISABLED)))
-		goto out_mask;
-
-	desc->status |= IRQ_INPROGRESS;
-	raw_spin_unlock(&desc->lock);
-
-	action_ret = handle_IRQ_event(irq, action);
-
-	/* XXX: There is no direct way to access noirqdebug, so check
-	 * unconditionally for spurious irqs...
-	 * Maybe this function should go to kernel/irq/chip.c? */
-	note_interrupt(irq, desc, action_ret);
-
-	raw_spin_lock(&desc->lock);
-	desc->status &= ~IRQ_INPROGRESS;
-
-	if (desc->status & IRQ_DISABLED)
-out_mask:
-		desc->irq_data.chip->irq_mask(&desc->irq_data);
-
-	/* ack unconditionally to unmask lower prio irqs */
-	desc->irq_data.chip->irq_ack(&desc->irq_data);
-
-	raw_spin_unlock(&desc->lock);
-}
-#define handle_irq handle_prio_irq
-#endif
-
 void __init ns9xxx_init_irq(void)
 {
 	int i;
@@ -119,7 +68,8 @@ void __init ns9xxx_init_irq(void)
 
 	for (i = 0; i <= 31; ++i) {
 		set_irq_chip(i, &ns9xxx_chip);
-		set_irq_handler(i, handle_irq);
+		set_irq_handler(i, handle_fasteoi_irq);
 		set_irq_flags(i, IRQF_VALID);
+		irq_set_status_flags(i, IRQ_LEVEL);
 	}
 }


