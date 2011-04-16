Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755539Ab1DPOGM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Apr 2011 10:06:12 -0400
Received: from mga11.intel.com ([192.55.52.93]:20815 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753318Ab1DPODe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Apr 2011 10:03:34 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.64,223,1301900400"; 
   d="scan'208";a="679955070"
Message-Id: <20110416134332.918936130@intel.com>
User-Agent: quilt/0.48-1
Date: Sat, 16 Apr 2011 21:25:50 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
CC: Jan Kara <jack@suse.cz>, larry <lantianyu1986@gmail.com>,
        Wu Fengguang <fengguang.wu@intel.com>
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
Subject: [PATCH 04/12] writeback: smoothed global/bdi dirty pages
References: <20110416132546.765212221@intel.com>
Content-Disposition: inline; filename=writeback-smooth-dirty.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Maintain a smoothed version of dirty pages for use in the throttle
bandwidth calculations.

default_backing_dev_info.avg_dirty holds the smoothed global dirty
pages.

The calculation favors smoothness rather than accuracy. It's non-sense
trying to track a much fluctuated value "accurately". And its users
don't really rely on it being accurate.

CC: larry <lantianyu1986@gmail.com>
Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
---
 include/linux/backing-dev.h |    2 +
 mm/backing-dev.c            |    3 +
 mm/page-writeback.c         |   66 ++++++++++++++++++++++++++++++++++
 3 files changed, 71 insertions(+)

--- linux-next.orig/mm/page-writeback.c	2011-04-13 17:18:12.000000000 +0800
+++ linux-next/mm/page-writeback.c	2011-04-13 17:18:12.000000000 +0800
@@ -471,6 +471,64 @@ unsigned long bdi_dirty_limit(struct bac
 	return bdi_dirty;
 }
 
+static void bdi_update_dirty_smooth(struct backing_dev_info *bdi,
+				    unsigned long dirty)
+{
+	unsigned long avg = bdi->avg_dirty;
+	unsigned long old = bdi->old_dirty;
+
+	if (unlikely(!avg)) {
+		avg = dirty;
+		goto update;
+	}
+
+	/*
+	 * dirty pages are departing upwards, follow up
+	 */
+	if (avg < old && old <= dirty) {
+		avg += (old - avg) >> 2;
+		goto update;
+	}
+
+	/*
+	 * dirty pages are departing downwards, follow down
+	 */
+	if (avg > old && old >= dirty) {
+		avg -= (avg - old) >> 2;
+		goto update;
+	}
+
+	/*
+	 * This can filter out one half unnecessary updates when bdi_dirty is
+	 * fluctuating around the balance point, and is most effective on XFS,
+	 * whose pattern is
+	 *                                                             .
+	 *	[.] dirty	[-] avg                       .       .
+	 *                                                   .       .
+	 *              .         .         .         .     .       .
+	 *      ---------------------------------------    .       .
+	 *            .         .         .         .     .       .
+	 *           .         .         .         .     .       .
+	 *          .         .         .         .     .       .
+	 *         .         .         .         .     .       .
+	 *        .         .         .         .
+	 *       .         .         .         .      (fluctuated)
+	 *      .         .         .         .
+	 *     .         .         .         .
+	 *
+	 * @avg will remain flat at the cost of being biased towards high. In
+	 * practice the error tend to be much smaller: thanks to more coarse
+	 * grained fluctuations, @avg becomes the real average number for the
+	 * last two rising lines of @dirty.
+	 */
+	goto out;
+
+update:
+	bdi->avg_dirty = avg;
+out:
+	bdi->old_dirty = dirty;
+}
+
 static void __bdi_update_write_bandwidth(struct backing_dev_info *bdi,
 					 unsigned long elapsed,
 					 unsigned long written)
@@ -535,6 +593,14 @@ void bdi_update_bandwidth(struct backing
 	if (elapsed <= HZ / 5)
 		goto unlock;
 
+	if (thresh &&
+	    now - default_backing_dev_info.bw_time_stamp >= HZ / 5) {
+		bdi_update_dirty_smooth(&default_backing_dev_info, dirty);
+		default_backing_dev_info.bw_time_stamp = now;
+	}
+	if (thresh) {
+		bdi_update_dirty_smooth(bdi, bdi_dirty);
+	}
 	__bdi_update_write_bandwidth(bdi, elapsed, written);
 
 snapshot:
--- linux-next.orig/include/linux/backing-dev.h	2011-04-13 17:18:12.000000000 +0800
+++ linux-next/include/linux/backing-dev.h	2011-04-13 17:18:12.000000000 +0800
@@ -77,6 +77,8 @@ struct backing_dev_info {
 	unsigned long written_stamp;
 	unsigned long write_bandwidth;
 	unsigned long avg_write_bandwidth;
+	unsigned long avg_dirty;
+	unsigned long old_dirty;
 
 	struct prop_local_percpu completions;
 	int dirty_exceeded;
--- linux-next.orig/mm/backing-dev.c	2011-04-13 17:18:12.000000000 +0800
+++ linux-next/mm/backing-dev.c	2011-04-13 17:18:12.000000000 +0800
@@ -669,6 +669,9 @@ int bdi_init(struct backing_dev_info *bd
 	bdi->write_bandwidth = INIT_BW;
 	bdi->avg_write_bandwidth = INIT_BW;
 
+	bdi->avg_dirty = 0;
+	bdi->old_dirty = 0;
+
 	err = prop_local_init_percpu(&bdi->completions);
 
 	if (err) {


