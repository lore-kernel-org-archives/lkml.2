Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754370Ab1HKVoT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Aug 2011 17:44:19 -0400
Received: from mga09.intel.com ([134.134.136.24]:63449 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751238Ab1HKVoQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Aug 2011 17:44:16 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,351,1309762800"; 
   d="scan'208";a="36946768"
Message-Id: <20110811213912.954068240@sbsiddha-MOBL3.sc.intel.com>
User-Agent: quilt/0.47-1
Date: Thu, 11 Aug 2011 14:37:52 -0700
From: Suresh Siddha <suresh.b.siddha@intel.com>
To: mingo@elte.hu, tglx@linutronix.de, hpa@zytor.com
Cc: linux-kernel@vger.kernel.org, yinghai@kernel.org, trenn@suse.de,
        rjw@novell.com, lchiquitto@novell.com,
        Suresh Siddha <suresh.b.siddha@intel.com>
Subject: [patch 1/3] x86, kdump, ioapic: reset remote IRR in clear_IO_APIC
Content-Disposition: inline; filename=reset_IRR_in_clear_IO_APIC_pin.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In the kdump scenario mentioned below, we can have a case where the device
using level triggered interrupt will not generate any interrupts in the
kdump kernel.

1. IO-APIC sends a level triggered interrupt to the CPU's local APIC
2. Kernel crashed before the CPU services this interrupt, leaving the remoteIRR
   in the IO-APIC set
3. kdump kernel boot sequence does clear_IO_APIC() as part of IO-APIC
   initialization. But this fails to reset remoteIRR bit of the IO-APIC RTE
   as the remoteIRR bit is read-only.
4. Device using that level triggered entry can't generate any more interrupts
   because of the remoteIRR bit.

In clear_IO_APIC_pin(), check if the remoteIRR bit is set and if so
do an explicit attempt to clear it (by doing EOI write on modern io-apic's
and changing trigger mode to edge/level on older io-apic's).

Fixes: https://bugzilla.novell.com/show_bug.cgi?id=701686   
(in this case megaraid SAS driver is not generating any interrupts in the
 kdump kernel)

Root-caused-by: Thomas Renninger <trenn@suse.de>
Tested-by: Leonardo Chiquitto <lchiquitto@novell.com>
Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: Rafael Wysocki <rjw@novell.com>
---
 arch/x86/kernel/apic/io_apic.c |   38 +++++++++++++++++++++++++++++++++++++-
 1 file changed, 37 insertions(+), 1 deletion(-)

Index: linux-2.6-tip/arch/x86/kernel/apic/io_apic.c
===================================================================
--- linux-2.6-tip.orig/arch/x86/kernel/apic/io_apic.c
+++ linux-2.6-tip/arch/x86/kernel/apic/io_apic.c
@@ -593,10 +593,46 @@ static void clear_IO_APIC_pin(unsigned i
 	entry = ioapic_read_entry(apic, pin);
 	if (entry.delivery_mode == dest_SMI)
 		return;
+
+	/*
+	 * Make sure the entry is masked and re-read the contents to check
+	 * if it is a level triggered pin and if the remoteIRR is set.
+	 */
+	if (!entry.mask) {
+		entry.mask = 1;
+		ioapic_write_entry(apic, pin, entry);
+		entry = ioapic_read_entry(apic, pin);
+	}
+
+	if (entry.trigger & entry.irr) {
+		if (mpc_ioapic_ver(apic) >= 0x20) {
+			unsigned long flags;
+
+			raw_spin_lock_irqsave(&ioapic_lock, flags);
+			io_apic_eoi(apic, entry.vector);
+			raw_spin_unlock_irqrestore(&ioapic_lock, flags);
+		} else {
+			/*
+			 * Mechanism by which we clear remoteIRR in this
+			 * case is by changing the trigger mode to edge and
+			 * back to level.
+			 */
+			entry.trigger = IOAPIC_EDGE;
+			ioapic_write_entry(apic, pin, entry);
+			entry.trigger = IOAPIC_LEVEL;
+			ioapic_write_entry(apic, pin, entry);
+		}
+	}
+
 	/*
-	 * Disable it in the IO-APIC irq-routing table:
+	 * Clear the rest of the bits in the IO-APIC RTE except for the mask
+	 * bit.
 	 */
 	ioapic_mask_entry(apic, pin);
+	entry = ioapic_read_entry(apic, pin);
+	if (entry.irr)
+		printk(KERN_ERR "Unable to reset IRR for apic: %d, pin :%d\n",
+		       mpc_ioapic_id(apic), pin);
 }
 
 static void clear_IO_APIC (void)


