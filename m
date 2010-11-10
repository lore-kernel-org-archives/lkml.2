Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757537Ab0KJXq2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Nov 2010 18:46:28 -0500
Received: from mail.perches.com ([173.55.12.10]:4949 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757421Ab0KJXq0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Nov 2010 18:46:26 -0500
From: Joe Perches <joe@perches.com>
To: linux-kernel@vger.kernel.org
Subject: [PATCH 3/6] fs/befs: Add printf format/argument verification and fix fallout
Date: Wed, 10 Nov 2010 15:46:15 -0800
Message-Id: <9b7d5766a79881a051e0e1c01e831cd7025f5c25.1289432524.git.joe@perches.com>
X-Mailer: git-send-email 1.7.3.1.g432b3.dirty
In-Reply-To: <cover.1289432524.git.joe@perches.com>
References: <cover.1289432524.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add __attribute__((format... to befs_error, befs_warning and befs_debug.
Change formats and arguments of u64 to %llu and (unsigned long long).

Signed-off-by: Joe Perches <joe@perches.com>
---
 fs/befs/befs.h       |    3 ++
 fs/befs/btree.c      |    5 ++-
 fs/befs/datastream.c |   76 +++++++++++++++++++++++++++++--------------------
 fs/befs/inode.c      |   11 ++++--
 fs/befs/io.c         |   12 +++++--
 fs/befs/linuxvfs.c   |   19 +++++++-----
 6 files changed, 77 insertions(+), 49 deletions(-)

diff --git a/fs/befs/befs.h b/fs/befs/befs.h
index d9a40ab..c7619b2 100644
--- a/fs/befs/befs.h
+++ b/fs/befs/befs.h
@@ -88,8 +88,11 @@ enum befs_err {
 
 /****************************/
 /* debug.c */
+__attribute__ ((format(printf, 2, 3)))
 void befs_error(const struct super_block *sb, const char *fmt, ...);
+__attribute__ ((format(printf, 2, 3)))
 void befs_warning(const struct super_block *sb, const char *fmt, ...);
+__attribute__ ((format(printf, 2, 3)))
 void befs_debug(const struct super_block *sb, const char *fmt, ...);
 
 void befs_dump_super_block(const struct super_block *sb, befs_super_block *);
diff --git a/fs/befs/btree.c b/fs/befs/btree.c
index 4202db7..95cbe72 100644
--- a/fs/befs/btree.c
+++ b/fs/befs/btree.c
@@ -468,8 +468,9 @@ befs_btree_read(struct super_block *sb, befs_data_stream * ds,
 			*keysize = 0;
 			*value = 0;
 			befs_debug(sb,
-				   "<--- befs_btree_read() END of keys at %Lu",
-				   key_sum + this_node->head.all_key_count);
+				   "<--- befs_btree_read() END of keys at %llu",
+				   (unsigned long long)
+				   (key_sum + this_node->head.all_key_count));
 			brelse(this_node->bh);
 			kfree(this_node);
 			return BEFS_BT_END;
diff --git a/fs/befs/datastream.c b/fs/befs/datastream.c
index 59096b5..a0ea94f 100644
--- a/fs/befs/datastream.c
+++ b/fs/befs/datastream.c
@@ -52,26 +52,27 @@ befs_read_datastream(struct super_block *sb, befs_data_stream * ds,
 	befs_block_run run;
 	befs_blocknr_t block;	/* block coresponding to pos */
 
-	befs_debug(sb, "---> befs_read_datastream() %Lu", pos);
+	befs_debug(sb, "---> befs_read_datastream() %llu",
+		   (unsigned long long)pos);
 	block = pos >> BEFS_SB(sb)->block_shift;
 	if (off)
 		*off = pos - (block << BEFS_SB(sb)->block_shift);
 
 	if (befs_fblock2brun(sb, ds, block, &run) != BEFS_OK) {
-		befs_error(sb, "BeFS: Error finding disk addr of block %lu",
-			   block);
+		befs_error(sb, "BeFS: Error finding disk addr of block %llu",
+			   (unsigned long long)block);
 		befs_debug(sb, "<--- befs_read_datastream() ERROR");
 		return NULL;
 	}
 	bh = befs_bread_iaddr(sb, run);
 	if (!bh) {
-		befs_error(sb, "BeFS: Error reading block %lu from datastream",
-			   block);
+		befs_error(sb, "BeFS: Error reading block %llu from datastream",
+			   (unsigned long long)block);
 		return NULL;
 	}
 
-	befs_debug(sb, "<--- befs_read_datastream() read data, starting at %Lu",
-		   pos);
+	befs_debug(sb, "<--- befs_read_datastream() read data, starting at %llu",
+		   (unsigned long long)pos);
 
 	return bh;
 }
@@ -105,8 +106,9 @@ befs_fblock2brun(struct super_block *sb, befs_data_stream * data,
 
 	} else {
 		befs_error(sb,
-			   "befs_fblock2brun() was asked to find block %lu, "
-			   "which is not mapped by the datastream\n", fblock);
+			   "befs_fblock2brun() was asked to find block %llu, "
+			   "which is not mapped by the datastream\n",
+			   (unsigned long long)fblock);
 		err = BEFS_ERR;
 	}
 	return err;
@@ -128,13 +130,15 @@ befs_read_lsymlink(struct super_block * sb, befs_data_stream * ds, void *buff,
 	befs_off_t bytes_read = 0;	/* bytes readed */
 	u16 plen;
 	struct buffer_head *bh = NULL;
-	befs_debug(sb, "---> befs_read_lsymlink() length: %Lu", len);
+	befs_debug(sb, "---> befs_read_lsymlink() length: %llu",
+		   (unsigned long long)len);
 
 	while (bytes_read < len) {
 		bh = befs_read_datastream(sb, ds, bytes_read, NULL);
 		if (!bh) {
 			befs_error(sb, "BeFS: Error reading datastream block "
-				   "starting from %Lu", bytes_read);
+				   "starting from %llu",
+				   (unsigned long long)bytes_read);
 			befs_debug(sb, "<--- befs_read_lsymlink() ERROR");
 			return bytes_read;
 
@@ -146,7 +150,8 @@ befs_read_lsymlink(struct super_block * sb, befs_data_stream * ds, void *buff,
 		bytes_read += plen;
 	}
 
-	befs_debug(sb, "<--- befs_read_lsymlink() read %u bytes", bytes_read);
+	befs_debug(sb, "<--- befs_read_lsymlink() read %llu bytes",
+		   (unsigned long long)bytes_read);
 	return bytes_read;
 }
 
@@ -206,7 +211,8 @@ befs_count_blocks(struct super_block * sb, befs_data_stream * ds)
 	}
 
 	blocks = datablocks + metablocks;
-	befs_debug(sb, "<--- befs_count_blocks() %u blocks", blocks);
+	befs_debug(sb, "<--- befs_count_blocks() %llu blocks",
+		   (unsigned long long)blocks);
 
 	return blocks;
 }
@@ -251,7 +257,8 @@ befs_find_brun_direct(struct super_block *sb, befs_data_stream * data,
 	befs_blocknr_t max_block =
 	    data->max_direct_range >> BEFS_SB(sb)->block_shift;
 
-	befs_debug(sb, "---> befs_find_brun_direct(), find %lu", blockno);
+	befs_debug(sb, "---> befs_find_brun_direct(), find %llu",
+		   (unsigned long long)blockno);
 
 	if (blockno > max_block) {
 		befs_error(sb, "befs_find_brun_direct() passed block outside of"
@@ -268,7 +275,8 @@ befs_find_brun_direct(struct super_block *sb, befs_data_stream * data,
 			run->len = array[i].len - offset;
 
 			befs_debug(sb, "---> befs_find_brun_direct(), "
-				   "found %lu at direct[%d]", blockno, i);
+				   "found %llu at direct[%d]",
+				   (unsigned long long)blockno, i);
 			return BEFS_OK;
 		}
 	}
@@ -316,7 +324,8 @@ befs_find_brun_indirect(struct super_block *sb,
 	befs_blocknr_t indirblockno = iaddr2blockno(sb, &indirect);
 	int arraylen = befs_iaddrs_per_block(sb);
 
-	befs_debug(sb, "---> befs_find_brun_indirect(), find %lu", blockno);
+	befs_debug(sb, "---> befs_find_brun_indirect(), find %llu",
+		   (unsigned long long)blockno);
 
 	indir_start_blk = data->max_direct_range >> BEFS_SB(sb)->block_shift;
 	search_blk = blockno - indir_start_blk;
@@ -327,8 +336,8 @@ befs_find_brun_indirect(struct super_block *sb,
 		if (indirblock == NULL) {
 			befs_debug(sb,
 				   "---> befs_find_brun_indirect() failed to "
-				   "read disk block %lu from the indirect brun",
-				   indirblockno + i);
+				   "read disk block %llu from the indirect brun",
+				   (unsigned long long)(indirblockno + i));
 			return BEFS_ERR;
 		}
 
@@ -349,8 +358,9 @@ befs_find_brun_indirect(struct super_block *sb,
 				brelse(indirblock);
 				befs_debug(sb,
 					   "<--- befs_find_brun_indirect() found "
-					   "file block %lu at indirect[%d]",
-					   blockno, j + (i * arraylen));
+					   "file block %llu at indirect[%d]",
+					   (unsigned long long)blockno,
+					   j + (i * arraylen));
 				return BEFS_OK;
 			}
 			sum += len;
@@ -361,7 +371,7 @@ befs_find_brun_indirect(struct super_block *sb,
 
 	/* Only fallthrough is an error */
 	befs_error(sb, "BeFS: befs_find_brun_indirect() failed to find "
-		   "file block %lu", blockno);
+		   "file block %llu", (unsigned long long)blockno);
 
 	befs_debug(sb, "<--- befs_find_brun_indirect() ERROR");
 	return BEFS_ERR;
@@ -444,7 +454,8 @@ befs_find_brun_dblindirect(struct super_block *sb,
 	size_t diblklen = iblklen * befs_iaddrs_per_block(sb)
 	    * BEFS_DBLINDIR_BRUN_LEN;
 
-	befs_debug(sb, "---> befs_find_brun_dblindirect() find %lu", blockno);
+	befs_debug(sb, "---> befs_find_brun_dblindirect() find %llu",
+		   (unsigned long long)blockno);
 
 	/* First, discover which of the double_indir->indir blocks
 	 * contains pos. Then figure out how much of pos that
@@ -470,10 +481,11 @@ befs_find_brun_dblindirect(struct super_block *sb,
 					dbl_which_block);
 	if (dbl_indir_block == NULL) {
 		befs_error(sb, "befs_read_brun_dblindirect() couldn't read the "
-			   "double-indirect block at blockno %lu",
-			   iaddr2blockno(sb,
-					 &data->double_indirect) +
-			   dbl_which_block);
+			   "double-indirect block at blockno %llu",
+			   (unsigned long long)
+			   (iaddr2blockno(sb,
+					  &data->double_indirect) +
+			    dbl_which_block));
 		brelse(dbl_indir_block);
 		return BEFS_ERR;
 	}
@@ -498,8 +510,9 @@ befs_find_brun_dblindirect(struct super_block *sb,
 	    befs_bread(sb, iaddr2blockno(sb, &indir_run) + which_block);
 	if (indir_block == NULL) {
 		befs_error(sb, "befs_read_brun_dblindirect() couldn't read the "
-			   "indirect block at blockno %lu",
-			   iaddr2blockno(sb, &indir_run) + which_block);
+			   "indirect block at blockno %llu",
+			   (unsigned long long)
+			   (iaddr2blockno(sb, &indir_run) + which_block));
 		brelse(indir_block);
 		return BEFS_ERR;
 	}
@@ -518,9 +531,10 @@ befs_find_brun_dblindirect(struct super_block *sb,
 	run->start += offset;
 	run->len -= offset;
 
-	befs_debug(sb, "Found file block %lu in double_indirect[%d][%d],"
-		   " double_indirect_leftover = %lu",
-		   blockno, dblindir_indx, indir_indx, dblindir_leftover);
+	befs_debug(sb, "Found file block %llu in double_indirect[%d][%d],"
+		   " double_indirect_leftover = %llu",
+		   (unsigned long long)blockno, dblindir_indx, indir_indx,
+		   (unsigned long long)dblindir_leftover);
 
 	return BEFS_OK;
 }
diff --git a/fs/befs/inode.c b/fs/befs/inode.c
index 94c17f9..4258023 100644
--- a/fs/befs/inode.c
+++ b/fs/befs/inode.c
@@ -25,7 +25,8 @@ befs_check_inode(struct super_block *sb, befs_inode * raw_inode,
 	/* check magic header. */
 	if (magic1 != BEFS_INODE_MAGIC1) {
 		befs_error(sb,
-			   "Inode has a bad magic header - inode = %lu", inode);
+			   "Inode has a bad magic header - inode = %llu",
+			   (unsigned long long)inode);
 		return BEFS_BAD_INODE;
 	}
 
@@ -34,8 +35,9 @@ befs_check_inode(struct super_block *sb, befs_inode * raw_inode,
 	 */
 	if (inode != iaddr2blockno(sb, &ino_num)) {
 		befs_error(sb, "inode blocknr field disagrees with vfs "
-			   "VFS: %lu, Inode %lu",
-			   inode, iaddr2blockno(sb, &ino_num));
+			   "VFS: %llu, Inode %llu",
+			   (unsigned long long)inode,
+			   (unsigned long long)iaddr2blockno(sb, &ino_num));
 		return BEFS_BAD_INODE;
 	}
 
@@ -44,7 +46,8 @@ befs_check_inode(struct super_block *sb, befs_inode * raw_inode,
 	 */
 
 	if (!(flags & BEFS_INODE_IN_USE)) {
-		befs_error(sb, "inode is not used - inode = %lu", inode);
+		befs_error(sb, "inode is not used - inode = %llu",
+			   (unsigned long long)inode);
 		return BEFS_BAD_INODE;
 	}
 
diff --git a/fs/befs/io.c b/fs/befs/io.c
index ddef98a..3c16fcb 100644
--- a/fs/befs/io.c
+++ b/fs/befs/io.c
@@ -42,12 +42,14 @@ befs_bread_iaddr(struct super_block *sb, befs_inode_addr iaddr)
 
 	block = iaddr2blockno(sb, &iaddr);
 
-	befs_debug(sb, "befs_read_iaddr: offset = %lu", block);
+	befs_debug(sb, "befs_read_iaddr: offset = %llu",
+		   (unsigned long long)block);
 
 	bh = sb_bread(sb, block);
 
 	if (bh == NULL) {
-		befs_error(sb, "Failed to read block %lu", block);
+		befs_error(sb, "Failed to read block %llu",
+			   (unsigned long long)block);
 		goto error;
 	}
 
@@ -64,12 +66,14 @@ befs_bread(struct super_block *sb, befs_blocknr_t block)
 {
 	struct buffer_head *bh = NULL;
 
-	befs_debug(sb, "---> Enter befs_read() %Lu", block);
+	befs_debug(sb, "---> Enter befs_read() %llu",
+		   (unsigned long long)block);
 
 	bh = sb_bread(sb, block);
 
 	if (bh == NULL) {
-		befs_error(sb, "Failed to read block %lu", block);
+		befs_error(sb, "Failed to read block %llu",
+			   (unsigned long long)block);
 		goto error;
 	}
 
diff --git a/fs/befs/linuxvfs.c b/fs/befs/linuxvfs.c
index aa4e7c7..ee265eb 100644
--- a/fs/befs/linuxvfs.c
+++ b/fs/befs/linuxvfs.c
@@ -125,19 +125,20 @@ befs_get_block(struct inode *inode, sector_t block,
 	int res = 0;
 	ulong disk_off;
 
-	befs_debug(sb, "---> befs_get_block() for inode %lu, block %ld",
-		   inode->i_ino, block);
+	befs_debug(sb, "---> befs_get_block() for inode %lu, block %llu",
+		   inode->i_ino, (unsigned long long)block);
 
 	if (block < 0) {
 		befs_error(sb, "befs_get_block() was asked for a block "
-			   "number less than zero: block %ld in inode %lu",
-			   block, inode->i_ino);
+			   "number less than zero: block %llu in inode %lu",
+			   (unsigned long long)block, inode->i_ino);
 		return -EIO;
 	}
 
 	if (create) {
 		befs_error(sb, "befs_get_block() was asked to write to "
-			   "block %ld in inode %lu", block, inode->i_ino);
+			   "block %llu in inode %lu",
+			   (unsigned long long)block, inode->i_ino);
 		return -EPERM;
 	}
 
@@ -145,7 +146,8 @@ befs_get_block(struct inode *inode, sector_t block,
 	if (res != BEFS_OK) {
 		befs_error(sb,
 			   "<--- befs_get_block() for inode %lu, block "
-			   "%ld ERROR", inode->i_ino, block);
+			   "%llu ERROR", inode->i_ino,
+			   (unsigned long long)block);
 		return -EFBIG;
 	}
 
@@ -153,8 +155,9 @@ befs_get_block(struct inode *inode, sector_t block,
 
 	map_bh(bh_result, inode->i_sb, disk_off);
 
-	befs_debug(sb, "<--- befs_get_block() for inode %lu, block %ld, "
-		   "disk address %lu", inode->i_ino, block, disk_off);
+	befs_debug(sb, "<--- befs_get_block() for inode %lu, block %llu, "
+		   "disk address %lu", inode->i_ino, (unsigned long long)block,
+		   disk_off);
 
 	return 0;
 }
-- 
1.7.3.1.g432b3.dirty

