Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753473Ab2FWJSQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Jun 2012 05:18:16 -0400
Received: from zene.cmpxchg.org ([85.214.230.12]:52356 "EHLO zene.cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752407Ab2FWJSP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Jun 2012 05:18:15 -0400
Date: Sat, 23 Jun 2012 11:17:52 +0200
From: Johannes Weiner <hannes@cmpxchg.org>
To: Yinghai Lu <yinghai@kernel.org>
Cc: akpm@linux-foundation.org, torvalds@linux-foundation.org,
        davem@davemloft.net, shangw@linux.vnet.ibm.com, tj@kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [patch 046/181] mm: remove sparsemem allocation details from the
 bootmem allocator
Message-ID: <20120623091752.GK27816@cmpxchg.org>
References: <20120529220636.AAA66A0308@akpm.mtv.corp.google.com>
 <CAE9FiQVEq5j1zoKS31fgfG_3xZSyfqsjdDorDku-Sgj6BTShEg@mail.gmail.com>
 <CAE9FiQXR+3k4QmOJe59xom+JW5JZAP3znRXQwdyqV5LMEPCw2g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAE9FiQXR+3k4QmOJe59xom+JW5JZAP3znRXQwdyqV5LMEPCw2g@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 22, 2012 at 07:05:45PM -0700, Yinghai Lu wrote:
> On Fri, Jun 22, 2012 at 6:11 PM, Yinghai Lu <yinghai@kernel.org> wrote:
> > On Tue, May 29, 2012 at 3:06 PM,  <akpm@linux-foundation.org> wrote:
> >> From: Johannes Weiner <hannes@cmpxchg.org>
> >> Subject: mm: remove sparsemem allocation details from the bootmem allocator
> >>
> >> alloc_bootmem_section() derives allocation area constraints from the
> >> specified sparsemem section.  This is a bit specific for a generic memory
> >> allocator like bootmem, though, so move it over to sparsemem.
> >>
> >> As __alloc_bootmem_node_nopanic() already retries failed allocations with
> >> relaxed area constraints, the fallback code in sparsemem.c can be removed
> >> and the code becomes a bit more compact overall.
> >>
> >> [akpm@linux-foundation.org: fix build]
> >> Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
> >> Acked-by: Tejun Heo <tj@kernel.org>
> >> Acked-by: David S. Miller <davem@davemloft.net>
> >> Cc: Yinghai Lu <yinghai@kernel.org>
> >> Cc: Gavin Shan <shangw@linux.vnet.ibm.com>
> >> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> >
> > hi, this one cause regression, will put usemap to last node's memory
> > instead of each node.
> 
> attached patch fixes the problem.

Sorry for the trouble and thanks for the patch!  The number of bugs in
these three lines is too damn high...

> Subject: [PATCH] mm: fix goal calculating with usemap
> 
> PAGE_SECTION_MASK should be used with pfn instead of pa.
> 
> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
> 
> diff --git a/mm/sparse.c b/mm/sparse.c
> index 6a4bf91..fd00928 100644
> --- a/mm/sparse.c
> +++ b/mm/sparse.c
> @@ -287,7 +287,7 @@ sparse_early_usemaps_alloc_pgdat_section(struct pglist_data *pgdat,
>  	 * from the same section as the pgdat where possible to avoid
>  	 * this problem.
>  	 */
> -	goal = __pa(pgdat) & PAGE_SECTION_MASK;
> +	goal = ((__pa(pgdat) >> PAGE_SHIFT) & PAGE_SECTION_MASK) << PAGE_SHIFT;

How about

	goal = __pa(pgdat) & (PAGE_SECTION_MASK << PAGE_SHIFT);

instead?

>  	host_pgdat = NODE_DATA(early_pfn_to_nid(goal >> PAGE_SHIFT));
>  	return __alloc_bootmem_node_nopanic(host_pgdat, size,
>  					    SMP_CACHE_BYTES, goal);
