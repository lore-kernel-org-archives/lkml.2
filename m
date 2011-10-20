Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756676Ab1JTPjf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Oct 2011 11:39:35 -0400
Received: from mga03.intel.com ([143.182.124.21]:27426 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756356Ab1JTPiJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Oct 2011 11:38:09 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.69,379,1315206000"; 
   d="scan'208";a="64588846"
Message-Id: <20111020153706.397951190@intel.com>
User-Agent: quilt/0.48-1
Date: Thu, 20 Oct 2011 23:22:46 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
to: <linux-fsdevel@vger.kernel.org>
cc: Jan Kara <jack@suse.cz>, Dave Chinner <david@fromorbit.com>,
        Christoph Hellwig <hch@infradead.org>,
        Wu Fengguang <fengguang.wu@intel.com>
cc: Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 6/7] writeback: requeue_io_wait() on blocked inode
References: <20111020152240.751936131@intel.com>
Content-Disposition: inline; filename=writeback-remove-redirty-blocked.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use requeue_io_wait() if inode is somehow blocked.

CC: Jan Kara <jack@suse.cz>
CC: Dave Chinner <david@fromorbit.com>
Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
---
 fs/fs-writeback.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- linux-next.orig/fs/fs-writeback.c	2011-10-20 22:42:25.000000000 +0800
+++ linux-next/fs/fs-writeback.c	2011-10-20 22:43:42.000000000 +0800
@@ -471,25 +471,25 @@ writeback_single_inode(struct inode *ino
 				/*
 				 * slice used up: queue for next turn
 				 */
 				requeue_io(inode, wb);
 			} else {
 				/*
 				 * Writeback blocked by something other than
 				 * congestion. Delay the inode for some time to
 				 * avoid spinning on the CPU (100% iowait)
 				 * retrying writeback of the dirty page/inode
 				 * that cannot be performed immediately.
 				 */
-				redirty_tail(inode, wb);
+				requeue_io_wait(inode, wb);
 			}
 		} else if (inode->i_state & I_DIRTY) {
 			/*
 			 * Filesystems can dirty the inode during writeback
 			 * operations, such as delayed allocation during
 			 * submission or metadata updates after data IO
 			 * completion.
 			 *
 			 * For the latter case it is very important to give
 			 * the inode another turn on b_more_io instead of
 			 * redirtying it.  Constantly moving dirtied_when
 			 * forward will prevent us from ever writing out


