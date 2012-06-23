Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756249Ab2FWWGj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Jun 2012 18:06:39 -0400
Received: from zene.cmpxchg.org ([85.214.230.12]:52590 "EHLO zene.cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755871Ab2FWWGh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Jun 2012 18:06:37 -0400
Date: Sun, 24 Jun 2012 00:06:17 +0200
From: Johannes Weiner <hannes@cmpxchg.org>
To: Yinghai Lu <yinghai@kernel.org>
Cc: akpm@linux-foundation.org, torvalds@linux-foundation.org,
        davem@davemloft.net, shangw@linux.vnet.ibm.com, tj@kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [patch 046/181] mm: remove sparsemem allocation details from the
 bootmem allocator
Message-ID: <20120623220616.GS27816@cmpxchg.org>
References: <20120529220636.AAA66A0308@akpm.mtv.corp.google.com>
 <CAE9FiQVEq5j1zoKS31fgfG_3xZSyfqsjdDorDku-Sgj6BTShEg@mail.gmail.com>
 <CAE9FiQXR+3k4QmOJe59xom+JW5JZAP3znRXQwdyqV5LMEPCw2g@mail.gmail.com>
 <20120623091752.GK27816@cmpxchg.org>
 <CAE9FiQXYG0=XFAzZStExBTNqdnRPMSjASNydM45GC_G6qfuNkA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAE9FiQXYG0=XFAzZStExBTNqdnRPMSjASNydM45GC_G6qfuNkA@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 23, 2012 at 11:58:02AM -0700, Yinghai Lu wrote:
> On Sat, Jun 23, 2012 at 2:17 AM, Johannes Weiner <hannes@cmpxchg.org> wrote:
> > On Fri, Jun 22, 2012 at 07:05:45PM -0700, Yinghai Lu wrote:
> >> On Fri, Jun 22, 2012 at 6:11 PM, Yinghai Lu <yinghai@kernel.org> wrote:
> >> > On Tue, May 29, 2012 at 3:06 PM,  <akpm@linux-foundation.org> wrote:
> >> >> From: Johannes Weiner <hannes@cmpxchg.org>
> >> >> Subject: mm: remove sparsemem allocation details from the bootmem allocator
> >> >>
> >> >> alloc_bootmem_section() derives allocation area constraints from the
> >> >> specified sparsemem section.  This is a bit specific for a generic memory
> >> >> allocator like bootmem, though, so move it over to sparsemem.
> >> >>
> >> >> As __alloc_bootmem_node_nopanic() already retries failed allocations with
> >> >> relaxed area constraints, the fallback code in sparsemem.c can be removed
> >> >> and the code becomes a bit more compact overall.
> >> >>
> >> >> [akpm@linux-foundation.org: fix build]
> >> >> Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
> >> >> Acked-by: Tejun Heo <tj@kernel.org>
> >> >> Acked-by: David S. Miller <davem@davemloft.net>
> >> >> Cc: Yinghai Lu <yinghai@kernel.org>
> >> >> Cc: Gavin Shan <shangw@linux.vnet.ibm.com>
> >> >> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> >> >
> >> > hi, this one cause regression, will put usemap to last node's memory
> >> > instead of each node.
> >>
> >> attached patch fixes the problem.
> >
> > Sorry for the trouble and thanks for the patch!  The number of bugs in
> > these three lines is too damn high...
> >
> yeah, i should run Andrew -mm early.
> 
> Andrew, Do you have git tree for your -mm?
> So I could merge it to my local tree.
> now i only have tip, pci, scsi, net, driver-core, usb, tty in my local tree.

(Parts of) -mm are included in linux-next.  I have a tree that is
automated raw -mm imports, including debugging stuff Andrew never
pushes upstream, you can find it here:

http://git.cmpxchg.org/?p=linux-mmotm.git;a=summary

git://git.cmpxchg.org/linux-mmotm.git

> >>        */
> >> -     goal = __pa(pgdat) & PAGE_SECTION_MASK;
> >> +     goal = ((__pa(pgdat) >> PAGE_SHIFT) & PAGE_SECTION_MASK) << PAGE_SHIFT;
> >
> > How about
> >
> >        goal = __pa(pgdat) & (PAGE_SECTION_MASK << PAGE_SHIFT);
> >
> > instead?
> 
> yeah.
> 
> After closely looking, looks like we need to revert the commit or
> apply -v2 patch.
> 
> old sequence is : try same section range at first.
> this commit will try [start_of_section, end_of_same_node_range], so
> could have chance to get

...yes? :)

> Subject: [PATCH] mm: fix goal calculating with usemap
> 
> PAGE_SECTION_MASK should be used with pfn instead of pa.
> 
> Also restore the old behavoir:
> 	limit the allocating to same section at first.
> 	need to expose __alloc_bootmem_node_nopanic with limit.
> 
> -v2: add limit of same section
> 
> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
> 
> ---
>  include/linux/bootmem.h |    5 +++++
>  mm/bootmem.c            |    2 +-
>  mm/nobootmem.c          |    2 +-
>  mm/sparse.c             |   22 ++++++++++++++++------
>  4 files changed, 23 insertions(+), 8 deletions(-)
> 
> Index: linux-2.6/mm/sparse.c
> ===================================================================
> --- linux-2.6.orig/mm/sparse.c
> +++ linux-2.6/mm/sparse.c
> @@ -275,8 +275,9 @@ static unsigned long * __init
>  sparse_early_usemaps_alloc_pgdat_section(struct pglist_data *pgdat,
>  					 unsigned long size)
>  {
> -	pg_data_t *host_pgdat;
> -	unsigned long goal;
> +	unsigned long goal, limit;
> +	unsigned long *p;
> +	int nid;
>  	/*
>  	 * A page may contain usemaps for other sections preventing the
>  	 * page being freed and making a section unremovable while
> @@ -287,10 +288,19 @@ sparse_early_usemaps_alloc_pgdat_section
>  	 * from the same section as the pgdat where possible to avoid
>  	 * this problem.
>  	 */
> -	goal = __pa(pgdat) & PAGE_SECTION_MASK;
> -	host_pgdat = NODE_DATA(early_pfn_to_nid(goal >> PAGE_SHIFT));
> -	return __alloc_bootmem_node_nopanic(host_pgdat, size,
> -					    SMP_CACHE_BYTES, goal);
> +	goal = __pa(pgdat) & (PAGE_SECTION_MASK << PAGE_SHIFT);
> +	limit = goal + (1UL << PA_SECTION_SHIFT);
> +	nid = early_pfn_to_nid(goal >> PAGE_SHIFT);
> +
> +again:
> +	p = ___alloc_bootmem_node_nopanic(NODE_DATA(nid), size,
> +					  SMP_CACHE_BYTES, goal, limit);
> +	if (!p && limit) {
> +		limit = 0;
> +		goto again;
> +	}

I was aware that __alloc_bootmem_node_nopanic does a slightly
different fallback sequence, but as soon as you go outside the
section, you have a node-section-dependency either way.

Without this patch, it would retry without the node first, then
without the goal.  With your patch, you would try to limit the upper
end, but you may already go below the requested section.  What would
the limit gain?
