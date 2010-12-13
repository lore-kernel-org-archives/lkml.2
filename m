Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932305Ab0LMGzj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Dec 2010 01:55:39 -0500
Received: from mga09.intel.com ([134.134.136.24]:15833 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752112Ab0LMGtn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Dec 2010 01:49:43 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.59,335,1288594800"; 
   d="scan'208";a="686523132"
Message-Id: <20101213064840.028400662@intel.com>
User-Agent: quilt/0.48-1
Date: Mon, 13 Dec 2010 14:43:14 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
CC: Jan Kara <jack@suse.cz>, Wu Fengguang <fengguang.wu@intel.com>
CC: Christoph Hellwig <hch@lst.de>
CC: Trond Myklebust <Trond.Myklebust@netapp.com>
CC: Dave Chinner <david@fromorbit.com>
CC: "Theodore Ts'o" <tytso@mit.edu>
CC: Chris Mason <chris.mason@oracle.com>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: Mel Gorman <mel@csn.ul.ie>
CC: Rik van Riel <riel@redhat.com>
CC: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
CC: Greg Thelen <gthelen@google.com>
CC: Minchan Kim <minchan.kim@gmail.com>
Cc: linux-mm <linux-mm@kvack.org>
Cc: <linux-fsdevel@vger.kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 25/47] writeback: make it easier to break from a dirty exceeded bdi
References: <20101213064249.648862451@intel.com>
Content-Disposition: inline; filename=writeback-bdi-throttle-break-fix.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The break is designed mainly to help the single task case.

For the 1-dd case, it looks better to lower the break threshold to
125ms data. After all, it's not easy for the dirty pages to drop by
250ms worth of data when you only slept 200ms (note: the max pause time
has been doubled for reducing overheads when there are lots of
concurrent dirtiers).

Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
---
 mm/page-writeback.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

--- linux-next.orig/mm/page-writeback.c	2010-12-09 12:19:22.000000000 +0800
+++ linux-next/mm/page-writeback.c	2010-12-09 12:26:56.000000000 +0800
@@ -652,13 +652,13 @@ static void balance_dirty_pages(struct a
 		 *	bdi_dirty = nr_dirty
 		 *		  = (background_thresh + dirty_thresh) / 2
 		 *		  >> bdi_thresh
-		 * Then the task could be blocked for a dozen second to flush
-		 * all the exceeded (bdi_dirty - bdi_thresh) pages. So offer a
-		 * complementary way to break out of the loop when 250ms worth
+		 * Then the task could be blocked for many seconds to flush all
+		 * the exceeded (bdi_dirty - bdi_thresh) pages. So offer a
+		 * complementary way to break out of the loop when 125ms worth
 		 * of dirty pages have been cleaned during our pause time.
 		 */
-		if (nr_dirty < dirty_thresh &&
-		    bdi_prev_dirty - bdi_dirty > (long)bdi->write_bandwidth / 4)
+		if (nr_dirty <= dirty_thresh &&
+		    bdi_prev_dirty - bdi_dirty > (long)bdi->write_bandwidth / 8)
 			break;
 		bdi_prev_dirty = bdi_dirty;
 


