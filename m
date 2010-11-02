Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757006Ab0KBH5X (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Nov 2010 03:57:23 -0400
Received: from mga01.intel.com ([192.55.52.88]:15377 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756988Ab0KBH5S (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Nov 2010 03:57:18 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.58,279,1286175600"; 
   d="scan'208";a="853258569"
From: Sheng Yang <sheng@linux.intel.com>
Organization: Intel Opensource Technology Center
To: Jan Kiszka <jan.kiszka@web.de>
Subject: Re: [PATCH] intel-iommu: Fix use after release during device attach
Date: Tue, 2 Nov 2010 15:57:23 +0800
User-Agent: KMail/1.13.5 (Linux/2.6.35-22-generic; KDE/4.5.1; x86_64; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        kvm <kvm@vger.kernel.org>, Avi Kivity <avi@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        iommu@lists.linux-foundation.org,
        David Woodhouse <dwmw2@infradead.org>
References: <4CCFB84F.6050102@web.de> <201011021531.22886.sheng@linux.intel.com> <4CCFC1C3.4070807@web.de>
In-Reply-To: <4CCFC1C3.4070807@web.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201011021557.24057.sheng@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 02 November 2010 15:46:11 Jan Kiszka wrote:
> Am 02.11.2010 08:31, Sheng Yang wrote:
> > On Tuesday 02 November 2010 15:05:51 Jan Kiszka wrote:
> >> From: Jan Kiszka <jan.kiszka@siemens.com>
> >> 
> >> Obtail the new pgd pointer before releasing the page containing this
> >> value.
> >> 
> >> Signed-off-by: Jan Kiszka <jan.kiszka@siemens.com>
> >> ---
> >> 
> >> Who is taking care of this? The kvm tree?
> >> 
> >>  drivers/pci/intel-iommu.c |    2 +-
> >>  1 files changed, 1 insertions(+), 1 deletions(-)
> >> 
> >> diff --git a/drivers/pci/intel-iommu.c b/drivers/pci/intel-iommu.c
> >> index 4789f8e..35463dd 100644
> >> --- a/drivers/pci/intel-iommu.c
> >> +++ b/drivers/pci/intel-iommu.c
> >> @@ -3627,9 +3627,9 @@ static int intel_iommu_attach_device(struct
> >> iommu_domain *domain,
> >> 
> >>  		pte = dmar_domain->pgd;
> >>  		if (dma_pte_present(pte)) {
> >> 
> >> -			free_pgtable_page(dmar_domain->pgd);
> >> 
> >>  			dmar_domain->pgd = (struct dma_pte *)
> >>  			
> >>  				phys_to_virt(dma_pte_addr(pte));
> >> 
> >> +			free_pgtable_page(pte);
> >> 
> >>  		}
> >>  		dmar_domain->agaw--;
> >>  	
> >>  	}
> > 
> > Reviewed-by: Sheng Yang <sheng@linux.intel.com>
> > 
> > CC iommu mailing list and David.
> > 
> > OK, Jan, I got your meaning now. And it's not the exactly swap. :)
> > 
> > I think the old code is safe, seems it's broken(exposed) by:
> > 
> > commit 1a8bd481bfba30515b54368d90a915db3faf302f
> > Author: David Woodhouse <David.Woodhouse@intel.com>
> > Date:   Tue Aug 10 01:38:53 2010 +0100
> > 
> >     intel-iommu: Fix 32-bit build warning with __cmpxchg()
> >     
> >     drivers/pci/intel-iommu.c: In function 'dma_pte_addr':
> >     drivers/pci/intel-iommu.c:239: warning: passing argument 1 of
> >     '__cmpxchg64'
> > 
> > from incompatible pointer typ
> > 
> >     It seems that __cmpxchg64() now cares about the type of its pointer
> >     argument, so give it a (uint64_t *) instead of a pointer to a
> >     structure which contains only that.
> >     
> >     Signed-off-by: David Woodhouse <David.Woodhouse@intel.com>
> > 
> > diff --git a/drivers/pci/intel-iommu.c b/drivers/pci/intel-iommu.c
> > index c9171be..603cdc0 100644
> > --- a/drivers/pci/intel-iommu.c
> > +++ b/drivers/pci/intel-iommu.c
> > @@ -236,7 +236,7 @@ static inline u64 dma_pte_addr(struct dma_pte *pte)
> > 
> >         return pte->val & VTD_PAGE_MASK;
> >  
> >  #else
> >  
> >         /* Must have a full atomic 64-bit read */
> > 
> > -       return  __cmpxchg64(pte, 0ULL, 0ULL) & VTD_PAGE_MASK;
> > +       return  __cmpxchg64(&pte->val, 0ULL, 0ULL) & VTD_PAGE_MASK;
> > 
> >  #endif
> >  }
> > 
> > Seems here is the only affected code?
> 
> CONFIG_64BIT is on here, so this change did not make a difference for me.

Oh...

Then it would due to most VT-d machine wouldn't run into while (iommu->agaw < 
dmar_domain->agaw). 

We have routing test for VT-d devices assignment, but seems we don't use this kind 
of VT-d machine for testing.

--
regards
Yang, Sheng


> 
> Jan
