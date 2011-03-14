Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753112Ab1CNR1d (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Mar 2011 13:27:33 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:63467 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751606Ab1CNR1b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Mar 2011 13:27:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=v/Bw9JmRgqKtaHX6nmch5fdK7MPbbENSLRkABWGw+ApVOphZGpggGMeNCxqn7BEP4m
         2juZjxFRrAB6dEQ6SRZL0SuX9S+BXvvEyQsYCdWScI2smIHqRIqxxr7eUDQzr99C1F3+
         HbwPW5/ZGOlQdGsnSrFMkZHQ5pPzdcufhg+xQ=
MIME-Version: 1.0
Date: Mon, 14 Mar 2011 17:27:10 +0000
Message-ID: <AANLkTik3qn-RVUTZp5+gTk+wB9SO_MsxySHEwE8Yzi-e@mail.gmail.com>
Subject: [RFC][PATCH v2 00/23] (alpha) __vmalloc: add gfp flags variant of pte
 and pmd allocation
From: Prasad Joshi <prasadjoshi124@gmail.com>
To: Richard Henderson <rth@twiddle.net>,
        Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
        Matt Turner <mattst88@gmail.com>, linux-alpha@vger.kernel.org,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
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
arch/alpha/include/asm/pgalloc.h |   18 ++++++++++++++----
1 files changed, 14 insertions(+), 4 deletions(-)
---
diff --git a/arch/alpha/include/asm/pgalloc.h b/arch/alpha/include/asm/pgalloc.h
index bc2a0da..d05dfc2 100644
--- a/arch/alpha/include/asm/pgalloc.h
+++ b/arch/alpha/include/asm/pgalloc.h
@@ -38,10 +38,15 @@ pgd_free(struct mm_struct *mm, pgd_t *pgd)
 }

 static inline pmd_t *
+__pmd_alloc_one(struct mm_struct *mm, unsigned long address, gfp_t gfp_mask)
+{
+	return (pmd_t *)__get_free_page(gfp_mask | __GFP_ZERO);
+}
+
+static inline pmd_t *
 pmd_alloc_one(struct mm_struct *mm, unsigned long address)
 {
-	pmd_t *ret = (pmd_t *)__get_free_page(GFP_KERNEL|__GFP_REPEAT|__GFP_ZERO);
-	return ret;
+	return __pmd_alloc_one(mm, address, GFP_KERNEL | __GFP_REPEAT);
 }

 static inline void
@@ -51,10 +56,15 @@ pmd_free(struct mm_struct *mm, pmd_t *pmd)
 }

 static inline pte_t *
+__pte_alloc_one_kernel(struct mm_struct *mm, unsigned long addressi,
gfp_t gfp_mask)
+{
+	return (pte_t *)__get_free_page(gfp_mask | __GFP_ZERO);
+}
+
+static inline pte_t *
 pte_alloc_one_kernel(struct mm_struct *mm, unsigned long address)
 {
-	pte_t *pte = (pte_t *)__get_free_page(GFP_KERNEL|__GFP_REPEAT|__GFP_ZERO);
-	return pte;
+	return __pte_alloc_one_kernel(mm, address, GFP_KERNEL | __GFP_REPEAT);
 }

 static inline void
