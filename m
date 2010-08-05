Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933674Ab0HEQ3h (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Aug 2010 12:29:37 -0400
Received: from mga09.intel.com ([134.134.136.24]:3165 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933640Ab0HEQ32 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Aug 2010 12:29:28 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.55,323,1278313200"; 
   d="scan'208";a="542252533"
Message-Id: <20100805162433.390104073@intel.com>
User-Agent: quilt/0.48-1
Date: Fri, 06 Aug 2010 00:10:56 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Wu Fengguang <fengguang.wu@intel.com>, LKML <linux-kernel@vger.kernel.org>,
        Dave Chinner <david@fromorbit.com>, Martin Bligh <mbligh@google.com>,
        Michael Rubin <mrubin@google.com>,
        Peter Zijlstra <peterz@infradead.org>
CC: Christoph Hellwig <hch@infradead.org>, Mel Gorman <mel@csn.ul.ie>,
        Chris Mason <chris.mason@oracle.com>, Jens Axboe <axboe@kernel.dk>,
        Jan Kara <jack@suse.cz>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>
Subject: [PATCH 05/13] writeback: fix queue_io() ordering
References: <20100805161051.501816677@intel.com>
Content-Disposition: inline; filename=queue_io-fix.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This was not a bug, since b_io is empty for kupdate writeback.
The next patch will do requeue_io() for non-kupdate writeback,
so let's fix it.

CC: Dave Chinner <david@fromorbit.com>
Cc: Martin Bligh <mbligh@google.com>
Cc: Michael Rubin <mrubin@google.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
---
 fs/fs-writeback.c |   10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

--- linux-next.orig/fs/fs-writeback.c	2010-08-05 23:03:37.000000000 +0800
+++ linux-next/fs/fs-writeback.c	2010-08-05 23:21:43.000000000 +0800
@@ -253,10 +253,18 @@ static void move_expired_inodes(struct l
 
 /*
  * Queue all expired dirty inodes for io, eldest first.
+ * Before
+ *         newly dirtied     b_dirty    b_io    b_more_io
+ *         =============>    gf         edc     BA
+ * After
+ *         newly dirtied     b_dirty    b_io    b_more_io
+ *         =============>    g          fBAedc
+ *                                           |
+ *                                           +--> dequeue for IO
  */
 static void queue_io(struct bdi_writeback *wb, unsigned long *older_than_this)
 {
-	list_splice_init(&wb->b_more_io, wb->b_io.prev);
+	list_splice_init(&wb->b_more_io, &wb->b_io);
 	move_expired_inodes(&wb->b_dirty, &wb->b_io, older_than_this);
 }
 


