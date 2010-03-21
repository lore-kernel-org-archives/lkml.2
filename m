Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753353Ab0CUHT4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Mar 2010 03:19:56 -0400
Received: from rcsinet12.oracle.com ([148.87.113.124]:56642 "EHLO
	rcsinet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752733Ab0CUHSK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Mar 2010 03:18:10 -0400
From: Yinghai Lu <yinghai@kernel.org>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Miller <davem@davemloft.net>,
       Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>, linux-kernel@vger.kernel.org,
       linux-arch@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH 15/20] x86/iommu/dmar: update iommu/inter_remapping to use desc
Date: Sun, 21 Mar 2010 00:13:16 -0700
Message-Id: <1269155601-18247-16-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.6.4.2
In-Reply-To: <1269155601-18247-1-git-send-email-yinghai@kernel.org>
References: <1269155601-18247-1-git-send-email-yinghai@kernel.org>
X-Source-IP: acsmt355.oracle.com [141.146.40.155]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090208.4BA5C78C.00DB,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

to make irq_remapped() not going to call irq_to_desc() ....

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
---
 arch/x86/include/asm/io_apic.h |    4 --
 arch/x86/kernel/apic/io_apic.c |   80 +++++++++++++++++++---------------------
 drivers/pci/intr_remapping.c   |   69 ++++++++++++++--------------------
 include/linux/dmar.h           |   36 +++++++++--------
 4 files changed, 86 insertions(+), 103 deletions(-)

diff --git a/arch/x86/include/asm/io_apic.h b/arch/x86/include/asm/io_apic.h
index c4683b9..d249186 100644
--- a/arch/x86/include/asm/io_apic.h
+++ b/arch/x86/include/asm/io_apic.h
@@ -171,10 +171,6 @@ extern int restore_IO_APIC_setup(struct IO_APIC_route_entry **ioapic_entries);
 
 extern void probe_nr_irqs_gsi(void);
 
-extern int setup_ioapic_entry(int apic, int irq,
-			      struct IO_APIC_route_entry *entry,
-			      unsigned int destination, int trigger,
-			      int polarity, int vector, int pin);
 extern void ioapic_write_entry(int apic, int pin,
 			       struct IO_APIC_route_entry e);
 extern void setup_ioapic_ids_from_mpc(void);
diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
index 5f061b7..c03bcd4 100644
--- a/arch/x86/kernel/apic/io_apic.c
+++ b/arch/x86/kernel/apic/io_apic.c
@@ -1340,7 +1340,7 @@ static void ioapic_register_intr(int irq, struct irq_desc *desc, unsigned long t
 	else
 		desc->status &= ~IRQ_LEVEL;
 
-	if (irq_remapped(irq)) {
+	if (irq_remapped(desc)) {
 		desc->status |= IRQ_MOVE_PCNTXT;
 		if (trigger)
 			set_irq_chip_and_handler_name(irq, &ir_ioapic_chip,
@@ -1362,7 +1362,7 @@ static void ioapic_register_intr(int irq, struct irq_desc *desc, unsigned long t
 					      handle_edge_irq, "edge");
 }
 
-int setup_ioapic_entry(int apic_id, int irq,
+static int setup_ioapic_entry(int apic_id, struct irq_desc *desc,
 		       struct IO_APIC_route_entry *entry,
 		       unsigned int destination, int trigger,
 		       int polarity, int vector, int pin)
@@ -1382,7 +1382,7 @@ int setup_ioapic_entry(int apic_id, int irq,
 		if (!iommu)
 			panic("No mapping iommu for ioapic %d\n", apic_id);
 
-		index = alloc_irte(iommu, irq, 1);
+		index = alloc_irte(iommu, desc, 1);
 		if (index < 0)
 			panic("Failed to allocate IRTE for ioapic %d\n", apic_id);
 
@@ -1405,7 +1405,7 @@ int setup_ioapic_entry(int apic_id, int irq,
 		/* Set source-id of interrupt request */
 		set_ioapic_sid(&irte, apic_id);
 
-		modify_irte(irq, &irte);
+		modify_irte(desc, &irte);
 
 		ir_entry->index2 = (index >> 15) & 0x1;
 		ir_entry->zero = 0;
@@ -1467,7 +1467,7 @@ static void setup_IO_APIC_irq(int apic_id, int pin, unsigned int irq, struct irq
 		    irq, trigger, polarity);
 
 
-	if (setup_ioapic_entry(mp_ioapics[apic_id].apicid, irq, &entry,
+	if (setup_ioapic_entry(mp_ioapics[apic_id].apicid, desc, &entry,
 			       dest, trigger, polarity, cfg->vector, pin)) {
 		printk("Failed to setup ioapic entry for ioapic  %d, pin %d\n",
 		       mp_ioapics[apic_id].apicid, pin);
@@ -2334,7 +2334,7 @@ void send_cleanup_vector(struct irq_cfg *cfg)
 	cfg->move_in_progress = 0;
 }
 
-static void __target_IO_APIC_irq(unsigned int irq, unsigned int dest, struct irq_cfg *cfg)
+static void __target_IO_APIC_irq(struct irq_desc *desc, unsigned int dest, struct irq_cfg *cfg)
 {
 	int apic, pin;
 	struct irq_pin_list *entry;
@@ -2349,7 +2349,7 @@ static void __target_IO_APIC_irq(unsigned int irq, unsigned int dest, struct irq
 		 * With interrupt-remapping, destination information comes
 		 * from interrupt-remapping table entry.
 		 */
-		if (!irq_remapped(irq))
+		if (!irq_remapped(desc))
 			io_apic_write(apic, 0x11 + pin*2, dest);
 		reg = io_apic_read(apic, 0x10 + pin*2);
 		reg &= ~IO_APIC_REDIR_VECTOR_MASK;
@@ -2388,10 +2388,8 @@ set_ioapic_affinity_irq_desc(struct irq_desc *desc, const struct cpumask *mask)
 	struct irq_cfg *cfg;
 	unsigned long flags;
 	unsigned int dest;
-	unsigned int irq;
 	int ret = -1;
 
-	irq = desc->irq;
 	cfg = desc->chip_data;
 
 	raw_spin_lock_irqsave(&ioapic_lock, flags);
@@ -2399,7 +2397,7 @@ set_ioapic_affinity_irq_desc(struct irq_desc *desc, const struct cpumask *mask)
 	if (!ret) {
 		/* Only the high 8 bits are valid. */
 		dest = SET_APIC_LOGICAL_ID(dest);
-		__target_IO_APIC_irq(irq, dest, cfg);
+		__target_IO_APIC_irq(desc, dest, cfg);
 	}
 	raw_spin_unlock_irqrestore(&ioapic_lock, flags);
 
@@ -2431,14 +2429,12 @@ migrate_ioapic_irq_desc(struct irq_desc *desc, const struct cpumask *mask)
 	struct irq_cfg *cfg;
 	struct irte irte;
 	unsigned int dest;
-	unsigned int irq;
 	int ret = -1;
 
 	if (!cpumask_intersects(mask, cpu_online_mask))
 		return ret;
 
-	irq = desc->irq;
-	if (get_irte(irq, &irte))
+	if (get_irte(desc, &irte))
 		return ret;
 
 	cfg = desc->chip_data;
@@ -2453,7 +2449,7 @@ migrate_ioapic_irq_desc(struct irq_desc *desc, const struct cpumask *mask)
 	/*
 	 * Modified the IRTE and flushes the Interrupt entry cache.
 	 */
-	modify_irte(irq, &irte);
+	modify_irte(desc, &irte);
 
 	if (cfg->move_in_progress)
 		send_cleanup_vector(cfg);
@@ -2591,7 +2587,7 @@ atomic_t irq_mis_count;
  * Otherwise, we simulate the EOI message manually by changing the trigger
  * mode to edge and then back to level, with RTE being masked during this.
 */
-static void __eoi_ioapic_irq(unsigned int irq, struct irq_cfg *cfg)
+static void __eoi_ioapic_irq(struct irq_desc *desc, struct irq_cfg *cfg)
 {
 	struct irq_pin_list *entry;
 
@@ -2603,7 +2599,7 @@ static void __eoi_ioapic_irq(unsigned int irq, struct irq_cfg *cfg)
 			 * intr-remapping table entry. Hence for the io-apic
 			 * EOI we use the pin number.
 			 */
-			if (irq_remapped(irq))
+			if (irq_remapped(desc))
 				io_apic_eoi(entry->apic, entry->pin);
 			else
 				io_apic_eoi(entry->apic, cfg->vector);
@@ -2618,13 +2614,11 @@ static void eoi_ioapic_irq(struct irq_desc *desc)
 {
 	struct irq_cfg *cfg;
 	unsigned long flags;
-	unsigned int irq;
 
-	irq = desc->irq;
 	cfg = desc->chip_data;
 
 	raw_spin_lock_irqsave(&ioapic_lock, flags);
-	__eoi_ioapic_irq(irq, cfg);
+	__eoi_ioapic_irq(desc, cfg);
 	raw_spin_unlock_irqrestore(&ioapic_lock, flags);
 }
 
@@ -3328,11 +3322,11 @@ void destroy_irq(unsigned int irq)
 	struct irq_desc *desc;
 	struct irq_cfg *cfg;
 
-	dynamic_irq_cleanup_keep_chip_data(irq_to_desc(irq));
+	desc = irq_to_desc(irq);
+	dynamic_irq_cleanup_keep_chip_data(desc);
 
-	free_irte(irq);
+	free_irte(desc);
 	raw_spin_lock_irqsave(&vector_lock, flags);
-	desc = irq_to_desc(irq);
 	cfg = desc->chip_data;
 	__clear_irq_vector(desc, cfg);
 	raw_spin_unlock_irqrestore(&vector_lock, flags);
@@ -3345,7 +3339,6 @@ void destroy_irq(unsigned int irq)
 static int msi_compose_msg(struct pci_dev *pdev, struct irq_desc *desc,
 			   struct msi_msg *msg, u8 hpet_id)
 {
-	unsigned int irq = desc->irq;
 	struct irq_cfg *cfg;
 	int err;
 	unsigned dest;
@@ -3360,15 +3353,15 @@ static int msi_compose_msg(struct pci_dev *pdev, struct irq_desc *desc,
 
 	dest = apic->cpu_mask_to_apicid_and(cfg->domain, apic->target_cpus());
 
-	if (irq_remapped(irq)) {
+	if (irq_remapped(desc)) {
 		struct irte irte;
 		int ir_index;
 		u16 sub_handle;
 
-		ir_index = map_irq_to_irte_handle(irq, &sub_handle);
+		ir_index = map_irq_to_irte_handle(desc, &sub_handle);
 		BUG_ON(ir_index == -1);
 
-		memset (&irte, 0, sizeof(irte));
+		memset(&irte, 0, sizeof(irte));
 
 		irte.present = 1;
 		irte.dst_mode = apic->irq_dest_mode;
@@ -3383,7 +3376,7 @@ static int msi_compose_msg(struct pci_dev *pdev, struct irq_desc *desc,
 		else
 			set_hpet_sid(&irte, hpet_id);
 
-		modify_irte(irq, &irte);
+		modify_irte(desc, &irte);
 
 		msg->address_hi = MSI_ADDR_BASE_HI;
 		msg->data = sub_handle;
@@ -3450,12 +3443,11 @@ static int set_msi_irq_affinity(struct irq_desc *desc, const struct cpumask *mas
 static int
 ir_set_msi_irq_affinity(struct irq_desc *desc, const struct cpumask *mask)
 {
-	unsigned int irq = desc->irq;
 	struct irq_cfg *cfg = desc->chip_data;
 	unsigned int dest;
 	struct irte irte;
 
-	if (get_irte(irq, &irte))
+	if (get_irte(desc, &irte))
 		return -1;
 
 	if (set_desc_affinity(desc, mask, &dest))
@@ -3467,7 +3459,7 @@ ir_set_msi_irq_affinity(struct irq_desc *desc, const struct cpumask *mask)
 	/*
 	 * atomically update the IRTE with the new destination and vector.
 	 */
-	modify_irte(irq, &irte);
+	modify_irte(desc, &irte);
 
 	/*
 	 * After this point, all the interrupts will start arriving
@@ -3522,7 +3514,7 @@ static struct irq_chip msi_ir_chip = {
  * and allocate 'nvec' consecutive interrupt-remapping table entries
  * in it.
  */
-static int msi_alloc_irte(struct pci_dev *dev, int irq, int nvec)
+static int msi_alloc_irte(struct pci_dev *dev, struct irq_desc *desc, int nvec)
 {
 	struct intel_iommu *iommu;
 	int index;
@@ -3534,7 +3526,7 @@ static int msi_alloc_irte(struct pci_dev *dev, int irq, int nvec)
 		return -ENOENT;
 	}
 
-	index = alloc_irte(iommu, irq, nvec);
+	index = alloc_irte(iommu, desc, nvec);
 	if (index < 0) {
 		printk(KERN_ERR
 		       "Unable to allocate %d IRTE for PCI %s\n", nvec,
@@ -3544,20 +3536,22 @@ static int msi_alloc_irte(struct pci_dev *dev, int irq, int nvec)
 	return index;
 }
 
-static int setup_msi_irq(struct pci_dev *dev, struct msi_desc *msidesc, int irq)
+static int
+setup_msi_irq(struct pci_dev *dev, struct msi_desc *msidesc, struct irq_desc *desc)
 {
 	int ret;
 	struct msi_msg msg;
-	struct irq_desc *desc = irq_to_desc(irq);
+	unsigned int irq;
 
 	ret = msi_compose_msg(dev, desc, &msg, -1);
 	if (ret < 0)
 		return ret;
 
-	set_irq_msi(irq, msidesc);
-	write_msi_msg(irq, &msg);
+	set_irq_desc_msi(desc, msidesc);
+	write_msi_msg_desc(desc, &msg);
 
-	if (irq_remapped(irq)) {
+	irq = desc->irq;
+	if (irq_remapped(desc)) {
 		/*
 		 * irq migration in process context
 		 */
@@ -3574,6 +3568,7 @@ static int setup_msi_irq(struct pci_dev *dev, struct msi_desc *msidesc, int irq)
 int arch_setup_msi_irqs(struct pci_dev *dev, int nvec, int type)
 {
 	unsigned int irq;
+	struct irq_desc *desc;
 	int ret, sub_handle;
 	struct msi_desc *msidesc;
 	unsigned int irq_want;
@@ -3593,6 +3588,7 @@ int arch_setup_msi_irqs(struct pci_dev *dev, int nvec, int type)
 		if (irq == 0)
 			return -1;
 		irq_want = irq + 1;
+		desc = irq_to_desc(irq);
 		if (!intr_remapping_enabled)
 			goto no_ir;
 
@@ -3601,7 +3597,7 @@ int arch_setup_msi_irqs(struct pci_dev *dev, int nvec, int type)
 			 * allocate the consecutive block of IRTE's
 			 * for 'nvec'
 			 */
-			index = msi_alloc_irte(dev, irq, nvec);
+			index = msi_alloc_irte(dev, desc, nvec);
 			if (index < 0) {
 				ret = index;
 				goto error;
@@ -3617,10 +3613,10 @@ int arch_setup_msi_irqs(struct pci_dev *dev, int nvec, int type)
 			 * base index, the sub_handle pointing to the
 			 * appropriate interrupt remap table entry.
 			 */
-			set_irte_irq(irq, iommu, index, sub_handle);
+			set_irte_irq(desc, iommu, index, sub_handle);
 		}
 no_ir:
-		ret = setup_msi_irq(dev, msidesc, irq);
+		ret = setup_msi_irq(dev, msidesc, desc);
 		if (ret < 0)
 			goto error;
 		sub_handle++;
@@ -3765,7 +3761,7 @@ int arch_setup_hpet_msi(unsigned int irq, unsigned int id)
 		if (!iommu)
 			return -1;
 
-		index = alloc_irte(iommu, irq, 1);
+		index = alloc_irte(iommu, desc, 1);
 		if (index < 0)
 			return -1;
 	}
@@ -3776,7 +3772,7 @@ int arch_setup_hpet_msi(unsigned int irq, unsigned int id)
 
 	hpet_msi_write(desc, &msg);
 	desc->status |= IRQ_MOVE_PCNTXT;
-	if (irq_remapped(irq))
+	if (irq_remapped(desc))
 		set_irq_chip_and_handler_name(irq, &ir_hpet_msi_type,
 					      handle_edge_irq, "edge");
 	else
diff --git a/drivers/pci/intr_remapping.c b/drivers/pci/intr_remapping.c
index 95b8491..1c03bc7 100644
--- a/drivers/pci/intr_remapping.c
+++ b/drivers/pci/intr_remapping.c
@@ -45,33 +45,27 @@ static struct irq_2_iommu *get_one_free_irq_2_iommu(int node)
 	return iommu;
 }
 
-static struct irq_2_iommu *irq_2_iommu(unsigned int irq)
+static struct irq_2_iommu *irq_2_iommu(struct irq_desc *desc)
 {
-	struct irq_desc *desc;
-
-	desc = irq_to_desc(irq);
-
 	if (WARN_ON_ONCE(!desc))
 		return NULL;
 
 	return desc->irq_2_iommu;
 }
 
-static struct irq_2_iommu *irq_2_iommu_alloc(unsigned int irq)
+static struct irq_2_iommu *irq_2_iommu_alloc(struct irq_desc *desc)
 {
-	struct irq_desc *desc;
 	struct irq_2_iommu *irq_iommu;
 
-	desc = irq_to_desc(irq);
 	if (!desc) {
-		printk(KERN_INFO "can not get irq_desc for %d\n", irq);
+		printk(KERN_INFO "can not get irq_desc\n");
 		return NULL;
 	}
 
 	irq_iommu = desc->irq_2_iommu;
 
 	if (!irq_iommu)
-		desc->irq_2_iommu = get_one_free_irq_2_iommu(irq_node(irq));
+		desc->irq_2_iommu = get_one_free_irq_2_iommu(irq_desc_node(desc));
 
 	return desc->irq_2_iommu;
 }
@@ -80,26 +74,27 @@ static struct irq_2_iommu *irq_2_iommu_alloc(unsigned int irq)
 
 static struct irq_2_iommu irq_2_iommuX[NR_IRQS];
 
-static struct irq_2_iommu *irq_2_iommu(unsigned int irq)
+static struct irq_2_iommu *irq_2_iommu(struct irq_desc *desc)
 {
+	unsigned int irq = desc->irq;
 	if (irq < nr_irqs)
 		return &irq_2_iommuX[irq];
 
 	return NULL;
 }
-static struct irq_2_iommu *irq_2_iommu_alloc(unsigned int irq)
+static struct irq_2_iommu *irq_2_iommu_alloc(struct irq_desc *desc)
 {
-	return irq_2_iommu(irq);
+	return irq_2_iommu(desc);
 }
 #endif
 
 static DEFINE_SPINLOCK(irq_2_ir_lock);
 
-static struct irq_2_iommu *valid_irq_2_iommu(unsigned int irq)
+static struct irq_2_iommu *valid_irq_2_iommu(struct irq_desc *desc)
 {
 	struct irq_2_iommu *irq_iommu;
 
-	irq_iommu = irq_2_iommu(irq);
+	irq_iommu = irq_2_iommu(desc);
 
 	if (!irq_iommu)
 		return NULL;
@@ -110,12 +105,12 @@ static struct irq_2_iommu *valid_irq_2_iommu(unsigned int irq)
 	return irq_iommu;
 }
 
-int irq_remapped(int irq)
+int irq_remapped(struct irq_desc *desc)
 {
-	return valid_irq_2_iommu(irq) != NULL;
+	return valid_irq_2_iommu(desc) != NULL;
 }
 
-int get_irte(int irq, struct irte *entry)
+int get_irte(struct irq_desc *desc, struct irte *entry)
 {
 	int index;
 	struct irq_2_iommu *irq_iommu;
@@ -125,7 +120,7 @@ int get_irte(int irq, struct irte *entry)
 		return -1;
 
 	spin_lock_irqsave(&irq_2_ir_lock, flags);
-	irq_iommu = valid_irq_2_iommu(irq);
+	irq_iommu = valid_irq_2_iommu(desc);
 	if (!irq_iommu) {
 		spin_unlock_irqrestore(&irq_2_ir_lock, flags);
 		return -1;
@@ -138,7 +133,7 @@ int get_irte(int irq, struct irte *entry)
 	return 0;
 }
 
-int alloc_irte(struct intel_iommu *iommu, int irq, u16 count)
+int alloc_irte(struct intel_iommu *iommu, struct irq_desc *desc, u16 count)
 {
 	struct ir_table *table = iommu->ir_table;
 	struct irq_2_iommu *irq_iommu;
@@ -150,12 +145,6 @@ int alloc_irte(struct intel_iommu *iommu, int irq, u16 count)
 	if (!count)
 		return -1;
 
-#ifndef CONFIG_SPARSE_IRQ
-	/* protect irq_2_iommu_alloc later */
-	if (irq >= nr_irqs)
-		return -1;
-#endif
-
 	/*
 	 * start the IRTE search from index 0.
 	 */
@@ -195,7 +184,7 @@ int alloc_irte(struct intel_iommu *iommu, int irq, u16 count)
 	for (i = index; i < index + count; i++)
 		table->base[i].present = 1;
 
-	irq_iommu = irq_2_iommu_alloc(irq);
+	irq_iommu = irq_2_iommu_alloc(desc);
 	if (!irq_iommu) {
 		spin_unlock_irqrestore(&irq_2_ir_lock, flags);
 		printk(KERN_ERR "can't allocate irq_2_iommu\n");
@@ -223,14 +212,14 @@ static int qi_flush_iec(struct intel_iommu *iommu, int index, int mask)
 	return qi_submit_sync(&desc, iommu);
 }
 
-int map_irq_to_irte_handle(int irq, u16 *sub_handle)
+int map_irq_to_irte_handle(struct irq_desc *desc, u16 *sub_handle)
 {
 	int index;
 	struct irq_2_iommu *irq_iommu;
 	unsigned long flags;
 
 	spin_lock_irqsave(&irq_2_ir_lock, flags);
-	irq_iommu = valid_irq_2_iommu(irq);
+	irq_iommu = valid_irq_2_iommu(desc);
 	if (!irq_iommu) {
 		spin_unlock_irqrestore(&irq_2_ir_lock, flags);
 		return -1;
@@ -242,14 +231,14 @@ int map_irq_to_irte_handle(int irq, u16 *sub_handle)
 	return index;
 }
 
-int set_irte_irq(int irq, struct intel_iommu *iommu, u16 index, u16 subhandle)
+int set_irte_irq(struct irq_desc *desc, struct intel_iommu *iommu, u16 index, u16 subhandle)
 {
 	struct irq_2_iommu *irq_iommu;
 	unsigned long flags;
 
 	spin_lock_irqsave(&irq_2_ir_lock, flags);
 
-	irq_iommu = irq_2_iommu_alloc(irq);
+	irq_iommu = irq_2_iommu_alloc(desc);
 
 	if (!irq_iommu) {
 		spin_unlock_irqrestore(&irq_2_ir_lock, flags);
@@ -267,13 +256,13 @@ int set_irte_irq(int irq, struct intel_iommu *iommu, u16 index, u16 subhandle)
 	return 0;
 }
 
-int clear_irte_irq(int irq, struct intel_iommu *iommu, u16 index)
+int clear_irte_irq(struct irq_desc *desc, struct intel_iommu *iommu, u16 index)
 {
 	struct irq_2_iommu *irq_iommu;
 	unsigned long flags;
 
 	spin_lock_irqsave(&irq_2_ir_lock, flags);
-	irq_iommu = valid_irq_2_iommu(irq);
+	irq_iommu = valid_irq_2_iommu(desc);
 	if (!irq_iommu) {
 		spin_unlock_irqrestore(&irq_2_ir_lock, flags);
 		return -1;
@@ -282,14 +271,14 @@ int clear_irte_irq(int irq, struct intel_iommu *iommu, u16 index)
 	irq_iommu->iommu = NULL;
 	irq_iommu->irte_index = 0;
 	irq_iommu->sub_handle = 0;
-	irq_2_iommu(irq)->irte_mask = 0;
+	irq_2_iommu(desc)->irte_mask = 0;
 
 	spin_unlock_irqrestore(&irq_2_ir_lock, flags);
 
 	return 0;
 }
 
-int modify_irte(int irq, struct irte *irte_modified)
+int modify_irte(struct irq_desc *desc, struct irte *irte_modified)
 {
 	int rc;
 	int index;
@@ -299,7 +288,7 @@ int modify_irte(int irq, struct irte *irte_modified)
 	unsigned long flags;
 
 	spin_lock_irqsave(&irq_2_ir_lock, flags);
-	irq_iommu = valid_irq_2_iommu(irq);
+	irq_iommu = valid_irq_2_iommu(desc);
 	if (!irq_iommu) {
 		spin_unlock_irqrestore(&irq_2_ir_lock, flags);
 		return -1;
@@ -320,7 +309,7 @@ int modify_irte(int irq, struct irte *irte_modified)
 	return rc;
 }
 
-int flush_irte(int irq)
+int flush_irte(struct irq_desc *desc)
 {
 	int rc;
 	int index;
@@ -329,7 +318,7 @@ int flush_irte(int irq)
 	unsigned long flags;
 
 	spin_lock_irqsave(&irq_2_ir_lock, flags);
-	irq_iommu = valid_irq_2_iommu(irq);
+	irq_iommu = valid_irq_2_iommu(desc);
 	if (!irq_iommu) {
 		spin_unlock_irqrestore(&irq_2_ir_lock, flags);
 		return -1;
@@ -399,14 +388,14 @@ static int clear_entries(struct irq_2_iommu *irq_iommu)
 	return qi_flush_iec(iommu, index, irq_iommu->irte_mask);
 }
 
-int free_irte(int irq)
+int free_irte(struct irq_desc *desc)
 {
 	int rc = 0;
 	struct irq_2_iommu *irq_iommu;
 	unsigned long flags;
 
 	spin_lock_irqsave(&irq_2_ir_lock, flags);
-	irq_iommu = valid_irq_2_iommu(irq);
+	irq_iommu = valid_irq_2_iommu(desc);
 	if (!irq_iommu) {
 		spin_unlock_irqrestore(&irq_2_ir_lock, flags);
 		return -1;
diff --git a/include/linux/dmar.h b/include/linux/dmar.h
index 6b4227a..a5f04a1 100644
--- a/include/linux/dmar.h
+++ b/include/linux/dmar.h
@@ -113,17 +113,17 @@ extern int enable_intr_remapping(int);
 extern void disable_intr_remapping(void);
 extern int reenable_intr_remapping(int);
 
-extern int get_irte(int irq, struct irte *entry);
-extern int modify_irte(int irq, struct irte *irte_modified);
-extern int alloc_irte(struct intel_iommu *iommu, int irq, u16 count);
-extern int set_irte_irq(int irq, struct intel_iommu *iommu, u16 index,
-   			u16 sub_handle);
-extern int map_irq_to_irte_handle(int irq, u16 *sub_handle);
-extern int clear_irte_irq(int irq, struct intel_iommu *iommu, u16 index);
-extern int flush_irte(int irq);
-extern int free_irte(int irq);
-
-extern int irq_remapped(int irq);
+int get_irte(struct irq_desc *desc, struct irte *entry);
+int modify_irte(struct irq_desc *desc, struct irte *irte_modified);
+int alloc_irte(struct intel_iommu *iommu, struct irq_desc *desc, u16 count);
+int set_irte_irq(struct irq_desc *desc, struct intel_iommu *iommu, u16 index,
+			u16 sub_handle);
+int map_irq_to_irte_handle(struct irq_desc *desc, u16 *sub_handle);
+int clear_irte_irq(struct irq_desc *desc, struct intel_iommu *iommu, u16 index);
+int flush_irte(struct irq_desc *desc);
+int free_irte(struct irq_desc *desc);
+
+extern int irq_remapped(struct irq_desc *desc);
 extern struct intel_iommu *map_dev_to_ir(struct pci_dev *dev);
 extern struct intel_iommu *map_ioapic_to_ir(int apic);
 extern struct intel_iommu *map_hpet_to_ir(u8 id);
@@ -131,23 +131,25 @@ extern int set_ioapic_sid(struct irte *irte, int apic);
 extern int set_hpet_sid(struct irte *irte, u8 id);
 extern int set_msi_sid(struct irte *irte, struct pci_dev *dev);
 #else
-static inline int alloc_irte(struct intel_iommu *iommu, int irq, u16 count)
+static inline int
+alloc_irte(struct intel_iommu *iommu, struct irq_desc *desc, u16 count)
 {
 	return -1;
 }
-static inline int modify_irte(int irq, struct irte *irte_modified)
+static inline int modify_irte(struct irq_desc *desc, struct irte *irte_modified)
 {
 	return -1;
 }
-static inline int free_irte(int irq)
+static inline int free_irte(struct irq_desc *desc)
 {
 	return -1;
 }
-static inline int map_irq_to_irte_handle(int irq, u16 *sub_handle)
+static inline int map_irq_to_irte_handle(struct irq_desc *desc, u16 *sub_handle)
 {
 	return -1;
 }
-static inline int set_irte_irq(int irq, struct intel_iommu *iommu, u16 index,
+static inline int
+set_irte_irq(struct irq_desc *desc, struct intel_iommu *iommu, u16 index,
 			       u16 sub_handle)
 {
 	return -1;
@@ -177,7 +179,7 @@ static inline int set_msi_sid(struct irte *irte, struct pci_dev *dev)
 	return 0;
 }
 
-#define irq_remapped(irq)		(0)
+#define irq_remapped(desc)		(0)
 #define enable_intr_remapping(mode)	(-1)
 #define disable_intr_remapping()	(0)
 #define reenable_intr_remapping(mode)	(0)
-- 
1.6.4.2

