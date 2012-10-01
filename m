Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751647Ab2JAOhw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2012 10:37:52 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:48782 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750888Ab2JAOhv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2012 10:37:51 -0400
Date: Mon, 1 Oct 2012 16:37:45 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] x86/platform changes for v3.7
Message-ID: <20121001143745.GA25356@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest x86-platform-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git x86-platform-for-linus

   HEAD: 64282278989d5b0398dcb3ba7904cb00c621dc35 x86: Document x86_init.paging.pagetable_init()

This cleans up some Xen-induced pagetable init code uglies,
by generalizing new platform callbacks and state: 
x86_init.paging.*.

 Thanks,

	Ingo

------------------>
Attilio Rao (5):
      x86: Remove base argument from x86_init.paging.pagetable_setup_start
      x86: Rename pagetable_setup_start() to pagetable_init()
      x86: Move paging_init() call to x86_init.paging.pagetable_init()
      x86: xen: Cleanup and remove x86_init.paging.pagetable_setup_done()
      x86: Document x86_init.paging.pagetable_init()


 arch/x86/include/asm/pgtable_types.h |  6 ++----
 arch/x86/include/asm/x86_init.h      |  9 +++++----
 arch/x86/kernel/setup.c              |  4 +---
 arch/x86/kernel/x86_init.c           |  4 +---
 arch/x86/mm/init_32.c                | 11 ++++-------
 arch/x86/xen/mmu.c                   | 18 +++++++-----------
 6 files changed, 20 insertions(+), 32 deletions(-)

diff --git a/arch/x86/include/asm/pgtable_types.h b/arch/x86/include/asm/pgtable_types.h
index 013286a..db8fec6 100644
--- a/arch/x86/include/asm/pgtable_types.h
+++ b/arch/x86/include/asm/pgtable_types.h
@@ -303,11 +303,9 @@ void set_pte_vaddr(unsigned long vaddr, pte_t pte);
 
 extern void native_pagetable_reserve(u64 start, u64 end);
 #ifdef CONFIG_X86_32
-extern void native_pagetable_setup_start(pgd_t *base);
-extern void native_pagetable_setup_done(pgd_t *base);
+extern void native_pagetable_init(void);
 #else
-#define native_pagetable_setup_start x86_init_pgd_noop
-#define native_pagetable_setup_done  x86_init_pgd_noop
+#define native_pagetable_init        paging_init
 #endif
 
 struct seq_file;
diff --git a/arch/x86/include/asm/x86_init.h b/arch/x86/include/asm/x86_init.h
index 38155f6..5769349 100644
--- a/arch/x86/include/asm/x86_init.h
+++ b/arch/x86/include/asm/x86_init.h
@@ -81,12 +81,13 @@ struct x86_init_mapping {
 
 /**
  * struct x86_init_paging - platform specific paging functions
- * @pagetable_setup_start:	platform specific pre paging_init() call
- * @pagetable_setup_done:	platform specific post paging_init() call
+ * @pagetable_init:	platform specific paging initialization call to setup
+ *			the kernel pagetables and prepare accessors functions.
+ *			Callback must call paging_init(). Called once after the
+ *			direct mapping for phys memory is available.
  */
 struct x86_init_paging {
-	void (*pagetable_setup_start)(pgd_t *base);
-	void (*pagetable_setup_done)(pgd_t *base);
+	void (*pagetable_init)(void);
 };
 
 /**
diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
index f4b9b80..4f16547 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -961,9 +961,7 @@ void __init setup_arch(char **cmdline_p)
 	kvmclock_init();
 #endif
 
-	x86_init.paging.pagetable_setup_start(swapper_pg_dir);
-	paging_init();
-	x86_init.paging.pagetable_setup_done(swapper_pg_dir);
+	x86_init.paging.pagetable_init();
 
 	if (boot_cpu_data.cpuid_level >= 0) {
 		/* A CPU has %cr4 if and only if it has CPUID */
diff --git a/arch/x86/kernel/x86_init.c b/arch/x86/kernel/x86_init.c
index 9f3167e..7a3d075 100644
--- a/arch/x86/kernel/x86_init.c
+++ b/arch/x86/kernel/x86_init.c
@@ -26,7 +26,6 @@
 
 void __cpuinit x86_init_noop(void) { }
 void __init x86_init_uint_noop(unsigned int unused) { }
-void __init x86_init_pgd_noop(pgd_t *unused) { }
 int __init iommu_init_noop(void) { return 0; }
 void iommu_shutdown_noop(void) { }
 
@@ -68,8 +67,7 @@ struct x86_init_ops x86_init __initdata = {
 	},
 
 	.paging = {
-		.pagetable_setup_start	= native_pagetable_setup_start,
-		.pagetable_setup_done	= native_pagetable_setup_done,
+		.pagetable_init		= native_pagetable_init,
 	},
 
 	.timers = {
diff --git a/arch/x86/mm/init_32.c b/arch/x86/mm/init_32.c
index 575d86f..4f04db1 100644
--- a/arch/x86/mm/init_32.c
+++ b/arch/x86/mm/init_32.c
@@ -445,10 +445,10 @@ static inline void permanent_kmaps_init(pgd_t *pgd_base)
 }
 #endif /* CONFIG_HIGHMEM */
 
-void __init native_pagetable_setup_start(pgd_t *base)
+void __init native_pagetable_init(void)
 {
 	unsigned long pfn, va;
-	pgd_t *pgd;
+	pgd_t *pgd, *base = swapper_pg_dir;
 	pud_t *pud;
 	pmd_t *pmd;
 	pte_t *pte;
@@ -475,10 +475,7 @@ void __init native_pagetable_setup_start(pgd_t *base)
 		pte_clear(NULL, va, pte);
 	}
 	paravirt_alloc_pmd(&init_mm, __pa(base) >> PAGE_SHIFT);
-}
-
-void __init native_pagetable_setup_done(pgd_t *base)
-{
+	paging_init();
 }
 
 /*
@@ -493,7 +490,7 @@ void __init native_pagetable_setup_done(pgd_t *base)
  * If we're booting paravirtualized under a hypervisor, then there are
  * more options: we may already be running PAE, and the pagetable may
  * or may not be based in swapper_pg_dir.  In any case,
- * paravirt_pagetable_setup_start() will set up swapper_pg_dir
+ * paravirt_pagetable_init() will set up swapper_pg_dir
  * appropriately for the rest of the initialization to work.
  *
  * In general, pagetable_init() assumes that the pagetable may already
diff --git a/arch/x86/xen/mmu.c b/arch/x86/xen/mmu.c
index 5141d80..7a769b7 100644
--- a/arch/x86/xen/mmu.c
+++ b/arch/x86/xen/mmu.c
@@ -1174,8 +1174,13 @@ static void xen_exit_mmap(struct mm_struct *mm)
 	spin_unlock(&mm->page_table_lock);
 }
 
-static void __init xen_pagetable_setup_start(pgd_t *base)
+static void xen_post_allocator_init(void);
+
+static void __init xen_pagetable_init(void)
 {
+	paging_init();
+	xen_setup_shared_info();
+	xen_post_allocator_init();
 }
 
 static __init void xen_mapping_pagetable_reserve(u64 start, u64 end)
@@ -1192,14 +1197,6 @@ static __init void xen_mapping_pagetable_reserve(u64 start, u64 end)
 	}
 }
 
-static void xen_post_allocator_init(void);
-
-static void __init xen_pagetable_setup_done(pgd_t *base)
-{
-	xen_setup_shared_info();
-	xen_post_allocator_init();
-}
-
 static void xen_write_cr2(unsigned long cr2)
 {
 	this_cpu_read(xen_vcpu)->arch.cr2 = cr2;
@@ -2068,8 +2065,7 @@ static const struct pv_mmu_ops xen_mmu_ops __initconst = {
 void __init xen_init_mmu_ops(void)
 {
 	x86_init.mapping.pagetable_reserve = xen_mapping_pagetable_reserve;
-	x86_init.paging.pagetable_setup_start = xen_pagetable_setup_start;
-	x86_init.paging.pagetable_setup_done = xen_pagetable_setup_done;
+	x86_init.paging.pagetable_init = xen_pagetable_init;
 	pv_mmu_ops = xen_mmu_ops;
 
 	memset(dummy_mapping, 0xff, PAGE_SIZE);
