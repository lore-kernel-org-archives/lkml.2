Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758679Ab0DBKmT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Apr 2010 06:42:19 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:37172 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752841Ab0DBKmN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Apr 2010 06:42:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:mime-version
         :content-type:content-disposition:x-operating-system:user-agent;
        b=M2iEHgVx09g0UVTVUBd5FgWHEZjTpnWZN+Gi4VXcKgGlWsMlmqCvTImaoAQkBaml8W
         FOxhOW+9wpLgmnqdOYAiBe8/0tDn8uW4ZWk0+YKwdXffhSMOzORDUZFParPpiLZsRSGv
         ZuZZwzg9H3RdEkXjYu1YhvIIHLhRL1FsOxvUc=
Date: Fri, 2 Apr 2010 18:42:06 +0800
From: Li Hong <lihong.hi@gmail.com>
To: KONISHI Ryusuke <konishi.ryusuke@lab.ntt.co.jp>,
       linux-nilfs@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] nilfs2: Combine nilfs_btree_alloc_path() and
 nilfs_btree_init_path()
Message-ID: <20100402104206.GB9652@xhl>
Mail-Followup-To: KONISHI Ryusuke <konishi.ryusuke@lab.ntt.co.jp>,
	linux-nilfs@vger.kernel.org, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Operating-System: Linux xhl 2.6.31-14-generic
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

nilfs_btree_alloc_path() and nilfs_btree_init_path() are bound into each other
tightly. Make them into one procedure to clearify the logic and avoid some
misusages.

Signed-off-by: Li Hong <lihong.hi@gmail.com>
---
 fs/nilfs2/btree.c |   39 +++++++++++++++++----------------------
 1 files changed, 17 insertions(+), 22 deletions(-)

diff --git a/fs/nilfs2/btree.c b/fs/nilfs2/btree.c
index 76c38e3..bb31ab3 100644
--- a/fs/nilfs2/btree.c
+++ b/fs/nilfs2/btree.c
@@ -71,23 +71,16 @@ void nilfs_btree_path_cache_destroy(void)
 	kmem_cache_destroy(nilfs_btree_path_cache);
 }
 
-static inline struct nilfs_btree_path *nilfs_btree_alloc_path(void)
+static struct nilfs_btree_path *nilfs_btree_alloc_path(void)
 {
-	return kmem_cache_alloc(nilfs_btree_path_cache, GFP_NOFS);
-}
-
-static inline void nilfs_btree_free_path(struct nilfs_btree_path *path)
-{
-	kmem_cache_free(nilfs_btree_path_cache, path);
-}
+	struct nilfs_btree_path *path;
+	int level = NILFS_BTREE_LEVEL_DATA;
 
-static void nilfs_btree_init_path(struct nilfs_btree_path *path)
-{
-	int level;
+        path = kmem_cache_alloc(nilfs_btree_path_cache, GFP_NOFS);
+	if (path == NULL)
+		goto out;
 
-	for (level = NILFS_BTREE_LEVEL_DATA;
-	     level < NILFS_BTREE_LEVEL_MAX;
-	     level++) {
+	for (; level < NILFS_BTREE_LEVEL_MAX; level++) {
 		path[level].bp_bh = NULL;
 		path[level].bp_sib_bh = NULL;
 		path[level].bp_index = 0;
@@ -95,6 +88,14 @@ static void nilfs_btree_init_path(struct nilfs_btree_path *path)
 		path[level].bp_newreq.bpr_ptr = NILFS_BMAP_INVALID_PTR;
 		path[level].bp_op = NULL;
 	}
+
+out:
+	return path;
+}
+
+static inline void nilfs_btree_free_path(struct nilfs_btree_path *path)
+{
+	kmem_cache_free(nilfs_btree_path_cache, path);
 }
 
 static void nilfs_btree_release_path(struct nilfs_btree_path *path)
@@ -566,7 +567,6 @@ static int nilfs_btree_lookup(const struct nilfs_bmap *bmap,
 	path = nilfs_btree_alloc_path();
 	if (path == NULL)
 		return -ENOMEM;
-	nilfs_btree_init_path(path);
 
 	ret = nilfs_btree_do_lookup(btree, path, key, &ptr, level);
 
@@ -594,7 +594,7 @@ static int nilfs_btree_lookup_contig(const struct nilfs_bmap *bmap,
 	path = nilfs_btree_alloc_path();
 	if (path == NULL)
 		return -ENOMEM;
-	nilfs_btree_init_path(path);
+
 	ret = nilfs_btree_do_lookup(btree, path, key, &ptr, level);
 	if (ret < 0)
 		goto out;
@@ -1123,7 +1123,6 @@ static int nilfs_btree_insert(struct nilfs_bmap *bmap, __u64 key, __u64 ptr)
 	path = nilfs_btree_alloc_path();
 	if (path == NULL)
 		return -ENOMEM;
-	nilfs_btree_init_path(path);
 
 	ret = nilfs_btree_do_lookup(btree, path, key, NULL,
 				    NILFS_BTREE_LEVEL_NODE_MIN);
@@ -1456,7 +1455,7 @@ static int nilfs_btree_delete(struct nilfs_bmap *bmap, __u64 key)
 	path = nilfs_btree_alloc_path();
 	if (path == NULL)
 		return -ENOMEM;
-	nilfs_btree_init_path(path);
+
 	ret = nilfs_btree_do_lookup(btree, path, key, NULL,
 				    NILFS_BTREE_LEVEL_NODE_MIN);
 	if (ret < 0)
@@ -1488,7 +1487,6 @@ static int nilfs_btree_last_key(const struct nilfs_bmap *bmap, __u64 *keyp)
 	path = nilfs_btree_alloc_path();
 	if (path == NULL)
 		return -ENOMEM;
-	nilfs_btree_init_path(path);
 
 	ret = nilfs_btree_do_lookup_last(btree, path, keyp, NULL);
 
@@ -1923,7 +1921,6 @@ static int nilfs_btree_propagate(const struct nilfs_bmap *bmap,
 	path = nilfs_btree_alloc_path();
 	if (path == NULL)
 		return -ENOMEM;
-	nilfs_btree_init_path(path);
 
 	if (buffer_nilfs_node(bh)) {
 		node = (struct nilfs_btree_node *)bh->b_data;
@@ -2108,7 +2105,6 @@ static int nilfs_btree_assign(struct nilfs_bmap *bmap,
 	path = nilfs_btree_alloc_path();
 	if (path == NULL)
 		return -ENOMEM;
-	nilfs_btree_init_path(path);
 
 	if (buffer_nilfs_node(*bh)) {
 		node = (struct nilfs_btree_node *)(*bh)->b_data;
@@ -2175,7 +2171,6 @@ static int nilfs_btree_mark(struct nilfs_bmap *bmap, __u64 key, int level)
 	path = nilfs_btree_alloc_path();
 	if (path == NULL)
 		return -ENOMEM;
-	nilfs_btree_init_path(path);
 
 	ret = nilfs_btree_do_lookup(btree, path, key, &ptr, level + 1);
 	if (ret < 0) {
-- 
1.6.3.3

