Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757439Ab2EHWRk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2012 18:17:40 -0400
Received: from terminus.zytor.com ([198.137.202.10]:34450 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755623Ab2EHWRi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2012 18:17:38 -0400
Date: Tue, 8 May 2012 15:17:26 -0700
From: tip-bot for Jarkko Sakkinen <jarkko.sakkinen@intel.com>
Message-ID: <tip-48927bbb97c7d4cf343c05827ab9ac30c60678cb@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        jarkko.sakkinen@intel.com, tglx@linutronix.de, hpa@linux.intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, jarkko.sakkinen@intel.com, hpa@linux.intel.com
In-Reply-To: <1336501366-28617-6-git-send-email-jarkko.sakkinen@intel.com>
References: <1336501366-28617-6-git-send-email-jarkko.sakkinen@intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/trampoline] x86, realmode:
  Move SMP trampoline to unified realmode code
Git-Commit-ID: 48927bbb97c7d4cf343c05827ab9ac30c60678cb
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Tue, 08 May 2012 15:17:32 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  48927bbb97c7d4cf343c05827ab9ac30c60678cb
Gitweb:     http://git.kernel.org/tip/48927bbb97c7d4cf343c05827ab9ac30c60678cb
Author:     Jarkko Sakkinen <jarkko.sakkinen@intel.com>
AuthorDate: Tue, 8 May 2012 21:22:28 +0300
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Tue, 8 May 2012 11:41:51 -0700

x86, realmode: Move SMP trampoline to unified realmode code

Migrated SMP trampoline code to the real mode blob.
SMP trampoline code is not yet removed from
.x86_trampoline because it is needed by the wakeup
code.

[ hpa: always enable compiling startup_32_smp in head_32.S... it is
  only a few instructions which go into .init on UP builds, and it makes
  the rest of the code less #ifdef ugly. ]

Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@intel.com>
Link: http://lkml.kernel.org/r/1336501366-28617-6-git-send-email-jarkko.sakkinen@intel.com
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/include/asm/realmode.h                  |   18 ++++
 arch/x86/kernel/head_32.S                        |    5 +-
 arch/x86/kernel/head_64.S                        |    4 -
 arch/x86/kernel/realmode.c                       |   14 +++
 arch/x86/kernel/smpboot.c                        |   18 +++--
 arch/x86/realmode/rm/Makefile                    |    1 +
 arch/x86/realmode/rm/header.S                    |   11 +++
 arch/x86/{kernel => realmode/rm}/trampoline_32.S |   63 ++++++++-------
 arch/x86/{kernel => realmode/rm}/trampoline_64.S |   94 +++++++++++----------
 9 files changed, 137 insertions(+), 91 deletions(-)

diff --git a/arch/x86/include/asm/realmode.h b/arch/x86/include/asm/realmode.h
index bf26b06..9b4a5da 100644
--- a/arch/x86/include/asm/realmode.h
+++ b/arch/x86/include/asm/realmode.h
@@ -13,6 +13,17 @@ struct real_mode_header {
 #ifdef CONFIG_X86_32
 	u32	machine_real_restart_asm;
 #endif
+	/* SMP trampoline */
+	u32	trampoline_data;
+	u32	trampoline_status;
+#ifdef CONFIG_X86_32
+	u32	startup_32_smp;
+	u32	boot_gdt;
+#else
+	u32	startup_64_smp;
+	u32	level3_ident_pgt;
+	u32	level3_kernel_pgt;
+#endif
 } __attribute__((__packed__));
 
 extern struct real_mode_header real_mode_header;
@@ -25,6 +36,13 @@ extern unsigned long initial_gs;
 extern unsigned char real_mode_blob[];
 extern unsigned char real_mode_relocs[];
 
+#ifdef CONFIG_X86_32
+extern unsigned char startup_32_smp[];
+extern unsigned char boot_gdt[];
+#else
+extern unsigned char secondary_startup_64[];
+#endif
+
 extern void __init setup_real_mode(void);
 
 #endif /* _ARCH_X86_REALMODE_H */
diff --git a/arch/x86/kernel/head_32.S b/arch/x86/kernel/head_32.S
index ce0be7c..a3c2b4f 100644
--- a/arch/x86/kernel/head_32.S
+++ b/arch/x86/kernel/head_32.S
@@ -273,10 +273,7 @@ num_subarch_entries = (. - subarch_entries) / 4
  * If cpu hotplug is not supported then this code can go in init section
  * which will be freed later
  */
-
 __CPUINIT
-
-#ifdef CONFIG_SMP
 ENTRY(startup_32_smp)
 	cld
 	movl $(__BOOT_DS),%eax
@@ -287,7 +284,7 @@ ENTRY(startup_32_smp)
 	movl pa(stack_start),%ecx
 	movl %eax,%ss
 	leal -__PAGE_OFFSET(%ecx),%esp
-#endif /* CONFIG_SMP */
+
 default_entry:
 
 /*
diff --git a/arch/x86/kernel/head_64.S b/arch/x86/kernel/head_64.S
index 40f4eb3..d70bc2e 100644
--- a/arch/x86/kernel/head_64.S
+++ b/arch/x86/kernel/head_64.S
@@ -136,10 +136,6 @@ ident_complete:
 	/* Fixup phys_base */
 	addq	%rbp, phys_base(%rip)
 
-	/* Fixup trampoline */
-	addq	%rbp, trampoline_level4_pgt + 0(%rip)
-	addq	%rbp, trampoline_level4_pgt + (511*8)(%rip)
-
 	/* Due to ENTRY(), sometimes the empty space gets filled with
 	 * zeros. Better take a jmp than relying on empty space being
 	 * filled with 0x90 (nop)
diff --git a/arch/x86/kernel/realmode.c b/arch/x86/kernel/realmode.c
index 7415c42..a465775 100644
--- a/arch/x86/kernel/realmode.c
+++ b/arch/x86/kernel/realmode.c
@@ -58,6 +58,20 @@ void __init setup_real_mode(void)
 	/* Copied header will contain relocated physical addresses. */
 	memcpy(&real_mode_header, real_mode_base,
 	       sizeof(struct real_mode_header));
+
+#ifdef CONFIG_X86_32
+	*((u32 *)__va(real_mode_header.startup_32_smp)) = __pa(startup_32_smp);
+	*((u32 *)__va(real_mode_header.boot_gdt)) = __pa(boot_gdt);
+#else
+	*((u64 *) __va(real_mode_header.startup_64_smp)) =
+		(u64) __pa(secondary_startup_64);
+
+	*((u64 *) __va(real_mode_header.level3_ident_pgt)) =
+		__pa(level3_ident_pgt) + _KERNPG_TABLE;
+
+	*((u64 *) __va(real_mode_header.level3_kernel_pgt)) =
+		__pa(level3_kernel_pgt) + _KERNPG_TABLE;
+#endif
 }
 
 /*
diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
index 6e1e406..c7971ea 100644
--- a/arch/x86/kernel/smpboot.c
+++ b/arch/x86/kernel/smpboot.c
@@ -57,7 +57,7 @@
 #include <asm/nmi.h>
 #include <asm/irq.h>
 #include <asm/idle.h>
-#include <asm/trampoline.h>
+#include <asm/realmode.h>
 #include <asm/cpu.h>
 #include <asm/numa.h>
 #include <asm/pgtable.h>
@@ -73,6 +73,8 @@
 #include <asm/smpboot_hooks.h>
 #include <asm/i8259.h>
 
+#include <asm/realmode.h>
+
 /* State of each CPU */
 DEFINE_PER_CPU(int, cpu_state) = { 0 };
 
@@ -662,8 +664,12 @@ static void __cpuinit announce_cpu(int cpu, int apicid)
  */
 static int __cpuinit do_boot_cpu(int apicid, int cpu)
 {
+	volatile u32 *trampoline_status =
+		(volatile u32 *) __va(real_mode_header.trampoline_status);
+	/* start_ip had better be page-aligned! */
+	unsigned long start_ip = real_mode_header.trampoline_data;
+
 	unsigned long boot_error = 0;
-	unsigned long start_ip;
 	int timeout;
 	struct create_idle c_idle = {
 		.cpu	= cpu,
@@ -713,9 +719,6 @@ do_rest:
 	initial_code = (unsigned long)start_secondary;
 	stack_start  = c_idle.idle->thread.sp;
 
-	/* start_ip had better be page-aligned! */
-	start_ip = trampoline_address();
-
 	/* So we see what's up */
 	announce_cpu(cpu, apicid);
 
@@ -778,8 +781,7 @@ do_rest:
 			pr_debug("CPU%d: has booted.\n", cpu);
 		} else {
 			boot_error = 1;
-			if (*(volatile u32 *)TRAMPOLINE_SYM(trampoline_status)
-			    == 0xA5A5A5A5)
+			if (*trampoline_status == 0xA5A5A5A5)
 				/* trampoline started but...? */
 				pr_err("CPU%d: Stuck ??\n", cpu);
 			else
@@ -805,7 +807,7 @@ do_rest:
 	}
 
 	/* mark "stuck" area as not stuck */
-	*(volatile u32 *)TRAMPOLINE_SYM(trampoline_status) = 0;
+	*trampoline_status = 0;
 
 	if (get_uv_system_type() != UV_NON_UNIQUE_APIC) {
 		/*
diff --git a/arch/x86/realmode/rm/Makefile b/arch/x86/realmode/rm/Makefile
index 3f851c4..56ec64f 100644
--- a/arch/x86/realmode/rm/Makefile
+++ b/arch/x86/realmode/rm/Makefile
@@ -13,6 +13,7 @@ always := realmode.bin
 
 realmode-y			+= header.o
 realmode-$(CONFIG_X86_32)	+= reboot_32.o
+realmode-y			+= trampoline_$(BITS).o
 
 targets	+= $(realmode-y)
 
diff --git a/arch/x86/realmode/rm/header.S b/arch/x86/realmode/rm/header.S
index db21401..a979004 100644
--- a/arch/x86/realmode/rm/header.S
+++ b/arch/x86/realmode/rm/header.S
@@ -16,4 +16,15 @@ ENTRY(real_mode_header)
 #ifdef CONFIG_X86_32
 		.long	pa_machine_real_restart_asm
 #endif
+		/* SMP trampoline */
+		.long	pa_trampoline_data
+		.long	pa_trampoline_status
+#ifdef CONFIG_X86_32
+		.long	pa_startup_32_smp
+		.long	pa_boot_gdt
+#else
+		.long	pa_startup_64_smp
+		.long	pa_level3_ident_pgt
+		.long	pa_level3_kernel_pgt
+#endif
 END(real_mode_header)
diff --git a/arch/x86/kernel/trampoline_32.S b/arch/x86/realmode/rm/trampoline_32.S
similarity index 53%
copy from arch/x86/kernel/trampoline_32.S
copy to arch/x86/realmode/rm/trampoline_32.S
index 451c0a7..18cb7fc 100644
--- a/arch/x86/kernel/trampoline_32.S
+++ b/arch/x86/realmode/rm/trampoline_32.S
@@ -6,8 +6,8 @@
  *
  *	This is only used for booting secondary CPUs in SMP machine
  *
- *	Entry: CS:IP point to the start of our code, we are 
- *	in real mode with no stack, but the rest of the 
+ *	Entry: CS:IP point to the start of our code, we are
+ *	in real mode with no stack, but the rest of the
  *	trampoline page to make our stack and everything else
  *	is a mystery.
  *
@@ -15,16 +15,14 @@
  *
  *	On entry to trampoline_data, the processor is in real mode
  *	with 16-bit addressing and 16-bit data.  CS has some value
- *	and IP is zero.  Thus, data addresses need to be absolute
- *	(no relocation) and are taken with regard to r_base.
+ *	and IP is zero.  Thus, we load CS to the physical segment
+ *	of the real mode code before doing anything further.
  *
- *	If you work on this file, check the object module with
- *	objdump --reloc to make sure there are no relocation
- *	entries except for:
+ *	The structure real_mode_header includes entries that need
+ *	to be set up before executing this code:
  *
- *	TYPE              VALUE
- *	R_386_32          startup_32_smp
- *	R_386_32          boot_gdt
+ *	startup_32_smp
+ *	boot_gdt
  */
 
 #include <linux/linkage.h>
@@ -32,21 +30,24 @@
 #include <asm/segment.h>
 #include <asm/page_types.h>
 
-#ifdef CONFIG_SMP
-
-	.section ".x86_trampoline","a"
-	.balign PAGE_SIZE
+	.text
 	.code16
+	.globl trampoline_data
 
-ENTRY(trampoline_data)
-r_base = .
+	.balign PAGE_SIZE
+trampoline_data:
 	wbinvd			# Needed for NUMA-Q should be harmless for others
+
+	.byte	0xea		# ljmpw
+	.word	1f		# Offset
+	.word	real_mode_seg	# Segment
+1:
 	mov	%cs, %ax	# Code and data in the same place
 	mov	%ax, %ds
 
 	cli			# We should be safe anyway
 
-	movl	$0xA5A5A5A5, trampoline_status - r_base
+	movl	$0xA5A5A5A5, trampoline_status
 				# write marker for master knows we're running
 
 	/* GDT tables in non default location kernel can be beyond 16MB and
@@ -55,29 +56,31 @@ r_base = .
 	 * to 32 bit.
 	 */
 
-	lidtl	boot_idt_descr - r_base	# load idt with 0, 0
-	lgdtl	boot_gdt_descr - r_base	# load gdt with whatever is appropriate
+	lidtl	boot_idt_descr		# load idt with 0, 0
+	lgdtl	boot_gdt_descr		# load gdt with whatever is appropriate
 
 	xor	%ax, %ax
-	inc	%ax		# protected mode (PE) bit
-	lmsw	%ax		# into protected mode
+	inc	%ax			# protected mode (PE) bit
+	lmsw	%ax			# into protected mode
+
 	# flush prefetch and jump to startup_32_smp in arch/i386/kernel/head.S
-	ljmpl	$__BOOT_CS, $(startup_32_smp-__PAGE_OFFSET)
+	ljmpl	*(startup_32_smp)
+
+	.data
+	.globl startup_32_smp, boot_gdt, trampoline_status
 
-	# These need to be in the same 64K segment as the above;
-	# hence we don't use the boot_gdt_descr defined in head.S
 boot_gdt_descr:
 	.word	__BOOT_DS + 7			# gdt limit
-	.long	boot_gdt - __PAGE_OFFSET	# gdt base
+boot_gdt:
+	.long	0				# gdt base
 
 boot_idt_descr:
 	.word	0				# idt limit = 0
 	.long	0				# idt base = 0L
 
-ENTRY(trampoline_status)
+trampoline_status:
 	.long	0
 
-.globl trampoline_end
-trampoline_end:
-
-#endif /* CONFIG_SMP */
+startup_32_smp:
+	.long	0x00000000
+	.word	__BOOT_CS, 0
diff --git a/arch/x86/kernel/trampoline_64.S b/arch/x86/realmode/rm/trampoline_64.S
similarity index 71%
copy from arch/x86/kernel/trampoline_64.S
copy to arch/x86/realmode/rm/trampoline_64.S
index 09ff517..063da00 100644
--- a/arch/x86/kernel/trampoline_64.S
+++ b/arch/x86/realmode/rm/trampoline_64.S
@@ -5,8 +5,8 @@
  *	4 Jan 1997 Michael Chastain: changed to gnu as.
  *	15 Sept 2005 Eric Biederman: 64bit PIC support
  *
- *	Entry: CS:IP point to the start of our code, we are 
- *	in real mode with no stack, but the rest of the 
+ *	Entry: CS:IP point to the start of our code, we are
+ *	in real mode with no stack, but the rest of the
  *	trampoline page to make our stack and everything else
  *	is a mystery.
  *
@@ -32,42 +32,33 @@
 #include <asm/segment.h>
 #include <asm/processor-flags.h>
 
-	.section ".x86_trampoline","a"
+	.text
 	.balign PAGE_SIZE
 	.code16
 
 ENTRY(trampoline_data)
-r_base = .
 	cli			# We should be safe anyway
 	wbinvd
+
+	.byte	0xea		# ljmpw
+	.word	1f		# Offset
+	.word	real_mode_seg	# Segment
+1:
 	mov	%cs, %ax	# Code and data in the same place
 	mov	%ax, %ds
 	mov	%ax, %es
 	mov	%ax, %ss
 
+	movl	$0xA5A5A5A5, trampoline_status
+	# write marker for master knows we're running
 
-	movl	$0xA5A5A5A5, trampoline_status - r_base
-				# write marker for master knows we're running
-
-					# Setup stack
-	movw	$(trampoline_stack_end - r_base), %sp
+	# Setup stack
+	movw	$trampoline_stack_end, %sp
 
 	call	verify_cpu		# Verify the cpu supports long mode
 	testl   %eax, %eax		# Check for return code
 	jnz	no_longmode
 
-	mov	%cs, %ax
-	movzx	%ax, %esi		# Find the 32bit trampoline location
-	shll	$4, %esi
-
-					# Fixup the absolute vectors
-	leal	(startup_32 - r_base)(%esi), %eax
-	movl	%eax, startup_32_vector - r_base
-	leal	(startup_64 - r_base)(%esi), %eax
-	movl	%eax, startup_64_vector - r_base
-	leal	(tgdt - r_base)(%esi), %eax
-	movl	%eax, (tgdt + 2 - r_base)
-
 	/*
 	 * GDT tables in non default location kernel can be beyond 16MB and
 	 * lgdt will not be able to load the address as in real mode default
@@ -75,26 +66,34 @@ r_base = .
 	 * to 32 bit.
 	 */
 
-	lidtl	tidt - r_base	# load idt with 0, 0
-	lgdtl	tgdt - r_base	# load gdt with whatever is appropriate
+	lidtl	tidt	# load idt with 0, 0
+	lgdtl	tgdt	# load gdt with whatever is appropriate
 
 	mov	$X86_CR0_PE, %ax	# protected mode (PE) bit
 	lmsw	%ax			# into protected mode
 
 	# flush prefetch and jump to startup_32
-	ljmpl	*(startup_32_vector - r_base)
+	ljmpl	*(startup_32_vector)
+
+no_longmode:
+	hlt
+	jmp no_longmode
+#include "../kernel/verify_cpu.S"
 
 	.code32
 	.balign 4
-startup_32:
+ENTRY(startup_32)
 	movl	$__KERNEL_DS, %eax	# Initialize the %ds segment register
 	movl	%eax, %ds
 
 	movl	$X86_CR4_PAE, %eax
 	movl	%eax, %cr4		# Enable PAE mode
 
+	movl	pa_startup_64_smp, %esi
+	movl	pa_startup_64_smp_high, %edi
+
 					# Setup trampoline 4 level pagetables
-	leal	(trampoline_level4_pgt - r_base)(%esi), %eax
+	leal	pa_trampoline_level4_pgt, %eax
 	movl	%eax, %cr3
 
 	movl	$MSR_EFER, %ecx
@@ -113,22 +112,17 @@ startup_32:
 	 * EFER.LMA = 1). Now we want to jump in 64bit mode, to do that we use
 	 * the new gdt/idt that has __KERNEL_CS with CS.L = 1.
 	 */
-	ljmp	*(startup_64_vector - r_base)(%esi)
+	ljmpl	*(pa_startup_64_vector)
 
 	.code64
 	.balign 4
-startup_64:
+ENTRY(startup_64)
 	# Now jump into the kernel using virtual addresses
-	movq	$secondary_startup_64, %rax
+	movl	%edi, %eax
+	shlq	$32, %rax
+	addl	%esi, %eax
 	jmp	*%rax
 
-	.code16
-no_longmode:
-	hlt
-	jmp no_longmode
-#include "verify_cpu.S"
-
-	.balign 4
 	# Careful these need to be in the same 64K segment as the above;
 tidt:
 	.word	0			# idt limit = 0
@@ -137,10 +131,11 @@ tidt:
 	# Duplicate the global descriptor table
 	# so the kernel can live anywhere
 	.balign 4
+	.globl tgdt
 tgdt:
 	.short	tgdt_end - tgdt		# gdt limit
-	.long	tgdt - r_base
-	.short 0
+	.long	pa_tgdt
+	.short	0
 	.quad	0x00cf9b000000ffff	# __KERNEL32_CS
 	.quad	0x00af9b000000ffff	# __KERNEL_CS
 	.quad	0x00cf93000000ffff	# __KERNEL_DS
@@ -148,14 +143,17 @@ tgdt_end:
 
 	.balign 4
 startup_32_vector:
-	.long	startup_32 - r_base
+	.long	pa_startup_32
 	.word	__KERNEL32_CS, 0
 
 	.balign 4
+	.globl startup_64_vector
 startup_64_vector:
-	.long	startup_64 - r_base
+	.long	pa_startup_64
 	.word	__KERNEL_CS, 0
 
+	.data
+
 	.balign 4
 ENTRY(trampoline_status)
 	.long	0
@@ -163,9 +161,15 @@ ENTRY(trampoline_status)
 trampoline_stack:
 	.org 0x1000
 trampoline_stack_end:
-ENTRY(trampoline_level4_pgt)
-	.quad	level3_ident_pgt - __START_KERNEL_map + _KERNPG_TABLE
-	.fill	510,8,0
-	.quad	level3_kernel_pgt - __START_KERNEL_map + _KERNPG_TABLE
 
-ENTRY(trampoline_end)
+	.globl	level3_ident_pgt
+	.globl	level3_kernel_pgt
+ENTRY(trampoline_level4_pgt)
+	level3_ident_pgt:	.quad	0
+	.fill 510,8,0
+	level3_kernel_pgt:	.quad	0
+
+	.globl	startup_64_smp
+	.globl	startup_64_smp_high
+startup_64_smp:		.long 0
+startup_64_smp_high:	.long 0
