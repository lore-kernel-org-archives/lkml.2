Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756838Ab2KZRkJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2012 12:40:09 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:47851 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933606Ab2KZRK7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2012 12:10:59 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Dmitry Monakhov <dmonakhov@openvz.org>, "Theodore Ts'o" <tytso@mit.edu>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 177/270] ext4: race-condition protection for ext4_convert_unwritten_extents_endio
Date: Mon, 26 Nov 2012 14:57:47 -0200
Message-Id: <1353949160-26803-178-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1353949160-26803-1-git-send-email-herton.krzesinski@canonical.com>
References: <1353949160-26803-1-git-send-email-herton.krzesinski@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7u1 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dmitry Monakhov <dmonakhov@openvz.org>

commit dee1f973ca341c266229faa5a1a5bb268bed3531 upstream.

We assumed that at the time we call ext4_convert_unwritten_extents_endio()
extent in question is fully inside [map.m_lblk, map->m_len] because
it was already split during submission.  But this may not be true due to
a race between writeback vs fallocate.

If extent in question is larger than requested we will split it again.
Special precautions should being done if zeroout required because
[map.m_lblk, map->m_len] already contains valid data.

Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 fs/ext4/extents.c |   57 ++++++++++++++++++++++++++++++++++++++++++-----------
 1 file changed, 46 insertions(+), 11 deletions(-)

diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index 9752106..844e11e 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -52,6 +52,9 @@
 #define EXT4_EXT_MARK_UNINIT1	0x2  /* mark first half uninitialized */
 #define EXT4_EXT_MARK_UNINIT2	0x4  /* mark second half uninitialized */
 
+#define EXT4_EXT_DATA_VALID1	0x8  /* first half contains valid data */
+#define EXT4_EXT_DATA_VALID2	0x10 /* second half contains valid data */
+
 static __le32 ext4_extent_block_csum(struct inode *inode,
 				     struct ext4_extent_header *eh)
 {
@@ -2896,6 +2899,9 @@ static int ext4_split_extent_at(handle_t *handle,
 	unsigned int ee_len, depth;
 	int err = 0;
 
+	BUG_ON((split_flag & (EXT4_EXT_DATA_VALID1 | EXT4_EXT_DATA_VALID2)) ==
+	       (EXT4_EXT_DATA_VALID1 | EXT4_EXT_DATA_VALID2));
+
 	ext_debug("ext4_split_extents_at: inode %lu, logical"
 		"block %llu\n", inode->i_ino, (unsigned long long)split);
 
@@ -2954,7 +2960,14 @@ static int ext4_split_extent_at(handle_t *handle,
 
 	err = ext4_ext_insert_extent(handle, inode, path, &newex, flags);
 	if (err == -ENOSPC && (EXT4_EXT_MAY_ZEROOUT & split_flag)) {
-		err = ext4_ext_zeroout(inode, &orig_ex);
+		if (split_flag & (EXT4_EXT_DATA_VALID1|EXT4_EXT_DATA_VALID2)) {
+			if (split_flag & EXT4_EXT_DATA_VALID1)
+				err = ext4_ext_zeroout(inode, ex2);
+			else
+				err = ext4_ext_zeroout(inode, ex);
+		} else
+			err = ext4_ext_zeroout(inode, &orig_ex);
+
 		if (err)
 			goto fix_extent_len;
 		/* update the extent length and mark as initialized */
@@ -3007,12 +3020,13 @@ static int ext4_split_extent(handle_t *handle,
 	uninitialized = ext4_ext_is_uninitialized(ex);
 
 	if (map->m_lblk + map->m_len < ee_block + ee_len) {
-		split_flag1 = split_flag & EXT4_EXT_MAY_ZEROOUT ?
-			      EXT4_EXT_MAY_ZEROOUT : 0;
+		split_flag1 = split_flag & EXT4_EXT_MAY_ZEROOUT;
 		flags1 = flags | EXT4_GET_BLOCKS_PRE_IO;
 		if (uninitialized)
 			split_flag1 |= EXT4_EXT_MARK_UNINIT1 |
 				       EXT4_EXT_MARK_UNINIT2;
+		if (split_flag & EXT4_EXT_DATA_VALID2)
+			split_flag1 |= EXT4_EXT_DATA_VALID1;
 		err = ext4_split_extent_at(handle, inode, path,
 				map->m_lblk + map->m_len, split_flag1, flags1);
 		if (err)
@@ -3025,8 +3039,8 @@ static int ext4_split_extent(handle_t *handle,
 		return PTR_ERR(path);
 
 	if (map->m_lblk >= ee_block) {
-		split_flag1 = split_flag & EXT4_EXT_MAY_ZEROOUT ?
-			      EXT4_EXT_MAY_ZEROOUT : 0;
+		split_flag1 = split_flag & (EXT4_EXT_MAY_ZEROOUT |
+					    EXT4_EXT_DATA_VALID2);
 		if (uninitialized)
 			split_flag1 |= EXT4_EXT_MARK_UNINIT1;
 		if (split_flag & EXT4_EXT_MARK_UNINIT2)
@@ -3304,26 +3318,47 @@ static int ext4_split_unwritten_extents(handle_t *handle,
 
 	split_flag |= ee_block + ee_len <= eof_block ? EXT4_EXT_MAY_ZEROOUT : 0;
 	split_flag |= EXT4_EXT_MARK_UNINIT2;
-
+	if (flags & EXT4_GET_BLOCKS_CONVERT)
+		split_flag |= EXT4_EXT_DATA_VALID2;
 	flags |= EXT4_GET_BLOCKS_PRE_IO;
 	return ext4_split_extent(handle, inode, path, map, split_flag, flags);
 }
 
 static int ext4_convert_unwritten_extents_endio(handle_t *handle,
-					      struct inode *inode,
-					      struct ext4_ext_path *path)
+						struct inode *inode,
+						struct ext4_map_blocks *map,
+						struct ext4_ext_path *path)
 {
 	struct ext4_extent *ex;
+	ext4_lblk_t ee_block;
+	unsigned int ee_len;
 	int depth;
 	int err = 0;
 
 	depth = ext_depth(inode);
 	ex = path[depth].p_ext;
+	ee_block = le32_to_cpu(ex->ee_block);
+	ee_len = ext4_ext_get_actual_len(ex);
 
 	ext_debug("ext4_convert_unwritten_extents_endio: inode %lu, logical"
 		"block %llu, max_blocks %u\n", inode->i_ino,
-		(unsigned long long)le32_to_cpu(ex->ee_block),
-		ext4_ext_get_actual_len(ex));
+		  (unsigned long long)ee_block, ee_len);
+
+	/* If extent is larger than requested then split is required */
+	if (ee_block != map->m_lblk || ee_len > map->m_len) {
+		err = ext4_split_unwritten_extents(handle, inode, map, path,
+						   EXT4_GET_BLOCKS_CONVERT);
+		if (err < 0)
+			goto out;
+		ext4_ext_drop_refs(path);
+		path = ext4_ext_find_extent(inode, map->m_lblk, path);
+		if (IS_ERR(path)) {
+			err = PTR_ERR(path);
+			goto out;
+		}
+		depth = ext_depth(inode);
+		ex = path[depth].p_ext;
+	}
 
 	err = ext4_ext_get_access(handle, inode, path + depth);
 	if (err)
@@ -3631,7 +3666,7 @@ ext4_ext_handle_uninitialized_extents(handle_t *handle, struct inode *inode,
 	}
 	/* IO end_io complete, convert the filled extent to written */
 	if ((flags & EXT4_GET_BLOCKS_CONVERT)) {
-		ret = ext4_convert_unwritten_extents_endio(handle, inode,
+		ret = ext4_convert_unwritten_extents_endio(handle, inode, map,
 							path);
 		if (ret >= 0) {
 			ext4_update_inode_fsync_trans(handle, inode, 1);
-- 
1.7.9.5

