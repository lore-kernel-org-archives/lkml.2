Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754353Ab2HEIer (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Aug 2012 04:34:47 -0400
Received: from mga01.intel.com ([192.55.52.88]:29789 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754067Ab2HEIep (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Aug 2012 04:34:45 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="193349700"
Message-Id: <20120805083337.187282560@intel.com>
User-Agent: quilt/0.51-1
Date: Sun, 05 Aug 2012 16:26:16 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
to: Jens Axboe <axboe@kernel.dk>
CC: Andrew Morton <akpm@linux-foundation.org>, Li Shaohua <shli@fusionio.com>,
        Jeff Moyer <jmoyer@redhat.com>, Wu Fengguang <fengguang.wu@intel.com>
cc: <linux-fsdevel@vger.kernel.org>
cc: Damien Wyart <damien.wyart@free.fr>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 2/2] block: move down direct IO plugging
References: <20120805082614.071671796@intel.com>
Content-Disposition: inline; filename=move-down-directio-plug.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move unplugging for direct I/O from around ->direct_IO() down to
do_blockdev_direct_IO(). This implicitly adds plugging for direct
writes.

CC: Li Shaohua <shli@fusionio.com>
Acked-by: Jeff Moyer <jmoyer@redhat.com>
Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
---
 fs/direct-io.c |    5 +++++
 mm/filemap.c   |    4 ----
 2 files changed, 5 insertions(+), 4 deletions(-)

--- linux-next.orig/mm/filemap.c	2012-08-05 16:24:47.859465122 +0800
+++ linux-next/mm/filemap.c	2012-08-05 16:24:48.407465135 +0800
@@ -1412,12 +1412,8 @@ generic_file_aio_read(struct kiocb *iocb
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
--- linux-next.orig/fs/direct-io.c	2012-07-07 21:46:39.531508198 +0800
+++ linux-next/fs/direct-io.c	2012-08-05 16:24:48.411465136 +0800
@@ -1062,6 +1062,7 @@ do_blockdev_direct_IO(int rw, struct kio
 	unsigned long user_addr;
 	size_t bytes;
 	struct buffer_head map_bh = { 0, };
+	struct blk_plug plug;
 
 	if (rw & WRITE)
 		rw = WRITE_ODIRECT;
@@ -1177,6 +1178,8 @@ do_blockdev_direct_IO(int rw, struct kio
 				PAGE_SIZE - user_addr / PAGE_SIZE);
 	}
 
+	blk_start_plug(&plug);
+
 	for (seg = 0; seg < nr_segs; seg++) {
 		user_addr = (unsigned long)iov[seg].iov_base;
 		sdio.size += bytes = iov[seg].iov_len;
@@ -1235,6 +1238,8 @@ do_blockdev_direct_IO(int rw, struct kio
 	if (sdio.bio)
 		dio_bio_submit(dio, &sdio);
 
+	blk_finish_plug(&plug);
+
 	/*
 	 * It is possible that, we return short IO due to end of file.
 	 * In that case, we need to release all the pages we got hold on.


