Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757271Ab1CRT5T (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Mar 2011 15:57:19 -0400
Received: from mail-ww0-f42.google.com ([74.125.82.42]:37223 "EHLO
	mail-ww0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756802Ab1CRT5P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Mar 2011 15:57:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=XhHPRJfP+V4kZEqCtYvOUUM58cr10CIWGoY52P1dpJzvxNkNlJBwC80Y+V4cn5cehq
         fO7Y2qR39LhusFixOiel7A+bvywwRH4wFjVXr2EyOwFQbmAC7602VPySuVJw21X3GrzY
         NpW6G3U8DZbDotFGUXMbNzyqiTA5WIYuHkYU4=
Date: Fri, 18 Mar 2011 19:57:54 +0000
From: Prasad Joshi <prasadjoshi124@gmail.com>
To: benh@kernel.crashing.org, paulus@samba.org, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, prasadjoshi124@gmail.com,
        mitra@kqinfotech.com
Subject: Re: [RFC][PATCH v3 10/22] mm, powerpc: add gfp flags variant of
 pud, pte, and pte allocations
Message-ID: <20110318195754.GK4746@prasad-kvm>
References: <20110318194135.GA4746@prasad-kvm>
 <20110318194341.GB4746@prasad-kvm>
 <20110318194600.GC4746@prasad-kvm>
 <20110318194740.GD4746@prasad-kvm>
 <20110318194929.GE4746@prasad-kvm>
 <20110318195035.GF4746@prasad-kvm>
 <20110318195141.GG4746@prasad-kvm>
 <20110318195307.GH4746@prasad-kvm>
 <20110318195507.GI4746@prasad-kvm>
 <20110318195643.GJ4746@prasad-kvm>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110318195643.GJ4746@prasad-kvm>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


changes for 32 bit architecture
 - Added __pte_alloc_one_kernel() to allocated zeroed page using
   allocation flag passed as an argument. If the slab allocator is not
   initialized the allocation flag is not passed down the call hierarchy.
   i.e. the call to early_get_page() is not modified.

- Changed pte_alloc_one_kernel() to call __pte_alloc_one_kernel() passing
  correct gfp_t flags.

changes for 64 bit architecture
- Added __pud_alloc_one() which is similar to pud_alloc_one(). This newly
  added function accepts allocation flag as a parameter and does the PUD
  allocation using this GFP flag.

- The function pud_alloc_one() is changed to call __pud_alloc_one() passing
  GFP_KERNEL | __GFP_REPEAT allocation flags.

- Similar changes for pmd (cache) and pte (page) allocations.

- The changes for both architectures help in fixing Bug 30702

Signed-off-by: Prasad Joshi <prasadjoshi124@gmail.com>
Signed-off-by: Anand Mitra <mitra@kqinfotech.com>
---
 arch/powerpc/include/asm/pgalloc-32.h |    2 ++
 arch/powerpc/include/asm/pgalloc-64.h |   27 ++++++++++++++++++++++-----
 arch/powerpc/mm/pgtable_32.c          |   10 ++++++++--
 3 files changed, 32 insertions(+), 7 deletions(-)

diff --git a/arch/powerpc/include/asm/pgalloc-32.h b/arch/powerpc/include/asm/pgalloc-32.h
index 580cf73..21b7a94 100644
--- a/arch/powerpc/include/asm/pgalloc-32.h
+++ b/arch/powerpc/include/asm/pgalloc-32.h
@@ -35,6 +35,8 @@ extern void pgd_free(struct mm_struct *mm, pgd_t *pgd);
 #endif
 
 extern pte_t *pte_alloc_one_kernel(struct mm_struct *mm, unsigned long addr);
+extern pte_t *__pte_alloc_one_kernel(struct mm_struct *, unsigned long, gfp_t);
+
 extern pgtable_t pte_alloc_one(struct mm_struct *mm, unsigned long addr);
 
 static inline void pgtable_free(void *table, unsigned index_size)
diff --git a/arch/powerpc/include/asm/pgalloc-64.h b/arch/powerpc/include/asm/pgalloc-64.h
index 292725c..e5ea650 100644
--- a/arch/powerpc/include/asm/pgalloc-64.h
+++ b/arch/powerpc/include/asm/pgalloc-64.h
@@ -51,10 +51,15 @@ static inline void pgd_free(struct mm_struct *mm, pgd_t *pgd)
 
 #define pgd_populate(MM, PGD, PUD)	pgd_set(PGD, PUD)
 
+static inline pud_t *
+__pud_alloc_one(struct mm_struct *mm, unsigned long addr, gfp_t gfp_mask)
+{
+	return kmem_cache_alloc(PGT_CACHE(PUD_INDEX_SIZE), gfp_mask);
+}
+
 static inline pud_t *pud_alloc_one(struct mm_struct *mm, unsigned long addr)
 {
-	return kmem_cache_alloc(PGT_CACHE(PUD_INDEX_SIZE),
-				GFP_KERNEL|__GFP_REPEAT);
+	return __pud_alloc_one(mm, addr, GFP_KERNEL | __GFP_REPEAT);
 }
 
 static inline void pud_free(struct mm_struct *mm, pud_t *pud)
@@ -89,10 +94,15 @@ static inline void pmd_populate_kernel(struct mm_struct *mm, pmd_t *pmd,
 
 #endif /* CONFIG_PPC_64K_PAGES */
 
+static inline pmd_t *
+__pmd_alloc_one(struct mm_struct *mm, unsigned long addr, gfp_t gfp_mask)
+{
+	return kmem_cache_alloc(PGT_CACHE(PMD_INDEX_SIZE), gfp_mask);
+}
+
 static inline pmd_t *pmd_alloc_one(struct mm_struct *mm, unsigned long addr)
 {
-	return kmem_cache_alloc(PGT_CACHE(PMD_INDEX_SIZE),
-				GFP_KERNEL|__GFP_REPEAT);
+	return __pmd_alloc_one(mm, addr, GFP_KERNEL | __GFP_REPEAT);
 }
 
 static inline void pmd_free(struct mm_struct *mm, pmd_t *pmd)
@@ -100,10 +110,17 @@ static inline void pmd_free(struct mm_struct *mm, pmd_t *pmd)
 	kmem_cache_free(PGT_CACHE(PMD_INDEX_SIZE), pmd);
 }
 
+static inline pte_t *
+__pte_alloc_one_kernel(struct mm_struct *mm, unsigned long address, 
+		gfp_t gfp_mask)
+{
+        return (pte_t *)__get_free_page(gfp_mask | __GFP_ZERO);
+}
+
 static inline pte_t *pte_alloc_one_kernel(struct mm_struct *mm,
 					  unsigned long address)
 {
-        return (pte_t *)__get_free_page(GFP_KERNEL | __GFP_REPEAT | __GFP_ZERO);
+	return __pte_alloc_one_kernel(mm, address, GFP_KERNEL | __GFP_REPEAT);
 }
 
 static inline pgtable_t pte_alloc_one(struct mm_struct *mm,
diff --git a/arch/powerpc/mm/pgtable_32.c b/arch/powerpc/mm/pgtable_32.c
index 8dc41c0..736593f 100644
--- a/arch/powerpc/mm/pgtable_32.c
+++ b/arch/powerpc/mm/pgtable_32.c
@@ -95,14 +95,15 @@ void pgd_free(struct mm_struct *mm, pgd_t *pgd)
 #endif
 }
 
-__init_refok pte_t *pte_alloc_one_kernel(struct mm_struct *mm, unsigned long address)
+__init_refok pte_t *
+__pte_alloc_one_kernel(struct mm_struct *mm, unsigned long address, gfp_t gfp_mask)
 {
 	pte_t *pte;
 	extern int mem_init_done;
 	extern void *early_get_page(void);
 
 	if (mem_init_done) {
-		pte = (pte_t *)__get_free_page(GFP_KERNEL|__GFP_REPEAT|__GFP_ZERO);
+		pte = (pte_t *)__get_free_page(gfp_mask | __GFP_ZERO);
 	} else {
 		pte = (pte_t *)early_get_page();
 		if (pte)
@@ -111,6 +112,11 @@ __init_refok pte_t *pte_alloc_one_kernel(struct mm_struct *mm, unsigned long add
 	return pte;
 }
 
+__init_refok pte_t *pte_alloc_one_kernel(struct mm_struct *mm, unsigned long address)
+{
+	return __pte_alloc_one_kernel(mm, address, GFP_KERNEL | __GFP_REPEAT);
+}
+
 pgtable_t pte_alloc_one(struct mm_struct *mm, unsigned long address)
 {
 	struct page *ptepage;
-- 
1.7.0.4

