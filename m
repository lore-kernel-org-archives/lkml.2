Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755498Ab2IZKto (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2012 06:49:44 -0400
Received: from [213.199.154.206] ([213.199.154.206]:41897 "EHLO
	am1outboundpool.messaging.microsoft.com" rhost-flags-FAIL-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1753354Ab2IZKq2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2012 06:46:28 -0400
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-SpamScore: 1
X-BigFish: VPS1(zzd6f1izz1202h1d1ah1d2ahzz8275bhz2dh668h839hd24he5bhf0ah11b5h121eh1288h12a5h12a9h12bdh12e5h137ah139eh13b6h1155h)
X-WSS-ID: 0MAYDV4-01-D55-02
X-M-MSG: 
From: Joerg Roedel <joerg.roedel@amd.com>
To: <x86@kernel.org>
CC: <linux-kernel@vger.kernel.org>, <joro@8bytes.org>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        Yinghai Lu <yinghai@kernel.org>,
        Sebastian Andrzej Siewior <sebastian@breakpoint.cc>,
        Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 08/19] x86, io_apic: Convert setup_ioapic_entry to function pointer
Date: Wed, 26 Sep 2012 12:44:40 +0200
Message-ID: <1348656291-10375-9-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1348656291-10375-1-git-send-email-joerg.roedel@amd.com>
References: <1348656291-10375-1-git-send-email-joerg.roedel@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This pointer is changed to a different function when IRQ
remapping is enabled.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/include/asm/io_apic.h  |    5 +++++
 arch/x86/include/asm/x86_init.h |    5 +++++
 arch/x86/kernel/apic/io_apic.c  |   14 +++++---------
 arch/x86/kernel/x86_init.c      |    1 +
 drivers/iommu/irq_remapping.c   |    1 +
 5 files changed, 17 insertions(+), 9 deletions(-)

diff --git a/arch/x86/include/asm/io_apic.h b/arch/x86/include/asm/io_apic.h
index a744cbb..71f5f08 100644
--- a/arch/x86/include/asm/io_apic.h
+++ b/arch/x86/include/asm/io_apic.h
@@ -149,6 +149,10 @@ extern int io_apic_set_pci_routing(struct device *dev, int irq,
 void setup_IO_APIC_irq_extra(u32 gsi);
 extern void ioapic_insert_resources(void);
 
+extern int native_setup_ioapic_entry(int, struct IO_APIC_route_entry *,
+				     unsigned int, int,
+				     struct io_apic_irq_attr *);
+
 int io_apic_setup_irq_pin_once(unsigned int irq, int node, struct io_apic_irq_attr *attr);
 
 extern int save_ioapic_entries(void);
@@ -232,6 +236,7 @@ static inline void disable_ioapic_support(void) { }
 #define native_disable_io_apic		NULL
 #define native_io_apic_print_entries	NULL
 #define native_ioapic_set_affinity	NULL
+#define native_setup_ioapic_entry	NULL
 #endif
 
 #endif /* _ASM_X86_IO_APIC_H */
diff --git a/arch/x86/include/asm/x86_init.h b/arch/x86/include/asm/x86_init.h
index f5f712b..bc13022 100644
--- a/arch/x86/include/asm/x86_init.h
+++ b/arch/x86/include/asm/x86_init.h
@@ -189,6 +189,8 @@ struct x86_msi_ops {
 	int  (*setup_hpet_msi)(unsigned int irq, unsigned int id);
 };
 
+struct IO_APIC_route_entry;
+struct io_apic_irq_attr;
 struct irq_data;
 struct cpumask;
 
@@ -202,6 +204,9 @@ struct x86_io_apic_ops {
 	int		(*set_affinity)(struct irq_data *data,
 					const struct cpumask *mask,
 					bool force);
+	int		(*setup_entry)(int irq, struct IO_APIC_route_entry *entry,
+				       unsigned int destination, int vector,
+				       struct io_apic_irq_attr *attr);
 };
 
 extern struct x86_init_ops x86_init;
diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
index 65c265ed..9500a07 100644
--- a/arch/x86/kernel/apic/io_apic.c
+++ b/arch/x86/kernel/apic/io_apic.c
@@ -1319,14 +1319,10 @@ static void ioapic_register_intr(unsigned int irq, struct irq_cfg *cfg,
 				      fasteoi ? "fasteoi" : "edge");
 }
 
-static int setup_ioapic_entry(int irq, struct IO_APIC_route_entry *entry,
-			       unsigned int destination, int vector,
-			       struct io_apic_irq_attr *attr)
+int native_setup_ioapic_entry(int irq, struct IO_APIC_route_entry *entry,
+			      unsigned int destination, int vector,
+			      struct io_apic_irq_attr *attr)
 {
-	if (irq_remapping_enabled)
-		return setup_ioapic_remapped_entry(irq, entry, destination,
-						   vector, attr);
-
 	memset(entry, 0, sizeof(*entry));
 
 	entry->delivery_mode = apic->irq_delivery_mode;
@@ -1384,8 +1380,8 @@ static void setup_ioapic_irq(unsigned int irq, struct irq_cfg *cfg,
 		    attr->ioapic, mpc_ioapic_id(attr->ioapic), attr->ioapic_pin,
 		    cfg->vector, irq, attr->trigger, attr->polarity, dest);
 
-	if (setup_ioapic_entry(irq, &entry, dest, cfg->vector, attr)) {
-		pr_warn("Failed to setup ioapic entry for ioapic %d, pin %d\n",
+	if (x86_io_apic_ops.setup_entry(irq, &entry, dest, cfg->vector, attr)) {
+		pr_warn("Failed to setup ioapic entry for ioapic  %d, pin %d\n",
 			mpc_ioapic_id(attr->ioapic), attr->ioapic_pin);
 		__clear_irq_vector(irq, cfg);
 
diff --git a/arch/x86/kernel/x86_init.c b/arch/x86/kernel/x86_init.c
index 8806d0b..3cd6bf7 100644
--- a/arch/x86/kernel/x86_init.c
+++ b/arch/x86/kernel/x86_init.c
@@ -129,4 +129,5 @@ struct x86_io_apic_ops x86_io_apic_ops = {
 	.disable		= native_disable_io_apic,
 	.print_entries		= native_io_apic_print_entries,
 	.set_affinity		= native_ioapic_set_affinity,
+	.setup_entry		= native_setup_ioapic_entry,
 };
diff --git a/drivers/iommu/irq_remapping.c b/drivers/iommu/irq_remapping.c
index ccf87e5..5b28e28 100644
--- a/drivers/iommu/irq_remapping.c
+++ b/drivers/iommu/irq_remapping.c
@@ -91,6 +91,7 @@ static void __init irq_remapping_modify_x86_ops(void)
 {
 	x86_io_apic_ops.disable		= irq_remapping_disable_io_apic;
 	x86_io_apic_ops.set_affinity	= set_remapped_irq_affinity;
+	x86_io_apic_ops.setup_entry	= setup_ioapic_remapped_entry;
 	x86_msi.setup_msi_irqs		= irq_remapping_setup_msi_irqs;
 	x86_msi.setup_hpet_msi		= setup_hpet_msi_remapped;
 }
-- 
1.7.9.5


