Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757107Ab1LWNWN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Dec 2011 08:22:13 -0500
Received: from mail-vw0-f46.google.com ([209.85.212.46]:34218 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754251Ab1LWNWJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Dec 2011 08:22:09 -0500
MIME-Version: 1.0
Date: Fri, 23 Dec 2011 18:52:08 +0530
Message-ID: <CAB4K4y79kiTWxQ7yaLRAPe5wOYPYY1RO2U-M9Dt8bZysefOgkA@mail.gmail.com>
Subject: [PATCH 1/2] Squashfs: add assert to cache entry refcount
From: Ajeet Yadav <ajeet.yadav.77@gmail.com>
To: Phillip Lougher <phillip@squashfs.org.uk>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From a7bb6c920bdc8341830387cff72726629dfd8730 Mon Sep 17 00:00:00 2001
From: Ajeet Yadav <ajeet.yadav.77@gmail.com>
Date: Fri, 23 Dec 2011 17:25:48 +0530
Subject: [PATCH 1/2] Squashfs: add assert to cache entry refcount

squashfs_cache_put() function decrements refcount, if the given
function is incorrectly used, refcount can have negative value.

Add ASSERT to entry->refcount, enabled if CONFIG_SQUASHFS_DEBUGGER
is defined.

Signed-off-by: Ajeet Yadav <ajeet.yadav.77@gmail.com>
---
 fs/squashfs/cache.c       |    8 ++++----
 fs/squashfs/squashfs_fs.h |   10 ++++++++++
 2 files changed, 14 insertions(+), 4 deletions(-)

diff --git a/fs/squashfs/cache.c b/fs/squashfs/cache.c
index f744be9..88d986a 100644
--- a/fs/squashfs/cache.c
+++ b/fs/squashfs/cache.c
@@ -58,7 +58,7 @@
 #include "squashfs.h"

 /*
- * Look-up block in cache, and increment usage count.  If not in cache, read
+ * Look-up block in cache, and increment reference count.  If not in
cache, read
  * and decompress it from disk.
  */
 struct squashfs_cache_entry *squashfs_cache_get(struct super_block *sb,
@@ -177,15 +177,15 @@ out:


 /*
- * Release cache entry, once usage count is zero it can be reused.
+ * Release cache entry, once reference count is zero it can be reused.
  */
 void squashfs_cache_put(struct squashfs_cache_entry *entry)
 {
 	struct squashfs_cache *cache = entry->cache;

 	spin_lock(&cache->lock);
-	entry->refcount--;
-	if (entry->refcount == 0) {
+	ASSERT(entry->refcount);
+	if (!(--entry->refcount)) {
 		cache->unused++;
 		/*
 		 * If there's any processes waiting for a block to become
diff --git a/fs/squashfs/squashfs_fs.h b/fs/squashfs/squashfs_fs.h
index e8e1464..db6cf53 100644
--- a/fs/squashfs/squashfs_fs.h
+++ b/fs/squashfs/squashfs_fs.h
@@ -463,4 +463,14 @@ struct squashfs_xattr_id_table {
 	__le32			unused;
 };

+#ifdef CONFIG_SQUASHFS_DEBUGGER
+#define ASSERT(x)                                                       \
+	if (!(x)) {                                                     \
+		printk(KERN_WARNING "assertion failed %s:%d: %s\n",     \
+			__FILE__, __LINE__, #x);                         \
+	}
+#else
+#define ASSERT(x) do { } while (0)
+#endif
+
 #endif
-- 
1.6.0.3
