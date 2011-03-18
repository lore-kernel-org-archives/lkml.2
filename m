Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757446Ab1CRUD2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Mar 2011 16:03:28 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:57202 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757239Ab1CRUDW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Mar 2011 16:03:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=ANRjc0cuU+97379wO2auLp5fr7cv3+arF8eMex1fRwYVmXpfhcMSkf8x76+g/E/7o5
         kQ2yfohdUz5ILbdjAH8f//ECNW9HeHaVfOUPfaUTebrtAQ+zf25A0bjZVn8eFrC7xsLq
         JznqjjxOvDlq9GCPX17hB5mwWg6uxUI4eGRpk=
Date: Fri, 18 Mar 2011 20:04:01 +0000
From: Prasad Joshi <prasadjoshi124@gmail.com>
To: geert@linux-m68k.org, zippel@linux-m68k.org, sammy@sammy.net,
        linux-m68k@vger.kernel.org, linux-kernel@vger.kernel.org,
        prasadjoshi124@gmail.com, mitra@kqinfotech.com
Subject: Re: [RFC][PATCH v3 15/22] mm, m68k: add gfp flags variant of pmd
 and pte allocations
Message-ID: <20110318200401.GP4746@prasad-kvm>
References: <20110318195035.GF4746@prasad-kvm>
 <20110318195141.GG4746@prasad-kvm>
 <20110318195307.GH4746@prasad-kvm>
 <20110318195507.GI4746@prasad-kvm>
 <20110318195643.GJ4746@prasad-kvm>
 <20110318195754.GK4746@prasad-kvm>
 <20110318195926.GL4746@prasad-kvm>
 <20110318200045.GM4746@prasad-kvm>
 <20110318200150.GN4746@prasad-kvm>
 <20110318200254.GO4746@prasad-kvm>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110318200254.GO4746@prasad-kvm>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Changes for motorola (motorola_pgalloc.h)
 - Added __pte_alloc_one_kernel to allocate zeroed page using given gfp_t flag

- Changed pte_alloc_one_kernel() to call __pte_alloc_one_kernel() passing
  correct allocation flag.

- Added __pmd_alloc_one() to accepts gfp_t flag and pass it to
  __get_pointer_table()

- Changed pmd_alloc_one() to call __pmd_alloc_one() passing GFP_KERNEL
  allocation flag.

Changes for sun3 (sun3_pgalloc.h)
- Added function __pmd_alloc_one which is same as pmd_alloc_one, but accepts
  an extra argument for gfp_t flag.

- Added function __pte_alloc_one_kernel to allocated page using
  allocation flag passed as an argument.

- Changed pte_alloc_one_kernel to call __pte_alloc_one_kernel using
  GFP_KERNEL allocation flag.

Generic Changes (mm/memory.c)
- Added __get_pointer_table() function which is same as get_pointer_table(),
  but allows caller to pass the allocation flag.

- Changed get_pointer_table() to call __get_pointer_table() passing
  GFP_KERNEL allocation flag.

- All these changes help in fixing the Bug 30702

Signed-off-by: Prasad Joshi <prasadjoshi124@gmail.com>
Signed-off-by: Anand Mitra <mitra@kqinfotech.com>
---
 arch/m68k/include/asm/motorola_pgalloc.h |   20 +++++++++++++++++---
 arch/m68k/include/asm/sun3_pgalloc.h     |   14 +++++++++++---
 arch/m68k/mm/memory.c                    |    9 +++++++--
 3 files changed, 35 insertions(+), 8 deletions(-)

diff --git a/arch/m68k/include/asm/motorola_pgalloc.h b/arch/m68k/include/asm/motorola_pgalloc.h
index 2f02f26..0d345e6 100644
--- a/arch/m68k/include/asm/motorola_pgalloc.h
+++ b/arch/m68k/include/asm/motorola_pgalloc.h
@@ -5,13 +5,16 @@
 #include <asm/tlbflush.h>
 
 extern pmd_t *get_pointer_table(void);
+extern pmd_t *__get_pointer_table (gfp_t);
 extern int free_pointer_table(pmd_t *);
 
-static inline pte_t *pte_alloc_one_kernel(struct mm_struct *mm, unsigned long address)
+static inline pte_t *
+__pte_alloc_one_kernel(struct mm_struct *mm, unsigned long address, 
+	gfp_t gfp_mask)
 {
 	pte_t *pte;
 
-	pte = (pte_t *)__get_free_page(GFP_KERNEL|__GFP_REPEAT|__GFP_ZERO);
+	pte = (pte_t *)__get_free_page(gfp_mask | __GFP_ZERO);
 	if (pte) {
 		__flush_page_to_ram(pte);
 		flush_tlb_kernel_page(pte);
@@ -21,6 +24,12 @@ static inline pte_t *pte_alloc_one_kernel(struct mm_struct *mm, unsigned long ad
 	return pte;
 }
 
+static inline pte_t *
+pte_alloc_one_kernel(struct mm_struct *mm, unsigned long address)
+{
+	return __pte_alloc_one_kernel(mm, address, GFP_KERNEL | __GFP_REPEAT);
+}
+
 static inline void pte_free_kernel(struct mm_struct *mm, pte_t *pte)
 {
 	cache_page(pte);
@@ -61,10 +70,15 @@ static inline void __pte_free_tlb(struct mmu_gather *tlb, pgtable_t page,
 	__free_page(page);
 }
 
+static inline pmd_t *
+__pmd_alloc_one(struct mm_struct *mm, unsigned long address, gfp_t gfp_mask)
+{
+	return __get_pointer_table(gfp_mask);
+}
 
 static inline pmd_t *pmd_alloc_one(struct mm_struct *mm, unsigned long address)
 {
-	return get_pointer_table();
+	return __pmd_alloc_one(mm, address, GFP_KERNEL);
 }
 
 static inline int pmd_free(struct mm_struct *mm, pmd_t *pmd)
diff --git a/arch/m68k/include/asm/sun3_pgalloc.h b/arch/m68k/include/asm/sun3_pgalloc.h
index 48d80d5..29cddb6 100644
--- a/arch/m68k/include/asm/sun3_pgalloc.h
+++ b/arch/m68k/include/asm/sun3_pgalloc.h
@@ -18,6 +18,7 @@
 
 extern const char bad_pmd_string[];
 
+#define __pmd_alloc_one(mm,address,mask)       ({ BUG(); ((pmd_t *)2); })
 #define pmd_alloc_one(mm,address)       ({ BUG(); ((pmd_t *)2); })
 
 
@@ -38,10 +39,11 @@ do {							\
 	tlb_remove_page((tlb), pte);			\
 } while (0)
 
-static inline pte_t *pte_alloc_one_kernel(struct mm_struct *mm,
-					  unsigned long address)
+static inline pte_t *
+__pte_alloc_one_kernel(struct mm_struct *mm, unsigned long address, 
+		gfp_t gfp_mask)
 {
-	unsigned long page = __get_free_page(GFP_KERNEL|__GFP_REPEAT);
+	unsigned long page = __get_free_page(gfp_mask);
 
 	if (!page)
 		return NULL;
@@ -50,6 +52,12 @@ static inline pte_t *pte_alloc_one_kernel(struct mm_struct *mm,
 	return (pte_t *) (page);
 }
 
+static inline pte_t *pte_alloc_one_kernel(struct mm_struct *mm,
+					  unsigned long address)
+{
+	return __pte_alloc_one_kernel(mm, address, GFP_KERNEL | __GFP_REPEAT);
+}
+
 static inline pgtable_t pte_alloc_one(struct mm_struct *mm,
 					unsigned long address)
 {
diff --git a/arch/m68k/mm/memory.c b/arch/m68k/mm/memory.c
index 34c77ce..1b2da3c 100644
--- a/arch/m68k/mm/memory.c
+++ b/arch/m68k/mm/memory.c
@@ -59,7 +59,7 @@ void __init init_pointer_table(unsigned long ptable)
 	return;
 }
 
-pmd_t *get_pointer_table (void)
+pmd_t *__get_pointer_table (gfp_t gfp_mask)
 {
 	ptable_desc *dp = ptable_list.next;
 	unsigned char mask = PD_MARKBITS (dp);
@@ -76,7 +76,7 @@ pmd_t *get_pointer_table (void)
 		void *page;
 		ptable_desc *new;
 
-		if (!(page = (void *)get_zeroed_page(GFP_KERNEL)))
+		if (!(page = (void *)get_zeroed_page(gfp_mask)))
 			return NULL;
 
 		flush_tlb_kernel_page(page);
@@ -99,6 +99,11 @@ pmd_t *get_pointer_table (void)
 	return (pmd_t *) (page_address(PD_PAGE(dp)) + off);
 }
 
+pmd_t *get_pointer_table (void)
+{
+	return __get_pointer_table(GFP_KERNEL);
+}
+
 int free_pointer_table (pmd_t *ptable)
 {
 	ptable_desc *dp;
-- 
1.7.0.4

