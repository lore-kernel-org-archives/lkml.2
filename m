Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761906Ab2EQMxd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2012 08:53:33 -0400
Received: from mx1.redhat.com ([209.132.183.28]:23344 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761734Ab2EQMsc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2012 08:48:32 -0400
From: Steven Whitehouse <swhiteho@redhat.com>
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: Bob Peterson <rpeterso@redhat.com>,
        Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 05/24] GFS2: Use slab for block reservation memory
Date: Thu, 17 May 2012 13:23:12 +0100
Message-Id: <1337257411-3173-6-git-send-email-swhiteho@redhat.com>
In-Reply-To: <1337257411-3173-1-git-send-email-swhiteho@redhat.com>
References: <1337257411-3173-1-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bob Peterson <rpeterso@redhat.com>

This patch changes block reservations so it uses slab storage.

Signed-off-by: Bob Peterson <rpeterso@redhat.com>
Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/main.c b/fs/gfs2/main.c
index 754426b..ce17944 100644
--- a/fs/gfs2/main.c
+++ b/fs/gfs2/main.c
@@ -143,6 +143,12 @@ static int __init init_gfs2_fs(void)
 	if (!gfs2_quotad_cachep)
 		goto fail;
 
+	gfs2_rsrv_cachep = kmem_cache_create("gfs2_mblk",
+					     sizeof(struct gfs2_blkreserv),
+					       0, 0, NULL);
+	if (!gfs2_rsrv_cachep)
+		goto fail;
+
 	register_shrinker(&qd_shrinker);
 
 	error = register_filesystem(&gfs2_fs_type);
@@ -186,6 +192,9 @@ fail:
 	unregister_shrinker(&qd_shrinker);
 	gfs2_glock_exit();
 
+	if (gfs2_rsrv_cachep)
+		kmem_cache_destroy(gfs2_rsrv_cachep);
+
 	if (gfs2_quotad_cachep)
 		kmem_cache_destroy(gfs2_quotad_cachep);
 
@@ -226,6 +235,7 @@ static void __exit exit_gfs2_fs(void)
 	rcu_barrier();
 
 	mempool_destroy(gfs2_bh_pool);
+	kmem_cache_destroy(gfs2_rsrv_cachep);
 	kmem_cache_destroy(gfs2_quotad_cachep);
 	kmem_cache_destroy(gfs2_rgrpd_cachep);
 	kmem_cache_destroy(gfs2_bufdata_cachep);
diff --git a/fs/gfs2/rgrp.c b/fs/gfs2/rgrp.c
index 3df65c9..69fa32f 100644
--- a/fs/gfs2/rgrp.c
+++ b/fs/gfs2/rgrp.c
@@ -1002,11 +1002,13 @@ struct gfs2_qadata *gfs2_qadata_get(struct gfs2_inode *ip)
  * Returns: the struct gfs2_qadata
  */
 
-static struct gfs2_blkreserv *gfs2_blkrsv_get(struct gfs2_inode *ip)
+static int gfs2_blkrsv_get(struct gfs2_inode *ip)
 {
 	BUG_ON(ip->i_res != NULL);
-	ip->i_res = kzalloc(sizeof(struct gfs2_blkreserv), GFP_NOFS);
-	return ip->i_res;
+	ip->i_res = kmem_cache_zalloc(gfs2_rsrv_cachep, GFP_NOFS);
+	if (!ip->i_res)
+		return -ENOMEM;
+	return 0;
 }
 
 /**
@@ -1164,7 +1166,7 @@ static int get_local_rgrp(struct gfs2_inode *ip, u64 *last_unlinked)
 static void gfs2_blkrsv_put(struct gfs2_inode *ip)
 {
 	BUG_ON(ip->i_res == NULL);
-	kfree(ip->i_res);
+	kmem_cache_free(gfs2_rsrv_cachep, ip->i_res);
 	ip->i_res = NULL;
 }
 
@@ -1179,14 +1181,15 @@ int gfs2_inplace_reserve(struct gfs2_inode *ip, u32 requested)
 {
 	struct gfs2_sbd *sdp = GFS2_SB(&ip->i_inode);
 	struct gfs2_blkreserv *rs;
-	int error = 0;
+	int error;
 	u64 last_unlinked = NO_BLOCK;
 	int tries = 0;
 
-	rs = gfs2_blkrsv_get(ip);
-	if (!rs)
-		return -ENOMEM;
+	error = gfs2_blkrsv_get(ip);
+	if (error)
+		return error;
 
+	rs = ip->i_res;
 	rs->rs_requested = requested;
 	if (gfs2_assert_warn(sdp, requested)) {
 		error = -EINVAL;
diff --git a/fs/gfs2/util.c b/fs/gfs2/util.c
index 9e7765e..3afc6ac 100644
--- a/fs/gfs2/util.c
+++ b/fs/gfs2/util.c
@@ -25,6 +25,7 @@ struct kmem_cache *gfs2_inode_cachep __read_mostly;
 struct kmem_cache *gfs2_bufdata_cachep __read_mostly;
 struct kmem_cache *gfs2_rgrpd_cachep __read_mostly;
 struct kmem_cache *gfs2_quotad_cachep __read_mostly;
+struct kmem_cache *gfs2_rsrv_cachep __read_mostly;
 mempool_t *gfs2_bh_pool __read_mostly;
 
 void gfs2_assert_i(struct gfs2_sbd *sdp)
diff --git a/fs/gfs2/util.h b/fs/gfs2/util.h
index a4ce76c..8fbe6cf 100644
--- a/fs/gfs2/util.h
+++ b/fs/gfs2/util.h
@@ -152,6 +152,7 @@ extern struct kmem_cache *gfs2_inode_cachep;
 extern struct kmem_cache *gfs2_bufdata_cachep;
 extern struct kmem_cache *gfs2_rgrpd_cachep;
 extern struct kmem_cache *gfs2_quotad_cachep;
+extern struct kmem_cache *gfs2_rsrv_cachep;
 extern mempool_t *gfs2_bh_pool;
 
 static inline unsigned int gfs2_tune_get_i(struct gfs2_tune *gt,
-- 
1.7.4

