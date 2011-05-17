Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756120Ab1EQSFo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 May 2011 14:05:44 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:33443 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755920Ab1EQSFn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 May 2011 14:05:43 -0400
Date: Tue, 17 May 2011 14:05:20 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Cc: "yinghai@kernel.org" <yinghai@kernel.org>,
        "jeremy@goop.org" <jeremy@goop.org>, "hpa@zytor.com" <hpa@zytor.com>,
        "hpa@linux.intel.com" <hpa@linux.intel.com>,
        Ian Campbell <Ian.Campbell@eu.citrix.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>
Subject: Re: Xen MMU's requirement to pin pages RO and initial_memory_mapping.
Message-ID: <20110517180520.GC13706@dumpdata.com>
References: <20110513153010.GB16519@dumpdata.com>
 <alpine.DEB.2.00.1105131650550.8972@kaball-desktop>
 <20110516154132.GA12486@dumpdata.com>
 <alpine.DEB.2.00.1105171745300.12963@kaball-desktop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1105171745300.12963@kaball-desktop>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: rtcsinet21.oracle.com [66.248.204.29]
X-CT-RefId: str=0001.0A090206.4DD2B8ED.00E9:SCFSTAT5015188,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 17, 2011 at 06:50:55PM +0100, Stefano Stabellini wrote:
> On Mon, 16 May 2011, Konrad Rzeszutek Wilk wrote:
> > > They become pagetable pages when:
> > > 
> > > - they are explicitly pinned by pin_pagetable_pfn
> > > 
> > > - they are hooked into the current pagetable
> > 
> > Ok, so could we use those two calls to trigger the pagetable walk
> > and mark them RO as appropiate? Which call sites are those? The
> > xen_set_pgd/xen_set_pud/xen_set_pmd ?
> 
> xen_alloc_pte_init and xen_alloc_pmd_init are the ones that mark the
> pagetable pages RO and pin them, calling make_lowmem_page_readonly and
> pin_pagetable_pfn.
> 
> alloc_pte/pmd are called right before hooking them into the pagetable;
> unfortunately that means that they fail at marking the pagetable pages
> RO: make_lowmem_page_readonly uses lookup_address to find the pte
> corresponding to a page, however at this point the pagetable pages are
> not mapped yet (usually they are not hooked but when they are hooked, the
> upper level pagetable page is not hooked), so lookup_address fails.

Right. We don't have to walk the hooked pagetable, I think. We are passed
in the PMD/PGD of the PFN and we could look at the content of that PFN.
Walk each entry in there and for those that are present, determine
if the page table it points to (whatever level it is) is RO. If not, mark
it RO. And naturally do it recursively to cover all levels.

> 
> In order to catch these errors Xen has a parachute: xen_set_pte_init,
> the function that takes care of writing a pte to memory and that on xen
> converts pfns to mfns, also marks pagetable pages RO trying to
> understand when that is appropriate.
> 
> This is all very ugly and delicate.

And complex.
> 
> I think alloc_pte/pmd were always thought to be used to mark and pin
> pagetable pages but they currently fail during the initial pagetable
> setup. If we could fix alloc_pte/pmd most of the problems and the hacks
> would go away.

Yeey!
> Ideally we could remove both mask_rw_pte (currently responsible for
> marking pagetable pages RO, called from xen_set_pte_init) and
> x86_init.mapping.pagetable_reserve.
> 
> More thinking (and caffeine) needed...
> 
> 
> 
> 
> > Presumarily we don't have
> > to do that for the PTE's that are already mapped (as
> > xen_setup_kernel_pagetable, and xen_map_identity_early do this
> > already).
> 
> No, we don't.
> We do need to make sure they stay RO on x86_32 where we write the
> pagetable pages in two steps and we switch pagetable to swapper_pg_dir.

And then vice-versa later on during the bootup.
