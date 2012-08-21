Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754633Ab2HUB2I (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2012 21:28:08 -0400
Received: from smtp.ctxuk.citrix.com ([62.200.22.115]:3114 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752795Ab2HUB1e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2012 21:27:34 -0400
X-IronPort-AV: E=Sophos;i="4.77,799,1336348800"; 
   d="scan'208";a="14095097"
From: Attilio Rao <attilio.rao@citrix.com>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Ian Campbell <Ian.Campbell@citrix.com>,
        Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>, <linux-kernel@vger.kernel.org>,
        <x86@kernel.org>, <xen-devel@lists.xensource.com>
CC: Attilio Rao <attilio.rao@citrix.com>
Subject: [PATCH 4/5] X86/XEN: Retire now unused x86_init.paging.pagetable_setup_start and x86_init.paging.pagetable_setup_done PVOPS
Date: Tue, 21 Aug 2012 02:14:05 +0100
Message-ID: <1345511646-12427-5-git-send-email-attilio.rao@citrix.com>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1345511646-12427-1-git-send-email-attilio.rao@citrix.com>
References: <1345511646-12427-1-git-send-email-attilio.rao@citrix.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now that x86_init.paging.pagetable_init PVOPS is implemented just
retire the 2 mentioned above and replace their usage with it.

Signed-off-by: Attilio Rao <attilio.rao@citrix.com>
---
 arch/x86/include/asm/pgtable_types.h |    4 ---
 arch/x86/include/asm/x86_init.h      |    4 ---
 arch/x86/kernel/setup.c              |    4 +--
 arch/x86/kernel/x86_init.c           |    3 --
 arch/x86/mm/init_32.c                |   40 +---------------------------------
 arch/x86/xen/mmu.c                   |   12 ----------
 6 files changed, 2 insertions(+), 65 deletions(-)

diff --git a/arch/x86/include/asm/pgtable_types.h b/arch/x86/include/asm/pgtable_types.h
index 55f24b5..db8fec6 100644
--- a/arch/x86/include/asm/pgtable_types.h
+++ b/arch/x86/include/asm/pgtable_types.h
@@ -304,12 +304,8 @@ void set_pte_vaddr(unsigned long vaddr, pte_t pte);
 extern void native_pagetable_reserve(u64 start, u64 end);
 #ifdef CONFIG_X86_32
 extern void native_pagetable_init(void);
-extern void native_pagetable_setup_start(void);
-extern void native_pagetable_setup_done(void);
 #else
 #define native_pagetable_init        paging_init
-#define native_pagetable_setup_start x86_init_pgd_noop
-#define native_pagetable_setup_done  x86_init_pgd_noop
 #endif
 
 struct seq_file;
diff --git a/arch/x86/include/asm/x86_init.h b/arch/x86/include/asm/x86_init.h
index a74cc19..995ea5c 100644
--- a/arch/x86/include/asm/x86_init.h
+++ b/arch/x86/include/asm/x86_init.h
@@ -82,13 +82,9 @@ struct x86_init_mapping {
 /**
  * struct x86_init_paging - platform specific paging functions
  * @pagetable_init:		platform specific paging initialization call
- * @pagetable_setup_start:	platform specific pre paging_init() call
- * @pagetable_setup_done:	platform specific post paging_init() call
  */
 struct x86_init_paging {
 	void (*pagetable_init)(void);
-	void (*pagetable_setup_start)(void);
-	void (*pagetable_setup_done)(void);
 };
 
 /**
diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
index d3d8f00..4f16547 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -961,9 +961,7 @@ void __init setup_arch(char **cmdline_p)
 	kvmclock_init();
 #endif
 
-	x86_init.paging.pagetable_setup_start();
-	paging_init();
-	x86_init.paging.pagetable_setup_done();
+	x86_init.paging.pagetable_init();
 
 	if (boot_cpu_data.cpuid_level >= 0) {
 		/* A CPU has %cr4 if and only if it has CPUID */
diff --git a/arch/x86/kernel/x86_init.c b/arch/x86/kernel/x86_init.c
index c1e910a..7a3d075 100644
--- a/arch/x86/kernel/x86_init.c
+++ b/arch/x86/kernel/x86_init.c
@@ -26,7 +26,6 @@
 
 void __cpuinit x86_init_noop(void) { }
 void __init x86_init_uint_noop(unsigned int unused) { }
-void __init x86_init_pgd_noop(void) { }
 int __init iommu_init_noop(void) { return 0; }
 void iommu_shutdown_noop(void) { }
 
@@ -69,8 +68,6 @@ struct x86_init_ops x86_init __initdata = {
 
 	.paging = {
 		.pagetable_init		= native_pagetable_init,
-		.pagetable_setup_start	= native_pagetable_setup_start,
-		.pagetable_setup_done	= native_pagetable_setup_done,
 	},
 
 	.timers = {
diff --git a/arch/x86/mm/init_32.c b/arch/x86/mm/init_32.c
index 2ff4790..f8771ad 100644
--- a/arch/x86/mm/init_32.c
+++ b/arch/x86/mm/init_32.c
@@ -480,44 +480,6 @@ void __init native_pagetable_init(void)
 	paravirt_alloc_pmd(&init_mm, __pa(base) >> PAGE_SHIFT);
 	paging_init();
 }
-void __init native_pagetable_setup_start(void)
-{
-	unsigned long pfn, va;
-	pgd_t *base;
-	pgd_t *pgd;
-	pud_t *pud;
-	pmd_t *pmd;
-	pte_t *pte;
-
-	base = swapper_pg_dir;
-
-	/*
-	 * Remove any mappings which extend past the end of physical
-	 * memory from the boot time page table:
-	 */
-	for (pfn = max_low_pfn + 1; pfn < 1<<(32-PAGE_SHIFT); pfn++) {
-		va = PAGE_OFFSET + (pfn<<PAGE_SHIFT);
-		pgd = base + pgd_index(va);
-		if (!pgd_present(*pgd))
-			break;
-
-		pud = pud_offset(pgd, va);
-		pmd = pmd_offset(pud, va);
-		if (!pmd_present(*pmd))
-			break;
-
-		pte = pte_offset_kernel(pmd, va);
-		if (!pte_present(*pte))
-			break;
-
-		pte_clear(NULL, va, pte);
-	}
-	paravirt_alloc_pmd(&init_mm, __pa(base) >> PAGE_SHIFT);
-}
-
-void __init native_pagetable_setup_done(void)
-{
-}
 
 /*
  * Build a proper pagetable for the kernel mappings.  Up until this
@@ -531,7 +493,7 @@ void __init native_pagetable_setup_done(void)
  * If we're booting paravirtualized under a hypervisor, then there are
  * more options: we may already be running PAE, and the pagetable may
  * or may not be based in swapper_pg_dir.  In any case,
- * paravirt_pagetable_setup_start() will set up swapper_pg_dir
+ * paravirt_pagetable_init() will set up swapper_pg_dir
  * appropriately for the rest of the initialization to work.
  *
  * In general, pagetable_init() assumes that the pagetable may already
diff --git a/arch/x86/xen/mmu.c b/arch/x86/xen/mmu.c
index 68466ce..4290d83 100644
--- a/arch/x86/xen/mmu.c
+++ b/arch/x86/xen/mmu.c
@@ -1183,10 +1183,6 @@ static void __init xen_pagetable_init(void)
 	xen_post_allocator_init();
 }
 
-static void __init xen_pagetable_setup_start(void)
-{
-}
-
 static __init void xen_mapping_pagetable_reserve(u64 start, u64 end)
 {
 	/* reserve the range used */
@@ -1201,12 +1197,6 @@ static __init void xen_mapping_pagetable_reserve(u64 start, u64 end)
 	}
 }
 
-static void __init xen_pagetable_setup_done(void)
-{
-	xen_setup_shared_info();
-	xen_post_allocator_init();
-}
-
 static void xen_write_cr2(unsigned long cr2)
 {
 	this_cpu_read(xen_vcpu)->arch.cr2 = cr2;
@@ -2076,8 +2066,6 @@ void __init xen_init_mmu_ops(void)
 {
 	x86_init.mapping.pagetable_reserve = xen_mapping_pagetable_reserve;
 	x86_init.paging.pagetable_init = xen_pagetable_init;
-	x86_init.paging.pagetable_setup_start = xen_pagetable_setup_start;
-	x86_init.paging.pagetable_setup_done = xen_pagetable_setup_done;
 	pv_mmu_ops = xen_mmu_ops;
 
 	memset(dummy_mapping, 0xff, PAGE_SIZE);
-- 
1.7.2.5

