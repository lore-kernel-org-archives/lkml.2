Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756355Ab2JRO1r (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2012 10:27:47 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:42203 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756293Ab2JRO1n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2012 10:27:43 -0400
From: Philipp Zabel <p.zabel@pengutronix.de>
To: linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Shawn Guo <shawn.guo@linaro.org>,
        Richard Zhao <richard.zhao@freescale.com>,
        Huang Shijie <shijie8@gmail.com>,
        Dong Aisheng <dong.aisheng@linaro.org>, Matt Porter <mporter@ti.com>,
        kernel@pengutronix.de, devicetree-discuss@lists.ozlabs.org
Cc: Philipp Zabel <p.zabel@pengutronix.de>
Subject: [PATCH v5 1/4] genalloc: add a global pool list, allow to find pools by phys address
Date: Thu, 18 Oct 2012 16:27:30 +0200
Message-Id: <1350570453-24546-2-git-send-email-p.zabel@pengutronix.de>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1350570453-24546-1-git-send-email-p.zabel@pengutronix.de>
References: <1350570453-24546-1-git-send-email-p.zabel@pengutronix.de>
X-SA-Exim-Connect-IP: 10.1.0.7
X-SA-Exim-Mail-From: p.zabel@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch keeps all created pools in a global list and adds two
functions that allow to retrieve the gen_pool pointer from a known
physical address and from a device tree node.

Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
Reviewed-by: Shawn Guo <shawn.guo@linaro.org>
---
 include/linux/genalloc.h |   14 ++++++++++
 lib/genalloc.c           |   67 ++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 81 insertions(+)

diff --git a/include/linux/genalloc.h b/include/linux/genalloc.h
index dd7c569..91d606e 100644
--- a/include/linux/genalloc.h
+++ b/include/linux/genalloc.h
@@ -47,6 +47,7 @@ typedef unsigned long (*genpool_algo_t)(unsigned long *map,
  *  General purpose special memory pool descriptor.
  */
 struct gen_pool {
+	struct list_head next_pool;	/* pool in global list */
 	spinlock_t lock;
 	struct list_head chunks;	/* list of chunks in this pool */
 	int min_alloc_order;		/* minimum allocation order */
@@ -105,4 +106,17 @@ extern unsigned long gen_pool_first_fit(unsigned long *map, unsigned long size,
 extern unsigned long gen_pool_best_fit(unsigned long *map, unsigned long size,
 		unsigned long start, unsigned int nr, void *data);
 
+extern struct gen_pool *gen_pool_find_by_phys(phys_addr_t phys);
+
+struct device_node;
+#ifdef CONFIG_OF
+extern struct gen_pool *of_get_named_gen_pool(struct device_node *np,
+	const char *propname, int index);
+#else
+inline struct gen_pool *of_get_named_gen_pool(struct device_node *np,
+	const char *propname, int index)
+{
+	return NULL;
+}
+#endif
 #endif /* __GENALLOC_H__ */
diff --git a/lib/genalloc.c b/lib/genalloc.c
index ca208a9..d77d240 100644
--- a/lib/genalloc.c
+++ b/lib/genalloc.c
@@ -34,6 +34,11 @@
 #include <linux/rculist.h>
 #include <linux/interrupt.h>
 #include <linux/genalloc.h>
+#include <linux/of_address.h>
+#include <linux/of_device.h>
+
+static LIST_HEAD(pools);
+static DEFINE_SPINLOCK(list_lock);
 
 static int set_bits_ll(unsigned long *addr, unsigned long mask_to_set)
 {
@@ -154,6 +159,9 @@ struct gen_pool *gen_pool_create(int min_alloc_order, int nid)
 		pool->min_alloc_order = min_alloc_order;
 		pool->algo = gen_pool_first_fit;
 		pool->data = NULL;
+		spin_lock(&list_lock);
+		list_add_rcu(&pool->next_pool, &pools);
+		spin_unlock(&list_lock);
 	}
 	return pool;
 }
@@ -236,6 +244,9 @@ void gen_pool_destroy(struct gen_pool *pool)
 	int order = pool->min_alloc_order;
 	int bit, end_bit;
 
+	spin_lock(&list_lock);
+	list_del_rcu(&pool->next_pool);
+	spin_unlock(&list_lock);
 	list_for_each_safe(_chunk, _next_chunk, &pool->chunks) {
 		chunk = list_entry(_chunk, struct gen_pool_chunk, next_chunk);
 		list_del(&chunk->next_chunk);
@@ -480,3 +491,59 @@ unsigned long gen_pool_best_fit(unsigned long *map, unsigned long size,
 	return start_bit;
 }
 EXPORT_SYMBOL(gen_pool_best_fit);
+
+/*
+ * gen_pool_find_by_phys - find a pool by physical start address
+ * @phys: physical address as added with gen_pool_add_virt
+ *
+ * Returns the pool that contains the chunk starting at phys,
+ * or NULL if not found.
+ */
+struct gen_pool *gen_pool_find_by_phys(phys_addr_t phys)
+{
+	struct gen_pool *pool, *found = NULL;
+	struct gen_pool_chunk *chunk;
+
+	rcu_read_lock();
+	list_for_each_entry_rcu(pool, &pools, next_pool) {
+		list_for_each_entry_rcu(chunk, &pool->chunks, next_chunk) {
+			if (phys == chunk->phys_addr) {
+				found = pool;
+				break;
+			}
+		}
+	}
+	rcu_read_unlock();
+
+	return found;
+}
+EXPORT_SYMBOL_GPL(gen_pool_find_by_phys);
+
+#ifdef CONFIG_OF
+/**
+ * of_get_named_gen_pool - find a pool by phandle property
+ * @np: device node
+ * @propname: property name containing phandle(s)
+ * @index: index into the phandle array
+ *
+ * Returns the pool that contains the chunk starting at the physical
+ * address of the device tree node pointed at by the phandle property,
+ * or NULL if not found.
+ */
+struct gen_pool *of_get_named_gen_pool(struct device_node *np,
+	const char *propname, int index)
+{
+	struct device_node *np_pool;
+	struct resource res;
+	int ret;
+
+	np_pool = of_parse_phandle(np, propname, index);
+	if (!np_pool)
+		return NULL;
+	ret = of_address_to_resource(np_pool, 0, &res);
+	if (ret < 0)
+		return NULL;
+	return gen_pool_find_by_phys((phys_addr_t) res.start);
+}
+EXPORT_SYMBOL_GPL(of_get_named_gen_pool);
+#endif /* CONFIG_OF */
-- 
1.7.10.4

