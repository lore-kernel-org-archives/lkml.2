Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964868Ab1LPUv6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Dec 2011 15:51:58 -0500
Received: from cantor2.suse.de ([195.135.220.15]:48968 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964879Ab1LPUvq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Dec 2011 15:51:46 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Fri Dec 16 12:50:43 2011
Message-Id: <20111216205043.297170982@clark.kroah.org>
User-Agent: quilt/0.50-24.1
Date: Fri, 16 Dec 2011 12:49:44 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Phillip Lougher <plougher@redhat.com>,
        Jeff Mahoney <jeffm@suse.com>, Christoph Hellwig <hch@lst.de>,
        =?UTF-8?q?Moritz=20M=C3=BChlenhoff?= <jmm@inutil.org>
Subject: [11/16] hfs: fix hfs_find_init() sb->ext_tree NULL ptr oops
In-Reply-To: <20111216205049.GA28030@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let me know.

------------------

From: Phillip Lougher <plougher@redhat.com>

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
Cc: Moritz Mühlenhoff <jmm@inutil.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/hfs/btree.c |   20 +++++++++++++++-----
 1 file changed, 15 insertions(+), 5 deletions(-)

--- a/fs/hfs/btree.c
+++ b/fs/hfs/btree.c
@@ -45,11 +45,26 @@ struct hfs_btree *hfs_btree_open(struct
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
@@ -58,11 +73,6 @@ struct hfs_btree *hfs_btree_open(struct
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


