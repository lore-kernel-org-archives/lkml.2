Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932397Ab1GMDnW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jul 2011 23:43:22 -0400
Received: from hera.kernel.org ([140.211.167.34]:45163 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932360Ab1GMDnV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jul 2011 23:43:21 -0400
Date: Wed, 13 Jul 2011 03:42:58 GMT
From: tip-bot for Naga Chumbalkar <nagananda.chumbalkar@hp.com>
Message-ID: <tip-42f0efc5aae2bd7e3bc420c0902c7024ef77391f@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        nagananda.chumbalkar@hp.com, tglx@linutronix.de, hpa@linux.intel.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        nagananda.chumbalkar@hp.com, tglx@linutronix.de, hpa@linux.intel.com
In-Reply-To: <20110712211658.2939.93123.sendpatchset@nchumbalkar.americas.cpqcorp.net>
References: <20110712211658.2939.93123.sendpatchset@nchumbalkar.americas.cpqcorp.net>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/apic] x86, ioapic: Print IR_IO_APIC_route_entry when IR is enabled
Git-Commit-ID: 42f0efc5aae2bd7e3bc420c0902c7024ef77391f
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 13 Jul 2011 03:43:03 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  42f0efc5aae2bd7e3bc420c0902c7024ef77391f
Gitweb:     http://git.kernel.org/tip/42f0efc5aae2bd7e3bc420c0902c7024ef77391f
Author:     Naga Chumbalkar <nagananda.chumbalkar@hp.com>
AuthorDate: Tue, 12 Jul 2011 21:17:35 +0000
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Tue, 12 Jul 2011 20:17:58 -0700

x86, ioapic: Print IR_IO_APIC_route_entry when IR is enabled

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
 01 000F 1   0    0    0   0   0    0     0    01
 02 0001 1   0    0    0   0   0    0     0    02
 03 0002 1   1    0    0   0   0    0     0    03
 04 0011 1   1    0    0   0   0    0     0    04
 05 0004 1   1    0    0   0   0    0     0    05
 06 0005 1   1    0    0   0   0    0     0    06
...

Signed-off-by: Naga Chumbalkar <nagananda.chumbalkar@hp.com>
Link: http://lkml.kernel.org/r/20110712211658.2939.93123.sendpatchset@nchumbalkar.americas.cpqcorp.net
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/kernel/apic/io_apic.c |   71 ++++++++++++++++++++++++++++------------
 1 files changed, 50 insertions(+), 21 deletions(-)

diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
index 1ed5cbb..8eb863e 100644
--- a/arch/x86/kernel/apic/io_apic.c
+++ b/arch/x86/kernel/apic/io_apic.c
@@ -1562,31 +1562,60 @@ __apicdebuginit(void) print_IO_APIC(void)
 
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
-		printk(KERN_DEBUG " %02x %02X  ",
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
