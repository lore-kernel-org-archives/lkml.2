Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756501Ab1F2PKZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jun 2011 11:10:25 -0400
Received: from mga11.intel.com ([192.55.52.93]:22128 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754824Ab1F2PJG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jun 2011 11:09:06 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.65,443,1304319600"; 
   d="scan'208";a="21923338"
Message-Id: <20110629145554.698086654@intel.com>
User-Agent: quilt/0.48-1
Date: Wed, 29 Jun 2011 22:52:54 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: <linux-fsdevel@vger.kernel.org>
CC: Jan Kara <jack@suse.cz>, Dave Chinner <david@fromorbit.com>,
        Christoph Hellwig <hch@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Wu Fengguang <fengguang.wu@intel.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 9/9] writeback: trace global_dirty_state
References: <20110629145245.835998321@intel.com>
Content-Disposition: inline; filename=writeback-trace-global-dirty-states.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add trace event balance_dirty_state for showing the global dirty page
counts and thresholds at each global_dirty_limits() invocation.  This
will cover the callers throttle_vm_writeout(), over_bground_thresh()
and each balance_dirty_pages() loop.

Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
---
 include/trace/events/writeback.h |   46 +++++++++++++++++++++++++++++
 mm/page-writeback.c              |    1 
 2 files changed, 47 insertions(+)

--- linux-next.orig/mm/page-writeback.c	2011-06-29 22:29:34.000000000 +0800
+++ linux-next/mm/page-writeback.c	2011-06-29 22:29:34.000000000 +0800
@@ -442,6 +442,7 @@ void global_dirty_limits(unsigned long *
 	}
 	*pbackground = background;
 	*pdirty = dirty;
+	trace_global_dirty_state(background, dirty);
 }
 
 /**
--- linux-next.orig/include/trace/events/writeback.h	2011-06-29 22:29:34.000000000 +0800
+++ linux-next/include/trace/events/writeback.h	2011-06-29 22:33:30.000000000 +0800
@@ -204,6 +204,52 @@ TRACE_EVENT(writeback_queue_io,
 		__entry->moved)
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
+		__entry->dirty_limit = global_dirty_limit;
+	),
+
+	TP_printk("dirty=%lu writeback=%lu unstable=%lu "
+		  "bg_thresh=%lu thresh=%lu limit=%lu "
+		  "dirtied=%lu written=%lu",
+		  __entry->nr_dirty,
+		  __entry->nr_writeback,
+		  __entry->nr_unstable,
+		  __entry->background_thresh,
+		  __entry->dirty_thresh,
+		  __entry->dirty_limit,
+		  __entry->nr_dirtied,
+		  __entry->nr_written
+	)
+);
+
 DECLARE_EVENT_CLASS(writeback_congest_waited_template,
 
 	TP_PROTO(unsigned int usec_timeout, unsigned int usec_delayed),


