Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757453Ab1K3COv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Nov 2011 21:14:51 -0500
Received: from perches-mx.perches.com ([206.117.179.246]:44870 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757409Ab1K3COr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Nov 2011 21:14:47 -0500
From: Joe Perches <joe@perches.com>
To: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 01/28] buffer: Use pr_<level>
Date: Tue, 29 Nov 2011 18:13:59 -0800
Message-Id: <208643b5c6b1ce50fab37364b8f7aff7822e87bb.1322609672.git.joe@perches.com>
X-Mailer: git-send-email 1.7.6.405.gc1be0
In-Reply-To: <cover.1322609672.git.joe@perches.com>
References: <cover.1322609672.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the current logging styles.
Add #define pr_fmt.
Convert bare printks to pr_notice.
Coalesce format strings.
Align arguments.
Convert %Lu to %llu.

Signed-off-by: Joe Perches <joe@perches.com>
---
 fs/buffer.c |   58 ++++++++++++++++++++++++++--------------------------------
 1 files changed, 26 insertions(+), 32 deletions(-)

diff --git a/fs/buffer.c b/fs/buffer.c
index 929d620..576a1ba 100644
--- a/fs/buffer.c
+++ b/fs/buffer.c
@@ -18,6 +18,8 @@
  * async buffer flushing, 1999 Andrea Arcangeli <andrea@suse.de>
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/kernel.h>
 #include <linux/syscalls.h>
 #include <linux/fs.h>
@@ -107,9 +109,8 @@ static int quiet_error(struct buffer_head *bh)
 static void buffer_io_error(struct buffer_head *bh)
 {
 	char b[BDEVNAME_SIZE];
-	printk(KERN_ERR "Buffer I/O error on device %s, logical block %Lu\n",
-			bdevname(bh->b_bdev, b),
-			(unsigned long long)bh->b_blocknr);
+	pr_err("Buffer I/O error on device %s, logical block %llu\n",
+	       bdevname(bh->b_bdev, b), (unsigned long long)bh->b_blocknr);
 }
 
 /*
@@ -151,9 +152,8 @@ void end_buffer_write_sync(struct buffer_head *bh, int uptodate)
 	} else {
 		if (!quiet_error(bh)) {
 			buffer_io_error(bh);
-			printk(KERN_WARNING "lost page write due to "
-					"I/O error on %s\n",
-				       bdevname(bh->b_bdev, b));
+			pr_warn("lost page write due to I/O error on %s\n",
+				bdevname(bh->b_bdev, b));
 		}
 		set_buffer_write_io_error(bh);
 		clear_buffer_uptodate(bh);
@@ -215,14 +215,13 @@ __find_get_block_slow(struct block_device *bdev, sector_t block)
 	if (all_mapped) {
 		char b[BDEVNAME_SIZE];
 
-		printk("__find_get_block_slow() failed. "
-			"block=%llu, b_blocknr=%llu\n",
-			(unsigned long long)block,
-			(unsigned long long)bh->b_blocknr);
-		printk("b_state=0x%08lx, b_size=%zu\n",
-			bh->b_state, bh->b_size);
-		printk("device %s blocksize: %d\n", bdevname(bdev, b),
-			1 << bd_inode->i_blkbits);
+		pr_notice("__find_get_block_slow() failed. block=%llu, b_blocknr=%llu\n",
+			  (unsigned long long)block,
+			  (unsigned long long)bh->b_blocknr);
+		pr_notice("b_state=0x%08lx, b_size=%zu\n",
+			  bh->b_state, bh->b_size);
+		pr_notice("device %s blocksize: %d\n",
+			  bdevname(bdev, b), 1 << bd_inode->i_blkbits);
 	}
 out_unlock:
 	spin_unlock(&bd_mapping->private_lock);
@@ -383,9 +382,8 @@ void end_buffer_async_write(struct buffer_head *bh, int uptodate)
 	} else {
 		if (!quiet_error(bh)) {
 			buffer_io_error(bh);
-			printk(KERN_WARNING "lost page write due to "
-					"I/O error on %s\n",
-			       bdevname(bh->b_bdev, b));
+			pr_warn("lost page write due to I/O error on %s\n",
+				bdevname(bh->b_bdev, b));
 		}
 		set_bit(AS_EIO, &page->mapping->flags);
 		set_buffer_write_io_error(bh);
@@ -565,15 +563,14 @@ static void do_thaw_one(struct super_block *sb, void *unused)
 {
 	char b[BDEVNAME_SIZE];
 	while (sb->s_bdev && !thaw_bdev(sb->s_bdev, sb))
-		printk(KERN_WARNING "Emergency Thaw on %s\n",
-		       bdevname(sb->s_bdev, b));
+		pr_warn("Emergency Thaw on %s\n", bdevname(sb->s_bdev, b));
 }
 
 static void do_thaw_all(struct work_struct *work)
 {
 	iterate_supers(do_thaw_one, NULL);
 	kfree(work);
-	printk(KERN_WARNING "Emergency Thaw complete\n");
+	pr_warn("Emergency Thaw complete\n");
 }
 
 /**
@@ -1066,10 +1063,9 @@ grow_buffers(struct block_device *bdev, sector_t block, int size)
 	if (unlikely(index != block >> sizebits)) {
 		char b[BDEVNAME_SIZE];
 
-		printk(KERN_ERR "%s: requested out-of-range block %llu for "
-			"device %s\n",
-			__func__, (unsigned long long)block,
-			bdevname(bdev, b));
+		pr_err("%s: requested out-of-range block %llu for device %s\n",
+		       __func__, (unsigned long long)block,
+		       bdevname(bdev, b));
 		return -EIO;
 	}
 	block = index << sizebits;
@@ -1088,10 +1084,9 @@ __getblk_slow(struct block_device *bdev, sector_t block, int size)
 	/* Size must be multiple of hard sectorsize */
 	if (unlikely(size & (bdev_logical_block_size(bdev)-1) ||
 			(size < 512 || size > PAGE_SIZE))) {
-		printk(KERN_ERR "getblk(): invalid block size %d requested\n",
-					size);
-		printk(KERN_ERR "logical block size: %d\n",
-					bdev_logical_block_size(bdev));
+		pr_err("getblk(): invalid block size %d requested\n", size);
+		pr_err("logical block size: %d\n",
+		       bdev_logical_block_size(bdev));
 
 		dump_stack();
 		return NULL;
@@ -3174,10 +3169,9 @@ SYSCALL_DEFINE2(bdflush, int, func, long, data)
 
 	if (msg_count < 5) {
 		msg_count++;
-		printk(KERN_INFO
-			"warning: process `%s' used the obsolete bdflush"
-			" system call\n", current->comm);
-		printk(KERN_INFO "Fix your initscripts?\n");
+		pr_info("warning: process `%s' used the obsolete bdflush system call\n",
+			current->comm);
+		pr_info("Fix your initscripts?\n");
 	}
 
 	if (func == 1)
-- 
1.7.6.405.gc1be0

