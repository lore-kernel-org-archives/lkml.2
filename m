Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934091Ab1J3Mvf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Oct 2011 08:51:35 -0400
Received: from georges.telenet-ops.be ([195.130.137.68]:43175 "EHLO
	georges.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933295Ab1J3Mst (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Oct 2011 08:48:49 -0400
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: linux-m68k@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Greg Ungerer <gerg@uclinux.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH 02/27] m68k/irq: Rename irq_controller to irq_chip
Date: Sun, 30 Oct 2011 13:48:10 +0100
Message-Id: <1319978915-10933-3-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1319978915-10933-1-git-send-email-geert@linux-m68k.org>
References: <1319978915-10933-1-git-send-email-geert@linux-m68k.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make it more similar to the genirq version:
  - Remove lock (unused as we don't do SMP anyway),
  - Prepend methods with irq_,
  - Make irq_startup() return unsigned int.

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
Acked-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/m68k/amiga/amiints.c   |    9 ++--
 arch/m68k/amiga/cia.c       |   18 ++++-----
 arch/m68k/apollo/dn_ints.c  |   11 ++---
 arch/m68k/atari/ataints.c   |   15 +++----
 arch/m68k/include/asm/irq.h |   15 +++----
 arch/m68k/kernel/ints.c     |   86 +++++++++++++++++++++----------------------
 arch/m68k/mac/macints.c     |    9 ++--
 arch/m68k/q40/q40ints.c     |   17 ++++----
 arch/m68k/sun3/sun3ints.c   |   13 +++---
 9 files changed, 91 insertions(+), 102 deletions(-)

diff --git a/arch/m68k/amiga/amiints.c b/arch/m68k/amiga/amiints.c
index c5b5212..320c5d0 100644
--- a/arch/m68k/amiga/amiints.c
+++ b/arch/m68k/amiga/amiints.c
@@ -52,11 +52,10 @@ static irqreturn_t ami_int3(int irq, void *dev_id);
 static irqreturn_t ami_int4(int irq, void *dev_id);
 static irqreturn_t ami_int5(int irq, void *dev_id);
 
-static struct irq_controller amiga_irq_controller = {
+static struct irq_chip amiga_irq_chip = {
 	.name		= "amiga",
-	.lock		= __SPIN_LOCK_UNLOCKED(amiga_irq_controller.lock),
-	.enable		= amiga_enable_irq,
-	.disable	= amiga_disable_irq,
+	.irq_enable	= amiga_enable_irq,
+	.irq_disable	= amiga_disable_irq,
 };
 
 /*
@@ -81,7 +80,7 @@ void __init amiga_init_IRQ(void)
 	if (request_irq(IRQ_AUTO_5, ami_int5, 0, "int5", NULL))
 		pr_err("Couldn't register int%d\n", 5);
 
-	m68k_setup_irq_controller(&amiga_irq_controller, IRQ_USER, AMI_STD_IRQS);
+	m68k_setup_irq_chip(&amiga_irq_chip, IRQ_USER, AMI_STD_IRQS);
 
 	/* turn off PCMCIA interrupts */
 	if (AMIGAHW_PRESENT(PCMCIA))
diff --git a/arch/m68k/amiga/cia.c b/arch/m68k/amiga/cia.c
index ecd0f7c..637ef53 100644
--- a/arch/m68k/amiga/cia.c
+++ b/arch/m68k/amiga/cia.c
@@ -121,11 +121,10 @@ static void cia_disable_irq(unsigned int irq)
 		cia_able_irq(&ciaa_base, 1 << (irq - IRQ_AMIGA_CIAA));
 }
 
-static struct irq_controller cia_irq_controller = {
+static struct irq_chip cia_irq_chip = {
 	.name		= "cia",
-	.lock		= __SPIN_LOCK_UNLOCKED(cia_irq_controller.lock),
-	.enable		= cia_enable_irq,
-	.disable	= cia_disable_irq,
+	.irq_enable	= cia_enable_irq,
+	.irq_disable	= cia_disable_irq,
 };
 
 /*
@@ -158,23 +157,22 @@ static void auto_disable_irq(unsigned int irq)
 	}
 }
 
-static struct irq_controller auto_irq_controller = {
+static struct irq_chip auto_irq_chip = {
 	.name		= "auto",
-	.lock		= __SPIN_LOCK_UNLOCKED(auto_irq_controller.lock),
-	.enable		= auto_enable_irq,
-	.disable	= auto_disable_irq,
+	.irq_enable	= auto_enable_irq,
+	.irq_disable	= auto_disable_irq,
 };
 
 void __init cia_init_IRQ(struct ciabase *base)
 {
-	m68k_setup_irq_controller(&cia_irq_controller, base->cia_irq, CIA_IRQS);
+	m68k_setup_irq_chip(&cia_irq_chip, base->cia_irq, CIA_IRQS);
 
 	/* clear any pending interrupt and turn off all interrupts */
 	cia_set_irq(base, CIA_ICR_ALL);
 	cia_able_irq(base, CIA_ICR_ALL);
 
 	/* override auto int and install CIA handler */
-	m68k_setup_irq_controller(&auto_irq_controller, base->handler_irq, 1);
+	m68k_setup_irq_chip(&auto_irq_chip, base->handler_irq, 1);
 	m68k_irq_startup(base->handler_irq);
 	if (request_irq(base->handler_irq, cia_handler, IRQF_SHARED,
 			base->name, base))
diff --git a/arch/m68k/apollo/dn_ints.c b/arch/m68k/apollo/dn_ints.c
index 5d47f3a..d6e8f33 100644
--- a/arch/m68k/apollo/dn_ints.c
+++ b/arch/m68k/apollo/dn_ints.c
@@ -12,7 +12,7 @@ void dn_process_int(unsigned int irq, struct pt_regs *fp)
 	*(volatile unsigned char *)(picb)=0x20;
 }
 
-int apollo_irq_startup(unsigned int irq)
+unsigned int apollo_irq_startup(unsigned int irq)
 {
 	if (irq < 8)
 		*(volatile unsigned char *)(pica+1) &= ~(1 << irq);
@@ -29,16 +29,15 @@ void apollo_irq_shutdown(unsigned int irq)
 		*(volatile unsigned char *)(picb+1) |= (1 << (irq - 8));
 }
 
-static struct irq_controller apollo_irq_controller = {
+static struct irq_chip apollo_irq_chip = {
 	.name           = "apollo",
-	.lock           = __SPIN_LOCK_UNLOCKED(apollo_irq_controller.lock),
-	.startup        = apollo_irq_startup,
-	.shutdown       = apollo_irq_shutdown,
+	.irq_startup    = apollo_irq_startup,
+	.irq_shutdown   = apollo_irq_shutdown,
 };
 
 
 void __init dn_init_IRQ(void)
 {
 	m68k_setup_user_interrupt(VEC_USER + 96, 16, dn_process_int);
-	m68k_setup_irq_controller(&apollo_irq_controller, IRQ_APOLLO, 16);
+	m68k_setup_irq_chip(&apollo_irq_chip, IRQ_APOLLO, 16);
 }
diff --git a/arch/m68k/atari/ataints.c b/arch/m68k/atari/ataints.c
index 26a804e..ac0ebdf 100644
--- a/arch/m68k/atari/ataints.c
+++ b/arch/m68k/atari/ataints.c
@@ -320,7 +320,7 @@ extern void atari_microwire_cmd(int cmd);
 
 extern int atari_SCC_reset_done;
 
-static int atari_startup_irq(unsigned int irq)
+static unsigned int atari_startup_irq(unsigned int irq)
 {
 	m68k_irq_startup(irq);
 	atari_turnon_irq(irq);
@@ -338,13 +338,12 @@ static void atari_shutdown_irq(unsigned int irq)
 	    vectors[VEC_INT4] = falcon_hblhandler;
 }
 
-static struct irq_controller atari_irq_controller = {
+static struct irq_chip atari_irq_chip = {
 	.name		= "atari",
-	.lock		= __SPIN_LOCK_UNLOCKED(atari_irq_controller.lock),
-	.startup	= atari_startup_irq,
-	.shutdown	= atari_shutdown_irq,
-	.enable		= atari_enable_irq,
-	.disable	= atari_disable_irq,
+	.irq_startup	= atari_startup_irq,
+	.irq_shutdown	= atari_shutdown_irq,
+	.irq_enable	= atari_enable_irq,
+	.irq_disable	= atari_disable_irq,
 };
 
 /*
@@ -361,7 +360,7 @@ static struct irq_controller atari_irq_controller = {
 void __init atari_init_IRQ(void)
 {
 	m68k_setup_user_interrupt(VEC_USER, NUM_ATARI_SOURCES - IRQ_USER, NULL);
-	m68k_setup_irq_controller(&atari_irq_controller, 1, NUM_ATARI_SOURCES - 1);
+	m68k_setup_irq_chip(&atari_irq_chip, 1, NUM_ATARI_SOURCES - 1);
 
 	/* Initialize the MFP(s) */
 
diff --git a/arch/m68k/include/asm/irq.h b/arch/m68k/include/asm/irq.h
index 69ed0d7..d8c6f68 100644
--- a/arch/m68k/include/asm/irq.h
+++ b/arch/m68k/include/asm/irq.h
@@ -93,16 +93,15 @@ struct irq_handler {
 	const char	*devname;
 };
 
-struct irq_controller {
+struct irq_chip {
 	const char *name;
-	spinlock_t lock;
-	int (*startup)(unsigned int irq);
-	void (*shutdown)(unsigned int irq);
-	void (*enable)(unsigned int irq);
-	void (*disable)(unsigned int irq);
+	unsigned int (*irq_startup)(unsigned int irq);
+	void (*irq_shutdown)(unsigned int irq);
+	void (*irq_enable)(unsigned int irq);
+	void (*irq_disable)(unsigned int irq);
 };
 
-extern int m68k_irq_startup(unsigned int);
+extern unsigned int m68k_irq_startup(unsigned int);
 extern void m68k_irq_shutdown(unsigned int);
 
 /*
@@ -113,7 +112,7 @@ extern irq_node_t *new_irq_node(void);
 extern void m68k_setup_auto_interrupt(void (*handler)(unsigned int, struct pt_regs *));
 extern void m68k_setup_user_interrupt(unsigned int vec, unsigned int cnt,
 				      void (*handler)(unsigned int, struct pt_regs *));
-extern void m68k_setup_irq_controller(struct irq_controller *, unsigned int, unsigned int);
+extern void m68k_setup_irq_chip(struct irq_chip *, unsigned int, unsigned int);
 
 asmlinkage void m68k_handle_int(unsigned int);
 asmlinkage void __m68k_handle_int(unsigned int, struct pt_regs *);
diff --git a/arch/m68k/kernel/ints.c b/arch/m68k/kernel/ints.c
index 761ee04..f43ad7b 100644
--- a/arch/m68k/kernel/ints.c
+++ b/arch/m68k/kernel/ints.c
@@ -52,23 +52,21 @@ extern u16 user_irqvec_fixup[];
 
 /* table for system interrupt handlers */
 static struct irq_node *irq_list[NR_IRQS];
-static struct irq_controller *irq_controller[NR_IRQS];
+static struct irq_chip *irq_chip[NR_IRQS];
 static int irq_depth[NR_IRQS];
 
 static int m68k_first_user_vec;
 
-static struct irq_controller auto_irq_controller = {
+static struct irq_chip auto_irq_chip = {
 	.name		= "auto",
-	.lock		= __SPIN_LOCK_UNLOCKED(auto_irq_controller.lock),
-	.startup	= m68k_irq_startup,
-	.shutdown	= m68k_irq_shutdown,
+	.irq_startup	= m68k_irq_startup,
+	.irq_shutdown	= m68k_irq_shutdown,
 };
 
-static struct irq_controller user_irq_controller = {
+static struct irq_chip user_irq_chip = {
 	.name		= "user",
-	.lock		= __SPIN_LOCK_UNLOCKED(user_irq_controller.lock),
-	.startup	= m68k_irq_startup,
-	.shutdown	= m68k_irq_shutdown,
+	.irq_startup	= m68k_irq_startup,
+	.irq_shutdown	= m68k_irq_shutdown,
 };
 
 #define NUM_IRQ_NODES 100
@@ -96,7 +94,7 @@ void __init init_IRQ(void)
 	}
 
 	for (i = IRQ_AUTO_1; i <= IRQ_AUTO_7; i++)
-		irq_controller[i] = &auto_irq_controller;
+		irq_chip[i] = &auto_irq_chip;
 
 	mach_init_IRQ();
 }
@@ -136,7 +134,7 @@ void __init m68k_setup_user_interrupt(unsigned int vec, unsigned int cnt,
 	BUG_ON(IRQ_USER + cnt > NR_IRQS);
 	m68k_first_user_vec = vec;
 	for (i = 0; i < cnt; i++)
-		irq_controller[IRQ_USER + i] = &user_irq_controller;
+		irq_chip[IRQ_USER + i] = &user_irq_chip;
 	*user_irqvec_fixup = vec - IRQ_USER;
 	if (handler)
 		*user_irqhandler_fixup = (u32)handler;
@@ -144,7 +142,7 @@ void __init m68k_setup_user_interrupt(unsigned int vec, unsigned int cnt,
 }
 
 /**
- * m68k_setup_irq_controller
+ * m68k_setup_irq_chip
  * @contr: irq controller which controls specified irq
  * @irq: first irq to be managed by the controller
  *
@@ -153,13 +151,13 @@ void __init m68k_setup_user_interrupt(unsigned int vec, unsigned int cnt,
  * be changed as well, but the controller probably should use m68k_irq_startup/
  * m68k_irq_shutdown.
  */
-void m68k_setup_irq_controller(struct irq_controller *contr, unsigned int irq,
+void m68k_setup_irq_chip(struct irq_chip *contr, unsigned int irq,
 			       unsigned int cnt)
 {
 	int i;
 
 	for (i = 0; i < cnt; i++)
-		irq_controller[irq + i] = contr;
+		irq_chip[irq + i] = contr;
 }
 
 irq_node_t *new_irq_node(void)
@@ -180,23 +178,23 @@ irq_node_t *new_irq_node(void)
 
 int setup_irq(unsigned int irq, struct irq_node *node)
 {
-	struct irq_controller *contr;
+	struct irq_chip *contr;
 	struct irq_node **prev;
 	unsigned long flags;
 
-	if (irq >= NR_IRQS || !(contr = irq_controller[irq])) {
+	if (irq >= NR_IRQS || !(contr = irq_chip[irq])) {
 		printk("%s: Incorrect IRQ %d from %s\n",
 		       __func__, irq, node->devname);
 		return -ENXIO;
 	}
 
-	spin_lock_irqsave(&contr->lock, flags);
+	local_irq_save(flags);
 
 	prev = irq_list + irq;
 	if (*prev) {
 		/* Can't share interrupts unless both agree to */
 		if (!((*prev)->flags & node->flags & IRQF_SHARED)) {
-			spin_unlock_irqrestore(&contr->lock, flags);
+			local_irq_restore(flags);
 			return -EBUSY;
 		}
 		while (*prev)
@@ -204,15 +202,15 @@ int setup_irq(unsigned int irq, struct irq_node *node)
 	}
 
 	if (!irq_list[irq]) {
-		if (contr->startup)
-			contr->startup(irq);
+		if (contr->irq_startup)
+			contr->irq_startup(irq);
 		else
-			contr->enable(irq);
+			contr->irq_enable(irq);
 	}
 	node->next = NULL;
 	*prev = node;
 
-	spin_unlock_irqrestore(&contr->lock, flags);
+	local_irq_restore(flags);
 
 	return 0;
 }
@@ -244,16 +242,16 @@ EXPORT_SYMBOL(request_irq);
 
 void free_irq(unsigned int irq, void *dev_id)
 {
-	struct irq_controller *contr;
+	struct irq_chip *contr;
 	struct irq_node **p, *node;
 	unsigned long flags;
 
-	if (irq >= NR_IRQS || !(contr = irq_controller[irq])) {
+	if (irq >= NR_IRQS || !(contr = irq_chip[irq])) {
 		printk("%s: Incorrect IRQ %d\n", __func__, irq);
 		return;
 	}
 
-	spin_lock_irqsave(&contr->lock, flags);
+	local_irq_save(flags);
 
 	p = irq_list + irq;
 	while ((node = *p)) {
@@ -270,58 +268,58 @@ void free_irq(unsigned int irq, void *dev_id)
 		       __func__, irq);
 
 	if (!irq_list[irq]) {
-		if (contr->shutdown)
-			contr->shutdown(irq);
+		if (contr->irq_shutdown)
+			contr->irq_shutdown(irq);
 		else
-			contr->disable(irq);
+			contr->irq_disable(irq);
 	}
 
-	spin_unlock_irqrestore(&contr->lock, flags);
+	local_irq_restore(flags);
 }
 
 EXPORT_SYMBOL(free_irq);
 
 void enable_irq(unsigned int irq)
 {
-	struct irq_controller *contr;
+	struct irq_chip *contr;
 	unsigned long flags;
 
-	if (irq >= NR_IRQS || !(contr = irq_controller[irq])) {
+	if (irq >= NR_IRQS || !(contr = irq_chip[irq])) {
 		printk("%s: Incorrect IRQ %d\n",
 		       __func__, irq);
 		return;
 	}
 
-	spin_lock_irqsave(&contr->lock, flags);
+	local_irq_save(flags);
 	if (irq_depth[irq]) {
 		if (!--irq_depth[irq]) {
-			if (contr->enable)
-				contr->enable(irq);
+			if (contr->irq_enable)
+				contr->irq_enable(irq);
 		}
 	} else
 		WARN_ON(1);
-	spin_unlock_irqrestore(&contr->lock, flags);
+	local_irq_restore(flags);
 }
 
 EXPORT_SYMBOL(enable_irq);
 
 void disable_irq(unsigned int irq)
 {
-	struct irq_controller *contr;
+	struct irq_chip *contr;
 	unsigned long flags;
 
-	if (irq >= NR_IRQS || !(contr = irq_controller[irq])) {
+	if (irq >= NR_IRQS || !(contr = irq_chip[irq])) {
 		printk("%s: Incorrect IRQ %d\n",
 		       __func__, irq);
 		return;
 	}
 
-	spin_lock_irqsave(&contr->lock, flags);
+	local_irq_save(flags);
 	if (!irq_depth[irq]++) {
-		if (contr->disable)
-			contr->disable(irq);
+		if (contr->irq_disable)
+			contr->irq_disable(irq);
 	}
-	spin_unlock_irqrestore(&contr->lock, flags);
+	local_irq_restore(flags);
 }
 
 EXPORT_SYMBOL(disable_irq);
@@ -330,7 +328,7 @@ void disable_irq_nosync(unsigned int irq) __attribute__((alias("disable_irq")));
 
 EXPORT_SYMBOL(disable_irq_nosync);
 
-int m68k_irq_startup(unsigned int irq)
+unsigned int m68k_irq_startup(unsigned int irq)
 {
 	if (irq <= IRQ_AUTO_7)
 		vectors[VEC_SPUR + irq] = auto_inthandler;
@@ -413,13 +411,13 @@ asmlinkage void handle_badint(struct pt_regs *regs)
 
 int show_interrupts(struct seq_file *p, void *v)
 {
-	struct irq_controller *contr;
+	struct irq_chip *contr;
 	struct irq_node *node;
 	int i = *(loff_t *) v;
 
 	/* autovector interrupts */
 	if (irq_list[i]) {
-		contr = irq_controller[i];
+		contr = irq_chip[i];
 		node = irq_list[i];
 		seq_printf(p, "%-8s %3u: %10u %s", contr->name, i, kstat_cpu(0).irqs[i], node->devname);
 		while ((node = node->next))
diff --git a/arch/m68k/mac/macints.c b/arch/m68k/mac/macints.c
index f92190c..ffa1b3f 100644
--- a/arch/m68k/mac/macints.c
+++ b/arch/m68k/mac/macints.c
@@ -193,11 +193,10 @@ irqreturn_t mac_debug_handler(int, void *);
 void mac_enable_irq(unsigned int irq);
 void mac_disable_irq(unsigned int irq);
 
-static struct irq_controller mac_irq_controller = {
+static struct irq_chip mac_irq_chip = {
 	.name		= "mac",
-	.lock		= __SPIN_LOCK_UNLOCKED(mac_irq_controller.lock),
-	.enable		= mac_enable_irq,
-	.disable	= mac_disable_irq,
+	.irq_enable	= mac_enable_irq,
+	.irq_disable	= mac_disable_irq,
 };
 
 void __init mac_init_IRQ(void)
@@ -205,7 +204,7 @@ void __init mac_init_IRQ(void)
 #ifdef DEBUG_MACINTS
 	printk("mac_init_IRQ(): Setting things up...\n");
 #endif
-	m68k_setup_irq_controller(&mac_irq_controller, IRQ_USER,
+	m68k_setup_irq_chip(&mac_irq_chip, IRQ_USER,
 				  NUM_MAC_SOURCES - IRQ_USER);
 	/* Make sure the SONIC interrupt is cleared or things get ugly */
 #ifdef SHUTUP_SONIC
diff --git a/arch/m68k/q40/q40ints.c b/arch/m68k/q40/q40ints.c
index 9f0e3d5..fa05a03 100644
--- a/arch/m68k/q40/q40ints.c
+++ b/arch/m68k/q40/q40ints.c
@@ -41,14 +41,14 @@ static void q40_disable_irq(unsigned int);
 unsigned short q40_ablecount[35];
 unsigned short q40_state[35];
 
-static int q40_irq_startup(unsigned int irq)
+static unsigned int q40_irq_startup(unsigned int irq)
 {
 	/* test for ISA ints not implemented by HW */
 	switch (irq) {
 	case 1: case 2: case 8: case 9:
 	case 11: case 12: case 13:
 		printk("%s: ISA IRQ %d not implemented by HW\n", __func__, irq);
-		return -ENXIO;
+		/* FIXME return -ENXIO; */
 	}
 	return 0;
 }
@@ -57,13 +57,12 @@ static void q40_irq_shutdown(unsigned int irq)
 {
 }
 
-static struct irq_controller q40_irq_controller = {
+static struct irq_chip q40_irq_chip = {
 	.name		= "q40",
-	.lock		= __SPIN_LOCK_UNLOCKED(q40_irq_controller.lock),
-	.startup	= q40_irq_startup,
-	.shutdown	= q40_irq_shutdown,
-	.enable		= q40_enable_irq,
-	.disable	= q40_disable_irq,
+	.irq_startup	= q40_irq_startup,
+	.irq_shutdown	= q40_irq_shutdown,
+	.irq_enable	= q40_enable_irq,
+	.irq_disable	= q40_disable_irq,
 };
 
 /*
@@ -81,7 +80,7 @@ static int disabled;
 
 void __init q40_init_IRQ(void)
 {
-	m68k_setup_irq_controller(&q40_irq_controller, 1, Q40_IRQ_MAX);
+	m68k_setup_irq_chip(&q40_irq_chip, 1, Q40_IRQ_MAX);
 
 	/* setup handler for ISA ints */
 	m68k_setup_auto_interrupt(q40_irq_handler);
diff --git a/arch/m68k/sun3/sun3ints.c b/arch/m68k/sun3/sun3ints.c
index 6464ad3..97fa9ed 100644
--- a/arch/m68k/sun3/sun3ints.c
+++ b/arch/m68k/sun3/sun3ints.c
@@ -86,13 +86,12 @@ static void sun3_inthandle(unsigned int irq, struct pt_regs *fp)
 	__m68k_handle_int(irq, fp);
 }
 
-static struct irq_controller sun3_irq_controller = {
+static struct irq_chip sun3_irq_chip = {
 	.name		= "sun3",
-	.lock		= __SPIN_LOCK_UNLOCKED(sun3_irq_controller.lock),
-	.startup	= m68k_irq_startup,
-	.shutdown	= m68k_irq_shutdown,
-	.enable		= sun3_enable_irq,
-	.disable	= sun3_disable_irq,
+	.irq_startup	= m68k_irq_startup,
+	.irq_shutdown	= m68k_irq_shutdown,
+	.irq_enable	= sun3_enable_irq,
+	.irq_disable	= sun3_disable_irq,
 };
 
 void __init sun3_init_IRQ(void)
@@ -100,7 +99,7 @@ void __init sun3_init_IRQ(void)
 	*sun3_intreg = 1;
 
 	m68k_setup_auto_interrupt(sun3_inthandle);
-	m68k_setup_irq_controller(&sun3_irq_controller, IRQ_AUTO_1, 7);
+	m68k_setup_irq_chip(&sun3_irq_chip, IRQ_AUTO_1, 7);
 	m68k_setup_user_interrupt(VEC_USER, 128, NULL);
 
 	if (request_irq(IRQ_AUTO_5, sun3_int5, 0, "int5", NULL))
-- 
1.7.0.4

