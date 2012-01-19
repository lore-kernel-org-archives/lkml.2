Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932791Ab2ASTfA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jan 2012 14:35:00 -0500
Received: from mx1.gd-ms.com ([153.11.250.40]:38440 "EHLO mx1.gd-ms.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932675Ab2ASTe7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jan 2012 14:34:59 -0500
In-Reply-To: <4F186C62.6000606@zytor.com>
References: <OF70B406E9.8D4A6789-ON85257988.0052C104-85257988.0053DE1E@gdeb.com>	<20120117195841.48fe8236@pyramind.ukuu.org.uk> <OFD4BB6876.6D903346-ON8525798A.00550E62-8525798A.005562A3@gdeb.com> <20120119154504.710e202e@pyramind.ukuu.org.uk> <OF8642E997.5ED041E1-ON8525798A.0056983A-8525798A.0056E05B@LocalDomain> <OF2B909250.6078896E-ON8525798A.0058FF49-8525798A.0061AEA1@gdeb.com> <4F18584F.7060603@zytor.com> <OFE1B368BB.B6249713-ON8525798A.00692513-8525798A.0069B44E@gdeb.com> <4F186C62.6000606@zytor.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Kushal Koolwal <kushalkoolwal@gmail.com>, linux-kernel@vger.kernel.org,
        michael.d.labriola@gmail.com, Ingo Molnar <mingo@elte.hu>,
        Matthew Garrett <mjg59@srcf.ucam.org>, support@versalogic.com,
        Thomas Gleixner <tglx@linutronix.de>, x86@kernel.org
MIME-Version: 1.0
Subject: Re: [PATCH] x86, reboot: skip DMI checks if reboot set by user
X-KeepSent: DCB45687:59B41E0E-8525798A:006AB19B;
 type=4; name=$KeepSent
Message-ID: <OFDCB45687.59B41E0E-ON8525798A.006AB19B-8525798A.006B8F71@gdeb.com>
From: Michael D Labriola <mlabriol@gdeb.com>
Date: Thu, 19 Jan 2012 14:34:48 -0500
X-GDMEncrypt: FALSE
X-GDMMarking: NOT_SENSITIVE
Content-Type: text/plain; charset="US-ASCII"
X-GDM-EVAL: score: /30; hits: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

H. Peter Anvin" <hpa@zytor.com> wrote on 01/19/2012 02:17:54 PM:

> On 01/19/2012 11:14 AM, Michael D Labriola wrote:
> >>
> >> Yes, and such a patch would be appreciated.
> >>
> >> The reason it is as it is dates back to before the 32-64 bit 
> >> unification, as far as I know.
> >>
> >> (BIOS reboot is currently not supported on 64 bits, mainly.)
> > 
> > Well, that does complicate it a bit.  I'll gin something up and see 
what
> > you think.  I guess it will involve having an #ifdef CONFIG_X86_32 
block
> > inside a single dmi_table structure for the BIOS quirks.
> > 
> > Actually, set_kbd_reboot is inside the current X86_32 only block, 
along
> > with the one DMI callback that uses it.  Is this correct?
> > 
> 
> Probably not, although I suspect most of the users of that are 32-bit
> only systems.

How does this look?  The patch looks kinda nasty because of how much code
is getting moved around...  Basically, all I did was move the reboot_init
method and reboot_dmi_table out of the X86_32 block they were in, put the
quirks that set BIOS reboot inside an X86_32 define block, and then added
all the PCI quirks into the new, single DMI table.  I did also move the
set_kbd_reboot method out of the X86_32 block, since all the
documentation I've run into in the kernel suggests that it's valid for
X86_64 as well.

I even tested it by adding an entry to reboot_dmi_table for my machine
and verified that behavior is the same as before the reorg.

Note that this patch got generated from my test tree, so it'll have
conflicts if applied against v3.2.  I'll rebase it and weed that stuff
out if you think it's a good idea.

diff --git a/arch/x86/kernel/reboot.c b/arch/x86/kernel/reboot.c
index d840e69..e739737 100644
--- a/arch/x86/kernel/reboot.c
+++ b/arch/x86/kernel/reboot.c
@@ -150,6 +150,80 @@ static int __init set_bios_reboot(const struct 
dmi_system_id *d)
        return 0;
 }
 
+extern const unsigned char machine_real_restart_asm[];
+extern const u64 machine_real_restart_gdt[3];
+
+void machine_real_restart(unsigned int type)
+{
+       void *restart_va;
+       unsigned long restart_pa;
+       void (*restart_lowmem)(unsigned int);
+       u64 *lowmem_gdt;
+
+       local_irq_disable();
+
+       /* Write zero to CMOS register number 0x0f, which the BIOS POST
+          routine will recognize as telling it to do a proper reboot. 
(Well
+          that's what this book in front of me says -- it may only apply 
to
+          the Phoenix BIOS though, it's not clear).  At the same time,
+          disable NMIs by setting the top bit in the CMOS address 
register,
+          as we're about to do peculiar things to the CPU.  I'm not sure 
if
+          `outb_p' is needed instead of just `outb'.  Use it to be on the
+          safe side.  (Yes, CMOS_WRITE does outb_p's. -  Paul G.)
+        */
+       spin_lock(&rtc_lock);
+       CMOS_WRITE(0x00, 0x8f);
+       spin_unlock(&rtc_lock);
+
+       /*
+        * Switch back to the initial page table.
+        */
+       load_cr3(initial_page_table);
+
+       /* Write 0x1234 to absolute memory location 0x472.  The BIOS reads
+          this on booting to tell it to "Bypass memory test (also warm
+          boot)".  This seems like a fairly standard thing that gets set 
by
+          REBOOT.COM programs, and the previous reset routine did this
+          too. */
+       *((unsigned short *)0x472) = reboot_mode;
+
+       /* Patch the GDT in the low memory trampoline */
+       lowmem_gdt = TRAMPOLINE_SYM(machine_real_restart_gdt);
+
+       restart_va = TRAMPOLINE_SYM(machine_real_restart_asm);
+       restart_pa = virt_to_phys(restart_va);
+       restart_lowmem = (void (*)(unsigned int))restart_pa;
+
+       /* GDT[0]: GDT self-pointer */
+       lowmem_gdt[0] =
+               (u64)(sizeof(machine_real_restart_gdt) - 1) +
+               ((u64)virt_to_phys(lowmem_gdt) << 16);
+       /* GDT[1]: 64K real mode code segment */
+       lowmem_gdt[1] =
+               GDT_ENTRY(0x009b, restart_pa, 0xffff);
+
+       /* Jump to the identity-mapped low memory code */
+       restart_lowmem(type);
+}
+#ifdef CONFIG_APM_MODULE
+EXPORT_SYMBOL(machine_real_restart);
+#endif
+
+#endif /* CONFIG_X86_32 */
+
+/*
+ * Some Apple MacBook and MacBookPro's needs reboot=p to be able to 
reboot
+ */
+static int __init set_pci_reboot(const struct dmi_system_id *d)
+{
+       if (reboot_type != BOOT_CF9) {
+               reboot_type = BOOT_CF9;
+               printk(KERN_INFO "%s series board detected. "
+                      "Selecting PCI-method for reboots.\n", d->ident);
+       }
+       return 0;
+}
+
 static int __init set_kbd_reboot(const struct dmi_system_id *d)
 {
        if (reboot_type != BOOT_KBD) {
@@ -159,7 +233,11 @@ static int __init set_kbd_reboot(const struct 
dmi_system_id *d)
        return 0;
 }
 
+/* This is a single dmi_table handling all reboot quirks.  Note that
+ * REBOOT_BIOS is only available for 32bit
+ */
 static struct dmi_system_id __initdata reboot_dmi_table[] = {
+#ifdef CONFIG_X86_32
        {       /* Handle problems with rebooting on Dell E520's */
                .callback = set_bios_reboot,
                .ident = "Dell E520",
@@ -309,6 +387,8 @@ static struct dmi_system_id __initdata 
reboot_dmi_table[] = {
                        DMI_MATCH(DMI_BOARD_NAME, "P4S800"),
                },
        },
+#endif /* CONFIG_X86_32 */
+
        { /* Handle reboot issue on Acer Aspire one */
                .callback = set_kbd_reboot,
                .ident = "Acer Aspire One A110",
@@ -317,96 +397,6 @@ static struct dmi_system_id __initdata 
reboot_dmi_table[] = {
                        DMI_MATCH(DMI_PRODUCT_NAME, "AOA110"),
                },
        },
-       { }
-};
-
-static int __init reboot_init(void)
-{
-       /* Only do the DMI check if reboot_type hasn't been overridden
-        * on the command line
-        */
-       if (reboot_default) {
-               dmi_check_system(reboot_dmi_table);
-       }
-       return 0;
-}
-core_initcall(reboot_init);
-
-extern const unsigned char machine_real_restart_asm[];
-extern const u64 machine_real_restart_gdt[3];
-
-void machine_real_restart(unsigned int type)
-{
-       void *restart_va;
-       unsigned long restart_pa;
-       void (*restart_lowmem)(unsigned int);
-       u64 *lowmem_gdt;
-
-       local_irq_disable();
-
-       /* Write zero to CMOS register number 0x0f, which the BIOS POST
-          routine will recognize as telling it to do a proper reboot. 
(Well
-          that's what this book in front of me says -- it may only apply 
to
-          the Phoenix BIOS though, it's not clear).  At the same time,
-          disable NMIs by setting the top bit in the CMOS address 
register,
-          as we're about to do peculiar things to the CPU.  I'm not sure 
if
-          `outb_p' is needed instead of just `outb'.  Use it to be on the
-          safe side.  (Yes, CMOS_WRITE does outb_p's. -  Paul G.)
-        */
-       spin_lock(&rtc_lock);
-       CMOS_WRITE(0x00, 0x8f);
-       spin_unlock(&rtc_lock);
-
-       /*
-        * Switch back to the initial page table.
-        */
-       load_cr3(initial_page_table);
-
-       /* Write 0x1234 to absolute memory location 0x472.  The BIOS reads
-          this on booting to tell it to "Bypass memory test (also warm
-          boot)".  This seems like a fairly standard thing that gets set 
by
-          REBOOT.COM programs, and the previous reset routine did this
-          too. */
-       *((unsigned short *)0x472) = reboot_mode;
-
-       /* Patch the GDT in the low memory trampoline */
-       lowmem_gdt = TRAMPOLINE_SYM(machine_real_restart_gdt);
-
-       restart_va = TRAMPOLINE_SYM(machine_real_restart_asm);
-       restart_pa = virt_to_phys(restart_va);
-       restart_lowmem = (void (*)(unsigned int))restart_pa;
-
-       /* GDT[0]: GDT self-pointer */
-       lowmem_gdt[0] =
-               (u64)(sizeof(machine_real_restart_gdt) - 1) +
-               ((u64)virt_to_phys(lowmem_gdt) << 16);
-       /* GDT[1]: 64K real mode code segment */
-       lowmem_gdt[1] =
-               GDT_ENTRY(0x009b, restart_pa, 0xffff);
-
-       /* Jump to the identity-mapped low memory code */
-       restart_lowmem(type);
-}
-#ifdef CONFIG_APM_MODULE
-EXPORT_SYMBOL(machine_real_restart);
-#endif
-
-#endif /* CONFIG_X86_32 */
-
-/*
- * Some Apple MacBook and MacBookPro's needs reboot=p to be able to 
reboot
- */
-static int __init set_pci_reboot(const struct dmi_system_id *d)
-{
-       if (reboot_type != BOOT_CF9) {
-               reboot_type = BOOT_CF9;
-               printk(KERN_INFO "%s series board detected. "
-                      "Selecting PCI-method for reboots.\n", d->ident);
-       }
-       return 0;
-}
-
-static struct dmi_system_id __initdata pci_reboot_dmi_table[] = {
        {       /* Handle problems with rebooting on Apple MacBook5 */
                .callback = set_pci_reboot,
                .ident = "Apple MacBook5",
@@ -474,17 +464,17 @@ static struct dmi_system_id __initdata 
pci_reboot_dmi_table[] = {
        { }
 };
 
-static int __init pci_reboot_init(void)
+static int __init reboot_init(void)
 {
        /* Only do the DMI check if reboot_type hasn't been overridden
         * on the command line
         */
        if (reboot_default) {
-               dmi_check_system(pci_reboot_dmi_table);
+               dmi_check_system(reboot_dmi_table);
        }
        return 0;
 }
-core_initcall(pci_reboot_init);
+core_initcall(reboot_init);
 
 static inline void kb_wait(void)
 {



