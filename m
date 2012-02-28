Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965050Ab2B1O4V (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Feb 2012 09:56:21 -0500
Received: from mga14.intel.com ([143.182.124.37]:7490 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755200Ab2B1O4T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Feb 2012 09:56:19 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="112219196"
Message-Id: <20120228140022.614718843@intel.com>
User-Agent: quilt/0.51-1
Date: Tue, 28 Feb 2012 22:00:22 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
CC: Greg Thelen <gthelen@google.com>, Jan Kara <jack@suse.cz>,
        Ying Han <yinghan@google.com>,
        "hannes@cmpxchg.org" <hannes@cmpxchg.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Rik van Riel <riel@redhat.com>
cc: Linux Memory Management List <linux-mm@kvack.org>
Cc: Fengguang Wu <fengguang.wu@intel.com>, LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 0/9] [RFC] pageout work and dirty reclaim throttling
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew,

This aims to improve two major page reclaim problems

a) pageout I/O efficiency, by sending pageout work to the flusher
b) interactive performance, by selectively throttle the writing tasks

when under heavy pressure of dirty/writeback pages. The tests results for 1)
and 2) look promising and are included in patches 6 and 9.

However there are still two open problems.

1) ext4 "hung task" problem, as put by Jan Kara:

: We enter memcg reclaim from grab_cache_page_write_begin() and are
: waiting in reclaim_wait(). Because grab_cache_page_write_begin() is
: called with transaction started, this blocks transaction from
: committing and subsequently blocks all other activity on the
: filesystem. The fact is this isn't new with your patches, just your
: changes or the fact that we are running in a memory constrained cgroup
: make this more visible.

2) the pageout work may be deferred by sync work

Like 1), there is also no obvious good way out. The closest fix may be to
service some pageout works each time the other work finishes with one inode.
But problem is, the sync work does not limit chunk size at all. So it's
possible for sync to work on one inode for 1 minute before giving the pageout
works a chance...

Due to problems (1) and (2), it's still not a complete solution. For ease of
debug, several trace_printk() and debugfs interfaces are included for now.

 [PATCH 1/9] memcg: add page_cgroup flags for dirty page tracking
 [PATCH 2/9] memcg: add dirty page accounting infrastructure
 [PATCH 3/9] memcg: add kernel calls for memcg dirty page stats
 [PATCH 4/9] memcg: dirty page accounting support routines
 [PATCH 5/9] writeback: introduce the pageout work
 [PATCH 6/9] vmscan: dirty reclaim throttling
 [PATCH 7/9] mm: pass __GFP_WRITE to memcg charge and reclaim routines
 [PATCH 8/9] mm: dont set __GFP_WRITE on ramfs/sysfs writes                                                  
 [PATCH 9/9] mm: debug vmscan waits

 fs/fs-writeback.c                |  230 +++++++++++++++++++++-
 fs/nfs/write.c                   |    4 
 fs/super.c                       |    1 
 include/linux/backing-dev.h      |    2 
 include/linux/gfp.h              |    2 
 include/linux/memcontrol.h       |   13 +
 include/linux/mmzone.h           |    1 
 include/linux/page_cgroup.h      |   23 ++
 include/linux/sched.h            |    1 
 include/linux/writeback.h        |   18 +
 include/trace/events/vmscan.h    |   68 ++++++
 include/trace/events/writeback.h |   12 -
 mm/backing-dev.c                 |   10 
 mm/filemap.c                     |   20 +
 mm/internal.h                    |    7 
 mm/memcontrol.c                  |  199 ++++++++++++++++++-
 mm/migrate.c                     |    3 
 mm/page-writeback.c              |    6 
 mm/page_alloc.c                  |    1 
 mm/swap.c                        |    4 
 mm/truncate.c                    |    1 
 mm/vmscan.c                      |  298 ++++++++++++++++++++++++++---
 22 files changed, 864 insertions(+), 60 deletions(-)

Thanks,
Fengguang

