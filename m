Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932225Ab1EXNHA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 May 2011 09:07:00 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:43206 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932204Ab1EXNG6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 May 2011 09:06:58 -0400
Date: Tue, 24 May 2011 09:06:35 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Cc: "yinghai@kernel.org" <yinghai@kernel.org>,
        "jeremy@goop.org" <jeremy@goop.org>, "hpa@zytor.com" <hpa@zytor.com>,
        "hpa@linux.intel.com" <hpa@linux.intel.com>,
        Ian Campbell <Ian.Campbell@eu.citrix.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>
Subject: Re: Xen MMU's requirement to pin pages RO and initial_memory_mapping.
Message-ID: <20110524130635.GB10017@dumpdata.com>
References: <20110513153010.GB16519@dumpdata.com>
 <alpine.DEB.2.00.1105131650550.8972@kaball-desktop>
 <20110516154132.GA12486@dumpdata.com>
 <alpine.DEB.2.00.1105171745300.12963@kaball-desktop>
 <20110517180520.GC13706@dumpdata.com>
 <alpine.DEB.2.00.1105231541020.12963@kaball-desktop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1105231541020.12963@kaball-desktop>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A010201.4DDBAD6A.008D:SCFMA922111,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 23, 2011 at 04:20:15PM +0100, Stefano Stabellini wrote:
> On Tue, 17 May 2011, Konrad Rzeszutek Wilk wrote:
> > On Tue, May 17, 2011 at 06:50:55PM +0100, Stefano Stabellini wrote:
> > > On Mon, 16 May 2011, Konrad Rzeszutek Wilk wrote:
> > > > > They become pagetable pages when:
> > > > > 
> > > > > - they are explicitly pinned by pin_pagetable_pfn
> > > > > 
> > > > > - they are hooked into the current pagetable
> > > > 
> > > > Ok, so could we use those two calls to trigger the pagetable walk
> > > > and mark them RO as appropiate? Which call sites are those? The
> > > > xen_set_pgd/xen_set_pud/xen_set_pmd ?
> > > 
> > > xen_alloc_pte_init and xen_alloc_pmd_init are the ones that mark the
> > > pagetable pages RO and pin them, calling make_lowmem_page_readonly and
> > > pin_pagetable_pfn.
> > > 
> > > alloc_pte/pmd are called right before hooking them into the pagetable;
> > > unfortunately that means that they fail at marking the pagetable pages
> > > RO: make_lowmem_page_readonly uses lookup_address to find the pte
> > > corresponding to a page, however at this point the pagetable pages are
> > > not mapped yet (usually they are not hooked but when they are hooked, the
> > > upper level pagetable page is not hooked), so lookup_address fails.
> > 
> > Right. We don't have to walk the hooked pagetable, I think. We are passed
> > in the PMD/PGD of the PFN and we could look at the content of that PFN.
> > Walk each entry in there and for those that are present, determine
> > if the page table it points to (whatever level it is) is RO. If not, mark
> > it RO. And naturally do it recursively to cover all levels.
>  
> I am not sure what you mean.
> The interface is the following:
> 
> void alloc_pte(struct mm_struct *mm, unsigned long pfn);
> 
> pfn is the pagetable page's pfn, that has to be marked RO in all his mappings;
> mm is the mm_struct where this pagetable page is mapped.
> Except it is not true anymore because the pagetable page is not mapped
> yet in mm; so we cannot walk anything here, unfortunately.

I was thinking to "resolve" the pfn, and directly read from the pfn's the
entries. So not walking the mm_struct, but reading the raw data from the 
PFN page... but I that would not do much as alloc_pte is done _before_ that
pagetable is actually populated - so it has nothing in it.


> We could remember that we failed to mark this page RO so that the next
> time we try to write a pte that contains that address we know we have to
> mark it RO.
> But this approach is basically equivalent to the one we had before
> 2.6.39: we consider the range pgt_buf_start-pgt_buf_end a "published"
> range of pagetable pages that we have to mark RO.
> In fact it is affected by the same problem: after writing the ptes that
> map the range pgt_buf_start-pgt_buf_end, if we try to allocate a new
> pagetable page incrementing pgt_buf_end we fail because the new page is
> already marked RW in a pinned page.
> At the same time we cannot modify the pte to change the mapping to RO
> because lookup_address doesn't find it (the pagetable page containing
> the pte in question is not reachable from init_mm yet).

So.. why not do the raw walk of the PFN (and within this
"raw walk" ioremap the PFNs, and do a depth-first walk on the page-tables
do set them to RO) when it is being hooked up to the page-table?
Meaning - whatever trigger point is when we try to set a PUD in a PGD,
or PTE into a PMD. And naturally we can't walk the 'init_mm' as it
has not been hooked up yet (and it cannot as the page-tables have not
been set to RO).

> 
> 
> Unfortunately I cannot see an easy way to fix alloc_pte without making
> sure that the pfn passed as an argument is already mapped and the pte is
> reachable using lookup_address.

Lets ignore that for now.
> 
> Alternatively we could come up with a new interface that properly
> publishes the pgt_buf_start-pgt_buf_top range, but it would still need a
> "free" function for the pgt_buf_end-pgt_buf_top range to be called after
> the initial mapping is complete.

