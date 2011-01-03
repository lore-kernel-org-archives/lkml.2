Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755490Ab1ACNvV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jan 2011 08:51:21 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:60593 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755437Ab1ACNux (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jan 2011 08:50:53 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=wjkCuODUlN/ihiX/WdBuGuAFfVKSOsHdaL04hfVCVdiM1MLjo2BC8AJBemGfqFew19
         lBNHxkmD7zxEZSVoW3LrCmMrU3s8a3r41nuYityp9ShRDQeBg7p/GTOaUhGkcwoubYe3
         1fs7FwfqrSR6l0dU5KpnYB11obUFn3wZyYe5o=
From: Tejun Heo <tj@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: Tejun Heo <tj@kernel.org>, Andy Grover <andy.grover@oracle.com>
Subject: [PATCH 31/32] rds/ib: use system_wq instead of rds_ib_fmr_wq
Date: Mon,  3 Jan 2011 14:49:54 +0100
Message-Id: <1294062595-30097-32-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1294062595-30097-1-git-send-email-tj@kernel.org>
References: <1294062595-30097-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With cmwq, there's no reason to use dedicated rds_ib_fmr_wq - it's not
in the memory reclaim path and the maximum number of concurrent work
items is bound by the number of devices.  Drop it and use system_wq
instead.  This rds_ib_fmr_init/exit() noops.  Both removed.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Andy Grover <andy.grover@oracle.com>
---
Only compile tested.  Please feel free to take it into the subsystem
tree or simply ack - I'll route it through the wq tree.

Thanks.

 net/rds/ib.c      |    9 +--------
 net/rds/ib.h      |    2 --
 net/rds/ib_rdma.c |   27 +++------------------------
 3 files changed, 4 insertions(+), 34 deletions(-)

diff --git a/net/rds/ib.c b/net/rds/ib.c
index 4123967..cce19f9 100644
--- a/net/rds/ib.c
+++ b/net/rds/ib.c
@@ -364,7 +364,6 @@ void rds_ib_exit(void)
 	rds_ib_sysctl_exit();
 	rds_ib_recv_exit();
 	rds_trans_unregister(&rds_ib_transport);
-	rds_ib_fmr_exit();
 }
 
 struct rds_transport rds_ib_transport = {
@@ -400,13 +399,9 @@ int rds_ib_init(void)
 
 	INIT_LIST_HEAD(&rds_ib_devices);
 
-	ret = rds_ib_fmr_init();
-	if (ret)
-		goto out;
-
 	ret = ib_register_client(&rds_ib_client);
 	if (ret)
-		goto out_fmr_exit;
+		goto out;
 
 	ret = rds_ib_sysctl_init();
 	if (ret)
@@ -430,8 +425,6 @@ out_sysctl:
 	rds_ib_sysctl_exit();
 out_ibreg:
 	rds_ib_unregister_client();
-out_fmr_exit:
-	rds_ib_fmr_exit();
 out:
 	return ret;
 }
diff --git a/net/rds/ib.h b/net/rds/ib.h
index e34ad03..4297d92 100644
--- a/net/rds/ib.h
+++ b/net/rds/ib.h
@@ -307,8 +307,6 @@ void *rds_ib_get_mr(struct scatterlist *sg, unsigned long nents,
 void rds_ib_sync_mr(void *trans_private, int dir);
 void rds_ib_free_mr(void *trans_private, int invalidate);
 void rds_ib_flush_mrs(void);
-int rds_ib_fmr_init(void);
-void rds_ib_fmr_exit(void);
 
 /* ib_recv.c */
 int rds_ib_recv_init(void);
diff --git a/net/rds/ib_rdma.c b/net/rds/ib_rdma.c
index 18a833c..819c35a 100644
--- a/net/rds/ib_rdma.c
+++ b/net/rds/ib_rdma.c
@@ -38,8 +38,6 @@
 #include "ib.h"
 #include "xlist.h"
 
-static struct workqueue_struct *rds_ib_fmr_wq;
-
 static DEFINE_PER_CPU(unsigned long, clean_list_grace);
 #define CLEAN_LIST_BUSY_BIT 0
 
@@ -307,7 +305,7 @@ static struct rds_ib_mr *rds_ib_alloc_fmr(struct rds_ib_device *rds_ibdev)
 	int err = 0, iter = 0;
 
 	if (atomic_read(&pool->dirty_count) >= pool->max_items / 10)
-		queue_delayed_work(rds_ib_fmr_wq, &pool->flush_worker, 10);
+		schedule_delayed_work(&pool->flush_worker, 10);
 
 	while (1) {
 		ibmr = rds_ib_reuse_fmr(pool);
@@ -696,24 +694,6 @@ out_nolock:
 	return ret;
 }
 
-int rds_ib_fmr_init(void)
-{
-	rds_ib_fmr_wq = create_workqueue("rds_fmr_flushd");
-	if (!rds_ib_fmr_wq)
-		return -ENOMEM;
-	return 0;
-}
-
-/*
- * By the time this is called all the IB devices should have been torn down and
- * had their pools freed.  As each pool is freed its work struct is waited on,
- * so the pool flushing work queue should be idle by the time we get here.
- */
-void rds_ib_fmr_exit(void)
-{
-	destroy_workqueue(rds_ib_fmr_wq);
-}
-
 static void rds_ib_mr_pool_flush_worker(struct work_struct *work)
 {
 	struct rds_ib_mr_pool *pool = container_of(work, struct rds_ib_mr_pool, flush_worker.work);
@@ -741,7 +721,7 @@ void rds_ib_free_mr(void *trans_private, int invalidate)
 	/* If we've pinned too many pages, request a flush */
 	if (atomic_read(&pool->free_pinned) >= pool->max_free_pinned ||
 	    atomic_read(&pool->dirty_count) >= pool->max_items / 10)
-		queue_delayed_work(rds_ib_fmr_wq, &pool->flush_worker, 10);
+		schedule_delayed_work(&pool->flush_worker, 10);
 
 	if (invalidate) {
 		if (likely(!in_interrupt())) {
@@ -749,8 +729,7 @@ void rds_ib_free_mr(void *trans_private, int invalidate)
 		} else {
 			/* We get here if the user created a MR marked
 			 * as use_once and invalidate at the same time. */
-			queue_delayed_work(rds_ib_fmr_wq,
-					   &pool->flush_worker, 10);
+			schedule_delayed_work(&pool->flush_worker, 10);
 		}
 	}
 
-- 
1.7.1

