Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932521Ab2JRU5A (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2012 16:57:00 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:24696 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756100Ab2JRUvH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2012 16:51:07 -0400
From: Yinghai Lu <yinghai@kernel.org>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>, Jacob Shin <jacob.shin@amd.com>,
        Tejun Heo <tj@kernel.org>
Cc: Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        linux-kernel@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH 19/19] x86, mm: Add check before clear pte above max_low_pfn on 32bit
Date: Thu, 18 Oct 2012 13:50:30 -0700
Message-Id: <1350593430-24470-23-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1350593430-24470-1-git-send-email-yinghai@kernel.org>
References: <1350593430-24470-1-git-send-email-yinghai@kernel.org>
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

During test patch that adjust page_size_mask to map small range ram with
big page size, found page table is setup wrongly for 32bit. And
native_pagetable_init wrong clear pte for pmd with large page support.

1. add more comments about why we are expecting pte.

2. Add BUG checking, so next time we could find problem earlier
   when we mess up page table setup again.

3. max_low_pfn is not included boundary for low memory mapping.
   We should check from max_low_pfn instead of +1.

4. add print out when some pte really get cleared, or we should use
   WARN() to find out why above max_low_pfn get mapped? so we could
   fix it.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
---
 arch/x86/mm/init_32.c |   18 ++++++++++++++++--
 1 files changed, 16 insertions(+), 2 deletions(-)

diff --git a/arch/x86/mm/init_32.c b/arch/x86/mm/init_32.c
index 0f05742..49e9edf 100644
--- a/arch/x86/mm/init_32.c
+++ b/arch/x86/mm/init_32.c
@@ -480,9 +480,14 @@ void __init native_pagetable_init(void)
 
 	/*
 	 * Remove any mappings which extend past the end of physical
-	 * memory from the boot time page table:
+	 * memory from the boot time page table.
+	 * In virtual address space, we should have at least two pages
+	 * from VMALLOC_END to pkmap or fixmap according to VMALLOC_END
+	 * definition. And max_low_pfn is set to VMALLOC_END physical
+	 * address. If initial memory mapping is doing right job, we
+	 * should have pte used near max_low_pfn or one pmd is not present.
 	 */
-	for (pfn = max_low_pfn + 1; pfn < 1<<(32-PAGE_SHIFT); pfn++) {
+	for (pfn = max_low_pfn; pfn < 1<<(32-PAGE_SHIFT); pfn++) {
 		va = PAGE_OFFSET + (pfn<<PAGE_SHIFT);
 		pgd = base + pgd_index(va);
 		if (!pgd_present(*pgd))
@@ -493,10 +498,19 @@ void __init native_pagetable_init(void)
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

