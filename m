Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754145Ab1IDCOa (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Sep 2011 22:14:30 -0400
Received: from mga03.intel.com ([143.182.124.21]:57046 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752975Ab1IDCN2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Sep 2011 22:13:28 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.68,326,1312182000"; 
   d="scan'208";a="45377086"
Message-Id: <20110904020916.460538138@intel.com>
User-Agent: quilt/0.48-1
Date: Sun, 04 Sep 2011 09:53:19 +0800
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
Subject: [PATCH 14/18] writeback: control dirty pause time
References: <20110904015305.367445271@intel.com>
Content-Disposition: inline; filename=max-pause-adaption
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The dirty pause time shall ultimately be controlled by adjusting
nr_dirtied_pause, since there is relationship

	pause = pages_dirtied / task_ratelimit

Assuming

	pages_dirtied ~= nr_dirtied_pause
	task_ratelimit ~= dirty_ratelimit

We get

	nr_dirtied_pause ~= dirty_ratelimit * desired_pause

Here dirty_ratelimit is preferred over task_ratelimit because it's
more stable.

It's also important to limit possible large transitional errors:

- bw is changing quickly
- pages_dirtied << nr_dirtied_pause on entering dirty exceeded area
- pages_dirtied >> nr_dirtied_pause on btrfs (to be improved by a
  separate fix, but still expect non-trivial errors)

So we end up using the above formula inside clamp_val().

The best test case for this code is to run 100 "dd bs=4M" tasks on
btrfs and check its pause time distribution.

Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
---
 mm/page-writeback.c |   15 ++++++++++++++-
 1 file changed, 14 insertions(+), 1 deletion(-)

--- linux-next.orig/mm/page-writeback.c	2011-08-29 19:08:43.000000000 +0800
+++ linux-next/mm/page-writeback.c	2011-08-29 19:08:44.000000000 +0800
@@ -1193,7 +1193,20 @@ pause:
 	if (!dirty_exceeded && bdi->dirty_exceeded)
 		bdi->dirty_exceeded = 0;
 
-	current->nr_dirtied_pause = dirty_poll_interval(nr_dirty, dirty_thresh);
+	if (pause == 0)
+		current->nr_dirtied_pause =
+				dirty_poll_interval(nr_dirty, dirty_thresh);
+	else if (period <= max_pause / 4 &&
+		 pages_dirtied >= current->nr_dirtied_pause)
+		current->nr_dirtied_pause = clamp_val(
+					dirty_ratelimit * (max_pause / 2) / HZ,
+					pages_dirtied + pages_dirtied / 8,
+					pages_dirtied * 4);
+	else if (pause >= max_pause)
+		current->nr_dirtied_pause = 1 | clamp_val(
+					dirty_ratelimit * (max_pause * 3/8)/HZ,
+					pages_dirtied / 4,
+					pages_dirtied * 7/8);
 
 	if (writeback_in_progress(bdi))
 		return;


