Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755215Ab2CSKt6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2012 06:49:58 -0400
Received: from mx1.redhat.com ([209.132.183.28]:36547 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030291Ab2CSKt4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2012 06:49:56 -0400
From: Steven Whitehouse <swhiteho@redhat.com>
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 10/12] GFS2: Remove a __GFP_NOFAIL allocation
Date: Mon, 19 Mar 2012 10:25:26 +0000
Message-Id: <1332152728-4027-11-git-send-email-swhiteho@redhat.com>
In-Reply-To: <1332152728-4027-1-git-send-email-swhiteho@redhat.com>
References: <1332152728-4027-1-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In order to ensure that we've got enough buffer heads for flushing
the journal, the orignal code used __GFP_NOFAIL when performing
this allocation. Here we dispense with that in favour of using a
mempool. This should improve efficiency in low memory conditions
since flushing the journal is a good way to get memory back, we
don't want to be spinning, waiting on memory allocations. The
buffers which are allocated via this mempool are fairly short lived,
so that we'll recycle them pretty quickly.

Although there are other memory allocations which occur during the
journal flush process, this is the one which can potentially require
the most memory, so the most important one to fix.

The amount of memory reserved is a fixed amount, and we should not need
to scale it when there are a greater number of filesystems in use.

Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/lops.c b/fs/gfs2/lops.c
index fe369bd..87e6e0d 100644
--- a/fs/gfs2/lops.c
+++ b/fs/gfs2/lops.c
@@ -12,6 +12,7 @@
 #include <linux/spinlock.h>
 #include <linux/completion.h>
 #include <linux/buffer_head.h>
+#include <linux/mempool.h>
 #include <linux/gfs2_ondisk.h>
 #include <linux/bio.h>
 #include <linux/fs.h>
@@ -199,7 +200,7 @@ static void gfs2_fake_write_endio(struct buffer_head *bh, int uptodate)
 	struct gfs2_sbd *sdp = bd->bd_gl->gl_sbd;
 
 	end_buffer_write_sync(bh, uptodate);
-	free_buffer_head(bh);
+	mempool_free(bh, gfs2_bh_pool);
 	unlock_buffer(real_bh);
 	brelse(real_bh);
 	if (atomic_dec_and_test(&sdp->sd_log_in_flight))
@@ -220,7 +221,7 @@ static struct buffer_head *gfs2_log_fake_buf(struct gfs2_sbd *sdp,
 	u64 blkno = gfs2_log_bmap(sdp, sdp->sd_log_flush_head);
 	struct buffer_head *bh;
 
-	bh = alloc_buffer_head(GFP_NOFS | __GFP_NOFAIL);
+	bh = mempool_alloc(gfs2_bh_pool, GFP_NOFS);
 	atomic_set(&bh->b_count, 1);
 	bh->b_state = (1 << BH_Mapped) | (1 << BH_Uptodate) | (1 << BH_Lock);
 	set_bh_page(bh, real->b_page, bh_offset(real));
diff --git a/fs/gfs2/main.c b/fs/gfs2/main.c
index a8d9bcd..754426b 100644
--- a/fs/gfs2/main.c
+++ b/fs/gfs2/main.c
@@ -17,6 +17,7 @@
 #include <linux/rcupdate.h>
 #include <linux/rculist_bl.h>
 #include <linux/atomic.h>
+#include <linux/mempool.h>
 
 #include "gfs2.h"
 #include "incore.h"
@@ -69,6 +70,16 @@ static void gfs2_init_gl_aspace_once(void *foo)
 	address_space_init_once(mapping);
 }
 
+static void *gfs2_bh_alloc(gfp_t mask, void *data)
+{
+	return alloc_buffer_head(mask);
+}
+
+static void gfs2_bh_free(void *ptr, void *data)
+{
+	return free_buffer_head(ptr);
+}
+
 /**
  * init_gfs2_fs - Register GFS2 as a filesystem
  *
@@ -151,6 +162,10 @@ static int __init init_gfs2_fs(void)
 	gfs2_control_wq = alloc_workqueue("gfs2_control",
 			       WQ_NON_REENTRANT | WQ_UNBOUND | WQ_FREEZABLE, 0);
 	if (!gfs2_control_wq)
+		goto fail_recovery;
+
+	gfs2_bh_pool = mempool_create(1024, gfs2_bh_alloc, gfs2_bh_free, NULL);
+	if (!gfs2_bh_pool)
 		goto fail_control;
 
 	gfs2_register_debugfs();
@@ -160,6 +175,8 @@ static int __init init_gfs2_fs(void)
 	return 0;
 
 fail_control:
+	destroy_workqueue(gfs2_control_wq);
+fail_recovery:
 	destroy_workqueue(gfs_recovery_wq);
 fail_wq:
 	unregister_filesystem(&gfs2meta_fs_type);
@@ -208,6 +225,7 @@ static void __exit exit_gfs2_fs(void)
 
 	rcu_barrier();
 
+	mempool_destroy(gfs2_bh_pool);
 	kmem_cache_destroy(gfs2_quotad_cachep);
 	kmem_cache_destroy(gfs2_rgrpd_cachep);
 	kmem_cache_destroy(gfs2_bufdata_cachep);
diff --git a/fs/gfs2/util.c b/fs/gfs2/util.c
index 5351129..9e7765e 100644
--- a/fs/gfs2/util.c
+++ b/fs/gfs2/util.c
@@ -25,6 +25,7 @@ struct kmem_cache *gfs2_inode_cachep __read_mostly;
 struct kmem_cache *gfs2_bufdata_cachep __read_mostly;
 struct kmem_cache *gfs2_rgrpd_cachep __read_mostly;
 struct kmem_cache *gfs2_quotad_cachep __read_mostly;
+mempool_t *gfs2_bh_pool __read_mostly;
 
 void gfs2_assert_i(struct gfs2_sbd *sdp)
 {
diff --git a/fs/gfs2/util.h b/fs/gfs2/util.h
index b432e04..a4ce76c 100644
--- a/fs/gfs2/util.h
+++ b/fs/gfs2/util.h
@@ -10,6 +10,8 @@
 #ifndef __UTIL_DOT_H__
 #define __UTIL_DOT_H__
 
+#include <linux/mempool.h>
+
 #include "incore.h"
 
 #define fs_printk(level, fs, fmt, arg...) \
@@ -150,6 +152,7 @@ extern struct kmem_cache *gfs2_inode_cachep;
 extern struct kmem_cache *gfs2_bufdata_cachep;
 extern struct kmem_cache *gfs2_rgrpd_cachep;
 extern struct kmem_cache *gfs2_quotad_cachep;
+extern mempool_t *gfs2_bh_pool;
 
 static inline unsigned int gfs2_tune_get_i(struct gfs2_tune *gt,
 					   unsigned int *p)
-- 
1.7.4

