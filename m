Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759482Ab0HLAdN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Aug 2010 20:33:13 -0400
Received: from kroah.org ([198.145.64.141]:43549 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759076Ab0HKX66 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Aug 2010 19:58:58 -0400
X-Mailbox-Line: From gregkh@clark.site Wed Aug 11 16:55:02 2010
Message-Id: <20100811235502.878242431@clark.site>
User-Agent: quilt/0.48-11.2
Date: Wed, 11 Aug 2010 16:55:01 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Shaohua Li <shaohua.li@intel.com>, Yan Zheng <zheng.yan@oracle.com>,
        Chris Mason <chris.mason@oracle.com>, Jeff Mahoney <jeffm@suse.com>
Subject: [080/111] Btrfs: btrfs_mark_extent_written uses the wrong slot
In-Reply-To: <20100811235623.GA24440@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Shaohua Li <shaohua.li@intel.com>

commit 3f6fae9559225741c91f1320090b285da1413290 upstream.

My test do: fallocate a big file and do write. The file is 512M, but
after file write is done btrfs-debug-tree shows:
item 6 key (257 EXTENT_DATA 0) itemoff 3516 itemsize 53
                extent data disk byte 1103101952 nr 536870912
                extent data offset 0 nr 399634432 ram 536870912
                extent compression 0
Looks like a regression introducted by
6c7d54ac87f338c479d9729e8392eca3f76e11e1, where we set wrong slot.

Signed-off-by: Shaohua Li <shaohua.li@intel.com>
Acked-by: Yan Zheng <zheng.yan@oracle.com>
Signed-off-by: Chris Mason <chris.mason@oracle.com>
Acked-by: Jeff Mahoney <jeffm@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/btrfs/file.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -720,13 +720,15 @@ again:
 					inode->i_ino, orig_offset);
 		BUG_ON(ret);
 	}
-	fi = btrfs_item_ptr(leaf, path->slots[0],
-			   struct btrfs_file_extent_item);
 	if (del_nr == 0) {
+		fi = btrfs_item_ptr(leaf, path->slots[0],
+			   struct btrfs_file_extent_item);
 		btrfs_set_file_extent_type(leaf, fi,
 					   BTRFS_FILE_EXTENT_REG);
 		btrfs_mark_buffer_dirty(leaf);
 	} else {
+		fi = btrfs_item_ptr(leaf, del_slot - 1,
+			   struct btrfs_file_extent_item);
 		btrfs_set_file_extent_type(leaf, fi,
 					   BTRFS_FILE_EXTENT_REG);
 		btrfs_set_file_extent_num_bytes(leaf, fi,


