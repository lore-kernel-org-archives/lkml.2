Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757604Ab2EHW1p (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2012 18:27:45 -0400
Received: from terminus.zytor.com ([198.137.202.10]:34598 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757543Ab2EHW1n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2012 18:27:43 -0400
Date: Tue, 8 May 2012 15:27:28 -0700
From: tip-bot for Jarkko Sakkinen <jarkko.sakkinen@intel.com>
Message-ID: <tip-8e029fcdd8702719c9179317cae9ef84ebe7027e@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        jarkko.sakkinen@intel.com, tglx@linutronix.de, rjw@sisk.pl,
        hpa@linux.intel.com, len.brown@intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, jarkko.sakkinen@intel.com, hpa@linux.intel.com,
        rjw@sisk.pl, len.brown@intel.com
In-Reply-To: <1336501366-28617-18-git-send-email-jarkko.sakkinen@intel.com>
References: <1336501366-28617-18-git-send-email-jarkko.sakkinen@intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/trampoline] x86, realmode: fix 64-bit wakeup sequence
Git-Commit-ID: 8e029fcdd8702719c9179317cae9ef84ebe7027e
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Tue, 08 May 2012 15:27:35 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  8e029fcdd8702719c9179317cae9ef84ebe7027e
Gitweb:     http://git.kernel.org/tip/8e029fcdd8702719c9179317cae9ef84ebe7027e
Author:     Jarkko Sakkinen <jarkko.sakkinen@intel.com>
AuthorDate: Tue, 8 May 2012 21:22:40 +0300
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Tue, 8 May 2012 11:48:11 -0700

x86, realmode: fix 64-bit wakeup sequence

There were number of issues in wakeup sequence:

- Wakeup stack was placed in hardcoded address.
- NX bit in EFER was not enabled.
- Initialization incorrectly set physical address
of secondary_startup_64.
- Some alignment issues.

This patch fixes these issues and in addition:

- Unifies coding conventions in .S files.
- Sets alignments of code and data right.

Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@intel.com>
Link: http://lkml.kernel.org/r/1336501366-28617-18-git-send-email-jarkko.sakkinen@intel.com
Originally-by: H. Peter Anvin <hpa@linux.intel.com>
Cc: Rafael J. Wysocki <rjw@sisk.pl>
Cc: Len Brown <len.brown@intel.com>
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/kernel/realmode.c               |    2 +-
 arch/x86/realmode/rm/Makefile            |    1 +
 arch/x86/realmode/rm/header.S            |    2 +-
 arch/x86/realmode/rm/reboot_32.S         |   18 ++++----
 arch/x86/realmode/rm/stack.S             |   19 ++++++++
 arch/x86/realmode/rm/trampoline_32.S     |   29 ++++++------
 arch/x86/realmode/rm/trampoline_64.S     |   67 +++++++++++---------------
 arch/x86/realmode/rm/wakeup/wakeup_asm.S |   75 +++++++++++++----------------
 arch/x86/realmode/rmpiggy.S              |    4 +-
 9 files changed, 110 insertions(+), 107 deletions(-)

diff --git a/arch/x86/kernel/realmode.c b/arch/x86/kernel/realmode.c
index d85ac20..e7bf82a 100644
--- a/arch/x86/kernel/realmode.c
+++ b/arch/x86/kernel/realmode.c
@@ -64,7 +64,7 @@ void __init setup_real_mode(void)
 	*((u32 *)__va(real_mode_header.boot_gdt)) = __pa(boot_gdt);
 #else
 	*((u64 *) __va(real_mode_header.startup_64_smp)) =
-		(u64) __pa(secondary_startup_64);
+		(u64)secondary_startup_64;
 
 	*((u64 *) __va(real_mode_header.level3_ident_pgt)) =
 		__pa(level3_ident_pgt) + _KERNPG_TABLE;
diff --git a/arch/x86/realmode/rm/Makefile b/arch/x86/realmode/rm/Makefile
index 2423142..c2c27a4 100644
--- a/arch/x86/realmode/rm/Makefile
+++ b/arch/x86/realmode/rm/Makefile
@@ -13,6 +13,7 @@ always := realmode.bin
 
 realmode-y			+= header.o
 realmode-y			+= trampoline_$(BITS).o
+realmode-y			+= stack.o
 realmode-$(CONFIG_X86_32)	+= reboot_32.o
 realmode-$(CONFIG_ACPI_SLEEP)	+= wakeup/wakeup.o
 
diff --git a/arch/x86/realmode/rm/header.S b/arch/x86/realmode/rm/header.S
index 730b131..a91ec8f 100644
--- a/arch/x86/realmode/rm/header.S
+++ b/arch/x86/realmode/rm/header.S
@@ -9,7 +9,7 @@
 
 		.section ".header", "a"
 
-ENTRY(real_mode_header)
+GLOBAL(real_mode_header)
 		.long	pa_text_start
 		.long	pa_ro_end
 		.long	pa_end
diff --git a/arch/x86/realmode/rm/reboot_32.S b/arch/x86/realmode/rm/reboot_32.S
index 50ba994..8d9bfd1 100644
--- a/arch/x86/realmode/rm/reboot_32.S
+++ b/arch/x86/realmode/rm/reboot_32.S
@@ -16,10 +16,9 @@
  */
 	.section ".text32", "ax"
 	.code32
-	.globl machine_real_restart_asm
 
-	.balign 16
-machine_real_restart_asm:
+	.balign	16
+ENTRY(machine_real_restart_asm)
 	/* Set up the IDT for real mode. */
 	lidtl	pa_machine_real_restart_idt
 
@@ -67,7 +66,7 @@ machine_real_restart_asm:
 	.text
 	.code16
 
-	.balign 16
+	.balign	16
 machine_real_restart_asm16:
 1:
 	xorl	%ecx, %ecx
@@ -102,15 +101,15 @@ bios:
 	ljmpw	$0xf000, $0xfff0
 
 	.section ".rodata", "a"
-	.globl	machine_real_restart_idt, machine_real_restart_gdt
 
-	.balign 16
-machine_real_restart_idt:
+	.balign	16
+GLOBAL(machine_real_restart_idt)
 	.word	0xffff		/* Length - real mode default value */
 	.long	0		/* Base - real mode default value */
+END(machine_real_restart_idt)
 
-	.balign 16
-machine_real_restart_gdt:
+	.balign	16
+GLOBAL(machine_real_restart_gdt)
 	/* Self-pointer */
 	.word	0xffff		/* Length - real mode default value */
 	.long	pa_machine_real_restart_gdt
@@ -130,3 +129,4 @@ machine_real_restart_gdt:
 	 * semantics we don't have to reload the segments once CR0.PE = 0.
 	 */
 	.quad	GDT_ENTRY(0x0093, 0x100, 0xffff)
+END(machine_real_restart_gdt)
diff --git a/arch/x86/realmode/rm/stack.S b/arch/x86/realmode/rm/stack.S
new file mode 100644
index 0000000..867ae87
--- /dev/null
+++ b/arch/x86/realmode/rm/stack.S
@@ -0,0 +1,19 @@
+/*
+ * Common heap and stack allocations
+ */
+
+#include <linux/linkage.h>
+
+	.data
+GLOBAL(HEAP)
+	.long	rm_heap
+GLOBAL(heap_end)
+	.long	rm_stack
+
+	.bss
+	.balign	16
+GLOBAL(rm_heap)
+	.space	2048
+GLOBAL(rm_stack)
+	.space	2048
+GLOBAL(rm_stack_end)
diff --git a/arch/x86/realmode/rm/trampoline_32.S b/arch/x86/realmode/rm/trampoline_32.S
index 279f82e..1ecdbb5 100644
--- a/arch/x86/realmode/rm/trampoline_32.S
+++ b/arch/x86/realmode/rm/trampoline_32.S
@@ -33,10 +33,9 @@
 
 	.text
 	.code16
-	.globl trampoline_data
 
-	.balign PAGE_SIZE
-trampoline_data:
+	.balign	PAGE_SIZE
+ENTRY(trampoline_data)
 	wbinvd			# Needed for NUMA-Q should be harmless for others
 
 	LJMPW_RM(1f)
@@ -70,20 +69,22 @@ trampoline_data:
 ENTRY(startup_32)			# note: also used from wakeup_asm.S
 	jmp	*%eax
 
-	.data
-	.globl startup_32_smp, boot_gdt, trampoline_status
-	.balign	4
-boot_gdt_descr:
-	.word	__BOOT_DS + 7			# gdt limit
-boot_gdt:
-	.long	0				# gdt base
+	.section ".rodata","a"
 
+	.balign	4
 boot_idt_descr:
 	.word	0				# idt limit = 0
 	.long	0				# idt base = 0L
 
-trampoline_status:
-	.long	0
+	.data
 
-startup_32_smp:
-	.long	0
+boot_gdt_descr:
+	.word	__BOOT_DS + 7			# gdt limit
+GLOBAL(boot_gdt)
+	.long	0				# gdt base
+
+	.bss
+
+	.balign	4
+GLOBAL(trampoline_status)	.space	4
+GLOBAL(startup_32_smp)		.space	4
diff --git a/arch/x86/realmode/rm/trampoline_64.S b/arch/x86/realmode/rm/trampoline_64.S
index 7459c52..f71ea08 100644
--- a/arch/x86/realmode/rm/trampoline_64.S
+++ b/arch/x86/realmode/rm/trampoline_64.S
@@ -52,7 +52,7 @@ ENTRY(trampoline_data)
 	# write marker for master knows we're running
 
 	# Setup stack
-	movw	$trampoline_stack_end, %sp
+	movl	$rm_stack_end, %esp
 
 	call	verify_cpu		# Verify the cpu supports long mode
 	testl   %eax, %eax		# Check for return code
@@ -68,8 +68,11 @@ ENTRY(trampoline_data)
 	lidtl	tidt	# load idt with 0, 0
 	lgdtl	tgdt	# load gdt with whatever is appropriate
 
-	mov	$X86_CR0_PE, %ax	# protected mode (PE) bit
-	lmsw	%ax			# into protected mode
+	movw	$__KERNEL_DS, %dx	# Data segment descriptor
+
+	# Enable protected mode
+	movl	$X86_CR0_PE, %eax	# protected mode (PE) bit
+	movl	%eax, %cr0		# into protected mode
 
 	# flush prefetch and jump to startup_32
 	ljmpl	$__KERNEL32_CS, $pa_startup_32
@@ -83,27 +86,27 @@ no_longmode:
 	.code32
 	.balign 4
 ENTRY(startup_32)
-	movl	$__KERNEL_DS, %eax	# Initialize the %ds segment register
-	movl	%eax, %ds
+	movl	%edx, %ss
+	addl	$pa_real_mode_base, %esp
+	movl	%edx, %ds
+	movl	%edx, %es
+	movl	%edx, %fs
+	movl	%edx, %gs
 
 	movl	$X86_CR4_PAE, %eax
 	movl	%eax, %cr4		# Enable PAE mode
 
-	movl	pa_startup_64_smp, %esi
-	movl	pa_startup_64_smp_high, %edi
-
-					# Setup trampoline 4 level pagetables
-	leal	pa_trampoline_level4_pgt, %eax
+	# Setup trampoline 4 level pagetables
+	movl	$pa_level3_ident_pgt, %eax
 	movl	%eax, %cr3
 
 	movl	$MSR_EFER, %ecx
-	movl	$(1 << _EFER_LME), %eax	# Enable Long Mode
+	movl	$((1 << _EFER_LME) | (1 << _EFER_NX)), %eax	# Enable Long Mode
 	xorl	%edx, %edx
 	wrmsr
 
 	# Enable paging and in turn activate Long Mode
-	# Enable protected mode
-	movl	$(X86_CR0_PG | X86_CR0_PE), %eax
+	movl	$(X86_CR0_PG | X86_CR0_WP | X86_CR0_PE), %eax
 	movl	%eax, %cr0
 
 	/*
@@ -119,10 +122,7 @@ ENTRY(startup_32)
 	.balign 4
 ENTRY(startup_64)
 	# Now jump into the kernel using virtual addresses
-	movl	%edi, %eax
-	shlq	$32, %rax
-	addl	%esi, %eax
-	jmp	*%rax
+	jmpq	*startup_64_smp(%rip)
 
 	.section ".rodata","a"
 	.balign	16
@@ -132,10 +132,10 @@ tidt:
 
 	# Duplicate the global descriptor table
 	# so the kernel can live anywhere
-	.balign 4
+	.balign 16
 	.globl tgdt
 tgdt:
-	.short	tgdt_end - tgdt		# gdt limit
+	.short	tgdt_end - tgdt - 1	# gdt limit
 	.long	pa_tgdt
 	.short	0
 	.quad	0x00cf9b000000ffff	# __KERNEL32_CS
@@ -143,23 +143,12 @@ tgdt:
 	.quad	0x00cf93000000ffff	# __KERNEL_DS
 tgdt_end:
 
-	.data
-	.balign 4
-GLOBAL(trampoline_status)
-	.long	0
-
-trampoline_stack:
-	.org 0x1000
-trampoline_stack_end:
-
-	.globl	level3_ident_pgt
-	.globl	level3_kernel_pgt
-GLOBAL(trampoline_level4_pgt)
-	level3_ident_pgt:	.quad	0
-	.fill 510,8,0
-	level3_kernel_pgt:	.quad	0
-
-	.globl	startup_64_smp
-	.globl	startup_64_smp_high
-startup_64_smp:		.long 0
-startup_64_smp_high:	.long 0
+	.bss
+
+	.balign	PAGE_SIZE
+GLOBAL(level3_ident_pgt)	.space	511*8
+GLOBAL(level3_kernel_pgt)	.space	8
+
+	.balign	8
+GLOBAL(startup_64_smp)		.space	8
+GLOBAL(trampoline_status)	.space	4
diff --git a/arch/x86/realmode/rm/wakeup/wakeup_asm.S b/arch/x86/realmode/rm/wakeup/wakeup_asm.S
index 8064e1c..f81c1cd 100644
--- a/arch/x86/realmode/rm/wakeup/wakeup_asm.S
+++ b/arch/x86/realmode/rm/wakeup/wakeup_asm.S
@@ -1,6 +1,7 @@
 /*
  * ACPI wakeup real mode startup stub
  */
+#include <linux/linkage.h>
 #include <asm/segment.h>
 #include <asm/msr-index.h>
 #include <asm/page_types.h>
@@ -9,31 +10,33 @@
 #include "../realmode.h"
 #include "wakeup.h"
 
-		.code16
+	.code16
 
 /* This should match the structure in wakeup.h */
-		.section ".data", "aw"
-		.globl	wakeup_header
-wakeup_header:
-video_mode:	.short	0	/* Video mode number */
-pmode_entry:	.long	0
-pmode_cs:	.short	__KERNEL_CS
-pmode_cr0:	.long	0	/* Saved %cr0 */
-pmode_cr3:	.long	0	/* Saved %cr3 */
-pmode_cr4:	.long	0	/* Saved %cr4 */
-pmode_efer:	.quad	0	/* Saved EFER */
-pmode_gdt:	.quad	0
-pmode_misc_en:	.quad	0	/* Saved MISC_ENABLE MSR */
-pmode_behavior:	.long	0	/* Wakeup behavior flags */
-realmode_flags:	.long	0
-real_magic:	.long	0
-signature:	.long	WAKEUP_HEADER_SIGNATURE
-		.size	wakeup_header, .-wakeup_header
+	.section ".data", "aw"
+
+	.balign	16
+GLOBAL(wakeup_header)
+	video_mode:	.short	0	/* Video mode number */
+	pmode_entry:	.long	0
+	pmode_cs:	.short	__KERNEL_CS
+	pmode_cr0:	.long	0	/* Saved %cr0 */
+	pmode_cr3:	.long	0	/* Saved %cr3 */
+	pmode_cr4:	.long	0	/* Saved %cr4 */
+	pmode_efer:	.quad	0	/* Saved EFER */
+	pmode_gdt:	.quad	0
+	pmode_misc_en:	.quad	0	/* Saved MISC_ENABLE MSR */
+	pmode_behavior:	.long	0	/* Wakeup behavior flags */
+	realmode_flags:	.long	0
+	real_magic:	.long	0
+	signature:	.long	WAKEUP_HEADER_SIGNATURE
+END(wakeup_header)
 
 	.text
 	.code16
-	.globl	wakeup_start
-wakeup_start:
+
+	.balign	16
+ENTRY(wakeup_start)
 	cli
 	cld
 
@@ -62,12 +65,14 @@ wakeup_start:
 3:
 	/* Set up segments */
 	movw	%cs, %ax
+	movw	%ax, %ss
+	movl	$rm_stack_end, %esp
 	movw	%ax, %ds
 	movw	%ax, %es
-	movw	%ax, %ss
-	lidtl	wakeup_idt
+	movw	%ax, %fs
+	movw	%ax, %gs
 
-	movl	$wakeup_stack_end, %esp
+	lidtl	wakeup_idt
 
 	/* Clear the EFLAGS */
 	pushl	$0
@@ -145,9 +150,8 @@ bogus_real_magic:
 	 * be the case for other laptops or integrated video devices.
 	 */
 
-	.globl	wakeup_gdt
 	.balign	16
-wakeup_gdt:
+GLOBAL(wakeup_gdt)
 	.word	3*8-1		/* Self-descriptor */
 	.long	pa_wakeup_gdt
 	.word	0
@@ -159,29 +163,18 @@ wakeup_gdt:
 	.word	0xffff		/* 16-bit data segment @ real_mode_base */
 	.long	0x93000000 + pa_real_mode_base
 	.word	0x008f		/* big real mode */
-	.size	wakeup_gdt, .-wakeup_gdt
+END(wakeup_gdt)
 
-	.data
+	.section ".rodata","a"
 	.balign	8
 
 	/* This is the standard real-mode IDT */
-wakeup_idt:
+	.balign	16
+GLOBAL(wakeup_idt)
 	.word	0xffff		/* limit */
 	.long	0		/* address */
 	.word	0
-
-	.globl	HEAP, heap_end
-HEAP:
-	.long	wakeup_heap
-heap_end:
-	.long	wakeup_stack
-
-	.bss
-wakeup_heap:
-	.space	2048
-wakeup_stack:
-	.space	2048
-wakeup_stack_end:
+END(wakeup_idt)
 
 	.section ".signature","a"
 end_signature:
diff --git a/arch/x86/realmode/rmpiggy.S b/arch/x86/realmode/rmpiggy.S
index 6047d7f..fd72a99 100644
--- a/arch/x86/realmode/rmpiggy.S
+++ b/arch/x86/realmode/rmpiggy.S
@@ -9,10 +9,10 @@
 
 	.balign PAGE_SIZE
 
-ENTRY(real_mode_blob)
+GLOBAL(real_mode_blob)
 	.incbin	"arch/x86/realmode/rm/realmode.bin"
 END(real_mode_blob)
 
-ENTRY(real_mode_relocs)
+GLOBAL(real_mode_relocs)
 	.incbin	"arch/x86/realmode/rm/realmode.relocs"
 END(real_mode_relocs)
