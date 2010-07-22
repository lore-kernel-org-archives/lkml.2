Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757747Ab0GVGUJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jul 2010 02:20:09 -0400
Received: from mga01.intel.com ([192.55.52.88]:18735 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757260Ab0GVGTd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jul 2010 02:19:33 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.55,241,1278313200"; 
   d="scan'208";a="588555496"
Message-Id: <20100722050928.653312535@intel.com>
User-Agent: quilt/0.48-1
Date: Thu, 22 Jul 2010 13:09:28 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
CC: Dave Chinner <david@fromorbit.com>
CC: Christoph Hellwig <hch@infradead.org>
CC: Mel Gorman <mel@csn.ul.ie>
CC: Chris Mason <chris.mason@oracle.com>
CC: Jens Axboe <jens.axboe@oracle.com>
Cc: Wu Fengguang <fengguang.wu@intel.com>, LKML <linux-kernel@vger.kernel.org>
CC: linux-fsdevel@vger.kernel.org
CC: linux-mm@kvack.org
Subject: [PATCH 0/6] [RFC] writeback: try to write older pages first
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew,

The basic way of avoiding pageout() is to make the flusher sync inodes in the
right order. Oldest dirty inodes contains oldest pages. The smaller inode it
is, the more correlation between inode dirty time and its pages' dirty time.
So for small dirty inodes, syncing in the order of inode dirty time is able to
avoid pageout(). If pageout() is still triggered frequently in this case, the
30s dirty expire time may be too long and could be shrinked adaptively; or it
may be a stressed memcg list whose dirty inodes/pages are more hard to track.

For a large dirty inode, it may flush lots of newly dirtied pages _after_
syncing the expired pages. This is the normal case for a single-stream
sequential dirtier, where older pages are in lower offsets.  In this case we
shall not insist on syncing the whole large dirty inode before considering the
other small dirty inodes. This risks wasting time syncing 1GB freshly dirtied
pages before syncing the other N*1MB expired dirty pages who are approaching
the end of the LRU list and hence pageout().

For a large dirty inode, it may also flush lots of newly dirtied pages _before_
hitting the desired old ones, in which case it helps for pageout() to do some
clustered writeback, and/or set mapping->writeback_index to help the flusher
focus on old pages.

For a large dirty inode, it may also have intermixed old and new dirty pages.
In this case we need to make sure the inode is queued for IO before some of
its pages hit pageout(). Adaptive dirty expire time helps here.

OK, end of the vapour ideas. As for this patchset, it fixes the current
kupdate/background writeback priority:

- the kupdate/background writeback shall include newly expired inodes at each
  queue_io() time, as the large inodes left over from previous writeback rounds
  are likely to have less density of old pages.

- the background writeback shall consider expired inodes first, just like the
  kupdate writeback

Thanks,
Fengguang

