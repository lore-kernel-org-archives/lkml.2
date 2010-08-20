Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753510Ab0HTUOq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Aug 2010 16:14:46 -0400
Received: from hera.kernel.org ([140.211.167.34]:52253 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752169Ab0HTUOo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Aug 2010 16:14:44 -0400
Date: Fri, 20 Aug 2010 20:13:46 GMT
Message-Id: <201008202013.o7KKDkNA026173@hera.kernel.org>
From: "H. Peter Anvin" <hpa@linux.intel.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [GIT PULL] x86 fixes for 2.6.36-rc2
Cc: <stable@kernel.org>, Borislav Petkov <borislav.petkov@amd.com>,
        Daniel Kiper <dkiper@net-space.pl>,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Hans Rosenfeld <hans.rosenfeld@amd.com>, Ingo Molnar <mingo@elte.hu>,
        Joerg Roedel <joerg.roedel@amd.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, jeremy@goop.org,
        konrad.wilk@oracle.com, xen-devel@lists.xensource.com,
        "Rafael J. Wysocki" <rjw@sisk.pl>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 20 Aug 2010 20:13:46 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

The following changes since commit 763008c4357b73c8d18396dfd8d79dc58fa3f99d:

  Merge branch 'bugfixes' of git://git.linux-nfs.org/projects/trondmy/nfs-2.6 (2010-08-18 15:45:23 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git x86-fixes-for-linus

Borislav Petkov (1):
      x86, hotplug: Serialize CPU hotplug to avoid bringup concurrency issues

Daniel Kiper (1):
      x86, apic: Fix apic=debug boot crash

H. Peter Anvin (1):
      x86-32: Fix dummy trampoline-related inline stubs

Hans Rosenfeld (1):
      x86, cpu: Fix regression in AMD errata checking code

Joerg Roedel (1):
      x86-32: Separate 1:1 pagetables from swapper_pg_dir

 arch/x86/Kconfig                  |    5 +++
 arch/x86/include/asm/pgtable_32.h |    1 +
 arch/x86/include/asm/trampoline.h |    5 +++-
 arch/x86/kernel/apic/io_apic.c    |    2 +
 arch/x86/kernel/cpu/amd.c         |    2 +-
 arch/x86/kernel/head_32.S         |    8 +++++-
 arch/x86/kernel/setup.c           |    2 +
 arch/x86/kernel/smpboot.c         |   51 +++++++++++++++++++++++-------------
 arch/x86/kernel/trampoline.c      |   18 +++++++++++++
 9 files changed, 72 insertions(+), 22 deletions(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index a84fc34..ac7827f 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -245,6 +245,11 @@ config ARCH_HWEIGHT_CFLAGS
 
 config KTIME_SCALAR
 	def_bool X86_32
+
+config ARCH_CPU_PROBE_RELEASE
+	def_bool y
+	depends on HOTPLUG_CPU
+
 source "init/Kconfig"
 source "kernel/Kconfig.freezer"
 
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
index cb507bb..4dde797 100644
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
-static inline void reserve_trampoline_memory(void) {};
+static inline void setup_trampoline_page_table(void) {}
+static inline void reserve_trampoline_memory(void) {}
 #endif /* CONFIG_X86_TRAMPOLINE */
 
 #endif /* __ASSEMBLY__ */
diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
index 4dc0084..f1efeba 100644
--- a/arch/x86/kernel/apic/io_apic.c
+++ b/arch/x86/kernel/apic/io_apic.c
@@ -1728,6 +1728,8 @@ __apicdebuginit(void) print_IO_APIC(void)
 		struct irq_pin_list *entry;
 
 		cfg = desc->chip_data;
+		if (!cfg)
+			continue;
 		entry = cfg->irq_2_pin;
 		if (!entry)
 			continue;
diff --git a/arch/x86/kernel/cpu/amd.c b/arch/x86/kernel/cpu/amd.c
index 60a57b1..ba5f62f 100644
--- a/arch/x86/kernel/cpu/amd.c
+++ b/arch/x86/kernel/cpu/amd.c
@@ -669,7 +669,7 @@ bool cpu_has_amd_erratum(const int *erratum)
 	}
 
 	/* OSVW unavailable or ID unknown, match family-model-stepping range */
-	ms = (cpu->x86_model << 8) | cpu->x86_mask;
+	ms = (cpu->x86_model << 4) | cpu->x86_mask;
 	while ((range = *erratum++))
 		if ((cpu->x86 == AMD_MODEL_RANGE_FAMILY(range)) &&
 		    (ms >= AMD_MODEL_RANGE_START(range)) &&
diff --git a/arch/x86/kernel/head_32.S b/arch/x86/kernel/head_32.S
index ff4c453..fa8c1b8 100644
--- a/arch/x86/kernel/head_32.S
+++ b/arch/x86/kernel/head_32.S
@@ -334,7 +334,7 @@ ENTRY(startup_32_smp)
 /*
  * Enable paging
  */
-	movl $pa(swapper_pg_dir),%eax
+	movl pa(initial_page_table), %eax
 	movl %eax,%cr3		/* set the page table pointer.. */
 	movl %cr0,%eax
 	orl  $X86_CR0_PG,%eax
@@ -614,6 +614,8 @@ ignore_int:
 .align 4
 ENTRY(initial_code)
 	.long i386_start_kernel
+ENTRY(initial_page_table)
+	.long pa(swapper_pg_dir)
 
 /*
  * BSS section
@@ -629,6 +631,10 @@ ENTRY(swapper_pg_dir)
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
index b008e78..c3a4fbb 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -1014,6 +1014,8 @@ void __init setup_arch(char **cmdline_p)
 	paging_init();
 	x86_init.paging.pagetable_setup_done(swapper_pg_dir);
 
+	setup_trampoline_page_table();
+
 	tboot_probe();
 
 #ifdef CONFIG_X86_64
diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
index a5e928b..8b3bfc4 100644
--- a/arch/x86/kernel/smpboot.c
+++ b/arch/x86/kernel/smpboot.c
@@ -73,7 +73,6 @@
 
 #ifdef CONFIG_X86_32
 u8 apicid_2_node[MAX_APICID];
-static int low_mappings;
 #endif
 
 /* State of each CPU */
@@ -91,6 +90,25 @@ DEFINE_PER_CPU(int, cpu_state) = { 0 };
 static DEFINE_PER_CPU(struct task_struct *, idle_thread_array);
 #define get_idle_for_cpu(x)      (per_cpu(idle_thread_array, x))
 #define set_idle_for_cpu(x, p)   (per_cpu(idle_thread_array, x) = (p))
+
+/*
+ * We need this for trampoline_base protection from concurrent accesses when
+ * off- and onlining cores wildly.
+ */
+static DEFINE_MUTEX(x86_cpu_hotplug_driver_mutex);
+
+void cpu_hotplug_driver_lock()
+{
+        mutex_lock(&x86_cpu_hotplug_driver_mutex);
+}
+
+void cpu_hotplug_driver_unlock()
+{
+        mutex_unlock(&x86_cpu_hotplug_driver_mutex);
+}
+
+ssize_t arch_cpu_probe(const char *buf, size_t count) { return -1; }
+ssize_t arch_cpu_release(const char *buf, size_t count) { return -1; }
 #else
 static struct task_struct *idle_thread_array[NR_CPUS] __cpuinitdata ;
 #define get_idle_for_cpu(x)      (idle_thread_array[(x)])
@@ -281,6 +299,18 @@ notrace static void __cpuinit start_secondary(void *unused)
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
@@ -299,12 +329,6 @@ notrace static void __cpuinit start_secondary(void *unused)
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
@@ -750,6 +774,7 @@ do_rest:
 #ifdef CONFIG_X86_32
 	/* Stack for startup_32 can be just as for start_secondary onwards */
 	irq_ctx_init(cpu);
+	initial_page_table = __pa(&trampoline_pg_dir);
 #else
 	clear_tsk_thread_flag(c_idle.idle, TIF_FORK);
 	initial_gs = per_cpu_offset(cpu);
@@ -897,20 +922,8 @@ int __cpuinit native_cpu_up(unsigned int cpu)
 
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
