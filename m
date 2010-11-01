Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754168Ab0KAOfa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Nov 2010 10:35:30 -0400
Received: from 8bytes.org ([88.198.83.132]:40104 "EHLO 8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752701Ab0KAOf2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Nov 2010 10:35:28 -0400
Date: Mon, 1 Nov 2010 15:35:26 +0100
From: Joerg Roedel <joro@8bytes.org>
To: Jan Kiszka <jan.kiszka@web.de>
Cc: "Roedel, Joerg" <Joerg.Roedel@amd.com>, kvm <kvm@vger.kernel.org>,
        Sheng Yang <sheng@linux.intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Crash on kvm_iommu_map_pages
Message-ID: <20101101143526.GD2987@8bytes.org>
References: <4CCEB7CF.8030207@web.de> <4CCEB946.7070103@web.de> <20101101132127.GF20959@amd.com> <4CCEBFAC.1000809@web.de> <20101101135322.GG20959@amd.com> <4CCECD17.3080303@web.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4CCECD17.3080303@web.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 01, 2010 at 03:22:15PM +0100, Jan Kiszka wrote:
> Am 01.11.2010 14:53, Roedel, Joerg wrote:
> > On Mon, Nov 01, 2010 at 09:25:00AM -0400, Jan Kiszka wrote:
> >> Am 01.11.2010 14:21, Roedel, Joerg wrote:
> >>> The registers rax and rbx contain non-canonical addresses (if
> >>> interpreted as pointers). The instruction where this happens is a mov so
> >>> I guess that the #GP is because of an non-canonical address.
> >>> Can you find out the code-line where this happens and the exact
> >>> assembler instruction? (haven't managed to decode the registers used).
> >>
> >> In pfn_to_dma_pte, line 710:
> >>
> >>                 if (!dma_pte_present(pte)) {
> >> ffffffff8121de8c:       f6 03 03                testb  $0x3,(%rbx)
> >> ffffffff8121de8f:       0f 85 d8 00 00 00       jne    ffffffff8121df6d <pfn_to_dma_pte+0x154>
> >>
> >> The first instruction raises the fault.
> > 
> > Ok, so it seems that my understanding of the Code: field in the
> > crash-message was wrong :)
> > Anyway, the testb uses rbx as an address which has a non-canonical
> > value. This means the the address of 'pte' is invalid. Since rax also
> > contains a wrong address the 'parent' variable probably already contains
> > the wrong address. Does the attached patch help?
> > 
> > diff --git a/include/linux/dma_remapping.h b/include/linux/dma_remapping.h
> > index 5619f85..ca46f24 100644
> > --- a/include/linux/dma_remapping.h
> > +++ b/include/linux/dma_remapping.h
> > @@ -6,7 +6,7 @@
> >   */
> >  #define VTD_PAGE_SHIFT		(12)
> >  #define VTD_PAGE_SIZE		(1UL << VTD_PAGE_SHIFT)
> > -#define VTD_PAGE_MASK		(((u64)-1) << VTD_PAGE_SHIFT)
> > +#define VTD_PAGE_MASK		((((u64)-1) << VTD_PAGE_SHIFT) & ((1ULL << 52) - 1))
> >  #define VTD_PAGE_ALIGN(addr)	(((addr) + VTD_PAGE_SIZE - 1) & VTD_PAGE_MASK)
> >  
> >  #define DMA_PTE_READ (1)
> > 
> 
> Crashes during early boot while initializing dmar. If you need the
> trace, I could set up some debug console.

Hmm, no. This was only a guess. The VTD_PAGE_MASK does not mask out the
bits 52-63 of the pte. According to the VT-d spec it is allowed to set
these bits, some are marked as AVL and some have special meanings. If a
pte has one of these bits set the phys_addr calculated will be wrong and
the virt_addr calculated from it too (probably non-canonical, leading to
the GPF). 

Probably masking out these bits in dma_pte_addr helps. 

	Joerg

