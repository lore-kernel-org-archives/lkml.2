Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753140Ab1L0JqT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Dec 2011 04:46:19 -0500
Received: from mail-vx0-f174.google.com ([209.85.220.174]:43700 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752550Ab1L0JqR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Dec 2011 04:46:17 -0500
MIME-Version: 1.0
Date: Tue, 27 Dec 2011 15:16:16 +0530
Message-ID: <CAB4K4y62oCFphQWzeR+Cwdc+EBhp+fGFjzFXyXyjOTiyjwh_sQ@mail.gmail.com>
Subject: [PATCH] Squashfs: optimise squashfs_cache_get entry search
From: Ajeet Yadav <ajeet.yadav.77@gmail.com>
To: Phillip Lougher <phillip@squashfs.org.uk>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 207aafb6e1dde1bc8d7f04be5c803f30a337c188 Mon Sep 17 00:00:00 2001
From: Ajeet Yadav <ajeet.yadav.77@gmail.com>
Date: Tue, 27 Dec 2011 15:10:04 +0530
Subject: [PATCH] Squashfs: optimise squashfs_cache_get entry search

squashfs_cache_get() iterates over all entries to search for
 block its looking for. Often get() / put() are called for
 same block.

If we cache the current entry index, then we can optimise the
subsequent *_get() calls.

Signed-off-by: Ajeet Yadav <ajeet.yadav.77@gmail.com>
---
 fs/squashfs/cache.c          |   11 ++++++++---
 fs/squashfs/squashfs_fs_sb.h |    1 +
 2 files changed, 9 insertions(+), 3 deletions(-)

diff --git a/fs/squashfs/cache.c b/fs/squashfs/cache.c
index 516ce2d..fbd9670 100644
--- a/fs/squashfs/cache.c
+++ b/fs/squashfs/cache.c
@@ -70,11 +70,15 @@ struct squashfs_cache_entry
*squashfs_cache_get(struct super_block *sb,
 	spin_lock(&cache->lock);

 	while (1) {
-		for (i = 0; i < cache->entries; i++)
-			if (cache->entry[i].block == block)
+		for (i = cache->curr_blk, n = 0; n < cache->entries; n++) {
+			if (cache->entry[i].block == block) {
+				cache->curr_blk = i;
 				break;
+			}
+			i = (i + 1) % cache->entries;
+		}

-		if (i == cache->entries) {
+		if (n == cache->entries) {
 			/*
 			 * Block not in cache, if all cache entries are used
 			 * go to sleep waiting for one to become available.
@@ -240,6 +244,7 @@ struct squashfs_cache *squashfs_cache_init(char
*name, int entries,
 		goto cleanup;
 	}

+	cache->curr_blk = 0;
 	cache->next_blk = 0;
 	cache->unused = entries;
 	cache->entries = entries;
diff --git a/fs/squashfs/squashfs_fs_sb.h b/fs/squashfs/squashfs_fs_sb.h
index 651f0b3..52934a2 100644
--- a/fs/squashfs/squashfs_fs_sb.h
+++ b/fs/squashfs/squashfs_fs_sb.h
@@ -28,6 +28,7 @@
 struct squashfs_cache {
 	char			*name;
 	int			entries;
+	int			curr_blk;
 	int			next_blk;
 	int			num_waiters;
 	int			unused;
-- 
1.6.0.3
