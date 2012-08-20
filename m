Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756497Ab2HTOAQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2012 10:00:16 -0400
Received: from co1ehsobe001.messaging.microsoft.com ([216.32.180.184]:13017
	"EHLO co1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755485Ab2HTN4S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2012 09:56:18 -0400
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-SpamScore: 0
X-BigFish: VPS0(zzzz1202hzz8275bhz2dh668h839hd24he5bhf0ah11b5h)
X-WSS-ID: 0M9241L-01-3DD-02
X-M-MSG: 
From: Joerg Roedel <joerg.roedel@amd.com>
To: <x86@kernel.org>
CC: <linux-kernel@vger.kernel.org>, <joro@8bytes.org>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        Yinghai Lu <yinghai@kernel.org>, Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 04/19] x86, io_apic: Introduce x86_io_apic_ops.print_entries for debugging
Date: Mon, 20 Aug 2012 15:55:50 +0200
Message-ID: <1345470965-24410-5-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1345470965-24410-1-git-send-email-joerg.roedel@amd.com>
References: <1345470965-24410-1-git-send-email-joerg.roedel@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This call-back is used to dump IO-APIC entries for debugging
purposes into the kernel log. VT-d needs a special routine
for this and will overwrite the default.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/include/asm/io_apic.h      |    3 +
 arch/x86/include/asm/x86_init.h     |    1 +
 arch/x86/kernel/apic/io_apic.c      |  109 ++++++++++++++++++-----------------
 arch/x86/kernel/x86_init.c          |    1 +
 drivers/iommu/intel_irq_remapping.c |    4 ++
 5 files changed, 65 insertions(+), 53 deletions(-)

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
index 8e1b44c..be8e9a6 100644
--- a/arch/x86/include/asm/x86_init.h
+++ b/arch/x86/include/asm/x86_init.h
@@ -194,6 +194,7 @@ struct x86_io_apic_ops {
 	void		(*write)  (unsigned int apic, unsigned int reg, unsigned int value);
 	void		(*modify) (unsigned int apic, unsigned int reg, unsigned int value);
 	void		(*disable)(void);
+	void		(*print_entries)(unsigned int apic, unsigned int nr_entries);
 };
 
 extern struct x86_init_ops x86_init;
diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
index b919f1e..1ac89a6 100644
--- a/arch/x86/kernel/apic/io_apic.c
+++ b/arch/x86/kernel/apic/io_apic.c
@@ -1517,9 +1517,63 @@ static void __init setup_timer_IRQ0_pin(unsigned int ioapic_idx,
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
@@ -1572,58 +1626,7 @@ __apicdebuginit(void) print_IO_APIC(int ioapic_idx)
 
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
index 3ea56c2..dc19c50 100644
--- a/arch/x86/kernel/x86_init.c
+++ b/arch/x86/kernel/x86_init.c
@@ -125,4 +125,5 @@ struct x86_io_apic_ops x86_io_apic_ops = {
 	.write			= native_io_apic_write,
 	.modify			= native_io_apic_modify,
 	.disable		= native_disable_io_apic,
+	.print_entries		= native_io_apic_print_entries,
 };
diff --git a/drivers/iommu/intel_irq_remapping.c b/drivers/iommu/intel_irq_remapping.c
index e0b18f3..321db1a 100644
--- a/drivers/iommu/intel_irq_remapping.c
+++ b/drivers/iommu/intel_irq_remapping.c
@@ -617,6 +617,10 @@ static int __init intel_enable_irq_remapping(void)
 		goto error;
 
 	irq_remapping_enabled = 1;
+
+	/* VT-d needs a special routine to print IO-APIC entries */
+	x86_io_apic_ops.print_entries = intel_ir_io_apic_print_entries;
+
 	pr_info("Enabled IRQ remapping in %s mode\n", eim ? "x2apic" : "xapic");
 
 	return eim ? IRQ_REMAP_X2APIC_MODE : IRQ_REMAP_XAPIC_MODE;
-- 
1.7.9.5


