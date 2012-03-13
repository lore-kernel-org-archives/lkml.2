Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757355Ab2CMARa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2012 20:17:30 -0400
Received: from mail.windriver.com ([147.11.1.11]:46483 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756530Ab2CMARY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2012 20:17:24 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: stable@kernel.org, linux-kernel@vger.kernel.org
Cc: stable-review@kernel.org,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [34-longterm 001/196] xen: set max_pfn_mapped to the last pfn mapped
Date: Mon, 12 Mar 2012 20:12:09 -0400
Message-Id: <1331597724-31358-2-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.9.3
In-Reply-To: <1331597724-31358-1-git-send-email-paul.gortmaker@windriver.com>
References: <1331597724-31358-1-git-send-email-paul.gortmaker@windriver.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    If you see a problem with using this for longterm, please comment.
                   -------------------

commit 14988a4d350ce3b41ecad4f63c4f44c56f5ae34d upstream.

Do not set max_pfn_mapped to the end of the initial memory mappings,
that also contain pages that don't belong in pfn space (like the mfn
list).

Set max_pfn_mapped to the last real pfn mapped in the initial memory
mappings that is the pfn backing _end.

Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Acked-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
LKML-Reference: <alpine.DEB.2.00.1103171739050.3382@kaball-desktop>
Signed-off-by: H. Peter Anvin <hpa@zytor.com>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 arch/x86/xen/mmu.c |   13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/arch/x86/xen/mmu.c b/arch/x86/xen/mmu.c
index 914f046..6adff93 100644
--- a/arch/x86/xen/mmu.c
+++ b/arch/x86/xen/mmu.c
@@ -1641,9 +1641,6 @@ static __init void xen_map_identity_early(pmd_t *pmd, unsigned long max_pfn)
 		for (pteidx = 0; pteidx < PTRS_PER_PTE; pteidx++, pfn++) {
 			pte_t pte;
 
-			if (pfn > max_pfn_mapped)
-				max_pfn_mapped = pfn;
-
 			if (!pte_none(pte_page[pteidx]))
 				continue;
 
@@ -1687,6 +1684,12 @@ __init pgd_t *xen_setup_kernel_pagetable(pgd_t *pgd,
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
 
@@ -1750,9 +1753,7 @@ __init pgd_t *xen_setup_kernel_pagetable(pgd_t *pgd,
 {
 	pmd_t *kernel_pmd;
 
-	max_pfn_mapped = PFN_DOWN(__pa(xen_start_info->pt_base) +
-				  xen_start_info->nr_pt_frames * PAGE_SIZE +
-				  512*1024);
+	max_pfn_mapped = PFN_DOWN(__pa(xen_start_info->mfn_list));
 
 	kernel_pmd = m2v(pgd[KERNEL_PGD_BOUNDARY].pgd);
 	memcpy(level2_kernel_pgt, kernel_pmd, sizeof(pmd_t) * PTRS_PER_PMD);
-- 
1.7.9.3

