Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752549Ab1GLFDg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jul 2011 01:03:36 -0400
Received: from g4t0016.houston.hp.com ([15.201.24.19]:4480 "EHLO
	g4t0016.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751965Ab1GLFDe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jul 2011 01:03:34 -0400
From: Naga Chumbalkar <nagananda.chumbalkar@hp.com>
To: x86@kernel.org
Cc: linux-kernel@vger.kernel.org,
        Naga Chumbalkar <nagananda.chumbalkar@hp.com>, mingo@elte.hu,
        tglx@linutronix.de, hpa@zytor.com
Message-Id: <20110712050256.2462.90160.sendpatchset@nchumbalkar.americas.cpqcorp.net>
In-Reply-To: <20110712050244.2462.51826.sendpatchset@nchumbalkar.americas.cpqcorp.net>
References: <20110712050244.2462.51826.sendpatchset@nchumbalkar.americas.cpqcorp.net>
Subject: [PATCH 2/2] x86, ioapic: Print IRTE when IR is enabled
Date: Tue, 12 Jul 2011 05:03:32 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When "apic=debug" is used as a boot parameter, Linux prints the IOAPIC routing
entries in "dmesg". Below is output from IOAPIC whose apic_id is 8:

# dmesg | grep "routing entry"
IOAPIC[8]: Set routing entry (8-1 -> 0x31 -> IRQ 1 Mode:0 Active:0 Dest:0)
IOAPIC[8]: Set routing entry (8-2 -> 0x30 -> IRQ 0 Mode:0 Active:0 Dest:0)
IOAPIC[8]: Set routing entry (8-3 -> 0x33 -> IRQ 3 Mode:0 Active:0 Dest:0)
...

Similarly, when IR (interrupt remapping) is enabled, and the IRTE
(interrupt remapping table entry) is set up we should display it.

After the fix:

# dmesg | grep IRTE
IOAPIC[8]: Set IRTE entry (P:1 FPD:0 Dst_Mode:0 Redir_hint:1 Trig_Mode:0 Dlvry_Mode:0 Avail:0 Vector:31 Dest:00000000 SID:00F1 SQ:0 SVT:1)
IOAPIC[8]: Set IRTE entry (P:1 FPD:0 Dst_Mode:0 Redir_hint:1 Trig_Mode:0 Dlvry_Mode:0 Avail:0 Vector:30 Dest:00000000 SID:00F1 SQ:0 SVT:1)
IOAPIC[8]: Set IRTE entry (P:1 FPD:0 Dst_Mode:0 Redir_hint:1 Trig_Mode:0 Dlvry_Mode:0 Avail:0 Vector:33 Dest:00000000 SID:00F1 SQ:0 SVT:1)
...

The IRTE is defined in Sec 9.5 of the Intel VT-d Specification.

Signed-off-by: Naga Chumbalkar <nagananda.chumbalkar@hp.com>

---
 arch/x86/kernel/apic/io_apic.c |   10 ++++++++++
 1 files changed, 10 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
index 3b139aa..c9bf3a5 100644
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
-- 
1.7.1

