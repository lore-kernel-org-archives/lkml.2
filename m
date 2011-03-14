Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754050Ab1CNSMM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Mar 2011 14:12:12 -0400
Received: from mail-qy0-f174.google.com ([209.85.216.174]:49928 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752465Ab1CNSMK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Mar 2011 14:12:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=uIGN3Y16gE7RCqa1hKNdU2hNVtbyxwt2FVrhHCiiXinI7avSEi1S/kkjAwYDraLbKu
         1yZBJhlPfejuGQWtY/TVi68mV5/5fZrLvn9HxAlexA1bhuSwPnJqAwR+4lxkh2FDMYOc
         G8emPP0viOPKwMI3N7z3D8jl0hxd3bmyvgaTk=
MIME-Version: 1.0
Date: Mon, 14 Mar 2011 18:12:09 +0000
Message-ID: <AANLkTim8nHe1jXagKg-5g0ZLh7J61LzAi0ww__Kgaerx@mail.gmail.com>
Subject: [RFC][PATCH v2 21/23] (um) __vmalloc: add gfp flags variant of pte
 and pmd allocation
From: Prasad Joshi <prasadjoshi124@gmail.com>
To: Jeff Dike <jdike@addtoit.com>, Tejun Heo <tj@kernel.org>,
        user-mode-linux-devel@lists.sourceforge.net,
        UML Mailing List <user-mode-linux-user@lists.sourceforge.net>,
        Prasad Joshi <prasadjoshi124@gmail.com>,
        Anand Mitra <mitra@kqinfotech.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        linux-arch@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

diff --git a/arch/um/include/asm/pgalloc.h b/arch/um/include/asm/pgalloc.h
index 32c8ce4..8b6257e 100644
--- a/arch/um/include/asm/pgalloc.h
+++ b/arch/um/include/asm/pgalloc.h
@@ -27,6 +27,7 @@ extern pgd_t *pgd_alloc(struct mm_struct *);
 extern void pgd_free(struct mm_struct *mm, pgd_t *pgd);

 extern pte_t *pte_alloc_one_kernel(struct mm_struct *, unsigned long);
+extern pte_t *__pte_alloc_one_kernel(struct mm_struct *, unsigned long, gfp_t);
 extern pgtable_t pte_alloc_one(struct mm_struct *, unsigned long);

 static inline void pte_free_kernel(struct mm_struct *mm, pte_t *pte)
diff --git a/arch/um/kernel/mem.c b/arch/um/kernel/mem.c
index 8137ccc..e4caf17 100644
--- a/arch/um/kernel/mem.c
+++ b/arch/um/kernel/mem.c
@@ -284,12 +284,15 @@ void pgd_free(struct mm_struct *mm, pgd_t *pgd)
    free_page((unsigned long) pgd);
 }

-pte_t *pte_alloc_one_kernel(struct mm_struct *mm, unsigned long address)
+pte_t *
+__pte_alloc_one_kernel(struct mm_struct *mm, unsigned long address,
gfp_t gfp_mask)
 {
-   pte_t *pte;
+   return (pte_t *)__get_free_page(gfp_mask | __GFP_ZERO);
+}

-   pte = (pte_t *)__get_free_page(GFP_KERNEL|__GFP_REPEAT|__GFP_ZERO);
-   return pte;
+pte_t *pte_alloc_one_kernel(struct mm_struct *mm, unsigned long address)
+{
+   return __pte_alloc_one_kernel(mm, address, GFP_KERNEL | __GFP_REPEAT);
 }

 pgtable_t pte_alloc_one(struct mm_struct *mm, unsigned long address)
@@ -303,15 +306,21 @@ pgtable_t pte_alloc_one(struct mm_struct *mm,
unsigned long address)
 }

 #ifdef CONFIG_3_LEVEL_PGTABLES
-pmd_t *pmd_alloc_one(struct mm_struct *mm, unsigned long address)
+pmd_t *
+__pmd_alloc_one(struct mm_struct *mm, unsigned long address, gfp_t gfp_mask)
 {
-   pmd_t *pmd = (pmd_t *) __get_free_page(GFP_KERNEL);
+   pmd_t *pmd = (pmd_t *) __get_free_page(gfp_mask);

    if (pmd)
        memset(pmd, 0, PAGE_SIZE);

    return pmd;
 }
+
+pmd_t *pmd_alloc_one(struct mm_struct *mm, unsigned long address)
+{
+   return __pmd_alloc_one(mm, address, GFP_KERNEL);
+}
 #endif

 void *uml_kmalloc(int size, int flags)
