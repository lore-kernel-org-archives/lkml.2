Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756387Ab2BWWbH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Feb 2012 17:31:07 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:51487 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756238Ab2BWWbD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Feb 2012 17:31:03 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of htejun@gmail.com designates 10.68.73.97 as permitted sender) smtp.mail=htejun@gmail.com; dkim=pass header.i=htejun@gmail.com
From: Tejun Heo <tj@kernel.org>
To: axboe@kernel.dk, vgoyal@redhat.com, akpm@linux-foundation.org,
        hughd@google.com
Cc: avi@redhat.com, nate@cpanel.net, cl@linux-foundation.org,
        linux-kernel@vger.kernel.org, dpshah@google.com, ctalbott@google.com,
        rni@google.com, Tejun Heo <tj@kernel.org>,
        Oleg Nesterov <oleg@redhat.com>
Subject: [PATCH 2/8] mempool: separate out __mempool_create()
Date: Thu, 23 Feb 2012 14:30:40 -0800
Message-Id: <1330036246-21633-3-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.7.3
In-Reply-To: <1330036246-21633-1-git-send-email-tj@kernel.org>
References: <1330036246-21633-1-git-send-email-tj@kernel.org>
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
index e0403d0..1ed8d5e 100644
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
1.7.7.3

