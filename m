Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752753Ab0JRAek (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Oct 2010 20:34:40 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:44583 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752098Ab0JRAej (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Oct 2010 20:34:39 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Mon, 18 Oct 2010 09:29:20 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Minchan Kim <minchan.kim@gmail.com>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [RFC][PATCH 2/3] find a contiguous range.
Message-Id: <20101018092920.b039f6ae.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <AANLkTikCZBLufoL7pH8LKSRZRzOeH0z508PwJ5KwyE-5@mail.gmail.com>
References: <20101013121527.8ec6a769.kamezawa.hiroyu@jp.fujitsu.com>
	<20101013121738.933ff002.kamezawa.hiroyu@jp.fujitsu.com>
	<AANLkTikCZBLufoL7pH8LKSRZRzOeH0z508PwJ5KwyE-5@mail.gmail.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.0.3 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 17 Oct 2010 12:18:48 +0900
Minchan Kim <minchan.kim@gmail.com> wrote:

> Hi Kame,
> Sorry for the late review.
> 
> On Wed, Oct 13, 2010 at 12:17 PM, KAMEZAWA Hiroyuki
> <kamezawa.hiroyu@jp.fujitsu.com> wrote:
> > From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> >
> > Unlike memory hotplug, at an allocation of contigous memory range, address
> > may not be a problem. IOW, if a requester of memory wants to allocate 100M of
> > of contigous memory, placement of allocated memory may not be a problem.
> > So, "finding a range of memory which seems to be MOVABLE" is required.
> >
> > This patch adds a functon to isolate a length of memory within [start, end).
> 
> Typo
> function
> 
> > This function returns a pfn which is 1st page of isolated contigous chunk
> 
> Typo
> contiguous
> 
I'll use aspell...


> > of given length within [start, end).
> >
> > If no_search=true is passed as argument, start address is always same to
> 
> I don't like no_search argument name. It would be better to show not
> the implement but context.
> How about "bool strict" or "ALLOC_FIXED"?

Hmm, ok. 

> > the specified "base" addresss.
> Typo
> address,
> Let's add following description.
> "Some devices want to bind memory to some memory bank. In this case,
> no_search and base address fix
> can be helpful."

Then, do you need "end" address for search ?


> 
> >
> > After isolation, free memory within this area will never be allocated.
> > But some pages will remain as "Used/LRU" pages. They should be dropped by
> > page reclaim or migration.
> 
> At first I saw the above description, I got confused. How about this?

> After it isolates some pages in the range, the part of some pages are
> freed but others could be used processes now.
> Next patch[3/3] try to move or reclaim used pages by page
> migration/reclaim for obtaining big contiguous page.
> 

will consider some.


> >
> >
> > Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> > ---
> >  mm/page_isolation.c |  130 ++++++++++++++++++++++++++++++++++++++++++++++++++++
> >  1 file changed, 130 insertions(+)
> >
> > Index: mmotm-1008/mm/page_isolation.c
> > ===================================================================
> > --- mmotm-1008.orig/mm/page_isolation.c
> > +++ mmotm-1008/mm/page_isolation.c
> > @@ -9,6 +9,7 @@
> >  #include <linux/pageblock-flags.h>
> >  #include <linux/memcontrol.h>
> >  #include <linux/migrate.h>
> > +#include <linux/memory_hotplug.h>
> >  #include <linux/mm_inline.h>
> >  #include "internal.h"
> >
> > @@ -254,3 +255,132 @@ out:
> >        return ret;
> >  }
> >
> > +/*
> > + * Functions for getting contiguous MOVABLE pages in a zone.
> > + */
> > +struct page_range {
> > +       unsigned long base; /* Base address of searching contigouous block */
> 
> Typo contiguous.
> Please, specify that it's a pfn number.
> 
ok.

> > +       unsigned long end;
> > +       unsigned long pages;/* Length of contiguous block */
> > +};
> > +
> > +static inline unsigned long  MAX_ORDER_ALIGN(unsigned long x)
> > +{
> > +       return ALIGN(x, MAX_ORDER_NR_PAGES);
> > +}
> > +
> > +static inline unsigned long MAX_ORDER_BASE(unsigned long x)
> > +{
> > +       return x & ~(MAX_ORDER_NR_PAGES - 1);
> > +}
> > +
> > +int __get_contig_block(unsigned long pfn, unsigned long nr_pages, void *arg)
> > +{
> > +       struct page_range *blockinfo = arg;
> > +       unsigned long end;
> > +
> > +       end = pfn + nr_pages;
> > +       pfn = MAX_ORDER_ALIGN(pfn);
> > +       end = MAX_ORDER_BASE(end);
> > +
> > +       if (end < pfn)
> > +               return 0;
> > +       if (end - pfn >= blockinfo->pages) {
> > +               blockinfo->base = pfn;
> > +               blockinfo->end = end;
> > +               return 1;
> > +       }
> > +       return 0;
> > +}
> > +
> > +static void __trim_zone(struct page_range *range)
> 
> Hmm..
> I think this function name can't present enough meaning.
> Let's move description in body of function to the head.
> 
> /*
>  * In most case, each zone's [start_pfn, end_pfn) has no
>  * overlap between each other. But some arch allows it and
>  * we need to check it here. If it happens, range end is changed
>  * to only include pfns in a zone.
>  */

ok.

> 
> > +{
> > +       struct zone *zone;
> > +       unsigned long pfn;
> > +       /*
> > +        * In most case, each zone's [start_pfn, end_pfn) has no
> > +        * overlap between each other. But some arch allows it and
> > +        * we need to check it here.
> > +        */
> > +       for (pfn = range->base, zone = page_zone(pfn_to_page(pfn));
> > +            pfn < range->end;
> > +            pfn += MAX_ORDER_NR_PAGES) {
> > +
> > +               if (zone != page_zone(pfn_to_page(pfn)))
> > +                       break;
> > +       }
> > +       range->end = min(pfn, range->end);
> > +       return;
> 
> Unnecessary return.
> 
will remove.

> > +}
> > +
> > +/*
> > + * This function is for finding a contiguous memory block which has length
> > + * of pages and MOVABLE. If it finds, make the range of pages as ISOLATED
> > + * and return the first page's pfn.
> > + * If no_search==true, this function doesn't scan the range but tries to
> > + * isolate the range of memory.
> > + */
> > +
> > +static unsigned long find_contig_block(unsigned long base,
> > +               unsigned long end, unsigned long pages, bool no_search)
> > +{
> > +       unsigned long pfn, pos;
> > +       struct page_range blockinfo;
> > +       int ret;
> > +
> > +       pages = MAX_ORDER_ALIGN(pages);
> > +retry:
> > +       blockinfo.base = base;
> > +       blockinfo.end = end;
> > +       blockinfo.pages = pages;
> > +       /*
> > +        * At first, check physical page layout and skip memory holes.
> > +        */
> > +       ret = walk_system_ram_range(base, end - base, &blockinfo,
> > +               __get_contig_block);
> > +       if (!ret)
> > +               return 0;
> > +       /* check contiguous pages in a zone */
> > +       __trim_zone(&blockinfo);
> > +
> > +
> > +       /* Ok, we found contiguous memory chunk of size. Isolate it.*/
> > +       for (pfn = blockinfo.base; pfn + pages < blockinfo.end;
> > +            pfn += MAX_ORDER_NR_PAGES) {
> > +               /* If no_search==true, base addess should be same to 'base' */
> > +               if (no_search && pfn != base)
> > +                       break;
> > +               /* Better code is necessary here.. */
> > +               for (pos = pfn; pos < pfn + pages; pos++) {
> > +                       struct page *p;
> > +
> > +                       if (!pfn_valid_within(pos))
> > +                               break;
> > +                       p = pfn_to_page(pos);
> > +                       if (PageReserved(p))
> > +                               break;
> > +                       /* This may hit a page on per-cpu queue. */
> 
> Couldn't we drain per-cpu queue before this function?
> 
We can't guarantee it on SMP systems because we don't ISOLATE the range
at this point.


Thanks,
-Kame

