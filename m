Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752682Ab0HWBTP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Aug 2010 21:19:15 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:58632 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751674Ab0HWBTN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Aug 2010 21:19:13 -0400
Message-ID: <4C71CDB7.6000602@cn.fujitsu.com>
Date: Mon, 23 Aug 2010 09:24:07 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: Chris Mason <chris.mason@oracle.com>
CC: Josef Bacik <josef@redhat.com>, linux-btrfs@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 6/6] btrfs: check mergeable free space when removing a cluster
References: <4C71CD4B.10606@cn.fujitsu.com>
In-Reply-To: <4C71CD4B.10606@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

After returing extents from a cluster to the block group, some
extents in the block group may be mergeable.

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
---
 fs/btrfs/free-space-cache.c |   26 ++++++++++++++++++++------
 1 files changed, 20 insertions(+), 6 deletions(-)

diff --git a/fs/btrfs/free-space-cache.c b/fs/btrfs/free-space-cache.c
index faeec8f..c11f4f7 100644
--- a/fs/btrfs/free-space-cache.c
+++ b/fs/btrfs/free-space-cache.c
@@ -234,11 +234,18 @@ tree_search_offset(struct btrfs_block_group_cache *block_group,
 	return entry;
 }
 
-static void unlink_free_space(struct btrfs_block_group_cache *block_group,
-			      struct btrfs_free_space *info)
+static inline void
+__unlink_free_space(struct btrfs_block_group_cache *block_group,
+		    struct btrfs_free_space *info)
 {
 	rb_erase(&info->offset_index, &block_group->free_space_offset);
 	block_group->free_extents--;
+}
+
+static void unlink_free_space(struct btrfs_block_group_cache *block_group,
+			      struct btrfs_free_space *info)
+{
+	__unlink_free_space(block_group, info);
 	block_group->free_space -= info->bytes;
 }
 
@@ -611,7 +618,7 @@ out:
 }
 
 bool try_merge_free_space(struct btrfs_block_group_cache *block_group,
-			  struct btrfs_free_space *info)
+			  struct btrfs_free_space *info, bool update_stat)
 {
 	struct btrfs_free_space *left_info;
 	struct btrfs_free_space *right_info;
@@ -632,7 +639,10 @@ bool try_merge_free_space(struct btrfs_block_group_cache *block_group,
 		left_info = tree_search_offset(block_group, offset - 1, 0, 0);
 
 	if (right_info && !right_info->bitmap) {
-		unlink_free_space(block_group, right_info);
+		if (update_stat)
+			unlink_free_space(block_group, right_info);
+		else
+			__unlink_free_space(block_group, right_info);
 		info->bytes += right_info->bytes;
 		kfree(right_info);
 		merged = true;
@@ -640,7 +650,10 @@ bool try_merge_free_space(struct btrfs_block_group_cache *block_group,
 
 	if (left_info && !left_info->bitmap &&
 	    left_info->offset + left_info->bytes == offset) {
-		unlink_free_space(block_group, left_info);
+		if (update_stat)
+			unlink_free_space(block_group, left_info);
+		else
+			__unlink_free_space(block_group, left_info);
 		info->offset = left_info->offset;
 		info->bytes += left_info->bytes;
 		kfree(left_info);
@@ -665,7 +678,7 @@ int btrfs_add_free_space(struct btrfs_block_group_cache *block_group,
 
 	spin_lock(&block_group->tree_lock);
 
-	if (try_merge_free_space(block_group, info))
+	if (try_merge_free_space(block_group, info, true))
 		goto link;
 
 	/*
@@ -883,6 +896,7 @@ __btrfs_return_cluster_to_free_space(
 		node = rb_next(&entry->offset_index);
 		rb_erase(&entry->offset_index, &cluster->root);
 		BUG_ON(entry->bitmap);
+		try_merge_free_space(block_group, entry, false);
 		tree_insert_offset(&block_group->free_space_offset,
 				   entry->offset, &entry->offset_index, 0);
 	}
-- 
1.7.0.1

