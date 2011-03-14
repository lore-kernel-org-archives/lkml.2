Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756883Ab1CNRmI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Mar 2011 13:42:08 -0400
Received: from mail-qy0-f174.google.com ([209.85.216.174]:44236 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752874Ab1CNRmH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Mar 2011 13:42:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=iaRnrRFiS7AW9k5WrXxEdo3kyskHVHsgQAodP6FS9GQy9FE69EhrQHf7XtO1vrZAKm
         olm05c/0smiZp5RYwIMG3p/sVUk6ddIP2qLSAvgQs8yorgwxQYre9dZ7VuP3WNnTMn/G
         wEGLRdP/kKMt7bBMElLuCW/c4T2QD8zNTgtrg=
MIME-Version: 1.0
Date: Mon, 14 Mar 2011 17:42:04 +0000
Message-ID: <AANLkTi=aZBzCXBwxYPYxs4SQ0L0gKO+tywPBcnAqfLpx@mail.gmail.com>
Subject: [RFC][PATCH v2 08/23] (m68k) __vmalloc: add gfp flags variant of pte
 and pmd allocation
From: Prasad Joshi <prasadjoshi124@gmail.com>
To: Prasad Joshi <prasadjoshi124@gmail.com>,
        Anand Mitra <mitra@kqinfotech.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        linux-arch@vger.kernel.org, Geert Uytterhoeven <geert@linux-m68k.org>,
        Roman Zippel <zippel@linux-m68k.org>, linux-m68k@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

__vmalloc: propagating GFP allocation flag.

- adds functions to allow caller to pass the GFP flag for memory allocation
- helps in fixing the Bug 30702 (__vmalloc(GFP_NOFS) can callback
		  file system evict_inode).

Signed-off-by: Anand Mitra <mitra@kqinfotech.com>
Signed-off-by: Prasad Joshi <prasadjoshi124@gmail.com>
---
Chnagelog:
arch/m68k/include/asm/motorola_pgalloc.h |   20 +++++++++++++++++---
arch/m68k/include/asm/sun3_pgalloc.h     |   14 +++++++++++---
arch/m68k/mm/memory.c                    |    9 +++++++--
3 files changed, 35 insertions(+), 8 deletions(-)
---
diff --git a/arch/m68k/include/asm/motorola_pgalloc.h
b/arch/m68k/include/asm/motorola_pgalloc.h
index 2f02f26..0d345e6 100644
--- a/arch/m68k/include/asm/motorola_pgalloc.h
+++ b/arch/m68k/include/asm/motorola_pgalloc.h
@@ -5,13 +5,16 @@
 #include <asm/tlbflush.h>

 extern pmd_t *get_pointer_table(void);
+extern pmd_t *__get_pointer_table (gfp_t);
 extern int free_pointer_table(pmd_t *);

-static inline pte_t *pte_alloc_one_kernel(struct mm_struct *mm,
unsigned long address)
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
@@ -21,6 +24,12 @@ static inline pte_t *pte_alloc_one_kernel(struct
mm_struct *mm, unsigned long ad
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
@@ -61,10 +70,15 @@ static inline void __pte_free_tlb(struct
mmu_gather *tlb, pgtable_t page,
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
diff --git a/arch/m68k/include/asm/sun3_pgalloc.h
b/arch/m68k/include/asm/sun3_pgalloc.h
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
@@ -50,6 +52,12 @@ static inline pte_t *pte_alloc_one_kernel(struct
mm_struct *mm,
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
