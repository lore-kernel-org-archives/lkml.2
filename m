Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753127Ab2EFJLA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 May 2012 05:11:00 -0400
Received: from mga11.intel.com ([192.55.52.93]:6808 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752922Ab2EFJKy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 May 2012 05:10:54 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="149797012"
Date: Sun, 6 May 2012 14:04:06 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Jens Axboe <axboe@kernel.dk>, linux-fsdevel@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        Dave Chinner <david@fromorbit.com>,
        Christoph Hellwig <hch@infradead.org>, Jan Kara <jack@suse.cz>,
        Chris Mason <chris.mason@oracle.com>, Shaohua Li <shli@fusionio.com>,
        Jeff Moyer <jmoyer@redhat.com>
Subject: [PATCH] block: move down direct IO plugging
Message-ID: <20120506060406.GB11650@localhost>
References: <20120506060308.GA11650@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120506060308.GA11650@localhost>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move unplugging for direct I/O from around ->direct_IO() down to
do_blockdev_direct_IO(). This implicitly adds plugging for direct
writes.

CC: Jens Axboe <axboe@kernel.dk>
CC: Li Shaohua <shli@fusionio.com>
Acked-by: Jeff Moyer <jmoyer@redhat.com>
Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
---
 fs/direct-io.c |    5 +++++
 mm/filemap.c   |    4 ----
 2 files changed, 5 insertions(+), 4 deletions(-)

--- linux-next.orig/mm/filemap.c	2012-05-03 19:32:58.051123379 +0800
+++ linux-next/mm/filemap.c	2012-05-03 19:33:27.235124073 +0800
@@ -1413,12 +1413,8 @@ generic_file_aio_read(struct kiocb *iocb
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
--- linux-next.orig/fs/direct-io.c	2012-05-03 19:32:57.000000000 +0800
+++ linux-next/fs/direct-io.c	2012-05-03 19:33:27.235124073 +0800
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
