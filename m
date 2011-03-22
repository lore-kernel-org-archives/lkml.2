Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754297Ab1CVKUu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Mar 2011 06:20:50 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:56584 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754100Ab1CVKUs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Mar 2011 06:20:48 -0400
Date: Tue, 22 Mar 2011 11:20:37 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] x86 fixes
Message-ID: <20110322102037.GA31968@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest x86-fixes-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git x86-fixes-for-linus

 Thanks,

	Ingo

------------------>
Stefano Stabellini (2):
      xen: set max_pfn_mapped to the last pfn mapped
      xen: update mask_rw_pte after kernel page tables init changes

Yinghai Lu (1):
      x86: Cleanup highmap after brk is concluded


 arch/x86/kernel/head64.c |    3 ---
 arch/x86/kernel/setup.c  |   25 +++----------------------
 arch/x86/mm/init_64.c    |   11 ++++++-----
 arch/x86/xen/mmu.c       |   21 ++++++++++++---------
 4 files changed, 21 insertions(+), 39 deletions(-)

diff --git a/arch/x86/kernel/head64.c b/arch/x86/kernel/head64.c
index 2d2673c..5655c22 100644
--- a/arch/x86/kernel/head64.c
+++ b/arch/x86/kernel/head64.c
@@ -77,9 +77,6 @@ void __init x86_64_start_kernel(char * real_mode_data)
 	/* Make NULL pointers segfault */
 	zap_identity_mappings();
 
-	/* Cleanup the over mapped high alias */
-	cleanup_highmap();
-
 	max_pfn_mapped = KERNEL_IMAGE_SIZE >> PAGE_SHIFT;
 
 	for (i = 0; i < NUM_EXCEPTION_VECTORS; i++) {
diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
index b176f2b..4a52a5f 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -294,30 +294,11 @@ static void __init init_gbpages(void)
 	else
 		direct_gbpages = 0;
 }
-
-static void __init cleanup_highmap_brk_end(void)
-{
-	pud_t *pud;
-	pmd_t *pmd;
-
-	mmu_cr4_features = read_cr4();
-
-	/*
-	 * _brk_end cannot change anymore, but it and _end may be
-	 * located on different 2M pages. cleanup_highmap(), however,
-	 * can only consider _end when it runs, so destroy any
-	 * mappings beyond _brk_end here.
-	 */
-	pud = pud_offset(pgd_offset_k(_brk_end), _brk_end);
-	pmd = pmd_offset(pud, _brk_end - 1);
-	while (++pmd <= pmd_offset(pud, (unsigned long)_end - 1))
-		pmd_clear(pmd);
-}
 #else
 static inline void init_gbpages(void)
 {
 }
-static inline void cleanup_highmap_brk_end(void)
+static void __init cleanup_highmap(void)
 {
 }
 #endif
@@ -330,8 +311,6 @@ static void __init reserve_brk(void)
 	/* Mark brk area as locked down and no longer taking any
 	   new allocations */
 	_brk_start = 0;
-
-	cleanup_highmap_brk_end();
 }
 
 #ifdef CONFIG_BLK_DEV_INITRD
@@ -950,6 +929,8 @@ void __init setup_arch(char **cmdline_p)
 	 */
 	reserve_brk();
 
+	cleanup_highmap();
+
 	memblock.current_limit = get_max_mapped();
 	memblock_x86_fill();
 
diff --git a/arch/x86/mm/init_64.c b/arch/x86/mm/init_64.c
index a08a62c..7026505 100644
--- a/arch/x86/mm/init_64.c
+++ b/arch/x86/mm/init_64.c
@@ -51,6 +51,7 @@
 #include <asm/numa.h>
 #include <asm/cacheflush.h>
 #include <asm/init.h>
+#include <asm/setup.h>
 
 static int __init parse_direct_gbpages_off(char *arg)
 {
@@ -293,18 +294,18 @@ void __init init_extra_mapping_uc(unsigned long phys, unsigned long size)
  * to the compile time generated pmds. This results in invalid pmds up
  * to the point where we hit the physaddr 0 mapping.
  *
- * We limit the mappings to the region from _text to _end.  _end is
- * rounded up to the 2MB boundary. This catches the invalid pmds as
+ * We limit the mappings to the region from _text to _brk_end.  _brk_end
+ * is rounded up to the 2MB boundary. This catches the invalid pmds as
  * well, as they are located before _text:
  */
 void __init cleanup_highmap(void)
 {
 	unsigned long vaddr = __START_KERNEL_map;
-	unsigned long end = roundup((unsigned long)_end, PMD_SIZE) - 1;
+	unsigned long vaddr_end = __START_KERNEL_map + (max_pfn_mapped << PAGE_SHIFT);
+	unsigned long end = roundup((unsigned long)_brk_end, PMD_SIZE) - 1;
 	pmd_t *pmd = level2_kernel_pgt;
-	pmd_t *last_pmd = pmd + PTRS_PER_PMD;
 
-	for (; pmd < last_pmd; pmd++, vaddr += PMD_SIZE) {
+	for (; vaddr + PMD_SIZE - 1 < vaddr_end; pmd++, vaddr += PMD_SIZE) {
 		if (pmd_none(*pmd))
 			continue;
 		if (vaddr < (unsigned long) _text || vaddr > end)
diff --git a/arch/x86/xen/mmu.c b/arch/x86/xen/mmu.c
index a2d78ad..21058ad 100644
--- a/arch/x86/xen/mmu.c
+++ b/arch/x86/xen/mmu.c
@@ -1488,10 +1488,12 @@ static __init pte_t mask_rw_pte(pte_t *ptep, pte_t pte)
 	/*
 	 * If the new pfn is within the range of the newly allocated
 	 * kernel pagetable, and it isn't being mapped into an
-	 * early_ioremap fixmap slot, make sure it is RO.
+	 * early_ioremap fixmap slot as a freshly allocated page, make sure
+	 * it is RO.
 	 */
-	if (!is_early_ioremap_ptep(ptep) &&
-	    pfn >= pgt_buf_start && pfn < pgt_buf_end)
+	if (((!is_early_ioremap_ptep(ptep) &&
+			pfn >= pgt_buf_start && pfn < pgt_buf_end)) ||
+			(is_early_ioremap_ptep(ptep) && pfn != (pgt_buf_end - 1)))
 		pte = pte_wrprotect(pte);
 
 	return pte;
@@ -1701,9 +1703,6 @@ static __init void xen_map_identity_early(pmd_t *pmd, unsigned long max_pfn)
 		for (pteidx = 0; pteidx < PTRS_PER_PTE; pteidx++, pfn++) {
 			pte_t pte;
 
-			if (pfn > max_pfn_mapped)
-				max_pfn_mapped = pfn;
-
 			if (!pte_none(pte_page[pteidx]))
 				continue;
 
@@ -1761,6 +1760,12 @@ __init pgd_t *xen_setup_kernel_pagetable(pgd_t *pgd,
 	pud_t *l3;
 	pmd_t *l2;
 
+	/* max_pfn_mapped is the last pfn mapped in the initial memory
+	 * mappings. Considering that on Xen after the kernel mappings we
+	 * have the mappings of some pages that don't exist in pfn space, we
+	 * set max_pfn_mapped to the last real pfn mapped. */
+	max_pfn_mapped = PFN_DOWN(__pa(xen_start_info->mfn_list));
+
 	/* Zap identity mapping */
 	init_level4_pgt[0] = __pgd(0);
 
@@ -1865,9 +1870,7 @@ __init pgd_t *xen_setup_kernel_pagetable(pgd_t *pgd,
 	initial_kernel_pmd =
 		extend_brk(sizeof(pmd_t) * PTRS_PER_PMD, PAGE_SIZE);
 
-	max_pfn_mapped = PFN_DOWN(__pa(xen_start_info->pt_base) +
-				  xen_start_info->nr_pt_frames * PAGE_SIZE +
-				  512*1024);
+	max_pfn_mapped = PFN_DOWN(__pa(xen_start_info->mfn_list));
 
 	kernel_pmd = m2v(pgd[KERNEL_PGD_BOUNDARY].pgd);
 	memcpy(initial_kernel_pmd, kernel_pmd, sizeof(pmd_t) * PTRS_PER_PMD);
