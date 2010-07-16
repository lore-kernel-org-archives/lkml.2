Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935488Ab0GPCMx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jul 2010 22:12:53 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:60976 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S935476Ab0GPCMu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jul 2010 22:12:50 -0400
Message-ID: <4C3FC03A.9040504@cn.fujitsu.com>
Date: Fri, 16 Jul 2010 10:13:14 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.9) Gecko/20100423 Thunderbird/3.0.4
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>, kvm@vger.kernel.org,
        Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        Nick Piggin <npiggin@suse.de>
Subject: [PATCH 6/6] kvm, faster and simpler version of get_user_page_and_protection()
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


a light weight version of get_user_page_and_protection()

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
---
diff --git a/arch/x86/include/asm/pgtable.h b/arch/x86/include/asm/pgtable.h
index a34c785..d0e4f2f 100644
--- a/arch/x86/include/asm/pgtable.h
+++ b/arch/x86/include/asm/pgtable.h
@@ -618,6 +618,8 @@ static inline void clone_pgd_range(pgd_t *dst, pgd_t *src, int count)
        memcpy(dst, src, count * sizeof(pgd_t));
 }
 
+extern
+struct page *get_user_page_and_protection(unsigned long addr, int *writable);
 
 #include <asm-generic/pgtable.h>
 #endif	/* __ASSEMBLY__ */
diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index 6382140..de44847 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -1832,23 +1832,6 @@ static void kvm_unsync_pages(struct kvm_vcpu *vcpu,  gfn_t gfn)
 	}
 }
 
-/* get a current mapped page fast, and test whether the page is writable. */
-static struct page *get_user_page_and_protection(unsigned long addr,
-	int *writable)
-{
-	struct page *page[1];
-
-	if (__get_user_pages_fast(addr, 1, 1, page) == 1) {
-		*writable = 1;
-		return page[0];
-	}
-	if (__get_user_pages_fast(addr, 1, 0, page) == 1) {
-		*writable = 0;
-		return page[0];
-	}
-	return NULL;
-}
-
 static pfn_t kvm_get_pfn_for_page_fault(struct kvm *kvm, gfn_t gfn,
 		int write_fault, int *host_writable)
 {
diff --git a/arch/x86/mm/gup.c b/arch/x86/mm/gup.c
index a4ce19f..34b05c7 100644
--- a/arch/x86/mm/gup.c
+++ b/arch/x86/mm/gup.c
@@ -275,7 +275,6 @@ int __get_user_pages_fast(unsigned long start, int nr_pages, int write,
 
 	return nr;
 }
-EXPORT_SYMBOL_GPL(__get_user_pages_fast);
 
 /**
  * get_user_pages_fast() - pin user pages in memory
@@ -375,3 +374,83 @@ slow_irqon:
 		return ret;
 	}
 }
+
+/*
+ * get a current mapped page fast, and test whether the page is writable.
+ * equivalent version(but slower):
+ * {
+ *	struct page *page[1];
+ *
+ *	if (__get_user_pages_fast(addr, 1, 1, page) == 1) {
+ *		*writable = 1;
+ *		return page[0];
+ *	}
+ *	if (__get_user_pages_fast(addr, 1, 0, page) == 1) {
+ *		*writable = 0;
+ *		return page[0];
+ *	}
+ *	return NULL;
+ * }
+ */
+struct page *get_user_page_and_protection(unsigned long addr, int *writable)
+{
+	unsigned long flags;
+	struct mm_struct *mm = current->mm;
+	pgd_t *pgdp;
+	pud_t *pudp;
+	pmd_t *pmdp;
+	pte_t pte, *ptep;
+
+	unsigned long mask = _PAGE_PRESENT | _PAGE_USER;
+	unsigned long offset = 0;
+	struct page *head, *page = NULL;
+
+	addr &= PAGE_MASK;
+
+	local_irq_save(flags);
+	pgdp = pgd_offset(mm, addr);
+	if (!pgd_present(*pgdp))
+		goto out;
+
+	pudp = pud_offset(pgdp, addr);
+	if (!pud_present(*pudp))
+		goto out;
+
+	if (unlikely(pud_large(*pudp))) {
+		pte = *(pte_t *)pudp;
+		offset = ((addr & ~PUD_MASK) >> PAGE_SHIFT);
+		goto verify;
+	}
+
+	pmdp = pmd_offset(pudp, addr);
+	if (!pmd_present(*pmdp))
+		goto out;
+
+	if (unlikely(pmd_large(*pmdp))) {
+		pte = *(pte_t *)pmdp;
+		offset = ((addr & ~PMD_MASK) >> PAGE_SHIFT);
+		goto verify;
+	}
+
+	ptep = pte_offset_map(pmdp, addr);
+	pte = gup_get_pte(ptep);
+	pte_unmap(ptep);
+
+verify:
+	if ((pte_flags(pte) & (mask | _PAGE_SPECIAL)) != mask)
+		goto out;
+
+	VM_BUG_ON(!pfn_valid(pte_pfn(pte)));
+
+	head = pte_page(pte);
+	page = head + offset;
+	VM_BUG_ON(compound_head(page) != head);
+	get_page(page);
+	*writable = !!(pte_flags(pte) & _PAGE_RW);
+
+out:
+	local_irq_restore(flags);
+	return page;
+}
+EXPORT_SYMBOL_GPL(get_user_page_and_protection);
+
