Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757187Ab0HDQpK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Aug 2010 12:45:10 -0400
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:32968 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756908Ab0HDQpG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Aug 2010 12:45:06 -0400
From: Borislav Petkov <bp@amd64.org>
To: <hpa@zytor.com>, <mingo@elte.hu>, <tglx@linutronix.de>
Cc: <andreas.herrmann3@amd.com>, conny.seidel@amd.com, <joerg.roedel@amd.com>,
        Bhavna.Sarathy@amd.com, <greg@kroah.com>, <x86@kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/2] x86-32: Fix crashes with CPU hotplug on AMD machines
Date: Wed,  4 Aug 2010 18:45:15 +0200
Message-Id: <1280940316-7966-2-git-send-email-bp@amd64.org>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1280940316-7966-1-git-send-email-bp@amd64.org>
References: <1280940316-7966-1-git-send-email-bp@amd64.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Joerg Roedel <joerg.roedel@amd.com>

This patch fixes machine crashes which occur when heavily exercising the
CPU hotplug codepaths on a 32-bit kernel. These crashes are caused by
AMD Erratum 383 and result in a fatal machine check exception. Here's
the scenario:

1. On 32-bit, the swapper_pg_dir page table is used as the initial page
table for booting a secondary CPU.

2. To make this work, swapper_pg_dir needs a direct mapping of physical
memory in it (the low mappings). By adding those low, large page (2M)
mappings (PAE kernel), we create the necessary conditions for Erratum
383 to occur.

3. Other CPUs which do not participate in the off- and onlining game may
use swapper_pg_dir while the low mappings are present (when leave_mm is
called). For all steps below, the CPU referred to is a CPU that is using
swapper_pg_dir, and not the CPU which is being onlined.

4. The presence of the low mappings in swapper_pg_dir can result
in TLB entries for addresses below __PAGE_OFFSET to be established
speculatively. These TLB entries are marked global and large.

5. When the CPU with such TLB entry switches to another page table, this
TLB entry remains because it is global.

6. The process then generates an access to an address covered by the
above TLB entry but there is a permission mismatch - the TLB entry
covers a large global page not accessible to userspace.

7. Due to this permission mismatch a new 4kb, user TLB entry gets
established. Further, Erratum 383 provides for a small window of time
where both TLB entries are present. This results in an uncorrectable
machine check exception signalling a TLB multimatch which panics the
machine.

There are two ways to fix this issue:

        1. Always do a global TLB flush when a new cr3 is loaded and the
        old page table was swapper_pg_dir. I consider this a hack hard
        to understand and with performance implications

        2. Do not use swapper_pg_dir to boot secondary CPUs like 64-bit
        does.

This patch implements solution 2. It introduces a trampoline_pg_dir
which has the same layout as swapper_pg_dir with low_mappings. This page
table is used as the initial page table of the booting CPU. Later in the
bringup process, it switches to swapper_pg_dir and does a global TLB
flush. This fixes the crashes in our test cases.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
---
 arch/x86/include/asm/pgtable_32.h |    1 +
 arch/x86/include/asm/trampoline.h |    3 +++
 arch/x86/kernel/head_32.S         |    8 +++++++-
 arch/x86/kernel/setup.c           |    2 ++
 arch/x86/kernel/smpboot.c         |   18 +++---------------
 arch/x86/kernel/trampoline.c      |   18 ++++++++++++++++++
 6 files changed, 34 insertions(+), 16 deletions(-)

diff --git a/arch/x86/include/asm/pgtable_32.h b/arch/x86/include/asm/pgtable_32.h
index 2984a25..f686f49 100644
--- a/arch/x86/include/asm/pgtable_32.h
+++ b/arch/x86/include/asm/pgtable_32.h
@@ -26,6 +26,7 @@ struct mm_struct;
 struct vm_area_struct;
 
 extern pgd_t swapper_pg_dir[1024];
+extern pgd_t trampoline_pg_dir[1024];
 
 static inline void pgtable_cache_init(void) { }
 static inline void check_pgt_cache(void) { }
diff --git a/arch/x86/include/asm/trampoline.h b/arch/x86/include/asm/trampoline.h
index cb507bb..8f78fdf 100644
--- a/arch/x86/include/asm/trampoline.h
+++ b/arch/x86/include/asm/trampoline.h
@@ -13,14 +13,17 @@ extern unsigned char *trampoline_base;
 
 extern unsigned long init_rsp;
 extern unsigned long initial_code;
+extern unsigned long initial_page_table;
 extern unsigned long initial_gs;
 
 #define TRAMPOLINE_SIZE roundup(trampoline_end - trampoline_data, PAGE_SIZE)
 
 extern unsigned long setup_trampoline(void);
+extern void __init setup_trampoline_page_table(void);
 extern void __init reserve_trampoline_memory(void);
 #else
 static inline void reserve_trampoline_memory(void) {};
+extern void __init setup_trampoline_page_table(void) {};
 #endif /* CONFIG_X86_TRAMPOLINE */
 
 #endif /* __ASSEMBLY__ */
diff --git a/arch/x86/kernel/head_32.S b/arch/x86/kernel/head_32.S
index 37c3d4b..75e3981 100644
--- a/arch/x86/kernel/head_32.S
+++ b/arch/x86/kernel/head_32.S
@@ -328,7 +328,7 @@ ENTRY(startup_32_smp)
 /*
  * Enable paging
  */
-	movl $pa(swapper_pg_dir),%eax
+	movl pa(initial_page_table), %eax
 	movl %eax,%cr3		/* set the page table pointer.. */
 	movl %cr0,%eax
 	orl  $X86_CR0_PG,%eax
@@ -608,6 +608,8 @@ ignore_int:
 .align 4
 ENTRY(initial_code)
 	.long i386_start_kernel
+ENTRY(initial_page_table)
+	.long pa(swapper_pg_dir)
 
 /*
  * BSS section
@@ -623,6 +625,10 @@ ENTRY(swapper_pg_dir)
 #endif
 swapper_pg_fixmap:
 	.fill 1024,4,0
+#ifdef CONFIG_X86_TRAMPOLINE
+ENTRY(trampoline_pg_dir)
+	.fill 1024,4,0
+#endif
 ENTRY(empty_zero_page)
 	.fill 4096,1,0
 
diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
index b4ae4ac..6600cfd 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -1008,6 +1008,8 @@ void __init setup_arch(char **cmdline_p)
 	paging_init();
 	x86_init.paging.pagetable_setup_done(swapper_pg_dir);
 
+	setup_trampoline_page_table();
+
 	tboot_probe();
 
 #ifdef CONFIG_X86_64
diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
index c4f33b2..6859a42 100644
--- a/arch/x86/kernel/smpboot.c
+++ b/arch/x86/kernel/smpboot.c
@@ -73,7 +73,6 @@
 
 #ifdef CONFIG_X86_32
 u8 apicid_2_node[MAX_APICID];
-static int low_mappings;
 #endif
 
 /* State of each CPU */
@@ -300,8 +299,8 @@ notrace static void __cpuinit start_secondary(void *unused)
 	}
 
 #ifdef CONFIG_X86_32
-	while (low_mappings)
-		cpu_relax();
+	/* switch away from the trampoline page-table */
+	load_cr3(swapper_pg_dir);
 	__flush_tlb_all();
 #endif
 
@@ -754,6 +753,7 @@ do_rest:
 #ifdef CONFIG_X86_32
 	/* Stack for startup_32 can be just as for start_secondary onwards */
 	irq_ctx_init(cpu);
+	initial_page_table = __pa(&trampoline_pg_dir);
 #else
 	clear_tsk_thread_flag(c_idle.idle, TIF_FORK);
 	initial_gs = per_cpu_offset(cpu);
@@ -894,20 +894,8 @@ int __cpuinit native_cpu_up(unsigned int cpu)
 
 	per_cpu(cpu_state, cpu) = CPU_UP_PREPARE;
 
-#ifdef CONFIG_X86_32
-	/* init low mem mapping */
-	clone_pgd_range(swapper_pg_dir, swapper_pg_dir + KERNEL_PGD_BOUNDARY,
-		min_t(unsigned long, KERNEL_PGD_PTRS, KERNEL_PGD_BOUNDARY));
-	flush_tlb_all();
-	low_mappings = 1;
-
 	err = do_boot_cpu(apicid, cpu);
 
-	zap_low_mappings(false);
-	low_mappings = 0;
-#else
-	err = do_boot_cpu(apicid, cpu);
-#endif
 	if (err) {
 		pr_debug("do_boot_cpu failed %d\n", err);
 		return -EIO;
diff --git a/arch/x86/kernel/trampoline.c b/arch/x86/kernel/trampoline.c
index c652ef6..a874495 100644
--- a/arch/x86/kernel/trampoline.c
+++ b/arch/x86/kernel/trampoline.c
@@ -1,6 +1,7 @@
 #include <linux/io.h>
 
 #include <asm/trampoline.h>
+#include <asm/pgtable.h>
 #include <asm/e820.h>
 
 #if defined(CONFIG_X86_64) && defined(CONFIG_ACPI_SLEEP)
@@ -37,3 +38,20 @@ unsigned long __trampinit setup_trampoline(void)
 	memcpy(trampoline_base, trampoline_data, TRAMPOLINE_SIZE);
 	return virt_to_phys(trampoline_base);
 }
+
+void __init setup_trampoline_page_table(void)
+{
+#ifdef CONFIG_X86_32
+	/* Copy kernel address range */
+	clone_pgd_range(trampoline_pg_dir + KERNEL_PGD_BOUNDARY,
+			swapper_pg_dir + KERNEL_PGD_BOUNDARY,
+			min_t(unsigned long, KERNEL_PGD_PTRS,
+			      KERNEL_PGD_BOUNDARY));
+
+	/* Initialize low mappings */
+	clone_pgd_range(trampoline_pg_dir,
+			swapper_pg_dir + KERNEL_PGD_BOUNDARY,
+			min_t(unsigned long, KERNEL_PGD_PTRS,
+			      KERNEL_PGD_BOUNDARY));
+#endif
+}
-- 
1.6.4.4

