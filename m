Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755385Ab1HYTGG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Aug 2011 15:06:06 -0400
Received: from mga01.intel.com ([192.55.52.88]:27799 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755346Ab1HYTFk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Aug 2011 15:05:40 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.68,282,1312182000"; 
   d="scan'208";a="44587373"
Message-Id: <20110825190657.259696697@sbsiddha-desk.sc.intel.com>
User-Agent: quilt/0.48-1
Date: Thu, 25 Aug 2011 12:01:13 -0700
From: Suresh Siddha <suresh.b.siddha@intel.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        trenn@suse.de, suresh.b.siddha@intel.com, rjw@novell.com,
        macro@linux-mips.org, lchiquitto@novell.com, jbeulich@novell.com,
        yinghai@kernel.org
Subject: [patch v2 3/3] x86, ioapic: consolidate the explicit EOI code
References: <20110825190110.255432370@sbsiddha-desk.sc.intel.com>
Content-Disposition: inline; filename=consolidate_eoi_ioapic_irq.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Consolidate the io-apic EOI code in clear_IO_APIC_pin() and eoi_ioapic_irq().

Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: Thomas Renninger <trenn@suse.de>
Cc: Rafael Wysocki <rjw@novell.com>
Cc: Maciej W. Rozycki <macro@linux-mips.org>
---
 arch/x86/kernel/apic/io_apic.c |  139 +++++++++++++++++++----------------------
 1 file changed, 65 insertions(+), 74 deletions(-)

Index: linux-2.6-tip/arch/x86/kernel/apic/io_apic.c
===================================================================
--- linux-2.6-tip.orig/arch/x86/kernel/apic/io_apic.c
+++ linux-2.6-tip/arch/x86/kernel/apic/io_apic.c
@@ -581,6 +581,66 @@ static void unmask_ioapic_irq(struct irq
 	unmask_ioapic(data->chip_data);
 }
 
+/*
+ * IO-APIC versions below 0x20 don't support EOI register.
+ * For the record, here is the information about various versions:
+ *     0Xh     82489DX
+ *     1Xh     I/OAPIC or I/O(x)APIC which are not PCI 2.2 Compliant
+ *     2Xh     I/O(x)APIC which is PCI 2.2 Compliant
+ *     30h-FFh Reserved
+ *
+ * Some of the Intel ICH Specs (ICH2 to ICH5) documents the io-apic
+ * version as 0x2. This is an error with documentation and these ICH chips
+ * use io-apic's of version 0x20.
+ *
+ * For IO-APIC's with EOI register, we use that to do an explicit EOI.
+ * Otherwise, we simulate the EOI message manually by changing the trigger
+ * mode to edge and then back to level, with RTE being masked during this.
+ */
+static void __eoi_ioapic_pin(int apic, int pin, int vector, struct irq_cfg *cfg)
+{
+	if (mpc_ioapic_ver(apic) >= 0x20) {
+		/*
+		 * Intr-remapping uses pin number as the virtual vector
+		 * in the RTE. Actual vector is programmed in
+		 * intr-remapping table entry. Hence for the io-apic
+		 * EOI we use the pin number.
+		 */
+		if (cfg && irq_remapped(cfg))
+			io_apic_eoi(apic, pin);
+		else
+			io_apic_eoi(apic, vector);
+	} else {
+		struct IO_APIC_route_entry entry, entry1;
+
+		entry = entry1 = __ioapic_read_entry(apic, pin);
+
+		/*
+		 * Mask the entry and change the trigger mode to edge.
+		 */
+		entry1.mask = 1;
+		entry1.trigger = IOAPIC_EDGE;
+
+		__ioapic_write_entry(apic, pin, entry1);
+
+		/*
+		 * Restore the previous level triggered entry.
+		 */
+		__ioapic_write_entry(apic, pin, entry);
+	}
+}
+
+static void eoi_ioapic_irq(unsigned int irq, struct irq_cfg *cfg)
+{
+	struct irq_pin_list *entry;
+	unsigned long flags;
+
+	raw_spin_lock_irqsave(&ioapic_lock, flags);
+	for_each_irq_pin(entry, cfg->irq_2_pin)
+		__eoi_ioapic_pin(entry->apic, entry->pin, cfg->vector, cfg);
+	raw_spin_unlock_irqrestore(&ioapic_lock, flags);
+}
+
 static void clear_IO_APIC_pin(unsigned int apic, unsigned int pin)
 {
 	struct IO_APIC_route_entry entry;
@@ -601,6 +661,8 @@ static void clear_IO_APIC_pin(unsigned i
 	}
 
 	if (entry.irr) {
+		unsigned long flags;
+
 		/*
 		 * Make sure the trigger mode is set to level. Explicit EOI
 		 * doesn't clear the remoteIRR if the trigger mode is not
@@ -611,23 +673,9 @@ static void clear_IO_APIC_pin(unsigned i
 			ioapic_write_entry(apic, pin, entry);
 		}
 
-		if (mpc_ioapic_ver(apic) >= 0x20) {
-			unsigned long flags;
-
-			raw_spin_lock_irqsave(&ioapic_lock, flags);
-			io_apic_eoi(apic, entry.vector);
-			raw_spin_unlock_irqrestore(&ioapic_lock, flags);
-		} else {
-			/*
-			 * Mechanism by which we clear remoteIRR in this
-			 * case is by changing the trigger mode to edge and
-			 * back to level.
-			 */
-			entry.trigger = IOAPIC_EDGE;
-			ioapic_write_entry(apic, pin, entry);
-			entry.trigger = IOAPIC_LEVEL;
-			ioapic_write_entry(apic, pin, entry);
-		}
+		raw_spin_lock_irqsave(&ioapic_lock, flags);
+		__eoi_ioapic_pin(apic, pin, entry.vector, NULL);
+		raw_spin_unlock_irqrestore(&ioapic_lock, flags);
 	}
 
 	/*
@@ -2449,63 +2497,6 @@ static void ack_apic_edge(struct irq_dat
 
 atomic_t irq_mis_count;
 
-/*
- * IO-APIC versions below 0x20 don't support EOI register.
- * For the record, here is the information about various versions:
- *     0Xh     82489DX
- *     1Xh     I/OAPIC or I/O(x)APIC which are not PCI 2.2 Compliant
- *     2Xh     I/O(x)APIC which is PCI 2.2 Compliant
- *     30h-FFh Reserved
- *
- * Some of the Intel ICH Specs (ICH2 to ICH5) documents the io-apic
- * version as 0x2. This is an error with documentation and these ICH chips
- * use io-apic's of version 0x20.
- *
- * For IO-APIC's with EOI register, we use that to do an explicit EOI.
- * Otherwise, we simulate the EOI message manually by changing the trigger
- * mode to edge and then back to level, with RTE being masked during this.
-*/
-static void eoi_ioapic_irq(unsigned int irq, struct irq_cfg *cfg)
-{
-	struct irq_pin_list *entry;
-	unsigned long flags;
-
-	raw_spin_lock_irqsave(&ioapic_lock, flags);
-	for_each_irq_pin(entry, cfg->irq_2_pin) {
-		if (mpc_ioapic_ver(entry->apic) >= 0x20) {
-			/*
-			 * Intr-remapping uses pin number as the virtual vector
-			 * in the RTE. Actual vector is programmed in
-			 * intr-remapping table entry. Hence for the io-apic
-			 * EOI we use the pin number.
-			 */
-			if (irq_remapped(cfg))
-				io_apic_eoi(entry->apic, entry->pin);
-			else
-				io_apic_eoi(entry->apic, cfg->vector);
-		} else {
-			struct IO_APIC_route_entry rte, rte1;
-
-			rte = rte1 =
-				__ioapic_read_entry(entry->apic, entry->pin);
-
-			/*
-			 * Mask the entry and change the trigger mode to edge.
-			 */
-			rte1.mask = 1;
-			rte1.trigger = IOAPIC_EDGE;
-
-			__ioapic_write_entry(apic, pin, rte1);
-
-			/*
-			 * Restore the previous level triggered entry.
-			 */
-			__ioapic_write_entry(apic, pin, rte);
-		}
-	}
-	raw_spin_unlock_irqrestore(&ioapic_lock, flags);
-}
-
 static void ack_apic_level(struct irq_data *data)
 {
 	struct irq_cfg *cfg = data->chip_data;


