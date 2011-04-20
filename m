Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752652Ab1DTIpp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Apr 2011 04:45:45 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:59046 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752012Ab1DTIpm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Apr 2011 04:45:42 -0400
Subject: [PATCH] powerpc: stop exporting irq_map
To: benh@kernel.crashing.org, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org
From: Grant Likely <grant.likely@secretlab.ca>
Date: Wed, 20 Apr 2011 02:45:39 -0600
Message-ID: <20110420084449.23741.45580.stgit@ponder>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

First step in eliminating irq_map[] table entirely.  This patch makes the
irq_map[] table only accessible by arch/powerpc/kernel/irq.c

Signed-off-by: Grant Likely <grant.likely@secretlab.ca>
---
 arch/powerpc/include/asm/irq.h                   |   15 +---
 arch/powerpc/kernel/irq.c                        |   26 +++++++
 arch/powerpc/platforms/512x/mpc5121_ads_cpld.c   |    4 +
 arch/powerpc/platforms/52xx/media5200.c          |    4 +
 arch/powerpc/platforms/52xx/mpc52xx_pic.c        |   79 ++++------------------
 arch/powerpc/platforms/82xx/pq2ads-pci-pic.c     |    4 +
 arch/powerpc/platforms/85xx/socrates_fpga_pic.c  |   26 ++-----
 arch/powerpc/platforms/86xx/gef_pic.c            |   10 +--
 arch/powerpc/platforms/8xx/m8xx_setup.c          |    2 -
 arch/powerpc/platforms/cell/axon_msi.c           |    2 -
 arch/powerpc/platforms/cell/spider-pic.c         |   10 +--
 arch/powerpc/platforms/embedded6xx/flipper-pic.c |    8 +-
 arch/powerpc/platforms/embedded6xx/hlwd-pic.c    |    8 +-
 arch/powerpc/platforms/iseries/irq.c             |   10 +--
 arch/powerpc/platforms/powermac/pic.c            |   12 ++-
 arch/powerpc/platforms/pseries/ras.c             |    4 +
 arch/powerpc/platforms/pseries/xics.c            |   14 ++--
 arch/powerpc/sysdev/cpm1.c                       |    8 +-
 arch/powerpc/sysdev/cpm2_pic.c                   |   10 +--
 arch/powerpc/sysdev/ipic.c                       |   16 ++--
 arch/powerpc/sysdev/mpc8xx_pic.c                 |   10 +--
 arch/powerpc/sysdev/mpc8xxx_gpio.c               |   12 ++-
 arch/powerpc/sysdev/mpic.c                       |   28 ++++----
 arch/powerpc/sysdev/mv64x60_pic.c                |   14 ++--
 arch/powerpc/sysdev/qe_lib/qe_ic.c               |    6 +-
 arch/powerpc/sysdev/uic.c                        |   12 +--
 arch/powerpc/sysdev/xilinx_intc.c                |    8 +-
 27 files changed, 147 insertions(+), 215 deletions(-)

diff --git a/arch/powerpc/include/asm/irq.h b/arch/powerpc/include/asm/irq.h
index 67ab5fb..e1983d5 100644
--- a/arch/powerpc/include/asm/irq.h
+++ b/arch/powerpc/include/asm/irq.h
@@ -128,19 +128,10 @@ struct irq_host {
 	struct device_node	*of_node;
 };
 
-/* The main irq map itself is an array of NR_IRQ entries containing the
- * associate host and irq number. An entry with a host of NULL is free.
- * An entry can be allocated if it's free, the allocator always then sets
- * hwirq first to the host's invalid irq number and then fills ops.
- */
-struct irq_map_entry {
-	irq_hw_number_t	hwirq;
-	struct irq_host	*host;
-};
-
-extern struct irq_map_entry irq_map[NR_IRQS];
-
+struct irq_data;
+extern irq_hw_number_t irqd_to_hwirq(struct irq_data *d);
 extern irq_hw_number_t virq_to_hw(unsigned int virq);
+extern struct irq_host *virq_to_host(unsigned int virq);
 
 /**
  * irq_alloc_host - Allocate a new irq_host data structure
diff --git a/arch/powerpc/kernel/irq.c b/arch/powerpc/kernel/irq.c
index f621b7d..422672b 100644
--- a/arch/powerpc/kernel/irq.c
+++ b/arch/powerpc/kernel/irq.c
@@ -477,20 +477,42 @@ void do_softirq(void)
  * IRQ controller and virtual interrupts
  */
 
+/* The main irq map itself is an array of NR_IRQ entries containing the
+ * associate host and irq number. An entry with a host of NULL is free.
+ * An entry can be allocated if it's free, the allocator always then sets
+ * hwirq first to the host's invalid irq number and then fills ops.
+ */
+struct irq_map_entry {
+	irq_hw_number_t	hwirq;
+	struct irq_host	*host;
+};
+
 static LIST_HEAD(irq_hosts);
 static DEFINE_RAW_SPINLOCK(irq_big_lock);
 static unsigned int revmap_trees_allocated;
 static DEFINE_MUTEX(revmap_trees_mutex);
-struct irq_map_entry irq_map[NR_IRQS];
+static struct irq_map_entry irq_map[NR_IRQS];
 static unsigned int irq_virq_count = NR_IRQS;
 static struct irq_host *irq_default_host;
 
+irq_hw_number_t irqd_to_hwirq(struct irq_data *d)
+{
+	return irq_map[d->irq].hwirq;
+}
+EXPORT_SYMBOL_GPL(irqd_to_hwirq);
+
 irq_hw_number_t virq_to_hw(unsigned int virq)
 {
 	return irq_map[virq].hwirq;
 }
 EXPORT_SYMBOL_GPL(virq_to_hw);
 
+struct irq_host *virq_to_host(unsigned int virq)
+{
+	return irq_map[virq].host;
+}
+EXPORT_SYMBOL_GPL(virq_to_host);
+
 static int default_irq_host_match(struct irq_host *h, struct device_node *np)
 {
 	return h->of_node != NULL && h->of_node == np;
@@ -1098,7 +1120,7 @@ static int virq_debug_show(struct seq_file *m, void *private)
 			struct irq_chip *chip;
 
 			seq_printf(m, "%5d  ", i);
-			seq_printf(m, "0x%05lx  ", virq_to_hw(i));
+			seq_printf(m, "0x%05lx  ", irq_map[i].hwirq);
 
 			chip = irq_desc_get_chip(desc);
 			if (chip && chip->name)
diff --git a/arch/powerpc/platforms/512x/mpc5121_ads_cpld.c b/arch/powerpc/platforms/512x/mpc5121_ads_cpld.c
index cfc4b20..a8bc0d4 100644
--- a/arch/powerpc/platforms/512x/mpc5121_ads_cpld.c
+++ b/arch/powerpc/platforms/512x/mpc5121_ads_cpld.c
@@ -61,7 +61,7 @@ irq_to_pic_bit(unsigned int irq)
 static void
 cpld_mask_irq(struct irq_data *d)
 {
-	unsigned int cpld_irq = (unsigned int)irq_map[d->irq].hwirq;
+	unsigned int cpld_irq = (unsigned int)irqd_to_hwirq(d);
 	void __iomem *pic_mask = irq_to_pic_mask(cpld_irq);
 
 	out_8(pic_mask,
@@ -71,7 +71,7 @@ cpld_mask_irq(struct irq_data *d)
 static void
 cpld_unmask_irq(struct irq_data *d)
 {
-	unsigned int cpld_irq = (unsigned int)irq_map[d->irq].hwirq;
+	unsigned int cpld_irq = (unsigned int)irqd_to_hwirq(d);
 	void __iomem *pic_mask = irq_to_pic_mask(cpld_irq);
 
 	out_8(pic_mask,
diff --git a/arch/powerpc/platforms/52xx/media5200.c b/arch/powerpc/platforms/52xx/media5200.c
index 57a6a34..96f85e5 100644
--- a/arch/powerpc/platforms/52xx/media5200.c
+++ b/arch/powerpc/platforms/52xx/media5200.c
@@ -56,7 +56,7 @@ static void media5200_irq_unmask(struct irq_data *d)
 
 	spin_lock_irqsave(&media5200_irq.lock, flags);
 	val = in_be32(media5200_irq.regs + MEDIA5200_IRQ_ENABLE);
-	val |= 1 << (MEDIA5200_IRQ_SHIFT + irq_map[d->irq].hwirq);
+	val |= 1 << (MEDIA5200_IRQ_SHIFT + irqd_to_hwirq(d));
 	out_be32(media5200_irq.regs + MEDIA5200_IRQ_ENABLE, val);
 	spin_unlock_irqrestore(&media5200_irq.lock, flags);
 }
@@ -68,7 +68,7 @@ static void media5200_irq_mask(struct irq_data *d)
 
 	spin_lock_irqsave(&media5200_irq.lock, flags);
 	val = in_be32(media5200_irq.regs + MEDIA5200_IRQ_ENABLE);
-	val &= ~(1 << (MEDIA5200_IRQ_SHIFT + irq_map[d->irq].hwirq));
+	val &= ~(1 << (MEDIA5200_IRQ_SHIFT + irqd_to_hwirq(d)));
 	out_be32(media5200_irq.regs + MEDIA5200_IRQ_ENABLE, val);
 	spin_unlock_irqrestore(&media5200_irq.lock, flags);
 }
diff --git a/arch/powerpc/platforms/52xx/mpc52xx_pic.c b/arch/powerpc/platforms/52xx/mpc52xx_pic.c
index 1dd1540..bb61181 100644
--- a/arch/powerpc/platforms/52xx/mpc52xx_pic.c
+++ b/arch/powerpc/platforms/52xx/mpc52xx_pic.c
@@ -157,48 +157,30 @@ static inline void io_be_clrbit(u32 __iomem *addr, int bitno)
  */
 static void mpc52xx_extirq_mask(struct irq_data *d)
 {
-	int irq;
-	int l2irq;
-
-	irq = irq_map[d->irq].hwirq;
-	l2irq = irq & MPC52xx_IRQ_L2_MASK;
-
+	int l2irq = irqd_to_hwirq(d) & MPC52xx_IRQ_L2_MASK;
 	io_be_clrbit(&intr->ctrl, 11 - l2irq);
 }
 
 static void mpc52xx_extirq_unmask(struct irq_data *d)
 {
-	int irq;
-	int l2irq;
-
-	irq = irq_map[d->irq].hwirq;
-	l2irq = irq & MPC52xx_IRQ_L2_MASK;
-
+	int l2irq = irqd_to_hwirq(d) & MPC52xx_IRQ_L2_MASK;
 	io_be_setbit(&intr->ctrl, 11 - l2irq);
 }
 
 static void mpc52xx_extirq_ack(struct irq_data *d)
 {
-	int irq;
-	int l2irq;
-
-	irq = irq_map[d->irq].hwirq;
-	l2irq = irq & MPC52xx_IRQ_L2_MASK;
-
+	int l2irq = irqd_to_hwirq(d) & MPC52xx_IRQ_L2_MASK;
 	io_be_setbit(&intr->ctrl, 27-l2irq);
 }
 
 static int mpc52xx_extirq_set_type(struct irq_data *d, unsigned int flow_type)
 {
 	u32 ctrl_reg, type;
-	int irq;
-	int l2irq;
+	int l2irq = irqd_to_hwirq(d) & MPC52xx_IRQ_L2_MASK;
 	void *handler = handle_level_irq;
 
-	irq = irq_map[d->irq].hwirq;
-	l2irq = irq & MPC52xx_IRQ_L2_MASK;
-
-	pr_debug("%s: irq=%x. l2=%d flow_type=%d\n", __func__, irq, l2irq, flow_type);
+	pr_debug("%s: irq=%x. l2=%d flow_type=%d\n", __func__,
+		(int) irqd_to_hwirq(d), l2irq, flow_type);
 
 	switch (flow_type) {
 	case IRQF_TRIGGER_HIGH: type = 0; break;
@@ -237,23 +219,13 @@ static int mpc52xx_null_set_type(struct irq_data *d, unsigned int flow_type)
 
 static void mpc52xx_main_mask(struct irq_data *d)
 {
-	int irq;
-	int l2irq;
-
-	irq = irq_map[d->irq].hwirq;
-	l2irq = irq & MPC52xx_IRQ_L2_MASK;
-
+	int l2irq = irqd_to_hwirq(d) & MPC52xx_IRQ_L2_MASK;
 	io_be_setbit(&intr->main_mask, 16 - l2irq);
 }
 
 static void mpc52xx_main_unmask(struct irq_data *d)
 {
-	int irq;
-	int l2irq;
-
-	irq = irq_map[d->irq].hwirq;
-	l2irq = irq & MPC52xx_IRQ_L2_MASK;
-
+	int l2irq = irqd_to_hwirq(d) & MPC52xx_IRQ_L2_MASK;
 	io_be_clrbit(&intr->main_mask, 16 - l2irq);
 }
 
@@ -270,23 +242,13 @@ static struct irq_chip mpc52xx_main_irqchip = {
  */
 static void mpc52xx_periph_mask(struct irq_data *d)
 {
-	int irq;
-	int l2irq;
-
-	irq = irq_map[d->irq].hwirq;
-	l2irq = irq & MPC52xx_IRQ_L2_MASK;
-
+	int l2irq = irqd_to_hwirq(d) & MPC52xx_IRQ_L2_MASK;
 	io_be_setbit(&intr->per_mask, 31 - l2irq);
 }
 
 static void mpc52xx_periph_unmask(struct irq_data *d)
 {
-	int irq;
-	int l2irq;
-
-	irq = irq_map[d->irq].hwirq;
-	l2irq = irq & MPC52xx_IRQ_L2_MASK;
-
+	int l2irq = irqd_to_hwirq(d) & MPC52xx_IRQ_L2_MASK;
 	io_be_clrbit(&intr->per_mask, 31 - l2irq);
 }
 
@@ -303,34 +265,19 @@ static struct irq_chip mpc52xx_periph_irqchip = {
  */
 static void mpc52xx_sdma_mask(struct irq_data *d)
 {
-	int irq;
-	int l2irq;
-
-	irq = irq_map[d->irq].hwirq;
-	l2irq = irq & MPC52xx_IRQ_L2_MASK;
-
+	int l2irq = irqd_to_hwirq(d) & MPC52xx_IRQ_L2_MASK;
 	io_be_setbit(&sdma->IntMask, l2irq);
 }
 
 static void mpc52xx_sdma_unmask(struct irq_data *d)
 {
-	int irq;
-	int l2irq;
-
-	irq = irq_map[d->irq].hwirq;
-	l2irq = irq & MPC52xx_IRQ_L2_MASK;
-
+	int l2irq = irqd_to_hwirq(d) & MPC52xx_IRQ_L2_MASK;
 	io_be_clrbit(&sdma->IntMask, l2irq);
 }
 
 static void mpc52xx_sdma_ack(struct irq_data *d)
 {
-	int irq;
-	int l2irq;
-
-	irq = irq_map[d->irq].hwirq;
-	l2irq = irq & MPC52xx_IRQ_L2_MASK;
-
+	int l2irq = irqd_to_hwirq(d) & MPC52xx_IRQ_L2_MASK;
 	out_be32(&sdma->IntPend, 1 << l2irq);
 }
 
diff --git a/arch/powerpc/platforms/82xx/pq2ads-pci-pic.c b/arch/powerpc/platforms/82xx/pq2ads-pci-pic.c
index 4a4eb6f..5d6c34c 100644
--- a/arch/powerpc/platforms/82xx/pq2ads-pci-pic.c
+++ b/arch/powerpc/platforms/82xx/pq2ads-pci-pic.c
@@ -42,7 +42,7 @@ struct pq2ads_pci_pic {
 static void pq2ads_pci_mask_irq(struct irq_data *d)
 {
 	struct pq2ads_pci_pic *priv = irq_data_get_irq_chip_data(d);
-	int irq = NUM_IRQS - virq_to_hw(d->irq) - 1;
+	int irq = NUM_IRQS - irqd_to_hwirq(d) - 1;
 
 	if (irq != -1) {
 		unsigned long flags;
@@ -58,7 +58,7 @@ static void pq2ads_pci_mask_irq(struct irq_data *d)
 static void pq2ads_pci_unmask_irq(struct irq_data *d)
 {
 	struct pq2ads_pci_pic *priv = irq_data_get_irq_chip_data(d);
-	int irq = NUM_IRQS - virq_to_hw(d->irq) - 1;
+	int irq = NUM_IRQS - irqd_to_hwirq(d) - 1;
 
 	if (irq != -1) {
 		unsigned long flags;
diff --git a/arch/powerpc/platforms/85xx/socrates_fpga_pic.c b/arch/powerpc/platforms/85xx/socrates_fpga_pic.c
index db86462..12cb9bb 100644
--- a/arch/powerpc/platforms/85xx/socrates_fpga_pic.c
+++ b/arch/powerpc/platforms/85xx/socrates_fpga_pic.c
@@ -48,8 +48,6 @@ static struct socrates_fpga_irq_info fpga_irqs[SOCRATES_FPGA_NUM_IRQS] = {
 	[8] = {0, IRQ_TYPE_LEVEL_HIGH},
 };
 
-#define socrates_fpga_irq_to_hw(virq)    ((unsigned int)irq_map[virq].hwirq)
-
 static DEFINE_RAW_SPINLOCK(socrates_fpga_pic_lock);
 
 static void __iomem *socrates_fpga_pic_iobase;
@@ -110,11 +108,9 @@ void socrates_fpga_pic_cascade(unsigned int irq, struct irq_desc *desc)
 static void socrates_fpga_pic_ack(struct irq_data *d)
 {
 	unsigned long flags;
-	unsigned int hwirq, irq_line;
+	unsigned int irq_line, hwirq = irqd_to_hwirq(d);
 	uint32_t mask;
 
-	hwirq = socrates_fpga_irq_to_hw(d->irq);
-
 	irq_line = fpga_irqs[hwirq].irq_line;
 	raw_spin_lock_irqsave(&socrates_fpga_pic_lock, flags);
 	mask = socrates_fpga_pic_read(FPGA_PIC_IRQMASK(irq_line))
@@ -127,12 +123,10 @@ static void socrates_fpga_pic_ack(struct irq_data *d)
 static void socrates_fpga_pic_mask(struct irq_data *d)
 {
 	unsigned long flags;
-	unsigned int hwirq;
+	unsigned int hwirq = irqd_to_hwirq(d);
 	int irq_line;
 	u32 mask;
 
-	hwirq = socrates_fpga_irq_to_hw(d->irq);
-
 	irq_line = fpga_irqs[hwirq].irq_line;
 	raw_spin_lock_irqsave(&socrates_fpga_pic_lock, flags);
 	mask = socrates_fpga_pic_read(FPGA_PIC_IRQMASK(irq_line))
@@ -145,12 +139,10 @@ static void socrates_fpga_pic_mask(struct irq_data *d)
 static void socrates_fpga_pic_mask_ack(struct irq_data *d)
 {
 	unsigned long flags;
-	unsigned int hwirq;
+	unsigned int hwirq = irqd_to_hwirq(d);
 	int irq_line;
 	u32 mask;
 
-	hwirq = socrates_fpga_irq_to_hw(d->irq);
-
 	irq_line = fpga_irqs[hwirq].irq_line;
 	raw_spin_lock_irqsave(&socrates_fpga_pic_lock, flags);
 	mask = socrates_fpga_pic_read(FPGA_PIC_IRQMASK(irq_line))
@@ -164,12 +156,10 @@ static void socrates_fpga_pic_mask_ack(struct irq_data *d)
 static void socrates_fpga_pic_unmask(struct irq_data *d)
 {
 	unsigned long flags;
-	unsigned int hwirq;
+	unsigned int hwirq = irqd_to_hwirq(d);
 	int irq_line;
 	u32 mask;
 
-	hwirq = socrates_fpga_irq_to_hw(d->irq);
-
 	irq_line = fpga_irqs[hwirq].irq_line;
 	raw_spin_lock_irqsave(&socrates_fpga_pic_lock, flags);
 	mask = socrates_fpga_pic_read(FPGA_PIC_IRQMASK(irq_line))
@@ -182,12 +172,10 @@ static void socrates_fpga_pic_unmask(struct irq_data *d)
 static void socrates_fpga_pic_eoi(struct irq_data *d)
 {
 	unsigned long flags;
-	unsigned int hwirq;
+	unsigned int hwirq = irqd_to_hwirq(d);
 	int irq_line;
 	u32 mask;
 
-	hwirq = socrates_fpga_irq_to_hw(d->irq);
-
 	irq_line = fpga_irqs[hwirq].irq_line;
 	raw_spin_lock_irqsave(&socrates_fpga_pic_lock, flags);
 	mask = socrates_fpga_pic_read(FPGA_PIC_IRQMASK(irq_line))
@@ -201,12 +189,10 @@ static int socrates_fpga_pic_set_type(struct irq_data *d,
 		unsigned int flow_type)
 {
 	unsigned long flags;
-	unsigned int hwirq;
+	unsigned int hwirq = irqd_to_hwirq(d);
 	int polarity;
 	u32 mask;
 
-	hwirq = socrates_fpga_irq_to_hw(d->irq);
-
 	if (fpga_irqs[hwirq].type != IRQ_TYPE_NONE)
 		return -EINVAL;
 
diff --git a/arch/powerpc/platforms/86xx/gef_pic.c b/arch/powerpc/platforms/86xx/gef_pic.c
index 0beec7d..94594e5 100644
--- a/arch/powerpc/platforms/86xx/gef_pic.c
+++ b/arch/powerpc/platforms/86xx/gef_pic.c
@@ -46,8 +46,6 @@
 #define GEF_PIC_CPU0_MCP_MASK	GEF_PIC_MCP_MASK(0)
 #define GEF_PIC_CPU1_MCP_MASK	GEF_PIC_MCP_MASK(1)
 
-#define gef_irq_to_hw(virq)    ((unsigned int)irq_map[virq].hwirq)
-
 
 static DEFINE_RAW_SPINLOCK(gef_pic_lock);
 
@@ -113,11 +111,9 @@ void gef_pic_cascade(unsigned int irq, struct irq_desc *desc)
 static void gef_pic_mask(struct irq_data *d)
 {
 	unsigned long flags;
-	unsigned int hwirq;
+	unsigned int hwirq = irqd_to_hwirq(d);
 	u32 mask;
 
-	hwirq = gef_irq_to_hw(d->irq);
-
 	raw_spin_lock_irqsave(&gef_pic_lock, flags);
 	mask = in_be32(gef_pic_irq_reg_base + GEF_PIC_INTR_MASK(0));
 	mask &= ~(1 << hwirq);
@@ -136,11 +132,9 @@ static void gef_pic_mask_ack(struct irq_data *d)
 static void gef_pic_unmask(struct irq_data *d)
 {
 	unsigned long flags;
-	unsigned int hwirq;
+	unsigned int hwirq = irqd_to_hwirq(d);
 	u32 mask;
 
-	hwirq = gef_irq_to_hw(d->irq);
-
 	raw_spin_lock_irqsave(&gef_pic_lock, flags);
 	mask = in_be32(gef_pic_irq_reg_base + GEF_PIC_INTR_MASK(0));
 	mask |= (1 << hwirq);
diff --git a/arch/powerpc/platforms/8xx/m8xx_setup.c b/arch/powerpc/platforms/8xx/m8xx_setup.c
index 9ecce99..1e12108 100644
--- a/arch/powerpc/platforms/8xx/m8xx_setup.c
+++ b/arch/powerpc/platforms/8xx/m8xx_setup.c
@@ -150,7 +150,7 @@ void __init mpc8xx_calibrate_decr(void)
 	 */
 	cpu = of_find_node_by_type(NULL, "cpu");
 	virq= irq_of_parse_and_map(cpu, 0);
-	irq = irq_map[virq].hwirq;
+	irq = virq_to_hw(virq);
 
 	sys_tmr2 = immr_map(im_sit);
 	out_be16(&sys_tmr2->sit_tbscr, ((1 << (7 - (irq/2))) << 8) |
diff --git a/arch/powerpc/platforms/cell/axon_msi.c b/arch/powerpc/platforms/cell/axon_msi.c
index bb5ebf8..1e3329e 100644
--- a/arch/powerpc/platforms/cell/axon_msi.c
+++ b/arch/powerpc/platforms/cell/axon_msi.c
@@ -113,7 +113,7 @@ static void axon_msi_cascade(unsigned int irq, struct irq_desc *desc)
 		pr_devel("axon_msi: woff %x roff %x msi %x\n",
 			  write_offset, msic->read_offset, msi);
 
-		if (msi < NR_IRQS && irq_map[msi].host == msic->irq_host) {
+		if (msi < NR_IRQS && virq_to_host(msi) == msic->irq_host) {
 			generic_handle_irq(msi);
 			msic->fifo_virt[idx] = cpu_to_le32(0xffffffff);
 		} else {
diff --git a/arch/powerpc/platforms/cell/spider-pic.c b/arch/powerpc/platforms/cell/spider-pic.c
index c5cf50e..34d2b99 100644
--- a/arch/powerpc/platforms/cell/spider-pic.c
+++ b/arch/powerpc/platforms/cell/spider-pic.c
@@ -70,7 +70,7 @@ static struct spider_pic spider_pics[SPIDER_CHIP_COUNT];
 
 static struct spider_pic *spider_virq_to_pic(unsigned int virq)
 {
-	return irq_map[virq].host->host_data;
+	return virq_to_host(virq)->host_data;
 }
 
 static void __iomem *spider_get_irq_config(struct spider_pic *pic,
@@ -82,7 +82,7 @@ static void __iomem *spider_get_irq_config(struct spider_pic *pic,
 static void spider_unmask_irq(struct irq_data *d)
 {
 	struct spider_pic *pic = spider_virq_to_pic(d->irq);
-	void __iomem *cfg = spider_get_irq_config(pic, irq_map[d->irq].hwirq);
+	void __iomem *cfg = spider_get_irq_config(pic, irqd_to_hwirq(d));
 
 	out_be32(cfg, in_be32(cfg) | 0x30000000u);
 }
@@ -90,7 +90,7 @@ static void spider_unmask_irq(struct irq_data *d)
 static void spider_mask_irq(struct irq_data *d)
 {
 	struct spider_pic *pic = spider_virq_to_pic(d->irq);
-	void __iomem *cfg = spider_get_irq_config(pic, irq_map[d->irq].hwirq);
+	void __iomem *cfg = spider_get_irq_config(pic, irqd_to_hwirq(d));
 
 	out_be32(cfg, in_be32(cfg) & ~0x30000000u);
 }
@@ -98,7 +98,7 @@ static void spider_mask_irq(struct irq_data *d)
 static void spider_ack_irq(struct irq_data *d)
 {
 	struct spider_pic *pic = spider_virq_to_pic(d->irq);
-	unsigned int src = irq_map[d->irq].hwirq;
+	unsigned int src = irqd_to_hwirq(d);
 
 	/* Reset edge detection logic if necessary
 	 */
@@ -117,7 +117,7 @@ static int spider_set_irq_type(struct irq_data *d, unsigned int type)
 {
 	unsigned int sense = type & IRQ_TYPE_SENSE_MASK;
 	struct spider_pic *pic = spider_virq_to_pic(d->irq);
-	unsigned int hw = irq_map[d->irq].hwirq;
+	unsigned int hw = irqd_to_hwirq(d);
 	void __iomem *cfg = spider_get_irq_config(pic, hw);
 	u32 old_mask;
 	u32 ic;
diff --git a/arch/powerpc/platforms/embedded6xx/flipper-pic.c b/arch/powerpc/platforms/embedded6xx/flipper-pic.c
index 12aa62b..77cbe4c 100644
--- a/arch/powerpc/platforms/embedded6xx/flipper-pic.c
+++ b/arch/powerpc/platforms/embedded6xx/flipper-pic.c
@@ -48,7 +48,7 @@
 
 static void flipper_pic_mask_and_ack(struct irq_data *d)
 {
-	int irq = virq_to_hw(d->irq);
+	int irq = irqd_to_hwirq(d);
 	void __iomem *io_base = irq_data_get_irq_chip_data(d);
 	u32 mask = 1 << irq;
 
@@ -59,7 +59,7 @@ static void flipper_pic_mask_and_ack(struct irq_data *d)
 
 static void flipper_pic_ack(struct irq_data *d)
 {
-	int irq = virq_to_hw(d->irq);
+	int irq = irqd_to_hwirq(d);
 	void __iomem *io_base = irq_data_get_irq_chip_data(d);
 
 	/* this is at least needed for RSW */
@@ -68,7 +68,7 @@ static void flipper_pic_ack(struct irq_data *d)
 
 static void flipper_pic_mask(struct irq_data *d)
 {
-	int irq = virq_to_hw(d->irq);
+	int irq = irqd_to_hwirq(d);
 	void __iomem *io_base = irq_data_get_irq_chip_data(d);
 
 	clrbits32(io_base + FLIPPER_IMR, 1 << irq);
@@ -76,7 +76,7 @@ static void flipper_pic_mask(struct irq_data *d)
 
 static void flipper_pic_unmask(struct irq_data *d)
 {
-	int irq = virq_to_hw(d->irq);
+	int irq = irqd_to_hwirq(d);
 	void __iomem *io_base = irq_data_get_irq_chip_data(d);
 
 	setbits32(io_base + FLIPPER_IMR, 1 << irq);
diff --git a/arch/powerpc/platforms/embedded6xx/hlwd-pic.c b/arch/powerpc/platforms/embedded6xx/hlwd-pic.c
index 2bdddfc..44b398b 100644
--- a/arch/powerpc/platforms/embedded6xx/hlwd-pic.c
+++ b/arch/powerpc/platforms/embedded6xx/hlwd-pic.c
@@ -43,7 +43,7 @@
 
 static void hlwd_pic_mask_and_ack(struct irq_data *d)
 {
-	int irq = virq_to_hw(d->irq);
+	int irq = irqd_to_hwirq(d);
 	void __iomem *io_base = irq_data_get_irq_chip_data(d);
 	u32 mask = 1 << irq;
 
@@ -53,7 +53,7 @@ static void hlwd_pic_mask_and_ack(struct irq_data *d)
 
 static void hlwd_pic_ack(struct irq_data *d)
 {
-	int irq = virq_to_hw(d->irq);
+	int irq = irqd_to_hwirq(d);
 	void __iomem *io_base = irq_data_get_irq_chip_data(d);
 
 	out_be32(io_base + HW_BROADWAY_ICR, 1 << irq);
@@ -61,7 +61,7 @@ static void hlwd_pic_ack(struct irq_data *d)
 
 static void hlwd_pic_mask(struct irq_data *d)
 {
-	int irq = virq_to_hw(d->irq);
+	int irq = irqd_to_hwirq(d);
 	void __iomem *io_base = irq_data_get_irq_chip_data(d);
 
 	clrbits32(io_base + HW_BROADWAY_IMR, 1 << irq);
@@ -69,7 +69,7 @@ static void hlwd_pic_mask(struct irq_data *d)
 
 static void hlwd_pic_unmask(struct irq_data *d)
 {
-	int irq = virq_to_hw(d->irq);
+	int irq = irqd_to_hwirq(d);
 	void __iomem *io_base = irq_data_get_irq_chip_data(d);
 
 	setbits32(io_base + HW_BROADWAY_IMR, 1 << irq);
diff --git a/arch/powerpc/platforms/iseries/irq.c b/arch/powerpc/platforms/iseries/irq.c
index 52a6889..375c21c 100644
--- a/arch/powerpc/platforms/iseries/irq.c
+++ b/arch/powerpc/platforms/iseries/irq.c
@@ -171,7 +171,7 @@ static void iseries_enable_IRQ(struct irq_data *d)
 {
 	u32 bus, dev_id, function, mask;
 	const u32 sub_bus = 0;
-	unsigned int rirq = (unsigned int)irq_map[d->irq].hwirq;
+	unsigned int rirq = (unsigned int)irqd_to_hwirq(d);
 
 	/* The IRQ has already been locked by the caller */
 	bus = REAL_IRQ_TO_BUS(rirq);
@@ -188,7 +188,7 @@ static unsigned int iseries_startup_IRQ(struct irq_data *d)
 {
 	u32 bus, dev_id, function, mask;
 	const u32 sub_bus = 0;
-	unsigned int rirq = (unsigned int)irq_map[d->irq].hwirq;
+	unsigned int rirq = (unsigned int)irqd_to_hwirq(d);
 
 	bus = REAL_IRQ_TO_BUS(rirq);
 	function = REAL_IRQ_TO_FUNC(rirq);
@@ -234,7 +234,7 @@ static void iseries_shutdown_IRQ(struct irq_data *d)
 {
 	u32 bus, dev_id, function, mask;
 	const u32 sub_bus = 0;
-	unsigned int rirq = (unsigned int)irq_map[d->irq].hwirq;
+	unsigned int rirq = (unsigned int)irqd_to_hwirq(d);
 
 	/* irq should be locked by the caller */
 	bus = REAL_IRQ_TO_BUS(rirq);
@@ -257,7 +257,7 @@ static void iseries_disable_IRQ(struct irq_data *d)
 {
 	u32 bus, dev_id, function, mask;
 	const u32 sub_bus = 0;
-	unsigned int rirq = (unsigned int)irq_map[d->irq].hwirq;
+	unsigned int rirq = (unsigned int)irqd_to_hwirq(d);
 
 	/* The IRQ has already been locked by the caller */
 	bus = REAL_IRQ_TO_BUS(rirq);
@@ -271,7 +271,7 @@ static void iseries_disable_IRQ(struct irq_data *d)
 
 static void iseries_end_IRQ(struct irq_data *d)
 {
-	unsigned int rirq = (unsigned int)irq_map[d->irq].hwirq;
+	unsigned int rirq = (unsigned int)irqd_to_hwirq(d);
 
 	HvCallPci_eoi(REAL_IRQ_TO_BUS(rirq), REAL_IRQ_TO_SUBBUS(rirq),
 		(REAL_IRQ_TO_IDSEL(rirq) << 4) + REAL_IRQ_TO_FUNC(rirq));
diff --git a/arch/powerpc/platforms/powermac/pic.c b/arch/powerpc/platforms/powermac/pic.c
index 023f240..2f34ad0 100644
--- a/arch/powerpc/platforms/powermac/pic.c
+++ b/arch/powerpc/platforms/powermac/pic.c
@@ -84,7 +84,7 @@ static void __pmac_retrigger(unsigned int irq_nr)
 
 static void pmac_mask_and_ack_irq(struct irq_data *d)
 {
-	unsigned int src = irq_map[d->irq].hwirq;
+	unsigned int src = irqd_to_hwirq(d);
         unsigned long bit = 1UL << (src & 0x1f);
         int i = src >> 5;
         unsigned long flags;
@@ -106,7 +106,7 @@ static void pmac_mask_and_ack_irq(struct irq_data *d)
 
 static void pmac_ack_irq(struct irq_data *d)
 {
-	unsigned int src = irq_map[d->irq].hwirq;
+	unsigned int src = irqd_to_hwirq(d);
         unsigned long bit = 1UL << (src & 0x1f);
         int i = src >> 5;
         unsigned long flags;
@@ -152,7 +152,7 @@ static void __pmac_set_irq_mask(unsigned int irq_nr, int nokicklost)
 static unsigned int pmac_startup_irq(struct irq_data *d)
 {
 	unsigned long flags;
-	unsigned int src = irq_map[d->irq].hwirq;
+	unsigned int src = irqd_to_hwirq(d);
         unsigned long bit = 1UL << (src & 0x1f);
         int i = src >> 5;
 
@@ -169,7 +169,7 @@ static unsigned int pmac_startup_irq(struct irq_data *d)
 static void pmac_mask_irq(struct irq_data *d)
 {
 	unsigned long flags;
-	unsigned int src = irq_map[d->irq].hwirq;
+	unsigned int src = irqd_to_hwirq(d);
 
 	raw_spin_lock_irqsave(&pmac_pic_lock, flags);
         __clear_bit(src, ppc_cached_irq_mask);
@@ -180,7 +180,7 @@ static void pmac_mask_irq(struct irq_data *d)
 static void pmac_unmask_irq(struct irq_data *d)
 {
 	unsigned long flags;
-	unsigned int src = irq_map[d->irq].hwirq;
+	unsigned int src = irqd_to_hwirq(d);
 
 	raw_spin_lock_irqsave(&pmac_pic_lock, flags);
 	__set_bit(src, ppc_cached_irq_mask);
@@ -193,7 +193,7 @@ static int pmac_retrigger(struct irq_data *d)
 	unsigned long flags;
 
 	raw_spin_lock_irqsave(&pmac_pic_lock, flags);
-	__pmac_retrigger(irq_map[d->irq].hwirq);
+	__pmac_retrigger(irqd_to_hwirq(d));
 	raw_spin_unlock_irqrestore(&pmac_pic_lock, flags);
 	return 1;
 }
diff --git a/arch/powerpc/platforms/pseries/ras.c b/arch/powerpc/platforms/pseries/ras.c
index c55d7ad..164a8eb 100644
--- a/arch/powerpc/platforms/pseries/ras.c
+++ b/arch/powerpc/platforms/pseries/ras.c
@@ -122,7 +122,7 @@ static irqreturn_t ras_epow_interrupt(int irq, void *dev_id)
 
 	status = rtas_call(ras_check_exception_token, 6, 1, NULL,
 			   RTAS_VECTOR_EXTERNAL_INTERRUPT,
-			   irq_map[irq].hwirq,
+			   virq_to_hw(irq),
 			   RTAS_EPOW_WARNING | RTAS_POWERMGM_EVENTS,
 			   critical, __pa(&ras_log_buf),
 				rtas_get_error_log_max());
@@ -157,7 +157,7 @@ static irqreturn_t ras_error_interrupt(int irq, void *dev_id)
 
 	status = rtas_call(ras_check_exception_token, 6, 1, NULL,
 			   RTAS_VECTOR_EXTERNAL_INTERRUPT,
-			   irq_map[irq].hwirq,
+			   virq_to_hw(irq),
 			   RTAS_INTERNAL_ERROR, 1 /*Time Critical */,
 			   __pa(&ras_log_buf),
 				rtas_get_error_log_max());
diff --git a/arch/powerpc/platforms/pseries/xics.c b/arch/powerpc/platforms/pseries/xics.c
index d690133..784e614 100644
--- a/arch/powerpc/platforms/pseries/xics.c
+++ b/arch/powerpc/platforms/pseries/xics.c
@@ -210,7 +210,7 @@ static void xics_unmask_irq(struct irq_data *d)
 
 	pr_devel("xics: unmask virq %d\n", d->irq);
 
-	hwirq = (unsigned int)irq_map[d->irq].hwirq;
+	hwirq = (unsigned int)irqd_to_hwirq(d);
 	pr_devel(" -> map to hwirq 0x%x\n", hwirq);
 	if (hwirq == XICS_IPI || hwirq == XICS_IRQ_SPURIOUS)
 		return;
@@ -280,7 +280,7 @@ static void xics_mask_irq(struct irq_data *d)
 
 	pr_devel("xics: mask virq %d\n", d->irq);
 
-	hwirq = (unsigned int)irq_map[d->irq].hwirq;
+	hwirq = (unsigned int)irqd_to_hwirq(d);
 	if (hwirq == XICS_IPI || hwirq == XICS_IRQ_SPURIOUS)
 		return;
 	xics_mask_real_irq(hwirq);
@@ -373,7 +373,7 @@ static unsigned char pop_cppr(void)
 
 static void xics_eoi_direct(struct irq_data *d)
 {
-	unsigned int hwirq = (unsigned int)irq_map[d->irq].hwirq;
+	unsigned int hwirq = (unsigned int)irqd_to_hwirq(d);
 
 	iosync();
 	direct_xirr_info_set((pop_cppr() << 24) | hwirq);
@@ -381,7 +381,7 @@ static void xics_eoi_direct(struct irq_data *d)
 
 static void xics_eoi_lpar(struct irq_data *d)
 {
-	unsigned int hwirq = (unsigned int)irq_map[d->irq].hwirq;
+	unsigned int hwirq = (unsigned int)irqd_to_hwirq(d);
 
 	iosync();
 	lpar_xirr_info_set((pop_cppr() << 24) | hwirq);
@@ -395,7 +395,7 @@ xics_set_affinity(struct irq_data *d, const struct cpumask *cpumask, bool force)
 	int xics_status[2];
 	int irq_server;
 
-	hwirq = (unsigned int)irq_map[d->irq].hwirq;
+	hwirq = (unsigned int)irqd_to_hwirq(d);
 	if (hwirq == XICS_IPI || hwirq == XICS_IRQ_SPURIOUS)
 		return -1;
 
@@ -900,9 +900,9 @@ void xics_migrate_irqs_away(void)
 		/* We can't set affinity on ISA interrupts */
 		if (virq < NUM_ISA_INTERRUPTS)
 			continue;
-		if (irq_map[virq].host != xics_host)
+		if (virq_to_host(virq) != xics_host)
 			continue;
-		hwirq = (unsigned int)irq_map[virq].hwirq;
+		hwirq = (unsigned int)virq_to_hw(virq);
 		/* We need to get IPIs still. */
 		if (hwirq == XICS_IPI || hwirq == XICS_IRQ_SPURIOUS)
 			continue;
diff --git a/arch/powerpc/sysdev/cpm1.c b/arch/powerpc/sysdev/cpm1.c
index e0bc944..350787c 100644
--- a/arch/powerpc/sysdev/cpm1.c
+++ b/arch/powerpc/sysdev/cpm1.c
@@ -58,21 +58,21 @@ static struct irq_host *cpm_pic_host;
 
 static void cpm_mask_irq(struct irq_data *d)
 {
-	unsigned int cpm_vec = (unsigned int)irq_map[d->irq].hwirq;
+	unsigned int cpm_vec = (unsigned int)irqd_to_hwirq(d);
 
 	clrbits32(&cpic_reg->cpic_cimr, (1 << cpm_vec));
 }
 
 static void cpm_unmask_irq(struct irq_data *d)
 {
-	unsigned int cpm_vec = (unsigned int)irq_map[d->irq].hwirq;
+	unsigned int cpm_vec = (unsigned int)irqd_to_hwirq(d);
 
 	setbits32(&cpic_reg->cpic_cimr, (1 << cpm_vec));
 }
 
 static void cpm_end_irq(struct irq_data *d)
 {
-	unsigned int cpm_vec = (unsigned int)irq_map[d->irq].hwirq;
+	unsigned int cpm_vec = (unsigned int)irqd_to_hwirq(d);
 
 	out_be32(&cpic_reg->cpic_cisr, (1 << cpm_vec));
 }
@@ -157,7 +157,7 @@ unsigned int cpm_pic_init(void)
 		goto end;
 
 	/* Initialize the CPM interrupt controller. */
-	hwirq = (unsigned int)irq_map[sirq].hwirq;
+	hwirq = (unsigned int)virq_to_hw(sirq);
 	out_be32(&cpic_reg->cpic_cicr,
 	    (CICR_SCD_SCC4 | CICR_SCC_SCC3 | CICR_SCB_SCC2 | CICR_SCA_SCC1) |
 		((hwirq/2) << 13) | CICR_HP_MASK);
diff --git a/arch/powerpc/sysdev/cpm2_pic.c b/arch/powerpc/sysdev/cpm2_pic.c
index 5495c1b..bcab50e 100644
--- a/arch/powerpc/sysdev/cpm2_pic.c
+++ b/arch/powerpc/sysdev/cpm2_pic.c
@@ -81,7 +81,7 @@ static const u_char irq_to_siubit[] = {
 static void cpm2_mask_irq(struct irq_data *d)
 {
 	int	bit, word;
-	unsigned int irq_nr = virq_to_hw(d->irq);
+	unsigned int irq_nr = irqd_to_hwirq(d);
 
 	bit = irq_to_siubit[irq_nr];
 	word = irq_to_siureg[irq_nr];
@@ -93,7 +93,7 @@ static void cpm2_mask_irq(struct irq_data *d)
 static void cpm2_unmask_irq(struct irq_data *d)
 {
 	int	bit, word;
-	unsigned int irq_nr = virq_to_hw(d->irq);
+	unsigned int irq_nr = irqd_to_hwirq(d);
 
 	bit = irq_to_siubit[irq_nr];
 	word = irq_to_siureg[irq_nr];
@@ -105,7 +105,7 @@ static void cpm2_unmask_irq(struct irq_data *d)
 static void cpm2_ack(struct irq_data *d)
 {
 	int	bit, word;
-	unsigned int irq_nr = virq_to_hw(d->irq);
+	unsigned int irq_nr = irqd_to_hwirq(d);
 
 	bit = irq_to_siubit[irq_nr];
 	word = irq_to_siureg[irq_nr];
@@ -116,7 +116,7 @@ static void cpm2_ack(struct irq_data *d)
 static void cpm2_end_irq(struct irq_data *d)
 {
 	int	bit, word;
-	unsigned int irq_nr = virq_to_hw(d->irq);
+	unsigned int irq_nr = irqd_to_hwirq(d);
 
 	bit = irq_to_siubit[irq_nr];
 	word = irq_to_siureg[irq_nr];
@@ -133,7 +133,7 @@ static void cpm2_end_irq(struct irq_data *d)
 
 static int cpm2_set_irq_type(struct irq_data *d, unsigned int flow_type)
 {
-	unsigned int src = virq_to_hw(d->irq);
+	unsigned int src = irqd_to_hwirq(d);
 	unsigned int vold, vnew, edibit;
 
 	/* Port C interrupts are either IRQ_TYPE_EDGE_FALLING or
diff --git a/arch/powerpc/sysdev/ipic.c b/arch/powerpc/sysdev/ipic.c
index fa438be..f0ece79 100644
--- a/arch/powerpc/sysdev/ipic.c
+++ b/arch/powerpc/sysdev/ipic.c
@@ -521,12 +521,10 @@ static inline struct ipic * ipic_from_irq(unsigned int virq)
 	return primary_ipic;
 }
 
-#define ipic_irq_to_hw(virq)	((unsigned int)irq_map[virq].hwirq)
-
 static void ipic_unmask_irq(struct irq_data *d)
 {
 	struct ipic *ipic = ipic_from_irq(d->irq);
-	unsigned int src = ipic_irq_to_hw(d->irq);
+	unsigned int src = irqd_to_hwirq(d);
 	unsigned long flags;
 	u32 temp;
 
@@ -542,7 +540,7 @@ static void ipic_unmask_irq(struct irq_data *d)
 static void ipic_mask_irq(struct irq_data *d)
 {
 	struct ipic *ipic = ipic_from_irq(d->irq);
-	unsigned int src = ipic_irq_to_hw(d->irq);
+	unsigned int src = irqd_to_hwirq(d);
 	unsigned long flags;
 	u32 temp;
 
@@ -562,7 +560,7 @@ static void ipic_mask_irq(struct irq_data *d)
 static void ipic_ack_irq(struct irq_data *d)
 {
 	struct ipic *ipic = ipic_from_irq(d->irq);
-	unsigned int src = ipic_irq_to_hw(d->irq);
+	unsigned int src = irqd_to_hwirq(d);
 	unsigned long flags;
 	u32 temp;
 
@@ -581,7 +579,7 @@ static void ipic_ack_irq(struct irq_data *d)
 static void ipic_mask_irq_and_ack(struct irq_data *d)
 {
 	struct ipic *ipic = ipic_from_irq(d->irq);
-	unsigned int src = ipic_irq_to_hw(d->irq);
+	unsigned int src = irqd_to_hwirq(d);
 	unsigned long flags;
 	u32 temp;
 
@@ -604,7 +602,7 @@ static void ipic_mask_irq_and_ack(struct irq_data *d)
 static int ipic_set_irq_type(struct irq_data *d, unsigned int flow_type)
 {
 	struct ipic *ipic = ipic_from_irq(d->irq);
-	unsigned int src = ipic_irq_to_hw(d->irq);
+	unsigned int src = irqd_to_hwirq(d);
 	unsigned int vold, vnew, edibit;
 
 	if (flow_type == IRQ_TYPE_NONE)
@@ -793,7 +791,7 @@ struct ipic * __init ipic_init(struct device_node *node, unsigned int flags)
 int ipic_set_priority(unsigned int virq, unsigned int priority)
 {
 	struct ipic *ipic = ipic_from_irq(virq);
-	unsigned int src = ipic_irq_to_hw(virq);
+	unsigned int src = virq_to_hw(virq);
 	u32 temp;
 
 	if (priority > 7)
@@ -821,7 +819,7 @@ int ipic_set_priority(unsigned int virq, unsigned int priority)
 void ipic_set_highest_priority(unsigned int virq)
 {
 	struct ipic *ipic = ipic_from_irq(virq);
-	unsigned int src = ipic_irq_to_hw(virq);
+	unsigned int src = virq_to_hw(virq);
 	u32 temp;
 
 	temp = ipic_read(ipic->regs, IPIC_SICFR);
diff --git a/arch/powerpc/sysdev/mpc8xx_pic.c b/arch/powerpc/sysdev/mpc8xx_pic.c
index a88800f..20924f2 100644
--- a/arch/powerpc/sysdev/mpc8xx_pic.c
+++ b/arch/powerpc/sysdev/mpc8xx_pic.c
@@ -28,7 +28,7 @@ int cpm_get_irq(struct pt_regs *regs);
 static void mpc8xx_unmask_irq(struct irq_data *d)
 {
 	int	bit, word;
-	unsigned int irq_nr = (unsigned int)irq_map[d->irq].hwirq;
+	unsigned int irq_nr = (unsigned int)irqd_to_hwirq(d);
 
 	bit = irq_nr & 0x1f;
 	word = irq_nr >> 5;
@@ -40,7 +40,7 @@ static void mpc8xx_unmask_irq(struct irq_data *d)
 static void mpc8xx_mask_irq(struct irq_data *d)
 {
 	int	bit, word;
-	unsigned int irq_nr = (unsigned int)irq_map[d->irq].hwirq;
+	unsigned int irq_nr = (unsigned int)irqd_to_hwirq(d);
 
 	bit = irq_nr & 0x1f;
 	word = irq_nr >> 5;
@@ -52,7 +52,7 @@ static void mpc8xx_mask_irq(struct irq_data *d)
 static void mpc8xx_ack(struct irq_data *d)
 {
 	int	bit;
-	unsigned int irq_nr = (unsigned int)irq_map[d->irq].hwirq;
+	unsigned int irq_nr = (unsigned int)irqd_to_hwirq(d);
 
 	bit = irq_nr & 0x1f;
 	out_be32(&siu_reg->sc_sipend, 1 << (31-bit));
@@ -61,7 +61,7 @@ static void mpc8xx_ack(struct irq_data *d)
 static void mpc8xx_end_irq(struct irq_data *d)
 {
 	int bit, word;
-	unsigned int irq_nr = (unsigned int)irq_map[d->irq].hwirq;
+	unsigned int irq_nr = (unsigned int)irqd_to_hwirq(d);
 
 	bit = irq_nr & 0x1f;
 	word = irq_nr >> 5;
@@ -73,7 +73,7 @@ static void mpc8xx_end_irq(struct irq_data *d)
 static int mpc8xx_set_irq_type(struct irq_data *d, unsigned int flow_type)
 {
 	if (flow_type & IRQ_TYPE_EDGE_FALLING) {
-		irq_hw_number_t hw = (unsigned int)irq_map[d->irq].hwirq;
+		irq_hw_number_t hw = (unsigned int)irqd_to_hwirq(d);
 		unsigned int siel = in_be32(&siu_reg->sc_siel);
 
 		/* only external IRQ senses are programmable */
diff --git a/arch/powerpc/sysdev/mpc8xxx_gpio.c b/arch/powerpc/sysdev/mpc8xxx_gpio.c
index 0892a28..fb4963a 100644
--- a/arch/powerpc/sysdev/mpc8xxx_gpio.c
+++ b/arch/powerpc/sysdev/mpc8xxx_gpio.c
@@ -163,7 +163,7 @@ static void mpc8xxx_irq_unmask(struct irq_data *d)
 
 	spin_lock_irqsave(&mpc8xxx_gc->lock, flags);
 
-	setbits32(mm->regs + GPIO_IMR, mpc8xxx_gpio2mask(virq_to_hw(d->irq)));
+	setbits32(mm->regs + GPIO_IMR, mpc8xxx_gpio2mask(irqd_to_hwirq(d)));
 
 	spin_unlock_irqrestore(&mpc8xxx_gc->lock, flags);
 }
@@ -176,7 +176,7 @@ static void mpc8xxx_irq_mask(struct irq_data *d)
 
 	spin_lock_irqsave(&mpc8xxx_gc->lock, flags);
 
-	clrbits32(mm->regs + GPIO_IMR, mpc8xxx_gpio2mask(virq_to_hw(d->irq)));
+	clrbits32(mm->regs + GPIO_IMR, mpc8xxx_gpio2mask(irqd_to_hwirq(d)));
 
 	spin_unlock_irqrestore(&mpc8xxx_gc->lock, flags);
 }
@@ -186,7 +186,7 @@ static void mpc8xxx_irq_ack(struct irq_data *d)
 	struct mpc8xxx_gpio_chip *mpc8xxx_gc = irq_data_get_irq_chip_data(d);
 	struct of_mm_gpio_chip *mm = &mpc8xxx_gc->mm_gc;
 
-	out_be32(mm->regs + GPIO_IER, mpc8xxx_gpio2mask(virq_to_hw(d->irq)));
+	out_be32(mm->regs + GPIO_IER, mpc8xxx_gpio2mask(irqd_to_hwirq(d)));
 }
 
 static int mpc8xxx_irq_set_type(struct irq_data *d, unsigned int flow_type)
@@ -199,14 +199,14 @@ static int mpc8xxx_irq_set_type(struct irq_data *d, unsigned int flow_type)
 	case IRQ_TYPE_EDGE_FALLING:
 		spin_lock_irqsave(&mpc8xxx_gc->lock, flags);
 		setbits32(mm->regs + GPIO_ICR,
-			  mpc8xxx_gpio2mask(virq_to_hw(d->irq)));
+			  mpc8xxx_gpio2mask(irqd_to_hwirq(d)));
 		spin_unlock_irqrestore(&mpc8xxx_gc->lock, flags);
 		break;
 
 	case IRQ_TYPE_EDGE_BOTH:
 		spin_lock_irqsave(&mpc8xxx_gc->lock, flags);
 		clrbits32(mm->regs + GPIO_ICR,
-			  mpc8xxx_gpio2mask(virq_to_hw(d->irq)));
+			  mpc8xxx_gpio2mask(irqd_to_hwirq(d)));
 		spin_unlock_irqrestore(&mpc8xxx_gc->lock, flags);
 		break;
 
@@ -221,7 +221,7 @@ static int mpc512x_irq_set_type(struct irq_data *d, unsigned int flow_type)
 {
 	struct mpc8xxx_gpio_chip *mpc8xxx_gc = irq_data_get_irq_chip_data(d);
 	struct of_mm_gpio_chip *mm = &mpc8xxx_gc->mm_gc;
-	unsigned long gpio = virq_to_hw(d->irq);
+	unsigned long gpio = irqd_to_hwirq(d);
 	void __iomem *reg;
 	unsigned int shift;
 	unsigned long flags;
diff --git a/arch/powerpc/sysdev/mpic.c b/arch/powerpc/sysdev/mpic.c
index f91c065..824a94f 100644
--- a/arch/powerpc/sysdev/mpic.c
+++ b/arch/powerpc/sysdev/mpic.c
@@ -607,8 +607,6 @@ static int irq_choose_cpu(const struct cpumask *mask)
 }
 #endif
 
-#define mpic_irq_to_hw(virq)	((unsigned int)irq_map[virq].hwirq)
-
 /* Find an mpic associated with a given linux interrupt */
 static struct mpic *mpic_find(unsigned int irq)
 {
@@ -621,7 +619,7 @@ static struct mpic *mpic_find(unsigned int irq)
 /* Determine if the linux irq is an IPI */
 static unsigned int mpic_is_ipi(struct mpic *mpic, unsigned int irq)
 {
-	unsigned int src = mpic_irq_to_hw(irq);
+	unsigned int src = virq_to_hw(irq);
 
 	return (src >= mpic->ipi_vecs[0] && src <= mpic->ipi_vecs[3]);
 }
@@ -674,7 +672,7 @@ void mpic_unmask_irq(struct irq_data *d)
 {
 	unsigned int loops = 100000;
 	struct mpic *mpic = mpic_from_irq_data(d);
-	unsigned int src = mpic_irq_to_hw(d->irq);
+	unsigned int src = irqd_to_hwirq(d);
 
 	DBG("%p: %s: enable_irq: %d (src %d)\n", mpic, mpic->name, d->irq, src);
 
@@ -695,7 +693,7 @@ void mpic_mask_irq(struct irq_data *d)
 {
 	unsigned int loops = 100000;
 	struct mpic *mpic = mpic_from_irq_data(d);
-	unsigned int src = mpic_irq_to_hw(d->irq);
+	unsigned int src = irqd_to_hwirq(d);
 
 	DBG("%s: disable_irq: %d (src %d)\n", mpic->name, d->irq, src);
 
@@ -733,7 +731,7 @@ void mpic_end_irq(struct irq_data *d)
 static void mpic_unmask_ht_irq(struct irq_data *d)
 {
 	struct mpic *mpic = mpic_from_irq_data(d);
-	unsigned int src = mpic_irq_to_hw(d->irq);
+	unsigned int src = irqd_to_hwirq(d);
 
 	mpic_unmask_irq(d);
 
@@ -744,7 +742,7 @@ static void mpic_unmask_ht_irq(struct irq_data *d)
 static unsigned int mpic_startup_ht_irq(struct irq_data *d)
 {
 	struct mpic *mpic = mpic_from_irq_data(d);
-	unsigned int src = mpic_irq_to_hw(d->irq);
+	unsigned int src = irqd_to_hwirq(d);
 
 	mpic_unmask_irq(d);
 	mpic_startup_ht_interrupt(mpic, src, irqd_is_level_type(d));
@@ -755,7 +753,7 @@ static unsigned int mpic_startup_ht_irq(struct irq_data *d)
 static void mpic_shutdown_ht_irq(struct irq_data *d)
 {
 	struct mpic *mpic = mpic_from_irq_data(d);
-	unsigned int src = mpic_irq_to_hw(d->irq);
+	unsigned int src = irqd_to_hwirq(d);
 
 	mpic_shutdown_ht_interrupt(mpic, src);
 	mpic_mask_irq(d);
@@ -764,7 +762,7 @@ static void mpic_shutdown_ht_irq(struct irq_data *d)
 static void mpic_end_ht_irq(struct irq_data *d)
 {
 	struct mpic *mpic = mpic_from_irq_data(d);
-	unsigned int src = mpic_irq_to_hw(d->irq);
+	unsigned int src = irqd_to_hwirq(d);
 
 #ifdef DEBUG_IRQ
 	DBG("%s: end_irq: %d\n", mpic->name, d->irq);
@@ -785,7 +783,7 @@ static void mpic_end_ht_irq(struct irq_data *d)
 static void mpic_unmask_ipi(struct irq_data *d)
 {
 	struct mpic *mpic = mpic_from_ipi(d);
-	unsigned int src = mpic_irq_to_hw(d->irq) - mpic->ipi_vecs[0];
+	unsigned int src = virq_to_hw(d->irq) - mpic->ipi_vecs[0];
 
 	DBG("%s: enable_ipi: %d (ipi %d)\n", mpic->name, d->irq, src);
 	mpic_ipi_write(src, mpic_ipi_read(src) & ~MPIC_VECPRI_MASK);
@@ -816,7 +814,7 @@ int mpic_set_affinity(struct irq_data *d, const struct cpumask *cpumask,
 		      bool force)
 {
 	struct mpic *mpic = mpic_from_irq_data(d);
-	unsigned int src = mpic_irq_to_hw(d->irq);
+	unsigned int src = irqd_to_hwirq(d);
 
 	if (mpic->flags & MPIC_SINGLE_DEST_CPU) {
 		int cpuid = irq_choose_cpu(cpumask);
@@ -862,7 +860,7 @@ static unsigned int mpic_type_to_vecpri(struct mpic *mpic, unsigned int type)
 int mpic_set_irq_type(struct irq_data *d, unsigned int flow_type)
 {
 	struct mpic *mpic = mpic_from_irq_data(d);
-	unsigned int src = mpic_irq_to_hw(d->irq);
+	unsigned int src = irqd_to_hwirq(d);
 	unsigned int vecpri, vold, vnew;
 
 	DBG("mpic: set_irq_type(mpic:@%p,virq:%d,src:0x%x,type:0x%x)\n",
@@ -898,7 +896,7 @@ int mpic_set_irq_type(struct irq_data *d, unsigned int flow_type)
 void mpic_set_vector(unsigned int virq, unsigned int vector)
 {
 	struct mpic *mpic = mpic_from_irq(virq);
-	unsigned int src = mpic_irq_to_hw(virq);
+	unsigned int src = virq_to_hw(virq);
 	unsigned int vecpri;
 
 	DBG("mpic: set_vector(mpic:@%p,virq:%d,src:%d,vector:0x%x)\n",
@@ -916,7 +914,7 @@ void mpic_set_vector(unsigned int virq, unsigned int vector)
 void mpic_set_destination(unsigned int virq, unsigned int cpuid)
 {
 	struct mpic *mpic = mpic_from_irq(virq);
-	unsigned int src = mpic_irq_to_hw(virq);
+	unsigned int src = virq_to_hw(virq);
 
 	DBG("mpic: set_destination(mpic:@%p,virq:%d,src:%d,cpuid:0x%x)\n",
 	    mpic, virq, src, cpuid);
@@ -1427,7 +1425,7 @@ void __init mpic_set_serial_int(struct mpic *mpic, int enable)
 void mpic_irq_set_priority(unsigned int irq, unsigned int pri)
 {
 	struct mpic *mpic = mpic_find(irq);
-	unsigned int src = mpic_irq_to_hw(irq);
+	unsigned int src = virq_to_hw(irq);
 	unsigned long flags;
 	u32 reg;
 
diff --git a/arch/powerpc/sysdev/mv64x60_pic.c b/arch/powerpc/sysdev/mv64x60_pic.c
index e9c633c..14d1302 100644
--- a/arch/powerpc/sysdev/mv64x60_pic.c
+++ b/arch/powerpc/sysdev/mv64x60_pic.c
@@ -78,7 +78,7 @@ static struct irq_host *mv64x60_irq_host;
 
 static void mv64x60_mask_low(struct irq_data *d)
 {
-	int level2 = irq_map[d->irq].hwirq & MV64x60_LEVEL2_MASK;
+	int level2 = irqd_to_hwirq(d) & MV64x60_LEVEL2_MASK;
 	unsigned long flags;
 
 	spin_lock_irqsave(&mv64x60_lock, flags);
@@ -91,7 +91,7 @@ static void mv64x60_mask_low(struct irq_data *d)
 
 static void mv64x60_unmask_low(struct irq_data *d)
 {
-	int level2 = irq_map[d->irq].hwirq & MV64x60_LEVEL2_MASK;
+	int level2 = irqd_to_hwirq(d) & MV64x60_LEVEL2_MASK;
 	unsigned long flags;
 
 	spin_lock_irqsave(&mv64x60_lock, flags);
@@ -115,7 +115,7 @@ static struct irq_chip mv64x60_chip_low = {
 
 static void mv64x60_mask_high(struct irq_data *d)
 {
-	int level2 = irq_map[d->irq].hwirq & MV64x60_LEVEL2_MASK;
+	int level2 = irqd_to_hwirq(d) & MV64x60_LEVEL2_MASK;
 	unsigned long flags;
 
 	spin_lock_irqsave(&mv64x60_lock, flags);
@@ -128,7 +128,7 @@ static void mv64x60_mask_high(struct irq_data *d)
 
 static void mv64x60_unmask_high(struct irq_data *d)
 {
-	int level2 = irq_map[d->irq].hwirq & MV64x60_LEVEL2_MASK;
+	int level2 = irqd_to_hwirq(d) & MV64x60_LEVEL2_MASK;
 	unsigned long flags;
 
 	spin_lock_irqsave(&mv64x60_lock, flags);
@@ -152,7 +152,7 @@ static struct irq_chip mv64x60_chip_high = {
 
 static void mv64x60_mask_gpp(struct irq_data *d)
 {
-	int level2 = irq_map[d->irq].hwirq & MV64x60_LEVEL2_MASK;
+	int level2 = irqd_to_hwirq(d) & MV64x60_LEVEL2_MASK;
 	unsigned long flags;
 
 	spin_lock_irqsave(&mv64x60_lock, flags);
@@ -165,7 +165,7 @@ static void mv64x60_mask_gpp(struct irq_data *d)
 
 static void mv64x60_mask_ack_gpp(struct irq_data *d)
 {
-	int level2 = irq_map[d->irq].hwirq & MV64x60_LEVEL2_MASK;
+	int level2 = irqd_to_hwirq(d) & MV64x60_LEVEL2_MASK;
 	unsigned long flags;
 
 	spin_lock_irqsave(&mv64x60_lock, flags);
@@ -180,7 +180,7 @@ static void mv64x60_mask_ack_gpp(struct irq_data *d)
 
 static void mv64x60_unmask_gpp(struct irq_data *d)
 {
-	int level2 = irq_map[d->irq].hwirq & MV64x60_LEVEL2_MASK;
+	int level2 = irqd_to_hwirq(d) & MV64x60_LEVEL2_MASK;
 	unsigned long flags;
 
 	spin_lock_irqsave(&mv64x60_lock, flags);
diff --git a/arch/powerpc/sysdev/qe_lib/qe_ic.c b/arch/powerpc/sysdev/qe_lib/qe_ic.c
index 832d692..b2acda0 100644
--- a/arch/powerpc/sysdev/qe_lib/qe_ic.c
+++ b/arch/powerpc/sysdev/qe_lib/qe_ic.c
@@ -197,12 +197,10 @@ static inline struct qe_ic *qe_ic_from_irq_data(struct irq_data *d)
 	return irq_data_get_irq_chip_data(d);
 }
 
-#define virq_to_hw(virq)	((unsigned int)irq_map[virq].hwirq)
-
 static void qe_ic_unmask_irq(struct irq_data *d)
 {
 	struct qe_ic *qe_ic = qe_ic_from_irq_data(d);
-	unsigned int src = virq_to_hw(d->irq);
+	unsigned int src = irqd_to_hwirq(d);
 	unsigned long flags;
 	u32 temp;
 
@@ -218,7 +216,7 @@ static void qe_ic_unmask_irq(struct irq_data *d)
 static void qe_ic_mask_irq(struct irq_data *d)
 {
 	struct qe_ic *qe_ic = qe_ic_from_irq_data(d);
-	unsigned int src = virq_to_hw(d->irq);
+	unsigned int src = irqd_to_hwirq(d);
 	unsigned long flags;
 	u32 temp;
 
diff --git a/arch/powerpc/sysdev/uic.c b/arch/powerpc/sysdev/uic.c
index 5d91385..984cd20 100644
--- a/arch/powerpc/sysdev/uic.c
+++ b/arch/powerpc/sysdev/uic.c
@@ -41,8 +41,6 @@
 #define UIC_VR		0x7
 #define UIC_VCR		0x8
 
-#define uic_irq_to_hw(virq)	(irq_map[virq].hwirq)
-
 struct uic *primary_uic;
 
 struct uic {
@@ -58,7 +56,7 @@ struct uic {
 static void uic_unmask_irq(struct irq_data *d)
 {
 	struct uic *uic = irq_data_get_irq_chip_data(d);
-	unsigned int src = uic_irq_to_hw(d->irq);
+	unsigned int src = irqd_to_hwirq(d);
 	unsigned long flags;
 	u32 er, sr;
 
@@ -76,7 +74,7 @@ static void uic_unmask_irq(struct irq_data *d)
 static void uic_mask_irq(struct irq_data *d)
 {
 	struct uic *uic = irq_data_get_irq_chip_data(d);
-	unsigned int src = uic_irq_to_hw(d->irq);
+	unsigned int src = irqd_to_hwirq(d);
 	unsigned long flags;
 	u32 er;
 
@@ -90,7 +88,7 @@ static void uic_mask_irq(struct irq_data *d)
 static void uic_ack_irq(struct irq_data *d)
 {
 	struct uic *uic = irq_data_get_irq_chip_data(d);
-	unsigned int src = uic_irq_to_hw(d->irq);
+	unsigned int src = irqd_to_hwirq(d);
 	unsigned long flags;
 
 	spin_lock_irqsave(&uic->lock, flags);
@@ -101,7 +99,7 @@ static void uic_ack_irq(struct irq_data *d)
 static void uic_mask_ack_irq(struct irq_data *d)
 {
 	struct uic *uic = irq_data_get_irq_chip_data(d);
-	unsigned int src = uic_irq_to_hw(d->irq);
+	unsigned int src = irqd_to_hwirq(d);
 	unsigned long flags;
 	u32 er, sr;
 
@@ -126,7 +124,7 @@ static void uic_mask_ack_irq(struct irq_data *d)
 static int uic_set_irq_type(struct irq_data *d, unsigned int flow_type)
 {
 	struct uic *uic = irq_data_get_irq_chip_data(d);
-	unsigned int src = uic_irq_to_hw(d->irq);
+	unsigned int src = irqd_to_hwirq(d);
 	unsigned long flags;
 	int trigger, polarity;
 	u32 tr, pr, mask;
diff --git a/arch/powerpc/sysdev/xilinx_intc.c b/arch/powerpc/sysdev/xilinx_intc.c
index 0a13fc1..6183799 100644
--- a/arch/powerpc/sysdev/xilinx_intc.c
+++ b/arch/powerpc/sysdev/xilinx_intc.c
@@ -71,7 +71,7 @@ static unsigned char xilinx_intc_map_senses[] = {
  */
 static void xilinx_intc_mask(struct irq_data *d)
 {
-	int irq = virq_to_hw(d->irq);
+	int irq = irqd_to_hwirq(d);
 	void * regs = irq_data_get_irq_chip_data(d);
 	pr_debug("mask: %d\n", irq);
 	out_be32(regs + XINTC_CIE, 1 << irq);
@@ -87,7 +87,7 @@ static int xilinx_intc_set_type(struct irq_data *d, unsigned int flow_type)
  */
 static void xilinx_intc_level_unmask(struct irq_data *d)
 {
-	int irq = virq_to_hw(d->irq);
+	int irq = irqd_to_hwirq(d);
 	void * regs = irq_data_get_irq_chip_data(d);
 	pr_debug("unmask: %d\n", irq);
 	out_be32(regs + XINTC_SIE, 1 << irq);
@@ -112,7 +112,7 @@ static struct irq_chip xilinx_intc_level_irqchip = {
  */
 static void xilinx_intc_edge_unmask(struct irq_data *d)
 {
-	int irq = virq_to_hw(d->irq);
+	int irq = irqd_to_hwirq(d);
 	void *regs = irq_data_get_irq_chip_data(d);
 	pr_debug("unmask: %d\n", irq);
 	out_be32(regs + XINTC_SIE, 1 << irq);
@@ -120,7 +120,7 @@ static void xilinx_intc_edge_unmask(struct irq_data *d)
 
 static void xilinx_intc_edge_ack(struct irq_data *d)
 {
-	int irq = virq_to_hw(d->irq);
+	int irq = irqd_to_hwirq(d);
 	void * regs = irq_data_get_irq_chip_data(d);
 	pr_debug("ack: %d\n", irq);
 	out_be32(regs + XINTC_IAR, 1 << irq);

