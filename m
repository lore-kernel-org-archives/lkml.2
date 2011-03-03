Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757928Ab1CCIXT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Mar 2011 03:23:19 -0500
Received: from mga02.intel.com ([134.134.136.20]:40252 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753982Ab1CCIR4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Mar 2011 03:17:56 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.62,257,1297065600"; 
   d="scan'208";a="715563054"
Message-Id: <20110303074949.040208949@intel.com>
User-Agent: quilt/0.48-1
Date: Thu, 03 Mar 2011 14:45:08 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
CC: Jan Kara <jack@suse.cz>, Hugh Dickins <hughd@google.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Rik van Riel <riel@redhat.com>, Wu Fengguang <fengguang.wu@intel.com>
CC: Christoph Hellwig <hch@lst.de>
CC: Trond Myklebust <Trond.Myklebust@netapp.com>
CC: Dave Chinner <david@fromorbit.com>
CC: "Theodore Ts'o" <tytso@mit.edu>
CC: Chris Mason <chris.mason@oracle.com>
CC: Mel Gorman <mel@csn.ul.ie>
CC: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
CC: Greg Thelen <gthelen@google.com>
CC: Minchan Kim <minchan.kim@gmail.com>
CC: Vivek Goyal <vgoyal@redhat.com>
CC: Andrea Righi <arighi@develer.com>
CC: Balbir Singh <balbir@linux.vnet.ibm.com>
Cc: linux-mm <linux-mm@kvack.org>
Cc: <linux-fsdevel@vger.kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 03/27] writeback: skip balance_dirty_pages() for in-memory fs
References: <20110303064505.718671603@intel.com>
Content-Disposition: inline; filename=writeback-trace-global-dirty-states-fix.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This avoids unnecessary checks and dirty throttling on tmpfs/ramfs.

It can also prevent

[  388.126563] BUG: unable to handle kernel NULL pointer dereference at 0000000000000050

in the balance_dirty_pages tracepoint, which will call

	dev_name(mapping->backing_dev_info->dev)

but shmem_backing_dev_info.dev is NULL.

Summary notes about the tmpfs/ramfs behavior changes:

As for 2.6.36 and older kernels, the tmpfs writes will sleep inside
balance_dirty_pages() as long as we are over the (dirty+background)/2
global throttle threshold.  This is because both the dirty pages and
threshold will be 0 for tmpfs/ramfs. Hence this test will always
evaluate to TRUE:

                dirty_exceeded =
                        (bdi_nr_reclaimable + bdi_nr_writeback >= bdi_thresh)
                        || (nr_reclaimable + nr_writeback >= dirty_thresh);

For 2.6.37, someone complained that the current logic does not allow the
users to set vm.dirty_ratio=0.  So commit 4cbec4c8b9 changed the test to

                dirty_exceeded =
                        (bdi_nr_reclaimable + bdi_nr_writeback > bdi_thresh)
                        || (nr_reclaimable + nr_writeback > dirty_thresh);

So 2.6.37 will behave differently for tmpfs/ramfs: it will never get
throttled unless the global dirty threshold is exceeded (which is very
unlikely to happen; once happen, will block many tasks).

I'd say that the 2.6.36 behavior is very bad for tmpfs/ramfs. It means
for a busy writing server, tmpfs write()s may get livelocked! The
"inadvertent" throttling can hardly bring help to any workload because
of its "either no throttling, or get throttled to death" property.

So based on 2.6.37, this patch won't bring more noticeable changes.

CC: Hugh Dickins <hughd@google.com>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>
Acked-by: Rik van Riel <riel@redhat.com>
Reviewed-by: Minchan Kim <minchan.kim@gmail.com>
Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
---
 mm/page-writeback.c |   10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

--- linux-next.orig/mm/page-writeback.c	2011-03-03 14:43:37.000000000 +0800
+++ linux-next/mm/page-writeback.c	2011-03-03 14:43:51.000000000 +0800
@@ -244,13 +244,8 @@ void task_dirty_inc(struct task_struct *
 static void bdi_writeout_fraction(struct backing_dev_info *bdi,
 		long *numerator, long *denominator)
 {
-	if (bdi_cap_writeback_dirty(bdi)) {
-		prop_fraction_percpu(&vm_completions, &bdi->completions,
+	prop_fraction_percpu(&vm_completions, &bdi->completions,
 				numerator, denominator);
-	} else {
-		*numerator = 0;
-		*denominator = 1;
-	}
 }
 
 static inline void task_dirties_fraction(struct task_struct *tsk,
@@ -495,6 +490,9 @@ static void balance_dirty_pages(struct a
 	bool dirty_exceeded = false;
 	struct backing_dev_info *bdi = mapping->backing_dev_info;
 
+	if (!bdi_cap_account_dirty(bdi))
+		return;
+
 	for (;;) {
 		struct writeback_control wbc = {
 			.sync_mode	= WB_SYNC_NONE,


