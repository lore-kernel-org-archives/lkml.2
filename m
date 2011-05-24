Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753003Ab1EXFZt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 May 2011 01:25:49 -0400
Received: from mga01.intel.com ([192.55.52.88]:13626 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751863Ab1EXFVs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 May 2011 01:21:48 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.65,260,1304319600"; 
   d="scan'208";a="7591324"
Message-Id: <20110524051900.458087722@intel.com>
User-Agent: quilt/0.48-1
Date: Tue, 24 May 2011 13:14:29 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
cc: Jan Kara <jack@suse.cz>, Wu Fengguang <fengguang.wu@intel.com>
cc: Dave Chinner <david@fromorbit.com>
cc: Christoph Hellwig <hch@infradead.org>
cc: <linux-fsdevel@vger.kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 18/18] writeback: rearrange the wb_writeback() loop
References: <20110524051411.924582719@intel.com>
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

--- linux-next.orig/fs/fs-writeback.c	2011-05-24 11:17:28.000000000 +0800
+++ linux-next/fs/fs-writeback.c	2011-05-24 11:17:30.000000000 +0800
@@ -713,42 +713,22 @@ static long wb_writeback(struct bdi_writ
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
@@ -778,14 +758,38 @@ retry:
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


