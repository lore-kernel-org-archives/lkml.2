Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755659Ab1CNRj5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Mar 2011 13:39:57 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:53522 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751853Ab1CNRj4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Mar 2011 13:39:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=U8BkqF99q8Iemc6iFyZANYp/LBc/BlMGtlJ41ZXwUHeTsxl0bCX+upWbarMWbQilVL
         lM7eqwl0P5iHq2dqzi8tC7M9sWlWPhD6dd/ypWKt0cnn6qgCub8KUNnKZM0qTIfnB5nZ
         k0iiFGfSajCdjLBDuPFyyUUu8GRllQgelRmgY=
MIME-Version: 1.0
Date: Mon, 14 Mar 2011 17:39:54 +0000
Message-ID: <AANLkTi=N6mnsHr-Cci3SOxYf=aNvPD-aEfLkQpU5-6+z@mail.gmail.com>
Subject: [RFC][PATCH v2 07/23] (m32r) __vmalloc: add gfp flags variant of pte
 and pmd allocation
From: Prasad Joshi <prasadjoshi124@gmail.com>
To: Hirokazu Takata <takata@linux-m32r.org>, linux-m32r@ml.linux-m32r.org,
        linux-m32r-ja@ml.linux-m32r.org,
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
arch/m32r/include/asm/pgalloc.h |   11 ++++++++---
1 files changed, 8 insertions(+), 3 deletions(-)
---
diff --git a/arch/m32r/include/asm/pgalloc.h b/arch/m32r/include/asm/pgalloc.h
index 0fc7361..0c1e4ae 100644
--- a/arch/m32r/include/asm/pgalloc.h
+++ b/arch/m32r/include/asm/pgalloc.h
@@ -30,12 +30,16 @@ static inline void pgd_free(struct mm_struct *mm,
pgd_t *pgd)
 	free_page((unsigned long)pgd);
 }

+static __inline__ pte_t *__pte_alloc_one_kernel(struct mm_struct *mm,
+	unsigned long address, gfp_t gfp_mask)
+{
+	return (pte_t *)__get_free_page(gfp_mask | __GFP_ZERO);
+}
+
 static __inline__ pte_t *pte_alloc_one_kernel(struct mm_struct *mm,
 	unsigned long address)
 {
-	pte_t *pte = (pte_t *)__get_free_page(GFP_KERNEL|__GFP_ZERO);
-
-	return pte;
+	return __pte_alloc_one_kernel(mm, address, GFP_KERNEL);
 }

 static __inline__ pgtable_t pte_alloc_one(struct mm_struct *mm,
@@ -66,6 +70,7 @@ static inline void pte_free(struct mm_struct *mm,
pgtable_t pte)
  * (In the PAE case we free the pmds as part of the pgd.)
  */

+#define __pmd_alloc_one(mm, addr,mask)		({ BUG(); ((pmd_t *)2); })
 #define pmd_alloc_one(mm, addr)		({ BUG(); ((pmd_t *)2); })
 #define pmd_free(mm, x)			do { } while (0)
 #define __pmd_free_tlb(tlb, x, addr)	do { } while (0)
