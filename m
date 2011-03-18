Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932366Ab1CRUER (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Mar 2011 16:04:17 -0400
Received: from mail-ww0-f42.google.com ([74.125.82.42]:42156 "EHLO
	mail-ww0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757239Ab1CRUEN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Mar 2011 16:04:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=MUNyXKxW6F6KULfU0IsUVi4EoSSf33FU+r0sCo9+C9ZpKjmhlP0cu/xzxbTtZ27Pgb
         02pJmrrnEyGf8T6yMkRjcI9NewOPOFyOWvzT5KL4Zhfxpl84YlEM8YDMdLF2cCXQ+LKc
         NJnR45qegCKDf2C0B16DiohqBMM4rBJwXXRlQ=
Date: Fri, 18 Mar 2011 20:04:52 +0000
From: Prasad Joshi <prasadjoshi124@gmail.com>
To: takata@linux-m32r.org, linux-m32r@ml.linux-m32r.org,
        linux-m32r-ja@ml.linux-m32r.org, linux-kernel@vger.kernel.org,
        prasadjoshi124@gmail.com, mitra@kqinfotech.com
Subject: Re: [RFC][PATCH v3 16/22] mm, m32r: add gfp flags variant of pmd
 and pte allocations
Message-ID: <20110318200452.GQ4746@prasad-kvm>
References: <20110318195141.GG4746@prasad-kvm>
 <20110318195307.GH4746@prasad-kvm>
 <20110318195507.GI4746@prasad-kvm>
 <20110318195643.GJ4746@prasad-kvm>
 <20110318195754.GK4746@prasad-kvm>
 <20110318195926.GL4746@prasad-kvm>
 <20110318200045.GM4746@prasad-kvm>
 <20110318200150.GN4746@prasad-kvm>
 <20110318200254.GO4746@prasad-kvm>
 <20110318200401.GP4746@prasad-kvm>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110318200401.GP4746@prasad-kvm>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


- Added function __pmd_alloc_one which is same as pmd_alloc_one, but accepts
   an extra argument for gfp_t flag.

- Added function __pte_alloc_one_kernel to allocated zeroed page using
  allocation flag passed as an argument.

- Changed pte_alloc_one_kernel to call __pte_alloc_one_kernel using
  GFP_KERNEL allocation flag.

- Helps in fixing the Bug 30702

Signed-off-by: Prasad Joshi <prasadjoshi124@gmail.com>
Signed-off-by: Anand Mitra <mitra@kqinfotech.com>
---
 arch/m32r/include/asm/pgalloc.h |   11 ++++++++---
 1 files changed, 8 insertions(+), 3 deletions(-)

diff --git a/arch/m32r/include/asm/pgalloc.h b/arch/m32r/include/asm/pgalloc.h
index 0fc7361..0c1e4ae 100644
--- a/arch/m32r/include/asm/pgalloc.h
+++ b/arch/m32r/include/asm/pgalloc.h
@@ -30,12 +30,16 @@ static inline void pgd_free(struct mm_struct *mm, pgd_t *pgd)
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
@@ -66,6 +70,7 @@ static inline void pte_free(struct mm_struct *mm, pgtable_t pte)
  * (In the PAE case we free the pmds as part of the pgd.)
  */
 
+#define __pmd_alloc_one(mm, addr,mask)		({ BUG(); ((pmd_t *)2); })
 #define pmd_alloc_one(mm, addr)		({ BUG(); ((pmd_t *)2); })
 #define pmd_free(mm, x)			do { } while (0)
 #define __pmd_free_tlb(tlb, x, addr)	do { } while (0)
-- 
1.7.0.4

