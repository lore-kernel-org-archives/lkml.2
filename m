Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964979Ab1C3ViR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 17:38:17 -0400
Received: from mga09.intel.com ([134.134.136.24]:61829 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964897Ab1C3VIR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 17:08:17 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.63,270,1299484800"; 
   d="scan'208";a="621237694"
From: Andi Kleen <andi@firstfloor.org>
References: <20110330203.501921634@firstfloor.org>
In-Reply-To: <20110330203.501921634@firstfloor.org>
To: andreas.herrmann3@amd.com, manoj.iyer@canonical.com,
        andre.przywara@amd.com, ak@linux.intel.com, borislav.petkov@amd.com,
        mingo@elte.hu, gregkh@suse.de, linux-kernel@vger.kernel.org,
        stable@kernel.org, tim.bird@am.sony.com
Subject: [PATCH] [153/275] x86 quirk: Fix polarity for IRQ0 pin2 override on SB800 systems
Message-Id: <20110330210634.C5E9F3E1A05@tassilo.jf.intel.com>
Date: Wed, 30 Mar 2011 14:06:34 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------
From: Andreas Herrmann <andreas.herrmann3@amd.com>

commit 7f74f8f28a2bd9db9404f7d364e2097a0c42cc12 upstream.

On some SB800 systems polarity for IOAPIC pin2 is wrongly
specified as low active by BIOS. This caused system hangs after
resume from S3 when HPET was used in one-shot mode on such
systems because a timer interrupt was missed (HPET signal is
high active).

For more details see:

  http://marc.info/?l=linux-kernel&m=129623757413868

Tested-by: Manoj Iyer <manoj.iyer@canonical.com>
Tested-by: Andre Przywara <andre.przywara@amd.com>
Signed-off-by: Andreas Herrmann <andreas.herrmann3@amd.com>
Signed-off-by: Andi Kleen <ak@linux.intel.com>
Cc: Borislav Petkov <borislav.petkov@amd.com>
LKML-Reference: <20110224145346.GD3658@alberich.amd.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/x86/include/asm/acpi.h    |    1 +
 arch/x86/kernel/acpi/boot.c    |   14 ++++++++++----
 arch/x86/kernel/early-quirks.c |   16 +++++++---------
 3 files changed, 18 insertions(+), 13 deletions(-)

Index: linux-2.6.35.y/arch/x86/include/asm/acpi.h
===================================================================
--- linux-2.6.35.y.orig/arch/x86/include/asm/acpi.h	2011-03-29 22:51:04.914597417 -0700
+++ linux-2.6.35.y/arch/x86/include/asm/acpi.h	2011-03-29 23:03:01.000000000 -0700
@@ -88,6 +88,7 @@
 extern int acpi_pci_disabled;
 extern int acpi_skip_timer_override;
 extern int acpi_use_timer_override;
+extern int acpi_fix_pin2_polarity;
 
 extern u8 acpi_sci_flags;
 extern int acpi_sci_override_gsi;
Index: linux-2.6.35.y/arch/x86/kernel/acpi/boot.c
===================================================================
--- linux-2.6.35.y.orig/arch/x86/kernel/acpi/boot.c	2011-03-29 22:51:04.914597417 -0700
+++ linux-2.6.35.y/arch/x86/kernel/acpi/boot.c	2011-03-29 23:03:01.000000000 -0700
@@ -72,6 +72,7 @@
 int acpi_sci_override_gsi __initdata;
 int acpi_skip_timer_override __initdata;
 int acpi_use_timer_override __initdata;
+int acpi_fix_pin2_polarity __initdata;
 
 #ifdef CONFIG_X86_LOCAL_APIC
 static u64 acpi_lapic_addr __initdata = APIC_DEFAULT_PHYS_BASE;
@@ -410,10 +411,15 @@
 		return 0;
 	}
 
-	if (acpi_skip_timer_override &&
-	    intsrc->source_irq == 0 && intsrc->global_irq == 2) {
-		printk(PREFIX "BIOS IRQ0 pin2 override ignored.\n");
-		return 0;
+	if (intsrc->source_irq == 0 && intsrc->global_irq == 2) {
+		if (acpi_skip_timer_override) {
+			printk(PREFIX "BIOS IRQ0 pin2 override ignored.\n");
+			return 0;
+		}
+		if (acpi_fix_pin2_polarity && (intsrc->inti_flags & ACPI_MADT_POLARITY_MASK)) {
+			intsrc->inti_flags &= ~ACPI_MADT_POLARITY_MASK;
+			printk(PREFIX "BIOS IRQ0 pin2 override: forcing polarity to high active.\n");
+		}
 	}
 
 	mp_override_legacy_irq(intsrc->source_irq,
Index: linux-2.6.35.y/arch/x86/kernel/early-quirks.c
===================================================================
--- linux-2.6.35.y.orig/arch/x86/kernel/early-quirks.c	2011-03-29 22:51:04.914597417 -0700
+++ linux-2.6.35.y/arch/x86/kernel/early-quirks.c	2011-03-29 23:54:13.604654318 -0700
@@ -145,15 +145,10 @@
 
 static u32 __init ati_sbx00_rev(int num, int slot, int func)
 {
-	u32 old, d;
+	u32 d;
 
-	d = read_pci_config(num, slot, func, 0x70);
-	old = d;
-	d &= ~(1<<8);
-	write_pci_config(num, slot, func, 0x70, d);
 	d = read_pci_config(num, slot, func, 0x8);
 	d &= 0xff;
-	write_pci_config(num, slot, func, 0x70, old);
 
 	return d;
 }
@@ -162,13 +157,16 @@
 {
 	u32 d, rev;
 
-	if (acpi_use_timer_override)
-		return;
-
 	rev = ati_sbx00_rev(num, slot, func);
+	if (rev >= 0x40)
+		acpi_fix_pin2_polarity = 1;
+
 	if (rev > 0x13)
 		return;
 
+	if (acpi_use_timer_override)
+		return;
+
 	/* check for IRQ0 interrupt swap */
 	d = read_pci_config(num, slot, func, 0x64);
 	if (!(d & (1<<14)))
