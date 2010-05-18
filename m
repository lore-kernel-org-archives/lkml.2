Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753567Ab0ERCT3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 May 2010 22:19:29 -0400
Received: from mga03.intel.com ([143.182.124.21]:19830 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752113Ab0ERCT2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 May 2010 22:19:28 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.53,251,1272870000"; 
   d="scan'208";a="278246806"
Date: Tue, 18 May 2010 10:19:23 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Christoph Lameter <cl@linux.com>
Cc: Haicheng Li <haicheng.li@linux.intel.com>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Andi Kleen <andi@firstfloor.org>, Mel Gorman <mel@csn.ul.ie>,
       Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 3/3] mem-hotplug: fix potential race while building
 zonelist for new populated zone
Message-ID: <20100518021923.GA6595@localhost>
References: <4BF0FC4C.4060306@linux.intel.com>
 <alpine.DEB.2.00.1005171108070.20764@router.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1005171108070.20764@router.home>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 18, 2010 at 12:09:31AM +0800, Christoph Lameter wrote:
> On Mon, 17 May 2010, Haicheng Li wrote:
> 
> > diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> > index 72c1211..0729a82 100644
> > --- a/mm/page_alloc.c
> > +++ b/mm/page_alloc.c
> > @@ -2783,6 +2783,20 @@ static __init_refok int __build_all_zonelists(void
> > *data)
> >  {
> >  	int nid;
> >  	int cpu;
> > +#ifdef CONFIG_MEMORY_HOTPLUG
> > +	struct zone_online_info *new = (struct zone_online_info *)data;
> > +
> > +	/*
> > +	 * Populate the new zone before build zonelists, which could
> > +	 * happen only when onlining a new node after system is booted.
> > +	 */
> > +	if (new) {
> > +		/* We are expecting a new memory block here. */
> > +		WARN_ON(!new->onlined_pages);
> > +		new->zone->present_pages += new->onlined_pages;
> > +		new->zone->zone_pgdat->node_present_pages +=
> > new->onlined_pages;
> > +	}
> > +#endif
> 
> 
> Building a zonelist now has the potential side effect of changes to the
> size of the zone?

Yeah, this sounds a bit hacky.

> Can we have a global mutex that protects against size modification of
> zonelists instead? And it could also serialize the pageset setup?

Good suggestion. We could make zone_pageset_mutex a global mutex and
take it in all the functions that call build_all_zonelists() --
currently only online_pages() and numa_zonelist_order_handler().

This can equally fix the possible race:

    CPU0                                    CPU1                            CPU2
(1) zone->present_pages += online_pages;
(2)                                         build_all_zonelists();
(3)                                                                 alloc_page();
(4)                                                                 free_page();
(5) build_all_zonelists();
(6)   __build_all_zonelists();
(7)     zone->pageset = alloc_percpu();

In step (3,4), zone->pageset still points to boot_pageset, so bad
things may happen if 2+ nodes are in this state. Even if only 1 node
is accessing the boot_pageset, (3) may still consume too much memory
to fail the memory allocations in step (7).

Thanks,
Fengguang
