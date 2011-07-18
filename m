Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753696Ab1GRMUI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jul 2011 08:20:08 -0400
Received: from smtp.citrix.com ([66.165.176.89]:58690 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751322Ab1GRMUH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jul 2011 08:20:07 -0400
X-IronPort-AV: E=Sophos;i="4.67,222,1309752000"; 
   d="scan'208";a="15127488"
From: <stefano.stabellini@eu.citrix.com>
To: hpa@zytor.com
CC: hpa@linux.intel.com, konrad.wilk@oracle.com, mingo@elte.hu,
        linux-kernel@vger.kernel.org, xen-devel@lists.xensource.com,
        Stefano.Stabellini@eu.citrix.com, yinghai@kernel.org,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Subject: [PATCH tip/x86/mm] x86_32: calculate additional memory needed by the fixmap
Date: Mon, 18 Jul 2011 13:25:31 +0100
Message-ID: <1310991931-29029-1-git-send-email-stefano.stabellini@eu.citrix.com>
X-Mailer: git-send-email 1.7.0.4
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>

When NR_CPUS increases the fixmap might need more than the page
allocated by head_32.S.
This patch introduces the logic to calculate the additional memory that
is going to be required by early_ioremap_page_table_range_init:

- enough memory to allocate the pte pages needed to cover the fixmap
virtual memory range, minus the single page allocated by head_32.S;

- account for the page already allocated by early_ioremap_init;

- account for the two additional pages that might be needed to make sure
that the kmap's ptes are contiguous.

Unfortunately this code is rather complex and depends on the behaviour
of other functions but I hope to have covered all the corner cases.

Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Reviewed-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Reported-and-Tested-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 arch/x86/mm/init.c |   47 +++++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 47 insertions(+), 0 deletions(-)

diff --git a/arch/x86/mm/init.c b/arch/x86/mm/init.c
index e72c9f8..a7ee16b 100644
--- a/arch/x86/mm/init.c
+++ b/arch/x86/mm/init.c
@@ -33,6 +33,9 @@ static void __init find_early_table_space(unsigned long start,
 {
 	unsigned long pmds = 0, ptes = 0, tables = 0, good_end = end,
 				  pud_mapped = 0, pmd_mapped = 0, size = end - start;
+	int kmap_begin_pmd_idx, kmap_end_pmd_idx;
+	int fixmap_begin_pmd_idx, fixmap_end_pmd_idx;
+	int btmap_begin_pmd_idx;
 	phys_addr_t base;
 
 	pud_mapped = DIV_ROUND_UP(PFN_PHYS(max_pfn_mapped),
@@ -92,6 +95,50 @@ static void __init find_early_table_space(unsigned long start,
 	} else
 		ptes = (size + PAGE_SIZE - 1) >> PAGE_SHIFT;
 
+#ifdef CONFIG_X86_32
+	fixmap_begin_pmd_idx = __fix_to_virt(__end_of_fixed_addresses - 1)
+		>> PMD_SHIFT;
+	/*
+	 * fixmap_end_pmd_idx is the end of the fixmap minus the PMD that
+	 * has been defined in the data section by head_32.S (see
+	 * initial_pg_fixmap).
+	 * Note: This is similar to what early_ioremap_page_table_range_init
+	 * does except that the "end" has PMD_SIZE expunged as per previous
+	 * comment.
+	 */
+	fixmap_end_pmd_idx = (FIXADDR_TOP - 1) >> PMD_SHIFT;
+	btmap_begin_pmd_idx = __fix_to_virt(FIX_BTMAP_BEGIN) >> PMD_SHIFT;
+
+	size = fixmap_end_pmd_idx - fixmap_begin_pmd_idx;
+	/*
+	 * early_ioremap_init has already allocated a PMD at
+	 * btmap_begin_pmd_idx
+	 */
+	if (btmap_begin_pmd_idx < fixmap_end_pmd_idx)
+		size--;
+
+#ifdef CONFIG_HIGHMEM
+	/*
+	 * see page_table_kmap_check: if the kmap spans multiple PMDs, make
+	 * sure the pte pages are allocated contiguously. It might need up
+	 * to two additional pte pages to replace the page declared by
+	 * head_32.S and the one allocated by early_ioremap_init, if they
+	 * are even partially used for the kmap.
+	 */
+	kmap_begin_pmd_idx = __fix_to_virt(FIX_KMAP_END) >> PMD_SHIFT;
+	kmap_end_pmd_idx = __fix_to_virt(FIX_KMAP_BEGIN) >> PMD_SHIFT;
+	if (kmap_begin_pmd_idx != kmap_end_pmd_idx) {
+		if (kmap_end_pmd_idx == fixmap_end_pmd_idx)
+			size++;
+		if (btmap_begin_pmd_idx >= kmap_begin_pmd_idx &&
+			btmap_begin_pmd_idx <= kmap_end_pmd_idx)
+			size++;
+	}
+#endif
+
+	ptes += (size * PMD_SIZE + PAGE_SIZE - 1) >> PAGE_SHIFT;
+#endif
+
 	tables += roundup(ptes * sizeof(pte_t), PAGE_SIZE);
 
 	if (!tables)
-- 
1.7.2.3

