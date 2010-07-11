Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754823Ab0GKCjN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Jul 2010 22:39:13 -0400
Received: from mga02.intel.com ([134.134.136.20]:51523 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754115Ab0GKCiM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Jul 2010 22:38:12 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.55,182,1278313200"; 
   d="scan'208";a="637293545"
Message-Id: <20100711021749.163345723@intel.com>
User-Agent: quilt/0.48-1
Date: Sun, 11 Jul 2010 10:07:01 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
CC: Christoph Hellwig <hch@infradead.org>, Dave Chinner <david@fromorbit.com>,
       Martin Bligh <mbligh@google.com>, Michael Rubin <mrubin@google.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Wu Fengguang <fengguang.wu@intel.com>
CC: Jan Kara <jack@suse.cz>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>
cc: <linux-fsdevel@vger.kernel.org>
cc: Linux Memory Management List <linux-mm@kvack.org>
cc: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 5/6] writeback: fix queue_io() ordering
References: <20100711020656.340075560@intel.com>
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
Signed-off-by: Fengguang Wu <wfg@mail.ustc.edu.cn>
Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
---
 fs/fs-writeback.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

--- linux-next.orig/fs/fs-writeback.c	2010-07-11 09:13:31.000000000 +0800
+++ linux-next/fs/fs-writeback.c	2010-07-11 09:13:32.000000000 +0800
@@ -252,11 +252,14 @@ static void move_expired_inodes(struct l
 }
 
 /*
- * Queue all expired dirty inodes for io, eldest first.
+ * Queue all expired dirty inodes for io, eldest first:
+ * (newly dirtied) => b_dirty inodes
+ *                 => b_more_io inodes
+ *                 => remaining inodes in b_io => (dequeue for sync)
  */
 static void queue_io(struct bdi_writeback *wb, unsigned long *older_than_this)
 {
-	list_splice_init(&wb->b_more_io, wb->b_io.prev);
+	list_splice_init(&wb->b_more_io, &wb->b_io);
 	move_expired_inodes(&wb->b_dirty, &wb->b_io, older_than_this);
 }
 


