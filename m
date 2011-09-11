Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760170Ab1IKMAt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Sep 2011 08:00:49 -0400
Received: from juliette.telenet-ops.be ([195.130.137.74]:53571 "EHLO
	juliette.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760130Ab1IKMAF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Sep 2011 08:00:05 -0400
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: linux-m68k@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH 27/28] m68k/irq: Remove obsolete m68k irq framework
Date: Sun, 11 Sep 2011 13:59:53 +0200
Message-Id: <1315742394-16036-28-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1315742394-16036-1-git-send-email-geert@linux-m68k.org>
References: <1315742394-16036-1-git-send-email-geert@linux-m68k.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
v6: Added this changeset
---
 arch/m68k/Kconfig               |    4 +-
 arch/m68k/Kconfig.mmu           |    5 -
 arch/m68k/amiga/amiints.c       |  114 ---------------
 arch/m68k/apollo/dn_ints.c      |   22 ---
 arch/m68k/include/asm/irq.h     |   63 --------
 arch/m68k/include/asm/q40ints.h |    5 -
 arch/m68k/kernel/Makefile_mm    |    5 +-
 arch/m68k/kernel/ints.c         |  297 ---------------------------------------
 arch/m68k/mac/baboon.c          |   41 ------
 arch/m68k/mac/oss.c             |   78 ----------
 arch/m68k/mac/psc.c             |   44 ------
 arch/m68k/mac/via.c             |  104 --------------
 arch/m68k/q40/q40ints.c         |   16 --
 arch/m68k/sun3/sun3ints.c       |   20 ---
 14 files changed, 3 insertions(+), 815 deletions(-)

diff --git a/arch/m68k/Kconfig b/arch/m68k/Kconfig
index 6f490b9..5306229 100644
--- a/arch/m68k/Kconfig
+++ b/arch/m68k/Kconfig
@@ -4,8 +4,8 @@ config M68K
 	select HAVE_IDE
 	select HAVE_AOUT if MMU
 	select GENERIC_ATOMIC64 if MMU
-	select HAVE_GENERIC_HARDIRQS if !MMU
-	select GENERIC_IRQ_SHOW if !MMU
+	select HAVE_GENERIC_HARDIRQS
+	select GENERIC_IRQ_SHOW
 	select ARCH_HAVE_NMI_SAFE_CMPXCHG if RMW_INSNS
 
 config RWSEM_GENERIC_SPINLOCK
diff --git a/arch/m68k/Kconfig.mmu b/arch/m68k/Kconfig.mmu
index 39da911..4ef37c9 100644
--- a/arch/m68k/Kconfig.mmu
+++ b/arch/m68k/Kconfig.mmu
@@ -198,11 +198,6 @@ config SUN3
 
 	  If you don't want to compile a kernel exclusively for a Sun 3, say N.
 
-config USE_GENERIC_HARDIRQS
-	bool "Use genirq"
-	select HAVE_GENERIC_HARDIRQS
-	select GENERIC_IRQ_SHOW
-
 config NATFEAT
 	bool "ARAnyM emulator support"
 	depends on ATARI
diff --git a/arch/m68k/amiga/amiints.c b/arch/m68k/amiga/amiints.c
index a8da471..47b5f90 100644
--- a/arch/m68k/amiga/amiints.c
+++ b/arch/m68k/amiga/amiints.c
@@ -9,9 +9,7 @@
 #include <linux/init.h>
 #include <linux/interrupt.h>
 #include <linux/errno.h>
-#ifdef CONFIG_GENERIC_HARDIRQS
 #include <linux/irq.h>
-#endif
 
 #include <asm/irq.h>
 #include <asm/traps.h>
@@ -48,7 +46,6 @@ static struct irq_chip amiga_irq_chip = {
  * The builtin Amiga hardware interrupt handlers.
  */
 
-#ifdef CONFIG_GENERIC_HARDIRQS
 static void ami_int1(unsigned int irq, struct irq_desc *desc)
 {
 	unsigned short ints = amiga_custom.intreqr & amiga_custom.intenar;
@@ -140,103 +137,6 @@ static void ami_int5(unsigned int irq, struct irq_desc *desc)
 		generic_handle_irq(IRQ_AMIGA_DSKSYN);
 	}
 }
-#else /* !CONFIG_GENERIC_HARDIRQS */
-static irqreturn_t ami_int1(int irq, void *dev_id)
-{
-	unsigned short ints = amiga_custom.intreqr & amiga_custom.intenar;
-
-	/* if serial transmit buffer empty, interrupt */
-	if (ints & IF_TBE) {
-		amiga_custom.intreq = IF_TBE;
-		generic_handle_irq(IRQ_AMIGA_TBE);
-	}
-
-	/* if floppy disk transfer complete, interrupt */
-	if (ints & IF_DSKBLK) {
-		amiga_custom.intreq = IF_DSKBLK;
-		generic_handle_irq(IRQ_AMIGA_DSKBLK);
-	}
-
-	/* if software interrupt set, interrupt */
-	if (ints & IF_SOFT) {
-		amiga_custom.intreq = IF_SOFT;
-		generic_handle_irq(IRQ_AMIGA_SOFT);
-	}
-	return IRQ_HANDLED;
-}
-
-static irqreturn_t ami_int3(int irq, void *dev_id)
-{
-	unsigned short ints = amiga_custom.intreqr & amiga_custom.intenar;
-
-	/* if a blitter interrupt */
-	if (ints & IF_BLIT) {
-		amiga_custom.intreq = IF_BLIT;
-		generic_handle_irq(IRQ_AMIGA_BLIT);
-	}
-
-	/* if a copper interrupt */
-	if (ints & IF_COPER) {
-		amiga_custom.intreq = IF_COPER;
-		generic_handle_irq(IRQ_AMIGA_COPPER);
-	}
-
-	/* if a vertical blank interrupt */
-	if (ints & IF_VERTB) {
-		amiga_custom.intreq = IF_VERTB;
-		generic_handle_irq(IRQ_AMIGA_VERTB);
-	}
-	return IRQ_HANDLED;
-}
-
-static irqreturn_t ami_int4(int irq, void *dev_id)
-{
-	unsigned short ints = amiga_custom.intreqr & amiga_custom.intenar;
-
-	/* if audio 0 interrupt */
-	if (ints & IF_AUD0) {
-		amiga_custom.intreq = IF_AUD0;
-		generic_handle_irq(IRQ_AMIGA_AUD0);
-	}
-
-	/* if audio 1 interrupt */
-	if (ints & IF_AUD1) {
-		amiga_custom.intreq = IF_AUD1;
-		generic_handle_irq(IRQ_AMIGA_AUD1);
-	}
-
-	/* if audio 2 interrupt */
-	if (ints & IF_AUD2) {
-		amiga_custom.intreq = IF_AUD2;
-		generic_handle_irq(IRQ_AMIGA_AUD2);
-	}
-
-	/* if audio 3 interrupt */
-	if (ints & IF_AUD3) {
-		amiga_custom.intreq = IF_AUD3;
-		generic_handle_irq(IRQ_AMIGA_AUD3);
-	}
-	return IRQ_HANDLED;
-}
-
-static irqreturn_t ami_int5(int irq, void *dev_id)
-{
-	unsigned short ints = amiga_custom.intreqr & amiga_custom.intenar;
-
-	/* if serial receive buffer full interrupt */
-	if (ints & IF_RBF) {
-		/* acknowledge of IF_RBF must be done by the serial interrupt */
-		generic_handle_irq(IRQ_AMIGA_RBF);
-	}
-
-	/* if a disk sync interrupt */
-	if (ints & IF_DSKSYN) {
-		amiga_custom.intreq = IF_DSKSYN;
-		generic_handle_irq(IRQ_AMIGA_DSKSYN);
-	}
-	return IRQ_HANDLED;
-}
-#endif /* !CONFIG_GENERIC_HARDIRQS */
 
 
 /*
@@ -252,7 +152,6 @@ static irqreturn_t ami_int5(int irq, void *dev_id)
 
 void __init amiga_init_IRQ(void)
 {
-#ifdef CONFIG_GENERIC_HARDIRQS
 	m68k_setup_irq_controller(&amiga_irq_chip, handle_simple_irq, IRQ_USER,
 				  AMI_STD_IRQS);
 
@@ -260,19 +159,6 @@ void __init amiga_init_IRQ(void)
 	irq_set_chained_handler(IRQ_AUTO_3, ami_int3);
 	irq_set_chained_handler(IRQ_AUTO_4, ami_int4);
 	irq_set_chained_handler(IRQ_AUTO_5, ami_int5);
-#else /* !CONFIG_GENERIC_HARDIRQS */
-	if (request_irq(IRQ_AUTO_1, ami_int1, 0, "int1", NULL))
-		pr_err("Couldn't register int%d\n", 1);
-	if (request_irq(IRQ_AUTO_3, ami_int3, 0, "int3", NULL))
-		pr_err("Couldn't register int%d\n", 3);
-	if (request_irq(IRQ_AUTO_4, ami_int4, 0, "int4", NULL))
-		pr_err("Couldn't register int%d\n", 4);
-	if (request_irq(IRQ_AUTO_5, ami_int5, 0, "int5", NULL))
-		pr_err("Couldn't register int%d\n", 5);
-
-	m68k_setup_irq_controller(&amiga_irq_chip, handle_simple_irq, IRQ_USER,
-				  AMI_STD_IRQS);
-#endif /* !CONFIG_GENERIC_HARDIRQS */
 
 	/* turn off PCMCIA interrupts */
 	if (AMIGAHW_PRESENT(PCMCIA))
diff --git a/arch/m68k/apollo/dn_ints.c b/arch/m68k/apollo/dn_ints.c
index fc190b3..b7d0aa3 100644
--- a/arch/m68k/apollo/dn_ints.c
+++ b/arch/m68k/apollo/dn_ints.c
@@ -1,23 +1,9 @@
 #include <linux/interrupt.h>
-#ifdef CONFIG_GENERIC_HARDIRQS
 #include <linux/irq.h>
-#else
-#include <asm/irq.h>
-#endif
 
 #include <asm/traps.h>
 #include <asm/apollohw.h>
 
-#ifndef CONFIG_GENERIC_HARDIRQS
-void dn_process_int(unsigned int irq, struct pt_regs *fp)
-{
-	do_IRQ(irq, fp);
-
-	*(volatile unsigned char *)(pica)=0x20;
-	*(volatile unsigned char *)(picb)=0x20;
-}
-#endif
-
 unsigned int apollo_irq_startup(struct irq_data *data)
 {
 	unsigned int irq = data->irq;
@@ -39,31 +25,23 @@ void apollo_irq_shutdown(struct irq_data *data)
 		*(volatile unsigned char *)(picb+1) |= (1 << (irq - 8));
 }
 
-#ifdef CONFIG_GENERIC_HARDIRQS
 void apollo_irq_eoi(struct irq_data *data)
 {
 	*(volatile unsigned char *)(pica) = 0x20;
 	*(volatile unsigned char *)(picb) = 0x20;
 }
-#endif
 
 static struct irq_chip apollo_irq_chip = {
 	.name           = "apollo",
 	.irq_startup    = apollo_irq_startup,
 	.irq_shutdown   = apollo_irq_shutdown,
-#ifdef CONFIG_GENERIC_HARDIRQS
 	.irq_eoi	= apollo_irq_eoi,
-#endif
 };
 
 
 void __init dn_init_IRQ(void)
 {
-#ifdef CONFIG_GENERIC_HARDIRQS
 	m68k_setup_user_interrupt(VEC_USER + 96, 16, NULL);
-#else
-	m68k_setup_user_interrupt(VEC_USER + 96, 16, dn_process_int);
-#endif
 	m68k_setup_irq_controller(&apollo_irq_chip, handle_fasteoi_irq,
 				  IRQ_APOLLO, 16);
 }
diff --git a/arch/m68k/include/asm/irq.h b/arch/m68k/include/asm/irq.h
index 8971647..6f28dd8 100644
--- a/arch/m68k/include/asm/irq.h
+++ b/arch/m68k/include/asm/irq.h
@@ -49,67 +49,6 @@
 
 #define IRQ_USER	8
 
-#ifndef CONFIG_GENERIC_HARDIRQS
-
-#include <linux/linkage.h>
-#include <linux/hardirq.h>
-#include <linux/irqreturn.h>
-#include <linux/spinlock_types.h>
-
-struct pt_regs;
-
-/*
- * This structure is used to chain together the ISRs for a particular
- * interrupt source (if it supports chaining).
- */
-struct irq_data {
-	unsigned int	irq;
-	irqreturn_t	(*handler)(int, void *);
-	void		*dev_id;
-	struct irq_data *next;
-	unsigned long	flags;
-	const char	*devname;
-};
-
-/*
- * This structure has only 4 elements for speed reasons
- */
-struct irq_handler {
-	int		(*handler)(int, void *);
-	unsigned long	flags;
-	void		*dev_id;
-	const char	*devname;
-};
-
-struct irq_chip {
-	const char *name;
-	unsigned int (*irq_startup)(struct irq_data *data);
-	void (*irq_shutdown)(struct irq_data *data);
-	void (*irq_enable)(struct irq_data *data);
-	void (*irq_disable)(struct irq_data *data);
-};
-
-extern unsigned int m68k_irq_startup(struct irq_data *data);
-extern unsigned int m68k_irq_startup_irq(unsigned int irq);
-extern void m68k_irq_shutdown(struct irq_data *data);
-
-/*
- * This function returns a new struct irq_data
- */
-extern struct irq_data *new_irq_node(void);
-
-extern void m68k_setup_auto_interrupt(void (*handler)(unsigned int, struct pt_regs *));
-extern void m68k_setup_user_interrupt(unsigned int vec, unsigned int cnt,
-				      void (*handler)(unsigned int, struct pt_regs *));
-extern void m68k_setup_irq_chip(struct irq_chip *, unsigned int, unsigned int);
-#define m68k_setup_irq_controller(chip, dummy, irq, cnt) \
-	m68k_setup_irq_chip((chip), (irq), (cnt))
-
-extern void generic_handle_irq(unsigned int);
-asmlinkage void do_IRQ(int irq, struct pt_regs *regs);
-
-#else /* CONFIG_GENERIC_HARDIRQS */
-
 struct irq_data;
 struct irq_chip;
 struct irq_desc;
@@ -126,8 +65,6 @@ extern void m68k_setup_irq_controller(struct irq_chip *,
 						     struct irq_desc *desc),
 				      unsigned int irq, unsigned int cnt);
 
-#endif /* CONFIG_GENERIC_HARDIRQS */
-
 extern unsigned int irq_canonicalize(unsigned int irq);
 
 #else
diff --git a/arch/m68k/include/asm/q40ints.h b/arch/m68k/include/asm/q40ints.h
index 01cdbb4..22f12c9 100644
--- a/arch/m68k/include/asm/q40ints.h
+++ b/arch/m68k/include/asm/q40ints.h
@@ -24,8 +24,3 @@
 #define Q40_IRQ10_MASK       (1<<5)
 #define Q40_IRQ14_MASK       (1<<6)
 #define Q40_IRQ15_MASK       (1<<7)
-
-#ifndef CONFIG_GENERIC_HARDIRQS
-extern unsigned long q40_probe_irq_on (void);
-extern int q40_probe_irq_off (unsigned long irqs);
-#endif
diff --git a/arch/m68k/kernel/Makefile_mm b/arch/m68k/kernel/Makefile_mm
index 8122750..24aed9c 100644
--- a/arch/m68k/kernel/Makefile_mm
+++ b/arch/m68k/kernel/Makefile_mm
@@ -10,11 +10,8 @@ endif
 extra-y	+= vmlinux.lds
 
 obj-y	:= entry.o process.o traps.o ints.o signal.o ptrace.o module.o \
-	   sys_m68k.o time.o setup.o m68k_ksyms.o syscalltable.o
+	   sys_m68k.o time.o setup.o m68k_ksyms.o syscalltable.o irq.o
 
 devres-y = ../../../kernel/irq/devres.o
 
 obj-y$(CONFIG_MMU_SUN3) += dma.o	# no, it's not a typo
-
-obj-y$(CONFIG_GENERIC_HARDIRQS) += devres.o
-obj-$(CONFIG_GENERIC_HARDIRQS) += irq.o
diff --git a/arch/m68k/kernel/ints.c b/arch/m68k/kernel/ints.c
index cea439f..e2b056b 100644
--- a/arch/m68k/kernel/ints.c
+++ b/arch/m68k/kernel/ints.c
@@ -31,20 +31,6 @@ extern u32 auto_irqhandler_fixup[];
 extern u32 user_irqhandler_fixup[];
 extern u16 user_irqvec_fixup[];
 
-#ifndef CONFIG_GENERIC_HARDIRQS
-/* table for system interrupt handlers */
-static struct irq_data *irq_list[NR_IRQS];
-static struct irq_chip *irq_chip[NR_IRQS];
-static int irq_depth[NR_IRQS];
-
-static inline int irq_set_chip(unsigned int irq, struct irq_chip *chip)
-{
-	irq_chip[irq] = chip;
-	return 0;
-}
-#define irq_set_chip_and_handler(irq, chip, dummy)	irq_set_chip(irq, chip)
-#endif /* !CONFIG_GENERIC_HARDIRQS */
-
 static int m68k_first_user_vec;
 
 static struct irq_chip auto_irq_chip = {
@@ -59,11 +45,6 @@ static struct irq_chip user_irq_chip = {
 	.irq_shutdown	= m68k_irq_shutdown,
 };
 
-#ifndef CONFIG_GENERIC_HARDIRQS
-#define NUM_IRQ_NODES 100
-static struct irq_data nodes[NUM_IRQ_NODES];
-#endif /* !CONFIG_GENERIC_HARDIRQS */
-
 /*
  * void init_IRQ(void)
  *
@@ -133,8 +114,6 @@ void __init m68k_setup_user_interrupt(unsigned int vec, unsigned int cnt,
 	flush_icache();
 }
 
-#ifdef CONFIG_GENERIC_HARDIRQS
-
 /**
  * m68k_setup_irq_controller
  * @chip: irq chip which controls specified irq
@@ -160,198 +139,6 @@ void m68k_setup_irq_controller(struct irq_chip *chip,
 	}
 }
 
-#else /* !CONFIG_GENERIC_HARDIRQS */
-
-/**
- * m68k_setup_irq_chip
- * @contr: irq controller which controls specified irq
- * @irq: first irq to be managed by the controller
- *
- * Change the controller for the specified range of irq, which will be used to
- * manage these irq. auto/user irq already have a default controller, which can
- * be changed as well, but the controller probably should use m68k_irq_startup/
- * m68k_irq_shutdown.
- */
-void m68k_setup_irq_chip(struct irq_chip *contr, unsigned int irq,
-			       unsigned int cnt)
-{
-	int i;
-
-	for (i = 0; i < cnt; i++)
-		irq_set_chip(irq + i, contr);
-}
-
-struct irq_data *new_irq_node(void)
-{
-	struct irq_data *node;
-	short i;
-
-	for (node = nodes, i = NUM_IRQ_NODES-1; i >= 0; node++, i--) {
-		if (!node->handler) {
-			memset(node, 0, sizeof(*node));
-			return node;
-		}
-	}
-
-	printk ("new_irq_node: out of nodes\n");
-	return NULL;
-}
-
-static int m68k_setup_irq(unsigned int irq, struct irq_data *node)
-{
-	struct irq_chip *contr;
-	struct irq_data **prev;
-	unsigned long flags;
-
-	if (irq >= NR_IRQS || !(contr = irq_chip[irq])) {
-		printk("%s: Incorrect IRQ %d from %s\n",
-		       __func__, irq, node->devname);
-		return -ENXIO;
-	}
-
-	local_irq_save(flags);
-
-	prev = irq_list + irq;
-	if (*prev) {
-		/* Can't share interrupts unless both agree to */
-		if (!((*prev)->flags & node->flags & IRQF_SHARED)) {
-			local_irq_restore(flags);
-			return -EBUSY;
-		}
-		while (*prev)
-			prev = &(*prev)->next;
-	}
-
-	if (!irq_list[irq]) {
-		if (contr->irq_startup)
-			contr->irq_startup(node);
-		else
-			contr->irq_enable(node);
-	}
-	node->next = NULL;
-	*prev = node;
-
-	local_irq_restore(flags);
-
-	return 0;
-}
-
-int request_irq(unsigned int irq,
-		irq_handler_t handler,
-		unsigned long flags, const char *devname, void *dev_id)
-{
-	struct irq_data *node;
-	int res;
-
-	node = new_irq_node();
-	if (!node)
-		return -ENOMEM;
-
-	node->irq     = irq;
-	node->handler = handler;
-	node->flags   = flags;
-	node->dev_id  = dev_id;
-	node->devname = devname;
-
-	res = m68k_setup_irq(irq, node);
-	if (res)
-		node->handler = NULL;
-
-	return res;
-}
-
-EXPORT_SYMBOL(request_irq);
-
-void free_irq(unsigned int irq, void *dev_id)
-{
-	struct irq_chip *contr;
-	struct irq_data **p, *node;
-	unsigned long flags;
-
-	if (irq >= NR_IRQS || !(contr = irq_chip[irq])) {
-		printk("%s: Incorrect IRQ %d\n", __func__, irq);
-		return;
-	}
-
-	local_irq_save(flags);
-
-	p = irq_list + irq;
-	while ((node = *p)) {
-		if (node->dev_id == dev_id)
-			break;
-		p = &node->next;
-	}
-
-	if (node) {
-		*p = node->next;
-		node->handler = NULL;
-	} else
-		printk("%s: Removing probably wrong IRQ %d\n",
-		       __func__, irq);
-
-	if (!irq_list[irq]) {
-		if (contr->irq_shutdown)
-			contr->irq_shutdown(node);
-		else
-			contr->irq_disable(node);
-	}
-
-	local_irq_restore(flags);
-}
-
-EXPORT_SYMBOL(free_irq);
-
-void enable_irq(unsigned int irq)
-{
-	struct irq_chip *contr;
-	unsigned long flags;
-
-	if (irq >= NR_IRQS || !(contr = irq_chip[irq])) {
-		printk("%s: Incorrect IRQ %d\n",
-		       __func__, irq);
-		return;
-	}
-
-	local_irq_save(flags);
-	if (irq_depth[irq]) {
-		if (!--irq_depth[irq]) {
-			if (contr->irq_enable)
-				contr->irq_enable(irq_list[irq]);
-		}
-	} else
-		WARN_ON(1);
-	local_irq_restore(flags);
-}
-
-EXPORT_SYMBOL(enable_irq);
-
-void disable_irq(unsigned int irq)
-{
-	struct irq_chip *contr;
-	unsigned long flags;
-
-	if (irq >= NR_IRQS || !(contr = irq_chip[irq])) {
-		printk("%s: Incorrect IRQ %d\n",
-		       __func__, irq);
-		return;
-	}
-
-	local_irq_save(flags);
-	if (!irq_depth[irq]++) {
-		if (contr->irq_disable)
-			contr->irq_disable(irq_list[irq]);
-	}
-	local_irq_restore(flags);
-}
-
-EXPORT_SYMBOL(disable_irq);
-
-void disable_irq_nosync(unsigned int irq) __attribute__((alias("disable_irq")));
-
-EXPORT_SYMBOL(disable_irq_nosync);
-
-#endif /* !CONFIG_GENERIC_HARDIRQS */
-
 unsigned int m68k_irq_startup_irq(unsigned int irq)
 {
 	if (irq <= IRQ_AUTO_7)
@@ -377,36 +164,6 @@ void m68k_irq_shutdown(struct irq_data *data)
 }
 
 
-#ifndef CONFIG_GENERIC_HARDIRQS
-
-/*
- * Do we need these probe functions on the m68k?
- *
- *  ... may be useful with ISA devices
- */
-unsigned long probe_irq_on (void)
-{
-#ifdef CONFIG_Q40
-	if (MACH_IS_Q40)
-		return q40_probe_irq_on();
-#endif
-	return 0;
-}
-
-EXPORT_SYMBOL(probe_irq_on);
-
-int probe_irq_off (unsigned long irqs)
-{
-#ifdef CONFIG_Q40
-	if (MACH_IS_Q40)
-		return q40_probe_irq_off(irqs);
-#endif
-	return 0;
-}
-
-EXPORT_SYMBOL(probe_irq_off);
-#endif /* CONFIG_GENERIC_HARDIRQS */
-
 unsigned int irq_canonicalize(unsigned int irq)
 {
 #ifdef CONFIG_Q40
@@ -418,63 +175,9 @@ unsigned int irq_canonicalize(unsigned int irq)
 
 EXPORT_SYMBOL(irq_canonicalize);
 
-#ifndef CONFIG_GENERIC_HARDIRQS
-void generic_handle_irq(unsigned int irq)
-{
-	struct irq_data *node;
-	kstat_cpu(0).irqs[irq]++;
-	node = irq_list[irq];
-	do {
-		node->handler(irq, node->dev_id);
-		node = node->next;
-	} while (node);
-}
-
-asmlinkage void do_IRQ(int irq, struct pt_regs *regs)
-{
-	struct pt_regs *old_regs;
-	old_regs = set_irq_regs(regs);
-	generic_handle_irq(irq);
-	set_irq_regs(old_regs);
-}
-
-asmlinkage void handle_badint(struct pt_regs *regs)
-{
-	kstat_cpu(0).irqs[0]++;
-	printk("unexpected interrupt from %u\n", regs->vector);
-}
-
-int show_interrupts(struct seq_file *p, void *v)
-{
-	struct irq_chip *contr;
-	struct irq_data *node;
-	int i = *(loff_t *) v;
-
-	/* autovector interrupts */
-	if (irq_list[i]) {
-		contr = irq_chip[i];
-		node = irq_list[i];
-		seq_printf(p, "%-8s %3u: %10u %s", contr->name, i, kstat_cpu(0).irqs[i], node->devname);
-		while ((node = node->next))
-			seq_printf(p, ", %s", node->devname);
-		seq_puts(p, "\n");
-	}
-	return 0;
-}
-
-#ifdef CONFIG_PROC_FS
-void init_irq_proc(void)
-{
-	/* Insert /proc/irq driver here */
-}
-#endif
-
-#else /* CONFIG_GENERIC_HARDIRQS */
 
 asmlinkage void handle_badint(struct pt_regs *regs)
 {
 	atomic_inc(&irq_err_count);
 	pr_warn("unexpected interrupt from %u\n", regs->vector);
 }
-
-#endif /* CONFIG_GENERIC_HARDIRQS */
diff --git a/arch/m68k/mac/baboon.c b/arch/m68k/mac/baboon.c
index 425144c..b55ead2 100644
--- a/arch/m68k/mac/baboon.c
+++ b/arch/m68k/mac/baboon.c
@@ -11,9 +11,7 @@
 #include <linux/mm.h>
 #include <linux/delay.h>
 #include <linux/init.h>
-#ifdef CONFIG_GENERIC_HARDIRQS
 #include <linux/irq.h>
-#endif
 
 #include <asm/traps.h>
 #include <asm/bootinfo.h>
@@ -56,7 +54,6 @@ void __init baboon_init(void)
  * Baboon interrupt handler. This works a lot like a VIA.
  */
 
-#ifdef CONFIG_GENERIC_HARDIRQS
 static void baboon_irq(unsigned int irq, struct irq_desc *desc)
 {
 	int irq_bit, irq_num;
@@ -88,39 +85,6 @@ static void baboon_irq(unsigned int irq, struct irq_desc *desc)
 	baboon->mb_ifr &= ~events;
 #endif
 }
-#else
-static irqreturn_t baboon_irq(int irq, void *dev_id)
-{
-	int irq_bit, irq_num;
-	unsigned char events;
-
-#ifdef DEBUG_IRQS
-	printk("baboon_irq: mb_control %02X mb_ifr %02X mb_status %02X\n",
-		(uint) baboon->mb_control, (uint) baboon->mb_ifr,
-		(uint) baboon->mb_status);
-#endif
-
-	if (!(events = baboon->mb_ifr & 0x07))
-		return IRQ_NONE;
-
-	irq_num = IRQ_BABOON_0;
-	irq_bit = 1;
-	do {
-	        if (events & irq_bit) {
-			baboon->mb_ifr &= ~irq_bit;
-			generic_handle_irq(irq_num);
-		}
-		irq_bit <<= 1;
-		irq_num++;
-	} while(events >= irq_bit);
-#if 0
-	if (baboon->mb_ifr & 0x02) macide_ack_intr(NULL);
-	/* for now we need to smash all interrupts */
-	baboon->mb_ifr &= ~events;
-#endif
-	return IRQ_HANDLED;
-}
-#endif
 
 /*
  * Register the Baboon interrupt dispatcher on nubus slot $C.
@@ -129,12 +93,7 @@ static irqreturn_t baboon_irq(int irq, void *dev_id)
 void __init baboon_register_interrupts(void)
 {
 	baboon_disabled = 0;
-#ifdef CONFIG_GENERIC_HARDIRQS
 	irq_set_chained_handler(IRQ_NUBUS_C, baboon_irq);
-#else
-	if (request_irq(IRQ_NUBUS_C, baboon_irq, 0, "baboon", (void *)baboon))
-		pr_err("Couldn't register baboon interrupt\n");
-#endif
 }
 
 /*
diff --git a/arch/m68k/mac/oss.c b/arch/m68k/mac/oss.c
index cc784c2..a4c82da 100644
--- a/arch/m68k/mac/oss.c
+++ b/arch/m68k/mac/oss.c
@@ -19,9 +19,7 @@
 #include <linux/mm.h>
 #include <linux/delay.h>
 #include <linux/init.h>
-#ifdef CONFIG_GENERIC_HARDIRQS
 #include <linux/irq.h>
-#endif
 
 #include <asm/bootinfo.h>
 #include <asm/macintosh.h>
@@ -32,11 +30,7 @@
 int oss_present;
 volatile struct mac_oss *oss;
 
-#ifdef CONFIG_GENERIC_HARDIRQS
 extern void via1_irq(unsigned int irq, struct irq_desc *desc);
-#else
-extern irqreturn_t via1_irq(int, void *);
-#endif
 
 /*
  * Initialize the OSS
@@ -76,7 +70,6 @@ void __init oss_nubus_init(void)
  * and SCSI; everything else is routed to its own autovector IRQ.
  */
 
-#ifdef CONFIG_GENERIC_HARDIRQS
 static void oss_irq(unsigned int irq, struct irq_desc *desc)
 {
 	int events;
@@ -103,35 +96,6 @@ static void oss_irq(unsigned int irq, struct irq_desc *desc)
 		/* FIXME: error check here? */
 	}
 }
-#else
-static irqreturn_t oss_irq(int irq, void *dev_id)
-{
-	int events;
-
-	events = oss->irq_pending & (OSS_IP_SOUND|OSS_IP_SCSI);
-	if (!events)
-		return IRQ_NONE;
-
-#ifdef DEBUG_IRQS
-	if ((console_loglevel == 10) && !(events & OSS_IP_SCSI)) {
-		printk("oss_irq: irq %d events = 0x%04X\n", irq,
-			(int) oss->irq_pending);
-	}
-#endif
-	/* FIXME: how do you clear a pending IRQ?    */
-
-	if (events & OSS_IP_SOUND) {
-		oss->irq_pending &= ~OSS_IP_SOUND;
-		/* FIXME: call sound handler */
-	} else if (events & OSS_IP_SCSI) {
-		oss->irq_pending &= ~OSS_IP_SCSI;
-		generic_handle_irq(IRQ_MAC_SCSI);
-	} else {
-		/* FIXME: error check here? */
-	}
-	return IRQ_HANDLED;
-}
-#endif
 
 /*
  * Nubus IRQ handler, OSS style
@@ -139,7 +103,6 @@ static irqreturn_t oss_irq(int irq, void *dev_id)
  * Unlike the VIA/RBV this is on its own autovector interrupt level.
  */
 
-#ifdef CONFIG_GENERIC_HARDIRQS
 static void oss_nubus_irq(unsigned int irq, struct irq_desc *desc)
 {
 	int events, irq_bit, i;
@@ -166,35 +129,6 @@ static void oss_nubus_irq(unsigned int irq, struct irq_desc *desc)
 		}
 	} while(events & (irq_bit - 1));
 }
-#else
-static irqreturn_t oss_nubus_irq(int irq, void *dev_id)
-{
-	int events, irq_bit, i;
-
-	events = oss->irq_pending & OSS_IP_NUBUS;
-	if (!events)
-		return IRQ_NONE;
-
-#ifdef DEBUG_NUBUS_INT
-	if (console_loglevel > 7) {
-		printk("oss_nubus_irq: events = 0x%04X\n", events);
-	}
-#endif
-	/* There are only six slots on the OSS, not seven */
-
-	i = 6;
-	irq_bit = 0x40;
-	do {
-		--i;
-		irq_bit >>= 1;
-		if (events & irq_bit) {
-			oss->irq_pending &= ~irq_bit;
-			generic_handle_irq(NUBUS_SOURCE_BASE + i);
-		}
-	} while(events & (irq_bit - 1));
-	return IRQ_HANDLED;
-}
-#endif
 
 /*
  * Register the OSS and NuBus interrupt dispatchers.
@@ -202,22 +136,10 @@ static irqreturn_t oss_nubus_irq(int irq, void *dev_id)
 
 void __init oss_register_interrupts(void)
 {
-#ifdef CONFIG_GENERIC_HARDIRQS
 	irq_set_chained_handler(OSS_IRQLEV_SCSI, oss_irq);
 	irq_set_chained_handler(OSS_IRQLEV_NUBUS, oss_nubus_irq);
 	irq_set_chained_handler(OSS_IRQLEV_SOUND, oss_irq);
 	irq_set_chained_handler(OSS_IRQLEV_VIA1, via1_irq);
-#else /* !CONFIG_GENERIC_HARDIRQS */
-	if (request_irq(OSS_IRQLEV_SCSI, oss_irq, 0, "scsi", (void *)oss))
-		pr_err("Couldn't register %s interrupt\n", "scsi");
-	if (request_irq(OSS_IRQLEV_NUBUS, oss_nubus_irq, 0, "nubus",
-			(void *)oss))
-		pr_err("Couldn't register %s interrupt\n", "nubus");
-	if (request_irq(OSS_IRQLEV_SOUND, oss_irq, 0, "sound", (void *)oss))
-		pr_err("Couldn't register %s interrupt\n", "sound");
-	if (request_irq(OSS_IRQLEV_VIA1, via1_irq, 0, "via1", (void *)via1))
-		pr_err("Couldn't register %s interrupt\n", "via1");
-#endif /* !CONFIG_GENERIC_HARDIRQS */
 }
 
 /*
diff --git a/arch/m68k/mac/psc.c b/arch/m68k/mac/psc.c
index 52840b8..e6c2d20 100644
--- a/arch/m68k/mac/psc.c
+++ b/arch/m68k/mac/psc.c
@@ -18,9 +18,7 @@
 #include <linux/mm.h>
 #include <linux/delay.h>
 #include <linux/init.h>
-#ifdef CONFIG_GENERIC_HARDIRQS
 #include <linux/irq.h>
-#endif
 
 #include <asm/traps.h>
 #include <asm/bootinfo.h>
@@ -116,7 +114,6 @@ void __init psc_init(void)
  * PSC interrupt handler. It's a lot like the VIA interrupt handler.
  */
 
-#ifdef CONFIG_GENERIC_HARDIRQS
 static void psc_irq(unsigned int irq, struct irq_desc *desc)
 {
 	unsigned int offset = (unsigned int)irq_desc_get_handler_data(desc);
@@ -145,36 +142,6 @@ static void psc_irq(unsigned int irq, struct irq_desc *desc)
 		irq_bit <<= 1;
 	} while (events >= irq_bit);
 }
-#else
-static irqreturn_t psc_irq(int irq, void *dev_id)
-{
-	int pIFR	= pIFRbase + ((int) dev_id);
-	int pIER	= pIERbase + ((int) dev_id);
-	int irq_num;
-	unsigned char irq_bit, events;
-
-#ifdef DEBUG_IRQS
-	printk("psc_irq: irq %d pIFR = 0x%02X pIER = 0x%02X\n",
-		irq, (int) psc_read_byte(pIFR), (int) psc_read_byte(pIER));
-#endif
-
-	events = psc_read_byte(pIFR) & psc_read_byte(pIER) & 0xF;
-	if (!events)
-		return IRQ_NONE;
-
-	irq_num = irq << 3;
-	irq_bit = 1;
-	do {
-		if (events & irq_bit) {
-			psc_write_byte(pIFR, irq_bit);
-			generic_handle_irq(irq_num);
-		}
-		irq_num++;
-		irq_bit <<= 1;
-	} while (events >= irq_bit);
-	return IRQ_HANDLED;
-}
-#endif
 
 /*
  * Register the PSC interrupt dispatchers for autovector interrupts 3-6.
@@ -182,7 +149,6 @@ static irqreturn_t psc_irq(int irq, void *dev_id)
 
 void __init psc_register_interrupts(void)
 {
-#ifdef CONFIG_GENERIC_HARDIRQS
 	irq_set_chained_handler(IRQ_AUTO_3, psc_irq);
 	irq_set_handler_data(IRQ_AUTO_3, (void *)0x30);
 	irq_set_chained_handler(IRQ_AUTO_4, psc_irq);
@@ -191,16 +157,6 @@ void __init psc_register_interrupts(void)
 	irq_set_handler_data(IRQ_AUTO_5, (void *)0x50);
 	irq_set_chained_handler(IRQ_AUTO_6, psc_irq);
 	irq_set_handler_data(IRQ_AUTO_6, (void *)0x60);
-#else /* !CONFIG_GENERIC_HARDIRQS */
-	if (request_irq(IRQ_AUTO_3, psc_irq, 0, "psc3", (void *) 0x30))
-		pr_err("Couldn't register psc%d interrupt\n", 3);
-	if (request_irq(IRQ_AUTO_4, psc_irq, 0, "psc4", (void *) 0x40))
-		pr_err("Couldn't register psc%d interrupt\n", 4);
-	if (request_irq(IRQ_AUTO_5, psc_irq, 0, "psc5", (void *) 0x50))
-		pr_err("Couldn't register psc%d interrupt\n", 5);
-	if (request_irq(IRQ_AUTO_6, psc_irq, 0, "psc6", (void *) 0x60))
-		pr_err("Couldn't register psc%d interrupt\n", 6);
-#endif /* !CONFIG_GENERIC_HARDIRQS */
 }
 
 void psc_irq_enable(int irq) {
diff --git a/arch/m68k/mac/via.c b/arch/m68k/mac/via.c
index b8156ac..f1600ad 100644
--- a/arch/m68k/mac/via.c
+++ b/arch/m68k/mac/via.c
@@ -28,9 +28,7 @@
 #include <linux/delay.h>
 #include <linux/init.h>
 #include <linux/module.h>
-#ifdef CONFIG_GENERIC_HARDIRQS
 #include <linux/irq.h>
-#endif
 
 #include <asm/bootinfo.h>
 #include <asm/macintosh.h>
@@ -417,7 +415,6 @@ void __init via_nubus_init(void)
  * via6522.c :-), disable/pending masks added.
  */
 
-#ifdef CONFIG_GENERIC_HARDIRQS
 void via1_irq(unsigned int irq, struct irq_desc *desc)
 {
 	int irq_num;
@@ -459,58 +456,12 @@ static void via2_irq(unsigned int irq, struct irq_desc *desc)
 		irq_bit <<= 1;
 	} while (events >= irq_bit);
 }
-#else
-irqreturn_t via1_irq(int irq, void *dev_id)
-{
-	int irq_num;
-	unsigned char irq_bit, events;
-
-	events = via1[vIFR] & via1[vIER] & 0x7F;
-	if (!events)
-		return IRQ_NONE;
-
-	irq_num = VIA1_SOURCE_BASE;
-	irq_bit = 1;
-	do {
-		if (events & irq_bit) {
-			via1[vIFR] = irq_bit;
-			generic_handle_irq(irq_num);
-		}
-		++irq_num;
-		irq_bit <<= 1;
-	} while (events >= irq_bit);
-	return IRQ_HANDLED;
-}
-
-irqreturn_t via2_irq(int irq, void *dev_id)
-{
-	int irq_num;
-	unsigned char irq_bit, events;
-
-	events = via2[gIFR] & via2[gIER] & 0x7F;
-	if (!events)
-		return IRQ_NONE;
-
-	irq_num = VIA2_SOURCE_BASE;
-	irq_bit = 1;
-	do {
-		if (events & irq_bit) {
-			via2[gIFR] = irq_bit | rbv_clear;
-			generic_handle_irq(irq_num);
-		}
-		++irq_num;
-		irq_bit <<= 1;
-	} while (events >= irq_bit);
-	return IRQ_HANDLED;
-}
-#endif
 
 /*
  * Dispatch Nubus interrupts. We are called as a secondary dispatch by the
  * VIA2 dispatcher as a fast interrupt handler.
  */
 
-#ifdef CONFIG_GENERIC_HARDIRQS
 void via_nubus_irq(unsigned int irq, struct irq_desc *desc)
 {
 	int slot_irq;
@@ -545,43 +496,6 @@ void via_nubus_irq(unsigned int irq, struct irq_desc *desc)
 			events &= ~via2[vDirA];
 	} while (events);
 }
-#else
-irqreturn_t via_nubus_irq(int irq, void *dev_id)
-{
-	int slot_irq;
-	unsigned char slot_bit, events;
-
-	events = ~via2[gBufA] & 0x7F;
-	if (rbv_present)
-		events &= via2[rSIER];
-	else
-		events &= ~via2[vDirA];
-	if (!events)
-		return IRQ_NONE;
-
-	do {
-		slot_irq = IRQ_NUBUS_F;
-		slot_bit = 0x40;
-		do {
-			if (events & slot_bit) {
-				events &= ~slot_bit;
-				generic_handle_irq(slot_irq);
-			}
-			--slot_irq;
-			slot_bit >>= 1;
-		} while (events);
-
- 		/* clear the CA1 interrupt and make certain there's no more. */
-		via2[gIFR] = 0x02 | rbv_clear;
-		events = ~via2[gBufA] & 0x7F;
-		if (rbv_present)
-			events &= via2[rSIER];
-		else
-			events &= ~via2[vDirA];
-	} while (events);
-	return IRQ_HANDLED;
-}
-#endif
 
 /*
  * Register the interrupt dispatchers for VIA or RBV machines only.
@@ -589,7 +503,6 @@ irqreturn_t via_nubus_irq(int irq, void *dev_id)
 
 void __init via_register_interrupts(void)
 {
-#ifdef CONFIG_GENERIC_HARDIRQS
 	if (via_alt_mapping) {
 		/* software interrupt */
 		irq_set_chained_handler(IRQ_AUTO_1, via1_irq);
@@ -600,23 +513,6 @@ void __init via_register_interrupts(void)
 	}
 	irq_set_chained_handler(IRQ_AUTO_2, via2_irq);
 	irq_set_chained_handler(IRQ_MAC_NUBUS, via_nubus_irq);
-#else
-	if (via_alt_mapping) {
-		if (request_irq(IRQ_AUTO_1, via1_irq, 0, "software",
-				(void *)via1))
-			pr_err("Couldn't register %s interrupt\n", "software");
-		if (request_irq(IRQ_AUTO_6, via1_irq, 0, "via1", (void *)via1))
-			pr_err("Couldn't register %s interrupt\n", "via1");
-	} else {
-		if (request_irq(IRQ_AUTO_1, via1_irq, 0, "via1", (void *)via1))
-			pr_err("Couldn't register %s interrupt\n", "via1");
-	}
-	if (request_irq(IRQ_AUTO_2, via2_irq, 0, "via2", (void *)via2))
-		pr_err("Couldn't register %s interrupt\n", "via2");
-	if (request_irq(IRQ_MAC_NUBUS, via_nubus_irq, 0, "nubus",
-			(void *)via2))
-		pr_err("Couldn't register %s interrupt\n", "nubus");
-#endif
 }
 
 void via_irq_enable(int irq) {
diff --git a/arch/m68k/q40/q40ints.c b/arch/m68k/q40/q40ints.c
index f1e5288..2b88849 100644
--- a/arch/m68k/q40/q40ints.c
+++ b/arch/m68k/q40/q40ints.c
@@ -15,11 +15,7 @@
 #include <linux/kernel.h>
 #include <linux/errno.h>
 #include <linux/interrupt.h>
-#ifdef CONFIG_GENERIC_HARDIRQS
 #include <linux/irq.h>
-#else
-#include <asm/irq.h>
-#endif
 
 #include <asm/ptrace.h>
 #include <asm/system.h>
@@ -329,15 +325,3 @@ void q40_irq_disable(struct irq_data *data)
 			printk("disable_irq nesting count %d\n",mext_disabled);
 	}
 }
-
-#ifndef CONFIG_GENERIC_HARDIRQS
-unsigned long q40_probe_irq_on(void)
-{
-	printk("irq probing not working - reconfigure the driver to avoid this\n");
-	return -1;
-}
-int q40_probe_irq_off(unsigned long irqs)
-{
-	return -1;
-}
-#endif
diff --git a/arch/m68k/sun3/sun3ints.c b/arch/m68k/sun3/sun3ints.c
index 626b601..7eb3781 100644
--- a/arch/m68k/sun3/sun3ints.c
+++ b/arch/m68k/sun3/sun3ints.c
@@ -53,9 +53,6 @@ static irqreturn_t sun3_int7(int irq, void *dev_id)
 {
 	unsigned int cnt;
 
-#ifndef CONFIG_GENERIC_HARDIRQS
-	*sun3_intreg |=  (1 << irq);
-#endif
 	cnt = kstat_irqs_cpu(irq, 0);
 	if (!(cnt % 2000))
 		sun3_leds(led_pattern[cnt % 16000 / 2000]);
@@ -69,9 +66,6 @@ static irqreturn_t sun3_int5(int irq, void *dev_id)
 #ifdef CONFIG_SUN3
 	intersil_clear();
 #endif
-#ifndef CONFIG_GENERIC_HARDIRQS
-        *sun3_intreg |=  (1 << irq);
-#endif
 #ifdef CONFIG_SUN3
 	intersil_clear();
 #endif
@@ -89,15 +83,6 @@ static irqreturn_t sun3_vec255(int irq, void *dev_id)
 	return IRQ_HANDLED;
 }
 
-#ifndef CONFIG_GENERIC_HARDIRQS
-static void sun3_inthandle(unsigned int irq, struct pt_regs *fp)
-{
-        *sun3_intreg &= ~(1 << irq);
-
-	do_IRQ(irq, fp);
-}
-#endif
-
 static void sun3_irq_enable(struct irq_data *data)
 {
     sun3_enable_irq(data->irq);
@@ -114,19 +99,14 @@ static struct irq_chip sun3_irq_chip = {
 	.irq_shutdown	= m68k_irq_shutdown,
 	.irq_enable	= sun3_irq_enable,
 	.irq_disable	= sun3_irq_disable,
-#ifdef CONFIG_GENERIC_HARDIRQS
 	.irq_mask	= sun3_irq_disable,
 	.irq_unmask	= sun3_irq_enable,
-#endif
 };
 
 void __init sun3_init_IRQ(void)
 {
 	*sun3_intreg = 1;
 
-#ifndef CONFIG_GENERIC_HARDIRQS
-	m68k_setup_auto_interrupt(sun3_inthandle);
-#endif
 	m68k_setup_irq_controller(&sun3_irq_chip, handle_level_irq, IRQ_AUTO_1,
 				  7);
 	m68k_setup_user_interrupt(VEC_USER, 128, NULL);
-- 
1.7.0.4

