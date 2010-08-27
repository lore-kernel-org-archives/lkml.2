Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753938Ab0H0Jhv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Aug 2010 05:37:51 -0400
Received: from gir.skynet.ie ([193.1.99.77]:42274 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753472Ab0H0Jhu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Aug 2010 05:37:50 -0400
Date: Fri, 27 Aug 2010 10:37:35 +0100
From: Mel Gorman <mel@csn.ul.ie>
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Minchan Kim <minchan.kim@gmail.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Christian Ehrhardt <ehrhardt@linux.vnet.ibm.com>,
        Jan Kara <jack@suse.cz>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Li Shaohua <shaohua.li@intel.com>, Rik van Riel <riel@redhat.com>
Subject: Re: [PATCH 3/3] writeback: Do not congestion sleep when there are
	no congested BDIs
Message-ID: <20100827093735.GE19556@csn.ul.ie>
References: <1282835656-5638-1-git-send-email-mel@csn.ul.ie> <1282835656-5638-4-git-send-email-mel@csn.ul.ie> <20100826173843.GD6873@barrios-desktop> <20100826174245.GJ20944@csn.ul.ie> <20100826181735.GB6805@cmpxchg.org> <20100827014254.GD7353@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20100827014254.GD7353@localhost>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 27, 2010 at 09:42:54AM +0800, Wu Fengguang wrote:
> On Fri, Aug 27, 2010 at 02:17:35AM +0800, Johannes Weiner wrote:
> > On Thu, Aug 26, 2010 at 06:42:45PM +0100, Mel Gorman wrote:
> > > On Fri, Aug 27, 2010 at 02:38:43AM +0900, Minchan Kim wrote:
> > > > On Thu, Aug 26, 2010 at 04:14:16PM +0100, Mel Gorman wrote:
> > > > > If congestion_wait() is called with no BDIs congested, the caller will
> > > > > sleep for the full timeout and this is an unnecessary sleep. This patch
> > > > > checks if there are BDIs congested. If so, it goes to sleep as normal.
> > > > > If not, it calls cond_resched() to ensure the caller is not hogging the
> > > > > CPU longer than its quota but otherwise will not sleep.
> > > > > 
> > > > > This is aimed at reducing some of the major desktop stalls reported during
> > > > > IO. For example, while kswapd is operating, it calls congestion_wait()
> > > > > but it could just have been reclaiming clean page cache pages with no
> > > > > congestion. Without this patch, it would sleep for a full timeout but after
> > > > > this patch, it'll just call schedule() if it has been on the CPU too long.
> > > > > Similar logic applies to direct reclaimers that are not making enough
> > > > > progress.
> > > > > 
> > > > > Signed-off-by: Mel Gorman <mel@csn.ul.ie>
> > > > > ---
> > > > >  mm/backing-dev.c |   20 ++++++++++++++------
> > > > >  1 files changed, 14 insertions(+), 6 deletions(-)
> > > > > 
> > > > > diff --git a/mm/backing-dev.c b/mm/backing-dev.c
> > > > > index a49167f..6abe860 100644
> > > > > --- a/mm/backing-dev.c
> > > > > +++ b/mm/backing-dev.c
> > > > 
> > > > Function's decripton should be changed since we don't wait next write any more. 
> > > > 
> > > 
> > > My bad. I need to check that "next write" thing. It doesn't appear to be
> > > happening but maybe that side of things just broke somewhere in the
> > > distant past. I lack context of how this is meant to work so maybe
> > > someone will educate me.
> > 
> > On every retired io request the congestion state on the bdi is checked
> > and the congestion waitqueue woken up.
> > 
> > So without congestion, we still only wait until the next write
> > retires, but without any IO, we sleep the full timeout.
> > 
> > Check __freed_requests() in block/blk-core.c.
> 
> congestion_wait() is tightly related with pageout() and writeback,
> however it may have some intention for the no-IO case as well.
> 
> - if write congested, maybe we are doing too much pageout(), so wait.
>   it might also reduce some get_request_wait() stalls (the normal way
>   is to explicitly check for congestion before doing write out).
> 
> - if any write completes, it may free some PG_reclaim pages, so proceed.
>   (when not congested)
> 

For these cases, would it make sense for wait_iff_congested() to compare
nr_writeback to nr_inactive and decide to wait on congestion if more
than half the inactive list is in writeback?

> - if no IO at all, the 100ms sleep might still prevent a page reclaimer
>   from stealing lots of slices from a busy computing program that
>   involves no page allocation at all.
> 

I don't think this is a very strong arguement because cond_reched() is
being called.

-- 
Mel Gorman
Part-time Phd Student                          Linux Technology Center
University of Limerick                         IBM Dublin Software Lab
