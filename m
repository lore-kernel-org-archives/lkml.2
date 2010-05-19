Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756244Ab0ESJis (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 May 2010 05:38:48 -0400
Received: from mail-pz0-f194.google.com ([209.85.222.194]:41491 "EHLO
	mail-pz0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751885Ab0ESJiq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 May 2010 05:38:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=KxPfPRLpsz3Z/sUSxTFjuRdc9yjCBxjyvhdyWlOWE2R94ZdZQn/NVL7PCV6frxYf26
         alyDClUoYVGInwp9v8FXkguMgIuFuKSVtdyR42hj/29jDnUrm8kJJT5tBWkvLBCgHrbe
         uBkWpWjkX9Rzl2YHRBM+WK05ILbkvVucSWvJI=
MIME-Version: 1.0
Date: Wed, 19 May 2010 17:38:45 +0800
Message-ID: <AANLkTimupBIpsY_YtwIw75-ZdilsiFabaaTSs-AJv0Ad@mail.gmail.com>
Subject: [PATCH] btrfs: check alloc return value before use handle and struct
From: Steven Liu <lingjiujianke@gmail.com>
To: chris.mason@oracle.com, linux-btrfs@vger.kernel.org,
       linux-kernel@vger.kernel.org, liuqi@thunderst.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

check alloc return value before use handle and struct
in btrfs_alloc_path will alloc memory,when there have no space it will
return NULL


Signed-off-by: LiuQi <lingjiujianke@gmail.com>
---
 fs/btrfs/dir-item.c    |    2 ++
 fs/btrfs/export.c      |    5 +++++
 fs/btrfs/inode.c       |    5 +++++
 fs/btrfs/transaction.c |    3 +++
 4 files changed, 15 insertions(+), 0 deletions(-)

diff --git a/fs/btrfs/dir-item.c b/fs/btrfs/dir-item.c
index e9103b3..230a131 100644
--- a/fs/btrfs/dir-item.c
+++ b/fs/btrfs/dir-item.c
@@ -142,6 +142,8 @@ int btrfs_insert_dir_item(struct
btrfs_trans_handle *trans, struct btrfs_root
 	key.offset = btrfs_name_hash(name, name_len);

 	path = btrfs_alloc_path();
+	if (!path)
+		return -ENOMEM;
 	path->leave_spinning = 1;

 	data_size = sizeof(*dir_item) + name_len;
diff --git a/fs/btrfs/export.c b/fs/btrfs/export.c
index 951ef09..e6782bc 100644
--- a/fs/btrfs/export.c
+++ b/fs/btrfs/export.c
@@ -176,6 +176,10 @@ static struct dentry *btrfs_get_parent(struct
dentry *child)
 	int ret;

 	path = btrfs_alloc_path();
+	if (!path) {
+		ret = -ENOMEM;
+		goto fail1;
+	}

 	if (dir->i_ino == BTRFS_FIRST_FREE_OBJECTID) {
 		key.objectid = root->root_key.objectid;
@@ -229,6 +233,7 @@ static struct dentry *btrfs_get_parent(struct dentry *child)
 	return dentry;
 fail:
 	btrfs_free_path(path);
+fail1:
 	return ERR_PTR(ret);
 }

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 2bfdc64..bafbd24 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -607,6 +607,8 @@ retry:
 			    GFP_NOFS);

 		trans = btrfs_join_transaction(root, 1);
+		BUG_ON(!trans);
+
 		ret = btrfs_reserve_extent(trans, root,
 					   async_extent->compressed_size,
 					   async_extent->compressed_size,
@@ -1680,6 +1682,7 @@ static int btrfs_finish_ordered_io(struct inode
*inode, u64 start, u64 end)
 			 0, &cached_state, GFP_NOFS);

 	trans = btrfs_join_transaction(root, 1);
+	BUG_ON(!trans);

 	if (test_bit(BTRFS_ORDERED_COMPRESSED, &ordered_extent->flags))
 		compressed = 1;
@@ -3955,6 +3958,7 @@ int btrfs_write_inode(struct inode *inode,
struct writeback_control *wbc)

 	if (wbc->sync_mode == WB_SYNC_ALL) {
 		trans = btrfs_join_transaction(root, 1);
+		BUG_ON(!trans);
 		btrfs_set_trans_block_group(trans, inode);
 		ret = btrfs_commit_transaction(trans, root);
 	}
@@ -3973,6 +3977,7 @@ void btrfs_dirty_inode(struct inode *inode)
 	struct btrfs_trans_handle *trans;

 	trans = btrfs_join_transaction(root, 1);
+	BUG_ON(!trans);
 	btrfs_set_trans_block_group(trans, inode);
 	btrfs_update_inode(trans, root, inode);
 	btrfs_end_transaction(trans, root);
diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
index 2cb1160..7fbb44f 100644
--- a/fs/btrfs/transaction.c
+++ b/fs/btrfs/transaction.c
@@ -173,6 +173,8 @@ static struct btrfs_trans_handle
*start_transaction(struct btrfs_root *root,
 	int ret;

 	mutex_lock(&root->fs_info->trans_mutex);
+	if (!h)
+		goto out;
 	if (!root->fs_info->log_root_recovering &&
 	    ((type == TRANS_START && !root->fs_info->open_ioctl_trans) ||
 	     type == TRANS_USERSPACE))
@@ -194,6 +196,7 @@ static struct btrfs_trans_handle
*start_transaction(struct btrfs_root *root,

 	root->fs_info->running_transaction->use_count++;
 	record_root_in_trans(h, root);
+out:
 	mutex_unlock(&root->fs_info->trans_mutex);
 	return h;
 }
-- 
1.7.1
