Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752851Ab1A3DQZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Jan 2011 22:16:25 -0500
Received: from mga02.intel.com ([134.134.136.20]:22257 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752433Ab1A3DQA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Jan 2011 22:16:00 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.60,398,1291622400"; 
   d="scan'208";a="597720047"
From: Huang Ying <ying.huang@intel.com>
To: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Andi Kleen <andi@firstfloor.org>, ying.huang@intel.com,
        Tony Luck <tony.luck@intel.com>, Dean Nelson <dnelson@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH -v2 3/3] KVM, Replace is_hwpoison_address with __get_user_pages
Date: Sun, 30 Jan 2011 11:15:49 +0800
Message-Id: <1296357349-18022-4-git-send-email-ying.huang@intel.com>
X-Mailer: git-send-email 1.7.2.3
In-Reply-To: <1296357349-18022-1-git-send-email-ying.huang@intel.com>
References: <1296357349-18022-1-git-send-email-ying.huang@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

is_hwpoison_address only checks whether the page table entry is
hwpoisoned, regardless the memory page mapped.  While __get_user_pages
will check both.

QEMU will clear the poisoned page table entry (via unmap/map) to make
it possible to allocate a new memory page for the virtual address
across guest rebooting.  But it is also possible that the underlying
memory page is kept poisoned even after the corresponding page table
entry is cleared, that is, a new memory page can not be allocated.
__get_user_pages can catch these situations.

Signed-off-by: Huang Ying <ying.huang@intel.com>
---
 include/linux/mm.h  |    8 --------
 mm/memory-failure.c |   32 --------------------------------
 virt/kvm/kvm_main.c |   11 ++++++++++-
 3 files changed, 10 insertions(+), 41 deletions(-)

--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -1627,14 +1627,6 @@ extern int sysctl_memory_failure_recover
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
@@ -1437,35 +1437,3 @@ done:
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
@@ -1029,6 +1029,15 @@ static pfn_t get_fault_pfn(void)
 	return fault_pfn;
 }
 
+static inline int check_user_page_hwpoison(unsigned long addr)
+{
+	int rc, flags = FOLL_TOUCH | FOLL_HWPOISON | FOLL_WRITE;
+
+	rc = __get_user_pages(current, current->mm, addr, 1,
+			      flags, NULL, NULL, NULL);
+	return rc == -EHWPOISON;
+}
+
 static pfn_t hva_to_pfn(struct kvm *kvm, unsigned long addr, bool atomic,
 			bool *async, bool write_fault, bool *writable)
 {
@@ -1076,7 +1085,7 @@ static pfn_t hva_to_pfn(struct kvm *kvm,
 			return get_fault_pfn();
 
 		down_read(&current->mm->mmap_sem);
-		if (is_hwpoison_address(addr)) {
+		if (check_user_page_hwpoison(addr)) {
 			up_read(&current->mm->mmap_sem);
 			get_page(hwpoison_page);
 			return page_to_pfn(hwpoison_page);
