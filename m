Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965034Ab2EOC5g (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2012 22:57:36 -0400
Received: from mail1.windriver.com ([147.11.146.13]:53291 "EHLO
	mail1.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964995Ab2EOCRD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2012 22:17:03 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: <stable@kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [34-longterm 078/179] xen: partially revert "xen: set max_pfn_mapped to the last pfn mapped"
Date: Mon, 14 May 2012 22:12:54 -0400
Message-ID: <1337048075-6132-79-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.9.6
In-Reply-To: <1337048075-6132-1-git-send-email-paul.gortmaker@windriver.com>
References: <1337048075-6132-1-git-send-email-paul.gortmaker@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    http://git.kernel.org/?p=linux/kernel/git/paulg/longterm-queue-2.6.34.git
    If you see a problem with using this for longterm, please comment.
                   -------------------

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
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 arch/x86/xen/mmu.c |    9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/arch/x86/xen/mmu.c b/arch/x86/xen/mmu.c
index 4916176..96cdf78 100644
--- a/arch/x86/xen/mmu.c
+++ b/arch/x86/xen/mmu.c
@@ -1641,6 +1641,11 @@ static __init void xen_map_identity_early(pmd_t *pmd, unsigned long max_pfn)
 		for (pteidx = 0; pteidx < PTRS_PER_PTE; pteidx++, pfn++) {
 			pte_t pte;
 
+#ifdef CONFIG_X86_32
+			if (pfn > max_pfn_mapped)
+				max_pfn_mapped = pfn;
+#endif
+
 			if (!pte_none(pte_page[pteidx]))
 				continue;
 
@@ -1753,7 +1758,9 @@ __init pgd_t *xen_setup_kernel_pagetable(pgd_t *pgd,
 {
 	pmd_t *kernel_pmd;
 
-	max_pfn_mapped = PFN_DOWN(__pa(xen_start_info->mfn_list));
+	max_pfn_mapped = PFN_DOWN(__pa(xen_start_info->pt_base) +
+				  xen_start_info->nr_pt_frames * PAGE_SIZE +
+				  512*1024);
 
 	kernel_pmd = m2v(pgd[KERNEL_PGD_BOUNDARY].pgd);
 	memcpy(level2_kernel_pgt, kernel_pmd, sizeof(pmd_t) * PTRS_PER_PMD);
-- 
1.7.9.6

