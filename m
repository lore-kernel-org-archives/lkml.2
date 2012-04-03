Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755778Ab2DCXBn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Apr 2012 19:01:43 -0400
Received: from mail-pz0-f52.google.com ([209.85.210.52]:54680 "EHLO
	mail-pz0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755646Ab2DCXBj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Apr 2012 19:01:39 -0400
From: Grant Likely <grant.likely@secretlab.ca>
To: linux-kernel@vger.kernel.org
Cc: Grant Likely <grant.likely@secretlab.ca>,
        Thomas Gleixner <tglx@linutronix.de>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: [PATCH] irq: Kill pointless irqd_to_hw export
Date: Tue,  3 Apr 2012 08:53:16 -0600
Message-Id: <1333464796-21861-1-git-send-email-grant.likely@secretlab.ca>
X-Mailer: git-send-email 1.7.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It makes no sense to export this trivial function.  Make it a static inline
instead.

Signed-off-by: Grant Likely <grant.likely@secretlab.ca>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
---
 arch/c6x/include/asm/irq.h     |    4 ----
 arch/c6x/kernel/irq.c          |   13 -------------
 arch/powerpc/include/asm/irq.h |    2 --
 arch/powerpc/kernel/irq.c      |    6 ------
 include/linux/irq.h            |    5 +++++
 5 files changed, 5 insertions(+), 25 deletions(-)

diff --git a/arch/c6x/include/asm/irq.h b/arch/c6x/include/asm/irq.h
index f13b78d..ab4577f 100644
--- a/arch/c6x/include/asm/irq.h
+++ b/arch/c6x/include/asm/irq.h
@@ -42,10 +42,6 @@
 /* This number is used when no interrupt has been assigned */
 #define NO_IRQ		0
 
-struct irq_data;
-extern irq_hw_number_t irqd_to_hwirq(struct irq_data *d);
-extern irq_hw_number_t virq_to_hw(unsigned int virq);
-
 extern void __init init_pic_c64xplus(void);
 
 extern void init_IRQ(void);
diff --git a/arch/c6x/kernel/irq.c b/arch/c6x/kernel/irq.c
index 65b8ddf..c90fb5e 100644
--- a/arch/c6x/kernel/irq.c
+++ b/arch/c6x/kernel/irq.c
@@ -130,16 +130,3 @@ int arch_show_interrupts(struct seq_file *p, int prec)
 	seq_printf(p, "%*s: %10lu\n", prec, "Err", irq_err_count);
 	return 0;
 }
-
-irq_hw_number_t irqd_to_hwirq(struct irq_data *d)
-{
-	return d->hwirq;
-}
-EXPORT_SYMBOL_GPL(irqd_to_hwirq);
-
-irq_hw_number_t virq_to_hw(unsigned int virq)
-{
-	struct irq_data *irq_data = irq_get_irq_data(virq);
-	return WARN_ON(!irq_data) ? 0 : irq_data->hwirq;
-}
-EXPORT_SYMBOL_GPL(virq_to_hw);
diff --git a/arch/powerpc/include/asm/irq.h b/arch/powerpc/include/asm/irq.h
index cf417e51..e648af9 100644
--- a/arch/powerpc/include/asm/irq.h
+++ b/arch/powerpc/include/asm/irq.h
@@ -33,8 +33,6 @@ extern atomic_t ppc_n_lost_interrupts;
 /* Same thing, used by the generic IRQ code */
 #define NR_IRQS_LEGACY		NUM_ISA_INTERRUPTS
 
-struct irq_data;
-extern irq_hw_number_t irqd_to_hwirq(struct irq_data *d);
 extern irq_hw_number_t virq_to_hw(unsigned int virq);
 
 /**
diff --git a/arch/powerpc/kernel/irq.c b/arch/powerpc/kernel/irq.c
index 243dbab..5ec1b23 100644
--- a/arch/powerpc/kernel/irq.c
+++ b/arch/powerpc/kernel/irq.c
@@ -560,12 +560,6 @@ void do_softirq(void)
 	local_irq_restore(flags);
 }
 
-irq_hw_number_t irqd_to_hwirq(struct irq_data *d)
-{
-	return d->hwirq;
-}
-EXPORT_SYMBOL_GPL(irqd_to_hwirq);
-
 irq_hw_number_t virq_to_hw(unsigned int virq)
 {
 	struct irq_data *irq_data = irq_get_irq_data(virq);
diff --git a/include/linux/irq.h b/include/linux/irq.h
index bff29c5..7810406 100644
--- a/include/linux/irq.h
+++ b/include/linux/irq.h
@@ -263,6 +263,11 @@ static inline void irqd_clr_chained_irq_inprogress(struct irq_data *d)
 	d->state_use_accessors &= ~IRQD_IRQ_INPROGRESS;
 }
 
+static inline irq_hw_number_t irqd_to_hwirq(struct irq_data *d)
+{
+	return d->hwirq;
+}
+
 /**
  * struct irq_chip - hardware interrupt chip descriptor
  *
-- 
1.7.9.1

