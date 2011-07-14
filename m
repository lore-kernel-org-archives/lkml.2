Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753242Ab1GNG3x (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jul 2011 02:29:53 -0400
Received: from cantor2.suse.de ([195.135.220.15]:57556 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752308Ab1GNG3w (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jul 2011 02:29:52 -0400
Date: Thu, 14 Jul 2011 07:29:47 +0100
From: Mel Gorman <mgorman@suse.de>
To: Dave Chinner <david@fromorbit.com>
Cc: Linux-MM <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>,
        XFS <xfs@oss.sgi.com>, Christoph Hellwig <hch@infradead.org>,
        Johannes Weiner <jweiner@redhat.com>,
        Wu Fengguang <fengguang.wu@intel.com>, Jan Kara <jack@suse.cz>,
        Rik van Riel <riel@redhat.com>, Minchan Kim <minchan.kim@gmail.com>
Subject: Re: [PATCH 2/5] mm: vmscan: Do not writeback filesystem pages in
 kswapd except in high priority
Message-ID: <20110714062947.GO7529@suse.de>
References: <1310567487-15367-1-git-send-email-mgorman@suse.de>
 <1310567487-15367-3-git-send-email-mgorman@suse.de>
 <20110713233743.GV23038@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20110713233743.GV23038@dastard>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 14, 2011 at 09:37:43AM +1000, Dave Chinner wrote:
> On Wed, Jul 13, 2011 at 03:31:24PM +0100, Mel Gorman wrote:
> > It is preferable that no dirty pages are dispatched for cleaning from
> > the page reclaim path. At normal priorities, this patch prevents kswapd
> > writing pages.
> > 
> > However, page reclaim does have a requirement that pages be freed
> > in a particular zone. If it is failing to make sufficient progress
> > (reclaiming < SWAP_CLUSTER_MAX at any priority priority), the priority
> > is raised to scan more pages. A priority of DEF_PRIORITY - 3 is
> > considered to tbe the point where kswapd is getting into trouble
> > reclaiming pages. If this priority is reached, kswapd will dispatch
> > pages for writing.
> > 
> > Signed-off-by: Mel Gorman <mgorman@suse.de>
> 
> Seems reasonable, but btrfs still will ignore this writeback from
> kswapd, and it doesn't fall over.

At least there are no reports of it falling over :)

> Given that data point, I'd like to
> see the results when you stop kswapd from doing writeback altogether
> as well.
> 

The results for this test will be identical because the ftrace results
show that kswapd is already writing 0 filesystem pages.

Where it makes a difference is when the system is under enough
pressure that it is failing to reclaim any memory and is in danger
of prematurely triggering the OOM killer. Andrea outlined some of
the concerns before at http://lkml.org/lkml/2010/6/15/246

> Can you try removing it altogether and seeing what that does to your
> test results? i.e
> 
> 			if (page_is_file_cache(page)) {
> 				inc_zone_page_state(page, NR_VMSCAN_WRITE_SKIP);
> 				goto keep_locked;
> 			}

It won't do anything, it'll still be writing 0 filesystem-backed pages.

Because of the possibility for the OOM killer triggering prematurely due
to the inability of kswapd to write pages, I'd prefer to separate such a
change by at least one release so that if there is an increase in OOM
reports, it'll be obvious what was the culprit.

-- 
Mel Gorman
SUSE Labs
