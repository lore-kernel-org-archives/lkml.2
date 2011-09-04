Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753388Ab1IDCNy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Sep 2011 22:13:54 -0400
Received: from mga03.intel.com ([143.182.124.21]:49417 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752876Ab1IDCN1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Sep 2011 22:13:27 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.68,326,1312182000"; 
   d="scan'208";a="45377073"
Message-Id: <20110904020915.664827035@intel.com>
User-Agent: quilt/0.48-1
Date: Sun, 04 Sep 2011 09:53:13 +0800
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
Subject: [PATCH 08/18] writeback: trace dirty_ratelimit
References: <20110904015305.367445271@intel.com>
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

--- linux-next.orig/mm/page-writeback.c	2011-08-29 19:51:30.000000000 +0800
+++ linux-next/mm/page-writeback.c	2011-08-29 19:52:11.000000000 +0800
@@ -864,6 +864,9 @@ static void bdi_update_dirty_ratelimit(s
 		dirty_ratelimit -= step;
 
 	bdi->dirty_ratelimit = max(dirty_ratelimit, 1UL);
+
+	trace_dirty_ratelimit(bdi, dirty_rate, task_ratelimit,
+			      balanced_dirty_ratelimit);
 }
 
 void __bdi_update_bandwidth(struct backing_dev_info *bdi,
--- linux-next.orig/include/trace/events/writeback.h	2011-08-29 19:51:30.000000000 +0800
+++ linux-next/include/trace/events/writeback.h	2011-08-29 19:52:11.000000000 +0800
@@ -226,6 +226,52 @@ TRACE_EVENT(global_dirty_state,
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


