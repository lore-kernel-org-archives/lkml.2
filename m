Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756010Ab2GAS2O (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jul 2012 14:28:14 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:46912 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751735Ab2GASQZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jul 2012 14:16:25 -0400
Message-Id: <20120701172008.111848920@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Sun, 01 Jul 2012 18:20:16 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk,
        Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Subject: [ 10/48] nilfs2: ensure proper cache clearing for gc-inodes
In-Reply-To: <20120701172006.535271340@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>

commit fbb24a3a915f105016f1c828476be11aceac8504 upstream.

A gc-inode is a pseudo inode used to buffer the blocks to be moved by
garbage collection.

Block caches of gc-inodes must be cleared every time a garbage collection
function (nilfs_clean_segments) completes.  Otherwise, stale blocks
buffered in the caches may be wrongly reused in successive calls of the GC
function.

For user files, this is not a problem because their gc-inodes are
distinguished by a checkpoint number as well as an inode number.  They
never buffer different blocks if either an inode number, a checkpoint
number, or a block offset differs.

However, gc-inodes of sufile, cpfile and DAT file can store different data
for the same block offset.  Thus, the nilfs_clean_segments function can
move incorrect block for these meta-data files if an old block is cached.
I found this is really causing meta-data corruption in nilfs.

This fixes the issue by ensuring cache clear of gc-inodes and resolves
reported GC problems including checkpoint file corruption, b-tree
corruption, and the following warning during GC.

  nilfs_palloc_freev: entry number 307234 already freed.
  ...

Signed-off-by: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Tested-by: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 fs/nilfs2/gcinode.c |    2 ++
 fs/nilfs2/segment.c |    2 ++
 2 files changed, 4 insertions(+)

diff --git a/fs/nilfs2/gcinode.c b/fs/nilfs2/gcinode.c
index 08a07a2..57ceaf3 100644
--- a/fs/nilfs2/gcinode.c
+++ b/fs/nilfs2/gcinode.c
@@ -191,6 +191,8 @@ void nilfs_remove_all_gcinodes(struct the_nilfs *nilfs)
 	while (!list_empty(head)) {
 		ii = list_first_entry(head, struct nilfs_inode_info, i_dirty);
 		list_del_init(&ii->i_dirty);
+		truncate_inode_pages(&ii->vfs_inode.i_data, 0);
+		nilfs_btnode_cache_clear(&ii->i_btnode_cache);
 		iput(&ii->vfs_inode);
 	}
 }
diff --git a/fs/nilfs2/segment.c b/fs/nilfs2/segment.c
index 0e72ad6..88e11fb 100644
--- a/fs/nilfs2/segment.c
+++ b/fs/nilfs2/segment.c
@@ -2309,6 +2309,8 @@ nilfs_remove_written_gcinodes(struct the_nilfs *nilfs, struct list_head *head)
 		if (!test_bit(NILFS_I_UPDATED, &ii->i_state))
 			continue;
 		list_del_init(&ii->i_dirty);
+		truncate_inode_pages(&ii->vfs_inode.i_data, 0);
+		nilfs_btnode_cache_clear(&ii->i_btnode_cache);
 		iput(&ii->vfs_inode);
 	}
 }


