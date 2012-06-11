Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755271Ab2FKQ3u (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2012 12:29:50 -0400
Received: from sh.osrg.net ([192.16.179.4]:60027 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754779Ab2FKQ3s (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2012 12:29:48 -0400
Date: Tue, 12 Jun 2012 01:29:43 +0900 (JST)
Message-Id: <20120612.012943.73783083.konishi.ryusuke@lab.ntt.co.jp>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-nilfs@vger.kernel.org
Subject: [PATCH] nilfs2: ensure proper cache clearing for gc-inodes
From: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
X-Mailer: Mew version 5.2 on Emacs 22.2 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.3.7 (sh.osrg.net [192.16.179.4]); Tue, 12 Jun 2012 01:29:44 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrew,

Please apply the following bug fix and send them upstream via the -mm
tree, hopefully in this cycle.

This eliminates a recently found meta-data corruption issue which
happens under specific conditions during garbage collection.

The bug is reproducible, and I confirmed that it fixes the issue in
the latest and prior kernels.

Thanks,
Ryusuke Konishi
--
From: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>

A gc-inode is a pseudo inode used to buffer the blocks to be moved by
garbage collection.

Block caches of gc-inodes must be cleared every time a garbage
collection function (nilfs_clean_segments) completes.  Otherwise,
stale blocks buffered in the caches may be wrongly reused in
successive calls of the GC function.

For user files, this is not a problem because their gc-inodes are
distinguished by a checkpoint number as well as an inode number.  They
never buffer different blocks if either an inode number, a checkpoint
number, or a block offset differs.

However, gc-inodes of sufile, cpfile and DAT file can store different
data for the same block offset.  Thus, the nilfs_clean_segments
function can move incorrect block for these meta-data files if an old
block is cached.  I found this is really causing meta-data corruption
in nilfs.

This fixes the issue by ensuring cache clear of gc-inodes and resolves
reported GC problems including checkpoint file corruption, b-tree
corruption, and the following warning during GC.

  nilfs_palloc_freev: entry number 307234 already freed.
  ...

Signed-off-by: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Tested-by: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Cc: <stable@vger.kernel.org> [2.6.37+]
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
-- 
1.7.9.3

