Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754506Ab1CNSPB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Mar 2011 14:15:01 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:59840 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753117Ab1CNSPA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Mar 2011 14:15:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=ZO1/a//tsj+kyNxLiILay8VJ5j9rvBdr7hvdXLJY5ub3A1ohW07Dtko4qvl5A9gOXB
         SGVutMb1LVtFF0zkvxyavgiLH1yp0Wm8YNMGa4ldrrmvl9tNqf8LvetECv13c0hBWu2b
         OiYE0Eq4th/DeL85tEntjWq1y+/BBCKbCSCBc=
MIME-Version: 1.0
Date: Mon, 14 Mar 2011 18:14:58 +0000
Message-ID: <AANLkTik=m5dCx_9bmnXfXJ9LPMwoS8Bc3CUoT7OAB5gY@mail.gmail.com>
Subject: [RFC][PATCH v2 22/23] (asm-generic) __vmalloc: add gfp flags variant
 of pte, pmd, and pud allocation
From: Prasad Joshi <prasadjoshi124@gmail.com>
To: Prasad Joshi <prasadjoshi124@gmail.com>,
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
include/asm-generic/4level-fixup.h  |    8 ++++++--
include/asm-generic/pgtable-nopmd.h |    3 ++-
include/asm-generic/pgtable-nopud.h |    1 +
3 files changed, 9 insertions(+), 3 deletions(-)
---
diff --git a/include/asm-generic/4level-fixup.h
b/include/asm-generic/4level-fixup.h
index 77ff547..f638309 100644
--- a/include/asm-generic/4level-fixup.h
+++ b/include/asm-generic/4level-fixup.h
@@ -10,10 +10,14 @@

 #define pud_t				pgd_t

-#define pmd_alloc(mm, pud, address) \
-	((unlikely(pgd_none(*(pud))) && __pmd_alloc(mm, pud, address))? \
+#define pmd_alloc_with_mask(mm, pud, address, mask) \
+	((unlikely(pgd_none(*(pud))) && __pmd_alloc(mm, pud, address, mask))? \
  		NULL: pmd_offset(pud, address))

+#define pmd_alloc(mm, pud, address) \
+	pmd_alloc_with_mask(mm, pud, address, GFP_KERNEL)
+
+#define pud_alloc_with_mask(mm, pgd, address, mask)	(pgd)
 #define pud_alloc(mm, pgd, address)	(pgd)
 #define pud_offset(pgd, start)		(pgd)
 #define pud_none(pud)			0
diff --git a/include/asm-generic/pgtable-nopmd.h
b/include/asm-generic/pgtable-nopmd.h
index 725612b..96ca8da 100644
--- a/include/asm-generic/pgtable-nopmd.h
+++ b/include/asm-generic/pgtable-nopmd.h
@@ -55,7 +55,8 @@ static inline pmd_t * pmd_offset(pud_t * pud,
unsigned long address)
  * allocating and freeing a pmd is trivial: the 1-entry pmd is
  * inside the pud, so has no extra memory associated with it.
  */
-#define pmd_alloc_one(mm, address)		NULL
+#define __pmd_alloc_one(mm, address, mask)		NULL
+#define pmd_alloc_one(mm, address)				NULL
 static inline void pmd_free(struct mm_struct *mm, pmd_t *pmd)
 {
 }
diff --git a/include/asm-generic/pgtable-nopud.h
b/include/asm-generic/pgtable-nopud.h
index 810431d..5a21868 100644
--- a/include/asm-generic/pgtable-nopud.h
+++ b/include/asm-generic/pgtable-nopud.h
@@ -50,6 +50,7 @@ static inline pud_t * pud_offset(pgd_t * pgd,
unsigned long address)
  * allocating and freeing a pud is trivial: the 1-entry pud is
  * inside the pgd, so has no extra memory associated with it.
  */
+#define __pud_alloc_one(mm, address, mask)		NULL
 #define pud_alloc_one(mm, address)		NULL
 #define pud_free(mm, x)				do { } while (0)
 #define __pud_free_tlb(tlb, x, a)		do { } while (0)
