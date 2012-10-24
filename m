Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935444Ab2JXTnj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2012 15:43:39 -0400
Received: from mail-da0-f46.google.com ([209.85.210.46]:64231 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935311Ab2JXTnd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2012 15:43:33 -0400
Date: Wed, 24 Oct 2012 12:43:30 -0700
From: Jonathan Nieder <jrnieder@gmail.com>
To: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Greg KH <gregkh@linuxfoundation.org>, linbao.zhang@hp.com,
        "Eric W. Biederman" <ebiederm@xmission.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH 3/3] x86, ioapic: Move nr_ioapic_registers calculation to
 mp_register_ioapic.
Message-ID: <20121024194330.GF3120@elie.Belkin>
References: <1351102644.6017.72.camel@sbsiddha-desk.sc.intel.com>
 <20121024182546.GB3338@elie.Belkin>
 <1351103872.6017.80.camel@sbsiddha-desk.sc.intel.com>
 <20121024194114.GC3120@elie.Belkin>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121024194114.GC3120@elie.Belkin>
User-Agent: Mutt/1.5.21+51 (9e756d1adb76) (2011-07-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Eric W. Biederman" <ebiederm@xmission.com>
Date: Tue, 30 Mar 2010 01:07:12 -0700

commit 7716a5c4ff5f1f3dc5e9edcab125cbf7fceef0af upstream.

Now that all ioapic registration happens in mp_register_ioapic we can
move the calculation of nr_ioapic_registers there from enable_IO_APIC.
The number of ioapic registers is already calucated in mp_register_ioapic
so all that really needs to be done is to save the caluclated value
in nr_ioapic_registers.

[suresh.b.siddha@intel.com: backport to 2.6.32.y and 2.6.34.y:

 Lin Bao reported that one of the HP platforms failed to boot
 2.6.32 kernel, when the BIOS enabled interrupt-remapping and
 x2apic before handing over the control to the Linux kernel.

 During boot, Linux kernel masks all the interrupt sources
 (8259, IO-APIC RTE's), setup the interrupt-remapping hardware
 with the OS controlled table and unmasks the 8259 interrupts
 but not the IO-APIC RTE's (as the newly setup interrupt-remapping
 table and the IO-APIC RTE's are not yet programmed by the kernel).

 Shortly after this, IO-APIC RTE's and the interrupt-remapping table
 entries are programmed based on the ACPI tables etc. So the
 expectation is that any interrupt during this window will be dropped
 and not see the intermediate configuration.

 In the reported problematic case, BIOS has configured the IO-APIC
 in virtual wire-B mode. Between the window of the kernel setting up
 new interrupt-remapping table  and the IO-APIC RTE's are properly
 configured, an interrupt gets routed by the IO-APIC RTE (setup
 by the virtual wire-B configuration) and sees the empty
 interrupt-remapping table entry, resulting in vt-d fault causing
 the platform to generate NMI. And the OS panics on this unexpected NMI.

 This problem doesn't happen with more recent kernels and closer
 look at the 2.6.32 kernel shows that the code which masks
 the IO-APIC RTE's is not working as expected as the nr_ioapic_registers
 for each IO-APIC is not yet initialized at this point. In the later
 kernels we initialize nr_ioapic_registers much before and
 everything works as expected.]

[jrnieder@gmail.com: include removal of nr_ioapic_registers calculation
 from enable_IO_APIC() to complete the backport]

Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
LKML-Reference: <1269936436-7039-11-git-send-email-ebiederm@xmission.com>
Signed-off-by: H. Peter Anvin <hpa@zytor.com>
Reported-by: Zhang, Lin-Bao <linbao.zhang@hp.com>
Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
Signed-off-by: Jonathan Nieder <jrnieder@gmail.com>
---
 arch/x86/kernel/apic/io_apic.c | 22 ++++++++--------------
 1 file changed, 8 insertions(+), 14 deletions(-)

diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
index 7a5087640599..6b7d97f1f5e5 100644
--- a/arch/x86/kernel/apic/io_apic.c
+++ b/arch/x86/kernel/apic/io_apic.c
@@ -1945,20 +1945,8 @@ static struct { int pin, apic; } ioapic_i8259 = { -1, -1 };
 
 void __init enable_IO_APIC(void)
 {
-	union IO_APIC_reg_01 reg_01;
 	int i8259_apic, i8259_pin;
 	int apic;
-	unsigned long flags;
-
-	/*
-	 * The number of IO-APIC IRQ registers (== #pins):
-	 */
-	for (apic = 0; apic < nr_ioapics; apic++) {
-		spin_lock_irqsave(&ioapic_lock, flags);
-		reg_01.raw = io_apic_read(apic, 1);
-		spin_unlock_irqrestore(&ioapic_lock, flags);
-		nr_ioapic_registers[apic] = reg_01.bits.entries+1;
-	}
 
 	if (!nr_legacy_irqs)
 		return;
@@ -4265,6 +4253,7 @@ static int bad_ioapic(unsigned long address)
 void __init mp_register_ioapic(int id, u32 address, u32 gsi_base)
 {
 	int idx = 0;
+	int entries;
 
 	if (bad_ioapic(address))
 		return;
@@ -4283,9 +4272,14 @@ void __init mp_register_ioapic(int id, u32 address, u32 gsi_base)
 	 * Build basic GSI lookup table to facilitate gsi->io_apic lookups
 	 * and to prevent reprogramming of IOAPIC pins (PCI GSIs).
 	 */
+	entries = io_apic_get_redir_entries(idx);
 	mp_gsi_routing[idx].gsi_base = gsi_base;
-	mp_gsi_routing[idx].gsi_end = gsi_base +
-	    io_apic_get_redir_entries(idx);
+	mp_gsi_routing[idx].gsi_end = gsi_base + entries;
+
+	/*
+	 * The number of IO-APIC IRQ registers (== #pins):
+	 */
+	nr_ioapic_registers[idx] = entries + 1;
 
 	if (mp_gsi_routing[idx].gsi_end > gsi_end)
 		gsi_end = mp_gsi_routing[idx].gsi_end;
-- 
1.8.0

