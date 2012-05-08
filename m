Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757449Ab2EHWQo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2012 18:16:44 -0400
Received: from terminus.zytor.com ([198.137.202.10]:34438 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754011Ab2EHWQm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2012 18:16:42 -0400
Date: Tue, 8 May 2012 15:16:32 -0700
From: tip-bot for Jarkko Sakkinen <jarkko.sakkinen@intel.com>
Message-ID: <tip-5a8c9aebe04a78b069828d364798d5f24c5a42bd@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        jarkko.sakkinen@intel.com, tglx@linutronix.de, hpa@linux.intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, jarkko.sakkinen@intel.com, hpa@linux.intel.com
In-Reply-To: <1336501366-28617-5-git-send-email-jarkko.sakkinen@intel.com>
References: <1336501366-28617-5-git-send-email-jarkko.sakkinen@intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/trampoline] x86, realmode: Move reboot_32.
 S to unified realmode code
Git-Commit-ID: 5a8c9aebe04a78b069828d364798d5f24c5a42bd
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Tue, 08 May 2012 15:16:37 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  5a8c9aebe04a78b069828d364798d5f24c5a42bd
Gitweb:     http://git.kernel.org/tip/5a8c9aebe04a78b069828d364798d5f24c5a42bd
Author:     Jarkko Sakkinen <jarkko.sakkinen@intel.com>
AuthorDate: Tue, 8 May 2012 21:22:27 +0300
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Tue, 8 May 2012 11:41:50 -0700

x86, realmode: Move reboot_32.S to unified realmode code

Migrated reboot_32.S from x86_trampoline to the real-mode
blob.

Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@intel.com>
Link: http://lkml.kernel.org/r/1336501366-28617-5-git-send-email-jarkko.sakkinen@intel.com
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/include/asm/realmode.h              |    4 +
 arch/x86/kernel/Makefile                     |    1 -
 arch/x86/kernel/reboot.c                     |   25 +-------
 arch/x86/realmode/rm/Makefile                |    1 +
 arch/x86/realmode/rm/header.S                |    3 +
 arch/x86/{kernel => realmode/rm}/reboot_32.S |   83 +++++++++++++-------------
 6 files changed, 52 insertions(+), 65 deletions(-)

diff --git a/arch/x86/include/asm/realmode.h b/arch/x86/include/asm/realmode.h
index dc1bba5..bf26b06 100644
--- a/arch/x86/include/asm/realmode.h
+++ b/arch/x86/include/asm/realmode.h
@@ -9,6 +9,10 @@ struct real_mode_header {
 	u32	text_start;
 	u32	ro_end;
 	u32	end;
+	/* reboot */
+#ifdef CONFIG_X86_32
+	u32	machine_real_restart_asm;
+#endif
 } __attribute__((__packed__));
 
 extern struct real_mode_header real_mode_header;
diff --git a/arch/x86/kernel/Makefile b/arch/x86/kernel/Makefile
index f9e19d4..b71ef35 100644
--- a/arch/x86/kernel/Makefile
+++ b/arch/x86/kernel/Makefile
@@ -49,7 +49,6 @@ obj-$(CONFIG_STACKTRACE)	+= stacktrace.o
 obj-y				+= cpu/
 obj-y				+= acpi/
 obj-y				+= reboot.o
-obj-$(CONFIG_X86_32)		+= reboot_32.o
 obj-$(CONFIG_MCA)		+= mca_32.o
 obj-$(CONFIG_X86_MSR)		+= msr.o
 obj-$(CONFIG_X86_CPUID)		+= cpuid.o
diff --git a/arch/x86/kernel/reboot.c b/arch/x86/kernel/reboot.c
index d840e69..050eff2 100644
--- a/arch/x86/kernel/reboot.c
+++ b/arch/x86/kernel/reboot.c
@@ -24,6 +24,7 @@
 #ifdef CONFIG_X86_32
 # include <linux/ctype.h>
 # include <linux/mc146818rtc.h>
+# include <asm/realmode.h>
 #else
 # include <asm/x86_init.h>
 #endif
@@ -332,15 +333,10 @@ static int __init reboot_init(void)
 }
 core_initcall(reboot_init);
 
-extern const unsigned char machine_real_restart_asm[];
-extern const u64 machine_real_restart_gdt[3];
-
 void machine_real_restart(unsigned int type)
 {
-	void *restart_va;
-	unsigned long restart_pa;
-	void (*restart_lowmem)(unsigned int);
-	u64 *lowmem_gdt;
+	void (*restart_lowmem)(unsigned int) = (void (*)(unsigned int))
+		real_mode_header.machine_real_restart_asm;
 
 	local_irq_disable();
 
@@ -369,21 +365,6 @@ void machine_real_restart(unsigned int type)
 	   too. */
 	*((unsigned short *)0x472) = reboot_mode;
 
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
 	/* Jump to the identity-mapped low memory code */
 	restart_lowmem(type);
 }
diff --git a/arch/x86/realmode/rm/Makefile b/arch/x86/realmode/rm/Makefile
index 7c3f202..3f851c4 100644
--- a/arch/x86/realmode/rm/Makefile
+++ b/arch/x86/realmode/rm/Makefile
@@ -12,6 +12,7 @@ subdir- := wakeup
 always := realmode.bin
 
 realmode-y			+= header.o
+realmode-$(CONFIG_X86_32)	+= reboot_32.o
 
 targets	+= $(realmode-y)
 
diff --git a/arch/x86/realmode/rm/header.S b/arch/x86/realmode/rm/header.S
index 7be17f2..db21401 100644
--- a/arch/x86/realmode/rm/header.S
+++ b/arch/x86/realmode/rm/header.S
@@ -13,4 +13,7 @@ ENTRY(real_mode_header)
 		.long	pa_text_start
 		.long	pa_ro_end
 		.long	pa_end
+#ifdef CONFIG_X86_32
+		.long	pa_machine_real_restart_asm
+#endif
 END(real_mode_header)
diff --git a/arch/x86/kernel/reboot_32.S b/arch/x86/realmode/rm/reboot_32.S
similarity index 73%
rename from arch/x86/kernel/reboot_32.S
rename to arch/x86/realmode/rm/reboot_32.S
index 1d5c46d..83803c2 100644
--- a/arch/x86/kernel/reboot_32.S
+++ b/arch/x86/realmode/rm/reboot_32.S
@@ -13,34 +13,21 @@
  *
  * This code is called with the restart type (0 = BIOS, 1 = APM) in %eax.
  */
-	.section ".x86_trampoline","a"
-	.balign 16
+	.section ".text32", "ax"
 	.code32
-ENTRY(machine_real_restart_asm)
-r_base = .
-	/* Get our own relocated address */
-	call	1f
-1:	popl	%ebx
-	subl	$(1b - r_base), %ebx
-
-	/* Compute the equivalent real-mode segment */
-	movl	%ebx, %ecx
-	shrl	$4, %ecx
-	
-	/* Patch post-real-mode segment jump */
-	movw	(dispatch_table - r_base)(%ebx,%eax,2),%ax
-	movw	%ax, (101f - r_base)(%ebx)
-	movw	%cx, (102f - r_base)(%ebx)
+	.globl machine_real_restart_asm
 
+	.balign 16
+machine_real_restart_asm:
 	/* Set up the IDT for real mode. */
-	lidtl	(machine_real_restart_idt - r_base)(%ebx)
+	lidtl	pa_machine_real_restart_idt
 
 	/*
 	 * Set up a GDT from which we can load segment descriptors for real
 	 * mode.  The GDT is not used in real mode; it is just needed here to
 	 * prepare the descriptors.
 	 */
-	lgdtl	(machine_real_restart_gdt - r_base)(%ebx)
+	lgdtl	pa_machine_real_restart_gdt
 
 	/*
 	 * Load the data segment registers with 16-bit compatible values
@@ -51,7 +38,7 @@ r_base = .
 	movl	%ecx, %fs
 	movl	%ecx, %gs
 	movl	%ecx, %ss
-	ljmpl	$8, $1f - r_base
+	ljmpw	$8, $1f
 
 /*
  * This is 16-bit protected mode code to disable paging and the cache,
@@ -76,27 +63,32 @@ r_base = .
  *
  * Most of this work is probably excessive, but it is what is tested.
  */
+	.text
 	.code16
+
+	.balign 16
+machine_real_restart_asm16:
 1:
 	xorl	%ecx, %ecx
-	movl	%cr0, %eax
-	andl	$0x00000011, %eax
-	orl	$0x60000000, %eax
-	movl	%eax, %cr0
+	movl	%cr0, %edx
+	andl	$0x00000011, %edx
+	orl	$0x60000000, %edx
+	movl	%edx, %cr0
 	movl	%ecx, %cr3
 	movl	%cr0, %edx
 	andl	$0x60000000, %edx	/* If no cache bits -> no wbinvd */
 	jz	2f
 	wbinvd
 2:
-	andb	$0x10, %al
-	movl	%eax, %cr0
+	andb	$0x10, %dl
+	movl	%edx, %cr0
 	.byte	0xea			/* ljmpw */
-101:	.word	0			/* Offset */
-102:	.word	0			/* Segment */
+	.word	3f			/* Offset */
+	.word	real_mode_seg		/* Segment */
 
-bios:
-	ljmpw	$0xf000, $0xfff0
+3:
+	testb	$0, %al
+	jz	bios
 
 apm:
 	movw	$0x1000, %ax
@@ -106,30 +98,37 @@ apm:
 	movw	$0x0001, %bx
 	movw	$0x0003, %cx
 	int	$0x15
+	/* This should never return... */
 
-END(machine_real_restart_asm)
+bios:
+	ljmpw	$0xf000, $0xfff0
 
-	.balign 16
-	/* These must match <asm/reboot.h */
-dispatch_table:
-	.word	bios - r_base
-	.word	apm - r_base
-END(dispatch_table)
+	.section ".rodata", "a"
+	.globl	machine_real_restart_idt, machine_real_restart_gdt
 
 	.balign 16
 machine_real_restart_idt:
 	.word	0xffff		/* Length - real mode default value */
 	.long	0		/* Base - real mode default value */
-END(machine_real_restart_idt)
 
 	.balign 16
-ENTRY(machine_real_restart_gdt)
-	.quad	0		/* Self-pointer, filled in by PM code */
-	.quad	0		/* 16-bit code segment, filled in by PM code */
+machine_real_restart_gdt:
+	/* Self-pointer */
+	.word	0xffff		/* Length - real mode default value */
+	.long	pa_machine_real_restart_gdt
+	.word	0
+
+	/*
+	 * 16-bit code segment pointing to real_mode_seg
+	 * Selector value 8
+	 */
+	.word	0xffff		/* Limit */
+	.long	0x9b000000 + pa_real_mode_base
+	.word	0
+
 	/*
 	 * 16-bit data segment with the selector value 16 = 0x10 and
 	 * base value 0x100; since this is consistent with real mode
 	 * semantics we don't have to reload the segments once CR0.PE = 0.
 	 */
 	.quad	GDT_ENTRY(0x0093, 0x100, 0xffff)
-END(machine_real_restart_gdt)
