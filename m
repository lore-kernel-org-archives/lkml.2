Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757617Ab1EKQ2e (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 May 2011 12:28:34 -0400
Received: from service88.mimecast.com ([195.130.217.12]:38451 "HELO
	service88.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1757553Ab1EKQ2b convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 May 2011 12:28:31 -0400
Subject: Re: [PATCH 20/19] ARM: LPAE: Invalidate the TLB before freeing the
 PMD
From: Catalin Marinas <catalin.marinas@arm.com>
To: Sergei Shtylyov <sshtylyov@mvista.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Russell King - ARM Linux <linux@arm.linux.org.uk>
In-Reply-To: <4DCA6593.80403@ru.mvista.com>
References: <1304859098-10760-1-git-send-email-catalin.marinas@arm.com>
	 <1305109399-13156-1-git-send-email-catalin.marinas@arm.com>
	 <4DCA6593.80403@ru.mvista.com>
Organization: ARM Limited
Date: Wed, 11 May 2011 11:40:45 +0100
Message-ID: <1305110445.10103.22.camel@e102109-lin.cambridge.arm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1
X-OriginalArrivalTime: 11 May 2011 10:40:51.0681 (UTC) FILETIME=[E5E52510:01CC0FC7]
X-MC-Unique: 111051111405302401
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-05-11 at 11:31 +0100, Sergei Shtylyov wrote:
> > Similar to the PTE freeing, this patch introduced __pmd_free_tlb() which
> > invalidates the TLB before freeing a PMD page. This is needed because on
> > newer processors the entry in the upper page table may be cached by the
> > TLB and point to random data after the PMD has been freed.
> 
> > Signed-off-by: Catalin Marinas<catalin.marinas@arm.com>
> > ---
> 
> > This patch should be part of the LPAE series but I haven't included it in the
> > latest series post.
> 
> >   arch/arm/include/asm/tlb.h |   12 +++++++++++-
> >   1 files changed, 11 insertions(+), 1 deletions(-)
> 
> > diff --git a/arch/arm/include/asm/tlb.h b/arch/arm/include/asm/tlb.h
> > index f9f6ecd..ef72f19 100644
> > --- a/arch/arm/include/asm/tlb.h
> > +++ b/arch/arm/include/asm/tlb.h
> > @@ -181,8 +181,18 @@ static inline void __pte_free_tlb(struct mmu_gather *tlb, pgtable_t pte,
> >       tlb_remove_page(tlb, pte);
> >   }
> >
> > +static inline void __pmd_free_tlb(struct mmu_gather *tlb, pmd_t *pmdp,
> > +                               unsigned long addr)
> > +{
> > +#ifdef CONFIG_ARM_LPAE
> > +     tlb_add_flush(tlb, addr);
> > +     tlb_flush(tlb);
> > +     pmd_free((tlb)->mm, pmdp);
> 
>     This is not a macro, so parens around 'tlb' are not needed.

True, just copy/paste error.
> 
> > +#endif
> > +}
> > +
> 
>     Perhaps a better style would be (as SubmittingPatches suggest):
> 
> +#ifdef CONFIG_ARM_LPAE
> +static inline void __pmd_free_tlb(struct mmu_gather *tlb, pmd_t *pmdp,
> +                                 unsigned long addr)
> +{
> +       tlb_add_flush(tlb, addr);
> +       tlb_flush(tlb);
> +       pmd_free(tlb->mm, pmdp);
> +}
> +#else
> +static inline void __pmd_free_tlb(struct mmu_gather *tlb, pmd_t *pmdp,
> +                                 unsigned long addr) {}
> +#endif
> +
> 
> WBR, Sergei

No real preference here though smaller number of lines changed in my
initial patch.

Thanks.

-- 
Catalin


