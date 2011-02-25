Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932853Ab1BYT6d (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Feb 2011 14:58:33 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:40200 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751325Ab1BYT6b (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Feb 2011 14:58:31 -0500
Date: Fri, 25 Feb 2011 20:58:22 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [GIT PULL] x86 fixes
Message-ID: <20110225195822.GA5377@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest x86-fixes-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git x86-fixes-for-linus

 Thanks,

	Ingo

------------------>
Andreas Herrmann (1):
      x86 quirk: Fix polarity for IRQ0 pin2 override on SB800 systems

Jacob Pan (1):
      x86/mrst: Fix apb timer rating when lapic timer is used

Kushal Koolwal (1):
      x86: Fix reboot problem on VersaLogic Menlow boards


 arch/x86/include/asm/acpi.h    |    1 +
 arch/x86/kernel/acpi/boot.c    |   14 ++++++++++----
 arch/x86/kernel/apb_timer.c    |    2 +-
 arch/x86/kernel/early-quirks.c |   16 +++++++---------
 arch/x86/kernel/reboot.c       |    8 ++++++++
 5 files changed, 27 insertions(+), 14 deletions(-)

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
diff --git a/arch/x86/kernel/apb_timer.c b/arch/x86/kernel/apb_timer.c
index 51ef31a..51d4e16 100644
--- a/arch/x86/kernel/apb_timer.c
+++ b/arch/x86/kernel/apb_timer.c
@@ -284,7 +284,7 @@ static int __init apbt_clockevent_register(void)
 	memcpy(&adev->evt, &apbt_clockevent, sizeof(struct clock_event_device));
 
 	if (mrst_timer_options == MRST_TIMER_LAPIC_APBT) {
-		apbt_clockevent.rating = APBT_CLOCKEVENT_RATING - 100;
+		adev->evt.rating = APBT_CLOCKEVENT_RATING - 100;
 		global_clock_event = &adev->evt;
 		printk(KERN_DEBUG "%s clockevent registered as global\n",
 		       global_clock_event->name);
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
diff --git a/arch/x86/kernel/reboot.c b/arch/x86/kernel/reboot.c
index fc7aae1..715037c 100644
--- a/arch/x86/kernel/reboot.c
+++ b/arch/x86/kernel/reboot.c
@@ -285,6 +285,14 @@ static struct dmi_system_id __initdata reboot_dmi_table[] = {
 			DMI_MATCH(DMI_BOARD_NAME, "P4S800"),
 		},
 	},
+	{	/* Handle problems with rebooting on VersaLogic Menlow boards */
+		.callback = set_bios_reboot,
+		.ident = "VersaLogic Menlow based board",
+		.matches = {
+			DMI_MATCH(DMI_BOARD_VENDOR, "VersaLogic Corporation"),
+			DMI_MATCH(DMI_BOARD_NAME, "VersaLogic Menlow board"),
+		},
+	},
 	{ }
 };
 
