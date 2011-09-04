Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753809Ab1IDCOM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Sep 2011 22:14:12 -0400
Received: from mga03.intel.com ([143.182.124.21]:49417 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753043Ab1IDCN3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Sep 2011 22:13:29 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.68,326,1312182000"; 
   d="scan'208";a="45377100"
Message-Id: <20110904020916.972004786@intel.com>
User-Agent: quilt/0.48-1
Date: Sun, 04 Sep 2011 09:53:23 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
to: <linux-fsdevel@vger.kernel.org>
cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Chris Mason <chris.mason@oracle.com>,
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
Subject: [PATCH 18/18] btrfs: fix dirtied pages accounting on sub-page writes
References: <20110904015305.367445271@intel.com>
Content-Disposition: inline; filename=btrfs-account-redirty
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When doing 1KB sequential writes to the same page,
balance_dirty_pages_ratelimited_nr() should be called once instead of 4
times, the latter makes the dirtier tasks be throttled much too heavy.

Fix it with proper de-accounting on clear_page_dirty_for_io().

CC: Chris Mason <chris.mason@oracle.com>
Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
---
 fs/btrfs/file.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- linux-next.orig/fs/btrfs/file.c	2011-08-29 19:14:32.000000000 +0800
+++ linux-next/fs/btrfs/file.c	2011-08-29 19:14:40.000000000 +0800
@@ -1138,7 +1138,8 @@ again:
 				     GFP_NOFS);
 	}
 	for (i = 0; i < num_pages; i++) {
-		clear_page_dirty_for_io(pages[i]);
+		if (clear_page_dirty_for_io(pages[i]))
+			account_page_redirty(pages[i]);
 		set_page_extent_mapped(pages[i]);
 		WARN_ON(!PageLocked(pages[i]));
 	}


