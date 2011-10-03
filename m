Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756143Ab1JCNsJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Oct 2011 09:48:09 -0400
Received: from mga14.intel.com ([143.182.124.37]:17735 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755859Ab1JCNp4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Oct 2011 09:45:56 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.68,479,1312182000"; 
   d="scan'208";a="58158733"
Message-Id: <20111003134537.434162395@intel.com>
User-Agent: quilt/0.48-1
Date: Mon, 03 Oct 2011 21:42:38 +0800
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
Subject: [PATCH 10/11] writeback: dirty position control - bdi reserve area
References: <20111003134228.090592370@intel.com>
Content-Disposition: inline; filename=bdi-reserve-area
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Keep a minimal pool of dirty pages for each bdi, so that the disk IO
queues won't underrun. Also gently increase a small bdi_thresh to avoid
it stuck in 0 for some light dirtied bdi.

It's particularly useful for JBOD and small memory system.

It may result in (pos_ratio > 1) at the setpoint and push the dirty
pages high. This is more or less intended because the bdi is in the
danger of IO queue underflow.

Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
---
 mm/page-writeback.c |   15 +++++++++++++++
 1 file changed, 15 insertions(+)

--- linux-next.orig/mm/page-writeback.c	2011-10-03 21:05:48.000000000 +0800
+++ linux-next/mm/page-writeback.c	2011-10-03 21:05:51.000000000 +0800
@@ -599,6 +599,7 @@ static unsigned long bdi_position_ratio(
 	 */
 	if (unlikely(bdi_thresh > thresh))
 		bdi_thresh = thresh;
+	bdi_thresh = max(bdi_thresh, (limit - dirty) / 8);
 	/*
 	 * scale global setpoint to bdi's:
 	 *	bdi_setpoint = setpoint * bdi_thresh / thresh
@@ -622,6 +623,20 @@ static unsigned long bdi_position_ratio(
 	} else
 		pos_ratio /= 4;
 
+	/*
+	 * bdi reserve area, safeguard against dirty pool underrun and disk idle
+	 * It may push the desired control point of global dirty pages higher
+	 * than setpoint.
+	 */
+	x_intercept = bdi_thresh / 2;
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
 


