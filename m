Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752655Ab1EXFVz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 May 2011 01:21:55 -0400
Received: from mga09.intel.com ([134.134.136.24]:22560 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751966Ab1EXFVt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 May 2011 01:21:49 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.65,260,1304319600"; 
   d="scan'208";a="3755227"
Message-Id: <20110524051859.717245396@intel.com>
User-Agent: quilt/0.48-1
Date: Tue, 24 May 2011 13:14:23 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
cc: Jan Kara <jack@suse.cz>, Hugh Dickins <hughd@google.com>,
        Rik van Riel <riel@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Wu Fengguang <fengguang.wu@intel.com>
cc: Dave Chinner <david@fromorbit.com>
cc: Christoph Hellwig <hch@infradead.org>
cc: <linux-fsdevel@vger.kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 12/18] writeback: skip balance_dirty_pages() for in-memory fs
References: <20110524051411.924582719@intel.com>
Content-Disposition: inline; filename=writeback-trace-global-dirty-states-fix.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This avoids unnecessary checks and dirty throttling on tmpfs/ramfs.

Notes about the tmpfs/ramfs behavior changes:

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
Acked-by: Rik van Riel <riel@redhat.com>
Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Reviewed-by: Minchan Kim <minchan.kim@gmail.com>
Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
---
 mm/page-writeback.c |   10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

--- linux-next.orig/mm/page-writeback.c	2011-05-24 11:17:23.000000000 +0800
+++ linux-next/mm/page-writeback.c	2011-05-24 11:17:24.000000000 +0800
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


