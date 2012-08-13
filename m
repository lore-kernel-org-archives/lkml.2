Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751821Ab2HMKdz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2012 06:33:55 -0400
Received: from mga03.intel.com ([143.182.124.21]:38637 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751352Ab2HMKdw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2012 06:33:52 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.77,759,1336374000"; 
   d="scan'208";a="180314556"
From: Yuanhan Liu <yuanhan.liu@linux.intel.com>
To: linux-kernel@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org, Yuanhan Liu <yuanhan.liu@linux.intel.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>, Jens Axboe <axboe@kernel.dk>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [RFC PATCH 2/2] vfs: replace bdevname(bdev, b) with bdev->bd_name
Date: Mon, 13 Aug 2012 18:34:00 +0800
Message-Id: <1344854040-15334-2-git-send-email-yuanhan.liu@linux.intel.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1344854040-15334-1-git-send-email-yuanhan.liu@linux.intel.com>
References: <1344854040-15334-1-git-send-email-yuanhan.liu@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since we embeded block device name into struct block_device, we don't
need call a function bdevname() to get the name any more.

Here this patch replace all the code using bdevname() in vfs layer to
bdev->bd_name.

This patch servers as an example of using embeded block device name.
It makes the code a little cleaner and a bit smaller stack usage. If
this change is OK to you, I will file more patches to apply this change
to all other codes.

Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Yuanhan Liu <yuanhan.liu@linux.intel.com>
---
 fs/buffer.c |   27 ++++++++-------------------
 fs/super.c  |    4 +---
 2 files changed, 9 insertions(+), 22 deletions(-)

diff --git a/fs/buffer.c b/fs/buffer.c
index 9f6d2e4..79cec42 100644
--- a/fs/buffer.c
+++ b/fs/buffer.c
@@ -105,9 +105,8 @@ static int quiet_error(struct buffer_head *bh)
 
 static void buffer_io_error(struct buffer_head *bh)
 {
-	char b[BDEVNAME_SIZE];
 	printk(KERN_ERR "Buffer I/O error on device %s, logical block %Lu\n",
-			bdevname(bh->b_bdev, b),
+			bh->b_bdev->bd_name,
 			(unsigned long long)bh->b_blocknr);
 }
 
@@ -143,16 +142,13 @@ EXPORT_SYMBOL(end_buffer_read_sync);
 
 void end_buffer_write_sync(struct buffer_head *bh, int uptodate)
 {
-	char b[BDEVNAME_SIZE];
-
 	if (uptodate) {
 		set_buffer_uptodate(bh);
 	} else {
 		if (!quiet_error(bh)) {
 			buffer_io_error(bh);
-			printk(KERN_WARNING "lost page write due to "
-					"I/O error on %s\n",
-				       bdevname(bh->b_bdev, b));
+			printk(KERN_WARNING "lost page write due to I/O error "
+					    "on %s\n", bh->b_bdev->bd_name);
 		}
 		set_buffer_write_io_error(bh);
 		clear_buffer_uptodate(bh);
@@ -212,15 +208,13 @@ __find_get_block_slow(struct block_device *bdev, sector_t block)
 	 * elsewhere, don't buffer_error if we had some unmapped buffers
 	 */
 	if (all_mapped) {
-		char b[BDEVNAME_SIZE];
-
 		printk("__find_get_block_slow() failed. "
 			"block=%llu, b_blocknr=%llu\n",
 			(unsigned long long)block,
 			(unsigned long long)bh->b_blocknr);
 		printk("b_state=0x%08lx, b_size=%zu\n",
 			bh->b_state, bh->b_size);
-		printk("device %s blocksize: %d\n", bdevname(bdev, b),
+		printk("device %s blocksize: %d\n", bdev->bd_name,
 			1 << bd_inode->i_blkbits);
 	}
 out_unlock:
@@ -319,7 +313,6 @@ still_busy:
  */
 void end_buffer_async_write(struct buffer_head *bh, int uptodate)
 {
-	char b[BDEVNAME_SIZE];
 	unsigned long flags;
 	struct buffer_head *first;
 	struct buffer_head *tmp;
@@ -333,9 +326,8 @@ void end_buffer_async_write(struct buffer_head *bh, int uptodate)
 	} else {
 		if (!quiet_error(bh)) {
 			buffer_io_error(bh);
-			printk(KERN_WARNING "lost page write due to "
-					"I/O error on %s\n",
-			       bdevname(bh->b_bdev, b));
+			printk(KERN_WARNING "lost page write due to I/O error "
+					    "on %s\n", bh->b_bdev->bd_name);
 		}
 		set_bit(AS_EIO, &page->mapping->flags);
 		set_buffer_write_io_error(bh);
@@ -513,10 +505,9 @@ repeat:
 
 static void do_thaw_one(struct super_block *sb, void *unused)
 {
-	char b[BDEVNAME_SIZE];
 	while (sb->s_bdev && !thaw_bdev(sb->s_bdev, sb))
 		printk(KERN_WARNING "Emergency Thaw on %s\n",
-		       bdevname(sb->s_bdev, b));
+		       sb->s_bdev->bd_name);
 }
 
 static void do_thaw_all(struct work_struct *work)
@@ -1015,12 +1006,10 @@ grow_buffers(struct block_device *bdev, sector_t block, int size)
 	 * pagecache index.  (this comparison is done using sector_t types).
 	 */
 	if (unlikely(index != block >> sizebits)) {
-		char b[BDEVNAME_SIZE];
-
 		printk(KERN_ERR "%s: requested out-of-range block %llu for "
 			"device %s\n",
 			__func__, (unsigned long long)block,
-			bdevname(bdev, b));
+			bdev->bd_name);
 		return -EIO;
 	}
 	block = index << sizebits;
diff --git a/fs/super.c b/fs/super.c
index 0902cfa..1b9c2fd 100644
--- a/fs/super.c
+++ b/fs/super.c
@@ -1029,10 +1029,8 @@ struct dentry *mount_bdev(struct file_system_type *fs_type,
 		blkdev_put(bdev, mode);
 		down_write(&s->s_umount);
 	} else {
-		char b[BDEVNAME_SIZE];
-
 		s->s_mode = mode;
-		strlcpy(s->s_id, bdevname(bdev, b), sizeof(s->s_id));
+		strlcpy(s->s_id, bdev->bd_name, sizeof(s->s_id));
 		sb_set_blocksize(s, block_size(bdev));
 		error = fill_super(s, data, flags & MS_SILENT ? 1 : 0);
 		if (error) {
-- 
1.7.7.6

