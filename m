Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756990Ab1EKQKF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 May 2011 12:10:05 -0400
Received: from service88.mimecast.com ([195.130.217.12]:36762 "HELO
	service88.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1757094Ab1EKQKD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 May 2011 12:10:03 -0400
X-Greylist: delayed 445 seconds by postgrey-1.27 at vger.kernel.org; Wed, 11 May 2011 12:10:02 EDT
Subject: Re: [PATCH 20/19] ARM: LPAE: Invalidate the TLB before freeing the
 PMD
From: Catalin Marinas <catalin.marinas@arm.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
In-Reply-To: <20110511105419.GD5315@n2100.arm.linux.org.uk>
References: <1304859098-10760-1-git-send-email-catalin.marinas@arm.com>
	 <1305109399-13156-1-git-send-email-catalin.marinas@arm.com>
	 <20110511105419.GD5315@n2100.arm.linux.org.uk>
Organization: ARM Limited
Date: Wed, 11 May 2011 14:40:49 +0100
Message-ID: <1305121249.10103.45.camel@e102109-lin.cambridge.arm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1
X-OriginalArrivalTime: 11 May 2011 13:40:54.0657 (UTC) FILETIME=[0CF87710:01CC0FE1]
X-MC-Unique: 111051114405801401
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-05-11 at 11:54 +0100, Russell King - ARM Linux wrote:
> On Wed, May 11, 2011 at 11:23:19AM +0100, Catalin Marinas wrote:
> > +static inline void __pmd_free_tlb(struct mmu_gather *tlb, pmd_t *pmdp,
> > +                               unsigned long addr)
> > +{
> > +#ifdef CONFIG_ARM_LPAE
> > +     tlb_add_flush(tlb, addr);
> > +     tlb_flush(tlb);
> > +     pmd_free((tlb)->mm, pmdp);
> > +#endif
> > +}
> 
> You're:
> 
> 1. tlb_add_flush() - Adding the address which covers the PMD to the range
>    of virtual addresses which need flushing - ok.
> 2. tlb_flush() - You're then forcing a flush.
> 3. pmd_free() - You're now freeing the page.
> 
> One of the points about the shootdown interface is that it batches things
> up.  So what's wrong with:
> 
> static inline void __pmd_free_tlb(struct mmu_gather *tlb, pmd_t *pmdp,
>         unsigned long addr)
> {
> #ifdef CONFIG_ARM_LPAE
>         tlb_add_flush(tlb, addr);
>         tlb_remove_page(tlb, virt_to_page(pmdp));
> #endif
> }
> 
> and leave the tlb invalidate and actual page freeing to the batching code
> to deal with?

There isn't a big overhead with my initial code as a pmd covers 1GB and
we only have 1 or 2 pmds per process that we can free.

Is there any room for optimising the mmu_gather range? I think this only
matters for case 1 in your tlb_flush() comment - unmapping a page range
with a few pages in one pmd and a few other pages in the next pmd we get
over 1GB range when we actually only need to flush the TLB for a few
pages.

If tlb_add_flush would get a start/end range (or addr/size), we know
that any TLB flush within the start..end range would be enough and thus
we avoid artificially increasing the range.

We could also modify flush_tlb_range() to branch to flush_tlb_mm() for
big ranges.

-- 
Catalin


