Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754208Ab2DHBLV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Apr 2012 21:11:21 -0400
Received: from mga11.intel.com ([192.55.52.93]:52258 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752232Ab2DHBLU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Apr 2012 21:11:20 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="139016096"
Date: Sun, 8 Apr 2012 09:06:00 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Jens Axboe <axboe@kernel.dk>, linux-fsdevel@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        Dave Chinner <david@fromorbit.com>,
        Christoph Hellwig <hch@infradead.org>, Jan Kara <jack@suse.cz>,
        Chris Mason <chris.mason@oracle.com>, Shaohua Li <shli@fusionio.com>
Subject: [RESEND][PATCH v2] block: remove plugging at buffered write time
Message-ID: <20120408010600.GA31377@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Buffered write(2) is not directly tied to IO, so it's not suitable to
handle plug in generic_file_aio_write().

Also moves unplugging for direct I/O from around ->direct_IO() down to
do_blockdev_direct_IO().

Note that plugging for O_SYNC writes is also removed. The user may pass
arbitrary @size arguments, which may be much larger than the preferable
I/O size, or may cross extent/device boundaries. Let the lower layers
handle the plugging. Otherwise the plugging code here will turn the
low level plugging into no-ops.

CC: Jens Axboe <axboe@kernel.dk>
CC: Shaohua Li <shli@fusionio.com>
Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
---
 fs/direct-io.c |    5 +++++
 fs/sync.c      |   11 ++++++++++-
 mm/filemap.c   |    7 -------
 3 files changed, 15 insertions(+), 8 deletions(-)

--- linux-next.orig/mm/filemap.c	2012-02-08 19:33:29.000000000 +0800
+++ linux-next/mm/filemap.c	2012-02-09 15:59:47.000000000 +0800
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
--- linux-next.orig/fs/direct-io.c	2012-02-08 19:33:29.000000000 +0800
+++ linux-next/fs/direct-io.c	2012-02-09 16:03:04.000000000 +0800
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
@@ -1279,6 +1282,8 @@ do_blockdev_direct_IO(int rw, struct kio
 	if (sdio.bio)
 		dio_bio_submit(dio, &sdio);
 
+	blk_finish_plug(&plug);
+
 	/*
 	 * It is possible that, we return short IO due to end of file.
 	 * In that case, we need to release all the pages we got hold on.
