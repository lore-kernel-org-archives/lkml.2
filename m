Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754087Ab0IIJWW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Sep 2010 05:22:22 -0400
Received: from gir.skynet.ie ([193.1.99.77]:35195 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753890Ab0IIJWR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Sep 2010 05:22:17 -0400
Date: Thu, 9 Sep 2010 10:22:03 +0100
From: Mel Gorman <mel@csn.ul.ie>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>, linux-mm@kvack.org,
        linux-fsdevel@vger.kernel.org,
        Linux Kernel List <linux-kernel@vger.kernel.org>,
        Rik van Riel <riel@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>,
        Minchan Kim <minchan.kim@gmail.com>,
        Wu Fengguang <fengguang.wu@intel.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Dave Chinner <david@fromorbit.com>,
        Chris Mason <chris.mason@oracle.com>, Christoph Hellwig <hch@lst.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 05/10] vmscan: Synchrounous lumpy reclaim use
	lock_page() instead trylock_page()
Message-ID: <20100909092203.GL29263@csn.ul.ie>
References: <20100909120448.58acc9a6.kamezawa.hiroyu@jp.fujitsu.com> <20100909121547.2e69735a.kamezawa.hiroyu@jp.fujitsu.com> <20100909131211.C93C.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20100909131211.C93C.A69D9226@jp.fujitsu.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 09, 2010 at 01:13:22PM +0900, KOSAKI Motohiro wrote:
> > On Thu, 9 Sep 2010 12:04:48 +0900
> > KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> wrote:
> > 
> > > On Mon,  6 Sep 2010 11:47:28 +0100
> > > Mel Gorman <mel@csn.ul.ie> wrote:
> > > 
> > > > From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
> > > > 
> > > > With synchrounous lumpy reclaim, there is no reason to give up to reclaim
> > > > pages even if page is locked. This patch uses lock_page() instead of
> > > > trylock_page() in this case.
> > > > 
> > > > Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
> > > > Signed-off-by: Mel Gorman <mel@csn.ul.ie>
> > > 
> > > Reviewed-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> > > 
> > Ah......but can't this change cause dead lock ??
> 
> Yes, this patch is purely crappy. please drop. I guess I was poisoned
> by poisonous mushroom of Mario Bros.
> 

Lets be clear on what the exact dead lock conditions are. The ones I had
thought about when I felt this patch was ok were;

o We are not holding the LRU lock (or any lock, we just called cond_resched())
o We do not have another page locked because we cannot lock multiple pages
o Kswapd will never be in LUMPY_MODE_SYNC so it is not getting blocked
o lock_page() itself is not allocating anything that we could recurse on

One potential dead lock would be if the direct reclaimer held a page
lock and ended up here but is that situation even allowed? I did not
think of an obvious example of when this would happen. Similarly,
deadlock situations with mmap_sem shouldn't happen unless multiple page
locks are being taken.

(prepares to feel foolish)

What did I miss?

-- 
Mel Gorman
Part-time Phd Student                          Linux Technology Center
University of Limerick                         IBM Dublin Software Lab
