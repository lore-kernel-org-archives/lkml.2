Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757192Ab2JSBmF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2012 21:42:05 -0400
Received: from mga09.intel.com ([134.134.136.24]:17256 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754047Ab2JSBmD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2012 21:42:03 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,610,1344236400"; 
   d="scan'208";a="229505152"
Subject: [PATCH] x86/ioapic: Fix that not all allocated irqs are ioapic
 type irqs
From: Chuansheng Liu <chuansheng.liu@intel.com>
To: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        suresh.b.siddha@intel.com, mathias.nyman@linux.intel.com
Cc: linux-kernel@vger.kernel.org, chuansheng.liu@intel.com
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 19 Oct 2012 18:41:29 +0800
Message-ID: <1350643289.15558.45.camel@cliu38-desktop-build>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


When debugging our system issues related with __setup_vector_irq(),
found there is a real wrong code that:
	for_each_active_irq(irq) {
		cfg = irq_get_chip_data(irq);
		if (!cfg)
			continue;

These codes presume all allocated irqs are ioapic irqs, but it is not
like that, in our system there are many GPIO interrupts also.

When one irq is not ioapic type irq, the chip_data will not be the
type of struct irq_cfg in most cases.

So in function __setup_vector_irq(), it will cause some strange issues,
moreover, if I added some prints(cfg->...) inside it, it can always
cause system panic.

Here using the struct irq_chip->flags to help identify if the irq
is ioapic type or not.

Looked forward all codes with for_each_active_irq(), found there is
a commit 6fd36ba02 indicates the similar case in print_IO_APICs().

Signed-off-by: liu chuansheng <chuansheng.liu@intel.com>
---
 arch/x86/kernel/apic/io_apic.c |   25 ++++++++++++++++++++++---
 1 files changed, 22 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
index c265593..f0355e6 100644
--- a/arch/x86/kernel/apic/io_apic.c
+++ b/arch/x86/kernel/apic/io_apic.c
@@ -68,6 +68,18 @@
 #define for_each_irq_pin(entry, head) \
 	for (entry = head; entry; entry = entry->next)
 
+/* need more thoughts ... */
+#define CHIP_FLAG_IOAPIC	0x1000
+static inline bool is_ioapic_irq(int irq)
+{
+	struct irq_chip *chip;
+	chip = irq_get_chip(irq);
+	if ((chip) && (chip->flags == CHIP_FLAG_IOAPIC))
+		return true;
+
+	return false;
+}
+
 #ifdef CONFIG_IRQ_REMAP
 static void irq_remap_modify_chip_defaults(struct irq_chip *chip);
 static inline bool irq_remapped(struct irq_cfg *cfg)
@@ -1238,6 +1250,9 @@ void __setup_vector_irq(int cpu)
 	raw_spin_lock(&vector_lock);
 	/* Mark the inuse vectors */
 	for_each_active_irq(irq) {
+		if (!is_ioapic_irq(irq))
+			continue;
+
 		cfg = irq_get_chip_data(irq);
 		if (!cfg)
 			continue;
@@ -1641,7 +1656,6 @@ __apicdebuginit(void) print_IO_APICs(void)
 	int ioapic_idx;
 	struct irq_cfg *cfg;
 	unsigned int irq;
-	struct irq_chip *chip;
 
 	printk(KERN_DEBUG "number of MP IRQ sources: %d.\n", mp_irq_entries);
 	for (ioapic_idx = 0; ioapic_idx < nr_ioapics; ioapic_idx++)
@@ -1662,8 +1676,7 @@ __apicdebuginit(void) print_IO_APICs(void)
 	for_each_active_irq(irq) {
 		struct irq_pin_list *entry;
 
-		chip = irq_get_chip(irq);
-		if (chip != &ioapic_chip)
+		if (!is_ioapic_irq(irq))
 			continue;
 
 		cfg = irq_get_chip_data(irq);
@@ -2593,6 +2606,7 @@ static struct irq_chip ioapic_chip __read_mostly = {
 	.irq_eoi		= ack_apic_level,
 	.irq_set_affinity	= ioapic_set_affinity,
 	.irq_retrigger		= ioapic_retrigger_irq,
+	.flags			= CHIP_FLAG_IOAPIC,
 };
 
 static inline void init_IO_APIC_traps(void)
@@ -2658,6 +2672,7 @@ static struct irq_chip lapic_chip __read_mostly = {
 	.irq_mask	= mask_lapic_irq,
 	.irq_unmask	= unmask_lapic_irq,
 	.irq_ack	= ack_lapic_irq,
+	.flags			= CHIP_FLAG_IOAPIC,
 };
 
 static void lapic_register_intr(int irq)
@@ -3143,6 +3158,7 @@ static struct irq_chip msi_chip = {
 	.irq_ack		= ack_apic_edge,
 	.irq_set_affinity	= msi_set_affinity,
 	.irq_retrigger		= ioapic_retrigger_irq,
+	.flags			= CHIP_FLAG_IOAPIC,
 };
 
 static int setup_msi_irq(struct pci_dev *dev, struct msi_desc *msidesc, int irq)
@@ -3257,6 +3273,7 @@ static struct irq_chip dmar_msi_type = {
 	.irq_ack		= ack_apic_edge,
 	.irq_set_affinity	= dmar_msi_set_affinity,
 	.irq_retrigger		= ioapic_retrigger_irq,
+	.flags			= CHIP_FLAG_IOAPIC,
 };
 
 int arch_setup_dmar_msi(unsigned int irq)
@@ -3305,6 +3322,7 @@ static struct irq_chip hpet_msi_type = {
 	.irq_ack = ack_apic_edge,
 	.irq_set_affinity = hpet_msi_set_affinity,
 	.irq_retrigger = ioapic_retrigger_irq,
+	.flags			= CHIP_FLAG_IOAPIC,
 };
 
 int arch_setup_hpet_msi(unsigned int irq, unsigned int id)
@@ -3372,6 +3390,7 @@ static struct irq_chip ht_irq_chip = {
 	.irq_ack		= ack_apic_edge,
 	.irq_set_affinity	= ht_set_affinity,
 	.irq_retrigger		= ioapic_retrigger_irq,
+	.flags			= CHIP_FLAG_IOAPIC,
 };
 
 int arch_setup_ht_irq(unsigned int irq, struct pci_dev *dev)
-- 
1.7.0.4



