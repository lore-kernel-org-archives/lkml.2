Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934160Ab1IOPzX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Sep 2011 11:55:23 -0400
Received: from mx1.redhat.com ([209.132.183.28]:14503 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934124Ab1IOPzW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Sep 2011 11:55:22 -0400
Date: Thu, 15 Sep 2011 16:55:17 +0100
To: linux-fsdevel@vger.kernel.org
Subject: [PATCH] hfs: fix hfs_find_init() sb->ext_tree NULL ptr oops
Cc: akpm@linux-foundation.org, hch@lst.de, linux-kernel@vger.kernel.org
User-Agent: Heirloom mailx 12.4 7/29/08
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20110915155517.8C68544B82@plougher.csb>
From: plougher@redhat.com (Phillip Lougher)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(Re-send due to missing off [PATCH] in the subject line)

Clement Lecigne reports a filesystem which causes a kernel oops
in hfs_find_init() trying to dereference sb->ext_tree which is NULL.

This proves to be because the filesystem has a corrupted MDB extent record,
where the extents file does not fit into the first three extents in
the file record (the first blocks).

In hfs_get_block() when looking up the blocks for the extent file
(HFS_EXT_CNID), it fails the first blocks special case, and falls through
to the extent code (which ultimately calls hfs_find_init()) which is
in the process of being initialised.

Hfs avoids this scenario by always having the extents b-tree
fitting into the first blocks (the extents B-tree can't have overflow
extents).

The fix is to check at mount time that the B-tree fits into first blocks,
i.e.  fail if HFS_I(inode)->alloc_blocks >= HFS_I(inode)->first_blocks

Note, the existing commit 47f365eb575735c6b2edf5d08e0d16d26a9c23bd
becomes subsumed into this as a special case, but only for the
extents B-tree (HFS_EXT_CNID), it is perfectly acceptable for the catalog
B-Tree file to grow beyond three extents, with the remaining extent
descriptors in the extents overfow.

This fixes CVE-2011-2203

Reported-by: Clement LECIGNE <clement.lecigne@netasq.com>
Signed-off-by: Phillip Lougher <plougher@redhat.com>
---
 fs/hfs/btree.c |   20 +++++++++++++++-----
 1 files changed, 15 insertions(+), 5 deletions(-)

diff --git a/fs/hfs/btree.c b/fs/hfs/btree.c
index 3ebc437..c28b7fa 100644
--- a/fs/hfs/btree.c
+++ b/fs/hfs/btree.c
@@ -46,11 +46,26 @@ struct hfs_btree *hfs_btree_open(struct super_block *sb, u32 id, btree_keycmp ke
 	case HFS_EXT_CNID:
 		hfs_inode_read_fork(tree->inode, mdb->drXTExtRec, mdb->drXTFlSize,
 				    mdb->drXTFlSize, be32_to_cpu(mdb->drXTClpSiz));
+		if (HFS_I(tree->inode)->alloc_blocks >
+					HFS_I(tree->inode)->first_blocks) {
+			printk(KERN_ERR "hfs: invalid btree extent records\n");
+			unlock_new_inode(tree->inode);
+			goto free_inode;
+		}
+
 		tree->inode->i_mapping->a_ops = &hfs_btree_aops;
 		break;
 	case HFS_CAT_CNID:
 		hfs_inode_read_fork(tree->inode, mdb->drCTExtRec, mdb->drCTFlSize,
 				    mdb->drCTFlSize, be32_to_cpu(mdb->drCTClpSiz));
+
+		if (!HFS_I(tree->inode)->first_blocks) {
+			printk(KERN_ERR "hfs: invalid btree extent records "
+								"(0 size).\n");
+			unlock_new_inode(tree->inode);
+			goto free_inode;
+		}
+
 		tree->inode->i_mapping->a_ops = &hfs_btree_aops;
 		break;
 	default:
@@ -59,11 +74,6 @@ struct hfs_btree *hfs_btree_open(struct super_block *sb, u32 id, btree_keycmp ke
 	}
 	unlock_new_inode(tree->inode);
 
-	if (!HFS_I(tree->inode)->first_blocks) {
-		printk(KERN_ERR "hfs: invalid btree extent records (0 size).\n");
-		goto free_inode;
-	}
-
 	mapping = tree->inode->i_mapping;
 	page = read_mapping_page(mapping, 0, NULL);
 	if (IS_ERR(page))
-- 
1.7.1
