Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756802Ab1CNRf7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Mar 2011 13:35:59 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:60067 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755965Ab1CNRf5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Mar 2011 13:35:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=N3roPPkTlBkLcq2J0kqG0XcnkFxd7Mwl9kiLEghSL7PZxRr3zVXJOrYW0J1BLif7/9
         1nMZhz4OHEzoRqdXsa2XsMZTdqxlHHdo8oYfoPVg0WNwEA6C8NVM7HSoC86VBASjP06Q
         06m0XDRrSa8vbI2KJlmruUCjKbiSlupqNdaQU=
MIME-Version: 1.0
Date: Mon, 14 Mar 2011 17:35:56 +0000
Message-ID: <AANLkTinMtOpFe4z6JKYRPbTEr0FR-iR0xgRjB+jnq=ME@mail.gmail.com>
Subject: [RFC][PATCH v2 05/23] (frv) __vmalloc: add gfp flags variant of pte
 and pmd allocation
From: Prasad Joshi <prasadjoshi124@gmail.com>
To: David Howells <dhowells@redhat.com>,
        Prasad Joshi <prasadjoshi124@gmail.com>,
        Anand Mitra <mitra@kqinfotech.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        linux-arch@vger.kernel.org
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
arch/frv/include/asm/pgalloc.h |    3 +++
arch/frv/include/asm/pgtable.h |    1 +
arch/frv/mm/pgalloc.c          |    9 +++++++--
3 files changed, 11 insertions(+), 2 deletions(-)
---
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
@@ -223,6 +223,7 @@ static inline pud_t *pud_offset(pgd_t *pgd,
unsigned long address)
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
+pte_t *__pte_alloc_one_kernel(struct mm_struct *mm, unsigned long
address, gfp_t gfp_mask)
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
