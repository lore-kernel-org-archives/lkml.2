Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752170Ab1GLFDc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jul 2011 01:03:32 -0400
Received: from g6t0184.atlanta.hp.com ([15.193.32.61]:45763 "EHLO
	g6t0184.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751965Ab1GLFD2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jul 2011 01:03:28 -0400
From: Naga Chumbalkar <nagananda.chumbalkar@hp.com>
To: x86@kernel.org
Cc: Naga Chumbalkar <nagananda.chumbalkar@hp.com>, hpa@zytor.com,
        tglx@linutronix.de, mingo@elte.hu, linux-kernel@vger.kernel.org
Message-Id: <20110712050250.2462.98285.sendpatchset@nchumbalkar.americas.cpqcorp.net>
In-Reply-To: <20110712050244.2462.51826.sendpatchset@nchumbalkar.americas.cpqcorp.net>
References: <20110712050244.2462.51826.sendpatchset@nchumbalkar.americas.cpqcorp.net>
Subject: [PATCH 1/2] x86, ioapic: Print IR_IO_APIC_route_entry when IR is enabled
Date: Tue, 12 Jul 2011 05:03:26 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When IR (interrupt remapping) is enabled print_IO_APIC() displays output according
to legacy RTE (redirection table entry) definitons:

 NR Dst Mask Trig IRR Pol Stat Dmod Deli Vect:
 00 00  1    0    0   0   0    0    0    00
 01 00  0    0    0   0   0    0    0    01
 02 00  0    0    0   0   0    0    0    02
 03 00  1    0    0   0   0    0    0    03
 04 00  1    0    0   0   0    0    0    04
 05 00  1    0    0   0   0    0    0    05
 06 00  1    0    0   0   0    0    0    06
...

The above output is as per Sec 3.2.4 of the IOAPIC datasheet:
82093AA I/O Advanced Programmable Interrupt Controller (IOAPIC):
http://download.intel.com/design/chipsets/datashts/29056601.pdf

Instead the output should display the fields as discussed in Sec 5.5.1
of the VT-d specification:

(Intel Virtualization Technology for Directed I/O:
http://download.intel.com/technology/computing/vptech/Intel(r)_VT_for_Direct_IO.pdf)

After the fix:
 NR Indx Fmt Mask Trig IRR Pol Stat Indx2 Zero Vect:
 00 0000 0   1    0    0   0   0    0     0    00
 NR Indx Fmt Mask Trig IRR Pol Stat Indx2 Zero Vect:
 01 000F 1   0    0    0   0   0    0     0    01
 NR Indx Fmt Mask Trig IRR Pol Stat Indx2 Zero Vect:
 02 0001 1   0    0    0   0   0    0     0    02
 NR Indx Fmt Mask Trig IRR Pol Stat Indx2 Zero Vect:
 03 0002 1   1    0    0   0   0    0     0    03
 NR Indx Fmt Mask Trig IRR Pol Stat Indx2 Zero Vect:
 04 0011 1   1    0    0   0   0    0     0    04
 NR Indx Fmt Mask Trig IRR Pol Stat Indx2 Zero Vect:
 05 0004 1   1    0    0   0   0    0     0    05
 NR Indx Fmt Mask Trig IRR Pol Stat Indx2 Zero Vect:
 06 0005 1   1    0    0   0   0    0     0    06
...

Signed-off-by: Naga Chumbalkar <nagananda.chumbalkar@hp.com>

---
 arch/x86/kernel/apic/io_apic.c |   75 ++++++++++++++++++++++++++++------------
 1 files changed, 53 insertions(+), 22 deletions(-)

diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
index 5cba200..3b139aa 100644
--- a/arch/x86/kernel/apic/io_apic.c
+++ b/arch/x86/kernel/apic/io_apic.c
@@ -1552,31 +1552,62 @@ __apicdebuginit(void) print_IO_APIC(void)
 
 	printk(KERN_DEBUG ".... IRQ redirection table:\n");
 
-	printk(KERN_DEBUG " NR Dst Mask Trig IRR Pol"
-			  " Stat Dmod Deli Vect:\n");
-
 	for (i = 0; i <= reg_01.bits.entries; i++) {
-		struct IO_APIC_route_entry entry;
-
-		entry = ioapic_read_entry(apic, i);
-
-		printk(KERN_DEBUG " %02x %02X  ",
-			i,
-			entry.dest
-		);
+		if (intr_remapping_enabled) {
+			struct IO_APIC_route_entry entry;
+			struct IR_IO_APIC_route_entry *ir_entry;
+
+			printk(KERN_DEBUG " NR Indx Fmt Mask Trig IRR"
+				" Pol Stat Indx2 Zero Vect:\n");
+
+			entry = ioapic_read_entry(apic, i);
+			ir_entry = (struct IR_IO_APIC_route_entry *) &entry;
+
+			printk(KERN_DEBUG " %02x %04X ",
+				i,
+				ir_entry->index
+			);
+
+			printk("%1d   %1d    %1d    %1d   %1d   "
+				"%1d    %1d     %X    %02X\n",
+				ir_entry->format,
+				ir_entry->mask,
+				ir_entry->trigger,
+				ir_entry->irr,
+				ir_entry->polarity,
+				ir_entry->delivery_status,
+				ir_entry->index2,
+				ir_entry->zero,
+				ir_entry->vector
+			);
+		} else {
+			struct IO_APIC_route_entry entry;
 
-		printk("%1d    %1d    %1d   %1d   %1d    %1d    %1d    %02X\n",
-			entry.mask,
-			entry.trigger,
-			entry.irr,
-			entry.polarity,
-			entry.delivery_status,
-			entry.dest_mode,
-			entry.delivery_mode,
-			entry.vector
-		);
+			printk(KERN_DEBUG " NR Dst Mask Trig IRR Pol"
+				" Stat Dmod Deli Vect:\n");
+
+			entry = ioapic_read_entry(apic, i);
+
+			printk(KERN_DEBUG " %02x %02X  ",
+				i,
+				entry.dest
+			);
+
+			printk("%1d    %1d    %1d   %1d   %1d    "
+				"%1d    %1d    %02X\n",
+				entry.mask,
+				entry.trigger,
+				entry.irr,
+				entry.polarity,
+				entry.delivery_status,
+				entry.dest_mode,
+				entry.delivery_mode,
+				entry.vector
+			);
+		}
 	}
 	}
+
 	printk(KERN_DEBUG "IRQ to pin mappings:\n");
 	for_each_active_irq(irq) {
 		struct irq_pin_list *entry;
-- 
1.7.1

