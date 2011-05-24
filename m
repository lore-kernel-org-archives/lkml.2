Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752969Ab1EXFWM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 May 2011 01:22:12 -0400
Received: from mga14.intel.com ([143.182.124.37]:55892 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752686Ab1EXFV7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 May 2011 01:21:59 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.65,260,1304319600"; 
   d="scan'208";a="354116"
Message-Id: <20110524051859.100100570@intel.com>
User-Agent: quilt/0.48-1
Date: Tue, 24 May 2011 13:14:18 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
cc: Jan Kara <jack@suse.cz>, Mel Gorman <mel@csn.ul.ie>,
        Wu Fengguang <fengguang.wu@intel.com>
cc: Dave Chinner <david@fromorbit.com>
cc: Christoph Hellwig <hch@infradead.org>
cc: <linux-fsdevel@vger.kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 07/18] writeback: refill b_io iff empty
References: <20110524051411.924582719@intel.com>
Content-Disposition: inline; filename=writeback-refill-queue-iff-empty.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is no point to carry different refill policies between for_kupdate
and other type of works. Use a consistent "refill b_io iff empty" policy
which can guarantee fairness in an easy to understand way.

A b_io refill will setup a _fixed_ work set with all currently eligible
inodes and start a new round of walk through b_io. The "fixed" work set
means no new inodes will be added to the work set during the walk.
Only when a complete walk over b_io is done, new inodes that are
eligible at the time will be enqueued and the walk be started over.

This procedure provides fairness among the inodes because it guarantees
each inode to be synced once and only once at each round. So all inodes
will be free from starvations.

This change relies on wb_writeback() to keep retrying as long as we made
some progress on cleaning some pages and/or inodes. Without that ability,
the old logic on background works relies on aggressively queuing all
eligible inodes into b_io at every time. But that's not a guarantee.

The below test script completes a slightly faster now:

             2.6.39-rc3	  2.6.39-rc3-dyn-expire+
------------------------------------------------
all elapsed     256.043      252.367
stddev           24.381       12.530

tar elapsed      30.097       28.808
dd  elapsed      13.214       11.782

	#!/bin/zsh

	cp /c/linux-2.6.38.3.tar.bz2 /dev/shm/

	umount /dev/sda7
	mkfs.xfs -f /dev/sda7
	mount /dev/sda7 /fs

	echo 3 > /proc/sys/vm/drop_caches

	tic=$(cat /proc/uptime|cut -d' ' -f2)

	cd /fs
	time tar jxf /dev/shm/linux-2.6.38.3.tar.bz2 &
	time dd if=/dev/zero of=/fs/zero bs=1M count=1000 &

	wait
	sync
	tac=$(cat /proc/uptime|cut -d' ' -f2)
	echo elapsed: $((tac - tic))

It maintains roughly the same small vs. large file writeout shares, and
offers large files better chances to be written in nice 4M chunks.

Analyzes from Dave Chinner in great details:

Let's say we have lots of inodes with 100 dirty pages being created,
and one large writeback going on. We expire 8 new inodes for every
1024 pages we write back.

With the old code, we do:

	b_more_io (large inode) -> b_io (1l)
	8 newly expired inodes -> b_io (1l, 8s)

	writeback  large inode 1024 pages -> b_more_io

	b_more_io (large inode) -> b_io (8s, 1l)
	8 newly expired inodes -> b_io (8s, 1l, 8s)

	writeback  8 small inodes 800 pages
		   1 large inode 224 pages -> b_more_io

	b_more_io (large inode) -> b_io (8s, 1l)
	8 newly expired inodes -> b_io (8s, 1l, 8s)
	.....

Your new code:

	b_more_io (large inode) -> b_io (1l)
	8 newly expired inodes -> b_io (1l, 8s)

	writeback  large inode 1024 pages -> b_more_io
	(b_io == 8s)
	writeback  8 small inodes 800 pages

	b_io empty: (1800 pages written)
		b_more_io (large inode) -> b_io (1l)
		14 newly expired inodes -> b_io (1l, 14s)

	writeback  large inode 1024 pages -> b_more_io
	(b_io == 14s)
	writeback  10 small inodes 1000 pages
		   1 small inode 24 pages -> b_more_io (1l, 1s(24))
	writeback  5 small inodes 500 pages
	b_io empty: (2548 pages written)
		b_more_io (large inode) -> b_io (1l, 1s(24))
		20 newly expired inodes -> b_io (1l, 1s(24), 20s)
	......

Rough progression of pages written at b_io refill:

Old code:

	total	large file	% of writeback
	1024	224		21.9% (fixed)

New code:
	total	large file	% of writeback
	1800	1024		~55%
	2550	1024		~40%
	3050	1024		~33%
	3500	1024		~29%
	3950	1024		~26%
	4250	1024		~24%
	4500	1024		~22.7%
	4700	1024		~21.7%
	4800	1024		~21.3%
	4800	1024		~21.3%
	(pretty much steady state from here)

Ok, so the steady state is reached with a similar percentage of
writeback to the large file as the existing code. Ok, that's good,
but providing some evidence that is doesn't change the shared of
writeback to the large should be in the commit message ;)

The other advantage to this is that we always write 1024 page chunks
to the large file, rather than smaller "whatever remains" chunks.

CC: Jan Kara <jack@suse.cz>
Acked-by: Mel Gorman <mel@csn.ul.ie>
Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
---
 fs/fs-writeback.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

after + dyn-expire + ioless:
                &(&wb->list_lock)->rlock:          2291           2304           0.15         204.09        3125.12          35315         970712           0.10         223.84     1113437.05
                ------------------------
                &(&wb->list_lock)->rlock              9          [<ffffffff8115dc5d>] inode_wb_list_del+0x5f/0x85
                &(&wb->list_lock)->rlock           1614          [<ffffffff8115da6a>] __mark_inode_dirty+0x173/0x1cf
                &(&wb->list_lock)->rlock            459          [<ffffffff8115d351>] writeback_sb_inodes+0x108/0x154
                &(&wb->list_lock)->rlock            137          [<ffffffff8115cdcf>] writeback_single_inode+0x1b4/0x296
                ------------------------
                &(&wb->list_lock)->rlock              3          [<ffffffff8110c367>] bdi_lock_two+0x46/0x4b
                &(&wb->list_lock)->rlock              6          [<ffffffff8115dc5d>] inode_wb_list_del+0x5f/0x85
                &(&wb->list_lock)->rlock           1160          [<ffffffff8115da6a>] __mark_inode_dirty+0x173/0x1cf
                &(&wb->list_lock)->rlock            435          [<ffffffff8115dcb6>] writeback_inodes_wb+0x33/0x12b

after + dyn-expire:
                &(&wb->list_lock)->rlock:        226820         229719           0.10         194.28      809275.91         327372     1033513685           0.08         476.96  3590929811.61
                ------------------------
                &(&wb->list_lock)->rlock             11          [<ffffffff8115b6d3>] inode_wb_list_del+0x5f/0x85
                &(&wb->list_lock)->rlock          30559          [<ffffffff8115bb1f>] wb_writeback+0x2fb/0x3c3
                &(&wb->list_lock)->rlock          37339          [<ffffffff8115b72c>] writeback_inodes_wb+0x33/0x12b
                &(&wb->list_lock)->rlock          54880          [<ffffffff8115a87f>] writeback_single_inode+0x17f/0x227
                ------------------------
                &(&wb->list_lock)->rlock              3          [<ffffffff8110b606>] bdi_lock_two+0x46/0x4b
                &(&wb->list_lock)->rlock              6          [<ffffffff8115b6d3>] inode_wb_list_del+0x5f/0x85
                &(&wb->list_lock)->rlock          55347          [<ffffffff8115b72c>] writeback_inodes_wb+0x33/0x12b
                &(&wb->list_lock)->rlock          55338          [<ffffffff8115a87f>] writeback_single_inode+0x17f/0x227

--- linux-next.orig/fs/fs-writeback.c	2011-05-24 11:17:18.000000000 +0800
+++ linux-next/fs/fs-writeback.c	2011-05-24 11:17:19.000000000 +0800
@@ -589,7 +589,8 @@ void writeback_inodes_wb(struct bdi_writ
 	if (!wbc->wb_start)
 		wbc->wb_start = jiffies; /* livelock avoidance */
 	spin_lock(&inode_wb_list_lock);
-	if (!wbc->for_kupdate || list_empty(&wb->b_io))
+
+	if (list_empty(&wb->b_io))
 		queue_io(wb, wbc->older_than_this);
 
 	while (!list_empty(&wb->b_io)) {
@@ -616,7 +617,7 @@ static void __writeback_inodes_sb(struct
 	WARN_ON(!rwsem_is_locked(&sb->s_umount));
 
 	spin_lock(&inode_wb_list_lock);
-	if (!wbc->for_kupdate || list_empty(&wb->b_io))
+	if (list_empty(&wb->b_io))
 		queue_io(wb, wbc->older_than_this);
 	writeback_sb_inodes(sb, wb, wbc, true);
 	spin_unlock(&inode_wb_list_lock);


