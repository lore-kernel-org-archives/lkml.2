Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755568Ab2B0VXV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Feb 2012 16:23:21 -0500
Received: from acsinet15.oracle.com ([141.146.126.227]:33629 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755295Ab2B0VUZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Feb 2012 16:20:25 -0500
From: Dave Kleikamp <dave.kleikamp@oracle.com>
To: linux-fsdevel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Zach Brown <zab@zabbo.net>,
        Dave Kleikamp <dave.kleikamp@oracle.com>
Subject: [RFC PATCH 08/22] dio: create a dio_aligned() helper function
Date: Mon, 27 Feb 2012 15:19:22 -0600
Message-Id: <1330377576-3659-9-git-send-email-dave.kleikamp@oracle.com>
X-Mailer: git-send-email 1.7.9.2
In-Reply-To: <1330377576-3659-1-git-send-email-dave.kleikamp@oracle.com>
References: <1330377576-3659-1-git-send-email-dave.kleikamp@oracle.com>
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
X-CT-RefId: str=0001.0A090203.4F4BF399.0028,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Zach Brown <zab@zabbo.net>

__blockdev_direct_IO() had two instances of the same code to determine
if a given offset wasn't aligned first to the inode's blkbits and then
to the underlying device's blkbits.   This was confusing enough but
we're about to add code that performs the same check on offsets in bvec
arrays.  Rather than add yet more copies of this code let's have
everyone call a helper.

Signed-off-by: Dave Kleikamp <dave.kleikamp@oracle.com>
Cc: Zach Brown <zab@zabbo.net>
---
 fs/direct-io.c |   59 +++++++++++++++++++++++++++++++++++---------------------
 1 file changed, 37 insertions(+), 22 deletions(-)

diff --git a/fs/direct-io.c b/fs/direct-io.c
index 4a588db..21a1412 100644
--- a/fs/direct-io.c
+++ b/fs/direct-io.c
@@ -1064,6 +1064,39 @@ static inline int drop_refcount(struct dio *dio)
 }
 
 /*
+ * Returns true if the given offset is aligned to either the IO size
+ * specified by the given blkbits or by the logical block size of the
+ * given block device.
+ *
+ * If the given offset isn't aligned to the blkbits arguments as this is
+ * called then blkbits is set to the block size of the specified block
+ * device.  The call can then return either true or false.
+ *
+ * This bizarre calling convention matches the code paths that
+ * duplicated the functionality that this helper was built from.  We
+ * reproduce the behaviour to avoid introducing subtle bugs.
+ */
+static int dio_aligned(unsigned long offset, unsigned *blkbits,
+		       struct block_device *bdev)
+{
+	unsigned mask = (1 << *blkbits) - 1;
+
+	/*
+	 * Avoid references to bdev if not absolutely needed to give
+	 * the early prefetch in the caller enough time.
+	 */
+
+	if (offset & mask) {
+		if (bdev)
+			*blkbits = blksize_bits(bdev_logical_block_size(bdev));
+		mask = (1 << *blkbits) - 1;
+		return !(offset & mask);
+	}
+
+	return 1;
+}
+
+/*
  * This is a library function for use by filesystem drivers.
  *
  * The locking rules are governed by the flags parameter:
@@ -1098,7 +1131,6 @@ do_blockdev_direct_IO(int rw, struct kiocb *iocb, struct inode *inode,
 	size_t size;
 	unsigned long addr;
 	unsigned blkbits = inode->i_blkbits;
-	unsigned blocksize_mask = (1 << blkbits) - 1;
 	ssize_t retval = -EINVAL;
 	loff_t end = offset;
 	struct dio *dio;
@@ -1110,33 +1142,16 @@ do_blockdev_direct_IO(int rw, struct kiocb *iocb, struct inode *inode,
 	if (rw & WRITE)
 		rw = WRITE_ODIRECT;
 
-	/*
-	 * Avoid references to bdev if not absolutely needed to give
-	 * the early prefetch in the caller enough time.
-	 */
-
-	if (offset & blocksize_mask) {
-		if (bdev)
-			blkbits = blksize_bits(bdev_logical_block_size(bdev));
-		blocksize_mask = (1 << blkbits) - 1;
-		if (offset & blocksize_mask)
-			goto out;
-	}
+	if (!dio_aligned(offset, &blkbits, bdev))
+		goto out;
 
 	/* Check the memory alignment.  Blocks cannot straddle pages */
 	for (seg = 0; seg < nr_segs; seg++) {
 		addr = (unsigned long)iov[seg].iov_base;
 		size = iov[seg].iov_len;
 		end += size;
-		if (unlikely((addr & blocksize_mask) ||
-			     (size & blocksize_mask))) {
-			if (bdev)
-				blkbits = blksize_bits(
-					 bdev_logical_block_size(bdev));
-			blocksize_mask = (1 << blkbits) - 1;
-			if ((addr & blocksize_mask) || (size & blocksize_mask))
-				goto out;
-		}
+		if (!dio_aligned(addr|size, &blkbits, bdev))
+			goto out;
 	}
 
 	/* watch out for a 0 len io from a tricksy fs */
-- 
1.7.9.2

