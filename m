Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933644Ab0HLAiT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Aug 2010 20:38:19 -0400
Received: from kroah.org ([198.145.64.141]:43327 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758968Ab0HKX6U (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Aug 2010 19:58:20 -0400
X-Mailbox-Line: From gregkh@clark.site Wed Aug 11 16:54:59 2010
Message-Id: <20100811235459.905456593@clark.site>
User-Agent: quilt/0.48-11.2
Date: Wed, 11 Aug 2010 16:54:29 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Yan Zheng <zheng.yan@oracle.com>, Chris Mason <chris.mason@oracle.com>,
        Jeff Mahoney <jeffm@suse.com>
Subject: [048/111] Btrfs: Avoid orphan inodes cleanup during committing transaction
In-Reply-To: <20100811235623.GA24440@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Yan, Zheng <zheng.yan@oracle.com>

commit 2e4bfab97055aa6acdd0637913bd705c2d6506d6 upstream.

btrfs_lookup_dentry may trigger orphan cleanup, so it's not good
to call it while committing a transaction.

Signed-off-by: Yan Zheng <zheng.yan@oracle.com>
Signed-off-by: Chris Mason <chris.mason@oracle.com>
Acked-by: Jeff Mahoney <jeffm@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/btrfs/ioctl.c       |   29 +++++++++++++++++------------
 fs/btrfs/transaction.c |    4 ----
 2 files changed, 17 insertions(+), 16 deletions(-)

--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -237,7 +237,6 @@ static noinline int create_subvol(struct
 	u64 objectid;
 	u64 new_dirid = BTRFS_FIRST_FREE_OBJECTID;
 	u64 index = 0;
-	unsigned long nr = 1;
 
 	/*
 	 * 1 - inode item
@@ -342,24 +341,21 @@ static noinline int create_subvol(struct
 
 	d_instantiate(dentry, btrfs_lookup_dentry(dir, dentry));
 fail:
-	nr = trans->blocks_used;
 	err = btrfs_commit_transaction(trans, root);
 	if (err && !ret)
 		ret = err;
 
 	btrfs_unreserve_metadata_space(root, 6);
-	btrfs_btree_balance_dirty(root, nr);
 	return ret;
 }
 
 static int create_snapshot(struct btrfs_root *root, struct dentry *dentry,
 			   char *name, int namelen)
 {
+	struct inode *inode;
 	struct btrfs_pending_snapshot *pending_snapshot;
 	struct btrfs_trans_handle *trans;
-	int ret = 0;
-	int err;
-	unsigned long nr = 0;
+	int ret;
 
 	if (!root->ref_cows)
 		return -EINVAL;
@@ -372,20 +368,20 @@ static int create_snapshot(struct btrfs_
 	 */
 	ret = btrfs_reserve_metadata_space(root, 6);
 	if (ret)
-		goto fail_unlock;
+		goto fail;
 
 	pending_snapshot = kzalloc(sizeof(*pending_snapshot), GFP_NOFS);
 	if (!pending_snapshot) {
 		ret = -ENOMEM;
 		btrfs_unreserve_metadata_space(root, 6);
-		goto fail_unlock;
+		goto fail;
 	}
 	pending_snapshot->name = kmalloc(namelen + 1, GFP_NOFS);
 	if (!pending_snapshot->name) {
 		ret = -ENOMEM;
 		kfree(pending_snapshot);
 		btrfs_unreserve_metadata_space(root, 6);
-		goto fail_unlock;
+		goto fail;
 	}
 	memcpy(pending_snapshot->name, name, namelen);
 	pending_snapshot->name[namelen] = '\0';
@@ -395,10 +391,19 @@ static int create_snapshot(struct btrfs_
 	pending_snapshot->root = root;
 	list_add(&pending_snapshot->list,
 		 &trans->transaction->pending_snapshots);
-	err = btrfs_commit_transaction(trans, root);
+	ret = btrfs_commit_transaction(trans, root);
+	BUG_ON(ret);
+	btrfs_unreserve_metadata_space(root, 6);
 
-fail_unlock:
-	btrfs_btree_balance_dirty(root, nr);
+	inode = btrfs_lookup_dentry(dentry->d_parent->d_inode, dentry);
+	if (IS_ERR(inode)) {
+		ret = PTR_ERR(inode);
+		goto fail;
+	}
+	BUG_ON(!inode);
+	d_instantiate(dentry, inode);
+	ret = 0;
+fail:
 	return ret;
 }
 
--- a/fs/btrfs/transaction.c
+++ b/fs/btrfs/transaction.c
@@ -796,7 +796,6 @@ static noinline int create_pending_snaps
 	memcpy(&pending->root_key, &key, sizeof(key));
 fail:
 	kfree(new_root_item);
-	btrfs_unreserve_metadata_space(root, 6);
 	return ret;
 }
 
@@ -808,7 +807,6 @@ static noinline int finish_pending_snaps
 	u64 index = 0;
 	struct btrfs_trans_handle *trans;
 	struct inode *parent_inode;
-	struct inode *inode;
 	struct btrfs_root *parent_root;
 
 	parent_inode = pending->dentry->d_parent->d_inode;
@@ -840,8 +838,6 @@ static noinline int finish_pending_snaps
 
 	BUG_ON(ret);
 
-	inode = btrfs_lookup_dentry(parent_inode, pending->dentry);
-	d_instantiate(pending->dentry, inode);
 fail:
 	btrfs_end_transaction(trans, fs_info->fs_root);
 	return ret;


