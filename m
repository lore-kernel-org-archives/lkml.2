Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752956Ab1GMXhr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jul 2011 19:37:47 -0400
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:24346 "EHLO
	ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752401Ab1GMXhq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jul 2011 19:37:46 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AqYCAJsqHk55LCkBgWdsb2JhbABTp0EVAQEWJiXLQg6GLASjQw
Date: Thu, 14 Jul 2011 09:37:43 +1000
From: Dave Chinner <david@fromorbit.com>
To: Mel Gorman <mgorman@suse.de>
Cc: Linux-MM <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>,
        XFS <xfs@oss.sgi.com>, Christoph Hellwig <hch@infradead.org>,
        Johannes Weiner <jweiner@redhat.com>,
        Wu Fengguang <fengguang.wu@intel.com>, Jan Kara <jack@suse.cz>,
        Rik van Riel <riel@redhat.com>, Minchan Kim <minchan.kim@gmail.com>
Subject: Re: [PATCH 2/5] mm: vmscan: Do not writeback filesystem pages in
 kswapd except in high priority
Message-ID: <20110713233743.GV23038@dastard>
References: <1310567487-15367-1-git-send-email-mgorman@suse.de>
 <1310567487-15367-3-git-send-email-mgorman@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1310567487-15367-3-git-send-email-mgorman@suse.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 13, 2011 at 03:31:24PM +0100, Mel Gorman wrote:
> It is preferable that no dirty pages are dispatched for cleaning from
> the page reclaim path. At normal priorities, this patch prevents kswapd
> writing pages.
> 
> However, page reclaim does have a requirement that pages be freed
> in a particular zone. If it is failing to make sufficient progress
> (reclaiming < SWAP_CLUSTER_MAX at any priority priority), the priority
> is raised to scan more pages. A priority of DEF_PRIORITY - 3 is
> considered to tbe the point where kswapd is getting into trouble
> reclaiming pages. If this priority is reached, kswapd will dispatch
> pages for writing.
> 
> Signed-off-by: Mel Gorman <mgorman@suse.de>

Seems reasonable, but btrfs still will ignore this writeback from
kswapd, and it doesn't fall over. Given that data point, I'd like to
see the results when you stop kswapd from doing writeback altogether
as well.

Can you try removing it altogether and seeing what that does to your
test results? i.e

			if (page_is_file_cache(page)) {
				inc_zone_page_state(page, NR_VMSCAN_WRITE_SKIP);
				goto keep_locked;
			}

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
