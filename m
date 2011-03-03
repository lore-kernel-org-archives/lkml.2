Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756920Ab1CCISp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Mar 2011 03:18:45 -0500
Received: from mga03.intel.com ([143.182.124.21]:18624 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755657Ab1CCIR7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Mar 2011 03:17:59 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.62,257,1297065600"; 
   d="scan'208";a="396816543"
Message-Id: <20110303074951.568969627@intel.com>
User-Agent: quilt/0.48-1
Date: Thu, 03 Mar 2011 14:45:27 +0800
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
Subject: [PATCH 22/27] writeback: trace dirty_throttle_bandwidth
References: <20110303064505.718671603@intel.com>
Content-Disposition: inline; filename=writeback-trace-throttle-bandwidth.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It provides critical information to understand how various throttle
bandwidths are updated.

Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
---
 include/trace/events/writeback.h |   49 +++++++++++++++++++++++++++++
 mm/page-writeback.c              |    1 
 2 files changed, 50 insertions(+)

--- linux-next.orig/mm/page-writeback.c	2011-03-03 14:44:31.000000000 +0800
+++ linux-next/mm/page-writeback.c	2011-03-03 14:44:38.000000000 +0800
@@ -1068,6 +1068,7 @@ adjust:
 	bdi->throttle_bandwidth = bw;
 out:
 	bdi_update_reference_bandwidth(bdi, ref_bw);
+	trace_dirty_throttle_bandwidth(bdi, dirty_bw, pos_bw, ref_bw);
 }
 
 void bdi_update_bandwidth(struct backing_dev_info *bdi,
--- linux-next.orig/include/trace/events/writeback.h	2011-03-03 14:43:49.000000000 +0800
+++ linux-next/include/trace/events/writeback.h	2011-03-03 14:44:38.000000000 +0800
@@ -152,6 +152,55 @@ DEFINE_WBC_EVENT(wbc_balance_dirty_writt
 DEFINE_WBC_EVENT(wbc_balance_dirty_wait);
 DEFINE_WBC_EVENT(wbc_writepage);
 
+#define KBps(x)			((x) << (PAGE_SHIFT - 10))
+#define Bps(x)			((x) >> (BASE_BW_SHIFT - PAGE_SHIFT))
+
+TRACE_EVENT(dirty_throttle_bandwidth,
+
+	TP_PROTO(struct backing_dev_info *bdi,
+		 unsigned long dirty_bw,
+		 unsigned long long pos_bw,
+		 unsigned long long ref_bw),
+
+	TP_ARGS(bdi, dirty_bw, pos_bw, ref_bw),
+
+	TP_STRUCT__entry(
+		__array(char,			bdi, 32)
+		__field(unsigned long,		write_bw)
+		__field(unsigned long,		avg_bw)
+		__field(unsigned long,		dirty_bw)
+		__field(unsigned long long,	base_bw)
+		__field(unsigned long long,	pos_bw)
+		__field(unsigned long long,	ref_bw)
+		__field(unsigned long long,	avg_ref_bw)
+	),
+
+	TP_fast_assign(
+		strlcpy(__entry->bdi, dev_name(bdi->dev), 32);
+		__entry->write_bw	= KBps(bdi->write_bandwidth);
+		__entry->avg_bw		= KBps(bdi->avg_bandwidth);
+		__entry->dirty_bw	= KBps(dirty_bw);
+		__entry->base_bw	= Bps(bdi->throttle_bandwidth);
+		__entry->pos_bw		= Bps(pos_bw);
+		__entry->ref_bw		= Bps(ref_bw);
+		__entry->avg_ref_bw	= Bps(bdi->reference_bandwidth);
+	),
+
+
+	TP_printk("bdi %s: "
+		  "write_bw=%lu avg_bw=%lu dirty_bw=%lu "
+		  "base_bw=%llu pos_bw=%llu ref_bw=%llu aref_bw=%llu",
+		  __entry->bdi,
+		  __entry->write_bw,	/* bdi write bandwidth */
+		  __entry->avg_bw,	/* bdi avg write bandwidth */
+		  __entry->dirty_bw,	/* bdi dirty bandwidth */
+		  __entry->base_bw,	/* base throttle bandwidth */
+		  __entry->pos_bw,	/* position control bandwidth */
+		  __entry->ref_bw,	/* reference throttle bandwidth */
+		  __entry->avg_ref_bw	/* smoothed reference bandwidth */
+	)
+);
+
 DECLARE_EVENT_CLASS(writeback_congest_waited_template,
 
 	TP_PROTO(unsigned int usec_timeout, unsigned int usec_delayed),


