Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932639Ab1CRTwf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Mar 2011 15:52:35 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:33620 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932469Ab1CRTw2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Mar 2011 15:52:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=ImnkO+jJREYzIk8phDQ/AF2v4qE8JyiaMea88+h09CDi+ij4hEFTOqrrtQDNszkI2B
         yCFhqHT9Tz4fdDoJ7fg7P7zojBoz1CBbtNi3Xau1zfFOM5qVRbhC05dVjfto0o3e+Khd
         Z4nE8COgnx+4zOskbzz83HrjHhR+UQGbYIQD8=
Date: Fri, 18 Mar 2011 19:53:07 +0000
From: Prasad Joshi <prasadjoshi124@gmail.com>
To: lethal@linux-sh.org, linux-sh@vger.kernel.org,
        linux-kernel@vger.kernel.org, prasadjoshi124@gmail.com,
        mitra@kqinfotech.com
Subject: Re: [RFC][PATCH v3 07/22] mm, sh: add gfp flags variant of pmd and
 pte allocations
Message-ID: <20110318195307.GH4746@prasad-kvm>
References: <20110318194135.GA4746@prasad-kvm>
 <20110318194341.GB4746@prasad-kvm>
 <20110318194600.GC4746@prasad-kvm>
 <20110318194740.GD4746@prasad-kvm>
 <20110318194929.GE4746@prasad-kvm>
 <20110318195035.GF4746@prasad-kvm>
 <20110318195141.GG4746@prasad-kvm>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110318195141.GG4746@prasad-kvm>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


- Added __pte_alloc_one_kernel() function to allow caller to allocation flag.
   Like pte_alloc_one_kernel() this newly added function calls
   quicklist_alloc() and passes the allocation flag down the call hierarchy.

- The function pte_alloc_one_kernel() is modified to call
  __pte_alloc_one_kernel() using the correct allocation flag.

- Similar changes for pmd allocations. Added function __pmd_alloc_one().

- The changes help in fixing the Bug 30702.

Signed-off-by: Prasad Joshi <prasadjoshi124@gmail.com>
Signed-off-by: Anand Mitra <mitra@kqinfotech.com>
---
 arch/sh/include/asm/pgalloc.h |    8 +++++++-
 arch/sh/mm/pgtable.c          |    8 +++++++-
 2 files changed, 14 insertions(+), 2 deletions(-)

diff --git a/arch/sh/include/asm/pgalloc.h b/arch/sh/include/asm/pgalloc.h
index 8c00785..aaed989 100644
--- a/arch/sh/include/asm/pgalloc.h
+++ b/arch/sh/include/asm/pgalloc.h
@@ -31,10 +31,16 @@ static inline void pmd_populate(struct mm_struct *mm, pmd_t *pmd,
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
@@ -45,9 +45,15 @@ void pud_populate(struct mm_struct *mm, pud_t *pud, pmd_t *pmd)
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
-- 
1.7.0.4

