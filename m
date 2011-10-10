Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754504Ab1JJOAR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Oct 2011 10:00:17 -0400
Received: from mga14.intel.com ([143.182.124.37]:29816 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754471Ab1JJOAP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Oct 2011 10:00:15 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.68,517,1312182000"; 
   d="scan'208";a="24853381"
From: Mathias Nyman <mathias.nyman@linux.intel.com>
To: linux-kernel@vger.kernel.org
Cc: jacob.jun.pan@intel.com, mingo@elte.hu,
        Mathias Nyman <mathias.nyman@linux.intel.com>
Subject: [PATCH] x86, ioapic: only print ioapic debug information for IRQs belonging to an ioapic chip
Date: Mon, 10 Oct 2011 17:00:36 +0300
Message-Id: <1318255236-6389-1-git-send-email-mathias.nyman@linux.intel.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

with "apic=verbose" the print_IO_APIC() function tries to print IRQ to pin mappings
for every active irq. It assumes chip_data is of type irq_cfg and may cause an oops if not.

As the print_IO_APIC() is called from a late_initcall other chained irq chips may already be
registered with custom chip_data information, causing an oops. This is the case with intel
MID SoC devices with gpio demuxers registered as irq_chips.

Signed-off-by: Mathias Nyman <mathias.nyman@linux.intel.com>
---
 arch/x86/kernel/apic/io_apic.c |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
index 472e094..0a37ec0 100644
--- a/arch/x86/kernel/apic/io_apic.c
+++ b/arch/x86/kernel/apic/io_apic.c
@@ -1499,6 +1499,7 @@ __apicdebuginit(void) print_IO_APIC(void)
 	unsigned long flags;
 	struct irq_cfg *cfg;
 	unsigned int irq;
+	struct irq_chip *chip;
 
 	printk(KERN_DEBUG "number of MP IRQ sources: %d.\n", mp_irq_entries);
 	for (i = 0; i < nr_ioapics; i++)
@@ -1618,6 +1619,10 @@ __apicdebuginit(void) print_IO_APIC(void)
 	for_each_active_irq(irq) {
 		struct irq_pin_list *entry;
 
+		chip = irq_get_chip(irq);
+		if (chip != &ioapic_chip && chip != &ir_ioapic_chip)
+			continue;
+
 		cfg = irq_get_chip_data(irq);
 		if (!cfg)
 			continue;
-- 
1.7.4.1

