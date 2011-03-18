Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757160Ab1CRTz2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Mar 2011 15:55:28 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:34049 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756675Ab1CRTzV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Mar 2011 15:55:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=smKKZ7TylQ4keCPkVYM/CWv/sbkikjfvN0f8rzv81vjWxkGYmIPVbxFGK5SNlJRrBX
         xrKLnLkzM7AmGNaon4BJjOX6d0JS+UphxXKjyL8GKSkX2vblT0E5L6XqLJCJ15N2mDTN
         zh20meupGxgVS4ZqwEUFPRp97FSec3k7bq6jk=
Date: Fri, 18 Mar 2011 19:55:07 +0000
From: Prasad Joshi <prasadjoshi124@gmail.com>
To: liqin.chen@sunplusct.com, lennox.wu@gmail.com,
        linux-kernel@vger.kernel.org, prasadjoshi124@gmail.com,
        mitra@kqinfotech.com
Subject: Re: [RFC][PATCH v3 08/22] mm, score: add gfp flags variant of pte
 allocations
Message-ID: <20110318195507.GI4746@prasad-kvm>
References: <20110318194135.GA4746@prasad-kvm>
 <20110318194341.GB4746@prasad-kvm>
 <20110318194600.GC4746@prasad-kvm>
 <20110318194740.GD4746@prasad-kvm>
 <20110318194929.GE4746@prasad-kvm>
 <20110318195035.GF4746@prasad-kvm>
 <20110318195141.GG4746@prasad-kvm>
 <20110318195307.GH4746@prasad-kvm>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110318195307.GH4746@prasad-kvm>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


- Added __pte_alloc_one_kernel() function to allocate zeroed pages using
   passed allocation flag. The function pte_alloc_one_kernel() is changed to
   call __pte_alloc_one_kernel() passing GFP_KERNEL | __GFP_REPEAT allocation
   flags.

- Helps in fixing the Bug 30702

Signed-off-by: Prasad Joshi <prasadjoshi124@gmail.com>
Signed-off-by: Anand Mitra <mitra@kqinfotech.com>
---
 arch/score/include/asm/pgalloc.h |   13 +++++++------
 1 files changed, 7 insertions(+), 6 deletions(-)

diff --git a/arch/score/include/asm/pgalloc.h b/arch/score/include/asm/pgalloc.h
index 059a61b..1a0a3a5 100644
--- a/arch/score/include/asm/pgalloc.h
+++ b/arch/score/include/asm/pgalloc.h
@@ -37,15 +37,16 @@ static inline void pgd_free(struct mm_struct *mm, pgd_t *pgd)
 	free_pages((unsigned long)pgd, PGD_ORDER);
 }
 
+static inline pte_t *
+__pte_alloc_one_kernel(struct mm_struct *mm, unsigned long address, gfp_t gfp_mask)
+{
+	return (pte_t *) __get_free_pages(gfp_mask | __GFP_ZERO, PTE_ORDER);
+}
+
 static inline pte_t *pte_alloc_one_kernel(struct mm_struct *mm,
 	unsigned long address)
 {
-	pte_t *pte;
-
-	pte = (pte_t *) __get_free_pages(GFP_KERNEL|__GFP_REPEAT|__GFP_ZERO,
-					PTE_ORDER);
-
-	return pte;
+	return __pte_alloc_one_kernel(mm, address, GFP_KERNEL | __GFP_REPEAT);
 }
 
 static inline struct page *pte_alloc_one(struct mm_struct *mm,
-- 
1.7.0.4

