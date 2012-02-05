Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754879Ab2BEW1P (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Feb 2012 17:27:15 -0500
Received: from 1wt.eu ([62.212.114.60]:62130 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754735Ab2BEW1E (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Feb 2012 17:27:04 -0500
Message-Id: <20120205220952.057754032@pcw.home.local>
User-Agent: quilt/0.48-1
Date: Sun, 05 Feb 2012 23:10:50 +0100
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Phillip Lougher <plougher@redhat.com>, Jeff Mahoney <jeffm@suse.com>,
        Christoph Hellwig <hch@lst.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        =?ISO-8859-15?q?Moritz=20M=FChlenhoff?= <jmm@inutil.org>,
        Greg KH <gregkh@linuxfoundation.org>
Subject: [PATCH 61/91] hfs: fix hfs_find_init() sb->ext_tree NULL ptr oops
In-Reply-To: <0635750f5f06ed2ca212b91fcb5c4483@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-longterm review patch.  If anyone has any objections, please let us know.

------------------

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

[WT: patch edited - 47f365eb57573 was missing from 2.6.27.x]

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
 1 files changed, 15 insertions(+), 5 deletions(-)

Index: longterm-2.6.27/fs/hfs/btree.c
===================================================================
--- longterm-2.6.27.orig/fs/hfs/btree.c	2012-02-05 22:34:33.129915287 +0100
+++ longterm-2.6.27/fs/hfs/btree.c	2012-02-05 22:34:43.555914905 +0100
@@ -45,11 +45,26 @@
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


