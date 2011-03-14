Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756930Ab1CNRuw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Mar 2011 13:50:52 -0400
Received: from mail-qy0-f181.google.com ([209.85.216.181]:61116 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751249Ab1CNRuu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Mar 2011 13:50:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=mXss1wApLGpnZ4hjVVxGLw10rMPYPw2vz4D5XI2R5leQRPlMDU5sFyhzO/tGMCOq09
         ZpLutngGzuzTG+e1h1ujMEoUKinrJVIpclMznt5yqGUq3n4A42LuEfIkmV426UBFY/eB
         J0dyLz+/3kL7YzZvLQG9MxxctUm0bSjSaEviw=
MIME-Version: 1.0
Date: Mon, 14 Mar 2011 17:50:49 +0000
Message-ID: <AANLkTin94oVyZ0-6sm5aRi-Xb+2tsNXQ2J+DbyDOMqZB@mail.gmail.com>
Subject: [RFC][PATCH v2 12/23] (parisc) __vmalloc: add gfp flags variant of
 pte and pmd allocation
From: Prasad Joshi <prasadjoshi124@gmail.com>
To: Prasad Joshi <prasadjoshi124@gmail.com>,
        Anand Mitra <mitra@kqinfotech.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        linux-arch@vger.kernel.org, Kyle McMartin <kyle@mcmartin.ca>,
        Helge Deller <deller@gmx.de>,
        "James E.J. Bottomley" <jejb@parisc-linux.org>,
        linux-parisc@vger.kernel.org
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
arch/parisc/include/asm/pgalloc.h |   21 ++++++++++++++++-----
1 files changed, 16 insertions(+), 5 deletions(-)
---
diff --git a/arch/parisc/include/asm/pgalloc.h
b/arch/parisc/include/asm/pgalloc.h
index fc987a1..0284a43 100644
--- a/arch/parisc/include/asm/pgalloc.h
+++ b/arch/parisc/include/asm/pgalloc.h
@@ -61,15 +61,20 @@ static inline void pgd_populate(struct mm_struct
*mm, pgd_t *pgd, pmd_t *pmd)
 		        (__u32)(__pa((unsigned long)pmd) >> PxD_VALUE_SHIFT));
 }

-static inline pmd_t *pmd_alloc_one(struct mm_struct *mm, unsigned long address)
+static inline pmd_t *
+__pmd_alloc_one(struct mm_struct *mm, unsigned long address, gfp_t gfp_mask)
 {
-	pmd_t *pmd = (pmd_t *)__get_free_pages(GFP_KERNEL|__GFP_REPEAT,
-					       PMD_ORDER);
+	pmd_t *pmd = (pmd_t *)__get_free_pages(gfp_mask, PMD_ORDER);
 	if (pmd)
 		memset(pmd, 0, PAGE_SIZE<<PMD_ORDER);
 	return pmd;
 }

+static inline pmd_t *pmd_alloc_one(struct mm_struct *mm, unsigned long address)
+{
+	return __pmd_alloc_one(mm, address, GFP_KERNEL | __GFP_REPEAT);
+}
+
 static inline void pmd_free(struct mm_struct *mm, pmd_t *pmd)
 {
 #ifdef CONFIG_64BIT
@@ -90,6 +95,7 @@ static inline void pmd_free(struct mm_struct *mm, pmd_t *pmd)
  * inside the pgd, so has no extra memory associated with it.
  */

+#define __pmd_alloc_one(mm, addr, mask)		({ BUG(); ((pmd_t *)2); })
 #define pmd_alloc_one(mm, addr)		({ BUG(); ((pmd_t *)2); })
 #define pmd_free(mm, x)			do { } while (0)
 #define pgd_populate(mm, pmd, pte)	BUG()
@@ -127,10 +133,15 @@ pte_alloc_one(struct mm_struct *mm, unsigned long address)
 }

 static inline pte_t *
+__pte_alloc_one_kernel(struct mm_struct *mm, unsigned long addr,
gfp_t gfp_mask)
+{
+	return (pte_t *)__get_free_page(gfp_mask | __GFP_ZERO);
+}
+
+static inline pte_t *
 pte_alloc_one_kernel(struct mm_struct *mm, unsigned long addr)
 {
-	pte_t *pte = (pte_t *)__get_free_page(GFP_KERNEL|__GFP_REPEAT|__GFP_ZERO);
-	return pte;
+	return __pte_alloc_one_kernel(mm, addr, GFP_KERNEL | __GFP_REPEAT);
 }

 static inline void pte_free_kernel(struct mm_struct *mm, pte_t *pte)
