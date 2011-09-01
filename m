Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932227Ab1IAMtR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Sep 2011 08:49:17 -0400
Received: from mail09.linbit.com ([212.69.161.110]:55653 "EHLO
	mail09.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757370Ab1IAMtI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Sep 2011 08:49:08 -0400
From: Philipp Reisner <philipp.reisner@linbit.com>
To: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: drbd-dev@lists.linbit.com
Subject: [PATCH 03/18] drbd: add page pool to be used for meta data IO
Date: Thu,  1 Sep 2011 14:48:50 +0200
Message-Id: <1314881345-6420-4-git-send-email-philipp.reisner@linbit.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1314881345-6420-1-git-send-email-philipp.reisner@linbit.com>
References: <1314881345-6420-1-git-send-email-philipp.reisner@linbit.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Lars Ellenberg <lars.ellenberg@linbit.com>

Signed-off-by: Philipp Reisner <philipp.reisner@linbit.com>
Signed-off-by: Lars Ellenberg <lars.ellenberg@linbit.com>
---
 drivers/block/drbd/drbd_int.h  |   23 ++++++++++++++++++++++-
 drivers/block/drbd/drbd_main.c |    9 +++++++++
 2 files changed, 31 insertions(+), 1 deletions(-)

diff --git a/drivers/block/drbd/drbd_int.h b/drivers/block/drbd/drbd_int.h
index e3f542c..4debab7 100644
--- a/drivers/block/drbd/drbd_int.h
+++ b/drivers/block/drbd/drbd_int.h
@@ -1463,11 +1463,32 @@ extern struct kmem_cache *drbd_al_ext_cache;	/* activity log extents */
 extern mempool_t *drbd_request_mempool;
 extern mempool_t *drbd_ee_mempool;
 
-extern struct page *drbd_pp_pool; /* drbd's page pool */
+/* drbd's page pool, used to buffer data received from the peer,
+ * or data requested by the peer.
+ *
+ * This does not have an emergency reserve.
+ *
+ * When allocating from this pool, it first takes pages from the pool.
+ * Only if the pool is depleted will try to allocate from the system.
+ *
+ * The assumption is that pages taken from this pool will be processed,
+ * and given back, "quickly", and then can be recycled, so we can avoid
+ * frequent calls to alloc_page(), and still will be able to make progress even
+ * under memory pressure.
+ */
+extern struct page *drbd_pp_pool;
 extern spinlock_t   drbd_pp_lock;
 extern int	    drbd_pp_vacant;
 extern wait_queue_head_t drbd_pp_wait;
 
+/* We also need a standard (emergency-reserve backed) page pool
+ * for meta data IO (activity log, bitmap).
+ * We can keep it global, as long as it is used as "N pages at a time".
+ * 128 should be plenty, currently we probably can get away with as few as 1.
+ */
+#define DRBD_MIN_POOL_PAGES	128
+extern mempool_t *drbd_md_io_page_pool;
+
 extern rwlock_t global_state_lock;
 
 extern int conn_lowest_minor(struct drbd_tconn *tconn);
diff --git a/drivers/block/drbd/drbd_main.c b/drivers/block/drbd/drbd_main.c
index 6d761cb..cb1636c 100644
--- a/drivers/block/drbd/drbd_main.c
+++ b/drivers/block/drbd/drbd_main.c
@@ -129,6 +129,7 @@ struct kmem_cache *drbd_bm_ext_cache;	/* bitmap extents */
 struct kmem_cache *drbd_al_ext_cache;	/* activity log extents */
 mempool_t *drbd_request_mempool;
 mempool_t *drbd_ee_mempool;
+mempool_t *drbd_md_io_page_pool;
 
 /* I do not use a standard mempool, because:
    1) I want to hand out the pre-allocated objects first.
@@ -1952,6 +1953,8 @@ static void drbd_destroy_mempools(void)
 
 	/* D_ASSERT(atomic_read(&drbd_pp_vacant)==0); */
 
+	if (drbd_md_io_page_pool)
+		mempool_destroy(drbd_md_io_page_pool);
 	if (drbd_ee_mempool)
 		mempool_destroy(drbd_ee_mempool);
 	if (drbd_request_mempool)
@@ -1965,6 +1968,7 @@ static void drbd_destroy_mempools(void)
 	if (drbd_al_ext_cache)
 		kmem_cache_destroy(drbd_al_ext_cache);
 
+	drbd_md_io_page_pool = NULL;
 	drbd_ee_mempool      = NULL;
 	drbd_request_mempool = NULL;
 	drbd_ee_cache        = NULL;
@@ -1988,6 +1992,7 @@ static int drbd_create_mempools(void)
 	drbd_bm_ext_cache    = NULL;
 	drbd_al_ext_cache    = NULL;
 	drbd_pp_pool         = NULL;
+	drbd_md_io_page_pool = NULL;
 
 	/* caches */
 	drbd_request_cache = kmem_cache_create(
@@ -2011,6 +2016,10 @@ static int drbd_create_mempools(void)
 		goto Enomem;
 
 	/* mempools */
+	drbd_md_io_page_pool = mempool_create_page_pool(DRBD_MIN_POOL_PAGES, 0);
+	if (drbd_md_io_page_pool == NULL)
+		goto Enomem;
+
 	drbd_request_mempool = mempool_create(number,
 		mempool_alloc_slab, mempool_free_slab, drbd_request_cache);
 	if (drbd_request_mempool == NULL)
-- 
1.7.4.1

