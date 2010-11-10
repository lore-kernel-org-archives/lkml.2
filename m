Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754773Ab0KJCpM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Nov 2010 21:45:12 -0500
Received: from mga01.intel.com ([192.55.52.88]:6118 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751901Ab0KJCoy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Nov 2010 21:44:54 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.59,176,1288594800"; 
   d="scan'208";a="625240676"
Message-Id: <20101110024223.565145579@intel.com>
User-Agent: quilt/0.48-1
Date: Wed, 10 Nov 2010 10:35:01 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
cc: Jan Kara <jack@suse.cz>, linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
        Johannes Weiner <hannes@cmpxchg.org>,
        Wu Fengguang <fengguang.wu@intel.com>
cc: Christoph Hellwig <hch@lst.de>, Jan Engelhardt <jengelh@medozas.de>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/5] writeback: integrated background writeback work
References: <20101110023500.404859581@intel.com>
Content-Disposition: inline; filename=writeback-integrated-background-work.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jan Kara <jack@suse.cz>

Check whether background writeback is needed after finishing each work.

When bdi flusher thread finishes doing some work check whether any kind
of background writeback needs to be done (either because
dirty_background_ratio is exceeded or because we need to start flushing
old inodes). If so, just do background write back.

This way, bdi_start_background_writeback() just needs to wake up the
flusher thread. It will do background writeback as soon as there is no
other work.

This is a preparatory patch for the next patch which stops background
writeback as soon as there is other work to do.

Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
---
 fs/fs-writeback.c |   61 +++++++++++++++++++++++++++++++++-----------
 1 file changed, 46 insertions(+), 15 deletions(-)

--- linux-next.orig/fs/fs-writeback.c	2010-11-06 23:55:25.000000000 +0800
+++ linux-next/fs/fs-writeback.c	2010-11-07 21:54:19.000000000 +0800
@@ -84,13 +84,9 @@ static inline struct inode *wb_inode(str
 	return list_entry(head, struct inode, i_wb_list);
 }
 
-static void bdi_queue_work(struct backing_dev_info *bdi,
-		struct wb_writeback_work *work)
+/* Wakeup flusher thread or forker thread to fork it. Requires bdi->wb_lock. */
+static void bdi_wakeup_flusher(struct backing_dev_info *bdi)
 {
-	trace_writeback_queue(bdi, work);
-
-	spin_lock_bh(&bdi->wb_lock);
-	list_add_tail(&work->list, &bdi->work_list);
 	if (bdi->wb.task) {
 		wake_up_process(bdi->wb.task);
 	} else {
@@ -98,15 +94,26 @@ static void bdi_queue_work(struct backin
 		 * The bdi thread isn't there, wake up the forker thread which
 		 * will create and run it.
 		 */
-		trace_writeback_nothread(bdi, work);
 		wake_up_process(default_backing_dev_info.wb.task);
 	}
+}
+
+static void bdi_queue_work(struct backing_dev_info *bdi,
+			   struct wb_writeback_work *work)
+{
+	trace_writeback_queue(bdi, work);
+
+	spin_lock_bh(&bdi->wb_lock);
+	list_add_tail(&work->list, &bdi->work_list);
+	if (!bdi->wb.task)
+		trace_writeback_nothread(bdi, work);
+	bdi_wakeup_flusher(bdi);
 	spin_unlock_bh(&bdi->wb_lock);
 }
 
 static void
 __bdi_start_writeback(struct backing_dev_info *bdi, long nr_pages,
-		bool range_cyclic, bool for_background)
+		      bool range_cyclic)
 {
 	struct wb_writeback_work *work;
 
@@ -126,7 +133,6 @@ __bdi_start_writeback(struct backing_dev
 	work->sync_mode	= WB_SYNC_NONE;
 	work->nr_pages	= nr_pages;
 	work->range_cyclic = range_cyclic;
-	work->for_background = for_background;
 
 	bdi_queue_work(bdi, work);
 }
@@ -144,7 +150,7 @@ __bdi_start_writeback(struct backing_dev
  */
 void bdi_start_writeback(struct backing_dev_info *bdi, long nr_pages)
 {
-	__bdi_start_writeback(bdi, nr_pages, true, false);
+	__bdi_start_writeback(bdi, nr_pages, true);
 }
 
 /**
@@ -152,13 +158,20 @@ void bdi_start_writeback(struct backing_
  * @bdi: the backing device to write from
  *
  * Description:
- *   This does WB_SYNC_NONE background writeback. The IO is only
- *   started when this function returns, we make no guarentees on
- *   completion. Caller need not hold sb s_umount semaphore.
+ *   This makes sure WB_SYNC_NONE background writeback happens. When
+ *   this function returns, it is only guaranteed that for given BDI
+ *   some IO is happening if we are over background dirty threshold.
+ *   Caller need not hold sb s_umount semaphore.
  */
 void bdi_start_background_writeback(struct backing_dev_info *bdi)
 {
-	__bdi_start_writeback(bdi, LONG_MAX, true, true);
+	/*
+	 * We just wake up the flusher thread. It will perform background
+	 * writeback as soon as there is no other work to do.
+	 */
+	spin_lock_bh(&bdi->wb_lock);
+	bdi_wakeup_flusher(bdi);
+	spin_unlock_bh(&bdi->wb_lock);
 }
 
 /*
@@ -707,6 +720,23 @@ get_next_work_item(struct backing_dev_in
 	return work;
 }
 
+static long wb_check_background_flush(struct bdi_writeback *wb)
+{
+	if (over_bground_thresh()) {
+
+		struct wb_writeback_work work = {
+			.nr_pages	= LONG_MAX,
+			.sync_mode	= WB_SYNC_NONE,
+			.for_background	= 1,
+			.range_cyclic	= 1,
+		};
+
+		return wb_writeback(wb, &work);
+	}
+
+	return 0;
+}
+
 static long wb_check_old_data_flush(struct bdi_writeback *wb)
 {
 	unsigned long expired;
@@ -782,6 +812,7 @@ long wb_do_writeback(struct bdi_writebac
 	 * Check for periodic writeback, kupdated() style
 	 */
 	wrote += wb_check_old_data_flush(wb);
+	wrote += wb_check_background_flush(wb);
 	clear_bit(BDI_writeback_running, &wb->bdi->state);
 
 	return wrote;
@@ -868,7 +899,7 @@ void wakeup_flusher_threads(long nr_page
 	list_for_each_entry_rcu(bdi, &bdi_list, bdi_list) {
 		if (!bdi_has_dirty_io(bdi))
 			continue;
-		__bdi_start_writeback(bdi, nr_pages, false, false);
+		__bdi_start_writeback(bdi, nr_pages, false);
 	}
 	rcu_read_unlock();
 }


