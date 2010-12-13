Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932276Ab0LMGzf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Dec 2010 01:55:35 -0500
Received: from mga11.intel.com ([192.55.52.93]:10948 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755323Ab0LMGto (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Dec 2010 01:49:44 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.59,335,1288594800"; 
   d="scan'208";a="867484075"
Message-Id: <20101213064841.064409042@intel.com>
User-Agent: quilt/0.48-1
Date: Mon, 13 Dec 2010 14:43:22 +0800
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
Subject: [PATCH 33/47] writeback: trace global dirty page states
References: <20101213064249.648862451@intel.com>
Content-Disposition: inline; filename=writeback-trace-global-dirty-states.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add trace balance_dirty_state for showing the global dirty page counts
and thresholds at each balance_dirty_pages() loop.

Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
---
 include/trace/events/writeback.h |   57 +++++++++++++++++++++++++++++
 mm/page-writeback.c              |   15 ++++++-
 2 files changed, 69 insertions(+), 3 deletions(-)

--- linux-next.orig/mm/page-writeback.c	2010-12-09 12:24:49.000000000 +0800
+++ linux-next/mm/page-writeback.c	2010-12-09 12:24:52.000000000 +0800
@@ -720,12 +720,21 @@ static void balance_dirty_pages(struct a
 		 * written to the server's write cache, but has not yet
 		 * been flushed to permanent storage.
 		 */
-		nr_reclaimable = global_page_state(NR_FILE_DIRTY) +
-					global_page_state(NR_UNSTABLE_NFS);
-		nr_dirty = nr_reclaimable + global_page_state(NR_WRITEBACK);
+		nr_reclaimable = global_page_state(NR_FILE_DIRTY);
+		bdi_dirty = global_page_state(NR_UNSTABLE_NFS);
+		nr_dirty = global_page_state(NR_WRITEBACK);
 
 		global_dirty_limits(&background_thresh, &dirty_thresh);
 
+		trace_balance_dirty_state(mapping,
+					  nr_reclaimable,
+					  nr_dirty,
+					  bdi_dirty,
+					  background_thresh,
+					  dirty_thresh);
+		nr_reclaimable += bdi_dirty;
+		nr_dirty += nr_reclaimable;
+
 		/*
 		 * Throttle it only when the background writeback cannot
 		 * catch-up. This avoids (excessively) small writeouts
--- linux-next.orig/include/trace/events/writeback.h	2010-12-09 12:24:49.000000000 +0800
+++ linux-next/include/trace/events/writeback.h	2010-12-09 12:24:52.000000000 +0800
@@ -149,6 +149,63 @@ DEFINE_WBC_EVENT(wbc_writeback_written);
 DEFINE_WBC_EVENT(wbc_writeback_wait);
 DEFINE_WBC_EVENT(wbc_writepage);
 
+TRACE_EVENT(balance_dirty_state,
+
+	TP_PROTO(struct address_space *mapping,
+		 unsigned long nr_dirty,
+		 unsigned long nr_writeback,
+		 unsigned long nr_unstable,
+		 unsigned long background_thresh,
+		 unsigned long dirty_thresh
+	),
+
+	TP_ARGS(mapping,
+		nr_dirty,
+		nr_writeback,
+		nr_unstable,
+		background_thresh,
+		dirty_thresh
+	),
+
+	TP_STRUCT__entry(
+		__array(char,		bdi, 32)
+		__field(unsigned long,	ino)
+		__field(unsigned long,	nr_dirty)
+		__field(unsigned long,	nr_writeback)
+		__field(unsigned long,	nr_unstable)
+		__field(unsigned long,	background_thresh)
+		__field(unsigned long,	dirty_thresh)
+		__field(unsigned long,	task_dirtied_pause)
+	),
+
+	TP_fast_assign(
+		strlcpy(__entry->bdi,
+			dev_name(mapping->backing_dev_info->dev), 32);
+		__entry->ino			= mapping->host->i_ino;
+		__entry->nr_dirty		= nr_dirty;
+		__entry->nr_writeback		= nr_writeback;
+		__entry->nr_unstable		= nr_unstable;
+		__entry->background_thresh	= background_thresh;
+		__entry->dirty_thresh		= dirty_thresh;
+		__entry->task_dirtied_pause	= current->nr_dirtied_pause;
+	),
+
+	TP_printk("bdi %s: dirty=%lu wb=%lu unstable=%lu "
+		  "bg_thresh=%lu thresh=%lu gap=%ld "
+		  "poll_thresh=%lu ino=%lu",
+		  __entry->bdi,
+		  __entry->nr_dirty,
+		  __entry->nr_writeback,
+		  __entry->nr_unstable,
+		  __entry->background_thresh,
+		  __entry->dirty_thresh,
+		  __entry->dirty_thresh - __entry->nr_dirty -
+		  __entry->nr_writeback - __entry->nr_unstable,
+		  __entry->task_dirtied_pause,
+		  __entry->ino
+	)
+);
+
 #define KBps(x)			((x) << (PAGE_SHIFT - 10))
 #define BDP_PERCENT(a, b, c)	((__entry->a - __entry->b) * 100 * c + \
 				  __entry->bdi_limit/2) / (__entry->bdi_limit|1)


