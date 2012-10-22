Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753540Ab2JVPPp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2012 11:15:45 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:22967 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752731Ab2JVPPm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2012 11:15:42 -0400
From: Dave Kleikamp <dave.kleikamp@oracle.com>
To: linux-fsdevel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Zach Brown <zab@zabbo.net>,
        "Maxim V. Patlasov" <mpatlasov@parallels.com>,
        Dave Kleikamp <dave.kleikamp@oracle.com>
Subject: [PATCH 09/22] dio: create a dio_aligned() helper function
Date: Mon, 22 Oct 2012 10:15:09 -0500
Message-Id: <1350918922-6096-10-git-send-email-dave.kleikamp@oracle.com>
X-Mailer: git-send-email 1.7.12.4
In-Reply-To: <1350918922-6096-1-git-send-email-dave.kleikamp@oracle.com>
References: <1350918922-6096-1-git-send-email-dave.kleikamp@oracle.com>
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
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
 fs/direct-io.c | 59 ++++++++++++++++++++++++++++++++++++----------------------
 1 file changed, 37 insertions(+), 22 deletions(-)

diff --git a/fs/direct-io.c b/fs/direct-io.c
index f86c720..035c0a3 100644
--- a/fs/direct-io.c
+++ b/fs/direct-io.c
@@ -1020,6 +1020,39 @@ static inline int drop_refcount(struct dio *dio)
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
@@ -1054,7 +1087,6 @@ do_blockdev_direct_IO(int rw, struct kiocb *iocb, struct inode *inode,
 	size_t size;
 	unsigned long addr;
 	unsigned blkbits = inode->i_blkbits;
-	unsigned blocksize_mask = (1 << blkbits) - 1;
 	ssize_t retval = -EINVAL;
 	loff_t end = offset;
 	struct dio *dio;
@@ -1067,33 +1099,16 @@ do_blockdev_direct_IO(int rw, struct kiocb *iocb, struct inode *inode,
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
1.7.12.3

