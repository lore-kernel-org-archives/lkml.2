Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752814Ab2GZU4a (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2012 16:56:30 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:36580 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752488Ab2GZU41 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2012 16:56:27 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: linux-kernel@vger.kernel.org, xen-devel@lists.xensource.com
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [PATCH 3/7] xen/mmu: Release the Xen provided L4 (PGD) back.
Date: Thu, 26 Jul 2012 16:47:28 -0400
Message-Id: <1343335652-5659-4-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1343335652-5659-1-git-send-email-konrad.wilk@oracle.com>
References: <1343335652-5659-1-git-send-email-konrad.wilk@oracle.com>
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since we are not using it and somebody else could use it.

Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 arch/x86/xen/mmu.c |   13 +++++++------
 1 files changed, 7 insertions(+), 6 deletions(-)

diff --git a/arch/x86/xen/mmu.c b/arch/x86/xen/mmu.c
index a59070b..48bdc9f 100644
--- a/arch/x86/xen/mmu.c
+++ b/arch/x86/xen/mmu.c
@@ -1782,20 +1782,21 @@ void __init xen_setup_kernel_pagetable(pgd_t *pgd, unsigned long max_pfn)
 	/* Unpin Xen-provided one */
 	pin_pagetable_pfn(MMUEXT_UNPIN_TABLE, PFN_DOWN(__pa(pgd)));
 
-	/* Switch over */
-	pgd = init_level4_pgt;
-
 	/*
 	 * At this stage there can be no user pgd, and no page
 	 * structure to attach it to, so make sure we just set kernel
 	 * pgd.
 	 */
 	xen_mc_batch();
-	__xen_write_cr3(true, __pa(pgd));
+	__xen_write_cr3(true, __pa(init_level4_pgt));
 	xen_mc_issue(PARAVIRT_LAZY_CPU);
 
-	memblock_reserve(__pa(xen_start_info->pt_base),
-			 xen_start_info->nr_pt_frames * PAGE_SIZE);
+	/* Offset by one page since the original pgd is going bye bye */
+	memblock_reserve(__pa(xen_start_info->pt_base + PAGE_SIZE),
+			 (xen_start_info->nr_pt_frames * PAGE_SIZE) - PAGE_SIZE);
+	/* and also RW it so it can actually be used. */
+	set_page_prot(pgd, PAGE_KERNEL);
+	clear_page(pgd);
 }
 #else	/* !CONFIG_X86_64 */
 static RESERVE_BRK_ARRAY(pmd_t, initial_kernel_pmd, PTRS_PER_PMD);
-- 
1.7.7.6

