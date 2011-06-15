Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754457Ab1FOTMO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jun 2011 15:12:14 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:20190 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754358Ab1FOTMK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jun 2011 15:12:10 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: xen-devel@lists.xensource.com, linux-kernel@vger.kernel.org,
        Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Stefano Stabellini <stefano.stabellini@eu.citrix.com>, stable@kernel.org,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [PATCH 1/4] xen: partially revert "xen: set max_pfn_mapped to the last pfn mapped"
Date: Wed, 15 Jun 2011 15:11:32 -0400
Message-Id: <1308165095-17303-2-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1308165095-17303-1-git-send-email-konrad.wilk@oracle.com>
References: <1308165095-17303-1-git-send-email-konrad.wilk@oracle.com>
X-Source-IP: rtcsinet21.oracle.com [66.248.204.29]
X-CT-RefId: str=0001.0A090206.4DF90401.0045:SCFSTAT5015188,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>

We only need to set max_pfn_mapped to the last pfn mapped on x86_64 to
make sure that cleanup_highmap doesn't remove important mappings at
_end.

We don't need to do this on x86_32 because cleanup_highmap is not called
on x86_32. Besides lowering max_pfn_mapped on x86_32 has the unwanted
side effect of limiting the amount of memory available for the 1:1
kernel pagetable allocation.

This patch reverts the x86_32 part of the original patch.

CC: stable@kernel.org
Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 arch/x86/xen/mmu.c |    9 ++++++++-
 1 files changed, 8 insertions(+), 1 deletions(-)

diff --git a/arch/x86/xen/mmu.c b/arch/x86/xen/mmu.c
index dc708dc..afe1d54 100644
--- a/arch/x86/xen/mmu.c
+++ b/arch/x86/xen/mmu.c
@@ -1599,6 +1599,11 @@ static void __init xen_map_identity_early(pmd_t *pmd, unsigned long max_pfn)
 		for (pteidx = 0; pteidx < PTRS_PER_PTE; pteidx++, pfn++) {
 			pte_t pte;
 
+#ifdef CONFIG_X86_32
+			if (pfn > max_pfn_mapped)
+				max_pfn_mapped = pfn;
+#endif
+
 			if (!pte_none(pte_page[pteidx]))
 				continue;
 
@@ -1766,7 +1771,9 @@ pgd_t * __init xen_setup_kernel_pagetable(pgd_t *pgd,
 	initial_kernel_pmd =
 		extend_brk(sizeof(pmd_t) * PTRS_PER_PMD, PAGE_SIZE);
 
-	max_pfn_mapped = PFN_DOWN(__pa(xen_start_info->mfn_list));
+	max_pfn_mapped = PFN_DOWN(__pa(xen_start_info->pt_base) +
+				  xen_start_info->nr_pt_frames * PAGE_SIZE +
+				  512*1024);
 
 	kernel_pmd = m2v(pgd[KERNEL_PGD_BOUNDARY].pgd);
 	memcpy(initial_kernel_pmd, kernel_pmd, sizeof(pmd_t) * PTRS_PER_PMD);
-- 
1.7.4.1

