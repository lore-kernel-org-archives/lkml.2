Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757468Ab1K3CO7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Nov 2011 21:14:59 -0500
Received: from perches-mx.perches.com ([206.117.179.246]:58739 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756637Ab1K3CO4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Nov 2011 21:14:56 -0500
From: Joe Perches <joe@perches.com>
To: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 02/28] mbcache: Use current logging styles
Date: Tue, 29 Nov 2011 18:14:00 -0800
Message-Id: <411ed863916031511d8c2ce5150f06be141b2a8c.1322609672.git.joe@perches.com>
X-Mailer: git-send-email 1.7.6.405.gc1be0
In-Reply-To: <cover.1322609672.git.joe@perches.com>
References: <cover.1322609672.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Convert mb_<level> uses to current logging styles.
Add newlines to uses, remove from #define to consolidate
output and avoid possible message interleaving.
Add #define pr_fmt.
Align arguments.
Neaten macro defines.

Signed-off-by: Joe Perches <joe@perches.com>
---
 fs/mbcache.c |   40 ++++++++++++++++++++--------------------
 1 files changed, 20 insertions(+), 20 deletions(-)

diff --git a/fs/mbcache.c b/fs/mbcache.c
index 8c32ef3..a3c533c 100644
--- a/fs/mbcache.c
+++ b/fs/mbcache.c
@@ -26,6 +26,8 @@
  * back on the lru list.
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/kernel.h>
 #include <linux/module.h>
 
@@ -37,23 +39,22 @@
 #include <linux/init.h>
 #include <linux/mbcache.h>
 
-
 #ifdef MB_CACHE_DEBUG
-# define mb_debug(f...) do { \
-		printk(KERN_DEBUG f); \
-		printk("\n"); \
-	} while (0)
-#define mb_assert(c) do { if (!(c)) \
-		printk(KERN_ERR "assertion " #c " failed\n"); \
-	} while(0)
+# define mb_debug(fmt, ...)				\
+	pr_debug(fmt, ##__VA_ARGS__)
+# define mb_assert(c)					\
+do {							\
+	if (!(c))					\
+		pr_err("assertion " #c " failed\n");	\
+} while (0)
 #else
-# define mb_debug(f...) do { } while(0)
-# define mb_assert(c) do { } while(0)
+# define mb_debug(fmt, ...)				\
+	no_printk(fmt, ##__VA_ARGS__)
+# define mb_assert(c)					\
+	do { } while (0)
 #endif
-#define mb_error(f...) do { \
-		printk(KERN_ERR f); \
-		printk("\n"); \
-	} while(0)
+#define mb_err(fmt, ...)				\
+	pr_err(fmt, ##__VA_ARGS__)
 
 #define MB_CACHE_WRITER ((unsigned short)~0U >> 1)
 
@@ -171,7 +172,7 @@ mb_cache_shrink_fn(struct shrinker *shrink, struct shrink_control *sc)
 	int nr_to_scan = sc->nr_to_scan;
 	gfp_t gfp_mask = sc->gfp_mask;
 
-	mb_debug("trying to free %d entries", nr_to_scan);
+	mb_debug("trying to free %d entries\n", nr_to_scan);
 	spin_lock(&mb_cache_spinlock);
 	while (nr_to_scan-- && !list_empty(&mb_cache_lru_list)) {
 		struct mb_cache_entry *ce =
@@ -181,8 +182,8 @@ mb_cache_shrink_fn(struct shrinker *shrink, struct shrink_control *sc)
 		__mb_cache_entry_unhash(ce);
 	}
 	list_for_each_entry(cache, &mb_cache_list, c_cache_list) {
-		mb_debug("cache %s (%d)", cache->c_name,
-			  atomic_read(&cache->c_entry_count));
+		mb_debug("cache %s (%d)\n",
+			 cache->c_name, atomic_read(&cache->c_entry_count));
 		count += atomic_read(&cache->c_entry_count);
 	}
 	spin_unlock(&mb_cache_spinlock);
@@ -318,9 +319,8 @@ mb_cache_destroy(struct mb_cache *cache)
 	}
 
 	if (atomic_read(&cache->c_entry_count) > 0) {
-		mb_error("cache %s: %d orphaned entries",
-			  cache->c_name,
-			  atomic_read(&cache->c_entry_count));
+		mb_err("cache %s: %d orphaned entries\n",
+		       cache->c_name, atomic_read(&cache->c_entry_count));
 	}
 
 	kmem_cache_destroy(cache->c_entry_cache);
-- 
1.7.6.405.gc1be0

