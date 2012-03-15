Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1032123Ab2CORlo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2012 13:41:44 -0400
Received: from tx2ehsobe002.messaging.microsoft.com ([65.55.88.12]:1646 "EHLO
	tx2outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1032049Ab2CORkH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2012 13:40:07 -0400
X-SpamScore: 0
X-BigFish: VPS0(zzzz1202hzz8275bhz2dh668h839hd24h)
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0M0XT2P-01-142-02
X-M-MSG: 
From: Joerg Roedel <joerg.roedel@amd.com>
To: <iommu@lists.linux-foundation.org>
CC: <linux-kernel@vger.kernel.org>, David Woodhouse <dwmw2@infradead.org>,
        Alex Williamson <alex.williamson@redhat.com>,
        Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        Yinghai Lu <yinghai@kernel.org>, Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 9/9] x86, iommu/vt-d: Clean up interfaces for interrupt remapping
Date: Thu, 15 Mar 2012 18:39:51 +0100
Message-ID: <1331833191-25779-10-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1331833191-25779-1-git-send-email-joerg.roedel@amd.com>
References: <1331833191-25779-1-git-send-email-joerg.roedel@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove the Intel specific interfaces from dmar.h and remove
asm/irq_remapping.h which is only used for io_apic.c anyway.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/include/asm/irq_remapping.h |   22 ------------
 arch/x86/kernel/apic/io_apic.c       |   17 +++++++++-
 drivers/iommu/intel_intr_remapping.c |   20 ++++++------
 include/linux/dmar.h                 |   59 ----------------------------------
 4 files changed, 26 insertions(+), 92 deletions(-)
 delete mode 100644 arch/x86/include/asm/irq_remapping.h

diff --git a/arch/x86/include/asm/irq_remapping.h b/arch/x86/include/asm/irq_remapping.h
deleted file mode 100644
index 0ddfc0b..0000000
--- a/arch/x86/include/asm/irq_remapping.h
+++ /dev/null
@@ -1,22 +0,0 @@
-#ifndef _ASM_X86_IRQ_REMAPPING_H
-#define _ASM_X86_IRQ_REMAPPING_H
-
-#define IRTE_DEST(dest) ((x2apic_mode) ? dest : dest << 8)
-
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
-#endif	/* _ASM_X86_IRQ_REMAPPING_H */
diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
index a6af128..c65d425 100644
--- a/arch/x86/kernel/apic/io_apic.c
+++ b/arch/x86/kernel/apic/io_apic.c
@@ -58,7 +58,6 @@
 #include <asm/hypertransport.h>
 #include <asm/setup.h>
 #include <asm/intr_remapping.h>
-#include <asm/irq_remapping.h>
 #include <asm/hpet.h>
 #include <asm/hw_irq.h>
 
@@ -68,6 +67,22 @@
 #define for_each_irq_pin(entry, head) \
 	for (entry = head; entry; entry = entry->next)
 
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
diff --git a/drivers/iommu/intel_intr_remapping.c b/drivers/iommu/intel_intr_remapping.c
index a3bae67..7472634 100644
--- a/drivers/iommu/intel_intr_remapping.c
+++ b/drivers/iommu/intel_intr_remapping.c
@@ -64,7 +64,7 @@ int get_irte(int irq, struct irte *entry)
 	return 0;
 }
 
-int alloc_irte(struct intel_iommu *iommu, int irq, u16 count)
+static int alloc_irte(struct intel_iommu *iommu, int irq, u16 count)
 {
 	struct ir_table *table = iommu->ir_table;
 	struct irq_2_iommu *irq_iommu = irq_2_iommu(irq);
@@ -136,7 +136,7 @@ static int qi_flush_iec(struct intel_iommu *iommu, int index, int mask)
 	return qi_submit_sync(&desc, iommu);
 }
 
-int map_irq_to_irte_handle(int irq, u16 *sub_handle)
+static int map_irq_to_irte_handle(int irq, u16 *sub_handle)
 {
 	struct irq_2_iommu *irq_iommu = irq_2_iommu(irq);
 	unsigned long flags;
@@ -152,7 +152,7 @@ int map_irq_to_irte_handle(int irq, u16 *sub_handle)
 	return index;
 }
 
-int set_irte_irq(int irq, struct intel_iommu *iommu, u16 index, u16 subhandle)
+static int set_irte_irq(int irq, struct intel_iommu *iommu, u16 index, u16 subhandle)
 {
 	struct irq_2_iommu *irq_iommu = irq_2_iommu(irq);
 	unsigned long flags;
@@ -172,7 +172,7 @@ int set_irte_irq(int irq, struct intel_iommu *iommu, u16 index, u16 subhandle)
 	return 0;
 }
 
-int modify_irte(int irq, struct irte *irte_modified)
+static int modify_irte(int irq, struct irte *irte_modified)
 {
 	struct irq_2_iommu *irq_iommu = irq_2_iommu(irq);
 	struct intel_iommu *iommu;
@@ -200,7 +200,7 @@ int modify_irte(int irq, struct irte *irte_modified)
 	return rc;
 }
 
-struct intel_iommu *map_hpet_to_ir(u8 hpet_id)
+static struct intel_iommu *map_hpet_to_ir(u8 hpet_id)
 {
 	int i;
 
@@ -210,7 +210,7 @@ struct intel_iommu *map_hpet_to_ir(u8 hpet_id)
 	return NULL;
 }
 
-struct intel_iommu *map_ioapic_to_ir(int apic)
+static struct intel_iommu *map_ioapic_to_ir(int apic)
 {
 	int i;
 
@@ -220,7 +220,7 @@ struct intel_iommu *map_ioapic_to_ir(int apic)
 	return NULL;
 }
 
-struct intel_iommu *map_dev_to_ir(struct pci_dev *dev)
+static struct intel_iommu *map_dev_to_ir(struct pci_dev *dev)
 {
 	struct dmar_drhd_unit *drhd;
 
@@ -312,7 +312,7 @@ static void set_irte_sid(struct irte *irte, unsigned int svt,
 	irte->sid = sid;
 }
 
-int set_ioapic_sid(struct irte *irte, int apic)
+static int set_ioapic_sid(struct irte *irte, int apic)
 {
 	int i;
 	u16 sid = 0;
@@ -337,7 +337,7 @@ int set_ioapic_sid(struct irte *irte, int apic)
 	return 0;
 }
 
-int set_hpet_sid(struct irte *irte, u8 id)
+static int set_hpet_sid(struct irte *irte, u8 id)
 {
 	int i;
 	u16 sid = 0;
@@ -367,7 +367,7 @@ int set_hpet_sid(struct irte *irte, u8 id)
 	return 0;
 }
 
-int set_msi_sid(struct irte *irte, struct pci_dev *dev)
+static int set_msi_sid(struct irte *irte, struct pci_dev *dev)
 {
 	struct pci_dev *bridge;
 
diff --git a/include/linux/dmar.h b/include/linux/dmar.h
index 7a207a3..b029d1a 100644
--- a/include/linux/dmar.h
+++ b/include/linux/dmar.h
@@ -114,65 +114,6 @@ struct irte {
 	};
 };
 
-#ifdef CONFIG_IRQ_REMAP
-extern int get_irte(int irq, struct irte *entry);
-extern int modify_irte(int irq, struct irte *irte_modified);
-extern int alloc_irte(struct intel_iommu *iommu, int irq, u16 count);
-extern int set_irte_irq(int irq, struct intel_iommu *iommu, u16 index,
-   			u16 sub_handle);
-extern int map_irq_to_irte_handle(int irq, u16 *sub_handle);
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
-#endif
-
 enum {
 	IRQ_REMAP_XAPIC_MODE,
 	IRQ_REMAP_X2APIC_MODE,
-- 
1.7.5.4


