Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754309Ab1GVNXZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jul 2011 09:23:25 -0400
Received: from cantor2.suse.de ([195.135.220.15]:39870 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754176Ab1GVNXY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jul 2011 09:23:24 -0400
Date: Fri, 22 Jul 2011 14:23:19 +0100
From: Mel Gorman <mgorman@suse.de>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Linux-MM <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>,
        XFS <xfs@oss.sgi.com>, Dave Chinner <david@fromorbit.com>,
        Christoph Hellwig <hch@infradead.org>,
        Johannes Weiner <jweiner@redhat.com>,
        Wu Fengguang <fengguang.wu@intel.com>, Jan Kara <jack@suse.cz>,
        Rik van Riel <riel@redhat.com>, Minchan Kim <minchan.kim@gmail.com>
Subject: Re: [PATCH 7/8] mm: vmscan: Immediately reclaim end-of-LRU dirty
 pages when writeback completes
Message-ID: <20110722132319.GX5349@suse.de>
References: <1311265730-5324-1-git-send-email-mgorman@suse.de>
 <1311265730-5324-8-git-send-email-mgorman@suse.de>
 <1311339228.27400.34.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <1311339228.27400.34.camel@twins>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 22, 2011 at 02:53:48PM +0200, Peter Zijlstra wrote:
> On Thu, 2011-07-21 at 17:28 +0100, Mel Gorman wrote:
> > When direct reclaim encounters a dirty page, it gets recycled around
> > the LRU for another cycle. This patch marks the page PageReclaim
> > similar to deactivate_page() so that the page gets reclaimed almost
> > immediately after the page gets cleaned. This is to avoid reclaiming
> > clean pages that are younger than a dirty page encountered at the
> > end of the LRU that might have been something like a use-once page.
> > 
> 
> > @@ -834,7 +834,15 @@ static unsigned long shrink_page_list(struct list_head *page_list,
> >  			 */
> >  			if (page_is_file_cache(page) &&
> >  					(!current_is_kswapd() || priority >= DEF_PRIORITY - 2)) {
> > -				inc_zone_page_state(page, NR_VMSCAN_WRITE_SKIP);
> > +				/*
> > +				 * Immediately reclaim when written back.
> > +				 * Similar in principal to deactivate_page()
> > +				 * except we already have the page isolated
> > +				 * and know it's dirty
> > +				 */
> > +				inc_zone_page_state(page, NR_VMSCAN_INVALIDATE);
> > +				SetPageReclaim(page);
> > +
> 
> I find the invalidate name somewhat confusing. It makes me think we'll
> drop the page without writeback, like invalidatepage().

I wasn't that happy with it either to be honest but didn't think of a
better one at the time. nr_reclaim_deferred?

-- 
Mel Gorman
SUSE Labs
