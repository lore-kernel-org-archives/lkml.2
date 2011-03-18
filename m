Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932573Ab1CRTpa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Mar 2011 15:45:30 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:63868 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757036Ab1CRTpW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Mar 2011 15:45:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=tlWAk0X6z1TOcntSku3l5atyzOAOMpqSgXmd3USWxPBesm1l10/IC7jF81KKaD2QzM
         q6MUxXMJiOS9X0H0bedCwajZ8aHT9Qr7TFqlczuQPu94izxAK17+tI2CkptC8xVbLbGX
         KmTOMSyRQlfQYelprchLB40Vaaus290AwGCOA=
Date: Fri, 18 Mar 2011 19:46:00 +0000
From: Prasad Joshi <prasadjoshi124@gmail.com>
To: chris@zankel.net, linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        linux-arch@vger.kernel.org, prasadjoshi124@gmail.com,
        mitra@kqinfotech.com
Subject: Re: [RFC][PATCH v3 02/22] mm, xtensa: add gfp flags variant of pte
 allocations
Message-ID: <20110318194600.GC4746@prasad-kvm>
References: <20110318194135.GA4746@prasad-kvm>
 <20110318194341.GB4746@prasad-kvm>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110318194341.GB4746@prasad-kvm>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


- Added __pte_alloc_one_kernel() function which is similar to
  pte_alloc_one_kernel(), but accepts an additional argument to allow caller
  to specify the allocation flag. The function pte_alloc_one_kernel() is
  changed to call __pte_alloc_one_kernel().

- changes help in fixing the Bug 30702

Signed-off-by: Prasad Joshi <prasadjoshi124@gmail.com>
Signed-off-by: Anand Mitra <mitra@kqinfotech.com>
---
 arch/xtensa/include/asm/pgalloc.h |    9 ++++++++-
 arch/xtensa/mm/pgtable.c          |   11 +++++++++--
 2 files changed, 17 insertions(+), 3 deletions(-)

diff --git a/arch/xtensa/include/asm/pgalloc.h b/arch/xtensa/include/asm/pgalloc.h
index 40cf9bc..d5a23ae 100644
--- a/arch/xtensa/include/asm/pgalloc.h
+++ b/arch/xtensa/include/asm/pgalloc.h
@@ -42,10 +42,17 @@ static inline void pgd_free(struct mm_struct *mm, pgd_t *pgd)
 
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
@@ -35,6 +37,11 @@ pte_t* pte_alloc_one_kernel(struct mm_struct *mm, unsigned long address)
 	return pte;
 }
 
+pte_t* pte_alloc_one_kernel(struct mm_struct *mm, unsigned long address)
+{
+	return __pte_alloc_one_kernel(mm, address, GFP_KERNEL | __GFP_REPEAT);
+}
+
 #ifdef PROFILING
 
 int mask;
-- 
1.7.0.4

