Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756291Ab1DGQLR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Apr 2011 12:11:17 -0400
Received: from 63.mail-out.ovh.net ([91.121.185.56]:58624 "HELO
	63.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755928Ab1DGQLN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Apr 2011 12:11:13 -0400
From: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
To: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: Patrice VILCHEZ <patrice.vilchez@atmel.com>, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
Subject: [PATCH 2/2] genalloc: add support to specify the physical address
Date: Thu,  7 Apr 2011 18:03:17 +0200
Message-Id: <1302192197-2248-2-git-send-email-plagnioj@jcrosoft.com>
X-Mailer: git-send-email 1.7.2.3
In-Reply-To: <1302192197-2248-1-git-send-email-plagnioj@jcrosoft.com>
References: <1302192197-2248-1-git-send-email-plagnioj@jcrosoft.com>
X-Ovh-Tracer-Id: 16293179027842902892
X-Ovh-Remote: 213.251.161.87 (ns32433.ovh.net)
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-Spam-Check: DONE|U 0.5/N
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

so we specify the virtual address as base of the pool chunk and then
get the physical address for hardware IP

as example on at91 we will use on spi, uart or macb

Signed-off-by: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
---
 include/linux/genalloc.h |   20 +++++++++++++++++++-
 lib/genalloc.c           |   39 ++++++++++++++++++++++++++++++++-------
 2 files changed, 51 insertions(+), 8 deletions(-)

diff --git a/include/linux/genalloc.h b/include/linux/genalloc.h
index b1c70f1..b44625b 100644
--- a/include/linux/genalloc.h
+++ b/include/linux/genalloc.h
@@ -26,13 +26,31 @@ struct gen_pool {
 struct gen_pool_chunk {
 	spinlock_t lock;
 	struct list_head next_chunk;	/* next chunk in pool */
+	unsigned long phys_addr;	/* physical starting address of memory chunk */
 	unsigned long start_addr;	/* starting address of memory chunk */
 	unsigned long end_addr;		/* ending address of memory chunk */
 	unsigned long bits[0];		/* bitmap for allocating memory chunk */
 };
 
 extern struct gen_pool *gen_pool_create(int, int);
-extern int gen_pool_add(struct gen_pool *, unsigned long, size_t, int);
+extern unsigned long gen_pool_virt_to_phys(struct gen_pool *pool, unsigned long);
+extern int gen_pool_add_virt(struct gen_pool *, unsigned long, unsigned long,
+			     size_t, int);
+/**
+ * gen_pool_add - add a new chunk of special memory to the pool
+ * @pool: pool to add new memory chunk to
+ * @addr: starting address of memory chunk to add to pool
+ * @size: size in bytes of the memory chunk to add to pool
+ * @nid: node id of the node the chunk structure and bitmap should be
+ *       allocated on, or -1
+ *
+ * Add a new chunk of special memory to the specified pool.
+ */
+static inline int gen_pool_add(struct gen_pool *pool, unsigned long addr,
+			       size_t size, int nid)
+{
+	return gen_pool_add_virt(pool, addr, 0, size, nid);
+}
 extern void gen_pool_destroy(struct gen_pool *);
 extern unsigned long gen_pool_alloc(struct gen_pool *, size_t);
 extern void gen_pool_free(struct gen_pool *, unsigned long, size_t);
diff --git a/lib/genalloc.c b/lib/genalloc.c
index 1923f14..83b069b 100644
--- a/lib/genalloc.c
+++ b/lib/genalloc.c
@@ -39,17 +39,18 @@ struct gen_pool *gen_pool_create(int min_alloc_order, int nid)
 EXPORT_SYMBOL(gen_pool_create);
 
 /**
- * gen_pool_add - add a new chunk of special memory to the pool
+ * gen_pool_add_virt - add a new chunk of special memory to the pool
  * @pool: pool to add new memory chunk to
- * @addr: starting address of memory chunk to add to pool
+ * @virt: virtual starting address of memory chunk to add to pool
+ * @phys: physical starting address of memory chunk to add to pool
  * @size: size in bytes of the memory chunk to add to pool
  * @nid: node id of the node the chunk structure and bitmap should be
  *       allocated on, or -1
  *
  * Add a new chunk of special memory to the specified pool.
  */
-int gen_pool_add(struct gen_pool *pool, unsigned long addr, size_t size,
-		 int nid)
+int gen_pool_add_virt(struct gen_pool *pool, unsigned long virt, unsigned long phys,
+		 size_t size, int nid)
 {
 	struct gen_pool_chunk *chunk;
 	int nbits = size >> pool->min_alloc_order;
@@ -61,8 +62,9 @@ int gen_pool_add(struct gen_pool *pool, unsigned long addr, size_t size,
 		return -1;
 
 	spin_lock_init(&chunk->lock);
-	chunk->start_addr = addr;
-	chunk->end_addr = addr + size;
+	chunk->phys_addr = phys;
+	chunk->start_addr = virt;
+	chunk->end_addr = virt + size;
 
 	write_lock(&pool->lock);
 	list_add(&chunk->next_chunk, &pool->chunks);
@@ -70,7 +72,30 @@ int gen_pool_add(struct gen_pool *pool, unsigned long addr, size_t size,
 
 	return 0;
 }
-EXPORT_SYMBOL(gen_pool_add);
+EXPORT_SYMBOL(gen_pool_add_virt);
+
+/**
+ * gen_pool_virt_to_phys - return the physical address of memory
+ * @pool: pool to allocate from
+ * @addr: starting address of memory
+ */
+unsigned long gen_pool_virt_to_phys(struct gen_pool *pool, unsigned long addr)
+{
+	struct list_head *_chunk;
+	struct gen_pool_chunk *chunk;
+
+	read_lock(&pool->lock);
+	list_for_each(_chunk, &pool->chunks) {
+		chunk = list_entry(_chunk, struct gen_pool_chunk, next_chunk);
+
+		if (addr >= chunk->start_addr && addr < chunk->end_addr)
+			return chunk->phys_addr + addr - chunk->start_addr;
+	}
+	read_unlock(&pool->lock);
+
+	return ~0UL;
+}
+EXPORT_SYMBOL(gen_pool_virt_to_phys);
 
 /**
  * gen_pool_destroy - destroy a special memory pool
-- 
1.7.4.1

