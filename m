Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752546Ab2G0RmY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jul 2012 13:42:24 -0400
Received: from andromeda.dapyr.net ([206.212.254.10]:52500 "EHLO
	andromeda.dapyr.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752214Ab2G0RmW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jul 2012 13:42:22 -0400
Date: Fri, 27 Jul 2012 13:42:14 -0400
From: Konrad Rzeszutek Wilk <konrad@darnok.org>
To: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [Xen-devel] [PATCH 7/7] xen/mmu: Remove from __ka space PMD entries for pagetables.
Message-ID: <20120727174214.GE17427@andromeda.dapyr.net>
References: <1343335652-5659-1-git-send-email-konrad.wilk@oracle.com> <1343335652-5659-8-git-send-email-konrad.wilk@oracle.com> <alpine.DEB.2.02.1207271230150.26163@kaball.uk.xensource.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1207271230150.26163@kaball.uk.xensource.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 27, 2012 at 12:31:17PM +0100, Stefano Stabellini wrote:
> On Thu, 26 Jul 2012, Konrad Rzeszutek Wilk wrote:
> > Please first read the description in "xen/mmu: Copy and revector the
> > P2M tree."
> > 
> > At this stage, the __ka address space (which is what the old
> > P2M tree was using) is partially disassembled. The cleanup_highmap
> > has removed the PMD entries from 0-16MB and anything past _brk_end
> > up to the max_pfn_mapped (which is the end of the ramdisk).
> > 
> > The xen_remove_p2m_tree and code around has ripped out the __ka for
> > the old P2M array.
> > 
> > Here we continue on doing it to where the Xen page-tables were.
> > It is safe to do it, as the page-tables are addressed using __va.
> > For good measure we delete anything that is within MODULES_VADDR
> > and up to the end of the PMD.
> > 
> > At this point the __ka only contains PMD entries for the start
> > of the kernel up to __brk.
> > 
> > Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
> > ---
> >  arch/x86/xen/mmu.c |   20 ++++++++++++++++++++
> >  1 files changed, 20 insertions(+), 0 deletions(-)
> > 
> > diff --git a/arch/x86/xen/mmu.c b/arch/x86/xen/mmu.c
> > index 05e8492..738feca 100644
> > --- a/arch/x86/xen/mmu.c
> > +++ b/arch/x86/xen/mmu.c
> > @@ -1241,6 +1241,26 @@ static void __init xen_pagetable_setup_done(pgd_t *base)
> >  			xen_start_info->mfn_list = new_mfn_list;
> >  		}
> >  	}
> > +#ifdef CONFIG_X86_64
> > +	/* At this stage, cleanup_highmap has already cleaned __ka space
> > +	 * from _brk_limit way up to the max_pfn_mapped (which is the end of
> > +	 * the ramdisk). We continue on, erasing PMD entries that point to page
> > +	 * tables - do note that they are accessible at this stage via __va.
> > +	 * For good measure we also round up to the PMD - which means that if
> > +	 * anybody is using __ka address to the initial boot-stack - and try
> > +	 * to use it - they are going to crash. The xen_start_info has been
> > +	 * taken care of already in xen_setup_kernel_pagetable. */
> > +	addr = xen_start_info->pt_base;
> > +	size = roundup(xen_start_info->nr_pt_frames * PAGE_SIZE, PMD_SIZE);
> > +
> > +	xen_cleanhighmap(addr, addr + size);
> > +	xen_start_info->pt_base = (unsigned long)__va(__pa(xen_start_info->pt_base));
> > +
> > +	/* This is superflous and shouldn't be neccessary, but you know what
> > +	 * lets do it. The MODULES_VADDR -> MODULES_END should be clear of
> > +	 * anything at this stage. */
> > +	xen_cleanhighmap(MODULES_VADDR, roundup(MODULES_VADDR, PUD_SIZE) - 1);
> 
> I would stick an #ifdef CONFIG_DEBUG of some kind around it

I am not really sure why, but we seem to have PMDs filed after the Xen
pagetables. I thought it was the bootstack, but it just looked like we
were filling up to the next PMD (so the 'roundup' right above this code
should take care of that). But let me double check that - to reproduce
this module loading problem I hacked the hypervisor to create a huge P2M
array and I might have not seen this issue when I was doing a proper bootup
of a PV guest with 220GB.
