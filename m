Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754418Ab2HTEGz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2012 00:06:55 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:51799 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752154Ab2HTEAr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2012 00:00:47 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Dave Jones <davej@redhat.com>, "Theodore Tso" <tytso@mit.edu>
Subject: [ 24/46] ext4: dont call ext4_error while block group is locked
Date: Sun, 19 Aug 2012 20:59:00 -0700
Message-Id: <20120820035835.633774496@linuxfoundation.org>
X-Mailer: git-send-email 1.7.10.2.565.gbd578b5
In-Reply-To: <20120820035832.274275502@linuxfoundation.org>
References: <20120820035832.274275502@linuxfoundation.org>
User-Agent: quilt/0.60-20.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>

3.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Theodore Ts'o <tytso@mit.edu>

commit 7a4c5de27efa4c2ecca87af0a3deea63446367e2 upstream.

While in ext4_validate_block_bitmap(), if an block allocation bitmap
is found to be invalid, we call ext4_error() while the block group is
still locked.  This causes ext4_commit_super() to call a function
which might sleep while in an atomic context.

There's no need to keep the block group locked at this point, so hoist
the ext4_error() call up to ext4_validate_block_bitmap() and release
the block group spinlock before calling ext4_error().

The reported stack trace can be found at:

	http://article.gmane.org/gmane.comp.file-systems.ext4/33731

Reported-by: Dave Jones <davej@redhat.com>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/ext4/balloc.c |   62 ++++++++++++++++++++++++++++++++-----------------------
 fs/ext4/bitmap.c |    1 
 2 files changed, 37 insertions(+), 26 deletions(-)

--- a/fs/ext4/balloc.c
+++ b/fs/ext4/balloc.c
@@ -280,14 +280,18 @@ struct ext4_group_desc * ext4_get_group_
 	return desc;
 }
 
-static int ext4_valid_block_bitmap(struct super_block *sb,
-				   struct ext4_group_desc *desc,
-				   unsigned int block_group,
-				   struct buffer_head *bh)
+/*
+ * Return the block number which was discovered to be invalid, or 0 if
+ * the block bitmap is valid.
+ */
+static ext4_fsblk_t ext4_valid_block_bitmap(struct super_block *sb,
+					    struct ext4_group_desc *desc,
+					    unsigned int block_group,
+					    struct buffer_head *bh)
 {
 	ext4_grpblk_t offset;
 	ext4_grpblk_t next_zero_bit;
-	ext4_fsblk_t bitmap_blk;
+	ext4_fsblk_t blk;
 	ext4_fsblk_t group_first_block;
 
 	if (EXT4_HAS_INCOMPAT_FEATURE(sb, EXT4_FEATURE_INCOMPAT_FLEX_BG)) {
@@ -297,37 +301,33 @@ static int ext4_valid_block_bitmap(struc
 		 * or it has to also read the block group where the bitmaps
 		 * are located to verify they are set.
 		 */
-		return 1;
+		return 0;
 	}
 	group_first_block = ext4_group_first_block_no(sb, block_group);
 
 	/* check whether block bitmap block number is set */
-	bitmap_blk = ext4_block_bitmap(sb, desc);
-	offset = bitmap_blk - group_first_block;
+	blk = ext4_block_bitmap(sb, desc);
+	offset = blk - group_first_block;
 	if (!ext4_test_bit(offset, bh->b_data))
 		/* bad block bitmap */
-		goto err_out;
+		return blk;
 
 	/* check whether the inode bitmap block number is set */
-	bitmap_blk = ext4_inode_bitmap(sb, desc);
-	offset = bitmap_blk - group_first_block;
+	blk = ext4_inode_bitmap(sb, desc);
+	offset = blk - group_first_block;
 	if (!ext4_test_bit(offset, bh->b_data))
 		/* bad block bitmap */
-		goto err_out;
+		return blk;
 
 	/* check whether the inode table block number is set */
-	bitmap_blk = ext4_inode_table(sb, desc);
-	offset = bitmap_blk - group_first_block;
+	blk = ext4_inode_table(sb, desc);
+	offset = blk - group_first_block;
 	next_zero_bit = ext4_find_next_zero_bit(bh->b_data,
 				offset + EXT4_SB(sb)->s_itb_per_group,
 				offset);
-	if (next_zero_bit >= offset + EXT4_SB(sb)->s_itb_per_group)
-		/* good bitmap for inode tables */
-		return 1;
-
-err_out:
-	ext4_error(sb, "Invalid block bitmap - block_group = %d, block = %llu",
-			block_group, bitmap_blk);
+	if (next_zero_bit < offset + EXT4_SB(sb)->s_itb_per_group)
+		/* bad bitmap for inode tables */
+		return blk;
 	return 0;
 }
 
@@ -336,14 +336,26 @@ void ext4_validate_block_bitmap(struct s
 			       unsigned int block_group,
 			       struct buffer_head *bh)
 {
+	ext4_fsblk_t	blk;
+
 	if (buffer_verified(bh))
 		return;
 
 	ext4_lock_group(sb, block_group);
-	if (ext4_valid_block_bitmap(sb, desc, block_group, bh) &&
-	    ext4_block_bitmap_csum_verify(sb, block_group, desc, bh,
-					  EXT4_BLOCKS_PER_GROUP(sb) / 8))
-		set_buffer_verified(bh);
+	blk = ext4_valid_block_bitmap(sb, desc, block_group, bh);
+	if (unlikely(blk != 0)) {
+		ext4_unlock_group(sb, block_group);
+		ext4_error(sb, "bg %u: block %llu: invalid block bitmap",
+			   block_group, blk);
+		return;
+	}
+	if (unlikely(!ext4_block_bitmap_csum_verify(sb, block_group,
+			desc, bh, EXT4_BLOCKS_PER_GROUP(sb) / 8))) {
+		ext4_unlock_group(sb, block_group);
+		ext4_error(sb, "bg %u: bad block bitmap checksum", block_group);
+		return;
+	}
+	set_buffer_verified(bh);
 	ext4_unlock_group(sb, block_group);
 }
 
--- a/fs/ext4/bitmap.c
+++ b/fs/ext4/bitmap.c
@@ -86,7 +86,6 @@ int ext4_block_bitmap_csum_verify(struct
 	if (provided == calculated)
 		return 1;
 
-	ext4_error(sb, "Bad block bitmap checksum: block_group = %u", group);
 	return 0;
 }
 


