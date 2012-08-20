Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756524Ab2HTOAY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2012 10:00:24 -0400
Received: from co1ehsobe002.messaging.microsoft.com ([216.32.180.185]:49257
	"EHLO co1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755465Ab2HTN4R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2012 09:56:17 -0400
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-SpamScore: -6
X-BigFish: VPS-6(zzea8Nzz1202hzz8275bhz2dh668h839hd24he5bhf0ah11b5h)
X-WSS-ID: 0M9241K-02-F0U-02
X-M-MSG: 
From: Joerg Roedel <joerg.roedel@amd.com>
To: <x86@kernel.org>
CC: <linux-kernel@vger.kernel.org>, <joro@8bytes.org>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        Yinghai Lu <yinghai@kernel.org>, Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 18/19] x86, io_apic: Introduce eoi_ioapic_pin call-back
Date: Mon, 20 Aug 2012 15:56:04 +0200
Message-ID: <1345470965-24410-19-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1345470965-24410-1-git-send-email-joerg.roedel@amd.com>
References: <1345470965-24410-1-git-send-email-joerg.roedel@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This callback replaces the old __eoi_ioapic_pin function
which needs a special path for interrupt remapping.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/include/asm/io_apic.h  |    5 +++++
 arch/x86/include/asm/x86_init.h |    1 +
 arch/x86/kernel/apic/io_apic.c  |   20 ++++++--------------
 arch/x86/kernel/x86_init.c      |    1 +
 drivers/iommu/irq_remapping.c   |   13 +++++++++++++
 5 files changed, 26 insertions(+), 14 deletions(-)

diff --git a/arch/x86/include/asm/io_apic.h b/arch/x86/include/asm/io_apic.h
index 59a3f4e..16f28fe 100644
--- a/arch/x86/include/asm/io_apic.h
+++ b/arch/x86/include/asm/io_apic.h
@@ -163,6 +163,7 @@ extern void eoi_ioapic_irq(unsigned int irq, struct irq_cfg *cfg);
 extern void native_compose_msi_msg(struct pci_dev *pdev,
 				   unsigned int irq, unsigned int dest,
 				   struct msi_msg *msg, u8 hpet_id);
+extern void native_eoi_ioapic_pin(int apic, int pin, int vector);
 int io_apic_setup_irq_pin_once(unsigned int irq, int node, struct io_apic_irq_attr *attr);
 
 extern int save_ioapic_entries(void);
@@ -213,6 +214,9 @@ static inline void io_apic_modify(unsigned int apic, unsigned int reg, unsigned
 {
 	x86_io_apic_ops.modify(apic, reg, value);
 }
+
+extern void io_apic_eoi(unsigned int apic, unsigned int vector);
+
 #else  /* !CONFIG_X86_IO_APIC */
 
 #define io_apic_assign_pci_irqs 0
@@ -249,6 +253,7 @@ static inline void disable_ioapic_support(void) { }
 #define native_setup_ioapic_entry	NULL
 #define native_setup_timer_pin		NULL
 #define native_compose_msi_msg		NULL
+#define native_eoi_ioapic_pin		NULL
 #endif
 
 #endif /* _ASM_X86_IO_APIC_H */
diff --git a/arch/x86/include/asm/x86_init.h b/arch/x86/include/asm/x86_init.h
index 1430af0..5d7faf7 100644
--- a/arch/x86/include/asm/x86_init.h
+++ b/arch/x86/include/asm/x86_init.h
@@ -213,6 +213,7 @@ struct x86_io_apic_ops {
 				       struct io_apic_irq_attr *attr);
 	void		(*setup_timer_pin)(unsigned int ioapic_idx,
 					   unsigned int pin, int vector);
+	void		(*eoi_ioapic_pin)(int apic, int pin, int vector);
 
 };
 
diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
index aac3f62..d4db390 100644
--- a/arch/x86/kernel/apic/io_apic.c
+++ b/arch/x86/kernel/apic/io_apic.c
@@ -310,7 +310,7 @@ static __attribute_const__ struct io_apic __iomem *io_apic_base(int idx)
 		+ (mpc_ioapic_addr(idx) & ~PAGE_MASK);
 }
 
-static inline void io_apic_eoi(unsigned int apic, unsigned int vector)
+void io_apic_eoi(unsigned int apic, unsigned int vector)
 {
 	struct io_apic __iomem *io_apic = io_apic_base(apic);
 	writel(vector, &io_apic->eoi);
@@ -557,19 +557,10 @@ static void unmask_ioapic_irq(struct irq_data *data)
  * Otherwise, we simulate the EOI message manually by changing the trigger
  * mode to edge and then back to level, with RTE being masked during this.
  */
-static void __eoi_ioapic_pin(int apic, int pin, int vector, struct irq_cfg *cfg)
+void native_eoi_ioapic_pin(int apic, int pin, int vector)
 {
 	if (mpc_ioapic_ver(apic) >= 0x20) {
-		/*
-		 * Intr-remapping uses pin number as the virtual vector
-		 * in the RTE. Actual vector is programmed in
-		 * intr-remapping table entry. Hence for the io-apic
-		 * EOI we use the pin number.
-		 */
-		if (cfg && irq_remapped(cfg))
-			io_apic_eoi(apic, pin);
-		else
-			io_apic_eoi(apic, vector);
+		io_apic_eoi(apic, vector);
 	} else {
 		struct IO_APIC_route_entry entry, entry1;
 
@@ -597,7 +588,8 @@ void eoi_ioapic_irq(unsigned int irq, struct irq_cfg *cfg)
 
 	raw_spin_lock_irqsave(&ioapic_lock, flags);
 	for_each_irq_pin(entry, cfg->irq_2_pin)
-		__eoi_ioapic_pin(entry->apic, entry->pin, cfg->vector, cfg);
+		x86_io_apic_ops.eoi_ioapic_pin(entry->apic, entry->pin,
+					       cfg->vector);
 	raw_spin_unlock_irqrestore(&ioapic_lock, flags);
 }
 
@@ -634,7 +626,7 @@ static void clear_IO_APIC_pin(unsigned int apic, unsigned int pin)
 		}
 
 		raw_spin_lock_irqsave(&ioapic_lock, flags);
-		__eoi_ioapic_pin(apic, pin, entry.vector, NULL);
+		x86_io_apic_ops.eoi_ioapic_pin(apic, pin, entry.vector);
 		raw_spin_unlock_irqrestore(&ioapic_lock, flags);
 	}
 
diff --git a/arch/x86/kernel/x86_init.c b/arch/x86/kernel/x86_init.c
index af5874e..589fb84 100644
--- a/arch/x86/kernel/x86_init.c
+++ b/arch/x86/kernel/x86_init.c
@@ -132,4 +132,5 @@ struct x86_io_apic_ops x86_io_apic_ops = {
 	.set_affinity		= native_ioapic_set_affinity,
 	.setup_entry		= native_setup_ioapic_entry,
 	.setup_timer_pin	= native_setup_timer_pin,
+	.eoi_ioapic_pin		= native_eoi_ioapic_pin,
 };
diff --git a/drivers/iommu/irq_remapping.c b/drivers/iommu/irq_remapping.c
index e61a174..d62e757 100644
--- a/drivers/iommu/irq_remapping.c
+++ b/drivers/iommu/irq_remapping.c
@@ -94,12 +94,24 @@ static void __init irq_remapping_setup_timer_pin(unsigned int ioapic_idx,
 	/* Not needed with interrupt remapping */
 }
 
+void eoi_ioapic_pin_remapped(int apic, int pin, int vector)
+{
+	/*
+	 * Intr-remapping uses pin number as the virtual vector
+	 * in the RTE. Actual vector is programmed in
+	 * intr-remapping table entry. Hence for the io-apic
+	 * EOI we use the pin number.
+	 */
+	io_apic_eoi(apic, pin);
+}
+
 static void __init irq_remapping_modify_x86_ops(void)
 {
 	x86_io_apic_ops.disable		= irq_remapping_disable_io_apic;
 	x86_io_apic_ops.set_affinity	= set_remapped_irq_affinity;
 	x86_io_apic_ops.setup_entry	= setup_ioapic_remapped_entry;
 	x86_io_apic_ops.setup_timer_pin	= irq_remapping_setup_timer_pin;
+	x86_io_apic_ops.eoi_ioapic_pin	= eoi_ioapic_pin_remapped;
 	x86_msi.setup_msi_irqs		= irq_remapping_setup_msi_irqs;
 	x86_msi.setup_hpet_msi		= setup_hpet_msi_remapped;
 	x86_msi.compose_msi_msg		= compose_remapped_msi_msg;
@@ -316,3 +328,4 @@ bool setup_remapped_irq(int irq, struct irq_cfg *cfg, struct irq_chip *chip)
 		return false;
 	}
 }
+
-- 
1.7.9.5


