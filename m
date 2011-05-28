Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754093Ab1E1P0v (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 May 2011 11:26:51 -0400
Received: from mga11.intel.com ([192.55.52.93]:3692 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752758Ab1E1P0t (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 May 2011 11:26:49 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.65,285,1304319600"; 
   d="scan'208";a="8935162"
From: Andi Kleen <andi@firstfloor.org>
To: viro@zeniv.linux.org.uk
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        Andi Kleen <ak@linux.intel.com>, josef@redhat.com,
        chris.mason@oracle.com
Subject: [PATCH 3/4] BTRFS: Set NOSEC early for btrfs v2
Date: Sat, 28 May 2011 08:25:53 -0700
Message-Id: <1306596354-18453-3-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1306596354-18453-1-git-send-email-andi@firstfloor.org>
References: <1306596354-18453-1-git-send-email-andi@firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

Based on a suggestion from Josef Bacik.

The btrfs inode lookup already does a quick check for xattrs.
If it doesn't find any and the file is not sgid set the NOSEC flag.
This avoids a xattr lookup on the first write.

v2: Use helper
Cc: josef@redhat.com
Cc: chris.mason@oracle.com
Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 fs/btrfs/inode.c |    8 +++++++-
 1 files changed, 7 insertions(+), 1 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 7cd8ab0..20cecb8 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -2544,8 +2544,10 @@ static void btrfs_read_locked_inode(struct inode *inode)
 	 * any xattrs or acls
 	 */
 	maybe_acls = acls_after_inode_item(leaf, path->slots[0], inode->i_ino);
-	if (!maybe_acls)
+	if (!maybe_acls) {
 		cache_no_acl(inode);
+		inode_has_no_xattr(inode);
+	}
 
 	BTRFS_I(inode)->block_group = btrfs_find_block_group(root, 0,
 						alloc_group_block, 0);
@@ -4616,6 +4618,10 @@ static struct inode *btrfs_new_inode(struct btrfs_trans_handle *trans,
 		    (BTRFS_I(dir)->flags & BTRFS_INODE_NODATACOW))
 			BTRFS_I(inode)->flags |= BTRFS_INODE_NODATACOW;
 	}
+	/* 
+ 	 * A new inode has no xattrs yet.
+ 	 */
+	inode_has_no_xattr(inode);
 
 	insert_inode_hash(inode);
 	inode_tree_add(inode);
-- 
1.7.4.4

