Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932380Ab0LMHAx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Dec 2010 02:00:53 -0500
Received: from mga09.intel.com ([134.134.136.24]:10971 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752157Ab0LMGtj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Dec 2010 01:49:39 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.59,335,1288594800"; 
   d="scan'208";a="686523114"
Message-Id: <20101213064837.177415939@intel.com>
User-Agent: quilt/0.48-1
Date: Mon, 13 Dec 2010 14:42:51 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
CC: Jan Kara <jack@suse.cz>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Wu Fengguang <fengguang.wu@intel.com>
CC: Christoph Hellwig <hch@lst.de>
CC: Trond Myklebust <Trond.Myklebust@netapp.com>
CC: Dave Chinner <david@fromorbit.com>
CC: "Theodore Ts'o" <tytso@mit.edu>
CC: Chris Mason <chris.mason@oracle.com>
CC: Mel Gorman <mel@csn.ul.ie>
CC: Rik van Riel <riel@redhat.com>
CC: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
CC: Greg Thelen <gthelen@google.com>
CC: Minchan Kim <minchan.kim@gmail.com>
Cc: linux-mm <linux-mm@kvack.org>
Cc: <linux-fsdevel@vger.kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 02/47] writeback: safety margin for bdi stat error
References: <20101213064249.648862451@intel.com>
Content-Disposition: inline; filename=writeback-bdi-error.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In a simple dd test on a 8p system with "mem=256M", I find all light
dirtier tasks on the root fs are get heavily throttled. That happens
because the global limit is exceeded. It's unbelievable at first sight,
because the test fs doing the heavy dd is under its bdi limit.  After
doing some tracing, it's discovered that

        bdi_dirty < bdi_dirty_limit() < global_dirty_limit() < nr_dirty

So the root cause is, the bdi_dirty is well under the global nr_dirty
due to accounting errors. This can be fixed by using bdi_stat_sum(),
however that's costly on large NUMA machines. So do a less costly fix
of lowering the bdi limit, so that the accounting errors won't lead to
the absurd situation "global limit exceeded but bdi limit not exceeded".

This provides guarantee when there is only 1 heavily dirtied bdi, and
works by opportunity for 2+ heavy dirtied bdi's (hopefully they won't
reach big error _and_ exceed their bdi limit at the same time).

CC: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
---
 mm/page-writeback.c |   18 ++++++++++++++++--
 1 file changed, 16 insertions(+), 2 deletions(-)

--- linux-next.orig/mm/page-writeback.c	2010-12-08 22:44:21.000000000 +0800
+++ linux-next/mm/page-writeback.c	2010-12-08 22:44:21.000000000 +0800
@@ -434,10 +434,16 @@ void global_dirty_limits(unsigned long *
 	*pdirty = dirty;
 }
 
-/*
+/**
  * bdi_dirty_limit - @bdi's share of dirty throttling threshold
+ * @bdi: the backing_dev_info to query
+ * @dirty: global dirty limit in pages
+ * @dirty_pages: current number of dirty pages
  *
- * Allocate high/low dirty limits to fast/slow devices, in order to prevent
+ * Returns @bdi's dirty limit in pages. The term "dirty" in the context of
+ * dirty balancing includes all PG_dirty, PG_writeback and NFS unstable pages.
+ *
+ * It allocates high/low dirty limits to fast/slow devices, in order to prevent
  * - starving fast devices
  * - piling up dirty pages (that will take long time to sync) on slow devices
  *
@@ -458,6 +464,14 @@ unsigned long bdi_dirty_limit(struct bac
 	long numerator, denominator;
 
 	/*
+	 * try to prevent "global limit exceeded but bdi limit not exceeded"
+	 */
+	if (likely(dirty > bdi_stat_error(bdi)))
+		dirty -= bdi_stat_error(bdi);
+	else
+		return 0;
+
+	/*
 	 * Provide a global safety margin of ~1%, or up to 32MB for a 20GB box.
 	 */
 	dirty -= min(dirty / 128, 32768ULL >> (PAGE_SHIFT-10));


