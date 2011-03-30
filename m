Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964984Ab1C3VJf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 17:09:35 -0400
Received: from mga09.intel.com ([134.134.136.24]:9067 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965153Ab1C3VJb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 17:09:31 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.63,270,1299484800"; 
   d="scan'208";a="621238719"
From: Andi Kleen <andi@firstfloor.org>
References: <20110330203.501921634@firstfloor.org>
In-Reply-To: <20110330203.501921634@firstfloor.org>
To: stefano.stabellini@eu.citrix.com, konrad.wilk@oracle.com,
        ak@linux.intel.com, hpa@zytor.com, gregkh@suse.de,
        linux-kernel@vger.kernel.org, stable@kernel.org, tim.bird@am.sony.com
Subject: [PATCH] [224/275] xen: set max_pfn_mapped to the last pfn mapped
Message-Id: <20110330210749.8A6653E1A05@tassilo.jf.intel.com>
Date: Wed, 30 Mar 2011 14:07:49 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>

commit 14988a4d350ce3b41ecad4f63c4f44c56f5ae34d upstream.

Do not set max_pfn_mapped to the end of the initial memory mappings,
that also contain pages that don't belong in pfn space (like the mfn
list).

Set max_pfn_mapped to the last real pfn mapped in the initial memory
mappings that is the pfn backing _end.

Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Acked-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Signed-off-by: Andi Kleen <ak@linux.intel.com>
LKML-Reference: <alpine.DEB.2.00.1103171739050.3382@kaball-desktop>
Signed-off-by: H. Peter Anvin <hpa@zytor.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/x86/xen/mmu.c |   13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

Index: linux-2.6.35.y/arch/x86/xen/mmu.c
===================================================================
--- linux-2.6.35.y.orig/arch/x86/xen/mmu.c	2011-03-29 22:50:26.784573069 -0700
+++ linux-2.6.35.y/arch/x86/xen/mmu.c	2011-03-29 23:03:02.900225961 -0700
@@ -1641,9 +1641,6 @@
 		for (pteidx = 0; pteidx < PTRS_PER_PTE; pteidx++, pfn++) {
 			pte_t pte;
 
-			if (pfn > max_pfn_mapped)
-				max_pfn_mapped = pfn;
-
 			if (!pte_none(pte_page[pteidx]))
 				continue;
 
@@ -1687,6 +1684,12 @@
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
 
@@ -1750,9 +1753,7 @@
 {
 	pmd_t *kernel_pmd;
 
-	max_pfn_mapped = PFN_DOWN(__pa(xen_start_info->pt_base) +
-				  xen_start_info->nr_pt_frames * PAGE_SIZE +
-				  512*1024);
+	max_pfn_mapped = PFN_DOWN(__pa(xen_start_info->mfn_list));
 
 	kernel_pmd = m2v(pgd[KERNEL_PGD_BOUNDARY].pgd);
 	memcpy(level2_kernel_pgt, kernel_pmd, sizeof(pmd_t) * PTRS_PER_PMD);
