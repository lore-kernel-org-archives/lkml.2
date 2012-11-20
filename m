Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753669Ab2KTNO2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2012 08:14:28 -0500
Received: from 8bytes.org ([85.214.48.195]:58468 "EHLO mail.8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753611Ab2KTNNQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2012 08:13:16 -0500
From: Joerg Roedel <joro@8bytes.org>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>
Cc: x86@kernel.org, iommu@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        Yinghai Lu <yinghai@kernel.org>,
        Sebastian Andrzej Siewior <sebastian@breakpoint.cc>,
        Joerg Roedel <joro@8bytes.org>
Subject: [PATCH 18/19] x86, io_apic: Introduce eoi_ioapic_pin call-back
Date: Tue, 20 Nov 2012 14:12:55 +0100
Message-Id: <1353417176-18945-19-git-send-email-joro@8bytes.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1353417176-18945-1-git-send-email-joro@8bytes.org>
References: <1353417176-18945-1-git-send-email-joro@8bytes.org>
X-DSPAM-Result: Whitelisted
X-DSPAM-Processed: Tue Nov 20 14:13:15 2012
X-DSPAM-Confidence: 0.9996
X-DSPAM-Probability: 0.0000
X-DSPAM-Signature: 50ab81eb22973759213966
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This callback replaces the old __eoi_ioapic_pin function
which needs a special path for interrupt remapping.

Signed-off-by: Joerg Roedel <joro@8bytes.org>
Acked-by: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
---
 arch/x86/include/asm/io_apic.h  |    5 +++++
 arch/x86/include/asm/x86_init.h |    1 +
 arch/x86/kernel/apic/io_apic.c  |   20 ++++++--------------
 arch/x86/kernel/x86_init.c      |    1 +
 drivers/iommu/irq_remapping.c   |   12 ++++++++++++
 5 files changed, 25 insertions(+), 14 deletions(-)

diff --git a/arch/x86/include/asm/io_apic.h b/arch/x86/include/asm/io_apic.h
index 1838e88..459e50a 100644
--- a/arch/x86/include/asm/io_apic.h
+++ b/arch/x86/include/asm/io_apic.h
@@ -161,6 +161,7 @@ extern void eoi_ioapic_irq(unsigned int irq, struct irq_cfg *cfg);
 extern void native_compose_msi_msg(struct pci_dev *pdev,
 				   unsigned int irq, unsigned int dest,
 				   struct msi_msg *msg, u8 hpet_id);
+extern void native_eoi_ioapic_pin(int apic, int pin, int vector);
 int io_apic_setup_irq_pin_once(unsigned int irq, int node, struct io_apic_irq_attr *attr);
 
 extern int save_ioapic_entries(void);
@@ -211,6 +212,9 @@ static inline void io_apic_modify(unsigned int apic, unsigned int reg, unsigned
 {
 	x86_io_apic_ops.modify(apic, reg, value);
 }
+
+extern void io_apic_eoi(unsigned int apic, unsigned int vector);
+
 #else  /* !CONFIG_X86_IO_APIC */
 
 #define io_apic_assign_pci_irqs 0
@@ -246,6 +250,7 @@ static inline void disable_ioapic_support(void) { }
 #define native_ioapic_set_affinity	NULL
 #define native_setup_ioapic_entry	NULL
 #define native_compose_msi_msg		NULL
+#define native_eoi_ioapic_pin		NULL
 #endif
 
 #endif /* _ASM_X86_IO_APIC_H */
diff --git a/arch/x86/include/asm/x86_init.h b/arch/x86/include/asm/x86_init.h
index c9f87be..7669941 100644
--- a/arch/x86/include/asm/x86_init.h
+++ b/arch/x86/include/asm/x86_init.h
@@ -212,6 +212,7 @@ struct x86_io_apic_ops {
 	int		(*setup_entry)(int irq, struct IO_APIC_route_entry *entry,
 				       unsigned int destination, int vector,
 				       struct io_apic_irq_attr *attr);
+	void		(*eoi_ioapic_pin)(int apic, int pin, int vector);
 };
 
 extern struct x86_init_ops x86_init;
diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
index d146a04..2170464 100644
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
index ee4a17c..d065d67 100644
--- a/arch/x86/kernel/x86_init.c
+++ b/arch/x86/kernel/x86_init.c
@@ -129,4 +129,5 @@ struct x86_io_apic_ops x86_io_apic_ops = {
 	.print_entries		= native_io_apic_print_entries,
 	.set_affinity		= native_ioapic_set_affinity,
 	.setup_entry		= native_setup_ioapic_entry,
+	.eoi_ioapic_pin		= native_eoi_ioapic_pin,
 };
diff --git a/drivers/iommu/irq_remapping.c b/drivers/iommu/irq_remapping.c
index 7055847..5622589 100644
--- a/drivers/iommu/irq_remapping.c
+++ b/drivers/iommu/irq_remapping.c
@@ -88,11 +88,23 @@ error:
 	return ret;
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
+	x86_io_apic_ops.eoi_ioapic_pin	= eoi_ioapic_pin_remapped;
 	x86_msi.setup_msi_irqs		= irq_remapping_setup_msi_irqs;
 	x86_msi.setup_hpet_msi		= setup_hpet_msi_remapped;
 	x86_msi.compose_msi_msg		= compose_remapped_msi_msg;
-- 
1.7.9.5


