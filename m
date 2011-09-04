Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752874Ab1IDCN0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Sep 2011 22:13:26 -0400
Received: from mga03.intel.com ([143.182.124.21]:25583 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752482Ab1IDCNY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Sep 2011 22:13:24 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.68,326,1312182000"; 
   d="scan'208";a="45377059"
Message-Id: <20110904015305.367445271@intel.com>
User-Agent: quilt/0.48-1
Date: Sun, 04 Sep 2011 09:53:05 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
to: <linux-fsdevel@vger.kernel.org>
cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
cc: Andrew Morton <akpm@linux-foundation.org>
CC: Jan Kara <jack@suse.cz>
CC: Christoph Hellwig <hch@lst.de>
CC: Dave Chinner <david@fromorbit.com>
CC: Greg Thelen <gthelen@google.com>
CC: Minchan Kim <minchan.kim@gmail.com>
CC: Vivek Goyal <vgoyal@redhat.com>
CC: Andrea Righi <arighi@develer.com>
Cc: linux-mm <linux-mm@kvack.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Cc: Wu Fengguang <fengguang.wu@intel.com>
Subject: [PATCH 00/18] IO-less dirty throttling v11 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Finally, the complete IO-less balance_dirty_pages(). NFS is observed to perform
better or worse depending on the memory size. Otherwise the added patches can
address all known regressions.

        git://git.kernel.org/pub/scm/linux/kernel/git/wfg/writeback.git dirty-throttling-v11
	(to be updated; currently it contains a pre-release v11)

Changes since v10:

- complete the renames
- add protections for IO queue underrun
  - pause time reduction
  - bdi reserve area
  - bdi underrun flag
- more accurate task dirty accounting for
  - sub-page writes
  - FS re-dirties
  - short lived tasks

Changes since v9:

- a lot of renames and comment/changelog rework, again
- seperate out the dirty_ratelimit update policy (as patch 04)
- add think time compensation
- add 3 trace events

Changes since v8:

- a lot of renames and comment/changelog rework
- use 3rd order polynomial as the global control line (Peter)
- stabilize dirty_ratelimit by decreasing update step size on small errors
- limit per-CPU dirtied pages to avoid dirty pages run away on 1k+ tasks (Peter)

Thanks a lot to Peter, Vivek, Andrea and Jan for the careful reviews!

shortlog:

	Wu Fengguang (18):
	      writeback: account per-bdi accumulated dirtied pages
	      writeback: dirty position control
	      writeback: dirty rate control
	      writeback: stabilize bdi->dirty_ratelimit
	      writeback: per task dirty rate limit
	      writeback: IO-less balance_dirty_pages()
	      writeback: dirty ratelimit - think time compensation
	      writeback: trace dirty_ratelimit
	      writeback: trace balance_dirty_pages
	      writeback: dirty position control - bdi reserve area
	      block: add bdi flag to indicate risk of io queue underrun
	      writeback: balanced_rate cannot exceed write bandwidth
	      writeback: limit max dirty pause time
	      writeback: control dirty pause time
	      writeback: charge leaked page dirties to active tasks
	      writeback: fix dirtied pages accounting on sub-page writes
	      writeback: fix dirtied pages accounting on redirty
	      btrfs: fix dirtied pages accounting on sub-page writes

diffstat:

	 block/blk-core.c                 |    7 
	 fs/btrfs/file.c                  |    3 
	 fs/fs-writeback.c                |    2 
	 include/linux/backing-dev.h      |   26 
	 include/linux/blkdev.h           |   12 
	 include/linux/sched.h            |    8 
	 include/linux/writeback.h        |    5 
	 include/trace/events/writeback.h |  151 ++++-
	 kernel/exit.c                    |    2 
	 kernel/fork.c                    |    4 
	 mm/backing-dev.c                 |    3 
	 mm/page-writeback.c              |  768 +++++++++++++++++++++++------
	 12 files changed, 816 insertions(+), 175 deletions(-)

Thanks,
Fengguang

