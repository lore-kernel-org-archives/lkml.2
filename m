Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030288Ab2HPQQg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2012 12:16:36 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:32105 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757647Ab2HPQNV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2012 12:13:21 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: linux-kernel@vger.kernel.org, xen-devel@lists.xensource.com
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [PATCH 04/11] xen/mmu: Provide comments describing the _ka and _va aliasing issue
Date: Thu, 16 Aug 2012 12:03:22 -0400
Message-Id: <1345133009-21941-5-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1345133009-21941-1-git-send-email-konrad.wilk@oracle.com>
References: <1345133009-21941-1-git-send-email-konrad.wilk@oracle.com>
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Which is that the level2_kernel_pgt (__ka virtual addresses)
and level2_ident_pgt (__va virtual address) contain the same
PMD entries. So if you modify a PTE in __ka, it will be reflected
in __va (and vice-versa).

Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 arch/x86/xen/mmu.c |   17 +++++++++++++++++
 1 files changed, 17 insertions(+), 0 deletions(-)

diff --git a/arch/x86/xen/mmu.c b/arch/x86/xen/mmu.c
index 4ac21a4..6ba6100 100644
--- a/arch/x86/xen/mmu.c
+++ b/arch/x86/xen/mmu.c
@@ -1734,19 +1734,36 @@ void __init xen_setup_kernel_pagetable(pgd_t *pgd, unsigned long max_pfn)
 	init_level4_pgt[0] = __pgd(0);
 
 	/* Pre-constructed entries are in pfn, so convert to mfn */
+	/* L4[272] -> level3_ident_pgt
+	 * L4[511] -> level3_kernel_pgt */
 	convert_pfn_mfn(init_level4_pgt);
+
+	/* L3_i[0] -> level2_ident_pgt */
 	convert_pfn_mfn(level3_ident_pgt);
+	/* L3_k[510] -> level2_kernel_pgt
+	 * L3_i[511] -> level2_fixmap_pgt */
 	convert_pfn_mfn(level3_kernel_pgt);
 
+	/* We get [511][511] and have Xen's version of level2_kernel_pgt */
 	l3 = m2v(pgd[pgd_index(__START_KERNEL_map)].pgd);
 	l2 = m2v(l3[pud_index(__START_KERNEL_map)].pud);
 
+	/* Graft it onto L4[272][0]. Note that we creating an aliasing problem:
+	 * Both L4[272][0] and L4[511][511] have entries that point to the same
+	 * L2 (PMD) tables. Meaning that if you modify it in __va space
+	 * it will be also modified in the __ka space! (But if you just
+	 * modify the PMD table to point to other PTE's or none, then you
+	 * are OK - which is what cleanup_highmap does) */
 	memcpy(level2_ident_pgt, l2, sizeof(pmd_t) * PTRS_PER_PMD);
+	/* Graft it onto L4[511][511] */
 	memcpy(level2_kernel_pgt, l2, sizeof(pmd_t) * PTRS_PER_PMD);
 
+	/* Get [511][510] and graft that in level2_fixmap_pgt */
 	l3 = m2v(pgd[pgd_index(__START_KERNEL_map + PMD_SIZE)].pgd);
 	l2 = m2v(l3[pud_index(__START_KERNEL_map + PMD_SIZE)].pud);
 	memcpy(level2_fixmap_pgt, l2, sizeof(pmd_t) * PTRS_PER_PMD);
+	/* Note that we don't do anything with level1_fixmap_pgt which
+	 * we don't need. */
 
 	/* Set up identity map */
 	xen_map_identity_early(level2_ident_pgt, max_pfn);
-- 
1.7.7.6

