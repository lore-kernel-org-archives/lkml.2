Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757462Ab1CRUIt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Mar 2011 16:08:49 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:62609 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756953Ab1CRUIn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Mar 2011 16:08:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=L4VjkcKO7XJD0YcBYwo4XTAufldct7GOHzuyC/Lpj5eiM+3zigwOE85nbDnBgO1iRw
         DirP6uHKN5Ijv2Gucz6d33ANpnNsgVUx4NrXg8KrOiBPONjPiIPJm7YK5RzYwlrSQHyf
         mJTZBeVC73O0lh9PCrIDhq0ceBLu/0qT60sC8=
Date: Fri, 18 Mar 2011 20:09:22 +0000
From: Prasad Joshi <prasadjoshi124@gmail.com>
To: linux@arm.linux.org.uk, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, prasadjoshi124@gmail.com,
        mitra@kqinfotech.com
Subject: Re: [RFC][PATCH v3 21/22] mm, arm: add gfp flags variant of pmd
 and pte allocations
Message-ID: <20110318200922.GV4746@prasad-kvm>
References: <20110318195926.GL4746@prasad-kvm>
 <20110318200045.GM4746@prasad-kvm>
 <20110318200150.GN4746@prasad-kvm>
 <20110318200254.GO4746@prasad-kvm>
 <20110318200401.GP4746@prasad-kvm>
 <20110318200452.GQ4746@prasad-kvm>
 <20110318200547.GR4746@prasad-kvm>
 <20110318200638.GS4746@prasad-kvm>
 <20110318200731.GT4746@prasad-kvm>
 <20110318200825.GU4746@prasad-kvm>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110318200825.GU4746@prasad-kvm>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


 - Added __pmd_alloc_one, which is same as pmd_alloc_one, but has extra parameter to specify the allocation flag
 - Added __pte_alloc_one_kernel to allocate page using specified GFP flag
 - Changed pte_alloc_one_kernel to call __pte_alloc_one_kernel newly added function using GFP_KERNEL allocation flag
 - Helps in fixing the Bug 30702

Signed-off-by: Prasad Joshi <prasadjoshi124@gmail.com>
Signed-off-by: Anand Mitra <mitra@kqinfotech.com>
---
 arch/arm/include/asm/pgalloc.h |   11 +++++++++--
 1 files changed, 9 insertions(+), 2 deletions(-)

diff --git a/arch/arm/include/asm/pgalloc.h b/arch/arm/include/asm/pgalloc.h
index 22de005..0696068 100644
--- a/arch/arm/include/asm/pgalloc.h
+++ b/arch/arm/include/asm/pgalloc.h
@@ -28,6 +28,7 @@
 /*
  * Since we have only two-level page tables, these are trivial
  */
+#define __pmd_alloc_one(mm,addr,mask)	({ BUG(); ((pmd_t *)2); })
 #define pmd_alloc_one(mm,addr)		({ BUG(); ((pmd_t *)2); })
 #define pmd_free(mm, pmd)		do { } while (0)
 #define pgd_populate(mm,pmd,pte)	BUG()
@@ -59,17 +60,23 @@ static inline void clean_pte_table(pte_t *pte)
  *  +------------+
  */
 static inline pte_t *
-pte_alloc_one_kernel(struct mm_struct *mm, unsigned long addr)
+__pte_alloc_one_kernel(struct mm_struct *mm, unsigned long addr, gfp_t gfp_mask)
 {
 	pte_t *pte;
 
-	pte = (pte_t *)__get_free_page(PGALLOC_GFP);
+	pte = (pte_t *)__get_free_page(gfp_mask | __GFP_NOTRACK | __GFP_ZERO);
 	if (pte)
 		clean_pte_table(pte);
 
 	return pte;
 }
 
+static inline pte_t *
+pte_alloc_one_kernel(struct mm_struct *mm, unsigned long addr)
+{
+	return __pte_alloc_one_kernel(mm, addr, GFP_KERNEL | __GFP_REPEAT);
+}
+
 static inline pgtable_t
 pte_alloc_one(struct mm_struct *mm, unsigned long addr)
 {
-- 
1.7.0.4

