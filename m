Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756345Ab2HTN5Z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2012 09:57:25 -0400
Received: from co1ehsobe006.messaging.microsoft.com ([216.32.180.189]:40658
	"EHLO co1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751820Ab2HTN41 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2012 09:56:27 -0400
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-SpamScore: 0
X-BigFish: VPS0(zzzz1202hzz8275bhz2dh668h839hd24he5bhf0ah11b5h)
X-WSS-ID: 0M9241Q-02-F16-02
X-M-MSG: 
From: Joerg Roedel <joerg.roedel@amd.com>
To: <x86@kernel.org>
CC: <linux-kernel@vger.kernel.org>, <joro@8bytes.org>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        Yinghai Lu <yinghai@kernel.org>, Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 16/19] x86, irq: Introduce setup_remapped_irq()
Date: Mon, 20 Aug 2012 15:56:02 +0200
Message-ID: <1345470965-24410-17-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1345470965-24410-1-git-send-email-joerg.roedel@amd.com>
References: <1345470965-24410-1-git-send-email-joerg.roedel@amd.com>
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
 drivers/iommu/irq_remapping.c        |   11 +++++++++++
 3 files changed, 23 insertions(+), 10 deletions(-)

diff --git a/arch/x86/include/asm/irq_remapping.h b/arch/x86/include/asm/irq_remapping.h
index 1888148..b670580 100644
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
index 6022e4c..c2f2d2d 100644
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
@@ -3093,10 +3090,7 @@ int setup_msi_irq(struct pci_dev *dev, struct msi_desc *msidesc, int irq)
 	irq_set_msi_desc(irq, msidesc);
 	write_msi_msg(irq, &msg);
 
-	if (irq_remapped(irq_get_chip_data(irq))) {
-		irq_set_status_flags(irq, IRQ_MOVE_PCNTXT);
-		irq_remap_modify_chip_defaults(chip);
-	}
+	setup_remapped_irq(irq, irq_get_chip_data(irq), chip);
 
 	irq_set_chip_and_handler_name(irq, chip, handle_edge_irq, "edge");
 
@@ -3234,8 +3228,7 @@ int default_setup_hpet_msi(unsigned int irq, unsigned int id)
 
 	hpet_msi_write(irq_get_handler_data(irq), &msg);
 	irq_set_status_flags(irq, IRQ_MOVE_PCNTXT);
-	if (irq_remapped(irq_get_chip_data(irq)))
-		irq_remap_modify_chip_defaults(chip);
+	setup_remapped_irq(irq, irq_get_chip_data(irq), chip);
 
 	irq_set_chip_and_handler_name(irq, chip, handle_edge_irq, "edge");
 	return 0;
diff --git a/drivers/iommu/irq_remapping.c b/drivers/iommu/irq_remapping.c
index f2affc7..d9cd920f 100644
--- a/drivers/iommu/irq_remapping.c
+++ b/drivers/iommu/irq_remapping.c
@@ -302,3 +302,14 @@ void irq_remap_modify_chip_defaults(struct irq_chip *chip)
 	chip->irq_eoi = ir_ack_apic_level;
 	chip->irq_set_affinity = x86_io_apic_ops.set_affinity;
 }
+
+bool setup_remapped_irq(int irq, struct irq_cfg *cfg, struct irq_chip *chip)
+{
+	if (irq_remapped(cfg)) {
+		irq_set_status_flags(irq, IRQ_MOVE_PCNTXT);
+		irq_remap_modify_chip_defaults(chip);
+		return true;
+	} else {
+		return false;
+	}
+}
-- 
1.7.9.5


