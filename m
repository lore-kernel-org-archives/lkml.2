Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757270Ab1CRUGD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Mar 2011 16:06:03 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:63761 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756818Ab1CRUF7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Mar 2011 16:05:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=lbP57Pm95l67b+G+w7J2Q02qESNmGRP3vxOt5r8Il/60u32i2+9PryhpxsWKuESu/X
         Q0/DjmuHO2r+O/UzJZqDVB7Wo3rbuA+nUEiSOHOTh9YLq4UFVUr4B772/RhUsySYRz4l
         DEbx8GnsFqXnxdDwPjue+sffJ3iUDcaNIvCgA=
Date: Fri, 18 Mar 2011 20:06:38 +0000
From: Prasad Joshi <prasadjoshi124@gmail.com>
To: dhowells@redhat.com, linux-kernel@vger.kernel.org,
        prasadjoshi124@gmail.com, mitra@kqinfotech.com
Subject: Re: [RFC][PATCH v3 18/22] mm, frv: add gfp flags variant of pud,
 pmd and pte allocations
Message-ID: <20110318200638.GS4746@prasad-kvm>
References: <20110318195507.GI4746@prasad-kvm>
 <20110318195643.GJ4746@prasad-kvm>
 <20110318195754.GK4746@prasad-kvm>
 <20110318195926.GL4746@prasad-kvm>
 <20110318200045.GM4746@prasad-kvm>
 <20110318200150.GN4746@prasad-kvm>
 <20110318200254.GO4746@prasad-kvm>
 <20110318200401.GP4746@prasad-kvm>
 <20110318200452.GQ4746@prasad-kvm>
 <20110318200547.GR4746@prasad-kvm>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110318200547.GR4746@prasad-kvm>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


- Added __pmd_alloc_one and __pud_alloc_one, which are same as pmd_alloc_one
   and pud_alloc_one respectively, but has extra parameter to specify the
   allocation flag

- Added __pte_alloc_one_kernel to allocate page using specified GFP flag

- Changed pte_alloc_one_kernel to call __pte_alloc_one_kernel passing
  GFP_KERNEL allocation flag
- Helps in fixing the Bug 30702

Signed-off-by: Prasad Joshi <prasadjoshi124@gmail.com>
Signed-off-by: Anand Mitra <mitra@kqinfotech.com>
---
 arch/frv/include/asm/pgalloc.h |    3 +++
 arch/frv/include/asm/pgtable.h |    1 +
 arch/frv/mm/pgalloc.c          |    9 +++++++--
 3 files changed, 11 insertions(+), 2 deletions(-)

diff --git a/arch/frv/include/asm/pgalloc.h b/arch/frv/include/asm/pgalloc.h
index 416d19a..bfc4f7c 100644
--- a/arch/frv/include/asm/pgalloc.h
+++ b/arch/frv/include/asm/pgalloc.h
@@ -35,8 +35,10 @@ extern pgd_t *pgd_alloc(struct mm_struct *);
 extern void pgd_free(struct mm_struct *mm, pgd_t *);
 
 extern pte_t *pte_alloc_one_kernel(struct mm_struct *, unsigned long);
+extern pte_t *__pte_alloc_one_kernel(struct mm_struct *, unsigned long, gfp_t);
 
 extern pgtable_t pte_alloc_one(struct mm_struct *, unsigned long);
+extern pgtable_t __pte_alloc_one(struct mm_struct *, unsigned long, gfp_t);
 
 static inline void pte_free_kernel(struct mm_struct *mm, pte_t *pte)
 {
@@ -60,6 +62,7 @@ do {							\
  * inside the pgd, so has no extra memory associated with it.
  * (In the PAE case we free the pmds as part of the pgd.)
  */
+#define __pmd_alloc_one(mm, addr,mask)		({ BUG(); ((pmd_t *) 2); })
 #define pmd_alloc_one(mm, addr)		({ BUG(); ((pmd_t *) 2); })
 #define pmd_free(mm, x)			do { } while (0)
 #define __pmd_free_tlb(tlb,x,a)		do { } while (0)
diff --git a/arch/frv/include/asm/pgtable.h b/arch/frv/include/asm/pgtable.h
index 6bc241e..698e280 100644
--- a/arch/frv/include/asm/pgtable.h
+++ b/arch/frv/include/asm/pgtable.h
@@ -223,6 +223,7 @@ static inline pud_t *pud_offset(pgd_t *pgd, unsigned long address)
  * allocating and freeing a pud is trivial: the 1-entry pud is
  * inside the pgd, so has no extra memory associated with it.
  */
+#define __pud_alloc_one(mm, address, mask)		NULL
 #define pud_alloc_one(mm, address)		NULL
 #define pud_free(mm, x)				do { } while (0)
 #define __pud_free_tlb(tlb, x, address)		do { } while (0)
diff --git a/arch/frv/mm/pgalloc.c b/arch/frv/mm/pgalloc.c
index c42c83d..374cd2c 100644
--- a/arch/frv/mm/pgalloc.c
+++ b/arch/frv/mm/pgalloc.c
@@ -20,14 +20,19 @@
 
 pgd_t swapper_pg_dir[PTRS_PER_PGD] __attribute__((aligned(PAGE_SIZE)));
 
-pte_t *pte_alloc_one_kernel(struct mm_struct *mm, unsigned long address)
+pte_t *__pte_alloc_one_kernel(struct mm_struct *mm, unsigned long address, gfp_t gfp_mask)
 {
-	pte_t *pte = (pte_t *)__get_free_page(GFP_KERNEL|__GFP_REPEAT);
+	pte_t *pte = (pte_t *)__get_free_page(gfp_mask);
 	if (pte)
 		clear_page(pte);
 	return pte;
 }
 
+pte_t *pte_alloc_one_kernel(struct mm_struct *mm, unsigned long address)
+{
+	return __pte_alloc_one_kernel(mm, address, GFP_KERNEL | __GFP_REPEAT);
+}
+
 pgtable_t pte_alloc_one(struct mm_struct *mm, unsigned long address)
 {
 	struct page *page;
-- 
1.7.0.4

