Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756024Ab1JCNqB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Oct 2011 09:46:01 -0400
Received: from mga03.intel.com ([143.182.124.21]:61846 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753649Ab1JCNpy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Oct 2011 09:45:54 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.68,479,1312182000"; 
   d="scan'208";a="58158709"
Message-Id: <20111003134228.090592370@intel.com>
User-Agent: quilt/0.48-1
Date: Mon, 03 Oct 2011 21:42:28 +0800
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
Subject: [PATCH 00/11] IO-less dirty throttling v12 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This is the minimal IO-less balance_dirty_pages() changes that are expected to
be regression free (well, except for NFS).

        git://github.com/fengguang/linux.git dirty-throttling-v12

Tests results will be posted in a separate email.

Changes since v11:

- improve bdi reserve area parameters (based on test results)
- drop bdi underrun flag
- drop aux bdi control line
- make bdi->dirty_ratelimit more stable

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

Wu Fengguang (11):
      writeback: account per-bdi accumulated dirtied pages
      writeback: dirty position control
      writeback: add bg_threshold parameter to __bdi_update_bandwidth()
      writeback: dirty rate control
      writeback: stabilize bdi->dirty_ratelimit
      writeback: per task dirty rate limit
      writeback: IO-less balance_dirty_pages()
      writeback: limit max dirty pause time
      writeback: control dirty pause time
      writeback: dirty position control - bdi reserve area
      writeback: per-bdi background threshold

diffstat:

 fs/fs-writeback.c                |   19 +-
 include/linux/backing-dev.h      |   11 +
 include/linux/sched.h            |    7 +
 include/linux/writeback.h        |    1 +
 include/trace/events/writeback.h |   24 --
 kernel/fork.c                    |    3 +
 mm/backing-dev.c                 |    4 +
 mm/page-writeback.c              |  678 +++++++++++++++++++++++++++++---------
 8 files changed, 566 insertions(+), 181 deletions(-)

Thanks,
Fengguang

