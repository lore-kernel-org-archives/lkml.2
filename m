Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932131Ab1CNSEh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Mar 2011 14:04:37 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:40014 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757194Ab1CNSE0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Mar 2011 14:04:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=SuA4dUFm0e8t879r1nfYIfarTykbJ29ZPBaN+0O6pNcR85AwKE7P3sUgeF20b3eXBs
         LMAfRkGX/UMbyEKn3eb1m8y5KenebuTszCSA/eGA2zGOaf0CupUalukpm+hNRmnKDi8k
         GPbSgmiz5yRGcvCLkf+LOGptLTD65K+qLRYRQ=
MIME-Version: 1.0
Date: Mon, 14 Mar 2011 18:04:25 +0000
Message-ID: <AANLkTinAp6FyP9Ln7HJOY0wZEZyW4yvfjgdOJK1uNzu_@mail.gmail.com>
Subject: [RFC][PATCH v2 19/23] (x86) __vmalloc: add gfp flags variant of pte,
 pmd, and pud allocation
From: Prasad Joshi <prasadjoshi124@gmail.com>
To: Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>, x86@kernel.org,
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
arch/x86/include/asm/pgalloc.h |   17 +++++++++++++++--
arch/x86/mm/pgtable.c          |    8 +++++++-
2 files changed, 22 insertions(+), 3 deletions(-)
---
diff --git a/arch/x86/include/asm/pgalloc.h b/arch/x86/include/asm/pgalloc.h
index b4389a4..db83bd4 100644
--- a/arch/x86/include/asm/pgalloc.h
+++ b/arch/x86/include/asm/pgalloc.h
@@ -34,6 +34,7 @@ extern pgd_t *pgd_alloc(struct mm_struct *);
 extern void pgd_free(struct mm_struct *mm, pgd_t *pgd);

 extern pte_t *pte_alloc_one_kernel(struct mm_struct *, unsigned long);
+extern pte_t *__pte_alloc_one_kernel(struct mm_struct *, unsigned long, gfp_t);
 extern pgtable_t pte_alloc_one(struct mm_struct *, unsigned long);

 /* Should really implement gc for free page table pages. This could be
@@ -78,9 +79,15 @@ static inline void pmd_populate(struct mm_struct
*mm, pmd_t *pmd,
 #define pmd_pgtable(pmd) pmd_page(pmd)

 #if PAGETABLE_LEVELS > 2
+static inline pmd_t *
+__pmd_alloc_one(struct mm_struct *mm, unsigned long addr, gfp_t gfp_mask)
+{
+	return (pmd_t *)get_zeroed_page(gfp_mask);
+}
+
 static inline pmd_t *pmd_alloc_one(struct mm_struct *mm, unsigned long addr)
 {
-	return (pmd_t *)get_zeroed_page(GFP_KERNEL|__GFP_REPEAT);
+	return __pmd_alloc_one(mm, addr, GFP_KERNEL | __GFP_REPEAT);
 }

 static inline void pmd_free(struct mm_struct *mm, pmd_t *pmd)
@@ -114,9 +121,15 @@ static inline void pgd_populate(struct mm_struct
*mm, pgd_t *pgd, pud_t *pud)
 	set_pgd(pgd, __pgd(_PAGE_TABLE | __pa(pud)));
 }

+static inline pud_t *
+__pud_alloc_one(struct mm_struct *mm, unsigned long addr, gfp_t gfp_mask)
+{
+	return (pud_t *)get_zeroed_page(gfp_mask);
+}
+
 static inline pud_t *pud_alloc_one(struct mm_struct *mm, unsigned long addr)
 {
-	return (pud_t *)get_zeroed_page(GFP_KERNEL|__GFP_REPEAT);
+	return __pud_alloc_one(mm, addr, GFP_KERNEL | __GFP_REPEAT);
 }

 static inline void pud_free(struct mm_struct *mm, pud_t *pud)
diff --git a/arch/x86/mm/pgtable.c b/arch/x86/mm/pgtable.c
index 500242d..c42a27c 100644
--- a/arch/x86/mm/pgtable.c
+++ b/arch/x86/mm/pgtable.c
@@ -15,9 +15,15 @@

 gfp_t __userpte_alloc_gfp = PGALLOC_GFP | PGALLOC_USER_GFP;

+pte_t *
+__pte_alloc_one_kernel(struct mm_struct *mm, unsigned long address,
gfp_t gfp_mask)
+{
+	return (pte_t *)__get_free_page(gfp_mask | __GFP_NOTRACK | __GFP_ZERO);
+}
+
 pte_t *pte_alloc_one_kernel(struct mm_struct *mm, unsigned long address)
 {
-	return (pte_t *)__get_free_page(PGALLOC_GFP);
+	return __pte_alloc_one_kernel(mm, address, GFP_KERNEL | __GFP_REPEAT);
 }

 pgtable_t pte_alloc_one(struct mm_struct *mm, unsigned long address)
