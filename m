Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932599Ab2KVUxX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2012 15:53:23 -0500
Received: from terminus.zytor.com ([198.137.202.10]:37038 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964814Ab2KVS6f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2012 13:58:35 -0500
Date: Wed, 21 Nov 2012 18:13:02 -0800
From: tip-bot for Yinghai Lu <yinghai@kernel.org>
Message-ID: <tip-11ed9e927d573d78beda6e6a166612666ae97064@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        yinghai@kernel.org, tglx@linutronix.de, hpa@linux.intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        yinghai@kernel.org, tglx@linutronix.de, hpa@linux.intel.com
In-Reply-To: <1353123563-3103-35-git-send-email-yinghai@kernel.org>
References: <1353123563-3103-35-git-send-email-yinghai@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/mm2] x86, mm:
  Add check before clear pte above max_low_pfn on 32bit
Git-Commit-ID: 11ed9e927d573d78beda6e6a166612666ae97064
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Wed, 21 Nov 2012 18:13:07 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  11ed9e927d573d78beda6e6a166612666ae97064
Gitweb:     http://git.kernel.org/tip/11ed9e927d573d78beda6e6a166612666ae97064
Author:     Yinghai Lu <yinghai@kernel.org>
AuthorDate: Fri, 16 Nov 2012 19:39:11 -0800
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Sat, 17 Nov 2012 11:59:39 -0800

x86, mm: Add check before clear pte above max_low_pfn on 32bit

During test patch that adjust page_size_mask to map small range ram with
big page size, found page table is setup wrongly for 32bit. And
native_pagetable_init wrong clear pte for pmd with large page support.

1. add more comments about why we are expecting pte.

2. add BUG checking, so next time we could find problem earlier
   when we mess up page table setup again.

3. max_low_pfn is not included boundary for low memory mapping.
   We should check from max_low_pfn instead of +1.

4. add print out when some pte really get cleared, or we should use
   WARN() to find out why above max_low_pfn get mapped? so we could
   fix it.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Link: http://lkml.kernel.org/r/1353123563-3103-35-git-send-email-yinghai@kernel.org
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/mm/init_32.c | 18 ++++++++++++++++--
 1 file changed, 16 insertions(+), 2 deletions(-)

diff --git a/arch/x86/mm/init_32.c b/arch/x86/mm/init_32.c
index 322ee56..19ef9f0 100644
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
