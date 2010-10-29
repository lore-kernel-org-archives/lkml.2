Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751392Ab0J2EId (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Oct 2010 00:08:33 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:57798 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750884Ab0J2EI2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Oct 2010 00:08:28 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Fri, 29 Oct 2010 13:02:51 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Bob Liu <lliubbo@gmail.com>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "minchan.kim@gmail.com" <minchan.kim@gmail.com>, andi.kleen@intel.com,
        KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
        fujita.tomonori@lab.ntt.co.jp, felipe.contreras@gmail.com
Subject: Re: [RFC][PATCH 3/3] a big contig memory allocator
Message-Id: <20101029130251.f82f6925.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <AANLkTik-d4-6xN6BFYNcAOyR3P7uJDB-0ucr6Uks3AXv@mail.gmail.com>
References: <20101026190042.57f30338.kamezawa.hiroyu@jp.fujitsu.com>
	<20101026190809.4869b4f0.kamezawa.hiroyu@jp.fujitsu.com>
	<AANLkTik-d4-6xN6BFYNcAOyR3P7uJDB-0ucr6Uks3AXv@mail.gmail.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.0.3 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 29 Oct 2010 11:55:10 +0800
Bob Liu <lliubbo@gmail.com> wrote:

> On Tue, Oct 26, 2010 at 6:08 PM, KAMEZAWA Hiroyuki
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
> >
> > The new function is
> >
> >  alloc_contig_pages(base, end, nr_pages, alignment)
> >
> > This function will allocate contiguous pages of nr_pages from the range
> > [base, end). If [base, end) is bigger than nr_pages, some pfn which
> > meats alignment will be allocated. If alignment is smaller than MAX_ORDER,
> > it will be raised to be MAX_ORDER.
> >
> > __alloc_contig_pages() has much more arguments.
> >
> > Some drivers allocates contig pages by bootmem or hiding some memory
> > from the kernel at boot. But if contig pages are necessary only in some
> > situation, kernelcore= boot option and using page migration is a choice.
> >
> > Note: I'm not 100% sure __GFP_HARDWALL check is required or not..
> >
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
> >  mm/page_isolation.c            |  239 +++++++++++++++++++++++++++++++++++++++++
> >  3 files changed, 283 insertions(+)
> >
> > Index: mmotm-1024/mm/page_isolation.c
> > ===================================================================
> > --- mmotm-1024.orig/mm/page_isolation.c
> > +++ mmotm-1024/mm/page_isolation.c
> > @@ -5,6 +5,7 @@
> >  #include <linux/mm.h>
> >  #include <linux/page-isolation.h>
> >  #include <linux/pageblock-flags.h>
> > +#include <linux/swap.h>
> >  #include <linux/memcontrol.h>
> >  #include <linux/migrate.h>
> >  #include <linux/memory_hotplug.h>
> > @@ -398,3 +399,241 @@ retry:
> >        }
> >        return 0;
> >  }
> > +
> > +/*
> > + * Comparing user specified [user_start, user_end) with physical memory layout
> > + * [phys_start, phys_end). If no intersection of length nr_pages, return 1.
> > + * If there is an intersection, return 0 and fill range in [*start, *end)
> > + */
> > +static int
> > +__calc_search_range(unsigned long user_start, unsigned long user_end,
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
> > +       bool no_search = false;
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
> > +       if ((gfpflag & (__GFP_WAIT | __GFP_IO | __GFP_FS | __GFP_HARDWALL)) !=
> > +               (__GFP_WAIT | __GFP_IO | __GFP_FS | __GFP_HARDWALL))
> > +               return NULL;
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
> > +       if (end - base == nr_pages)
> > +               no_search = true;
> 
> no_search is not used ?
> 
Ah, yes. I wanted to remove this and I missed this one.
But I have to do check again whether no_search check is required or not..

Thanks,
-Kame

