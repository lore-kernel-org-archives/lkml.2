Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756980Ab3AHXii (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2013 18:38:38 -0500
Received: from mail1.windriver.com ([147.11.146.13]:53701 "EHLO
	mail1.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756897Ab3AHXig (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2013 18:38:36 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: <stable@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: Phillip Lougher <plougher@redhat.com>, Jeff Mahoney <jeffm@suse.com>,
        Christoph Hellwig <hch@lst.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [v2.6.34-stable 54/77] hfs: fix hfs_find_init() sb->ext_tree NULL ptr oops
Date: Tue, 8 Jan 2013 18:35:33 -0500
Message-ID: <1357688156-25387-55-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.12.1
In-Reply-To: <1357688156-25387-1-git-send-email-paul.gortmaker@windriver.com>
References: <1357688156-25387-1-git-send-email-paul.gortmaker@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Phillip Lougher <plougher@redhat.com>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    http://git.kernel.org/?p=linux/kernel/git/paulg/longterm-queue-2.6.34.git
    If you see a problem with using this for longterm, please comment.
                   -------------------

commit 434a964daa14b9db083ce20404a4a2add54d037a upstream.

Clement Lecigne reports a filesystem which causes a kernel oops in
hfs_find_init() trying to dereference sb->ext_tree which is NULL.

This proves to be because the filesystem has a corrupted MDB extent
record, where the extents file does not fit into the first three extents
in the file record (the first blocks).

In hfs_get_block() when looking up the blocks for the extent file
(HFS_EXT_CNID), it fails the first blocks special case, and falls
through to the extent code (which ultimately calls hfs_find_init())
which is in the process of being initialised.

Hfs avoids this scenario by always having the extents b-tree fitting
into the first blocks (the extents B-tree can't have overflow extents).

The fix is to check at mount time that the B-tree fits into first
blocks, i.e.  fail if HFS_I(inode)->alloc_blocks >=
HFS_I(inode)->first_blocks

Note, the existing commit 47f365eb57573 ("hfs: fix oops on mount with
corrupted btree extent records") becomes subsumed into this as a special
case, but only for the extents B-tree (HFS_EXT_CNID), it is perfectly
acceptable for the catalog B-Tree file to grow beyond three extents,
with the remaining extent descriptors in the extents overfow.

This fixes CVE-2011-2203

Reported-by: Clement LECIGNE <clement.lecigne@netasq.com>
Signed-off-by: Phillip Lougher <plougher@redhat.com>
Cc: Jeff Mahoney <jeffm@suse.com>
Cc: Christoph Hellwig <hch@lst.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 fs/hfs/btree.c | 20 +++++++++++++++-----
 1 file changed, 15 insertions(+), 5 deletions(-)

diff --git a/fs/hfs/btree.c b/fs/hfs/btree.c
index 38a0a99..d4e98a7 100644
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
1.7.12.1

