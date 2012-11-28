Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756348Ab2K1V76 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2012 16:59:58 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:44924 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756207Ab2K1Vso (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2012 16:48:44 -0500
From: Yinghai Lu <yinghai@kernel.org>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>, Jacob Shin <jacob.shin@amd.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        linux-kernel@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH v9 01/46] x86, mm: Add global page_size_mask and probe one time only
Date: Wed, 28 Nov 2012 13:47:12 -0800
Message-Id: <1354139277-17376-2-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1354139277-17376-1-git-send-email-yinghai@kernel.org>
References: <1354139277-17376-1-git-send-email-yinghai@kernel.org>
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now we pass around use_gbpages and use_pse for calculating page table size,
Later we will need to call init_memory_mapping for every ram range one by one,
that mean those calculation will be done several times.

Those information are the same for all ram range and could be stored in
page_size_mask and could be probed it one time only.

Move that probing code out of init_memory_mapping into separated function
probe_page_size_mask(), and call it before all init_memory_mapping.

Suggested-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Reviewed-by: Pekka Enberg <penberg@kernel.org>
Reviewed-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 arch/x86/include/asm/pgtable.h |    1 +
 arch/x86/kernel/setup.c        |    1 +
 arch/x86/mm/init.c             |   55 ++++++++++++++++++---------------------
 3 files changed, 27 insertions(+), 30 deletions(-)

diff --git a/arch/x86/include/asm/pgtable.h b/arch/x86/include/asm/pgtable.h
index a1f780d..98ac76d 100644
--- a/arch/x86/include/asm/pgtable.h
+++ b/arch/x86/include/asm/pgtable.h
@@ -602,6 +602,7 @@ static inline int pgd_none(pgd_t pgd)
 #ifndef __ASSEMBLY__
 
 extern int direct_gbpages;
+void probe_page_size_mask(void);
 
 /* local pte updates need not use xchg for locking */
 static inline pte_t native_local_ptep_get_and_clear(pte_t *ptep)
diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
index ca45696..01fb5f9 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -913,6 +913,7 @@ void __init setup_arch(char **cmdline_p)
 	setup_real_mode();
 
 	init_gbpages();
+	probe_page_size_mask();
 
 	/* max_pfn_mapped is updated here */
 	max_low_pfn_mapped = init_memory_mapping(0, max_low_pfn<<PAGE_SHIFT);
diff --git a/arch/x86/mm/init.c b/arch/x86/mm/init.c
index d7aea41..aa5b0da 100644
--- a/arch/x86/mm/init.c
+++ b/arch/x86/mm/init.c
@@ -35,6 +35,7 @@ struct map_range {
 	unsigned page_size_mask;
 };
 
+static int page_size_mask;
 /*
  * First calculate space needed for kernel direct mapping page tables to cover
  * mr[0].start to mr[nr_range - 1].end, while accounting for possible 2M and 1GB
@@ -94,6 +95,30 @@ static void __init find_early_table_space(struct map_range *mr, int nr_range)
 		(pgt_buf_top << PAGE_SHIFT) - 1);
 }
 
+void probe_page_size_mask(void)
+{
+#if !defined(CONFIG_DEBUG_PAGEALLOC) && !defined(CONFIG_KMEMCHECK)
+	/*
+	 * For CONFIG_DEBUG_PAGEALLOC, identity mapping will use small pages.
+	 * This will simplify cpa(), which otherwise needs to support splitting
+	 * large pages into small in interrupt context, etc.
+	 */
+	if (direct_gbpages)
+		page_size_mask |= 1 << PG_LEVEL_1G;
+	if (cpu_has_pse)
+		page_size_mask |= 1 << PG_LEVEL_2M;
+#endif
+
+	/* Enable PSE if available */
+	if (cpu_has_pse)
+		set_in_cr4(X86_CR4_PSE);
+
+	/* Enable PGE if available */
+	if (cpu_has_pge) {
+		set_in_cr4(X86_CR4_PGE);
+		__supported_pte_mask |= _PAGE_GLOBAL;
+	}
+}
 void __init native_pagetable_reserve(u64 start, u64 end)
 {
 	memblock_reserve(start, end - start);
@@ -129,45 +154,15 @@ static int __meminit save_mr(struct map_range *mr, int nr_range,
 unsigned long __init_refok init_memory_mapping(unsigned long start,
 					       unsigned long end)
 {
-	unsigned long page_size_mask = 0;
 	unsigned long start_pfn, end_pfn;
 	unsigned long ret = 0;
 	unsigned long pos;
-
 	struct map_range mr[NR_RANGE_MR];
 	int nr_range, i;
-	int use_pse, use_gbpages;
 
 	printk(KERN_INFO "init_memory_mapping: [mem %#010lx-%#010lx]\n",
 	       start, end - 1);
 
-#if defined(CONFIG_DEBUG_PAGEALLOC) || defined(CONFIG_KMEMCHECK)
-	/*
-	 * For CONFIG_DEBUG_PAGEALLOC, identity mapping will use small pages.
-	 * This will simplify cpa(), which otherwise needs to support splitting
-	 * large pages into small in interrupt context, etc.
-	 */
-	use_pse = use_gbpages = 0;
-#else
-	use_pse = cpu_has_pse;
-	use_gbpages = direct_gbpages;
-#endif
-
-	/* Enable PSE if available */
-	if (cpu_has_pse)
-		set_in_cr4(X86_CR4_PSE);
-
-	/* Enable PGE if available */
-	if (cpu_has_pge) {
-		set_in_cr4(X86_CR4_PGE);
-		__supported_pte_mask |= _PAGE_GLOBAL;
-	}
-
-	if (use_gbpages)
-		page_size_mask |= 1 << PG_LEVEL_1G;
-	if (use_pse)
-		page_size_mask |= 1 << PG_LEVEL_2M;
-
 	memset(mr, 0, sizeof(mr));
 	nr_range = 0;
 
-- 
1.7.7

