Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756687Ab1JTPk1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Oct 2011 11:40:27 -0400
Received: from mga03.intel.com ([143.182.124.21]:52461 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756436Ab1JTPiI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Oct 2011 11:38:08 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.69,379,1315206000"; 
   d="scan'208";a="64588841"
Message-Id: <20111020153706.134518256@intel.com>
User-Agent: quilt/0.48-1
Date: Thu, 20 Oct 2011 23:22:44 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
to: <linux-fsdevel@vger.kernel.org>
cc: Jan Kara <jack@suse.cz>, Dave Chinner <david@fromorbit.com>,
        Christoph Hellwig <hch@infradead.org>,
        Wu Fengguang <fengguang.wu@intel.com>
cc: Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 4/7] writeback: Retry kupdate work early if we need to retry some inode writeback
References: <20111020152240.751936131@intel.com>
Content-Disposition: inline; filename=0001-writeback-Retry-kupdate-work-early-if-we-need-to-ret.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jan Kara <jack@suse.cz>

In case we could not do any writeback for some inodes, trigger next kupdate
work early so that writeback on these inodes is not delayed for the whole
dirty_writeback_interval.

Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
---
 fs/fs-writeback.c |   17 +++++++++++++----
 1 file changed, 13 insertions(+), 4 deletions(-)

--- linux-next.orig/fs/fs-writeback.c	2011-10-20 22:36:59.000000000 +0800
+++ linux-next/fs/fs-writeback.c	2011-10-20 22:42:24.000000000 +0800
@@ -886,7 +886,7 @@ static long wb_check_old_data_flush(stru
 
 	expired = wb->last_old_flush +
 			msecs_to_jiffies(dirty_writeback_interval * 10);
-	if (time_before(jiffies, expired))
+	if (time_before(jiffies, expired) && list_empty(&wb->b_more_io_wait))
 		return 0;
 
 	wb->last_old_flush = jiffies;
@@ -958,6 +958,10 @@ int bdi_writeback_thread(void *data)
 	struct bdi_writeback *wb = data;
 	struct backing_dev_info *bdi = wb->bdi;
 	long progress;
+	unsigned int pause = 1;
+	unsigned int max_pause = dirty_writeback_interval ?
+			msecs_to_jiffies(dirty_writeback_interval * 10) :
+			HZ;
 
 	current->flags |= PF_SWAPWRITE;
 	set_freezable();
@@ -979,8 +983,10 @@ int bdi_writeback_thread(void *data)
 
 		progress = wb_do_writeback(wb, 0);
 
-		if (progress)
+		if (progress) {
 			wb->last_active = jiffies;
+			pause = 1;
+		}
 
 		set_current_state(TASK_INTERRUPTIBLE);
 		if (!list_empty(&bdi->work_list) || kthread_should_stop()) {
@@ -988,8 +994,11 @@ int bdi_writeback_thread(void *data)
 			continue;
 		}
 
-		if (wb_has_dirty_io(wb) && dirty_writeback_interval)
-			schedule_timeout(msecs_to_jiffies(dirty_writeback_interval * 10));
+		if (!list_empty(&wb->b_more_io_wait) && pause < max_pause) {
+			schedule_timeout(pause);
+			pause <<= 1;
+		} else if (wb_has_dirty_io(wb) && dirty_writeback_interval)
+			schedule_timeout(max_pause);
 		else {
 			/*
 			 * We have nothing to do, so can go sleep without any


