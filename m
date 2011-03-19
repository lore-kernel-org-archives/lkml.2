Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757400Ab1CSThj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Mar 2011 15:37:39 -0400
Received: from hera.kernel.org ([140.211.167.34]:43273 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757162Ab1CSThh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Mar 2011 15:37:37 -0400
Date: Sat, 19 Mar 2011 19:37:22 GMT
From: tip-bot for Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        konrad.wilk@oracle.com, tglx@linutronix.de,
        stefano.stabellini@eu.citrix.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        konrad.wilk@oracle.com, tglx@linutronix.de,
        stefano.stabellini@eu.citrix.com
In-Reply-To: <alpine.DEB.2.00.1103171739050.3382@kaball-desktop>
References: <alpine.DEB.2.00.1103171739050.3382@kaball-desktop>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] xen: set max_pfn_mapped to the last pfn mapped
Message-ID: <tip-14988a4d350ce3b41ecad4f63c4f44c56f5ae34d@git.kernel.org>
Git-Commit-ID: 14988a4d350ce3b41ecad4f63c4f44c56f5ae34d
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Sat, 19 Mar 2011 19:37:22 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  14988a4d350ce3b41ecad4f63c4f44c56f5ae34d
Gitweb:     http://git.kernel.org/tip/14988a4d350ce3b41ecad4f63c4f44c56f5ae34d
Author:     Stefano Stabellini <stefano.stabellini@eu.citrix.com>
AuthorDate: Fri, 18 Feb 2011 11:32:40 +0000
Committer:  H. Peter Anvin <hpa@zytor.com>
CommitDate: Sat, 19 Mar 2011 11:58:25 -0700

xen: set max_pfn_mapped to the last pfn mapped

Do not set max_pfn_mapped to the end of the initial memory mappings,
that also contain pages that don't belong in pfn space (like the mfn
list).

Set max_pfn_mapped to the last real pfn mapped in the initial memory
mappings that is the pfn backing _end.

Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Acked-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
LKML-Reference: <alpine.DEB.2.00.1103171739050.3382@kaball-desktop>
Signed-off-by: H. Peter Anvin <hpa@zytor.com>
---
 arch/x86/xen/mmu.c |   13 +++++++------
 1 files changed, 7 insertions(+), 6 deletions(-)

diff --git a/arch/x86/xen/mmu.c b/arch/x86/xen/mmu.c
index a2d78ad..6e27979 100644
--- a/arch/x86/xen/mmu.c
+++ b/arch/x86/xen/mmu.c
@@ -1701,9 +1701,6 @@ static __init void xen_map_identity_early(pmd_t *pmd, unsigned long max_pfn)
 		for (pteidx = 0; pteidx < PTRS_PER_PTE; pteidx++, pfn++) {
 			pte_t pte;
 
-			if (pfn > max_pfn_mapped)
-				max_pfn_mapped = pfn;
-
 			if (!pte_none(pte_page[pteidx]))
 				continue;
 
@@ -1761,6 +1758,12 @@ __init pgd_t *xen_setup_kernel_pagetable(pgd_t *pgd,
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
 
@@ -1865,9 +1868,7 @@ __init pgd_t *xen_setup_kernel_pagetable(pgd_t *pgd,
 	initial_kernel_pmd =
 		extend_brk(sizeof(pmd_t) * PTRS_PER_PMD, PAGE_SIZE);
 
-	max_pfn_mapped = PFN_DOWN(__pa(xen_start_info->pt_base) +
-				  xen_start_info->nr_pt_frames * PAGE_SIZE +
-				  512*1024);
+	max_pfn_mapped = PFN_DOWN(__pa(xen_start_info->mfn_list));
 
 	kernel_pmd = m2v(pgd[KERNEL_PGD_BOUNDARY].pgd);
 	memcpy(initial_kernel_pmd, kernel_pmd, sizeof(pmd_t) * PTRS_PER_PMD);
