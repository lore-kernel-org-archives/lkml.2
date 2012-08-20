Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756349Ab2HTN4l (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2012 09:56:41 -0400
Received: from va3ehsobe005.messaging.microsoft.com ([216.32.180.31]:25898
	"EHLO va3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755055Ab2HTN4a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2012 09:56:30 -0400
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-SpamScore: 0
X-BigFish: VPS0(zzzz1202hzz8275bhz2dh668h839hd24he5bhf0ah11b5h)
X-WSS-ID: 0M9241R-01-3DP-02
X-M-MSG: 
From: Joerg Roedel <joerg.roedel@amd.com>
To: <x86@kernel.org>
CC: <linux-kernel@vger.kernel.org>, <joro@8bytes.org>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        Yinghai Lu <yinghai@kernel.org>, Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 10/19] x86, io_apic: Introduce function pointer for setup_timer_IRQ0_pin
Date: Mon, 20 Aug 2012 15:55:56 +0200
Message-ID: <1345470965-24410-11-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1345470965-24410-1-git-send-email-joerg.roedel@amd.com>
References: <1345470965-24410-1-git-send-email-joerg.roedel@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This function must be a NOP with interrupt remapping
enabled. So use a funtion pointer for it which points to an
empty function when irq_remapping_enabled == true.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/include/asm/io_apic.h  |    6 ++++++
 arch/x86/include/asm/x86_init.h |    3 +++
 arch/x86/kernel/apic/io_apic.c  |   11 ++++-------
 arch/x86/kernel/x86_init.c      |    1 +
 drivers/iommu/irq_remapping.c   |    7 +++++++
 5 files changed, 21 insertions(+), 7 deletions(-)

diff --git a/arch/x86/include/asm/io_apic.h b/arch/x86/include/asm/io_apic.h
index 71f5f08..bb5caee 100644
--- a/arch/x86/include/asm/io_apic.h
+++ b/arch/x86/include/asm/io_apic.h
@@ -152,6 +152,11 @@ extern void ioapic_insert_resources(void);
 extern int native_setup_ioapic_entry(int, struct IO_APIC_route_entry *,
 				     unsigned int, int,
 				     struct io_apic_irq_attr *);
+extern int native_setup_ioapic_entry(int, struct IO_APIC_route_entry *,
+				     unsigned int, int,
+				     struct io_apic_irq_attr *);
+extern void __init native_setup_timer_pin(unsigned int ioapic_idx,
+					  unsigned int pin, int vector);
 
 int io_apic_setup_irq_pin_once(unsigned int irq, int node, struct io_apic_irq_attr *attr);
 
@@ -237,6 +242,7 @@ static inline void disable_ioapic_support(void) { }
 #define native_io_apic_print_entries	NULL
 #define native_ioapic_set_affinity	NULL
 #define native_setup_ioapic_entry	NULL
+#define native_setup_timer_pin		NULL
 #endif
 
 #endif /* _ASM_X86_IO_APIC_H */
diff --git a/arch/x86/include/asm/x86_init.h b/arch/x86/include/asm/x86_init.h
index bc13022..ffe5860 100644
--- a/arch/x86/include/asm/x86_init.h
+++ b/arch/x86/include/asm/x86_init.h
@@ -207,6 +207,9 @@ struct x86_io_apic_ops {
 	int		(*setup_entry)(int irq, struct IO_APIC_route_entry *entry,
 				       unsigned int destination, int vector,
 				       struct io_apic_irq_attr *attr);
+	void		(*setup_timer_pin)(unsigned int ioapic_idx,
+					   unsigned int pin, int vector);
+
 };
 
 extern struct x86_init_ops x86_init;
diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
index 8816280..22e6bef 100644
--- a/arch/x86/kernel/apic/io_apic.c
+++ b/arch/x86/kernel/apic/io_apic.c
@@ -1473,15 +1473,12 @@ void setup_IO_APIC_irq_extra(u32 gsi)
 /*
  * Set up the timer pin, possibly with the 8259A-master behind.
  */
-static void __init setup_timer_IRQ0_pin(unsigned int ioapic_idx,
-					unsigned int pin, int vector)
+void __init native_setup_timer_pin(unsigned int ioapic_idx,
+				   unsigned int pin, int vector)
 {
 	struct IO_APIC_route_entry entry;
 	unsigned int dest;
 
-	if (irq_remapping_enabled)
-		return;
-
 	memset(&entry, 0, sizeof(entry));
 
 	/*
@@ -2791,7 +2788,7 @@ static inline void __init check_timer(void)
 		 */
 		if (no_pin1) {
 			add_pin_to_irq_node(cfg, node, apic1, pin1);
-			setup_timer_IRQ0_pin(apic1, pin1, cfg->vector);
+			x86_io_apic_ops.setup_timer_pin(apic1, pin1, cfg->vector);
 		} else {
 			/* for edge trigger, setup_ioapic_irq already
 			 * leave it unmasked.
@@ -2823,7 +2820,7 @@ static inline void __init check_timer(void)
 		 * legacy devices should be connected to IO APIC #0
 		 */
 		replace_pin_at_irq_node(cfg, node, apic1, pin1, apic2, pin2);
-		setup_timer_IRQ0_pin(apic2, pin2, cfg->vector);
+		x86_io_apic_ops.setup_timer_pin(apic2, pin2, cfg->vector);
 		legacy_pic->unmask(0);
 		if (timer_irq_works()) {
 			apic_printk(APIC_QUIET, KERN_INFO "....... works.\n");
diff --git a/arch/x86/kernel/x86_init.c b/arch/x86/kernel/x86_init.c
index 3cd6bf7..eba02e5 100644
--- a/arch/x86/kernel/x86_init.c
+++ b/arch/x86/kernel/x86_init.c
@@ -130,4 +130,5 @@ struct x86_io_apic_ops x86_io_apic_ops = {
 	.print_entries		= native_io_apic_print_entries,
 	.set_affinity		= native_ioapic_set_affinity,
 	.setup_entry		= native_setup_ioapic_entry,
+	.setup_timer_pin	= native_setup_timer_pin,
 };
diff --git a/drivers/iommu/irq_remapping.c b/drivers/iommu/irq_remapping.c
index 827f8a1..71824fc 100644
--- a/drivers/iommu/irq_remapping.c
+++ b/drivers/iommu/irq_remapping.c
@@ -87,11 +87,18 @@ error:
 	return ret;
 }
 
+static void __init irq_remapping_setup_timer_pin(unsigned int ioapic_idx,
+						 unsigned int pin, int vector)
+{
+	/* Not needed with interrupt remapping */
+}
+
 static void __init irq_remapping_modify_x86_ops(void)
 {
 	x86_io_apic_ops.disable		= irq_remapping_disable_io_apic;
 	x86_io_apic_ops.set_affinity	= set_remapped_irq_affinity;
 	x86_io_apic_ops.setup_entry	= setup_ioapic_remapped_entry;
+	x86_io_apic_ops.setup_timer_pin	= irq_remapping_setup_timer_pin;
 	x86_msi.setup_msi_irqs		= irq_remapping_setup_msi_irqs;
 	x86_msi.setup_hpet_msi		= setup_hpet_msi_remapped;
 }
-- 
1.7.9.5


