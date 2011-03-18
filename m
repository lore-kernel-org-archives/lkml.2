Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757482Ab1CRUMT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Mar 2011 16:12:19 -0400
Received: from mail-ww0-f42.google.com ([74.125.82.42]:36172 "EHLO
	mail-ww0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756739Ab1CRUMN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Mar 2011 16:12:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=U3W6PmTnZOA6vDoIOGXWhbtBsjWq5aCMNKEjTb57Mg+QzMhD7dJPDdQ4unUYLei9l6
         aRgcOnigJePN0KE8NE+M9LLt4wxoWI2gvWioO129Y4HG0A4N4jLJKHmxKJIDOU4h8im6
         bCB8HjUK+wcnKl8xJVpFcnCMXh1Ir6oDPL2wI=
Subject: Re: [RFC][PATCH v3 05/22] mm, tile: add gfp flags variant of pmd
 and pte allocations
From: Prasad Joshi <prasadjoshi124@gmail.com>
To: Chris Metcalf <cmetcalf@tilera.com>
Cc: cmetcalf@tilera.com, linux-kernel@vger.kernel.org,
        prasadjoshi124@gmail.com, Anand Mitra <mitra@kqinfotech.com>
In-Reply-To: <4D83B7F2.4000903@tilera.com>
References: <20110318194135.GA4746@prasad-kvm>
	 <20110318194341.GB4746@prasad-kvm> <20110318194600.GC4746@prasad-kvm>
	 <20110318194740.GD4746@prasad-kvm> <20110318194929.GE4746@prasad-kvm>
	 <20110318195035.GF4746@prasad-kvm>  <4D83B7F2.4000903@tilera.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 18 Mar 2011 20:12:52 +0000
Message-ID: <1300479172.32664.33.camel@prasad-kvm>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-03-18 at 15:52 -0400, Chris Metcalf wrote:
> Acked-by: Chris Metcalf <cmetcalf@tilera.com>

Thanks Chris.

Regards,
Prasad

> 
> On 3/18/2011 3:50 PM, Prasad Joshi wrote:
> > - Added function __pte_alloc_one() which is very similar to pte_alloc_one(),
> >   but also accepts an additional gfp_t allocation flag.
> >
> > - The pte_alloc_one() function calls __pte_alloc_one().
> >
> > - Added function __pte_alloc_one_kernel() to accept and then pass the
> >   allocation flag to __pte_alloc_one().
> >
> > - The function pte_alloc_one_kernel() calls __pte_alloc_one_kernel().
> >
> > - Added function __pmd_alloc_one to allocation pmd entries using the
> >   specified allocation flag. It works by passing the allocation flag
> >   to __pte_alloc_one().
> >
> > - changes help in fixing the Bug 30702
> >
> > Signed-off-by: Prasad Joshi <prasadjoshi124@gmail.com>
> > Signed-off-by: Anand Mitra <mitra@kqinfotech.com>
> > ---
> >  arch/tile/include/asm/pgalloc.h |   13 ++++++++++++-
> >  arch/tile/mm/pgtable.c          |   10 ++++++++--
> >  2 files changed, 20 insertions(+), 3 deletions(-)
> >
> > diff --git a/arch/tile/include/asm/pgalloc.h b/arch/tile/include/asm/pgalloc.h
> > index cf52791..2dcad88 100644
> > --- a/arch/tile/include/asm/pgalloc.h
> > +++ b/arch/tile/include/asm/pgalloc.h
> > @@ -69,14 +69,23 @@ extern pgd_t *pgd_alloc(struct mm_struct *mm);
> >  extern void pgd_free(struct mm_struct *mm, pgd_t *pgd);
> >  
> >  extern pgtable_t pte_alloc_one(struct mm_struct *mm, unsigned long address);
> > +extern pgtable_t __pte_alloc_one(struct mm_struct *, unsigned long, gfp_t);
> > +
> >  extern void pte_free(struct mm_struct *mm, struct page *pte);
> >  
> >  #define pmd_pgtable(pmd) pmd_page(pmd)
> >  
> >  static inline pte_t *
> > +__pte_alloc_one_kernel(struct mm_struct *mm, unsigned long address, 
> > +		gfp_t gfp_mask)
> > +{
> > +	return pfn_to_kaddr(page_to_pfn(__pte_alloc_one(mm, address, gfp_mask)));
> > +}
> > +
> > +static inline pte_t *
> >  pte_alloc_one_kernel(struct mm_struct *mm, unsigned long address)
> >  {
> > -	return pfn_to_kaddr(page_to_pfn(pte_alloc_one(mm, address)));
> > +	return __pte_alloc_one_kernel(mm, address, GFP_KERNEL | __GFP_REPEAT);
> >  }
> >  
> >  static inline void pte_free_kernel(struct mm_struct *mm, pte_t *pte)
> > @@ -108,6 +117,8 @@ void shatter_pmd(pmd_t *pmd);
> >  #define L1_USER_PGTABLE_ORDER L2_USER_PGTABLE_ORDER
> >  #define pud_populate(mm, pud, pmd) \
> >    pmd_populate_kernel((mm), (pmd_t *)(pud), (pte_t *)(pmd))
> > +#define __pmd_alloc_one(mm, addr, mask) \
> > +  ((pmd_t *)page_to_virt(__pte_alloc_one((mm), (addr), (mask))))
> >  #define pmd_alloc_one(mm, addr) \
> >    ((pmd_t *)page_to_virt(pte_alloc_one((mm), (addr))))
> >  #define pmd_free(mm, pmdp) \
> > diff --git a/arch/tile/mm/pgtable.c b/arch/tile/mm/pgtable.c
> > index 1f5430c..34ee920 100644
> > --- a/arch/tile/mm/pgtable.c
> > +++ b/arch/tile/mm/pgtable.c
> > @@ -218,9 +218,10 @@ void pgd_free(struct mm_struct *mm, pgd_t *pgd)
> >  
> >  #define L2_USER_PGTABLE_PAGES (1 << L2_USER_PGTABLE_ORDER)
> >  
> > -struct page *pte_alloc_one(struct mm_struct *mm, unsigned long address)
> > +struct page *
> > +__pte_alloc_one(struct mm_struct *mm, unsigned long address, gfp_t gfp_mask)
> >  {
> > -	gfp_t flags = GFP_KERNEL|__GFP_REPEAT|__GFP_ZERO|__GFP_COMP;
> > +	gfp_t flags = gfp_mask | __GFP_ZERO | __GFP_COMP;
> >  	struct page *p;
> >  
> >  #ifdef CONFIG_HIGHPTE
> > @@ -235,6 +236,11 @@ struct page *pte_alloc_one(struct mm_struct *mm, unsigned long address)
> >  	return p;
> >  }
> >  
> > +struct page *pte_alloc_one(struct mm_struct *mm, unsigned long address)
> > +{
> > +	return __pte_alloc_one(mm, address, GFP_KERNEL);
> > +}
> > +
> >  /*
> >   * Free page immediately (used in __pte_alloc if we raced with another
> >   * process).  We have to correct whatever pte_alloc_one() did before
> 


