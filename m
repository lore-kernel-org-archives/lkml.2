Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755059Ab1DPOEK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Apr 2011 10:04:10 -0400
Received: from mga02.intel.com ([134.134.136.20]:50901 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754663Ab1DPODn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Apr 2011 10:03:43 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.64,223,1301900400"; 
   d="scan'208";a="734315232"
Message-Id: <20110416134333.960669369@intel.com>
User-Agent: quilt/0.48-1
Date: Sat, 16 Apr 2011 21:25:58 +0800
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
CC: Vivek Goyal <vgoyal@redhat.com>
CC: Andrea Righi <arighi@develer.com>
CC: Balbir Singh <balbir@linux.vnet.ibm.com>
Cc: linux-mm <linux-mm@kvack.org>
Cc: <linux-fsdevel@vger.kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 12/12] writeback: trace global_dirty_state
References: <20110416132546.765212221@intel.com>
Content-Disposition: inline; filename=writeback-trace-global-dirty-states.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add trace balance_dirty_state for showing the global dirty page counts
and thresholds at each balance_dirty_pages() loop.

Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
---
 include/trace/events/writeback.h |   48 +++++++++++++++++++++++++++++
 mm/page-writeback.c              |    1 
 2 files changed, 49 insertions(+)

--- linux-next.orig/mm/page-writeback.c	2011-04-16 11:28:28.000000000 +0800
+++ linux-next/mm/page-writeback.c	2011-04-16 11:28:30.000000000 +0800
@@ -387,6 +387,7 @@ void global_dirty_limits(unsigned long *
 	tsk = current;
 	*pbackground = background;
 	*pdirty = dirty;
+	trace_global_dirty_state(background, dirty);
 }
 
 /**
--- linux-next.orig/include/trace/events/writeback.h	2011-04-16 11:28:28.000000000 +0800
+++ linux-next/include/trace/events/writeback.h	2011-04-16 11:28:30.000000000 +0800
@@ -277,6 +277,54 @@ TRACE_EVENT(balance_dirty_pages,
 		  )
 );
 
+TRACE_EVENT(global_dirty_state,
+
+	TP_PROTO(unsigned long background_thresh,
+		 unsigned long dirty_thresh
+	),
+
+	TP_ARGS(background_thresh,
+		dirty_thresh
+	),
+
+	TP_STRUCT__entry(
+		__field(unsigned long,	nr_dirty)
+		__field(unsigned long,	nr_writeback)
+		__field(unsigned long,	nr_unstable)
+		__field(unsigned long,	background_thresh)
+		__field(unsigned long,	dirty_thresh)
+		__field(unsigned long,	dirty_limit)
+		__field(unsigned long,	nr_dirtied)
+		__field(unsigned long,	nr_written)
+	),
+
+	TP_fast_assign(
+		__entry->nr_dirty	= global_page_state(NR_FILE_DIRTY);
+		__entry->nr_writeback	= global_page_state(NR_WRITEBACK);
+		__entry->nr_unstable	= global_page_state(NR_UNSTABLE_NFS);
+		__entry->nr_dirtied	= global_page_state(NR_DIRTIED);
+		__entry->nr_written	= global_page_state(NR_WRITTEN);
+		__entry->background_thresh = background_thresh;
+		__entry->dirty_thresh	= dirty_thresh;
+		__entry->dirty_limit = default_backing_dev_info.dirty_threshold;
+	),
+
+	TP_printk("dirty=%lu writeback=%lu unstable=%lu "
+		  "bg_thresh=%lu thresh=%lu limit=%lu gap=%ld "
+		  "dirtied=%lu written=%lu",
+		  __entry->nr_dirty,
+		  __entry->nr_writeback,
+		  __entry->nr_unstable,
+		  __entry->background_thresh,
+		  __entry->dirty_thresh,
+		  __entry->dirty_limit,
+		  __entry->dirty_thresh - __entry->nr_dirty -
+		  __entry->nr_writeback - __entry->nr_unstable,
+		  __entry->nr_dirtied,
+		  __entry->nr_written
+	)
+);
+
 DECLARE_EVENT_CLASS(writeback_congest_waited_template,
 
 	TP_PROTO(unsigned int usec_timeout, unsigned int usec_delayed),


