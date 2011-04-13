Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932502Ab1DMQHx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Apr 2011 12:07:53 -0400
Received: from kroah.org ([198.145.64.141]:54304 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757904Ab1DMPzY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Apr 2011 11:55:24 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Apr 13 08:51:45 2011
Message-Id: <20110413155145.640744834@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 13 Apr 2011 08:50:49 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Li Zefan <lizf@cn.fujitsu.com>, Chris Mason <chris.mason@oracle.com>
Subject: [25/74] Btrfs: Fix uninitialized root flags for subvolumes
In-Reply-To: <20110413155406.GA22568@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let us know.

------------------

From: Li Zefan <lizf@cn.fujitsu.com>

commit 08fe4db170b4193603d9d31f40ebaf652d07ac9c upstream.

root_item->flags and root_item->byte_limit are not initialized when
a subvolume is created. This bug is not revealed until we added
readonly snapshot support - now you mount a btrfs filesystem and you
may find the subvolumes in it are readonly.

To work around this problem, we steal a bit from root_item->inode_item->flags,
and use it to indicate if those fields have been properly initialized.
When we read a tree root from disk, we check if the bit is set, and if
not we'll set the flag and initialize the two fields of the root item.

Reported-by: Andreas Philipp <philipp.andreas@gmail.com>
Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
Tested-by: Andreas Philipp <philipp.andreas@gmail.com>
Signed-off-by: Chris Mason <chris.mason@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/btrfs/ctree.h       |    4 ++++
 fs/btrfs/disk-io.c     |    4 +++-
 fs/btrfs/ioctl.c       |    4 ++++
 fs/btrfs/root-tree.c   |   18 ++++++++++++++++++
 fs/btrfs/transaction.c |    1 +
 5 files changed, 30 insertions(+), 1 deletion(-)

--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -1182,6 +1182,8 @@ struct btrfs_root {
 #define BTRFS_INODE_DIRSYNC		(1 << 10)
 
 
+#define BTRFS_INODE_ROOT_ITEM_INIT	(1 << 31)
+
 /* some macros to generate set/get funcs for the struct fields.  This
  * assumes there is a lefoo_to_cpu for every type, so lets make a simple
  * one for u8:
@@ -2183,6 +2185,8 @@ int btrfs_find_dead_roots(struct btrfs_r
 int btrfs_find_orphan_roots(struct btrfs_root *tree_root);
 int btrfs_set_root_node(struct btrfs_root_item *item,
 			struct extent_buffer *node);
+void btrfs_check_and_init_root_item(struct btrfs_root_item *item);
+
 /* dir-item.c */
 int btrfs_insert_dir_item(struct btrfs_trans_handle *trans,
 			  struct btrfs_root *root, const char *name,
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -1145,8 +1145,10 @@ struct btrfs_root *btrfs_read_fs_root_no
 	root->commit_root = btrfs_root_node(root);
 	BUG_ON(!root->node);
 out:
-	if (location->objectid != BTRFS_TREE_LOG_OBJECTID)
+	if (location->objectid != BTRFS_TREE_LOG_OBJECTID) {
 		root->ref_cows = 1;
+		btrfs_check_and_init_root_item(&root->root_item);
+	}
 
 	return root;
 }
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -285,6 +285,10 @@ static noinline int create_subvol(struct
 	inode_item->nbytes = cpu_to_le64(root->leafsize);
 	inode_item->mode = cpu_to_le32(S_IFDIR | 0755);
 
+	root_item.flags = 0;
+	root_item.byte_limit = 0;
+	inode_item->flags = cpu_to_le64(BTRFS_INODE_ROOT_ITEM_INIT);
+
 	btrfs_set_root_bytenr(&root_item, leaf->start);
 	btrfs_set_root_generation(&root_item, trans->transid);
 	btrfs_set_root_level(&root_item, 0);
--- a/fs/btrfs/root-tree.c
+++ b/fs/btrfs/root-tree.c
@@ -459,3 +459,21 @@ again:
 	btrfs_free_path(path);
 	return 0;
 }
+
+/*
+ * Old btrfs forgets to init root_item->flags and root_item->byte_limit
+ * for subvolumes. To work around this problem, we steal a bit from
+ * root_item->inode_item->flags, and use it to indicate if those fields
+ * have been properly initialized.
+ */
+void btrfs_check_and_init_root_item(struct btrfs_root_item *root_item)
+{
+	u64 inode_flags = le64_to_cpu(root_item->inode.flags);
+
+	if (!(inode_flags & BTRFS_INODE_ROOT_ITEM_INIT)) {
+		inode_flags |= BTRFS_INODE_ROOT_ITEM_INIT;
+		root_item->inode.flags = cpu_to_le64(inode_flags);
+		root_item->flags = 0;
+		root_item->byte_limit = 0;
+	}
+}
--- a/fs/btrfs/transaction.c
+++ b/fs/btrfs/transaction.c
@@ -777,6 +777,7 @@ static noinline int create_pending_snaps
 	record_root_in_trans(trans, root);
 	btrfs_set_root_last_snapshot(&root->root_item, trans->transid);
 	memcpy(new_root_item, &root->root_item, sizeof(*new_root_item));
+	btrfs_check_and_init_root_item(new_root_item);
 
 	key.objectid = objectid;
 	/* record when the snapshot was created in key.offset */


