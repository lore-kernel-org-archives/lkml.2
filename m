Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933631Ab0HLAiR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Aug 2010 20:38:17 -0400
Received: from kroah.org ([198.145.64.141]:43335 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758972Ab0HKX6V (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Aug 2010 19:58:21 -0400
X-Mailbox-Line: From gregkh@clark.site Wed Aug 11 16:55:00 2010
Message-Id: <20100811235459.997227518@clark.site>
User-Agent: quilt/0.48-11.2
Date: Wed, 11 Aug 2010 16:54:30 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Yan Zheng <zheng.yan@oracle.com>, Chris Mason <chris.mason@oracle.com>,
        Jeff Mahoney <jeffm@suse.com>
Subject: [049/111] Btrfs: Make fallocate(2) more ENOSPC friendly
In-Reply-To: <20100811235623.GA24440@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Yan, Zheng <zheng.yan@oracle.com>

commit 5a303d5d4b8055d2e5a03e92d04745bfc5881a22 upstream.

fallocate(2) may allocate large number of file extents, so it's not
good to do it in a single transaction. This patch make fallocate(2)
start a new transaction for each file extents it allocates.

Signed-off-by: Yan Zheng <zheng.yan@oracle.com>
Signed-off-by: Chris Mason <chris.mason@oracle.com>
Acked-by: Jeff Mahoney <jeffm@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>


---
 fs/btrfs/inode.c |   65 +++++++++++++++++++++++++++----------------------------
 1 file changed, 32 insertions(+), 33 deletions(-)

--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -5664,10 +5664,10 @@ out_fail:
 	return err;
 }
 
-static int prealloc_file_range(struct btrfs_trans_handle *trans,
-			       struct inode *inode, u64 start, u64 end,
+static int prealloc_file_range(struct inode *inode, u64 start, u64 end,
 			       u64 alloc_hint, int mode)
 {
+	struct btrfs_trans_handle *trans;
 	struct btrfs_root *root = BTRFS_I(inode)->root;
 	struct btrfs_key ins;
 	u64 alloc_size;
@@ -5678,17 +5678,23 @@ static int prealloc_file_range(struct bt
 	while (num_bytes > 0) {
 		alloc_size = min(num_bytes, root->fs_info->max_extent);
 
-		ret = btrfs_reserve_metadata_space(root, 1);
-		if (ret)
-			goto out;
-
 		ret = btrfs_reserve_extent(trans, root, alloc_size,
 					   root->sectorsize, 0, alloc_hint,
 					   (u64)-1, &ins, 1);
 		if (ret) {
 			WARN_ON(1);
-			goto out;
+			break;
 		}
+
+		ret = btrfs_reserve_metadata_space(root, 3);
+		if (ret) {
+			btrfs_free_reserved_extent(root, ins.objectid,
+						   ins.offset);
+			break;
+		}
+
+		trans = btrfs_start_transaction(root, 1);
+
 		ret = insert_reserved_file_extent(trans, inode,
 						  cur_offset, ins.objectid,
 						  ins.offset, ins.offset,
@@ -5697,22 +5703,25 @@ static int prealloc_file_range(struct bt
 		BUG_ON(ret);
 		btrfs_drop_extent_cache(inode, cur_offset,
 					cur_offset + ins.offset -1, 0);
+
 		num_bytes -= ins.offset;
 		cur_offset += ins.offset;
 		alloc_hint = ins.objectid + ins.offset;
-		btrfs_unreserve_metadata_space(root, 1);
-	}
-out:
-	if (cur_offset > start) {
+
 		inode->i_ctime = CURRENT_TIME;
 		BTRFS_I(inode)->flags |= BTRFS_INODE_PREALLOC;
 		if (!(mode & FALLOC_FL_KEEP_SIZE) &&
-		    cur_offset > i_size_read(inode))
-			btrfs_i_size_write(inode, cur_offset);
+		    cur_offset > inode->i_size) {
+			i_size_write(inode, cur_offset);
+			btrfs_ordered_update_i_size(inode, cur_offset, NULL);
+		}
+
 		ret = btrfs_update_inode(trans, root, inode);
 		BUG_ON(ret);
-	}
 
+		btrfs_end_transaction(trans, root);
+		btrfs_unreserve_metadata_space(root, 3);
+	}
 	return ret;
 }
 
@@ -5727,8 +5736,6 @@ static long btrfs_fallocate(struct inode
 	u64 locked_end;
 	u64 mask = BTRFS_I(inode)->root->sectorsize - 1;
 	struct extent_map *em;
-	struct btrfs_trans_handle *trans;
-	struct btrfs_root *root;
 	int ret;
 
 	alloc_start = offset & ~mask;
@@ -5747,9 +5754,7 @@ static long btrfs_fallocate(struct inode
 			goto out;
 	}
 
-	root = BTRFS_I(inode)->root;
-
-	ret = btrfs_check_data_free_space(root, inode,
+	ret = btrfs_check_data_free_space(BTRFS_I(inode)->root, inode,
 					  alloc_end - alloc_start);
 	if (ret)
 		goto out;
@@ -5758,12 +5763,6 @@ static long btrfs_fallocate(struct inode
 	while (1) {
 		struct btrfs_ordered_extent *ordered;
 
-		trans = btrfs_start_transaction(BTRFS_I(inode)->root, 1);
-		if (!trans) {
-			ret = -EIO;
-			goto out_free;
-		}
-
 		/* the extent lock is ordered inside the running
 		 * transaction
 		 */
@@ -5777,8 +5776,6 @@ static long btrfs_fallocate(struct inode
 			btrfs_put_ordered_extent(ordered);
 			unlock_extent(&BTRFS_I(inode)->io_tree,
 				      alloc_start, locked_end, GFP_NOFS);
-			btrfs_end_transaction(trans, BTRFS_I(inode)->root);
-
 			/*
 			 * we can't wait on the range with the transaction
 			 * running or with the extent lock held
@@ -5799,9 +5796,12 @@ static long btrfs_fallocate(struct inode
 		BUG_ON(IS_ERR(em) || !em);
 		last_byte = min(extent_map_end(em), alloc_end);
 		last_byte = (last_byte + mask) & ~mask;
-		if (em->block_start == EXTENT_MAP_HOLE) {
-			ret = prealloc_file_range(trans, inode, cur_offset,
-						last_byte, alloc_hint, mode);
+		if (em->block_start == EXTENT_MAP_HOLE ||
+		    (cur_offset >= inode->i_size &&
+		     !test_bit(EXTENT_FLAG_PREALLOC, &em->flags))) {
+			ret = prealloc_file_range(inode,
+						  cur_offset, last_byte,
+						  alloc_hint, mode);
 			if (ret < 0) {
 				free_extent_map(em);
 				break;
@@ -5820,9 +5820,8 @@ static long btrfs_fallocate(struct inode
 	unlock_extent(&BTRFS_I(inode)->io_tree, alloc_start, locked_end,
 		      GFP_NOFS);
 
-	btrfs_end_transaction(trans, BTRFS_I(inode)->root);
-out_free:
-	btrfs_free_reserved_data_space(root, inode, alloc_end - alloc_start);
+	btrfs_free_reserved_data_space(BTRFS_I(inode)->root, inode,
+				       alloc_end - alloc_start);
 out:
 	mutex_unlock(&inode->i_mutex);
 	return ret;


