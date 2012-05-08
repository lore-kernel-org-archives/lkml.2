Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756439Ab2EHS2W (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2012 14:28:22 -0400
Received: from mga01.intel.com ([192.55.52.88]:1552 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754960Ab2EHSXR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2012 14:23:17 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="150636976"
From: Jarkko Sakkinen <jarkko.sakkinen@intel.com>
To: linux-kernel@vger.kernel.org
Cc: linux-kbuild@vger.kernel.org, Michal Marek <mmarek@suse.cz>,
        Sam Ravnborg <sam@ravnborg.org>,
        Joseph Cihula <joseph.cihula@intel.com>,
        Shane Wang <shane.wang@intel.com>, hpa@linux.intel.com,
        Jarkko Sakkinen <jarkko.sakkinen@intel.com>
Subject: [PATCH 04/23] x86, realmode: Move reboot_32.S to unified realmode code
Date: Tue,  8 May 2012 21:22:27 +0300
Message-Id: <1336501366-28617-5-git-send-email-jarkko.sakkinen@intel.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1336501366-28617-1-git-send-email-jarkko.sakkinen@intel.com>
References: <1336501366-28617-1-git-send-email-jarkko.sakkinen@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Migrated reboot_32.S from x86_trampoline to the real-mode
blob.

Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@intel.com>
---
 arch/x86/include/asm/realmode.h  |    4 ++
 arch/x86/kernel/Makefile         |    1 -
 arch/x86/kernel/reboot.c         |   25 +------
 arch/x86/kernel/reboot_32.S      |  135 --------------------------------------
 arch/x86/realmode/rm/Makefile    |    1 +
 arch/x86/realmode/rm/header.S    |    3 +
 arch/x86/realmode/rm/reboot_32.S |  134 +++++++++++++++++++++++++++++++++++++
 7 files changed, 145 insertions(+), 158 deletions(-)
 delete mode 100644 arch/x86/kernel/reboot_32.S
 create mode 100644 arch/x86/realmode/rm/reboot_32.S

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
diff --git a/arch/x86/kernel/reboot_32.S b/arch/x86/kernel/reboot_32.S
deleted file mode 100644
index 1d5c46d..0000000
--- a/arch/x86/kernel/reboot_32.S
+++ /dev/null
@@ -1,135 +0,0 @@
-#include <linux/linkage.h>
-#include <linux/init.h>
-#include <asm/segment.h>
-#include <asm/page_types.h>
-
-/*
- * The following code and data reboots the machine by switching to real
- * mode and jumping to the BIOS reset entry point, as if the CPU has
- * really been reset.  The previous version asked the keyboard
- * controller to pulse the CPU reset line, which is more thorough, but
- * doesn't work with at least one type of 486 motherboard.  It is easy
- * to stop this code working; hence the copious comments.
- *
- * This code is called with the restart type (0 = BIOS, 1 = APM) in %eax.
- */
-	.section ".x86_trampoline","a"
-	.balign 16
-	.code32
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
-
-	/* Set up the IDT for real mode. */
-	lidtl	(machine_real_restart_idt - r_base)(%ebx)
-
-	/*
-	 * Set up a GDT from which we can load segment descriptors for real
-	 * mode.  The GDT is not used in real mode; it is just needed here to
-	 * prepare the descriptors.
-	 */
-	lgdtl	(machine_real_restart_gdt - r_base)(%ebx)
-
-	/*
-	 * Load the data segment registers with 16-bit compatible values
-	 */
-	movl	$16, %ecx
-	movl	%ecx, %ds
-	movl	%ecx, %es
-	movl	%ecx, %fs
-	movl	%ecx, %gs
-	movl	%ecx, %ss
-	ljmpl	$8, $1f - r_base
-
-/*
- * This is 16-bit protected mode code to disable paging and the cache,
- * switch to real mode and jump to the BIOS reset code.
- *
- * The instruction that switches to real mode by writing to CR0 must be
- * followed immediately by a far jump instruction, which set CS to a
- * valid value for real mode, and flushes the prefetch queue to avoid
- * running instructions that have already been decoded in protected
- * mode.
- *
- * Clears all the flags except ET, especially PG (paging), PE
- * (protected-mode enable) and TS (task switch for coprocessor state
- * save).  Flushes the TLB after paging has been disabled.  Sets CD and
- * NW, to disable the cache on a 486, and invalidates the cache.  This
- * is more like the state of a 486 after reset.  I don't know if
- * something else should be done for other chips.
- *
- * More could be done here to set up the registers as if a CPU reset had
- * occurred; hopefully real BIOSs don't assume much.  This is not the
- * actual BIOS entry point, anyway (that is at 0xfffffff0).
- *
- * Most of this work is probably excessive, but it is what is tested.
- */
-	.code16
-1:
-	xorl	%ecx, %ecx
-	movl	%cr0, %eax
-	andl	$0x00000011, %eax
-	orl	$0x60000000, %eax
-	movl	%eax, %cr0
-	movl	%ecx, %cr3
-	movl	%cr0, %edx
-	andl	$0x60000000, %edx	/* If no cache bits -> no wbinvd */
-	jz	2f
-	wbinvd
-2:
-	andb	$0x10, %al
-	movl	%eax, %cr0
-	.byte	0xea			/* ljmpw */
-101:	.word	0			/* Offset */
-102:	.word	0			/* Segment */
-
-bios:
-	ljmpw	$0xf000, $0xfff0
-
-apm:
-	movw	$0x1000, %ax
-	movw	%ax, %ss
-	movw	$0xf000, %sp
-	movw	$0x5307, %ax
-	movw	$0x0001, %bx
-	movw	$0x0003, %cx
-	int	$0x15
-
-END(machine_real_restart_asm)
-
-	.balign 16
-	/* These must match <asm/reboot.h */
-dispatch_table:
-	.word	bios - r_base
-	.word	apm - r_base
-END(dispatch_table)
-
-	.balign 16
-machine_real_restart_idt:
-	.word	0xffff		/* Length - real mode default value */
-	.long	0		/* Base - real mode default value */
-END(machine_real_restart_idt)
-
-	.balign 16
-ENTRY(machine_real_restart_gdt)
-	.quad	0		/* Self-pointer, filled in by PM code */
-	.quad	0		/* 16-bit code segment, filled in by PM code */
-	/*
-	 * 16-bit data segment with the selector value 16 = 0x10 and
-	 * base value 0x100; since this is consistent with real mode
-	 * semantics we don't have to reload the segments once CR0.PE = 0.
-	 */
-	.quad	GDT_ENTRY(0x0093, 0x100, 0xffff)
-END(machine_real_restart_gdt)
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
diff --git a/arch/x86/realmode/rm/reboot_32.S b/arch/x86/realmode/rm/reboot_32.S
new file mode 100644
index 0000000..83803c2
--- /dev/null
+++ b/arch/x86/realmode/rm/reboot_32.S
@@ -0,0 +1,134 @@
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
+	.section ".text32", "ax"
+	.code32
+	.globl machine_real_restart_asm
+
+	.balign 16
+machine_real_restart_asm:
+	/* Set up the IDT for real mode. */
+	lidtl	pa_machine_real_restart_idt
+
+	/*
+	 * Set up a GDT from which we can load segment descriptors for real
+	 * mode.  The GDT is not used in real mode; it is just needed here to
+	 * prepare the descriptors.
+	 */
+	lgdtl	pa_machine_real_restart_gdt
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
+	ljmpw	$8, $1f
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
+	.text
+	.code16
+
+	.balign 16
+machine_real_restart_asm16:
+1:
+	xorl	%ecx, %ecx
+	movl	%cr0, %edx
+	andl	$0x00000011, %edx
+	orl	$0x60000000, %edx
+	movl	%edx, %cr0
+	movl	%ecx, %cr3
+	movl	%cr0, %edx
+	andl	$0x60000000, %edx	/* If no cache bits -> no wbinvd */
+	jz	2f
+	wbinvd
+2:
+	andb	$0x10, %dl
+	movl	%edx, %cr0
+	.byte	0xea			/* ljmpw */
+	.word	3f			/* Offset */
+	.word	real_mode_seg		/* Segment */
+
+3:
+	testb	$0, %al
+	jz	bios
+
+apm:
+	movw	$0x1000, %ax
+	movw	%ax, %ss
+	movw	$0xf000, %sp
+	movw	$0x5307, %ax
+	movw	$0x0001, %bx
+	movw	$0x0003, %cx
+	int	$0x15
+	/* This should never return... */
+
+bios:
+	ljmpw	$0xf000, $0xfff0
+
+	.section ".rodata", "a"
+	.globl	machine_real_restart_idt, machine_real_restart_gdt
+
+	.balign 16
+machine_real_restart_idt:
+	.word	0xffff		/* Length - real mode default value */
+	.long	0		/* Base - real mode default value */
+
+	.balign 16
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
+	/*
+	 * 16-bit data segment with the selector value 16 = 0x10 and
+	 * base value 0x100; since this is consistent with real mode
+	 * semantics we don't have to reload the segments once CR0.PE = 0.
+	 */
+	.quad	GDT_ENTRY(0x0093, 0x100, 0xffff)
-- 
1.7.9.5

