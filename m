Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753070Ab1BRFVA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Feb 2011 00:21:00 -0500
Received: from hera.kernel.org ([140.211.167.34]:55514 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751114Ab1BRFUp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Feb 2011 00:20:45 -0500
Date: Fri, 18 Feb 2011 05:20:19 GMT
From: "tip-bot for H. Peter Anvin" <hpa@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        castet.matthieu@free.fr, sfr@canb.auug.org.au, tglx@linutronix.de,
        rjw@sisk.pl, hpa@linux.intel.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        castet.matthieu@free.fr, sfr@canb.auug.org.au, tglx@linutronix.de,
        rjw@sisk.pl, hpa@linux.intel.com
In-Reply-To: <4D5DFBE4.7090104@intel.com>
References: <4D5DFBE4.7090104@intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/trampoline] x86, reboot: Move the real-mode reboot code to an assembly file
Message-ID: <tip-3d35ac346e981162eeba391e496faceed4753e7b@git.kernel.org>
Git-Commit-ID: 3d35ac346e981162eeba391e496faceed4753e7b
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 18 Feb 2011 05:20:20 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  3d35ac346e981162eeba391e496faceed4753e7b
Gitweb:     http://git.kernel.org/tip/3d35ac346e981162eeba391e496faceed4753e7b
Author:     H. Peter Anvin <hpa@linux.intel.com>
AuthorDate: Mon, 14 Feb 2011 18:36:03 -0800
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Thu, 17 Feb 2011 21:05:34 -0800

x86, reboot: Move the real-mode reboot code to an assembly file

Move the real-mode reboot code out to an assembly file (reboot_32.S)
which is allocated using the common lowmem trampoline allocator.

Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
LKML-Reference: <4D5DFBE4.7090104@intel.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Rafael J. Wysocki <rjw@sisk.pl>
Cc: Matthieu Castet <castet.matthieu@free.fr>
---
 arch/x86/include/asm/reboot.h |    5 +-
 arch/x86/kernel/Makefile      |    1 +
 arch/x86/kernel/apm_32.c      |   12 +----
 arch/x86/kernel/reboot.c      |  120 ++++++++-----------------------------
 arch/x86/kernel/reboot_32.S   |  131 +++++++++++++++++++++++++++++++++++++++++
 5 files changed, 162 insertions(+), 107 deletions(-)

diff --git a/arch/x86/include/asm/reboot.h b/arch/x86/include/asm/reboot.h
index 562d4fd..3250e3d 100644
--- a/arch/x86/include/asm/reboot.h
+++ b/arch/x86/include/asm/reboot.h
@@ -18,7 +18,10 @@ extern struct machine_ops machine_ops;
 
 void native_machine_crash_shutdown(struct pt_regs *regs);
 void native_machine_shutdown(void);
-void machine_real_restart(const unsigned char *code, int length);
+void machine_real_restart(unsigned int type);
+/* These must match dispatch_table in reboot_32.S */
+#define MRR_BIOS	0
+#define MRR_APM		1
 
 typedef void (*nmi_shootdown_cb)(int, struct die_args*);
 void nmi_shootdown_cpus(nmi_shootdown_cb callback);
diff --git a/arch/x86/kernel/Makefile b/arch/x86/kernel/Makefile
index 2e8ce0d..778c5b93 100644
--- a/arch/x86/kernel/Makefile
+++ b/arch/x86/kernel/Makefile
@@ -59,6 +59,7 @@ obj-$(CONFIG_STACKTRACE)	+= stacktrace.o
 obj-y				+= cpu/
 obj-y				+= acpi/
 obj-y				+= reboot.o
+obj-$(CONFIG_X86_32)		+= reboot_32.o
 obj-$(CONFIG_MCA)		+= mca_32.o
 obj-$(CONFIG_X86_MSR)		+= msr.o
 obj-$(CONFIG_X86_CPUID)		+= cpuid.o
diff --git a/arch/x86/kernel/apm_32.c b/arch/x86/kernel/apm_32.c
index 0e4f24c..b929108 100644
--- a/arch/x86/kernel/apm_32.c
+++ b/arch/x86/kernel/apm_32.c
@@ -975,20 +975,10 @@ recalc:
 
 static void apm_power_off(void)
 {
-	unsigned char po_bios_call[] = {
-		0xb8, 0x00, 0x10,	/* movw  $0x1000,ax  */
-		0x8e, 0xd0,		/* movw  ax,ss       */
-		0xbc, 0x00, 0xf0,	/* movw  $0xf000,sp  */
-		0xb8, 0x07, 0x53,	/* movw  $0x5307,ax  */
-		0xbb, 0x01, 0x00,	/* movw  $0x0001,bx  */
-		0xb9, 0x03, 0x00,	/* movw  $0x0003,cx  */
-		0xcd, 0x15		/* int   $0x15       */
-	};
-
 	/* Some bioses don't like being called from CPU != 0 */
 	if (apm_info.realmode_power_off) {
 		set_cpus_allowed_ptr(current, cpumask_of(0));
-		machine_real_restart(po_bios_call, sizeof(po_bios_call));
+		machine_real_restart(MRR_APM);
 	} else {
 		(void)set_system_power_state(APM_STATE_OFF);
 	}
diff --git a/arch/x86/kernel/reboot.c b/arch/x86/kernel/reboot.c
index fc7aae1..10c6619 100644
--- a/arch/x86/kernel/reboot.c
+++ b/arch/x86/kernel/reboot.c
@@ -295,68 +295,16 @@ static int __init reboot_init(void)
 }
 core_initcall(reboot_init);
 
-/* The following code and data reboots the machine by switching to real
-   mode and jumping to the BIOS reset entry point, as if the CPU has
-   really been reset.  The previous version asked the keyboard
-   controller to pulse the CPU reset line, which is more thorough, but
-   doesn't work with at least one type of 486 motherboard.  It is easy
-   to stop this code working; hence the copious comments. */
-static const unsigned long long
-real_mode_gdt_entries [3] =
-{
-	0x0000000000000000ULL,	/* Null descriptor */
-	0x00009b000000ffffULL,	/* 16-bit real-mode 64k code at 0x00000000 */
-	0x000093000100ffffULL	/* 16-bit real-mode 64k data at 0x00000100 */
-};
+extern const unsigned char machine_real_restart_asm[];
+extern const u64 machine_real_restart_gdt[3];
 
-static const struct desc_ptr
-real_mode_gdt = { sizeof (real_mode_gdt_entries) - 1, (long)real_mode_gdt_entries },
-real_mode_idt = { 0x3ff, 0 };
-
-/* This is 16-bit protected mode code to disable paging and the cache,
-   switch to real mode and jump to the BIOS reset code.
-
-   The instruction that switches to real mode by writing to CR0 must be
-   followed immediately by a far jump instruction, which set CS to a
-   valid value for real mode, and flushes the prefetch queue to avoid
-   running instructions that have already been decoded in protected
-   mode.
-
-   Clears all the flags except ET, especially PG (paging), PE
-   (protected-mode enable) and TS (task switch for coprocessor state
-   save).  Flushes the TLB after paging has been disabled.  Sets CD and
-   NW, to disable the cache on a 486, and invalidates the cache.  This
-   is more like the state of a 486 after reset.  I don't know if
-   something else should be done for other chips.
-
-   More could be done here to set up the registers as if a CPU reset had
-   occurred; hopefully real BIOSs don't assume much. */
-static const unsigned char real_mode_switch [] =
-{
-	0x66, 0x0f, 0x20, 0xc0,			/*    movl  %cr0,%eax        */
-	0x66, 0x83, 0xe0, 0x11,			/*    andl  $0x00000011,%eax */
-	0x66, 0x0d, 0x00, 0x00, 0x00, 0x60,	/*    orl   $0x60000000,%eax */
-	0x66, 0x0f, 0x22, 0xc0,			/*    movl  %eax,%cr0        */
-	0x66, 0x0f, 0x22, 0xd8,			/*    movl  %eax,%cr3        */
-	0x66, 0x0f, 0x20, 0xc3,			/*    movl  %cr0,%ebx        */
-	0x66, 0x81, 0xe3, 0x00, 0x00, 0x00, 0x60,	/*    andl  $0x60000000,%ebx */
-	0x74, 0x02,				/*    jz    f                */
-	0x0f, 0x09,				/*    wbinvd                 */
-	0x24, 0x10,				/* f: andb  $0x10,al         */
-	0x66, 0x0f, 0x22, 0xc0			/*    movl  %eax,%cr0        */
-};
-static const unsigned char jump_to_bios [] =
+void machine_real_restart(unsigned int type)
 {
-	0xea, 0x00, 0x00, 0xff, 0xff		/*    ljmp  $0xffff,$0x0000  */
-};
+	void *restart_va;
+	unsigned long restart_pa;
+	void (*restart_lowmem)(unsigned int);
+	u64 *lowmem_gdt;
 
-/*
- * Switch to real mode and then execute the code
- * specified by the code and length parameters.
- * We assume that length will aways be less that 100!
- */
-void machine_real_restart(const unsigned char *code, int length)
-{
 	local_irq_disable();
 
 	/* Write zero to CMOS register number 0x0f, which the BIOS POST
@@ -384,41 +332,23 @@ void machine_real_restart(const unsigned char *code, int length)
 	   too. */
 	*((unsigned short *)0x472) = reboot_mode;
 
-	/* For the switch to real mode, copy some code to low memory.  It has
-	   to be in the first 64k because it is running in 16-bit mode, and it
-	   has to have the same physical and virtual address, because it turns
-	   off paging.  Copy it near the end of the first page, out of the way
-	   of BIOS variables. */
-	memcpy((void *)(0x1000 - sizeof(real_mode_switch) - 100),
-		real_mode_switch, sizeof (real_mode_switch));
-	memcpy((void *)(0x1000 - 100), code, length);
-
-	/* Set up the IDT for real mode. */
-	load_idt(&real_mode_idt);
-
-	/* Set up a GDT from which we can load segment descriptors for real
-	   mode.  The GDT is not used in real mode; it is just needed here to
-	   prepare the descriptors. */
-	load_gdt(&real_mode_gdt);
-
-	/* Load the data segment registers, and thus the descriptors ready for
-	   real mode.  The base address of each segment is 0x100, 16 times the
-	   selector value being loaded here.  This is so that the segment
-	   registers don't have to be reloaded after switching to real mode:
-	   the values are consistent for real mode operation already. */
-	__asm__ __volatile__ ("movl $0x0010,%%eax\n"
-				"\tmovl %%eax,%%ds\n"
-				"\tmovl %%eax,%%es\n"
-				"\tmovl %%eax,%%fs\n"
-				"\tmovl %%eax,%%gs\n"
-				"\tmovl %%eax,%%ss" : : : "eax");
-
-	/* Jump to the 16-bit code that we copied earlier.  It disables paging
-	   and the cache, switches to real mode, and jumps to the BIOS reset
-	   entry point. */
-	__asm__ __volatile__ ("ljmp $0x0008,%0"
-				:
-				: "i" ((void *)(0x1000 - sizeof (real_mode_switch) - 100)));
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
 }
 #ifdef CONFIG_APM_MODULE
 EXPORT_SYMBOL(machine_real_restart);
@@ -573,7 +503,7 @@ static void native_machine_emergency_restart(void)
 
 #ifdef CONFIG_X86_32
 		case BOOT_BIOS:
-			machine_real_restart(jump_to_bios, sizeof(jump_to_bios));
+			machine_real_restart(MRR_BIOS);
 
 			reboot_type = BOOT_KBD;
 			break;
diff --git a/arch/x86/kernel/reboot_32.S b/arch/x86/kernel/reboot_32.S
new file mode 100644
index 0000000..f242356
--- /dev/null
+++ b/arch/x86/kernel/reboot_32.S
@@ -0,0 +1,131 @@
+#include <linux/linkage.h>
+#include <linux/init.h>
+#include <asm/segment.h>
+#include <asm/page_types.h>
+
+/*
+ * The following code and data reboots the machine by switching to real
+ * mode and jumping to the BIOS reset entry point, as if the CPU has
+ * really been reset.  The previous version asked the keyboard
+ * controller to pulse the CPU reset line, which is more thorough, but
+ * doesn't work with at least one type of 486 motherboard.  It is easy
+ * to stop this code working; hence the copious comments.
+ *
+ * This code is called with the restart type (0 = BIOS, 1 = APM) in %eax.
+ */
+	.section ".x86_trampoline","a"
+	.balign 16
+	.code32
+ENTRY(machine_real_restart_asm)
+r_base = .
+	/* Get our own relocated address */
+	call	1f
+1:	popl	%ebx
+	subl	$1b, %ebx
+
+	/* Patch post-real-mode segment jump */
+	movw	dispatch_table(%ebx,%ecx,2),%cx
+	movw	%cx, 101f(%ebx)
+	movw	%ax, 102f(%ebx)
+
+	/* Set up the IDT for real mode. */
+	lidtl	machine_real_restart_idt(%ebx)
+
+	/*
+	 * Set up a GDT from which we can load segment descriptors for real
+	 * mode.  The GDT is not used in real mode; it is just needed here to
+	 * prepare the descriptors.
+	 */
+	lgdtl	machine_real_restart_gdt(%ebx)
+
+	/*
+	 * Load the data segment registers with 16-bit compatible values
+	 */
+	movl	$16, %ecx
+	movl	%ecx, %ds
+	movl	%ecx, %es
+	movl	%ecx, %fs
+	movl	%ecx, %gs
+	movl	%ecx, %ss
+	ljmpl	$8, $1f - r_base
+
+/*
+ * This is 16-bit protected mode code to disable paging and the cache,
+ * switch to real mode and jump to the BIOS reset code.
+ *
+ * The instruction that switches to real mode by writing to CR0 must be
+ * followed immediately by a far jump instruction, which set CS to a
+ * valid value for real mode, and flushes the prefetch queue to avoid
+ * running instructions that have already been decoded in protected
+ * mode.
+ *
+ * Clears all the flags except ET, especially PG (paging), PE
+ * (protected-mode enable) and TS (task switch for coprocessor state
+ * save).  Flushes the TLB after paging has been disabled.  Sets CD and
+ * NW, to disable the cache on a 486, and invalidates the cache.  This
+ * is more like the state of a 486 after reset.  I don't know if
+ * something else should be done for other chips.
+ *
+ * More could be done here to set up the registers as if a CPU reset had
+ * occurred; hopefully real BIOSs don't assume much.  This is not the
+ * actual BIOS entry point, anyway (that is at 0xfffffff0).
+ *
+ * Most of this work is probably excessive, but it is what is tested.
+ */
+	.code16
+1:
+	xorl	%ecx, %ecx
+	movl	%cr0, %eax
+	andl	$0x00000011, %eax
+	orl	$0x60000000, %eax
+	movl	%eax, %cr0
+	movl	%ecx, %cr3
+	movl	%cr0, %edx
+	andl	$0x60000000, %edx	/* If no cache bits -> no wbinvd */
+	jz	2f
+	wbinvd
+2:
+	andb	$0x10, %al
+	movl	%eax, %cr0
+	.byte	0xea			/* ljmpw */
+101:	.word	0			/* Offset */
+102:	.word	0			/* Segment */
+
+bios:
+	ljmpw	$0xf000, $0xfff0
+
+apm:
+	movw	$0x1000, %ax
+	movw	%ax, %ss
+	movw	$0xf000, %sp
+	movw	$0x5307, %ax
+	movw	$0x0001, %bx
+	movw	$0x0003, %cx
+	int	$0x15
+
+END(machine_real_restart_asm)
+
+	.balign 16
+	/* These must match <asm/reboot.h */
+dispatch_table:
+	.word	bios - r_base
+	.word	apm - r_base
+END(dispatch_table)
+
+	.balign 16
+machine_real_restart_idt:
+	.word	0xffff		/* Length - real mode default value */
+	.long	0		/* Base - real mode default value */
+END(machine_real_restart_idt)
+
+	.balign 16
+ENTRY(machine_real_restart_gdt)
+	.quad	0		/* Self-pointer, filled in by PM code */
+	.quad	0		/* 16-bit code segment, filled in by PM code */
+	/*
+	 * 16-bit data segment with the selector value 16 = 0x10 and
+	 * base value 0x100; since this is consistent with real mode
+	 * semantics we don't have to reload the segments once CR0.PE = 0.
+	 */
+	.quad	GDT_ENTRY(0x0093, 0x100, 0xffff)
+END(machine_real_restart_gdt)
