Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756100Ab1LVVqx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Dec 2011 16:46:53 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:37320 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756032Ab1LVVpp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Dec 2011 16:45:45 -0500
From: Tejun Heo <tj@kernel.org>
To: akpm@linux-foundation.org, avi@redhat.com, nate@cpanel.net,
        cl@linux-foundation.org, oleg@redhat.com, axboe@kernel.dk,
        vgoyal@redhat.com
Cc: linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>
Subject: [PATCH 5/7] mempool: separate out __mempool_create()
Date: Thu, 22 Dec 2011 13:45:24 -0800
Message-Id: <1324590326-10135-6-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.3.1
In-Reply-To: <1324590326-10135-1-git-send-email-tj@kernel.org>
References: <1324590326-10135-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Separate out __mempool_create(), which handles creation of the mempool
without filling it, from mempool_create_node().  This will be used to
implemen percpu_mempool.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Oleg Nesterov <oleg@redhat.com>
---
 mm/mempool.c |   24 ++++++++++++++++++------
 1 files changed, 18 insertions(+), 6 deletions(-)

diff --git a/mm/mempool.c b/mm/mempool.c
index 4747283..85e2c28 100644
--- a/mm/mempool.c
+++ b/mm/mempool.c
@@ -104,11 +104,13 @@ mempool_t *mempool_create(int min_nr, mempool_alloc_t *alloc_fn,
 }
 EXPORT_SYMBOL(mempool_create);
 
-mempool_t *mempool_create_node(int min_nr, mempool_alloc_t *alloc_fn,
-			mempool_free_t *free_fn, void *pool_data, int node_id)
+static mempool_t *__mempool_create(int min_nr, mempool_alloc_t *alloc_fn,
+				   mempool_free_t *free_fn, void *pool_data,
+				   int node_id, size_t mempool_bytes)
 {
 	mempool_t *pool;
-	pool = kmalloc_node(sizeof(*pool), GFP_KERNEL | __GFP_ZERO, node_id);
+
+	pool = kmalloc_node(mempool_bytes, GFP_KERNEL | __GFP_ZERO, node_id);
 	if (!pool)
 		return NULL;
 	pool->elements = kmalloc_node(min_nr * sizeof(void *),
@@ -124,9 +126,19 @@ mempool_t *mempool_create_node(int min_nr, mempool_alloc_t *alloc_fn,
 	pool->alloc = alloc_fn;
 	pool->free = free_fn;
 
-	/*
-	 * First pre-allocate the guaranteed number of buffers.
-	 */
+	return pool;
+}
+
+mempool_t *mempool_create_node(int min_nr, mempool_alloc_t *alloc_fn,
+			       mempool_free_t *free_fn, void *pool_data,
+			       int node_id)
+{
+	mempool_t *pool;
+
+	pool = __mempool_create(min_nr, alloc_fn, free_fn, pool_data, node_id,
+				sizeof(*pool));
+
+	/* Pre-allocate the guaranteed number of buffers */
 	if (mempool_fill(pool, GFP_KERNEL)) {
 		mempool_destroy(pool);
 		return NULL;
-- 
1.7.3.1

