Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756532Ab0ICJSe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Sep 2010 05:18:34 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:57307 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754673Ab0ICJSd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Sep 2010 05:18:33 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Fri, 3 Sep 2010 18:13:27 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Michal Hocko <mhocko@suse.cz>
Cc: Hiroyuki Kamezawa <kamezawa.hiroyuki@gmail.com>,
        Wu Fengguang <fengguang.wu@intel.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Kleen, Andi" <andi.kleen@intel.com>,
        Haicheng Li <haicheng.li@linux.intel.com>,
        Christoph Lameter <cl@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Mel Gorman <mel@linux.vnet.ibm.com>
Subject: Re: [PATCH 2/2] Make is_mem_section_removable more conformable with
 offlining code
Message-Id: <20100903181327.7dad3f84.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20100903082558.GC10686@tiehlicka.suse.cz>
References: <20100902082829.GA10265@tiehlicka.suse.cz>
	<20100902180343.f4232c6e.kamezawa.hiroyu@jp.fujitsu.com>
	<20100902092454.GA17971@tiehlicka.suse.cz>
	<AANLkTi=cLzRGPCc3gCubtU7Ggws7yyAK5c7tp4iocv6u@mail.gmail.com>
	<20100902131855.GC10265@tiehlicka.suse.cz>
	<AANLkTikYt3Hu_XeNuwAa9KjzfWgpC8cNen6q657ZKmm-@mail.gmail.com>
	<20100902143939.GD10265@tiehlicka.suse.cz>
	<20100902150554.GE10265@tiehlicka.suse.cz>
	<20100903121003.e2b8993a.kamezawa.hiroyu@jp.fujitsu.com>
	<20100903121452.2d22b3aa.kamezawa.hiroyu@jp.fujitsu.com>
	<20100903082558.GC10686@tiehlicka.suse.cz>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.0.3 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 3 Sep 2010 10:25:58 +0200
Michal Hocko <mhocko@suse.cz> wrote:

> On Fri 03-09-10 12:14:52, KAMEZAWA Hiroyuki wrote:
> [...]
> > ---
> >  include/linux/memory_hotplug.h |    1 
> >  mm/memory_hotplug.c            |   15 --------
> >  mm/page_alloc.c                |   76 ++++++++++++++++++++++++++++++-----------
> >  3 files changed, 59 insertions(+), 33 deletions(-)
> > 
> > Index: mmotm-0827/mm/page_alloc.c
> > ===================================================================
> > --- mmotm-0827.orig/mm/page_alloc.c
> > +++ mmotm-0827/mm/page_alloc.c
> > @@ -5274,11 +5274,63 @@ void set_pageblock_flags_group(struct pa
> >   * page allocater never alloc memory from ISOLATE block.
> >   */
> >  
> > +static int __count_unmovable_pages(struct zone *zone, struct page *page)
> > +{
> > +	unsigned long pfn, iter, found;
> > +	/*
> > +	 * For avoiding noise data, lru_add_drain_all() should be called.
> > + 	 * before this.
> > + 	 */
> > +	if (zone_idx(zone) == ZONE_MOVABLE)
> > +		return 0;
> 
> Cannot ZONE_MOVABLE contain different MIGRATE_types?
> 
never.

> > +
> > +	pfn = page_to_pfn(page);
> > +	for (found = 0, iter = 0; iter < pageblock_nr_pages; iter++) {
> > +		unsigned long check = pfn + iter;
> > +
> > +		if (!pfn_valid_within(check)) {
> > +			iter++;
> > +			continue;
> > +		}
> > +		page = pfn_to_page(check);
> > +		if (!page_count(page)) {
> > +			if (PageBuddy(page))
> 
> Why do you check page_count as well? PageBuddy has alwyas count==0,
> right?
> 

But PageBuddy() flag is considered to be valid only when page_count()==0.
This is for safe handling.


> > +				iter += (1 << page_order(page)) - 1;
> > +			continue;
> > +		}
> > +		if (!PageLRU(page))
> > +			found++;
> > +		/*
> > +		 * If the page is not RAM, page_count()should be 0.
> > +		 * we don't need more check. This is an _used_ not-movable page.
> > +		 *
> > +		 * The problematic thing here is PG_reserved pages. But if
> > +		 * a PG_reserved page is _used_ (at boot), page_count > 1.
> > +		 * But...is there PG_reserved && page_count(page)==0 page ?
> 
> Can we have PG_reserved && PG_lru? 

I think never.

> I also quite don't understand the comment. 

There an issue that "remove an memory section which includes memory hole".
Then,

   a page used by bootmem .... PG_reserved.
   a page of memory hole  .... PG_reserved.

We need to call page_is_ram() or some for handling this mess.


> At this place we are sure that the page is valid and neither
> free nor LRU.
> 


> > +		 */
> > +	}
> > +	return found;
> > +}
> > +
> > +bool is_pageblock_removable(struct page *page)
> > +{
> > +	struct zone *zone = page_zone(page);
> > +	unsigned long flags;
> > +	int num;
> > +
> > +	spin_lock_irqsave(&zone->lock, flags);
> > +	num = __count_unmovable_pages(zone, page);
> > +	spin_unlock_irqrestore(&zone->lock, flags);
> 
> Isn't this a problem? The function is triggered from userspace by sysfs
> (0444 file) and holds the lock for pageblock_nr_pages. So someone can
> simply read the file and block the zone->lock preventing/delaying
> allocations for the rest of the system.
> 
But we need to take this. Maybe no panic you'll see even if no-lock.

> I think that the function should rather bail out as soon as possible.
> 

I did this for 100% accuracy, but ok, will remove this lock and see what happens.

> [...]
> 
> >  	/* All pageblocks in the memory block are likely to be hot-removable */
> > Index: mmotm-0827/include/linux/memory_hotplug.h
> > ===================================================================
> > --- mmotm-0827.orig/include/linux/memory_hotplug.h
> > +++ mmotm-0827/include/linux/memory_hotplug.h
> > @@ -76,6 +76,7 @@ extern int __add_pages(int nid, struct z
> >  extern int __remove_pages(struct zone *zone, unsigned long start_pfn,
> >  	unsigned long nr_pages);
> >  
> > +extern bool is_pageblock_removable(struct page *page);
> >  #ifdef CONFIG_NUMA
> >  extern int memory_add_physaddr_to_nid(u64 start);
> >  #else
> 
> Shouldn't this go rather under CONFIG_MEMORY_HOTREMOVE?
> 

Hmm. maybe. will post udpated one.

Thanks,
-Kame

