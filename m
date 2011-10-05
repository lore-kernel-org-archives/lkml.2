Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935246Ab1JER6p (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Oct 2011 13:58:45 -0400
Received: from cantor2.suse.de ([195.135.220.15]:35646 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758087Ab1JER6f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Oct 2011 13:58:35 -0400
From: Jan Kara <jack@suse.cz>
To: Christoph Hellwig <hch@infradead.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Jan Kara <jack@suse.cz>,
        Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 1/2] writeback: Improve busyloop prevention
Date: Wed,  5 Oct 2011 19:58:18 +0200
Message-Id: <1317837499-9842-2-git-send-email-jack@suse.cz>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1317837499-9842-1-git-send-email-jack@suse.cz>
References: <1317837499-9842-1-git-send-email-jack@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Writeback of an inode can be stalled by things like internal fs locks being
held. So in case we didn't write anything during a pass through b_io list,
just wait for a moment and try again.

CC: Christoph Hellwig <hch@infradead.org>
Reviewed-by: Wu Fengguang <fengguang.wu@intel.com>
Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/fs-writeback.c |   26 ++++++++++++++------------
 1 files changed, 14 insertions(+), 12 deletions(-)

diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
index 04cf3b9..bdeb26a 100644
--- a/fs/fs-writeback.c
+++ b/fs/fs-writeback.c
@@ -699,8 +699,8 @@ static long wb_writeback(struct bdi_writeback *wb,
 	unsigned long wb_start = jiffies;
 	long nr_pages = work->nr_pages;
 	unsigned long oldest_jif;
-	struct inode *inode;
 	long progress;
+	long pause = 1;
 
 	oldest_jif = jiffies;
 	work->older_than_this = &oldest_jif;
@@ -755,25 +755,27 @@ static long wb_writeback(struct bdi_writeback *wb,
 		 * mean the overall work is done. So we keep looping as long
 		 * as made some progress on cleaning pages or inodes.
 		 */
-		if (progress)
+		if (progress) {
+			pause = 1;
 			continue;
+		}
 		/*
 		 * No more inodes for IO, bail
 		 */
 		if (list_empty(&wb->b_more_io))
 			break;
 		/*
-		 * Nothing written. Wait for some inode to
-		 * become available for writeback. Otherwise
-		 * we'll just busyloop.
+		 * Nothing written (some internal fs locks were unavailable or
+		 * inode was under writeback from balance_dirty_pages() or
+		 * similar conditions).  Wait for a while to avoid busylooping.
 		 */
-		if (!list_empty(&wb->b_more_io))  {
-			trace_writeback_wait(wb->bdi, work);
-			inode = wb_inode(wb->b_more_io.prev);
-			spin_lock(&inode->i_lock);
-			inode_wait_for_writeback(inode, wb);
-			spin_unlock(&inode->i_lock);
-		}
+		trace_writeback_wait(wb->bdi, work);
+		spin_unlock(&wb->list_lock);
+		__set_current_state(TASK_INTERRUPTIBLE);
+		schedule_timeout(pause);
+		if (pause < HZ / 10)
+			pause <<= 1;
+		spin_lock(&wb->list_lock);
 	}
 	spin_unlock(&wb->list_lock);
 
-- 
1.7.1

