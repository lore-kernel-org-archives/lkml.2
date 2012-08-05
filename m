Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754379Ab2HEIfQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Aug 2012 04:35:16 -0400
Received: from mga01.intel.com ([192.55.52.88]:29789 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752893Ab2HEIeo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Aug 2012 04:34:44 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="193349698"
Message-Id: <20120805083337.109517848@intel.com>
User-Agent: quilt/0.51-1
Date: Sun, 05 Aug 2012 16:26:15 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
to: Jens Axboe <axboe@kernel.dk>
CC: Andrew Morton <akpm@linux-foundation.org>, Li Shaohua <shli@fusionio.com>,
        Wu Fengguang <fengguang.wu@intel.com>
cc: <linux-fsdevel@vger.kernel.org>
cc: Damien Wyart <damien.wyart@free.fr>
CC: Jeff Moyer <jmoyer@redhat.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/2] block: remove plugging at buffered write time 
References: <20120805082614.071671796@intel.com>
Content-Disposition: inline; filename=remove-write-plug.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Buffered write(2) is not directly tied to IO, so it's not suitable to
handle plug in generic_file_aio_write().

Note that plugging for O_SYNC writes is also removed. The user may pass
arbitrary @size arguments, which may be much larger than the preferable
I/O size, or may cross extent/device boundaries. Let the lower layers
handle the plugging. The plugging code here actually turns them into
no-ops.

CC: Li Shaohua <shli@fusionio.com>
Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
---
 mm/filemap.c |    3 ---
 1 file changed, 3 deletions(-)

--- linux-next.orig/mm/filemap.c	2012-08-05 16:23:53.000000000 +0800
+++ linux-next/mm/filemap.c	2012-08-05 16:24:07.251464157 +0800
@@ -2527,14 +2527,12 @@ ssize_t generic_file_aio_write(struct ki
 {
 	struct file *file = iocb->ki_filp;
 	struct inode *inode = file->f_mapping->host;
-	struct blk_plug plug;
 	ssize_t ret;
 
 	BUG_ON(iocb->ki_pos != pos);
 
 	sb_start_write(inode->i_sb);
 	mutex_lock(&inode->i_mutex);
-	blk_start_plug(&plug);
 	ret = __generic_file_aio_write(iocb, iov, nr_segs, &iocb->ki_pos);
 	mutex_unlock(&inode->i_mutex);
 
@@ -2545,7 +2543,6 @@ ssize_t generic_file_aio_write(struct ki
 		if (err < 0 && ret > 0)
 			ret = err;
 	}
-	blk_finish_plug(&plug);
 	sb_end_write(inode->i_sb);
 	return ret;
 }


