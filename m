Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755681Ab0KVARP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Nov 2010 19:17:15 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:33249 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755300Ab0KVARO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Nov 2010 19:17:14 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Mon, 22 Nov 2010 09:11:37 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Minchan Kim <minchan.kim@gmail.com>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Bob Liu <lliubbo@gmail.com>, fujita.tomonori@lab.ntt.co.jp,
        m.nazarewicz@samsung.com, pawel@osciak.com, andi.kleen@intel.com,
        felipe.contreras@gmail.com,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "kosaki.motohiro@jp.fujitsu.com" <kosaki.motohiro@jp.fujitsu.com>
Subject: Re: [PATCH 2/4] alloc_contig_pages() find appropriate physical
 memory range
Message-Id: <20101122091137.13da6a25.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20101121152131.GB20947@barrios-desktop>
References: <20101119171033.a8d9dc8f.kamezawa.hiroyu@jp.fujitsu.com>
	<20101119171415.aa320cab.kamezawa.hiroyu@jp.fujitsu.com>
	<20101121152131.GB20947@barrios-desktop>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.0.3 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 22 Nov 2010 00:21:31 +0900
Minchan Kim <minchan.kim@gmail.com> wrote:

> Acked-by: Minchan Kim <minchan.kim@gmail.com>
> 
> Just some trivial comment below. 
> 
> Intentionally, I don't add Reviewed-by. 
> Instead of it, I add Acked-by since I support this work.
Thanks.

> 
> I reviewed your old version but have forgot it. :(

Sorry, I had a vacation ;(

> So I will have a time to review your code and then add Reviewed-by.
> 
> > ---
> >  mm/page_isolation.c |  146 ++++++++++++++++++++++++++++++++++++++++++++++++++++
> >  1 file changed, 146 insertions(+)
> > 
> > Index: mmotm-1117/mm/page_isolation.c
> > ===================================================================
> > --- mmotm-1117.orig/mm/page_isolation.c
> > +++ mmotm-1117/mm/page_isolation.c
> > @@ -7,6 +7,7 @@
> >  #include <linux/pageblock-flags.h>
> >  #include <linux/memcontrol.h>
> >  #include <linux/migrate.h>
> > +#include <linux/memory_hotplug.h>
> >  #include <linux/mm_inline.h>
> >  #include "internal.h"
> >  
> > @@ -250,3 +251,148 @@ int do_migrate_range(unsigned long start
> >  out:
> >  	return ret;
> >  }
> > +
> > +/*
> > + * Functions for getting contiguous MOVABLE pages in a zone.
> > + */
> > +struct page_range {
> > +	unsigned long base; /* Base address of searching contigouous block */
> > +	unsigned long end;
> > +	unsigned long pages;/* Length of contiguous block */
> > +	int align_order;
> > +	unsigned long align_mask;
> > +};
> > +
> > +int __get_contig_block(unsigned long pfn, unsigned long nr_pages, void *arg)
> > +{
> > +	struct page_range *blockinfo = arg;
> > +	unsigned long end;
> > +
> > +	end = pfn + nr_pages;
> > +	pfn = ALIGN(pfn, 1 << blockinfo->align_order);
> > +	end = end & ~(MAX_ORDER_NR_PAGES - 1);
> > +
> > +	if (end < pfn)
> > +		return 0;
> > +	if (end - pfn >= blockinfo->pages) {
> > +		blockinfo->base = pfn;
> > +		blockinfo->end = end;
> > +		return 1;
> > +	}
> > +	return 0;
> > +}
> > +
> > +static void __trim_zone(struct zone *zone, struct page_range *range)
> > +{
> > +	unsigned long pfn;
> > +	/*
> > + 	 * skip pages which dones'nt under the zone.
> 
>                             typo
> 
will fix.


> > + 	 * There are some archs which zones are not in linear layout.
> > +	 */
> > +	if (page_zone(pfn_to_page(range->base)) != zone) {
> > +		for (pfn = range->base;
> > +			pfn < range->end;
> > +			pfn += MAX_ORDER_NR_PAGES) {
> > +			if (page_zone(pfn_to_page(pfn)) == zone)
> > +				break;
> > +		}
> > +		range->base = min(pfn, range->end);
> > +	}
> > +	/* Here, range-> base is in the zone if range->base != range->end */
> > +	for (pfn = range->base;
> > +	     pfn < range->end;
> > +	     pfn += MAX_ORDER_NR_PAGES) {
> > +		if (zone != page_zone(pfn_to_page(pfn))) {
> > +			pfn = pfn - MAX_ORDER_NR_PAGES;
> > +			break;
> > +		}
> > +	}
> > +	range->end = min(pfn, range->end);
> > +	return;
> > +}
> > +
> > +/*
> > + * This function is for finding a contiguous memory block which has length
> > + * of pages and MOVABLE. If it finds, make the range of pages as ISOLATED
> > + * and return the first page's pfn.
> > + * This checks all pages in the returned range is free of Pg_LRU. To reduce
> 
>                                                               typo
> 
will lfix.

> > + * the risk of false-positive testing, lru_add_drain_all() should be called
> > + * before this function to reduce pages on pagevec for zones.
> > + */
> > +
> > +static unsigned long find_contig_block(unsigned long base,
> > +		unsigned long end, unsigned long pages,
> > +		int align_order, struct zone *zone)
> > +{
> > +	unsigned long pfn, pos;
> > +	struct page_range blockinfo;
> > +	int ret;
> > +
> > +	VM_BUG_ON(pages & (MAX_ORDER_NR_PAGES - 1));
> > +	VM_BUG_ON(base & ((1 << align_order) - 1));
> > +retry:
> > +	blockinfo.base = base;
> > +	blockinfo.end = end;
> > +	blockinfo.pages = pages;
> > +	blockinfo.align_order = align_order;
> > +	blockinfo.align_mask = (1 << align_order) - 1;
> > +	/*
> > +	 * At first, check physical page layout and skip memory holes.
> > +	 */
> > +	ret = walk_system_ram_range(base, end - base, &blockinfo,
> > +		__get_contig_block);
> 
> We need #include <linux/ioport.h>
> 

ok.

Thanks,
-Kame

