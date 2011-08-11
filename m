Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753682Ab1HKUiL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Aug 2011 16:38:11 -0400
Received: from cantor2.suse.de ([195.135.220.15]:43918 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753023Ab1HKUiJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Aug 2011 16:38:09 -0400
Date: Thu, 11 Aug 2011 21:38:05 +0100
From: Mel Gorman <mgorman@suse.de>
To: Rik van Riel <riel@redhat.com>
Cc: Linux-MM <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>,
        XFS <xfs@oss.sgi.com>, Dave Chinner <david@fromorbit.com>,
        Christoph Hellwig <hch@infradead.org>,
        Johannes Weiner <jweiner@redhat.com>,
        Wu Fengguang <fengguang.wu@intel.com>, Jan Kara <jack@suse.cz>,
        Minchan Kim <minchan.kim@gmail.com>
Subject: Re: [PATCH 5/7] mm: vmscan: Do not writeback filesystem pages in
 kswapd except in high priority
Message-ID: <20110811203805.GC4844@suse.de>
References: <1312973240-32576-1-git-send-email-mgorman@suse.de>
 <1312973240-32576-6-git-send-email-mgorman@suse.de>
 <4E441D0E.6020602@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <4E441D0E.6020602@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 11, 2011 at 02:18:54PM -0400, Rik van Riel wrote:
> On 08/10/2011 06:47 AM, Mel Gorman wrote:
> >It is preferable that no dirty pages are dispatched for cleaning from
> >the page reclaim path. At normal priorities, this patch prevents kswapd
> >writing pages.
> >
> >However, page reclaim does have a requirement that pages be freed
> >in a particular zone. If it is failing to make sufficient progress
> >(reclaiming<  SWAP_CLUSTER_MAX at any priority priority), the priority
> >is raised to scan more pages. A priority of DEF_PRIORITY - 3 is
> >considered to be the point where kswapd is getting into trouble
> >reclaiming pages. If this priority is reached, kswapd will dispatch
> >pages for writing.
> >
> >Signed-off-by: Mel Gorman<mgorman@suse.de>
> >Reviewed-by: Minchan Kim<minchan.kim@gmail.com>
> 
> My only worry with this patch is that maybe we'll burn too
> much CPU time freeing pages from a zone. 

The throttling patch prevents too much CPU being used if pages under
writeback are being encountered during scanning. That said, I shared
your concern and recorded kswapd CPU usage over time.

> However, chances
> are we'll have freed pages from other zones when scanning
> one zone multiple times (the page cache dirty limit is global,
> the clean pages have to be _somewhere_).
> 
> Since the bulk of the allocators are not too picky about
> which zone they get their pages from, I suspect this patch
> will be an overall improvement pretty much all the time.
> 

This is roughly similar to my own reasoning.

I uploaded all the kswapd CPU usage charts to
http://www.csn.ul.ie/~mel/postings/riel-20110811

These are smoothened as the raw figures are barely readable. If you
go through them, you'll see that kswapd CPU usage is sometimes higher
but generally within 2-3%.

> Acked-by: Rik van Riel <riel@redhat.com>

Thanks.

-- 
Mel Gorman
SUSE Labs
