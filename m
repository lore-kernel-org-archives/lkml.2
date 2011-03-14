Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753234Ab1CNSH3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Mar 2011 14:07:29 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:46826 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752504Ab1CNSH2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Mar 2011 14:07:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=u1W9ir3nlbcjsq1Q3arHoihcMM9jb6RNFmN8ees571j8LwqEk/JWzDkVvikB8XiHZC
         eVfTX3tsf8fhnnpiv9VOGo1FRUQqkYxidkQ168IdiDwoqTwbpz1CkATCmv7cv5l6Dujt
         Lr+uOIVoOknG/1bpp90fXeOwNeCuaXyWJQDa8=
MIME-Version: 1.0
Date: Mon, 14 Mar 2011 18:07:26 +0000
Message-ID: <AANLkTikenEE4GOHM4VgLEOrQjDXaYW+TRy8RLT9V28mu@mail.gmail.com>
Subject: [RFC][PATCH v2 20/23] (xtensa) __vmalloc: add gfp flags variant of
 pte, pmd, and pud allocation
From: Prasad Joshi <prasadjoshi124@gmail.com>
To: Chris Zankel <chris@zankel.net>, Prasad Joshi <prasadjoshi124@gmail.com>,
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
arch/xtensa/include/asm/pgalloc.h |    9 ++++++++-
arch/xtensa/mm/pgtable.c          |   11 +++++++++--
2 files changed, 17 insertions(+), 3 deletions(-)
---
diff --git a/arch/xtensa/include/asm/pgalloc.h
b/arch/xtensa/include/asm/pgalloc.h
index 40cf9bc..d5a23ae 100644
--- a/arch/xtensa/include/asm/pgalloc.h
+++ b/arch/xtensa/include/asm/pgalloc.h
@@ -42,10 +42,17 @@ static inline void pgd_free(struct mm_struct *mm,
pgd_t *pgd)

 extern struct kmem_cache *pgtable_cache;

+static inline pte_t *
+__pte_alloc_one_kernel(struct mm_struct *mm, unsigned long address,
+		gfp_t gfp_mask)
+{
+	return kmem_cache_alloc(pgtable_cache, gfp_mask);
+}
+
 static inline pte_t *pte_alloc_one_kernel(struct mm_struct *mm,
 					 unsigned long address)
 {
-	return kmem_cache_alloc(pgtable_cache, GFP_KERNEL|__GFP_REPEAT);
+	return __pte_alloc_one_kernel(mm, address, GFP_KERNEL | __GFP_REPEAT);
 }

 static inline pgtable_t pte_alloc_one(struct mm_struct *mm,
diff --git a/arch/xtensa/mm/pgtable.c b/arch/xtensa/mm/pgtable.c
index 6979927..eff6c1d 100644
--- a/arch/xtensa/mm/pgtable.c
+++ b/arch/xtensa/mm/pgtable.c
@@ -12,13 +12,15 @@

 #if (DCACHE_SIZE > PAGE_SIZE)

-pte_t* pte_alloc_one_kernel(struct mm_struct *mm, unsigned long address)
+pte_t*
+__pte_alloc_one_kernel(struct mm_struct *mm, unsigned long address,
+		gfp_t gfp_mask)
 {
 	pte_t *pte = NULL, *p;
 	int color = ADDR_COLOR(address);
 	int i;

-	p = (pte_t*) __get_free_pages(GFP_KERNEL|__GFP_REPEAT, COLOR_ORDER);
+	p = (pte_t*) __get_free_pages(gfp_mask, COLOR_ORDER);

 	if (likely(p)) {
 		split_page(virt_to_page(p), COLOR_ORDER);
@@ -35,6 +37,11 @@ pte_t* pte_alloc_one_kernel(struct mm_struct *mm,
unsigned long address)
 	return pte;
 }

+pte_t* pte_alloc_one_kernel(struct mm_struct *mm, unsigned long address)
+{
+	return __pte_alloc_one_kernel(mm, address, GFP_KERNEL | __GFP_REPEAT);
+}
+
 #ifdef PROFILING

 int mask;
