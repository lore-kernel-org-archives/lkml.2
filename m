Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756206Ab1FJOsP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jun 2011 10:48:15 -0400
Received: from mga11.intel.com ([192.55.52.93]:44217 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753421Ab1FJOsN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jun 2011 10:48:13 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.65,347,1304319600"; 
   d="scan'208";a="16802890"
Date: Fri, 10 Jun 2011 22:48:05 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Jan Kara <jack@suse.cz>, Dave Chinner <david@fromorbit.com>,
        Christoph Hellwig <hch@infradead.org>,
        Linux Memory Management List <linux-mm@kvack.org>,
        linux-fsdevel@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] writeback: trace global_dirty_state
Message-ID: <20110610144805.GA9986@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[It seems beneficial to queue this simple trace event for
 next/upstream after the review?]

Add trace event balance_dirty_state for showing the global dirty page
counts and thresholds at each global_dirty_limits() invocation.  This
will cover the callers throttle_vm_writeout(), over_bground_thresh()
and each balance_dirty_pages() loop.

Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
---
 include/trace/events/writeback.h |   36 +++++++++++++++++++++++++++++
 mm/page-writeback.c              |    1 
 2 files changed, 37 insertions(+)

--- linux-next.orig/mm/page-writeback.c	2011-06-10 21:52:34.000000000 +0800
+++ linux-next/mm/page-writeback.c	2011-06-10 22:08:26.000000000 +0800
@@ -430,6 +430,7 @@ void global_dirty_limits(unsigned long *
 	}
 	*pbackground = background;
 	*pdirty = dirty;
+	trace_global_dirty_state(background, dirty);
 }
 
 /**
--- linux-next.orig/include/trace/events/writeback.h	2011-06-10 21:52:34.000000000 +0800
+++ linux-next/include/trace/events/writeback.h	2011-06-10 22:25:33.000000000 +0800
@@ -187,6 +187,42 @@ TRACE_EVENT(writeback_queue_io,
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
+	),
+
+	TP_fast_assign(
+		__entry->nr_dirty	= global_page_state(NR_FILE_DIRTY);
+		__entry->nr_writeback	= global_page_state(NR_WRITEBACK);
+		__entry->nr_unstable	= global_page_state(NR_UNSTABLE_NFS);
+		__entry->background_thresh = background_thresh;
+		__entry->dirty_thresh	= dirty_thresh;
+	),
+
+	TP_printk("dirty=%lu writeback=%lu unstable=%lu "
+		  "bg_thresh=%lu thresh=%lu",
+		  __entry->nr_dirty,
+		  __entry->nr_writeback,
+		  __entry->nr_unstable,
+		  __entry->background_thresh,
+		  __entry->dirty_thresh
+	)
+);
+
 DECLARE_EVENT_CLASS(writeback_congest_waited_template,
 
 	TP_PROTO(unsigned int usec_timeout, unsigned int usec_delayed),
