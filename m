Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161916Ab2GLXlp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2012 19:41:45 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:60450 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759612Ab2GLWiW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2012 18:38:22 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Subject: [ 049/187] nilfs2: ensure proper cache clearing for gc-inodes
Date: Thu, 12 Jul 2012 15:33:25 -0700
Message-Id: <20120712191526.889754823@linuxfoundation.org>
X-Mailer: git-send-email 1.7.10.1.362.g242cab3
In-Reply-To: <20120712191522.742634173@linuxfoundation.org>
References: <20120712192421.GA28926@kroah.com>
 <20120712191522.742634173@linuxfoundation.org>
User-Agent: quilt/0.60-20.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>

3.4-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/nilfs2/gcinode.c |    2 ++
 fs/nilfs2/segment.c |    2 ++
 2 files changed, 4 insertions(+)

--- a/fs/nilfs2/gcinode.c
+++ b/fs/nilfs2/gcinode.c
@@ -191,6 +191,8 @@ void nilfs_remove_all_gcinodes(struct th
 	while (!list_empty(head)) {
 		ii = list_first_entry(head, struct nilfs_inode_info, i_dirty);
 		list_del_init(&ii->i_dirty);
+		truncate_inode_pages(&ii->vfs_inode.i_data, 0);
+		nilfs_btnode_cache_clear(&ii->i_btnode_cache);
 		iput(&ii->vfs_inode);
 	}
 }
--- a/fs/nilfs2/segment.c
+++ b/fs/nilfs2/segment.c
@@ -2309,6 +2309,8 @@ nilfs_remove_written_gcinodes(struct the
 		if (!test_bit(NILFS_I_UPDATED, &ii->i_state))
 			continue;
 		list_del_init(&ii->i_dirty);
+		truncate_inode_pages(&ii->vfs_inode.i_data, 0);
+		nilfs_btnode_cache_clear(&ii->i_btnode_cache);
 		iput(&ii->vfs_inode);
 	}
 }


