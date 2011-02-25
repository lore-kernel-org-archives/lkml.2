Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932193Ab1BYIxM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Feb 2011 03:53:12 -0500
Received: from hera.kernel.org ([140.211.167.34]:51887 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753901Ab1BYIxK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Feb 2011 03:53:10 -0500
Date: Fri, 25 Feb 2011 08:52:36 GMT
From: tip-bot for Andreas Herrmann <andreas.herrmann3@amd.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        manoj.iyer@canonical.com, andreas.herrmann3@amd.com,
        andre.przywara@amd.com, tglx@linutronix.de, mingo@elte.hu,
        borislav.petkov@amd.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        manoj.iyer@canonical.com, andreas.herrmann3@amd.com,
        andre.przywara@amd.com, tglx@linutronix.de, mingo@elte.hu,
        borislav.petkov@amd.com
In-Reply-To: <20110224145346.GD3658@alberich.amd.com>
References: <20110224145346.GD3658@alberich.amd.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86 quirk: Fix polarity for IRQ0 pin2 override on SB800 systems
Message-ID: <tip-7f74f8f28a2bd9db9404f7d364e2097a0c42cc12@git.kernel.org>
Git-Commit-ID: 7f74f8f28a2bd9db9404f7d364e2097a0c42cc12
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 25 Feb 2011 08:52:38 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  7f74f8f28a2bd9db9404f7d364e2097a0c42cc12
Gitweb:     http://git.kernel.org/tip/7f74f8f28a2bd9db9404f7d364e2097a0c42cc12
Author:     Andreas Herrmann <andreas.herrmann3@amd.com>
AuthorDate: Thu, 24 Feb 2011 15:53:46 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 24 Feb 2011 20:30:21 +0100

x86 quirk: Fix polarity for IRQ0 pin2 override on SB800 systems

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
Cc: stable@kernel.org # 37.x, 32.x
LKML-Reference: <20110224145346.GD3658@alberich.amd.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/include/asm/acpi.h    |    1 +
 arch/x86/kernel/acpi/boot.c    |   14 ++++++++++----
 arch/x86/kernel/early-quirks.c |   16 +++++++---------
 3 files changed, 18 insertions(+), 13 deletions(-)

diff --git a/arch/x86/include/asm/acpi.h b/arch/x86/include/asm/acpi.h
index 211ca3f..4ea15ca 100644
--- a/arch/x86/include/asm/acpi.h
+++ b/arch/x86/include/asm/acpi.h
@@ -88,6 +88,7 @@ extern int acpi_disabled;
 extern int acpi_pci_disabled;
 extern int acpi_skip_timer_override;
 extern int acpi_use_timer_override;
+extern int acpi_fix_pin2_polarity;
 
 extern u8 acpi_sci_flags;
 extern int acpi_sci_override_gsi;
diff --git a/arch/x86/kernel/acpi/boot.c b/arch/x86/kernel/acpi/boot.c
index b3a7113..3e6e2d6 100644
--- a/arch/x86/kernel/acpi/boot.c
+++ b/arch/x86/kernel/acpi/boot.c
@@ -72,6 +72,7 @@ u8 acpi_sci_flags __initdata;
 int acpi_sci_override_gsi __initdata;
 int acpi_skip_timer_override __initdata;
 int acpi_use_timer_override __initdata;
+int acpi_fix_pin2_polarity __initdata;
 
 #ifdef CONFIG_X86_LOCAL_APIC
 static u64 acpi_lapic_addr __initdata = APIC_DEFAULT_PHYS_BASE;
@@ -415,10 +416,15 @@ acpi_parse_int_src_ovr(struct acpi_subtable_header * header,
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
diff --git a/arch/x86/kernel/early-quirks.c b/arch/x86/kernel/early-quirks.c
index 76b8cd9..9efbdcc 100644
--- a/arch/x86/kernel/early-quirks.c
+++ b/arch/x86/kernel/early-quirks.c
@@ -143,15 +143,10 @@ static void __init ati_bugs(int num, int slot, int func)
 
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
@@ -160,13 +155,16 @@ static void __init ati_bugs_contd(int num, int slot, int func)
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
