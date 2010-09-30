Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756710Ab0I3XSB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Sep 2010 19:18:01 -0400
Received: from www.tglx.de ([62.245.132.106]:52970 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755261Ab0I3XR6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Sep 2010 19:17:58 -0400
Message-Id: <20100930221741.818158044@linutronix.de>
User-Agent: quilt/0.48-1
Date: Thu, 30 Sep 2010 23:17:27 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: linux-arch@vger.kernel.org, Linus Torvalds <torvalds@osdl.org>,
        Andrew Morton <akpm@linux-foundation.org>, x86@kernel.org,
        Peter Zijlstra <peterz@infradead.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mundt <lethal@linux-sh.org>,
        Russell King <linux@arm.linux.org.uk>,
        David Woodhouse <dwmw2@infradead.org>,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        Yinghai Lu <yinghai@kernel.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        "Eric W. Biederman" <ebiederm@xmission.com>
Subject: [patch 34/47] x86: ioapic: Convert irq affinity to new chip functions
References: <20100930221351.682772535@linutronix.de>
Content-Disposition: inline; filename=x86-ioapic-affinity.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/x86/include/asm/hw_irq.h  |    6 -
 arch/x86/kernel/apic/io_apic.c |  215 ++++++++++++++++-------------------------
 arch/x86/kernel/uv_irq.c       |    2 
 3 files changed, 90 insertions(+), 133 deletions(-)

Index: linux-2.6-tip/arch/x86/include/asm/hw_irq.h
===================================================================
--- linux-2.6-tip.orig/arch/x86/include/asm/hw_irq.h
+++ linux-2.6-tip/arch/x86/include/asm/hw_irq.h
@@ -95,9 +95,9 @@ extern struct irq_cfg *irq_cfg(unsigned 
 extern int assign_irq_vector(int, struct irq_cfg *, const struct cpumask *);
 extern void send_cleanup_vector(struct irq_cfg *);
 
-struct irq_desc;
-extern unsigned int set_desc_affinity(struct irq_desc *, const struct cpumask *,
-				      unsigned int *dest_id);
+struct irq_data;
+unsigned int __ioapic_set_affinity(struct irq_data *, const struct cpumask *,
+				   unsigned int *dest_id);
 extern int IO_APIC_get_PCI_irq_vector(int bus, int devfn, int pin, struct io_apic_irq_attr *irq_attr);
 extern void setup_ioapic_dest(void);
 
Index: linux-2.6-tip/arch/x86/kernel/apic/io_apic.c
===================================================================
--- linux-2.6-tip.orig/arch/x86/kernel/apic/io_apic.c
+++ linux-2.6-tip/arch/x86/kernel/apic/io_apic.c
@@ -2293,65 +2293,47 @@ static void __target_IO_APIC_irq(unsigne
 }
 
 /*
- * Either sets desc->affinity to a valid value, and returns
+ * Either sets data->affinity to a valid value, and returns
  * ->cpu_mask_to_apicid of that in dest_id, or returns -1 and
- * leaves desc->affinity untouched.
+ * leaves data->affinity untouched.
  */
 unsigned int
-set_desc_affinity(struct irq_desc *desc, const struct cpumask *mask,
-		  unsigned int *dest_id)
+__ioapic_set_affinity(struct irq_data *data, const struct cpumask *mask,
+		      unsigned int *dest_id)
 {
-	struct irq_cfg *cfg;
-	unsigned int irq;
+	struct irq_cfg *cfg = data->chip_data;
 
 	if (!cpumask_intersects(mask, cpu_online_mask))
 		return -1;
 
-	irq = desc->irq;
-	cfg = get_irq_desc_chip_data(desc);
-	if (assign_irq_vector(irq, cfg, mask))
+	if (assign_irq_vector(data->irq, data->chip_data, mask))
 		return -1;
 
-	cpumask_copy(desc->affinity, mask);
+	cpumask_copy(*data->affinity, mask);
 
-	*dest_id = apic->cpu_mask_to_apicid_and(desc->affinity, cfg->domain);
+	*dest_id = apic->cpu_mask_to_apicid_and(mask, cfg->domain);
 	return 0;
 }
 
 static int
-set_ioapic_affinity_irq_desc(struct irq_desc *desc, const struct cpumask *mask)
+ioapic_set_affinity(struct irq_data *data, const struct cpumask *mask,
+			     bool force)
 {
-	struct irq_cfg *cfg;
+	unsigned int dest, irq = data->irq;
 	unsigned long flags;
-	unsigned int dest;
-	unsigned int irq;
-	int ret = -1;
-
-	irq = desc->irq;
-	cfg = get_irq_desc_chip_data(desc);
+	int ret;
 
 	raw_spin_lock_irqsave(&ioapic_lock, flags);
-	ret = set_desc_affinity(desc, mask, &dest);
+	ret = __ioapic_set_affinity(data, mask, &dest);
 	if (!ret) {
 		/* Only the high 8 bits are valid. */
 		dest = SET_APIC_LOGICAL_ID(dest);
-		__target_IO_APIC_irq(irq, dest, cfg);
+		__target_IO_APIC_irq(irq, dest, data->chip_data);
 	}
 	raw_spin_unlock_irqrestore(&ioapic_lock, flags);
-
 	return ret;
 }
 
-static int
-set_ioapic_affinity_irq(unsigned int irq, const struct cpumask *mask)
-{
-	struct irq_desc *desc;
-
-	desc = irq_to_desc(irq);
-
-	return set_ioapic_affinity_irq_desc(desc, mask);
-}
-
 #ifdef CONFIG_INTR_REMAP
 
 /*
@@ -2366,24 +2348,21 @@ set_ioapic_affinity_irq(unsigned int irq
  * the interrupt-remapping table entry.
  */
 static int
-migrate_ioapic_irq_desc(struct irq_desc *desc, const struct cpumask *mask)
+ir_ioapic_set_affinity(struct irq_data *data, const struct cpumask *mask,
+		       bool force)
 {
-	struct irq_cfg *cfg;
+	struct irq_cfg *cfg = data->chip_data;
+	unsigned int dest, irq = data->irq;
 	struct irte irte;
-	unsigned int dest;
-	unsigned int irq;
-	int ret = -1;
 
 	if (!cpumask_intersects(mask, cpu_online_mask))
-		return ret;
+		return -EINVAL;
 
-	irq = desc->irq;
 	if (get_irte(irq, &irte))
-		return ret;
+		return -EBUSY;
 
-	cfg = get_irq_desc_chip_data(desc);
 	if (assign_irq_vector(irq, cfg, mask))
-		return ret;
+		return -EBUSY;
 
 	dest = apic->cpu_mask_to_apicid_and(cfg->domain, mask);
 
@@ -2398,29 +2377,14 @@ migrate_ioapic_irq_desc(struct irq_desc 
 	if (cfg->move_in_progress)
 		send_cleanup_vector(cfg);
 
-	cpumask_copy(desc->affinity, mask);
-
+	cpumask_copy(*data->affinity, mask);
 	return 0;
 }
 
-/*
- * Migrates the IRQ destination in the process context.
- */
-static int set_ir_ioapic_affinity_irq_desc(struct irq_desc *desc,
-					    const struct cpumask *mask)
-{
-	return migrate_ioapic_irq_desc(desc, mask);
-}
-static int set_ir_ioapic_affinity_irq(unsigned int irq,
-				       const struct cpumask *mask)
-{
-	struct irq_desc *desc = irq_to_desc(irq);
-
-	return set_ir_ioapic_affinity_irq_desc(desc, mask);
-}
 #else
-static inline int set_ir_ioapic_affinity_irq_desc(struct irq_desc *desc,
-						   const struct cpumask *mask)
+static inline int
+ir_ioapic_set_affinity(struct irq_data *data, const struct cpumask *mask,
+		       bool force)
 {
 	return 0;
 }
@@ -2682,31 +2646,31 @@ static void ir_ack_apic_level(struct irq
 #endif /* CONFIG_INTR_REMAP */
 
 static struct irq_chip ioapic_chip __read_mostly = {
-	.name		= "IO-APIC",
-	.irq_startup	= startup_ioapic_irq,
-	.irq_mask	= mask_ioapic_irq,
-	.irq_unmask	= unmask_ioapic_irq,
-	.irq_ack	= ack_apic_edge,
-	.irq_eoi	= ack_apic_level,
+	.name			= "IO-APIC",
+	.irq_startup		= startup_ioapic_irq,
+	.irq_mask		= mask_ioapic_irq,
+	.irq_unmask		= unmask_ioapic_irq,
+	.irq_ack		= ack_apic_edge,
+	.irq_eoi		= ack_apic_level,
 #ifdef CONFIG_SMP
-	.set_affinity	= set_ioapic_affinity_irq,
+	.irq_set_affinity	= ioapic_set_affinity,
 #endif
-	.irq_retrigger	= ioapic_retrigger_irq,
+	.irq_retrigger		= ioapic_retrigger_irq,
 };
 
 static struct irq_chip ir_ioapic_chip __read_mostly = {
-	.name		= "IR-IO-APIC",
-	.irq_startup	= startup_ioapic_irq,
-	.irq_mask	= mask_ioapic_irq,
-	.irq_unmask	= unmask_ioapic_irq,
+	.name			= "IR-IO-APIC",
+	.irq_startup		= startup_ioapic_irq,
+	.irq_mask		= mask_ioapic_irq,
+	.irq_unmask		= unmask_ioapic_irq,
 #ifdef CONFIG_INTR_REMAP
-	.irq_ack	= ir_ack_apic_edge,
-	.irq_eoi	= ir_ack_apic_level,
+	.irq_ack		= ir_ack_apic_edge,
+	.irq_eoi		= ir_ack_apic_level,
 #ifdef CONFIG_SMP
-	.set_affinity	= set_ir_ioapic_affinity_irq,
+	.irq_set_affinity	= ir_ioapic_set_affinity,
 #endif
 #endif
-	.irq_retrigger	= ioapic_retrigger_irq,
+	.irq_retrigger		= ioapic_retrigger_irq,
 };
 
 static inline void init_IO_APIC_traps(void)
@@ -3341,26 +3305,24 @@ static int msi_compose_msg(struct pci_de
 }
 
 #ifdef CONFIG_SMP
-static int set_msi_irq_affinity(unsigned int irq, const struct cpumask *mask)
+static int
+msi_set_affinity(struct irq_data *data, const struct cpumask *mask, bool force)
 {
-	struct irq_desc *desc = irq_to_desc(irq);
-	struct irq_cfg *cfg;
+	struct irq_cfg *cfg = data->chip_data;
 	struct msi_msg msg;
 	unsigned int dest;
 
-	if (set_desc_affinity(desc, mask, &dest))
+	if (__ioapic_set_affinity(data, mask, &dest))
 		return -1;
 
-	cfg = get_irq_desc_chip_data(desc);
-
-	__get_cached_msi_msg(desc->irq_data.msi_desc, &msg);
+	__get_cached_msi_msg(data->msi_desc, &msg);
 
 	msg.data &= ~MSI_DATA_VECTOR_MASK;
 	msg.data |= MSI_DATA_VECTOR(cfg->vector);
 	msg.address_lo &= ~MSI_ADDR_DEST_ID_MASK;
 	msg.address_lo |= MSI_ADDR_DEST_ID(dest);
 
-	__write_msi_msg(desc->irq_data.msi_desc, &msg);
+	__write_msi_msg(data->msi_desc, &msg);
 
 	return 0;
 }
@@ -3370,17 +3332,17 @@ static int set_msi_irq_affinity(unsigned
  * done in the process context using interrupt-remapping hardware.
  */
 static int
-ir_set_msi_irq_affinity(unsigned int irq, const struct cpumask *mask)
+ir_msi_set_affinity(struct irq_data *data, const struct cpumask *mask,
+		    bool force)
 {
-	struct irq_desc *desc = irq_to_desc(irq);
-	struct irq_cfg *cfg = get_irq_desc_chip_data(desc);
-	unsigned int dest;
+	struct irq_cfg *cfg = data->chip_data;
+	unsigned int dest, irq = data->irq;
 	struct irte irte;
 
 	if (get_irte(irq, &irte))
 		return -1;
 
-	if (set_desc_affinity(desc, mask, &dest))
+	if (__ioapic_set_affinity(data, mask, &dest))
 		return -1;
 
 	irte.vector = cfg->vector;
@@ -3410,27 +3372,27 @@ ir_set_msi_irq_affinity(unsigned int irq
  * which implement the MSI or MSI-X Capability Structure.
  */
 static struct irq_chip msi_chip = {
-	.name		= "PCI-MSI",
-	.irq_unmask	= unmask_msi_irq,
-	.irq_mask	= mask_msi_irq,
-	.irq_ack	= ack_apic_edge,
+	.name			= "PCI-MSI",
+	.irq_unmask		= unmask_msi_irq,
+	.irq_mask		= mask_msi_irq,
+	.irq_ack		= ack_apic_edge,
 #ifdef CONFIG_SMP
-	.set_affinity	= set_msi_irq_affinity,
+	.irq_set_affinity	= msi_set_affinity,
 #endif
-	.irq_retrigger	= ioapic_retrigger_irq,
+	.irq_retrigger		= ioapic_retrigger_irq,
 };
 
 static struct irq_chip msi_ir_chip = {
-	.name		= "IR-PCI-MSI",
-	.irq_unmask	= unmask_msi_irq,
-	.irq_mask	= mask_msi_irq,
+	.name			= "IR-PCI-MSI",
+	.irq_unmask		= unmask_msi_irq,
+	.irq_mask		= mask_msi_irq,
 #ifdef CONFIG_INTR_REMAP
-	.irq_ack	= ir_ack_apic_edge,
+	.irq_ack		= ir_ack_apic_edge,
 #ifdef CONFIG_SMP
-	.set_affinity	= ir_set_msi_irq_affinity,
+	.irq_set_affinity	= ir_msi_set_affinity,
 #endif
 #endif
-	.irq_retrigger	= ioapic_retrigger_irq,
+	.irq_retrigger		= ioapic_retrigger_irq,
 };
 
 /*
@@ -3548,18 +3510,17 @@ void arch_teardown_msi_irq(unsigned int 
 
 #if defined (CONFIG_DMAR) || defined (CONFIG_INTR_REMAP)
 #ifdef CONFIG_SMP
-static int dmar_msi_set_affinity(unsigned int irq, const struct cpumask *mask)
+static int
+dmar_msi_set_affinity(struct irq_data *data, const struct cpumask *mask,
+		      bool force)
 {
-	struct irq_desc *desc = irq_to_desc(irq);
-	struct irq_cfg *cfg;
+	struct irq_cfg *cfg = data->chip_data;
+	unsigned int dest, irq = data->irq;
 	struct msi_msg msg;
-	unsigned int dest;
 
-	if (set_desc_affinity(desc, mask, &dest))
+	if (__ioapic_set_affinity(data, mask, &dest))
 		return -1;
 
-	cfg = get_irq_desc_chip_data(desc);
-
 	dmar_msi_read(irq, &msg);
 
 	msg.data &= ~MSI_DATA_VECTOR_MASK;
@@ -3580,7 +3541,7 @@ static struct irq_chip dmar_msi_type = {
 	.irq_mask = dmar_msi_mask,
 	.irq_ack = ack_apic_edge,
 #ifdef CONFIG_SMP
-	.set_affinity = dmar_msi_set_affinity,
+	.irq_set_affinity = dmar_msi_set_affinity,
 #endif
 	.irq_retrigger = ioapic_retrigger_irq,
 };
@@ -3606,12 +3567,11 @@ int arch_setup_dmar_msi(unsigned int irq
 static int hpet_msi_set_affinity(struct irq_data *data,
 				 const struct cpumask *mask, bool force)
 {
-	struct irq_desc *desc = irq_to_desc(data->irq);
 	struct irq_cfg *cfg = data->chip_data;
 	struct msi_msg msg;
 	unsigned int dest;
 
-	if (set_desc_affinity(desc, mask, &dest))
+	if (__ioapic_set_affinity(data, mask, &dest))
 		return -1;
 
 	hpet_msi_read(data->handler_data, &msg);
@@ -3635,7 +3595,7 @@ static struct irq_chip ir_hpet_msi_type 
 #ifdef CONFIG_INTR_REMAP
 	.irq_ack = ir_ack_apic_edge,
 #ifdef CONFIG_SMP
-	.set_affinity = ir_set_msi_irq_affinity,
+	.irq_set_affinity = ir_msi_set_affinity,
 #endif
 #endif
 	.irq_retrigger = ioapic_retrigger_irq,
@@ -3708,33 +3668,30 @@ static void target_ht_irq(unsigned int i
 	write_ht_irq_msg(irq, &msg);
 }
 
-static int set_ht_irq_affinity(unsigned int irq, const struct cpumask *mask)
+static int
+ht_set_affinity(struct irq_data *data, const struct cpumask *mask, bool force)
 {
-	struct irq_desc *desc = irq_to_desc(irq);
-	struct irq_cfg *cfg;
+	struct irq_cfg *cfg = data->chip_data;
 	unsigned int dest;
 
-	if (set_desc_affinity(desc, mask, &dest))
+	if (__ioapic_set_affinity(data, mask, &dest))
 		return -1;
 
-	cfg = get_irq_desc_chip_data(desc);
-
-	target_ht_irq(irq, dest, cfg->vector);
-
+	target_ht_irq(data->irq, dest, cfg->vector);
 	return 0;
 }
 
 #endif
 
 static struct irq_chip ht_irq_chip = {
-	.name		= "PCI-HT",
-	.irq_mask	= mask_ht_irq,
-	.irq_unmask	= unmask_ht_irq,
-	.irq_ack	= ack_apic_edge,
+	.name			= "PCI-HT",
+	.irq_mask		= mask_ht_irq,
+	.irq_unmask		= unmask_ht_irq,
+	.irq_ack		= ack_apic_edge,
 #ifdef CONFIG_SMP
-	.set_affinity	= set_ht_irq_affinity,
+	.irq_set_affinity	= ht_set_affinity,
 #endif
-	.irq_retrigger	= ioapic_retrigger_irq,
+	.irq_retrigger		= ioapic_retrigger_irq,
 };
 
 int arch_setup_ht_irq(unsigned int irq, struct pci_dev *dev)
@@ -4071,9 +4028,9 @@ void __init setup_ioapic_dest(void)
 			mask = apic->target_cpus();
 
 		if (intr_remapping_enabled)
-			set_ir_ioapic_affinity_irq_desc(desc, mask);
+			ir_ioapic_set_affinity(&desc->irq_data, mask, false);
 		else
-			set_ioapic_affinity_irq_desc(desc, mask);
+			ioapic_set_affinity(&desc->irq_data, mask, false);
 	}
 
 }
Index: linux-2.6-tip/arch/x86/kernel/uv_irq.c
===================================================================
--- linux-2.6-tip.orig/arch/x86/kernel/uv_irq.c
+++ linux-2.6-tip/arch/x86/kernel/uv_irq.c
@@ -216,7 +216,7 @@ static int uv_set_irq_affinity(unsigned 
 	unsigned long mmr_offset;
 	int mmr_pnode;
 
-	if (set_desc_affinity(desc, mask, &dest))
+	if (__ioapic_set_affinity(&desc->irq_data, mask, &dest))
 		return -1;
 
 	mmr_value = 0;


