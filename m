Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753033Ab1GMXmJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jul 2011 19:42:09 -0400
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:3984 "EHLO
	ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751395Ab1GMXl7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jul 2011 19:41:59 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AqYCAJsqHk55LCkBgWdsb2JhbABTp0EVAQEWJiXLQg6DJ4MFBKND
Date: Thu, 14 Jul 2011 09:41:50 +1000
From: Dave Chinner <david@fromorbit.com>
To: Mel Gorman <mgorman@suse.de>
Cc: Linux-MM <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>,
        XFS <xfs@oss.sgi.com>, Christoph Hellwig <hch@infradead.org>,
        Johannes Weiner <jweiner@redhat.com>,
        Wu Fengguang <fengguang.wu@intel.com>, Jan Kara <jack@suse.cz>,
        Rik van Riel <riel@redhat.com>, Minchan Kim <minchan.kim@gmail.com>
Subject: Re: [PATCH 3/5] mm: vmscan: Throttle reclaim if encountering too
 many dirty pages under writeback
Message-ID: <20110713234150.GW23038@dastard>
References: <1310567487-15367-1-git-send-email-mgorman@suse.de>
 <1310567487-15367-4-git-send-email-mgorman@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1310567487-15367-4-git-send-email-mgorman@suse.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 13, 2011 at 03:31:25PM +0100, Mel Gorman wrote:
> Workloads that are allocating frequently and writing files place a
> large number of dirty pages on the LRU. With use-once logic, it is
> possible for them to reach the end of the LRU quickly requiring the
> reclaimer to scan more to find clean pages. Ordinarily, processes that
> are dirtying memory will get throttled by dirty balancing but this
> is a global heuristic and does not take into account that LRUs are
> maintained on a per-zone basis. This can lead to a situation whereby
> reclaim is scanning heavily, skipping over a large number of pages
> under writeback and recycling them around the LRU consuming CPU.
> 
> This patch checks how many of the number of pages isolated from the
> LRU were dirty. If a percentage of them are dirty, the process will be
> throttled if a blocking device is congested or the zone being scanned
> is marked congested. The percentage that must be dirty depends on
> the priority. At default priority, all of them must be dirty. At
> DEF_PRIORITY-1, 50% of them must be dirty, DEF_PRIORITY-2, 25%
> etc. i.e.  as pressure increases the greater the likelihood the process
> will get throttled to allow the flusher threads to make some progress.

It still doesn't take into account how many pages under writeback
were skipped. If there are lots of pages that are under writeback, I
think we still want to throttle to give IO a chance to complete and
clean those pages before scanning again....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
