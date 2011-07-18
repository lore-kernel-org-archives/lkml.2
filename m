Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754353Ab1GRMVx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jul 2011 08:21:53 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:54229 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751957Ab1GRMVw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jul 2011 08:21:52 -0400
From: Wanlong Gao <wanlong.gao@gmail.com>
To: linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Chris Mason <chris.mason@oracle.com>, Wanlong Gao <wanlong.gao@gmail.com>,
        Wanlong Gao <gaowanlong@cn.fujitsu.com>
Subject: [PATCH] Btrfs:don't check the return value of __btrfs_add_inode_defrag
Date: Mon, 18 Jul 2011 20:19:35 +0800
Message-Id: <1310991575-7528-1-git-send-email-wanlong.gao@gmail.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Don't need to check the return value of __btrfs_add_inode_defrag(),
since it will always return 0.

Signed-off-by: Wanlong Gao <gaowanlong@cn.fujitsu.com>
---
 fs/btrfs/file.c |   11 +++++------
 1 files changed, 5 insertions(+), 6 deletions(-)

diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
index fa4ef18..4a6d190 100644
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -74,7 +74,7 @@ struct inode_defrag {
  * If an existing record is found the defrag item you
  * pass in is freed
  */
-static int __btrfs_add_inode_defrag(struct inode *inode,
+static void __btrfs_add_inode_defrag(struct inode *inode,
 				    struct inode_defrag *defrag)
 {
 	struct btrfs_root *root = BTRFS_I(inode)->root;
@@ -106,11 +106,11 @@ static int __btrfs_add_inode_defrag(struct inode *inode,
 	BTRFS_I(inode)->in_defrag = 1;
 	rb_link_node(&defrag->rb_node, parent, p);
 	rb_insert_color(&defrag->rb_node, &root->fs_info->defrag_inodes);
-	return 0;
+	return;
 
 exists:
 	kfree(defrag);
-	return 0;
+	return;
 
 }
 
@@ -123,7 +123,6 @@ int btrfs_add_inode_defrag(struct btrfs_trans_handle *trans,
 {
 	struct btrfs_root *root = BTRFS_I(inode)->root;
 	struct inode_defrag *defrag;
-	int ret = 0;
 	u64 transid;
 
 	if (!btrfs_test_opt(root, AUTO_DEFRAG))
@@ -150,9 +149,9 @@ int btrfs_add_inode_defrag(struct btrfs_trans_handle *trans,
 
 	spin_lock(&root->fs_info->defrag_inodes_lock);
 	if (!BTRFS_I(inode)->in_defrag)
-		ret = __btrfs_add_inode_defrag(inode, defrag);
+		__btrfs_add_inode_defrag(inode, defrag);
 	spin_unlock(&root->fs_info->defrag_inodes_lock);
-	return ret;
+	return 0;
 }
 
 /*
-- 
1.7.4.1

