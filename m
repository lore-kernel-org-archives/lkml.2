Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756532Ab2BAPEa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Feb 2012 10:04:30 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:51007 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754904Ab2BAPE3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Feb 2012 10:04:29 -0500
Date: Wed, 01 Feb 2012 10:05:00 -0500
Message-Id: <87bopi7fxf.fsf@gmail.com>
From: Michael D Labriola <michael.d.labriola@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
CC: "H. Peter Anvin" <hpa@zytor.com>
CC: Michael D Labriola <mlabriol@gdeb.com>
CC: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] x86/reboot: reduce to a single DMI table for reboot quirks
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This commit reduces the X86_32 reboot_dmi_table and the X86_64
pci_reboot_dmi_table into a single table with a single set of functions
(e.g., only 1 call to core_initcall).

The table entries that use set_bios_reboot are grouped together inside a
#define CONFIG_X86_32 block.

Note that there's a single entry that uses set_kbd_reboot, which used to be
available only on X86_32.  This commit moves that entry outside the X86_32
block because it seems it never should have been in there.  There's
multiple places in reboot.c that assume KBD is valid regardless of
X86_32/X86_64.

Signed-off-by: Michael D Labriola <michael.d.labriola@gmail.com>
---
 arch/x86/kernel/reboot.c |  176 ++++++++++++++++++++++------------------------
 1 files changed, 83 insertions(+), 93 deletions(-)

diff --git a/arch/x86/kernel/reboot.c b/arch/x86/kernel/reboot.c
index d840e69..e739737 100644
--- a/arch/x86/kernel/reboot.c
+++ b/arch/x86/kernel/reboot.c
@@ -150,6 +150,80 @@ static int __init set_bios_reboot(const struct dmi_system_id *d)
 	return 0;
 }
 
+extern const unsigned char machine_real_restart_asm[];
+extern const u64 machine_real_restart_gdt[3];
+
+void machine_real_restart(unsigned int type)
+{
+	void *restart_va;
+	unsigned long restart_pa;
+	void (*restart_lowmem)(unsigned int);
+	u64 *lowmem_gdt;
+
+	local_irq_disable();
+
+	/* Write zero to CMOS register number 0x0f, which the BIOS POST
+	   routine will recognize as telling it to do a proper reboot.  (Well
+	   that's what this book in front of me says -- it may only apply to
+	   the Phoenix BIOS though, it's not clear).  At the same time,
+	   disable NMIs by setting the top bit in the CMOS address register,
+	   as we're about to do peculiar things to the CPU.  I'm not sure if
+	   `outb_p' is needed instead of just `outb'.  Use it to be on the
+	   safe side.  (Yes, CMOS_WRITE does outb_p's. -  Paul G.)
+	 */
+	spin_lock(&rtc_lock);
+	CMOS_WRITE(0x00, 0x8f);
+	spin_unlock(&rtc_lock);
+
+	/*
+	 * Switch back to the initial page table.
+	 */
+	load_cr3(initial_page_table);
+
+	/* Write 0x1234 to absolute memory location 0x472.  The BIOS reads
+	   this on booting to tell it to "Bypass memory test (also warm
+	   boot)".  This seems like a fairly standard thing that gets set by
+	   REBOOT.COM programs, and the previous reset routine did this
+	   too. */
+	*((unsigned short *)0x472) = reboot_mode;
+
+	/* Patch the GDT in the low memory trampoline */
+	lowmem_gdt = TRAMPOLINE_SYM(machine_real_restart_gdt);
+
+	restart_va = TRAMPOLINE_SYM(machine_real_restart_asm);
+	restart_pa = virt_to_phys(restart_va);
+	restart_lowmem = (void (*)(unsigned int))restart_pa;
+
+	/* GDT[0]: GDT self-pointer */
+	lowmem_gdt[0] =
+		(u64)(sizeof(machine_real_restart_gdt) - 1) +
+		((u64)virt_to_phys(lowmem_gdt) << 16);
+	/* GDT[1]: 64K real mode code segment */
+	lowmem_gdt[1] =
+		GDT_ENTRY(0x009b, restart_pa, 0xffff);
+
+	/* Jump to the identity-mapped low memory code */
+	restart_lowmem(type);
+}
+#ifdef CONFIG_APM_MODULE
+EXPORT_SYMBOL(machine_real_restart);
+#endif
+
+#endif /* CONFIG_X86_32 */
+
+/*
+ * Some Apple MacBook and MacBookPro's needs reboot=p to be able to reboot
+ */
+static int __init set_pci_reboot(const struct dmi_system_id *d)
+{
+	if (reboot_type != BOOT_CF9) {
+		reboot_type = BOOT_CF9;
+		printk(KERN_INFO "%s series board detected. "
+		       "Selecting PCI-method for reboots.\n", d->ident);
+	}
+	return 0;
+}
+
 static int __init set_kbd_reboot(const struct dmi_system_id *d)
 {
 	if (reboot_type != BOOT_KBD) {
@@ -159,7 +233,11 @@ static int __init set_kbd_reboot(const struct dmi_system_id *d)
 	return 0;
 }
 
+/* This is a single dmi_table handling all reboot quirks.  Note that
+ * REBOOT_BIOS is only available for 32bit
+ */
 static struct dmi_system_id __initdata reboot_dmi_table[] = {
+#ifdef CONFIG_X86_32
 	{	/* Handle problems with rebooting on Dell E520's */
 		.callback = set_bios_reboot,
 		.ident = "Dell E520",
@@ -309,6 +387,8 @@ static struct dmi_system_id __initdata reboot_dmi_table[] = {
 			DMI_MATCH(DMI_BOARD_NAME, "P4S800"),
 		},
 	},
+#endif /* CONFIG_X86_32 */
+
 	{ /* Handle reboot issue on Acer Aspire one */
 		.callback = set_kbd_reboot,
 		.ident = "Acer Aspire One A110",
@@ -317,96 +397,6 @@ static struct dmi_system_id __initdata reboot_dmi_table[] = {
 			DMI_MATCH(DMI_PRODUCT_NAME, "AOA110"),
 		},
 	},
-	{ }
-};
-
-static int __init reboot_init(void)
-{
-	/* Only do the DMI check if reboot_type hasn't been overridden
-	 * on the command line
-	 */
-	if (reboot_default) {
-		dmi_check_system(reboot_dmi_table);
-	}
-	return 0;
-}
-core_initcall(reboot_init);
-
-extern const unsigned char machine_real_restart_asm[];
-extern const u64 machine_real_restart_gdt[3];
-
-void machine_real_restart(unsigned int type)
-{
-	void *restart_va;
-	unsigned long restart_pa;
-	void (*restart_lowmem)(unsigned int);
-	u64 *lowmem_gdt;
-
-	local_irq_disable();
-
-	/* Write zero to CMOS register number 0x0f, which the BIOS POST
-	   routine will recognize as telling it to do a proper reboot.  (Well
-	   that's what this book in front of me says -- it may only apply to
-	   the Phoenix BIOS though, it's not clear).  At the same time,
-	   disable NMIs by setting the top bit in the CMOS address register,
-	   as we're about to do peculiar things to the CPU.  I'm not sure if
-	   `outb_p' is needed instead of just `outb'.  Use it to be on the
-	   safe side.  (Yes, CMOS_WRITE does outb_p's. -  Paul G.)
-	 */
-	spin_lock(&rtc_lock);
-	CMOS_WRITE(0x00, 0x8f);
-	spin_unlock(&rtc_lock);
-
-	/*
-	 * Switch back to the initial page table.
-	 */
-	load_cr3(initial_page_table);
-
-	/* Write 0x1234 to absolute memory location 0x472.  The BIOS reads
-	   this on booting to tell it to "Bypass memory test (also warm
-	   boot)".  This seems like a fairly standard thing that gets set by
-	   REBOOT.COM programs, and the previous reset routine did this
-	   too. */
-	*((unsigned short *)0x472) = reboot_mode;
-
-	/* Patch the GDT in the low memory trampoline */
-	lowmem_gdt = TRAMPOLINE_SYM(machine_real_restart_gdt);
-
-	restart_va = TRAMPOLINE_SYM(machine_real_restart_asm);
-	restart_pa = virt_to_phys(restart_va);
-	restart_lowmem = (void (*)(unsigned int))restart_pa;
-
-	/* GDT[0]: GDT self-pointer */
-	lowmem_gdt[0] =
-		(u64)(sizeof(machine_real_restart_gdt) - 1) +
-		((u64)virt_to_phys(lowmem_gdt) << 16);
-	/* GDT[1]: 64K real mode code segment */
-	lowmem_gdt[1] =
-		GDT_ENTRY(0x009b, restart_pa, 0xffff);
-
-	/* Jump to the identity-mapped low memory code */
-	restart_lowmem(type);
-}
-#ifdef CONFIG_APM_MODULE
-EXPORT_SYMBOL(machine_real_restart);
-#endif
-
-#endif /* CONFIG_X86_32 */
-
-/*
- * Some Apple MacBook and MacBookPro's needs reboot=p to be able to reboot
- */
-static int __init set_pci_reboot(const struct dmi_system_id *d)
-{
-	if (reboot_type != BOOT_CF9) {
-		reboot_type = BOOT_CF9;
-		printk(KERN_INFO "%s series board detected. "
-		       "Selecting PCI-method for reboots.\n", d->ident);
-	}
-	return 0;
-}
-
-static struct dmi_system_id __initdata pci_reboot_dmi_table[] = {
 	{	/* Handle problems with rebooting on Apple MacBook5 */
 		.callback = set_pci_reboot,
 		.ident = "Apple MacBook5",
@@ -474,17 +464,17 @@ static struct dmi_system_id __initdata pci_reboot_dmi_table[] = {
 	{ }
 };
 
-static int __init pci_reboot_init(void)
+static int __init reboot_init(void)
 {
 	/* Only do the DMI check if reboot_type hasn't been overridden
 	 * on the command line
 	 */
 	if (reboot_default) {
-		dmi_check_system(pci_reboot_dmi_table);
+		dmi_check_system(reboot_dmi_table);
 	}
 	return 0;
 }
-core_initcall(pci_reboot_init);
+core_initcall(reboot_init);
 
 static inline void kb_wait(void)
 {
-- 
1.7.1.1

