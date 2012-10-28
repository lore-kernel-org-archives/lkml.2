Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757272Ab2J1Xa4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Oct 2012 19:30:56 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:42224 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757037Ab2J1X2b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Oct 2012 19:28:31 -0400
Message-Id: <20121028231547.747971375@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Sun, 28 Oct 2012 23:16:11 +0000
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Dmitry Monakhov <dmonakhov@openvz.org>, "Theodore Tso" <tytso@mit.edu>
Subject: [ 035/105] ext4: race-condition protection for
 ext4_convert_unwritten_extents_endio
In-Reply-To: <20121028231536.970033833@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

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
[bwh: Backported to 3.2: adjust context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 fs/ext4/extents.c |   57 ++++++++++++++++++++++++++++++++++++++++++-----------
 1 file changed, 46 insertions(+), 11 deletions(-)

--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -2715,6 +2715,9 @@ static int ext4_ext_zeroout(struct inode
 #define EXT4_EXT_MARK_UNINIT1	0x2  /* mark first half uninitialized */
 #define EXT4_EXT_MARK_UNINIT2	0x4  /* mark second half uninitialized */
 
+#define EXT4_EXT_DATA_VALID1	0x8  /* first half contains valid data */
+#define EXT4_EXT_DATA_VALID2	0x10 /* second half contains valid data */
+
 /*
  * ext4_split_extent_at() splits an extent at given block.
  *
@@ -2750,6 +2753,9 @@ static int ext4_split_extent_at(handle_t
 	unsigned int ee_len, depth;
 	int err = 0;
 
+	BUG_ON((split_flag & (EXT4_EXT_DATA_VALID1 | EXT4_EXT_DATA_VALID2)) ==
+	       (EXT4_EXT_DATA_VALID1 | EXT4_EXT_DATA_VALID2));
+
 	ext_debug("ext4_split_extents_at: inode %lu, logical"
 		"block %llu\n", inode->i_ino, (unsigned long long)split);
 
@@ -2808,7 +2814,14 @@ static int ext4_split_extent_at(handle_t
 
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
@@ -2861,12 +2874,13 @@ static int ext4_split_extent(handle_t *h
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
@@ -2879,8 +2893,8 @@ static int ext4_split_extent(handle_t *h
 		return PTR_ERR(path);
 
 	if (map->m_lblk >= ee_block) {
-		split_flag1 = split_flag & EXT4_EXT_MAY_ZEROOUT ?
-			      EXT4_EXT_MAY_ZEROOUT : 0;
+		split_flag1 = split_flag & (EXT4_EXT_MAY_ZEROOUT |
+					    EXT4_EXT_DATA_VALID2);
 		if (uninitialized)
 			split_flag1 |= EXT4_EXT_MARK_UNINIT1;
 		if (split_flag & EXT4_EXT_MARK_UNINIT2)
@@ -3158,26 +3172,47 @@ static int ext4_split_unwritten_extents(
 
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
@@ -3479,7 +3514,7 @@ ext4_ext_handle_uninitialized_extents(ha
 	}
 	/* IO end_io complete, convert the filled extent to written */
 	if ((flags & EXT4_GET_BLOCKS_CONVERT)) {
-		ret = ext4_convert_unwritten_extents_endio(handle, inode,
+		ret = ext4_convert_unwritten_extents_endio(handle, inode, map,
 							path);
 		if (ret >= 0) {
 			ext4_update_inode_fsync_trans(handle, inode, 1);


