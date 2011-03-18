Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757383Ab1CRUCW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Mar 2011 16:02:22 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:57319 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753937Ab1CRUCP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Mar 2011 16:02:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=lM8UFxrjLxrNAWMehyrUhMN0vIfh4Gz7S4DUH/mVkPofGIoij3C4G4eKjNDkzmrQRC
         aXpnkCl6HDQik7O2O6eOqEM8p7Fr0R2SVSvT8GDNZsMKbAGKx9y0KaSMGnBjuFN3mlX3
         wL1aMpASu9USL2ci1xdKPTfe1HBvgmX3bB88Y=
Date: Fri, 18 Mar 2011 20:02:55 +0000
From: Prasad Joshi <prasadjoshi124@gmail.com>
To: monstr@monstr.eu, microblaze-uclinux@itee.uq.edu.au,
        linux-kernel@vger.kernel.org, prasadjoshi124@gmail.com,
        mitra@kqinfotech.com
Subject: Re: [RFC][PATCH v3 14/22] mm, microblaze: add gfp flags variant of
 pmd and pte allocations
Message-ID: <20110318200254.GO4746@prasad-kvm>
References: <20110318194929.GE4746@prasad-kvm>
 <20110318195035.GF4746@prasad-kvm>
 <20110318195141.GG4746@prasad-kvm>
 <20110318195307.GH4746@prasad-kvm>
 <20110318195507.GI4746@prasad-kvm>
 <20110318195643.GJ4746@prasad-kvm>
 <20110318195754.GK4746@prasad-kvm>
 <20110318195926.GL4746@prasad-kvm>
 <20110318200045.GM4746@prasad-kvm>
 <20110318200150.GN4746@prasad-kvm>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110318200150.GN4746@prasad-kvm>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


- Added function __pmd_alloc_one which is same as pmd_alloc_one, but accepts
   an extra argument for gfp_t flag.

- Added __pte_alloc_one_kernel() to allocated zeroed page using
  allocation flag passed as an argument. If the slab allocator is not
  initialized the allocation flag is not passed down the call hierarchy.
  i.e. early_get_page() is not modified.

- pte_alloc_one_kernel calls __pte_alloc_one_kernel using
  GFP_KERNEL | __GFP_REPEAT allocation flag.

- Helps in fixing the Bug 30702

Signed-off-by: Prasad Joshi <prasadjoshi124@gmail.com>
Signed-off-by: Anand Mitra <mitra@kqinfotech.com>
---
 arch/microblaze/include/asm/pgalloc.h |    3 +++
 arch/microblaze/mm/pgtable.c          |   13 +++++++++----
 2 files changed, 12 insertions(+), 4 deletions(-)

diff --git a/arch/microblaze/include/asm/pgalloc.h b/arch/microblaze/include/asm/pgalloc.h
index ebd3579..07864a1 100644
--- a/arch/microblaze/include/asm/pgalloc.h
+++ b/arch/microblaze/include/asm/pgalloc.h
@@ -106,9 +106,11 @@ extern inline void free_pgd_slow(pgd_t *pgd)
  * the pgd will always be present..
  */
 #define pmd_alloc_one_fast(mm, address)	({ BUG(); ((pmd_t *)1); })
+#define __pmd_alloc_one(mm, address, mask)	({ BUG(); ((pmd_t *)2); })
 #define pmd_alloc_one(mm, address)	({ BUG(); ((pmd_t *)2); })
 
 extern pte_t *pte_alloc_one_kernel(struct mm_struct *mm, unsigned long addr);
+extern pte_t *__pte_alloc_one_kernel(struct mm_struct *, unsigned long, gfp_t);
 
 static inline struct page *pte_alloc_one(struct mm_struct *mm,
 		unsigned long address)
@@ -175,6 +177,7 @@ extern inline void pte_free(struct mm_struct *mm, struct page *ptepage)
  * We don't have any real pmd's, and this code never triggers because
  * the pgd will always be present..
  */
+#define __pmd_alloc_one(mm, address, mask)	({ BUG(); ((pmd_t *)2); })
 #define pmd_alloc_one(mm, address)	({ BUG(); ((pmd_t *)2); })
 #define pmd_free(mm, x)			do { } while (0)
 #define __pmd_free_tlb(tlb, x, addr)	pmd_free((tlb)->mm, x)
diff --git a/arch/microblaze/mm/pgtable.c b/arch/microblaze/mm/pgtable.c
index 59bf233..ae4d315 100644
--- a/arch/microblaze/mm/pgtable.c
+++ b/arch/microblaze/mm/pgtable.c
@@ -240,13 +240,12 @@ unsigned long iopa(unsigned long addr)
 	return pa;
 }
 
-__init_refok pte_t *pte_alloc_one_kernel(struct mm_struct *mm,
-		unsigned long address)
+__init_refok pte_t *__pte_alloc_one_kernel(struct mm_struct *mm,
+		unsigned long address, gfp_t gfp_mask)
 {
 	pte_t *pte;
 	if (mem_init_done) {
-		pte = (pte_t *)__get_free_page(GFP_KERNEL |
-					__GFP_REPEAT | __GFP_ZERO);
+		pte = (pte_t *)__get_free_page(gfp_mask | __GFP_ZERO);
 	} else {
 		pte = (pte_t *)early_get_page();
 		if (pte)
@@ -254,3 +253,9 @@ __init_refok pte_t *pte_alloc_one_kernel(struct mm_struct *mm,
 	}
 	return pte;
 }
+
+__init_refok pte_t *pte_alloc_one_kernel(struct mm_struct *mm,
+		unsigned long address)
+{
+	return __pte_alloc_one_kernel(mm, address, GFP_KERNEL | __GFP_REPEAT);
+}
-- 
1.7.0.4

