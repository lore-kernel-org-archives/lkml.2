Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754837Ab2IZKqi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2012 06:46:38 -0400
Received: from [216.32.181.183] ([216.32.181.183]:6096 "EHLO
	ch1outboundpool.messaging.microsoft.com" rhost-flags-FAIL-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1753112Ab2IZKqf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2012 06:46:35 -0400
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-SpamScore: 0
X-BigFish: VPS0(zzzz1202h1d1ah1d2ahzz8275bhz2dh668h839hd24he5bhf0ah11b5h121eh1288h12a5h12a9h12bdh12e5h137ah139eh13b6h1155h)
X-WSS-ID: 0MAYDVD-02-54T-02
X-M-MSG: 
From: Joerg Roedel <joerg.roedel@amd.com>
To: <x86@kernel.org>
CC: <linux-kernel@vger.kernel.org>, <joro@8bytes.org>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        Yinghai Lu <yinghai@kernel.org>,
        Sebastian Andrzej Siewior <sebastian@breakpoint.cc>,
        Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 16/19] x86, irq: Introduce setup_remapped_irq()
Date: Wed, 26 Sep 2012 12:44:48 +0200
Message-ID: <1348656291-10375-17-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1348656291-10375-1-git-send-email-joerg.roedel@amd.com>
References: <1348656291-10375-1-git-send-email-joerg.roedel@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This function does irq-remapping specific interrupt setup
like modifying the chip defaults.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/include/asm/irq_remapping.h |    9 +++++++++
 arch/x86/kernel/apic/io_apic.c       |   13 +++----------
 drivers/iommu/irq_remapping.c        |    9 +++++++++
 3 files changed, 21 insertions(+), 10 deletions(-)

diff --git a/arch/x86/include/asm/irq_remapping.h b/arch/x86/include/asm/irq_remapping.h
index 562db68..b30fca1 100644
--- a/arch/x86/include/asm/irq_remapping.h
+++ b/arch/x86/include/asm/irq_remapping.h
@@ -44,6 +44,9 @@ extern void compose_remapped_msi_msg(struct pci_dev *pdev,
 				     struct msi_msg *msg, u8 hpet_id);
 extern int setup_hpet_msi_remapped(unsigned int irq, unsigned int id);
 extern void panic_if_irq_remap(const char *msg);
+extern bool setup_remapped_irq(int irq,
+			       struct irq_cfg *cfg,
+			       struct irq_chip *chip);
 
 static inline bool irq_remapped(struct irq_cfg *cfg)
 {
@@ -93,6 +96,12 @@ static inline void irq_remap_modify_chip_defaults(struct irq_chip *chip)
 {
 }
 
+static inline bool setup_remapped_irq(int irq,
+				      struct irq_cfg *cfg,
+				      struct irq_chip *chip)
+{
+	return false;
+}
 #endif /* CONFIG_IRQ_REMAP */
 
 #endif /* __X86_IRQ_REMAPPING_H */
diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
index 87a0fd1..88c4fff 100644
--- a/arch/x86/kernel/apic/io_apic.c
+++ b/arch/x86/kernel/apic/io_apic.c
@@ -1292,11 +1292,8 @@ static void ioapic_register_intr(unsigned int irq, struct irq_cfg *cfg,
 		fasteoi = false;
 	}
 
-	if (irq_remapped(cfg)) {
-		irq_set_status_flags(irq, IRQ_MOVE_PCNTXT);
-		irq_remap_modify_chip_defaults(chip);
+	if (setup_remapped_irq(irq, cfg, chip))
 		fasteoi = trigger != 0;
-	}
 
 	hdl = fasteoi ? handle_fasteoi_irq : handle_edge_irq;
 	irq_set_chip_and_handler_name(irq, chip, hdl,
@@ -3103,10 +3100,7 @@ int setup_msi_irq(struct pci_dev *dev, struct msi_desc *msidesc, int irq)
 	irq_set_msi_desc(irq, msidesc);
 	write_msi_msg(irq, &msg);
 
-	if (irq_remapped(irq_get_chip_data(irq))) {
-		irq_set_status_flags(irq, IRQ_MOVE_PCNTXT);
-		irq_remap_modify_chip_defaults(chip);
-	}
+	setup_remapped_irq(irq, irq_get_chip_data(irq), chip);
 
 	irq_set_chip_and_handler_name(irq, chip, handle_edge_irq, "edge");
 
@@ -3244,8 +3238,7 @@ int default_setup_hpet_msi(unsigned int irq, unsigned int id)
 
 	hpet_msi_write(irq_get_handler_data(irq), &msg);
 	irq_set_status_flags(irq, IRQ_MOVE_PCNTXT);
-	if (irq_remapped(irq_get_chip_data(irq)))
-		irq_remap_modify_chip_defaults(chip);
+	setup_remapped_irq(irq, irq_get_chip_data(irq), chip);
 
 	irq_set_chip_and_handler_name(irq, chip, handle_edge_irq, "edge");
 	return 0;
diff --git a/drivers/iommu/irq_remapping.c b/drivers/iommu/irq_remapping.c
index 165ac14..1e6bc13 100644
--- a/drivers/iommu/irq_remapping.c
+++ b/drivers/iommu/irq_remapping.c
@@ -295,3 +295,12 @@ void irq_remap_modify_chip_defaults(struct irq_chip *chip)
 	chip->irq_eoi = ir_ack_apic_level;
 	chip->irq_set_affinity = x86_io_apic_ops.set_affinity;
 }
+
+bool setup_remapped_irq(int irq, struct irq_cfg *cfg, struct irq_chip *chip)
+{
+	if (!irq_remapped(cfg))
+		return false;
+	irq_set_status_flags(irq, IRQ_MOVE_PCNTXT);
+	irq_remap_modify_chip_defaults(chip);
+	return true;
+}
-- 
1.7.9.5


