Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756582Ab1CCIYp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Mar 2011 03:24:45 -0500
Received: from mga01.intel.com ([192.55.52.88]:17631 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753724Ab1CCIR4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Mar 2011 03:17:56 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.62,257,1297065600"; 
   d="scan'208";a="893290345"
Message-Id: <20110303074950.704987840@intel.com>
User-Agent: quilt/0.48-1
Date: Thu, 03 Mar 2011 14:45:21 +0800
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
Subject: [PATCH 16/27] writeback: smoothed global/bdi dirty pages
References: <20110303064505.718671603@intel.com>
Content-Disposition: inline; filename=writeback-smooth-dirty.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Maintain a smoothed version of dirty pages for use in the throttle
bandwidth calculations.

default_backing_dev_info.avg_dirty holds the smoothed global dirty
pages.

Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
---
 include/linux/backing-dev.h |    2 +
 mm/backing-dev.c            |    3 +
 mm/page-writeback.c         |   62 ++++++++++++++++++++++++++++++++++
 3 files changed, 67 insertions(+)

--- linux-next.orig/mm/page-writeback.c	2011-03-03 14:44:07.000000000 +0800
+++ linux-next/mm/page-writeback.c	2011-03-03 14:44:10.000000000 +0800
@@ -472,6 +472,64 @@ unsigned long bdi_dirty_limit(struct bac
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
+		avg += (old - avg) >> 3;
+		goto update;
+	}
+
+	/*
+	 * dirty pages are departing downwards, follow down
+	 */
+	if (avg > old && old >= dirty) {
+		avg -= (avg - old) >> 3;
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
+	 *       .         .         .         .      (flucuated)
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
@@ -537,6 +595,10 @@ void bdi_update_bandwidth(struct backing
 		goto unlock;
 
 	__bdi_update_write_bandwidth(bdi, elapsed, written);
+	if (thresh) {
+		bdi_update_dirty_smooth(bdi, bdi_dirty);
+		bdi_update_dirty_smooth(&default_backing_dev_info, dirty);
+	}
 
 snapshot:
 	bdi->written_stamp = written;
--- linux-next.orig/include/linux/backing-dev.h	2011-03-03 14:44:07.000000000 +0800
+++ linux-next/include/linux/backing-dev.h	2011-03-03 14:44:10.000000000 +0800
@@ -79,6 +79,8 @@ struct backing_dev_info {
 	unsigned long written_stamp;
 	unsigned long write_bandwidth;
 	unsigned long avg_bandwidth;
+	unsigned long avg_dirty;
+	unsigned long old_dirty;
 
 	struct prop_local_percpu completions;
 	int dirty_exceeded;
--- linux-next.orig/mm/backing-dev.c	2011-03-03 14:44:07.000000000 +0800
+++ linux-next/mm/backing-dev.c	2011-03-03 14:44:10.000000000 +0800
@@ -675,6 +675,9 @@ int bdi_init(struct backing_dev_info *bd
 	bdi->write_bandwidth = INIT_BW;
 	bdi->avg_bandwidth = INIT_BW;
 
+	bdi->avg_dirty = 0;
+	bdi->old_dirty = 0;
+
 	err = prop_local_init_percpu(&bdi->completions);
 
 	if (err) {


