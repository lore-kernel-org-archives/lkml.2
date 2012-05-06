Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753213Ab2EFJLY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 May 2012 05:11:24 -0400
Received: from mga11.intel.com ([192.55.52.93]:6808 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752973Ab2EFJK6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 May 2012 05:10:58 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="149797023"
Date: Sun, 6 May 2012 14:03:08 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Jens Axboe <axboe@kernel.dk>, linux-fsdevel@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        Dave Chinner <david@fromorbit.com>,
        Christoph Hellwig <hch@infradead.org>, Jan Kara <jack@suse.cz>,
        Chris Mason <chris.mason@oracle.com>, Shaohua Li <shli@fusionio.com>,
        Jeff Moyer <jmoyer@redhat.com>
Subject: [PATCH v3] block: remove plugging at buffered write time
Message-ID: <20120506060308.GA11650@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
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

CC: Jens Axboe <axboe@kernel.dk>
CC: Li Shaohua <shli@fusionio.com>
Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
---
 fs/direct-io.c |    5 +++++
 mm/filemap.c   |    7 -------
 2 files changed, 5 insertions(+), 7 deletions(-)

--- linux-next.orig/mm/filemap.c	2012-04-25 12:16:57.496149458 +0800
+++ linux-next/mm/filemap.c	2012-04-25 12:17:00.116149521 +0800
@@ -2605,13 +2601,11 @@ ssize_t generic_file_aio_write(struct ki
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
 
@@ -2622,7 +2616,6 @@ ssize_t generic_file_aio_write(struct ki
 		if (err < 0 && ret > 0)
 			ret = err;
 	}
-	blk_finish_plug(&plug);
 	return ret;
 }
 EXPORT_SYMBOL(generic_file_aio_write);
