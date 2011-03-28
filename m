Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754592Ab1C1ROa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Mar 2011 13:14:30 -0400
Received: from hera.kernel.org ([140.211.167.34]:46948 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752529Ab1C1RO3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Mar 2011 13:14:29 -0400
Date: Mon, 28 Mar 2011 17:13:52 GMT
From: tip-bot for Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        peterz@infradead.org, u.kleine-koenig@pengutronix.de,
        tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        peterz@infradead.org, tglx@linutronix.de,
        u.kleine-koenig@pengutronix.de
In-Reply-To: <20110202212552.299898447@linutronix.de>
References: <20110202212552.299898447@linutronix.de>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:irq/urgent] arm: Ns9xxx: Remove private irq flow handler
Message-ID: <tip-6829310548a76d343205029bb41c14e75bf6a7fb@git.kernel.org>
Git-Commit-ID: 6829310548a76d343205029bb41c14e75bf6a7fb
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Mon, 28 Mar 2011 17:13:53 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  6829310548a76d343205029bb41c14e75bf6a7fb
Gitweb:     http://git.kernel.org/tip/6829310548a76d343205029bb41c14e75bf6a7fb
Author:     Thomas Gleixner <tglx@linutronix.de>
AuthorDate: Wed, 2 Feb 2011 21:41:27 +0000
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Mon, 28 Mar 2011 16:55:11 +0200

arm: Ns9xxx: Remove private irq flow handler

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
Cc: Peter Zijlstra <peterz@infradead.org>
Acked-by: Uwe Kleine-Koenig <u.kleine-koenig@pengutronix.de>
Cc: linux-arm-kernel@lists.infradead.org
LKML-Reference: <20110202212552.299898447@linutronix.de>
---
 arch/arm/mach-ns9xxx/irq.c |   58 +++----------------------------------------
 1 files changed, 4 insertions(+), 54 deletions(-)

diff --git a/arch/arm/mach-ns9xxx/irq.c b/arch/arm/mach-ns9xxx/irq.c
index 389fa5c..bf0fd48 100644
--- a/arch/arm/mach-ns9xxx/irq.c
+++ b/arch/arm/mach-ns9xxx/irq.c
@@ -31,17 +31,11 @@ static void ns9xxx_mask_irq(struct irq_data *d)
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
@@ -52,56 +46,11 @@ static void ns9xxx_unmask_irq(struct irq_data *d)
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
