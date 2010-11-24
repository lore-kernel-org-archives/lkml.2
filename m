Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755672Ab0KXAZz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Nov 2010 19:25:55 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:35203 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753690Ab0KXAZx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Nov 2010 19:25:53 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Wed, 24 Nov 2010 09:20:03 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Minchan Kim <minchan.kim@gmail.com>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Bob Liu <lliubbo@gmail.com>, fujita.tomonori@lab.ntt.co.jp,
        m.nazarewicz@samsung.com, pawel@osciak.com, andi.kleen@intel.com,
        felipe.contreras@gmail.com,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "kosaki.motohiro@jp.fujitsu.com" <kosaki.motohiro@jp.fujitsu.com>
Subject: Re: [PATCH 3/4] alloc_contig_pages() allocate big chunk memory
 using migration
Message-Id: <20101124092003.145e0c13.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <AANLkTi=E=b7X1Un7Bp_eSAFrFjOPsYpBO-Ba1aeTrrjr@mail.gmail.com>
References: <20101119171033.a8d9dc8f.kamezawa.hiroyu@jp.fujitsu.com>
	<20101119171528.32674ef4.kamezawa.hiroyu@jp.fujitsu.com>
	<AANLkTi=E=b7X1Un7Bp_eSAFrFjOPsYpBO-Ba1aeTrrjr@mail.gmail.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.0.3 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 22 Nov 2010 20:44:03 +0900
Minchan Kim <minchan.kim@gmail.com> wrote:

> On Fri, Nov 19, 2010 at 5:15 PM, KAMEZAWA Hiroyuki
> <kamezawa.hiroyu@jp.fujitsu.com> wrote:
> > From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> >
> > Add an function to allocate contiguous memory larger than MAX_ORDER.
> > The main difference between usual page allocator is that this uses
> > memory offline technique (Isolate pages and migrate remaining pages.).
> >
> > I think this is not 100% solution because we can't avoid fragmentation,
> > but we have kernelcore= boot option and can create MOVABLE zone. That
> > helps us to allow allocate a contiguous range on demand.
> 
> And later we can use compaction and reclaim, too.
> So I think this approach is the way we have to go.
> 
> >
> > The new function is
> >
> >  alloc_contig_pages(base, end, nr_pages, alignment)
> >
> > This function will allocate contiguous pages of nr_pages from the range
> > [base, end). If [base, end) is bigger than nr_pages, some pfn which
> > meats alignment will be allocated. If alignment is smaller than MAX_ORDER,
> 
> type meet
> 
will fix.

> > it will be raised to be MAX_ORDER.
> >
> > __alloc_contig_pages() has much more arguments.
> >
> >
> > Some drivers allocates contig pages by bootmem or hiding some memory
> > from the kernel at boot. But if contig pages are necessary only in some
> > situation, kernelcore= boot option and using page migration is a choice.
> >
> > Changelog: 2010-11-19
> >  - removed no_search
> >  - removed some drain_ functions because they are heavy.
> >  - check -ENOMEM case
> >
> > Changelog: 2010-10-26
> >  - support gfp_t
> >  - support zonelist/nodemask
> >  - support [base, end)
> >  - support alignment
> >
> > Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> > ---
> >  include/linux/page-isolation.h |   15 ++
> >  mm/page_alloc.c                |   29 ++++
> >  mm/page_isolation.c            |  242 +++++++++++++++++++++++++++++++++++++++++
> >  3 files changed, 286 insertions(+)
> >
> > Index: mmotm-1117/mm/page_isolation.c
> > ===================================================================
> > --- mmotm-1117.orig/mm/page_isolation.c
> > +++ mmotm-1117/mm/page_isolation.c
> > @@ -5,6 +5,7 @@
> >  #include <linux/mm.h>
> >  #include <linux/page-isolation.h>
> >  #include <linux/pageblock-flags.h>
> > +#include <linux/swap.h>
> >  #include <linux/memcontrol.h>
> >  #include <linux/migrate.h>
> >  #include <linux/memory_hotplug.h>
> > @@ -396,3 +397,244 @@ retry:
> >        }
> >        return 0;
> >  }
> > +
> > +/*
> > + * Comparing caller specified [user_start, user_end) with physical memory layout
> > + * [phys_start, phys_end). If no intersection is longer than nr_pages, return 1.
> > + * If there is an intersection, return 0 and fill range in [*start, *end)
> 
> I understand the goal of function.
> But comment is rather awkward.
> 

ok, I will rewrite.

> > + */
> > +static int
> > +__calc_search_range(unsigned long user_start, unsigned long user_end,
> 
> Personally, I don't like the function name.
> How about "__adjust_search_range"?
> But I am not against this name strongly. :)
> 
I will rename this.


> > +               unsigned long nr_pages,
> > +               unsigned long phys_start, unsigned long phys_end,
> > +               unsigned long *start, unsigned long *end)
> > +{
> > +       if ((user_start >= phys_end) || (user_end <= phys_start))
> > +               return 1;
> > +       if (user_start <= phys_start) {
> > +               *start = phys_start;
> > +               *end = min(user_end, phys_end);
> > +       } else {
> > +               *start = user_start;
> > +               *end = min(user_end, phys_end);
> > +       }
> > +       if (*end - *start < nr_pages)
> > +               return 1;
> > +       return 0;
> > +}
> > +
> > +
> > +/**
> > + * __alloc_contig_pages - allocate a contiguous physical pages
> > + * @base: the lowest pfn which caller wants.
> > + * @end:  the highest pfn which caller wants.
> > + * @nr_pages: the length of a chunk of pages to be allocated.
> 
> the number of pages to be allocated.
> 
ok.

> > + * @align_order: alignment of start address of returned chunk in order.
> > + *   Returned' page's order will be aligned to (1 << align_order).If smaller
> > + *   than MAX_ORDER, it's raised to MAX_ORDER.
> > + * @node: allocate near memory to the node, If -1, current node is used.
> > + * @gfpflag: used to specify what zone the memory should be from.
> > + * @nodemask: allocate memory within the nodemask.
> > + *
> > + * Search a memory range [base, end) and allocates physically contiguous
> > + * pages. If end - base is larger than nr_pages, a chunk in [base, end) will
> > + * be allocated
> > + *
> > + * This returns a page of the beginning of contiguous block. At failure, NULL
> > + * is returned.
> > + *
> > + * Limitation: at allocation, nr_pages may be increased to be aligned to
> > + * MAX_ORDER before searching a range. So, even if there is a enough chunk
> > + * for nr_pages, it may not be able to be allocated. Extra tail pages of
> > + * allocated chunk is returned to buddy allocator before returning the caller.
> > + */
> > +
> > +#define MIGRATION_RETRY        (5)
> > +struct page *__alloc_contig_pages(unsigned long base, unsigned long end,
> > +                       unsigned long nr_pages, int align_order,
> > +                       int node, gfp_t gfpflag, nodemask_t *mask)
> > +{
> > +       unsigned long found, aligned_pages, start;
> > +       struct page *ret = NULL;
> > +       int migration_failed;
> > +       unsigned long align_mask;
> > +       struct zoneref *z;
> > +       struct zone *zone;
> > +       struct zonelist *zonelist;
> > +       enum zone_type highzone_idx = gfp_zone(gfpflag);
> > +       unsigned long zone_start, zone_end, rs, re, pos;
> > +
> > +       if (node == -1)
> > +               node = numa_node_id();
> > +
> > +       /* check unsupported flags */
> > +       if (gfpflag & __GFP_NORETRY)
> > +               return NULL;
> > +       if ((gfpflag & (__GFP_WAIT | __GFP_IO | __GFP_FS)) !=
> > +               (__GFP_WAIT | __GFP_IO | __GFP_FS))
> > +               return NULL;
> 
> Why do we have to care about __GFP_IO|__GFP_FS?
> If you consider compaction/reclaim later, I am OK.
> 
because in page migration, we use GFP_HIGHUSER_MOVABLE now.


> > +
> > +       if (gfpflag & __GFP_THISNODE)
> > +               zonelist = &NODE_DATA(node)->node_zonelists[1];
> > +       else
> > +               zonelist = &NODE_DATA(node)->node_zonelists[0];
> > +       /*
> > +        * Base/nr_page/end should be aligned to MAX_ORDER
> > +        */
> > +       found = 0;
> > +
> > +       if (align_order < MAX_ORDER)
> > +               align_order = MAX_ORDER;
> > +
> > +       align_mask = (1 << align_order) - 1;
> > +       /*
> > +        * We allocates MAX_ORDER aligned pages and cut tail pages later.
> > +        */
> > +       aligned_pages = ALIGN(nr_pages, (1 << MAX_ORDER));
> > +       /*
> > +        * If end - base == nr_pages, we can't search range. base must be
> > +        * aligned.
> > +        */
> > +       if ((end - base == nr_pages) && (base & align_mask))
> > +               return NULL;
> > +
> > +       base = ALIGN(base, (1 << align_order));
> > +       if ((end <= base) || (end - base < aligned_pages))
> > +               return NULL;
> > +
> > +       /*
> > +        * searching contig memory range within [pos, end).
> > +        * pos is updated at migration failure to find next chunk in zone.
> > +        * pos is reset to the base at searching next zone.
> > +        * (see for_each_zone_zonelist_nodemask in mmzone.h)
> > +        *
> > +        * Note: we cannot assume zones/nodes are in linear memory layout.
> > +        */
> > +       z = first_zones_zonelist(zonelist, highzone_idx, mask, &zone);
> > +       pos = base;
> > +retry:
> > +       if (!zone)
> > +               return NULL;
> > +
> > +       zone_start = ALIGN(zone->zone_start_pfn, 1 << align_order);
> > +       zone_end = zone->zone_start_pfn + zone->spanned_pages;
> > +
> > +       /* check [pos, end) is in this zone. */
> > +       if ((pos >= end) ||
> > +            (__calc_search_range(pos, end, aligned_pages,
> > +                       zone_start, zone_end, &rs, &re))) {
> > +next_zone:
> > +               /* go to the next zone */
> > +               z = next_zones_zonelist(++z, highzone_idx, mask, &zone);
> > +               /* reset the pos */
> > +               pos = base;
> > +               goto retry;
> > +       }
> > +       /* [pos, end) is trimmed to [rs, re) in this zone. */
> > +       pos = rs;
> 
> The 'pos' doesn't used any more at below.
> 
Ah, yes. I'll check this was for what and remove this.

Thanks,
-Kame

