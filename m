Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755747Ab2IZKtr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2012 06:49:47 -0400
Received: from [216.32.181.185] ([216.32.181.185]:28982 "EHLO
	ch1outboundpool.messaging.microsoft.com" rhost-flags-FAIL-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1753328Ab2IZKq2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2012 06:46:28 -0400
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-SpamScore: 1
X-BigFish: VPS1(zzd6f1izz1202h1d1ah1d2ahzz8275bhz2dh668h839hd24he5bhf0ah11b5h121eh1288h12a5h12a9h12bdh12e5h137ah139eh13b6h1155h)
X-WSS-ID: 0MAYDVC-02-54O-02
X-M-MSG: 
From: Joerg Roedel <joerg.roedel@amd.com>
To: <x86@kernel.org>
CC: <linux-kernel@vger.kernel.org>, <joro@8bytes.org>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        Yinghai Lu <yinghai@kernel.org>,
        Sebastian Andrzej Siewior <sebastian@breakpoint.cc>,
        Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 17/19] x86, msi: Introduce x86_msi.compose_msi_msg call-back
Date: Wed, 26 Sep 2012 12:44:49 +0200
Message-ID: <1348656291-10375-18-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1348656291-10375-1-git-send-email-joerg.roedel@amd.com>
References: <1348656291-10375-1-git-send-email-joerg.roedel@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This call-back points to the right function for initializing
the msi_msg structure. The old code for msi_msg generation
was split up into the irq-remapped and the default case.

The irq-remapped case just calls into the specific Intel or
AMD implementation when the device is behind an IOMMU.
Otherwise the default function is called.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/include/asm/io_apic.h  |    4 +++
 arch/x86/include/asm/x86_init.h |    4 +++
 arch/x86/kernel/apic/io_apic.c  |   59 ++++++++++++++++++++-------------------
 arch/x86/kernel/x86_init.c      |    1 +
 drivers/iommu/irq_remapping.c   |    9 ++++--
 5 files changed, 46 insertions(+), 31 deletions(-)

diff --git a/arch/x86/include/asm/io_apic.h b/arch/x86/include/asm/io_apic.h
index 36fb5ab..1838e88 100644
--- a/arch/x86/include/asm/io_apic.h
+++ b/arch/x86/include/asm/io_apic.h
@@ -158,6 +158,9 @@ extern int native_setup_ioapic_entry(int, struct IO_APIC_route_entry *,
 				     struct io_apic_irq_attr *);
 extern void eoi_ioapic_irq(unsigned int irq, struct irq_cfg *cfg);
 
+extern void native_compose_msi_msg(struct pci_dev *pdev,
+				   unsigned int irq, unsigned int dest,
+				   struct msi_msg *msg, u8 hpet_id);
 int io_apic_setup_irq_pin_once(unsigned int irq, int node, struct io_apic_irq_attr *attr);
 
 extern int save_ioapic_entries(void);
@@ -242,6 +245,7 @@ static inline void disable_ioapic_support(void) { }
 #define native_io_apic_print_entries	NULL
 #define native_ioapic_set_affinity	NULL
 #define native_setup_ioapic_entry	NULL
+#define native_compose_msi_msg		NULL
 #endif
 
 #endif /* _ASM_X86_IO_APIC_H */
diff --git a/arch/x86/include/asm/x86_init.h b/arch/x86/include/asm/x86_init.h
index bc13022..3ef598e 100644
--- a/arch/x86/include/asm/x86_init.h
+++ b/arch/x86/include/asm/x86_init.h
@@ -180,9 +180,13 @@ struct x86_platform_ops {
 };
 
 struct pci_dev;
+struct msi_msg;
 
 struct x86_msi_ops {
 	int (*setup_msi_irqs)(struct pci_dev *dev, int nvec, int type);
+	void (*compose_msi_msg)(struct pci_dev *dev, unsigned int irq,
+				unsigned int dest, struct msi_msg *msg,
+			       u8 hpet_id);
 	void (*teardown_msi_irq)(unsigned int irq);
 	void (*teardown_msi_irqs)(struct pci_dev *dev);
 	void (*restore_msi_irqs)(struct pci_dev *dev, int irq);
diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
index 88c4fff..c545a1d 100644
--- a/arch/x86/kernel/apic/io_apic.c
+++ b/arch/x86/kernel/apic/io_apic.c
@@ -2999,37 +2999,16 @@ void destroy_irq(unsigned int irq)
 /*
  * MSI message composition
  */
-#ifdef CONFIG_PCI_MSI
-static int msi_compose_msg(struct pci_dev *pdev, unsigned int irq,
-			   struct msi_msg *msg, u8 hpet_id)
+void native_compose_msi_msg(struct pci_dev *pdev,
+			    unsigned int irq, unsigned int dest,
+			    struct msi_msg *msg, u8 hpet_id)
 {
-	struct irq_cfg *cfg;
-	int err;
-	unsigned dest;
-
-	if (disable_apic)
-		return -ENXIO;
-
-	cfg = irq_cfg(irq);
-	err = assign_irq_vector(irq, cfg, apic->target_cpus());
-	if (err)
-		return err;
-
-	err = apic->cpu_mask_to_apicid_and(cfg->domain,
-					   apic->target_cpus(), &dest);
-	if (err)
-		return err;
+	struct irq_cfg *cfg = irq_cfg(irq);
 
-	if (irq_remapped(cfg)) {
-		compose_remapped_msi_msg(pdev, irq, dest, msg, hpet_id);
-		return err;
-	}
+	msg->address_hi = MSI_ADDR_BASE_HI;
 
 	if (x2apic_enabled())
-		msg->address_hi = MSI_ADDR_BASE_HI |
-				  MSI_ADDR_EXT_DEST_ID(dest);
-	else
-		msg->address_hi = MSI_ADDR_BASE_HI;
+		msg->address_hi |= MSI_ADDR_EXT_DEST_ID(dest);
 
 	msg->address_lo =
 		MSI_ADDR_BASE_LO |
@@ -3048,8 +3027,32 @@ static int msi_compose_msg(struct pci_dev *pdev, unsigned int irq,
 			MSI_DATA_DELIVERY_FIXED:
 			MSI_DATA_DELIVERY_LOWPRI) |
 		MSI_DATA_VECTOR(cfg->vector);
+}
 
-	return err;
+#ifdef CONFIG_PCI_MSI
+static int msi_compose_msg(struct pci_dev *pdev, unsigned int irq,
+			   struct msi_msg *msg, u8 hpet_id)
+{
+	struct irq_cfg *cfg;
+	int err;
+	unsigned dest;
+
+	if (disable_apic)
+		return -ENXIO;
+
+	cfg = irq_cfg(irq);
+	err = assign_irq_vector(irq, cfg, apic->target_cpus());
+	if (err)
+		return err;
+
+	err = apic->cpu_mask_to_apicid_and(cfg->domain,
+					   apic->target_cpus(), &dest);
+	if (err)
+		return err;
+
+	x86_msi.compose_msi_msg(pdev, irq, dest, msg, hpet_id);
+
+	return 0;
 }
 
 static int
diff --git a/arch/x86/kernel/x86_init.c b/arch/x86/kernel/x86_init.c
index 3cd6bf7..357d127 100644
--- a/arch/x86/kernel/x86_init.c
+++ b/arch/x86/kernel/x86_init.c
@@ -115,6 +115,7 @@ struct x86_platform_ops x86_platform = {
 EXPORT_SYMBOL_GPL(x86_platform);
 struct x86_msi_ops x86_msi = {
 	.setup_msi_irqs		= native_setup_msi_irqs,
+	.compose_msi_msg	= native_compose_msi_msg,
 	.teardown_msi_irq	= native_teardown_msi_irq,
 	.teardown_msi_irqs	= default_teardown_msi_irqs,
 	.restore_msi_irqs	= default_restore_msi_irqs,
diff --git a/drivers/iommu/irq_remapping.c b/drivers/iommu/irq_remapping.c
index 1e6bc13..92351f8 100644
--- a/drivers/iommu/irq_remapping.c
+++ b/drivers/iommu/irq_remapping.c
@@ -95,6 +95,7 @@ static void __init irq_remapping_modify_x86_ops(void)
 	x86_io_apic_ops.setup_entry	= setup_ioapic_remapped_entry;
 	x86_msi.setup_msi_irqs		= irq_remapping_setup_msi_irqs;
 	x86_msi.setup_hpet_msi		= setup_hpet_msi_remapped;
+	x86_msi.compose_msi_msg		= compose_remapped_msi_msg;
 }
 
 static __init int setup_nointremap(char *str)
@@ -235,10 +236,12 @@ void compose_remapped_msi_msg(struct pci_dev *pdev,
 			      unsigned int irq, unsigned int dest,
 			      struct msi_msg *msg, u8 hpet_id)
 {
-	if (!remap_ops || !remap_ops->compose_msi_msg)
-		return;
+	struct irq_cfg *cfg = irq_get_chip_data(irq);
 
-	remap_ops->compose_msi_msg(pdev, irq, dest, msg, hpet_id);
+	if (!irq_remapped(cfg))
+		native_compose_msi_msg(pdev, irq, dest, msg, hpet_id);
+	else if (remap_ops && remap_ops->compose_msi_msg)
+		remap_ops->compose_msi_msg(pdev, irq, dest, msg, hpet_id);
 }
 
 static int msi_alloc_remapped_irq(struct pci_dev *pdev, int irq, int nvec)
-- 
1.7.9.5


