Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754492Ab2IZKtw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2012 06:49:52 -0400
Received: from [216.32.181.182] ([216.32.181.182]:13727 "EHLO
	ch1outboundpool.messaging.microsoft.com" rhost-flags-FAIL-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1753242Ab2IZKq2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2012 06:46:28 -0400
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-SpamScore: 1
X-BigFish: VPS1(zzd6f1izz1202h1d1ah1d2ahzz8275bhz2dh668h839hd24he5bhf0ah11b5h121eh1288h12a5h12a9h12bdh12e5h137ah139eh13b6h1155h)
X-WSS-ID: 0MAYDV5-01-D5A-02
X-M-MSG: 
From: Joerg Roedel <joerg.roedel@amd.com>
To: <x86@kernel.org>
CC: <linux-kernel@vger.kernel.org>, <joro@8bytes.org>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        Yinghai Lu <yinghai@kernel.org>,
        Sebastian Andrzej Siewior <sebastian@breakpoint.cc>,
        Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 07/19] x86, io_apic: Introduce set_affinity function pointer
Date: Wed, 26 Sep 2012 12:44:39 +0200
Message-ID: <1348656291-10375-8-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1348656291-10375-1-git-send-email-joerg.roedel@amd.com>
References: <1348656291-10375-1-git-send-email-joerg.roedel@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With interrupt remapping a special function is used to
change the affinity of an IO-APIC interrupt. Abstract this
with a function pointer.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/include/asm/io_apic.h       |    4 ++++
 arch/x86/include/asm/irq_remapping.h |    9 ---------
 arch/x86/include/asm/x86_init.h      |    6 ++++++
 arch/x86/kernel/apic/io_apic.c       |   17 +++++++----------
 arch/x86/kernel/x86_init.c           |    1 +
 drivers/iommu/irq_remapping.c        |    4 ++++
 6 files changed, 22 insertions(+), 19 deletions(-)

diff --git a/arch/x86/include/asm/io_apic.h b/arch/x86/include/asm/io_apic.h
index 21aa81e..a744cbb 100644
--- a/arch/x86/include/asm/io_apic.h
+++ b/arch/x86/include/asm/io_apic.h
@@ -182,6 +182,9 @@ extern void native_io_apic_modify(unsigned int apic, unsigned int reg, unsigned
 extern void native_disable_io_apic(void);
 extern void native_io_apic_print_entries(unsigned int apic, unsigned int nr_entries);
 extern void intel_ir_io_apic_print_entries(unsigned int apic, unsigned int nr_entries);
+extern int native_ioapic_set_affinity(struct irq_data *,
+				      const struct cpumask *,
+				      bool);
 
 static inline unsigned int io_apic_read(unsigned int apic, unsigned int reg)
 {
@@ -228,6 +231,7 @@ static inline void disable_ioapic_support(void) { }
 #define native_io_apic_modify		NULL
 #define native_disable_io_apic		NULL
 #define native_io_apic_print_entries	NULL
+#define native_ioapic_set_affinity	NULL
 #endif
 
 #endif /* _ASM_X86_IO_APIC_H */
diff --git a/arch/x86/include/asm/irq_remapping.h b/arch/x86/include/asm/irq_remapping.h
index 0ee1e88..f1afa04 100644
--- a/arch/x86/include/asm/irq_remapping.h
+++ b/arch/x86/include/asm/irq_remapping.h
@@ -40,9 +40,6 @@ extern int setup_ioapic_remapped_entry(int irq,
 				       unsigned int destination,
 				       int vector,
 				       struct io_apic_irq_attr *attr);
-extern int set_remapped_irq_affinity(struct irq_data *data,
-				     const struct cpumask *mask,
-				     bool force);
 extern void free_remapped_irq(int irq);
 extern void compose_remapped_msi_msg(struct pci_dev *pdev,
 				     unsigned int irq, unsigned int dest,
@@ -68,12 +65,6 @@ static inline int setup_ioapic_remapped_entry(int irq,
 {
 	return -ENODEV;
 }
-static inline int set_remapped_irq_affinity(struct irq_data *data,
-					    const struct cpumask *mask,
-					    bool force)
-{
-	return 0;
-}
 static inline void free_remapped_irq(int irq) { }
 static inline void compose_remapped_msi_msg(struct pci_dev *pdev,
 					    unsigned int irq, unsigned int dest,
diff --git a/arch/x86/include/asm/x86_init.h b/arch/x86/include/asm/x86_init.h
index 1f49c8a..f5f712b 100644
--- a/arch/x86/include/asm/x86_init.h
+++ b/arch/x86/include/asm/x86_init.h
@@ -189,6 +189,9 @@ struct x86_msi_ops {
 	int  (*setup_hpet_msi)(unsigned int irq, unsigned int id);
 };
 
+struct irq_data;
+struct cpumask;
+
 struct x86_io_apic_ops {
 	void		(*init)   (void);
 	unsigned int	(*read)   (unsigned int apic, unsigned int reg);
@@ -196,6 +199,9 @@ struct x86_io_apic_ops {
 	void		(*modify) (unsigned int apic, unsigned int reg, unsigned int value);
 	void		(*disable)(void);
 	void		(*print_entries)(unsigned int apic, unsigned int nr_entries);
+	int		(*set_affinity)(struct irq_data *data,
+					const struct cpumask *mask,
+					bool force);
 };
 
 extern struct x86_init_ops x86_init;
diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
index 5ae0292..65c265ed 100644
--- a/arch/x86/kernel/apic/io_apic.c
+++ b/arch/x86/kernel/apic/io_apic.c
@@ -2378,9 +2378,10 @@ int __ioapic_set_affinity(struct irq_data *data, const struct cpumask *mask,
 	return 0;
 }
 
-static int
-ioapic_set_affinity(struct irq_data *data, const struct cpumask *mask,
-		    bool force)
+
+int native_ioapic_set_affinity(struct irq_data *data,
+			       const struct cpumask *mask,
+			       bool force)
 {
 	unsigned int dest, irq = data->irq;
 	unsigned long flags;
@@ -2579,8 +2580,7 @@ static void irq_remap_modify_chip_defaults(struct irq_chip *chip)
 	chip->irq_print_chip = ir_print_prefix;
 	chip->irq_ack = ir_ack_apic_edge;
 	chip->irq_eoi = ir_ack_apic_level;
-
-	chip->irq_set_affinity = set_remapped_irq_affinity;
+	chip->irq_set_affinity = x86_io_apic_ops.set_affinity;
 }
 #endif /* CONFIG_IRQ_REMAP */
 
@@ -2591,7 +2591,7 @@ static struct irq_chip ioapic_chip __read_mostly = {
 	.irq_unmask		= unmask_ioapic_irq,
 	.irq_ack		= ack_apic_edge,
 	.irq_eoi		= ack_apic_level,
-	.irq_set_affinity	= ioapic_set_affinity,
+	.irq_set_affinity	= native_ioapic_set_affinity,
 	.irq_retrigger		= ioapic_retrigger_irq,
 };
 
@@ -3666,10 +3666,7 @@ void __init setup_ioapic_dest(void)
 		else
 			mask = apic->target_cpus();
 
-		if (irq_remapping_enabled)
-			set_remapped_irq_affinity(idata, mask, false);
-		else
-			ioapic_set_affinity(idata, mask, false);
+		x86_io_apic_ops.set_affinity(idata, mask, false);
 	}
 
 }
diff --git a/arch/x86/kernel/x86_init.c b/arch/x86/kernel/x86_init.c
index 339e108..8806d0b 100644
--- a/arch/x86/kernel/x86_init.c
+++ b/arch/x86/kernel/x86_init.c
@@ -128,4 +128,5 @@ struct x86_io_apic_ops x86_io_apic_ops = {
 	.modify			= native_io_apic_modify,
 	.disable		= native_disable_io_apic,
 	.print_entries		= native_io_apic_print_entries,
+	.set_affinity		= native_ioapic_set_affinity,
 };
diff --git a/drivers/iommu/irq_remapping.c b/drivers/iommu/irq_remapping.c
index 984104b..ccf87e5 100644
--- a/drivers/iommu/irq_remapping.c
+++ b/drivers/iommu/irq_remapping.c
@@ -26,6 +26,9 @@ static struct irq_remap_ops *remap_ops;
 static int msi_alloc_remapped_irq(struct pci_dev *pdev, int irq, int nvec);
 static int msi_setup_remapped_irq(struct pci_dev *pdev, unsigned int irq,
 				  int index, int sub_handle);
+static int set_remapped_irq_affinity(struct irq_data *data,
+				     const struct cpumask *mask,
+				     bool force);
 
 static void irq_remapping_disable_io_apic(void)
 {
@@ -87,6 +90,7 @@ error:
 static void __init irq_remapping_modify_x86_ops(void)
 {
 	x86_io_apic_ops.disable		= irq_remapping_disable_io_apic;
+	x86_io_apic_ops.set_affinity	= set_remapped_irq_affinity;
 	x86_msi.setup_msi_irqs		= irq_remapping_setup_msi_irqs;
 	x86_msi.setup_hpet_msi		= setup_hpet_msi_remapped;
 }
-- 
1.7.9.5


