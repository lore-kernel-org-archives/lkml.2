Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756054Ab2EHSYI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2012 14:24:08 -0400
Received: from mga01.intel.com ([192.55.52.88]:24480 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754610Ab2EHSYG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2012 14:24:06 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="150637265"
From: Jarkko Sakkinen <jarkko.sakkinen@intel.com>
To: linux-kernel@vger.kernel.org
Cc: linux-kbuild@vger.kernel.org, Michal Marek <mmarek@suse.cz>,
        Sam Ravnborg <sam@ravnborg.org>,
        Joseph Cihula <joseph.cihula@intel.com>,
        Shane Wang <shane.wang@intel.com>, hpa@linux.intel.com,
        Jarkko Sakkinen <jarkko.sakkinen@intel.com>
Subject: [PATCH 23/23] x86, realmode: read cr4 and EFER from kernel for 64-bit trampoline
Date: Tue,  8 May 2012 21:22:46 +0300
Message-Id: <1336501366-28617-24-git-send-email-jarkko.sakkinen@intel.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1336501366-28617-1-git-send-email-jarkko.sakkinen@intel.com>
References: <1336501366-28617-1-git-send-email-jarkko.sakkinen@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch changes 64-bit trampoline so that CR4 and
EFER are provided by the kernel instead of using fixed
values.

Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@intel.com>
---
 arch/x86/include/asm/processor.h         |    7 ++++++-
 arch/x86/include/asm/realmode.h          |    8 ++++++--
 arch/x86/kernel/realmode.c               |    8 ++++++++
 arch/x86/kernel/setup.c                  |    2 ++
 arch/x86/realmode/rm/header.S            |    1 +
 arch/x86/realmode/rm/trampoline_64.S     |   32 +++++++-----------------------
 arch/x86/realmode/rm/trampoline_common.S |   19 ++++++++++++++++++
 7 files changed, 49 insertions(+), 28 deletions(-)

diff --git a/arch/x86/include/asm/processor.h b/arch/x86/include/asm/processor.h
index 4fa7dcc..404583c 100644
--- a/arch/x86/include/asm/processor.h
+++ b/arch/x86/include/asm/processor.h
@@ -544,13 +544,16 @@ static inline void load_sp0(struct tss_struct *tss,
  * enable), so that any CPU's that boot up
  * after us can get the correct flags.
  */
-extern unsigned long		mmu_cr4_features;
+extern unsigned long mmu_cr4_features;
+extern u32 *trampoline_cr4_features;
 
 static inline void set_in_cr4(unsigned long mask)
 {
 	unsigned long cr4;
 
 	mmu_cr4_features |= mask;
+	if (trampoline_cr4_features)
+		*trampoline_cr4_features = mmu_cr4_features;
 	cr4 = read_cr4();
 	cr4 |= mask;
 	write_cr4(cr4);
@@ -561,6 +564,8 @@ static inline void clear_in_cr4(unsigned long mask)
 	unsigned long cr4;
 
 	mmu_cr4_features &= ~mask;
+	if (trampoline_cr4_features)
+		*trampoline_cr4_features = mmu_cr4_features;
 	cr4 = read_cr4();
 	cr4 &= ~mask;
 	write_cr4(cr4);
diff --git a/arch/x86/include/asm/realmode.h b/arch/x86/include/asm/realmode.h
index 1421eed..937dc60 100644
--- a/arch/x86/include/asm/realmode.h
+++ b/arch/x86/include/asm/realmode.h
@@ -24,18 +24,22 @@ struct real_mode_header {
 #ifdef CONFIG_X86_32
 	u32	machine_real_restart_asm;
 #endif
-} __attribute__((__packed__));
+};
 
 /* This must match data at trampoline_32/64.S */
 struct trampoline_header {
 #ifdef CONFIG_X86_32
 	u32 start;
+	u16 gdt_pad;
 	u16 gdt_limit;
 	u32 gdt_base;
 #else
 	u64 start;
+	u32 cr4;
+	u32 efer_low;
+	u32 efer_high;
 #endif
-} __attribute__((__packed__));
+};
 
 extern struct real_mode_header *real_mode_header;
 extern unsigned char real_mode_blob_end[];
diff --git a/arch/x86/kernel/realmode.c b/arch/x86/kernel/realmode.c
index 712fba8..66ac276 100644
--- a/arch/x86/kernel/realmode.c
+++ b/arch/x86/kernel/realmode.c
@@ -6,6 +6,7 @@
 #include <asm/realmode.h>
 
 struct real_mode_header *real_mode_header;
+u32 *trampoline_cr4_features;
 
 void __init setup_real_mode(void)
 {
@@ -64,7 +65,14 @@ void __init setup_real_mode(void)
 	trampoline_header->gdt_limit = __BOOT_DS + 7;
 	trampoline_header->gdt_base = __pa(boot_gdt);
 #else
+	if (rdmsr_safe(MSR_EFER, &trampoline_header->efer_low,
+		       &trampoline_header->efer_high))
+		BUG();
+
 	trampoline_header->start = (u64) secondary_startup_64;
+	trampoline_cr4_features = &trampoline_header->cr4;
+	*trampoline_cr4_features = read_cr4();
+
 	trampoline_pgd = (u64 *) __va(real_mode_header->trampoline_pgd);
 	trampoline_pgd[0] = __pa(level3_ident_pgt) + _KERNPG_TABLE;
 	trampoline_pgd[511] = __pa(level3_kernel_pgt) + _KERNPG_TABLE;
diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
index 7a14fec..efcf305 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -975,6 +975,8 @@ void __init setup_arch(char **cmdline_p)
 	if (boot_cpu_data.cpuid_level >= 0) {
 		/* A CPU has %cr4 if and only if it has CPUID */
 		mmu_cr4_features = read_cr4();
+		if (trampoline_cr4_features)
+			*trampoline_cr4_features = mmu_cr4_features;
 	}
 
 #ifdef CONFIG_X86_32
diff --git a/arch/x86/realmode/rm/header.S b/arch/x86/realmode/rm/header.S
index b4c3263..4612d53 100644
--- a/arch/x86/realmode/rm/header.S
+++ b/arch/x86/realmode/rm/header.S
@@ -9,6 +9,7 @@
 
 	.section ".header", "a"
 
+	.balign	16
 GLOBAL(real_mode_header)
 	.long	pa_text_start
 	.long	pa_ro_end
diff --git a/arch/x86/realmode/rm/trampoline_64.S b/arch/x86/realmode/rm/trampoline_64.S
index c4a60d1..023a925 100644
--- a/arch/x86/realmode/rm/trampoline_64.S
+++ b/arch/x86/realmode/rm/trampoline_64.S
@@ -34,9 +34,9 @@
 #include "realmode.h"
 
 	.text
-	.balign PAGE_SIZE
 	.code16
 
+	.balign	PAGE_SIZE
 ENTRY(trampoline_start)
 	cli			# We should be safe anyway
 	wbinvd
@@ -65,8 +65,8 @@ ENTRY(trampoline_start)
 	 * to 32 bit.
 	 */
 
-	lidtl	tidt	# load idt with 0, 0
-	lgdtl	tgdt	# load gdt with whatever is appropriate
+	lidtl	tr_idt	# load idt with 0, 0
+	lgdtl	tr_gdt	# load gdt with whatever is appropriate
 
 	movw	$__KERNEL_DS, %dx	# Data segment descriptor
 	
@@ -93,16 +93,17 @@ ENTRY(startup_32)
 	movl	%edx, %fs
 	movl	%edx, %gs
 
-	movl	$X86_CR4_PAE, %eax
+	movl	pa_tr_cr4, %eax
 	movl	%eax, %cr4		# Enable PAE mode
 
 	# Setup trampoline 4 level pagetables
 	movl	$pa_trampoline_pgd, %eax
 	movl	%eax, %cr3
 
+	# Set up EFER
+	movl	pa_tr_efer, %eax
+	movl	pa_tr_efer + 4, %edx
 	movl	$MSR_EFER, %ecx
-	movl	$((1 << _EFER_LME) | (1 << _EFER_NX)), %eax	# Enable Long Mode
-	xorl	%edx, %edx
 	wrmsr
 
 	# Enable paging and in turn activate Long Mode
@@ -124,23 +125,4 @@ ENTRY(startup_64)
 	# Now jump into the kernel using virtual addresses
 	jmpq	*tr_start(%rip)
 
-	.section ".rodata","a"
-	.balign	16
-tidt:
-	.word	0			# idt limit = 0
-	.word	0, 0			# idt base = 0L
-
-	# Duplicate the global descriptor table
-	# so the kernel can live anywhere
-	.balign 16
-	.globl tgdt
-tgdt:
-	.short	tgdt_end - tgdt - 1	# gdt limit
-	.long	pa_tgdt
-	.short	0
-	.quad	0x00cf9b000000ffff	# __KERNEL32_CS
-	.quad	0x00af9b000000ffff	# __KERNEL_CS
-	.quad	0x00cf93000000ffff	# __KERNEL_DS
-tgdt_end:
-
 #include "trampoline_common.S"
diff --git a/arch/x86/realmode/rm/trampoline_common.S b/arch/x86/realmode/rm/trampoline_common.S
index c3f951c..cac444b 100644
--- a/arch/x86/realmode/rm/trampoline_common.S
+++ b/arch/x86/realmode/rm/trampoline_common.S
@@ -1,5 +1,20 @@
 	.section ".rodata","a"
 
+#ifdef CONFIG_X86_64
+	# Duplicate the global descriptor table
+	# so the kernel can live anywhere
+	.balign	16
+	.globl tr_gdt
+tr_gdt:
+	.short	tr_gdt_end - tr_gdt - 1	# gdt limit
+	.long	pa_tr_gdt
+	.short	0
+	.quad	0x00cf9b000000ffff	# __KERNEL32_CS
+	.quad	0x00af9b000000ffff	# __KERNEL_CS
+	.quad	0x00cf93000000ffff	# __KERNEL_DS
+tr_gdt_end:
+#endif
+
 	.balign	4
 tr_idt: .fill 1, 6, 0
 
@@ -8,12 +23,16 @@ tr_idt: .fill 1, 6, 0
 	.balign	4
 GLOBAL(trampoline_status)	.space	4
 
+	.balign	8
 GLOBAL(trampoline_header)
 #ifdef CONFIG_X86_32
 	tr_start:		.space	4
+	tr_gdt_pad:		.space	2
 	tr_gdt:			.space	6
 #else
 	tr_start:		.space	8
+	GLOBAL(tr_cr4)		.space	4
+	GLOBAL(tr_efer)		.space	8
 #endif
 END(trampoline_header)
 
-- 
1.7.9.5

