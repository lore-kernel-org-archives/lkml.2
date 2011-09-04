Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753549Ab1IDCOA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Sep 2011 22:14:00 -0400
Received: from mga03.intel.com ([143.182.124.21]:57046 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752912Ab1IDCN1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Sep 2011 22:13:27 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.68,326,1312182000"; 
   d="scan'208";a="45377081"
Message-Id: <20110904020915.942753370@intel.com>
User-Agent: quilt/0.48-1
Date: Sun, 04 Sep 2011 09:53:15 +0800
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
Subject: [PATCH 10/18] writeback: dirty position control - bdi reserve area
References: <20110904015305.367445271@intel.com>
Content-Disposition: inline; filename=bdi-reserve-area
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Keep a minimal pool of dirty pages for each bdi, so that the disk IO
queues won't underrun.

It's particularly useful for JBOD and small memory system.

Note that this is not enough when memory is really tight (in comparison
to write bandwidth). It may result in (pos_ratio > 1) at the setpoint
and push the dirty pages high. This is more or less intended because the
bdi is in the danger of IO queue underflow. However the global dirty
pages, when pushed close to limit, will eventually conteract our desire
to push up the low bdi_dirty.

In low memory JBOD tests we do see disks under-utilized from time to
time. The additional fix may be to add a BDI_async_underrun flag to
indicate that the block write queue is running low and it's time to
quickly fill the queue by unthrottling the tasks regardless of the
global limit.

Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
---
 mm/page-writeback.c |   26 ++++++++++++++++++++++++++
 1 file changed, 26 insertions(+)

--- linux-next.orig/mm/page-writeback.c	2011-08-26 20:12:19.000000000 +0800
+++ linux-next/mm/page-writeback.c	2011-08-26 20:13:21.000000000 +0800
@@ -487,6 +487,16 @@ unsigned long bdi_dirty_limit(struct bac
  *   0 +------------.------------------.----------------------*------------->
  *           freerun^          setpoint^                 limit^   dirty pages
  *
+ * (o) bdi reserve area
+ *
+ * The bdi reserve area tries to keep a reasonable number of dirty pages for
+ * preventing block queue underrun.
+ *
+ * reserve area, scale up rate as dirty pages drop low
+ * |<----------------------------------------------->|
+ * |-------------------------------------------------------*-------|----------
+ * 0                                           bdi setpoint^       ^bdi_thresh
+ *
  * (o) bdi control lines
  *
  * The control lines for the global/bdi setpoints both stretch up to @limit.
@@ -634,6 +644,22 @@ static unsigned long bdi_position_ratio(
 	pos_ratio *= x_intercept - bdi_dirty;
 	do_div(pos_ratio, x_intercept - bdi_setpoint + 1);
 
+	/*
+	 * bdi reserve area, safeguard against dirty pool underrun and disk idle
+	 *
+	 * It may push the desired control point of global dirty pages higher
+	 * than setpoint. It's not necessary in single-bdi case because a
+	 * minimal pool of @freerun dirty pages will already be guaranteed.
+	 */
+	x_intercept = min(write_bw, freerun);
+	if (bdi_dirty < x_intercept) {
+		if (bdi_dirty > x_intercept / 8) {
+			pos_ratio *= x_intercept;
+			do_div(pos_ratio, bdi_dirty);
+		} else
+			pos_ratio *= 8;
+	}
+
 	return pos_ratio;
 }
 


