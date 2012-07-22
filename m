Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752056Ab2GVOK0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jul 2012 10:10:26 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:58356 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751772Ab2GVOKZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jul 2012 10:10:25 -0400
Date: Sun, 22 Jul 2012 16:10:19 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] x86/reboot changes for v3.6
Message-ID: <20120722141019.GA8542@gmail.com>
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

   HEAD: 9751d7627582fc1cc64625d63bde9528c14f1544 x86-64, reboot: Be more paranoid in 64-bit reboot=bios

Now that the revampted x86 real-mode trampoline code is upstream 
and seems to be working well, we can extend the 64-bit reboot 
code to be as capable as the 32-bit one.

 Thanks,

	Ingo

------------------>
H. Peter Anvin (3):
      x86-64, reboot: Allow reboot=bios and reboot-cpu override on x86-64
      x86, reboot: Drop redundant write of reboot_mode
      x86-64, reboot: Be more paranoid in 64-bit reboot=bios


 arch/x86/include/asm/emergency-restart.h       |    2 -
 arch/x86/include/asm/realmode.h                |    3 +-
 arch/x86/include/asm/reboot.h                  |    4 +-
 arch/x86/kernel/reboot.c                       |   60 ++++++++++--------------
 arch/x86/realmode/rm/Makefile                  |    2 +-
 arch/x86/realmode/rm/header.S                  |    4 +-
 arch/x86/realmode/rm/{reboot_32.S => reboot.S} |   30 ++++++++++--
 7 files changed, 59 insertions(+), 46 deletions(-)
 rename arch/x86/realmode/rm/{reboot_32.S => reboot.S} (85%)

diff --git a/arch/x86/include/asm/emergency-restart.h b/arch/x86/include/asm/emergency-restart.h
index cc70c1c..75ce3f4 100644
--- a/arch/x86/include/asm/emergency-restart.h
+++ b/arch/x86/include/asm/emergency-restart.h
@@ -4,9 +4,7 @@
 enum reboot_type {
 	BOOT_TRIPLE = 't',
 	BOOT_KBD = 'k',
-#ifdef CONFIG_X86_32
 	BOOT_BIOS = 'b',
-#endif
 	BOOT_ACPI = 'a',
 	BOOT_EFI = 'e',
 	BOOT_CF9 = 'p',
diff --git a/arch/x86/include/asm/realmode.h b/arch/x86/include/asm/realmode.h
index fce3f4a..fe1ec5b 100644
--- a/arch/x86/include/asm/realmode.h
+++ b/arch/x86/include/asm/realmode.h
@@ -21,8 +21,9 @@ struct real_mode_header {
 	u32	wakeup_header;
 #endif
 	/* APM/BIOS reboot */
-#ifdef CONFIG_X86_32
 	u32	machine_real_restart_asm;
+#ifdef CONFIG_X86_64
+	u32	machine_real_restart_seg;
 #endif
 };
 
diff --git a/arch/x86/include/asm/reboot.h b/arch/x86/include/asm/reboot.h
index 92f29706..a82c4f1 100644
--- a/arch/x86/include/asm/reboot.h
+++ b/arch/x86/include/asm/reboot.h
@@ -18,8 +18,8 @@ extern struct machine_ops machine_ops;
 
 void native_machine_crash_shutdown(struct pt_regs *regs);
 void native_machine_shutdown(void);
-void machine_real_restart(unsigned int type);
-/* These must match dispatch_table in reboot_32.S */
+void __noreturn machine_real_restart(unsigned int type);
+/* These must match dispatch in arch/x86/realmore/rm/reboot.S */
 #define MRR_BIOS	0
 #define MRR_APM		1
 
diff --git a/arch/x86/kernel/reboot.c b/arch/x86/kernel/reboot.c
index 25b48ed..6ef559f 100644
--- a/arch/x86/kernel/reboot.c
+++ b/arch/x86/kernel/reboot.c
@@ -20,14 +20,12 @@
 #include <asm/virtext.h>
 #include <asm/cpu.h>
 #include <asm/nmi.h>
+#include <asm/smp.h>
 
-#ifdef CONFIG_X86_32
-# include <linux/ctype.h>
-# include <linux/mc146818rtc.h>
-# include <asm/realmode.h>
-#else
-# include <asm/x86_init.h>
-#endif
+#include <linux/ctype.h>
+#include <linux/mc146818rtc.h>
+#include <asm/realmode.h>
+#include <asm/x86_init.h>
 
 /*
  * Power off function, if any
@@ -49,7 +47,7 @@ int reboot_force;
  */
 static int reboot_default = 1;
 
-#if defined(CONFIG_X86_32) && defined(CONFIG_SMP)
+#ifdef CONFIG_SMP
 static int reboot_cpu = -1;
 #endif
 
@@ -67,8 +65,8 @@ bool port_cf9_safe = false;
  * reboot=b[ios] | s[mp] | t[riple] | k[bd] | e[fi] [, [w]arm | [c]old] | p[ci]
  * warm   Don't set the cold reboot flag
  * cold   Set the cold reboot flag
- * bios   Reboot by jumping through the BIOS (only for X86_32)
- * smp    Reboot by executing reset on BSP or other CPU (only for X86_32)
+ * bios   Reboot by jumping through the BIOS
+ * smp    Reboot by executing reset on BSP or other CPU
  * triple Force a triple fault (init)
  * kbd    Use the keyboard controller. cold reset (default)
  * acpi   Use the RESET_REG in the FADT
@@ -95,7 +93,6 @@ static int __init reboot_setup(char *str)
 			reboot_mode = 0;
 			break;
 
-#ifdef CONFIG_X86_32
 #ifdef CONFIG_SMP
 		case 's':
 			if (isdigit(*(str+1))) {
@@ -112,7 +109,6 @@ static int __init reboot_setup(char *str)
 #endif /* CONFIG_SMP */
 
 		case 'b':
-#endif
 		case 'a':
 		case 'k':
 		case 't':
@@ -138,7 +134,6 @@ static int __init reboot_setup(char *str)
 __setup("reboot=", reboot_setup);
 
 
-#ifdef CONFIG_X86_32
 /*
  * Reboot options and system auto-detection code provided by
  * Dell Inc. so their systems "just work". :-)
@@ -157,11 +152,8 @@ static int __init set_bios_reboot(const struct dmi_system_id *d)
 	return 0;
 }
 
-void machine_real_restart(unsigned int type)
+void __noreturn machine_real_restart(unsigned int type)
 {
-	void (*restart_lowmem)(unsigned int) = (void (*)(unsigned int))
-		real_mode_header->machine_real_restart_asm;
-
 	local_irq_disable();
 
 	/*
@@ -181,25 +173,28 @@ void machine_real_restart(unsigned int type)
 	/*
 	 * Switch back to the initial page table.
 	 */
+#ifdef CONFIG_X86_32
 	load_cr3(initial_page_table);
-
-	/*
-	 * Write 0x1234 to absolute memory location 0x472.  The BIOS reads
-	 * this on booting to tell it to "Bypass memory test (also warm
-	 * boot)".  This seems like a fairly standard thing that gets set by
-	 * REBOOT.COM programs, and the previous reset routine did this
-	 * too. */
-	*((unsigned short *)0x472) = reboot_mode;
+#else
+	write_cr3(real_mode_header->trampoline_pgd);
+#endif
 
 	/* Jump to the identity-mapped low memory code */
-	restart_lowmem(type);
+#ifdef CONFIG_X86_32
+	asm volatile("jmpl *%0" : :
+		     "rm" (real_mode_header->machine_real_restart_asm),
+		     "a" (type));
+#else
+	asm volatile("ljmpl *%0" : :
+		     "m" (real_mode_header->machine_real_restart_asm),
+		     "D" (type));
+#endif
+	unreachable();
 }
 #ifdef CONFIG_APM_MODULE
 EXPORT_SYMBOL(machine_real_restart);
 #endif
 
-#endif /* CONFIG_X86_32 */
-
 /*
  * Some Apple MacBook and MacBookPro's needs reboot=p to be able to reboot
  */
@@ -223,11 +218,9 @@ static int __init set_kbd_reboot(const struct dmi_system_id *d)
 }
 
 /*
- * This is a single dmi_table handling all reboot quirks.  Note that
- * REBOOT_BIOS is only available for 32bit
+ * This is a single dmi_table handling all reboot quirks.
  */
 static struct dmi_system_id __initdata reboot_dmi_table[] = {
-#ifdef CONFIG_X86_32
 	{	/* Handle problems with rebooting on Dell E520's */
 		.callback = set_bios_reboot,
 		.ident = "Dell E520",
@@ -377,7 +370,6 @@ static struct dmi_system_id __initdata reboot_dmi_table[] = {
 			DMI_MATCH(DMI_BOARD_NAME, "P4S800"),
 		},
 	},
-#endif /* CONFIG_X86_32 */
 
 	{	/* Handle reboot issue on Acer Aspire one */
 		.callback = set_kbd_reboot,
@@ -576,13 +568,11 @@ static void native_machine_emergency_restart(void)
 			reboot_type = BOOT_KBD;
 			break;
 
-#ifdef CONFIG_X86_32
 		case BOOT_BIOS:
 			machine_real_restart(MRR_BIOS);
 
 			reboot_type = BOOT_KBD;
 			break;
-#endif
 
 		case BOOT_ACPI:
 			acpi_reboot();
@@ -624,12 +614,10 @@ void native_machine_shutdown(void)
 	/* The boot cpu is always logical cpu 0 */
 	int reboot_cpu_id = 0;
 
-#ifdef CONFIG_X86_32
 	/* See if there has been given a command line override */
 	if ((reboot_cpu != -1) && (reboot_cpu < nr_cpu_ids) &&
 		cpu_online(reboot_cpu))
 		reboot_cpu_id = reboot_cpu;
-#endif
 
 	/* Make certain the cpu I'm about to reboot on is online */
 	if (!cpu_online(reboot_cpu_id))
diff --git a/arch/x86/realmode/rm/Makefile b/arch/x86/realmode/rm/Makefile
index 5b84a2d..b2d534c 100644
--- a/arch/x86/realmode/rm/Makefile
+++ b/arch/x86/realmode/rm/Makefile
@@ -22,7 +22,7 @@ wakeup-objs	+= video-bios.o
 realmode-y			+= header.o
 realmode-y			+= trampoline_$(BITS).o
 realmode-y			+= stack.o
-realmode-$(CONFIG_X86_32)	+= reboot_32.o
+realmode-y			+= reboot.o
 realmode-$(CONFIG_ACPI_SLEEP)	+= $(wakeup-objs)
 
 targets	+= $(realmode-y)
diff --git a/arch/x86/realmode/rm/header.S b/arch/x86/realmode/rm/header.S
index fadf483..a28221d 100644
--- a/arch/x86/realmode/rm/header.S
+++ b/arch/x86/realmode/rm/header.S
@@ -6,6 +6,7 @@
 
 #include <linux/linkage.h>
 #include <asm/page_types.h>
+#include <asm/segment.h>
 
 #include "realmode.h"
 	
@@ -28,8 +29,9 @@ GLOBAL(real_mode_header)
 	.long	pa_wakeup_header
 #endif
 	/* APM/BIOS reboot */
-#ifdef CONFIG_X86_32
 	.long	pa_machine_real_restart_asm
+#ifdef CONFIG_X86_64
+	.long	__KERNEL32_CS
 #endif
 END(real_mode_header)
 
diff --git a/arch/x86/realmode/rm/reboot_32.S b/arch/x86/realmode/rm/reboot.S
similarity index 85%
rename from arch/x86/realmode/rm/reboot_32.S
rename to arch/x86/realmode/rm/reboot.S
index 1140448..f932ea6 100644
--- a/arch/x86/realmode/rm/reboot_32.S
+++ b/arch/x86/realmode/rm/reboot.S
@@ -2,6 +2,8 @@
 #include <linux/init.h>
 #include <asm/segment.h>
 #include <asm/page_types.h>
+#include <asm/processor-flags.h>
+#include <asm/msr-index.h>
 #include "realmode.h"
 
 /*
@@ -12,13 +14,35 @@
  * doesn't work with at least one type of 486 motherboard.  It is easy
  * to stop this code working; hence the copious comments.
  *
- * This code is called with the restart type (0 = BIOS, 1 = APM) in %eax.
+ * This code is called with the restart type (0 = BIOS, 1 = APM) in
+ * the primary argument register (%eax for 32 bit, %edi for 64 bit).
  */
 	.section ".text32", "ax"
 	.code32
-
-	.balign	16
 ENTRY(machine_real_restart_asm)
+
+#ifdef CONFIG_X86_64
+	/* Switch to trampoline GDT as it is guaranteed < 4 GiB */
+	movl	$__KERNEL_DS, %eax
+	movl	%eax, %ds
+	lgdtl	pa_tr_gdt
+
+	/* Disable paging to drop us out of long mode */
+	movl	%cr0, %eax
+	andl	$~X86_CR0_PG, %eax
+	movl	%eax, %cr0
+	ljmpl	$__KERNEL32_CS, $pa_machine_real_restart_paging_off
+
+GLOBAL(machine_real_restart_paging_off)
+	xorl	%eax, %eax
+	xorl	%edx, %edx
+	movl	$MSR_EFER, %ecx
+	wrmsr
+
+	movl	%edi, %eax
+	
+#endif /* CONFIG_X86_64 */
+	
 	/* Set up the IDT for real mode. */
 	lidtl	pa_machine_real_restart_idt
 
