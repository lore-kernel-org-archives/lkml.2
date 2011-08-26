Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753710Ab1HZLtd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Aug 2011 07:49:33 -0400
Received: from mga03.intel.com ([143.182.124.21]:52630 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752262Ab1HZLr4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Aug 2011 07:47:56 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.68,284,1312182000"; 
   d="scan'208";a="42702490"
Message-Id: <20110826114619.923651827@intel.com>
User-Agent: quilt/0.48-1
Date: Fri, 26 Aug 2011 19:38:23 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
to: <linux-fsdevel@vger.kernel.org>
cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Wu Fengguang <fengguang.wu@intel.com>
cc: Andrew Morton <akpm@linux-foundation.org>
CC: Jan Kara <jack@suse.cz>
CC: Christoph Hellwig <hch@lst.de>
CC: Dave Chinner <david@fromorbit.com>
CC: Greg Thelen <gthelen@google.com>
CC: Minchan Kim <minchan.kim@gmail.com>
CC: Vivek Goyal <vgoyal@redhat.com>
CC: Andrea Righi <arighi@develer.com>
Cc: linux-mm <linux-mm@kvack.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 10/10] trace task_io
References: <20110826113813.895522398@intel.com>
Content-Disposition: inline; filename=writeback-trace-task-total-dirtied.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The "write_bytes" curve over time is very handy for viewing the
smoothness and fairness of page dirties for each task.

XXX: It looks not a good fit for writeback traces, shall we create a
include/trace/events/vfs.h for this?

XXX: the other fields of struct task_io_accounting are not dumped.

Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
---
 include/trace/events/writeback.h |   32 +++++++++++++++++++++++++++++
 mm/page-writeback.c              |    1 
 2 files changed, 33 insertions(+)

--- linux-next.orig/include/trace/events/writeback.h	2011-08-22 11:58:21.000000000 +0800
+++ linux-next/include/trace/events/writeback.h	2011-08-22 12:22:38.000000000 +0800
@@ -180,6 +180,38 @@ TRACE_EVENT(writeback_queue_io,
 		__entry->moved)
 );
 
+TRACE_EVENT(task_io,
+	TP_PROTO(struct task_struct *task),
+	TP_ARGS(task),
+
+	TP_STRUCT__entry(
+		__field(unsigned long long,	read_bytes)
+		__field(unsigned long long,	write_bytes)
+		__field(unsigned long long,	cancelled_write_bytes)
+	),
+
+	TP_fast_assign(
+		struct task_io_accounting *ioac = &task->ioac;
+
+#ifdef CONFIG_TASK_IO_ACCOUNTING
+		__entry->read_bytes		= ioac->read_bytes;
+		__entry->write_bytes		= ioac->write_bytes;
+		__entry->cancelled_write_bytes	= ioac->cancelled_write_bytes;
+#else
+		__entry->read_bytes		= 0;
+		__entry->write_bytes		= 0;
+		__entry->cancelled_write_bytes	= 0;
+#endif
+	),
+
+	TP_printk("read=%llu write=%llu cancelled_write=%llu",
+		  __entry->read_bytes,
+		  __entry->write_bytes,
+		  __entry->cancelled_write_bytes
+	)
+);
+
+
 TRACE_EVENT(global_dirty_state,
 
 	TP_PROTO(unsigned long background_thresh,
--- linux-next.orig/mm/page-writeback.c	2011-08-22 12:10:33.000000000 +0800
+++ linux-next/mm/page-writeback.c	2011-08-22 12:20:33.000000000 +0800
@@ -407,6 +407,7 @@ void global_dirty_limits(unsigned long *
 	*pbackground = background;
 	*pdirty = dirty;
 	trace_global_dirty_state(background, dirty);
+	trace_task_io(current);
 }
 
 /**


