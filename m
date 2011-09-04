Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753630Ab1IDCOE (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Sep 2011 22:14:04 -0400
Received: from mga03.intel.com ([143.182.124.21]:25583 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752482Ab1IDCN1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Sep 2011 22:13:27 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.68,326,1312182000"; 
   d="scan'208";a="45377075"
Message-Id: <20110904020916.197826172@intel.com>
User-Agent: quilt/0.48-1
Date: Sun, 04 Sep 2011 09:53:17 +0800
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
Subject: [PATCH 12/18] writeback: balanced_rate cannot exceed write bandwidth
References: <20110904015305.367445271@intel.com>
Content-Disposition: inline; filename=ref-bw-up-bound
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add an upper limit to balanced_rate according to the below inequality.
This filters out some rare but huge singular points, which at least
enables more readable gnuplot figures.

When there are N dd dirtiers,

	balanced_dirty_ratelimit = write_bw / N

So it holds that

	balanced_dirty_ratelimit <= write_bw

Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
---
 mm/page-writeback.c |    5 +++++
 1 file changed, 5 insertions(+)

--- linux-next.orig/mm/page-writeback.c	2011-08-29 19:14:22.000000000 +0800
+++ linux-next/mm/page-writeback.c	2011-08-29 19:20:36.000000000 +0800
@@ -828,6 +828,11 @@ static void bdi_update_dirty_ratelimit(s
 	 */
 	balanced_dirty_ratelimit = div_u64((u64)task_ratelimit * write_bw,
 					   dirty_rate | 1);
+	/*
+	 * balanced_dirty_ratelimit ~= (write_bw / N) <= write_bw
+	 */
+	if (unlikely(balanced_dirty_ratelimit > write_bw))
+		balanced_dirty_ratelimit = write_bw;
 
 	/*
 	 * We could safely do this and return immediately:


