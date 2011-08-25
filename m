Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755396Ab1HYTGI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Aug 2011 15:06:08 -0400
Received: from mga03.intel.com ([143.182.124.21]:59701 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755345Ab1HYTFj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Aug 2011 15:05:39 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.68,282,1312182000"; 
   d="scan'208";a="42458343"
Message-Id: <20110825190657.210286410@sbsiddha-desk.sc.intel.com>
User-Agent: quilt/0.48-1
Date: Thu, 25 Aug 2011 12:01:12 -0700
From: Suresh Siddha <suresh.b.siddha@intel.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        trenn@suse.de, suresh.b.siddha@intel.com, rjw@novell.com,
        macro@linux-mips.org, lchiquitto@novell.com, jbeulich@novell.com,
        yinghai@kernel.org
Subject: [patch v2 2/3] x86, ioapic: restore the mask bit correctly in eoi_ioapic_irq()
References: <20110825190110.255432370@sbsiddha-desk.sc.intel.com>
Content-Disposition: inline; filename=fix_eoi_ioapic_irq_mask_unmask.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For older io-apic's, we were clearing the remote IRR by changing the RTE
trigger mode to edge and then back to level. We wanted to mask the RTE during
this process, so we were essentially doing mask+edge and then to unmask+level.

As part of the commit ca64c47cecd0321b2e0dcbd7aaff44b68ce20654, we
moved this EOI process earlier where the IO-APIC RTE is masked. So we were
wrongly unmasking it in the eoi_ioapic_irq().

So change the remoteIRR clear sequence in eoi_ioapic_irq() to mask + edge and
then restore the previous RTE entry which will restore the mask status aswell
as the level trigger.

Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: Maciej W. Rozycki <macro@linux-mips.org>
Cc: Thomas Renninger <trenn@suse.de>
Cc: Rafael Wysocki <rjw@novell.com>
---
 arch/x86/kernel/apic/io_apic.c |   43 +++++++++++++++++++++++++----------------
 1 file changed, 27 insertions(+), 16 deletions(-)

Index: linux-2.6-tip/arch/x86/kernel/apic/io_apic.c
===================================================================
--- linux-2.6-tip.orig/arch/x86/kernel/apic/io_apic.c
+++ linux-2.6-tip/arch/x86/kernel/apic/io_apic.c
@@ -394,13 +394,21 @@ union entry_union {
 	struct IO_APIC_route_entry entry;
 };
 
+static struct IO_APIC_route_entry __ioapic_read_entry(int apic, int pin)
+{
+	union entry_union eu;
+
+	eu.w1 = io_apic_read(apic, 0x10 + 2 * pin);
+	eu.w2 = io_apic_read(apic, 0x11 + 2 * pin);
+	return eu.entry;
+}
+
 static struct IO_APIC_route_entry ioapic_read_entry(int apic, int pin)
 {
 	union entry_union eu;
 	unsigned long flags;
 	raw_spin_lock_irqsave(&ioapic_lock, flags);
-	eu.w1 = io_apic_read(apic, 0x10 + 2 * pin);
-	eu.w2 = io_apic_read(apic, 0x11 + 2 * pin);
+	eu.entry = __ioapic_read_entry(apic, pin);
 	raw_spin_unlock_irqrestore(&ioapic_lock, flags);
 	return eu.entry;
 }
@@ -529,18 +537,6 @@ static void io_apic_modify_irq(struct ir
 		__io_apic_modify_irq(entry, mask_and, mask_or, final);
 }
 
-static void __mask_and_edge_IO_APIC_irq(struct irq_pin_list *entry)
-{
-	__io_apic_modify_irq(entry, ~IO_APIC_REDIR_LEVEL_TRIGGER,
-			     IO_APIC_REDIR_MASKED, NULL);
-}
-
-static void __unmask_and_level_IO_APIC_irq(struct irq_pin_list *entry)
-{
-	__io_apic_modify_irq(entry, ~IO_APIC_REDIR_MASKED,
-			     IO_APIC_REDIR_LEVEL_TRIGGER, NULL);
-}
-
 static void io_apic_sync(struct irq_pin_list *entry)
 {
 	/*
@@ -2488,8 +2484,23 @@ static void eoi_ioapic_irq(unsigned int 
 			else
 				io_apic_eoi(entry->apic, cfg->vector);
 		} else {
-			__mask_and_edge_IO_APIC_irq(entry);
-			__unmask_and_level_IO_APIC_irq(entry);
+			struct IO_APIC_route_entry rte, rte1;
+
+			rte = rte1 =
+				__ioapic_read_entry(entry->apic, entry->pin);
+
+			/*
+			 * Mask the entry and change the trigger mode to edge.
+			 */
+			rte1.mask = 1;
+			rte1.trigger = IOAPIC_EDGE;
+
+			__ioapic_write_entry(apic, pin, rte1);
+
+			/*
+			 * Restore the previous level triggered entry.
+			 */
+			__ioapic_write_entry(apic, pin, rte);
 		}
 	}
 	raw_spin_unlock_irqrestore(&ioapic_lock, flags);


