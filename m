Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754966Ab1BMUgr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Feb 2011 15:36:47 -0500
Received: from edu-smtp-01.edutel.nl ([88.159.1.175]:43516 "EHLO
	edu-smtp-01.edutel.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754744Ab1BMUgk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Feb 2011 15:36:40 -0500
X-Greylist: delayed 656 seconds by postgrey-1.27 at vger.kernel.org; Sun, 13 Feb 2011 15:36:39 EST
Message-ID: <4D583E31.4070507@neli.hopto.org>
Date: Sun, 13 Feb 2011 21:25:21 +0100
From: Micha Nelissen <micha@neli.hopto.org>
User-Agent: Mozilla-Thunderbird 2.0.0.22 (X11/20091109)
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        "Venkatesh Pallipadi (Venki)" <venki@google.com>,
        Jesse Barnes <jbarnes@virtuousgeek.org>, linux-kernel@vger.kernel.org,
        linux-pci@vger.kernel.org, Matthew Wilcox <matthew@wil.cx>
Subject: [PATCH] Add support for multiple MSI on x86
Content-Type: multipart/mixed;
 boundary="------------070605090106020505020100"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------070605090106020505020100
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Patch is based on earlier patch from Matthew Wilcox.

--------------070605090106020505020100
Content-Type: text/plain;
 name="0001-Add-support-for-multiple-MSI-on-x86.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="0001-Add-support-for-multiple-MSI-on-x86.patch"

---
 arch/x86/kernel/apic/io_apic.c |  310 ++++++++++++++++++++++++++++++++++------
 arch/x86/kernel/hpet.c         |    2 +-
 drivers/pci/htirq.c            |    2 +-
 include/linux/irq.h            |    3 +-
 4 files changed, 271 insertions(+), 46 deletions(-)

diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
index fadcd74..5e9decc 100644
--- a/arch/x86/kernel/apic/io_apic.c
+++ b/arch/x86/kernel/apic/io_apic.c
@@ -249,11 +249,6 @@ static struct irq_cfg *alloc_irq_and_cfg_at(unsigned int at, int node)
 	return cfg;
 }
 
-static int alloc_irq_from(unsigned int from, int node)
-{
-	return irq_alloc_desc_from(from, node);
-}
-
 static void free_irq_at(unsigned int at, struct irq_cfg *cfg)
 {
 	free_irq_cfg(at, cfg);
@@ -1037,6 +1032,39 @@ void unlock_vector_lock(void)
 	raw_spin_unlock(&vector_lock);
 }
 
+/*
+ * The P6 family and Pentium processors (presumably also earlier processors),
+ * can queue no more than two interrupts per priority level, and will ignore
+ * other interrupts that are received within the same priority level (the
+ * priority level is the vector number shifted right by 4), so we try to
+ * spread these out a bit to avoid this happening.
+ *
+ * Pentium 4, Xeon and later processors do not have this limitation.
+ * It is unknown what limitations AMD, Cyrix, Transmeta, VIA, IDT and
+ * other manufacturers have.
+ */
+static int many_vectors_per_prio(void)
+{
+	struct cpuinfo_x86 *c;
+	static char init, result;
+	if (init)
+		return result;
+
+	c = &boot_cpu_data;
+	switch (c->x86_vendor) {
+	case X86_VENDOR_INTEL:
+		if (c->x86 > 6 ||
+		    ((c->x86 == 6) && (c->x86_model >= 13)))
+			result = 1;
+		break;
+	default:
+		break;
+	}
+
+	init = 1;
+	return result;
+}
+
 static int
 __assign_irq_vector(int irq, struct irq_cfg *cfg, const struct cpumask *mask)
 {
@@ -1117,13 +1145,110 @@ next:
 	return err;
 }
 
+static int __assign_irq_vector_block(int irq, unsigned count, const struct cpumask *mask)
+{
+	static int current_vector = FIRST_EXTERNAL_VECTOR;
+	unsigned int old_vector;
+	unsigned i, cpu;
+	int err;
+	struct irq_cfg *cfg;
+	cpumask_var_t tmp_mask;
+
+	BUG_ON(irq + count > NR_IRQS);
+	BUG_ON(count & (count - 1));
+
+	for (i = 0; i < count; i++) {
+		cfg = irq_cfg(irq + i);
+		if (cfg->move_in_progress)
+			return -EBUSY;
+	}
+
+	if (!alloc_cpumask_var(&tmp_mask, GFP_ATOMIC))
+		return -ENOMEM;
+
+	cfg = irq_cfg(irq);
+	old_vector = cfg->vector;
+	if (old_vector) {
+		err = 0;
+		cpumask_and(tmp_mask, mask, cpu_online_mask);
+		cpumask_and(tmp_mask, cfg->domain, tmp_mask);
+		if (!cpumask_empty(tmp_mask))
+			goto out;
+	}
+
+	/* Only try and allocate irqs on cpus that are present */
+	err = -ENOSPC;
+	for_each_cpu_and(cpu, mask, cpu_online_mask) {
+		int new_cpu;
+		int vector;
+
+		apic->vector_allocation_domain(cpu, tmp_mask);
+
+		vector = current_vector & ~(count - 1);
+next:
+		vector += count;
+		if (vector + count >= first_system_vector) {
+			vector = FIRST_EXTERNAL_VECTOR & ~(count - 1);
+			if (vector < FIRST_EXTERNAL_VECTOR)
+				vector += count;
+		}
+		if (unlikely((current_vector & ~(count - 1)) == vector))
+			continue;
+
+		for (i = 0; i < count; i++)
+			if (test_bit(vector + i, used_vectors))
+				goto next;
+
+		for_each_cpu_and(new_cpu, tmp_mask, cpu_online_mask) {
+			for (i = 0; i < count; i++) {
+				if (per_cpu(vector_irq, new_cpu)[vector + i] != -1)
+					goto next;
+			}
+		}
+		/* Found one! */
+		current_vector = vector + count - 1;
+		for (i = 0; i < count; i++) {
+			cfg = irq_cfg(irq + i);
+			if (old_vector) {
+				cfg->move_in_progress = 1;
+				cpumask_copy(cfg->old_domain, cfg->domain);
+			}
+			for_each_cpu_and(new_cpu, tmp_mask, cpu_online_mask)
+				per_cpu(vector_irq, new_cpu)[vector + i] = irq + i;
+			cfg->vector = vector + i;
+			cpumask_copy(cfg->domain, tmp_mask);
+		}
+		err = 0;
+		break;
+	}
+out:
+	free_cpumask_var(tmp_mask);
+	return err;
+}
+
 int assign_irq_vector(int irq, struct irq_cfg *cfg, const struct cpumask *mask)
 {
 	int err;
 	unsigned long flags;
 
 	raw_spin_lock_irqsave(&vector_lock, flags);
-	err = __assign_irq_vector(irq, cfg, mask);
+	if (many_vectors_per_prio())
+		err = __assign_irq_vector_block(irq, 1, mask);
+	else
+		err = __assign_irq_vector(irq, cfg, mask);
+	raw_spin_unlock_irqrestore(&vector_lock, flags);
+	return err;
+}
+
+/* Assumes that count is a power of two and aligns to that power of two */
+static int
+assign_irq_vector_block(int irq, unsigned count, const struct cpumask *mask)
+{
+	int err;
+	unsigned long flags;
+
+	raw_spin_lock_irqsave(&vector_lock, flags);
+	err = __assign_irq_vector_block(irq, count, mask);
 	raw_spin_unlock_irqrestore(&vector_lock, flags);
 	return err;
 }
@@ -2200,14 +2325,34 @@ int __ioapic_set_affinity(struct irq_data *data, const struct cpumask *mask,
 			  unsigned int *dest_id)
 {
 	struct irq_cfg *cfg = data->chip_data;
+	unsigned irq;
 
 	if (!cpumask_intersects(mask, cpu_online_mask))
 		return -1;
 
-	if (assign_irq_vector(data->irq, data->chip_data, mask))
-		return -1;
+	irq = data->irq;
+	cfg = data->chip_data;
 
-	cpumask_copy(data->affinity, mask);
+	if (many_vectors_per_prio()) {
+		struct msi_desc *msi_desc = data->msi_desc;
+		unsigned i, count = 1;
+
+		if (msi_desc)
+			count = 1 << msi_desc->msi_attrib.multiple;
+
+		/* Multiple MSIs all go to the same destination */
+		if (assign_irq_vector_block(irq, count, mask))
+			return -1;
+		for (i = 0; i < count; i++) {
+			data = &irq_to_desc(irq + i)->irq_data;
+			cpumask_copy(data->affinity, mask);
+		}
+	} else {
+		if (assign_irq_vector(irq, cfg, mask))
+			return BAD_APICID;
+
+		cpumask_copy(data->affinity, mask);
+	}
 
 	*dest_id = apic->cpu_mask_to_apicid_and(mask, cfg->domain);
 	return 0;
@@ -3053,7 +3198,7 @@ device_initcall(ioapic_init_sysfs);
 /*
  * Dynamic irq allocate and deallocation
  */
-unsigned int create_irq_nr(unsigned int from, int node)
+unsigned int create_irq_nr(unsigned int from, unsigned count, int node)
 {
 	struct irq_cfg *cfg;
 	unsigned long flags;
@@ -3063,25 +3208,31 @@ unsigned int create_irq_nr(unsigned int from, int node)
 	if (from < nr_irqs_gsi)
 		from = nr_irqs_gsi;
 
-	irq = alloc_irq_from(from, node);
+	irq = irq_alloc_descs(-1, from, count, node);
 	if (irq < 0)
 		return 0;
 	cfg = alloc_irq_cfg(irq, node);
 	if (!cfg) {
-		free_irq_at(irq, NULL);
+		irq_free_descs(irq, count);
 		return 0;
 	}
 
 	raw_spin_lock_irqsave(&vector_lock, flags);
-	if (!__assign_irq_vector(irq, cfg, apic->target_cpus()))
-		ret = irq;
+	if (many_vectors_per_prio()) {
+		if (!__assign_irq_vector_block(irq, count, apic->target_cpus()))
+			ret = irq;
+	} else {
+		if (!__assign_irq_vector(irq, cfg, apic->target_cpus()))
+			ret = irq;
+	}
 	raw_spin_unlock_irqrestore(&vector_lock, flags);
 
 	if (ret) {
 		set_irq_chip_data(irq, cfg);
 		irq_clear_status_flags(irq, IRQ_NOREQUEST);
 	} else {
-		free_irq_at(irq, cfg);
+		free_irq_cfg(irq, cfg);
+		irq_free_descs(irq, count);
 	}
 	return ret;
 }
@@ -3093,7 +3244,7 @@ int create_irq(void)
 	int irq;
 
 	irq_want = nr_irqs_gsi;
-	irq = create_irq_nr(irq_want, node);
+	irq = create_irq_nr(irq_want, 1, node);
 
 	if (irq == 0)
 		irq = -1;
@@ -3121,7 +3272,7 @@ void destroy_irq(unsigned int irq)
  */
 #ifdef CONFIG_PCI_MSI
 static int msi_compose_msg(struct pci_dev *pdev, unsigned int irq,
-			   struct msi_msg *msg, u8 hpet_id)
+			   unsigned count, struct msi_msg *msg, u8 hpet_id)
 {
 	struct irq_cfg *cfg;
 	int err;
@@ -3131,7 +3282,10 @@ static int msi_compose_msg(struct pci_dev *pdev, unsigned int irq,
 		return -ENXIO;
 
 	cfg = irq_cfg(irq);
-	err = assign_irq_vector(irq, cfg, apic->target_cpus());
+	if (count == 1)
+		err = assign_irq_vector(irq, cfg, apic->target_cpus());
+	else
+		err = assign_irq_vector_block(irq, count, apic->target_cpus());
 	if (err)
 		return err;
 
@@ -3307,47 +3461,99 @@ static int msi_alloc_irte(struct pci_dev *dev, int irq, int nvec)
 	return index;
 }
 
-static int setup_msi_irq(struct pci_dev *dev, struct msi_desc *msidesc, int irq)
+static int setup_msi_irq(struct pci_dev *dev, struct msi_desc *msidesc,
+			 unsigned count, int base_irq)
 {
 	struct msi_msg msg;
+	unsigned irq;
 	int ret;
 
-	ret = msi_compose_msg(dev, irq, &msg, -1);
+	ret = msi_compose_msg(dev, base_irq, count, &msg, -1);
 	if (ret < 0)
 		return ret;
 
-	set_irq_msi(irq, msidesc);
-	write_msi_msg(irq, &msg);
+	msidesc->msi_attrib.multiple = order_base_2(count);
 
-	if (irq_remapped(get_irq_chip_data(irq))) {
-		irq_set_status_flags(irq, IRQ_MOVE_PCNTXT);
-		set_irq_chip_and_handler_name(irq, &msi_ir_chip, handle_edge_irq, "edge");
-	} else
-		set_irq_chip_and_handler_name(irq, &msi_chip, handle_edge_irq, "edge");
+	/* perform loop backwards, so first irq has msidesc set */
+	for (irq = base_irq + count - 1; irq >= base_irq; irq--) {
+		set_irq_msi(irq, msidesc);
+		if (irq_remapped(get_irq_chip_data(irq))) {
+			irq_set_status_flags(irq, IRQ_MOVE_PCNTXT);
+			set_irq_chip_and_handler_name(irq, &msi_ir_chip, handle_edge_irq, "edge");
+		} else
+			set_irq_chip_and_handler_name(irq, &msi_chip, handle_edge_irq, "edge");
+	}
 
-	dev_printk(KERN_DEBUG, &dev->dev, "irq %d for MSI/MSI-X\n", irq);
+	write_msi_msg(base_irq, &msg);
+	dev_printk(KERN_DEBUG, &dev->dev, "irq %d-%d for MSI/MSI-X\n",
+		base_irq, base_irq + count - 1);
 
 	return 0;
 }
 
-int native_setup_msi_irqs(struct pci_dev *dev, int nvec, int type)
+static int setup_msi_irqs(struct pci_dev *dev, int nvec)
+{
+	unsigned base_irq, alloc, i;
+	int ret, node;
+	struct msi_desc *msidesc = list_first_entry(&dev->msi_list,
+							struct msi_desc, list);
+	struct intel_iommu *iommu = map_dev_to_ir(dev);
+
+	if (intr_remapping_enabled && !iommu)
+		return -ENOENT;
+	if (nvec > 1 && !many_vectors_per_prio())
+		return 1;
+
+	/*
+	 * MSI only lets you program the device with nvec that is a power
+	 * of two.  We could possibly trust the device driver that it'll
+	 * only use the number it asked for, but to be safe, let's reserve
+	 * all the interrupts we're telling the device it can use.
+	 */
+	alloc = roundup_pow_of_two(nvec);
+	node = dev_to_node(&dev->dev);
+	base_irq = create_irq_nr(nr_irqs_gsi, alloc, node);
+	if (base_irq == 0)
+		return (alloc > 1) ? alloc / 2 : -ENOSPC;
+
+	if (intr_remapping_enabled) {
+		ret = msi_alloc_irte(dev, base_irq, alloc);
+		if (ret < 0)
+			goto error;
+
+		for (i = 1; i < alloc; i++)
+			set_irte_irq(base_irq + i, iommu, ret, i);
+	}
+
+	ret = setup_msi_irq(dev, msidesc, alloc, base_irq);
+	if (ret < 0)
+		goto error;
+
+	return 0;
+
+error:
+	for (i = 0; i < alloc; i++)
+		destroy_irq(base_irq + i);
+	return ret;
+}
+
+static int setup_msix_irqs(struct pci_dev *dev, int nvec)
 {
 	int node, ret, sub_handle, index = 0;
+	struct intel_iommu *iommu = map_dev_to_ir(dev);
 	unsigned int irq, irq_want;
 	struct msi_desc *msidesc;
-	struct intel_iommu *iommu = NULL;
 
-	/* x86 doesn't support multiple MSI yet */
-	if (type == PCI_CAP_ID_MSI && nvec > 1)
-		return 1;
+	if (intr_remapping_enabled && !iommu)
+		return -ENOENT;
 
 	node = dev_to_node(&dev->dev);
 	irq_want = nr_irqs_gsi;
 	sub_handle = 0;
 	list_for_each_entry(msidesc, &dev->msi_list, list) {
-		irq = create_irq_nr(irq_want, node);
+		irq = create_irq_nr(irq_want, 1, node);
 		if (irq == 0)
-			return -1;
+			return -ENOSPC;
 		irq_want = irq + 1;
 		if (!intr_remapping_enabled)
 			goto no_ir;
@@ -3363,11 +3569,6 @@ int native_setup_msi_irqs(struct pci_dev *dev, int nvec, int type)
 				goto error;
 			}
 		} else {
-			iommu = map_dev_to_ir(dev);
-			if (!iommu) {
-				ret = -ENOENT;
-				goto error;
-			}
 			/*
 			 * setup the mapping between the irq and the IRTE
 			 * base index, the sub_handle pointing to the
@@ -3376,7 +3577,7 @@ int native_setup_msi_irqs(struct pci_dev *dev, int nvec, int type)
 			set_irte_irq(irq, iommu, index, sub_handle);
 		}
 no_ir:
-		ret = setup_msi_irq(dev, msidesc, irq);
+		ret = setup_msi_irq(dev, msidesc, 1, irq);
 		if (ret < 0)
 			goto error;
 		sub_handle++;
@@ -3388,11 +3589,34 @@ error:
 	return ret;
 }
 
+int native_setup_msi_irqs(struct pci_dev *dev, int nvec, int type)
+{
+	if (type == PCI_CAP_ID_MSI) {
+		return setup_msi_irqs(dev, nvec);
+	} else {
+		return setup_msix_irqs(dev, nvec);
+	}
+}
+
 void native_teardown_msi_irq(unsigned int irq)
 {
 	destroy_irq(irq);
 }
 
+void native_teardown_msi_irqs(struct pci_dev *dev)
+{
+	struct msi_desc *desc;
+	unsigned i;
+
+	list_for_each_entry(desc, &dev->msi_list, list) {
+		if (desc->irq == 0)
+			continue;
+		for (i = 0; i < (1 << desc->msi_attrib.multiple); i++) {
+			destroy_irq(desc->irq + i);
+		}
+	}
+}
+
 #if defined (CONFIG_DMAR) || defined (CONFIG_INTR_REMAP)
 #ifdef CONFIG_SMP
 static int
@@ -3437,7 +3661,7 @@ int arch_setup_dmar_msi(unsigned int irq)
 	int ret;
 	struct msi_msg msg;
 
-	ret = msi_compose_msg(NULL, irq, &msg, -1);
+	ret = msi_compose_msg(NULL, irq, 1, &msg, -1);
 	if (ret < 0)
 		return ret;
 	dmar_msi_write(irq, &msg);
@@ -3515,7 +3739,7 @@ int arch_setup_hpet_msi(unsigned int irq, unsigned int id)
 			return -1;
 	}
 
-	ret = msi_compose_msg(NULL, irq, &msg, id);
+	ret = msi_compose_msg(NULL, irq, 1, &msg, id);
 	if (ret < 0)
 		return ret;
 
diff --git a/arch/x86/kernel/hpet.c b/arch/x86/kernel/hpet.c
index 4ff5968..cce3afd 100644
--- a/arch/x86/kernel/hpet.c
+++ b/arch/x86/kernel/hpet.c
@@ -499,7 +499,7 @@ static int hpet_assign_irq(struct hpet_dev *dev)
 {
 	unsigned int irq;
 
-	irq = create_irq_nr(0, -1);
+	irq = create_irq_nr(0, 1, -1);
 	if (!irq)
 		return -EINVAL;
 
diff --git a/drivers/pci/htirq.c b/drivers/pci/htirq.c
index 834842a..2b48cc3 100644
--- a/drivers/pci/htirq.c
+++ b/drivers/pci/htirq.c
@@ -120,7 +120,7 @@ int __ht_create_irq(struct pci_dev *dev, int idx, ht_irq_update_t *update)
 	cfg->msg.address_hi = 0xffffffff;
 
 	node = dev_to_node(&dev->dev);
-	irq = create_irq_nr(0, node);
+	irq = create_irq_nr(0, 1, node);
 
 	if (irq <= 0) {
 		kfree(cfg);
diff --git a/include/linux/irq.h b/include/linux/irq.h
index abde252..842a8c4 100644
--- a/include/linux/irq.h
+++ b/include/linux/irq.h
@@ -322,7 +322,8 @@ static inline void set_irq_probe(unsigned int irq)
 }
 
 /* Handle dynamic irq creation and destruction */
-extern unsigned int create_irq_nr(unsigned int irq_want, int node);
+extern unsigned int create_irq_nr(unsigned int irq_want, unsigned count,
+				  int node);
 extern int create_irq(void);
 extern void destroy_irq(unsigned int irq);
 
-- 
1.5.6.5


--------------070605090106020505020100--
