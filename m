Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754129Ab1CUTFa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Mar 2011 15:05:30 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:35729 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753967Ab1CUTF1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Mar 2011 15:05:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=o39bwxCjE291j5RIYoBLuKQfH4Udd3gbEKnP370kPEV7ifJxzIB9dR+EM6MKmfPPYs
         ehrUsv+nUxhHzGO9PLGa4ugwz8wWY11tmd3K+l+Gy9jdB2TjU2WRYykyNFy05sBGigEj
         QZg8yhW7qk08uxhxB7CHn7n218dOt1FOmhp6A=
Date: Mon, 21 Mar 2011 19:05:20 +0000
From: Prasad Joshi <prasadjoshi124@gmail.com>
To: David Rientjes <rientjes@google.com>
Cc: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, x86@kernel.org,
        linux-kernel@vger.kernel.org, mitra@kqinfotech.com,
        prasadjoshi124@gmail.com
Subject: Re: [RFC][PATCH v3 03/22] mm, x86: add gfp flags variant of pud,
 pmd, and pte allocations
Message-ID: <20110321190520.GB6541@prasad-kvm>
References: <20110318194135.GA4746@prasad-kvm>
 <20110318194341.GB4746@prasad-kvm>
 <20110318194600.GC4746@prasad-kvm>
 <20110318194740.GD4746@prasad-kvm>
 <alpine.DEB.2.00.1103181514340.30968@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1103181514340.30968@chino.kir.corp.google.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 18, 2011 at 03:17:42PM -0700, David Rientjes wrote:
> On Fri, 18 Mar 2011, Prasad Joshi wrote:
> 
> 
> There should be no break between the function type and its name.
> 
> 
> PGALLOC_GFP represents the gfp flags intended for the allocators in this 
> file, there's no need to replace its use with GFP_KERNEL | __GFP_REPEAT, 
> we don't care that __pte_alloc_one_kernel() ORs this with __GFP_NOTRACK 
> and __GFP_ZERO.
> 
> >  }

Thanks a lot David for your reply. Sending a new patch with the changes suggested by you.

- Added __pud_alloc_one() function which is similar to pud_alloc_one(), but
  accepts an additional argument of type gfp_t. The function pud_alloc_one()
  calls __pud_alloc_one().

- similar changes for pmd allocations. The newly added function name is__pmd_alloc_one.

- Similar changes for pte allocation. Added function __pte_alloc_one_kernel.

- changes help in fixing the Bug 30702

Signed-off-by: Prasad Joshi <prasadjoshi124@gmail.com>
Signed-off-by: Anand Mitra <mitra@kqinfotech.com>
---
 arch/x86/include/asm/pgalloc.h |   17 +++++++++++++++--
 arch/x86/mm/pgtable.c          |    8 +++++++-
 2 files changed, 22 insertions(+), 3 deletions(-)

diff --git a/arch/x86/include/asm/pgalloc.h b/arch/x86/include/asm/pgalloc.h
index b4389a4..7278096 100644
--- a/arch/x86/include/asm/pgalloc.h
+++ b/arch/x86/include/asm/pgalloc.h
@@ -34,6 +34,7 @@ extern pgd_t *pgd_alloc(struct mm_struct *);
 extern void pgd_free(struct mm_struct *mm, pgd_t *pgd);
 
 extern pte_t *pte_alloc_one_kernel(struct mm_struct *, unsigned long);
+extern pte_t *__pte_alloc_one_kernel(struct mm_struct *, unsigned long, gfp_t);
 extern pgtable_t pte_alloc_one(struct mm_struct *, unsigned long);
 
 /* Should really implement gc for free page table pages. This could be
@@ -78,9 +79,15 @@ static inline void pmd_populate(struct mm_struct *mm, pmd_t *pmd,
 #define pmd_pgtable(pmd) pmd_page(pmd)
 
 #if PAGETABLE_LEVELS > 2
+static inline pmd_t *__pmd_alloc_one(struct mm_struct *mm, unsigned long addr,
+		gfp_t gfp_mask)
+{
+	return (pmd_t *)get_zeroed_page(gfp_mask);
+}
+
 static inline pmd_t *pmd_alloc_one(struct mm_struct *mm, unsigned long addr)
 {
-	return (pmd_t *)get_zeroed_page(GFP_KERNEL|__GFP_REPEAT);
+	return __pmd_alloc_one(mm, addr, GFP_KERNEL | __GFP_REPEAT);
 }
 
 static inline void pmd_free(struct mm_struct *mm, pmd_t *pmd)
@@ -114,9 +121,15 @@ static inline void pgd_populate(struct mm_struct *mm, pgd_t *pgd, pud_t *pud)
 	set_pgd(pgd, __pgd(_PAGE_TABLE | __pa(pud)));
 }
 
+static inline pud_t *__pud_alloc_one(struct mm_struct *mm, unsigned long addr,
+		gfp_t gfp_mask)
+{
+	return (pud_t *)get_zeroed_page(gfp_mask);
+}
+
 static inline pud_t *pud_alloc_one(struct mm_struct *mm, unsigned long addr)
 {
-	return (pud_t *)get_zeroed_page(GFP_KERNEL|__GFP_REPEAT);
+	return __pud_alloc_one(mm, addr, GFP_KERNEL | __GFP_REPEAT);
 }
 
 static inline void pud_free(struct mm_struct *mm, pud_t *pud)
diff --git a/arch/x86/mm/pgtable.c b/arch/x86/mm/pgtable.c
index 8573b83..f1b0de7 100644
--- a/arch/x86/mm/pgtable.c
+++ b/arch/x86/mm/pgtable.c
@@ -15,9 +15,15 @@
 
 gfp_t __userpte_alloc_gfp = PGALLOC_GFP | PGALLOC_USER_GFP;
 
+pte_t * __pte_alloc_one_kernel(struct mm_struct *mm, unsigned long address,
+		gfp_t gfp_mask)
+{
+	return (pte_t *)__get_free_page(gfp_mask);
+}
+
 pte_t *pte_alloc_one_kernel(struct mm_struct *mm, unsigned long address)
 {
-	return (pte_t *)__get_free_page(PGALLOC_GFP);
+	return __pte_alloc_one_kernel(mm, address, PGALLOC_GFP);
 }
 
 pgtable_t pte_alloc_one(struct mm_struct *mm, unsigned long address)
-- 
1.7.0.4
