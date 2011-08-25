Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755358Ab1HYTFl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Aug 2011 15:05:41 -0400
Received: from mga01.intel.com ([192.55.52.88]:27799 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755344Ab1HYTFj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Aug 2011 15:05:39 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.68,282,1312182000"; 
   d="scan'208";a="44587368"
Message-Id: <20110825190657.157502602@sbsiddha-desk.sc.intel.com>
User-Agent: quilt/0.48-1
Date: Thu, 25 Aug 2011 12:01:11 -0700
From: Suresh Siddha <suresh.b.siddha@intel.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        trenn@suse.de, suresh.b.siddha@intel.com, rjw@novell.com,
        macro@linux-mips.org, lchiquitto@novell.com, jbeulich@novell.com,
        yinghai@kernel.org
Subject: [patch v2 1/3] x86, kdump, ioapic: reset remote IRR in clear_IO_APIC
References: <20110825190110.255432370@sbsiddha-desk.sc.intel.com>
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
Also before doing the explicit EOI to the io-apic, ensure that the trigger
mode is indeed set to level. This will enable the explicit EOI to the
io-apic to reset the remoteIRR bit.

Fixes: https://bugzilla.novell.com/show_bug.cgi?id=701686   

Root-caused-by: Thomas Renninger <trenn@suse.de>
Tested-by: Leonardo Chiquitto <lchiquitto@novell.com>
Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: Rafael Wysocki <rjw@novell.com>
Cc: Maciej W. Rozycki <macro@linux-mips.org>
---
 arch/x86/kernel/apic/io_apic.c |   48 ++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 47 insertions(+), 1 deletion(-)

Index: linux-2.6-tip/arch/x86/kernel/apic/io_apic.c
===================================================================
--- linux-2.6-tip.orig/arch/x86/kernel/apic/io_apic.c
+++ linux-2.6-tip/arch/x86/kernel/apic/io_apic.c
@@ -593,10 +593,56 @@ static void clear_IO_APIC_pin(unsigned i
 	entry = ioapic_read_entry(apic, pin);
 	if (entry.delivery_mode == dest_SMI)
 		return;
+
 	/*
-	 * Disable it in the IO-APIC irq-routing table:
+	 * Make sure the entry is masked and re-read the contents to check
+	 * if it is a level triggered pin and if the remoteIRR is set.
+	 */
+	if (!entry.mask) {
+		entry.mask = 1;
+		ioapic_write_entry(apic, pin, entry);
+		entry = ioapic_read_entry(apic, pin);
+	}
+
+	if (entry.irr) {
+		/*
+		 * Make sure the trigger mode is set to level. Explicit EOI
+		 * doesn't clear the remoteIRR if the trigger mode is not
+		 * set to level.
+		 */
+		if (!entry.trigger) {
+			entry.trigger = IOAPIC_LEVEL;
+			ioapic_write_entry(apic, pin, entry);
+		}
+
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
+	/*
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


