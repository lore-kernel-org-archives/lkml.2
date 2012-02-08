Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756966Ab2BHLLv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Feb 2012 06:11:51 -0500
Received: from mga03.intel.com ([143.182.124.21]:6993 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756794Ab2BHLLu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Feb 2012 06:11:50 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="104458051"
Date: Wed, 8 Feb 2012 19:01:44 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-fsdevel@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Jens Axboe <axboe@kernel.dk>, Li Shaohua <shaohua.li@intel.com>
Subject: [PATCH] block: remove plugging at buffered write time
Message-ID: <20120208110143.GA5550@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Buffered write(2) is not directly tied to IO, so it's not suitable to
handle plug in generic_file_aio_write().

Also remove the redundant plug calls around ->direct_IO(), since we now
do unplugging in the lower layer do_blockdev_direct_IO().

CC: Jens Axboe <axboe@kernel.dk>
CC: Li Shaohua <shaohua.li@intel.com>
Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
---
 fs/direct-io.c |    4 ++++
 mm/filemap.c   |    7 -------
 2 files changed, 4 insertions(+), 7 deletions(-)

--- linux-next.orig/mm/filemap.c	2012-02-08 18:51:50.000000000 +0800
+++ linux-next/mm/filemap.c	2012-02-08 18:52:19.000000000 +0800
@@ -1421,12 +1421,8 @@ generic_file_aio_read(struct kiocb *iocb
 			retval = filemap_write_and_wait_range(mapping, pos,
 					pos + iov_length(iov, nr_segs) - 1);
 			if (!retval) {
-				struct blk_plug plug;
-
-				blk_start_plug(&plug);
 				retval = mapping->a_ops->direct_IO(READ, iocb,
 							iov, pos, nr_segs);
-				blk_finish_plug(&plug);
 			}
 			if (retval > 0) {
 				*ppos = pos + retval;
@@ -2610,13 +2606,11 @@ ssize_t generic_file_aio_write(struct ki
 {
 	struct file *file = iocb->ki_filp;
 	struct inode *inode = file->f_mapping->host;
-	struct blk_plug plug;
 	ssize_t ret;
 
 	BUG_ON(iocb->ki_pos != pos);
 
 	mutex_lock(&inode->i_mutex);
-	blk_start_plug(&plug);
 	ret = __generic_file_aio_write(iocb, iov, nr_segs, &iocb->ki_pos);
 	mutex_unlock(&inode->i_mutex);
 
@@ -2627,7 +2621,6 @@ ssize_t generic_file_aio_write(struct ki
 		if (err < 0 && ret > 0)
 			ret = err;
 	}
-	blk_finish_plug(&plug);
 	return ret;
 }
 EXPORT_SYMBOL(generic_file_aio_write);
--- linux-next.orig/fs/direct-io.c	2012-02-08 18:51:37.000000000 +0800
+++ linux-next/fs/direct-io.c	2012-02-08 18:52:19.000000000 +0800
@@ -1106,6 +1106,7 @@ do_blockdev_direct_IO(int rw, struct kio
 	unsigned long user_addr;
 	size_t bytes;
 	struct buffer_head map_bh = { 0, };
+	struct blk_plug plug;
 
 	if (rw & WRITE)
 		rw = WRITE_ODIRECT;
@@ -1221,6 +1222,8 @@ do_blockdev_direct_IO(int rw, struct kio
 				PAGE_SIZE - user_addr / PAGE_SIZE);
 	}
 
+	blk_start_plug(&plug);
+
 	for (seg = 0; seg < nr_segs; seg++) {
 		user_addr = (unsigned long)iov[seg].iov_base;
 		sdio.size += bytes = iov[seg].iov_len;
@@ -1314,6 +1317,7 @@ do_blockdev_direct_IO(int rw, struct kio
 	} else
 		BUG_ON(retval != -EIOCBQUEUED);
 
+	blk_finish_plug(&plug);
 out:
 	return retval;
 }
