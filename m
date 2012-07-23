Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754691Ab2GWShV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2012 14:37:21 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:39676 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754608Ab2GWShO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2012 14:37:14 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: linux-kernel@vger.kernel.org, xen-devel@lists.xensource.com
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [PATCH 3/5] xen/mmu: Provide comments describing the _kva and _va aliasing issue
Date: Mon, 23 Jul 2012 14:28:21 -0400
Message-Id: <1343068103-13579-4-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1343068103-13579-1-git-send-email-konrad.wilk@oracle.com>
References: <1343068103-13579-1-git-send-email-konrad.wilk@oracle.com>
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

And also explain how the pagetables are being grafted on.
Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 arch/x86/xen/mmu.c |   15 +++++++++++++++
 1 files changed, 15 insertions(+), 0 deletions(-)

diff --git a/arch/x86/xen/mmu.c b/arch/x86/xen/mmu.c
index 4ac21a4..b0b72e0 100644
--- a/arch/x86/xen/mmu.c
+++ b/arch/x86/xen/mmu.c
@@ -1734,19 +1734,34 @@ void __init xen_setup_kernel_pagetable(pgd_t *pgd, unsigned long max_pfn)
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
+	 * it will be also modified in the __kva space! */
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

