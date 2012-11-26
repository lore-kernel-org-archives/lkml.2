Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933776Ab2KZRM3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2012 12:12:29 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:47968 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933761Ab2KZRMY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2012 12:12:24 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Tao Ma <boyu.mt@taobao.com>, "Theodore Ts'o" <tytso@mit.edu>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 200/270] ext4: Checksum the block bitmap properly with bigalloc enabled
Date: Mon, 26 Nov 2012 14:58:10 -0200
Message-Id: <1353949160-26803-201-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1353949160-26803-1-git-send-email-herton.krzesinski@canonical.com>
References: <1353949160-26803-1-git-send-email-herton.krzesinski@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7u1 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tao Ma <boyu.mt@taobao.com>

commit 79f1ba49569e5aec919b653c55b03274c2331701 upstream.

In mke2fs, we only checksum the whole bitmap block and it is right.
While in the kernel, we use EXT4_BLOCKS_PER_GROUP to indicate the
size of the checksumed bitmap which is wrong when we enable bigalloc.
The right size should be EXT4_CLUSTERS_PER_GROUP and this patch fixes
it.

Also as every caller of ext4_block_bitmap_csum_set and
ext4_block_bitmap_csum_verify pass in EXT4_BLOCKS_PER_GROUP(sb)/8,
we'd better removes this parameter and sets it in the function itself.

Signed-off-by: Tao Ma <boyu.mt@taobao.com>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
Reviewed-by: Lukas Czerner <lczerner@redhat.com>
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 fs/ext4/balloc.c  |    8 +++-----
 fs/ext4/bitmap.c  |    6 ++++--
 fs/ext4/ext4.h    |    4 ++--
 fs/ext4/ialloc.c  |    4 +---
 fs/ext4/mballoc.c |    9 +++------
 fs/ext4/resize.c  |    3 +--
 6 files changed, 14 insertions(+), 20 deletions(-)

diff --git a/fs/ext4/balloc.c b/fs/ext4/balloc.c
index 1b50890..cf18217 100644
--- a/fs/ext4/balloc.c
+++ b/fs/ext4/balloc.c
@@ -174,8 +174,7 @@ void ext4_init_block_bitmap(struct super_block *sb, struct buffer_head *bh,
 		ext4_free_inodes_set(sb, gdp, 0);
 		ext4_itable_unused_set(sb, gdp, 0);
 		memset(bh->b_data, 0xff, sb->s_blocksize);
-		ext4_block_bitmap_csum_set(sb, block_group, gdp, bh,
-					   EXT4_BLOCKS_PER_GROUP(sb) / 8);
+		ext4_block_bitmap_csum_set(sb, block_group, gdp, bh);
 		return;
 	}
 	memset(bh->b_data, 0, sb->s_blocksize);
@@ -212,8 +211,7 @@ void ext4_init_block_bitmap(struct super_block *sb, struct buffer_head *bh,
 	 */
 	ext4_mark_bitmap_end(num_clusters_in_group(sb, block_group),
 			     sb->s_blocksize * 8, bh->b_data);
-	ext4_block_bitmap_csum_set(sb, block_group, gdp, bh,
-				   EXT4_BLOCKS_PER_GROUP(sb) / 8);
+	ext4_block_bitmap_csum_set(sb, block_group, gdp, bh);
 	ext4_group_desc_csum_set(sb, block_group, gdp);
 }
 
@@ -350,7 +348,7 @@ void ext4_validate_block_bitmap(struct super_block *sb,
 		return;
 	}
 	if (unlikely(!ext4_block_bitmap_csum_verify(sb, block_group,
-			desc, bh, EXT4_BLOCKS_PER_GROUP(sb) / 8))) {
+			desc, bh))) {
 		ext4_unlock_group(sb, block_group);
 		ext4_error(sb, "bg %u: bad block bitmap checksum", block_group);
 		return;
diff --git a/fs/ext4/bitmap.c b/fs/ext4/bitmap.c
index ad9d96e..e76c10e 100644
--- a/fs/ext4/bitmap.c
+++ b/fs/ext4/bitmap.c
@@ -65,11 +65,12 @@ void ext4_inode_bitmap_csum_set(struct super_block *sb, ext4_group_t group,
 
 int ext4_block_bitmap_csum_verify(struct super_block *sb, ext4_group_t group,
 				  struct ext4_group_desc *gdp,
-				  struct buffer_head *bh, int sz)
+				  struct buffer_head *bh)
 {
 	__u32 hi;
 	__u32 provided, calculated;
 	struct ext4_sb_info *sbi = EXT4_SB(sb);
+	int sz = EXT4_CLUSTERS_PER_GROUP(sb) / 8;
 
 	if (!EXT4_HAS_RO_COMPAT_FEATURE(sb,
 					EXT4_FEATURE_RO_COMPAT_METADATA_CSUM))
@@ -91,8 +92,9 @@ int ext4_block_bitmap_csum_verify(struct super_block *sb, ext4_group_t group,
 
 void ext4_block_bitmap_csum_set(struct super_block *sb, ext4_group_t group,
 				struct ext4_group_desc *gdp,
-				struct buffer_head *bh, int sz)
+				struct buffer_head *bh)
 {
+	int sz = EXT4_CLUSTERS_PER_GROUP(sb) / 8;
 	__u32 csum;
 	struct ext4_sb_info *sbi = EXT4_SB(sb);
 
diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index 42f5a18..a14c45e 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -1860,10 +1860,10 @@ int ext4_inode_bitmap_csum_verify(struct super_block *sb, ext4_group_t group,
 				  struct buffer_head *bh, int sz);
 void ext4_block_bitmap_csum_set(struct super_block *sb, ext4_group_t group,
 				struct ext4_group_desc *gdp,
-				struct buffer_head *bh, int sz);
+				struct buffer_head *bh);
 int ext4_block_bitmap_csum_verify(struct super_block *sb, ext4_group_t group,
 				  struct ext4_group_desc *gdp,
-				  struct buffer_head *bh, int sz);
+				  struct buffer_head *bh);
 
 /* balloc.c */
 extern void ext4_validate_block_bitmap(struct super_block *sb,
diff --git a/fs/ext4/ialloc.c b/fs/ext4/ialloc.c
index 6866bc2..76dcdcf 100644
--- a/fs/ext4/ialloc.c
+++ b/fs/ext4/ialloc.c
@@ -754,9 +754,7 @@ got:
 			ext4_free_group_clusters_set(sb, gdp,
 				ext4_free_clusters_after_init(sb, group, gdp));
 			ext4_block_bitmap_csum_set(sb, group, gdp,
-						   block_bitmap_bh,
-						   EXT4_BLOCKS_PER_GROUP(sb) /
-						   8);
+						   block_bitmap_bh);
 			ext4_group_desc_csum_set(sb, group, gdp);
 		}
 		ext4_unlock_group(sb, group);
diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index 1cd6994..70f97a5 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -2798,8 +2798,7 @@ ext4_mb_mark_diskspace_used(struct ext4_allocation_context *ac,
 	}
 	len = ext4_free_group_clusters(sb, gdp) - ac->ac_b_ex.fe_len;
 	ext4_free_group_clusters_set(sb, gdp, len);
-	ext4_block_bitmap_csum_set(sb, ac->ac_b_ex.fe_group, gdp, bitmap_bh,
-				   EXT4_BLOCKS_PER_GROUP(sb) / 8);
+	ext4_block_bitmap_csum_set(sb, ac->ac_b_ex.fe_group, gdp, bitmap_bh);
 	ext4_group_desc_csum_set(sb, ac->ac_b_ex.fe_group, gdp);
 
 	ext4_unlock_group(sb, ac->ac_b_ex.fe_group);
@@ -4659,8 +4658,7 @@ do_more:
 
 	ret = ext4_free_group_clusters(sb, gdp) + count_clusters;
 	ext4_free_group_clusters_set(sb, gdp, ret);
-	ext4_block_bitmap_csum_set(sb, block_group, gdp, bitmap_bh,
-				   EXT4_BLOCKS_PER_GROUP(sb) / 8);
+	ext4_block_bitmap_csum_set(sb, block_group, gdp, bitmap_bh);
 	ext4_group_desc_csum_set(sb, block_group, gdp);
 	ext4_unlock_group(sb, block_group);
 	percpu_counter_add(&sbi->s_freeclusters_counter, count_clusters);
@@ -4805,8 +4803,7 @@ int ext4_group_add_blocks(handle_t *handle, struct super_block *sb,
 	mb_free_blocks(NULL, &e4b, bit, count);
 	blk_free_count = blocks_freed + ext4_free_group_clusters(sb, desc);
 	ext4_free_group_clusters_set(sb, desc, blk_free_count);
-	ext4_block_bitmap_csum_set(sb, block_group, desc, bitmap_bh,
-				   EXT4_BLOCKS_PER_GROUP(sb) / 8);
+	ext4_block_bitmap_csum_set(sb, block_group, desc, bitmap_bh);
 	ext4_group_desc_csum_set(sb, block_group, desc);
 	ext4_unlock_group(sb, block_group);
 	percpu_counter_add(&sbi->s_freeclusters_counter,
diff --git a/fs/ext4/resize.c b/fs/ext4/resize.c
index dc1affc..367510e 100644
--- a/fs/ext4/resize.c
+++ b/fs/ext4/resize.c
@@ -1119,8 +1119,7 @@ static int ext4_set_bitmap_checksums(struct super_block *sb,
 	bh = ext4_get_bitmap(sb, group_data->block_bitmap);
 	if (!bh)
 		return -EIO;
-	ext4_block_bitmap_csum_set(sb, group, gdp, bh,
-				   EXT4_BLOCKS_PER_GROUP(sb) / 8);
+	ext4_block_bitmap_csum_set(sb, group, gdp, bh);
 	brelse(bh);
 
 	return 0;
-- 
1.7.9.5

