Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754546Ab1GVO0m (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jul 2011 10:26:42 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:41566 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751418Ab1GVO0l (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jul 2011 10:26:41 -0400
Date: Fri, 22 Jul 2011 16:25:55 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] x86/apic changes for v3.1
Message-ID: <20110722142555.GA11616@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest x86-apic-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git x86-apic-for-linus

 Thanks,

	Ingo

------------------>
Naga Chumbalkar (6):
      x86: print APIC data a little later during boot
      x86, ioapic: Format clean up for IOAPIC output
      x86, ioapic: Also print Dest field
      x86, x2apic: Preserve high 32-bits of IA32_APIC_BASE MSR
      x86, ioapic: Print IRTE when IR is enabled
      x86, ioapic: Print IR_IO_APIC_route_entry when IR is enabled


 arch/x86/kernel/apic/apic.c    |    2 +-
 arch/x86/kernel/apic/io_apic.c |   93 ++++++++++++++++++++++++++++-----------
 2 files changed, 68 insertions(+), 27 deletions(-)

diff --git a/arch/x86/kernel/apic/apic.c b/arch/x86/kernel/apic/apic.c
index b9338b8..f7b0c7a 100644
--- a/arch/x86/kernel/apic/apic.c
+++ b/arch/x86/kernel/apic/apic.c
@@ -1429,7 +1429,7 @@ void enable_x2apic(void)
 	rdmsr(MSR_IA32_APICBASE, msr, msr2);
 	if (!(msr & X2APIC_ENABLE)) {
 		printk_once(KERN_INFO "Enabling x2apic\n");
-		wrmsr(MSR_IA32_APICBASE, msr | X2APIC_ENABLE, 0);
+		wrmsr(MSR_IA32_APICBASE, msr | X2APIC_ENABLE, msr2);
 	}
 }
 #endif /* CONFIG_X86_X2APIC */
diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
index e529339..8eb863e 100644
--- a/arch/x86/kernel/apic/io_apic.c
+++ b/arch/x86/kernel/apic/io_apic.c
@@ -1295,6 +1295,16 @@ static int setup_ioapic_entry(int apic_id, int irq,
 		 * irq handler will do the explicit EOI to the io-apic.
 		 */
 		ir_entry->vector = pin;
+
+		apic_printk(APIC_VERBOSE, KERN_DEBUG "IOAPIC[%d]: "
+			"Set IRTE entry (P:%d FPD:%d Dst_Mode:%d "
+			"Redir_hint:%d Trig_Mode:%d Dlvry_Mode:%X "
+			"Avail:%X Vector:%02X Dest:%08X "
+			"SID:%04X SQ:%X SVT:%X)\n",
+			apic_id, irte.present, irte.fpd, irte.dst_mode,
+			irte.redir_hint, irte.trigger_mode, irte.dlvry_mode,
+			irte.avail, irte.vector, irte.dest_id,
+			irte.sid, irte.sq, irte.svt);
 	} else {
 		entry->delivery_mode = apic->irq_delivery_mode;
 		entry->dest_mode = apic->irq_dest_mode;
@@ -1337,9 +1347,9 @@ static void setup_ioapic_irq(int apic_id, int pin, unsigned int irq,
 
 	apic_printk(APIC_VERBOSE,KERN_DEBUG
 		    "IOAPIC[%d]: Set routing entry (%d-%d -> 0x%x -> "
-		    "IRQ %d Mode:%i Active:%i)\n",
+		    "IRQ %d Mode:%i Active:%i Dest:%d)\n",
 		    apic_id, mpc_ioapic_id(apic_id), pin, cfg->vector,
-		    irq, trigger, polarity);
+		    irq, trigger, polarity, dest);
 
 
 	if (setup_ioapic_entry(mpc_ioapic_id(apic_id), irq, &entry,
@@ -1522,10 +1532,12 @@ __apicdebuginit(void) print_IO_APIC(void)
 	printk(KERN_DEBUG ".......    : LTS          : %X\n", reg_00.bits.LTS);
 
 	printk(KERN_DEBUG ".... register #01: %08X\n", *(int *)&reg_01);
-	printk(KERN_DEBUG ".......     : max redirection entries: %04X\n", reg_01.bits.entries);
+	printk(KERN_DEBUG ".......     : max redirection entries: %02X\n",
+		reg_01.bits.entries);
 
 	printk(KERN_DEBUG ".......     : PRQ implemented: %X\n", reg_01.bits.PRQ);
-	printk(KERN_DEBUG ".......     : IO APIC version: %04X\n", reg_01.bits.version);
+	printk(KERN_DEBUG ".......     : IO APIC version: %02X\n",
+		reg_01.bits.version);
 
 	/*
 	 * Some Intel chipsets with IO APIC VERSION of 0x1? don't have reg_02,
@@ -1550,31 +1562,60 @@ __apicdebuginit(void) print_IO_APIC(void)
 
 	printk(KERN_DEBUG ".... IRQ redirection table:\n");
 
-	printk(KERN_DEBUG " NR Dst Mask Trig IRR Pol"
-			  " Stat Dmod Deli Vect:\n");
+	if (intr_remapping_enabled) {
+		printk(KERN_DEBUG " NR Indx Fmt Mask Trig IRR"
+			" Pol Stat Indx2 Zero Vect:\n");
+	} else {
+		printk(KERN_DEBUG " NR Dst Mask Trig IRR Pol"
+			" Stat Dmod Deli Vect:\n");
+	}
 
 	for (i = 0; i <= reg_01.bits.entries; i++) {
-		struct IO_APIC_route_entry entry;
-
-		entry = ioapic_read_entry(apic, i);
-
-		printk(KERN_DEBUG " %02x %03X ",
-			i,
-			entry.dest
-		);
+		if (intr_remapping_enabled) {
+			struct IO_APIC_route_entry entry;
+			struct IR_IO_APIC_route_entry *ir_entry;
+
+			entry = ioapic_read_entry(apic, i);
+			ir_entry = (struct IR_IO_APIC_route_entry *) &entry;
+			printk(KERN_DEBUG " %02x %04X ",
+				i,
+				ir_entry->index
+			);
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
+			entry = ioapic_read_entry(apic, i);
+			printk(KERN_DEBUG " %02x %02X  ",
+				i,
+				entry.dest
+			);
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
@@ -1792,7 +1833,7 @@ __apicdebuginit(int) print_ICs(void)
 	return 0;
 }
 
-fs_initcall(print_ICs);
+late_initcall(print_ICs);
 
 
 /* Where if anywhere is the i8259 connect in external int mode */
