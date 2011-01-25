Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752650Ab1AYIEF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jan 2011 03:04:05 -0500
Received: from mail-yi0-f46.google.com ([209.85.218.46]:64757 "EHLO
	mail-yi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751499Ab1AYIEC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jan 2011 03:04:02 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=HwnFyCNk/GOH5mPL7J6HvXBZSaDE32Sv6rL6CLOdDnO2hvdnqsFzvXVQmZlnZqZKT+
         zu82ggSN4dLUoQibL52lOw8fmkm1mij/tB1zJHFifKLnbacPZk1DZ+N0Hb0Z3f1mE1pA
         PGgc/XPZ+W01gaOt93w7c57G863YaqZUqj3lE=
From: "Anoop P.A" <anoop.pa@gmail.com>
To: ralf@linux-mips.org, linux-mips@linux-mips.org,
        linux-kernel@vger.kernel.org, dhowells@redhat.com
Cc: Anoop P A <anoop.pa@gmail.com>
Subject: [PATCH 2/6] Vectored interrupt support.
Date: Tue, 25 Jan 2011 13:50:10 +0530
Message-Id: <1295943610-20099-1-git-send-email-anoop.pa@gmail.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Anoop P A <anoop.pa@gmail.com>

This patch will add vectored interrupt setups required for MIPS MT modes.
irq_cic has been restructured and moved per irq handler to different file.
irq_cic has been re wrote to support mips MT modes ( VSMP / SMTC )

Signed-off-by: Anoop P A <anoop.pa@gmail.com>
---
 arch/mips/pmc-sierra/msp71xx/Makefile      |    2 +-
 arch/mips/pmc-sierra/msp71xx/msp_irq.c     |   56 ++++++-
 arch/mips/pmc-sierra/msp71xx/msp_irq_cic.c |  248 +++++++++++++++++++---------
 arch/mips/pmc-sierra/msp71xx/msp_irq_per.c |  179 ++++++++++++++++++++
 4 files changed, 397 insertions(+), 88 deletions(-)
 create mode 100644 arch/mips/pmc-sierra/msp71xx/msp_irq_per.c

diff --git a/arch/mips/pmc-sierra/msp71xx/Makefile b/arch/mips/pmc-sierra/msp71xx/Makefile
index e107f79..b25f354 100644
--- a/arch/mips/pmc-sierra/msp71xx/Makefile
+++ b/arch/mips/pmc-sierra/msp71xx/Makefile
@@ -6,7 +6,7 @@ obj-y += msp_prom.o msp_setup.o msp_irq.o \
 obj-$(CONFIG_HAVE_GPIO_LIB) += gpio.o gpio_extended.o
 obj-$(CONFIG_PMC_MSP7120_GW) += msp_hwbutton.o
 obj-$(CONFIG_IRQ_MSP_SLP) += msp_irq_slp.o
-obj-$(CONFIG_IRQ_MSP_CIC) += msp_irq_cic.o
+obj-$(CONFIG_IRQ_MSP_CIC) += msp_irq_cic.o msp_irq_per.o
 obj-$(CONFIG_PCI) += msp_pci.o
 obj-$(CONFIG_MSPETH) += msp_eth.o
 obj-$(CONFIG_USB_MSP71XX) += msp_usb.o
diff --git a/arch/mips/pmc-sierra/msp71xx/msp_irq.c b/arch/mips/pmc-sierra/msp71xx/msp_irq.c
index 734d598..4531c4a 100644
--- a/arch/mips/pmc-sierra/msp71xx/msp_irq.c
+++ b/arch/mips/pmc-sierra/msp71xx/msp_irq.c
@@ -19,8 +19,6 @@
 
 #include <msp_int.h>
 
-extern void msp_int_handle(void);
-
 /* SLP bases systems */
 extern void msp_slp_irq_init(void);
 extern void msp_slp_irq_dispatch(void);
@@ -29,6 +27,18 @@ extern void msp_slp_irq_dispatch(void);
 extern void msp_cic_irq_init(void);
 extern void msp_cic_irq_dispatch(void);
 
+/* VSMP support init */
+extern void msp_vsmp_int_init(void);
+
+/* vectored interrupt implementation */
+
+/* SW0/1 interrupts are used for SMP/SMTC */
+static inline void mac0_int_dispatch(void) { do_IRQ(MSP_INT_MAC0); }
+static inline void mac1_int_dispatch(void) { do_IRQ(MSP_INT_MAC1); }
+static inline void mac2_int_dispatch(void) { do_IRQ(MSP_INT_SAR); }
+static inline void usb_int_dispatch(void)  { do_IRQ(MSP_INT_USB);  }
+static inline void sec_int_dispatch(void)  { do_IRQ(MSP_INT_SEC);  }
+
 /*
  * The PMC-Sierra MSP interrupts are arranged in a 3 level cascaded
  * hierarchical system.  The first level are the direct MIPS interrupts
@@ -96,29 +106,57 @@ asmlinkage void plat_irq_dispatch(struct pt_regs *regs)
 		do_IRQ(MSP_INT_SW1);
 }
 
-static struct irqaction cascade_msp = {
+static struct irqaction cic_cascade_msp = {
 	.handler = no_action,
-	.name	 = "MSP cascade"
+	.name	 = "MSP CIC cascade"
 };
 
+static struct irqaction per_cascade_msp = {
+	.handler = no_action,
+	.name	 = "MSP PER cascade"
+};
 
 void __init arch_init_irq(void)
 {
+	/* assume we'll be using vectored interrupt mode except in UP mode*/
+#ifdef CONFIG_MIPS_MT
+	BUG_ON(!cpu_has_vint);
+#endif
 	/* initialize the 1st-level CPU based interrupt controller */
 	mips_cpu_irq_init();
 
 #ifdef CONFIG_IRQ_MSP_CIC
 	msp_cic_irq_init();
-
+#ifdef CONFIG_MIPS_MT
+	set_vi_handler(MSP_INT_CIC, msp_cic_irq_dispatch);
+	set_vi_handler(MSP_INT_MAC0, mac0_int_dispatch);
+	set_vi_handler(MSP_INT_MAC1, mac1_int_dispatch);
+	set_vi_handler(MSP_INT_SAR, mac2_int_dispatch);
+	set_vi_handler(MSP_INT_USB, usb_int_dispatch);
+	set_vi_handler(MSP_INT_SEC, sec_int_dispatch);
+#ifdef CONFIG_MIPS_MT_SMP
+	msp_vsmp_int_init();
+#elif defined CONFIG_MIPS_MT_SMTC
+	/*Set hwmask for all platform devices */
+	irq_hwmask[MSP_INT_MAC0] = C_IRQ0;
+	irq_hwmask[MSP_INT_MAC1] = C_IRQ1;
+	irq_hwmask[MSP_INT_USB] = C_IRQ2;
+	irq_hwmask[MSP_INT_SAR] = C_IRQ3;
+	irq_hwmask[MSP_INT_SEC] = C_IRQ5;
+
+#endif	/* CONFIG_MIPS_MT_SMP */
+#endif	/* CONFIG_MIPS_MT */
 	/* setup the cascaded interrupts */
-	setup_irq(MSP_INT_CIC, &cascade_msp);
-	setup_irq(MSP_INT_PER, &cascade_msp);
+	setup_irq(MSP_INT_CIC, &cic_cascade_msp);
+	setup_irq(MSP_INT_PER, &per_cascade_msp);
+
 #else
 	/* setup the 2nd-level SLP register based interrupt controller */
+	/* VSMP /SMTC support support is not enabled for SLP */
 	msp_slp_irq_init();
 
 	/* setup the cascaded SLP/PER interrupts */
-	setup_irq(MSP_INT_SLP, &cascade_msp);
-	setup_irq(MSP_INT_PER, &cascade_msp);
+	setup_irq(MSP_INT_SLP, &cic_cascade_msp);
+	setup_irq(MSP_INT_PER, &per_cascade_msp);
 #endif
 }
diff --git a/arch/mips/pmc-sierra/msp71xx/msp_irq_cic.c b/arch/mips/pmc-sierra/msp71xx/msp_irq_cic.c
index 07e71ff..e64458a 100644
--- a/arch/mips/pmc-sierra/msp71xx/msp_irq_cic.c
+++ b/arch/mips/pmc-sierra/msp71xx/msp_irq_cic.c
@@ -1,8 +1,7 @@
 /*
- * This file define the irq handler for MSP SLM subsystem interrupts.
+ * Copyright 2010 PMC-Sierra, Inc, derived from irq_cpu.c
  *
- * Copyright 2005-2007 PMC-Sierra, Inc, derived from irq_cpu.c
- * Author: Andrew Hughes, Andrew_Hughes@pmc-sierra.com
+ * This file define the irq handler for MSP CIC subsystem interrupts.
  *
  * This program is free software; you can redistribute  it and/or modify it
  * under  the terms of  the GNU General  Public License as published by the
@@ -16,119 +15,212 @@
 #include <linux/bitops.h>
 #include <linux/irq.h>
 
+#include <asm/mipsregs.h>
 #include <asm/system.h>
 
 #include <msp_cic_int.h>
 #include <msp_regs.h>
 
 /*
- * NOTE: We are only enabling support for VPE0 right now.
+ * External API
  */
+extern void msp_per_irq_init(void);
+extern void msp_per_irq_dispatch(void);
 
-static inline void unmask_msp_cic_irq(unsigned int irq)
+
+/*
+ * Convenience Macro.  Should be somewhere generic.
+ */
+#define get_current_vpe()   \
+	((read_c0_tcbind() >> TCBIND_CURVPE_SHIFT) & TCBIND_CURVPE)
+
+#ifdef CONFIG_SMP
+
+#define LOCK_VPE(flags, mtflags) \
+do {				\
+	local_irq_save(flags);	\
+	mtflags = dmt();	\
+} while (0)
+
+#define UNLOCK_VPE(flags, mtflags) \
+do {				\
+	emt(mtflags);		\
+	local_irq_restore(flags);\
+} while (0)
+
+#define LOCK_CORE(flags, mtflags) \
+do {				\
+	local_irq_save(flags);	\
+	mtflags = dvpe();	\
+} while (0)
+
+#define UNLOCK_CORE(flags, mtflags)		\
+do {				\
+	evpe(mtflags);		\
+	local_irq_restore(flags);\
+} while (0)
+
+#else
+
+#define LOCK_VPE(flags, mtflags)
+#define UNLOCK_VPE(flags, mtflags)
+#endif
+
+/* ensure writes to cic are completed */
+static inline void cic_wmb(void)
 {
+	const volatile void __iomem *cic_mem = CIC_VPE0_MSK_REG;
+	volatile u32 dummy_read;
 
-	/* check for PER interrupt range */
-	if (irq < MSP_PER_INTBASE)
-		*CIC_VPE0_MSK_REG |= (1 << (irq - MSP_CIC_INTBASE));
-	else
-		*PER_INT_MSK_REG |= (1 << (irq - MSP_PER_INTBASE));
+	wmb();
+	dummy_read = __raw_readl(cic_mem);
+	dummy_read++;
 }
 
-static inline void mask_msp_cic_irq(unsigned int irq)
+static inline void unmask_cic_irq(unsigned int irq)
 {
-	/* check for PER interrupt range */
-	if (irq < MSP_PER_INTBASE)
-		*CIC_VPE0_MSK_REG &= ~(1 << (irq - MSP_CIC_INTBASE));
-	else
-		*PER_INT_MSK_REG &= ~(1 << (irq - MSP_PER_INTBASE));
+	volatile u32   *cic_msk_reg = CIC_VPE0_MSK_REG;
+	int vpe;
+#ifdef CONFIG_SMP
+	unsigned int mtflags;
+	unsigned long  flags;
+
+	/*
+	* Make sure we have IRQ affinity.  It may have changed while
+	* we were processing the IRQ.
+	*/
+	if (!cpumask_test_cpu(smp_processor_id(), irq_desc[irq].affinity))
+		return;
+#endif
+
+	vpe = get_current_vpe();
+	LOCK_VPE(flags, mtflags);
+	cic_msk_reg[vpe] |= (1 << (irq - MSP_CIC_INTBASE));
+	UNLOCK_VPE(flags, mtflags);
+	cic_wmb();
 }
 
-/*
- * While we ack the interrupt interrupts are disabled and thus we don't need
- * to deal with concurrency issues.  Same for msp_cic_irq_end.
- */
-static inline void ack_msp_cic_irq(unsigned int irq)
+static inline void mask_cic_irq(unsigned int irq)
 {
-	mask_msp_cic_irq(irq);
-
+	volatile u32 *cic_msk_reg = CIC_VPE0_MSK_REG;
+	int	vpe = get_current_vpe();
+#ifdef CONFIG_SMP
+	unsigned long flags, mtflags;
+#endif
+	LOCK_VPE(flags, mtflags);
+	cic_msk_reg[vpe] &= ~(1 << (irq - MSP_CIC_INTBASE));
+	UNLOCK_VPE(flags, mtflags);
+	cic_wmb();
+}
+static inline void msp_cic_irq_ack(unsigned int irq)
+{
+	mask_cic_irq(irq);
 	/*
-	 * only really necessary for 18, 16-14 and sometimes 3:0 (since
-	 * these can be edge sensitive) but it doesn't hurt for the others.
-	 */
-
-	/* check for PER interrupt range */
-	if (irq < MSP_PER_INTBASE)
-		*CIC_STS_REG = (1 << (irq - MSP_CIC_INTBASE));
-	else
-		*PER_INT_STS_REG = (1 << (irq - MSP_PER_INTBASE));
+	* Only really necessary for 18, 16-14 and sometimes 3:0
+	* (since these can be edge sensitive) but it doesn't
+	* hurt for the others
+	*/
+	*CIC_STS_REG = (1 << (irq - MSP_CIC_INTBASE));
+	smtc_im_ack_irq(irq);
+}
+
+static void msp_cic_irq_end(unsigned int irq)
+{
+	if (!(irq_desc[irq].status & (IRQ_DISABLED | IRQ_INPROGRESS)))
+		unmask_cic_irq(irq);
+}
+
+/*Note: Limiting to VSMP . Not tested in SMTC */
+
+#ifdef CONFIG_MIPS_MT_SMP
+static inline int msp_cic_irq_set_affinity(unsigned int irq,
+					const struct cpumask *cpumask)
+{
+	int cpu;
+	unsigned long flags;
+	unsigned int  mtflags;
+	unsigned long imask = (1 << (irq - MSP_CIC_INTBASE));
+	volatile u32 *cic_mask = (volatile u32 *)CIC_VPE0_MSK_REG;
+
+	/* timer balancing should be disabled in kernel code */
+	BUG_ON(irq == MSP_INT_VPE0_TIMER || irq == MSP_INT_VPE1_TIMER);
+
+	LOCK_CORE(flags, mtflags);
+	/* enable if any of each VPE's TCs require this IRQ */
+	for_each_online_cpu(cpu) {
+		if (cpumask_test_cpu(cpu, cpumask))
+			cic_mask[cpu] |= imask;
+		else
+			cic_mask[cpu] &= ~imask;
+
+	}
+
+	UNLOCK_CORE(flags, mtflags);
+	return 0;
+
 }
+#endif
 
 static struct irq_chip msp_cic_irq_controller = {
 	.name = "MSP_CIC",
-	.ack = ack_msp_cic_irq,
-	.mask = ack_msp_cic_irq,
-	.mask_ack = ack_msp_cic_irq,
-	.unmask = unmask_msp_cic_irq,
+	.mask = mask_cic_irq,
+	.mask_ack = msp_cic_irq_ack,
+	.unmask = unmask_cic_irq,
+	.ack = msp_cic_irq_ack,
+	.end = msp_cic_irq_end,
+#ifdef CONFIG_MIPS_MT_SMP
+	.set_affinity = msp_cic_irq_set_affinity,
+#endif
 };
 
-
 void __init msp_cic_irq_init(void)
 {
 	int i;
-
 	/* Mask/clear interrupts. */
 	*CIC_VPE0_MSK_REG = 0x00000000;
-	*PER_INT_MSK_REG  = 0x00000000;
+	*CIC_VPE1_MSK_REG = 0x00000000;
 	*CIC_STS_REG      = 0xFFFFFFFF;
-	*PER_INT_STS_REG  = 0xFFFFFFFF;
-
-#if defined(CONFIG_PMC_MSP7120_GW) || \
-    defined(CONFIG_PMC_MSP7120_EVAL)
 	/*
-	 * The MSP7120 RG and EVBD boards use IRQ[6:4] for PCI.
-	 * These inputs map to EXT_INT_POL[6:4] inside the CIC.
-	 * They are to be active low, level sensitive.
-	 */
+	* The MSP7120 RG and EVBD boards use IRQ[6:4] for PCI.
+	* These inputs map to EXT_INT_POL[6:4] inside the CIC.
+	* They are to be active low, level sensitive.
+	*/
 	*CIC_EXT_CFG_REG &= 0xFFFF8F8F;
-#endif
 
 	/* initialize all the IRQ descriptors */
-	for (i = MSP_CIC_INTBASE; i < MSP_PER_INTBASE + 32; i++)
+	for (i = MSP_CIC_INTBASE ; i < MSP_CIC_INTBASE + 32 ; i++) {
 		set_irq_chip_and_handler(i, &msp_cic_irq_controller,
 					 handle_level_irq);
+#ifdef CONFIG_MIPS_MT_SMTC
+		/* Mask of CIC interrupt */
+		irq_hwmask[i] = C_IRQ4;
+#endif
+	}
+
+	/* Initialize the PER interrupt sub-system */
+	 msp_per_irq_init();
 }
 
+/* CIC masked by CIC vector processing before dispatch called */
 void msp_cic_irq_dispatch(void)
 {
-	u32 pending;
-	int intbase;
-
-	intbase = MSP_CIC_INTBASE;
-	pending = *CIC_STS_REG & *CIC_VPE0_MSK_REG;
-
-	/* check for PER interrupt */
-	if (pending == (1 << (MSP_INT_PER - MSP_CIC_INTBASE))) {
-		intbase = MSP_PER_INTBASE;
-		pending = *PER_INT_STS_REG & *PER_INT_MSK_REG;
-	}
-
-	/* check for spurious interrupt */
-	if (pending == 0x00000000) {
-		printk(KERN_ERR
-			"Spurious %s interrupt? status %08x, mask %08x\n",
-			(intbase == MSP_CIC_INTBASE) ? "CIC" : "PER",
-			(intbase == MSP_CIC_INTBASE) ?
-				*CIC_STS_REG : *PER_INT_STS_REG,
-			(intbase == MSP_CIC_INTBASE) ?
-				*CIC_VPE0_MSK_REG : *PER_INT_MSK_REG);
-		return;
-	}
-
-	/* check for the timer and dispatch it first */
-	if ((intbase == MSP_CIC_INTBASE) &&
-	    (pending & (1 << (MSP_INT_VPE0_TIMER - MSP_CIC_INTBASE))))
+	volatile u32	*cic_msk_reg = (volatile u32 *)CIC_VPE0_MSK_REG;
+	u32	cic_mask;
+	u32	 pending;
+	int	cic_status = *CIC_STS_REG;
+	cic_mask = cic_msk_reg[get_current_vpe()];
+	pending = cic_status & cic_mask;
+	if (pending & (1 << (MSP_INT_VPE0_TIMER - MSP_CIC_INTBASE))) {
 		do_IRQ(MSP_INT_VPE0_TIMER);
-	else
-		do_IRQ(ffs(pending) + intbase - 1);
+	} else if (pending & (1 << (MSP_INT_VPE1_TIMER - MSP_CIC_INTBASE))) {
+		do_IRQ(MSP_INT_VPE1_TIMER);
+	} else if (pending & (1 << (MSP_INT_PER - MSP_CIC_INTBASE))) {
+		msp_per_irq_dispatch();
+	} else if (pending) {
+		do_IRQ(ffs(pending) + MSP_CIC_INTBASE - 1);
+	} else{
+		spurious_interrupt();
+		/* Re-enable the CIC cascaded interrupt. */
+		irq_desc[MSP_INT_CIC].chip->end(MSP_INT_CIC);
+	}
 }
diff --git a/arch/mips/pmc-sierra/msp71xx/msp_irq_per.c b/arch/mips/pmc-sierra/msp71xx/msp_irq_per.c
new file mode 100644
index 0000000..949fd14
--- /dev/null
+++ b/arch/mips/pmc-sierra/msp71xx/msp_irq_per.c
@@ -0,0 +1,179 @@
+/*
+ * Copyright 2010 PMC-Sierra, Inc, derived from irq_cpu.c
+ *
+ * This file define the irq handler for MSP PER subsystem interrupts.
+ *
+ * This program is free software; you can redistribute  it and/or modify it
+ * under  the terms of  the GNU General  Public License as published by the
+ * Free Software Foundation;  either version 2 of the  License, or (at your
+ * option) any later version.
+ */
+
+#include <linux/init.h>
+#include <linux/interrupt.h>
+#include <linux/kernel.h>
+#include <linux/spinlock.h>
+#include <linux/bitops.h>
+
+#include <asm/mipsregs.h>
+#include <asm/system.h>
+
+#include <msp_cic_int.h>
+#include <msp_regs.h>
+
+
+/*
+ * Convenience Macro.  Should be somewhere generic.
+ */
+#define get_current_vpe()	\
+	((read_c0_tcbind() >> TCBIND_CURVPE_SHIFT) & TCBIND_CURVPE)
+
+#ifdef CONFIG_SMP
+/*
+ * The PER registers must be protected from concurrent access.
+ */
+
+static DEFINE_SPINLOCK(per_lock);
+#endif
+
+/* ensure writes to per are completed */
+
+static inline void per_wmb(void)
+{
+	const volatile void __iomem *per_mem = PER_INT_MSK_REG;
+	volatile u32 dummy_read;
+
+	wmb();
+	dummy_read = __raw_readl(per_mem);
+	dummy_read++;
+}
+
+static inline void unmask_per_irq(unsigned int irq)
+{
+#ifdef CONFIG_SMP
+	unsigned long flags;
+	spin_lock_irqsave(&per_lock, flags);
+	*PER_INT_MSK_REG |= (1 << (irq - MSP_PER_INTBASE));
+	spin_unlock_irqrestore(&per_lock, flags);
+#else
+	*PER_INT_MSK_REG |= (1 << (irq - MSP_PER_INTBASE));
+#endif
+	per_wmb();
+}
+
+static inline void mask_per_irq(unsigned int irq)
+{
+#ifdef CONFIG_SMP
+	unsigned long flags;
+	spin_lock_irqsave(&per_lock, flags);
+	*PER_INT_MSK_REG &= ~(1 << (irq - MSP_PER_INTBASE));
+	spin_unlock_irqrestore(&per_lock, flags);
+#else
+	*PER_INT_MSK_REG &= ~(1 << (irq - MSP_PER_INTBASE));
+#endif
+	per_wmb();
+}
+
+static inline void msp_per_irq_enable(unsigned int irq)
+{
+	unmask_per_irq(irq);
+}
+
+static inline void msp_per_irq_disable(unsigned int irq)
+{
+	 mask_per_irq(irq);
+}
+
+static unsigned int msp_per_irq_startup(unsigned int irq)
+{
+	msp_per_irq_enable(irq);
+	return 0;
+}
+
+#define    msp_per_irq_shutdown    msp_per_irq_disable
+
+static inline void msp_per_irq_ack(unsigned int irq)
+{
+	mask_per_irq(irq);
+	/*
+	 * In the PER interrupt controller, only bits 11 and 10
+	 * are write-to-clear, (SPI TX complete, SPI RX complete).
+	 * It does nothing for any others.
+	 */
+
+	*PER_INT_STS_REG = (1 << (irq - MSP_PER_INTBASE));
+
+	/* Re-enable the CIC cascaded interrupt and return */
+	irq_desc[MSP_INT_CIC].chip->end(MSP_INT_CIC);
+}
+
+static void msp_per_irq_end(unsigned int irq)
+{
+	if (!(irq_desc[irq].status & (IRQ_DISABLED | IRQ_INPROGRESS)))
+	unmask_per_irq(irq);
+}
+
+#ifdef CONFIG_SMP
+static inline int msp_per_irq_set_affinity(unsigned int irq,
+				const struct cpumask *affinity)
+{
+	unsigned long flags;
+	/*
+	 * Calls to ack, end, startup, enable are spinlocked in setup_irq and
+	 * __do_IRQ.Callers of this function do not spinlock,so we need to
+	 * do so ourselves.
+	 */
+	raw_spin_lock_irqsave(&irq_desc[irq].lock, flags);
+	msp_per_irq_enable(irq);
+	raw_spin_unlock_irqrestore(&irq_desc[irq].lock, flags);
+	return 0;
+
+}
+#endif
+
+static struct irq_chip msp_per_irq_controller = {
+	.name = "MSP_PER",
+	.startup = msp_per_irq_startup,
+	.shutdown = msp_per_irq_shutdown,
+	.enable = msp_per_irq_enable,
+	.disable = msp_per_irq_disable,
+#ifdef CONFIG_SMP
+	.set_affinity = msp_per_irq_set_affinity,
+#endif
+	.ack = msp_per_irq_ack,
+	.end = msp_per_irq_end,
+};
+
+void __init msp_per_irq_init(void)
+{
+	int i;
+	/* Mask/clear interrupts. */
+	*PER_INT_MSK_REG  = 0x00000000;
+	*PER_INT_STS_REG  = 0xFFFFFFFF;
+	/* initialize all the IRQ descriptors */
+	for (i = MSP_PER_INTBASE; i < MSP_PER_INTBASE + 32; i++) {
+		irq_desc[i].status = IRQ_DISABLED;
+		irq_desc[i].action = NULL;
+		irq_desc[i].depth = 1;
+		irq_desc[i].chip = &msp_per_irq_controller;
+#ifdef CONFIG_MIPS_MT_SMTC
+		irq_hwmask[i] = C_IRQ4;
+#endif
+	}
+}
+
+void msp_per_irq_dispatch(void)
+{
+	u32	per_mask = *PER_INT_MSK_REG;
+	u32	per_status = *PER_INT_STS_REG;
+	u32	pending;
+
+	pending = per_status & per_mask;
+	if (pending) {
+		do_IRQ(ffs(pending) + MSP_PER_INTBASE - 1);
+	} else {
+		spurious_interrupt();
+	/* Re-enable the CIC cascaded interrupt and return */
+	irq_desc[MSP_INT_CIC].chip->end(MSP_INT_CIC);
+	}
+}
-- 
1.7.0.4

