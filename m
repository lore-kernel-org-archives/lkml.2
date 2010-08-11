Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933585Ab0HLAg2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Aug 2010 20:36:28 -0400
Received: from kroah.org ([198.145.64.141]:43410 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759044Ab0HKX6e (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Aug 2010 19:58:34 -0400
X-Mailbox-Line: From gregkh@clark.site Wed Aug 11 16:55:01 2010
Message-Id: <20100811235501.062003071@clark.site>
User-Agent: quilt/0.48-11.2
Date: Wed, 11 Aug 2010 16:54:41 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Chris Mason <chris.mason@oracle.com>, Jeff Mahoney <jeffm@suse.com>
Subject: [060/111] Btrfs: make sure fallocate properly starts a transaction
In-Reply-To: <20100811235623.GA24440@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Chris Mason <chris.mason@oracle.com>

commit 3a1abec9f6880cf406593c392636199ea1c6c917 upstream.

The recent patch to make fallocate enospc friendly would send
down a NULL trans handle to the allocator.  This moves the
transaction start to properly fix things.

Signed-off-by: Chris Mason <chris.mason@oracle.com>
Acked-by: Jeff Mahoney <jeffm@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>


---
 fs/btrfs/inode.c |   13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -5802,23 +5802,23 @@ static int prealloc_file_range(struct in
 	while (num_bytes > 0) {
 		alloc_size = min(num_bytes, root->fs_info->max_extent);
 
+		trans = btrfs_start_transaction(root, 1);
+
 		ret = btrfs_reserve_extent(trans, root, alloc_size,
 					   root->sectorsize, 0, alloc_hint,
 					   (u64)-1, &ins, 1);
 		if (ret) {
 			WARN_ON(1);
-			break;
+			goto stop_trans;
 		}
 
 		ret = btrfs_reserve_metadata_space(root, 3);
 		if (ret) {
 			btrfs_free_reserved_extent(root, ins.objectid,
 						   ins.offset);
-			break;
+			goto stop_trans;
 		}
 
-		trans = btrfs_start_transaction(root, 1);
-
 		ret = insert_reserved_file_extent(trans, inode,
 						  cur_offset, ins.objectid,
 						  ins.offset, ins.offset,
@@ -5847,6 +5847,11 @@ static int prealloc_file_range(struct in
 		btrfs_unreserve_metadata_space(root, 3);
 	}
 	return ret;
+
+stop_trans:
+	btrfs_end_transaction(trans, root);
+	return ret;
+
 }
 
 static long btrfs_fallocate(struct inode *inode, int mode,


