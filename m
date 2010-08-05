Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760451Ab0HEQ3P (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Aug 2010 12:29:15 -0400
Received: from mga01.intel.com ([192.55.52.88]:56292 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760206Ab0HEQ3H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Aug 2010 12:29:07 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.55,323,1278313200"; 
   d="scan'208";a="593284684"
Message-Id: <20100805162434.385571675@intel.com>
User-Agent: quilt/0.48-1
Date: Fri, 06 Aug 2010 00:11:03 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Wu Fengguang <fengguang.wu@intel.com>, LKML <linux-kernel@vger.kernel.org>
CC: Dave Chinner <david@fromorbit.com>, Christoph Hellwig <hch@infradead.org>,
        Mel Gorman <mel@csn.ul.ie>, Chris Mason <chris.mason@oracle.com>,
        Jens Axboe <axboe@kernel.dk>, Jan Kara <jack@suse.cz>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>
Subject: [PATCH 12/13] writeback: try more writeback as long as something was written
References: <20100805161051.501816677@intel.com>
Content-Disposition: inline; filename=writeback-background-retry.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

writeback_inodes_wb()/__writeback_inodes_sb() are not aggressive in that
they only populate b_io when necessary at entrance time. When the queued
set of inodes are all synced, they just return, possibly with
wbc.nr_to_write > 0.

For kupdate and background writeback, there may be more eligible inodes
sitting in b_dirty when the current set of b_io inodes are completed. So
it is necessary to try another round of writeback as long as we made some
progress in this round. When there are no more eligible inodes, no more
inodes will be enqueued in queue_io(), hence nothing could/will be
synced and we may safely bail.

Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
---
 fs/fs-writeback.c |   19 +++++++++++--------
 1 file changed, 11 insertions(+), 8 deletions(-)

--- linux-next.orig/fs/fs-writeback.c	2010-08-05 23:30:27.000000000 +0800
+++ linux-next/fs/fs-writeback.c	2010-08-05 23:30:45.000000000 +0800
@@ -654,20 +654,23 @@ static long wb_writeback(struct bdi_writ
 		wrote += MAX_WRITEBACK_PAGES - wbc.nr_to_write;
 
 		/*
-		 * If we consumed everything, see if we have more
+		 * Did we write something? Try for more
+		 *
+		 * This is needed _before_ the b_more_io test because the
+		 * background writeback moves inodes to b_io and works on
+		 * them in batches (in order to sync old pages first).  The
+		 * completion of the current batch does not necessarily mean
+		 * the overall work is done.
 		 */
-		if (wbc.nr_to_write <= 0)
+		if (wbc.nr_to_write < MAX_WRITEBACK_PAGES)
 			continue;
+
 		/*
-		 * Didn't write everything and we don't have more IO, bail
+		 * Nothing written and no more inodes for IO, bail
 		 */
 		if (list_empty(&wb->b_more_io))
 			break;
-		/*
-		 * Did we write something? Try for more
-		 */
-		if (wbc.nr_to_write < MAX_WRITEBACK_PAGES)
-			continue;
+
 		/*
 		 * Nothing written. Wait for some inode to
 		 * become available for writeback. Otherwise


