Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759267Ab2EUUFK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2012 16:05:10 -0400
Received: from mail-wg0-f42.google.com ([74.125.82.42]:44001 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750945Ab2EUUFH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2012 16:05:07 -0400
Date: Mon, 21 May 2012 22:05:00 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Joerg Roedel <joerg.roedel@amd.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] core/iommu changes for v3.5
Message-ID: <20120521200459.GA9014@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest core-iommu-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git core-iommu-for-linus

   HEAD: fefe1ed1398b81e3fadc92d11d91162d343c8836 iommu: Fix off by one in dmar_get_fault_reason()

The IOMMU changes in this cycle are mostly about factoring out 
Intel-VT-d specific IRQ remapping details and introducing struct 
irq_remap_ops, in preparation for AMD specific hardware.

 Thanks,

	Ingo

------------------>
Dan Carpenter (1):
      iommu: Fix off by one in dmar_get_fault_reason()

Joerg Roedel (8):
      iommu: Rename intr_remapping files to intel_intr_remapping
      iommu/vt-d: Make intr-remapping initialization generic
      iommu/vt-d: Convert missing apic.c intr-remapping call to remap_ops
      iommu/vt-d: Convert IR ioapic-setup to use remap_ops
      iommu/vt-d: Convert IR set_affinity function to remap_ops
      iommu/vt-d: Convert free_irte into a remap_ops callback
      iommu/vt-d: Convert MSI remapping setup to remap_ops
      x86, iommu/vt-d: Clean up interfaces for interrupt remapping

Suresh Siddha (5):
      iommu: rename intr_remapping references to irq_remapping
      iommu: rename intr_remapping.[ch] to irq_remapping.[ch]
      irq_remap: Fix compiler warning with CONFIG_IRQ_REMAP=y
      irq_remap: Fix UP build failure
      irq_remap: Fix the 'sub_handle' uninitialized warning


 arch/ia64/include/asm/irq_remapping.h              |    4 +
 arch/x86/include/asm/irq_remapping.h               |  118 +++++--
 arch/x86/kernel/apic/apic.c                        |   30 +-
 arch/x86/kernel/apic/io_apic.c                     |  297 ++++-------------
 drivers/iommu/Makefile                             |    2 +-
 drivers/iommu/dmar.c                               |   11 +-
 drivers/iommu/intel-iommu.c                        |    3 +-
 .../{intr_remapping.c => intel_irq_remapping.c}    |  359 ++++++++++++++++----
 drivers/iommu/intr_remapping.h                     |   17 -
 drivers/iommu/irq_remapping.c                      |  166 +++++++++
 drivers/iommu/irq_remapping.h                      |   90 +++++
 include/linux/dmar.h                               |   85 -----
 12 files changed, 731 insertions(+), 451 deletions(-)
 create mode 100644 arch/ia64/include/asm/irq_remapping.h
 rename drivers/iommu/{intr_remapping.c => intel_irq_remapping.c} (66%)
 delete mode 100644 drivers/iommu/intr_remapping.h
 create mode 100644 drivers/iommu/irq_remapping.c
 create mode 100644 drivers/iommu/irq_remapping.h

diff --git a/arch/ia64/include/asm/irq_remapping.h b/arch/ia64/include/asm/irq_remapping.h
new file mode 100644
index 0000000..a8687b1
--- /dev/null
+++ b/arch/ia64/include/asm/irq_remapping.h
@@ -0,0 +1,4 @@
+#ifndef __IA64_INTR_REMAPPING_H
+#define __IA64_INTR_REMAPPING_H
+#define irq_remapping_enabled 0
+#endif
diff --git a/arch/x86/include/asm/irq_remapping.h b/arch/x86/include/asm/irq_remapping.h
index 47d9993..5fb9bbb 100644
--- a/arch/x86/include/asm/irq_remapping.h
+++ b/arch/x86/include/asm/irq_remapping.h
@@ -1,45 +1,101 @@
-#ifndef _ASM_X86_IRQ_REMAPPING_H
-#define _ASM_X86_IRQ_REMAPPING_H
+/*
+ * Copyright (C) 2012 Advanced Micro Devices, Inc.
+ * Author: Joerg Roedel <joerg.roedel@amd.com>
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License version 2 as published
+ * by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307 USA
+ *
+ * This header file contains the interface of the interrupt remapping code to
+ * the x86 interrupt management code.
+ */
 
-#define IRTE_DEST(dest) ((x2apic_mode) ? dest : dest << 8)
+#ifndef __X86_IRQ_REMAPPING_H
+#define __X86_IRQ_REMAPPING_H
+
+#include <asm/io_apic.h>
 
 #ifdef CONFIG_IRQ_REMAP
-static void irq_remap_modify_chip_defaults(struct irq_chip *chip);
-static inline void prepare_irte(struct irte *irte, int vector,
-			        unsigned int dest)
+
+extern int irq_remapping_enabled;
+
+extern void setup_irq_remapping_ops(void);
+extern int irq_remapping_supported(void);
+extern int irq_remapping_prepare(void);
+extern int irq_remapping_enable(void);
+extern void irq_remapping_disable(void);
+extern int irq_remapping_reenable(int);
+extern int irq_remap_enable_fault_handling(void);
+extern int setup_ioapic_remapped_entry(int irq,
+				       struct IO_APIC_route_entry *entry,
+				       unsigned int destination,
+				       int vector,
+				       struct io_apic_irq_attr *attr);
+extern int set_remapped_irq_affinity(struct irq_data *data,
+				     const struct cpumask *mask,
+				     bool force);
+extern void free_remapped_irq(int irq);
+extern void compose_remapped_msi_msg(struct pci_dev *pdev,
+				     unsigned int irq, unsigned int dest,
+				     struct msi_msg *msg, u8 hpet_id);
+extern int msi_alloc_remapped_irq(struct pci_dev *pdev, int irq, int nvec);
+extern int msi_setup_remapped_irq(struct pci_dev *pdev, unsigned int irq,
+				  int index, int sub_handle);
+extern int setup_hpet_msi_remapped(unsigned int irq, unsigned int id);
+
+#else  /* CONFIG_IRQ_REMAP */
+
+#define irq_remapping_enabled	0
+
+static inline void setup_irq_remapping_ops(void) { }
+static inline int irq_remapping_supported(void) { return 0; }
+static inline int irq_remapping_prepare(void) { return -ENODEV; }
+static inline int irq_remapping_enable(void) { return -ENODEV; }
+static inline void irq_remapping_disable(void) { }
+static inline int irq_remapping_reenable(int eim) { return -ENODEV; }
+static inline int irq_remap_enable_fault_handling(void) { return -ENODEV; }
+static inline int setup_ioapic_remapped_entry(int irq,
+					      struct IO_APIC_route_entry *entry,
+					      unsigned int destination,
+					      int vector,
+					      struct io_apic_irq_attr *attr)
+{
+	return -ENODEV;
+}
+static inline int set_remapped_irq_affinity(struct irq_data *data,
+					    const struct cpumask *mask,
+					    bool force)
 {
-	memset(irte, 0, sizeof(*irte));
-
-	irte->present = 1;
-	irte->dst_mode = apic->irq_dest_mode;
-	/*
-	 * Trigger mode in the IRTE will always be edge, and for IO-APIC, the
-	 * actual level or edge trigger will be setup in the IO-APIC
-	 * RTE. This will help simplify level triggered irq migration.
-	 * For more details, see the comments (in io_apic.c) explainig IO-APIC
-	 * irq migration in the presence of interrupt-remapping.
-	*/
-	irte->trigger_mode = 0;
-	irte->dlvry_mode = apic->irq_delivery_mode;
-	irte->vector = vector;
-	irte->dest_id = IRTE_DEST(dest);
-	irte->redir_hint = 1;
+	return 0;
 }
-static inline bool irq_remapped(struct irq_cfg *cfg)
+static inline void free_remapped_irq(int irq) { }
+static inline void compose_remapped_msi_msg(struct pci_dev *pdev,
+					    unsigned int irq, unsigned int dest,
+					    struct msi_msg *msg, u8 hpet_id)
 {
-	return cfg->irq_2_iommu.iommu != NULL;
 }
-#else
-static void prepare_irte(struct irte *irte, int vector, unsigned int dest)
+static inline int msi_alloc_remapped_irq(struct pci_dev *pdev, int irq, int nvec)
 {
+	return -ENODEV;
 }
-static inline bool irq_remapped(struct irq_cfg *cfg)
+static inline int msi_setup_remapped_irq(struct pci_dev *pdev, unsigned int irq,
+					 int index, int sub_handle)
 {
-	return false;
+	return -ENODEV;
 }
-static inline void irq_remap_modify_chip_defaults(struct irq_chip *chip)
+static inline int setup_hpet_msi_remapped(unsigned int irq, unsigned int id)
 {
+	return -ENODEV;
 }
-#endif
+#endif /* CONFIG_IRQ_REMAP */
 
-#endif	/* _ASM_X86_IRQ_REMAPPING_H */
+#endif /* __X86_IRQ_REMAPPING_H */
diff --git a/arch/x86/kernel/apic/apic.c b/arch/x86/kernel/apic/apic.c
index edc2448..3722179 100644
--- a/arch/x86/kernel/apic/apic.c
+++ b/arch/x86/kernel/apic/apic.c
@@ -35,6 +35,7 @@
 #include <linux/smp.h>
 #include <linux/mm.h>
 
+#include <asm/irq_remapping.h>
 #include <asm/perf_event.h>
 #include <asm/x86_init.h>
 #include <asm/pgalloc.h>
@@ -1441,8 +1442,8 @@ void __init bsp_end_local_APIC_setup(void)
 	 * Now that local APIC setup is completed for BP, configure the fault
 	 * handling for interrupt remapping.
 	 */
-	if (intr_remapping_enabled)
-		enable_drhd_fault_handling();
+	if (irq_remapping_enabled)
+		irq_remap_enable_fault_handling();
 
 }
 
@@ -1517,7 +1518,7 @@ void enable_x2apic(void)
 int __init enable_IR(void)
 {
 #ifdef CONFIG_IRQ_REMAP
-	if (!intr_remapping_supported()) {
+	if (!irq_remapping_supported()) {
 		pr_debug("intr-remapping not supported\n");
 		return -1;
 	}
@@ -1528,7 +1529,7 @@ int __init enable_IR(void)
 		return -1;
 	}
 
-	return enable_intr_remapping();
+	return irq_remapping_enable();
 #endif
 	return -1;
 }
@@ -1537,10 +1538,13 @@ void __init enable_IR_x2apic(void)
 {
 	unsigned long flags;
 	int ret, x2apic_enabled = 0;
-	int dmar_table_init_ret;
+	int hardware_init_ret;
 
-	dmar_table_init_ret = dmar_table_init();
-	if (dmar_table_init_ret && !x2apic_supported())
+	/* Make sure irq_remap_ops are initialized */
+	setup_irq_remapping_ops();
+
+	hardware_init_ret = irq_remapping_prepare();
+	if (hardware_init_ret && !x2apic_supported())
 		return;
 
 	ret = save_ioapic_entries();
@@ -1556,7 +1560,7 @@ void __init enable_IR_x2apic(void)
 	if (x2apic_preenabled && nox2apic)
 		disable_x2apic();
 
-	if (dmar_table_init_ret)
+	if (hardware_init_ret)
 		ret = -1;
 	else
 		ret = enable_IR();
@@ -2176,8 +2180,8 @@ static int lapic_suspend(void)
 	local_irq_save(flags);
 	disable_local_APIC();
 
-	if (intr_remapping_enabled)
-		disable_intr_remapping();
+	if (irq_remapping_enabled)
+		irq_remapping_disable();
 
 	local_irq_restore(flags);
 	return 0;
@@ -2193,7 +2197,7 @@ static void lapic_resume(void)
 		return;
 
 	local_irq_save(flags);
-	if (intr_remapping_enabled) {
+	if (irq_remapping_enabled) {
 		/*
 		 * IO-APIC and PIC have their own resume routines.
 		 * We just mask them here to make sure the interrupt
@@ -2245,8 +2249,8 @@ static void lapic_resume(void)
 	apic_write(APIC_ESR, 0);
 	apic_read(APIC_ESR);
 
-	if (intr_remapping_enabled)
-		reenable_intr_remapping(x2apic_mode);
+	if (irq_remapping_enabled)
+		irq_remapping_reenable(x2apic_mode);
 
 	local_irq_restore(flags);
 }
diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
index e88300d..ef0648c 100644
--- a/arch/x86/kernel/apic/io_apic.c
+++ b/arch/x86/kernel/apic/io_apic.c
@@ -86,6 +86,22 @@ void __init set_io_apic_ops(const struct io_apic_ops *ops)
 	io_apic_ops = *ops;
 }
 
+#ifdef CONFIG_IRQ_REMAP
+static void irq_remap_modify_chip_defaults(struct irq_chip *chip);
+static inline bool irq_remapped(struct irq_cfg *cfg)
+{
+	return cfg->irq_2_iommu.iommu != NULL;
+}
+#else
+static inline bool irq_remapped(struct irq_cfg *cfg)
+{
+	return false;
+}
+static inline void irq_remap_modify_chip_defaults(struct irq_chip *chip)
+{
+}
+#endif
+
 /*
  *      Is the SiS APIC rmw bug present ?
  *      -1 = don't know, 0 = no, 1 = yes
@@ -1361,77 +1377,13 @@ static void ioapic_register_intr(unsigned int irq, struct irq_cfg *cfg,
 				      fasteoi ? "fasteoi" : "edge");
 }
 
-
-static int setup_ir_ioapic_entry(int irq,
-			      struct IR_IO_APIC_route_entry *entry,
-			      unsigned int destination, int vector,
-			      struct io_apic_irq_attr *attr)
-{
-	int index;
-	struct irte irte;
-	int ioapic_id = mpc_ioapic_id(attr->ioapic);
-	struct intel_iommu *iommu = map_ioapic_to_ir(ioapic_id);
-
-	if (!iommu) {
-		pr_warn("No mapping iommu for ioapic %d\n", ioapic_id);
-		return -ENODEV;
-	}
-
-	index = alloc_irte(iommu, irq, 1);
-	if (index < 0) {
-		pr_warn("Failed to allocate IRTE for ioapic %d\n", ioapic_id);
-		return -ENOMEM;
-	}
-
-	prepare_irte(&irte, vector, destination);
-
-	/* Set source-id of interrupt request */
-	set_ioapic_sid(&irte, ioapic_id);
-
-	modify_irte(irq, &irte);
-
-	apic_printk(APIC_VERBOSE, KERN_DEBUG "IOAPIC[%d]: "
-		"Set IRTE entry (P:%d FPD:%d Dst_Mode:%d "
-		"Redir_hint:%d Trig_Mode:%d Dlvry_Mode:%X "
-		"Avail:%X Vector:%02X Dest:%08X "
-		"SID:%04X SQ:%X SVT:%X)\n",
-		attr->ioapic, irte.present, irte.fpd, irte.dst_mode,
-		irte.redir_hint, irte.trigger_mode, irte.dlvry_mode,
-		irte.avail, irte.vector, irte.dest_id,
-		irte.sid, irte.sq, irte.svt);
-
-	memset(entry, 0, sizeof(*entry));
-
-	entry->index2	= (index >> 15) & 0x1;
-	entry->zero	= 0;
-	entry->format	= 1;
-	entry->index	= (index & 0x7fff);
-	/*
-	 * IO-APIC RTE will be configured with virtual vector.
-	 * irq handler will do the explicit EOI to the io-apic.
-	 */
-	entry->vector	= attr->ioapic_pin;
-	entry->mask	= 0;			/* enable IRQ */
-	entry->trigger	= attr->trigger;
-	entry->polarity	= attr->polarity;
-
-	/* Mask level triggered irqs.
-	 * Use IRQ_DELAYED_DISABLE for edge triggered irqs.
-	 */
-	if (attr->trigger)
-		entry->mask = 1;
-
-	return 0;
-}
-
 static int setup_ioapic_entry(int irq, struct IO_APIC_route_entry *entry,
 			       unsigned int destination, int vector,
 			       struct io_apic_irq_attr *attr)
 {
-	if (intr_remapping_enabled)
-		return setup_ir_ioapic_entry(irq,
-			 (struct IR_IO_APIC_route_entry *)entry,
-			 destination, vector, attr);
+	if (irq_remapping_enabled)
+		return setup_ioapic_remapped_entry(irq, entry, destination,
+						   vector, attr);
 
 	memset(entry, 0, sizeof(*entry));
 
@@ -1588,7 +1540,7 @@ static void __init setup_timer_IRQ0_pin(unsigned int ioapic_idx,
 {
 	struct IO_APIC_route_entry entry;
 
-	if (intr_remapping_enabled)
+	if (irq_remapping_enabled)
 		return;
 
 	memset(&entry, 0, sizeof(entry));
@@ -1674,7 +1626,7 @@ __apicdebuginit(void) print_IO_APIC(int ioapic_idx)
 
 	printk(KERN_DEBUG ".... IRQ redirection table:\n");
 
-	if (intr_remapping_enabled) {
+	if (irq_remapping_enabled) {
 		printk(KERN_DEBUG " NR Indx Fmt Mask Trig IRR"
 			" Pol Stat Indx2 Zero Vect:\n");
 	} else {
@@ -1683,7 +1635,7 @@ __apicdebuginit(void) print_IO_APIC(int ioapic_idx)
 	}
 
 	for (i = 0; i <= reg_01.bits.entries; i++) {
-		if (intr_remapping_enabled) {
+		if (irq_remapping_enabled) {
 			struct IO_APIC_route_entry entry;
 			struct IR_IO_APIC_route_entry *ir_entry;
 
@@ -2050,7 +2002,7 @@ void disable_IO_APIC(void)
 	 * IOAPIC RTE as well as interrupt-remapping table entry).
 	 * As this gets called during crash dump, keep this simple for now.
 	 */
-	if (ioapic_i8259.pin != -1 && !intr_remapping_enabled) {
+	if (ioapic_i8259.pin != -1 && !irq_remapping_enabled) {
 		struct IO_APIC_route_entry entry;
 
 		memset(&entry, 0, sizeof(entry));
@@ -2074,7 +2026,7 @@ void disable_IO_APIC(void)
 	 * Use virtual wire A mode when interrupt remapping is enabled.
 	 */
 	if (cpu_has_apic || apic_from_smp_config())
-		disconnect_bsp_APIC(!intr_remapping_enabled &&
+		disconnect_bsp_APIC(!irq_remapping_enabled &&
 				ioapic_i8259.pin != -1);
 }
 
@@ -2390,71 +2342,6 @@ ioapic_set_affinity(struct irq_data *data, const struct cpumask *mask,
 	return ret;
 }
 
-#ifdef CONFIG_IRQ_REMAP
-
-/*
- * Migrate the IO-APIC irq in the presence of intr-remapping.
- *
- * For both level and edge triggered, irq migration is a simple atomic
- * update(of vector and cpu destination) of IRTE and flush the hardware cache.
- *
- * For level triggered, we eliminate the io-apic RTE modification (with the
- * updated vector information), by using a virtual vector (io-apic pin number).
- * Real vector that is used for interrupting cpu will be coming from
- * the interrupt-remapping table entry.
- *
- * As the migration is a simple atomic update of IRTE, the same mechanism
- * is used to migrate MSI irq's in the presence of interrupt-remapping.
- */
-static int
-ir_ioapic_set_affinity(struct irq_data *data, const struct cpumask *mask,
-		       bool force)
-{
-	struct irq_cfg *cfg = data->chip_data;
-	unsigned int dest, irq = data->irq;
-	struct irte irte;
-
-	if (!cpumask_intersects(mask, cpu_online_mask))
-		return -EINVAL;
-
-	if (get_irte(irq, &irte))
-		return -EBUSY;
-
-	if (assign_irq_vector(irq, cfg, mask))
-		return -EBUSY;
-
-	dest = apic->cpu_mask_to_apicid_and(cfg->domain, mask);
-
-	irte.vector = cfg->vector;
-	irte.dest_id = IRTE_DEST(dest);
-
-	/*
-	 * Atomically updates the IRTE with the new destination, vector
-	 * and flushes the interrupt entry cache.
-	 */
-	modify_irte(irq, &irte);
-
-	/*
-	 * After this point, all the interrupts will start arriving
-	 * at the new destination. So, time to cleanup the previous
-	 * vector allocation.
-	 */
-	if (cfg->move_in_progress)
-		send_cleanup_vector(cfg);
-
-	cpumask_copy(data->affinity, mask);
-	return 0;
-}
-
-#else
-static inline int
-ir_ioapic_set_affinity(struct irq_data *data, const struct cpumask *mask,
-		       bool force)
-{
-	return 0;
-}
-#endif
-
 asmlinkage void smp_irq_move_cleanup_interrupt(void)
 {
 	unsigned vector, me;
@@ -2699,7 +2586,7 @@ static void irq_remap_modify_chip_defaults(struct irq_chip *chip)
 	chip->irq_eoi = ir_ack_apic_level;
 
 #ifdef CONFIG_SMP
-	chip->irq_set_affinity = ir_ioapic_set_affinity;
+	chip->irq_set_affinity = set_remapped_irq_affinity;
 #endif
 }
 #endif /* CONFIG_IRQ_REMAP */
@@ -2912,7 +2799,7 @@ static inline void __init check_timer(void)
 	 * 8259A.
 	 */
 	if (pin1 == -1) {
-		if (intr_remapping_enabled)
+		if (irq_remapping_enabled)
 			panic("BIOS bug: timer not connected to IO-APIC");
 		pin1 = pin2;
 		apic1 = apic2;
@@ -2945,7 +2832,7 @@ static inline void __init check_timer(void)
 				clear_IO_APIC_pin(0, pin1);
 			goto out;
 		}
-		if (intr_remapping_enabled)
+		if (irq_remapping_enabled)
 			panic("timer doesn't work through Interrupt-remapped IO-APIC");
 		local_irq_disable();
 		clear_IO_APIC_pin(apic1, pin1);
@@ -3169,7 +3056,7 @@ void destroy_irq(unsigned int irq)
 	irq_set_status_flags(irq, IRQ_NOREQUEST|IRQ_NOPROBE);
 
 	if (irq_remapped(cfg))
-		free_irte(irq);
+		free_remapped_irq(irq);
 	raw_spin_lock_irqsave(&vector_lock, flags);
 	__clear_irq_vector(irq, cfg);
 	raw_spin_unlock_irqrestore(&vector_lock, flags);
@@ -3198,54 +3085,34 @@ static int msi_compose_msg(struct pci_dev *pdev, unsigned int irq,
 	dest = apic->cpu_mask_to_apicid_and(cfg->domain, apic->target_cpus());
 
 	if (irq_remapped(cfg)) {
-		struct irte irte;
-		int ir_index;
-		u16 sub_handle;
-
-		ir_index = map_irq_to_irte_handle(irq, &sub_handle);
-		BUG_ON(ir_index == -1);
-
-		prepare_irte(&irte, cfg->vector, dest);
-
-		/* Set source-id of interrupt request */
-		if (pdev)
-			set_msi_sid(&irte, pdev);
-		else
-			set_hpet_sid(&irte, hpet_id);
-
-		modify_irte(irq, &irte);
+		compose_remapped_msi_msg(pdev, irq, dest, msg, hpet_id);
+		return err;
+	}
 
+	if (x2apic_enabled())
+		msg->address_hi = MSI_ADDR_BASE_HI |
+				  MSI_ADDR_EXT_DEST_ID(dest);
+	else
 		msg->address_hi = MSI_ADDR_BASE_HI;
-		msg->data = sub_handle;
-		msg->address_lo = MSI_ADDR_BASE_LO | MSI_ADDR_IR_EXT_INT |
-				  MSI_ADDR_IR_SHV |
-				  MSI_ADDR_IR_INDEX1(ir_index) |
-				  MSI_ADDR_IR_INDEX2(ir_index);
-	} else {
-		if (x2apic_enabled())
-			msg->address_hi = MSI_ADDR_BASE_HI |
-					  MSI_ADDR_EXT_DEST_ID(dest);
-		else
-			msg->address_hi = MSI_ADDR_BASE_HI;
 
-		msg->address_lo =
-			MSI_ADDR_BASE_LO |
-			((apic->irq_dest_mode == 0) ?
-				MSI_ADDR_DEST_MODE_PHYSICAL:
-				MSI_ADDR_DEST_MODE_LOGICAL) |
-			((apic->irq_delivery_mode != dest_LowestPrio) ?
-				MSI_ADDR_REDIRECTION_CPU:
-				MSI_ADDR_REDIRECTION_LOWPRI) |
-			MSI_ADDR_DEST_ID(dest);
+	msg->address_lo =
+		MSI_ADDR_BASE_LO |
+		((apic->irq_dest_mode == 0) ?
+			MSI_ADDR_DEST_MODE_PHYSICAL:
+			MSI_ADDR_DEST_MODE_LOGICAL) |
+		((apic->irq_delivery_mode != dest_LowestPrio) ?
+			MSI_ADDR_REDIRECTION_CPU:
+			MSI_ADDR_REDIRECTION_LOWPRI) |
+		MSI_ADDR_DEST_ID(dest);
+
+	msg->data =
+		MSI_DATA_TRIGGER_EDGE |
+		MSI_DATA_LEVEL_ASSERT |
+		((apic->irq_delivery_mode != dest_LowestPrio) ?
+			MSI_DATA_DELIVERY_FIXED:
+			MSI_DATA_DELIVERY_LOWPRI) |
+		MSI_DATA_VECTOR(cfg->vector);
 
-		msg->data =
-			MSI_DATA_TRIGGER_EDGE |
-			MSI_DATA_LEVEL_ASSERT |
-			((apic->irq_delivery_mode != dest_LowestPrio) ?
-				MSI_DATA_DELIVERY_FIXED:
-				MSI_DATA_DELIVERY_LOWPRI) |
-			MSI_DATA_VECTOR(cfg->vector);
-	}
 	return err;
 }
 
@@ -3288,33 +3155,6 @@ static struct irq_chip msi_chip = {
 	.irq_retrigger		= ioapic_retrigger_irq,
 };
 
-/*
- * Map the PCI dev to the corresponding remapping hardware unit
- * and allocate 'nvec' consecutive interrupt-remapping table entries
- * in it.
- */
-static int msi_alloc_irte(struct pci_dev *dev, int irq, int nvec)
-{
-	struct intel_iommu *iommu;
-	int index;
-
-	iommu = map_dev_to_ir(dev);
-	if (!iommu) {
-		printk(KERN_ERR
-		       "Unable to map PCI %s to iommu\n", pci_name(dev));
-		return -ENOENT;
-	}
-
-	index = alloc_irte(iommu, irq, nvec);
-	if (index < 0) {
-		printk(KERN_ERR
-		       "Unable to allocate %d IRTE for PCI %s\n", nvec,
-		       pci_name(dev));
-		return -ENOSPC;
-	}
-	return index;
-}
-
 static int setup_msi_irq(struct pci_dev *dev, struct msi_desc *msidesc, int irq)
 {
 	struct irq_chip *chip = &msi_chip;
@@ -3345,7 +3185,6 @@ int native_setup_msi_irqs(struct pci_dev *dev, int nvec, int type)
 	int node, ret, sub_handle, index = 0;
 	unsigned int irq, irq_want;
 	struct msi_desc *msidesc;
-	struct intel_iommu *iommu = NULL;
 
 	/* x86 doesn't support multiple MSI yet */
 	if (type == PCI_CAP_ID_MSI && nvec > 1)
@@ -3359,7 +3198,7 @@ int native_setup_msi_irqs(struct pci_dev *dev, int nvec, int type)
 		if (irq == 0)
 			return -1;
 		irq_want = irq + 1;
-		if (!intr_remapping_enabled)
+		if (!irq_remapping_enabled)
 			goto no_ir;
 
 		if (!sub_handle) {
@@ -3367,23 +3206,16 @@ int native_setup_msi_irqs(struct pci_dev *dev, int nvec, int type)
 			 * allocate the consecutive block of IRTE's
 			 * for 'nvec'
 			 */
-			index = msi_alloc_irte(dev, irq, nvec);
+			index = msi_alloc_remapped_irq(dev, irq, nvec);
 			if (index < 0) {
 				ret = index;
 				goto error;
 			}
 		} else {
-			iommu = map_dev_to_ir(dev);
-			if (!iommu) {
-				ret = -ENOENT;
+			ret = msi_setup_remapped_irq(dev, irq, index,
+						     sub_handle);
+			if (ret < 0)
 				goto error;
-			}
-			/*
-			 * setup the mapping between the irq and the IRTE
-			 * base index, the sub_handle pointing to the
-			 * appropriate interrupt remap table entry.
-			 */
-			set_irte_irq(irq, iommu, index, sub_handle);
 		}
 no_ir:
 		ret = setup_msi_irq(dev, msidesc, irq);
@@ -3501,15 +3333,8 @@ int arch_setup_hpet_msi(unsigned int irq, unsigned int id)
 	struct msi_msg msg;
 	int ret;
 
-	if (intr_remapping_enabled) {
-		struct intel_iommu *iommu = map_hpet_to_ir(id);
-		int index;
-
-		if (!iommu)
-			return -1;
-
-		index = alloc_irte(iommu, irq, 1);
-		if (index < 0)
+	if (irq_remapping_enabled) {
+		if (!setup_hpet_msi_remapped(irq, id))
 			return -1;
 	}
 
@@ -3888,8 +3713,8 @@ void __init setup_ioapic_dest(void)
 		else
 			mask = apic->target_cpus();
 
-		if (intr_remapping_enabled)
-			ir_ioapic_set_affinity(idata, mask, false);
+		if (irq_remapping_enabled)
+			set_remapped_irq_affinity(idata, mask, false);
 		else
 			ioapic_set_affinity(idata, mask, false);
 	}
diff --git a/drivers/iommu/Makefile b/drivers/iommu/Makefile
index 7ad7a3b..3e5e82a 100644
--- a/drivers/iommu/Makefile
+++ b/drivers/iommu/Makefile
@@ -4,7 +4,7 @@ obj-$(CONFIG_AMD_IOMMU) += amd_iommu.o amd_iommu_init.o
 obj-$(CONFIG_AMD_IOMMU_V2) += amd_iommu_v2.o
 obj-$(CONFIG_DMAR_TABLE) += dmar.o
 obj-$(CONFIG_INTEL_IOMMU) += iova.o intel-iommu.o
-obj-$(CONFIG_IRQ_REMAP) += intr_remapping.o
+obj-$(CONFIG_IRQ_REMAP) += intel_irq_remapping.o irq_remapping.o
 obj-$(CONFIG_OMAP_IOMMU) += omap-iommu.o
 obj-$(CONFIG_OMAP_IOVMM) += omap-iovmm.o
 obj-$(CONFIG_OMAP_IOMMU_DEBUG) += omap-iommu-debug.o
diff --git a/drivers/iommu/dmar.c b/drivers/iommu/dmar.c
index 35c1e17..3a74e44 100644
--- a/drivers/iommu/dmar.c
+++ b/drivers/iommu/dmar.c
@@ -36,6 +36,7 @@
 #include <linux/tboot.h>
 #include <linux/dmi.h>
 #include <linux/slab.h>
+#include <asm/irq_remapping.h>
 #include <asm/iommu_table.h>
 
 #define PREFIX "DMAR: "
@@ -555,7 +556,7 @@ int __init detect_intel_iommu(void)
 
 		dmar = (struct acpi_table_dmar *) dmar_tbl;
 
-		if (ret && intr_remapping_enabled && cpu_has_x2apic &&
+		if (ret && irq_remapping_enabled && cpu_has_x2apic &&
 		    dmar->flags & 0x1)
 			printk(KERN_INFO
 			       "Queued invalidation will be enabled to support x2apic and Intr-remapping.\n");
@@ -1041,7 +1042,7 @@ static const char *dma_remap_fault_reasons[] =
 	"non-zero reserved fields in PTE",
 };
 
-static const char *intr_remap_fault_reasons[] =
+static const char *irq_remap_fault_reasons[] =
 {
 	"Detected reserved fields in the decoded interrupt-remapped request",
 	"Interrupt index exceeded the interrupt-remapping table size",
@@ -1056,10 +1057,10 @@ static const char *intr_remap_fault_reasons[] =
 
 const char *dmar_get_fault_reason(u8 fault_reason, int *fault_type)
 {
-	if (fault_reason >= 0x20 && (fault_reason <= 0x20 +
-				     ARRAY_SIZE(intr_remap_fault_reasons))) {
+	if (fault_reason >= 0x20 && (fault_reason - 0x20 <
+					ARRAY_SIZE(irq_remap_fault_reasons))) {
 		*fault_type = INTR_REMAP;
-		return intr_remap_fault_reasons[fault_reason - 0x20];
+		return irq_remap_fault_reasons[fault_reason - 0x20];
 	} else if (fault_reason < ARRAY_SIZE(dma_remap_fault_reasons)) {
 		*fault_type = DMA_REMAP;
 		return dma_remap_fault_reasons[fault_reason];
diff --git a/drivers/iommu/intel-iommu.c b/drivers/iommu/intel-iommu.c
index f93d5ac..bf2fbaa 100644
--- a/drivers/iommu/intel-iommu.c
+++ b/drivers/iommu/intel-iommu.c
@@ -42,6 +42,7 @@
 #include <linux/dmi.h>
 #include <linux/pci-ats.h>
 #include <linux/memblock.h>
+#include <asm/irq_remapping.h>
 #include <asm/cacheflush.h>
 #include <asm/iommu.h>
 
@@ -4082,7 +4083,7 @@ static int intel_iommu_domain_has_cap(struct iommu_domain *domain,
 	if (cap == IOMMU_CAP_CACHE_COHERENCY)
 		return dmar_domain->iommu_snooping;
 	if (cap == IOMMU_CAP_INTR_REMAP)
-		return intr_remapping_enabled;
+		return irq_remapping_enabled;
 
 	return 0;
 }
diff --git a/drivers/iommu/intr_remapping.c b/drivers/iommu/intel_irq_remapping.c
similarity index 66%
rename from drivers/iommu/intr_remapping.c
rename to drivers/iommu/intel_irq_remapping.c
index 6777ca0..6d34706 100644
--- a/drivers/iommu/intr_remapping.c
+++ b/drivers/iommu/intel_irq_remapping.c
@@ -10,49 +10,33 @@
 #include <asm/smp.h>
 #include <asm/cpu.h>
 #include <linux/intel-iommu.h>
-#include "intr_remapping.h"
 #include <acpi/acpi.h>
+#include <asm/irq_remapping.h>
 #include <asm/pci-direct.h>
+#include <asm/msidef.h>
 
-static struct ioapic_scope ir_ioapic[MAX_IO_APICS];
-static struct hpet_scope ir_hpet[MAX_HPET_TBS];
-static int ir_ioapic_num, ir_hpet_num;
-int intr_remapping_enabled;
-
-static int disable_intremap;
-static int disable_sourceid_checking;
-static int no_x2apic_optout;
+#include "irq_remapping.h"
 
-static __init int setup_nointremap(char *str)
-{
-	disable_intremap = 1;
-	return 0;
-}
-early_param("nointremap", setup_nointremap);
+struct ioapic_scope {
+	struct intel_iommu *iommu;
+	unsigned int id;
+	unsigned int bus;	/* PCI bus number */
+	unsigned int devfn;	/* PCI devfn number */
+};
 
-static __init int setup_intremap(char *str)
-{
-	if (!str)
-		return -EINVAL;
+struct hpet_scope {
+	struct intel_iommu *iommu;
+	u8 id;
+	unsigned int bus;
+	unsigned int devfn;
+};
 
-	while (*str) {
-		if (!strncmp(str, "on", 2))
-			disable_intremap = 0;
-		else if (!strncmp(str, "off", 3))
-			disable_intremap = 1;
-		else if (!strncmp(str, "nosid", 5))
-			disable_sourceid_checking = 1;
-		else if (!strncmp(str, "no_x2apic_optout", 16))
-			no_x2apic_optout = 1;
-
-		str += strcspn(str, ",");
-		while (*str == ',')
-			str++;
-	}
+#define IR_X2APIC_MODE(mode) (mode ? (1 << 11) : 0)
+#define IRTE_DEST(dest) ((x2apic_mode) ? dest : dest << 8)
 
-	return 0;
-}
-early_param("intremap", setup_intremap);
+static struct ioapic_scope ir_ioapic[MAX_IO_APICS];
+static struct hpet_scope ir_hpet[MAX_HPET_TBS];
+static int ir_ioapic_num, ir_hpet_num;
 
 static DEFINE_RAW_SPINLOCK(irq_2_ir_lock);
 
@@ -80,7 +64,7 @@ int get_irte(int irq, struct irte *entry)
 	return 0;
 }
 
-int alloc_irte(struct intel_iommu *iommu, int irq, u16 count)
+static int alloc_irte(struct intel_iommu *iommu, int irq, u16 count)
 {
 	struct ir_table *table = iommu->ir_table;
 	struct irq_2_iommu *irq_iommu = irq_2_iommu(irq);
@@ -152,7 +136,7 @@ static int qi_flush_iec(struct intel_iommu *iommu, int index, int mask)
 	return qi_submit_sync(&desc, iommu);
 }
 
-int map_irq_to_irte_handle(int irq, u16 *sub_handle)
+static int map_irq_to_irte_handle(int irq, u16 *sub_handle)
 {
 	struct irq_2_iommu *irq_iommu = irq_2_iommu(irq);
 	unsigned long flags;
@@ -168,7 +152,7 @@ int map_irq_to_irte_handle(int irq, u16 *sub_handle)
 	return index;
 }
 
-int set_irte_irq(int irq, struct intel_iommu *iommu, u16 index, u16 subhandle)
+static int set_irte_irq(int irq, struct intel_iommu *iommu, u16 index, u16 subhandle)
 {
 	struct irq_2_iommu *irq_iommu = irq_2_iommu(irq);
 	unsigned long flags;
@@ -188,7 +172,7 @@ int set_irte_irq(int irq, struct intel_iommu *iommu, u16 index, u16 subhandle)
 	return 0;
 }
 
-int modify_irte(int irq, struct irte *irte_modified)
+static int modify_irte(int irq, struct irte *irte_modified)
 {
 	struct irq_2_iommu *irq_iommu = irq_2_iommu(irq);
 	struct intel_iommu *iommu;
@@ -216,7 +200,7 @@ int modify_irte(int irq, struct irte *irte_modified)
 	return rc;
 }
 
-struct intel_iommu *map_hpet_to_ir(u8 hpet_id)
+static struct intel_iommu *map_hpet_to_ir(u8 hpet_id)
 {
 	int i;
 
@@ -226,7 +210,7 @@ struct intel_iommu *map_hpet_to_ir(u8 hpet_id)
 	return NULL;
 }
 
-struct intel_iommu *map_ioapic_to_ir(int apic)
+static struct intel_iommu *map_ioapic_to_ir(int apic)
 {
 	int i;
 
@@ -236,7 +220,7 @@ struct intel_iommu *map_ioapic_to_ir(int apic)
 	return NULL;
 }
 
-struct intel_iommu *map_dev_to_ir(struct pci_dev *dev)
+static struct intel_iommu *map_dev_to_ir(struct pci_dev *dev)
 {
 	struct dmar_drhd_unit *drhd;
 
@@ -270,7 +254,7 @@ static int clear_entries(struct irq_2_iommu *irq_iommu)
 	return qi_flush_iec(iommu, index, irq_iommu->irte_mask);
 }
 
-int free_irte(int irq)
+static int free_irte(int irq)
 {
 	struct irq_2_iommu *irq_iommu = irq_2_iommu(irq);
 	unsigned long flags;
@@ -328,7 +312,7 @@ static void set_irte_sid(struct irte *irte, unsigned int svt,
 	irte->sid = sid;
 }
 
-int set_ioapic_sid(struct irte *irte, int apic)
+static int set_ioapic_sid(struct irte *irte, int apic)
 {
 	int i;
 	u16 sid = 0;
@@ -353,7 +337,7 @@ int set_ioapic_sid(struct irte *irte, int apic)
 	return 0;
 }
 
-int set_hpet_sid(struct irte *irte, u8 id)
+static int set_hpet_sid(struct irte *irte, u8 id)
 {
 	int i;
 	u16 sid = 0;
@@ -383,7 +367,7 @@ int set_hpet_sid(struct irte *irte, u8 id)
 	return 0;
 }
 
-int set_msi_sid(struct irte *irte, struct pci_dev *dev)
+static int set_msi_sid(struct irte *irte, struct pci_dev *dev)
 {
 	struct pci_dev *bridge;
 
@@ -410,7 +394,7 @@ int set_msi_sid(struct irte *irte, struct pci_dev *dev)
 	return 0;
 }
 
-static void iommu_set_intr_remapping(struct intel_iommu *iommu, int mode)
+static void iommu_set_irq_remapping(struct intel_iommu *iommu, int mode)
 {
 	u64 addr;
 	u32 sts;
@@ -450,7 +434,7 @@ static void iommu_set_intr_remapping(struct intel_iommu *iommu, int mode)
 }
 
 
-static int setup_intr_remapping(struct intel_iommu *iommu, int mode)
+static int intel_setup_irq_remapping(struct intel_iommu *iommu, int mode)
 {
 	struct ir_table *ir_table;
 	struct page *pages;
@@ -473,14 +457,14 @@ static int setup_intr_remapping(struct intel_iommu *iommu, int mode)
 
 	ir_table->base = page_address(pages);
 
-	iommu_set_intr_remapping(iommu, mode);
+	iommu_set_irq_remapping(iommu, mode);
 	return 0;
 }
 
 /*
  * Disable Interrupt Remapping.
  */
-static void iommu_disable_intr_remapping(struct intel_iommu *iommu)
+static void iommu_disable_irq_remapping(struct intel_iommu *iommu)
 {
 	unsigned long flags;
 	u32 sts;
@@ -519,11 +503,11 @@ static int __init dmar_x2apic_optout(void)
 	return dmar->flags & DMAR_X2APIC_OPT_OUT;
 }
 
-int __init intr_remapping_supported(void)
+static int __init intel_irq_remapping_supported(void)
 {
 	struct dmar_drhd_unit *drhd;
 
-	if (disable_intremap)
+	if (disable_irq_remap)
 		return 0;
 
 	if (!dmar_ir_support())
@@ -539,7 +523,7 @@ int __init intr_remapping_supported(void)
 	return 1;
 }
 
-int __init enable_intr_remapping(void)
+static int __init intel_enable_irq_remapping(void)
 {
 	struct dmar_drhd_unit *drhd;
 	int setup = 0;
@@ -577,7 +561,7 @@ int __init enable_intr_remapping(void)
 		 * Disable intr remapping and queued invalidation, if already
 		 * enabled prior to OS handover.
 		 */
-		iommu_disable_intr_remapping(iommu);
+		iommu_disable_irq_remapping(iommu);
 
 		dmar_disable_qi(iommu);
 	}
@@ -623,7 +607,7 @@ int __init enable_intr_remapping(void)
 		if (!ecap_ir_support(iommu->ecap))
 			continue;
 
-		if (setup_intr_remapping(iommu, eim))
+		if (intel_setup_irq_remapping(iommu, eim))
 			goto error;
 
 		setup = 1;
@@ -632,7 +616,7 @@ int __init enable_intr_remapping(void)
 	if (!setup)
 		goto error;
 
-	intr_remapping_enabled = 1;
+	irq_remapping_enabled = 1;
 	pr_info("Enabled IRQ remapping in %s mode\n", eim ? "x2apic" : "xapic");
 
 	return eim ? IRQ_REMAP_X2APIC_MODE : IRQ_REMAP_XAPIC_MODE;
@@ -775,14 +759,14 @@ int __init parse_ioapics_under_ir(void)
 
 int __init ir_dev_scope_init(void)
 {
-	if (!intr_remapping_enabled)
+	if (!irq_remapping_enabled)
 		return 0;
 
 	return dmar_dev_scope_init();
 }
 rootfs_initcall(ir_dev_scope_init);
 
-void disable_intr_remapping(void)
+static void disable_irq_remapping(void)
 {
 	struct dmar_drhd_unit *drhd;
 	struct intel_iommu *iommu = NULL;
@@ -794,11 +778,11 @@ void disable_intr_remapping(void)
 		if (!ecap_ir_support(iommu->ecap))
 			continue;
 
-		iommu_disable_intr_remapping(iommu);
+		iommu_disable_irq_remapping(iommu);
 	}
 }
 
-int reenable_intr_remapping(int eim)
+static int reenable_irq_remapping(int eim)
 {
 	struct dmar_drhd_unit *drhd;
 	int setup = 0;
@@ -816,7 +800,7 @@ int reenable_intr_remapping(int eim)
 			continue;
 
 		/* Set up interrupt remapping for iommu.*/
-		iommu_set_intr_remapping(iommu, eim);
+		iommu_set_irq_remapping(iommu, eim);
 		setup = 1;
 	}
 
@@ -832,3 +816,254 @@ error:
 	return -1;
 }
 
+static void prepare_irte(struct irte *irte, int vector,
+			 unsigned int dest)
+{
+	memset(irte, 0, sizeof(*irte));
+
+	irte->present = 1;
+	irte->dst_mode = apic->irq_dest_mode;
+	/*
+	 * Trigger mode in the IRTE will always be edge, and for IO-APIC, the
+	 * actual level or edge trigger will be setup in the IO-APIC
+	 * RTE. This will help simplify level triggered irq migration.
+	 * For more details, see the comments (in io_apic.c) explainig IO-APIC
+	 * irq migration in the presence of interrupt-remapping.
+	*/
+	irte->trigger_mode = 0;
+	irte->dlvry_mode = apic->irq_delivery_mode;
+	irte->vector = vector;
+	irte->dest_id = IRTE_DEST(dest);
+	irte->redir_hint = 1;
+}
+
+static int intel_setup_ioapic_entry(int irq,
+				    struct IO_APIC_route_entry *route_entry,
+				    unsigned int destination, int vector,
+				    struct io_apic_irq_attr *attr)
+{
+	int ioapic_id = mpc_ioapic_id(attr->ioapic);
+	struct intel_iommu *iommu = map_ioapic_to_ir(ioapic_id);
+	struct IR_IO_APIC_route_entry *entry;
+	struct irte irte;
+	int index;
+
+	if (!iommu) {
+		pr_warn("No mapping iommu for ioapic %d\n", ioapic_id);
+		return -ENODEV;
+	}
+
+	entry = (struct IR_IO_APIC_route_entry *)route_entry;
+
+	index = alloc_irte(iommu, irq, 1);
+	if (index < 0) {
+		pr_warn("Failed to allocate IRTE for ioapic %d\n", ioapic_id);
+		return -ENOMEM;
+	}
+
+	prepare_irte(&irte, vector, destination);
+
+	/* Set source-id of interrupt request */
+	set_ioapic_sid(&irte, ioapic_id);
+
+	modify_irte(irq, &irte);
+
+	apic_printk(APIC_VERBOSE, KERN_DEBUG "IOAPIC[%d]: "
+		"Set IRTE entry (P:%d FPD:%d Dst_Mode:%d "
+		"Redir_hint:%d Trig_Mode:%d Dlvry_Mode:%X "
+		"Avail:%X Vector:%02X Dest:%08X "
+		"SID:%04X SQ:%X SVT:%X)\n",
+		attr->ioapic, irte.present, irte.fpd, irte.dst_mode,
+		irte.redir_hint, irte.trigger_mode, irte.dlvry_mode,
+		irte.avail, irte.vector, irte.dest_id,
+		irte.sid, irte.sq, irte.svt);
+
+	memset(entry, 0, sizeof(*entry));
+
+	entry->index2	= (index >> 15) & 0x1;
+	entry->zero	= 0;
+	entry->format	= 1;
+	entry->index	= (index & 0x7fff);
+	/*
+	 * IO-APIC RTE will be configured with virtual vector.
+	 * irq handler will do the explicit EOI to the io-apic.
+	 */
+	entry->vector	= attr->ioapic_pin;
+	entry->mask	= 0;			/* enable IRQ */
+	entry->trigger	= attr->trigger;
+	entry->polarity	= attr->polarity;
+
+	/* Mask level triggered irqs.
+	 * Use IRQ_DELAYED_DISABLE for edge triggered irqs.
+	 */
+	if (attr->trigger)
+		entry->mask = 1;
+
+	return 0;
+}
+
+#ifdef CONFIG_SMP
+/*
+ * Migrate the IO-APIC irq in the presence of intr-remapping.
+ *
+ * For both level and edge triggered, irq migration is a simple atomic
+ * update(of vector and cpu destination) of IRTE and flush the hardware cache.
+ *
+ * For level triggered, we eliminate the io-apic RTE modification (with the
+ * updated vector information), by using a virtual vector (io-apic pin number).
+ * Real vector that is used for interrupting cpu will be coming from
+ * the interrupt-remapping table entry.
+ *
+ * As the migration is a simple atomic update of IRTE, the same mechanism
+ * is used to migrate MSI irq's in the presence of interrupt-remapping.
+ */
+static int
+intel_ioapic_set_affinity(struct irq_data *data, const struct cpumask *mask,
+			  bool force)
+{
+	struct irq_cfg *cfg = data->chip_data;
+	unsigned int dest, irq = data->irq;
+	struct irte irte;
+
+	if (!cpumask_intersects(mask, cpu_online_mask))
+		return -EINVAL;
+
+	if (get_irte(irq, &irte))
+		return -EBUSY;
+
+	if (assign_irq_vector(irq, cfg, mask))
+		return -EBUSY;
+
+	dest = apic->cpu_mask_to_apicid_and(cfg->domain, mask);
+
+	irte.vector = cfg->vector;
+	irte.dest_id = IRTE_DEST(dest);
+
+	/*
+	 * Atomically updates the IRTE with the new destination, vector
+	 * and flushes the interrupt entry cache.
+	 */
+	modify_irte(irq, &irte);
+
+	/*
+	 * After this point, all the interrupts will start arriving
+	 * at the new destination. So, time to cleanup the previous
+	 * vector allocation.
+	 */
+	if (cfg->move_in_progress)
+		send_cleanup_vector(cfg);
+
+	cpumask_copy(data->affinity, mask);
+	return 0;
+}
+#endif
+
+static void intel_compose_msi_msg(struct pci_dev *pdev,
+				  unsigned int irq, unsigned int dest,
+				  struct msi_msg *msg, u8 hpet_id)
+{
+	struct irq_cfg *cfg;
+	struct irte irte;
+	u16 sub_handle = 0;
+	int ir_index;
+
+	cfg = irq_get_chip_data(irq);
+
+	ir_index = map_irq_to_irte_handle(irq, &sub_handle);
+	BUG_ON(ir_index == -1);
+
+	prepare_irte(&irte, cfg->vector, dest);
+
+	/* Set source-id of interrupt request */
+	if (pdev)
+		set_msi_sid(&irte, pdev);
+	else
+		set_hpet_sid(&irte, hpet_id);
+
+	modify_irte(irq, &irte);
+
+	msg->address_hi = MSI_ADDR_BASE_HI;
+	msg->data = sub_handle;
+	msg->address_lo = MSI_ADDR_BASE_LO | MSI_ADDR_IR_EXT_INT |
+			  MSI_ADDR_IR_SHV |
+			  MSI_ADDR_IR_INDEX1(ir_index) |
+			  MSI_ADDR_IR_INDEX2(ir_index);
+}
+
+/*
+ * Map the PCI dev to the corresponding remapping hardware unit
+ * and allocate 'nvec' consecutive interrupt-remapping table entries
+ * in it.
+ */
+static int intel_msi_alloc_irq(struct pci_dev *dev, int irq, int nvec)
+{
+	struct intel_iommu *iommu;
+	int index;
+
+	iommu = map_dev_to_ir(dev);
+	if (!iommu) {
+		printk(KERN_ERR
+		       "Unable to map PCI %s to iommu\n", pci_name(dev));
+		return -ENOENT;
+	}
+
+	index = alloc_irte(iommu, irq, nvec);
+	if (index < 0) {
+		printk(KERN_ERR
+		       "Unable to allocate %d IRTE for PCI %s\n", nvec,
+		       pci_name(dev));
+		return -ENOSPC;
+	}
+	return index;
+}
+
+static int intel_msi_setup_irq(struct pci_dev *pdev, unsigned int irq,
+			       int index, int sub_handle)
+{
+	struct intel_iommu *iommu;
+
+	iommu = map_dev_to_ir(pdev);
+	if (!iommu)
+		return -ENOENT;
+	/*
+	 * setup the mapping between the irq and the IRTE
+	 * base index, the sub_handle pointing to the
+	 * appropriate interrupt remap table entry.
+	 */
+	set_irte_irq(irq, iommu, index, sub_handle);
+
+	return 0;
+}
+
+static int intel_setup_hpet_msi(unsigned int irq, unsigned int id)
+{
+	struct intel_iommu *iommu = map_hpet_to_ir(id);
+	int index;
+
+	if (!iommu)
+		return -1;
+
+	index = alloc_irte(iommu, irq, 1);
+	if (index < 0)
+		return -1;
+
+	return 0;
+}
+
+struct irq_remap_ops intel_irq_remap_ops = {
+	.supported		= intel_irq_remapping_supported,
+	.prepare		= dmar_table_init,
+	.enable			= intel_enable_irq_remapping,
+	.disable		= disable_irq_remapping,
+	.reenable		= reenable_irq_remapping,
+	.enable_faulting	= enable_drhd_fault_handling,
+	.setup_ioapic_entry	= intel_setup_ioapic_entry,
+#ifdef CONFIG_SMP
+	.set_affinity		= intel_ioapic_set_affinity,
+#endif
+	.free_irq		= free_irte,
+	.compose_msi_msg	= intel_compose_msi_msg,
+	.msi_alloc_irq		= intel_msi_alloc_irq,
+	.msi_setup_irq		= intel_msi_setup_irq,
+	.setup_hpet_msi		= intel_setup_hpet_msi,
+};
diff --git a/drivers/iommu/intr_remapping.h b/drivers/iommu/intr_remapping.h
deleted file mode 100644
index 5662fec..0000000
--- a/drivers/iommu/intr_remapping.h
+++ /dev/null
@@ -1,17 +0,0 @@
-#include <linux/intel-iommu.h>
-
-struct ioapic_scope {
-	struct intel_iommu *iommu;
-	unsigned int id;
-	unsigned int bus;	/* PCI bus number */
-	unsigned int devfn;	/* PCI devfn number */
-};
-
-struct hpet_scope {
-	struct intel_iommu *iommu;
-	u8 id;
-	unsigned int bus;
-	unsigned int devfn;
-};
-
-#define IR_X2APIC_MODE(mode) (mode ? (1 << 11) : 0)
diff --git a/drivers/iommu/irq_remapping.c b/drivers/iommu/irq_remapping.c
new file mode 100644
index 0000000..40cda8e
--- /dev/null
+++ b/drivers/iommu/irq_remapping.c
@@ -0,0 +1,166 @@
+#include <linux/kernel.h>
+#include <linux/string.h>
+#include <linux/errno.h>
+
+#include "irq_remapping.h"
+
+int irq_remapping_enabled;
+
+int disable_irq_remap;
+int disable_sourceid_checking;
+int no_x2apic_optout;
+
+static struct irq_remap_ops *remap_ops;
+
+static __init int setup_nointremap(char *str)
+{
+	disable_irq_remap = 1;
+	return 0;
+}
+early_param("nointremap", setup_nointremap);
+
+static __init int setup_irqremap(char *str)
+{
+	if (!str)
+		return -EINVAL;
+
+	while (*str) {
+		if (!strncmp(str, "on", 2))
+			disable_irq_remap = 0;
+		else if (!strncmp(str, "off", 3))
+			disable_irq_remap = 1;
+		else if (!strncmp(str, "nosid", 5))
+			disable_sourceid_checking = 1;
+		else if (!strncmp(str, "no_x2apic_optout", 16))
+			no_x2apic_optout = 1;
+
+		str += strcspn(str, ",");
+		while (*str == ',')
+			str++;
+	}
+
+	return 0;
+}
+early_param("intremap", setup_irqremap);
+
+void __init setup_irq_remapping_ops(void)
+{
+	remap_ops = &intel_irq_remap_ops;
+}
+
+int irq_remapping_supported(void)
+{
+	if (disable_irq_remap)
+		return 0;
+
+	if (!remap_ops || !remap_ops->supported)
+		return 0;
+
+	return remap_ops->supported();
+}
+
+int __init irq_remapping_prepare(void)
+{
+	if (!remap_ops || !remap_ops->prepare)
+		return -ENODEV;
+
+	return remap_ops->prepare();
+}
+
+int __init irq_remapping_enable(void)
+{
+	if (!remap_ops || !remap_ops->enable)
+		return -ENODEV;
+
+	return remap_ops->enable();
+}
+
+void irq_remapping_disable(void)
+{
+	if (!remap_ops || !remap_ops->disable)
+		return;
+
+	remap_ops->disable();
+}
+
+int irq_remapping_reenable(int mode)
+{
+	if (!remap_ops || !remap_ops->reenable)
+		return 0;
+
+	return remap_ops->reenable(mode);
+}
+
+int __init irq_remap_enable_fault_handling(void)
+{
+	if (!remap_ops || !remap_ops->enable_faulting)
+		return -ENODEV;
+
+	return remap_ops->enable_faulting();
+}
+
+int setup_ioapic_remapped_entry(int irq,
+				struct IO_APIC_route_entry *entry,
+				unsigned int destination, int vector,
+				struct io_apic_irq_attr *attr)
+{
+	if (!remap_ops || !remap_ops->setup_ioapic_entry)
+		return -ENODEV;
+
+	return remap_ops->setup_ioapic_entry(irq, entry, destination,
+					     vector, attr);
+}
+
+#ifdef CONFIG_SMP
+int set_remapped_irq_affinity(struct irq_data *data, const struct cpumask *mask,
+			      bool force)
+{
+	if (!remap_ops || !remap_ops->set_affinity)
+		return 0;
+
+	return remap_ops->set_affinity(data, mask, force);
+}
+#endif
+
+void free_remapped_irq(int irq)
+{
+	if (!remap_ops || !remap_ops->free_irq)
+		return;
+
+	remap_ops->free_irq(irq);
+}
+
+void compose_remapped_msi_msg(struct pci_dev *pdev,
+			      unsigned int irq, unsigned int dest,
+			      struct msi_msg *msg, u8 hpet_id)
+{
+	if (!remap_ops || !remap_ops->compose_msi_msg)
+		return;
+
+	remap_ops->compose_msi_msg(pdev, irq, dest, msg, hpet_id);
+}
+
+int msi_alloc_remapped_irq(struct pci_dev *pdev, int irq, int nvec)
+{
+	if (!remap_ops || !remap_ops->msi_alloc_irq)
+		return -ENODEV;
+
+	return remap_ops->msi_alloc_irq(pdev, irq, nvec);
+}
+
+int msi_setup_remapped_irq(struct pci_dev *pdev, unsigned int irq,
+			   int index, int sub_handle)
+{
+	if (!remap_ops || !remap_ops->msi_setup_irq)
+		return -ENODEV;
+
+	return remap_ops->msi_setup_irq(pdev, irq, index, sub_handle);
+}
+
+int setup_hpet_msi_remapped(unsigned int irq, unsigned int id)
+{
+	if (!remap_ops || !remap_ops->setup_hpet_msi)
+		return -ENODEV;
+
+	return remap_ops->setup_hpet_msi(irq, id);
+}
diff --git a/drivers/iommu/irq_remapping.h b/drivers/iommu/irq_remapping.h
new file mode 100644
index 0000000..be9d729
--- /dev/null
+++ b/drivers/iommu/irq_remapping.h
@@ -0,0 +1,90 @@
+/*
+ * Copyright (C) 2012 Advanced Micro Devices, Inc.
+ * Author: Joerg Roedel <joerg.roedel@amd.com>
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License version 2 as published
+ * by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307 USA
+ *
+ * This header file contains stuff that is shared between different interrupt
+ * remapping drivers but with no need to be visible outside of the IOMMU layer.
+ */
+
+#ifndef __IRQ_REMAPPING_H
+#define __IRQ_REMAPPING_H
+
+#ifdef CONFIG_IRQ_REMAP
+
+struct IO_APIC_route_entry;
+struct io_apic_irq_attr;
+struct irq_data;
+struct cpumask;
+struct pci_dev;
+struct msi_msg;
+
+extern int disable_irq_remap;
+extern int disable_sourceid_checking;
+extern int no_x2apic_optout;
+
+struct irq_remap_ops {
+	/* Check whether Interrupt Remapping is supported */
+	int (*supported)(void);
+
+	/* Initializes hardware and makes it ready for remapping interrupts */
+	int  (*prepare)(void);
+
+	/* Enables the remapping hardware */
+	int  (*enable)(void);
+
+	/* Disables the remapping hardware */
+	void (*disable)(void);
+
+	/* Reenables the remapping hardware */
+	int  (*reenable)(int);
+
+	/* Enable fault handling */
+	int  (*enable_faulting)(void);
+
+	/* IO-APIC setup routine */
+	int (*setup_ioapic_entry)(int irq, struct IO_APIC_route_entry *,
+				  unsigned int, int,
+				  struct io_apic_irq_attr *);
+
+#ifdef CONFIG_SMP
+	/* Set the CPU affinity of a remapped interrupt */
+	int (*set_affinity)(struct irq_data *data, const struct cpumask *mask,
+			    bool force);
+#endif
+
+	/* Free an IRQ */
+	int (*free_irq)(int);
+
+	/* Create MSI msg to use for interrupt remapping */
+	void (*compose_msi_msg)(struct pci_dev *,
+				unsigned int, unsigned int,
+				struct msi_msg *, u8);
+
+	/* Allocate remapping resources for MSI */
+	int (*msi_alloc_irq)(struct pci_dev *, int, int);
+
+	/* Setup the remapped MSI irq */
+	int (*msi_setup_irq)(struct pci_dev *, unsigned int, int, int);
+
+	/* Setup interrupt remapping for an HPET MSI */
+	int (*setup_hpet_msi)(unsigned int, unsigned int);
+};
+
+extern struct irq_remap_ops intel_irq_remap_ops;
+
+#endif /* CONFIG_IRQ_REMAP */
+
+#endif /* __IRQ_REMAPPING_H */
diff --git a/include/linux/dmar.h b/include/linux/dmar.h
index 731a609..b029d1a 100644
--- a/include/linux/dmar.h
+++ b/include/linux/dmar.h
@@ -114,91 +114,6 @@ struct irte {
 	};
 };
 
-#ifdef CONFIG_IRQ_REMAP
-extern int intr_remapping_enabled;
-extern int intr_remapping_supported(void);
-extern int enable_intr_remapping(void);
-extern void disable_intr_remapping(void);
-extern int reenable_intr_remapping(int);
-
-extern int get_irte(int irq, struct irte *entry);
-extern int modify_irte(int irq, struct irte *irte_modified);
-extern int alloc_irte(struct intel_iommu *iommu, int irq, u16 count);
-extern int set_irte_irq(int irq, struct intel_iommu *iommu, u16 index,
-   			u16 sub_handle);
-extern int map_irq_to_irte_handle(int irq, u16 *sub_handle);
-extern int free_irte(int irq);
-
-extern struct intel_iommu *map_dev_to_ir(struct pci_dev *dev);
-extern struct intel_iommu *map_ioapic_to_ir(int apic);
-extern struct intel_iommu *map_hpet_to_ir(u8 id);
-extern int set_ioapic_sid(struct irte *irte, int apic);
-extern int set_hpet_sid(struct irte *irte, u8 id);
-extern int set_msi_sid(struct irte *irte, struct pci_dev *dev);
-#else
-static inline int alloc_irte(struct intel_iommu *iommu, int irq, u16 count)
-{
-	return -1;
-}
-static inline int modify_irte(int irq, struct irte *irte_modified)
-{
-	return -1;
-}
-static inline int free_irte(int irq)
-{
-	return -1;
-}
-static inline int map_irq_to_irte_handle(int irq, u16 *sub_handle)
-{
-	return -1;
-}
-static inline int set_irte_irq(int irq, struct intel_iommu *iommu, u16 index,
-			       u16 sub_handle)
-{
-	return -1;
-}
-static inline struct intel_iommu *map_dev_to_ir(struct pci_dev *dev)
-{
-	return NULL;
-}
-static inline struct intel_iommu *map_ioapic_to_ir(int apic)
-{
-	return NULL;
-}
-static inline struct intel_iommu *map_hpet_to_ir(unsigned int hpet_id)
-{
-	return NULL;
-}
-static inline int set_ioapic_sid(struct irte *irte, int apic)
-{
-	return 0;
-}
-static inline int set_hpet_sid(struct irte *irte, u8 id)
-{
-	return -1;
-}
-static inline int set_msi_sid(struct irte *irte, struct pci_dev *dev)
-{
-	return 0;
-}
-
-#define intr_remapping_enabled		(0)
-
-static inline int enable_intr_remapping(void)
-{
-	return -1;
-}
-
-static inline void disable_intr_remapping(void)
-{
-}
-
-static inline int reenable_intr_remapping(int eim)
-{
-	return 0;
-}
-#endif
-
 enum {
 	IRQ_REMAP_XAPIC_MODE,
 	IRQ_REMAP_X2APIC_MODE,
