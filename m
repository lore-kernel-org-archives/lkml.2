Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753848Ab1K1OKM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Nov 2011 09:10:12 -0500
Received: from mga03.intel.com ([143.182.124.21]:41420 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753275Ab1K1OJI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Nov 2011 09:09:08 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.69,584,1315206000"; 
   d="scan'208";a="79787557"
Message-Id: <20111128140513.528601145@intel.com>
User-Agent: quilt/0.48-1
Date: Mon, 28 Nov 2011 21:53:43 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: <linux-fsdevel@vger.kernel.org>
cc: Jan Kara <jack@suse.cz>, Chris Mason <chris.mason@oracle.com>,
        Wu Fengguang <fengguang.wu@intel.com>
cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: Christoph Hellwig <hch@lst.de>
cc: Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 5/7] btrfs: fix dirtied pages accounting on sub-page writes
References: <20111128135338.249672012@intel.com>
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

--- linux-next.orig/fs/btrfs/file.c	2011-11-17 20:13:47.000000000 +0800
+++ linux-next/fs/btrfs/file.c	2011-11-17 20:18:51.000000000 +0800
@@ -1136,7 +1136,8 @@ again:
 				     GFP_NOFS);
 	}
 	for (i = 0; i < num_pages; i++) {
-		clear_page_dirty_for_io(pages[i]);
+		if (clear_page_dirty_for_io(pages[i]))
+			account_page_redirty(pages[i]);
 		set_page_extent_mapped(pages[i]);
 		WARN_ON(!PageLocked(pages[i]));
 	}


