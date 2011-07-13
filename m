Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932375Ab1GMDHn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jul 2011 23:07:43 -0400
Received: from hera.kernel.org ([140.211.167.34]:44096 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932349Ab1GMDHl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jul 2011 23:07:41 -0400
Date: Wed, 13 Jul 2011 03:07:29 GMT
From: tip-bot for Naga Chumbalkar <nagananda.chumbalkar@hp.com>
Message-ID: <tip-3040db92ee1b6c5b6b6d73f8cdcad54c0da11563@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        nagananda.chumbalkar@hp.com, tglx@linutronix.de, hpa@linux.intel.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        nagananda.chumbalkar@hp.com, tglx@linutronix.de, hpa@linux.intel.com
In-Reply-To: <20110712211704.2939.71291.sendpatchset@nchumbalkar.americas.cpqcorp.net>
References: <20110712211704.2939.71291.sendpatchset@nchumbalkar.americas.cpqcorp.net>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/apic] x86, ioapic: Print IRTE when IR is enabled
Git-Commit-ID: 3040db92ee1b6c5b6b6d73f8cdcad54c0da11563
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 13 Jul 2011 03:07:34 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  3040db92ee1b6c5b6b6d73f8cdcad54c0da11563
Gitweb:     http://git.kernel.org/tip/3040db92ee1b6c5b6b6d73f8cdcad54c0da11563
Author:     Naga Chumbalkar <nagananda.chumbalkar@hp.com>
AuthorDate: Tue, 12 Jul 2011 21:17:41 +0000
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Tue, 12 Jul 2011 14:34:00 -0700

x86, ioapic: Print IRTE when IR is enabled

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
Link: http://lkml.kernel.org/r/20110712211704.2939.71291.sendpatchset@nchumbalkar.americas.cpqcorp.net
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/kernel/apic/io_apic.c |   10 ++++++++++
 1 files changed, 10 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
index 5cba200..1ed5cbb 100644
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
