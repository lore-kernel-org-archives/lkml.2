Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752295Ab0IMOlI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Sep 2010 10:41:08 -0400
Received: from mga01.intel.com ([192.55.52.88]:58112 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751815Ab0IMOlG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Sep 2010 10:41:06 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.56,359,1280732400"; 
   d="scan'208";a="837187007"
Date: Mon, 13 Sep 2010 22:41:01 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Mel Gorman <mel@csn.ul.ie>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        Linux Kernel List <linux-kernel@vger.kernel.org>,
        Rik van Riel <riel@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>,
        Minchan Kim <minchan.kim@gmail.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Dave Chinner <david@fromorbit.com>,
        Chris Mason <chris.mason@oracle.com>, Christoph Hellwig <hch@lst.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 10/10] vmscan: Kick flusher threads to clean pages when
 reclaim is encountering dirty pages
Message-ID: <20100913144101.GA15130@localhost>
References: <1283770053-18833-1-git-send-email-mel@csn.ul.ie>
 <1283770053-18833-11-git-send-email-mel@csn.ul.ie>
 <20100913134845.GB12355@localhost>
 <20100913141046.GI23508@csn.ul.ie>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100913141046.GI23508@csn.ul.ie>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 13, 2010 at 10:10:46PM +0800, Mel Gorman wrote:
> On Mon, Sep 13, 2010 at 09:48:45PM +0800, Wu Fengguang wrote:
> > > +	/*
> > > +	 * If reclaim is encountering dirty pages, it may be because
> > > +	 * dirty pages are reaching the end of the LRU even though the
> > > +	 * dirty_ratio may be satisified. In this case, wake flusher
> > > +	 * threads to pro-actively clean up to a maximum of
> > > +	 * 4 * SWAP_CLUSTER_MAX amount of data (usually 1/2MB) unless
> > > +	 * !may_writepage indicates that this is a direct reclaimer in
> > > +	 * laptop mode avoiding disk spin-ups
> > > +	 */
> > > +	if (file && nr_dirty_seen && sc->may_writepage)
> > > +		wakeup_flusher_threads(nr_writeback_pages(nr_dirty));
> > 
> > wakeup_flusher_threads() works, but seems not the pertinent one.
> > 
> > - locally, it needs some luck to clean the pages that direct reclaim is waiting on
> 
> There is a certain amount of luck involved but it's depending on there being a
> correlation between old inodes and old pages on the LRU list. As long as that
> correlation is accurate, some relevant pages will get cleaned.  Testing on
> previously released versions of this patch did show that the percentage of
> dirty pages encountered during reclaim were reduced as a result of this patch.

Yup.

> > - globally, it cleans up some dirty pages, however some heavy dirtier
> >   may quickly create new ones..
> > 
> > So how about taking the approaches in these patches?
> > 
> > - "[PATCH 4/4] vmscan: transfer async file writeback to the flusher"
> > - "[PATCH 15/17] mm: lower soft dirty limits on memory pressure"
> > 
> 
> There is a lot going on in those patches. It's going to take me a while to
> figure them out and formulate an opinion.

OK. I also need some time off for doing other works :)

> > In particular the first patch should work very nicely with memcg, as
> > all pages of an inode typically belong to the same memcg. So doing
> > write-around helps clean lots of dirty pages in the target LRU list in
> > one shot.
> > 
> 
> It might but as there is also a correlation between old dirty inodes and
> the location of dirty pages, it is tricky to predict if it is better and
> if so, by how much.

It at least guarantees to clean the one page pageout() is running into :)
Others will depend on the locality/sequentiality of the workload. But
as the write-around pages are in the same LRU lists, the vmscan code
will hit them sooner or later.

Thanks,
Fengguang

