Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756554Ab1AMIm6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jan 2011 03:42:58 -0500
Received: from mga14.intel.com ([143.182.124.37]:36310 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756343Ab1AMImy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jan 2011 03:42:54 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.60,317,1291622400"; 
   d="scan'208";a="373946011"
Subject: [PATCH 2/2] KVM, Replace is_hwpoison_address with
 get_user_pages_hwpoison
From: Huang Ying <ying.huang@intel.com>
To: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Andi Kleen <andi@firstfloor.org>, Dean Nelson <dnelson@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Tony Luck <tony.luck@intel.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 13 Jan 2011 16:42:49 +0800
Message-ID: <1294908169.4596.59.camel@yhuang-dev>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

is_hwpoison_address only checks whether the page table entry is
hwpoisoned, regardless the memory page mapped.  While
get_user_pages_hwpoison will check both.

QEMU will clear the poisoned page table entry (via unmap/map) to make
it possible to allocate a new memory page for the virtual address
across guest rebooting.  But it is also possible that the underlying
memory page is kept poisoned even after the corresponding page table
entry is cleared, that is, a new memory page can not be allocated.
get_user_pages_hwpoison can catch these situations.

Signed-off-by: Huang Ying <ying.huang@intel.com>
---
 include/linux/mm.h  |    8 --------
 mm/memory-failure.c |   32 --------------------------------
 virt/kvm/kvm_main.c |    4 +++-
 3 files changed, 3 insertions(+), 41 deletions(-)

--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -1524,14 +1524,6 @@ extern int sysctl_memory_failure_recover
 extern void shake_page(struct page *p, int access);
 extern atomic_long_t mce_bad_pages;
 extern int soft_offline_page(struct page *page, int flags);
-#ifdef CONFIG_MEMORY_FAILURE
-int is_hwpoison_address(unsigned long addr);
-#else
-static inline int is_hwpoison_address(unsigned long addr)
-{
-	return 0;
-}
-#endif
 
 extern void dump_page(struct page *page);
 
--- a/mm/memory-failure.c
+++ b/mm/memory-failure.c
@@ -1433,35 +1433,3 @@ done:
 	/* keep elevated page count for bad page */
 	return ret;
 }
-
-/*
- * The caller must hold current->mm->mmap_sem in read mode.
- */
-int is_hwpoison_address(unsigned long addr)
-{
-	pgd_t *pgdp;
-	pud_t pud, *pudp;
-	pmd_t pmd, *pmdp;
-	pte_t pte, *ptep;
-	swp_entry_t entry;
-
-	pgdp = pgd_offset(current->mm, addr);
-	if (!pgd_present(*pgdp))
-		return 0;
-	pudp = pud_offset(pgdp, addr);
-	pud = *pudp;
-	if (!pud_present(pud) || pud_large(pud))
-		return 0;
-	pmdp = pmd_offset(pudp, addr);
-	pmd = *pmdp;
-	if (!pmd_present(pmd) || pmd_large(pmd))
-		return 0;
-	ptep = pte_offset_map(pmdp, addr);
-	pte = *ptep;
-	pte_unmap(ptep);
-	if (!is_swap_pte(pte))
-		return 0;
-	entry = pte_to_swp_entry(pte);
-	return is_hwpoison_entry(entry);
-}
-EXPORT_SYMBOL_GPL(is_hwpoison_address);
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -966,7 +966,9 @@ static pfn_t hva_to_pfn(struct kvm *kvm,
 			goto return_fault_page;
 
 		down_read(&current->mm->mmap_sem);
-		if (is_hwpoison_address(addr)) {
+		npages = get_user_pages_hwpoison(current, current->mm,
+						 addr, 1, 1, 0, page, NULL);
+		if (npages == -EHWPOISON) {
 			up_read(&current->mm->mmap_sem);
 			get_page(hwpoison_page);
 			return page_to_pfn(hwpoison_page);


