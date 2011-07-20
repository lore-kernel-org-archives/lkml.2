Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752176Ab1GTQCX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jul 2011 12:02:23 -0400
Received: from smtp.citrix.com ([66.165.176.89]:3024 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751584Ab1GTQCW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jul 2011 12:02:22 -0400
X-IronPort-AV: E=Sophos;i="4.67,236,1309752000"; 
   d="scan'208";a="15179602"
From: <stefano.stabellini@eu.citrix.com>
To: hpa@zytor.com
CC: hpa@linux.intel.com, konrad.wilk@oracle.com, mingo@elte.hu,
        linux-kernel@vger.kernel.org, xen-devel@lists.xensource.com,
        Stefano.Stabellini@eu.citrix.com, yinghai@kernel.org,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Subject: [PATCH v2 tip/x86/mm] x86_32: calculate additional memory needed by the fixmap
Date: Wed, 20 Jul 2011 17:07:54 +0100
Message-ID: <1311178074-16833-1-git-send-email-stefano.stabellini@eu.citrix.com>
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

Changes to v1:

- refactor the fixmap space calculation in a new function to make it
easier to read and avoid compilation warnings on x86_64.

Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Reviewed-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Reported-and-Tested-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 arch/x86/mm/init.c |   53 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 53 insertions(+), 0 deletions(-)

diff --git a/arch/x86/mm/init.c b/arch/x86/mm/init.c
index 1e3098b..1fdf67e 100644
--- a/arch/x86/mm/init.c
+++ b/arch/x86/mm/init.c
@@ -28,6 +28,57 @@ int direct_gbpages
 #endif
 ;
 
+static unsigned long __init find_early_fixmap_space(void)
+{
+	unsigned long size = 0;
+#ifdef CONFIG_X86_32
+	int kmap_begin_pmd_idx, kmap_end_pmd_idx;
+	int fixmap_begin_pmd_idx, fixmap_end_pmd_idx;
+	int btmap_begin_pmd_idx;
+
+	fixmap_begin_pmd_idx =
+		__fix_to_virt(__end_of_fixed_addresses - 1) >> PMD_SHIFT;
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
+	kmap_begin_pmd_idx = __fix_to_virt(FIX_KMAP_END) >> PMD_SHIFT;
+	kmap_end_pmd_idx = __fix_to_virt(FIX_KMAP_BEGIN) >> PMD_SHIFT;
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
+	if (kmap_begin_pmd_idx != kmap_end_pmd_idx) {
+		if (kmap_end_pmd_idx == fixmap_end_pmd_idx)
+			size++;
+		if (btmap_begin_pmd_idx >= kmap_begin_pmd_idx &&
+				btmap_begin_pmd_idx <= kmap_end_pmd_idx)
+			size++;
+	}
+#endif
+#endif
+	return (size * PMD_SIZE + PAGE_SIZE - 1) >> PAGE_SHIFT;
+}
+
 static void __init find_early_table_space(unsigned long start,
 		unsigned long end, int use_pse, int use_gbpages)
 {
@@ -92,6 +143,8 @@ static void __init find_early_table_space(unsigned long start,
 	} else
 		ptes = (size + PAGE_SIZE - 1) >> PAGE_SHIFT;
 
+	ptes += find_early_fixmap_space();
+
 	tables += roundup(ptes * sizeof(pte_t), PAGE_SIZE);
 
 	if (!tables)
-- 
1.7.2.3

