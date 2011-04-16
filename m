Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754775Ab1DPODq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Apr 2011 10:03:46 -0400
Received: from mga11.intel.com ([192.55.52.93]:2530 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751672Ab1DPODd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Apr 2011 10:03:33 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.64,223,1301900400"; 
   d="scan'208";a="910491955"
Message-Id: <20110416134333.693350038@intel.com>
User-Agent: quilt/0.48-1
Date: Sat, 16 Apr 2011 21:25:56 +0800
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
Subject: [PATCH 10/12] writeback: trace dirty_ratelimit
References: <20110416132546.765212221@intel.com>
Content-Disposition: inline; filename=writeback-trace-throttle-bandwidth.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It provides critical information to understand how various throttle
bandwidths are updated.

Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
---
 include/trace/events/writeback.h |   51 +++++++++++++++++++++++++++--
 mm/page-writeback.c              |    1 
 2 files changed, 49 insertions(+), 3 deletions(-)

--- linux-next.orig/mm/page-writeback.c	2011-04-16 11:28:21.000000000 +0800
+++ linux-next/mm/page-writeback.c	2011-04-16 11:28:27.000000000 +0800
@@ -974,6 +974,7 @@ adjust:
 	bdi->dirty_ratelimit = bw;
 out:
 	bdi_update_reference_ratelimit(bdi, ref_bw);
+	trace_dirty_ratelimit(bdi, dirty_bw, pos_bw, ref_bw);
 }
 
 void bdi_update_bandwidth(struct backing_dev_info *bdi,
--- linux-next.orig/include/trace/events/writeback.h	2011-04-16 11:28:17.000000000 +0800
+++ linux-next/include/trace/events/writeback.h	2011-04-16 11:28:27.000000000 +0800
@@ -147,11 +147,56 @@ DEFINE_EVENT(wbc_class, name, \
 DEFINE_WBC_EVENT(wbc_writeback_start);
 DEFINE_WBC_EVENT(wbc_writeback_written);
 DEFINE_WBC_EVENT(wbc_writeback_wait);
-DEFINE_WBC_EVENT(wbc_balance_dirty_start);
-DEFINE_WBC_EVENT(wbc_balance_dirty_written);
-DEFINE_WBC_EVENT(wbc_balance_dirty_wait);
 DEFINE_WBC_EVENT(wbc_writepage);
 
+#define KBps(x)			((x) << (PAGE_SHIFT - 10))
+
+TRACE_EVENT(dirty_ratelimit,
+
+	TP_PROTO(struct backing_dev_info *bdi,
+		 unsigned long dirty_bw,
+		 unsigned long pos_bw,
+		 unsigned long ref_bw),
+
+	TP_ARGS(bdi, dirty_bw, pos_bw, ref_bw),
+
+	TP_STRUCT__entry(
+		__array(char,		bdi, 32)
+		__field(unsigned long,	write_bw)
+		__field(unsigned long,	avg_bw)
+		__field(unsigned long,	dirty_bw)
+		__field(unsigned long,	base_bw)
+		__field(unsigned long,	pos_bw)
+		__field(unsigned long,	ref_bw)
+		__field(unsigned long,	avg_ref_bw)
+	),
+
+	TP_fast_assign(
+		strlcpy(__entry->bdi, dev_name(bdi->dev), 32);
+		__entry->write_bw	= KBps(bdi->write_bandwidth);
+		__entry->avg_bw		= KBps(bdi->avg_write_bandwidth);
+		__entry->dirty_bw	= KBps(dirty_bw);
+		__entry->base_bw	= KBps(bdi->dirty_ratelimit);
+		__entry->pos_bw		= KBps(pos_bw);
+		__entry->ref_bw		= KBps(ref_bw);
+		__entry->avg_ref_bw	= KBps(bdi->reference_ratelimit);
+	),
+
+
+	TP_printk("bdi %s: "
+		  "write_bw=%lu awrite_bw=%lu dirty_bw=%lu "
+		  "base_bw=%lu pos_bw=%lu ref_bw=%lu aref_bw=%lu",
+		  __entry->bdi,
+		  __entry->write_bw,	/* write bandwidth */
+		  __entry->avg_bw,	/* avg write bandwidth */
+		  __entry->dirty_bw,	/* dirty bandwidth */
+		  __entry->base_bw,	/* dirty ratelimit on each task */
+		  __entry->pos_bw,	/* position control ratelimit */
+		  __entry->ref_bw,	/* the reference ratelimit */
+		  __entry->avg_ref_bw	/* smoothed reference ratelimit */
+	)
+);
+
 DECLARE_EVENT_CLASS(writeback_congest_waited_template,
 
 	TP_PROTO(unsigned int usec_timeout, unsigned int usec_delayed),


