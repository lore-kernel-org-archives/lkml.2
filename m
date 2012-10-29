Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753145Ab2J2HPa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2012 03:15:30 -0400
Received: from mga02.intel.com ([134.134.136.20]:43748 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751385Ab2J2HP2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2012 03:15:28 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,669,1344236400"; 
   d="scan'208";a="212347080"
Subject: [PATCH] x86/ioapic: Fix the vector_irq[] is corrupted randomly
From: Chuansheng Liu <chuansheng.liu@intel.com>
To: mingo@redhat.com, hpa@zytor.com, tglx@linutronix.de, yinghai@kernel.org,
        suresh.b.siddha@intel.com
Cc: x86@kernel.org, linux-kernel@vger.kernel.org, chuansheng.liu@intel.com
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 30 Oct 2012 00:15:41 +0800
Message-ID: <1351527341.15558.1445.camel@cliu38-desktop-build>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Not all irq chips are IO-APIC chip.

In our system, there are many demux GPIO interrupts except for the
io-apic chip interrupts, and these GPIO interrupts are belonged
to other irq chips, the chip data is not type of struct irq_cfg
either.

But in function __setup_vector_irq(), it listed all allocated irqs,
and presume all irq chip is ioapic_chip and the chip data is type
of struct irq_cfg, it possibly causes the vector_irq is corrupted
randomly.

For example, one irq 258 is not io-apic chip irq, in __setup_vector_irq(),
the chip data is forced to be used as struct irq_cfg, then the value
cfg->domain and cfg->vector are wrong to be used to write vector_irq:
		vector = cfg->vector;
		per_cpu(vector_irq, cpu)[vector] = irq;

This patch use the .flags to identify if the irq chip is io-apic.

Signed-off-by: liu chuansheng <chuansheng.liu@intel.com>
---
 arch/x86/kernel/apic/io_apic.c |   24 ++++++++++++++++++++++++
 1 files changed, 24 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
index 1817fa9..f9cac47 100644
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
@@ -1259,6 +1274,9 @@ void __setup_vector_irq(int cpu)
 		if (irq < 0)
 			continue;
 
+		if (!is_ioapic_irq(irq))
+			continue;
+
 		cfg = irq_cfg(irq);
 		if (!cpumask_test_cpu(cpu, cfg->domain))
 			per_cpu(vector_irq, cpu)[vector] = -1;
@@ -2596,6 +2614,7 @@ static struct irq_chip ioapic_chip __read_mostly = {
 	.irq_eoi		= ack_apic_level,
 	.irq_set_affinity	= ioapic_set_affinity,
 	.irq_retrigger		= ioapic_retrigger_irq,
+	.flags			= CHIP_FLAG_IOAPIC,
 };
 
 static inline void init_IO_APIC_traps(void)
@@ -2661,6 +2680,7 @@ static struct irq_chip lapic_chip __read_mostly = {
 	.irq_mask	= mask_lapic_irq,
 	.irq_unmask	= unmask_lapic_irq,
 	.irq_ack	= ack_lapic_irq,
+	.flags			= CHIP_FLAG_IOAPIC,
 };
 
 static void lapic_register_intr(int irq)
@@ -3146,6 +3166,7 @@ static struct irq_chip msi_chip = {
 	.irq_ack		= ack_apic_edge,
 	.irq_set_affinity	= msi_set_affinity,
 	.irq_retrigger		= ioapic_retrigger_irq,
+	.flags			= CHIP_FLAG_IOAPIC,
 };
 
 static int setup_msi_irq(struct pci_dev *dev, struct msi_desc *msidesc, int irq)
@@ -3260,6 +3281,7 @@ static struct irq_chip dmar_msi_type = {
 	.irq_ack		= ack_apic_edge,
 	.irq_set_affinity	= dmar_msi_set_affinity,
 	.irq_retrigger		= ioapic_retrigger_irq,
+	.flags			= CHIP_FLAG_IOAPIC,
 };
 
 int arch_setup_dmar_msi(unsigned int irq)
@@ -3308,6 +3330,7 @@ static struct irq_chip hpet_msi_type = {
 	.irq_ack = ack_apic_edge,
 	.irq_set_affinity = hpet_msi_set_affinity,
 	.irq_retrigger = ioapic_retrigger_irq,
+	.flags			= CHIP_FLAG_IOAPIC,
 };
 
 int arch_setup_hpet_msi(unsigned int irq, unsigned int id)
@@ -3375,6 +3398,7 @@ static struct irq_chip ht_irq_chip = {
 	.irq_ack		= ack_apic_edge,
 	.irq_set_affinity	= ht_set_affinity,
 	.irq_retrigger		= ioapic_retrigger_irq,
+	.flags			= CHIP_FLAG_IOAPIC,
 };
 
 int arch_setup_ht_irq(unsigned int irq, struct pci_dev *dev)
-- 
1.7.0.4



