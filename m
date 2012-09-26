Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755386Ab2IZKsk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2012 06:48:40 -0400
Received: from [216.32.181.181] ([216.32.181.181]:23392 "EHLO
	ch1outboundpool.messaging.microsoft.com" rhost-flags-FAIL-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752874Ab2IZKqa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2012 06:46:30 -0400
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-SpamScore: 1
X-BigFish: VPS1(zzd6f1izz1202h1d1ah1d2ahzz8275bhz2dh668h839hd24he5bhf0ah11b5h121eh1288h12a5h12a9h12bdh12e5h137ah139eh13b6h1155h)
X-WSS-ID: 0MAYDV3-02-54F-02
X-M-MSG: 
From: Joerg Roedel <joerg.roedel@amd.com>
To: <x86@kernel.org>
CC: <linux-kernel@vger.kernel.org>, <joro@8bytes.org>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        Yinghai Lu <yinghai@kernel.org>,
        Sebastian Andrzej Siewior <sebastian@breakpoint.cc>,
        Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 13/19] x86, io-apic: Move CONFIG_IRQ_REMAP code out of x86 core
Date: Wed, 26 Sep 2012 12:44:45 +0200
Message-ID: <1348656291-10375-14-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1348656291-10375-1-git-send-email-joerg.roedel@amd.com>
References: <1348656291-10375-1-git-send-email-joerg.roedel@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move all the code to either to the header file
asm/irq_remapping.h or to drivers/iommu/.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/include/asm/hw_irq.h        |    1 +
 arch/x86/include/asm/io_apic.h       |    5 ++++
 arch/x86/include/asm/irq_remapping.h |   17 +++++++++++++
 arch/x86/kernel/apic/io_apic.c       |   44 +---------------------------------
 drivers/iommu/intel_irq_remapping.c  |    4 ++++
 drivers/iommu/irq_remapping.c        |   25 +++++++++++++++++++
 6 files changed, 53 insertions(+), 43 deletions(-)

diff --git a/arch/x86/include/asm/hw_irq.h b/arch/x86/include/asm/hw_irq.h
index fc89a2a..10a78c3 100644
--- a/arch/x86/include/asm/hw_irq.h
+++ b/arch/x86/include/asm/hw_irq.h
@@ -127,6 +127,7 @@ struct irq_cfg {
 	u8			vector;
 	u8			move_in_progress : 1;
 #ifdef CONFIG_IRQ_REMAP
+	u8			remapped : 1;
 	union {
 		struct irq_2_iommu irq_2_iommu;
 		struct irq_2_irte  irq_2_irte;
diff --git a/arch/x86/include/asm/io_apic.h b/arch/x86/include/asm/io_apic.h
index 71f5f08..36fb5ab 100644
--- a/arch/x86/include/asm/io_apic.h
+++ b/arch/x86/include/asm/io_apic.h
@@ -144,6 +144,7 @@ extern int timer_through_8259;
 	(mp_irq_entries && !skip_ioapic_setup && io_apic_irqs)
 
 struct io_apic_irq_attr;
+struct irq_cfg;
 extern int io_apic_set_pci_routing(struct device *dev, int irq,
 		 struct io_apic_irq_attr *irq_attr);
 void setup_IO_APIC_irq_extra(u32 gsi);
@@ -152,6 +153,10 @@ extern void ioapic_insert_resources(void);
 extern int native_setup_ioapic_entry(int, struct IO_APIC_route_entry *,
 				     unsigned int, int,
 				     struct io_apic_irq_attr *);
+extern int native_setup_ioapic_entry(int, struct IO_APIC_route_entry *,
+				     unsigned int, int,
+				     struct io_apic_irq_attr *);
+extern void eoi_ioapic_irq(unsigned int irq, struct irq_cfg *cfg);
 
 int io_apic_setup_irq_pin_once(unsigned int irq, int node, struct io_apic_irq_attr *attr);
 
diff --git a/arch/x86/include/asm/irq_remapping.h b/arch/x86/include/asm/irq_remapping.h
index 6f4b48b..562db68 100644
--- a/arch/x86/include/asm/irq_remapping.h
+++ b/arch/x86/include/asm/irq_remapping.h
@@ -45,6 +45,13 @@ extern void compose_remapped_msi_msg(struct pci_dev *pdev,
 extern int setup_hpet_msi_remapped(unsigned int irq, unsigned int id);
 extern void panic_if_irq_remap(const char *msg);
 
+static inline bool irq_remapped(struct irq_cfg *cfg)
+{
+	return (cfg->remapped == 1);
+}
+
+void irq_remap_modify_chip_defaults(struct irq_chip *chip);
+
 #else  /* CONFIG_IRQ_REMAP */
 
 static inline void setup_irq_remapping_ops(void) { }
@@ -76,6 +83,16 @@ static inline int setup_hpet_msi_remapped(unsigned int irq, unsigned int id)
 static inline void panic_if_irq_remap(const char *msg)
 {
 }
+
+static inline bool irq_remapped(struct irq_cfg *cfg)
+{
+	return false;
+}
+
+static inline void irq_remap_modify_chip_defaults(struct irq_chip *chip)
+{
+}
+
 #endif /* CONFIG_IRQ_REMAP */
 
 #endif /* __X86_IRQ_REMAPPING_H */
diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
index d5cd6e1..6f2f21a 100644
--- a/arch/x86/kernel/apic/io_apic.c
+++ b/arch/x86/kernel/apic/io_apic.c
@@ -68,22 +68,6 @@
 #define for_each_irq_pin(entry, head) \
 	for (entry = head; entry; entry = entry->next)
 
-#ifdef CONFIG_IRQ_REMAP
-static void irq_remap_modify_chip_defaults(struct irq_chip *chip);
-static inline bool irq_remapped(struct irq_cfg *cfg)
-{
-	return cfg->irq_2_iommu.iommu != NULL;
-}
-#else
-static inline bool irq_remapped(struct irq_cfg *cfg)
-{
-	return false;
-}
-static inline void irq_remap_modify_chip_defaults(struct irq_chip *chip)
-{
-}
-#endif
-
 /*
  *      Is the SiS APIC rmw bug present ?
  *      -1 = don't know, 0 = no, 1 = yes
@@ -606,7 +590,7 @@ static void __eoi_ioapic_pin(int apic, int pin, int vector, struct irq_cfg *cfg)
 	}
 }
 
-static void eoi_ioapic_irq(unsigned int irq, struct irq_cfg *cfg)
+void eoi_ioapic_irq(unsigned int irq, struct irq_cfg *cfg)
 {
 	struct irq_pin_list *entry;
 	unsigned long flags;
@@ -2551,32 +2535,6 @@ static void ack_apic_level(struct irq_data *data)
 	ioapic_irqd_unmask(data, cfg, masked);
 }
 
-#ifdef CONFIG_IRQ_REMAP
-static void ir_ack_apic_edge(struct irq_data *data)
-{
-	ack_APIC_irq();
-}
-
-static void ir_ack_apic_level(struct irq_data *data)
-{
-	ack_APIC_irq();
-	eoi_ioapic_irq(data->irq, data->chip_data);
-}
-
-static void ir_print_prefix(struct irq_data *data, struct seq_file *p)
-{
-	seq_printf(p, " IR-%s", data->chip->name);
-}
-
-static void irq_remap_modify_chip_defaults(struct irq_chip *chip)
-{
-	chip->irq_print_chip = ir_print_prefix;
-	chip->irq_ack = ir_ack_apic_edge;
-	chip->irq_eoi = ir_ack_apic_level;
-	chip->irq_set_affinity = x86_io_apic_ops.set_affinity;
-}
-#endif /* CONFIG_IRQ_REMAP */
-
 static struct irq_chip ioapic_chip __read_mostly = {
 	.name			= "IO-APIC",
 	.irq_startup		= startup_ioapic_irq,
diff --git a/drivers/iommu/intel_irq_remapping.c b/drivers/iommu/intel_irq_remapping.c
index cb9a72d..7ca4947 100644
--- a/drivers/iommu/intel_irq_remapping.c
+++ b/drivers/iommu/intel_irq_remapping.c
@@ -68,6 +68,7 @@ static int alloc_irte(struct intel_iommu *iommu, int irq, u16 count)
 {
 	struct ir_table *table = iommu->ir_table;
 	struct irq_2_iommu *irq_iommu = irq_2_iommu(irq);
+	struct irq_cfg *cfg = irq_get_chip_data(irq);
 	u16 index, start_index;
 	unsigned int mask = 0;
 	unsigned long flags;
@@ -115,6 +116,7 @@ static int alloc_irte(struct intel_iommu *iommu, int irq, u16 count)
 	for (i = index; i < index + count; i++)
 		table->base[i].present = 1;
 
+	cfg->remapped = 1;
 	irq_iommu->iommu = iommu;
 	irq_iommu->irte_index =  index;
 	irq_iommu->sub_handle = 0;
@@ -155,6 +157,7 @@ static int map_irq_to_irte_handle(int irq, u16 *sub_handle)
 static int set_irte_irq(int irq, struct intel_iommu *iommu, u16 index, u16 subhandle)
 {
 	struct irq_2_iommu *irq_iommu = irq_2_iommu(irq);
+	struct irq_cfg *cfg = irq_get_chip_data(irq);
 	unsigned long flags;
 
 	if (!irq_iommu)
@@ -162,6 +165,7 @@ static int set_irte_irq(int irq, struct intel_iommu *iommu, u16 index, u16 subha
 
 	raw_spin_lock_irqsave(&irq_2_ir_lock, flags);
 
+	cfg->remapped = 1;
 	irq_iommu->iommu = iommu;
 	irq_iommu->irte_index = index;
 	irq_iommu->sub_handle = subhandle;
diff --git a/drivers/iommu/irq_remapping.c b/drivers/iommu/irq_remapping.c
index 827f8a1..f0ac30a 100644
--- a/drivers/iommu/irq_remapping.c
+++ b/drivers/iommu/irq_remapping.c
@@ -1,3 +1,4 @@
+#include <linux/seq_file.h>
 #include <linux/cpumask.h>
 #include <linux/kernel.h>
 #include <linux/string.h>
@@ -267,3 +268,27 @@ void panic_if_irq_remap(const char *msg)
 	if (irq_remapping_enabled)
 		panic(msg);
 }
+
+static void ir_ack_apic_edge(struct irq_data *data)
+{
+	ack_APIC_irq();
+}
+
+static void ir_ack_apic_level(struct irq_data *data)
+{
+	ack_APIC_irq();
+	eoi_ioapic_irq(data->irq, data->chip_data);
+}
+
+static void ir_print_prefix(struct irq_data *data, struct seq_file *p)
+{
+	seq_printf(p, " IR-%s", data->chip->name);
+}
+
+void irq_remap_modify_chip_defaults(struct irq_chip *chip)
+{
+	chip->irq_print_chip = ir_print_prefix;
+	chip->irq_ack = ir_ack_apic_edge;
+	chip->irq_eoi = ir_ack_apic_level;
+	chip->irq_set_affinity = x86_io_apic_ops.set_affinity;
+}
-- 
1.7.9.5


