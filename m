Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753213Ab2KTNNJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2012 08:13:09 -0500
Received: from 8bytes.org ([85.214.48.195]:58234 "EHLO mail.8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753375Ab2KTNNH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2012 08:13:07 -0500
From: Joerg Roedel <joro@8bytes.org>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>
Cc: x86@kernel.org, iommu@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        Yinghai Lu <yinghai@kernel.org>,
        Sebastian Andrzej Siewior <sebastian@breakpoint.cc>,
        Joerg Roedel <joro@8bytes.org>
Subject: [PATCH 04/19] x86, io_apic: Introduce x86_io_apic_ops.print_entries for debugging
Date: Tue, 20 Nov 2012 14:12:41 +0100
Message-Id: <1353417176-18945-5-git-send-email-joro@8bytes.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1353417176-18945-1-git-send-email-joro@8bytes.org>
References: <1353417176-18945-1-git-send-email-joro@8bytes.org>
X-DSPAM-Result: Whitelisted
X-DSPAM-Processed: Tue Nov 20 14:13:05 2012
X-DSPAM-Confidence: 0.9996
X-DSPAM-Probability: 0.0000
X-DSPAM-Signature: 50ab81e122977124395289
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This call-back is used to dump IO-APIC entries for debugging
purposes into the kernel log. VT-d needs a special routine
for this and will overwrite the default.

Signed-off-by: Joerg Roedel <joro@8bytes.org>
Acked-by: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
---
 arch/x86/include/asm/io_apic.h      |    3 +
 arch/x86/include/asm/x86_init.h     |    1 +
 arch/x86/kernel/apic/io_apic.c      |  109 ++++++++++++++++++-----------------
 arch/x86/kernel/x86_init.c          |    1 +
 drivers/iommu/intel_irq_remapping.c |    8 +++
 5 files changed, 69 insertions(+), 53 deletions(-)

diff --git a/arch/x86/include/asm/io_apic.h b/arch/x86/include/asm/io_apic.h
index d59e172..21aa81e 100644
--- a/arch/x86/include/asm/io_apic.h
+++ b/arch/x86/include/asm/io_apic.h
@@ -180,6 +180,8 @@ extern unsigned int native_io_apic_read(unsigned int apic, unsigned int reg);
 extern void native_io_apic_write(unsigned int apic, unsigned int reg, unsigned int val);
 extern void native_io_apic_modify(unsigned int apic, unsigned int reg, unsigned int val);
 extern void native_disable_io_apic(void);
+extern void native_io_apic_print_entries(unsigned int apic, unsigned int nr_entries);
+extern void intel_ir_io_apic_print_entries(unsigned int apic, unsigned int nr_entries);
 
 static inline unsigned int io_apic_read(unsigned int apic, unsigned int reg)
 {
@@ -225,6 +227,7 @@ static inline void disable_ioapic_support(void) { }
 #define native_io_apic_write		NULL
 #define native_io_apic_modify		NULL
 #define native_disable_io_apic		NULL
+#define native_io_apic_print_entries	NULL
 #endif
 
 #endif /* _ASM_X86_IO_APIC_H */
diff --git a/arch/x86/include/asm/x86_init.h b/arch/x86/include/asm/x86_init.h
index b1d2d6a..8ff79f7 100644
--- a/arch/x86/include/asm/x86_init.h
+++ b/arch/x86/include/asm/x86_init.h
@@ -195,6 +195,7 @@ struct x86_io_apic_ops {
 	void		(*write)  (unsigned int apic, unsigned int reg, unsigned int value);
 	void		(*modify) (unsigned int apic, unsigned int reg, unsigned int value);
 	void		(*disable)(void);
+	void		(*print_entries)(unsigned int apic, unsigned int nr_entries);
 };
 
 extern struct x86_init_ops x86_init;
diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
index 3603bc4..edaaad9 100644
--- a/arch/x86/kernel/apic/io_apic.c
+++ b/arch/x86/kernel/apic/io_apic.c
@@ -1527,9 +1527,63 @@ static void __init setup_timer_IRQ0_pin(unsigned int ioapic_idx,
 	ioapic_write_entry(ioapic_idx, pin, entry);
 }
 
-__apicdebuginit(void) print_IO_APIC(int ioapic_idx)
+void native_io_apic_print_entries(unsigned int apic, unsigned int nr_entries)
+{
+	int i;
+
+	pr_debug(" NR Dst Mask Trig IRR Pol Stat Dmod Deli Vect:\n");
+
+	for (i = 0; i <= nr_entries; i++) {
+		struct IO_APIC_route_entry entry;
+
+		entry = ioapic_read_entry(apic, i);
+
+		pr_debug(" %02x %02X  ", i, entry.dest);
+		pr_cont("%1d    %1d    %1d   %1d   %1d    "
+			"%1d    %1d    %02X\n",
+			entry.mask,
+			entry.trigger,
+			entry.irr,
+			entry.polarity,
+			entry.delivery_status,
+			entry.dest_mode,
+			entry.delivery_mode,
+			entry.vector);
+	}
+}
+
+void intel_ir_io_apic_print_entries(unsigned int apic,
+				    unsigned int nr_entries)
 {
 	int i;
+
+	pr_debug(" NR Indx Fmt Mask Trig IRR Pol Stat Indx2 Zero Vect:\n");
+
+	for (i = 0; i <= nr_entries; i++) {
+		struct IR_IO_APIC_route_entry *ir_entry;
+		struct IO_APIC_route_entry entry;
+
+		entry = ioapic_read_entry(apic, i);
+
+		ir_entry = (struct IR_IO_APIC_route_entry *)&entry;
+
+		pr_debug(" %02x %04X ", i, ir_entry->index);
+		pr_cont("%1d   %1d    %1d    %1d   %1d   "
+			"%1d    %1d     %X    %02X\n",
+			ir_entry->format,
+			ir_entry->mask,
+			ir_entry->trigger,
+			ir_entry->irr,
+			ir_entry->polarity,
+			ir_entry->delivery_status,
+			ir_entry->index2,
+			ir_entry->zero,
+			ir_entry->vector);
+	}
+}
+
+__apicdebuginit(void) print_IO_APIC(int ioapic_idx)
+{
 	union IO_APIC_reg_00 reg_00;
 	union IO_APIC_reg_01 reg_01;
 	union IO_APIC_reg_02 reg_02;
@@ -1582,58 +1636,7 @@ __apicdebuginit(void) print_IO_APIC(int ioapic_idx)
 
 	printk(KERN_DEBUG ".... IRQ redirection table:\n");
 
-	if (irq_remapping_enabled) {
-		printk(KERN_DEBUG " NR Indx Fmt Mask Trig IRR"
-			" Pol Stat Indx2 Zero Vect:\n");
-	} else {
-		printk(KERN_DEBUG " NR Dst Mask Trig IRR Pol"
-			" Stat Dmod Deli Vect:\n");
-	}
-
-	for (i = 0; i <= reg_01.bits.entries; i++) {
-		if (irq_remapping_enabled) {
-			struct IO_APIC_route_entry entry;
-			struct IR_IO_APIC_route_entry *ir_entry;
-
-			entry = ioapic_read_entry(ioapic_idx, i);
-			ir_entry = (struct IR_IO_APIC_route_entry *) &entry;
-			printk(KERN_DEBUG " %02x %04X ",
-				i,
-				ir_entry->index
-			);
-			pr_cont("%1d   %1d    %1d    %1d   %1d   "
-				"%1d    %1d     %X    %02X\n",
-				ir_entry->format,
-				ir_entry->mask,
-				ir_entry->trigger,
-				ir_entry->irr,
-				ir_entry->polarity,
-				ir_entry->delivery_status,
-				ir_entry->index2,
-				ir_entry->zero,
-				ir_entry->vector
-			);
-		} else {
-			struct IO_APIC_route_entry entry;
-
-			entry = ioapic_read_entry(ioapic_idx, i);
-			printk(KERN_DEBUG " %02x %02X  ",
-				i,
-				entry.dest
-			);
-			pr_cont("%1d    %1d    %1d   %1d   %1d    "
-				"%1d    %1d    %02X\n",
-				entry.mask,
-				entry.trigger,
-				entry.irr,
-				entry.polarity,
-				entry.delivery_status,
-				entry.dest_mode,
-				entry.delivery_mode,
-				entry.vector
-			);
-		}
-	}
+	x86_io_apic_ops.print_entries(ioapic_idx, reg_01.bits.entries);
 }
 
 __apicdebuginit(void) print_IO_APICs(void)
diff --git a/arch/x86/kernel/x86_init.c b/arch/x86/kernel/x86_init.c
index 754524a..ee4af8b 100644
--- a/arch/x86/kernel/x86_init.c
+++ b/arch/x86/kernel/x86_init.c
@@ -123,4 +123,5 @@ struct x86_io_apic_ops x86_io_apic_ops = {
 	.write			= native_io_apic_write,
 	.modify			= native_io_apic_modify,
 	.disable		= native_disable_io_apic,
+	.print_entries		= native_io_apic_print_entries,
 };
diff --git a/drivers/iommu/intel_irq_remapping.c b/drivers/iommu/intel_irq_remapping.c
index af8904d..cb9a72d 100644
--- a/drivers/iommu/intel_irq_remapping.c
+++ b/drivers/iommu/intel_irq_remapping.c
@@ -617,6 +617,14 @@ static int __init intel_enable_irq_remapping(void)
 		goto error;
 
 	irq_remapping_enabled = 1;
+
+	/*
+	 * VT-d has a different layout for IO-APIC entries when
+	 * interrupt remapping is enabled. So it needs a special routine
+	 * to print IO-APIC entries for debugging purposes too.
+	 */
+	x86_io_apic_ops.print_entries = intel_ir_io_apic_print_entries;
+
 	pr_info("Enabled IRQ remapping in %s mode\n", eim ? "x2apic" : "xapic");
 
 	return eim ? IRQ_REMAP_X2APIC_MODE : IRQ_REMAP_XAPIC_MODE;
-- 
1.7.9.5


