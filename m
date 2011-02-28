Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754580Ab1B1SZ2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Feb 2011 13:25:28 -0500
Received: from smtp02.citrix.com ([66.165.176.63]:19387 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754399Ab1B1SZ1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Feb 2011 13:25:27 -0500
X-IronPort-AV: E=Sophos;i="4.62,241,1297054800"; 
   d="scan'208";a="137922020"
From: stefano.stabellini@eu.citrix.com
To: linux-kernel@vger.kernel.org
Cc: xen-devel@lists.xensource.com, hpa@zytor.com, konrad.wilk@oracle.com,
        yinghai@kernel.org, jeremy@goop.org, Stefano.Stabellini@eu.citrix.com,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Subject: [PATCH 2/2] xen: set max_pfn_mapped to the last pfn mapped
Date: Mon, 28 Feb 2011 18:25:17 +0000
Message-Id: <1298917517-5858-2-git-send-email-stefano.stabellini@eu.citrix.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <alpine.DEB.2.00.1102281755270.2917@kaball-desktop>
References: <alpine.DEB.2.00.1102281755270.2917@kaball-desktop>
X-OriginalArrivalTime: 28 Feb 2011 18:25:26.0809 (UTC) FILETIME=[DF062090:01CBD774]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>

Do not set max_pfn_mapped to the end of the initial memory mappings,
that also contain pages that don't belong in pfn space (like the mfn
list).

Set max_pfn_mapped to the last real pfn mapped in the initial memory
mappings that is the pfn backing _end.

Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
---
 arch/x86/xen/mmu.c |   13 +++++++------
 1 files changed, 7 insertions(+), 6 deletions(-)

diff --git a/arch/x86/xen/mmu.c b/arch/x86/xen/mmu.c
index 5e92b61..6092f73 100644
--- a/arch/x86/xen/mmu.c
+++ b/arch/x86/xen/mmu.c
@@ -1653,9 +1653,6 @@ static __init void xen_map_identity_early(pmd_t *pmd, unsigned long max_pfn)
 		for (pteidx = 0; pteidx < PTRS_PER_PTE; pteidx++, pfn++) {
 			pte_t pte;
 
-			if (pfn > max_pfn_mapped)
-				max_pfn_mapped = pfn;
-
 			if (!pte_none(pte_page[pteidx]))
 				continue;
 
@@ -1713,6 +1710,12 @@ __init pgd_t *xen_setup_kernel_pagetable(pgd_t *pgd,
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
 
@@ -1817,9 +1820,7 @@ __init pgd_t *xen_setup_kernel_pagetable(pgd_t *pgd,
 	initial_kernel_pmd =
 		extend_brk(sizeof(pmd_t) * PTRS_PER_PMD, PAGE_SIZE);
 
-	max_pfn_mapped = PFN_DOWN(__pa(xen_start_info->pt_base) +
-				  xen_start_info->nr_pt_frames * PAGE_SIZE +
-				  512*1024);
+	max_pfn_mapped = PFN_DOWN(__pa(xen_start_info->mfn_list));
 
 	kernel_pmd = m2v(pgd[KERNEL_PGD_BOUNDARY].pgd);
 	memcpy(initial_kernel_pmd, kernel_pmd, sizeof(pmd_t) * PTRS_PER_PMD);
-- 
1.5.6.5

