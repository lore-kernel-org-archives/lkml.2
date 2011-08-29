Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755586Ab1H2XXt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Aug 2011 19:23:49 -0400
Received: from mga02.intel.com ([134.134.136.20]:24129 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755457Ab1H2XXa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Aug 2011 19:23:30 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="scan'208";a="43424144"
From: Andi Kleen <andi@firstfloor.org>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        viro@zeniv.linux.org.uk, Andi Kleen <ak@linux.intel.com>
Subject: [PATCH 11/11] DIO: optimize cache misses in the submission path v2
Date: Mon, 29 Aug 2011 16:23:22 -0700
Message-Id: <1314660202-661-12-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1314660202-661-1-git-send-email-andi@firstfloor.org>
References: <1314660202-661-1-git-send-email-andi@firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

Some investigation of a transaction processing workload showed that
a major consumer of cycles in __blockdev_direct_IO is the cache miss
while accessing the block size. This is because it has to walk
the chain from block_dev to gendisk to queue.

The block size is needed early on to check alignment and sizes.
It's only done if the check for the inode block size fails.
But the costly block device state is unconditionally fetched.

- Reorganize the code to only fetch block dev state when actually
needed.

Then do a prefetch on the block dev early on in the direct IO
path. This is worth it, because there is substantial code run
before we actually touch the block dev now.

- I also added some unlikelies to make it clear the compiler
that block device fetch code is not normally executed.

This gave a small, but measurable improvement on a large database
benchmark (about 0.3%)

v2: Remove unlikely (Jeff Moyer)
Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 fs/direct-io.c |   45 ++++++++++++++++++++++++++++++++++++---------
 1 files changed, 36 insertions(+), 9 deletions(-)

diff --git a/fs/direct-io.c b/fs/direct-io.c
index 03bcc6f..e149f5f 100644
--- a/fs/direct-io.c
+++ b/fs/direct-io.c
@@ -1086,8 +1086,8 @@ static inline int drop_refcount(struct dio *dio)
  * individual fields and will generate much worse code. 
  * This is important for the whole file.
  */
-ssize_t
-__blockdev_direct_IO(int rw, struct kiocb *iocb, struct inode *inode,
+static inline ssize_t
+do_blockdev_direct_IO(int rw, struct kiocb *iocb, struct inode *inode,
 	struct block_device *bdev, const struct iovec *iov, loff_t offset, 
 	unsigned long nr_segs, get_block_t get_block, dio_iodone_t end_io,
 	dio_submit_t submit_io,	int flags)
@@ -1096,7 +1096,6 @@ __blockdev_direct_IO(int rw, struct kiocb *iocb, struct inode *inode,
 	size_t size;
 	unsigned long addr;
 	unsigned blkbits = inode->i_blkbits;
-	unsigned bdev_blkbits = 0;
 	unsigned blocksize_mask = (1 << blkbits) - 1;
 	ssize_t retval = -EINVAL;
 	loff_t end = offset;
@@ -1109,12 +1108,14 @@ __blockdev_direct_IO(int rw, struct kiocb *iocb, struct inode *inode,
 	if (rw & WRITE)
 		rw = WRITE_ODIRECT;
 
-	if (bdev)
-		bdev_blkbits = blksize_bits(bdev_logical_block_size(bdev));
+	/* 
+	 * Avoid references to bdev if not absolutely needed to give
+	 * the early prefetch in the caller enough time.
+	 */
 
 	if (offset & blocksize_mask) {
 		if (bdev)
-			 blkbits = bdev_blkbits;
+			blkbits = blksize_bits(bdev_logical_block_size(bdev));
 		blocksize_mask = (1 << blkbits) - 1;
 		if (offset & blocksize_mask)
 			goto out;
@@ -1125,11 +1126,13 @@ __blockdev_direct_IO(int rw, struct kiocb *iocb, struct inode *inode,
 		addr = (unsigned long)iov[seg].iov_base;
 		size = iov[seg].iov_len;
 		end += size;
-		if ((addr & blocksize_mask) || (size & blocksize_mask))  {
+		if (unlikely((addr & blocksize_mask) || 
+			     (size & blocksize_mask)))  {
 			if (bdev)
-				 blkbits = bdev_blkbits;
+				 blkbits = blksize_bits(
+					 bdev_logical_block_size(bdev));
 			blocksize_mask = (1 << blkbits) - 1;
-			if ((addr & blocksize_mask) || (size & blocksize_mask))  
+			if ((addr & blocksize_mask) || (size & blocksize_mask))
 				goto out;
 		}
 	}
@@ -1312,6 +1315,30 @@ __blockdev_direct_IO(int rw, struct kiocb *iocb, struct inode *inode,
 out:
 	return retval;
 }
+
+ssize_t
+__blockdev_direct_IO(int rw, struct kiocb *iocb, struct inode *inode,
+	struct block_device *bdev, const struct iovec *iov, loff_t offset, 
+	unsigned long nr_segs, get_block_t get_block, dio_iodone_t end_io,
+	dio_submit_t submit_io,	int flags)
+{
+	/* 
+	 * The block device state is needed in the end to finally
+	 * submit everything.  Since it's likely to be cache cold
+	 * prefetch it here as first thing to hide some of the
+	 * latency.
+	 * 
+	 * Attempt to prefetch the pieces we likely need later.
+	 */
+	prefetch(&bdev->bd_disk->part_tbl);
+	prefetch(bdev->bd_queue);
+	prefetch((char *)bdev->bd_queue + SMP_CACHE_BYTES);
+
+	return do_blockdev_direct_IO(rw, iocb, inode, bdev, iov, offset,
+				     nr_segs, get_block, end_io,
+				     submit_io, flags);
+}
+
 EXPORT_SYMBOL(__blockdev_direct_IO);
 
 static __init int dio_init(void)
-- 
1.7.4.4

