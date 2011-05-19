Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935049Ab1ESV5V (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 May 2011 17:57:21 -0400
Received: from mga09.intel.com ([134.134.136.24]:17849 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935013Ab1ESVyr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 May 2011 17:54:47 -0400
X-ExtLoop1: 1
Message-Id: <20110519214746.536735878@intel.com>
User-Agent: quilt/0.48-1
Date: Fri, 20 May 2011 05:45:48 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
cc: Jan Kara <jack@suse.cz>, Wu Fengguang <fengguang.wu@intel.com>
cc: Dave Chinner <david@fromorbit.com>
cc: Christoph Hellwig <hch@infradead.org>
cc: <linux-fsdevel@vger.kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 18/18] writeback: rearrange the wb_writeback() loop
References: <20110519214530.939830917@intel.com>
Content-Disposition: inline; filename=loop-cleanup
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move the terminate conditions to the end of the loop, and move the
work->older_than_this updates close to each others.

Proposed-by: Dave Chinner <david@fromorbit.com>
Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
---
 fs/fs-writeback.c |   58 +++++++++++++++++++++++---------------------
 1 file changed, 31 insertions(+), 27 deletions(-)

--- linux-next.orig/fs/fs-writeback.c	2011-05-20 05:41:35.000000000 +0800
+++ linux-next/fs/fs-writeback.c	2011-05-20 05:41:36.000000000 +0800
@@ -712,42 +712,22 @@ static long wb_writeback(struct bdi_writ
 	unsigned long oldest_jif;
 	struct inode *inode;
 	long progress;
+	bool bg_retry_all = false;
 
 	oldest_jif = jiffies;
 	work->older_than_this = &oldest_jif;
 
 	spin_lock(&wb->list_lock);
 	for (;;) {
-		/*
-		 * Stop writeback when nr_pages has been consumed
-		 */
-		if (work->nr_pages <= 0)
-			break;
-
-		/*
-		 * Background writeout and kupdate-style writeback may
-		 * run forever. Stop them if there is other work to do
-		 * so that e.g. sync can proceed. They'll be restarted
-		 * after the other works are all done.
-		 */
-		if ((work->for_background || work->for_kupdate) &&
-		    !list_empty(&wb->bdi->work_list))
-			break;
-
-		/*
-		 * For background writeout, stop when we are below the
-		 * background dirty threshold
-		 */
-		if (work->for_background && !over_bground_thresh())
-			break;
-
-		if (work->for_kupdate || work->for_background) {
+		if (bg_retry_all) {
+			bg_retry_all = false;
+			work->older_than_this = NULL;
+		} else if (work->for_kupdate || work->for_background) {
 			oldest_jif = jiffies -
 				msecs_to_jiffies(dirty_expire_interval * 10);
 			work->older_than_this = &oldest_jif;
 		}
 
-retry:
 		trace_writeback_start(wb->bdi, work);
 		if (list_empty(&wb->b_io))
 			queue_io(wb, work->older_than_this);
@@ -777,14 +757,38 @@ retry:
 		    work->older_than_this &&
 		    list_empty(&wb->b_io) &&
 		    list_empty(&wb->b_more_io)) {
-			work->older_than_this = NULL;
-			goto retry;
+			bg_retry_all = true;
+			continue;
 		}
 		/*
 		 * No more inodes for IO, bail
 		 */
 		if (list_empty(&wb->b_more_io))
 			break;
+
+		/*
+		 * Stop writeback when nr_pages has been consumed
+		 */
+		if (work->nr_pages <= 0)
+			break;
+
+		/*
+		 * For background writeout, stop when we are below the
+		 * background dirty threshold
+		 */
+		if (work->for_background && !over_bground_thresh())
+			break;
+
+		/*
+		 * Background writeout and kupdate-style writeback may
+		 * run forever. Stop them if there is other work to do
+		 * so that e.g. sync can proceed. They'll be restarted
+		 * after the other works are all done.
+		 */
+		if ((work->for_background || work->for_kupdate) &&
+		    !list_empty(&wb->bdi->work_list))
+			break;
+
 		/*
 		 * Nothing written. Wait for some inode to
 		 * become available for writeback. Otherwise


