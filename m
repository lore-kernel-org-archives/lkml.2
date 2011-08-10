Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753565Ab1HJMlN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Aug 2011 08:41:13 -0400
Received: from mx1.redhat.com ([209.132.183.28]:64083 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753043Ab1HJMlM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Aug 2011 08:41:12 -0400
Date: Wed, 10 Aug 2011 14:40:34 +0200
From: Johannes Weiner <jweiner@redhat.com>
To: Mel Gorman <mgorman@suse.de>
Cc: Linux-MM <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>,
        XFS <xfs@oss.sgi.com>, Dave Chinner <david@fromorbit.com>,
        Christoph Hellwig <hch@infradead.org>,
        Wu Fengguang <fengguang.wu@intel.com>, Jan Kara <jack@suse.cz>,
        Rik van Riel <riel@redhat.com>, Minchan Kim <minchan.kim@gmail.com>
Subject: Re: [PATCH 1/7] mm: vmscan: Do not writeback filesystem pages in
 direct reclaim
Message-ID: <20110810124034.GA24133@redhat.com>
References: <1312973240-32576-1-git-send-email-mgorman@suse.de>
 <1312973240-32576-2-git-send-email-mgorman@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1312973240-32576-2-git-send-email-mgorman@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 10, 2011 at 11:47:14AM +0100, Mel Gorman wrote:
> From: Mel Gorman <mel@csn.ul.ie>
> 
> When kswapd is failing to keep zones above the min watermark, a process
> will enter direct reclaim in the same manner kswapd does. If a dirty
> page is encountered during the scan, this page is written to backing
> storage using mapping->writepage.
> 
> This causes two problems. First, it can result in very deep call
> stacks, particularly if the target storage or filesystem are complex.
> Some filesystems ignore write requests from direct reclaim as a result.
> The second is that a single-page flush is inefficient in terms of IO.
> While there is an expectation that the elevator will merge requests,
> this does not always happen. Quoting Christoph Hellwig;
> 
> 	The elevator has a relatively small window it can operate on,
> 	and can never fix up a bad large scale writeback pattern.
> 
> This patch prevents direct reclaim writing back filesystem pages by
> checking if current is kswapd. Anonymous pages are still written to
> swap as there is not the equivalent of a flusher thread for anonymous
> pages. If the dirty pages cannot be written back, they are placed
> back on the LRU lists. There is now a direct dependency on dirty page
> balancing to prevent too many pages in the system being dirtied which
> would prevent reclaim making forward progress.
> 
> Signed-off-by: Mel Gorman <mgorman@suse.de>
> Reviewed-by: Minchan Kim <minchan.kim@gmail.com>

Acked-by: Johannes Weiner <jweiner@redhat.com>
