Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756698Ab1JTPjg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Oct 2011 11:39:36 -0400
Received: from mga03.intel.com ([143.182.124.21]:52461 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756343Ab1JTPiJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Oct 2011 11:38:09 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.69,379,1315206000"; 
   d="scan'208";a="64588848"
Message-Id: <20111020153706.523067174@intel.com>
User-Agent: quilt/0.48-1
Date: Thu, 20 Oct 2011 23:22:47 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
to: <linux-fsdevel@vger.kernel.org>
cc: Jan Kara <jack@suse.cz>, Dave Chinner <david@fromorbit.com>,
        Christoph Hellwig <hch@infradead.org>,
        Wu Fengguang <fengguang.wu@intel.com>
cc: Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 7/7] writeback: requeue_io_wait() when failed to grab superblock
References: <20111020152240.751936131@intel.com>
Content-Disposition: inline; filename=writeback-more_io_wait-grab.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It's some block condition that's not really related to the inode, but
still need to move it to b_more_io_wait to prevent possible busy looping.

CC: Jan Kara <jack@suse.cz>
Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
---
 fs/fs-writeback.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- linux-next.orig/fs/fs-writeback.c	2011-10-20 22:43:42.000000000 +0800
+++ linux-next/fs/fs-writeback.c	2011-10-20 22:46:53.000000000 +0800
@@ -652,17 +652,17 @@ static long __writeback_inodes_wb(struct
 		struct super_block *sb = inode->i_sb;
 
 		if (!grab_super_passive(sb)) {
 			/*
 			 * grab_super_passive() may fail consistently due to
 			 * s_umount being grabbed by someone else. Don't use
 			 * requeue_io() to avoid busy retrying the inode/sb.
 			 */
-			redirty_tail(inode, wb);
+			requeue_io_wait(inode, wb);
 			continue;
 		}
 		wrote += writeback_sb_inodes(sb, wb, work);
 		drop_super(sb);
 
 		/* refer to the same tests at the end of writeback_sb_inodes */
 		if (wrote) {
 			if (time_is_before_jiffies(start_time + HZ / 10UL))


