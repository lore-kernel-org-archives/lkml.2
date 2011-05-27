Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757498Ab1E0Wzq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 May 2011 18:55:46 -0400
Received: from mga09.intel.com ([134.134.136.24]:63407 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755239Ab1E0WzA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 May 2011 18:55:00 -0400
X-ExtLoop1: 1
From: Andi Kleen <andi@firstfloor.org>
To: linux-kernel@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org, viro@zeniv.linux.org.uk,
        Andi Kleen <ak@linux.intel.com>, josef@redhat.com,
        chris.mason@oracle.com
Subject: [PATCH 3/4] BTRFS: Set NOSEC early for btrfs
Date: Fri, 27 May 2011 15:54:04 -0700
Message-Id: <1306536845-24162-3-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1306536845-24162-1-git-send-email-andi@firstfloor.org>
References: <1306536845-24162-1-git-send-email-andi@firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

Based on a suggestion from Josef Bacik.

The btrfs inode lookup already does a quick check for xattrs.
If it doesn't find any and the file is not sgid set the NOSEC flag.
This avoids a xattr lookup on the first write.

Cc: josef@redhat.com
Cc: chris.mason@oracle.com
Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 fs/btrfs/inode.c |    7 ++++++-
 1 files changed, 6 insertions(+), 1 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 7cd8ab0..b309c30 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -2544,8 +2544,11 @@ static void btrfs_read_locked_inode(struct inode *inode)
 	 * any xattrs or acls
 	 */
 	maybe_acls = acls_after_inode_item(leaf, path->slots[0], inode->i_ino);
-	if (!maybe_acls)
+	if (!maybe_acls) {
 		cache_no_acl(inode);
+		if (!is_sgid(inode->i_mode))
+			inode->i_flags |= S_NOSEC;
+	}
 
 	BTRFS_I(inode)->block_group = btrfs_find_block_group(root, 0,
 						alloc_group_block, 0);
@@ -4616,6 +4619,8 @@ static struct inode *btrfs_new_inode(struct btrfs_trans_handle *trans,
 		    (BTRFS_I(dir)->flags & BTRFS_INODE_NODATACOW))
 			BTRFS_I(inode)->flags |= BTRFS_INODE_NODATACOW;
 	}
+	if (!is_sgid(mode))
+		inode->i_flags |= S_NOSEC;
 
 	insert_inode_hash(inode);
 	inode_tree_add(inode);
-- 
1.7.4.4

