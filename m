Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752845Ab2KSPCO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2012 10:02:14 -0500
Received: from mx1.redhat.com ([209.132.183.28]:60835 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751944Ab2KSPCN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2012 10:02:13 -0500
Date: Mon, 19 Nov 2012 16:01:29 +0100
From: Alexander Gordeev <agordeev@redhat.com>
To: Jeff Garzik <jgarzik@pobox.com>
Cc: Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        Yinghai Lu <yinghai@kernel.org>,
        Matthew Wilcox <willy@linux.intel.com>, x86@kernel.org,
        linux-pci@vger.kernel.org, linux-ide@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v4 -tip 1/3] x86, MSI: Support multiple MSIs in presense of
 IRQ remapping
Message-ID: <c8bd86ff56b5fc118257436768aaa04489ac0a4c.1353324359.git.agordeev@redhat.com>
References: <cover.1353324359.git.agordeev@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1353324359.git.agordeev@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The MSI specification has several constraints in comparison with MSI-X,
most notable of them is the inability to configure MSIs independently.
As a result, it is impossible to dispatch interrupts from different
queues to different CPUs. This is largely devalues the support of
multiple MSIs in SMP systems.

Also, a necessity to allocate a contiguous block of vector numbers for
devices capable of multiple MSIs might cause a considerable pressure on
x86 interrupt vector allocator and could lead to fragmentation of the
interrupt vectors space.

This patch overcomes both drawbacks in presense of IRQ remapping and
lets devices take advantage of multiple queues and per-IRQ affinity
assignments.

Signed-off-by: Alexander Gordeev <agordeev@redhat.com>
---
 arch/x86/kernel/apic/io_apic.c |  165 ++++++++++++++++++++++++++++++++--------
 include/linux/irq.h            |    5 +
 kernel/irq/chip.c              |   30 +++++--
 3 files changed, 160 insertions(+), 40 deletions(-)

diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
index b134f0b..2cdc1b9 100644
--- a/arch/x86/kernel/apic/io_apic.c
+++ b/arch/x86/kernel/apic/io_apic.c
@@ -300,9 +300,9 @@ static struct irq_cfg *alloc_irq_and_cfg_at(unsigned int at, int node)
 	return cfg;
 }
 
-static int alloc_irq_from(unsigned int from, int node)
+static int alloc_irqs_from(unsigned int from, unsigned int count, int node)
 {
-	return irq_alloc_desc_from(from, node);
+	return irq_alloc_descs_from(from, count, node);
 }
 
 static void free_irq_at(unsigned int at, struct irq_cfg *cfg)
@@ -2994,37 +2994,58 @@ device_initcall(ioapic_init_ops);
 /*
  * Dynamic irq allocate and deallocation
  */
-unsigned int create_irq_nr(unsigned int from, int node)
+unsigned int __create_irqs(unsigned int from, unsigned int count, int node)
 {
-	struct irq_cfg *cfg;
+	struct irq_cfg **cfg;
 	unsigned long flags;
-	unsigned int ret = 0;
-	int irq;
+	int irq, i;
 
 	if (from < nr_irqs_gsi)
 		from = nr_irqs_gsi;
 
-	irq = alloc_irq_from(from, node);
-	if (irq < 0)
-		return 0;
-	cfg = alloc_irq_cfg(irq, node);
-	if (!cfg) {
-		free_irq_at(irq, NULL);
+	cfg = kzalloc_node(count * sizeof(cfg[0]), GFP_KERNEL, node);
+	if (!cfg)
 		return 0;
+
+	irq = alloc_irqs_from(from, count, node);
+	if (irq < 0)
+		goto out_cfgs;
+
+	for (i = 0; i < count; i++) {
+		cfg[i] = alloc_irq_cfg(irq + i, node);
+		if (!cfg[i])
+			goto out_irqs;
 	}
 
 	raw_spin_lock_irqsave(&vector_lock, flags);
-	if (!__assign_irq_vector(irq, cfg, apic->target_cpus()))
-		ret = irq;
+	for (i = 0; i < count; i++)
+		if (__assign_irq_vector(irq + i, cfg[i], apic->target_cpus()))
+			goto out_vecs;
 	raw_spin_unlock_irqrestore(&vector_lock, flags);
 
-	if (ret) {
-		irq_set_chip_data(irq, cfg);
-		irq_clear_status_flags(irq, IRQ_NOREQUEST);
-	} else {
-		free_irq_at(irq, cfg);
+	for (i = 0; i < count; i++) {
+		irq_set_chip_data(irq + i, cfg[i]);
+		irq_clear_status_flags(irq + i, IRQ_NOREQUEST);
 	}
-	return ret;
+
+	kfree(cfg);
+	return irq;
+
+out_vecs:
+	for (i--; i >= 0; i--)
+		__clear_irq_vector(irq + i, cfg[i]);
+	raw_spin_unlock_irqrestore(&vector_lock, flags);
+out_irqs:
+	for (i = 0; i < count; i++)
+		free_irq_at(irq + i, cfg[i]);
+out_cfgs:
+	kfree(cfg);
+	return 0;
+}
+
+unsigned int create_irq_nr(unsigned int from, int node)
+{
+	return __create_irqs(from, 1, node);
 }
 
 int create_irq(void)
@@ -3057,6 +3078,14 @@ void destroy_irq(unsigned int irq)
 	free_irq_at(irq, cfg);
 }
 
+static inline void destroy_irqs(unsigned int irq, unsigned int count)
+{
+	unsigned int i;
+
+	for (i = 0; i < count; i++)
+		destroy_irq(irq + i);
+}
+
 /*
  * MSI message composition
  */
@@ -3083,7 +3112,7 @@ static int msi_compose_msg(struct pci_dev *pdev, unsigned int irq,
 
 	if (irq_remapped(cfg)) {
 		compose_remapped_msi_msg(pdev, irq, dest, msg, hpet_id);
-		return err;
+		return 0;
 	}
 
 	if (x2apic_enabled())
@@ -3110,7 +3139,7 @@ static int msi_compose_msg(struct pci_dev *pdev, unsigned int irq,
 			MSI_DATA_DELIVERY_LOWPRI) |
 		MSI_DATA_VECTOR(cfg->vector);
 
-	return err;
+	return 0;
 }
 
 static int
@@ -3148,18 +3177,26 @@ static struct irq_chip msi_chip = {
 	.irq_retrigger		= ioapic_retrigger_irq,
 };
 
-static int setup_msi_irq(struct pci_dev *dev, struct msi_desc *msidesc, int irq)
+static int setup_msi_irq(struct pci_dev *dev, struct msi_desc *msidesc,
+			 unsigned int irq_base, unsigned int irq_offset)
 {
 	struct irq_chip *chip = &msi_chip;
 	struct msi_msg msg;
+	unsigned int irq = irq_base + irq_offset;
 	int ret;
 
 	ret = msi_compose_msg(dev, irq, &msg, -1);
 	if (ret < 0)
 		return ret;
 
-	irq_set_msi_desc(irq, msidesc);
-	write_msi_msg(irq, &msg);
+	irq_set_msi_desc_off(irq_base, irq_offset, msidesc);
+
+	/*
+	 * MSI-X message is written per-IRQ, the offset is always 0.
+	 * MSI message denotes a contiguous group of IRQs, written for 0th IRQ.
+	 */
+	if (!irq_offset)
+		write_msi_msg(irq, &msg);
 
 	if (irq_remapped(irq_get_chip_data(irq))) {
 		irq_set_status_flags(irq, IRQ_MOVE_PCNTXT);
@@ -3173,23 +3210,19 @@ static int setup_msi_irq(struct pci_dev *dev, struct msi_desc *msidesc, int irq)
 	return 0;
 }
 
-int native_setup_msi_irqs(struct pci_dev *dev, int nvec, int type)
+int setup_msix_irqs(struct pci_dev *dev, int nvec)
 {
 	int node, ret, sub_handle, index = 0;
 	unsigned int irq, irq_want;
 	struct msi_desc *msidesc;
 
-	/* x86 doesn't support multiple MSI yet */
-	if (type == PCI_CAP_ID_MSI && nvec > 1)
-		return 1;
-
 	node = dev_to_node(&dev->dev);
 	irq_want = nr_irqs_gsi;
 	sub_handle = 0;
 	list_for_each_entry(msidesc, &dev->msi_list, list) {
 		irq = create_irq_nr(irq_want, node);
 		if (irq == 0)
-			return -1;
+			return -ENOSPC;
 		irq_want = irq + 1;
 		if (!irq_remapping_enabled)
 			goto no_ir;
@@ -3211,7 +3244,7 @@ int native_setup_msi_irqs(struct pci_dev *dev, int nvec, int type)
 				goto error;
 		}
 no_ir:
-		ret = setup_msi_irq(dev, msidesc, irq);
+		ret = setup_msi_irq(dev, msidesc, irq, 0);
 		if (ret < 0)
 			goto error;
 		sub_handle++;
@@ -3223,6 +3256,74 @@ error:
 	return ret;
 }
 
+int setup_msi_irqs(struct pci_dev *dev, int nvec)
+{
+	int node, ret, sub_handle, index = 0;
+	unsigned int irq;
+	struct msi_desc *msidesc;
+
+	if (nvec > 1 && !irq_remapping_enabled)
+		return 1;
+
+	nvec = __roundup_pow_of_two(nvec);
+
+	WARN_ON(!list_is_singular(&dev->msi_list));
+	msidesc = list_entry(dev->msi_list.next, struct msi_desc, list);
+	WARN_ON(msidesc->irq);
+	WARN_ON(msidesc->msi_attrib.multiple);
+
+	node = dev_to_node(&dev->dev);
+	irq = __create_irqs(nr_irqs_gsi, nvec, node);
+	if (irq == 0)
+		return -ENOSPC;
+
+	if (!irq_remapping_enabled) {
+		ret = setup_msi_irq(dev, msidesc, irq, 0);
+		if (ret < 0)
+			goto error;
+		return 0;
+	}
+
+	msidesc->msi_attrib.multiple = ilog2(nvec);
+	for (sub_handle = 0; sub_handle < nvec; sub_handle++) {
+		if (!sub_handle) {
+			index = msi_alloc_remapped_irq(dev, irq, nvec);
+			if (index < 0) {
+				ret = index;
+				goto error;
+			}
+		} else {
+			ret = msi_setup_remapped_irq(dev, irq + sub_handle,
+						     index, sub_handle);
+			if (ret < 0)
+				goto error;
+		}
+		ret = setup_msi_irq(dev, msidesc, irq, sub_handle);
+		if (ret < 0)
+			goto error;
+	}
+	return 0;
+
+error:
+	destroy_irqs(irq, nvec);
+
+	/*
+	 * Restore altered MSI descriptor fields and prevent just destroyed
+	 * IRQs from tearing down again in default_teardown_msi_irqs()
+	 */
+	msidesc->irq = 0;
+	msidesc->msi_attrib.multiple = 0;
+
+	return ret;
+}
+
+int native_setup_msi_irqs(struct pci_dev *dev, int nvec, int type)
+{
+	if (type == PCI_CAP_ID_MSI)
+		return setup_msi_irqs(dev, nvec);
+	return setup_msix_irqs(dev, nvec);
+}
+
 void native_teardown_msi_irq(unsigned int irq)
 {
 	destroy_irq(irq);
diff --git a/include/linux/irq.h b/include/linux/irq.h
index 526f10a..90568cf 100644
--- a/include/linux/irq.h
+++ b/include/linux/irq.h
@@ -531,6 +531,8 @@ extern int irq_set_handler_data(unsigned int irq, void *data);
 extern int irq_set_chip_data(unsigned int irq, void *data);
 extern int irq_set_irq_type(unsigned int irq, unsigned int type);
 extern int irq_set_msi_desc(unsigned int irq, struct msi_desc *entry);
+extern int irq_set_msi_desc_off(unsigned int irq_base, unsigned int irq_offset,
+				struct msi_desc *entry);
 extern struct irq_data *irq_get_irq_data(unsigned int irq);
 
 static inline struct irq_chip *irq_get_chip(unsigned int irq)
@@ -593,6 +595,9 @@ int __irq_alloc_descs(int irq, unsigned int from, unsigned int cnt, int node,
 #define irq_alloc_desc_from(from, node)		\
 	irq_alloc_descs(-1, from, 1, node)
 
+#define irq_alloc_descs_from(from, cnt, node)	\
+	irq_alloc_descs(-1, from, cnt, node)
+
 void irq_free_descs(unsigned int irq, unsigned int cnt);
 int irq_reserve_irqs(unsigned int from, unsigned int cnt);
 
diff --git a/kernel/irq/chip.c b/kernel/irq/chip.c
index 3aca9f2..cbd97ce 100644
--- a/kernel/irq/chip.c
+++ b/kernel/irq/chip.c
@@ -90,27 +90,41 @@ int irq_set_handler_data(unsigned int irq, void *data)
 EXPORT_SYMBOL(irq_set_handler_data);
 
 /**
- *	irq_set_msi_desc - set MSI descriptor data for an irq
- *	@irq:	Interrupt number
- *	@entry:	Pointer to MSI descriptor data
+ *	irq_set_msi_desc_off - set MSI descriptor data for an irq at offset
+ *	@irq_base:	Interrupt number base
+ *	@irq_offset:	Interrupt number offset
+ *	@entry:		Pointer to MSI descriptor data
  *
- *	Set the MSI descriptor entry for an irq
+ *	Set the MSI descriptor entry for an irq at offset
  */
-int irq_set_msi_desc(unsigned int irq, struct msi_desc *entry)
+int irq_set_msi_desc_off(unsigned int irq_base, unsigned int irq_offset,
+			 struct msi_desc *entry)
 {
 	unsigned long flags;
-	struct irq_desc *desc = irq_get_desc_lock(irq, &flags, IRQ_GET_DESC_CHECK_GLOBAL);
+	struct irq_desc *desc = irq_get_desc_lock(irq_base + irq_offset, &flags, IRQ_GET_DESC_CHECK_GLOBAL);
 
 	if (!desc)
 		return -EINVAL;
 	desc->irq_data.msi_desc = entry;
-	if (entry)
-		entry->irq = irq;
+	if (entry && !irq_offset)
+		entry->irq = irq_base;
 	irq_put_desc_unlock(desc, flags);
 	return 0;
 }
 
 /**
+ *	irq_set_msi_desc - set MSI descriptor data for an irq
+ *	@irq:	Interrupt number
+ *	@entry:	Pointer to MSI descriptor data
+ *
+ *	Set the MSI descriptor entry for an irq
+ */
+int irq_set_msi_desc(unsigned int irq, struct msi_desc *entry)
+{
+	return irq_set_msi_desc_off(irq, 0, entry);
+}
+
+/**
  *	irq_set_chip_data - set irq chip data for an irq
  *	@irq:	Interrupt number
  *	@data:	Pointer to chip specific data
-- 
1.7.7.6


-- 
Regards,
Alexander Gordeev
agordeev@redhat.com
