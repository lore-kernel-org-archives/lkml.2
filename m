Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754261Ab1HQQSk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Aug 2011 12:18:40 -0400
Received: from smtp-out.google.com ([216.239.44.51]:41331 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754240Ab1HQQSg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Aug 2011 12:18:36 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
	b=Glm4HnTmbk8eVxBGKsKE91He2nnz41s7qr48Yhtz48KtMmg0TK/L/usRwlpKtw+4Y
	BjWurOIaaCfpGS6bqpYAw==
From: Greg Thelen <gthelen@google.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        containers@lists.osdl.org, linux-fsdevel@vger.kernel.org,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Balbir Singh <bsingharora@gmail.com>,
        Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>,
        Minchan Kim <minchan.kim@gmail.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Wu Fengguang <fengguang.wu@intel.com>,
        Dave Chinner <david@fromorbit.com>, Vivek Goyal <vgoyal@redhat.com>,
        Andrea Righi <andrea@betterlinux.com>,
        Ciju Rajan K <ciju@linux.vnet.ibm.com>,
        David Rientjes <rientjes@google.com>, Greg Thelen <gthelen@google.com>
Subject: [PATCH v9 10/13] writeback: pass wb_writeback_work into move_expired_inodes()
Date: Wed, 17 Aug 2011 09:15:02 -0700
Message-Id: <1313597705-6093-11-git-send-email-gthelen@google.com>
X-Mailer: git-send-email 1.7.3.1
In-Reply-To: <1313597705-6093-1-git-send-email-gthelen@google.com>
References: <1313597705-6093-1-git-send-email-gthelen@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A later change to move_expired_inodes() requires passing fields from
writeback work descriptor into memcontrol code when determining if an
inode should be written back considered.

Signed-off-by: Greg Thelen <gthelen@google.com>
---
 fs/fs-writeback.c |   15 ++++++++-------
 1 files changed, 8 insertions(+), 7 deletions(-)

diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
index 6bf4c49..e91fb82 100644
--- a/fs/fs-writeback.c
+++ b/fs/fs-writeback.c
@@ -252,7 +252,7 @@ static bool inode_dirtied_after(struct inode *inode, unsigned long t)
  */
 static int move_expired_inodes(struct list_head *delaying_queue,
 			       struct list_head *dispatch_queue,
-			       unsigned long *older_than_this)
+			       struct wb_writeback_work *work)
 {
 	LIST_HEAD(tmp);
 	struct list_head *pos, *node;
@@ -263,8 +263,8 @@ static int move_expired_inodes(struct list_head *delaying_queue,
 
 	while (!list_empty(delaying_queue)) {
 		inode = wb_inode(delaying_queue->prev);
-		if (older_than_this &&
-		    inode_dirtied_after(inode, *older_than_this))
+		if (work->older_than_this &&
+		    inode_dirtied_after(inode, *work->older_than_this))
 			break;
 		if (sb && sb != inode->i_sb)
 			do_sb_sort = 1;
@@ -303,13 +303,14 @@ out:
  *                                           |
  *                                           +--> dequeue for IO
  */
-static void queue_io(struct bdi_writeback *wb, unsigned long *older_than_this)
+static void queue_io(struct bdi_writeback *wb, struct wb_writeback_work *work)
 {
 	int moved;
 	assert_spin_locked(&wb->list_lock);
 	list_splice_init(&wb->b_more_io, &wb->b_io);
-	moved = move_expired_inodes(&wb->b_dirty, &wb->b_io, older_than_this);
-	trace_writeback_queue_io(wb, older_than_this, moved);
+	moved = move_expired_inodes(&wb->b_dirty, &wb->b_io, work);
+	trace_writeback_queue_io(wb, work ? work->older_than_this : NULL,
+				 moved);
 }
 
 static int write_inode(struct inode *inode, struct writeback_control *wbc)
@@ -739,7 +740,7 @@ static long wb_writeback(struct bdi_writeback *wb,
 
 		trace_writeback_start(wb->bdi, work);
 		if (list_empty(&wb->b_io))
-			queue_io(wb, work->older_than_this);
+			queue_io(wb, work);
 		if (work->sb)
 			progress = writeback_sb_inodes(work->sb, wb, work);
 		else
-- 
1.7.3.1

