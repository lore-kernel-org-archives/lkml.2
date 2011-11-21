Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754798Ab1KUNQA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Nov 2011 08:16:00 -0500
Received: from mga14.intel.com ([143.182.124.37]:15513 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754026Ab1KUNPk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Nov 2011 08:15:40 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.69,547,1315206000"; 
   d="scan'208";a="77539457"
Message-Id: <20111121131215.645601798@intel.com>
User-Agent: quilt/0.48-1
Date: Mon, 21 Nov 2011 21:03:43 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
to: <linux-fsdevel@vger.kernel.org>
cc: Jan Kara <jack@suse.cz>, Wu Fengguang <fengguang.wu@intel.com>
cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: Christoph Hellwig <hch@lst.de>
cc: Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/5] writeback: balanced_rate cannot exceed write bandwidth
References: <20111121130342.211953629@intel.com>
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


