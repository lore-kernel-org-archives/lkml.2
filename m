Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751925Ab1GaPKY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Jul 2011 11:10:24 -0400
Received: from mga03.intel.com ([143.182.124.21]:7547 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751772Ab1GaPKS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Jul 2011 11:10:18 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,296,1309762800"; 
   d="scan'208";a="33510259"
Date: Sun, 31 Jul 2011 23:10:14 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Christoph Hellwig <hch@infradead.org>, Jan Kara <jack@suse.cz>,
        Dave Chinner <david@fromorbit.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: xfstests 073 regression
Message-ID: <20110731151014.GA23106@localhost>
References: <20110728164105.GA18258@infradead.org>
 <20110729142121.GA21149@localhost>
 <20110730134422.GA1884@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110730134422.GA1884@infradead.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 30, 2011 at 09:44:22PM +0800, Christoph Hellwig wrote:
> This patch fixes the hang for me.

Thanks. It'd be better to get the _simple and tested_ fix into 3.1-rc1.
(if anyone find major problems with the fix, please speak up)

Linus, will you pull from this branch for the below one-liner change?

        git://git.kernel.org/pub/scm/linux/kernel/git/wfg/writeback.git urgent-for-linus

Thanks,
Fengguang
---

>From 0e995816f4fb69cef602b7fe82da68ced6be3b41 Mon Sep 17 00:00:00 2001
From: Wu Fengguang <fengguang.wu@intel.com>
Date: Fri, 29 Jul 2011 22:14:35 -0600
Subject: [PATCH] don't busy retry the inode on failed grab_super_passive()

This fixes a soft lockup on conditions

a) the flusher is working on a work by __bdi_start_writeback(), while

b) someone else calls writeback_inodes_sb*() or sync_inodes_sb(), which
   grab sb->s_umount and enqueue a new work for the flusher to execute

The s_umount grabbed by (b) will fail the grab_super_passive() in (a).
Then if the inode is requeued, wb_writeback() will busy retry on it.
As a result, wb_writeback() loops for ever without releasing
wb->list_lock, which further blocks other tasks.

Fix the busy loop by redirtying the inode. This may undesirably delay
the writeback of the inode, however most likely it will be picked up
soon by the queued work by writeback_inodes_sb*(), sync_inodes_sb() or
even writeback_inodes_wb().

bug url: http://www.spinics.net/lists/linux-fsdevel/msg47292.html

Reported-by: Christoph Hellwig <hch@infradead.org>
Tested-by: Christoph Hellwig <hch@infradead.org>
Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
---
 fs/fs-writeback.c |    7 ++++++-
 1 files changed, 6 insertions(+), 1 deletions(-)

diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
index 1599aa9..04cf3b9 100644
--- a/fs/fs-writeback.c
+++ b/fs/fs-writeback.c
@@ -618,7 +618,12 @@ static long __writeback_inodes_wb(struct bdi_writeback *wb,
 		struct super_block *sb = inode->i_sb;
 
 		if (!grab_super_passive(sb)) {
-			requeue_io(inode, wb);
+			/*
+			 * grab_super_passive() may fail consistently due to
+			 * s_umount being grabbed by someone else. Don't use
+			 * requeue_io() to avoid busy retrying the inode/sb.
+			 */
+			redirty_tail(inode, wb);
 			continue;
 		}
 		wrote += writeback_sb_inodes(sb, wb, work);
-- 
1.7.2.3

