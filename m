Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752321Ab2G0RmN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jul 2012 13:42:13 -0400
Received: from andromeda.dapyr.net ([206.212.254.10]:52494 "EHLO
	andromeda.dapyr.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751962Ab2G0RmM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jul 2012 13:42:12 -0400
X-Greylist: delayed 415 seconds by postgrey-1.27 at vger.kernel.org; Fri, 27 Jul 2012 13:42:12 EDT
Date: Fri, 27 Jul 2012 13:35:18 -0400
From: Konrad Rzeszutek Wilk <konrad@darnok.org>
To: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [Xen-devel] [PATCH 3/7] xen/mmu: Release the Xen provided L4 (PGD) back.
Message-ID: <20120727173518.GC17427@andromeda.dapyr.net>
References: <1343335652-5659-1-git-send-email-konrad.wilk@oracle.com> <1343335652-5659-4-git-send-email-konrad.wilk@oracle.com> <alpine.DEB.2.02.1207271231560.26163@kaball.uk.xensource.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1207271231560.26163@kaball.uk.xensource.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 27, 2012 at 12:37:24PM +0100, Stefano Stabellini wrote:
> On Thu, 26 Jul 2012, Konrad Rzeszutek Wilk wrote:
> > Since we are not using it and somebody else could use it.
> 
> make sense except it is almost entirely rewritten by the following
> patch...

Yeah, I should squash them.
> 
> > Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
> > ---
> >  arch/x86/xen/mmu.c |   13 +++++++------
> >  1 files changed, 7 insertions(+), 6 deletions(-)
> > 
> > diff --git a/arch/x86/xen/mmu.c b/arch/x86/xen/mmu.c
> > index a59070b..48bdc9f 100644
> > --- a/arch/x86/xen/mmu.c
> > +++ b/arch/x86/xen/mmu.c
> > @@ -1782,20 +1782,21 @@ void __init xen_setup_kernel_pagetable(pgd_t *pgd, unsigned long max_pfn)
> >  	/* Unpin Xen-provided one */
> >  	pin_pagetable_pfn(MMUEXT_UNPIN_TABLE, PFN_DOWN(__pa(pgd)));
> >  
> > -	/* Switch over */
> > -	pgd = init_level4_pgt;
> > -
> >  	/*
> >  	 * At this stage there can be no user pgd, and no page
> >  	 * structure to attach it to, so make sure we just set kernel
> >  	 * pgd.
> >  	 */
> >  	xen_mc_batch();
> > -	__xen_write_cr3(true, __pa(pgd));
> > +	__xen_write_cr3(true, __pa(init_level4_pgt));
> >  	xen_mc_issue(PARAVIRT_LAZY_CPU);
> >  
> > -	memblock_reserve(__pa(xen_start_info->pt_base),
> > -			 xen_start_info->nr_pt_frames * PAGE_SIZE);
> > +	/* Offset by one page since the original pgd is going bye bye */
> > +	memblock_reserve(__pa(xen_start_info->pt_base + PAGE_SIZE),
> > +			 (xen_start_info->nr_pt_frames * PAGE_SIZE) - PAGE_SIZE);
> > +	/* and also RW it so it can actually be used. */
> > +	set_page_prot(pgd, PAGE_KERNEL);
> > +	clear_page(pgd);
> >  }
> >  #else	/* !CONFIG_X86_64 */
> >  static RESERVE_BRK_ARRAY(pmd_t, initial_kernel_pmd, PTRS_PER_PMD);
> > -- 
> > 1.7.7.6
> > 
> > 
> > _______________________________________________
> > Xen-devel mailing list
> > Xen-devel@lists.xen.org
> > http://lists.xen.org/xen-devel
> > 
> 
> _______________________________________________
> Xen-devel mailing list
> Xen-devel@lists.xen.org
> http://lists.xen.org/xen-devel
