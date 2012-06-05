Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761859Ab2FELEy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2012 07:04:54 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:60772 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752951Ab2FELEx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2012 07:04:53 -0400
From: Sasha Levin <levinsasha928@gmail.com>
To: gregkh@linuxfoundation.org, sjenning@linux.vnet.ibm.com,
        dan.magenheimer@oracle.com, konrad.wilk@oracle.com
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Sasha Levin <levinsasha928@gmail.com>
Subject: [PATCH] zcache: don't limit number of pools per client
Date: Tue,  5 Jun 2012 13:05:52 +0200
Message-Id: <1338894352-23054-1-git-send-email-levinsasha928@gmail.com>
X-Mailer: git-send-email 1.7.8.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently the amount of pools each client can use is limited to 16, this is
and arbitrary limit which isn't really required by current implementation.

This patch removes that limit and uses IDR to do sparse mapping of pools
in each client.

Signed-off-by: Sasha Levin <levinsasha928@gmail.com>
---
 drivers/staging/zcache/zcache-main.c |   41 +++++++++++++++++++--------------
 1 files changed, 24 insertions(+), 17 deletions(-)

diff --git a/drivers/staging/zcache/zcache-main.c b/drivers/staging/zcache/zcache-main.c
index 784c796..b068bd8 100644
--- a/drivers/staging/zcache/zcache-main.c
+++ b/drivers/staging/zcache/zcache-main.c
@@ -53,15 +53,13 @@
 	(__GFP_FS | __GFP_NORETRY | __GFP_NOWARN | __GFP_NOMEMALLOC)
 #endif
 
-#define MAX_POOLS_PER_CLIENT 16
-
 #define MAX_CLIENTS 16
 #define LOCAL_CLIENT ((uint16_t)-1)
 
 MODULE_LICENSE("GPL");
 
 struct zcache_client {
-	struct tmem_pool *tmem_pools[MAX_POOLS_PER_CLIENT];
+	struct idr tmem_pools;
 	struct zs_pool *zspool;
 	bool allocated;
 	atomic_t refcount;
@@ -949,11 +947,9 @@ static struct tmem_pool *zcache_get_pool_by_id(uint16_t cli_id, uint16_t poolid)
 			goto out;
 		atomic_inc(&cli->refcount);
 	}
-	if (poolid < MAX_POOLS_PER_CLIENT) {
-		pool = cli->tmem_pools[poolid];
-		if (pool != NULL)
-			atomic_inc(&pool->refcount);
-	}
+	pool = idr_find(&cli->tmem_pools, poolid);
+	if (pool != NULL)
+		atomic_inc(&pool->refcount);
 out:
 	return pool;
 }
@@ -987,6 +983,7 @@ int zcache_new_client(uint16_t cli_id)
 	cli->zspool = zs_create_pool("zcache", ZCACHE_GFP_MASK);
 	if (cli->zspool == NULL)
 		goto out;
+	idr_init(&cli->tmem_pools);
 #endif
 	ret = 0;
 out:
@@ -1673,10 +1670,10 @@ static int zcache_destroy_pool(int cli_id, int pool_id)
 	if (cli == NULL)
 		goto out;
 	atomic_inc(&cli->refcount);
-	pool = cli->tmem_pools[pool_id];
+	pool = idr_find(&cli->tmem_pools, pool_id);
 	if (pool == NULL)
 		goto out;
-	cli->tmem_pools[pool_id] = NULL;
+	idr_remove(&cli->tmem_pools, pool_id);
 	/* wait for pool activity on other cpus to quiesce */
 	while (atomic_read(&pool->refcount) != 0)
 		;
@@ -1696,6 +1693,7 @@ static int zcache_new_pool(uint16_t cli_id, uint32_t flags)
 	int poolid = -1;
 	struct tmem_pool *pool;
 	struct zcache_client *cli = NULL;
+	int r;
 
 	if (cli_id == LOCAL_CLIENT)
 		cli = &zcache_host;
@@ -1710,20 +1708,29 @@ static int zcache_new_pool(uint16_t cli_id, uint32_t flags)
 		goto out;
 	}
 
-	for (poolid = 0; poolid < MAX_POOLS_PER_CLIENT; poolid++)
-		if (cli->tmem_pools[poolid] == NULL)
-			break;
-	if (poolid >= MAX_POOLS_PER_CLIENT) {
-		pr_info("zcache: pool creation failed: max exceeded\n");
+retry:
+	r = idr_pre_get(&cli->tmem_pools, GFP_ATOMIC);
+	if (r != 1) {
+		kfree(pool);
+		pr_info("zcache: pool creation failed: out of memory\n");
+		goto out;
+	}
+	r = idr_get_new(&cli->tmem_pools, pool, &poolid);
+	switch (r) {
+	case 0:
+		break;
+	case -EAGAIN:
+		goto retry;
+	default:
+		pr_info("zcache: pool creation failed: error %d\n", r);
 		kfree(pool);
-		poolid = -1;
 		goto out;
 	}
+
 	atomic_set(&pool->refcount, 0);
 	pool->client = cli;
 	pool->pool_id = poolid;
 	tmem_new_pool(pool, flags);
-	cli->tmem_pools[poolid] = pool;
 	pr_info("zcache: created %s tmem pool, id=%d, client=%d\n",
 		flags & TMEM_POOL_PERSIST ? "persistent" : "ephemeral",
 		poolid, cli_id);
-- 
1.7.8.6

