Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752530Ab1CYNV7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Mar 2011 09:21:59 -0400
Received: from www.linutronix.de ([62.245.132.108]:34602 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752257Ab1CYNV4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Mar 2011 09:21:56 -0400
Message-Id: <20110325132047.748781678@linutronix.de>
User-Agent: quilt/0.48-1
Date: Fri, 25 Mar 2011 13:21:54 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: LAK <linux-arm-kernel@lists.infradead.org>,
        Russell King <linux@arm.linux.org.uk>,
        Lennert Buytenhek <buytenh@wantstofly.org>
Subject: [patch 04/23] arm: Use irq flag setter function
References: <20110325131617.258789658@linutronix.de>
Content-Disposition: inline; filename=arm-use-wrapper.patch
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the proper accessor function instead of fiddling in the status
bits directly.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: linux-arm-kernel@lists.infradead.org
---
 arch/arm/kernel/irq.c |   15 ++++++---------
 1 file changed, 6 insertions(+), 9 deletions(-)

Index: linux-2.6-tip/arch/arm/kernel/irq.c
===================================================================
--- linux-2.6-tip.orig/arch/arm/kernel/irq.c
+++ linux-2.6-tip/arch/arm/kernel/irq.c
@@ -144,24 +144,21 @@ asm_do_IRQ(unsigned int irq, struct pt_r
 
 void set_irq_flags(unsigned int irq, unsigned int iflags)
 {
-	struct irq_desc *desc;
-	unsigned long flags;
+	unsigned long clr = 0, set = IRQ_NOREQUEST | IRQ_NOPROBE | IRQ_NOAUTOEN;
 
 	if (irq >= nr_irqs) {
 		printk(KERN_ERR "Trying to set irq flags for IRQ%d\n", irq);
 		return;
 	}
 
-	desc = irq_to_desc(irq);
-	raw_spin_lock_irqsave(&desc->lock, flags);
-	desc->status |= IRQ_NOREQUEST | IRQ_NOPROBE | IRQ_NOAUTOEN;
 	if (iflags & IRQF_VALID)
-		desc->status &= ~IRQ_NOREQUEST;
+		clr |= IRQ_NOREQUEST;
 	if (iflags & IRQF_PROBE)
-		desc->status &= ~IRQ_NOPROBE;
+		clr |= IRQ_NOPROBE;
 	if (!(iflags & IRQF_NOAUTOEN))
-		desc->status &= ~IRQ_NOAUTOEN;
-	raw_spin_unlock_irqrestore(&desc->lock, flags);
+		clr |= IRQ_NOAUTOEN;
+	/* Order is clear bits in "clr" then set bits in "set" */
+	irq_modify_status(irq, clr, set & ~clr);
 }
 
 void __init init_IRQ(void)


