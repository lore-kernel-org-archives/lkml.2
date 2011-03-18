Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932216Ab1CRUBS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Mar 2011 16:01:18 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:35539 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757150Ab1CRUBL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Mar 2011 16:01:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=ZNLKMOStu2D/3hmO6uiTKokKiv3HJRA+Wh0zfmScYLIASjujYAy+muxhqhgUeUVkUS
         vpaAuxgZxZeb2SLp5Q8qz+StsJbZWhFLRbhPXJ/e+3YFYgm8hEVEnTL/SDANLAkst1og
         xHsKqhgURrhwcMJpK9d8s/Gea0DODAbDGhlTs=
Date: Fri, 18 Mar 2011 20:01:50 +0000
From: Prasad Joshi <prasadjoshi124@gmail.com>
To: ralf@linux-mips.org, linux-mips@linux-mips.org,
        linux-kernel@vger.kernel.org, prasadjoshi124@gmail.com,
        mitra@kqinfotech.com
Subject: Re: [RFC][PATCH v3 13/22] mm, mips: add gfp flags variant of pmd
 and pte allocations
Message-ID: <20110318200150.GN4746@prasad-kvm>
References: <20110318194740.GD4746@prasad-kvm>
 <20110318194929.GE4746@prasad-kvm>
 <20110318195035.GF4746@prasad-kvm>
 <20110318195141.GG4746@prasad-kvm>
 <20110318195307.GH4746@prasad-kvm>
 <20110318195507.GI4746@prasad-kvm>
 <20110318195643.GJ4746@prasad-kvm>
 <20110318195754.GK4746@prasad-kvm>
 <20110318195926.GL4746@prasad-kvm>
 <20110318200045.GM4746@prasad-kvm>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110318200045.GM4746@prasad-kvm>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


- Added __pmd_alloc_one to allocate pages using the given allocation flag.

- Changed pmd_alloc_one to call __pmd_alloc_one and pass
  GFP_KERNEL | __GFP_REPEAT allocation flag.

- Added __pte_alloc_one_kernel to allocate zeroed pages using the given
  allocation flag. The function pte_alloc_one_kernel() has been changed to
  call __pte_alloc_one_kernel() passing GFP_KERNEL | __GFP_REPEAT
  allocation flags.

- Helps in fixing the Bug 30702

Signed-off-by: Prasad Joshi <prasadjoshi124@gmail.com>
Signed-off-by: Anand Mitra <mitra@kqinfotech.com>
---
 arch/mips/include/asm/pgalloc.h |   22 +++++++++++++++-------
 1 files changed, 15 insertions(+), 7 deletions(-)

diff --git a/arch/mips/include/asm/pgalloc.h b/arch/mips/include/asm/pgalloc.h
index 881d18b..f2c5439 100644
--- a/arch/mips/include/asm/pgalloc.h
+++ b/arch/mips/include/asm/pgalloc.h
@@ -64,14 +64,16 @@ static inline void pgd_free(struct mm_struct *mm, pgd_t *pgd)
 	free_pages((unsigned long)pgd, PGD_ORDER);
 }
 
+static inline pte_t *__pte_alloc_one_kernel(struct mm_struct *mm,
+	unsigned long address, gfp_t gfp_mask)
+{
+	return (pte_t *) __get_free_pages(gfp_mask | __GFP_ZERO, PTE_ORDER);
+}
+
 static inline pte_t *pte_alloc_one_kernel(struct mm_struct *mm,
 	unsigned long address)
 {
-	pte_t *pte;
-
-	pte = (pte_t *) __get_free_pages(GFP_KERNEL|__GFP_REPEAT|__GFP_ZERO, PTE_ORDER);
-
-	return pte;
+	return __pte_alloc_one_kernel(mm, address, GFP_KERNEL | __GFP_REPEAT);
 }
 
 static inline struct page *pte_alloc_one(struct mm_struct *mm,
@@ -106,16 +108,22 @@ do {							\
 
 #ifndef __PAGETABLE_PMD_FOLDED
 
-static inline pmd_t *pmd_alloc_one(struct mm_struct *mm, unsigned long address)
+static inline pmd_t *
+__pmd_alloc_one(struct mm_struct *mm, unsigned long address, gfp_t gfp_mask)
 {
 	pmd_t *pmd;
 
-	pmd = (pmd_t *) __get_free_pages(GFP_KERNEL|__GFP_REPEAT, PMD_ORDER);
+	pmd = (pmd_t *) __get_free_pages(gfp_mask, PMD_ORDER);
 	if (pmd)
 		pmd_init((unsigned long)pmd, (unsigned long)invalid_pte_table);
 	return pmd;
 }
 
+static inline pmd_t *pmd_alloc_one(struct mm_struct *mm, unsigned long address)
+{
+	return __pmd_alloc_one(mm, address, GFP_KERNEL | __GFP_REPEAT);
+}
+
 static inline void pmd_free(struct mm_struct *mm, pmd_t *pmd)
 {
 	free_pages((unsigned long)pmd, PMD_ORDER);
-- 
1.7.0.4

