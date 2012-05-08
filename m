Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756228Ab2EHSZK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2012 14:25:10 -0400
Received: from mga01.intel.com ([192.55.52.88]:58189 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755908Ab2EHSYA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2012 14:24:00 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="150637217"
From: Jarkko Sakkinen <jarkko.sakkinen@intel.com>
To: linux-kernel@vger.kernel.org
Cc: linux-kbuild@vger.kernel.org, Michal Marek <mmarek@suse.cz>,
        Sam Ravnborg <sam@ravnborg.org>,
        Joseph Cihula <joseph.cihula@intel.com>,
        Shane Wang <shane.wang@intel.com>, hpa@linux.intel.com,
        Jarkko Sakkinen <jarkko.sakkinen@intel.com>
Subject: [PATCH 20/23] x86, realmode: header for trampoline code
Date: Tue,  8 May 2012 21:22:43 +0300
Message-Id: <1336501366-28617-21-git-send-email-jarkko.sakkinen@intel.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1336501366-28617-1-git-send-email-jarkko.sakkinen@intel.com>
References: <1336501366-28617-1-git-send-email-jarkko.sakkinen@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Added header for trampoline code that can be used to supply
input data to it. This makes interface between real mode code
and kernel cleaner and simpler. Replaced two confusing pointers
to level4 pgt in trampoline_64.S with a single pointer to the
beginning of the page table.

Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@intel.com>
---
 arch/x86/include/asm/realmode.h          |   32 ++++++++++++++++----------
 arch/x86/kernel/realmode.c               |   27 ++++++++++++----------
 arch/x86/kernel/smpboot.c                |    2 +-
 arch/x86/realmode/rm/header.S            |   35 +++++++++++++----------------
 arch/x86/realmode/rm/trampoline_32.S     |   36 +++++-------------------------
 arch/x86/realmode/rm/trampoline_64.S     |   18 +++++----------
 arch/x86/realmode/rm/trampoline_common.S |   23 +++++++++++++++++++
 arch/x86/realmode/rm/wakeup_asm.S        |    2 +-
 8 files changed, 87 insertions(+), 88 deletions(-)
 create mode 100644 arch/x86/realmode/rm/trampoline_common.S

diff --git a/arch/x86/include/asm/realmode.h b/arch/x86/include/asm/realmode.h
index d3ae49f..1421eed 100644
--- a/arch/x86/include/asm/realmode.h
+++ b/arch/x86/include/asm/realmode.h
@@ -8,25 +8,33 @@
 struct real_mode_header {
 	u32	text_start;
 	u32	ro_end;
-	/* reboot */
-#ifdef CONFIG_X86_32
-	u32	machine_real_restart_asm;
-#endif
 	/* SMP trampoline */
-	u32	trampoline_data;
+	u32	trampoline_start;
 	u32	trampoline_status;
-#ifdef CONFIG_X86_32
-	u32	startup_32_smp;
-	u32	boot_gdt;
-#else
-	u32	startup_64_smp;
-	u32	level3_ident_pgt;
-	u32	level3_kernel_pgt;
+	u32	trampoline_header;
+#ifdef CONFIG_X86_64
+	u32	trampoline_pgd;
 #endif
+	/* ACPI S3 wakeup */
 #ifdef CONFIG_ACPI_SLEEP
 	u32	wakeup_start;
 	u32	wakeup_header;
 #endif
+	/* APM/BIOS reboot */
+#ifdef CONFIG_X86_32
+	u32	machine_real_restart_asm;
+#endif
+} __attribute__((__packed__));
+
+/* This must match data at trampoline_32/64.S */
+struct trampoline_header {
+#ifdef CONFIG_X86_32
+	u32 start;
+	u16 gdt_limit;
+	u32 gdt_base;
+#else
+	u64 start;
+#endif
 } __attribute__((__packed__));
 
 extern struct real_mode_header *real_mode_header;
diff --git a/arch/x86/kernel/realmode.c b/arch/x86/kernel/realmode.c
index 632c810..712fba8 100644
--- a/arch/x86/kernel/realmode.c
+++ b/arch/x86/kernel/realmode.c
@@ -17,8 +17,11 @@ void __init setup_real_mode(void)
 	u16 *seg;
 	int i;
 	unsigned char *base;
-
+	struct trampoline_header *trampoline_header;
 	size_t size = PAGE_ALIGN(real_mode_blob_end - real_mode_blob);
+#ifdef CONFIG_X86_64
+	u64 *trampoline_pgd;
+#endif
 
 	/* Has to be in very low memory so we can execute real-mode AP code. */
 	mem = memblock_find_in_range(0, 1<<20, size, PAGE_SIZE);
@@ -28,7 +31,6 @@ void __init setup_real_mode(void)
 	base = __va(mem);
 	memblock_reserve(mem, size);
 	real_mode_header = (struct real_mode_header *) base;
-
 	printk(KERN_DEBUG "Base memory trampoline at [%p] %llx size %zu\n",
 	       base, (unsigned long long)mem, size);
 
@@ -53,18 +55,19 @@ void __init setup_real_mode(void)
 		*ptr += __pa(base);
 	}
 
+	/* Must be perfomed *after* relocation. */
+	trampoline_header = (struct trampoline_header *)
+		__va(real_mode_header->trampoline_header);
+
 #ifdef CONFIG_X86_32
-	*((u32 *)__va(real_mode_header->startup_32_smp)) = __pa(startup_32_smp);
-	*((u32 *)__va(real_mode_header->boot_gdt)) = __pa(boot_gdt);
+	trampoline_header->start = __pa(startup_32_smp);
+	trampoline_header->gdt_limit = __BOOT_DS + 7;
+	trampoline_header->gdt_base = __pa(boot_gdt);
 #else
-	*((u64 *) __va(real_mode_header->startup_64_smp)) =
-		(u64)secondary_startup_64;
-
-	*((u64 *) __va(real_mode_header->level3_ident_pgt)) =
-		__pa(level3_ident_pgt) + _KERNPG_TABLE;
-
-	*((u64 *) __va(real_mode_header->level3_kernel_pgt)) =
-		__pa(level3_kernel_pgt) + _KERNPG_TABLE;
+	trampoline_header->start = (u64) secondary_startup_64;
+	trampoline_pgd = (u64 *) __va(real_mode_header->trampoline_pgd);
+	trampoline_pgd[0] = __pa(level3_ident_pgt) + _KERNPG_TABLE;
+	trampoline_pgd[511] = __pa(level3_kernel_pgt) + _KERNPG_TABLE;
 #endif
 }
 
diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
index b8c0661..757c4b1 100644
--- a/arch/x86/kernel/smpboot.c
+++ b/arch/x86/kernel/smpboot.c
@@ -667,7 +667,7 @@ static int __cpuinit do_boot_cpu(int apicid, int cpu)
 	volatile u32 *trampoline_status =
 		(volatile u32 *) __va(real_mode_header->trampoline_status);
 	/* start_ip had better be page-aligned! */
-	unsigned long start_ip = real_mode_header->trampoline_data;
+	unsigned long start_ip = real_mode_header->trampoline_start;
 
 	unsigned long boot_error = 0;
 	int timeout;
diff --git a/arch/x86/realmode/rm/header.S b/arch/x86/realmode/rm/header.S
index c83005c..b4c3263 100644
--- a/arch/x86/realmode/rm/header.S
+++ b/arch/x86/realmode/rm/header.S
@@ -7,28 +7,25 @@
 #include <linux/linkage.h>
 #include <asm/page_types.h>
 
-		.section ".header", "a"
+	.section ".header", "a"
 
 GLOBAL(real_mode_header)
-		.long	pa_text_start
-		.long	pa_ro_end
-#ifdef CONFIG_X86_32
-		.long	pa_machine_real_restart_asm
-#endif
-		/* SMP trampoline */
-		.long	pa_trampoline_data
-		.long	pa_trampoline_status
-#ifdef CONFIG_X86_32
-		.long	pa_startup_32_smp
-		.long	pa_boot_gdt
-#else
-		.long	pa_startup_64_smp
-		.long	pa_level3_ident_pgt
-		.long	pa_level3_kernel_pgt
+	.long	pa_text_start
+	.long	pa_ro_end
+	/* SMP trampoline */
+	.long	pa_trampoline_start
+	.long	pa_trampoline_status
+	.long	pa_trampoline_header
+#ifdef CONFIG_X86_64
+	.long	pa_trampoline_pgd;
 #endif
-		/* ACPI sleep */
+	/* ACPI S3 wakeup */
 #ifdef CONFIG_ACPI_SLEEP
-		.long	pa_wakeup_start
-		.long	pa_wakeup_header
+	.long	pa_wakeup_start
+	.long	pa_wakeup_header
+#endif
+	/* APM/BIOS reboot */
+#ifdef CONFIG_X86_32
+	.long	pa_machine_real_restart_asm
 #endif
 END(real_mode_header)
diff --git a/arch/x86/realmode/rm/trampoline_32.S b/arch/x86/realmode/rm/trampoline_32.S
index 1ecdbb5..6fc064b 100644
--- a/arch/x86/realmode/rm/trampoline_32.S
+++ b/arch/x86/realmode/rm/trampoline_32.S
@@ -13,16 +13,10 @@
  *
  *	We jump into arch/x86/kernel/head_32.S.
  *
- *	On entry to trampoline_data, the processor is in real mode
+ *	On entry to trampoline_start, the processor is in real mode
  *	with 16-bit addressing and 16-bit data.  CS has some value
  *	and IP is zero.  Thus, we load CS to the physical segment
  *	of the real mode code before doing anything further.
- *
- *	The structure real_mode_header includes entries that need
- *	to be set up before executing this code:
- *
- *	startup_32_smp
- *	boot_gdt
  */
 
 #include <linux/linkage.h>
@@ -35,7 +29,7 @@
 	.code16
 
 	.balign	PAGE_SIZE
-ENTRY(trampoline_data)
+ENTRY(trampoline_start)
 	wbinvd			# Needed for NUMA-Q should be harmless for others
 
 	LJMPW_RM(1f)
@@ -45,7 +39,7 @@ ENTRY(trampoline_data)
 
 	cli			# We should be safe anyway
 
-	movl	startup_32_smp, %eax	# where we need to go
+	movl	tr_start, %eax	# where we need to go
 
 	movl	$0xA5A5A5A5, trampoline_status
 				# write marker for master knows we're running
@@ -56,8 +50,8 @@ ENTRY(trampoline_data)
 	 * operand size is 16bit. Use lgdtl instead to force operand size
 	 * to 32 bit.
 	 */
-	lidtl	boot_idt_descr		# load idt with 0, 0
-	lgdtl	boot_gdt_descr		# load gdt with whatever is appropriate
+	lidtl	tr_idt			# load idt with 0, 0
+	lgdtl	tr_gdt			# load gdt with whatever is appropriate
 
 	movw	$1, %dx			# protected mode (PE) bit
 	lmsw	%dx			# into protected mode
@@ -69,22 +63,4 @@ ENTRY(trampoline_data)
 ENTRY(startup_32)			# note: also used from wakeup_asm.S
 	jmp	*%eax
 
-	.section ".rodata","a"
-
-	.balign	4
-boot_idt_descr:
-	.word	0				# idt limit = 0
-	.long	0				# idt base = 0L
-
-	.data
-
-boot_gdt_descr:
-	.word	__BOOT_DS + 7			# gdt limit
-GLOBAL(boot_gdt)
-	.long	0				# gdt base
-
-	.bss
-
-	.balign	4
-GLOBAL(trampoline_status)	.space	4
-GLOBAL(startup_32_smp)		.space	4
+#include "trampoline_common.S"
diff --git a/arch/x86/realmode/rm/trampoline_64.S b/arch/x86/realmode/rm/trampoline_64.S
index 195a307..c4a60d1 100644
--- a/arch/x86/realmode/rm/trampoline_64.S
+++ b/arch/x86/realmode/rm/trampoline_64.S
@@ -10,7 +10,7 @@
  *	trampoline page to make our stack and everything else
  *	is a mystery.
  *
- *	On entry to trampoline_data, the processor is in real mode
+ *	On entry to trampoline_start, the processor is in real mode
  *	with 16-bit addressing and 16-bit data.  CS has some value
  *	and IP is zero.  Thus, data addresses need to be absolute
  *	(no relocation) and are taken with regard to r_base.
@@ -37,7 +37,7 @@
 	.balign PAGE_SIZE
 	.code16
 
-ENTRY(trampoline_data)
+ENTRY(trampoline_start)
 	cli			# We should be safe anyway
 	wbinvd
 
@@ -97,7 +97,7 @@ ENTRY(startup_32)
 	movl	%eax, %cr4		# Enable PAE mode
 
 	# Setup trampoline 4 level pagetables
-	movl	$pa_level3_ident_pgt, %eax
+	movl	$pa_trampoline_pgd, %eax
 	movl	%eax, %cr3
 
 	movl	$MSR_EFER, %ecx
@@ -122,7 +122,7 @@ ENTRY(startup_32)
 	.balign 4
 ENTRY(startup_64)
 	# Now jump into the kernel using virtual addresses
-	jmpq	*startup_64_smp(%rip)
+	jmpq	*tr_start(%rip)
 
 	.section ".rodata","a"
 	.balign	16
@@ -143,12 +143,4 @@ tgdt:
 	.quad	0x00cf93000000ffff	# __KERNEL_DS
 tgdt_end:
 
-	.bss
-
-	.balign	PAGE_SIZE
-GLOBAL(level3_ident_pgt)	.space	511*8
-GLOBAL(level3_kernel_pgt)	.space	8
-
-	.balign	8
-GLOBAL(startup_64_smp)		.space	8
-GLOBAL(trampoline_status)	.space	4
+#include "trampoline_common.S"
diff --git a/arch/x86/realmode/rm/trampoline_common.S b/arch/x86/realmode/rm/trampoline_common.S
new file mode 100644
index 0000000..c3f951c
--- /dev/null
+++ b/arch/x86/realmode/rm/trampoline_common.S
@@ -0,0 +1,23 @@
+	.section ".rodata","a"
+
+	.balign	4
+tr_idt: .fill 1, 6, 0
+
+	.bss
+
+	.balign	4
+GLOBAL(trampoline_status)	.space	4
+
+GLOBAL(trampoline_header)
+#ifdef CONFIG_X86_32
+	tr_start:		.space	4
+	tr_gdt:			.space	6
+#else
+	tr_start:		.space	8
+#endif
+END(trampoline_header)
+
+#ifdef CONFIG_X86_64
+	.balign	PAGE_SIZE
+GLOBAL(trampoline_pgd)		.space	PAGE_SIZE
+#endif
diff --git a/arch/x86/realmode/rm/wakeup_asm.S b/arch/x86/realmode/rm/wakeup_asm.S
index 8a57c5a..46108f0 100644
--- a/arch/x86/realmode/rm/wakeup_asm.S
+++ b/arch/x86/realmode/rm/wakeup_asm.S
@@ -132,7 +132,7 @@ ENTRY(wakeup_start)
 	ljmpl	$__KERNEL_CS, $pa_startup_32
 	/* -> jmp *%eax in trampoline_32.S */
 #else
-	jmp	trampoline_data
+	jmp	trampoline_start
 #endif
 
 bogus_real_magic:
-- 
1.7.9.5

