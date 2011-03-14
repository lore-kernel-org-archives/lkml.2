Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757112Ab1CNR7w (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Mar 2011 13:59:52 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:43869 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757073Ab1CNR7t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Mar 2011 13:59:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=b7wna/jdG7Driq+526ur6Lp8HONdnKRimPWH0OEANGbqMI4Ma+5QA+grIu3VFXOruC
         6cKYV2IcfapO3p/3kFOJiG6E26G9KayItjTDLASJledEz/EdkdFJHlThvE5htdxggkFY
         FctdnAtl//uTMS6wqmYlkPJOcQatOREL/woQ4=
MIME-Version: 1.0
Date: Mon, 14 Mar 2011 17:59:48 +0000
Message-ID: <AANLkTim9zfcfMkLhQeXE7TCdFGGF8Ypb_h=s4bxFMZ9E@mail.gmail.com>
Subject: [RFC][PATCH v2 16/23] (sh) __vmalloc: add gfp flags variant of pte
 and pmd allocation
From: Prasad Joshi <prasadjoshi124@gmail.com>
To: Paul Mundt <lethal@linux-sh.org>, linux-sh@vger.kernel.org,
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
arch/sh/include/asm/pgalloc.h |    8 +++++++-
arch/sh/mm/pgtable.c          |    8 +++++++-
2 files changed, 14 insertions(+), 2 deletions(-)
---
diff --git a/arch/sh/include/asm/pgalloc.h b/arch/sh/include/asm/pgalloc.h
index 8c00785..aaed989 100644
--- a/arch/sh/include/asm/pgalloc.h
+++ b/arch/sh/include/asm/pgalloc.h
@@ -31,10 +31,16 @@ static inline void pmd_populate(struct mm_struct
*mm, pmd_t *pmd,
 /*
  * Allocate and free page tables.
  */
+static inline pte_t *__pte_alloc_one_kernel(struct mm_struct *mm,
+					  unsigned long address, gfp_t gfp_mask)
+{
+	return quicklist_alloc(QUICK_PT, gfp_mask, NULL);
+}
+
 static inline pte_t *pte_alloc_one_kernel(struct mm_struct *mm,
 					  unsigned long address)
 {
-	return quicklist_alloc(QUICK_PT, GFP_KERNEL | __GFP_REPEAT, NULL);
+	return __pte_alloc_one_kernel(mm, address, GFP_KERNEL | __GFP_REPEAT);
 }

 static inline pgtable_t pte_alloc_one(struct mm_struct *mm,
diff --git a/arch/sh/mm/pgtable.c b/arch/sh/mm/pgtable.c
index 26e03a1..b938eb8 100644
--- a/arch/sh/mm/pgtable.c
+++ b/arch/sh/mm/pgtable.c
@@ -45,9 +45,15 @@ void pud_populate(struct mm_struct *mm, pud_t *pud,
pmd_t *pmd)
 	set_pud(pud, __pud((unsigned long)pmd));
 }

+pmd_t *
+__pmd_alloc_one(struct mm_struct *mm, unsigned long address, gfp_t gfp_mask)
+{
+	return kmem_cache_alloc(pmd_cachep, gfp_mask | __GFP_ZERO);
+}
+
 pmd_t *pmd_alloc_one(struct mm_struct *mm, unsigned long address)
 {
-	return kmem_cache_alloc(pmd_cachep, PGALLOC_GFP);
+	return __pmd_alloc_one(mm, address, GFP_KERNEL | __GFP_REPEAT);
 }

 void pmd_free(struct mm_struct *mm, pmd_t *pmd)
