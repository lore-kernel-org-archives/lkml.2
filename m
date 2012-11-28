Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932674Ab2K1Vx7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2012 16:53:59 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:45067 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932315Ab2K1Vsz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2012 16:48:55 -0500
From: Yinghai Lu <yinghai@kernel.org>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>, Jacob Shin <jacob.shin@amd.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        linux-kernel@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH v9 34/46] x86, mm: Add check before clear pte above max_low_pfn on 32bit
Date: Wed, 28 Nov 2012 13:47:45 -0800
Message-Id: <1354139277-17376-35-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1354139277-17376-1-git-send-email-yinghai@kernel.org>
References: <1354139277-17376-1-git-send-email-yinghai@kernel.org>
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

During test patch
	x86, mm: Use big page size for small memory range

found page table is setup wrongly for 32bit. And native_pagetable_init
wrongly cleared pte for pmd with large page support.

1. add more comments about why we are expecting pte.

2. add BUG checking, so next time we could find problem earlier
   when we mess up page table setup again.

3. max_low_pfn is not included boundary for low memory mapping.
   We should check from max_low_pfn instead of +1.

4. add print out when some pte really get cleared, or we should use
   WARN() to find out why above max_low_pfn get mapped? so we could
   fix it.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Reviewed-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 arch/x86/mm/init_32.c |   19 +++++++++++++++++--
 1 files changed, 17 insertions(+), 2 deletions(-)

diff --git a/arch/x86/mm/init_32.c b/arch/x86/mm/init_32.c
index 322ee56..6f3ab45 100644
--- a/arch/x86/mm/init_32.c
+++ b/arch/x86/mm/init_32.c
@@ -480,9 +480,15 @@ void __init native_pagetable_init(void)
 
 	/*
 	 * Remove any mappings which extend past the end of physical
-	 * memory from the boot time page table:
+	 * memory from the boot time page table.
+	 * In virtual address space, we should have at least two pages
+	 * from VMALLOC_END to pkmap or fixmap according to VMALLOC_END
+	 * definition. And max_low_pfn is set to VMALLOC_END physical
+	 * address. If initial memory mapping is doing right job, we
+	 * should have used PTE to map address near max_low_pfn or
+	 * one empty PMD
 	 */
-	for (pfn = max_low_pfn + 1; pfn < 1<<(32-PAGE_SHIFT); pfn++) {
+	for (pfn = max_low_pfn; pfn < 1<<(32-PAGE_SHIFT); pfn++) {
 		va = PAGE_OFFSET + (pfn<<PAGE_SHIFT);
 		pgd = base + pgd_index(va);
 		if (!pgd_present(*pgd))
@@ -493,10 +499,19 @@ void __init native_pagetable_init(void)
 		if (!pmd_present(*pmd))
 			break;
 
+		/* should not be large page here */
+		if (pmd_large(*pmd)) {
+			pr_warn("try to clear pte for ram above max_low_pfn: pfn: %lx pmd: %p pmd phys: %lx, but pmd is big page and is not using pte !\n",
+				pfn, pmd, __pa(pmd));
+			BUG_ON(1);
+		}
+
 		pte = pte_offset_kernel(pmd, va);
 		if (!pte_present(*pte))
 			break;
 
+		printk(KERN_DEBUG "clearing pte for ram above max_low_pfn: pfn: %lx pmd: %p pmd phys: %lx pte: %p pte phys: %lx\n",
+				pfn, pmd, __pa(pmd), pte, __pa(pte));
 		pte_clear(NULL, va, pte);
 	}
 	paravirt_alloc_pmd(&init_mm, __pa(base) >> PAGE_SHIFT);
-- 
1.7.7

