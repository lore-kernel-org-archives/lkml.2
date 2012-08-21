Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754165Ab2HUPH2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2012 11:07:28 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:44896 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752506Ab2HUPH0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2012 11:07:26 -0400
Date: Tue, 21 Aug 2012 10:57:13 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>
Subject: Re: [Xen-devel] [PATCH 11/11] xen/mmu: Release just the MFN list,
 not MFN list and part of pagetables.
Message-ID: <20120821145713.GG20289@phenom.dumpdata.com>
References: <1345133009-21941-1-git-send-email-konrad.wilk@oracle.com>
 <1345133009-21941-12-git-send-email-konrad.wilk@oracle.com>
 <alpine.DEB.2.02.1208211514130.15568@kaball.uk.xensource.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1208211514130.15568@kaball.uk.xensource.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 21, 2012 at 03:18:26PM +0100, Stefano Stabellini wrote:
> On Thu, 16 Aug 2012, Konrad Rzeszutek Wilk wrote:
> > We call memblock_reserve for [start of mfn list] -> [PMD aligned end
> > of mfn list] instead of <start of mfn list> -> <page aligned end of mfn list].
> > 
> > This has the disastrous effect that if at bootup the end of mfn_list is
> > not PMD aligned we end up returning to memblock parts of the region
> > past the mfn_list array. And those parts are the PTE tables with
> > the disastrous effect of seeing this at bootup:
> 
> This patch looks wrong to me.

Its easier to see if you stick the patch in the code. The size = part
was actually also done earlier.
> 
> Aren't you changing the way mfn_list is reserved using memblock in patch
> #3? Moreover it really seems to me that you are PAGE_ALIGN'ing size
> rather than PMD_ALIGN'ing it there.

Correct. That is proper way of doing it. We want to PMD_ALIGN for the xen_cleanhighmap
to remove the pesky virtual address, but we want PAGE_ALIGN (so exactly the
same way memblock_reserve was called) for memblock_free.
> 
> 
> > Write protecting the kernel read-only data: 10240k
> > Freeing unused kernel memory: 1860k freed
> > Freeing unused kernel memory: 200k freed
> > (XEN) mm.c:2429:d0 Bad type (saw 1400000000000002 != exp 7000000000000000) for mfn 116a80 (pfn 14e26)
> > ...
> > (XEN) mm.c:908:d0 Error getting mfn 116a83 (pfn 14e2a) from L1 entry 8000000116a83067 for l1e_owner=0, pg_owner=0
> > (XEN) mm.c:908:d0 Error getting mfn 4040 (pfn 5555555555555555) from L1 entry 0000000004040601 for l1e_owner=0, pg_owner=0
> > .. and so on.
> >
> > Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
> > ---
> >  arch/x86/xen/mmu.c |    2 +-
> >  1 files changed, 1 insertions(+), 1 deletions(-)
> > 
> > diff --git a/arch/x86/xen/mmu.c b/arch/x86/xen/mmu.c
> > index 5a880b8..6019c22 100644
> > --- a/arch/x86/xen/mmu.c
> > +++ b/arch/x86/xen/mmu.c
> > @@ -1227,7 +1227,6 @@ static void __init xen_pagetable_setup_done(pgd_t *base)
> >  			/* We should be in __ka space. */
> >  			BUG_ON(xen_start_info->mfn_list < __START_KERNEL_map);
> >  			addr = xen_start_info->mfn_list;
> > -			size = PAGE_ALIGN(xen_start_info->nr_pages * sizeof(unsigned long));
> >  			/* We roundup to the PMD, which means that if anybody at this stage is
> >  			 * using the __ka address of xen_start_info or xen_start_info->shared_info
> >  			 * they are in going to crash. Fortunatly we have already revectored
> > @@ -1235,6 +1234,7 @@ static void __init xen_pagetable_setup_done(pgd_t *base)
> >  			size = roundup(size, PMD_SIZE);
> >  			xen_cleanhighmap(addr, addr + size);
> >  
> > +			size = PAGE_ALIGN(xen_start_info->nr_pages * sizeof(unsigned long));
> >  			memblock_free(__pa(xen_start_info->mfn_list), size);
> >  			/* And revector! Bye bye old array */
> >  			xen_start_info->mfn_list = new_mfn_list;
> > -- 
> > 1.7.7.6
> > 
> > 
> > _______________________________________________
> > Xen-devel mailing list
> > Xen-devel@lists.xen.org
> > http://lists.xen.org/xen-devel
> > 
