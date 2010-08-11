Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759181Ab0HKX6z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Aug 2010 19:58:55 -0400
Received: from kroah.org ([198.145.64.141]:43437 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759074Ab0HKX6j (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Aug 2010 19:58:39 -0400
X-Mailbox-Line: From gregkh@clark.site Wed Aug 11 16:55:01 2010
Message-Id: <20100811235501.433933214@clark.site>
User-Agent: quilt/0.48-11.2
Date: Wed, 11 Aug 2010 16:54:45 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Yan Zheng <zheng.yan@oracle.com>, Chris Mason <chris.mason@oracle.com>,
        Jeff Mahoney <jeffm@suse.com>
Subject: [064/111] Btrfs: Fix race in btrfs_mark_extent_written
In-Reply-To: <20100811235623.GA24440@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Yan, Zheng <zheng.yan@oracle.com>

commit 6c7d54ac87f338c479d9729e8392eca3f76e11e1 upstream.

Fix bug reported by Johannes Hirte. The reason of that bug
is btrfs_del_items is called after btrfs_duplicate_item and
btrfs_del_items triggers tree balance. The fix is check that
case and call btrfs_search_slot when needed.

Signed-off-by: Yan Zheng <zheng.yan@oracle.com>
Signed-off-by: Chris Mason <chris.mason@oracle.com>
Acked-by: Jeff Mahoney <jeffm@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/btrfs/file.c |  100 ++++++++++++++++++++++++++++++++++++++++++++------------
 1 file changed, 80 insertions(+), 20 deletions(-)

--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -506,7 +506,8 @@ next_slot:
 }
 
 static int extent_mergeable(struct extent_buffer *leaf, int slot,
-			    u64 objectid, u64 bytenr, u64 *start, u64 *end)
+			    u64 objectid, u64 bytenr, u64 orig_offset,
+			    u64 *start, u64 *end)
 {
 	struct btrfs_file_extent_item *fi;
 	struct btrfs_key key;
@@ -522,6 +523,7 @@ static int extent_mergeable(struct exten
 	fi = btrfs_item_ptr(leaf, slot, struct btrfs_file_extent_item);
 	if (btrfs_file_extent_type(leaf, fi) != BTRFS_FILE_EXTENT_REG ||
 	    btrfs_file_extent_disk_bytenr(leaf, fi) != bytenr ||
+	    btrfs_file_extent_offset(leaf, fi) != key.offset - orig_offset ||
 	    btrfs_file_extent_compression(leaf, fi) ||
 	    btrfs_file_extent_encryption(leaf, fi) ||
 	    btrfs_file_extent_other_encoding(leaf, fi))
@@ -561,6 +563,7 @@ int btrfs_mark_extent_written(struct btr
 	u64 split;
 	int del_nr = 0;
 	int del_slot = 0;
+	int recow;
 	int ret;
 
 	btrfs_drop_extent_cache(inode, start, end - 1, 0);
@@ -568,6 +571,7 @@ int btrfs_mark_extent_written(struct btr
 	path = btrfs_alloc_path();
 	BUG_ON(!path);
 again:
+	recow = 0;
 	split = start;
 	key.objectid = inode->i_ino;
 	key.type = BTRFS_EXTENT_DATA_KEY;
@@ -591,12 +595,60 @@ again:
 	bytenr = btrfs_file_extent_disk_bytenr(leaf, fi);
 	num_bytes = btrfs_file_extent_disk_num_bytes(leaf, fi);
 	orig_offset = key.offset - btrfs_file_extent_offset(leaf, fi);
+	memcpy(&new_key, &key, sizeof(new_key));
+
+	if (start == key.offset && end < extent_end) {
+		other_start = 0;
+		other_end = start;
+		if (extent_mergeable(leaf, path->slots[0] - 1,
+				     inode->i_ino, bytenr, orig_offset,
+				     &other_start, &other_end)) {
+			new_key.offset = end;
+			btrfs_set_item_key_safe(trans, root, path, &new_key);
+			fi = btrfs_item_ptr(leaf, path->slots[0],
+					    struct btrfs_file_extent_item);
+			btrfs_set_file_extent_num_bytes(leaf, fi,
+							extent_end - end);
+			btrfs_set_file_extent_offset(leaf, fi,
+						     end - orig_offset);
+			fi = btrfs_item_ptr(leaf, path->slots[0] - 1,
+					    struct btrfs_file_extent_item);
+			btrfs_set_file_extent_num_bytes(leaf, fi,
+							end - other_start);
+			btrfs_mark_buffer_dirty(leaf);
+			goto out;
+		}
+	}
+
+	if (start > key.offset && end == extent_end) {
+		other_start = end;
+		other_end = 0;
+		if (extent_mergeable(leaf, path->slots[0] + 1,
+				     inode->i_ino, bytenr, orig_offset,
+				     &other_start, &other_end)) {
+			fi = btrfs_item_ptr(leaf, path->slots[0],
+					    struct btrfs_file_extent_item);
+			btrfs_set_file_extent_num_bytes(leaf, fi,
+							start - key.offset);
+			path->slots[0]++;
+			new_key.offset = start;
+			btrfs_set_item_key_safe(trans, root, path, &new_key);
+
+			fi = btrfs_item_ptr(leaf, path->slots[0],
+					    struct btrfs_file_extent_item);
+			btrfs_set_file_extent_num_bytes(leaf, fi,
+							other_end - start);
+			btrfs_set_file_extent_offset(leaf, fi,
+						     start - orig_offset);
+			btrfs_mark_buffer_dirty(leaf);
+			goto out;
+		}
+	}
 
 	while (start > key.offset || end < extent_end) {
 		if (key.offset == start)
 			split = end;
 
-		memcpy(&new_key, &key, sizeof(new_key));
 		new_key.offset = split;
 		ret = btrfs_duplicate_item(trans, root, path, &new_key);
 		if (ret == -EAGAIN) {
@@ -631,15 +683,18 @@ again:
 			path->slots[0]--;
 			extent_end = end;
 		}
+		recow = 1;
 	}
 
-	fi = btrfs_item_ptr(leaf, path->slots[0],
-			    struct btrfs_file_extent_item);
-
 	other_start = end;
 	other_end = 0;
-	if (extent_mergeable(leaf, path->slots[0] + 1, inode->i_ino,
-			     bytenr, &other_start, &other_end)) {
+	if (extent_mergeable(leaf, path->slots[0] + 1,
+			     inode->i_ino, bytenr, orig_offset,
+			     &other_start, &other_end)) {
+		if (recow) {
+			btrfs_release_path(root, path);
+			goto again;
+		}
 		extent_end = other_end;
 		del_slot = path->slots[0] + 1;
 		del_nr++;
@@ -650,8 +705,13 @@ again:
 	}
 	other_start = 0;
 	other_end = start;
-	if (extent_mergeable(leaf, path->slots[0] - 1, inode->i_ino,
-			     bytenr, &other_start, &other_end)) {
+	if (extent_mergeable(leaf, path->slots[0] - 1,
+			     inode->i_ino, bytenr, orig_offset,
+			     &other_start, &other_end)) {
+		if (recow) {
+			btrfs_release_path(root, path);
+			goto again;
+		}
 		key.offset = other_start;
 		del_slot = path->slots[0];
 		del_nr++;
@@ -660,22 +720,22 @@ again:
 					inode->i_ino, orig_offset);
 		BUG_ON(ret);
 	}
+	fi = btrfs_item_ptr(leaf, path->slots[0],
+			   struct btrfs_file_extent_item);
 	if (del_nr == 0) {
 		btrfs_set_file_extent_type(leaf, fi,
 					   BTRFS_FILE_EXTENT_REG);
 		btrfs_mark_buffer_dirty(leaf);
-		goto out;
-	}
-
-	fi = btrfs_item_ptr(leaf, del_slot - 1,
-			    struct btrfs_file_extent_item);
-	btrfs_set_file_extent_type(leaf, fi, BTRFS_FILE_EXTENT_REG);
-	btrfs_set_file_extent_num_bytes(leaf, fi,
-					extent_end - key.offset);
-	btrfs_mark_buffer_dirty(leaf);
+	} else {
+		btrfs_set_file_extent_type(leaf, fi,
+					   BTRFS_FILE_EXTENT_REG);
+		btrfs_set_file_extent_num_bytes(leaf, fi,
+						extent_end - key.offset);
+		btrfs_mark_buffer_dirty(leaf);
 
-	ret = btrfs_del_items(trans, root, path, del_slot, del_nr);
-	BUG_ON(ret);
+		ret = btrfs_del_items(trans, root, path, del_slot, del_nr);
+		BUG_ON(ret);
+	}
 out:
 	btrfs_free_path(path);
 	return 0;


