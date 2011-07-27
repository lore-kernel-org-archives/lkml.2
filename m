Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755682Ab1G0VtL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jul 2011 17:49:11 -0400
Received: from mga09.intel.com ([134.134.136.24]:17198 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755661Ab1G0VtG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jul 2011 17:49:06 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,279,1309762800"; 
   d="scan'208";a="32826482"
From: Andi Kleen <andi@firstfloor.org>
References: <20110727247.325703029@firstfloor.org>
In-Reply-To: <20110727247.325703029@firstfloor.org>
To: stefano.stabellini@eu.citrix.com, konrad.wilk@oracle.com, gregkh@suse.de,
        ak@linux.intel.com, linux-kernel@vger.kernel.org, stable@kernel.org,
        tim.bird@am.sony.com
Subject: [PATCH] [67/99] xen: partially revert "xen: set max_pfn_mapped to the last pfn mapped"
Message-Id: <20110727214906.82D092403FF@tassilo.jf.intel.com>
Date: Wed, 27 Jul 2011 14:49:06 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>

commit a91d92875ee94e4703fd017ccaadb48cfb344994 upstream.

We only need to set max_pfn_mapped to the last pfn mapped on x86_64 to
make sure that cleanup_highmap doesn't remove important mappings at
_end.

We don't need to do this on x86_32 because cleanup_highmap is not called
on x86_32. Besides lowering max_pfn_mapped on x86_32 has the unwanted
side effect of limiting the amount of memory available for the 1:1
kernel pagetable allocation.

This patch reverts the x86_32 part of the original patch.

Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 arch/x86/xen/mmu.c |    9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

Index: linux-2.6.35.y/arch/x86/xen/mmu.c
===================================================================
--- linux-2.6.35.y.orig/arch/x86/xen/mmu.c
+++ linux-2.6.35.y/arch/x86/xen/mmu.c
@@ -1641,6 +1641,11 @@ static __init void xen_map_identity_earl
 		for (pteidx = 0; pteidx < PTRS_PER_PTE; pteidx++, pfn++) {
 			pte_t pte;
 
+#ifdef CONFIG_X86_32
+			if (pfn > max_pfn_mapped)
+				max_pfn_mapped = pfn;
+#endif
+
 			if (!pte_none(pte_page[pteidx]))
 				continue;
 
@@ -1753,7 +1758,9 @@ __init pgd_t *xen_setup_kernel_pagetable
 {
 	pmd_t *kernel_pmd;
 
-	max_pfn_mapped = PFN_DOWN(__pa(xen_start_info->mfn_list));
+	max_pfn_mapped = PFN_DOWN(__pa(xen_start_info->pt_base) +
+				  xen_start_info->nr_pt_frames * PAGE_SIZE +
+				  512*1024);
 
 	kernel_pmd = m2v(pgd[KERNEL_PGD_BOUNDARY].pgd);
 	memcpy(level2_kernel_pgt, kernel_pmd, sizeof(pmd_t) * PTRS_PER_PMD);
