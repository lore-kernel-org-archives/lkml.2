Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751623Ab1JTXVX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Oct 2011 19:21:23 -0400
Received: from cantor2.suse.de ([195.135.220.15]:47535 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750870Ab1JTXVV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Oct 2011 19:21:21 -0400
Date: Fri, 21 Oct 2011 01:21:16 +0200
From: Jan Kara <jack@suse.cz>
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: linux-fsdevel@vger.kernel.org, Jan Kara <jack@suse.cz>,
        Dave Chinner <david@fromorbit.com>,
        Christoph Hellwig <hch@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/7] writeback: avoid touching dirtied_when on blocked
 inodes
Message-ID: <20111020232116.GB20542@quack.suse.cz>
References: <20111020152240.751936131@intel.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="XsQoSWH+UP9D9v3l"
Content-Disposition: inline
In-Reply-To: <20111020152240.751936131@intel.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--XsQoSWH+UP9D9v3l
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

  Hello,

On Thu 20-10-11 23:22:40, Wu Fengguang wrote:
> This tries to keep dirtied_when for blocked inodes by converting some
> redirty_tail() calls to requeue_io_wait(). The possibly blocked inodes
> will be moved to b_more_io_wait. The b_more_io_wait inodes will now be
> retried as dillegent as b_more_io inodes, except when the latter goes empty,
> b_more_io_wait will be retried by the kupdate work on increasing intervals
> until exceeding dirty_writeback_interval.
> 
> Christoph Hellwig (1):
>       writeback: avoid redirtying when ->write_inode failed to clear I_DIRTY
> 
> Jan Kara (2):
>       writeback: update wb->last_active on written pages/inodes
>       writeback: Retry kupdate work early if we need to retry some inode writeback
> 
> Wu Fengguang (4):
>       writeback: introduce queue b_more_io_wait
>       writeback: requeue_io_wait() on pages_skipped inode
>       writeback: requeue_io_wait() on blocked inode
>       writeback: requeue_io_wait() when failed to grab superblock
  How about adding the attached patch to the series? With it applied we
would have all busyloop prevention done in the same way.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR

--XsQoSWH+UP9D9v3l
Content-Type: text/x-patch; charset=us-ascii
Content-Disposition: attachment; filename="0001-writeback-requeue_io_wait-when-I_SYNC-is-set.patch"

>From 15f3c6f15891121ff8ca06e214f75c4bac9f2f80 Mon Sep 17 00:00:00 2001
From: Jan Kara <jack@suse.cz>
Date: Fri, 21 Oct 2011 01:15:43 +0200
Subject: [PATCH] writeback: requeue_io_wait() when I_SYNC is set

If writeback skips inode because it is already under writeback (I_SYNC flag is
set), we can now use requeue_io_wait() instead of requeue_io() and remove
special busyloop prevention in wb_writeback().

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/fs-writeback.c |   21 +++++++++------------
 1 files changed, 9 insertions(+), 12 deletions(-)

diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
index 89b9b70..4e5cae0 100644
--- a/fs/fs-writeback.c
+++ b/fs/fs-writeback.c
@@ -14,6 +14,7 @@
  */
 
 #include <linux/kernel.h>
+#include <linux/ratelimit.h>
 #include <linux/module.h>
 #include <linux/spinlock.h>
 #include <linux/slab.h>
@@ -391,7 +392,7 @@ writeback_single_inode(struct inode *inode, struct bdi_writeback *wb,
 		 * completed a full scan of b_io.
 		 */
 		if (wbc->sync_mode != WB_SYNC_ALL) {
-			requeue_io(inode, wb);
+			requeue_io_wait(inode, wb);
 			trace_writeback_single_inode_requeue(inode, wbc,
 							     nr_to_write);
 			return 0;
@@ -725,7 +726,6 @@ static long wb_writeback(struct bdi_writeback *wb,
 	unsigned long wb_start = jiffies;
 	long nr_pages = work->nr_pages;
 	unsigned long oldest_jif;
-	struct inode *inode;
 	long progress;
 	long total_progress = 0;
 
@@ -791,17 +791,14 @@ static long wb_writeback(struct bdi_writeback *wb,
 		if (list_empty(&wb->b_more_io))
 			break;
 		/*
-		 * Nothing written. Wait for some inode to
-		 * become available for writeback. Otherwise
-		 * we'll just busyloop.
+		 * Nothing written but some inodes were moved to b_more_io.
+		 * This should not happen as we can easily busyloop.
 		 */
-		if (!list_empty(&wb->b_more_io))  {
-			trace_writeback_wait(wb->bdi, work);
-			inode = wb_inode(wb->b_more_io.prev);
-			spin_lock(&inode->i_lock);
-			inode_wait_for_writeback(inode, wb);
-			spin_unlock(&inode->i_lock);
-		}
+		pr_warn_ratelimited("mm: Possible busyloop in data writeback "
+			"(bdi %s nr_pages %ld sync_mode %d kupdate %d "
+			"background %d)\n",
+			wb->bdi->name, work->nr_pages, work->sync_mode,
+			work->for_kupdate, work->for_background);
 	}
 	spin_unlock(&wb->list_lock);
 
-- 
1.7.1


--XsQoSWH+UP9D9v3l--
