Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756736Ab1EKQCv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 May 2011 12:02:51 -0400
Received: from mga11.intel.com ([192.55.52.93]:65192 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755978Ab1EKQCt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 May 2011 12:02:49 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.64,353,1301900400"; 
   d="scan'208";a="311843"
Date: Wed, 11 May 2011 22:38:07 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Jan Kara <jack@suse.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Dave Chinner <david@fromorbit.com>,
        Christoph Hellwig <hch@infradead.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>
Subject: Re: [PATCH 14/17] writeback: make writeback_control.nr_to_write
 straight
Message-ID: <20110511143807.GA28435@localhost>
References: <20110506030821.523093711@intel.com>
 <20110506031613.556854231@intel.com>
 <20110509165458.GV4122@quack.suse.cz>
 <20110510031939.GE6758@localhost>
 <20110510134406.GG4402@quack.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110510134406.GG4402@quack.suse.cz>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>   One more thing that I've noticed while looking through this patch: You
> are removing several trace points (without actually removing the trace
> point definitions BTW):
> trace_wbc_writeback_start(&wbc, wb->bdi);
> trace_wbc_writeback_written(&wbc, wb->bdi);
> trace_wbc_writeback_wait(&wbc, wb->bdi);
> trace_wbc_balance_dirty_start(&wbc, bdi);
> trace_wbc_balance_dirty_written(&wbc, bdi);
> trace_wbc_balance_dirty_wait(&wbc, bdi);
> 
> I guess they should be replaced with equivalent trace points that take
> struct wb_writeback_work as an argument instead of just removing them?

OK. How about this change?

---
 fs/fs-writeback.c                |    3 ++
 include/trace/events/writeback.h |   33 +++++++++++++++++++++++------
 mm/page-writeback.c              |    3 ++
 3 files changed, 33 insertions(+), 6 deletions(-)

--- linux-next.orig/fs/fs-writeback.c	2011-05-11 22:19:22.000000000 +0800
+++ linux-next/fs/fs-writeback.c	2011-05-11 22:20:50.000000000 +0800
@@ -731,6 +731,7 @@ static long wb_writeback(struct bdi_writ
 		}
 
 retry:
+		trace_writeback_start(wb->bdi, work);
 		spin_lock(&wb->list_lock);
 		if (list_empty(&wb->b_io))
 			queue_io(wb, work->older_than_this);
@@ -739,6 +740,7 @@ retry:
 		else
 			progress = __writeback_inodes_wb(wb, work);
 		spin_unlock(&wb->list_lock);
+		trace_writeback_written(wb->bdi, work);
 
 		/*
 		 * Did we write something? Try for more
@@ -775,6 +777,7 @@ retry:
 		 */
 		spin_lock(&wb->list_lock);
 		if (!list_empty(&wb->b_more_io))  {
+			trace_writeback_wait(wb->bdi, work);
 			inode = wb_inode(wb->b_more_io.prev);
 			spin_lock(&inode->i_lock);
 			inode_wait_for_writeback(inode, wb);
--- linux-next.orig/mm/page-writeback.c	2011-05-11 22:19:22.000000000 +0800
+++ linux-next/mm/page-writeback.c	2011-05-11 22:20:50.000000000 +0800
@@ -555,14 +555,17 @@ static void balance_dirty_pages(struct a
 		 * threshold otherwise wait until the disk writes catch
 		 * up.
 		 */
+		trace_balance_dirty_start(bdi);
 		if (bdi_nr_reclaimable > bdi_thresh) {
 			pages_written += writeback_inodes_wb(&bdi->wb,
 							     write_chunk);
+			trace_balance_dirty_written(bdi, pages_written);
 			if (pages_written >= write_chunk)
 				break;		/* We've done our duty */
 		}
 		__set_current_state(TASK_UNINTERRUPTIBLE);
 		io_schedule_timeout(pause);
+		trace_balance_dirty_wait(bdi);
 
 		/*
 		 * Increase the delay for each loop, up to our previous
--- linux-next.orig/include/trace/events/writeback.h	2011-05-11 22:19:22.000000000 +0800
+++ linux-next/include/trace/events/writeback.h	2011-05-11 22:22:20.000000000 +0800
@@ -49,6 +49,9 @@ DEFINE_EVENT(writeback_work_class, name,
 DEFINE_WRITEBACK_WORK_EVENT(writeback_nothread);
 DEFINE_WRITEBACK_WORK_EVENT(writeback_queue);
 DEFINE_WRITEBACK_WORK_EVENT(writeback_exec);
+DEFINE_WRITEBACK_WORK_EVENT(writeback_start);
+DEFINE_WRITEBACK_WORK_EVENT(writeback_written);
+DEFINE_WRITEBACK_WORK_EVENT(writeback_wait);
 
 TRACE_EVENT(writeback_pages_written,
 	TP_PROTO(long pages_written),
@@ -88,6 +91,30 @@ DEFINE_WRITEBACK_EVENT(writeback_bdi_reg
 DEFINE_WRITEBACK_EVENT(writeback_bdi_unregister);
 DEFINE_WRITEBACK_EVENT(writeback_thread_start);
 DEFINE_WRITEBACK_EVENT(writeback_thread_stop);
+DEFINE_WRITEBACK_EVENT(balance_dirty_start);
+DEFINE_WRITEBACK_EVENT(balance_dirty_wait);
+
+TRACE_EVENT(balance_dirty_written,
+
+	TP_PROTO(struct backing_dev_info *bdi, int written),
+
+	TP_ARGS(bdi, written),
+
+	TP_STRUCT__entry(
+		__array(char,	name, 32)
+		__field(int,	written)
+	),
+
+	TP_fast_assign(
+		strncpy(__entry->name, dev_name(bdi->dev), 32);
+		__entry->written = written;
+	),
+
+	TP_printk("bdi %s written %d",
+		  __entry->name,
+		  __entry->written
+	)
+);
 
 DECLARE_EVENT_CLASS(wbc_class,
 	TP_PROTO(struct writeback_control *wbc, struct backing_dev_info *bdi),
@@ -137,12 +164,6 @@ DECLARE_EVENT_CLASS(wbc_class,
 DEFINE_EVENT(wbc_class, name, \
 	TP_PROTO(struct writeback_control *wbc, struct backing_dev_info *bdi), \
 	TP_ARGS(wbc, bdi))
-DEFINE_WBC_EVENT(wbc_writeback_start);
-DEFINE_WBC_EVENT(wbc_writeback_written);
-DEFINE_WBC_EVENT(wbc_writeback_wait);
-DEFINE_WBC_EVENT(wbc_balance_dirty_start);
-DEFINE_WBC_EVENT(wbc_balance_dirty_written);
-DEFINE_WBC_EVENT(wbc_balance_dirty_wait);
 DEFINE_WBC_EVENT(wbc_writepage);
 
 DECLARE_EVENT_CLASS(writeback_congest_waited_template,
