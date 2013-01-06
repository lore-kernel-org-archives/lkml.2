Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753414Ab3AFWoW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jan 2013 17:44:22 -0500
Received: from eu1sys200aog111.obsmtp.com ([207.126.144.131]:43261 "EHLO
	eu1sys200aog111.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753229Ab3AFWoR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jan 2013 17:44:17 -0500
From: Linus Walleij <linus.walleij@stericsson.com>
To: Vinod Koul <vinod.koul@intel.com>
Cc: <linux-kernel@vger.kernel.org>, Dan Williams <dan.j.williams@intel.com>,
        Anmar Oueja <anmar.oueja@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH 7/8] dma: coh901318: merge header files
Date: Sun, 6 Jan 2013 23:44:01 +0100
Message-ID: <1357512241-5813-1-git-send-email-linus.walleij@stericsson.com>
X-Mailer: git-send-email 1.7.11.3
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Linus Walleij <linus.walleij@linaro.org>

We do not need two header files for the two parts of the driver
to talk to each other so merge them into one.

Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
 drivers/dma/coh901318.c     |   1 -
 drivers/dma/coh901318.h     | 108 +++++++++++++++++++++++++++++++++++++++
 drivers/dma/coh901318_lli.c |   1 -
 drivers/dma/coh901318_lli.h | 122 --------------------------------------------
 4 files changed, 108 insertions(+), 124 deletions(-)
 delete mode 100644 drivers/dma/coh901318_lli.h

diff --git a/drivers/dma/coh901318.c b/drivers/dma/coh901318.c
index f7100dc..0604273 100644
--- a/drivers/dma/coh901318.c
+++ b/drivers/dma/coh901318.c
@@ -24,7 +24,6 @@
 #include <linux/platform_data/dma-coh901318.h>
 
 #include "coh901318.h"
-#include "coh901318_lli.h"
 #include "dmaengine.h"
 
 #define COH901318_MOD32_MASK					(0x1F)
diff --git a/drivers/dma/coh901318.h b/drivers/dma/coh901318.h
index 275a36e..95ce1e2 100644
--- a/drivers/dma/coh901318.h
+++ b/drivers/dma/coh901318.h
@@ -11,6 +11,18 @@
 #define MAX_DMA_PACKET_SIZE_SHIFT 11
 #define MAX_DMA_PACKET_SIZE (1 << MAX_DMA_PACKET_SIZE_SHIFT)
 
+struct device;
+
+struct coh901318_pool {
+	spinlock_t lock;
+	struct dma_pool *dmapool;
+	struct device *dev;
+
+#ifdef CONFIG_DEBUG_FS
+	int debugfs_pool_counter;
+#endif
+};
+
 /**
  * struct coh901318_lli - linked list item for DMAC
  * @control: control settings for DMAC
@@ -30,4 +42,100 @@ struct coh901318_lli {
 	dma_addr_t phy_this;
 };
 
+/**
+ * coh901318_pool_create() - Creates an dma pool for lli:s
+ * @pool: pool handle
+ * @dev: dma device
+ * @lli_nbr: number of lli:s in the pool
+ * @algin: address alignemtn of lli:s
+ * returns 0 on success otherwise none zero
+ */
+int coh901318_pool_create(struct coh901318_pool *pool,
+			  struct device *dev,
+			  size_t lli_nbr, size_t align);
+
+/**
+ * coh901318_pool_destroy() - Destroys the dma pool
+ * @pool: pool handle
+ * returns 0 on success otherwise none zero
+ */
+int coh901318_pool_destroy(struct coh901318_pool *pool);
+
+/**
+ * coh901318_lli_alloc() - Allocates a linked list
+ *
+ * @pool: pool handle
+ * @len: length to list
+ * return: none NULL if success otherwise NULL
+ */
+struct coh901318_lli *
+coh901318_lli_alloc(struct coh901318_pool *pool,
+		    unsigned int len);
+
+/**
+ * coh901318_lli_free() - Returns the linked list items to the pool
+ * @pool: pool handle
+ * @lli: reference to lli pointer to be freed
+ */
+void coh901318_lli_free(struct coh901318_pool *pool,
+			struct coh901318_lli **lli);
+
+/**
+ * coh901318_lli_fill_memcpy() - Prepares the lli:s for dma memcpy
+ * @pool: pool handle
+ * @lli: allocated lli
+ * @src: src address
+ * @size: transfer size
+ * @dst: destination address
+ * @ctrl_chained: ctrl for chained lli
+ * @ctrl_last: ctrl for the last lli
+ * returns number of CPU interrupts for the lli, negative on error.
+ */
+int
+coh901318_lli_fill_memcpy(struct coh901318_pool *pool,
+			  struct coh901318_lli *lli,
+			  dma_addr_t src, unsigned int size,
+			  dma_addr_t dst, u32 ctrl_chained, u32 ctrl_last);
+
+/**
+ * coh901318_lli_fill_single() - Prepares the lli:s for dma single transfer
+ * @pool: pool handle
+ * @lli: allocated lli
+ * @buf: transfer buffer
+ * @size: transfer size
+ * @dev_addr: address of periphal
+ * @ctrl_chained: ctrl for chained lli
+ * @ctrl_last: ctrl for the last lli
+ * @dir: direction of transfer (to or from device)
+ * returns number of CPU interrupts for the lli, negative on error.
+ */
+int
+coh901318_lli_fill_single(struct coh901318_pool *pool,
+			  struct coh901318_lli *lli,
+			  dma_addr_t buf, unsigned int size,
+			  dma_addr_t dev_addr, u32 ctrl_chained, u32 ctrl_last,
+			  enum dma_transfer_direction dir);
+
+/**
+ * coh901318_lli_fill_single() - Prepares the lli:s for dma scatter list transfer
+ * @pool: pool handle
+ * @lli: allocated lli
+ * @sg: scatter gather list
+ * @nents: number of entries in sg
+ * @dev_addr: address of periphal
+ * @ctrl_chained: ctrl for chained lli
+ * @ctrl: ctrl of middle lli
+ * @ctrl_last: ctrl for the last lli
+ * @dir: direction of transfer (to or from device)
+ * @ctrl_irq_mask: ctrl mask for CPU interrupt
+ * returns number of CPU interrupts for the lli, negative on error.
+ */
+int
+coh901318_lli_fill_sg(struct coh901318_pool *pool,
+		      struct coh901318_lli *lli,
+		      struct scatterlist *sg, unsigned int nents,
+		      dma_addr_t dev_addr, u32 ctrl_chained,
+		      u32 ctrl, u32 ctrl_last,
+		      enum dma_transfer_direction dir, u32 ctrl_irq_mask);
+
 #endif /* COH901318_H */
diff --git a/drivers/dma/coh901318_lli.c b/drivers/dma/coh901318_lli.c
index b2e284f..3e96610 100644
--- a/drivers/dma/coh901318_lli.c
+++ b/drivers/dma/coh901318_lli.c
@@ -14,7 +14,6 @@
 #include <linux/dmaengine.h>
 
 #include "coh901318.h"
-#include "coh901318_lli.h"
 
 #if (defined(CONFIG_DEBUG_FS) && defined(CONFIG_U300_DEBUG))
 #define DEBUGFS_POOL_COUNTER_RESET(pool) (pool->debugfs_pool_counter = 0)
diff --git a/drivers/dma/coh901318_lli.h b/drivers/dma/coh901318_lli.h
deleted file mode 100644
index 0c7cace..0000000
--- a/drivers/dma/coh901318_lli.h
+++ /dev/null
@@ -1,122 +0,0 @@
-/*
- * driver/dma/coh901318_lli.h
- *
- * Copyright (C) 2007-2009 ST-Ericsson
- * License terms: GNU General Public License (GPL) version 2
- * Support functions for handling lli for coh901318
- * Author: Per Friden <per.friden@stericsson.com>
- */
-
-#ifndef COH901318_LLI_H
-#define COH901318_LLI_H
-
-struct device;
-
-struct coh901318_pool {
-	spinlock_t lock;
-	struct dma_pool *dmapool;
-	struct device *dev;
-
-#ifdef CONFIG_DEBUG_FS
-	int debugfs_pool_counter;
-#endif
-};
-
-struct device;
-/**
- * coh901318_pool_create() - Creates an dma pool for lli:s
- * @pool: pool handle
- * @dev: dma device
- * @lli_nbr: number of lli:s in the pool
- * @algin: address alignemtn of lli:s
- * returns 0 on success otherwise none zero
- */
-int coh901318_pool_create(struct coh901318_pool *pool,
-			  struct device *dev,
-			  size_t lli_nbr, size_t align);
-
-/**
- * coh901318_pool_destroy() - Destroys the dma pool
- * @pool: pool handle
- * returns 0 on success otherwise none zero
- */
-int coh901318_pool_destroy(struct coh901318_pool *pool);
-
-/**
- * coh901318_lli_alloc() - Allocates a linked list
- *
- * @pool: pool handle
- * @len: length to list
- * return: none NULL if success otherwise NULL
- */
-struct coh901318_lli *
-coh901318_lli_alloc(struct coh901318_pool *pool,
-		    unsigned int len);
-
-/**
- * coh901318_lli_free() - Returns the linked list items to the pool
- * @pool: pool handle
- * @lli: reference to lli pointer to be freed
- */
-void coh901318_lli_free(struct coh901318_pool *pool,
-			struct coh901318_lli **lli);
-
-/**
- * coh901318_lli_fill_memcpy() - Prepares the lli:s for dma memcpy
- * @pool: pool handle
- * @lli: allocated lli
- * @src: src address
- * @size: transfer size
- * @dst: destination address
- * @ctrl_chained: ctrl for chained lli
- * @ctrl_last: ctrl for the last lli
- * returns number of CPU interrupts for the lli, negative on error.
- */
-int
-coh901318_lli_fill_memcpy(struct coh901318_pool *pool,
-			  struct coh901318_lli *lli,
-			  dma_addr_t src, unsigned int size,
-			  dma_addr_t dst, u32 ctrl_chained, u32 ctrl_last);
-
-/**
- * coh901318_lli_fill_single() - Prepares the lli:s for dma single transfer
- * @pool: pool handle
- * @lli: allocated lli
- * @buf: transfer buffer
- * @size: transfer size
- * @dev_addr: address of periphal
- * @ctrl_chained: ctrl for chained lli
- * @ctrl_last: ctrl for the last lli
- * @dir: direction of transfer (to or from device)
- * returns number of CPU interrupts for the lli, negative on error.
- */
-int
-coh901318_lli_fill_single(struct coh901318_pool *pool,
-			  struct coh901318_lli *lli,
-			  dma_addr_t buf, unsigned int size,
-			  dma_addr_t dev_addr, u32 ctrl_chained, u32 ctrl_last,
-			  enum dma_transfer_direction dir);
-
-/**
- * coh901318_lli_fill_single() - Prepares the lli:s for dma scatter list transfer
- * @pool: pool handle
- * @lli: allocated lli
- * @sg: scatter gather list
- * @nents: number of entries in sg
- * @dev_addr: address of periphal
- * @ctrl_chained: ctrl for chained lli
- * @ctrl: ctrl of middle lli
- * @ctrl_last: ctrl for the last lli
- * @dir: direction of transfer (to or from device)
- * @ctrl_irq_mask: ctrl mask for CPU interrupt
- * returns number of CPU interrupts for the lli, negative on error.
- */
-int
-coh901318_lli_fill_sg(struct coh901318_pool *pool,
-		      struct coh901318_lli *lli,
-		      struct scatterlist *sg, unsigned int nents,
-		      dma_addr_t dev_addr, u32 ctrl_chained,
-		      u32 ctrl, u32 ctrl_last,
-		      enum dma_transfer_direction dir, u32 ctrl_irq_mask);
-
-#endif /* COH901318_LLI_H */
-- 
1.7.11.3

