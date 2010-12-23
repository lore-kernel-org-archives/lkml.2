Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752748Ab0LWKOE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Dec 2010 05:14:04 -0500
Received: from e28smtp03.in.ibm.com ([122.248.162.3]:59242 "EHLO
	e28smtp03.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752277Ab0LWKOB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Dec 2010 05:14:01 -0500
Date: Thu, 23 Dec 2010 14:03:54 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
To: Minchan Kim <minchan.kim@gmail.com>
Cc: linux-mm@kvack.org, akpm@linux-foundation.org, npiggin@kernel.dk,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        kosaki.motohiro@jp.fujitsu.com, cl@linux.com,
        kamezawa.hiroyu@jp.fujitsu.com
Subject: Re: [PATCH 3/3] Provide control over unmapped pages (v2)
Message-ID: <20101223083354.GB16046@balbir.in.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
References: <20101210142745.29934.29186.stgit@localhost6.localdomain6>
 <20101210143112.29934.22944.stgit@localhost6.localdomain6>
 <AANLkTinaTUUfvK+Nc-Whck21r-OzT+0CFVnS4W_jG5aw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AANLkTinaTUUfvK+Nc-Whck21r-OzT+0CFVnS4W_jG5aw@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* MinChan Kim <minchan.kim@gmail.com> [2010-12-14 20:02:45]:

> > +                       if (should_reclaim_unmapped_pages(zone))
> > +                               wakeup_kswapd(zone, order);
> 
> I think we can put the logic into zone_watermark_okay.
>

I did some checks and zone_watermark_ok is used in several places for
a generic check like this -- for example prior to zone_reclaim(), if
in get_page_from_freelist() we skip zones based on the return value.
The compaction code uses it as well, the impact would be deeper. The
compaction code uses it to check whether an allocation will succeed or
not, I don't want unmapped page control to impact that.
 
> > +                       /*
> > +                        * We do unmapped page reclaim once here and once
> > +                        * below, so that we don't lose out
> > +                        */
> > +                       reclaim_unmapped_pages(priority, zone, &sc);
> 
> It can make unnecessary stir of lru pages.
> How about this?
> zone_watermark_ok returns ZONE_UNMAPPED_PAGE_FULL.
> wakeup_kswapd(..., please reclaim unmapped page cache).
> If kswapd is woke up by unmapped page full, kswapd sets up sc with unmap = 0.
> If the kswapd try to reclaim unmapped page, shrink_page_list doesn't
> rotate non-unmapped pages.

With may_unmap set to 0 and may_writepage set to 0, I don't think this
should be a major problem, like I said this code is already enabled if
zone_reclaim_mode != 0 and CONFIG_NUMA is set.

> > +unsigned long reclaim_unmapped_pages(int priority, struct zone *zone,
> > +                                               struct scan_control *sc)
> > +{
> > +       if (unlikely(unmapped_page_control) &&
> > +               (zone_unmapped_file_pages(zone) > zone->min_unmapped_pages)) {
> > +               struct scan_control nsc;
> > +               unsigned long nr_pages;
> > +
> > +               nsc = *sc;
> > +
> > +               nsc.swappiness = 0;
> > +               nsc.may_writepage = 0;
> > +               nsc.may_unmap = 0;
> > +               nsc.nr_reclaimed = 0;
> 
> This logic can be put in zone_reclaim_unmapped_pages.
> 

Now that I refactored the code and called it zone_reclaim_pages, I
expect the correct sc to be passed to it. This code is reused between
zone_reclaim() and reclaim_unmapped_pages(). In the former,
zone_reclaim does the setup.

> If we want really this, how about the new cache lru idea as Kame suggests?
> For example, add_to_page_cache_lru adds the page into cache lru.
> page_add_file_rmap moves the page into inactive file.
> page_remove_rmap moves the page into lru cache, again.
> We can count the unmapped pages and if the size exceeds limit, we can
> wake up kswapd.
> whenever the memory pressure happens, first of all, reclaimer try to
> reclaim cache lru.

We already have a file LRU and that has active/inactive lists, I don't
think a special mapped/unmapped list makes sense at this point.


-- 
	Three Cheers,
	Balbir
