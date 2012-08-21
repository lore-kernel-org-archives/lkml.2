Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754488Ab2HUB2E (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2012 21:28:04 -0400
Received: from smtp.eu.citrix.com ([62.200.22.115]:42065 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752330Ab2HUB1c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2012 21:27:32 -0400
X-IronPort-AV: E=Sophos;i="4.77,799,1336348800"; 
   d="scan'208";a="14095096"
From: Attilio Rao <attilio.rao@citrix.com>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Ian Campbell <Ian.Campbell@citrix.com>,
        Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>, <linux-kernel@vger.kernel.org>,
        <x86@kernel.org>, <xen-devel@lists.xensource.com>
CC: Attilio Rao <attilio.rao@citrix.com>
Subject: [PATCH 3/5] X86/XEN: Introduce the x86_init.paging.pagetable_init PVOPS
Date: Tue, 21 Aug 2012 02:14:04 +0100
Message-ID: <1345511646-12427-4-git-send-email-attilio.rao@citrix.com>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1345511646-12427-1-git-send-email-attilio.rao@citrix.com>
References: <1345511646-12427-1-git-send-email-attilio.rao@citrix.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This new PVOPS is responsible to setup the kernel pagetables and
replace entirely x86_init.paging.pagetable_setup_start and
x86_init.paging.pagetable_setup_done PVOPS work.

For performance the x86_64 stub is implemented as a macro to paging_init()
rather than an actual function stub.

Signed-off-by: Attilio Rao <attilio.rao@citrix.com>
---
 arch/x86/include/asm/pgtable_types.h |    2 +
 arch/x86/include/asm/x86_init.h      |    2 +
 arch/x86/kernel/x86_init.c           |    1 +
 arch/x86/mm/init_32.c                |   35 ++++++++++++++++++++++++++++++++++
 arch/x86/xen/mmu.c                   |   12 +++++++++-
 5 files changed, 50 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/pgtable_types.h b/arch/x86/include/asm/pgtable_types.h
index 9b1c1f7..55f24b5 100644
--- a/arch/x86/include/asm/pgtable_types.h
+++ b/arch/x86/include/asm/pgtable_types.h
@@ -303,9 +303,11 @@ void set_pte_vaddr(unsigned long vaddr, pte_t pte);
 
 extern void native_pagetable_reserve(u64 start, u64 end);
 #ifdef CONFIG_X86_32
+extern void native_pagetable_init(void);
 extern void native_pagetable_setup_start(void);
 extern void native_pagetable_setup_done(void);
 #else
+#define native_pagetable_init        paging_init
 #define native_pagetable_setup_start x86_init_pgd_noop
 #define native_pagetable_setup_done  x86_init_pgd_noop
 #endif
diff --git a/arch/x86/include/asm/x86_init.h b/arch/x86/include/asm/x86_init.h
index efd0075..a74cc19 100644
--- a/arch/x86/include/asm/x86_init.h
+++ b/arch/x86/include/asm/x86_init.h
@@ -81,10 +81,12 @@ struct x86_init_mapping {
 
 /**
  * struct x86_init_paging - platform specific paging functions
+ * @pagetable_init:		platform specific paging initialization call
  * @pagetable_setup_start:	platform specific pre paging_init() call
  * @pagetable_setup_done:	platform specific post paging_init() call
  */
 struct x86_init_paging {
+	void (*pagetable_init)(void);
 	void (*pagetable_setup_start)(void);
 	void (*pagetable_setup_done)(void);
 };
diff --git a/arch/x86/kernel/x86_init.c b/arch/x86/kernel/x86_init.c
index 849be14..c1e910a 100644
--- a/arch/x86/kernel/x86_init.c
+++ b/arch/x86/kernel/x86_init.c
@@ -68,6 +68,7 @@ struct x86_init_ops x86_init __initdata = {
 	},
 
 	.paging = {
+		.pagetable_init		= native_pagetable_init,
 		.pagetable_setup_start	= native_pagetable_setup_start,
 		.pagetable_setup_done	= native_pagetable_setup_done,
 	},
diff --git a/arch/x86/mm/init_32.c b/arch/x86/mm/init_32.c
index 7999cef..2ff4790 100644
--- a/arch/x86/mm/init_32.c
+++ b/arch/x86/mm/init_32.c
@@ -445,6 +445,41 @@ static inline void permanent_kmaps_init(pgd_t *pgd_base)
 }
 #endif /* CONFIG_HIGHMEM */
 
+void __init native_pagetable_init(void)
+{
+	unsigned long pfn, va;
+	pgd_t *base;
+	pgd_t *pgd;
+	pud_t *pud;
+	pmd_t *pmd;
+	pte_t *pte;
+
+	base = swapper_pg_dir;
+
+	/*
+	 * Remove any mappings which extend past the end of physical
+	 * memory from the boot time page table:
+	 */
+	for (pfn = max_low_pfn + 1; pfn < 1<<(32-PAGE_SHIFT); pfn++) {
+		va = PAGE_OFFSET + (pfn<<PAGE_SHIFT);
+		pgd = base + pgd_index(va);
+		if (!pgd_present(*pgd))
+			break;
+
+		pud = pud_offset(pgd, va);
+		pmd = pmd_offset(pud, va);
+		if (!pmd_present(*pmd))
+			break;
+
+		pte = pte_offset_kernel(pmd, va);
+		if (!pte_present(*pte))
+			break;
+
+		pte_clear(NULL, va, pte);
+	}
+	paravirt_alloc_pmd(&init_mm, __pa(base) >> PAGE_SHIFT);
+	paging_init();
+}
 void __init native_pagetable_setup_start(void)
 {
 	unsigned long pfn, va;
diff --git a/arch/x86/xen/mmu.c b/arch/x86/xen/mmu.c
index 04a0a8f..68466ce 100644
--- a/arch/x86/xen/mmu.c
+++ b/arch/x86/xen/mmu.c
@@ -1174,6 +1174,15 @@ static void xen_exit_mmap(struct mm_struct *mm)
 	spin_unlock(&mm->page_table_lock);
 }
 
+static void xen_post_allocator_init(void);
+
+static void __init xen_pagetable_init(void)
+{
+	paging_init();
+	xen_setup_shared_info();
+	xen_post_allocator_init();
+}
+
 static void __init xen_pagetable_setup_start(void)
 {
 }
@@ -1192,8 +1201,6 @@ static __init void xen_mapping_pagetable_reserve(u64 start, u64 end)
 	}
 }
 
-static void xen_post_allocator_init(void);
-
 static void __init xen_pagetable_setup_done(void)
 {
 	xen_setup_shared_info();
@@ -2068,6 +2075,7 @@ static const struct pv_mmu_ops xen_mmu_ops __initconst = {
 void __init xen_init_mmu_ops(void)
 {
 	x86_init.mapping.pagetable_reserve = xen_mapping_pagetable_reserve;
+	x86_init.paging.pagetable_init = xen_pagetable_init;
 	x86_init.paging.pagetable_setup_start = xen_pagetable_setup_start;
 	x86_init.paging.pagetable_setup_done = xen_pagetable_setup_done;
 	pv_mmu_ops = xen_mmu_ops;
-- 
1.7.2.5

