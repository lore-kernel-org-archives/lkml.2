Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751484Ab1IWS0S (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Sep 2011 14:26:18 -0400
Received: from mail131.messagelabs.com ([216.82.242.99]:41672 "EHLO
	mail131.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750957Ab1IWS0P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Sep 2011 14:26:15 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-7.tower-131.messagelabs.com!1316802370!1890128!9
X-Originating-IP: [216.166.12.32]
X-StarScan-Version: 6.3.6; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] btrfs/free-space-cache.c: quiet sparse warnings
Date: Fri, 23 Sep 2011 11:25:12 -0700
User-Agent: KMail/1.9.9
CC: <linux-btrfs@vger.kernel.org>, <chris.mason@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201109231125.12628.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quiet the following sparse warnings:

warning: symbol '__create_free_space_inode' was not declared. Should it be static?
warning: symbol '__load_free_space_cache' was not declared. Should it be static?
warning: symbol '__btrfs_write_out_cache' was not declared. Should it be static?
warning: symbol '__btrfs_remove_free_space_cache_locked' was not declared. Should it be static?
warning: context imbalance in 'insert_into_bitmap' - unexpected unlock

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Chris Mason <chris.mason@oracle.com> (maintainer:BTRFS FILE SYSTEM)

---

diff --git a/fs/btrfs/free-space-cache.c b/fs/btrfs/free-space-cache.c
index 6a265b9..bdd5c0e 100644
--- a/fs/btrfs/free-space-cache.c
+++ b/fs/btrfs/free-space-cache.c
@@ -113,7 +113,7 @@ struct inode *lookup_free_space_inode(struct btrfs_root *root,
 	return inode;
 }
 
-int __create_free_space_inode(struct btrfs_root *root,
+static int __create_free_space_inode(struct btrfs_root *root,
 			      struct btrfs_trans_handle *trans,
 			      struct btrfs_path *path, u64 ino, u64 offset)
 {
@@ -238,7 +238,7 @@ static int readahead_cache(struct inode *inode)
 	return 0;
 }
 
-int __load_free_space_cache(struct btrfs_root *root, struct inode *inode,
+static int __load_free_space_cache(struct btrfs_root *root, struct inode *inode,
 			    struct btrfs_free_space_ctl *ctl,
 			    struct btrfs_path *path, u64 offset)
 {
@@ -526,7 +526,7 @@ out:
 	return ret;
 }
 
-int __btrfs_write_out_cache(struct btrfs_root *root, struct inode *inode,
+static int __btrfs_write_out_cache(struct btrfs_root *root, struct inode *inode,
 			    struct btrfs_free_space_ctl *ctl,
 			    struct btrfs_block_group_cache *block_group,
 			    struct btrfs_trans_handle *trans,
@@ -1433,6 +1433,8 @@ static struct btrfs_free_space_op free_space_op = {
 
 static int insert_into_bitmap(struct btrfs_free_space_ctl *ctl,
 			      struct btrfs_free_space *info)
+	__releases(&ctl->tree_lock)
+	__acquires(&ctl->tree_lock)
 {
 	struct btrfs_free_space *bitmap_info;
 	struct btrfs_block_group_cache *block_group = NULL;
@@ -1842,7 +1844,8 @@ out:
 	return 0;
 }
 
-void __btrfs_remove_free_space_cache_locked(struct btrfs_free_space_ctl *ctl)
+static void
+__btrfs_remove_free_space_cache_locked(struct btrfs_free_space_ctl *ctl)
 {
 	struct btrfs_free_space *info;
 	struct rb_node *node;
