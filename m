Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756718Ab1JTPjh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Oct 2011 11:39:37 -0400
Received: from mga03.intel.com ([143.182.124.21]:27426 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756440Ab1JTPiI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Oct 2011 11:38:08 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.69,379,1315206000"; 
   d="scan'208";a="64588843"
Message-Id: <20111020153706.009762650@intel.com>
User-Agent: quilt/0.48-1
Date: Thu, 20 Oct 2011 23:22:43 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
to: <linux-fsdevel@vger.kernel.org>
cc: Jan Kara <jack@suse.cz>, Dave Chinner <david@fromorbit.com>,
        Christoph Hellwig <hch@infradead.org>,
        Wu Fengguang <fengguang.wu@intel.com>
cc: Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 3/7] writeback: update wb->last_active on written pages/inodes
References: <20111020152240.751936131@intel.com>
Content-Disposition: inline; filename=writeback-progress
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jan Kara <jack@suse.cz>

The writeback last_active value should be updated on not only written
pages, but also cleaned inodes.

Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
---
 fs/fs-writeback.c |   13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

--- linux-next.orig/fs/fs-writeback.c	2011-10-20 21:39:48.000000000 +0800
+++ linux-next/fs/fs-writeback.c	2011-10-20 22:36:59.000000000 +0800
@@ -744,6 +744,7 @@ static long wb_writeback(struct bdi_writ
 	unsigned long oldest_jif;
 	struct inode *inode;
 	long progress;
+	long total_progress = 0;
 
 	oldest_jif = jiffies;
 	work->older_than_this = &oldest_jif;
@@ -787,6 +788,7 @@ static long wb_writeback(struct bdi_writ
 		else
 			progress = __writeback_inodes_wb(wb, work);
 		trace_writeback_written(wb->bdi, work);
+		total_progress += progress;
 
 		wb_update_bandwidth(wb, wb_start);
 
@@ -820,7 +822,8 @@ static long wb_writeback(struct bdi_writ
 	}
 	spin_unlock(&wb->list_lock);
 
-	return nr_pages - work->nr_pages;
+	trace_writeback_pages_written(nr_pages - work->nr_pages);
+	return total_progress;
 }
 
 /*
@@ -954,7 +957,7 @@ int bdi_writeback_thread(void *data)
 {
 	struct bdi_writeback *wb = data;
 	struct backing_dev_info *bdi = wb->bdi;
-	long pages_written;
+	long progress;
 
 	current->flags |= PF_SWAPWRITE;
 	set_freezable();
@@ -974,11 +977,9 @@ int bdi_writeback_thread(void *data)
 		 */
 		del_timer(&wb->wakeup_timer);
 
-		pages_written = wb_do_writeback(wb, 0);
-
-		trace_writeback_pages_written(pages_written);
+		progress = wb_do_writeback(wb, 0);
 
-		if (pages_written)
+		if (progress)
 			wb->last_active = jiffies;
 
 		set_current_state(TASK_INTERRUPTIBLE);


