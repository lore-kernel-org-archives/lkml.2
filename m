Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753687Ab1K1OK4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Nov 2011 09:10:56 -0500
Received: from mga03.intel.com ([143.182.124.21]:41420 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753024Ab1K1OJG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Nov 2011 09:09:06 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.69,584,1315206000"; 
   d="scan'208";a="79787547"
Message-Id: <20111128140513.038056015@intel.com>
User-Agent: quilt/0.48-1
Date: Mon, 28 Nov 2011 21:53:39 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: <linux-fsdevel@vger.kernel.org>
cc: Jan Kara <jack@suse.cz>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Wu Fengguang <fengguang.wu@intel.com>
CC: Christoph Hellwig <hch@lst.de>
cc: Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/7] writeback: balanced_rate cannot exceed write bandwidth
References: <20111128135338.249672012@intel.com>
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

The singular points originate from dirty_rate in the below formular:

        balanced_dirty_ratelimit = task_ratelimit * write_bw / dirty_rate
where
	dirty_rate = (number of page dirties in the past 200ms) / 200ms

In the extreme case, if all dd tasks suddenly get blocked on something
else and hence no pages are dirtied at all, dirty_rate will be 0 and
balanced_dirty_ratelimit will be inf. This could happen in reality.

Note that these huge singular points are not a real threat, since they
are _guaranteed_ to be filtered out by the
	min(balanced_dirty_ratelimit, task_ratelimit)
line in bdi_update_dirty_ratelimit(). task_ratelimit is based on the
number of dirty pages, which will never _suddenly_ fly away like
balanced_dirty_ratelimit. So any weirdly large balanced_dirty_ratelimit
will be cut down to the level of task_ratelimit.

There won't be tiny singular points though, as long as the dirty pages
lie inside the dirty throttling region (above the freerun region).
Because there the dd tasks will be throttled by balanced_dirty_pages()
and won't be able to suddenly dirty much more pages than average.

Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
---
 mm/page-writeback.c |    5 +++++
 1 file changed, 5 insertions(+)

--- linux-next.orig/mm/page-writeback.c	2011-11-17 20:18:03.000000000 +0800
+++ linux-next/mm/page-writeback.c	2011-11-17 20:18:23.000000000 +0800
@@ -804,6 +804,11 @@ static void bdi_update_dirty_ratelimit(s
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


