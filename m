Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757152Ab1EXQVo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 May 2011 12:21:44 -0400
Received: from smtp.eu.citrix.com ([62.200.22.115]:39592 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751566Ab1EXQVn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 May 2011 12:21:43 -0400
X-IronPort-AV: E=Sophos;i="4.65,261,1304294400"; 
   d="scan'208";a="5924357"
Date: Tue, 24 May 2011 17:24:04 +0100
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball-desktop
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>,
        "yinghai@kernel.org" <yinghai@kernel.org>,
        "jeremy@goop.org" <jeremy@goop.org>, "hpa@zytor.com" <hpa@zytor.com>,
        "hpa@linux.intel.com" <hpa@linux.intel.com>,
        Ian Campbell <Ian.Campbell@eu.citrix.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>
Subject: Re: Xen MMU's requirement to pin pages RO and
 initial_memory_mapping.
In-Reply-To: <20110524130635.GB10017@dumpdata.com>
Message-ID: <alpine.DEB.2.00.1105241510110.12963@kaball-desktop>
References: <20110513153010.GB16519@dumpdata.com> <alpine.DEB.2.00.1105131650550.8972@kaball-desktop> <20110516154132.GA12486@dumpdata.com> <alpine.DEB.2.00.1105171745300.12963@kaball-desktop> <20110517180520.GC13706@dumpdata.com>
 <alpine.DEB.2.00.1105231541020.12963@kaball-desktop> <20110524130635.GB10017@dumpdata.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 24 May 2011, Konrad Rzeszutek Wilk wrote:
> > > Right. We don't have to walk the hooked pagetable, I think. We are passed
> > > in the PMD/PGD of the PFN and we could look at the content of that PFN.
> > > Walk each entry in there and for those that are present, determine
> > > if the page table it points to (whatever level it is) is RO. If not, mark
> > > it RO. And naturally do it recursively to cover all levels.
> >  
> > I am not sure what you mean.
> > The interface is the following:
> > 
> > void alloc_pte(struct mm_struct *mm, unsigned long pfn);
> > 
> > pfn is the pagetable page's pfn, that has to be marked RO in all his mappings;
> > mm is the mm_struct where this pagetable page is mapped.
> > Except it is not true anymore because the pagetable page is not mapped
> > yet in mm; so we cannot walk anything here, unfortunately.
> 
> I was thinking to "resolve" the pfn, and directly read from the pfn's the
> entries. So not walking the mm_struct, but reading the raw data from the 
> PFN page... but I that would not do much as alloc_pte is done _before_ that
> pagetable is actually populated - so it has nothing in it.
> 
> 
> > We could remember that we failed to mark this page RO so that the next
> > time we try to write a pte that contains that address we know we have to
> > mark it RO.
> > But this approach is basically equivalent to the one we had before
> > 2.6.39: we consider the range pgt_buf_start-pgt_buf_end a "published"
> > range of pagetable pages that we have to mark RO.
> > In fact it is affected by the same problem: after writing the ptes that
> > map the range pgt_buf_start-pgt_buf_end, if we try to allocate a new
> > pagetable page incrementing pgt_buf_end we fail because the new page is
> > already marked RW in a pinned page.
> > At the same time we cannot modify the pte to change the mapping to RO
> > because lookup_address doesn't find it (the pagetable page containing
> > the pte in question is not reachable from init_mm yet).
> 
> So.. why not do the raw walk of the PFN (and within this
> "raw walk" ioremap the PFNs, and do a depth-first walk on the page-tables
> do set them to RO) when it is being hooked up to the page-table?
> Meaning - whatever trigger point is when we try to set a PUD in a PGD,
> or PTE into a PMD. And naturally we can't walk the 'init_mm' as it
> has not been hooked up yet (and it cannot as the page-tables have not
> been set to RO).


We cannot use the pvop call when we hook the pagetable page into the
upper level because it is right after the alloc_pte call and we still
cannot find its mappings through lookup_address. Keep in mind that it is
the pagetable page mapping that we have to set read-only, not the
content of the pagetable page.
The pagetable page mapping might be written before or after the
pagetable page is being hooked into the pagetable.
BTW I have to say that all the alloc_pte calls are currently wrong
because the struct mm that we are passing is meaningless.


On the other hand if you are suggesting to use the pvop call when we
write pte entries, that is set_pte (xen_set_pte_init), get the pfn from
the pte, figure out if it is a pagetable page, and if it is mark it
read-only, that is exactly what we are already doing.


Unfortunately it has a number of issues:

- once the pte entries are written they cannot easily be changed because
they still cannot be found using lookup_address. This means that once
the pte entries for range pgt_buf_start-pgt_buf_end have been written,
we cannot allocate any new pagetable pages, because we don't have a way
to mark them read-only anymore. This is the issue that brought us to the
introduction of x86_init.mapping.pagetable_reserve.

- we need to distinguish between normal mappings and temporary
mappings; among the temporary mappings we need to distinguish between new
pagetable pages that are not hooked into the pagetable yet and
pagetable already hooked into the pagetable. It is not easy and it is
error prone.



I think the approach of catching a pte write and trying to understand
what the pfn exactly is has proven to be too fragile.
We need a simple proper interface, like alloc_pte was supposed to be,
otherwise it will keep breaking.



At the moment I can only see two possible ways of solving this:

1) Have a way to find the pte that maps a pagetable page when the
pagetable page is hooked into the pagetable.
Unfortunately I fail to see a way to do it, given the current way of
allocating the pagetable pages. Maybe somebody with a deeper knowlegde
of kernel_physical_mapping_init could suggest a way.

2) Have a simple way to know if a pfn is a pagetable page.
If we had a function like pfn_is_pagetable_page(unsigned long pfn) we
could remove the hacks we have in xen_set_pte and mark read-only
the entry whenever needed. This implies that we need a way to know all
the pfn's of the pagetable pages in advance.

