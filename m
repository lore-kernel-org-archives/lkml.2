Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755989Ab1F2PJV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jun 2011 11:09:21 -0400
Received: from mga11.intel.com ([192.55.52.93]:10680 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755319Ab1F2PJK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jun 2011 11:09:10 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.65,443,1304319600"; 
   d="scan'208";a="24301024"
Message-Id: <20110629145554.548899246@intel.com>
User-Agent: quilt/0.48-1
Date: Wed, 29 Jun 2011 22:52:53 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: <linux-fsdevel@vger.kernel.org>
CC: Jan Kara <jack@suse.cz>, Dave Chinner <david@fromorbit.com>,
        Christoph Hellwig <hch@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Theodore Tso <tytso@mit.edu>, Chris Mason <chris.mason@oracle.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Wu Fengguang <fengguang.wu@intel.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 8/9] writeback: scale IO chunk size up to half device bandwidth
References: <20110629145245.835998321@intel.com>
Content-Disposition: inline; filename=writeback-128M-MAX_WRITEBACK_PAGES.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Originally, MAX_WRITEBACK_PAGES was hard-coded to 1024 because of a
concern of not holding I_SYNC for too long.  (At least, that was the
comment previously.)  This doesn't make sense now because the only
time we wait for I_SYNC is if we are calling sync or fsync, and in
that case we need to write out all of the data anyway.  Previously
there may have been other code paths that waited on I_SYNC, but not
any more.					    -- Theodore Ts'o

So remove the MAX_WRITEBACK_PAGES constraint. The writeback pages
will adapt to as large as the storage device can write within 500ms.

XFS is observed to do IO completions in a batch, and the batch size is
equal to the write chunk size. To avoid dirty pages to suddenly drop
out of balance_dirty_pages()'s dirty control scope and create large
fluctuations, the chunk size is also limited to half the control scope.

The balance_dirty_pages() control scrope is

	[(background_thresh + dirty_thresh) / 2, dirty_thresh]

which is by default [15%, 20%] of global dirty pages, whose range size
is dirty_thresh / DIRTY_FULL_SCOPE.

The adpative write chunk size will be rounded to the nearest 4MB
boundary.

http://bugzilla.kernel.org/show_bug.cgi?id=13930

CC: Theodore Ts'o <tytso@mit.edu>
CC: Dave Chinner <david@fromorbit.com>
CC: Chris Mason <chris.mason@oracle.com>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
---
 fs/fs-writeback.c         |   23 ++++++++++-------------
 include/linux/writeback.h |   11 +++++++++++
 2 files changed, 21 insertions(+), 13 deletions(-)

--- linux-next.orig/include/linux/writeback.h	2011-06-22 22:15:36.000000000 +0800
+++ linux-next/include/linux/writeback.h	2011-06-23 10:08:24.000000000 +0800
@@ -8,6 +8,10 @@
 #include <linux/fs.h>
 
 /*
+ * The 1/4 region under the global dirty thresh is for smooth dirty throttling:
+ *
+ *	(thresh - thresh/DIRTY_FULL_SCOPE, thresh)
+ *
  * The 1/16 region above the global dirty limit will be put to maximum pauses:
  *
  *	(limit, limit + limit/DIRTY_MAXPAUSE_AREA)
@@ -25,9 +29,16 @@
  * knocks down the global dirty threshold quickly, in which case the global
  * dirty limit will follow down slowly to prevent livelocking all dirtier tasks.
  */
+#define DIRTY_SCOPE		8
+#define DIRTY_FULL_SCOPE	(DIRTY_SCOPE / 2)
 #define DIRTY_MAXPAUSE_AREA		16
 #define DIRTY_PASSGOOD_AREA		8
 
+/*
+ * 4MB minimal write chunk size
+ */
+#define MIN_WRITEBACK_PAGES	(4096UL >> (PAGE_CACHE_SHIFT - 10))
+
 struct backing_dev_info;
 
 /*
--- linux-next.orig/fs/fs-writeback.c	2011-06-22 20:43:12.000000000 +0800
+++ linux-next/fs/fs-writeback.c	2011-06-23 10:08:01.000000000 +0800
@@ -30,15 +30,6 @@
 #include "internal.h"
 
 /*
- * The maximum number of pages to writeout in a single bdi flush/kupdate
- * operation.  We do this so we don't hold I_SYNC against an inode for
- * enormous amounts of time, which would block a userspace task which has
- * been forced to throttle against that inode.  Also, the code reevaluates
- * the dirty each time it has written this many pages.
- */
-#define MAX_WRITEBACK_PAGES     1024L
-
-/*
  * Passed into wb_writeback(), essentially a subset of writeback_control
  */
 struct wb_writeback_work {
@@ -515,7 +506,8 @@ static bool pin_sb_for_writeback(struct 
 	return false;
 }
 
-static long writeback_chunk_size(struct wb_writeback_work *work)
+static long writeback_chunk_size(struct backing_dev_info *bdi,
+				 struct wb_writeback_work *work)
 {
 	long pages;
 
@@ -534,8 +526,13 @@ static long writeback_chunk_size(struct 
 	 */
 	if (work->sync_mode == WB_SYNC_ALL || work->tagged_writepages)
 		pages = LONG_MAX;
-	else
-		pages = min(MAX_WRITEBACK_PAGES, work->nr_pages);
+	else {
+		pages = min(bdi->avg_write_bandwidth / 2,
+			    global_dirty_limit / DIRTY_SCOPE);
+		pages = min(pages, work->nr_pages);
+		pages = round_down(pages + MIN_WRITEBACK_PAGES,
+				   MIN_WRITEBACK_PAGES);
+	}
 
 	return pages;
 }
@@ -600,7 +597,7 @@ static long writeback_sb_inodes(struct s
 			continue;
 		}
 		__iget(inode);
-		write_chunk = writeback_chunk_size(work);
+		write_chunk = writeback_chunk_size(wb->bdi, work);
 		wbc.nr_to_write = write_chunk;
 		wbc.pages_skipped = 0;
 


