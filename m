Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753820Ab1HZLts (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Aug 2011 07:49:48 -0400
Received: from mga03.intel.com ([143.182.124.21]:39650 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752152Ab1HZLrz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Aug 2011 07:47:55 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.68,284,1312182000"; 
   d="scan'208";a="42702487"
Message-Id: <20110826114619.793951115@intel.com>
User-Agent: quilt/0.48-1
Date: Fri, 26 Aug 2011 19:38:22 +0800
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
Subject: [PATCH 09/10] writeback: trace dirty_ratelimit
References: <20110826113813.895522398@intel.com>
Content-Disposition: inline; filename=writeback-trace-throttle-bandwidth.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It helps understand how various throttle bandwidths are updated.

Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
---
 include/trace/events/writeback.h |   46 +++++++++++++++++++++++++++++
 mm/page-writeback.c              |    3 +
 2 files changed, 49 insertions(+)

--- linux-next.orig/mm/page-writeback.c	2011-08-26 19:27:21.000000000 +0800
+++ linux-next/mm/page-writeback.c	2011-08-26 19:27:26.000000000 +0800
@@ -864,6 +864,9 @@ static void bdi_update_dirty_ratelimit(s
 		dirty_ratelimit -= step;
 
 	bdi->dirty_ratelimit = max(dirty_ratelimit, 1UL);
+
+	trace_dirty_ratelimit(bdi, dirty_rate, task_ratelimit,
+			      balanced_dirty_ratelimit);
 }
 
 void __bdi_update_bandwidth(struct backing_dev_info *bdi,
--- linux-next.orig/include/trace/events/writeback.h	2011-08-26 19:27:21.000000000 +0800
+++ linux-next/include/trace/events/writeback.h	2011-08-26 19:27:23.000000000 +0800
@@ -305,6 +305,52 @@ TRACE_EVENT(balance_dirty_pages,
 	  )
 );
 
+#define KBps(x)			((x) << (PAGE_SHIFT - 10))
+
+TRACE_EVENT(dirty_ratelimit,
+
+	TP_PROTO(struct backing_dev_info *bdi,
+		 unsigned long dirty_rate,
+		 unsigned long task_ratelimit,
+		 unsigned long balanced_dirty_ratelimit),
+
+	TP_ARGS(bdi, dirty_rate, task_ratelimit, balanced_dirty_ratelimit),
+
+	TP_STRUCT__entry(
+		__array(char,		bdi, 32)
+		__field(unsigned long,	write_bw)
+		__field(unsigned long,	avg_write_bw)
+		__field(unsigned long,	dirty_rate)
+		__field(unsigned long,	dirty_ratelimit)
+		__field(unsigned long,	task_ratelimit)
+		__field(unsigned long,	balanced_dirty_ratelimit)
+	),
+
+	TP_fast_assign(
+		strlcpy(__entry->bdi, dev_name(bdi->dev), 32);
+		__entry->write_bw	= KBps(bdi->write_bandwidth);
+		__entry->avg_write_bw	= KBps(bdi->avg_write_bandwidth);
+		__entry->dirty_rate	= KBps(dirty_rate);
+		__entry->dirty_ratelimit = KBps(bdi->dirty_ratelimit);
+		__entry->task_ratelimit	= KBps(task_ratelimit);
+		__entry->balanced_dirty_ratelimit =
+					  KBps(balanced_dirty_ratelimit);
+	),
+
+	TP_printk("bdi %s: "
+		  "write_bw=%lu awrite_bw=%lu dirty_rate=%lu "
+		  "dirty_ratelimit=%lu task_ratelimit=%lu "
+		  "balanced_dirty_ratelimit=%lu",
+		  __entry->bdi,
+		  __entry->write_bw,		/* write bandwidth */
+		  __entry->avg_write_bw,	/* avg write bandwidth */
+		  __entry->dirty_rate,		/* bdi dirty rate */
+		  __entry->dirty_ratelimit,	/* base ratelimit */
+		  __entry->task_ratelimit, /* ratelimit with position control */
+		  __entry->balanced_dirty_ratelimit /* the balanced ratelimit */
+	)
+);
+
 DECLARE_EVENT_CLASS(writeback_congest_waited_template,
 
 	TP_PROTO(unsigned int usec_timeout, unsigned int usec_delayed),


