Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753699Ab0HPMgs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Aug 2010 08:36:48 -0400
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:35732 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752101Ab0HPMgr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Aug 2010 08:36:47 -0400
Date: Mon, 16 Aug 2010 14:38:33 +0200
From: Borislav Petkov <bp@amd64.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Joerg Roedel <joro@8bytes.org>, "Roedel, Joerg" <Joerg.Roedel@amd.com>,
        "mingo@elte.hu" <mingo@elte.hu>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "Herrmann3, Andreas" <Andreas.Herrmann3@amd.com>,
        "Seidel, Conny" <Conny.Seidel@amd.com>,
        "Sarathy, Bhavna" <Bhavna.Sarathy@amd.com>,
        "greg@kroah.com" <greg@kroah.com>, "x86@kernel.org" <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH -v2 1/2] x86-32: Fix crashes with CPU hotplug on AMD
 machines
Message-ID: <20100816123833.GB28147@aftab>
References: <4C59F24B.1010702@zytor.com>
 <20100805074503.GI18307@amd.com>
 <4C5AC736.20903@zytor.com>
 <20100812144142.GY23755@8bytes.org>
 <4C64148D.5080305@zytor.com>
 <20100812170644.GZ23755@8bytes.org>
 <4C644507.9020606@zytor.com>
 <20100812190414.GA23755@8bytes.org>
 <20100813123543.GC9046@aftab>
 <20100816121933.GA28147@aftab>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100816121933.GA28147@aftab>
User-Agent: Mutt/1.5.20 (2009-06-14)
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

-v2: switch to swapper_pg_dir right after entering start_secondary() so
that we are able to access percpu data which might not be mapped in the
trampoline page table.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
---
 arch/x86/include/asm/pgtable_32.h |    1 +
 arch/x86/include/asm/trampoline.h |    3 +++
 arch/x86/kernel/head_32.S         |    8 +++++++-
 arch/x86/kernel/setup.c           |    2 ++
 arch/x86/kernel/smpboot.c         |   32 +++++++++++++-------------------
 arch/x86/kernel/trampoline.c      |   18 ++++++++++++++++++
 6 files changed, 44 insertions(+), 20 deletions(-)

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
index c4f33b2..2d148a9 100644
--- a/arch/x86/kernel/smpboot.c
+++ b/arch/x86/kernel/smpboot.c
@@ -73,7 +73,6 @@
 
 #ifdef CONFIG_X86_32
 u8 apicid_2_node[MAX_APICID];
-static int low_mappings;
 #endif
 
 /* State of each CPU */
@@ -281,6 +280,18 @@ notrace static void __cpuinit start_secondary(void *unused)
 	 * fragile that we want to limit the things done here to the
 	 * most necessary things.
 	 */
+
+#ifdef CONFIG_X86_32
+	/*
+	 * Switch away from the trampoline page-table
+	 *
+	 * Do this before cpu_init() because it needs to access per-cpu
+	 * data which may not be mapped in the trampoline page-table.
+	 */
+	load_cr3(swapper_pg_dir);
+	__flush_tlb_all();
+#endif
+
 	vmi_bringup();
 	cpu_init();
 	preempt_disable();
@@ -299,12 +310,6 @@ notrace static void __cpuinit start_secondary(void *unused)
 		legacy_pic->chip->unmask(0);
 	}
 
-#ifdef CONFIG_X86_32
-	while (low_mappings)
-		cpu_relax();
-	__flush_tlb_all();
-#endif
-
 	/* This must be done before setting cpu_online_mask */
 	set_cpu_sibling_map(raw_smp_processor_id());
 	wmb();
@@ -754,6 +759,7 @@ do_rest:
 #ifdef CONFIG_X86_32
 	/* Stack for startup_32 can be just as for start_secondary onwards */
 	irq_ctx_init(cpu);
+	initial_page_table = __pa(&trampoline_pg_dir);
 #else
 	clear_tsk_thread_flag(c_idle.idle, TIF_FORK);
 	initial_gs = per_cpu_offset(cpu);
@@ -894,20 +900,8 @@ int __cpuinit native_cpu_up(unsigned int cpu)
 
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
1.7.1


-- 
Regards/Gruss,
Boris.
