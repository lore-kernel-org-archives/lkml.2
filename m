Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754412Ab1C0Uew (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Mar 2011 16:34:52 -0400
Received: from www.linutronix.de ([62.245.132.108]:33286 "EHLO linutronix.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754239Ab1C0Uev (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Mar 2011 16:34:51 -0400
Date: Sun, 27 Mar 2011 22:34:47 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>
Subject: [GIT pull] irq cleanups for .39
Message-ID: <alpine.LFD.2.00.1103272230440.31464@localhost6.localdomain6>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest irq-cleanup-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git irq-cleanup-for-linus

All acked by the relevant maintainers.

Thanks,

	tglx

------------------>
Thomas Gleixner (3):
      dma: Ipu: Convert interupt code
      tile: Convert to new irq function names
      tile: Use generic show_interupts()


 arch/tile/Kconfig         |    1 +
 arch/tile/kernel/irq.c    |   45 +---------------------------------
 drivers/dma/ipu/ipu_irq.c |   58 ++++++++++++++++++++++----------------------
 3 files changed, 32 insertions(+), 72 deletions(-)

diff --git a/arch/tile/Kconfig b/arch/tile/Kconfig
index f3b7870..5e34a9f 100644
--- a/arch/tile/Kconfig
+++ b/arch/tile/Kconfig
@@ -12,6 +12,7 @@ config TILE
 	select GENERIC_IRQ_PROBE
 	select GENERIC_PENDING_IRQ if SMP
 	select GENERIC_HARDIRQS_NO_DEPRECATED
+	select GENERIC_IRQ_SHOW
 
 # FIXME: investigate whether we need/want these options.
 #	select HAVE_IOREMAP_PROT
diff --git a/arch/tile/kernel/irq.c b/arch/tile/kernel/irq.c
index 0baa758..aa0134d 100644
--- a/arch/tile/kernel/irq.c
+++ b/arch/tile/kernel/irq.c
@@ -241,14 +241,14 @@ void tile_irq_activate(unsigned int irq, int tile_irq_type)
 	irq_flow_handler_t handle = handle_level_irq;
 	if (tile_irq_type == TILE_IRQ_PERCPU)
 		handle = handle_percpu_irq;
-	set_irq_chip_and_handler(irq, &tile_irq_chip, handle);
+	irq_set_chip_and_handler(irq, &tile_irq_chip, handle);
 
 	/*
 	 * Flag interrupts that are hardware-cleared so that ack()
 	 * won't clear them.
 	 */
 	if (tile_irq_type == TILE_IRQ_HW_CLEAR)
-		set_irq_chip_data(irq, (void *)IS_HW_CLEARED);
+		irq_set_chip_data(irq, (void *)IS_HW_CLEARED);
 }
 EXPORT_SYMBOL(tile_irq_activate);
 
@@ -262,47 +262,6 @@ void ack_bad_irq(unsigned int irq)
  * Generic, controller-independent functions:
  */
 
-int show_interrupts(struct seq_file *p, void *v)
-{
-	int i = *(loff_t *) v, j;
-	struct irqaction *action;
-	unsigned long flags;
-
-	if (i == 0) {
-		seq_printf(p, "           ");
-		for (j = 0; j < NR_CPUS; j++)
-			if (cpu_online(j))
-				seq_printf(p, "CPU%-8d", j);
-		seq_putc(p, '\n');
-	}
-
-	if (i < NR_IRQS) {
-		struct irq_desc *desc = irq_to_desc(i);
-
-		raw_spin_lock_irqsave(&desc->lock, flags);
-		action = desc->action;
-		if (!action)
-			goto skip;
-		seq_printf(p, "%3d: ", i);
-#ifndef CONFIG_SMP
-		seq_printf(p, "%10u ", kstat_irqs(i));
-#else
-		for_each_online_cpu(j)
-			seq_printf(p, "%10u ", kstat_irqs_cpu(i, j));
-#endif
-		seq_printf(p, " %14s", get_irq_desc_chip(desc)->name);
-		seq_printf(p, "  %s", action->name);
-
-		for (action = action->next; action; action = action->next)
-			seq_printf(p, ", %s", action->name);
-
-		seq_putc(p, '\n');
-skip:
-		raw_spin_unlock_irqrestore(&desc->lock, flags);
-	}
-	return 0;
-}
-
 #if CHIP_HAS_IPI()
 int create_irq(void)
 {
diff --git a/drivers/dma/ipu/ipu_irq.c b/drivers/dma/ipu/ipu_irq.c
index dd8ebc7..ab8a4ef 100644
--- a/drivers/dma/ipu/ipu_irq.c
+++ b/drivers/dma/ipu/ipu_irq.c
@@ -94,9 +94,9 @@ static struct ipu_irq_map *src2map(unsigned int src)
 	return NULL;
 }
 
-static void ipu_irq_unmask(unsigned int irq)
+static void ipu_irq_unmask(struct irq_data *d)
 {
-	struct ipu_irq_map *map = get_irq_chip_data(irq);
+	struct ipu_irq_map *map = irq_data_get_irq_chip_data(d);
 	struct ipu_irq_bank *bank;
 	uint32_t reg;
 	unsigned long lock_flags;
@@ -106,7 +106,7 @@ static void ipu_irq_unmask(unsigned int irq)
 	bank = map->bank;
 	if (!bank) {
 		spin_unlock_irqrestore(&bank_lock, lock_flags);
-		pr_err("IPU: %s(%u) - unmapped!\n", __func__, irq);
+		pr_err("IPU: %s(%u) - unmapped!\n", __func__, d->irq);
 		return;
 	}
 
@@ -117,9 +117,9 @@ static void ipu_irq_unmask(unsigned int irq)
 	spin_unlock_irqrestore(&bank_lock, lock_flags);
 }
 
-static void ipu_irq_mask(unsigned int irq)
+static void ipu_irq_mask(struct irq_data *d)
 {
-	struct ipu_irq_map *map = get_irq_chip_data(irq);
+	struct ipu_irq_map *map = irq_data_get_irq_chip_data(d);
 	struct ipu_irq_bank *bank;
 	uint32_t reg;
 	unsigned long lock_flags;
@@ -129,7 +129,7 @@ static void ipu_irq_mask(unsigned int irq)
 	bank = map->bank;
 	if (!bank) {
 		spin_unlock_irqrestore(&bank_lock, lock_flags);
-		pr_err("IPU: %s(%u) - unmapped!\n", __func__, irq);
+		pr_err("IPU: %s(%u) - unmapped!\n", __func__, d->irq);
 		return;
 	}
 
@@ -140,9 +140,9 @@ static void ipu_irq_mask(unsigned int irq)
 	spin_unlock_irqrestore(&bank_lock, lock_flags);
 }
 
-static void ipu_irq_ack(unsigned int irq)
+static void ipu_irq_ack(struct irq_data *d)
 {
-	struct ipu_irq_map *map = get_irq_chip_data(irq);
+	struct ipu_irq_map *map = irq_data_get_irq_chip_data(d);
 	struct ipu_irq_bank *bank;
 	unsigned long lock_flags;
 
@@ -151,7 +151,7 @@ static void ipu_irq_ack(unsigned int irq)
 	bank = map->bank;
 	if (!bank) {
 		spin_unlock_irqrestore(&bank_lock, lock_flags);
-		pr_err("IPU: %s(%u) - unmapped!\n", __func__, irq);
+		pr_err("IPU: %s(%u) - unmapped!\n", __func__, d->irq);
 		return;
 	}
 
@@ -167,7 +167,7 @@ static void ipu_irq_ack(unsigned int irq)
  */
 bool ipu_irq_status(unsigned int irq)
 {
-	struct ipu_irq_map *map = get_irq_chip_data(irq);
+	struct ipu_irq_map *map = irq_get_chip_data(irq);
 	struct ipu_irq_bank *bank;
 	unsigned long lock_flags;
 	bool ret;
@@ -269,7 +269,7 @@ int ipu_irq_unmap(unsigned int source)
 /* Chained IRQ handler for IPU error interrupt */
 static void ipu_irq_err(unsigned int irq, struct irq_desc *desc)
 {
-	struct ipu *ipu = get_irq_data(irq);
+	struct ipu *ipu = irq_get_handler_data(irq);
 	u32 status;
 	int i, line;
 
@@ -310,7 +310,7 @@ static void ipu_irq_err(unsigned int irq, struct irq_desc *desc)
 /* Chained IRQ handler for IPU function interrupt */
 static void ipu_irq_fn(unsigned int irq, struct irq_desc *desc)
 {
-	struct ipu *ipu = get_irq_data(irq);
+	struct ipu *ipu = irq_desc_get_handler_data(desc);
 	u32 status;
 	int i, line;
 
@@ -345,10 +345,10 @@ static void ipu_irq_fn(unsigned int irq, struct irq_desc *desc)
 }
 
 static struct irq_chip ipu_irq_chip = {
-	.name	= "ipu_irq",
-	.ack	= ipu_irq_ack,
-	.mask	= ipu_irq_mask,
-	.unmask	= ipu_irq_unmask,
+	.name		= "ipu_irq",
+	.irq_ack	= ipu_irq_ack,
+	.irq_mask	= ipu_irq_mask,
+	.irq_unmask	= ipu_irq_unmask,
 };
 
 /* Install the IRQ handler */
@@ -366,26 +366,26 @@ int __init ipu_irq_attach_irq(struct ipu *ipu, struct platform_device *dev)
 		int ret;
 
 		irq = irq_base + i;
-		ret = set_irq_chip(irq, &ipu_irq_chip);
+		ret = irq_set_chip(irq, &ipu_irq_chip);
 		if (ret < 0)
 			return ret;
-		ret = set_irq_chip_data(irq, irq_map + i);
+		ret = irq_set_chip_data(irq, irq_map + i);
 		if (ret < 0)
 			return ret;
 		irq_map[i].ipu = ipu;
 		irq_map[i].irq = irq;
 		irq_map[i].source = -EINVAL;
-		set_irq_handler(irq, handle_level_irq);
+		irq_set_handler(irq, handle_level_irq);
 #ifdef CONFIG_ARM
 		set_irq_flags(irq, IRQF_VALID | IRQF_PROBE);
 #endif
 	}
 
-	set_irq_data(ipu->irq_fn, ipu);
-	set_irq_chained_handler(ipu->irq_fn, ipu_irq_fn);
+	irq_set_handler_data(ipu->irq_fn, ipu);
+	irq_set_chained_handler(ipu->irq_fn, ipu_irq_fn);
 
-	set_irq_data(ipu->irq_err, ipu);
-	set_irq_chained_handler(ipu->irq_err, ipu_irq_err);
+	irq_set_handler_data(ipu->irq_err, ipu);
+	irq_set_chained_handler(ipu->irq_err, ipu_irq_err);
 
 	return 0;
 }
@@ -397,17 +397,17 @@ void ipu_irq_detach_irq(struct ipu *ipu, struct platform_device *dev)
 
 	irq_base = pdata->irq_base;
 
-	set_irq_chained_handler(ipu->irq_fn, NULL);
-	set_irq_data(ipu->irq_fn, NULL);
+	irq_set_chained_handler(ipu->irq_fn, NULL);
+	irq_set_handler_data(ipu->irq_fn, NULL);
 
-	set_irq_chained_handler(ipu->irq_err, NULL);
-	set_irq_data(ipu->irq_err, NULL);
+	irq_set_chained_handler(ipu->irq_err, NULL);
+	irq_set_handler_data(ipu->irq_err, NULL);
 
 	for (irq = irq_base; irq < irq_base + CONFIG_MX3_IPU_IRQS; irq++) {
 #ifdef CONFIG_ARM
 		set_irq_flags(irq, 0);
 #endif
-		set_irq_chip(irq, NULL);
-		set_irq_chip_data(irq, NULL);
+		irq_set_chip(irq, NULL);
+		irq_set_chip_data(irq, NULL);
 	}
 }
