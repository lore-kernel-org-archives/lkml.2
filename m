Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757613Ab2BIJ7q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Feb 2012 04:59:46 -0500
Received: from mga03.intel.com ([143.182.124.21]:52699 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757426Ab2BIJ7o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Feb 2012 04:59:44 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="104851088"
Date: Thu, 9 Feb 2012 17:49:38 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Damien Wyart <damien.wyart@free.fr>
Cc: Shaohua Li <shaohua.li@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-fsdevel@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH] block: remove plugging at buffered write time
Message-ID: <20120209094938.GA5403@localhost>
References: <20120208110143.GA5550@localhost>
 <1328750089.5949.1.camel@sli10-conroe>
 <20120209080726.GB28465@localhost>
 <20120209092535.GA10272@brouette>
 <20120209094019.GA516@brouette>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120209094019.GA516@brouette>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 09, 2012 at 10:40:19AM +0100, Damien Wyart wrote:
> > > Done, thanks! Here is the updated patch with O_SYNC write fix.
> 
> > Got these errors with the updated patch on top of 3.3-rc3:
> 
> > fs/sync.c: In function 'vfs_fsync_range':
> > fs/sync.c:167:18: error: storage size of 'plug' isn't known
> > fs/sync.c:173:2: error: implicit declaration of function 'blk_start_plug' [-Werror=implicit-function-declaration]
> > fs/sync.c:175:2: error: implicit declaration of function 'blk_finish_plug' [-Werror=implicit-function-declaration]
> > fs/sync.c:167:18: warning: unused variable 'plug' [-Wunused-variable]
> 
> Adding a #include <linux/blkdev.h> at the top of fs/sync.c solved the
> problem. Of course, this needs approval of a kernel developper before
> being added to the patch and resubmitted because I know adding #includes
> can have unwanted consequences sometimes or be seen as bloat...

Thank you! This includes the necessary blkdev.h and it compiles here too:

Subject: block: remove plugging at buffered write time 
Date: Tue Jan 31 18:25:48 CST 2012

Buffered write(2) is not directly tied to IO, so it's not suitable to
handle plug in generic_file_aio_write().

Also moves unplugging to lower layers:
- for direct I/O, from around ->direct_IO() to do_blockdev_direct_IO()
- for O_SYNC writes, to around ->fsync()

CC: Jens Axboe <axboe@kernel.dk>
CC: Li Shaohua <shaohua.li@intel.com>
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
--- linux-next.orig/fs/sync.c	2012-02-09 15:59:52.000000000 +0800
+++ linux-next/fs/sync.c	2012-02-09 17:39:02.000000000 +0800
@@ -15,6 +15,7 @@
 #include <linux/pagemap.h>
 #include <linux/quotaops.h>
 #include <linux/backing-dev.h>
+#include <linux/blkdev.h>
 #include "internal.h"
 
 #define VALID_FLAGS (SYNC_FILE_RANGE_WAIT_BEFORE|SYNC_FILE_RANGE_WRITE| \
@@ -164,9 +165,17 @@ SYSCALL_DEFINE1(syncfs, int, fd)
  */
 int vfs_fsync_range(struct file *file, loff_t start, loff_t end, int datasync)
 {
+	struct blk_plug plug;
+	int ret;
+
 	if (!file->f_op || !file->f_op->fsync)
 		return -EINVAL;
-	return file->f_op->fsync(file, start, end, datasync);
+
+	blk_start_plug(&plug);
+	ret = file->f_op->fsync(file, start, end, datasync);
+	blk_finish_plug(&plug);
+
+	return ret;
 }
 EXPORT_SYMBOL(vfs_fsync_range);
 
