Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933425Ab2EWL30 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2012 07:29:26 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:63201 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932302Ab2EWL3Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2012 07:29:24 -0400
Date: Wed, 23 May 2012 13:29:16 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>, Don Zickus <dzickus@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] x86/reboot changes for v3.5
Message-ID: <20120523112915.GA19944@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest x86-reboot-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git x86-reboot-for-linus

   HEAD: 3aac27aba79b7c52e709ef6de0f7d8139caedc01 x86/reboot: Update nonmi_ipi parameter

The biggest change is a gentler method of rebooting/stopping via 
IRQs first and then via NMIs. There are several cleanups in the 
tree as well.

 Thanks,

	Ingo

------------------>
Don Zickus (3):
      Revert "x86, reboot: Use NMI instead of REBOOT_VECTOR to stop cpus"
      x86/reboot: Use NMI to assist in shutting down if IRQ fails
      x86/reboot: Update nonmi_ipi parameter

He Chunhui (1):
      x86, boot: Fix port argument to inl() function

Michael D Labriola (2):
      x86/reboot: Reduce to a single DMI table for reboot quirks
      x86/reboot: Clean up coding style


 arch/x86/boot/boot.h     |   2 +-
 arch/x86/kernel/reboot.c | 277 ++++++++++++++++++++++++-----------------------
 arch/x86/kernel/smp.c    | 100 ++++++++---------
 3 files changed, 186 insertions(+), 193 deletions(-)

diff --git a/arch/x86/boot/boot.h b/arch/x86/boot/boot.h
index c7093bd..18997e5 100644
--- a/arch/x86/boot/boot.h
+++ b/arch/x86/boot/boot.h
@@ -67,7 +67,7 @@ static inline void outl(u32 v, u16 port)
 {
 	asm volatile("outl %0,%1" : : "a" (v), "dN" (port));
 }
-static inline u32 inl(u32 port)
+static inline u32 inl(u16 port)
 {
 	u32 v;
 	asm volatile("inl %1,%0" : "=a" (v) : "dN" (port));
diff --git a/arch/x86/kernel/reboot.c b/arch/x86/kernel/reboot.c
index d840e69..77215c2 100644
--- a/arch/x86/kernel/reboot.c
+++ b/arch/x86/kernel/reboot.c
@@ -39,7 +39,8 @@ static int reboot_mode;
 enum reboot_type reboot_type = BOOT_ACPI;
 int reboot_force;
 
-/* This variable is used privately to keep track of whether or not
+/*
+ * This variable is used privately to keep track of whether or not
  * reboot_type is still set to its default value (i.e., reboot= hasn't
  * been set on the command line).  This is needed so that we can
  * suppress DMI scanning for reboot quirks.  Without it, it's
@@ -51,7 +52,8 @@ static int reboot_default = 1;
 static int reboot_cpu = -1;
 #endif
 
-/* This is set if we need to go through the 'emergency' path.
+/*
+ * This is set if we need to go through the 'emergency' path.
  * When machine_emergency_restart() is called, we may be on
  * an inconsistent state and won't be able to do a clean cleanup
  */
@@ -60,22 +62,24 @@ static int reboot_emergency;
 /* This is set by the PCI code if either type 1 or type 2 PCI is detected */
 bool port_cf9_safe = false;
 
-/* reboot=b[ios] | s[mp] | t[riple] | k[bd] | e[fi] [, [w]arm | [c]old] | p[ci]
-   warm   Don't set the cold reboot flag
-   cold   Set the cold reboot flag
-   bios   Reboot by jumping through the BIOS (only for X86_32)
-   smp    Reboot by executing reset on BSP or other CPU (only for X86_32)
-   triple Force a triple fault (init)
-   kbd    Use the keyboard controller. cold reset (default)
-   acpi   Use the RESET_REG in the FADT
-   efi    Use efi reset_system runtime service
-   pci    Use the so-called "PCI reset register", CF9
-   force  Avoid anything that could hang.
+/*
+ * reboot=b[ios] | s[mp] | t[riple] | k[bd] | e[fi] [, [w]arm | [c]old] | p[ci]
+ * warm   Don't set the cold reboot flag
+ * cold   Set the cold reboot flag
+ * bios   Reboot by jumping through the BIOS (only for X86_32)
+ * smp    Reboot by executing reset on BSP or other CPU (only for X86_32)
+ * triple Force a triple fault (init)
+ * kbd    Use the keyboard controller. cold reset (default)
+ * acpi   Use the RESET_REG in the FADT
+ * efi    Use efi reset_system runtime service
+ * pci    Use the so-called "PCI reset register", CF9
+ * force  Avoid anything that could hang.
  */
 static int __init reboot_setup(char *str)
 {
 	for (;;) {
-		/* Having anything passed on the command line via
+		/*
+		 * Having anything passed on the command line via
 		 * reboot= will cause us to disable DMI checking
 		 * below.
 		 */
@@ -98,9 +102,11 @@ static int __init reboot_setup(char *str)
 				if (isdigit(*(str+2)))
 					reboot_cpu = reboot_cpu*10 + (int)(*(str+2) - '0');
 			}
-				/* we will leave sorting out the final value
-				   when we are ready to reboot, since we might not
-				   have detected BSP APIC ID or smp_num_cpu */
+			/*
+			 * We will leave sorting out the final value
+			 * when we are ready to reboot, since we might not
+			 * have detected BSP APIC ID or smp_num_cpu
+			 */
 			break;
 #endif /* CONFIG_SMP */
 
@@ -150,6 +156,82 @@ static int __init set_bios_reboot(const struct dmi_system_id *d)
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
+	/*
+	 * Write zero to CMOS register number 0x0f, which the BIOS POST
+	 * routine will recognize as telling it to do a proper reboot.  (Well
+	 * that's what this book in front of me says -- it may only apply to
+	 * the Phoenix BIOS though, it's not clear).  At the same time,
+	 * disable NMIs by setting the top bit in the CMOS address register,
+	 * as we're about to do peculiar things to the CPU.  I'm not sure if
+	 * `outb_p' is needed instead of just `outb'.  Use it to be on the
+	 * safe side.  (Yes, CMOS_WRITE does outb_p's. -  Paul G.)
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
+	/*
+	 * Write 0x1234 to absolute memory location 0x472.  The BIOS reads
+	 * this on booting to tell it to "Bypass memory test (also warm
+	 * boot)".  This seems like a fairly standard thing that gets set by
+	 * REBOOT.COM programs, and the previous reset routine did this
+	 * too. */
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
@@ -159,7 +241,12 @@ static int __init set_kbd_reboot(const struct dmi_system_id *d)
 	return 0;
 }
 
+/*
+ * This is a single dmi_table handling all reboot quirks.  Note that
+ * REBOOT_BIOS is only available for 32bit
+ */
 static struct dmi_system_id __initdata reboot_dmi_table[] = {
+#ifdef CONFIG_X86_32
 	{	/* Handle problems with rebooting on Dell E520's */
 		.callback = set_bios_reboot,
 		.ident = "Dell E520",
@@ -184,7 +271,7 @@ static struct dmi_system_id __initdata reboot_dmi_table[] = {
 			DMI_MATCH(DMI_PRODUCT_NAME, "PowerEdge 300/"),
 		},
 	},
-	{       /* Handle problems with rebooting on Dell Optiplex 745's SFF*/
+	{	/* Handle problems with rebooting on Dell Optiplex 745's SFF */
 		.callback = set_bios_reboot,
 		.ident = "Dell OptiPlex 745",
 		.matches = {
@@ -192,7 +279,7 @@ static struct dmi_system_id __initdata reboot_dmi_table[] = {
 			DMI_MATCH(DMI_PRODUCT_NAME, "OptiPlex 745"),
 		},
 	},
-	{       /* Handle problems with rebooting on Dell Optiplex 745's DFF*/
+	{	/* Handle problems with rebooting on Dell Optiplex 745's DFF */
 		.callback = set_bios_reboot,
 		.ident = "Dell OptiPlex 745",
 		.matches = {
@@ -201,7 +288,7 @@ static struct dmi_system_id __initdata reboot_dmi_table[] = {
 			DMI_MATCH(DMI_BOARD_NAME, "0MM599"),
 		},
 	},
-	{       /* Handle problems with rebooting on Dell Optiplex 745 with 0KW626 */
+	{	/* Handle problems with rebooting on Dell Optiplex 745 with 0KW626 */
 		.callback = set_bios_reboot,
 		.ident = "Dell OptiPlex 745",
 		.matches = {
@@ -210,7 +297,7 @@ static struct dmi_system_id __initdata reboot_dmi_table[] = {
 			DMI_MATCH(DMI_BOARD_NAME, "0KW626"),
 		},
 	},
-	{   /* Handle problems with rebooting on Dell Optiplex 330 with 0KP561 */
+	{	/* Handle problems with rebooting on Dell Optiplex 330 with 0KP561 */
 		.callback = set_bios_reboot,
 		.ident = "Dell OptiPlex 330",
 		.matches = {
@@ -219,7 +306,7 @@ static struct dmi_system_id __initdata reboot_dmi_table[] = {
 			DMI_MATCH(DMI_BOARD_NAME, "0KP561"),
 		},
 	},
-	{   /* Handle problems with rebooting on Dell Optiplex 360 with 0T656F */
+	{	/* Handle problems with rebooting on Dell Optiplex 360 with 0T656F */
 		.callback = set_bios_reboot,
 		.ident = "Dell OptiPlex 360",
 		.matches = {
@@ -228,7 +315,7 @@ static struct dmi_system_id __initdata reboot_dmi_table[] = {
 			DMI_MATCH(DMI_BOARD_NAME, "0T656F"),
 		},
 	},
-	{	/* Handle problems with rebooting on Dell OptiPlex 760 with 0G919G*/
+	{	/* Handle problems with rebooting on Dell OptiPlex 760 with 0G919G */
 		.callback = set_bios_reboot,
 		.ident = "Dell OptiPlex 760",
 		.matches = {
@@ -301,7 +388,7 @@ static struct dmi_system_id __initdata reboot_dmi_table[] = {
 			DMI_MATCH(DMI_PRODUCT_NAME, "SBC-FITPC2"),
 		},
 	},
-	{       /* Handle problems with rebooting on ASUS P4S800 */
+	{	/* Handle problems with rebooting on ASUS P4S800 */
 		.callback = set_bios_reboot,
 		.ident = "ASUS P4S800",
 		.matches = {
@@ -309,7 +396,9 @@ static struct dmi_system_id __initdata reboot_dmi_table[] = {
 			DMI_MATCH(DMI_BOARD_NAME, "P4S800"),
 		},
 	},
-	{ /* Handle reboot issue on Acer Aspire one */
+#endif /* CONFIG_X86_32 */
+
+	{	/* Handle reboot issue on Acer Aspire one */
 		.callback = set_kbd_reboot,
 		.ident = "Acer Aspire One A110",
 		.matches = {
@@ -317,96 +406,6 @@ static struct dmi_system_id __initdata reboot_dmi_table[] = {
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
@@ -474,17 +473,17 @@ static struct dmi_system_id __initdata pci_reboot_dmi_table[] = {
 	{ }
 };
 
-static int __init pci_reboot_init(void)
+static int __init reboot_init(void)
 {
-	/* Only do the DMI check if reboot_type hasn't been overridden
+	/*
+	 * Only do the DMI check if reboot_type hasn't been overridden
 	 * on the command line
 	 */
-	if (reboot_default) {
-		dmi_check_system(pci_reboot_dmi_table);
-	}
+	if (reboot_default)
+		dmi_check_system(reboot_dmi_table);
 	return 0;
 }
-core_initcall(pci_reboot_init);
+core_initcall(reboot_init);
 
 static inline void kb_wait(void)
 {
@@ -502,14 +501,14 @@ static void vmxoff_nmi(int cpu, struct pt_regs *regs)
 	cpu_emergency_vmxoff();
 }
 
-/* Use NMIs as IPIs to tell all CPUs to disable virtualization
- */
+/* Use NMIs as IPIs to tell all CPUs to disable virtualization */
 static void emergency_vmx_disable_all(void)
 {
 	/* Just make sure we won't change CPUs while doing this */
 	local_irq_disable();
 
-	/* We need to disable VMX on all CPUs before rebooting, otherwise
+	/*
+	 * We need to disable VMX on all CPUs before rebooting, otherwise
 	 * we risk hanging up the machine, because the CPU ignore INIT
 	 * signals when VMX is enabled.
 	 *
@@ -528,8 +527,7 @@ static void emergency_vmx_disable_all(void)
 	 * is still enabling VMX.
 	 */
 	if (cpu_has_vmx() && cpu_vmx_enabled()) {
-		/* Disable VMX on this CPU.
-		 */
+		/* Disable VMX on this CPU. */
 		cpu_vmxoff();
 
 		/* Halt and disable VMX on the other CPUs */
@@ -574,12 +572,12 @@ static void native_machine_emergency_restart(void)
 		/* Could also try the reset bit in the Hammer NB */
 		switch (reboot_type) {
 		case BOOT_KBD:
-			mach_reboot_fixups(); /* for board specific fixups */
+			mach_reboot_fixups(); /* For board specific fixups */
 
 			for (i = 0; i < 10; i++) {
 				kb_wait();
 				udelay(50);
-				outb(0xfe, 0x64); /* pulse reset low */
+				outb(0xfe, 0x64); /* Pulse reset low */
 				udelay(50);
 			}
 			if (attempt == 0 && orig_reboot_type == BOOT_ACPI) {
@@ -621,7 +619,7 @@ static void native_machine_emergency_restart(void)
 
 		case BOOT_CF9:
 			port_cf9_safe = true;
-			/* fall through */
+			/* Fall through */
 
 		case BOOT_CF9_COND:
 			if (port_cf9_safe) {
@@ -659,7 +657,8 @@ void native_machine_shutdown(void)
 	/* Make certain I only run on the appropriate processor */
 	set_cpus_allowed_ptr(current, cpumask_of(reboot_cpu_id));
 
-	/* O.K Now that I'm on the appropriate processor,
+	/*
+	 * O.K Now that I'm on the appropriate processor,
 	 * stop all of the others.
 	 */
 	stop_other_cpus();
@@ -697,12 +696,11 @@ static void native_machine_restart(char *__unused)
 
 static void native_machine_halt(void)
 {
-	/* stop other cpus and apics */
+	/* Stop other cpus and apics */
 	machine_shutdown();
 
 	tboot_shutdown(TB_SHUTDOWN_HALT);
 
-	/* stop this cpu */
 	stop_this_cpu(NULL);
 }
 
@@ -713,7 +711,7 @@ static void native_machine_power_off(void)
 			machine_shutdown();
 		pm_power_off();
 	}
-	/* a fallback in case there is no PM info available */
+	/* A fallback in case there is no PM info available */
 	tboot_shutdown(TB_SHUTDOWN_HALT);
 }
 
@@ -775,7 +773,8 @@ static int crash_nmi_callback(unsigned int val, struct pt_regs *regs)
 
 	cpu = raw_smp_processor_id();
 
-	/* Don't do anything if this handler is invoked on crashing cpu.
+	/*
+	 * Don't do anything if this handler is invoked on crashing cpu.
 	 * Otherwise, system will completely hang. Crashing cpu can get
 	 * an NMI if system was initially booted with nmi_watchdog parameter.
 	 */
@@ -799,7 +798,8 @@ static void smp_send_nmi_allbutself(void)
 	apic->send_IPI_allbutself(NMI_VECTOR);
 }
 
-/* Halt all other CPUs, calling the specified function on each of them
+/*
+ * Halt all other CPUs, calling the specified function on each of them
  *
  * This function can be used to halt all other CPUs on crash
  * or emergency reboot time. The function passed as parameter
@@ -810,7 +810,7 @@ void nmi_shootdown_cpus(nmi_shootdown_cb callback)
 	unsigned long msecs;
 	local_irq_disable();
 
-	/* Make a note of crashing cpu. Will be used in NMI callback.*/
+	/* Make a note of crashing cpu. Will be used in NMI callback. */
 	crashing_cpu = safe_smp_processor_id();
 
 	shootdown_callback = callback;
@@ -819,8 +819,9 @@ void nmi_shootdown_cpus(nmi_shootdown_cb callback)
 	/* Would it be better to replace the trap vector here? */
 	if (register_nmi_handler(NMI_LOCAL, crash_nmi_callback,
 				 NMI_FLAG_FIRST, "crash"))
-		return;		/* return what? */
-	/* Ensure the new callback function is set before sending
+		return;		/* Return what? */
+	/*
+	 * Ensure the new callback function is set before sending
 	 * out the NMI
 	 */
 	wmb();
diff --git a/arch/x86/kernel/smp.c b/arch/x86/kernel/smp.c
index 66c74f4..48d2b7d 100644
--- a/arch/x86/kernel/smp.c
+++ b/arch/x86/kernel/smp.c
@@ -109,6 +109,9 @@
  *	about nothing of note with C stepping upwards.
  */
 
+static atomic_t stopping_cpu = ATOMIC_INIT(-1);
+static bool smp_no_nmi_ipi = false;
+
 /*
  * this function sends a 'reschedule' IPI to another CPU.
  * it goes straight through and wastes no time serializing
@@ -149,8 +152,6 @@ void native_send_call_func_ipi(const struct cpumask *mask)
 	free_cpumask_var(allbutself);
 }
 
-static atomic_t stopping_cpu = ATOMIC_INIT(-1);
-
 static int smp_stop_nmi_callback(unsigned int val, struct pt_regs *regs)
 {
 	/* We are registered on stopping cpu too, avoid spurious NMI */
@@ -162,7 +163,19 @@ static int smp_stop_nmi_callback(unsigned int val, struct pt_regs *regs)
 	return NMI_HANDLED;
 }
 
-static void native_nmi_stop_other_cpus(int wait)
+/*
+ * this function calls the 'stop' function on all other CPUs in the system.
+ */
+
+asmlinkage void smp_reboot_interrupt(void)
+{
+	ack_APIC_irq();
+	irq_enter();
+	stop_this_cpu(NULL);
+	irq_exit();
+}
+
+static void native_stop_other_cpus(int wait)
 {
 	unsigned long flags;
 	unsigned long timeout;
@@ -174,20 +187,25 @@ static void native_nmi_stop_other_cpus(int wait)
 	 * Use an own vector here because smp_call_function
 	 * does lots of things not suitable in a panic situation.
 	 */
+
+	/*
+	 * We start by using the REBOOT_VECTOR irq.
+	 * The irq is treated as a sync point to allow critical
+	 * regions of code on other cpus to release their spin locks
+	 * and re-enable irqs.  Jumping straight to an NMI might
+	 * accidentally cause deadlocks with further shutdown/panic
+	 * code.  By syncing, we give the cpus up to one second to
+	 * finish their work before we force them off with the NMI.
+	 */
 	if (num_online_cpus() > 1) {
 		/* did someone beat us here? */
 		if (atomic_cmpxchg(&stopping_cpu, -1, safe_smp_processor_id()) != -1)
 			return;
 
-		if (register_nmi_handler(NMI_LOCAL, smp_stop_nmi_callback,
-					 NMI_FLAG_FIRST, "smp_stop"))
-			/* Note: we ignore failures here */
-			return;
-
-		/* sync above data before sending NMI */
+		/* sync above data before sending IRQ */
 		wmb();
 
-		apic->send_IPI_allbutself(NMI_VECTOR);
+		apic->send_IPI_allbutself(REBOOT_VECTOR);
 
 		/*
 		 * Don't wait longer than a second if the caller
@@ -197,63 +215,37 @@ static void native_nmi_stop_other_cpus(int wait)
 		while (num_online_cpus() > 1 && (wait || timeout--))
 			udelay(1);
 	}
+	
+	/* if the REBOOT_VECTOR didn't work, try with the NMI */
+	if ((num_online_cpus() > 1) && (!smp_no_nmi_ipi))  {
+		if (register_nmi_handler(NMI_LOCAL, smp_stop_nmi_callback,
+					 NMI_FLAG_FIRST, "smp_stop"))
+			/* Note: we ignore failures here */
+			/* Hope the REBOOT_IRQ is good enough */
+			goto finish;
 
-	local_irq_save(flags);
-	disable_local_APIC();
-	local_irq_restore(flags);
-}
-
-/*
- * this function calls the 'stop' function on all other CPUs in the system.
- */
-
-asmlinkage void smp_reboot_interrupt(void)
-{
-	ack_APIC_irq();
-	irq_enter();
-	stop_this_cpu(NULL);
-	irq_exit();
-}
-
-static void native_irq_stop_other_cpus(int wait)
-{
-	unsigned long flags;
-	unsigned long timeout;
+		/* sync above data before sending IRQ */
+		wmb();
 
-	if (reboot_force)
-		return;
+		pr_emerg("Shutting down cpus with NMI\n");
 
-	/*
-	 * Use an own vector here because smp_call_function
-	 * does lots of things not suitable in a panic situation.
-	 * On most systems we could also use an NMI here,
-	 * but there are a few systems around where NMI
-	 * is problematic so stay with an non NMI for now
-	 * (this implies we cannot stop CPUs spinning with irq off
-	 * currently)
-	 */
-	if (num_online_cpus() > 1) {
-		apic->send_IPI_allbutself(REBOOT_VECTOR);
+		apic->send_IPI_allbutself(NMI_VECTOR);
 
 		/*
-		 * Don't wait longer than a second if the caller
+		 * Don't wait longer than a 10 ms if the caller
 		 * didn't ask us to wait.
 		 */
-		timeout = USEC_PER_SEC;
+		timeout = USEC_PER_MSEC * 10;
 		while (num_online_cpus() > 1 && (wait || timeout--))
 			udelay(1);
 	}
 
+finish:
 	local_irq_save(flags);
 	disable_local_APIC();
 	local_irq_restore(flags);
 }
 
-static void native_smp_disable_nmi_ipi(void)
-{
-	smp_ops.stop_other_cpus = native_irq_stop_other_cpus;
-}
-
 /*
  * Reschedule call back.
  */
@@ -287,8 +279,8 @@ void smp_call_function_single_interrupt(struct pt_regs *regs)
 
 static int __init nonmi_ipi_setup(char *str)
 {
-        native_smp_disable_nmi_ipi();
-        return 1;
+	smp_no_nmi_ipi = true;
+	return 1;
 }
 
 __setup("nonmi_ipi", nonmi_ipi_setup);
@@ -298,7 +290,7 @@ struct smp_ops smp_ops = {
 	.smp_prepare_cpus	= native_smp_prepare_cpus,
 	.smp_cpus_done		= native_smp_cpus_done,
 
-	.stop_other_cpus	= native_nmi_stop_other_cpus,
+	.stop_other_cpus	= native_stop_other_cpus,
 	.smp_send_reschedule	= native_smp_send_reschedule,
 
 	.cpu_up			= native_cpu_up,
