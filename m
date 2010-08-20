Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752032Ab0HTDZM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Aug 2010 23:25:12 -0400
Received: from mga01.intel.com ([192.55.52.88]:41903 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751059Ab0HTDZK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Aug 2010 23:25:10 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.56,237,1280732400"; 
   d="scan'208";a="830012348"
Date: Fri, 20 Aug 2010 11:25:06 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-mm@kvack.org, riel@redhat.com, david@fromorbit.com, hch@lst.de,
        axboe@kernel.dk, Michael Rubin <mrubin@google.com>,
        Jan Kara <jack@suse.cz>, Neil Brown <neilb@suse.de>
Subject: [PATCH] writeback: remove the internal 5% low bound on dirty_ratio
Message-ID: <20100820032506.GA6662@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The dirty_ratio was silently limited to >= 5%. This is not a user
expected behavior. Let's rip it.

It's not likely the user space will depend on the old behavior.
So the risk of breaking user space is very low.

CC: Jan Kara <jack@suse.cz>
CC: Neil Brown <neilb@suse.de>
Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
---
 mm/page-writeback.c |   10 ++--------
 1 file changed, 2 insertions(+), 8 deletions(-)

--- linux-next.orig/mm/page-writeback.c	2010-08-20 10:55:17.000000000 +0800
+++ linux-next/mm/page-writeback.c	2010-08-20 10:56:36.000000000 +0800
@@ -415,14 +415,8 @@ void global_dirty_limits(unsigned long *
 
 	if (vm_dirty_bytes)
 		dirty = DIV_ROUND_UP(vm_dirty_bytes, PAGE_SIZE);
-	else {
-		int dirty_ratio;
-
-		dirty_ratio = vm_dirty_ratio;
-		if (dirty_ratio < 5)
-			dirty_ratio = 5;
-		dirty = (dirty_ratio * available_memory) / 100;
-	}
+	else
+		dirty = (vm_dirty_ratio * available_memory) / 100;
 
 	if (dirty_background_bytes)
 		background = DIV_ROUND_UP(dirty_background_bytes, PAGE_SIZE);
