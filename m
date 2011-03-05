Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760714Ab1CEBOi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Mar 2011 20:14:38 -0500
Received: from kroah.org ([198.145.64.141]:50233 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760363Ab1CEBAO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Mar 2011 20:00:14 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Fri Mar  4 16:56:37 2011
Message-Id: <20110305005637.327705973@clark.kroah.org>
User-Agent: quilt/0.48-11.2
Date: Fri, 04 Mar 2011 16:55:33 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Andreas Herrmann <andreas.herrmann3@amd.com>,
        Borislav Petkov <borislav.petkov@amd.com>, Ingo Molnar <mingo@elte.hu>
Subject: [28/73] x86 quirk: Fix polarity for IRQ0 pin2 override on SB800 systems
In-Reply-To: <20110305005720.GA16162@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.37-stable review patch.  If anyone has any objections, please let us know.

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
Cc: Borislav Petkov <borislav.petkov@amd.com>
LKML-Reference: <20110224145346.GD3658@alberich.amd.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/x86/include/asm/acpi.h    |    1 +
 arch/x86/kernel/acpi/boot.c    |   14 ++++++++++----
 arch/x86/kernel/early-quirks.c |   16 +++++++---------
 3 files changed, 18 insertions(+), 13 deletions(-)

--- a/arch/x86/include/asm/acpi.h
+++ b/arch/x86/include/asm/acpi.h
@@ -88,6 +88,7 @@ extern int acpi_disabled;
 extern int acpi_pci_disabled;
 extern int acpi_skip_timer_override;
 extern int acpi_use_timer_override;
+extern int acpi_fix_pin2_polarity;
 
 extern u8 acpi_sci_flags;
 extern int acpi_sci_override_gsi;
--- a/arch/x86/kernel/acpi/boot.c
+++ b/arch/x86/kernel/acpi/boot.c
@@ -72,6 +72,7 @@ u8 acpi_sci_flags __initdata;
 int acpi_sci_override_gsi __initdata;
 int acpi_skip_timer_override __initdata;
 int acpi_use_timer_override __initdata;
+int acpi_fix_pin2_polarity __initdata;
 
 #ifdef CONFIG_X86_LOCAL_APIC
 static u64 acpi_lapic_addr __initdata = APIC_DEFAULT_PHYS_BASE;
@@ -410,10 +411,15 @@ acpi_parse_int_src_ovr(struct acpi_subta
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
--- a/arch/x86/kernel/early-quirks.c
+++ b/arch/x86/kernel/early-quirks.c
@@ -143,15 +143,10 @@ static void __init ati_bugs(int num, int
 
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
@@ -160,13 +155,16 @@ static void __init ati_bugs_contd(int nu
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


