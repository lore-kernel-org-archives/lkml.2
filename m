Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936627Ab2C3W4I (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2012 18:56:08 -0400
Received: from 206.83.70.73.ptr.us.xo.net ([206.83.70.73]:41906 "EHLO
	king.tilera.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934932Ab2C3VFx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2012 17:05:53 -0400
Message-Id: <201203302105.q2UL55nn006294@farm-0012.internal.tilera.com>
From: Chris Metcalf <cmetcalf@tilera.com>
Date: Thu, 29 Mar 2012 15:42:27 -0400
Subject: [PATCH] arch/tile: support loading kernels larger than 16 MB
In-Reply-To: <4F761E1C.80808.com>
References: <4F761E1C.80808.com>
To: Chris Metcalf <cmetcalf@tilera.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Julia Lawall <julia@diku.dk>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        linux-kernel@vger.kernel.org
X-OriginalArrivalTime: 30 Mar 2012 21:05:05.0913 (UTC) FILETIME=[C8326690:01CD0EB8]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Previously we only handled kernels up to a single huge page in size.
Now we create additional PTEs appropriately.

Signed-off-by: Chris Metcalf <cmetcalf@tilera.com>
---
 arch/tile/mm/init.c |   21 +++++++++++++++------
 1 files changed, 15 insertions(+), 6 deletions(-)

diff --git a/arch/tile/mm/init.c b/arch/tile/mm/init.c
index d1c6391..6119f46 100644
--- a/arch/tile/mm/init.c
+++ b/arch/tile/mm/init.c
@@ -554,6 +554,7 @@ static void __init kernel_physical_mapping_init(pgd_t *pgd_base)
 
 	address = MEM_SV_INTRPT;
 	pmd = get_pmd(pgtables, address);
+	pfn = 0;  /* code starts at PA 0 */
 	if (ktext_small) {
 		/* Allocate an L2 PTE for the kernel text */
 		int cpu = 0;
@@ -576,10 +577,15 @@ static void __init kernel_physical_mapping_init(pgd_t *pgd_base)
 		}
 
 		BUG_ON(address != (unsigned long)_stext);
-		pfn = 0;  /* code starts at PA 0 */
-		pte = alloc_pte();
-		for (pte_ofs = 0; address < (unsigned long)_einittext;
-		     pfn++, pte_ofs++, address += PAGE_SIZE) {
+		pte = NULL;
+		for (; address < (unsigned long)_einittext;
+		     pfn++, address += PAGE_SIZE) {
+			pte_ofs = pte_index(address);
+			if (pte_ofs == 0) {
+				if (pte)
+					assign_pte(pmd++, pte);
+				pte = alloc_pte();
+			}
 			if (!ktext_local) {
 				prot = set_remote_cache_cpu(prot, cpu);
 				cpu = cpumask_next(cpu, &ktext_mask);
@@ -588,7 +594,8 @@ static void __init kernel_physical_mapping_init(pgd_t *pgd_base)
 			}
 			pte[pte_ofs] = pfn_pte(pfn, prot);
 		}
-		assign_pte(pmd, pte);
+		if (pte)
+			assign_pte(pmd, pte);
 	} else {
 		pte_t pteval = pfn_pte(0, PAGE_KERNEL_EXEC);
 		pteval = pte_mkhuge(pteval);
@@ -611,7 +618,9 @@ static void __init kernel_physical_mapping_init(pgd_t *pgd_base)
 		else
 			pteval = hv_pte_set_mode(pteval,
 						 HV_PTE_MODE_CACHE_NO_L3);
-		*(pte_t *)pmd = pteval;
+		for (; address < (unsigned long)_einittext;
+		     pfn += PFN_DOWN(HPAGE_SIZE), address += HPAGE_SIZE)
+			*(pte_t *)(pmd++) = pfn_pte(pfn, pteval);
 	}
 
 	/* Set swapper_pgprot here so it is flushed to memory right away. */
-- 
1.6.5.2

