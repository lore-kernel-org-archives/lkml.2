Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756659Ab1JTPjJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Oct 2011 11:39:09 -0400
Received: from mga03.intel.com ([143.182.124.21]:52461 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756466Ab1JTPiJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Oct 2011 11:38:09 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.69,379,1315206000"; 
   d="scan'208";a="64588850"
Message-Id: <20111020153705.882281372@intel.com>
User-Agent: quilt/0.48-1
Date: Thu, 20 Oct 2011 23:22:42 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
to: <linux-fsdevel@vger.kernel.org>
cc: Jan Kara <jack@suse.cz>, Dave Chinner <david@fromorbit.com>,
        Christoph Hellwig <hch@infradead.org>, Christoph Hellwig <hch@lst.de>,
        Wu Fengguang <fengguang.wu@intel.com>
cc: Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 2/7] writeback: avoid redirtying when ->write_inode failed to clear I_DIRTY
References: <20111020152240.751936131@intel.com>
Content-Disposition: inline; filename=mutt-wfg-hp-1000-22575-612225d7a6295ddc6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Christoph Hellwig <hch@infradead.org>

Right now ->write_inode has no way to safely return a EAGAIN without explicitly
redirtying the inode, as we would lose the dirty state otherwise.  Most
filesystems get this wrong, but XFS makes heavy use of it to avoid blocking
the flusher thread when ->write_inode hits contentended inode locks.  A
contended ilock is something XFS can hit very easibly when extending files, as
the data I/O completion handler takes the lock to update the size, and the
->write_inode call can race with it fairly easily if writing enough data
in one go so that the completion for the first write come in just before
we call ->write_inode.

Change the handling of this case to use requeue_io_wait for a quick retry instead
of redirty_tail, which keeps moving out the dirtied_when data and thus keeps
delaying the writeout more and more with every failed attempt to get the lock.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
---
 fs/fs-writeback.c |   12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

--- linux-next.orig/fs/fs-writeback.c	2011-10-08 13:30:25.000000000 +0800
+++ linux-next/fs/fs-writeback.c	2011-10-08 13:30:41.000000000 +0800
@@ -488,8 +488,18 @@ writeback_single_inode(struct inode *ino
 			 * operations, such as delayed allocation during
 			 * submission or metadata updates after data IO
 			 * completion.
+			 *
+			 * For the latter case it is very important to give
+			 * the inode another turn on b_more_io instead of
+			 * redirtying it.  Constantly moving dirtied_when
+			 * forward will prevent us from ever writing out
+			 * the metadata dirtied in the I/O completion handler.
+			 *
+			 * For files on XFS that constantly get appended to
+			 * calling redirty_tail means they will never get
+			 * their updated i_size written out.
 			 */
-			redirty_tail(inode, wb);
+			requeue_io_wait(inode, wb);
 		} else {
 			/*
 			 * The inode is clean.  At this point we either have


