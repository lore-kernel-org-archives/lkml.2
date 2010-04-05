Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755817Ab0DEReU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Apr 2010 13:34:20 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:34527 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755240Ab0DEReN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Apr 2010 13:34:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:subject:message-id:mail-followup-to:mime-version
         :content-type:content-disposition:x-operating-system:user-agent;
        b=K1SUbZZBlLGd/racWcwiKm1vhsd2p4CyZjo/ad2udJoFKjMocQVk8f4n/HsfIZL018
         Gh4O6ISMB2nrVvP5vGR5K00HFJGilue3zoqkhA2nEd0cZGR/P/lNXH8+M6J8elXJ9gur
         88RRiSitkkEwIR7hSMCDG3LTEIlVNtz/hAUnY=
Date: Tue, 6 Apr 2010 01:34:02 +0800
From: Li Hong <lihong.hi@gmail.com>
To: KONISHI Ryusuke <konishi.ryusuke@lab.ntt.co.jp>,
       linux-nilfs@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] nilfs2: cleanup multi kmem_cache_{create,destroy} code
Message-ID: <20100405173402.GA22644@xhl>
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

Hi KONISHI Ryusuke,

The following two patches are base on the tip of your nilfs2/for-next branch.
A build and simple mount test has been passed.

Thanks,
Li Hong

>From 834d30bc730aab19f48474ad77733ef450e96e62 Mon Sep 17 00:00:00 2001
From: Li Hong <lihong.hi@gmail.com>
Date: Tue, 6 Apr 2010 00:54:11 +0800
Subject: [PATCH] nilfs2: cleanup multi kmem_cache_{create,destroy} code

This cleanup patch gives several improvements:

 - Moving all kmem_cache_{create_destroy} calls into one place, which removes
 some small function calls, cleans up error check code and clarify the logic.

 - Mark all initial code in __init section.

 - Remove some very obvious comments.

 - Adjust some declarations.

 - Fix some space-tab issues.

Signed-off-by: Li Hong <lihong.hi@gmail.com>
---
 fs/nilfs2/btree.c   |   40 ----------------
 fs/nilfs2/btree.h   |   23 ++++++++-
 fs/nilfs2/segbuf.c  |   25 ----------
 fs/nilfs2/segbuf.h  |    1 +
 fs/nilfs2/segment.c |   36 --------------
 fs/nilfs2/segment.h |    2 +
 fs/nilfs2/super.c   |  128 ++++++++++++++++++++++++++------------------------
 7 files changed, 90 insertions(+), 165 deletions(-)

diff --git a/fs/nilfs2/btree.c b/fs/nilfs2/btree.c
index dcd4e1c..b27a342 100644
--- a/fs/nilfs2/btree.c
+++ b/fs/nilfs2/btree.c
@@ -31,46 +31,6 @@
 #include "alloc.h"
 #include "dat.h"
 
-/**
- * struct nilfs_btree_path - A path on which B-tree operations are executed
- * @bp_bh: buffer head of node block
- * @bp_sib_bh: buffer head of sibling node block
- * @bp_index: index of child node
- * @bp_oldreq: ptr end request for old ptr
- * @bp_newreq: ptr alloc request for new ptr
- * @bp_op: rebalance operation
- */
-struct nilfs_btree_path {
-	struct buffer_head *bp_bh;
-	struct buffer_head *bp_sib_bh;
-	int bp_index;
-	union nilfs_bmap_ptr_req bp_oldreq;
-	union nilfs_bmap_ptr_req bp_newreq;
-	struct nilfs_btnode_chkey_ctxt bp_ctxt;
-	void (*bp_op)(struct nilfs_btree *, struct nilfs_btree_path *,
-		      int, __u64 *, __u64 *);
-};
-
-/*
- * B-tree path operations
- */
-
-static struct kmem_cache *nilfs_btree_path_cache;
-
-int __init nilfs_btree_path_cache_init(void)
-{
-	nilfs_btree_path_cache =
-		kmem_cache_create("nilfs2_btree_path_cache",
-				  sizeof(struct nilfs_btree_path) *
-				  NILFS_BTREE_LEVEL_MAX, 0, 0, NULL);
-	return (nilfs_btree_path_cache != NULL) ? 0 : -ENOMEM;
-}
-
-void nilfs_btree_path_cache_destroy(void)
-{
-	kmem_cache_destroy(nilfs_btree_path_cache);
-}
-
 static struct nilfs_btree_path *nilfs_btree_alloc_path(void)
 {
 	struct nilfs_btree_path *path;
diff --git a/fs/nilfs2/btree.h b/fs/nilfs2/btree.h
index 4b82d84..af638d5 100644
--- a/fs/nilfs2/btree.h
+++ b/fs/nilfs2/btree.h
@@ -30,9 +30,6 @@
 #include "btnode.h"
 #include "bmap.h"
 
-struct nilfs_btree;
-struct nilfs_btree_path;
-
 /**
  * struct nilfs_btree - B-tree structure
  * @bt_bmap: bmap base structure
@@ -41,6 +38,25 @@ struct nilfs_btree {
 	struct nilfs_bmap bt_bmap;
 };
 
+/**
+ * struct nilfs_btree_path - A path on which B-tree operations are executed
+ * @bp_bh: buffer head of node block
+ * @bp_sib_bh: buffer head of sibling node block
+ * @bp_index: index of child node
+ * @bp_oldreq: ptr end request for old ptr
+ * @bp_newreq: ptr alloc request for new ptr
+ * @bp_op: rebalance operation
+ */
+struct nilfs_btree_path {
+	struct buffer_head *bp_bh;
+	struct buffer_head *bp_sib_bh;
+	int bp_index;
+	union nilfs_bmap_ptr_req bp_oldreq;
+	union nilfs_bmap_ptr_req bp_newreq;
+	struct nilfs_btnode_chkey_ctxt bp_ctxt;
+	void (*bp_op)(struct nilfs_btree *, struct nilfs_btree_path *,
+		      int, __u64 *, __u64 *);
+};
 
 #define NILFS_BTREE_ROOT_SIZE		NILFS_BMAP_SIZE
 #define NILFS_BTREE_ROOT_NCHILDREN_MAX					\
@@ -57,6 +73,7 @@ struct nilfs_btree {
 #define NILFS_BTREE_KEY_MIN	((__u64)0)
 #define NILFS_BTREE_KEY_MAX	(~(__u64)0)
 
+extern struct kmem_cache *nilfs_btree_path_cache;
 
 int nilfs_btree_path_cache_init(void);
 void nilfs_btree_path_cache_destroy(void);
diff --git a/fs/nilfs2/segbuf.c b/fs/nilfs2/segbuf.c
index 6129a43..4a4b433 100644
--- a/fs/nilfs2/segbuf.c
+++ b/fs/nilfs2/segbuf.c
@@ -39,35 +39,10 @@ struct nilfs_write_info {
 	sector_t		blocknr;
 };
 
-
 static int nilfs_segbuf_write(struct nilfs_segment_buffer *segbuf,
 			      struct the_nilfs *nilfs);
 static int nilfs_segbuf_wait(struct nilfs_segment_buffer *segbuf);
 
-
-static struct kmem_cache *nilfs_segbuf_cachep;
-
-static void nilfs_segbuf_init_once(void *obj)
-{
-	memset(obj, 0, sizeof(struct nilfs_segment_buffer));
-}
-
-int __init nilfs_init_segbuf_cache(void)
-{
-	nilfs_segbuf_cachep =
-		kmem_cache_create("nilfs2_segbuf_cache",
-				  sizeof(struct nilfs_segment_buffer),
-				  0, SLAB_RECLAIM_ACCOUNT,
-				  nilfs_segbuf_init_once);
-
-	return (nilfs_segbuf_cachep == NULL) ? -ENOMEM : 0;
-}
-
-void nilfs_destroy_segbuf_cache(void)
-{
-	kmem_cache_destroy(nilfs_segbuf_cachep);
-}
-
 struct nilfs_segment_buffer *nilfs_segbuf_new(struct super_block *sb)
 {
 	struct nilfs_segment_buffer *segbuf;
diff --git a/fs/nilfs2/segbuf.h b/fs/nilfs2/segbuf.h
index 94dfd35..cad9c7c 100644
--- a/fs/nilfs2/segbuf.h
+++ b/fs/nilfs2/segbuf.h
@@ -121,6 +121,7 @@ struct nilfs_segment_buffer {
 		    b_assoc_buffers))
 #define NILFS_SEGBUF_BH_IS_LAST(bh, head)  ((bh)->b_assoc_buffers.next == head)
 
+extern struct kmem_cache *nilfs_segbuf_cachep;
 
 int __init nilfs_init_segbuf_cache(void);
 void nilfs_destroy_segbuf_cache(void);
diff --git a/fs/nilfs2/segment.c b/fs/nilfs2/segment.c
index c161d89..1138713 100644
--- a/fs/nilfs2/segment.c
+++ b/fs/nilfs2/segment.c
@@ -115,42 +115,6 @@ static void nilfs_dispose_list(struct nilfs_sb_info *, struct list_head *,
 #define nilfs_cnt32_lt(a, b)  nilfs_cnt32_gt(b, a)
 #define nilfs_cnt32_le(a, b)  nilfs_cnt32_ge(b, a)
 
-/*
- * Transaction
- */
-static struct kmem_cache *nilfs_transaction_cachep;
-
-/**
- * nilfs_init_transaction_cache - create a cache for nilfs_transaction_info
- *
- * nilfs_init_transaction_cache() creates a slab cache for the struct
- * nilfs_transaction_info.
- *
- * Return Value: On success, it returns 0. On error, one of the following
- * negative error code is returned.
- *
- * %-ENOMEM - Insufficient memory available.
- */
-int nilfs_init_transaction_cache(void)
-{
-	nilfs_transaction_cachep =
-		kmem_cache_create("nilfs2_transaction_cache",
-				  sizeof(struct nilfs_transaction_info),
-				  0, SLAB_RECLAIM_ACCOUNT, NULL);
-	return (nilfs_transaction_cachep == NULL) ? -ENOMEM : 0;
-}
-
-/**
- * nilfs_destroy_transaction_cache - destroy the cache for transaction info
- *
- * nilfs_destroy_transaction_cache() frees the slab cache for the struct
- * nilfs_transaction_info.
- */
-void nilfs_destroy_transaction_cache(void)
-{
-	kmem_cache_destroy(nilfs_transaction_cachep);
-}
-
 static int nilfs_prepare_segment_lock(struct nilfs_transaction_info *ti)
 {
 	struct nilfs_transaction_info *cur_ti = current->journal_info;
diff --git a/fs/nilfs2/segment.h b/fs/nilfs2/segment.h
index 82dfd6a..2de218b 100644
--- a/fs/nilfs2/segment.h
+++ b/fs/nilfs2/segment.h
@@ -219,6 +219,8 @@ enum {
  */
 #define NILFS_SC_DEFAULT_WATERMARK  3600
 
+/* super.c */
+extern struct kmem_cache *nilfs_transaction_cachep;
 
 /* segment.c */
 extern int nilfs_init_transaction_cache(void);
diff --git a/fs/nilfs2/super.c b/fs/nilfs2/super.c
index aa1ad6c..2e767bc 100644
--- a/fs/nilfs2/super.c
+++ b/fs/nilfs2/super.c
@@ -67,6 +67,11 @@ MODULE_DESCRIPTION("A New Implementation of the Log-structured Filesystem "
 		   "(NILFS)");
 MODULE_LICENSE("GPL");
 
+struct kmem_cache *nilfs_inode_cachep;
+struct kmem_cache *nilfs_transaction_cachep;
+struct kmem_cache *nilfs_segbuf_cachep;
+struct kmem_cache *nilfs_btree_path_cache;
+
 static int nilfs_remount(struct super_block *sb, int *flags, char *data);
 
 /**
@@ -129,7 +134,6 @@ void nilfs_warning(struct super_block *sb, const char *function,
 	va_end(args);
 }
 
-static struct kmem_cache *nilfs_inode_cachep;
 
 struct inode *nilfs_alloc_inode_common(struct the_nilfs *nilfs)
 {
@@ -155,34 +159,6 @@ void nilfs_destroy_inode(struct inode *inode)
 	kmem_cache_free(nilfs_inode_cachep, NILFS_I(inode));
 }
 
-static void init_once(void *obj)
-{
-	struct nilfs_inode_info *ii = obj;
-
-	INIT_LIST_HEAD(&ii->i_dirty);
-#ifdef CONFIG_NILFS_XATTR
-	init_rwsem(&ii->xattr_sem);
-#endif
-	nilfs_btnode_cache_init_once(&ii->i_btnode_cache);
-	ii->i_bmap = (struct nilfs_bmap *)&ii->i_bmap_union;
-	inode_init_once(&ii->vfs_inode);
-}
-
-static int nilfs_init_inode_cache(void)
-{
-	nilfs_inode_cachep = kmem_cache_create("nilfs2_inode_cache",
-					       sizeof(struct nilfs_inode_info),
-					       0, SLAB_RECLAIM_ACCOUNT,
-					       init_once);
-
-	return (nilfs_inode_cachep == NULL) ? -ENOMEM : 0;
-}
-
-static inline void nilfs_destroy_inode_cache(void)
-{
-	kmem_cache_destroy(nilfs_inode_cachep);
-}
-
 static void nilfs_clear_inode(struct inode *inode)
 {
 	struct nilfs_inode_info *ii = NILFS_I(inode);
@@ -1138,54 +1114,84 @@ struct file_system_type nilfs_fs_type = {
 	.fs_flags = FS_REQUIRES_DEV,
 };
 
-static int __init init_nilfs_fs(void)
+static void nilfs_inode_init_once(void *obj)
 {
-	int err;
-
-	err = nilfs_init_inode_cache();
-	if (err)
-		goto failed;
+	struct nilfs_inode_info *ii = obj;
 
-	err = nilfs_init_transaction_cache();
-	if (err)
-		goto failed_inode_cache;
+	INIT_LIST_HEAD(&ii->i_dirty);
+#ifdef CONFIG_NILFS_XATTR
+	init_rwsem(&ii->xattr_sem);
+#endif
+	nilfs_btnode_cache_init_once(&ii->i_btnode_cache);
+	ii->i_bmap = (struct nilfs_bmap *)&ii->i_bmap_union;
+	inode_init_once(&ii->vfs_inode);
+}
 
-	err = nilfs_init_segbuf_cache();
-	if (err)
-		goto failed_transaction_cache;
+static void nilfs_segbuf_init_once(void *obj)
+{
+	memset(obj, 0, sizeof(struct nilfs_segment_buffer));
+}
 
-	err = nilfs_btree_path_cache_init();
-	if (err)
-		goto failed_segbuf_cache;
+static void nilfs_destroy_cachep(void)
+{
+	 if (nilfs_inode_cachep)
+		kmem_cache_destroy(nilfs_inode_cachep);
+	 if (nilfs_transaction_cachep)
+		kmem_cache_destroy(nilfs_transaction_cachep);
+	 if (nilfs_segbuf_cachep)
+		kmem_cache_destroy(nilfs_segbuf_cachep);
+	 if (nilfs_btree_path_cache)
+		kmem_cache_destroy(nilfs_btree_path_cache);
+}
 
-	err = register_filesystem(&nilfs_fs_type);
-	if (err)
-		goto failed_btree_path_cache;
+static int __init nilfs_init_cachep(void)
+{
+	nilfs_inode_cachep = kmem_cache_create("nilfs2_inode_cache",
+			sizeof(struct nilfs_inode_info), 0,
+			SLAB_RECLAIM_ACCOUNT, nilfs_inode_init_once);
+	if (!nilfs_inode_cachep)
+		goto fail;
+
+	nilfs_transaction_cachep = kmem_cache_create("nilfs2_transaction_cache",
+			sizeof(struct nilfs_transaction_info), 0,
+			SLAB_RECLAIM_ACCOUNT, NULL);
+	if (!nilfs_transaction_cachep)
+		goto fail;
+
+	nilfs_segbuf_cachep = kmem_cache_create("nilfs2_segbuf_cache",
+			sizeof(struct nilfs_segment_buffer), 0,
+			SLAB_RECLAIM_ACCOUNT, nilfs_segbuf_init_once);
+	if (!nilfs_segbuf_cachep)
+		goto fail;
+
+	nilfs_btree_path_cache = kmem_cache_create("nilfs2_btree_path_cache",
+			sizeof(struct nilfs_btree_path) * NILFS_BTREE_LEVEL_MAX,
+			0, 0, NULL);
+	if (!nilfs_btree_path_cache)
+		goto fail;
 
 	return 0;
 
- failed_btree_path_cache:
-	nilfs_btree_path_cache_destroy();
-
- failed_segbuf_cache:
-	nilfs_destroy_segbuf_cache();
+fail:
+	nilfs_destroy_cachep();
+	return -ENOMEM;
+}
 
- failed_transaction_cache:
-	nilfs_destroy_transaction_cache();
+static int __init init_nilfs_fs(void)
+{
+	int err;
 
- failed_inode_cache:
-	nilfs_destroy_inode_cache();
+	err = nilfs_init_cachep();
+	if (err)
+		return err;
 
- failed:
+	err = register_filesystem(&nilfs_fs_type);
 	return err;
 }
 
 static void __exit exit_nilfs_fs(void)
 {
-	nilfs_destroy_segbuf_cache();
-	nilfs_destroy_transaction_cache();
-	nilfs_destroy_inode_cache();
-	nilfs_btree_path_cache_destroy();
+	nilfs_destroy_cachep();
 	unregister_filesystem(&nilfs_fs_type);
 }
 
-- 
1.6.3.3

