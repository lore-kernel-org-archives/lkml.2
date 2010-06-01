Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756497Ab0FAMXp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jun 2010 08:23:45 -0400
Received: from eu1sys200aog113.obsmtp.com ([207.126.144.135]:58858 "EHLO
	eu1sys200aog113.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756097Ab0FAMVN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jun 2010 08:21:13 -0400
From: Linus Walleij <linus.walleij@stericsson.com>
To: Dan Williams <dan.j.williams@intel.com>
Cc: <linux-kernel@vger.kernel.org>, Jonas Aaberg <jonas.aberg@stericsson.com>,
       Linus Walleij <linus.walleij@stericsson.com>
Subject: [PATCH 04/18] DMAENGINE: ste_dma40: use kmem cache
Date: Tue, 1 Jun 2010 14:20:52 +0200
Message-ID: <1275394852-26260-1-git-send-email-linus.walleij@stericsson.com>
X-Mailer: git-send-email 1.6.3.3
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jonas Aaberg <jonas.aberg@stericsson.com>

Use kmem cache instead of own cache, reducing code duplication
and bug sources.

Signed-off-by: Jonas Aaberg <jonas.aberg@stericsson.com>
Signed-off-by: Linus Walleij <linus.walleij@stericsson.com>
---
 drivers/dma/ste_dma40.c |   52 ++++++++++++++++------------------------------
 1 files changed, 18 insertions(+), 34 deletions(-)

diff --git a/drivers/dma/ste_dma40.c b/drivers/dma/ste_dma40.c
index 2b5e876..d952201 100644
--- a/drivers/dma/ste_dma40.c
+++ b/drivers/dma/ste_dma40.c
@@ -34,10 +34,6 @@
 #define D40_ALLOC_PHY		(1 << 30)
 #define D40_ALLOC_LOG_FREE	0
 
-/* The number of free d40_desc to keep in memory before starting
- * to kfree() them */
-#define D40_DESC_CACHE_SIZE 50
-
 /* Hardware designer of the block */
 #define D40_PERIPHID2_DESIGNER 0x8
 
@@ -172,8 +168,6 @@ struct d40_base;
  * @client: Cliented owned descriptor list.
  * @active: Active descriptor.
  * @queue: Queued jobs.
- * @free: List of free descripts, ready to be reused.
- * @free_len: Number of descriptors in the free list.
  * @dma_cfg: The client configuration of this dma channel.
  * @base: Pointer to the device instance struct.
  * @src_def_cfg: Default cfg register setting for src.
@@ -197,8 +191,6 @@ struct d40_chan {
 	struct list_head		 client;
 	struct list_head		 active;
 	struct list_head		 queue;
-	struct list_head		 free;
-	int				 free_len;
 	struct stedma40_chan_cfg	 dma_cfg;
 	struct d40_base			*base;
 	/* Default register configurations */
@@ -242,6 +234,7 @@ struct d40_chan {
  * @lcpa_base: The virtual mapped address of LCPA.
  * @phy_lcpa: The physical address of the LCPA.
  * @lcpa_size: The size of the LCPA area.
+ * @desc_slab: cache for descriptors.
  */
 struct d40_base {
 	spinlock_t			 interrupt_lock;
@@ -268,6 +261,7 @@ struct d40_base {
 	void				 *lcpa_base;
 	dma_addr_t			  phy_lcpa;
 	resource_size_t			  lcpa_size;
+	struct kmem_cache		 *desc_slab;
 };
 
 /**
@@ -382,36 +376,21 @@ static struct d40_desc *d40_desc_get(struct d40_chan *d40c)
 			if (async_tx_test_ack(&d->txd)) {
 				d40_pool_lli_free(d);
 				d40_desc_remove(d);
-				desc = d;
-				goto out;
+				break;
 			}
-	}
-
-	if (list_empty(&d40c->free)) {
-		/* Alloc new desc because we're out of used ones */
-		desc = kzalloc(sizeof(struct d40_desc), GFP_NOWAIT);
-		if (desc == NULL)
-			goto out;
-		INIT_LIST_HEAD(&desc->node);
 	} else {
-		/* Reuse an old desc. */
-		desc = list_first_entry(&d40c->free,
-					struct d40_desc,
-					node);
-		list_del(&desc->node);
-		d40c->free_len--;
+		d = kmem_cache_alloc(d40c->base->desc_slab, GFP_NOWAIT);
+		if (d != NULL) {
+			memset(d, 0, sizeof(struct d40_desc));
+			INIT_LIST_HEAD(&d->node);
+		}
 	}
-out:
-	return desc;
+	return d;
 }
 
 static void d40_desc_free(struct d40_chan *d40c, struct d40_desc *d40d)
 {
-	if (d40c->free_len < D40_DESC_CACHE_SIZE) {
-		list_add_tail(&d40d->node, &d40c->free);
-		d40c->free_len++;
-	} else
-		kfree(d40d);
+	kmem_cache_free(d40c->base->desc_slab, d40d);
 }
 
 static void d40_desc_submit(struct d40_chan *d40c, struct d40_desc *desc)
@@ -2114,13 +2093,10 @@ static void __init d40_chan_init(struct d40_base *base, struct dma_device *dma,
 
 		d40c->log_num = D40_PHY_CHAN;
 
-		INIT_LIST_HEAD(&d40c->free);
 		INIT_LIST_HEAD(&d40c->active);
 		INIT_LIST_HEAD(&d40c->queue);
 		INIT_LIST_HEAD(&d40c->client);
 
-		d40c->free_len = 0;
-
 		tasklet_init(&d40c->tasklet, dma_tasklet,
 			     (unsigned long) d40c);
 
@@ -2405,6 +2381,12 @@ static struct d40_base * __init d40_hw_detect_init(struct platform_device *pdev)
 	if (!base->lcla_pool.alloc_map)
 		goto failure;
 
+	base->desc_slab = kmem_cache_create(D40_NAME, sizeof(struct d40_desc),
+					    0, SLAB_HWCACHE_ALIGN,
+					    NULL);
+	if (base->desc_slab == NULL)
+		goto failure;
+
 	return base;
 
 failure:
@@ -2619,6 +2601,8 @@ static int __init d40_probe(struct platform_device *pdev)
 
 failure:
 	if (base) {
+		if (base->desc_slab)
+			kmem_cache_destroy(base->desc_slab);
 		if (base->virtbase)
 			iounmap(base->virtbase);
 		if (base->lcla_pool.phy)
-- 
1.6.3.3

