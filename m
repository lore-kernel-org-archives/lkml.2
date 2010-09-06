Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751950Ab0IFJQk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Sep 2010 05:16:40 -0400
Received: from cantor.suse.de ([195.135.220.2]:33395 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750914Ab0IFJQi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Sep 2010 05:16:38 -0400
Date: Mon, 6 Sep 2010 11:16:33 +0200
From: Michal Hocko <mhocko@suse.cz>
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Hiroyuki Kamezawa <kamezawa.hiroyuki@gmail.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Kleen, Andi" <andi.kleen@intel.com>,
        Haicheng Li <haicheng.li@linux.intel.com>,
        Christoph Lameter <cl@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Mel Gorman <mel@linux.vnet.ibm.com>
Subject: Re: [PATCH 2/2] Make is_mem_section_removable more conformable
 with offlining code v3
Message-ID: <20100906091633.GA23089@tiehlicka.suse.cz>
References: <20100902143939.GD10265@tiehlicka.suse.cz>
 <20100902150554.GE10265@tiehlicka.suse.cz>
 <20100903121003.e2b8993a.kamezawa.hiroyu@jp.fujitsu.com>
 <20100903121452.2d22b3aa.kamezawa.hiroyu@jp.fujitsu.com>
 <20100903082558.GC10686@tiehlicka.suse.cz>
 <20100903181327.7dad3f84.kamezawa.hiroyu@jp.fujitsu.com>
 <20100903095049.GG10686@tiehlicka.suse.cz>
 <20100903190520.8751aab6.kamezawa.hiroyu@jp.fujitsu.com>
 <20100903114213.GI10686@tiehlicka.suse.cz>
 <20100904025516.GB7788@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100904025516.GB7788@localhost>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat 04-09-10 10:55:16, Wu Fengguang wrote:
> On Fri, Sep 03, 2010 at 07:42:13PM +0800, Michal Hocko wrote:
> 
> > +/*
> > + * A free or LRU pages block are removable
> > + * Do not use MIGRATE_MOVABLE because it can be insufficient and
> > + * other MIGRATE types are tricky.
> > + * Do not hold zone->lock as this is used from user space by the
> > + * sysfs interface.
> > + */
> > +bool is_page_removable(struct page *page)
> > +{
> > +	int page_block = 1 << pageblock_order;
> > +
> > +	/* All pages from the MOVABLE zone are movable */
> > +	if (zone_idx(page_zone(page)) == ZONE_MOVABLE)
> > +		return true;
> > +
> > +	while (page_block > 0) {
> > +		int order = 0;
> > +
> > +		if (pfn_valid_within(page_to_pfn(page))) {
> > +			if (!page_count(page) && PageBuddy(page)) {
> 
> PageBuddy() is true only for the head page and false for all tail
> pages. So when is_page_removable() is given a random 4k page
> (get_any_page() will exactly do that), the above test is not enough.

OK, I haven't noticed that set_migratetype_isolate (which calls
is_page_removable in my patch - bellow) is called from that context.
is_mem_section_removable goes by pageblocks so we are always checking
the head.

Anyway, I can see why you are counting unmovable pages in your patch
now. You need it for notifier logic, so my approach is not usable.

Thanks!
-- 
Michal Hocko
L3 team 
SUSE LINUX s.r.o.
Lihovarska 1060/12
190 00 Praha 9    
Czech Republic
