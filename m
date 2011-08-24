Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756380Ab1HXAuh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Aug 2011 20:50:37 -0400
Received: from mga02.intel.com ([134.134.136.20]:64483 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756058Ab1HXAtl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Aug 2011 20:49:41 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,351,1309762800"; 
   d="scan'208";a="41195060"
Message-Id: <20110824001456.499225692@sbsiddha-desk.sc.intel.com>
User-Agent: quilt/0.48-1
Date: Tue, 23 Aug 2011 17:05:24 -0700
From: Suresh Siddha <suresh.b.siddha@intel.com>
To: mingo@elte.hu, tglx@linutronix.de, hpa@zytor.com, dwmw2@infradead.org
Cc: yinghai@kernel.org, youquan.song@intel.com, joerg.roedel@amd.com,
        tony.luck@intel.com, linux-kernel@vger.kernel.org,
        Suresh Siddha <suresh.b.siddha@intel.com>
Subject: [patch 7/8] x86, ioapic: define irq_remap_modify_chip_defaults()
References: <20110824000517.710353624@sbsiddha-desk.sc.intel.com>
Content-Disposition: inline; filename=ioapic_ifdef_intr_remap_cleanups.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

define irq_remap_modify_chip_defaults() and remove the duplicate code,
cleanup the unnecessary ifdefs.

Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
---
 arch/x86/include/asm/irq_remapping.h |    4 ++
 arch/x86/kernel/apic/io_apic.c       |   64 ++++++++++-------------------------
 2 files changed, 23 insertions(+), 45 deletions(-)

Index: tree/arch/x86/include/asm/irq_remapping.h
===================================================================
--- tree.orig/arch/x86/include/asm/irq_remapping.h
+++ tree/arch/x86/include/asm/irq_remapping.h
@@ -4,6 +4,7 @@
 #define IRTE_DEST(dest) ((x2apic_mode) ? dest : dest << 8)
 
 #ifdef CONFIG_INTR_REMAP
+static void irq_remap_modify_chip_defaults(struct irq_chip *chip);
 static inline void prepare_irte(struct irte *irte, int vector,
 			        unsigned int dest)
 {
@@ -36,6 +37,9 @@ static inline bool irq_remapped(struct i
 {
 	return false;
 }
+static inline void irq_remap_modify_chip_defaults(struct irq_chip *chip)
+{
+}
 #endif
 
 #endif	/* _ASM_X86_IRQ_REMAPPING_H */
Index: tree/arch/x86/kernel/apic/io_apic.c
===================================================================
--- tree.orig/arch/x86/kernel/apic/io_apic.c
+++ tree/arch/x86/kernel/apic/io_apic.c
@@ -1202,7 +1202,6 @@ void __setup_vector_irq(int cpu)
 }
 
 static struct irq_chip ioapic_chip;
-static struct irq_chip ir_ioapic_chip;
 
 #ifdef CONFIG_X86_32
 static inline int IO_APIC_irq_trigger(int irq)
@@ -1246,7 +1245,7 @@ static void ioapic_register_intr(unsigne
 
 	if (irq_remapped(cfg)) {
 		irq_set_status_flags(irq, IRQ_MOVE_PCNTXT);
-		chip = &ir_ioapic_chip;
+		irq_remap_modify_chip_defaults(chip);
 		fasteoi = trigger != 0;
 	}
 
@@ -2572,6 +2571,22 @@ static void ir_ack_apic_level(struct irq
 	ack_APIC_irq();
 	eoi_ioapic_irq(data->irq, data->chip_data);
 }
+
+static void ir_print_prefix(struct irq_data *data, struct seq_file *p)
+{
+	seq_printf(p, " IR-%s", data->chip->name);
+}
+
+static void irq_remap_modify_chip_defaults(struct irq_chip *chip)
+{
+	chip->irq_print_chip = ir_print_prefix;
+	chip->irq_ack = ir_ack_apic_edge;
+	chip->irq_eoi = ir_ack_apic_level;
+
+#ifdef CONFIG_SMP
+	chip->irq_set_affinity = ir_ioapic_set_affinity;
+#endif
+}
 #endif /* CONFIG_INTR_REMAP */
 
 static struct irq_chip ioapic_chip __read_mostly = {
@@ -2587,21 +2602,6 @@ static struct irq_chip ioapic_chip __rea
 	.irq_retrigger		= ioapic_retrigger_irq,
 };
 
-static struct irq_chip ir_ioapic_chip __read_mostly = {
-	.name			= "IR-IO-APIC",
-	.irq_startup		= startup_ioapic_irq,
-	.irq_mask		= mask_ioapic_irq,
-	.irq_unmask		= unmask_ioapic_irq,
-#ifdef CONFIG_INTR_REMAP
-	.irq_ack		= ir_ack_apic_edge,
-	.irq_eoi		= ir_ack_apic_level,
-#ifdef CONFIG_SMP
-	.irq_set_affinity	= ir_ioapic_set_affinity,
-#endif
-#endif
-	.irq_retrigger		= ioapic_retrigger_irq,
-};
-
 static inline void init_IO_APIC_traps(void)
 {
 	struct irq_cfg *cfg;
@@ -3170,19 +3170,6 @@ static struct irq_chip msi_chip = {
 	.irq_retrigger		= ioapic_retrigger_irq,
 };
 
-static struct irq_chip msi_ir_chip = {
-	.name			= "IR-PCI-MSI",
-	.irq_unmask		= unmask_msi_irq,
-	.irq_mask		= mask_msi_irq,
-#ifdef CONFIG_INTR_REMAP
-	.irq_ack		= ir_ack_apic_edge,
-#ifdef CONFIG_SMP
-	.irq_set_affinity	= ir_ioapic_set_affinity,
-#endif
-#endif
-	.irq_retrigger		= ioapic_retrigger_irq,
-};
-
 /*
  * Map the PCI dev to the corresponding remapping hardware unit
  * and allocate 'nvec' consecutive interrupt-remapping table entries
@@ -3225,7 +3212,7 @@ static int setup_msi_irq(struct pci_dev 
 
 	if (irq_remapped(irq_get_chip_data(irq))) {
 		irq_set_status_flags(irq, IRQ_MOVE_PCNTXT);
-		chip = &msi_ir_chip;
+		irq_remap_modify_chip_defaults(chip);
 	}
 
 	irq_set_chip_and_handler_name(irq, chip, handle_edge_irq, "edge");
@@ -3379,19 +3366,6 @@ static int hpet_msi_set_affinity(struct 
 
 #endif /* CONFIG_SMP */
 
-static struct irq_chip ir_hpet_msi_type = {
-	.name			= "IR-HPET_MSI",
-	.irq_unmask		= hpet_msi_unmask,
-	.irq_mask		= hpet_msi_mask,
-#ifdef CONFIG_INTR_REMAP
-	.irq_ack		= ir_ack_apic_edge,
-#ifdef CONFIG_SMP
-	.irq_set_affinity	= ir_ioapic_set_affinity,
-#endif
-#endif
-	.irq_retrigger		= ioapic_retrigger_irq,
-};
-
 static struct irq_chip hpet_msi_type = {
 	.name = "HPET_MSI",
 	.irq_unmask = hpet_msi_unmask,
@@ -3428,7 +3402,7 @@ int arch_setup_hpet_msi(unsigned int irq
 	hpet_msi_write(irq_get_handler_data(irq), &msg);
 	irq_set_status_flags(irq, IRQ_MOVE_PCNTXT);
 	if (irq_remapped(irq_get_chip_data(irq)))
-		chip = &ir_hpet_msi_type;
+		irq_remap_modify_chip_defaults(chip);
 
 	irq_set_chip_and_handler_name(irq, chip, handle_edge_irq, "edge");
 	return 0;


