Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755955Ab0DWQR6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Apr 2010 12:17:58 -0400
Received: from mx1.redhat.com ([209.132.183.28]:13116 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754824Ab0DWQRz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Apr 2010 12:17:55 -0400
Date: Fri, 23 Apr 2010 12:17:17 -0400
From: Josef Bacik <josef@redhat.com>
To: torvalds@linux-foundation.org
Cc: akpm@linux-foundation.org, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, randy.dunlap@oracle.com
Subject: [PATCH] Cleanup generic block based fiemap
Message-ID: <20100423161716.GA3971@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

This patch cleans up a few of the complaints of __generic_block_fiemap.  I've
fixed all the typing stuff, used inline functions instead of macros, gotten rid
of a couple of variables, and made sure the size and block requests are all
block aligned.  It also fixes a problem where sometimes FIEMAP_EXTENT_LAST
wasn't being set properly.  Thanks,

Signed-off-by: Josef Bacik <josef@redhat.com>

diff --git a/fs/ioctl.c b/fs/ioctl.c
index 6c75110..7faefb4 100644
--- a/fs/ioctl.c
+++ b/fs/ioctl.c
@@ -228,14 +228,23 @@ static int ioctl_fiemap(struct file *filp, unsigned long arg)
 
 #ifdef CONFIG_BLOCK
 
-#define blk_to_logical(inode, blk) (blk << (inode)->i_blkbits)
-#define logical_to_blk(inode, offset) (offset >> (inode)->i_blkbits);
+static inline sector_t logical_to_blk(struct inode *inode, loff_t offset)
+{
+	return (offset >> inode->i_blkbits);
+}
+
+static inline loff_t blk_to_logical(struct inode *inode, sector_t blk)
+{
+	return (blk << inode->i_blkbits);
+}
 
 /**
  * __generic_block_fiemap - FIEMAP for block based inodes (no locking)
- * @inode - the inode to map
- * @arg - the pointer to userspace where we copy everything to
- * @get_block - the fs's get_block function
+ * @inode: the inode to map
+ * @fieinfo: the fiemap info struct that will be passed back to userspace
+ * @start: where to start mapping in the inode
+ * @len: how much space to map
+ * @get_block: the fs's get_block function
  *
  * This does FIEMAP for block based inodes.  Basically it will just loop
  * through get_block until we hit the number of extents we want to map, or we
@@ -250,58 +259,63 @@ static int ioctl_fiemap(struct file *filp, unsigned long arg)
  */
 
 int __generic_block_fiemap(struct inode *inode,
-			   struct fiemap_extent_info *fieinfo, u64 start,
-			   u64 len, get_block_t *get_block)
+			   struct fiemap_extent_info *fieinfo, loff_t start,
+			   loff_t len, get_block_t *get_block)
 {
-	struct buffer_head tmp;
-	unsigned long long start_blk;
-	long long length = 0, map_len = 0;
+	struct buffer_head map_bh;
+	sector_t start_blk, last_blk;
+	loff_t isize = i_size_read(inode);
 	u64 logical = 0, phys = 0, size = 0;
 	u32 flags = FIEMAP_EXTENT_MERGED;
-	int ret = 0, past_eof = 0, whole_file = 0;
+	bool past_eof = false, whole_file = false;
+	int ret = 0;
 
-	if ((ret = fiemap_check_flags(fieinfo, FIEMAP_FLAG_SYNC)))
+	ret = fiemap_check_flags(fieinfo, FIEMAP_FLAG_SYNC);
+	if (ret)
 		return ret;
 
-	start_blk = logical_to_blk(inode, start);
-
-	length = (long long)min_t(u64, len, i_size_read(inode));
-	if (length < len)
-		whole_file = 1;
+	/*
+	 * Either the i_mutex or other appropriate locking needs to be held
+	 * since we expect isize to not change at all through the duration of
+	 * this call.
+	 */
+	if (len >= isize) {
+		whole_file = true;
+		len = isize;
+	}
 
-	map_len = length;
+	start_blk = logical_to_blk(inode, start);
+	last_blk = logical_to_blk(inode, start + len - 1);
 
 	do {
 		/*
 		 * we set b_size to the total size we want so it will map as
 		 * many contiguous blocks as possible at once
 		 */
-		memset(&tmp, 0, sizeof(struct buffer_head));
-		tmp.b_size = map_len;
+		memset(&map_bh, 0, sizeof(struct buffer_head));
+		map_bh.b_size = len;
 
-		ret = get_block(inode, start_blk, &tmp, 0);
+		ret = get_block(inode, start_blk, &map_bh, 0);
 		if (ret)
 			break;
 
 		/* HOLE */
-		if (!buffer_mapped(&tmp)) {
-			length -= blk_to_logical(inode, 1);
+		if (!buffer_mapped(&map_bh)) {
 			start_blk++;
 
 			/*
-			 * we want to handle the case where there is an
+			 * We want to handle the case where there is an
 			 * allocated block at the front of the file, and then
 			 * nothing but holes up to the end of the file properly,
 			 * to make sure that extent at the front gets properly
 			 * marked with FIEMAP_EXTENT_LAST
 			 */
 			if (!past_eof &&
-			    blk_to_logical(inode, start_blk) >=
-			    blk_to_logical(inode, 0)+i_size_read(inode))
+			    blk_to_logical(inode, start_blk) >= isize)
 				past_eof = 1;
 
 			/*
-			 * first hole after going past the EOF, this is our
+			 * First hole after going past the EOF, this is our
 			 * last extent
 			 */
 			if (past_eof && size) {
@@ -309,15 +323,18 @@ int __generic_block_fiemap(struct inode *inode,
 				ret = fiemap_fill_next_extent(fieinfo, logical,
 							      phys, size,
 							      flags);
-				break;
+			} else if (size) {
+				ret = fiemap_fill_next_extent(fieinfo, logical,
+							      phys, size, flags);
+				size = 0;
 			}
 
 			/* if we have holes up to/past EOF then we're done */
-			if (length <= 0 || past_eof)
+			if (start_blk > last_blk || past_eof || ret)
 				break;
 		} else {
 			/*
-			 * we have gone over the length of what we wanted to
+			 * We have gone over the length of what we wanted to
 			 * map, and it wasn't the entire file, so add the extent
 			 * we got last time and exit.
 			 *
@@ -331,7 +348,7 @@ int __generic_block_fiemap(struct inode *inode,
 			 * are good to go, just add the extent to the fieinfo
 			 * and break
 			 */
-			if (length <= 0 && !whole_file) {
+			if (start_blk > last_blk && !whole_file) {
 				ret = fiemap_fill_next_extent(fieinfo, logical,
 							      phys, size,
 							      flags);
@@ -351,11 +368,10 @@ int __generic_block_fiemap(struct inode *inode,
 			}
 
 			logical = blk_to_logical(inode, start_blk);
-			phys = blk_to_logical(inode, tmp.b_blocknr);
-			size = tmp.b_size;
+			phys = blk_to_logical(inode, map_bh.b_blocknr);
+			size = map_bh.b_size;
 			flags = FIEMAP_EXTENT_MERGED;
 
-			length -= tmp.b_size;
 			start_blk += logical_to_blk(inode, size);
 
 			/*
@@ -363,15 +379,13 @@ int __generic_block_fiemap(struct inode *inode,
 			 * soon as we find a hole that the last extent we found
 			 * is marked with FIEMAP_EXTENT_LAST
 			 */
-			if (!past_eof &&
-			    logical+size >=
-			    blk_to_logical(inode, 0)+i_size_read(inode))
-				past_eof = 1;
+			if (!past_eof && logical + size >= isize)
+				past_eof = true;
 		}
 		cond_resched();
 	} while (1);
 
-	/* if ret is 1 then we just hit the end of the extent array */
+	/* If ret is 1 then we just hit the end of the extent array */
 	if (ret == 1)
 		ret = 0;
 
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 39d57bc..44f35ae 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -2315,8 +2315,9 @@ extern int vfs_fstatat(int , char __user *, struct kstat *, int);
 extern int do_vfs_ioctl(struct file *filp, unsigned int fd, unsigned int cmd,
 		    unsigned long arg);
 extern int __generic_block_fiemap(struct inode *inode,
-				  struct fiemap_extent_info *fieinfo, u64 start,
-				  u64 len, get_block_t *get_block);
+				  struct fiemap_extent_info *fieinfo,
+				  loff_t start, loff_t len,
+				  get_block_t *get_block);
 extern int generic_block_fiemap(struct inode *inode,
 				struct fiemap_extent_info *fieinfo, u64 start,
 				u64 len, get_block_t *get_block);
