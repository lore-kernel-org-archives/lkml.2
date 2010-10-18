Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752880Ab0JRAkx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Oct 2010 20:40:53 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:44817 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752620Ab0JRAkw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Oct 2010 20:40:52 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Mon, 18 Oct 2010 09:35:33 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Minchan Kim <minchan.kim@gmail.com>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [RFC][PATCH 3/3] alloc contig pages with migration.
Message-Id: <20101018093533.abd4c8ee.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <AANLkTingNmxT6ww_VB_K=rjsgR+dHANLnyNkwV1Myvnk@mail.gmail.com>
References: <20101013121527.8ec6a769.kamezawa.hiroyu@jp.fujitsu.com>
	<20101013121829.c3320944.kamezawa.hiroyu@jp.fujitsu.com>
	<AANLkTingNmxT6ww_VB_K=rjsgR+dHANLnyNkwV1Myvnk@mail.gmail.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.0.3 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 17 Oct 2010 13:05:22 +0900
Minchan Kim <minchan.kim@gmail.com> wrote:

> On Wed, Oct 13, 2010 at 12:18 PM, KAMEZAWA Hiroyuki
> <kamezawa.hiroyu@jp.fujitsu.com> wrote:
> > From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> >
> > Add an function to allocate contigous memory larger than MAX_ORDER.
> > The main difference between usual page allocater is that this uses
> > memory offline techiqueue (Isoalte pages and migrate remaining pages.).
> >
> > I think this is not 100% solution because we can't avoid fragmentation,
> > but we have kernelcore= boot option and can create MOVABLE zone. That
> > helps us to allow allocate a contigous range on demand.
> >
> > Maybe drivers can alloc contig pages by bootmem or hiding some memory
> > from the kernel at boot. But if contig pages are necessary only in some
> > situation, kernelcore= boot option and using page migration is a choice.
> >
> > Anyway, to allocate a contiguous chunk larger than MAX_ORDER, we need to
> > add an overlay allocator on buddy allocator. This can be a 1st step.
> >
> > Note:
> > This function is heavy if there are tons of memory requesters. So, maybe
> > not good for 1GB pages for x86's usual use. It will requires some other
> > tricks than migration.
> 
> I got found many typos but I don't pointed out each by each. :)
> Please, correct typos in next version.
> 
Sorry.

> >
> > TODO:
> >  - allows the caller to specify the migration target pages.
> >  - reduce the number of lru_add_drain_all()..etc...system wide heavy calls.
> >  - Pass gfp_t for some purpose...
> >
> > Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> > ---
> >  include/linux/page-isolation.h |    8 ++
> >  mm/page_alloc.c                |   29 ++++++++
> >  mm/page_isolation.c            |  136 +++++++++++++++++++++++++++++++++++++++++
> >  3 files changed, 173 insertions(+)
> >
> > Index: mmotm-1008/mm/page_isolation.c
> > ===================================================================
> > --- mmotm-1008.orig/mm/page_isolation.c
> > +++ mmotm-1008/mm/page_isolation.c
> > @@ -7,6 +7,7 @@
> >  #include <linux/mm.h>
> >  #include <linux/page-isolation.h>
> >  #include <linux/pageblock-flags.h>
> > +#include <linux/swap.h>
> >  #include <linux/memcontrol.h>
> >  #include <linux/migrate.h>
> >  #include <linux/memory_hotplug.h>
> > @@ -384,3 +385,138 @@ retry:
> >        }
> >        return 0;
> >  }
> > +
> > +/**
> > + * alloc_contig_pages - allocate a contigous physical pages
> > + * @hint:      the base address of searching free space(in pfn)
> > + * @size:      size of requested area (in # of pages)
> 
> Could you add _range_ which can be specified by user into your TODO list?
> Maybe some embedded system have a requirement to allocate contiguous
> pages in some bank.
> so guys try to allocate pages in some base address and if it fails, he
> can try to next offset in same bank.
> But it's very annoying. So let's add feature that user can specify
> _range_ where user want to allocate.

Add [start, end) to the argument.

> 
> > + * @node:       the node from which memory is allocated. "-1" means anywhere.
> > + * @no_search: if true, "hint" is not a hint, requirement.
> 
> As I said previous, how about "strict" or "ALLOC_FIXED" like MAP_FIXED?
> 

If "range" is an argument, ALLOC_FIXED is not necessary. I'll add "range".

> > + *
> > + * Search an area of @size in the physical memory map and checks wheter
> 
> Typo
> whether
> 
> > + * we can create a contigous free space. If it seems possible, try to
> > + * create contigous space with page migration. If no_search==true, we just try
> > + * to allocate [hint, hint+size) range of pages as contigous block.
> > + *
> > + * Returns a page of the beginning of contiguous block. At failure, NULL
> > + * is returned. Each page in the area is set to page_count() = 1. Because
> 
> Why do you mention page_count() = 1?
> Do users of this function have to know it?

A user can free any page within the range for his purpose.


> > + * this function does page migration, this function is very heavy and
> 
> Nitpick.
> page migration is implementation, too. Do we need to mention it in here?
> We might add page reclaim/or new feature in future or page migration
> might be very light function although it is not a easy. :)
> Let's not show the implementation for users.
> 

ok.



> > + * sleeps some time. Caller must be aware that "NULL returned" is not a
> > + * special case.
> 
> I think this information is enough to users.
> 
> > + *
> > + * Now, returned range is aligned to MAX_ORDER. (So "hint" must be aligned
> > + * if no_search==true.)
> 
> Couldn't we add handling of this exception?
> If (hint != MAX_ORDER_ALIGH(hint) && no_search == true)
>     return 0 or WARN_ON?
> 

I'll add "alignment" argument. (for 1G hugepage.)
and add the check.



> > + */
> > +
> > +#define MIGRATION_RETRY        (5)
> > +struct page *alloc_contig_pages(unsigned long hint, unsigned long size,
> > +                               int node, bool no_search)
> > +{
> > +       unsigned long base, found, end, pages, start;
> > +       struct page *ret = NULL;
> > +       int migration_failed;
> > +       struct zone *zone;
> > +
> > +       hint = MAX_ORDER_ALIGN(hint);
> > +       /*
> > +        * request size should be aligned to pageblock_order..but use
> > +        * MAX_ORDER here for avoiding messy checks.
> > +        */
> > +       pages = MAX_ORDER_ALIGN(size);
> > +       found = 0;
> > +retry:
> > +       for_each_populated_zone(zone) {
> > +               unsigned long zone_end_pfn;
> > +
> > +               if (node >= 0 && node != zone_to_nid(zone))
> > +                       continue;
> > +               if (zone->present_pages < pages)
> > +                       continue;
> > +               base = MAX_ORDER_ALIGN(zone->zone_start_pfn);
> > +               base = max(base, hint);
> > +               zone_end_pfn = zone->zone_start_pfn + zone->spanned_pages;
> > +               if (base + pages > zone_end_pfn)
> > +                       continue;
> > +               found = find_contig_block(base, zone_end_pfn, pages, no_search);
> > +               /* Next try will see the next block. */
> > +               hint = base + MAX_ORDER_NR_PAGES;
> > +               if (found)
> > +                       break;
> > +       }
> > +
> > +       if (!found)
> > +               return NULL;
> > +
> > +       if (no_search && found != hint)
> 
> You increased hint before "break".
> So if the no_search is true, this condition (found != hint) is always true.
> 
Ah...yes.

> 
> > +               return NULL;
> > +
> > +       /*
> > +        * Ok, here, we have contiguous pageblock marked as "isolated"
> > +        * try migration.
> > +        *
> > +        * FIXME: permanent migration_failure detection logic is required.
> > +        */
> > +       lru_add_drain_all();
> > +       flush_scheduled_work();
> > +       drain_all_pages();
> > +
> > +       end = found + pages;
> > +       /*
> > +        * scan_lru_pages() finds the next PG_lru page in the range
> > +        * scan_lru_pages() returns 0 when it reaches the end.
> > +        */
> > +       for (start = scan_lru_pages(found, end), migration_failed = 0;
> > +            start && start < end;
> > +            start = scan_lru_pages(start, end)) {
> > +               if (do_migrate_range(start, end)) {
> > +                       /* it's better to try another block ? */
> > +                       if (++migration_failed >= MIGRATION_RETRY)
> > +                               break;
> > +                       /* take a rest and synchronize LRU etc. */
> > +                       lru_add_drain_all();
> > +                       flush_scheduled_work();
> > +                       cond_resched();
> > +                       drain_all_pages();
> > +               } else /* reset migration_failure counter */
> > +                       migration_failed = 0;
> > +       }
> > +
> > +       lru_add_drain_all();
> > +       flush_scheduled_work();
> > +       drain_all_pages();
> 
> Hmm.. as you mentioned, It would be better to remove many flush lru/per-cpu.
> But in embedded system, it couldn't be a big overhead.
> 

I'll drop flush_scheduled_work().


> > +       /* Check all pages are isolated */
> > +       if (test_pages_isolated(found, end)) {
> > +               undo_isolate_page_range(found, pages);
> > +               /*
> > +                * We failed at [start...end) migration.
> > +                * FIXME: there may be better restaring point.
> > +                */
> > +               hint = MAX_ORDER_ALIGN(end + 1);
> > +               goto retry; /* goto next chunk */
> > +       }
> > +       /*
> > +        * Ok, here, [found...found+pages) memory are isolated.
> > +        * All pages in the range will be moved into the list with
> > +        * page_count(page)=1.
> > +        */
> > +       ret = pfn_to_page(found);
> > +       alloc_contig_freed_pages(found, found + pages);
> > +       /* unset ISOLATE */
> > +       undo_isolate_page_range(found, pages);
> > +       /* Free unnecessary pages in tail */
> > +       for (start = found + size; start < found + pages; start++)
> > +               __free_page(pfn_to_page(start));
> > +       return ret;
> > +
> > +}
> 
> Thanks for the good patches, Kame.
> 

Thank you for advices.

-Kame

