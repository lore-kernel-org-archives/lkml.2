Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753655Ab2KTNNW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2012 08:13:22 -0500
Received: from 8bytes.org ([85.214.48.195]:58502 "EHLO mail.8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753375Ab2KTNNU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2012 08:13:20 -0500
From: Joerg Roedel <joro@8bytes.org>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>
Cc: x86@kernel.org, iommu@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        Yinghai Lu <yinghai@kernel.org>,
        Sebastian Andrzej Siewior <sebastian@breakpoint.cc>,
        Joerg Roedel <joro@8bytes.org>
Subject: [PATCH 16/19] x86, irq: Introduce setup_remapped_irq()
Date: Tue, 20 Nov 2012 14:12:53 +0100
Message-Id: <1353417176-18945-17-git-send-email-joro@8bytes.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1353417176-18945-1-git-send-email-joro@8bytes.org>
References: <1353417176-18945-1-git-send-email-joro@8bytes.org>
X-DSPAM-Result: Whitelisted
X-DSPAM-Processed: Tue Nov 20 14:13:19 2012
X-DSPAM-Confidence: 0.9995
X-DSPAM-Probability: 0.0000
X-DSPAM-Signature: 50ab81ef22971007957311
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This function does irq-remapping specific interrupt setup
like modifying the chip defaults.

Signed-off-by: Joerg Roedel <joro@8bytes.org>
Acked-by: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
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
index 73f1bf2..391c0b9 100644
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
@@ -3106,10 +3103,7 @@ int setup_msi_irq(struct pci_dev *dev, struct msi_desc *msidesc, int irq)
 	irq_set_msi_desc(irq, msidesc);
 	write_msi_msg(irq, &msg);
 
-	if (irq_remapped(irq_get_chip_data(irq))) {
-		irq_set_status_flags(irq, IRQ_MOVE_PCNTXT);
-		irq_remap_modify_chip_defaults(chip);
-	}
+	setup_remapped_irq(irq, irq_get_chip_data(irq), chip);
 
 	irq_set_chip_and_handler_name(irq, chip, handle_edge_irq, "edge");
 
@@ -3247,8 +3241,7 @@ int default_setup_hpet_msi(unsigned int irq, unsigned int id)
 
 	hpet_msi_write(irq_get_handler_data(irq), &msg);
 	irq_set_status_flags(irq, IRQ_MOVE_PCNTXT);
-	if (irq_remapped(irq_get_chip_data(irq)))
-		irq_remap_modify_chip_defaults(chip);
+	setup_remapped_irq(irq, irq_get_chip_data(irq), chip);
 
 	irq_set_chip_and_handler_name(irq, chip, handle_edge_irq, "edge");
 	return 0;
diff --git a/drivers/iommu/irq_remapping.c b/drivers/iommu/irq_remapping.c
index 5053482..30884ee 100644
--- a/drivers/iommu/irq_remapping.c
+++ b/drivers/iommu/irq_remapping.c
@@ -300,3 +300,12 @@ void irq_remap_modify_chip_defaults(struct irq_chip *chip)
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


